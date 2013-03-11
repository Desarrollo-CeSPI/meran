#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Date;
use C4::AR::Prestamos;
use Date::Manip;
use C4::Date;
use C4::AR::Sanciones;

my $input = new CGI;

my ($template, $session, $t_params) =  get_template_and_user ({
			template_name	=> 'usuarios/reales/detalleSanciones.tmpl',
			query		    => $input,
			type		    => "intranet",
			authnotrequired	=> 0,
			flagsrequired	=> {    ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
});

my $obj         = $input->param('obj');
my $obj         = C4::AR::Utilidades::from_json_ISO($obj);
my $nro_socio   = $obj->{'nro_socio'};

C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

my $sanciones = C4::AR::Sanciones::tieneSanciones($nro_socio);

if ($sanciones){
	$t_params->{'SANCIONES'} = $sanciones;
}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
