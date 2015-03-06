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
use C4::AR::Sphinx;
use C4::AR::CacheMeran;

	my $id1 = $ARGV[0] || '0'; #id1 del registro
	my $flag = $ARGV[1] || 'R_FULL'; #id1 del registro

	 my $tt1 = time();

	C4::AR::Sphinx::generar_indice($id1,$flag);
	
	#Agrego generar sugerencias del indice
	C4::AR::Sphinx::generar_sugerencias();

	 my $end1 = time();
	 my $tardo1=($end1 - $tt1);
	 my $min= $tardo1/60;
	 my $hour= $min/60;
 
	use C4::AR::Preferencias;
	use C4::AR::Mail;

	my %mail;                    

	$mail{'mail_from'}      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('mailFrom'));
	$mail{'mail_to'}        = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('mailFrom'));  
	$mail{'mail_subject'}   = "Generar Indice"; 
	$mail{'mail_message'}   = "Termino de generar el indice!! \n Tardo ".$hour." horas.";

	C4::AR::Mail::send_mail(\%mail);
1;