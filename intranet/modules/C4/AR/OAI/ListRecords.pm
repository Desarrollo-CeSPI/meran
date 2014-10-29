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
    my $sql = "SELECT id
               FROM   cat_registro_marc_n1 ";

    if($token->{from} && $token->{until}) {
              $sql.=" WHERE  id >= ? AND id <= ? ";
              push(@bind,$token->{from});
              push(@bind,$token->{until});
     }
    
    if($repository->{koha_max_count} && $token->{offset}){
                $sql.="LIMIT  ?  OFFSET ? ";
                push(@bind,$repository->{koha_max_count});
                push(@bind,$token->{offset});
    }

    $sql.=" ORDER BY id ";

    my $sth = $dbh->prepare( $sql );
    $sth->execute(@bind);

    my $pos = $token->{offset};
    while ( my ($id) = $sth->fetchrow ) {
    
        #arma dinamicamente el  marcxml
        my $marc_record = C4::AR::Nivel1::getNivel1FromId1($id)->getMarcRecordObject();
    
        $self->record( C4::AR::OAI::Record->new(
            $repository, $marc_record, 'id',
            identifier      => $repository->{ meran_identifier } . ':' . $id,
            metadataPrefix  => $token->{metadata_prefix}
        ));
        $pos++;
    }

    $self->resumptionToken( new C4::AR::OAI::ResumptionToken(
        metadataPrefix  => $token->{metadata_prefix},
        from            => $token->{from},
        until           => $token->{until},
        offset          => $pos ) );

    return $self;
}

# __END__ C4::AR::OAI::ListRecords

1;