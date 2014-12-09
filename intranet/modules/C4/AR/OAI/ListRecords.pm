package C4::AR::OAI::ListRecords;

use strict;
use warnings;
use diagnostics;
use HTTP::OAI;
use C4::AR::OAI::ResumptionToken;
use C4::AR::OAI::Record;
use C4::AR::ExportacionIsoMARC;

use base ("HTTP::OAI::ListRecords");


sub new {
    my ($class, $repository, %args) = @_;
    my $self = HTTP::OAI::ListRecords->new(%args);

    my @bind=();
    my $token = new C4::AR::OAI::ResumptionToken( %args );
    my $dbh = C4::Context->dbh;
    my $sql = "SELECT * FROM indice_busqueda ";

    if($token->{from} && $token->{until}) {
              $sql.=" WHERE  timestamp >= ? AND timestamp < ? ";
              push(@bind,$token->{from});
              C4::AR::Debug::debug("OAI list records - from => ".$token->{from});
              push(@bind,$token->{until});
              C4::AR::Debug::debug("OAI list records - until => ".$token->{until});

     }

    $sql.=" ORDER BY timestamp ";

    if($repository->{meran_max_count}) {
              $sql.="LIMIT  ".$repository->{meran_max_count}." ";
    }
    
    if($token->{offset}){
                $sql.=" OFFSET ".$token->{offset};
    }

    my $sth = $dbh->prepare($sql);
    $sth->execute(@bind);

    my $pos = $token->{offset};

  C4::AR::Debug::debug("OAI => POS Ini = ".$pos);
    while ( my $record = $sth->fetchrow_hashref ) {
        #arma dinamicamente el  marcxml
        my $marc_record = MARC::Record->new_from_usmarc($record->{"marc_record"});
        $self->record(
          C4::AR::OAI::Record->new(
            $repository,
            $marc_record,
            $record->{"timestamp"},
            $record->{"id"},
            identifier      => $repository->{meran_identifier} . ':' . $record->{"id"},
            metadataPrefix  => $token->{metadata_prefix},
          )
        );
        $pos++;
    }
  C4::AR::Debug::debug("OAI => POS Fin = ".$pos);

  my $total = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda_count();
  C4::AR::Debug::debug("OAI => CANT  = ".$total);
  
  if($pos < $total){
    $self->resumptionToken( new C4::AR::OAI::ResumptionToken(
        metadataPrefix  => $token->{metadata_prefix},
        from            => $token->{from},
        until           => $token->{until},
        offset          => $pos ) );
  }
    return $self;
}

# __END__ C4::AR::OAI::ListRecords

1;
