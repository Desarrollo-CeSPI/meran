#!/usr/bin/perl
use MARC::Record;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;


sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

my $nivel2_array_ref = C4::AR::Nivel2::getAllNivel2();

foreach my $nivel2 (@$nivel2_array_ref){

    my $nota = $nivel2->getNotaGeneral();
 #   if ($nota){C4::AR::Debug::debug("TIENE NOTA: ".$nota);}
 #   if ($nivel2->tiene_indice){C4::AR::Debug::debug("YA TIENE INDICE: ".$nivel2->getIndice);}
    
    
    if (($nota)&&(!$nivel2->tiene_indice)){
		
		  my $new_indice ='';
		  my $index = index($nota, 'Contiene:');
		  if($index != -1){
			$new_indice = substr($nota,$index+9);		  
			  }else{
				$index = index($nota, 'Contiene :');
				if($index != -1){
					$new_indice = substr($nota,$index+10);	
					}
					else{
					$index = index($nota, 'Contenido :');
					if($index != -1){
						$new_indice = substr($nota,$index+11);	
						}
						else{
							$index = index($nota, 'Contenido:');
							if($index != -1){
								$new_indice = substr($nota,$index+10);	
								}
						}
					}
			}
			
			if($new_indice){
				
				$new_indice =~ s/\s--\s/\n/g;
				$new_indice =~ s/\s--/\n/g;
				$new_indice =~ s/--\s/\n/g;
				$new_indice =~ s/--/\n/g;
				$new_indice =~ s/\s-\s/\n/g;
				$new_indice =~ s/\s–\s/\n/g;
				$new_indice =~ s/\s–/\n/g;
				$new_indice =~ s/–\s/\n/g;
				$new_indice =~ s/–/\n/g;
				
				C4::AR::Debug::debug("NUEVO INDICE:\n".trim($new_indice));
				$nivel2->setIndice(trim($new_indice));
				
				my $new_nota=trim(substr($nota,0,$index));
				my $marc_record = MARC::Record->new_from_usmarc($nivel2->getMarcRecord());
				if(trim($new_nota)){
					C4::AR::Debug::debug("NUEVA NOTA:\n".trim($new_nota));
					$marc_record->field("500")->update( 'a' => trim($new_nota));
				}else{
					$marc_record->field("500")->delete_subfield(code => 'a');
					}
				$nivel2->setMarcRecord($marc_record->as_usmarc);
				C4::AR::Debug::debug("########################################");
				C4::AR::Debug::debug($marc_record->as_formatted);
				C4::AR::Debug::debug("########################################");
			}	
		}
	

    $nivel2->save();

}

1;
