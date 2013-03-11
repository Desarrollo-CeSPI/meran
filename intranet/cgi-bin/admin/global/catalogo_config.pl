#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;

my $input = new CGI;

my ($template, $session, $t_params, $socio)  = get_template_and_user({
                            template_name       => "admin/global/catalogoResultConfig.tmpl",
                            query               => $input,
                            type                => "intranet",
                            authnotrequired     => 0,
                            flagsrequired       => {    ui              => 'ANY', 
                                                        tipo_documento  => 'ANY', 
                                                        accion          => 'CONSULTA', 
                                                        entorno         => 'undefined'},
                            debug               => 1,
                 });

my ($contPreferenciasCatalogo,$preferenciasCatalogo) = C4::AR::Preferencias::getPreferenciasByCategoria('catalogo');

#trae las preferencias que son renderizadas como un radio button de bootstrap
my $preferenciasBooleanas   = C4::AR::Preferencias::getPreferenciasBooleanas('catalogo');

#si estamos haciendo el post del form hay que guardar los cambios
if($input->param('editando')){

    my $msg_object = C4::AR::Mensajes::create();
    my $tmp;
    
    foreach my $preferencia (@$preferenciasCatalogo){ 
        
        $tmp = C4::AR::Preferencias::t_modificarVariable($preferencia->getVariable,$input->param($preferencia->getVariable),$preferencia->getExplanation,'catalogo');
        
    }
    
    C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'SP000', 'params' => []} ) ;

    $t_params->{'mensaje'} = C4::AR::Mensajes::getMensaje('SP000','intranet');
    $t_params->{'mensaje_class'}    = 'alert-success';
    
}

#hay que recargarlas de nuevo para mostrar los valores actualizados
($contPreferenciasCatalogo,$preferenciasCatalogo) = C4::AR::Preferencias::getPreferenciasByCategoria('catalogo');

my @arrayPreferencias;
my $campo       = "";
my $tabla       = "";

#armamos la data para pasar al template
foreach my $preferencia (@$preferenciasCatalogo){
        
    if($preferencia->getOptions ne ""){              
        if($preferencia->getType eq "referencia"){          
                my @array;
                      @array = split(/\|/,$preferencia->getOptions);
                      $tabla = $array[0];
                      $campo = $array[1];                   
           }
    }


    my $nuevoCampo;
    my @labels;
    my @values;
    my %labels;
    my %hash;
    
    $hash{'preferencia'} = $preferencia;

    if($preferencia->getType eq "bool"){
        push(@values, 1);
        push(@values, 0);
        push(@labels, C4::AR::Filtros::i18n('Si'));
        push(@labels, C4::AR::Filtros::i18n('No'));
        $nuevoCampo = C4::AR::Utilidades::crearRadioButtonBootstrap($preferencia->getVariable,\@values,\@labels,$preferencia->getValue);
    }
    
    elsif($preferencia->getType eq "texta"){
        $nuevoCampo = C4::AR::Utilidades::crearComponentes("texta",$preferencia->getVariable,58,4,$preferencia->getValue);
    }
     
    elsif($preferencia->getType eq "referencia"){
        my $orden = $campo;
        my ($cantidad,$valores) = C4::AR::Referencias::obtenerValoresTablaRef($tabla,$campo,$orden);
        foreach my $val(@$valores){
               $labels{$val->{"clave"}} = $val->{"valor"};     
               push(@values,$val->{"clave"});
        }
        $nuevoCampo = C4::AR::Utilidades::crearComponentes("combo",$preferencia->getVariable,\@values,\%labels,$preferencia->getValue);
        $hash{'tabla'} = $tabla;
        $hash{'campo'} = $campo;

    }  elsif($preferencia->getType eq "text"){
        $nuevoCampo = C4::AR::Utilidades::crearComponentes("text",$preferencia->getVariable,50,0,$preferencia->getValue);
    }

    $hash{'tipo'}  = $preferencia->getType;
    $hash{'valor'} = $nuevoCampo;
    
    push(@arrayPreferencias, \%hash);
}

$t_params->{'preferencias'}             = \@arrayPreferencias;
$t_params->{'preferenciasBooleanas'}    = $preferenciasBooleanas;
$t_params->{'page_sub_title'}           = C4::AR::Filtros::i18n("Preferencias del Cat&aacute;logo");   

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);