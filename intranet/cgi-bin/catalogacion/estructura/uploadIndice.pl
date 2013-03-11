#!/usr/bin/perl
use CGI;
use C4::Context;
use C4::AR::UploadFile;
use C4::AR::Auth;
use JSON;
use strict;
use CGI::Carp qw(fatalsToBrowser);

my $query       = new CGI;
my $id2         = $query->param('id2');
my $file_name   = $query->param('fileToUpload');
my $file_data   = $query->upload('fileToUpload');
my $name        = $file_name;
my $authnotrequired = 0;

C4::AR::Debug::debug("INDICE PARA GRUPO:                 ".$id2);
C4::AR::Debug::debug("INDICE FILENAME:                 ".$file_name);
C4::AR::Debug::debug("INDICE FILEDATA:                 ".$file_data);

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


my ($msg) = C4::AR::UploadFile::uploadIndiceFile($file_name,$name,$id2,$file_data);

print $session->header();
print $msg;

