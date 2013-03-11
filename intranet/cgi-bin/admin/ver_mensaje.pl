#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::MensajesContacto;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name => "admin/ver_mensaje.tmpl",
									query => $input,
									type => "intranet",
									authnotrequired => 0,
									flagsrequired => {  ui => 'ANY', 
                                                        accion => 'TODOS', 
                                                        entorno => 'usuarios'},
									debug => 1,
			    });


my $obj=$input->param('obj');

$obj=C4::AR::Utilidades::from_json_ISO($obj);

my ($id_mensaje) = $obj->{'id'};
my ($mensaje) = C4::AR::MensajesContacto::ver($id_mensaje);

$t_params->{'mensaje'} = $mensaje;
$t_params->{'page_sub_title'}=C4::AR::Filtros::i18n("Mensajes - Ver mensaje");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);