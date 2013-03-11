#!/usr/bin/perl

use strict;
require Exporter;
use CGI;
use C4::AR::Auth;

use C4::AR::Busquedas;

my $input=new CGI;

my ($template, $session, $t_params) = get_template_and_user({
				template_name   => ('busquedas/MARCDetalle.tmpl'),
				query           => $input,
				type            => "intranet",
				authnotrequired => 0,
				flagsrequired   => {    ui => 'ANY', 
                                        tipo_documento => 'ANY', 
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
    });

my $obj=C4::AR::Utilidades::from_json_ISO($input->param('obj'));
my $idNivel3=$obj->{'id3'};

my $MARCDetail_array = C4::AR::Busquedas::MARCDetail($idNivel3,'intra');
my $marc_record	= C4::AR::Busquedas::MARCRecordById3WithReferences($idNivel3);

$t_params->{'MARCDetail_array'}= $MARCDetail_array;
$t_params->{'detalle_marc'}= $marc_record->as_formatted;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
