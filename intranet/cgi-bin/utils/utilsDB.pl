#!/usr/bin/perl


use strict;
use CGI;
use C4::AR::Auth;

use C4::AR::Utilidades;
use C4::AR::Catalogacion;
use JSON;

my $input = new CGI;


my $obj=$input->param('obj');
$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $authnotrequired= 0;

my $tipoAccion= $obj->{'tipoAccion'}||"";


if($tipoAccion eq "GENERAR_ARREGLO_TABLA_REF"){

     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1',
                                                    tipo_permiso => 'catalogo'
                                                    
                                                }, 
                                                'intranet'
                                    );

    my ($tablaRef_array) = C4::AR::Referencias::obtenerTablasDeReferenciaAsString();
    
    my ($infoOperacionJSON) = to_json($tablaRef_array);

    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;

}

elsif($tipoAccion eq "GENERAR_ARREGLO_UI"){


     my ($user, $session, $flags)= checkauth(    $input, 
                                                $authnotrequired, 
                                                {   ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1',
                                                    tipo_permiso => 'catalogo'
                                                    
                                                }, 
                                                'intranet'
                                    );

    my ($ui_array_ref) = C4::AR::Referencias::obtenerUnidadesDeInformacion();
    my %select_ui;
    my @infoCombo;

    foreach my $ui (@$ui_array_ref) {
#         $select_ui{$ui->id_ui}= $ui->nombre;
        my %select_ui;
        $select_ui{'clave'}= $ui->id_ui;
        $select_ui{'valor'}= $ui->nombre;
        push (@infoCombo, \%select_ui);
    }

#     my ($infoOperacionJSON) = to_json(\%select_ui);
    my ($infoOperacionJSON) = to_json(\@infoCombo);
    
    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
}


