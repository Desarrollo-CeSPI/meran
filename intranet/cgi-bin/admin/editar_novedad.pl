#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::Novedades;
use C4::AR::Utilidades;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
									template_name => "admin/agregar_novedad.tmpl",
									query => $input,
									type => "intranet",
									authnotrequired => 0,
									flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'usuarios'},
									debug => 1,
			    });

my $action = $input->param('action') || 0;

my $id = $input->param('id') || 0;

if ($action eq 'editar'){

    #------------ data de los inputs-------------
    $t_params->{'titulo'}       = $input->param('titulo');
    $t_params->{'categoria'}    = $input->param('categoria');
    $t_params->{'contenido'}    = $input->param('contenido');
    $t_params->{'twiter'}       = $input->param('check_publicar');
    $t_params->{'nombreAdjunto'}= $input->param('nombreAdjunto');
    $t_params->{'links'}        = $input->param('links');
    #--------- FIN data de los inputs -----------

    #--------- imagenes nuevas -----------
    my @arrayFiles;
    
    #copio la referencia de la hash
    my $hash        = $input->{'param'};

    my $imagenes    = $hash->{'imagenes'};

    foreach my $file ( @$imagenes ){

        if($file){
            push(@arrayFiles, $file);
        }

    }
    #-------- FIN imagenes nuevas ----------
    
    
    
    #------------------- imagenes a borrar --------------------
    my @arrayDeleteImages;
    
    #si marcaron alguna imagen para eliminarla
    if($input->param('cantidad')){
    
        for( my $i=0; $i<$input->param('cantidad'); $i++){
        
            push(@arrayDeleteImages, $input->param('imagen_' . $i));
            
        }    
    }
    
    #---------------- fin imagenes a borrar -----------------
    
    
    #--------- links -----------
    my $linksTodos  = C4::AR::Utilidades::trim($input->param('links'));  
    my @links       = split('\ ', $linksTodos);   
    my $linksFinal  = "";
    
    foreach my $link (@links){
    
        if($link !~ /^http/){
            $linksFinal .= " http://" . $link;
        }else{
            $linksFinal .= " " . $link;
        }
    }
    
    $input->param('links', $linksFinal);
    #------- FIN links ---------
    
    my ($Message_arrayref) = C4::AR::Novedades::editar($input, \@arrayFiles, \@arrayDeleteImages);
    
    if($Message_arrayref->{'error'} == 0){

        C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/admin/novedades_opac.pl?token='.$input->param('token'));
    }else{
        $t_params->{'mensaje'} = $Message_arrayref->{'messages'}[0]->{'message'};
    }
    
}else{

    my ($imagenes_novedad,$cant)    = C4::AR::Novedades::getImagenesNovedad($id);
    
    $t_params->{'imagenes_hash'}    = $imagenes_novedad;
    
    $t_params->{'novedad'}          = C4::AR::Novedades::getNovedad($id);
    
    $t_params->{'cant_novedades'}   = $cant;
    
    $t_params->{'editing'}          = 1;
}

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
