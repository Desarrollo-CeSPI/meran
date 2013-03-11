#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

use C4::Date;
use C4::AR::Usuarios;
use Date::Manip;
use Cwd;
my $input=new CGI;

my ($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
			                    template_name	=> 'usuarios/potenciales/detalleUsuario.tmpl',
			                    query		=> $input,
			                    type		=> "intranet",
			                    authnotrequired	=> 0,
			                    flagsrequired	=> {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'usuarios'},
    });

    my $obj=$input->param('obj');
    $obj=C4::AR::Utilidades::from_json_ISO($obj);
    my $msg_object= C4::AR::Mensajes::create();
    my $nro_socio= $obj->{'nro_socio'};
	my $socio=C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio) || C4::AR::Utilidades::redirectAndAdvice('U353');

	$t_params->{'nro_socio'}= $nro_socio;
    $t_params->{'socio'}= $socio;


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);