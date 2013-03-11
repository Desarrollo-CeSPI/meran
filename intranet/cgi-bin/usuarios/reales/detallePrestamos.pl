#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Date;
use C4::AR::Prestamos;
use Date::Manip;
use C4::Date;
use C4::AR::Sanciones;

my $input=new CGI;

my ($template, $session, $t_params) =  get_template_and_user ({
							template_name	=> 'usuarios/reales/detallePrestamos.tmpl',
							query		    => $input,
							type		    => "intranet",
							authnotrequired	=> 0,
							flagsrequired	=> {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'undefined'},
    });

my $obj = $input->param('obj');
$obj    = C4::AR::Utilidades::from_json_ISO($obj);
C4::AR::Validator::validateParams('U389',$obj,['nro_socio'] );

my $nro_socio                   = $obj->{'nro_socio'};
my $prestamos                   = C4::AR::Prestamos::obtenerPrestamosDeSocio($nro_socio);
C4::AR::Validator::validateObjectInstance($prestamos);

$t_params->{'PRESTAMOS'}        = $prestamos;
$t_params->{'prestamos_cant'}   = scalar(@$prestamos);
my $algunoSeRenueva             = 0;
my $vencidos                    = 0;

foreach my $prestamo (@$prestamos) {
	if($prestamo->estaVencido){$vencidos++;}
	if($prestamo->sePuedeRenovar){$algunoSeRenueva=1;}
}

$t_params->{'vencidos'}         = $vencidos;
$t_params->{'algunoSeRenueva'}  = $algunoSeRenueva;

#se ferifica si la preferencia "circularDesdeDetalleUsuario" esta seteada
$t_params->{'circularDesdeDetalleUsuario'} = C4::AR::Preferencias::getValorPreferencia('circularDesdeDetalleUsuario');

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
