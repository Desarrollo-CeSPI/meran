#!/usr/bin/perl
use strict;
require Exporter;
use C4::AR::Auth;
use CGI;
use C4::AR::MensajesContacto;
use C4::AR::BackgroundJob;

my $job = C4::AR::BackgroundJob->new();

for (my $x=0; $x<10; $x++){
    C4::AR::Utilidades::printAjaxPercent(10,$x);
    sleep(1);
}
