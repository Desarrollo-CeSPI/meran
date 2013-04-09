#!/usr/bin/perl

use utf8;
use lib "/usr/share/meran/dev/intranet/modules/";
use C4::Output;  
use C4::AR::Auth;
use C4::Context;
use CGI::Session;
use CGI;

use Rose::DB;

use MARC::Record;
use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );

use C4::AR::Sphinx;
use C4::AR::PortadasRegistros;
use C4::Modelo::UsrSocio;
use C4::Modelo::UsrSocio::Manager;



 print "Dar Permisos a Usuarios \n";
   darPermisosSocios();


 print "Generar Indice\n";
   regenerarIndice();

 print "Volver a Bajar las Portadas\n";
   bajarPortadas();
   
 print "Reparar Templates\n";  
   repararTemplates();

sub darPermisosSocios {
    #Permisos de socios!

    my $socio_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( 
                                                    require_objects => ['persona','ui','persona.documento','categoria'],
                                                    select       => ['persona.*','usr_socio.*','usr_ref_categoria_socio.*','ui.*'],
                                        );
                                        
    print "Son ".scalar(@$socio_array_ref)." socios para darle permisos!\n";
    
    foreach my $socio (@$socio_array_ref){
        
        print $socio->persona->getApeYNom()." es ";
        
        if($socio->esAdmin()){
            #Es super Admin
            $socio->convertirEnSuperLibrarian();
            print " SUPER ADMIN!!\n";
            }
        elsif($socio->getCod_categoria eq "BB"){
            #Es Bibliotecario
            $socio->convertirEnLibrarian();
            print " BIBLIOTECARIO!!\n";
        }else{
            #El resto estudia
            $socio->convertirEnEstudiante();
            print" estudiante!!\n";
            }
        }
}


sub regenerarIndice {



	my $id1 =  '0'; #id1 del registro
	my $flag = 'R_FULL'; #id1 del registro

	 my $tt1 = time();

	C4::AR::Sphinx::generar_indice($id1,$flag);
	 
	 my $end1 = time();
	 my $tardo1=($end1 - $tt1);
	 my $min= $tardo1/60;
	 my $hour= $min/60;
    
    print "Termino de generar el indice!! \n Tardo ".$hour." horas.";
    
}

sub bajarPortadas {
    
    #Truncamos Portadas
    my $base = C4::Context->config('database');
    my $dbh = C4::Context->dbh;
    my $sql_base = "TRUNCATE TABLE cat_portada_registro;";
    my $sth0=$dbh->prepare($sql_base);
    $sth0->execute();
    
    my $tt1 = time();

    my $session =  CGI::Session->load() || CGI::Session->new();
    $session->param("type","intranet");
    $session->param('nro_socio', 'kohaadmin');
    C4::AR::PortadasRegistros::getAllImages();


	 my $end1 = time();
	 my $tardo1=($end1 - $tt1);
	 my $min= $tardo1/60;
	 my $hour= $min/60;
    
    print "Termino de bajar las portadas! \n Tardo ".$hour." horas.";
}


sub repararTemplates {
    
    use C4::Modelo::CatRegistroMarcN2;
    use C4::Modelo::CatRegistroMarcN2::Manager;

    my $nivel2_array_ref = C4::AR::Nivel2::getAllNivel2();

    foreach my $nivel2 (@$nivel2_array_ref){

        my $tipo_doc = $nivel2->getTipoDocumento();

        if(($nivel2->nivel1->getTemplate eq 'ALL')||($tipo_doc eq 'REV')||($tipo_doc eq 'ANA')||($tipo_doc eq 'ACT')||($tipo_doc eq 'MON')||($tipo_doc eq 'TES')){
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
    
}
