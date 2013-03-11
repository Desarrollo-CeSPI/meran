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
                                                        accion          => 'MODIFICACION', 
                                                        entorno         => 'usuarios'
                                                    },
                                                    "intranet",
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

my ($Message_arrayref)      = C4::AR::Auth::cambiarPassword(\%params);

if(C4::AR::Mensajes::hayError($Message_arrayref)){

    $params{'error'}= 1;
    $session->param('codMsg', C4::AR::Mensajes::getFirstCodeError($Message_arrayref));
    #hay error vulve al mismo
    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/usuarios/change_password.pl?error=1&token='.$input->param('token'));
    
}

C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/sessionDestroy.pl');
