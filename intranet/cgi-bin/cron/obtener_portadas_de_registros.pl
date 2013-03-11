#!/usr/bin/perl

use C4::AR::PortadasRegistros;

my $session =  CGI::Session->load() || CGI::Session->new();
$session->param("type","intranet");
$session->param('nro_socio', 'kohaadmin');
C4::AR::PortadasRegistros::getAllImages();
