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

use C4::Modelo::IoImportacionIsoRegistro;
use MARC::Moose::Record;
use MARC::Moose::Reader::File::Isis;
use MARC::Moose::Formater::Iso2709;
my $outfile= "badrecords.iso";
my $badRecords=0;
my $records=0;
my $exit=0;
open (OUT,">", $outfile); 


my $reader = MARC::Moose::Reader::File::Isis->new(
    file   =>  $ARGV[0] || 'biblio.iso');

    while ( my $record = $reader->read() ) {
      $records++;
         my $marc_record = MARC::Record->new();
         my $registro_erroneo=0;
         for my $field ( @{$record->fields} ) {
             my $new_field=0;

             if(($field->tag < '010')&&(!$field->{'subf'})){
                 #CONTROL FIELD
                 $new_field = MARC::Field->new( $field->tag, $field->{'value'} );
                 }
                 else {
                    for my $subfield ( @{$field->subf} ) {

                        if(!$new_field){
                            my $ind1=$field->ind1?$field->ind1:'#';
                            my $ind2=$field->ind2?$field->ind2:'#';
                            my $campo = $field->tag;
                            #Si es un campo de CONTROL pero tiene SUBCAMPOS hay que moverlo a un 900 para que no se pierdan los datos.
                             if(($field->tag < '010')&&($field->{'subf'})){
                                 #Empiezo viendo a partir de los campos 900 (son solo 10 los de control!!!)
                                my $movidos =$params->{'camposMovidos'};
                                my $campos =$params->{'camposArchivo'};

                                if($movidos->{$campo}){
                                    #ya fue movido?
                                    $campo=$movidos->{$campo};
                                 }
                                 else{
                                     #hay que moverlo
                                     $campo+=900;
                                     while (($campos->{$campo}) && ($campo <= 999)){
                                         C4::AR::Debug::debug("Campo ".$campo." ==> ".$campos->{$campo});
                                         $campo++;
                                        }
                                        #C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'IO017', 'params' => [$field->tag,$campo]});
                                      #lo marco como movido y utilizado
                                     $movidos->{$field->tag}=$campo;
                                     $campos->{$campo}=1;
                                }
                             }

                            $new_field= MARC::Field->new($campo, $ind1, $ind2,$subfield->[0] => $subfield->[1]);
                            }
                        else{
                            $new_field->add_subfields( $subfield->[0] => $subfield->[1] );
                        }
                        
                       if($subfield->[1] =~ m/\x1e/g){
                          #Encuentro un delimitador en un campo de texto, algo está mal, REGISTRO ERRONEO
                          $registro_erroneo=1;
                        }
                
                    }
                }
             if($new_field){
                $marc_record->append_fields($new_field);
             }
         }
       
  print $marc_record->as_formatted();
#Se guarda!
                my %parametros;
                $parametros{'id_importacion_iso'}   = '2';
                $parametros{'marc_record'}          = $marc_record->as_usmarc();
                my $Io_registro_importacion         = C4::Modelo::IoImportacionIsoRegistro->new(db => $db);
                $Io_registro_importacion->agregar(\%parametros);

}
print "TOTAL RECORDS!!!---> ".$records."\n";

close OUT;