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
sub trim($)
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

open(DATOS,'ecadlist.txt');
my %datos;
my $campo;
while(<DATOS>){
    chomp; 
    if ($_ =~ m/Indicators/ ){
        my $line=$_;
        while((!($line =~ m/Subfield Codes/))&&($line)){
            $line=<DATOS>;
            chomp($line);
            #print "Indicators.$line";
            if ($line =~ m/First/){
                $datos{$campo}->{"FIRST"}->{'descripcion'}= trim((split('-',$line))[1]) ;
                #print  $datos{$campo}->{"FIRST"};
                $line=<DATOS>;
                chomp($line);
                while ((!($line =~ m/Second/))&&($line)){
          my @dato=split('-',$line);
          $datos{$campo}->{"FIRST"}->{'elementos'}->{trim($dato[0])}=trim($dato[1]);
          $line=<DATOS>;
          chomp($line);
      } 
      $datos{$campo}->{"SECOND"}->{'descripcion'}=trim((split('-',$line))[1]);
      $line=<DATOS>;
      chomp($line);

      while((!($line =~ m/Subfield Codes/))&&($line)){
          my @dato=split('-',$line);
          $datos{$campo}->{"SECOND"}->{'elementos'}->{trim($dato[0])}=trim($dato[1]);
          $line=<DATOS>;
          chomp($line);
          #print $campo;
      }
      while((!($line eq "\n"))&&($line)){
          $line=<DATOS>;
          chomp($line);


      }
      }	

  }

  }
  else{ if (substr($_,0,1) =~ m/[0-9]/ ){
          $campo= substr($_,0,3);
          }
  }
}
while ( my ($key, $value) = each(%datos) ) {
    print "UPDATE pref_estructura_campo_marc set indicadorPrimario=".'"'.$value->{"FIRST"}->{'descripcion'}.'"'.", IndicadorSecundario=".'"'.$value->{"SECOND"}->{'descripcion'}.'"'." where campo=".$key.";\n";
    
    # print "campo".$key."\n";
    #print "descripcion del first".($value->{"FIRST"}->{'descripcion'})."\n";

    my $first=$value->{"FIRST"}->{'elementos'};
    while ( my ($keyF, $valueF) = each(%$first) ){
        print "INSERT into pref_indicadores_primarios (indicador,dato, campo_marc) values (".'"'.$keyF.'"'.",".'"'.$valueF.'"'.",".$key.");\n"}
    #print "descripcion del second".$value->{"SECOND"}->{'descripcion'}."\n";
    my $second=$value->{"SECOND"}->{'elementos'};
    while ( my ($keyS, $valueS) = each(%$second) ) {
    #print "Indicador ".$keyS." es igual a ".$valueS."\n";}
        print "INSERT into pref_indicadores_secundarios (indicador,dato, campo_marc) values  (".'"'.$keyS.'"'.",".'"'.$valueS.'"'.",".$key.");\n"}

}