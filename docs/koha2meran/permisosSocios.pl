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