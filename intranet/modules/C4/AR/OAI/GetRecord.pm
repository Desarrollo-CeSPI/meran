package C4::AR::OAI::GetRecord;

use strict;
use warnings;
use diagnostics;
use HTTP::OAI;
use C4::AR::OAI::Record;
use MARC::Crosswalk::DublinCore;
use C4::AR::Nivel1;

use base ("HTTP::OAI::GetRecord");


sub new {
    my ($class, $repository, %args) = @_;


    my $self = HTTP::OAI::GetRecord->new(%args);

    my $prefix = $repository->{meran_identifier} . ':';
    my ($id1) = $args{identifier} =~ /^$prefix(.*)/;
    
    my $nivel1 = C4::AR::Nivel1::getNivel1FromId1($id1);
    unless ( $nivel1 ) {
        return HTTP::OAI::Response->new(
            requestURL  => $repository->self_url(),
            errors      => [ new HTTP::OAI::Error(
                code    => 'idDoesNotExist',
                message => "There is no record with this identifier",
                ) ] ,
        );
    }
    
    $self->record( C4::AR::OAI::Record->new($repository, $nivel1->getMarcRecord , $nivel1->getId, %args ));

    return $self;
}

# __END__ C4::AR::OAI::GetRecord
1;