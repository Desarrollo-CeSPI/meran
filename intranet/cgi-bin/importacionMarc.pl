#!/usr/bin/perl



# Copyright 2000-2002 Katipo Communications
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Koha; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA  02111-1307 USA
#
#Este script , le pide a la modulo ImportacionIso, los datos de la tabla ISO2709 
#y se encarga de armar el arreglo para enviarlo al template import.
#

use strict;
use C4::AR::Auth;

use CGI;
use C4::AR::ImportacionIsoMARC;
use C4::AR::Busquedas;

my $input = new CGI;

my $theme = $input->param('theme') || "default";
my $campoIso = $input->param('code') || "1"; 
my ($template, $nro_socio, $cookie)
    = get_template_and_user({template_name => "importacionMarc.tmpl",

			     query => $input,
			     type => "intranet",
			     authnotrequired => 0,
			     flagsrequired => {     ui => 'ANY', 
                                        tipo_documento => 'ANY',  
                                        accion => 'CONSULTA', 
                                        entorno => 'undefined'},
			     debug => 1,
			     });

my $ok = $input->param('ok');
my $campoiso = $input->param('campoiso');
my $subcampoiso = $input->param('subcampoiso');

#Si se hizo una insercion, muestro sobre que campo y subcampo ingreso una nueva descripcion
$template->param( 
			ok 		=> $ok,
			campoiso	=> $campoiso,
			subcampoiso 	=> $subcampoiso,	
		);
#my @tablaskoha =mostrarTablas(); #Tomo todas las tablas de koha para que elegir a que tabla pertenece ese campo 
#y subcampo

#Luciano
#Luciano
my $i;
my @ordenes;
push(@ordenes,"");
for($i=1;$i<=9;$i++){
        my  $algo='k'.'0'.$i;
        push(@ordenes,$algo);
}

for($i=10;$i<=60;$i++){#para los campos k interfazWeb
  	my  $algo='k'.$i;
	push(@ordenes,$algo);
}

my $campos=CGI::scrolling_list(  -name     =>'campoK',
                                 -values   => \@ordenes,
                                 -size     => 1,
                               );



my @orden=("1","2","3","4","5","6","7","8","9","10");
my $orden1= CGI::scrolling_list(  -name     =>'orden',
                                  -values   => \@orden,
                                  -size     => 1,
                               );
my @orden2=("0","m","x");

my $campo5= CGI::scrolling_list(  -name     =>'campo5',
                                  -values   => \@orden2,
                                  -size     => 1,
                               );
my @orden3=("0","TI","PE","CO","IN","RE");
my $campo9= CGI::scrolling_list(  -name     =>'campo9',
                                  -values   => \@orden3,
                                  -size     => 1,
                               );

#Por los campos y subcampos MARC
my @branches;
my @select_branch;
my %select_branches;
my $branches=C4::AR::Busquedas::getBranches();
foreach my $branch (keys %$branches) {
        push @select_branch, $branch;
        $select_branches{$branch} = $branches->{$branch}->{'branchname'};
}

#Miguel - 03-04-07 - Le agrego una opcion para que le indique al usuario que no se ha seleccionado nada a�n, ver si queda
push @select_branch, 'SIN SELECCIONAR';

#agregado por Einar para que quede el branch por defecto
my $branch=$input->param('branch');
unless ($branch) {$branch=(split("_",(split(";",$cookie))[0]))[1];}
#hasta aca y la linea adentro del pasaje por parametros a la CGIbranch

my $CGIbranch=CGI::scrolling_list(      -name      => 'branch',
                                        -id        => 'branch',
                                        -values    => \@select_branch,
                                        -defaults  => $branch,
                                        -labels    => \%select_branches,
                                        -size      => 1,
                                        -multiple  => 0,
                                        -onChange  => 'cambioUnidadDeInformacion()',
					default    => 'SIN SELECCIONAR'
                                 );
#Fin: Por los branches
my @indices =listadoDeCodigosDeCampo($branch);

#Por los camposMArc
my @select_fieldMarc=mostrarCamposMARC();

my $MarcField=CGI::scrolling_list( 	-name      => 'fMarc',
		                        -id        => 'fMarc',
        		                -values    => \@select_fieldMarc,
	        	       	        #-labels    => \%select_fieldsMarc,
        	        	        -size      => 1,
	                        	-multiple  => 0,
					-onChange => 'cambiarListaDependiente(fMarc,listaSecundaria,idfrm)'
				 );

#Fin: Por los camposMArc

my @resultsdata=datosCompletos($campoIso,$branch);

#Luciano
my @select_fieldMarcYSubfields=mostrarSubCamposMARC();
my $inicializacion="";
my $valor="";
my $k=0;
for ($i=0; $i<scalar(@select_fieldMarc); $i++) {
	$inicializacion.= 'listaValues['.$i.'] = new Array();listaOptions['.$i.'] = new Array();listaCaract['.$i.'] = new Array();';
        my $j= 0;
	my $tagField= $select_fieldMarcYSubfields[$k]->{'tagfield'};
        while (($k<scalar(@select_fieldMarcYSubfields)) && ($tagField eq $select_fieldMarcYSubfields[$k]->{'tagfield'})) {
		$select_fieldMarcYSubfields[$k]->{'liblibrarian'}=~s/"//g;
		$valor.= 'listaCaract['.$i.']['.$j.']=new Array();listaCaract['.$i.']['.$j.'][0]="'.$select_fieldMarcYSubfields[$k]->{'repeatable'}.'";listaCaract['.$i.']['.$j.'][1]="'.$select_fieldMarcYSubfields[$k]->{'liblibrarian'}.'";listaValues['.$i.']['.$j.']="'.$select_fieldMarcYSubfields[$k]->{'tagsubfield'}.'";listaOptions['.$i.']['.$j.']="'.$select_fieldMarcYSubfields[$k]->{'tagsubfield'}.'";';
                $j+=1;
	$k++;
        }
}
##Luciano
#


$template->param( 
			resultsloop      => \@resultsdata,
			indices		 => \@indices,
			CGIbranch 	 => $CGIbranch,
			FieldMarc 	 => $MarcField,
			code 		 => $campoIso,
			branch           => $branch,
			ordenSelect      => $orden1,
                        inicializaciones => $inicializacion,
                        valores          => $valor,
			campo5s		 => $campo5,
			campo9s		 => $campo9,
			
		);

output_html_with_http_headers $cookie, $template->output;

