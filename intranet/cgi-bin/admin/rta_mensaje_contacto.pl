#!/usr/bin/perl
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

use strict;
require Exporter;
use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use JSON;
use C4::Context;
use C4::AR::Mail;
use C4::AR::MensajesContacto;
use CGI;

my $input               = new CGI;
my $obj                 = $input->param('obj')||"";
$obj                    = C4::AR::Utilidades::from_json_ISO($obj);
my $asunto              = $obj->{'asunto'} || "Respuesta a mail de contacto (sin asunto)";
my $email               = $obj->{'email'};
my $texto               = $obj->{'texto'};
my $mensaje_contacto    = $obj->{'mensaje_contacto'};
my $id_mensaje_contacto = $obj->{'dm_id'};
my $authnotrequired     = 0;

my ($user, $session, $flags) = checkauth($input, 
                                        $authnotrequired, 
                                        {   ui              => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'ALTA', 
                                            entorno         => 'undefined' },
                                        'intranet'
                       );

my %mail;

## Datos para el mail
$mail{'mail_from'}      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('mailFrom'));
$mail{'mail_to'}        = $email;
$mail{'mail_subject'}   = 'Re: '. $asunto;
$mail{'page_title'}   = 'Respuesta de Contacto';

use C4::Modelo::PrefUnidadInformacion;

my $ui                  = C4::AR::Referencias::obtenerDefaultUI();
my $nombre_ui           = $ui->getNombre();

my $mailMessage         = C4::AR::Filtros::i18n("Estimado/a: ")."<br/><br/>".$texto."<br/><br/><br/><hr>"
                                        .C4::AR::Filtros::i18n("Este mensaje es enviado en respuesta al mensaje que aparece a continuacion:").
                                        "<br /><br /> $mensaje_contacto<br /><br />";
                                        
       
$mail{'mail_message'}   = $mailMessage;

my ($ok, $msg_error)    = C4::AR::Mail::send_mail(\%mail);
  
my  $msg = C4::AR::Mensajes::create();
if ($msg_error){
    C4::AR::Mensajes::add($msg, {'codMsg'=> 'U427', 'params' => []} ) ;
}else{
	C4::AR::MensajesContacto::marcarRespondido($id_mensaje_contacto);
    C4::AR::Mensajes::add($msg, {'codMsg'=> 'U426', 'params' => []} ) ;
}

my $infoOperacionJSON   = to_json $msg;

C4::AR::Auth::print_header($session);
print $infoOperacionJSON;