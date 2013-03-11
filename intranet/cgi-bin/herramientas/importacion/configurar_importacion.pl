#!/usr/bin/perl
use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use CGI;
use C4::AR::ImportacionIsoMARC;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "/herramientas/importacion/configurar_importacion.tmpl",
                                    query => $query,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY',
                                                        tipo_documento => 'ANY',
                                                        accion => 'CONSULTA',
                                                        entorno => 'undefined'},
                                    debug => 1,
            });
my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($query->param('id_importacion'));
$t_params->{'importacion'}          = $importacion;
$t_params->{'selectCampoX1'}         = C4::AR::Utilidades::generarComboCampoX('eleccionCampoOrigenX("1","'.$importacion->getIdImportacionEsquema.'")','','campoX1');
$t_params->{'selectCampoX2'}         = C4::AR::Utilidades::generarComboCampoX('eleccionCampoOrigenX("2","'.$importacion->getIdImportacionEsquema.'")','','campoX2');
$t_params->{'selectCampoX'} = C4::AR::Utilidades::generarComboCampoX('eleccionCampoX()');

C4::AR::Auth::output_html_with_http_headers($template, $t_params,$session);
