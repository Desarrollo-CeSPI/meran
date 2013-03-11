#!/usr/bin/perl

use C4::Context;
use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

my $nivel2_array_ref = C4::AR::Nivel2::getAllNivel2();

foreach my $nivel2 (@$nivel2_array_ref){

    my $tipo_doc = $nivel2->getTipoDocumento();

	if(($nivel2->nivel1->getTemplate eq 'ALL')||($tipo_doc eq 'REV')||($tipo_doc eq 'ANA')||($tipo_doc eq 'ACT')){
		C4::AR::Debug::debug("============== seteando tipo_doc: ".$tipo_doc." al registro: ".$nivel2->nivel1->getId1()." ==============");
		$nivel2->nivel1->setTemplate($tipo_doc);
		$nivel2->nivel1->save();
	}
	
    C4::AR::Debug::debug("seteando tipo_doc: ".$tipo_doc." al grupo: ".$nivel2->getId2());
    $nivel2->setTemplate($tipo_doc);
    $nivel2->save();

    my $nivel3_array_ref = C4::AR::Nivel3::getNivel3FromId2($nivel2->getId2());
    
    foreach my $nivel3 (@$nivel3_array_ref){

        C4::AR::Debug::debug("seteando tipo_doc: ".$tipo_doc." al ejemplar: ".$nivel3->getId());
        $nivel3->setTemplate($tipo_doc);
        $nivel3->save();
    }
}

1;
