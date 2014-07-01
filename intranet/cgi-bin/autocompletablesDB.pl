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
use C4::AR::Auth;
use C4::AR::Utilidades;

my $input = new CGI;
my $authnotrequired = 0;
my $flagsrequired = { ui => 'ANY', tipo_documento => 'ANY', accion => 'CONSULTA', entorno => 'sistema'};

my $session = CGI::Session->load();

my $type = $session->param('type') || "opac";

my ($user, $session, $flags)= C4::AR::Auth::checkauth($input, $authnotrequired, $flagsrequired, $type);

my $operacion   = C4::AR::Utilidades::trim( $input->param('operacion') ) || '';
my $accion      = C4::AR::Utilidades::trim( $input->param('accion') );
my $string      = C4::AR::Utilidades::trim( $input->param('q') );
# C4::AR::Debug::debug("BUSCASTE: ".$string);
#Variable para luego hacerle el print
my $result;

if ($accion eq 'autocomplete_monedas'){

    $result = C4::AR::Utilidades::monedasAutocomplete($string);
}
elsif ($accion eq 'autocomplete_ciudades'){

    $result = C4::AR::Utilidades::ciudadesAutocomplete($string);
}
elsif ($accion eq 'autocomplete_paises'){

    $result = C4::AR::Utilidades::paisesAutocomplete($string);
}
elsif ($accion eq 'autocomplete_lenguajes'){

    $result = C4::AR::Utilidades::lenguajesAutocomplete($string);
}
elsif ($accion eq 'autocomplete_autores'){

    $result = C4::AR::Utilidades::autoresAutocomplete($string);
}
elsif ($accion eq 'autocomplete_soportes'){

    $result = C4::AR::Utilidades::soportesAutocomplete($string);
}
elsif ($accion eq 'autocomplete_usuarios'){

    $result = C4::AR::Utilidades::usuarioAutocomplete($string);
}
elsif ($accion eq 'autocomplete_usuarios_con_regularidad'){

    $result = C4::AR::Utilidades::usuarioAutocomplete($string, 1);
}
elsif ($accion eq 'autocomplete_usuarios_by_credential'){

    my @array_credentials; 
    
    push(@array_credentials, "librarian");
    push(@array_credentials, "superlibrarian");

    $result = C4::AR::Utilidades::usuarioAutocompleteByCredentialType($string, \@array_credentials);
}
elsif ($accion eq 'autocomplete_barcodes_prestados'){

	$result = C4::AR::Utilidades::barcodePrestadoAutocomplete($string);
}
elsif ($accion eq 'autocomplete_barcodes'){

     $result = C4::AR::Utilidades::barcodeAutocomplete($string);
}
elsif ($accion eq 'autocomplete_temas'){

     $result = C4::AR::Utilidades::autocompleteTemas($string);
}
elsif ($accion eq 'autocomplete_editoriales'){

     $result = C4::AR::Utilidades::autocompleteEditoriales($string);
}
elsif ($accion eq 'autocomplete_ayuda_marc'){

     $result = C4::AR::Utilidades::ayudaCampoMARCAutocomplete($string);
}
elsif ($accion eq 'autocomplete_UI'){

     $result = C4::AR::Utilidades::uiAutocomplete($string);
}
elsif ($accion eq 'autocomplete_catalogo'){

    $result = C4::AR::Utilidades::catalogoAutocomplete($string);
}
elsif ($accion eq 'autocomplete_nivel2'){
    $result = C4::AR::Utilidades::gruposAutocomplete($string);
}
elsif ($accion eq 'autocomplete_catalogo_id'){

    $result = C4::AR::Utilidades::catalogoAutocompleteId($string);
}
elsif ($accion eq 'autocomplete_nivel2_id'){
	my $id1 = C4::AR::Nivel2::getNivel2FromId2($string);
	if ($id1){
	   $id1   =  $id1->getId1;
	}else{
		$id1 = "-1";
	}
    $result = C4::AR::Utilidades::catalogoAutocompleteId($id1);
}


C4::AR::Auth::print_header($session);
print C4::AR::Utilidades::escapeData($result);

1;