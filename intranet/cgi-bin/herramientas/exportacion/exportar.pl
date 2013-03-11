#!/usr/bin/perl

use strict;

use C4::AR::Auth;
use CGI;
use C4::AR::ExportacionIsoMARC;

my $query = new CGI;

my ($template, $session, $t_params)= get_template_and_user({
                                    template_name => "herramientas/exportacion/exportar.tmpl",
                                    query => $query,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY',
                                                        tipo_documento => 'ANY',
                                                        accion => 'CONSULTA',
                                                        entorno => 'undefined'},
                                    debug => 1,
            });

    $t_params->{'page_sub_title'} = C4::AR::Filtros::i18n("Exportaciones");

    my %params_combo1;
    $params_combo1{'default'}                    = C4::AR::Preferencias::getValorPreferencia('defaultTipoNivel3');
    $t_params->{'combo_tipo_documento'}         = C4::AR::Utilidades::generarComboTipoNivel3(\%params_combo1);

    my %params_combo2;
    $params_combo2{'default'}                    = C4::AR::Preferencias::getValorPreferencia('defaultUI');
    $t_params->{'combo_ui'}                     = C4::AR::Utilidades::generarComboUI(\%params_combo2);

    my %params_combo3;
    my $nb =C4::AR::Utilidades::getNivelBibliograficoByCode(C4::AR::Preferencias::getValorPreferencia('defaultNivelBibliografico'));
    $params_combo3{'default'} = $nb->getId;
    $t_params->{'combo_nivel_bibliogratico'}    = C4::AR::Utilidades::generarComboNivelBibliografico(\%params_combo3);

    C4::AR::Auth::output_html_with_http_headers($template, $t_params,$session);
