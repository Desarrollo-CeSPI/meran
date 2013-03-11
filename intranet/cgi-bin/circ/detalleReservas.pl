#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;



my $input=new CGI;

my ($template, $session, $t_params, $usuario_logueado) =  get_template_and_user ({
								template_name	=> 'circ/detalleReservas.tmpl',
								query		=> $input,
								type		=> "intranet",
								authnotrequired	=> 0,
								flagsrequired	=> {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
    });


my $obj         = $input->param('obj');
$obj            = C4::AR::Utilidades::from_json_ISO($obj);
my $nro_socio   = $obj->{'nro_socio'};
my $reservas    = C4::AR::Reservas::obtenerReservasDeSocio($nro_socio);

if($reservas){

	my @reservas_asignadas;
	my $racount = 0;
	my @reservas_espera;
	my $recount = 0;
	
	
	foreach my $reserva (@$reservas) {
		if ($reserva->getId3) {
			#Reservas para retirar
			push @reservas_asignadas, $reserva;
			$racount++;
		}else{
			#Reservas en espera
			push @reservas_espera, $reserva;
			$recount++;
		}
	}
	
	$t_params->{'RESERVAS_ASIGNADAS'}           = \@reservas_asignadas;
	$t_params->{'reservas_asignadas_count'}     = $racount;
	$t_params->{'RESERVAS_ESPERA'}              = \@reservas_espera;
	$t_params->{'reservas_espera_count'}        = $recount;
}


C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);