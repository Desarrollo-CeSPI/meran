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
                                template_name => "usuarios/potenciales/buscarUsuarioResult.tmpl",
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
my $socioBuscado=$obj->{'persona'};
my $ini=$obj->{'ini'};
my $funcion=$obj->{'funcion'};
my $inicial=$obj->{'inicial'};
my $activo;
my ($cantidad,$socios);
my ($ini,$pageNumber,$cantR)=C4::AR::Utilidades::InitPaginador($ini);
my $habilitados = $obj->{'habilitados_filter'} || 0; #se setea por defecto para mostrar los deshabilitados

if ($inicial){
    ($cantidad,$socios)= C4::AR::Usuarios::getSocioLike($socioBuscado,$orden,$ini,$cantR,$habilitados,$inicial);
}else{												
    ($cantidad,$socios)= C4::AR::Usuarios::getSocioLike($socioBuscado,$orden,$ini,$cantR,$habilitados,0);
}

$t_params->{'paginador'}= C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);

if($socios){

	my $comboDeCategorias= C4::AR::Utilidades::generarComboCategoriasDeSocio();
	
	my @resultsdata; 
	my $i=0;
	
	foreach my $socio (@$socios){
		my $clase="";

    	$activo = C4::AR::Utilidades::translateYesNo_fromNumber($socio->esRegular);
		
		my %row = (
				clase=> $clase,
				socio => $socio,
				comboCategorias => $comboDeCategorias,
				activo => $activo,
		);
	
		push(@resultsdata, \%row);
	}
	
	$t_params->{'resultsloop'}= \@resultsdata;
	

}#END if($socios)

$t_params->{'cantidad'}= $cantidad;
$t_params->{'socio_busqueda'}= $socioBuscado;
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
