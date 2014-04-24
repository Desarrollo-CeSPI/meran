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

use CGI::Session;
use C4::Context;
use  C4::AR::ImportacionIsoMARC;

my $id = $ARGV[0] || 1;
my $found=0;
my $notfound=0;
my $multi=0;
my $fixed=0;
my $nada=0;
my $importacion = C4::AR::ImportacionIsoMARC::getImportacionById($id);
my $cant=0;
foreach my $registro ($importacion->registros){
    print $cant." =  ";
    my $marc 	= $registro->getRegistroMARCOriginal();
    my $pais 	= $marc->subfield('040','Z'); 
    my $idioma 	= $marc->subfield('064','Z');
    my $titulo 	= $registro->getTitulo();
    my $autor 	= $registro->getAutor();

	if ($titulo && $autor){
		my ($resultados) = buscar_registro($titulo->[0],$autor->[0]);
	  
	                    if(scalar(@$resultados) == 0 ){
	                        $notfound++;   
	                        print " notfound ";
	                    }elsif(scalar(@$resultados) == 1){
	                    	$found++;

	                    	my $n1 = $resultados->[0]->nivel1;
	                    	my $grupos = $n1->getGrupos();

							#de los grupos saco su marc record con los ejemplares
							    foreach my $nivel2 (@$grupos){
							        my $marc_record_n2  =$nivel2->getMarcRecordObject();

							       # Idioma ref_idioma@ print $marc_record_n2->subfield("041","a");
							       #print $marc_record_n2->subfield("041","a") ." === ".$idioma." ===> ".getIdioma($idioma)." \n";
							       

							       my $new_idioma = getIdioma($idioma);
							       if ($new_idioma){
							       	if($marc_record_n2->field("041")){
							       		$marc_record_n2->field("041")->update("a" => "ref_idioma@".$new_idioma );
							       	}else{
							       		my $new_field = MARC::Field->new('041','','',"a" => "ref_idioma@".$new_idioma);
                						$marc_record_n2->append_fields($new_field);
							       	}
							       }

							       # Pais ref_pais@  print $marc_record_n2->subfield("043","c");
							       #print $marc_record_n2->subfield("043","c") ." === ".$pais." ===> ".getPais($pais)." \n";


							       my $new_pais = getPais($pais);
							       if ($new_pais){
							      	if($marc_record_n2->field("043")){
							       		$marc_record_n2->field("043")->update("c" => "ref_pais@".$new_pais );
							       	}else{
							       		my $new_field = MARC::Field->new('043','','',"c" => "ref_pais@".$new_pais);
                						$marc_record_n2->append_fields($new_field);
							       	}
							       }
						            $nivel2 ->setMarcRecord($marc_record_n2->as_usmarc);
						            #print $marc_record_n2->as_formatted; 
						            $nivel2->save();
							       }

	                    	print " found ";
	                    }else{
	                    	$multi++;
	                    	print " multi ";
	                    }

    }
    else{
    	$nada++;
    }
    $cant++;
    print " \n";
}
print "ENCONTRADO UNICO: ".$found."\n";
print "NO ENCONTRADOS: ".$notfound."\n";
print "MULTIPLES: ".$multi."\n";
print "ARREGLADOS : ".$fixed."\n";
print "NADA : ".$nada."\n";



sub buscar_registro {
    my ($titulo,$autor) = @_;

    my $db = C4::Modelo::IndiceBusqueda->new()->db();

    my @filtros;
    if ($titulo){
    	push (@filtros, ( titulo => { eq => $titulo } ));
    }
    if ($autor){
    	push (@filtros, ( autor =>  { like => '%'.$autor.'%'} ));
	}

    my $indice_array_ref = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda (
                                                                        db => $db,
																		query => \@filtros,
                                                                );


    return $indice_array_ref;

}


sub getPais{
    my ($pais) = @_;
    
    use C4::Modelo::RefPais;

    # Si hay un () es porque viene nombre (codigo), busco con código, luego con nombre

    my $codigo =undef;
    my $nombre =undef;

    if ( index($pais,'(') != -1 ){
     ($codigo) =  $pais =~ /\((.*)\)/; 
     $nombre =  substr($pais, 0, index($pais,'(')); 
    }
    else{
        $nombre = $pais;
    }

    my @textos =();
    push (@textos, $nombre);
    if ($codigo){ push (@textos, $codigo);}

    foreach my $texto (@textos){
        $texto = C4::AR::Utilidades::trim($texto);
        #Casos raros
        use Switch;
        switch (uc($texto)) {
            case 'XXK' { 
                $texto = "GBR";
                }
            case 'ENK' { 
                $texto = "GBR";
                }
            case 'REINO UNIDO' { 
                $texto = "GBR";
                }
            case 'XXU' { 
                $texto = "USA";
                }
            case 'NE' { 
                $texto = "NLD";
                }
            case 'AG' { 
                $texto = "ARG";
                }
            case 'BL' { 
                $texto = "BRA";
                }
            case 'JA' { 
                $texto = "JPN";
                }
            case 'GW' { 
                $texto = "DEU";
                }
        }

        if (length($texto) le 3 ){
            # no es un código
            my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByIso($texto);
       
            if($cantidad){
                 return  $objetos->[0]->getIso();
            }
        }

            #NO lo encontre por iso voy a buscar por nombre exacto
            my ($cantidad, $objetos) = (C4::Modelo::RefPais->new())->getPaisByName($texto);
            if($cantidad){
                return $objetos->[0]->getIso();
            }
    }
}



sub getIdioma{
    my ($idioma) = @_;
    
    use C4::Modelo::RefIdioma;

    # Si hay un () es porque viene nombre (codigo), busco con código, luego con nombre

    my $codigo =undef;
    my $nombre =undef;

    if ( index($idioma,'(') != -1 ){
     ($codigo) =  $idioma =~ /\((.*)\)/; 
     $nombre =  substr($idioma, 0, index($idioma,'(')); 
    }
    else{
        $nombre = $idioma;
    }

    my @textos =();
    if ($codigo){ push (@textos, $codigo);}
    push (@textos, $nombre);


    foreach my $texto (@textos){
        $texto = C4::AR::Utilidades::trim($texto);
        #Casos raros
            use Switch;
            switch (uc($idioma)) {
                case 'CASTELLANO' { 
                    $idioma = "es";
                    }
                case 'INGLES' { 
                    $idioma = "en";
                    }
                case 'FRANCES' { 
                    $idioma = "fr";
                    }
                case 'GALLEGO' { 
                    $idioma = "gl";
                    }
            }
        if (length($texto) le 3 ){
            my ($cantidad, $objetos) = (C4::Modelo::RefIdioma->new())->getIdiomaById($texto);
            if($cantidad){
                 return  $objetos->[0]->getIdLanguage();
            }
        }
        #NO lo encontre por iso voy a buscar por nombre exacto
        my ($cantidad, $objetos) = (C4::Modelo::RefIdioma->new())->getIdiomaByName($texto);
        if($cantidad){
            return $objetos->[0]->getIdLanguage();
        }
    }
}

1;
