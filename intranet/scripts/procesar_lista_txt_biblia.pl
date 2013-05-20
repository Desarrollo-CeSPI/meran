#!/usr/local/perl
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
require Exporter;
use C4::Context;
use C4::Modelo::PrefEstructuraSubcampoMarc::Manager;
use C4::Modelo::PrefEstructuraSubcampoMarc;
use C4::Modelo::PrefEstructuraCampoMarc::Manager;
use C4::Modelo::PrefEstructuraCampoMarc;
use C4::Modelo::PrefIndicadorPrimario::Manager;
use C4::Modelo::PrefIndicadorPrimario;
use C4::Modelo::PrefIndicadorSecundario::Manager;
use C4::Modelo::PrefIndicadorSecundario;

########Algunos metodos############
sub trim
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

sub getCampo {
    my ($campo) = @_;
    my @filtros;
    push(@filtros, ( campo => { like => $campo} ) );
    my $db_campo_MARC = C4::Modelo::PrefEstructuraCampoMarc::Manager->get_pref_estructura_campo_marc( query => \@filtros );

    if (scalar(@$db_campo_MARC) > 0){
        return $db_campo_MARC->[0];
    }else{
        return 0;
    }
}

sub getSubCampo {
    my ($campo,$subcampo) = @_;
    my @filtros;
    push(@filtros, ( campo => { like => $campo} ) );
    push(@filtros, ( subcampo => { like => $subcampo} ) );
    my $db_subcampo_MARC = C4::Modelo::PrefEstructuraSubcampoMarc::Manager->get_pref_estructura_subcampo_marc( query => \@filtros );

   if (scalar(@$db_subcampo_MARC) > 0){
        return $db_subcampo_MARC->[0];
    }else{
        return 0;
    }
}

my $data_file = $ARGV[0];
open(DATOS, $data_file) || die("Could not open file!");

my %datos;
my $line;
while ($line= <DATOS>) {
    while (!($line =~ /^[\d]{3,3}/)) {$line=<DATOS>;}
    
    #Campo Nuevo
    $line=trim($line);
    chomp($line);

    my $campo=substr($line,0,3);
    $datos{$campo}->{'descripcion'}=trim(substr($line,6));

    if($line =~ /\[OBSOLETE\]$/){$datos{$campo}->{'obsoleto'}=1;}
      elsif($line =~ /\[LOCAL\]$/){#print "CAMPO LOCAL WTF!!\n";
        }
	elsif($line =~ /\(R\)$/){$datos{$campo}->{'repetible'}=1;}
	  elsif($line =~ /\(NR\)$/){$datos{$campo}->{'repetible'}=0;}
	    else{#print "NO DICE NADA\n";
		  $datos{$campo}->{'repetible'}=0;}

    #Indicadores
    $line=<DATOS>;
    chomp($line);

    if($line =~ m/Indicators/) {
    
	while (!($line =~ m/First/)) {$line=<DATOS>;}
    chomp($line);
	$datos{$campo}->{'primario'}->{'descripcion'}= trim(substr($line,14));
	$line=<DATOS>;
	while (!($line =~ m/Second/)){
	
	  $line=trim($line);
	   chomp($line);
	  if($line =~ m/^0-9/){ #Caso especial - campo indicador  0-9
	    $datos{$campo}->{'primario'}->{'elementos'}->{'0-9'}=substr($line,6); 
	  }else{
	    $datos{$campo}->{'primario'}->{'elementos'}->{substr($line,0,1)}=substr($line,4);
	  }
	  
	  $line=<DATOS>;
	}
	
	$datos{$campo}->{'secundario'}->{'descripcion'}= trim(substr($line,15));
	$line=<DATOS>;
	while (!($line =~ m/Subfield Codes/)){

	  $line=trim($line);
      chomp($line);	  
	  if($line =~ m/^0-9/){ #Caso especial - campo indicador  0-9
	    $datos{$campo}->{'secundario'}->{'elementos'}->{'0-9'}=substr($line,6); 
	  }else{
	    $datos{$campo}->{'secundario'}->{'elementos'}->{substr($line,0,1)}=substr($line,4);
	  }
	  $line=<DATOS>;
	}
	
	$line=<DATOS>;
	while ((chomp($line) ne '')&&($line)) {
	  $line=trim($line);
	  my $subcampo;
	  
	  if(substr($line,2,1) eq '-'){#Caso especial por ej campo a-z!!
	    $subcampo=substr($line,1,3);
	    $datos{$campo}->{'subcampos'}->{$subcampo}->{'descripcion'}=substr($line,7);
	  }
	  else{
	    $subcampo=substr($line,1,1);
	    $datos{$campo}->{'subcampos'}->{$subcampo}->{'descripcion'}=substr($line,5);
	  }
	  if($line =~ /\[OBSOLETE\]$/){$datos{$campo}->{'subcampos'}->{$subcampo}->{'obsoleto'}=1;}
	    elsif($line =~ /\[LOCAL\]$/){#print "CAMPO LOCAL WTF!!\n";
        }
	      elsif($line =~ /\(R\)$/){$datos{$campo}->{'subcampos'}->{$subcampo}->{'repetible'}=1;}
		elsif($line =~ /\(NR\)$/){ $datos{$campo}->{'subcampos'}->{$subcampo}->{'repetible'}=0;}
		  else{	
		    #print "NO DICE NADA\n";
		    $datos{$campo}->{'subcampos'}->{$subcampo}->{'repetible'}=0;
		    }
	  
	  $line=<DATOS>;
	}
    }
}

 print 'SET NAMES UTF8;';
 print "\n";
 print 'TRUNCATE pref_indicador_primario;';
 print "\n";
 print 'TRUNCATE pref_indicador_secundario;';
 print "\n";

####A RECORRER!!!!!!!!!!!!!!
my $sql='';
while ( my ($key, $value) = each(%datos) ) {
    #Prosesamos el campo
    my $campo=getCampo($key);
    if($campo){ #El campo existe
      $sql='UPDATE pref_estructura_campo_marc SET indicador_primario="'.$value->{'primario'}->{'descripcion'}.'",indicador_secundario="'.$value->{'secundario'}->{'descripcion'}.'",liblibrarian="'.$value->{'descripcion'}.'",libopac="'.$value->{'descripcion'}.'",repeatable="'.$value->{'repetible'}.'"';
      if($value->{'obsoleto'}){$sql.=' ,descripcion="OBSOLETO" ';}
      $sql.=' WHERE campo="'.$key.'";';
    } 
    else { #campo nuevo
      my $obsoleto='';
      if($value->{'obsoleto'}){$obsoleto="OBSOLETO";}
      $sql='INSERT INTO pref_estructura_campo_marc (campo,liblibrarian,libopac,repeatable,descripcion,indicador_primario,indicador_secundario) VALUES ("'.$key.'","'.$value->{'descripcion'}.'","'.$value->{'descripcion'}.'","'.$value->{'repetible'}.'","'.$obsoleto.'","'.$value->{'primario'}->{'descripcion'}.'","'.$value->{'secundario'}->{'descripcion'}.'"); ';
    }
     print $sql;
     print "\n";
     $sql='';

    #Prosesamos los indicadores primarios
    my $first=$value->{'primario'}->{'elementos'};
    while ( my ($keyF, $valueF) = each(%$first) ){
       print 'INSERT into pref_indicador_primario (indicador,dato, campo_marc) values ("'.$keyF.'","'.$valueF.'","'.$key.'");';
       print "\n";
    }

    #Prosesamos los indicadores secundarios
    my $second=$value->{'secundario'}->{'elementos'};
    while ( my ($keyS, $valueS) = each(%$second) ) {
       print 'INSERT into pref_indicador_secundario (indicador,dato, campo_marc) values  ("'.$keyS.'","'.$valueS.'","'.$key.'");';
       print "\n";
     }
    
    #Subcampos!!!!!!
    my $subcampos = $value->{'subcampos'};
    while ( my ($keySub, $valueSub) = each(%$subcampos) ) {

        my $subcampo=getSubCampo($key,$keySub);
        if($subcampo){ #El subcampo existe
              $sql='UPDATE pref_estructura_subcampo_marc SET liblibrarian="'.$valueSub->{'descripcion'}.'",libopac="'.$valueSub->{'descripcion'}.'",repetible="'.$valueSub->{'repetible'}.'"';
              if($valueSub->{'obsoleto'}){$sql.=' ,descripcion="OBSOLETO" ';}
              $sql.=' WHERE campo="'.$key.'" AND subcampo="'.$keySub.'";';
            } 
        else { #subcampo nuevo
              my $obsoleto='';
              if($valueSub->{'obsoleto'}){$obsoleto="OBSOLETO";}
              $sql='INSERT INTO pref_estructura_subcampo_marc (campo,subcampo,liblibrarian,libopac,repetible,descripcion) VALUES ("'.$key.'","'.$keySub.'","'.$valueSub->{'descripcion'}.'","'.$valueSub->{'descripcion'}.'","'.$valueSub->{'repetible'}.'","'.$obsoleto.'"); ';
            }
         print $sql;
         print "\n";
         $sql ='';

#         my $subcampoEstructura=getSubCampoFromEstructura($key,$keySub);
#         if($subcampoEstructura){ #El subcampo existe en la tabla estructura, actualizo la descripcion
#               $sql='UPDATE cat_estructura_catalogacion SET liblibrarian="'.$value->{'descripcion'}.'",repetible="'.$value->{'repetible'}.'" WHERE campo="'.$key.'" AND subcampo="'.$keySub.'";';
#               print $sql;
#               print "\n";
#               $sql ='';
#             }

     }
}