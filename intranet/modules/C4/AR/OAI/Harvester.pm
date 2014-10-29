package C4::AR::OAI::Harvester;

use strict;
require Exporter;
use C4::Context;
use HTTP::OAI;
use HTTP::OAI::Metadata::OAI_DC;
use C4::AR::OAI::ResumptionToken;


sub getRespositoryById {
   my ($id) = @_;
    my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("select * from oai_harvester_server where id=?;");
    $sth->execute($id);
    my $data = $sth->fetchrow_hashref;
    $sth->finish;
    return($data);
}

sub getRespositories {
  my $dbh   = C4::Context->dbh;
  my $sth   = $dbh->prepare("select * from oai_harvester_server;");
  $sth->execute;

  my @results;
  while (my $data = $sth->fetchrow_hashref) {
    push (@results, $data);
  }
  $sth->finish;
  return(\@results);
}

sub addRespository {
   my ($url) = @_;

   my $h = HTTP::OAI::Harvester->new(
                baseURL =>      $url,
                resume=>0, # Suppress automatic resumption
        );
   my $response = $h->repository($h->Identify);
   my $status='OK';

   my $dbh   = C4::Context->dbh;
   my $sth2   = $dbh->prepare("select * from oai_harvester_server where url = ? ;");
   $sth2->execute($url);

   if (!$sth2->fetchrow_hashref) {
        my $sth   = $dbh->prepare("insert into oai_harvester_server (name,mail,version,firstdate,url,status) values (?,?,?,?,?,?) ;");
        $sth->execute($h->Identify->repositoryName, $h->Identify->adminEmail, $h->Identify->protocolVersion, $h->Identify->earliestDatestamp, $url, $status);
    }
}

sub setHarvestRespository {
   my ($id) = @_;
   my $server = getRespositoryById($id);
   if (($server) &&($server->{'status'} eq 'OK')) {
        my $dbh   = C4::Context->dbh;
        my $sth3   = $dbh->prepare("Update oai_harvester_server set status='HARVEST' where id = ? ;");
        $sth3->execute($id);
   }
}


sub harvestRespository {
   my ($id) = @_;

   my $server = getRespositoryById($id);

   if ($server) {
    my $dbh   = C4::Context->dbh;

    my $sth3   = $dbh->prepare("Update oai_harvester_server set status='HARVESTING' where id = ? ;");
    $sth3->execute($id);

    my $harvester = HTTP::OAI::Harvester->new(
                    baseURL =>      $server->{'url'},
                    resume=>0, # Suppress automatic resumption

            );

    my $response = $harvester->ListRecords(
                    metadataPrefix=>'oai_dc',
                    handlers=>{metadata=>'HTTP::OAI::Metadata::OAI_DC'},
                    resumptionToken=>$server->{'resumptionToken'},
            );

        my $lastrecord;
        my $cant_records = C4::Context->preference("OAI-PMH:MaxCount");
        my $count=0;
    while (( my $record = $response->next()) && ($count <= $cant_records)) {
            my $sth   = $dbh->prepare("insert into oai_harvester_register (server_id,oai_identifier,record) values (?,?,?) ;");
            $sth->execute($id,$record->identifier, $record->metadata->dom->toString);
            $lastrecord=$record;
            $count++;
        }

     if ( $response->resumptionToken && $lastrecord->identifier) {
#             C4::AR::Debug::debug(" lastrecord identifier ==> ".$lastrecord->identifier);
#             C4::AR::Debug::debug("resumptionToken final ==> ".$response->resumptionToken);
            my @last_id= split(/\:/,$lastrecord->identifier); #id_repo:id_record
            my ($day, $month, $year) = (localtime)[3..5]; $year += 1900; $month++;
            my $today=$year."-".$month."-".$day;

            my $resumptionToken='oai_dc:'.$last_id[1].':1970-01-01:'.$today;
#             C4::AR::Debug::debug("resumptionToken que va ==> ".$resumptionToken);
            my $sth2   = $dbh->prepare("Update oai_harvester_server set status='HARVESTING', resumptionToken=?  where id = ? ;");
            $sth2->execute($resumptionToken,$id);
        } else { 
            my $sth2   = $dbh->prepare("Update oai_harvester_server set status='END', resumptionToken=?  where id = ? ;");
            $sth2->execute('',$id);
        }
   }

   }

sub harvestAllRespository {
   my ($id) = @_;

   my $server = getRespositoryById($id);

   if ($server) {
    my $dbh   = C4::Context->dbh;

    my $sth3   = $dbh->prepare("Update oai_harvester_server set status='HARVESTING' where id = ? ;");
    $sth3->execute($id);

    my $harvester = HTTP::OAI::Harvester->new(
                    baseURL =>      $server->{'url'},
            );

    my $end=0;
    while (! $end) {

        my $response = $harvester->ListRecords(
                        metadataPrefix=>'oai_dc',
                        handlers=>{metadata=>'HTTP::OAI::Metadata::OAI_DC'},
                        resumptionToken=>$server->{'resumptionToken'},
                );

        my $lastrecord;

        while ( my $record = $response->next()) {
                my $sth   = $dbh->prepare("insert into oai_harvester_register (server_id,oai_identifier,record) values (?,?,?) ;");
                $sth->execute($id,$record->identifier, $record->metadata->dom->toString);
                $lastrecord=$record;
            }

        if ( $response->resumptionToken && $lastrecord->identifier) {

                my @last_id= split(/\:/,$lastrecord->identifier); #id_repo:id_record
                my ($day, $month, $year) = (localtime)[3..5]; $year += 1900; $month++;
                my $today=$year."-".$month."-".$day;
                my $resumptionToken='oai_dc:'.$last_id[1].':1970-01-01:'.$today;
                my $sth2   = $dbh->prepare("Update oai_harvester_server set status='HARVESTING', resumptionToken=?  where id = ? ;");
                $sth2->execute($resumptionToken,$id);

            } else { 
                my $sth2   = $dbh->prepare("Update oai_harvester_server set status='END', resumptionToken=?  where id = ? ;");
                $sth2->execute('',$id);
                $end=1;
            }
    }
    }

   }


sub getRecordsFromServer {
   my ($id,$num,$ini) = @_;

    my $dbh   = C4::Context->dbh;

    my $queryCount= "select count(*) as cant from oai_harvester_register where server_id=?;";
    my $sthCount=$dbh->prepare($queryCount);
        $sthCount->execute($id);
    my $dataResult= $sthCount->fetchrow_hashref;
    my $cant= $dataResult->{'cant'};

    my $query = "select * from oai_harvester_register where server_id=? ";
    if ($num ne 0){
       $query .= " limit ".$ini.",".$num;
      }
    my $sth   = $dbh->prepare($query);
    $sth->execute($id);
  
   my @results;
  while (my $data = $sth->fetchrow_hashref) {

     my $xml = XML::LibXML->load_xml(
       string => $data->{'record'},
       encoding   => 'ISO-8859-1',
     );

    my @nodelist = $xml->getElementsByTagName('dc:creator');
    $data->{'dc:creator'}= join('; ' ,map($_->textContent,@nodelist));

    @nodelist = $xml->getElementsByTagName('dc:title');
    $data->{'dc:title'}= join('; ' ,map($_->textContent,@nodelist));

    push (@results, $data);
  }

  $sth->finish;
  return($cant,\@results);
}

sub getFullRecordFromServer {
   my ($idServer, $idRecord) = @_;
    my $dbh   = C4::Context->dbh;
    my $sth   = $dbh->prepare("select * from oai_harvester_register where server_id=? and id= ?;");
    $sth->execute($idServer, $idRecord);
  
  my $data = $sth->fetchrow_hashref;

     my $xml = XML::LibXML->load_xml(
       string => $data->{'record'},
       encoding   => 'ISO-8859-1',
     );
    
    my @elements = qw(contributor coverage creator date description format identifier language publisher relation rights source subject title type);
    my @titles   = qw(Colaborador Lugar Autor Fecha Descripci&oacute;n Formato Identificador Lenguaje Editor Link Derechos Origen Tema T&iacute;tulo Tipo);

    my @results;
    my $i=0;
    foreach my $elem (@elements){
        my @nodelist = $xml->getElementsByTagName('dc:'.$elem);
        my $result;
        $result->{'campo'}= $titles[$i];
            my @valores = map($_->textContent,@nodelist);
            my @vals;
            foreach my $val (@valores){
                my $vr;
                if($elem eq 'relation'){
                    $vr->{'valor'}= '<a onclick="this.target=\'_blank\'" href="'.$val.'">'.$val.'</a>';
                }else{
                    $vr->{'valor'}= $val;
                }
                push (@vals, $vr);
            }
        $result->{'valores'} = \@vals;
        push (@results, $result);
        $i++;
    }

    $sth->finish;

    #Para obtener Next y Prev

    my $sthNext   = $dbh->prepare("select id from oai_harvester_register where server_id= ? and id > ? ORDER BY id ASC LIMIT 1;");
    $sthNext->execute($idServer, $idRecord);
    my $next = $sthNext->fetchrow;

    my $sthPrev   = $dbh->prepare("select id from oai_harvester_register where server_id= ? and id < ? ORDER BY id DESC LIMIT 1;");
    $sthPrev->execute($idServer, $idRecord);
    my $prev = $sthPrev->fetchrow;


  return($data->{'oai_identifier'},$next,$prev,\@results);
}

sub searchInRespository {
   my ($search,$num,$ini) = @_;

    my $dbh   = C4::Context->dbh;
    
    my $se="%".$search."%";
    my $queryCount= "select count(*) as cant from oai_harvester_register where record like ?;";
    my $sthCount=$dbh->prepare($queryCount);
       $sthCount->execute($se);
    my $dataResult= $sthCount->fetchrow_hashref;
    my $cant= $dataResult->{'cant'};

    my $query = "select *,oai_harvester_register.id as record_id from 
                    oai_harvester_register left join oai_harvester_server 
                    on oai_harvester_register.server_id=oai_harvester_server.id 
                    where record like ? ";

    if ($num ne 0){
       $query .= " limit ".$ini.",".$num;
      }
    my $sth   = $dbh->prepare($query);
    $sth->execute($se);
  
   my @results;
  while (my $data = $sth->fetchrow_hashref) {

     my $xml = XML::LibXML->load_xml(
       string => $data->{'record'},
       encoding   => 'ISO-8859-1',
     );

    my @nodelist = $xml->getElementsByTagName('dc:creator');
    $data->{'dc:creator'}= join('; ' ,map($_->textContent,@nodelist));

    @nodelist = $xml->getElementsByTagName('dc:title');
    $data->{'dc:title'}= join('; ' ,map($_->textContent,@nodelist));

    push (@results, $data);
  }
  $sth->finish;
  return($cant,\@results);
}
1;
