#!/usr/bin/perl
#Le da permisos a los usuarios segun su campo flags

use C4::Modelo::UsrSocio::Manager;
use C4::Modelo::UsrSocio;

        my @filtros;
        push (@filtros, ( activo => 1 ) );
        my  $socios_activos = C4::Modelo::UsrSocio::Manager->get_usr_socio( query => \@filtros );
    my $cant=0;
    foreach my $socio (@$socios_activos){
                if (!$socio->tieneSeteadosPermisos){
                        C4::AR::Debug::debug("USUARIO ACTIVO SIN PERMISOS!!!  ".$socio->persona->getApeYNom()." (".$socio->getNro_socio.")");
                        $socio->activar();
                        $cant++;
                }
    }

 C4::AR::Debug::debug("CANT. USUARIOS SIN PERMISOS: ".$cant);


