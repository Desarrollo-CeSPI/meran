#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use JSON;

my $input               = new CGI;
my $authnotrequired     = 0;
my $obj                 = $input->param('obj');
$obj                    = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion          = $obj->{'tipoAccion'}||"";

if($tipoAccion eq "ENVIAR_TODOS_MAILS_PRESTAMOS_VENCIDOS"){

    my ($user, $session, $flags) = checkauth($input, 
                                            $authnotrequired, 
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'ALTA', 
                                                entorno         => 'undefined' },
                                            'intranet'
                           );
                           
    # seteamos en 1 el flag para el CRON                           
    C4::AR::Preferencias::setVariable('enableMailPrestVencidos', 1);
    
    my $msg_object            = C4::AR::Mensajes::create();
    
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'PV00'});

    my ($Messages_arrayref)   = $msg_object;

    my $infoOperacionJSON     = to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
    
}

elsif($tipoAccion eq "ENVIAR_A_SELECCION_MAILS_PRESTAMOS_VENCIDOS"){

    my ($user, $session, $flags) = checkauth($input, 
                                            $authnotrequired, 
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'ALTA', 
                                                entorno         => 'undefined' },
                                            'intranet'
                           );
                           
    # seteamos en 1 el flag para el CRON                           
    C4::AR::Preferencias::setVariable('enableMailPrestVencidos', 1);
    
    my ($Messages_arrayref) = C4::AR::Prestamos::setPrestamosVencidosTemp($obj->{'ids_prestamos'});

    my $infoOperacionJSON   = to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
    
}
