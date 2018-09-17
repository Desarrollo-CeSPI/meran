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
my $input  = new CGI;
my %resp_hash=();
my $nro_socio = $input->param('nro_socio');

if( $ENV{ 'REQUEST_METHOD' } eq 'GET' ){
	my $socio= C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
	if ( (!$socio) || ($socio == 0) ){
	 #No existe el usuario 404
	  	
	} else {
		my $msg_object = C4::AR::Usuarios::_verificarLibreDeuda($obj->{'nro_socio'});


		if (!($msg_object->{'error'})){
		#Libre deuda aprobado
			
		} else {
		#Libre deuda rechazado

	 	}
	
	}
	print $input->header('application/json');
	my $json = encode_json \%resp_hash;
	print "$json\n";
}