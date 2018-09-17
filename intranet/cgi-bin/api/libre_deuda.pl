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
use C4::AR::Usuarios;
use JSON;
use CGI;
use C4::Context;

my $input  = new CGI;

my %resp_hash=();

my $api_token = C4::Context->config('api_token');
my $token = $input->param('token');

if (!$api_token){
	$resp_hash{'error'} = '1';
	$resp_hash{'error_msg'} = '500';
} elsif($token != $api_token){
	$resp_hash{'error'} = '1';
	$resp_hash{'error_msg'} = 'Invalid Token';
} else {
	if( $ENV{ 'REQUEST_METHOD' } eq 'GET' ){
		my $nro_socio = $input->param('nro_socio');
		my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
		if ( (!$socio) || ($socio == 0) ){
		 #No existe el usuario 404
		  $resp_hash{'error'} = '1';
		  $resp_hash{'error_msg'} = '404';
		} else {
			my $msg_object = C4::AR::Usuarios::_verificarLibreDeuda($nro_socio);
			$resp_hash{'error'} = '0';
			if (!C4::AR::Mensajes::hayError($msg_object)){
			#Libre deuda aprobado
				$resp_hash{'libre_deuda'} = 'APROBADO';
			} else {
			#Libre deuda rechazado
				$resp_hash{'libre_deuda'} = 'RECHAZADO';
				$resp_hash{'libre_deuda_msg'} = $msg_object->{'messages'};
		 	}
		
		}
	}
}
print $input->header('application/json');
my $json = encode_json \%resp_hash;
print "$json\n";