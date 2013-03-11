#!/usr/bin/perl
#Le da permisos a los usuarios segun su campo flags

use C4::Modelo::UsrSocio::Manager;
use C4::Modelo::UsrSocio;
my  $socios = C4::Modelo::UsrSocio::Manager->get_usr_socio();
    foreach my $socio (@$socios){
      my $flag = $socio->getFlags;
      if ($flag){
	#Si tiene flags seteados NO es un estudiante
	  if($flag % 2){
	    #Da 1 entonces era IMPAR => tenia el 1er bit en 1 => es SUPERLIBRARIAN
	    $socio->setCredentials('superLibrarian');
	  }else{
	    #Da 0 entonces era PAR => tenia el 1er bit en 0 => NO es SUPERLIBRARIAN
        $socio->setCredentials('librarian');
	  }
      }else{
	#Si NO tiene flags seteados es un estudiante
        $socio->setCredentials('estudiante');
      }
    }



