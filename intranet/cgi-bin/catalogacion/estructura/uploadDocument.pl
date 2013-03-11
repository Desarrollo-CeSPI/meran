#!/usr/bin/perl
use CGI;
use C4::Context;
use C4::AR::UploadFile;
use C4::AR::Auth;
use JSON;
use strict;
use CGI::Carp qw(fatalsToBrowser);
use Digest::MD5;

C4::AR::Debug::debug("SE CREO CGI ");
my $query       = new CGI;
my $id2         = $query->param('id2');
my $id1         = $query->param('id1');
my $name        = $query->param('filename');
my $file_name   = $query->param('fileToUpload');
my $file_data   = $query->upload('fileToUpload');
my $authnotrequired = 0;

C4::AR::Debug::debug("E-DOCUMENT PARA GRUPO:                 ".$id2);
C4::AR::Debug::debug("E-DOCUMENT FILENAME:                 ".$file_data);


my ($template, $session, $t_params) = get_template_and_user({
                            template_name   => ('catalogacion/estructura/detalle.tmpl'),
                            query           => $query,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui => 'ANY', 
                                                    tipo_documento => 'ANY', 
                                                    accion => 'CONSULTA', 
                                                    entorno => 'datos_nivel1'},
                        });


my ($msg) = C4::AR::UploadFile::uploadDocument($file_name,$name,$id2,$file_data);

print $session->header();
print $msg;

#C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);

#C4::AR::Debug::debug($msg);


