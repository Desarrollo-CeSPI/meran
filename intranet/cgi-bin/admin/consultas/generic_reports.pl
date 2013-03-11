#!/usr/bin/perl

#Para configurar los campos involucrados en los reportes genericos
#Escrito el 26/9/2007 por matiasp@info.unlp.edu.ar
#
#Copyright (C) 2003-2007  Linti, Facultad de Inform�tica, UNLP
#This file is part of Koha-UNLP
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

use strict;
use C4::Output;

use C4::AR::Auth;
use CGI;
use C4::Context;
use C4::AR::Generic_Report;




my $input = new CGI;
my $tablename=$input->param('tablename');
my $fieldname=$input->param('fieldname');
my $nombre=$input->param('nombre');

if (!$fieldname)
{ 
	$fieldname='';
} 

my $op=$input->param('op');


my ($template, $session, $params) = get_template_and_user({
								template_name => "admin/generic_reports.tmpl",
								query => $input,
								type => "intranet",
								authnotrequired => 0,
								flagsrequired => {  ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'undefined'},
								debug => 1,
			    });


#Lista de  Tablas!!!
my @tablenames=C4::AR::Generic_Report::getAllTables();
#
#
if (!$tablename)
{ #No hay nada seleccionado
	$tablename=' ';
	push (@tablenames,' ');
}
#
my $tablenames= CGI::scrolling_list(
	   -name=>'tablename',
	   -id=>'tablename',
           -values=> \@tablenames,
	   -default=>$tablename,
	   -size=>1,
	   -multiple=>0,
	   -onChange=>"table_selected('GET_FIELDS')");

if (($op eq 'GET_FIELDS')||($fieldname ne ''))
{
	#Buscar los campos de $tablenameme,
	my @fields=C4::AR::Generic_Report::getFields($tablename);
	#
	
	my $fieldnames= CGI::scrolling_list(
						-name=>'fieldname',
						-id=>'fieldname',
						-values=>\@fields,
						-default=>$fieldname,
						-size=>1,
						-multiple=>0
					);  
				
	$params->{'fieldnames'}= $fieldnames;
}

if ($op eq 'ADD'){
	if (($tablename ne '')&&($fieldname ne '')){
	my $msg=C4::AR::Generic_Report::insertReportTable($tablename,$fieldname,$nombre);
	$params->{'msg'}= $msg;
	}
}


if ($op eq 'DELETE'){

	my $table=$input->param('table');
	my $field=$input->param('field');

	if (($table ne '')&&($field ne ''))
	{
		my $msg=C4::AR::Generic_Report::deleteReportTable($table,$field);
	}
}

#Busco las tablas que se encuentran ya agregadas en generic_report_tables
 my @tables=C4::AR::Generic_Report::getReportTables();


$params->{'TABLES'}= \@tables;
$params->{'tablenames'}= $tablenames;



#############################JOIN####################################JOIN##############################
my $tablejoin1=$input->param('tablejoin1');
my $fields1=$input->param('fields1');
my $tablejoin2=$input->param('tablejoin2');
my $fields2=$input->param('fields2');
my $unionjoin=$input->param('jointype');


if (!$fields1)
{ 
	$fields1='';
}

if (!$fields2)
{ 
	$fields2='';
}

my $tables1= CGI::scrolling_list(
	   -name=>'tablejoin1',
	   -id=>'tablejoin1',
           -values=> \@tablenames,
	   -default=>$tablejoin1,
	   -size=>1,
	   -multiple=>0,
	   -onChange=>"tablejoin_selected('GET_JOINFIELDS1')");

$params->{'tables1'}= $tables1;
  

if (($op eq 'GET_JOINFIELDS1')||($fields1 ne '')){
		#Buscar los campos de $tablejoin1
	my @fields1=C4::AR::Generic_Report::getFields($tablejoin1);
	#
	
	my $fields1= CGI::scrolling_list(
		-name=>'fields1',
		-id=>'fields1',
		-values=>\@fields1,
		-default=>$fields1,
		-size=>1,
		-multiple=>0                                                                                                                 );  
				
	$params->{'fields1'}= $fields1;
}


if ($tablejoin1){ #Se selecciono la 1ra tabla

	my $tables2= CGI::scrolling_list(
					-name=>'tablejoin2',
					-id=>'tablejoin2',
					-values=> \@tablenames,
					-default=>$tablejoin2,
					-size=>1,
					-multiple=>0,
					-onChange=>"tablejoin_selected('GET_JOINFIELDS2')"
					);
	
	$params->{'tables2'}= $tables2;
} #FIXME no se si cierra aca el IF, pero no estaba cerrado,.... VER URGENTE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

if (($op eq 'GET_JOINFIELDS2')||($fields2 ne ''))
{
		#Buscar los campos de $tablejoin2
		my @fields2=C4::AR::Generic_Report::getFields($tablejoin2);
		#
		
		my $fields2= CGI::scrolling_list(
						-name=>'fields2',
						-id=>'fields2',
						-values=>\@fields2,
						-default=>$fields2,
						-size=>1,
						-multiple=>0             
						);  
					
		$params->{'fields2'}= $fields2;
			
		my @jointypes=('INNER','LEFT','RIGHT');
		my $jointype= CGI::scrolling_list(
						-name=>'jointype',
						-id=>'jointype',
						-values=>\@jointypes,
						-default=>'INNER',
						-size=>1,
						-multiple=>		);
		
		$params->{'jointype'}= $jointype;


}

#Agregar un Join
if ($op eq 'ADDJOIN')
{
        if (($tablejoin1 ne '')&&($fields1 ne '')&&($tablejoin2 ne '')&&($fields2 ne ''))
		{
			my $msg=C4::AR::Generic_Report::insertReportJoinTable($tablejoin1,$fields1,$tablejoin2,$fields2,$unionjoin);
			$template->param(msg=> $msg);
					
		}
}


if ($op eq 'DELETEJOIN'){ 
	my $tabla1=$input->param('tabla1');
	my $campo1=$input->param('campo1');
	my $tabla2=$input->param('tabla2');
	my $campo2=$input->param('campo2');

	if (($tabla1 ne '')&&($campo1 ne '')&&($tabla2 ne '')&&($campo2 ne '')){
		my $msg=C4::AR::Generic_Report::deleteReportJoinTable($tabla1,$campo1,$tabla2,$campo2);
	}
}

#Busco los joins que se encuentran ya agregadas en generic_report_joins
 my @joins=C4::AR::Generic_Report::getReportJoinTables();

$params->{'JOINS'}= \@joins;
#

C4::AR::Auth::output_html_with_http_headers($template, $params);
