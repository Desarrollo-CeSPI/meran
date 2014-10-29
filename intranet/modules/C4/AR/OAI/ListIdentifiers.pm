package C4::AR::OAI::ListIdentifiers;

use strict;
use warnings;
use diagnostics;
use HTTP::OAI;

use C4::AR::OAI::ResumptionToken;

use base ("HTTP::OAI::ListIdentifiers");

sub new {
    my ($class, $repository, %args) = @_;

    my $self = HTTP::OAI::ListIdentifiers->new(%args);

    my $token = new C4::AR::OAI::ResumptionToken( %args );
    my $dbh = C4::Context->dbh;
    my $sql = "SELECT id
               FROM   cat_registro_marc_n1
               WHERE  id >= ? AND id <= ?
               LIMIT  " . $repository->{meran_max_count} . "
               OFFSET " . $token->{offset};
    my $sth = $dbh->prepare( $sql );
    $sth->execute( $token->{from}, $token->{until} );

    my $pos = $token->{offset};
    while ( my ($id) = $sth->fetchrow ) {
#         $timestamp =~ s/ /T/, $timestamp .= 'Z';
        $self->identifier( new HTTP::OAI::Header(
            identifier => $repository->{ meran_identifier} . ':' . $id,
            datestamp  => $id, 
        ) );
        $pos++;
    }
    $self->resumptionToken( new C4::AR::OAI::ResumptionToken(
        metadataPrefix  => $token->{metadata_prefix},
        from            => $token->{from},
        until           => $token->{until},
        offset          => $pos ) );

    return $self;
}

# __END__ C4::AR::OAI::ListIdentifiers
1;