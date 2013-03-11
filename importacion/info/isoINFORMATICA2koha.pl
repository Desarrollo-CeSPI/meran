#!/usr/bin/perl -w

# ---------------------------------------------------------------------------
#	iso2txt.pl	<version 0.1.3>
#	(c) François Lemarchand 2002
#	francois.banholzer@free.fr
#	converts an ISO 2709 file in "human readable" file
#	requires Perl >= 5.0
# ---------------------------------------------------------------------------

# pragmas

use strict ;
require Exporter;
use diagnostics;
use ImportacionIso3;


# some special chars in ISO 2709 (ISO 6630 and ISO 646 set)

my $IS3 = '##\n' ;		# IS3 : record end
my $ISubcampo = '\x5e' ;		# IS3 : el ^record end
my $IS2 = '\x1e' ;		# IS2 : field end
my $IS1 = '\x1f' ;		# IS1 : begin subfield
my $NSB = '\x88' ;		# NSB : begin Non Sorting Block
my $NSE = '\x89' ;		# NSE : Non Sorting Block end

#Variable que recupera los datos del la tabla iso2709 para no tener que hacer n consultas!
my %tabla;
my %tablaK;
%tabla=ImportacionIso3->list; 
%tablaK=ImportacionIso3->listK; 

# check Perl version

open (L,">/tmp/fin");



require 5 ;

# local declarations

my $recordid = 0 ;
my $iso2txt_version="0.1" ;
my $awk_style = 0 ;
my $help = 0 ;
my $version = 0 ;

# Processing command line parameters

my $i=0;
foreach (@ARGV)
{
   # Looking for long arguments. Who needs GetOpt::Long ?

   if ($_ eq     "--awk-style") {     $awk_style=1; @ARGV[$i, $#ARGV]=@ARGV[$#ARGV, $i]; pop(@ARGV);}
   if ($_ eq    "--help") {    $help=1; @ARGV[$i, $#ARGV]=@ARGV[$#ARGV, $i]; pop(@ARGV);}
   if ($_ eq    "--version") {    $version=1; @ARGV[$i, $#ARGV]=@ARGV[$#ARGV, $i]; pop(@ARGV);}

   # Looking for short arguments. Better than GetOpt::Std
   # Unknown arguments are simply ignored

   if (/^-[^-]*/) 
   {
      if (/.*[aA].*/) {     $awk_style=1;} # 'a' means "awk_style"
      if (/.*[hH].*/) {    $help=1;} # 'h' means "help"
      if (/.*[vV].*/) { $version=1;} # 'v' means "version"
       @ARGV[$i, $#ARGV]=@ARGV[$#ARGV, $i];
      pop(@ARGV);
   }
   ++$i;
}

if ($help || $version) 
{
   print("\nISO2709 a Koha  $iso2txt_version\n");
   print("Einar Lanfranco 2004, mailto:koha\@info.unlp.edu.ar\n");
   print("distributed under GNU General Public License\n");
   if ($help)
   {
      print <<HELP_MESSAGE;

Este script toma una exportacion con formato ISO2709 y genera el sql para introducirlo en las tablas de Koha.

usage :
	[perl] iso2koha.pl [-h][-v] Archivo_ISO

	option	GNU style
	-h	--help		muestra la ayuda
	-v	--version	la version  


HELP_MESSAGE
   }
   exit; # no processing today.
}


# opening source(s) file(s)
undef $/;
#$/ = '';
 
foreach my $file (@ARGV) {
	open(F, $file) || die "$!";
	binmode(F);

	# processing records in source file
	foreach my $record (split($IS3,<F>)) {
	#Para cada registro hacemos esto
	my %biblio; #agregado para obtener el biblio
	my %bibitem;
	my $responsable;
	my $relacion;
	my @field = () ;
	my @data = () ;
	my $onlyitem;
	if ( length($record) > 23 ){
		$record=~ s/\n//g;
		# fetch rotulo datas
	#	$record=~ s/'/ /;
		my %rotulo = get_rotulo(substr($record, 0, 24)) ;
		#el registro deberia tener los datos del biblio,biblioitem y los items.
		my %registro;
		# process directory

		my $directory = substr($record, 24, $rotulo{base_address} - 25) ;

		#print "directorio".$directory;

		# split directory

		for(	my $i = 0 ; 
			$i < length($directory) ;
			$i = $i + 3 + $rotulo{directory_map_1} + $rotulo{directory_map_2}) {

		  	# rotulo 
             		my $field_rotulo =  substr($directory, $i, 3) ;

		 	# lentgh	
			my $field_length = int(	substr(	$directory,
										$i + 3,
										$rotulo{directory_map_1})
								)  ;

	 	 	# address
				my $field_address = int(		substr(	$directory, 
											$i + 3 + $rotulo{directory_map_1}, 
											$rotulo{directory_map_2})
								) ;
				

			# getting fields content in a field list
			#fields se usa para guardar los campos y data para guardar los datos que corresponden al campo del mismo indice en el otro archivo	
		my @miarreglo= split ($ISubcampo, substr($record, $rotulo{base_address} + $field_address, $field_length - 1));  #le saco 1 porque el ultimo es un caracter raro de separacion
	
		if (scalar(@miarreglo) == 1) {
	
			$field[$#field + 1] = substr($directory, $i, 3);
			$data[$#data +1]= $miarreglo[0];
		} else {
			my $iaux= 0;
			foreach my $pepe (@miarreglo) {
				if (($iaux==0) && (length($pepe)>0)) {
				$field[$#field + 1] = substr($directory, $i, 3); #."\n";
				$data[$#data +1]= $pepe;
				
				} else {
					if (length($pepe)>0) {
					$field[$#field + 1] = substr($directory, $i, 3)." ".substr($pepe,0,1); #."\n";
					$data[$#data +1]= substr($pepe,1,length($pepe)-1);
					}
				}
				$iaux++;
			}						
		}

		}

		# updates record id

			$recordid++;

		if( ! $awk_style) {
			#printf "\nRecord %06d\n\n", $recordid ;
		} else {
			print "\n";
		}

		#show_rotulo(%rotulo) ;

		# tipo e isbn son para controlar k20
		my $tipo;	
		my $isbn=0;
		my $autor=0;
		#Para la signatura topografica
		my @bulk=(0,0,0);
		my @bulkdata;
		my %modificacion;	
		my $tbiblio=0;
		my $tbibitem=0;
		my @items= ();
		my $nroitem=0;
		my $onlyitem=0; #Marca si es un registro que contiene solo un item
		my $ind=0;
		#EL while manda todos los campos del registro a procesar
		while ($ind < scalar(@field)){
		    #Biblio de k1 a k9 
		    #Obtener biblionumber + k50 y guardarlo en relationISO
		my $campo="";
		my $subcampo="";
		$campo= substr($field[$ind],0,3);
		if (length($field[$ind]) >= 5) {
		$subcampo= substr($field[$ind],4,1);
						}#if (length($field[$ind]) >= 5) {

#PREGUNTO POR EL K42 QUE ES EL QUE NO SE USA
	if ($tabla{$campo,$subcampo}{'k'} ne 'k42'){

#RELACION
	if ($tabla{$campo,$subcampo}{'k'} eq 'k50'){
		
		$relacion=$data[$ind];
						}
#BIBLIO
       if ($tbiblio < 7) { #chequeo por las variables de biblio hasta que junto todos los datos
	if ($tabla{$campo,$subcampo}{'k'} eq 'k01'){
		$biblio{'title'}=$data[$ind];
		$tbiblio++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k02'){
		$biblio{'unititle'}=$data[$ind];
		$tbiblio++;
						}
	if (($tabla{$campo,$subcampo}{'k'} eq 'k04') || ($tabla{$campo,$subcampo}{'k'} eq 'k05')){
		if ($tabla{$campo,$subcampo}{'orden'} eq '1'){
			if ($biblio{'author'}){	
					if ($autor==0){
						$biblio{'author'}=$data[$ind].$biblio{'author'};
						$autor=1;}
		        		else{
					if ($autor>1){
						$biblio{'additionalauthors'}=$biblio{'additionalauthors'}.chr(13).chr(10).$data[$ind]
					     }
					elsif ($biblio{'additionalauthors'})
						{$biblio{'additionalauthors'}=$biblio{'additionalauthors'}.chr(13).chr(10).$data[$ind]; $autor++;}
          					 else{$biblio{'additionalauthors'}=$data[$ind];
							$autor++;}
						}#if autor==0
						      }#if existe el autor
						    else{
						$biblio{'author'}=$data[$ind];
						$autor=1}
				} #eq <> 1
					else {
		        	if ($autor>1){
					$biblio{'additionalauthors'}=$biblio{'additionalauthors'}.$tabla{$campo,$subcampo}{'separador'}." ".$data[$ind];
					}
				elsif ($biblio{'author'}){
					$biblio{'author'}=$biblio{'author'}.$tabla{$campo,$subcampo}{'separador'}." ".$data[$ind];}
						    else{$biblio{'author'}=$tabla{$campo,$subcampo}{'separador'}." ".$data[$ind];}
				      }
		$tbiblio++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k06'){
		$biblio{'seriestitle'}=$data[$ind];
		$tbiblio++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k08'){
		$biblio{'notes'}=$data[$ind];
		$tbiblio++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k09'){
		$biblio{'abstract'}=$data[$ind];
		$tbiblio++;
						}
	}
	#Campos repetidos en biblio: subtitulos,colaboradores y Materias
	if ($tabla{$campo,$subcampo}{'k'} eq 'k03'){
		if ($biblio{'subtitle'}){$biblio{'subtitle'}=$biblio{'subtitle'}.chr(13).chr(10).$data[$ind]}
					else{$biblio{'subtitle'}=$data[$ind];
						}
						}
	#if ($tabla{$campo,$subcampo}{'k'} eq 'k05'){
	 # if ($biblio{'additionalauthors'}){$biblio{'additionalauthors'}=$biblio{'additionalauthors'}.chr(13).chr(10).$data[$ind]}
	  #else{$biblio{'additionalauthors'}=$data[$ind];}
	#					}

	if ($tabla{$campo,$subcampo}{'k'} eq 'k07'){
	if ($biblio{'subjectheadings'}){$biblio{'subjectheadings'}=$biblio{'subjectheadings'}.chr(13).chr(10).$data[$ind]}
	  else{$biblio{'subjectheadings'}=$data[$ind];}
						}
       
#BIBLIOITEM
	if ($tbibitem < 222) { #chequeo por las variables de biblioitem hasta que junto todos los datos
	if ($tabla{$campo,$subcampo}{'k'} eq 'k10'){

	if (lc(substr($data[$ind], 0, 1)) eq 'x'){ #Solo registro Hijo

	 	$onlyitem=1; #el registro es solo un item 
	  	$relacion=substr($data[$ind],1);#Le quito la X del principio
		}
		else{
		$bibitem{'subclass'}=$data[$ind];
		$tbibitem++;}
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k11'){# hay que hacer una busqueda en la tabla de referencia
		$bibitem{'itemtype'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k12'){#hay que hacer una busqueda en la tabla de referencia
		$bibitem{'support'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k13'){
		$bibitem{'number'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k14'){
		$bibitem{'place'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k15'){#hay que hacer una busqueda en la tabla de referencia
		$bibitem{'publishercode'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k16'){
		$bibitem{'publicationyear'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k17'){
		$bibitem{'pages'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k18'){
		 my @arr= split (/;/,$data[$ind]);

	if (scalar(@arr) eq 1){$bibitem{'size'}=$arr[0];}
		else{$bibitem{'illus'}=$arr[0];
		     $bibitem{'size'}=$arr[1];}

		$tbibitem++;
						}

	if ($tabla{$campo,$subcampo}{'k'} eq 'k19'){
		if ($bibitem{'seriestitle'}){$bibitem{'seriestitle'}=$bibitem{'seriestitle'}.$tabla{$campo,$subcampo}{'separador'}." ".$data[$ind];  
	print "ENTRO\n";}
		else {$bibitem{'seriestitle'}=$data[$ind];}
		$tbibitem++;
						}

	if ($tabla{$campo,$subcampo}{'k'} eq 'k20'){
#en Econo el campo k20 puede ser ISBN, ISBNSEC, o ISSN por eso hago estos chequeos
	#	if ($subcampo eq "t"){$tipo=$data[$ind];    
	#		       	      $tipo=~ tr/A-Z/a-z/ ;}
	#			    else{
	#				if ($tipo eq "isbn") { if ($isbn==1) {$bibitem{'isbnSec'}=$data[$ind];}
	#								     else{ $bibitem{$tipo}=$data[$ind];
	#									   $isbn=1;}
	#				 } else { $bibitem{$tipo}=$data[$ind];}
	if ($bibitem{'isbn'}){$bibitem{'isbn'}=$bibitem{'isbn'}.chr(13).chr(10).$data[$ind]}
	  else{$bibitem{'isbn'}=$data[$ind];}
	$tbibitem++; }
	
	if ($tabla{$campo,$subcampo}{'k'} eq 'k22'){
		$bibitem{'issn'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k23'){
		$bibitem{'lccn'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k24'){
		$bibitem{'volume'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k25'){
		$bibitem{'volumeddesc'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k26'){#otro que va a tener que buscarse en la tabla de referencia
		$bibitem{'country'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k27'){
		$bibitem{'language'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k28'){
		$bibitem{'url'}=$data[$ind];
		$tbibitem++;
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k29'){
		$bibitem{'notes'}=$data[$ind];
		$tbibitem++;
						}
	}
#ITEMS
	
	if ($tabla{$campo,$subcampo}{'k'} eq 'k30'){
	        if (exists($items[$nroitem]{'barcode'})) {#actualizar($nroitem,@items,@bulk,@bulkdata);
				  if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
				  		if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
				  		if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
       							 }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
                     							      if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." t. ".$bulkdata[2];}}
                        					  elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}
							@bulk=(0,0,0);
							  $nroitem++}
		$items[$nroitem]{'barcode'}="DIF-".$data[$ind];
						}
#	if ($tabla{$campo,$subcampo}{'k'} eq 'k31'){# hay que hacer una busqueda en la tabla de referencia
#	        if (exists($items[$nroitem]{'homebranch'})) {
#				  if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
#				  		if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
#				  		if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
 #      							 }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
 #                    							      if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." t. ".$bulkdata[2];}}
 #                       					  elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}
						
#						@bulk=(0,0,0);
#						$nroitem++}
#		$items[$nroitem]{'homebranch'}=$data[$ind];
#						}

	if ($tabla{$campo,$subcampo}{'k'} eq 'k32'){#hay que hacer una busqueda en la tabla de referenci
		if ($tabla{$campo,$subcampo}{'orden'} eq '1'){
				if ($bulk[0]==1){
						 $items[$nroitem]{'bulk'}=$bulkdata[0];
					         if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
					         if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
						$nroitem++; 
						@bulk=(1,0,0);
						$bulkdata[0]=$data[$ind];
						} else{$bulk[0]=1;
							$bulkdata[0]=$data[$ind];
							}
						             }#else si el orden es el 2do
			
		elsif ($tabla{$campo,$subcampo}{'orden'} eq '2'){
				if ($bulk[1]==1){
					         if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0]." ".$bulkdata[1];}
						 else {$items[$nroitem]{'bulk'}=$bulkdata[1];}
					         if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
						$nroitem++; 
						@bulk=(0,1,0);
						$bulkdata[1]=$data[$ind];
						} else{$bulk[1]=1;
						       $bulkdata[1]=$data[$ind];
							}
								}#si el orden es 2 	
		elsif ($tabla{$campo,$subcampo}{'orden'} eq '3'){
				if ($bulk[2]==1){
					         if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
								  if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
								 }
					         elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];}
					         if ($bulk[0]==1 or $bulk[1]==1) {$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];} else{$items[$nroitem]{'bulk'}="T. ".$bulkdata[2];}
						$nroitem++; 
						@bulk=(0,0,1);
						$bulkdata[2]=$data[$ind];
						} else{$bulk[2]=1;
							$bulkdata[2]=$data[$ind];
						}
								}#si el oreden es 3
				}	
	if ($tabla{$campo,$subcampo}{'k'} eq 'k33'){
	        if (exists($items[$nroitem]{'replacementprice'})) {
				  if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
				  		if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
				  		if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
       							 }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
                     							      if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}}
                        					  elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}
							@bulk=(0,0,0);
							$nroitem++}
		$items[$nroitem]{'replacementprice'}=$data[$ind];
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k34'){
	        if (exists($items[$nroitem]{'itemnotes'})) {
				  if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
				  		if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
				  		if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
       							 }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
                     							      if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}}
                        					  elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}
							@bulk=(0,0,0);
							$nroitem++}
		$items[$nroitem]{'itemnotes'}=$data[$ind];
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k35'){#hay que hacer una busqueda en la tabla de referencia
	        if (exists($items[$nroitem]{'Lost'})) {
				  if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
				  		if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
				  		if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
       							 }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
                     							      if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}}
                        					  elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}
							@bulk=(0,0,0);
							$nroitem++}
		$items[$nroitem]{'Lost'}=$data[$ind];
	if ($data[$ind] eq 'Lost'){$items[$nroitem]{'Lost'}=0;}
				else{$items[$nroitem]{'Lost'}=1;}
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k36'){
	        if (exists($items[$nroitem]{'withdrawn'})) {
				  if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
				  		if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
				  		if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
       							 }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
                     							      if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}}
                        					  elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}
							@bulk=(0,0,0);
							$nroitem++}
	if ($data[$ind] eq 'withdrawn'){$items[$nroitem]{'withdrawn'}=0;}
				else{$items[$nroitem]{'withdrawn'}=1;}
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k37'){
	        if (exists($items[$nroitem]{'notforloan'})) {
				  if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
				  		if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
				  		if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
       							 }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
                     							      if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}}
                        					  elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}
							@bulk=(0,0,0);
							$nroitem++;}
	if ($data[$ind] eq 'SALA'){$items[$nroitem]{'notforloan'}=1;}
				else{$items[$nroitem]{'notforloan'}=0;}
					}
#OPERACION
	if ($tabla{$campo,$subcampo}{'k'} eq 'k44'){
		$modificacion{'fechaAlta'}=$data[$ind];
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k45'){
		$modificacion{'responsableControl'}=$data[$ind];
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k46'){
		$modificacion{'fechaModificacion'}=$data[$ind];
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k47'){
		$modificacion{'fechaBaja'}=$data[$ind];
						}
	if ($tabla{$campo,$subcampo}{'k'} eq 'k48'){
		$modificacion{'operador'}=$data[$ind];
						}
 }#if no es campo k42
	else{#quiere decir que es campo k42, asi que no sirve, hay que mandarlo a algun lado
		} 



	$ind++;	
		  	 
		   #Biblioitem de k10 a k29 + biblionumber
		    #item de k30 a k34+biblioitemnumber
		    #analiticas K35 a knn +biblionumber
		
		#	print_field($field[$ind],$data[$ind]) ;
		}#while
#ACA HAY QUE LLAMAR A UN SCRIPT EN UN pm QUE LLAME A TODOS LOS AGREGAR, HAY QUE PASARLE 1 BIBLIO, 1 BIBITEM, N ITEMS, RESPONSABLE, K50 .... EL BIBLIO DEBERIA CHEQUEAR QUE NO EXISTA YA!
#ACTUALIZO LA ULTIMA SIG TOP que faltaba
if ($bulk[0]==1){$items[$nroitem]{'bulk'}=$bulkdata[0];
                 if ($bulk[1]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." ".$bulkdata[1];}
                 if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}
                }elsif ($bulk[1]==1){$items[$nroitem]{'bulk'}=$bulkdata[1];
                                     if ($bulk[2]==1){$items[$nroitem]{'bulk'}=$items[$nroitem]{'bulk'}." T. ".$bulkdata[2];}}
                                                     elsif ($bulk[2]==1){$items[$nroitem]{'bulk'}=" T. ".$bulkdata[2];}

#	printf L "BIBLIO \n";


if ($onlyitem eq 1){
#Solo 1 item hay que buscar en relationIso
my ($biblionumber,$biblioitemnumber)=buscarRelacion($relacion);
if (($biblionumber eq '') or ($biblioitemnumber eq '')) {print ('NO EXISTE EL BIBLIO : '.$relacion);
								printf L  $record."\n";}
foreach my $ai (@items)
                {
		#Agrego los items
		$ai->{'homebranch'}="DIF";
		$ai->{'holdingbranch'}="DIF";
		agregarItem("importacionEinar",$biblionumber,$biblioitemnumber,$relacion,%$ai);
		                }                
}
else {
#Agrego los biblios
my $nrobiblio= agregarBiblio("importacionEinar",$relacion,%biblio);
#Agrego los Biblioitems
my $nrobiblioitem= agregarBibItem("importacionEinar",$nrobiblio,$relacion,%bibitem);

foreach my $ai (@items)
		{
#Agrego los items
$ai->{'homebranch'}="DIF";
$ai->{'holdingbranch'}="DIF";
agregarItem("importacionEinar",$nrobiblio,$nrobiblioitem,$relacion,%$ai);

#foreach my $prueba (values(%$ai))
#{printf L $prueba."\n"}
#printf L $nroitem."\n"
		}
}
		
}

}


# closing source file

close L;
close(F);

sub get_rotulo {
	my ($guide) = @_ ;
	my %result = (

	# Record length (pos.0-4)
		record_length => int(substr($guide, 0, 5)),
	# Record status (pos.5)
		record_status => substr($guide, 5, 1),

	# POS.6-9 : Implementation code
		# Type of record (pos.6)
			document_type => substr($guide, 6, 1),
		# Bibliographic level (pos.7)
			bibliographic_level => substr($guide, 7, 1),
		# Hierarchical level code (pos.8)
			hierarchical_level => substr($guide, 8, 1),
 
		# Indicator length (pos.10)
			indicator_length => int(substr($guide, 10, 1)),
		# Subfield identifier length (pos.11, invariably 2 in UNIMARC)
			subfield_identifier_length => int(substr($guide, 11, 1)),
		# Base address of data (pos.12-16)
		 	base_address => int(substr($guide, 12, 5)),

	# POS.17-19 : Additional record definition
		# Encoding level (pos.17)
			encoding_level => substr($guide, 17, 1),
		# Descriptive cataloguing form (pos.18)
			record_update => substr($guide, 18, 1),
	
	# POS.20-23 : Directory map 
		# Length of 'Length of field' (pos.20, 4 in UNIMARC)
			directory_map_1 => int(substr($guide, 20, 1)),
		# Length of 'Starting character position' (pos.21, 5 in UNIMARC)
			directory_map_2 => int(substr($guide, 21, 1)),
		# Length of implementationdefined portion (pos.22, 0 in UNIMARC)
			directory_map_3 => int(substr($guide, 22, 1))

	# note : positions 9, 19 and 23 are undefined

		) ;
	 return(%result) ;
}



}

sub char_decode {

	# converts ISO 5426 coded string to ISO 8859-1
	# sloppy code : should be improved in next issue

	my ($string) = @_ ;
	$_ = $string ;

	if(/[\xc1-\xff]/) {
		s/\xe1/Æ/gm ;
		s/\xe2/Ð/gm ;
		s/\xe9/Ø/gm ;
		s/\xec/þ/gm ;
		s/\xf1/æ/gm ;
		s/\xf3/ð/gm ;
		s/\xf9/ø/gm ;
		s/\xfb/ß/gm ;
		s/\xc1\x61/à/gm ;
		s/\xc1\x65/è/gm ;
		s/\xc1\x69/ì/gm ;
		s/\xc1\x6f/ò/gm ;
		s/\xc1\x75/ù/gm ;
		s/\xc1\x41/À/gm ;
		s/\xc1\x45/È/gm ;
		s/\xc1\x49/Ì/gm ;
		s/\xc1\x4f/Ò/gm ;
		s/\xc1\x55/Ù/gm ;
		s/\xc2\x41/Á/gm ;
		s/\xc2\x45/É/gm ;
		s/\xc2\x49/Í/gm ;
		s/\xc2\x4f/Ó/gm ;

		s/\xc2\x65/é/gm ;
		s/\xc2\x69/í/gm ;
		s/\xc2\x6f/ó/gm ;
		s/\xc2\x75/ú/gm ;
		s/\xc2\x79/ý/gm ;
		s/\xc3\x41/Â/gm ;
		s/\xc3\x45/Ê/gm ;
		s/\xc3\x49/Î/gm ;
		s/\xc3\x4f/Ô/gm ;
		s/\xc3\x55/Û/gm ;
		s/\xc3\x61/â/gm ;
		s/\xc3\x65/ê/gm ;
		s/\xc3\x69/î/gm ;
		s/\xc3\x6f/ô/gm ;
		s/\xc3\x75/û/gm ;
		s/\xc4\x41/Ã/gm ;
		s/\xc4\x4e/Ñ/gm ;
		s/\xc4\x4f/Õ/gm ;
		s/\xc4\x61/ã/gm ;
		s/\xc4\x6e/ñ/gm ;
		s/\xc4\x6f/õ/gm ;
		s/\xc8\x45/Ë/gm ;
		s/\xc8\x49/Ï/gm ;
		s/\xc8\x65/ë/gm ;
		s/\xc8\x69/ï/gm ;
		s/\xc8\x76/ÿ/gm ;
		s/\xc9\x41/Ä/gm ;
		s/\xc9\x4f/Ö/gm ;
		s/\xc9\x55/Ü/gm ;
		s/\xc9\x61/ä/gm ;
		s/\xc9\x6f/ö/gm ;
		s/\xc9\x75/ü/gm ;
		s/\xca\x41/Å/gm ;
		s/\xca\x61/å/gm ;
		s/\xd0\x43/Ç/gm ;
		s/\xd0\x63/ç/gm ;
	}
	$string = nsb_clean($_) ;
	return($string) ;

}

sub show_rotulo {

	my %rotulo = @_ ;

	print "record length\t".$rotulo{record_length}."\n" ;
	print "record status\t".$rotulo{record_status}."\n" ;
	print "document type\t".$rotulo{document_type}."\n" ;
	print "bibliographic level\t".$rotulo{bibliographic_level}."\n" ;
	print "hierarchical level\t".$rotulo{hierarchical_level}."\n" ;
	print "indicator length\t".$rotulo{indicator_length}."\n" ;
	print "subfield identifier length\t".$rotulo{subfield_identifier_length}."\n" ;
	print "base address of data\t".$rotulo{base_address}."\n" ;
	print "encoding level\t".$rotulo{encoding_level}."\n" ;
	print "descriptive cataloguing form\t".$rotulo{record_update}."\n" ;
	print "length of \'length of field\'\t".$rotulo{directory_map_1}."\n" ;
	print "length of \'starting character position\'\t".$rotulo{directory_map_2}."\n" ;
	print "length of \'length of implementationdefined portion\'\t".$rotulo{directory_map_3}."\n" ;
}

sub nsb_clean {

	# handles non sorting blocks

	my ($string) = @_ ;

	$_ = $string ;
	s/$NSB/(/gm ;
	s/[ ]{0,1}$NSE/) /gm ;
	$string = $_ ;
	return($string) ;

}
