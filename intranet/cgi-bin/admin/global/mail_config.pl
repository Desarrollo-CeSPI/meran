#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::Context;
use C4::Output;
use C4::AR::Preferencias;
use C4::AR::Mail;

my $input = new CGI;

my ($template, $session, $t_params, $socio)  = get_template_and_user({
                            template_name => "admin/global/mailConfig.tmpl",
                            query => $input,
                            type => "intranet",
                            authnotrequired => 0,
                            flagsrequired => {  ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                            debug => 1,
                 });


my $post_accion               = $input->param('post_form');
my $mensaje;

if($post_accion){
# viene desde el post del formulario
    
    my %hash_temp               = {};
    my $accion                  = $input->param('accion');
    my $smtp_server             = $input->param('smtp_server');
    my $smtp_metodo             = $input->param('smtp_metodo');
    my $port_mail               = $input->param('port_mail');
    my $username_mail           = $input->param('username_mail');
    my $password_mail           = $input->param('password_mail');
    my $mailFrom                = $input->param('mailFrom');
    my $reserveFrom             = $input->param('reserveFrom');
    my $smtp_server_sendmail    = $input->param('smtp_server_sendmail')||0; 

    my $categoria               = 'mail';
    my $Message_arrayref        = C4::AR::Preferencias::t_modificarVariable('smtp_server', $smtp_server,'',$categoria);
    $Message_arrayref           = C4::AR::Preferencias::t_modificarVariable('smtp_metodo', $smtp_metodo, '',$categoria);
    $Message_arrayref           = C4::AR::Preferencias::t_modificarVariable('port_mail', $port_mail, '',$categoria);
    $Message_arrayref           = C4::AR::Preferencias::t_modificarVariable('username_mail', $username_mail, '',$categoria);
    $Message_arrayref           = C4::AR::Preferencias::t_modificarVariable('password_mail', $password_mail, '',$categoria);
    $Message_arrayref           = C4::AR::Preferencias::t_modificarVariable('mailFrom', $mailFrom, '',$categoria);
    $Message_arrayref           = C4::AR::Preferencias::t_modificarVariable('reserveFrom', $reserveFrom, '',$categoria);
    $Message_arrayref           = C4::AR::Preferencias::t_modificarVariable('smtp_server_sendmail', $smtp_server_sendmail, '',$categoria);

    my $msg_object              = C4::AR::Mensajes::create();  
    my $user                    = C4::AR::Usuarios::getSocioInfoPorNroSocio(C4::AR::Auth::getSessionNroSocio());

    my $default_ui              = C4::AR::Preferencias::getValorPreferencia('defaultUI');
    my $ui                      = C4::Modelo::PrefUnidadInformacion->getByCode($default_ui);
    my $mail_to                 = $user->persona->getEmail; 

    if($accion eq 'PROBAR_CONFIGURACION'){
    #   solo si esta probando la configuracion mandamos el mail de prueba

        my ($ok, $msg_error)        = C4::AR::Mail::send_mail_TEST($mail_to);    

        if($ok){
            $msg_object->{'error'}  = 0;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U413', 'params' => [$mail_to]} ) ;
        } else {
            $msg_object->{'error'}  = 1;
            C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U414', 'params' => [$mail_to, $msg_error]} ) ;
        }
        
        $mensaje = $msg_object->{'messages'}[0]->{'message'};
    }

    elsif($accion eq 'MODIFICAR_CONFIGURACION'){
        $mensaje = "Se guardaron los cambios con &eacute;xito"
    }

}

my $preferencias_mail         = C4::AR::Preferencias::getPreferenciasByCategoriaHash('mail');
$t_params->{'preferencias'}   = $preferencias_mail;
$t_params->{'mensaje'}        = $mensaje;
$t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Configuraci&oacute;n del Mail");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
