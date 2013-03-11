use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::NovedadesIntra;
my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                                    template_name => "admin/global/agregar_novedad_intra.tmpl",
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

    #--------- links -----------
    my $linksTodos  = $input->param('links');  
    my @links       = split(' ', $linksTodos);   
    my $linksFinal  = "";

    C4::AR::Debug::debug("links todos ---------------- " .$linksTodos . " scalar : " . scalar(@links));
    # C4::AR::Utilidades::printARRAY(@links);
    
    foreach my $link (@links){
    
        if($link !~ /^http/){
            $linksFinal .= " http://" . $link;
        }else{
            $linksFinal .= " " . $link;
        }
        C4::AR::Debug::debug("links final dentro del foreach " . $linksFinal);
    }

    C4::AR::Debug::debug("links ------------------ " . $linksFinal);
    
    $input->param('links', $linksFinal);
    #------- FIN links ---------

    my $status = C4::AR::NovedadesIntra::editar($input);
    if ($status){
        C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/admin/global/novedades_intra.pl?token='.$input->param('token'));
    }
}elsif($action eq 'agregar'){
    
        #--------- links -----------
    my $linksTodos  = $input->param('links');  
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

    my $status = C4::AR::NovedadesIntra::agregar($input);
    if ($status){
        C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/admin/global/novedades_intra.pl?token='.$input->param('token'));
    }

}else{
    $t_params->{'novedad'} = C4::AR::NovedadesIntra::getNovedad($id);
    $t_params->{'editing'} = 1;
}



C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
