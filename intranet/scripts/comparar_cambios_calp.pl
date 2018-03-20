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
use lib qw(/usr/local/share/meran/dev/intranet/modules/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl5/);

use DBI;

use CGI::Session;
use C4::Context;
use Switch;
use C4::AR::Utilidades;
use C4::Modelo::RefPais;
use C4::Modelo::CatAutor;
use MARC::Record;
use C4::AR::ImportacionIsoMARC;
use C4::AR::Catalogacion;
use C4::Modelo::CatRegistroMarcN2Analitica;


my $db_driver =  "mysql";
my $db_name   = 'meran_calp_2015';
my $db_host   = 'db';
my $db_user   = 'root';
my $db_passwd = 'dev';
my $dbh = C4::Context->dbh;

my $db_calp= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_calp->do('SET NAMES utf8');

my $n1s = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1(); 
my $cant=0;
my $encontrado=0;
my $distinto_autor_principal=0;
my $distintos_autores_secundarios=0;
my $distintos_temas=0;
my $distintos_editores=0;

my $hash = ();

print "Total Registros ".scalar(@$n1s)."\n";

foreach my $n1 (@$n1s){
   my $id1=$n1->getId1();
   my $old = "SELECT * FROM  cat_registro_marc_n1 WHERE   id = ".$n1->getId1()."; ";
   my $old_rec = $db_calp->prepare($old);
   $old_rec->execute();
   my $cant_old_rec =  $old_rec->rows;
   if ($cant_old_rec gt 0){
   		$encontrado++;
   		my $new_record = $n1->getMarcRecordObject();
   		my $old_record_found = $old_rec->fetchrow_hashref();
   		my $old_record = MARC::Record->new_from_usmarc($old_record_found->{'marc_record'});


   		#Autores
   		my $new_autor = $new_record->subfield("100","a");
   		my $old_autor = $old_record->subfield("100","a");

   		if ($new_autor != $old_autor){
  			$distinto_autor_principal++;
        $hash->{$id1}->{'distinto_autor_principal'}=1;

        if($old_autor){
          my $id_autor        = C4::AR::Catalogacion::getRefFromStringConArrobas($old_autor);
          my $autor           = C4::Modelo::CatAutor->getByPk($id_autor);
          $hash->{$id1}->{'autor_anterior'} = $autor->toString;
        }

        if($new_autor){
        my $id_autor        = C4::AR::Catalogacion::getRefFromStringConArrobas($new_autor);
        my $autor           = C4::Modelo::CatAutor->getByPk($id_autor);
        $hash->{$id1}->{'autor_actual'} = $autor->toString;
        }

   		}

      #Autores Secundarios
      my @new_asec = $new_record->subfield("700","a");
      my @old_asec = $old_record->subfield("700","a");

      if ( comparar(\@new_asec,\@old_asec)){
         $distintos_autores_secundarios++;
         $hash->{$id1}->{'distintos_autores_secundarios'}=1;

         if (!$hash->{$id1}->{'asec_anteriores'}){
          $hash->{$id1}->{'asec_anteriores'}="";
         }
        if (!$hash->{$id1}->{'asec_actuales'}){
          $hash->{$id1}->{'asec_actuales'}="";
           }

        foreach my $ref (@old_asec){
          my $id_autor        = C4::AR::Catalogacion::getRefFromStringConArrobas($ref);
          my $autor           = C4::Modelo::CatAutor->getByPk($id_autor);
          $hash->{$id1}->{'asec_anteriores'}.= $autor->toString;
        }

        foreach my $ref (@new_asec){
          my $id_autor        = C4::AR::Catalogacion::getRefFromStringConArrobas($ref);
          my $autor           = C4::Modelo::CatAutor->getByPk($id_autor);
          $hash->{$id1}->{'asec_actuales'}.= $autor->toString;
        }
      }

   		#Temas
   		my @new_temas = $new_record->subfield("650","a");
   		my @old_temas = $old_record->subfield("650","a");

   		if ( comparar(\@new_temas,\@old_temas)){
			   $distintos_temas++;
         $hash->{$id1}->{'distintos_temas'}=1;
         if (!$hash->{$id1}->{'temas_anteriores'}){
          $hash->{$id1}->{'temas_anteriores'}="";
         }
        if (!$hash->{$id1}->{'temas_actuales'}){
          $hash->{$id1}->{'temas_actuales'}="";
           }

        foreach my $ref (@old_temas){
          my $id_tema        = C4::AR::Catalogacion::getRefFromStringConArrobas($ref);
          my $tema           = C4::Modelo::CatTema->getByPk($id_tema);
          $hash->{$id1}->{'temas_anteriores'}.= $tema->toString;
        }

        foreach my $ref (@new_temas){
          my $id_tema        = C4::AR::Catalogacion::getRefFromStringConArrobas($ref);
          my $tema           = C4::Modelo::CatTema->getByPk($id_tema);
          $hash->{$id1}->{'temas_actuales'}.= $tema->toString;
        }

      }

       # my @new_editores = editores($n1->getId1(),$dbh);
       # my @old_editores = editores($n1->getId1(),$db_calp);

       # if ( comparar(\@new_editores,\@old_editores)){
       #    $distintos_editores++;
       #    $hash->{$n1}->{'distintos_editores'}=1;

       #   if (!$hash->{$id1}->{'temas_anteriores'}){
       #    $hash->{$id1}->{'temas_anteriores'}="";
       #   }
       #  if (!$hash->{$id1}->{'temas_actuales'}){
       #    $hash->{$id1}->{'temas_actuales'}="";
       #     }

       #  foreach my $ref (@old_editores){
       #    my $id_editor        = C4::AR::Catalogacion::getRefFromStringConArrobas($ref);
       #    my $editor           = C4::Modelo::CatEditorial->getByPk($id_editor);
       #    $hash->{$id1}->{'editores_anteriores'}.= $editor->toString;
       #  }

       #  foreach my $ref (@new_editores){
       #    my $id_editor        = C4::AR::Catalogacion::getRefFromStringConArrobas($ref);
       #    my $editor           = C4::Modelo::CatEditorial->getByPk($id_editor);
       #    $hash->{$id1}->{'editores_actuales'}.= $editor->toString;
       #  }

       # }

   }
}

print "Registros distinto autor principal ".$distinto_autor_principal."\n";
print "Registros distinto autores secundarios ".$distintos_autores_secundarios."\n";
print "Registros con diferencias en temas ".$distintos_temas."\n";
print "Registros con diferencias en editores ".$distintos_editores."\n";
print "Registros Encontrados ".$encontrado."\n";

  print "ID ## distinto_autor_principal ## autor_anterior ## autor_actual ## ";
  print "distintos_autores_secundarios ## asec_anteriores ## asec_actuales ## ";
  print "distintos_temas ## temas_anteriores ## temas_actuales ## ";
  print "distintos_editores ## editores_anteriores ## editores_actuales ##\n";

  for $id ( keys %$hash ) {

    print $id." ## ".$hash->{$id}{'distinto_autor_principal'}." ## ".$hash->{$id}{'autor_anterior'}." ## ".$hash->{$id}{'autor_actual'}." ## ";
    print $hash->{$id}{'distintos_autores_secundarios'}." ## ".$hash->{$id}{'asec_anteriores'}." ## ".$hash->{$id}{'asec_actuales'}." ## ";
    print $hash->{$id}{'distintos_temas'}." ## ".$hash->{$id}{'temas_anteriores'}." ## ".$hash->{$id}{'temas_actuales'}." ## ";
    print $hash->{$id}{'distintos_editores'}." ## ".$hash->{$id}{'editores_anteriores'}." ## ".$hash->{$id}{'editores_actuales'}." ##\n";

  }



sub comparar {
 	my ($new, $old) = @_;

 	my $diff=0;
 	if (scalar(@$new) == scalar(@$old)){

 		foreach my $v1 (@$new){
 			my $esta=0;
	       	foreach my $v2 (@$old){
	        	if($v1 == $v2){$esta=1;}
        	}
        	
        	if(!$esta){$diff=1;}
        }

 	}else{
 		$diff=1;
 	}

 	return $diff;
}


sub editores {
  my ($id,$db) = @_;

   my @new_editores =();
   my $n2s = "SELECT * FROM  cat_registro_marc_n2 WHERE   id1 = ".$id."; ";
   my $n2_recs = $db->prepare($n2s);
   $n2_recs->execute();
   while (my $n2=$n2_recs->fetchrow_hashref) {
      my $marc_record_n2 = MARC::Record->new_from_usmarc($n2->{'marc_record'});
      my @ed=$marc_record_n2->subfield("260","b");

      foreach my $e1 (@$ed){
        my $esta=0;
          foreach my $e2 (@$new_editores){
            if($e1 == $e2){$esta=1;}
          }
          
          if(!$esta){
            push (@new_editores,$e1);
          }
        }
   }

  return \@new_editores;
}
