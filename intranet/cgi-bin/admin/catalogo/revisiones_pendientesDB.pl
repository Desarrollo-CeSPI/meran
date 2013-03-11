#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use JSON;

my $input               = new CGI;
my $authnotrequired     = 0;
my $obj                 = $input->param('obj');
$obj                    = C4::AR::Utilidades::from_json_ISO($obj);
my $tipoAccion          = $obj->{'tipoAccion'}||"";


if($tipoAccion eq "ELIMINAR_REVISIONES"){

    my ($user, $session, $flags) = checkauth($input, 
                                            $authnotrequired, 
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'ALTA', 
                                                entorno         => 'undefined' },
                                            'intranet'
                           );
    
    my ($Messages_arrayref) = C4::AR::Nivel2::eliminarReviews($obj->{'ids_revisiones'});

    my $infoOperacionJSON   = to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
    
}elsif($tipoAccion eq "APROBAR_REVISIONES"){

    my ($user, $session, $flags) = checkauth($input, 
                                            $authnotrequired, 
                                            {   ui              => 'ANY', 
                                                tipo_documento  => 'ANY', 
                                                accion          => 'ALTA', 
                                                entorno         => 'undefined' },
                                            'intranet'
                           );
    
    my ($Messages_arrayref) = C4::AR::Nivel2::aprobarReviews($obj->{'ids_revisiones'});

    my $infoOperacionJSON   = to_json $Messages_arrayref;

    C4::AR::Auth::print_header($session);
    print $infoOperacionJSON;
    
}