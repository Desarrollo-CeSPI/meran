#!/usr/bin/perl

use strict;
use C4::AR::Auth;

use JSON;
use CGI;

my $input           = new CGI;
my $authnotrequired = 0;
my $change_password = 1;

my ($template, $session, $t_params) = checkauth(    $input, 
                                                    $authnotrequired,
                                                    {   ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'usuarios'
                                                    },
                                                    "opac",
                                                    $change_password,
                            );

my %params;
$params{'nro_socio'}        = $input->param('usuario');
$params{'actual_password'}  = $input->param('actual_password');
$params{'new_password1'}    = $input->param('new_password1');
$params{'new_password2'}    = $input->param('new_password2');
$params{'key'}              = $input->param('key');
$params{'changePassword'}   = $input->param('changePassword');
$params{'token'}            = $input->param('token');

if(C4::AR::Preferencias::getValorPreferencia("permite_cambio_password_desde_opac")){

    my ($Message_arrayref)= C4::AR::Auth::cambiarPassword(\%params);
    
    
    if(C4::AR::Mensajes::hayError($Message_arrayref)){
        $session->param('codMsg', C4::AR::Mensajes::getFirstCodeError($Message_arrayref));
        #hay error vuelve al mismo
        C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/change_password.pl?token='.$input->param('token'));
    }else{
        #se cambio la password exitosamente, se destruye la sesion y se obliga al socio a ingresar nuevamente
        C4::AR::Auth::session_destroy();
        $session->param('codMsg', 'U400');
        #redirecciono a auth.pl
        C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/auth.pl');
    }
}else{
    #no se permite el cambio de passoword desde el OPAC
    my $authnotrequired = 0;
    my ($template, $session, $t_params) = checkauth(    $input, 
                                                        $authnotrequired,
                                                        {   ui => 'ANY', 
                                                            tipo_documento => 'ANY', 
                                                            accion => 'MODIFICACION', 
                                                            entorno => 'usuarios'
                                                        },
                                                        "opac",
                            );

    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/opac-user.pl?token='.$session->param('token'));
}
