#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use C4::Output;
use CGI;
use C4::AR::Catalogacion;
use C4::Context;
my $input = new CGI;

#SE PONE CUALQUIER TEMPLATE PARA EL CHEQUEO DE PERMISOS, PERO EL TEMPLATE NO SE USA
my ($template, $session, $t_params)  = get_template_and_user({  
                        template_name   => "main.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {  ui            => 'ANY', 
                                            tipo_documento  => 'ANY', 
                                            accion          => 'CONSULTA', 
                                            entorno         => 'permisos', 
                                            tipo_permiso    => 'general'},
                        debug => 1,
                    });

# por si meten por URL un id no valido                   
eval{                

    my $file_id         = $input->param('id2');
    my $eDocsDir        = C4::Context->config('edocsdir');
    my ($nivel2,$file)  = C4::AR::Catalogacion::getIndiceFile($file_id);
    my $tmpFileName     = $eDocsDir.'/'.$file;

    open INF, $tmpFileName or die "\nCan't open $tmpFileName for reading: $!\n";

    print $input->header(       -type           => $nivel2->getIndiceFileType,
                                -attachment     => C4::AR::Filtros::i18n("Indice")." - #".$nivel2->id." - ".$nivel2->nivel1->getTitulo,
                                -expires        => '0',
                        );
    my $buffer;

    #SE ESCRIBE EL ARCHIVO EN EL CLIENTE
    while (read (INF, $buffer, 65536) and print $buffer ) {};

};

# redirigimos
if($@){

    my $session = CGI::Session->load();

    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix() . '/mainpage.pl?token=' . $session->param('token'));
  
}
