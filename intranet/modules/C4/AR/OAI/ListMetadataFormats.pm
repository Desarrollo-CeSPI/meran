package C4::AR::OAI::ListMetadataFormats;

use strict;
use warnings;
use diagnostics;
use HTTP::OAI;

use base ("HTTP::OAI::ListMetadataFormats");

sub new {
    my ($class, $repository) = @_;

    my $self = $class->SUPER::new();

    $self->metadataFormat( HTTP::OAI::MetadataFormat->new(
        metadataPrefix    => 'oai_dc',
        schema            => 'http://www.openarchives.org/OAI/2.0/oai_dc.xsd',
        metadataNamespace => 'http://www.openarchives.org/OAI/2.0/oai_dc/'
    ) );

    $self->metadataFormat( HTTP::OAI::MetadataFormat->new(
        metadataPrefix    => 'marcxml',
        schema            => 'http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd',
        metadataNamespace => 'http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim'
    ) );

    return $self;
}

# __END__ C4::AR::OAI::ListMetadataFormats
1;
