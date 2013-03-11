#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Modelo::PrefTablaReferenciaConf;
use JSON;

my $input   = new CGI;
my $editing = $input->param('id');

if($editing){

    my $type    = $input->param('type');
    
    my ($template, $session, $t_params)  = get_template_and_user({  
                            template_name   => "includes/partials/modificar_value.tmpl",
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {  ui            => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'CONSULTA', 
                                                entorno         => 'permisos', 
                                                tipo_permiso    => 'general'},
                            debug => 1,
                        });
    my $configuracion; 
    my $value;   
    my $tabla_campo; 
    my ($campo,$tabla);                   

    if($type eq "nombre"){
        $value              = $input->param('value');
        $tabla_campo        = $input->param('id');
        my ($campo,$tabla)  = split(",", $tabla_campo);
        $configuracion      = C4::Modelo::PrefTablaReferenciaConf::getConfig($tabla,$campo);
        if ($configuracion){
            $configuracion->setCampoAlias($value);
        }
    }
    $t_params->{'value'} = $configuracion->getCampoAlias();

    C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}
else{
    my $obj             = $input->param('obj');
    $obj                = C4::AR::Utilidades::from_json_ISO($obj);
    my $accion          = $obj->{'accion'};
    my $authnotrequired = 0;

    if ($accion eq "OBTENER_TABLA"){

        my $alias_tabla = $obj->{'alias_tabla'};

        my ($template, $session, $t_params) = get_template_and_user({  
                            template_name   => "catalogacion/tablasReferencia/detalle_tabla.tmpl",
                            query           => $input,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {  ui            => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'CONSULTA', 
                                                entorno         => 'permisos', 
                                                tipo_permiso    => 'general'},
                            debug           => 1,
                        });

        my ($data)          = C4::Modelo::PrefTablaReferenciaConf::getConfTabla($alias_tabla);

        $t_params->{'data'} = $data;
       

        C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
    }
    elsif ($accion eq "CHANGE_VISIBILIDAD"){
    
        my $tabla  = $obj->{'tabla'};
        my $campo  = $obj->{'campo'};
               
        my ($user, $session, $flags)= checkauth(  $input, 
                                                  $authnotrequired, 
                                                  {   ui                => 'ANY', 
                                                      tipo_documento    => 'ANY', 
                                                      accion            => 'CONSULTA', 
                                                      entorno           => 'undefined'}, 
                                                  'intranet'
                                      );

        my ($data)          = C4::Modelo::PrefTablaReferenciaConf::cambiarVisivilidad($tabla,$campo);
        
        return  1;

    }
}
