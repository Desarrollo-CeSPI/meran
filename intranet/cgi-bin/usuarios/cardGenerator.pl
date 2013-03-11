#!/usr/bin/perl

require Exporter;

use strict;
use CGI;
use C4::Context;
use C4::AR::Auth;
use PDF::Report;
use C4::AR::PdfGenerator;

my $input= new CGI;
my $authnotrequired= 0;

my ($userid, $session, $flags) = C4::AR::Auth::checkauth(   $input, 
                                                        $authnotrequired,
                                                        {   ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'MODIFICACION', 
                                                            entorno => 'usuarios'
                                                        },
                                                        "intranet"
                            );

my $nro_socio = $input->param('nro_socio');

my $tmpFileName= $nro_socio.".pdf";
my $pdf = C4::AR::PdfGenerator::cardGenerator($nro_socio);
print "Content-type: application/pdf\n";
print "Content-Disposition: attachment; filename=\"$tmpFileName\"\n\n";
print $pdf->Finish();
