#!/usr/bin/perl
use strict;
require Exporter;
use CGI;
use C4::AR::Auth;

use C4::Date;

my $query = new CGI;

my $input = $query;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "opac-main.tmpl",
                                    query => $query,
                                    type => "opac",
#                                     authnotrequired => 1,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY', 
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
             });


my $nro_socio = C4::AR::Auth::getSessionNroSocio();

my ($socio, $flags) = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);

C4::AR::Validator::validateObjectInstance($socio);

my $rate = $input->param('rate');
my $id2 = $input->param('id2');

C4::AR::Nivel2::rate($rate,$id2,$nro_socio);

print $session->header;
print C4::AR::Filtros::i18n("Gracias por votar!");

1;
