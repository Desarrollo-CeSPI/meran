#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use CGI qw/:standard -oldstyle_urls/;
use Encode;
use vars qw( $GZIP );
use C4::Context;
use C4::AR::OAI::Repository;

BEGIN {
    eval { require PerlIO::gzip };
    $GZIP = $@ ? 0 : 1;
}

unless ( C4::AR::Preferencias::getValorPreferencia('OAI-PMH') ) {
    print
        header(
            -type       => 'text/plain; charset=utf-8',
            -charset    => 'utf-8',
            -status     => '404 OAI-PMH service is disabled',
        ),
        "OAI-PMH service is disabled";
}
else {

my @encodings = http('HTTP_ACCEPT_ENCODING');
if ( $GZIP && grep { defined($_) && $_ eq 'gzip' } @encodings ) {
    print header(
        -type               => 'text/xml; charset=utf-8',
        -charset            => 'utf-8',
        -Content-Encoding   => 'gzip',
    );
    binmode( STDOUT, ":gzip" );
}
else {
    print header(
        -type       => 'text/xml; charset=utf-8',
        -charset    => 'utf-8',
    );
}

#   $utf8data = encode("utf8", decode("iso-8859-1", $latin1data));


binmode( STDOUT,":utf-8"  );
my $repository = C4::AR::OAI::Repository->new();
}

# __END__ Main Prog



