#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#

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