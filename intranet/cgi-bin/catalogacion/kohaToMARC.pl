#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

use CGI;
use C4::AR::VisualizacionOpac;

my $input = new CGI;

my $mensajeError = $input->param('mensajeError')||"";

my ($template, $nro_socio, $cookie)= get_template_and_user({
                    template_name => "catalogacion/kohaToMARC.tmpl",
			        query => $input,
			        type => "intranet",
			        authnotrequired => 0,
			        flagsrequired => {  ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
			        debug => 1,
			 });


 my @tablas = ['biblio','biblioitems','items','bibliosubject','bibliosubtitle','additionalauthors','publisher','isbns', 'nivel1', 'nivel2', 'nivel3'];


 my $selectTablasKoha=CGI::scrolling_list(  	-name      => 'tablasKoha',
 						-id	   => 'tablasKoha',
						-values    => @tablas,
                                		-size      => 1,
						-onChange  => 'SelectTablasKohaChange()',
                                  	);


$template->param(
 			tablasKoha  => $selectTablasKoha,
			mensajeError => $mensajeError,
);

output_html_with_http_headers $cookie, $template->output;
