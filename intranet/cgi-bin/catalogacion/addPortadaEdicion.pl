#!/usr/bin/perl

use CGI;
use C4::Context;
use C4::AR::PortadaNivel2;
use C4::AR::Auth;
use JSON;
use strict;
use CGI::Carp qw(fatalsToBrowser);

my $query = new CGI;

#--------- portadas nuevas -----------
my @arrayFiles;

my $id2         = $query->param('id2');
my $id1         = $query->param('id1');
my $token       = $query->param('token');

#copio la referencia de la hash
my $hash        = $query->{'param'};

my $imagenes    = $hash->{'imagenes'};

foreach my $file ( @$imagenes ){

    if($file){
        push(@arrayFiles, $file);
    }
    
}
#-------- FIN portadas nuevas ----------


#------------------- portadas a borrar --------------------
my @arrayDeleteImages;

#si marcaron alguna imagen para eliminarla
if($query->param('cantidad')){

    for( my $i=0; $i<$query->param('cantidad'); $i++){
    
        push(@arrayDeleteImages, $query->param('imagen_' . $i));
        
    }    
}

#---------------- fin portadas a borrar -----------------

my %paramHash;

$paramHash{'id2'}               = $id2;
$paramHash{'arrayFiles'}        = \@arrayFiles;
$paramHash{'arrayFilesDelete'}  = \@arrayDeleteImages;

my $authnotrequired = 0;

my ($template, $session, $t_params) = get_template_and_user({
                            template_name   => ('catalogacion/estructura/detalle.tmpl'),
                            query           => $query,
                            type            => "intranet",
                            authnotrequired => 0,
                            flagsrequired   => {    ui              => 'ANY', 
                                                    tipo_documento  => 'ANY', 
                                                    accion          => 'CONSULTA', 
                                                    entorno         => 'datos_nivel1'},
                        });

my ($msg_object)    = C4::AR::PortadaNivel2::agregar(\%paramHash);

my $code            = C4::AR::Mensajes::getFirstCodeError($msg_object);

my $mensaje         = C4::AR::Mensajes::getMensaje($code, 'intranet');

my $url             = C4::AR::Utilidades::getUrlPrefix()."/catalogacion/estructura/detalle.pl";

$url                = C4::AR::Utilidades::addParamToUrl($url,'id1',$id1);
$url                = C4::AR::Utilidades::addParamToUrl($url,'&token',$query->param('token'));
$url                = C4::AR::Utilidades::addParamToUrl($url,'msg_file',$mensaje);

C4::AR::Auth::redirectTo($url);