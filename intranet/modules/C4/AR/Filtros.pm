package C4::AR::Filtros;

use strict;
require Exporter;
#use POSIX;
use Locale::Maketext::Gettext::Functions qw(__);
use Template::Plugin::Filter;
use CGI::Session;
use HTML::Entities;
use base qw( Template::Plugin::Filter );

use vars qw(@EXPORT_OK @ISA);
@ISA        = qw(Exporter);
@EXPORT_OK  = qw( 
    setHelpIco
    i18n
    link_to
    to_Button
    action_link_button
    action_button
    setHelpInput
    action_set_button
    crearCheckButtonsBootstrap
    tabbedPane
);

=item
    Crea un grupo de checkbox para estilos bootstrap
    Utilizado para permisos.pl
=cut
sub crearCheckButtonsBootstrap {

    my $params  = shift;

    # el tipo lo usamos como id en el div generado
    my $tipo    = shift;

    my $text    = '<div class="btn-group" id="' . $tipo . '"data-toggle="buttons-checkbox">';


    if ($params->{'TODOS'}) { 
        $text .= '<button class="btn btn-danger active">'.i18n("Todos").' </button>';
    } else {
        $text .= '<button class="btn btn-danger">'.i18n("Todos").' </button>';
    }

    if ($params->{'BAJA'}) { 
        $text .= '<button class="btn btn-danger active">'.i18n("Baja").' </button>';
    } else {
        $text .= '<button class="btn btn-danger">'.i18n("Baja").' </button>';
    }

    if ($params->{'MODIFICACION'}) { 
        $text .= '<button class="btn btn-danger active">'.i18n("Modificaci&oacute;n").' </button>';
    } else {
        $text .= '<button class="btn btn-danger">'.i18n("Modificaci&oacute;n").' </button>';
    }

    if ($params->{'ALTA'}) { 
        $text .= '<button class="btn btn-warning active">'.i18n("Alta").' </button>';
    } else {
        $text .= '<button class="btn btn-warning">'.i18n("Alta").' </button>';
    }

    if ($params->{'CONSULTA'}) { 
        $text .= '<button class="btn btn-success active">'.i18n("Consulta").' </button>';
    } else {
        $text .= '<button class="btn btn-success">'.i18n("Consulta").' </button>';
    }

    $text .= '</div>';

    return $text;   

}

sub showPermisosActuales {

    my $params  = shift;

    # el tipo lo usamos como id en el div generado
    my $tipo    = shift;

    my $text    = '<div class="btn-group" id="' . $tipo . '_actual" >';


    if ($params->{'TODOS'}) { 
        $text .= '<button class="btn btn-danger active ">'.i18n("Todos").' </button>';
    } else {

        if ($params->{'BAJA'}) { 
            $text .= '<button class="btn btn-danger active ">'.i18n("Baja").' </button>';
        }  
        if ($params->{'MODIFICACION'}) { 
            $text .= '<button class="btn btn-danger active ">'.i18n("Modificaci&oacute;n").' </button>';
        } 
        if ($params->{'ALTA'}) { 
            $text .= '<button class="btn btn-warning active ">'.i18n("Alta").' </button>';
        }
        if ($params->{'CONSULTA'}) { 
            $text .= '<button class="btn btn-success active ">'.i18n("Consulta").' </button>';
        }

        if (!($params->{'TODOS'} || $params->{'BAJA'} || $params->{'MODIFICACION'} || $params->{'ALTA'} || $params->{'CONSULTA'} )) {
           $text .= '<button class="btn btn-info active ">'.i18n("Sin Permisos").' </button>'; 
        }

    }
    $text .= '</div>';

    return $text;   

}

=item
    Esta funcion despliega un texto sobre un icono, una especia de ayuda.
=cut
sub setHelpIcon{
    my (%params_hash_ref) = @_;

    my $help    = '';
    $help       =  "<div class='hover_ico' title='".i18n($params_hash_ref{'text'})."'></div>";

    return $help;
}


=item
Esta funcion genera un link de la forma <a href="url?parametros" title="title">texto</a>, concatenando a los parametros
el parametro "token" utilizado 
@params
$params_hash_ref{'params'}, arreglo con los parametros enviados por get a la url
$params_hash_ref{'text'}, texto a mostrar en el link
$params_hash_ref{'url'}, url 
$params_hash_ref{'title'}, titulo a mostrar cuando se pone el puntero sobre el link

El objetivo principal de la funcion es la de evitar CSRF (Cross Site Request Forgery), esto es llevado a cabo con la inclusion del token
en cada link.
=cut
sub link_to {
    my (%params_hash_ref) = @_;

    my $link            = '';
    my $params          = $params_hash_ref{'params'} || []; #obtengo los paraametros
    my $text            = $params_hash_ref{'text'}; #obtengo el texto a mostrar
    my $url             = C4::AR::Utilidades::trim($params_hash_ref{'url'}); #obtengo la url
    my $title           = $params_hash_ref{'title'}; #obtengo el title a mostrar
    my $class           = $params_hash_ref{'class'}; #obtengo la clase
    my $boton           = $params_hash_ref{'boton'}; #obtengo el title a mostrar
    my $width           = $params_hash_ref{'width'};
    my $blank           = $params_hash_ref{'blank'} || 0;
    my $icon            = $params_hash_ref{'icon'} || 0;
    my $tooltip         = $params_hash_ref{'tooltip'};
    my $url_absolute    = $params_hash_ref{'url_absolute'}||0;
    my $without_token   = $params_hash_ref{'without_token'}||0;
    my $ancla           = $params_hash_ref{'ancla'}||0;
    my $onClick         = $params_hash_ref{'on_click'}||0;
    
    
    my $cant    = scalar(@$params);
    my @result;
    
    foreach my $p (@$params){
        @result = split(/=/,$p);

        $url = C4::AR::Utilidades::addParamToUrl($url,@result[0],@result[1]);
    }

    my $session = CGI::Session->load() || CGI::Session->new();

    eval{
        if(($session->param('token'))&&(!$without_token)){        
        #si hay sesion se usa el token, sino no tiene sentido
            my $status = index($url,'?');
             #SI NO HUBO PARAMETROS, EL TOKEN ES EL UNICO EN LA URL, O SEA QUE SE PONE ? EN VEZ DE &
            if (($cant > 0)||($status != -1)){
                $url .= '&amp;token='.$session->param('token'); #se agrega el token
            }else{
                $url .= '?token='.$session->param('token'); 
            }
        }
    };

     # or do{
    if ($@){
        C4::AR::Debug::error("Se rompio Filtros.pm en :133 con: ".$@);
    };

    if ($ancla){
        $url .= "#".$ancla;
    }

    if($url_absolute){
        #verifico si la URL contiene http, sino lo agrego
        # ($url =~ m/http/)?$link= "<a href='".$url."'":$link= "<a href='http://".$url."'";        
        if($url =~ m/http/){
            $link= "<a href='".$url."'";
        } else {
            $link= "<a href='http://".$url."'";     
        }
        
    } else {
        $link= "<a href='".$url."'";
    }

    # C4::AR::Debug::debug("FILTROS URL => ".$link);

    if ($tooltip ne ''){
        $link .= " data-original-title='$tooltip'";
        $class.= ' tooltip_link';
    }

    if (C4::AR::Utilidades::validateString($class)){
         $link .= " class='$class'";
    }

    if (C4::AR::Utilidades::validateString($onClick)){
         $link .= " onclick='$onClick'";
    }

    if($title ne ''){
        $link .= " title='".$title."'";
    }

    if($blank){
        $link .= " target='_blank'";
    }
    
    $link .= " >";


    if ($icon){
        $link .= "<i class='$icon'></i>";    	
    }
    $link .= $text."</a>"; 

    return $link;
}

=item
Esta funcion es utilizada para la Internacionalizacion, lo que hace es tomar el parametro "text" del template
y hacer la traduccion del mismo, obteniedola del binario correspondiente, por ej. en_EN/LC_MESSAGES/intranet.mo
=cut
sub i18n {
    my ($text)      = @_;
    # La inicializacion se paso toda a auth => checkauth

    # Esto es por acentos, decode y encode
    my $text = C4::AR::Utilidades::trim($text);

    if (C4::AR::Utilidades::validateString($text)){
        return __(Encode::decode_utf8(Encode::encode_utf8($text)));
    }else{
        return ("");
    }
}



sub to_Button__{
    my (%params_hash_ref) = @_;

    my $button= '';

    if ($params_hash_ref{'url'}){
      $button .="<a href="."$params_hash_ref{'url'}"."> ";
    }

    my $text    = $params_hash_ref{'text'}; #obtengo el texto a mostrar
    my $boton   = $params_hash_ref{'boton'}; #obtengo el boton
    my $onclick = $params_hash_ref{'onclick'} || $params_hash_ref{'onClick'}; #obtengo el llamado a la funcion en el evento onclick
    my $title   = $params_hash_ref{'title'}; #obtengo el title de la componete
    my $width   = length($text);
    my $id      = $params_hash_ref{'id'}; #obtengo el id del boton
    if($params_hash_ref{'width'}){
        if ($params_hash_ref{'width'}=="auto"){
            $width =$width+4;
            $width= $width."ex";
        }
        else{ $width= $params_hash_ref{'width'};
        }
    }
    
    my $alternClass  = $params_hash_ref{'alternClass'} || 'horizontal';
    $button .=  '<li class="click boton_medio '.$alternClass.' " onclick="'.$onclick.'" style="width:'.$width.'"';

    if($title){
        $button .= ' title="'.$title.'"';
    }

    if(C4::AR::Utilidads::validateString($id)){
        $button .= ' id="'.$id.'"';
    }
    
    $button .=  '> ';
    $button .=  '    <div class="'.$boton.'"> ';
    $button .=  '   </div> ';
    $button .=  '   <div class="boton_der"> ';
    $button .=  '   </div> ';
    $button .=  '   <div class="boton_texto">'.$text.'</div> ';
    $button .=  '</li> ';

    if ($params_hash_ref{'url'}){
      $button .="</a>";
    }

    #C4::AR::Debug::debug("Filtros => to_Button => ".$button);
    return $button;
}


sub to_Button{
    my (%params_hash_ref) = @_;

    my $button= '';


    my @array_clases_buttons = ('btn btn-large btn-primary', 'btn btn-large', 'btn btn-primary','btn');  

    if ($params_hash_ref{'url'}){
      $button .="<a href="."$params_hash_ref{'url'}"."> ";
    }

    my $text    = $params_hash_ref{'text'}; #obtengo el texto a mostrar
    
    my $boton   = $params_hash_ref{'boton'} || "btn btn-primary"; #obtengo el boton
    
    if (!C4::AR::Utilidades::existeInArray($boton,@array_clases_buttons)){
        $boton = "btn btn-primary";
    }
    
    my $onclick     = $params_hash_ref{'onclick'} || $params_hash_ref{'onClick'}; #obtengo el llamado a la funcion en el evento onclick
    my $title       = $params_hash_ref{'title'}; #obtengo el title de la componete
    my $type        = $params_hash_ref{'type'} || 0; #obtengo el title de la componete
    my $show_inline = $params_hash_ref{'inline'} || 0; #obtengo el title de la componete
    my $width       = length($text);
    my $id          = $params_hash_ref{'id'}; #obtengo el id del boton
    if($params_hash_ref{'width'}){
        if ($params_hash_ref{'width'}=="auto"){
            $width =$width+4;
            $width= $width."ex";
        }
        else{ $width= $params_hash_ref{'width'};
        }
    }
    
    my $alternClass  = $params_hash_ref{'alternClass'} || 'horizontal';

    if($title){
    }

    if ($type){
        $type = "type= ".$type;
    }
    
    if (!$show_inline){
        $button .=  '<p style="text-align: center; margin: 0;">';
    }

    $button .=  '<button id="'.$id.'" class="'.$boton.' '.$alternClass.'" onclick="'.$onclick.'" '.$type.'>'.$text.'</button>';
    
    if (!$show_inline){
        $button .=  '</p>';
    }

    if ($params_hash_ref{'url'}){
      $button .="</a>";
    }

    #C4::AR::Debug::debug("Filtros => to_Button => ".$button);
    return $button;
}

sub setHelp{
    my (%params_hash_ref) = @_;

    my $help    = '';
#     $help       =  "<div class='reference'>".i18n($params_hash_ref{'text'})."</div>";
    $help       =  "<span class='help-inline'>".i18n($params_hash_ref{'text'})."</span>";
    return $help;
}


=item 
Funcion que crea los mensajes de ayuda en los inputs
Recibe como parametro una hash con:
    textLabel: texto del label
    class: clase del label (para darle colores, sino pone una por default)
    text: texto de ayuda
    
Ejemplo:
        text        => "[% 'El M&eacute;todo se agrega deshabilitado por defecto.' | i18n %]",
        class       => "info",
        textLabel   => "NOTA:"    
=cut
sub setHelpInput{

    my (%params_hash_ref)       = @_;
    
    my @array_clases_labels     = ('success','warning', 'important', 'info');
    
    my $classLabel              = $params_hash_ref{'class'} || "label";
    my $textLabel               = $params_hash_ref{'textLabel'} || "";
    my $help                    = "";
    my $icon                    = $params_hash_ref{'icon'};
    
    if (!C4::AR::Utilidades::existeInArray($classLabel,@array_clases_labels)){
        $classLabel = "label";
    }
    
    if($classLabel ne "label"){
        $classLabel = "label label-" . $classLabel;
    }
    
    if($textLabel eq ""){
        
            if ($icon){
                  $help                = "<p class='help-block'><i class='$icon'></i>"
                                          . $params_hash_ref{'text'} . "</p>";
            } else {
                $help                    = "<p class='help-block'>"
                                          . $params_hash_ref{'text'} . "</p>";
            }

  
    }   else {
       
        $help                    = "<p class='help-block'><span class='"
                                        . $classLabel . "'>"
                                        . $params_hash_ref{'textLabel'} . "</span>"
                                        . $params_hash_ref{'text'} . "</p>";
                                    
    }

    return $help;                                    
   
}


sub to_Icon{
    my (%params_hash_ref) = @_;

    my $button  = '';
    my $boton   = $params_hash_ref{'boton'}; #obtengo el boton
    my $onclick = $params_hash_ref{'onclick'} || $params_hash_ref{'onClick'}; #obtengo el llamado a la funcion en el evento onclick
    my $title   = $params_hash_ref{'title'}; #obtengo el title de la componete
    
    my $alternClass     = $params_hash_ref{'alternClass'} || 'horizontal';

    my $open_elem       = "<div ";
    my $close_elem      = "</div>";

    if ($params_hash_ref{'id'}){
        $open_elem     .= "id='".$params_hash_ref{'id'}."' ";
    }
      
    my $style = $params_hash_ref{'style'} || '';
    if ($params_hash_ref{'elem'}){
        $open_elem  = "<".$params_hash_ref{'elem'};
        $close_elem = "</".$params_hash_ref{'elem'}.">";
    }

    if($params_hash_ref{'li'}){
        $button .=  '<li class="click '.$alternClass.' '.$boton.' " onclick="'.$onclick.'"';
    }else{
        $button .=  $open_elem.' class="click '.$alternClass.' '.$boton.'" onclick="'.$onclick.'"'.' style="'.$style.'"';
    }

    if($title){
        $button .= ' title="'.$title.'"';
    }
    
    $button .= '> ';
    if($params_hash_ref{'li'}){
        $button .=  '&nbsp;</li> ';
    }else{
        $button .=  $close_elem;
    }

    return $button;
}

sub show_componente {
    my (%params_hash_ref) = @_;

    my $campo               = $params_hash_ref{'campo'};
    my $subcampo            = $params_hash_ref{'subcampo'};
    my $dato                = $params_hash_ref{'dato'};
    my $id1                 = $params_hash_ref{'id1'};
    my $id2                 = $params_hash_ref{'id2'};
    my $template            = $params_hash_ref{'template'};

    my $session             = CGI::Session->load();
    my $session_type        = $session->param('type') || 'opac';
     

# NO SE VA A USAR MAS PARECE, LO DEJO POR LAS DUDAS AUN!!!!
    # if(($campo eq "245")&&($subcampo eq "a")&&($template eq "ANA")) {

    #   my $catRegistroMarcN1   = C4::AR::Nivel1::getNivel1FromId1($id1);

    #     if($catRegistroMarcN1){
    #         my %params_hash;
    #         my $text        = $catRegistroMarcN1->getTitulo(); 
    #         %params_hash    = ('id1' => $catRegistroMarcN1->getId1());
    #         my $url;

    #         if ($session_type eq 'intranet'){
    #             $url         = C4::AR::Utilidades::url_for("/catalogacion/estructura/detalle.pl", \%params_hash);
    #         }else{
    #             $url         = C4::AR::Utilidades::url_for("/opac-detail.pl", \%params_hash);
    #         }

    #         return C4::AR::Filtros::link_to( text => $text, url => $url , blank => 1);
    #     }
        
    #     return "NO_LINK";
    # }
    
    if(($campo eq "856")&&($subcampo eq "u")) {


        #C4::AR::Debug::debug("C4::AR::Filtros::show_componente => campo, subcampo: ".$campo.", ".$subcampo); 
        #C4::AR::Debug::debug("C4::AR::Filtros::show_componente => DENTRO => dato: ".$dato);
        
        return C4::AR::Filtros::link_to( text => $dato, url => $dato , blank => 1, url_absolute => 1, without_token => 1);

    }
    
    if((($campo eq "700")||($campo eq "100"))&&($subcampo eq "a")) {
   
        if($session_type eq 'intranet'){
    
            return "<a class='click' onClick='buscarPorAutor(&#039$dato&#039)' title='" . i18n('Filtrar por Autor') . "'>$dato</a>";
        
        }else{
        
            my %params_hash    = ('autor' => $dato, 'tipoAccion' => 'BUSQUEDA_AVANZADA');
            my $url            = C4::AR::Utilidades::url_for("/opac-busquedasDB.pl", \%params_hash);
            
            return C4::AR::Filtros::link_to( text => $dato, url => $url );
        
        }
    }
  
    # if((($campo eq "650")||($campo eq "653"))&&($subcampo eq "a")) {
    if((($campo eq "650"))&&($subcampo eq "a")) {
  
        if($session_type eq 'intranet'){
    
            return "<a class='click' onClick='verTema(&#039$dato&#039)' title='" . i18n('Filtrar por Tema') . "'>$dato</a>";

        }else{

            my %params_hash    = ('tema' => $dato, 'tipoAccion' => 'BUSQUEDA_AVANZADA');
            my $url            = C4::AR::Utilidades::url_for("/opac-busquedasDB.pl", \%params_hash);
            
            return C4::AR::Filtros::link_to( text => $dato, url => $url );

        }
    }

    if(($campo eq "773")&&($subcampo eq "a")&&($dato ne "")) {

            
        my $nivel2_object       = C4::AR::Nivel2::getNivel2FromId2($dato);

	if(!$nivel2_object){
		return "NO_LINK";
	}	

        $id1                    = $nivel2_object->getId1();
        my $catRegistroMarcN1   = C4::AR::Nivel1::getNivel1FromId1($id1);

#       C4::AR::Debug::debug("C4::AR::Filtros::show_componente => campo, subcampo: ".$campo.", ".$subcampo); 
#       C4::AR::Debug::debug("C4::AR::Filtros::show_componente => DENTRO => dato: ".$dato);

        if($catRegistroMarcN1){
            my %params_hash;
            my $text        = $catRegistroMarcN1->getTitulo(); 
            %params_hash    = ('id1' => $catRegistroMarcN1->getId1());
            my $url;

            if ($session_type eq 'intranet'){
                $url         = C4::AR::Utilidades::url_for("/catalogacion/estructura/detalle.pl", \%params_hash);
            }else{
                $url         = C4::AR::Utilidades::url_for("/opac-detail.pl", \%params_hash);
            }

#             C4::AR::Debug::debug("C4::AR::Filtros::show_componente => DENTRO => url: ".$url);

            return C4::AR::Filtros::link_to( text => $text, url => $url , blank => 1);
        }
        
        return "NO_LINK";
    }

    return "NO_LINK";
}


# sub show_componente {
#     my (%params_hash_ref) = @_;
# 
#     my $campo               = $params_hash_ref{'campo'};
#     my $subcampo            = $params_hash_ref{'subcampo'};
#     my $dato                = $params_hash_ref{'dato'};
#     my $itemtype            = $params_hash_ref{'itemtype'};
#     my $type                = $params_hash_ref{'type'};
# 
#     my $session             = CGI::Session->load();
#     my $session_type        = $session->param('type') || 'opac';
#      
#     if(($campo eq "245")&&($subcampo eq "a")) {
# 
#       my $catRegistroMarcN2   = C4::AR::Nivel2::getNivel2FromId2($dato);
# 
#       C4::AR::Debug::debug("C4::AR::Filtros::show_componente => campo, subcampo: ".$campo.", ".$subcampo); 
# 
#       C4::AR::Debug::debug("C4::AR::Filtros::show_componente => DENTRO => dato: ".$dato);
# 
#         if($catRegistroMarcN2){
#             my %params_hash;
#             my $text        = $catRegistroMarcN2->nivel1->getTitulo()." (".$catRegistroMarcN2->nivel1->getAutor().") - ".$catRegistroMarcN2->toString; 
#             %params_hash    = ('id1' => $catRegistroMarcN2->getId1());
#             my $url;
# 
#             if ($session_type eq 'intranet'){
#               $url         = C4::AR::Utilidades::url_for("/catalogacion/estructura/detalle.pl", \%params_hash);
#             }else{
#                 $url         = C4::AR::Utilidades::url_for("/opac-detail.pl", \%params_hash);
#             }
# 
#             return C4::AR::Filtros::link_to( text => $text, url => $url );
#         }
#         
#     } elsif($type eq "INTRA") {
#         if(($campo eq "773")&&($subcampo eq "a")){
#             my $catRegistroMarcN2   = C4::AR::Nivel2::getNivel2FromId2($dato);
#     
# # TODO FIXEDDDDDDDDDD en el futuro esto se debe levantar de la configuracion
#             if($catRegistroMarcN2){
# 
#                 #obtengo las analiticas
#                 my $cat_reg_marc_n2_analiticas = $catRegistroMarcN2->getAnaliticas();
#   
#                 if(scalar(@$cat_reg_marc_n2_analiticas) > 0){
#                      #no tiene analiticas
#                     C4::AR::Debug::debug("C4::AR::Filtros::show_componente => TIENE ANALITICAS"); 
#                     my %params_hash;
#                     my $text        = $catRegistroMarcN2->nivel1->getTitulo()." (".$catRegistroMarcN2->nivel1->getAutor().") - ".$catRegistroMarcN2->toString; 
#                     %params_hash    = ('id1' => $catRegistroMarcN2->getId1());
#                     my $url         = C4::AR::Utilidades::url_for("/catalogacion/estructura/detalle.pl", \%params_hash);
# 
#                     return C4::AR::Filtros::link_to( text => $text, url => $url );
#                 }
# 
# #                 aca tengo que identificar si este nivel 2 es padre o hijo de una analitica para cambiar el link               
#             } else {
#                 C4::AR::Debug::debug("C4::AR::Filtros::show_componente => NO TIENE ANALITICAS"); 
#             }
#         }
#     } else {
# # TODO FIXEDDDDDDDDDD en el futuro esto se debe levantar de la configuracion
#         if(($campo eq "773")&&($subcampo eq "a")){
#             my $catRegistroMarcN2 = C4::AR::Nivel2::getNivel2FromId2($dato);
#     
#             if($catRegistroMarcN2){
#                 return $catRegistroMarcN2->nivel1->getTitulo()." (".$catRegistroMarcN2->nivel1->getAutor().") - ".$catRegistroMarcN2->toString; 
#             }
#         }
#     }
# 
#     return $dato;
# }

sub ayuda_marc{

#     my $icon= to_Icon(  
#                 boton   => "icon_ayuda_marc",
#                 onclick => "abrirVentanaHelperMARC();",
#                 title   => i18n("Ayuda MARC"),
#             ) ;

#     return "<div style='float: right;'><span class='click'>".$icon."</span></div><div id='ayuda_marc_content'></div>";
return "<i class='click icon-question-sign' onclick='abrirVentanaHelperMARC();'><div id='ayuda_marc_content' class='modal fade hide'></div></i>";
}


=item   sub get_error_message
    Esta funcion muestra un error en el template cuando falta algun parametros  
    $params_hash_ref{'debug'}: mensaje para debug 
    $params_hash_ref{'msg'}: mensaje para el usuario, sino se ingresa nada muesrta mensaje por defecto "ERROR EN LOS PARAMETROS"
=cut
sub get_error_message{
    my (%params_hash_ref) = @_;

    my $mensaje = i18n('ERROR EN LOS PARAMETROS');

    if($params_hash_ref{'debug'}){
        C4::AR::Debug::debug("Filtro => error_en_parametros => ".$params_hash_ref{'debug'});
    }

    if($params_hash_ref{'msg'}){
        $mensaje = i18n($params_hash_ref{'msg'});
    }

    return "<div class='error_en_parametros'>".$mensaje."</div>";
}

sub ayuda_in_line{
    my ($text) = @_;
    
    my $icon= to_Icon(  
                boton   => "icon_ayuda",
                title   => i18n("Ayuda"),
            ) ;

    my $ayuda = "<div id='ayuda' style='text-align: left;'><span class='click'>".$icon."</span>";
    $ayuda .= "<div id='ayuda_in_line' style='display:none'>".$text."</div></div>";

    return $ayuda;
}
=item
Este filtro sirve para generar dinamicamente le combo para seleccionar el idioma.
Este es llamado desde el opac-top.inc o intranet-top.inc (solo una vez).
Se le parametriza si el combo es para la INTRA u OPAC
=cut
sub setFlagsLang {

    my ($type,$theme) = @_;
    my $session = CGI::Session->load();
    my $html= '<ul class="culture_selection">';
    my $lang_Selected= $session->param('usr_locale');
## FIXME falta recuperar esta info desde la base es_ES => Español, ademas estaria bueno agregarle la banderita
    my @array_lang;


    my %hash_flags = {};
    $hash_flags{'lang'} = 'es_ES';
    $hash_flags{'flag'} = 'es.png';
    $hash_flags{'title'} = 'Espa&ntilde;ol';
    push (@array_lang, \%hash_flags);
    my %hash_flags = {};
    $hash_flags{'lang'} = 'en_EN';
    $hash_flags{'flag'} = 'en.png';
    $hash_flags{'title'} = 'English';
    push (@array_lang, \%hash_flags);
    my $href;

    my $token   =   $session->param('token');
    my $url = $ENV{'REQUEST_URI'};
    if($type eq 'OPAC'){
        $href = C4::AR::Utilidades::getUrlPrefix().'/opac-language.pl?token='.$token.'&amp;';
    }else{
        $href = C4::AR::Utilidades::getUrlPrefix().'/intra-language.pl?token='.$token.'&amp;';
    }

    my $flags_dir = '';

    foreach my $hash_temp (@array_lang){
            $html .='<li><a href='."$href"."lang_server=".$hash_temp->{'lang'}.' title="'.$hash_temp->{'title'}.'"><img src='."$flags_dir".'/'.$hash_temp->{'flag'}.' alt="'.i18n("Cambio de lenguaje").'" /></a></li>';
    }
    $html .="</ul>";

    return $html;
}

sub getComboMatchMode {
    my $html= '';

    $html .="<select id='match_mode' tabindex='-1'>";
    $html .="<option value='SPH_MATCH_PHRASE'>".i18n("Coincidir con la frase exacta")."</option>";
    $html .="<option value='SPH_MATCH_ANY'>".i18n("Coincidir con cualquier palabra")."</option>";
    $html .="<option value='SPH_MATCH_BOOLEAN'>".i18n("Coincidir con valores booleanos (&), OR (|), NOT (!,-)")."</option>";
    $html .="<option value='SPH_MATCH_EXTENDED' selected='selected'>".i18n("Coincidencia Extendida")."</option>";
    $html .="<option value='SPH_MATCH_ALL'>".i18n("Coincidir con todas las palabras")."</option>";
    $html .="</select>";

    return $html;
}

sub getComboLang {
    my $html= '';

    my @languages = ("es_ES","en_EN");
    my %languages_name = {};
    $languages_name{'es_ES'} = "Espa&ntilde;ol";
    $languages_name{'en_EN'} = "English";


    my $user_lang = C4::AR::Auth::getUserLocale(); 
    my $default = "";

    $html .="<select id='language' name='language' tabindex='-1' style='width:170px;'>";

    foreach my $lang (@languages){
        if ($user_lang eq $lang){
           $default = "selected='selected'";
           $html .="<option value='$lang' $default>".$languages_name{$lang}."</option>";
        }else{
           $html .="<option value='$lang '>".$languages_name{$lang}."</option>";
            
        }
    }
    
    $html .="</select>";

    return $html;
}

sub getComboValidadores {
    my $html= '';

    $html .="<select id='combo_validate' tabindex='-1'>";
    my $validadores_hash_ref = C4::AR::Referencias::getValidadores();
    while ( my ($key, $value) = each(%$validadores_hash_ref) ) {
        $html .="<option value=".$key.">".$value."</option>";
    }

    $html .="</select>";

    return $html;
}

sub action_link_button{

    my (%params_hash_ref) = @_;

    my $url      = $params_hash_ref{'url'} || $params_hash_ref{'url'};
    my $button   = $params_hash_ref{'button'};
    my $icon     = $params_hash_ref{'icon'} || undef;
    my $params   = $params_hash_ref{'params'} || $params_hash_ref{'url'};
    my $title    = $params_hash_ref{'title'};


    my $popover = $params_hash_ref{'popover'} ||undef;
    my $popopver_attr = "";
    
    if ($popover){
        $button.= " popover_button ";
        my $placement = $popover->{'placement'}||'right';
        my $text_pop = $popover->{'text'};
        my $title_pop= $popover->{'title'};
        $popopver_attr.= " rel='popover' data-content='$text_pop' rel='popover' data-placement='$placement' data-original-title='$title_pop' ";   
    }
    
    my $params   = $params_hash_ref{'params'}; #obtengo el llamado a la funcion en el evento onclick
    my $title    = $params_hash_ref{'title'}; #obtengo el title de la componete
    my $popover  = $params_hash_ref{'popover'} || undef;
    my @result;
    
    foreach my $p (@$params){
        @result = split(/=/,$p);

        $url = C4::AR::Utilidades::addParamToUrl($url,@result[0],@result[1]);
    }
    
    my $html = "<a class='".$button."' $popopver_attr href='".$url."'><i class='".$icon."'></i>".$title."</a>";
    
    return $html;
}

sub action_button{

    my (%params_hash_ref) = @_;

    my $action   = $params_hash_ref{'action'};
    my $button   = $params_hash_ref{'button'}; #obtengo el boton
    my $icon     = $params_hash_ref{'icon'} || undef;  #obtengo el boton
    my $title    = $params_hash_ref{'title'}; #obtengo el title de la componete
    my $id       = $params_hash_ref{'id'} || undef;
    my $popover  = $params_hash_ref{'popover'} || undef;
    my $disabled = $params_hash_ref{'disabled'} || undef;
    my $alt_text = $params_hash_ref{'alt_text'} || undef;

    $button.= " click";

    if ($disabled){
    	$button .= " disabled";
    }
    my $popopver_attr = "";
    
    if ($popover){
        $button.= " popover_button ";
        my $placement = $popover->{'placement'}||'right';
        my $text_pop = $popover->{'text'};
        my $title_pop= $popover->{'title'};
        $popopver_attr.= " rel='popover' data-content='$text_pop' rel='popover' data-placement='$placement' data-original-title='$title_pop' ";   
    }
    
    
    my $html = "<a id='$id' title='".$alt_text."' class='".$button."' $popopver_attr onclick='".$action."'><i class='".$icon."'></i> ".$title."</a>";
    
    return $html;
}


sub action_set_button{
    my (%params_hash_ref) = @_;
    
    my $title       = $params_hash_ref{'title'}; #obtengo el title de la componete
    my $action      = $params_hash_ref{'action'} || undef;
    my $url         = $params_hash_ref{'url'} || undef;
    my $class       = $params_hash_ref{'class'} || undef;
    my $modifier    = $params_hash_ref{'modifier'} || undef;
    
    my $icon  = $params_hash_ref{'icon'} || 'icon white user'; #obtengo el title de la componete

    my $actions     = $params_hash_ref{'actions'} || [];
    
    my $button   = $params_hash_ref{'button'} || "btn btn-primary";
       $button   .= ' '.$modifier;

    my $popover = $params_hash_ref{'popover'} ||undef;
    my $popopver_attr = "";
    
    if ($popover){
        $button.= " popover_button ";
        my $placement = $popover->{'placement'}||'right';
        my $text_pop = $popover->{'text'};
        my $title_pop= $popover->{'title'};
        $popopver_attr.= " rel='popover' data-content='$text_pop' rel='popover' data-placement='$placement' data-original-title='$title_pop' ";   
    }

    
    my $html = "<div class='btn-group $class'>";
    
    if ($url){
            my $params   =  $params_hash_ref{'params'} ||  $url;
            my @result;
            foreach my $p (@$params){
                @result = split(/=/,$p);
                $url = C4::AR::Utilidades::addParamToUrl($url,@result[0],@result[1]);
            }
        $html.= "<a class='$button' $popopver_attr href='$url'><i class='$icon'></i> $title</a>";
        
    }else{
        $html.= "<a class='$button' $popopver_attr class='click' onclick='$action'><i class='$icon'></i> $title</a>";
    }


    if (scalar(@$actions)){
	    $html.= "<a class='$button dropdown-toggle' data-toggle='dropdown' href='#'><span class='caret'></span></a>";
	    $html.= "<ul class='dropdown-menu'>";
	    
	    foreach my $action (@$actions){
	        my $name = $action->{'title'};
	        my $func = $action->{'action'};
	        my $url  = $action->{'url'};
	        my $icon = $action->{'icon'};
	        if ($func){
	            $html .= "<li><a class='click' onclick='$func' ><i class='$icon' ></i> $name</a></li>";
	        }else{
	            my $params   =  $action->{'params'} ||  $action->{'url'};
	            my @result;
	            foreach my $p (@$params){
	                @result = split(/=/,$p);
	                $url = C4::AR::Utilidades::addParamToUrl($url,@result[0],@result[1]);
	            }
	            $html .= "<li><a href='$url'><i class='$icon'></i> $name</a></li>";
	        }
	
	    }
	
	    $html.= "</ul>";
    }    
    $html.= "</div>";

    return $html;   
}

sub tableHeader{
    my (%params_hash_ref) = @_;
    
    my $id          = $params_hash_ref{'id'}; 
    my $class       = $params_hash_ref{'class'} || undef;
    my $select_all  = $params_hash_ref{'selectAll_id'} || undef;


    my $columns     = $params_hash_ref{'columns'};
    
    my $html = "<table id=$id class='table table-striped $class'><thead>";
    
    if ($select_all){
        $html .= "<th><i class='icon-ok-sign click' id='$select_all' title='".C4::AR::Filtros::i18n("Seleccionar todos")."'></th>";
    }
    
    foreach my $column (@$columns){
        $html .= "<th>$column</th>";
    }

    $html .= "</thead>";
    
    return $html;	
}


sub sortableTableHeader{
    my (%params_hash_ref) = @_;
    
    my $id              = $params_hash_ref{'id'}; 
    my $class           = $params_hash_ref{'class'} || undef;
    my $select_all      = $params_hash_ref{'selectAll_id'} || undef;
    my $sortable_fields = $params_hash_ref{'sortable_fields'} || undef;
    my $order           = $params_hash_ref{'order'} || undef;
    my $order_direction = $params_hash_ref{'order_direction'} || undef;

    my $order_name_function =  $params_hash_ref{'order_name_function'} || undef;

    my $columns     = $params_hash_ref{'columns'};
    
    my $html = "<table id=$id class='table table-striped $class'><thead>";
    
    if ($select_all){
        $html .= "<th><i class='icon-ok-sign click' id='$select_all' title='".C4::AR::Filtros::i18n("Seleccionar todos")."'></th>";
    }

    if ($sortable_fields){
          foreach my $column (@$columns){
              if ($sortable_fields->{$column}){   
                    my $field_name= $sortable_fields->{$column};
                    $field_name =~ s/[.]//g;

                    if ($order){
                       
                        if ($order eq $field_name){
                            
                            if ($order_direction){
                               
                                $html .= "<th class='click' id='columna_$field_name' onclick=ordenar_$order_name_function('".$sortable_fields->{$column}."')>$column <i id='icon_$field_name' class='icon-chevron-down click' style='float:right;'></th>";
                            } else {
                                
                                $html .= "<th class='click' id='columna_$field_name' onclick=ordenar_$order_name_function('".$sortable_fields->{$column}."')>$column <i id='icon_$field_name' class='icon-chevron-up click' style='float:right;'></th>";
                            }
                        } else {
                            
                             $html .= "<th class='click' id='columna_$field_name' onclick=ordenar_$order_name_function('".$sortable_fields->{$column}."')>$column <i id='icon_$field_name' class='icon-chevron-up click' style='float:right;'></th>";
                        }
                    } else {
                       
                         $html .= "<th class='click' id='columna_$field_name' onclick=ordenar_$order_name_function('".$sortable_fields->{$column}."')>$column <i id='icon_$field_name' class='icon-chevron-up click' style='float:right;'></th>";
                    }   
               
              } else {
                     $html .= "<th>$column</th>";
              }
          }
    } else {
        foreach my $column (@$columns){
            $html .= "<th>$column</th>";
        }
    }
    
    $html .= "</thead>";
    
    return $html;   
}







sub action_group_link_button{
	my (%params_hash_ref) = @_;
	
    my $actions     = $params_hash_ref{'actions'} || [];
    
    
    my $html = "<div class='btn-group'>";
   
    foreach my $action (@$actions){
        my $url   =  $action->{'url'}; #obtengo la url si es un link 
        my $title = $action->{'title'};
		my $icon  = $action->{'icon'};
		my $class = $action->{'class'};
		
        if($url){
			#ES UN LINK
			my $params   =  $action->{'params'} ||  $action->{'url'}; #obtengo el llamado a la funcion en el evento onclick
			my @result;
			foreach my $p (@$params){
				@result = split(/=/,$p);
				$url = C4::AR::Utilidades::addParamToUrl($url,@result[0],@result[1]);
			}
			$html .= "<a class='click btn $class' href='$url'><i class='$icon'></i>$title</a>";
		}
		else{
			#ES UNA ACCION
			my $func = $action->{'action'}; #obtengo la funcion si es una accion
			$html .= "<a class='click btn $class' onclick='$func' ><i class='$icon'></i>$title</a>";
		}

    }

    $html.= "</div>";
    
    return $html;	
}

sub tabbedPane{
    my (%params) = @_;
    
    my $span = $params{'span'} ||'';
    
    my $html = "<section class='$span'>";

    $html .= "<h2>".$params{'titulo'}."</h2>";
    $html .= "<p>".$params{'subtitulo'}."</p>";
    $html .= "<ul id='tab' class='nav nav-tabs'>";    
    
    my $content_elems = $params{'content'};
    foreach my $elem (@$content_elems){
    	my $active = "";
    	
    	if ($elem->{'id'} eq $params{'active_id'}){
    		$active = "class='active'";
    	}
    	$html .= "<li $active><a href='#".$elem->{'id'}."' data-toggle='tab'>".$elem->{'text'}."</a></li>";
    }
    
    $html .= "</ul>";
    
    $html .= "<div id='".$params{'content_id'}."' class='tab-content'>";
    
    return $html;
    
}

END { }

1;
__END__
