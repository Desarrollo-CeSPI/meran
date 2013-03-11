#!/usr/bin/perl

use strict;
use CGI;
use C4::AR::Auth;
use C4::AR::PdfGenerator;

my $input=new CGI;


# my ($template, $session, $t_params) =  get_template_and_user ({
# 			template_name	=> 'circ/ticket.tmpl',
# 			query		=> $input,
# 			type		=> "intranet",
# 			authnotrequired	=> 0,
# 			flagsrequired	=> {    ui => 'ANY', 
#                                     tipo_documento => 'ANY', 
#                                     accion => 'CONSULTA', 
#                                     entorno => 'undefined'},
#     });
    my $obj;
 
    $obj= C4::AR::Utilidades::from_json_ISO($input->param('comp'));

    my ($template, $session, $t_params) =  get_template_and_user ({
                    template_name   => 'circ/ticket.tmpl',
                    query       => $input,
                    type        => "intranet",
                    authnotrequired => 0,
                    flagsrequired   => {    ui => 'ANY', 
                                            tipo_documento => 'ANY', 
                                            accion => 'ALTA', 
                                            entorno => 'circ_prestar',
                                            tipo_permiso => 'circulacion'},
            });

        
    my @comprobantes;

    foreach my $elem (@$obj) {
            my %hash;    
            my $ticket= $elem->{'ticket'};

            $hash{'socio'} =    C4::AR::Usuarios::getSocioInfoPorNroSocio($ticket->{'socio'});
            $hash{'responsable'} = C4::AR::Usuarios::getSocioInfoPorNroSocio($ticket->{'responsable'});                
            $hash{'prestamo'} = C4::AR::Prestamos::getPrestamoDeId3($ticket->{'id3'});
            $hash{'adicional_selected'}   = $ticket->{'adicional_selected'};
            push(@comprobantes,\%hash);
            
    }


    $t_params->{'comprobantes'}   = \@comprobantes;
    $t_params->{'pageSize'}   = "A5";
    

    my $out= C4::AR::Auth::get_html_content($template, $t_params, $session);
    my $filename= C4::AR::PdfGenerator::pdfFromHTML($out, $t_params);

#     my $public_report = C4::AR::Utilidades::moveFileToReports($filename);

#      print C4::AR::PdfGenerator::pdfHeader();
#      C4::AR::PdfGenerator::printPDF($filename);

   
  C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
