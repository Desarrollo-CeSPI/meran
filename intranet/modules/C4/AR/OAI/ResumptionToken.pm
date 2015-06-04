package C4::AR::OAI::ResumptionToken;

# Extends HTTP::AR::OAI::ResumptionToken
# A token is identified by:
# - metadataPrefix
# - from
# - until
# - offset


use strict;
use warnings;
use diagnostics;
use HTTP::OAI;

use base ("HTTP::OAI::ResumptionToken");


sub new {
    my ($class, %args) = @_;


    my $self = $class->SUPER::new(%args);

    my ($metadata_prefix, $offset, $from, $until);
    if ( $args{ resumptionToken } ) {
        ($metadata_prefix, $offset, $from, $until)
            = split( ':', $args{resumptionToken} );
    }
    else {
        $metadata_prefix = $args{ metadataPrefix };
        $from = $args{ from } || substr(C4::Modelo::IndiceBusqueda::Manager->get_minimum_timestamp(),0,10);  #Min ID - Solo Fecha
        $until = $args{ until };
        unless ( $until) {
            $until = substr(C4::Modelo::IndiceBusqueda::Manager->get_maximum_timestamp(),0,10); #Max ID - Solo Fecha
        }
        $offset = $args{ offset } || 0;
    }

    $self->{ metadata_prefix } = $metadata_prefix;
    $self->{ offset          } = $offset;
    $self->{ from            } = $from;
    $self->{ until           } = $until;

    $self->resumptionToken( join( ':', $metadata_prefix, $offset, $from, $until ));
    $self->cursor( $offset );

    return $self;
}

# __END__ C4::AR::OAI::ResumptionToken

1;
