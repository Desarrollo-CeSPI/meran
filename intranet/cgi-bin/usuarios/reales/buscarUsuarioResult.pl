#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::Date;
use Date::Manip;
use C4::AR::Usuarios;
use C4::AR::Utilidades;


my $input = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
								template_name => "usuarios/reales/buscarUsuarioResult.tmpl",
								query => $input,
								type => "intranet",
								authnotrequired => 0,
								flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'usuarios'},
								debug => 1,
			     });


my $obj=C4::AR::Utilidades::from_json_ISO($input->param('obj'));

my $orden=$obj->{'orden'}||'apellido';
my $socio=$obj->{'socio'};
my $string = $socio;

C4::AR::Debug::debug("socio string : " . $socio);
 
$obj->{'ini'} = $obj->{'ini'} || 1;
my $ini=$obj->{'ini'};
my $funcion=$obj->{'funcion'};
my $inicial=$obj->{'inicial'};
my $env;
C4::AR::Validator::validateParams('U389',$obj,['socio','ini','funcion'] );


my ($cantidad,$socios);
my ($ini,$pageNumber,$cantR)=C4::AR::Utilidades::InitPaginador($ini);

if ($inicial){
    ($cantidad,$socios)= C4::AR::Usuarios::getSocioLike($socio,$orden,$ini,$cantR,1,$inicial);
}else{
    ($cantidad,$socios)= C4::AR::Usuarios::getSocioLike($socio,$orden,$ini,$cantR,1,0);
}

$t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
my @resultsdata;

foreach my $socio (@$socios){
    my $clase="";
	my ($od,$issue)=C4::AR::Prestamos::cantidadDePrestamosPorUsuario($socio->getNro_socio);
	my $regular= $socio->esRegular;
	
	my %row = (
			clase=>$clase,
			socio => $socio,
			issue => $issue,
			od => $od,
			regular => $regular,
	);
	push(@resultsdata, \%row);
}
	
$t_params->{'resultsloop'}      = \@resultsdata;
$t_params->{'cantidad'}         = $cantidad;
$t_params->{'socio_busqueda'}   = Encode::encode_utf8($string); #acentos

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
