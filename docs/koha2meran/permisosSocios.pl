use CGI::Session;
use C4::Context;

#Permisos de socios!
    use C4::Modelo::UsrSocio;
    use C4::Modelo::UsrSocio::Manager;

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
