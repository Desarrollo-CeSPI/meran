#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::Date;
use C4::AR::Proveedores;

my $input = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                template_name   => "adquisiciones/listProveedoresResult.tmpl",
                                query           => $input,
                                type            => "intranet",
                                authnotrequired => 0,
                                flagsrequired   => {    ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        tipo_permiso => 'general',
                                                        entorno => 'adq_intra'}, # FIXME
                                debug           => 1,
                 });

  my $accion    = $input->param('accion');
  my $obj       = C4::AR::Utilidades::from_json_ISO($input->param('obj'));

  my $orden     = $obj->{'orden'}||'nombre';
  my $funcion   = $obj->{'funcion'};
  my $inicial   = $obj->{'inicial'};
  my $proveedor = $obj->{'nombre_proveedor'};
  my $ini       = $obj->{'ini'} || 1;

  my $funcion   = $obj->{'funcion'};

  my ($cantidad,$proveedores);
  my ($ini,$pageNumber,$cantR) = C4::AR::Utilidades::InitPaginador($ini);
 
  if ($inicial){
     ($cantidad,$proveedores) = C4::AR::Proveedores::getProveedorLike($proveedor,$orden,$ini,$cantR,1,$inicial);
  }else{
     ($cantidad,$proveedores) = &C4::AR::Proveedores::getProveedorLike($proveedor,$orden,$ini,$cantR,1,0);
  }
  
  if($proveedores){
      $t_params->{'paginador'} = C4::AR::Utilidades::crearPaginador($cantidad,$cantR, $pageNumber,$funcion,$t_params);
      my @resultsdata;
  
      for my $proveedor (@$proveedores){
         my $clase="";     
           my %row = ( proveedor => $proveedor, );
           push(@resultsdata, \%row);
       }
      
      $t_params->{'resultsloop'}        = \@resultsdata;
      $t_params->{'cantidad'}           = $cantidad;
      $t_params->{'proveedor_busqueda'} = $proveedor;
 
  }#END if($proveedores)

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
