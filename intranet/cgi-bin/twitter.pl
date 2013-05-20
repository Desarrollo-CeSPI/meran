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
use CGI;
use JSON;
use C4::AR::Auth;
require Exporter;
use Net::Twitter;
use Net::Twitter::Role::OAuth;
use Scalar::Util 'blessed';
use WWW::Shorten::Bitly;
use C4::AR::Social;


# my $consumer_key        = "ee4q1gf165jmFQTObJVY2w";
# my $consumer_secret     = "F4TEnfC1SjYm3XG6vHZ0aJmsYQIFysyu9bwjG9BDdQ";
# my $token               = "148446079-IL4MsMqXzKU24xMr32No58H5meHmsqLMZHk4qZ0";
# my $token_secret        = "fSCpzZELbLFYQPJtP7nRJFQjgfGXvR0538a0i0AIcj0"; 

my $input = new CGI;
my $obj   = $input->param('obj');

my ($template, $session, $t_params) = get_template_and_user({
                                    template_name => "/main.tmpl",
                                    query => $input,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'usuarios'},
                                    debug => 1,
                });



my $post;
my $mensaje;

if($obj){
     
      $obj = C4::AR::Utilidades::from_json_ISO($obj);
      C4::AR::Debug::debug($obj);
      my $action= $obj->{'tipoAccion'};
    
      if ($action = "PUBLICAR_TWITTER"){
            $post = $obj->{'post'};
      }
} else {  
      $post =$input->param('textarea_twitter');
}

$mensaje= C4::AR::Social::sendPost($post);

if($obj){
      my $infoOperacionJSON   = to_json $mensaje;
      C4::AR::Auth::print_header($session);
      print $infoOperacionJSON;
} else {
      $t_params->{'mensaje'} = $mensaje;
      C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
}