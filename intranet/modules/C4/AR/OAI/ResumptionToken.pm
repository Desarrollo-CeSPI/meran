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
        $from = $args{ from } || '1';
        $until = $args{ until };
        unless ( $until) {
            $until = '100000'; #Max ID
        }
        $offset = $args{ offset } || 0;
    }

    $self->{ metadata_prefix } = $metadata_prefix;
    $self->{ offset          } = $offset;
    $self->{ from            } = $from;
    $self->{ until           } = $until;

    $self->resumptionToken(
        join( ':', $metadata_prefix, $offset, $from, $until ) );
    $self->cursor( $offset );

    return $self;
}

# __END__ C4::AR::OAI::ResumptionToken

1;