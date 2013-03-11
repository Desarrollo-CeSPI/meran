#!/usr/bin/perl

use strict;

use C4::AR::Auth;
use CGI;
use C4::AR::ExportacionIsoMARC;


use CGI;
use JSON;

my $query           = new CGI;
my $authnotrequired = 0;
my $tipoAccion             = $query->param('tipoAccion') ||"EXPORTAR";

if ($tipoAccion eq 'EXPORTAR') {

    my $filename    = $query->param('filename');

    if (!$filename){
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
        $year       += 1900;
        my $dt      = "$hour$min-$mday-$mon-$year";
        $filename   = 'export-'.$dt.'.iso';
    }

    C4::AR::Debug::debug("Exportar => OP: ".$tipoAccion);
    C4::AR::Debug::debug("Exportar => : ".$filename);
    print $query->header(
                                -type           => 'application/octet-stream',
                                -attachment     => $filename,
                                -expires        => '0',
                      );

    eval {

        C4::AR::ExportacionIsoMARC::marc_record_to_ISO_from_range( $query );
    };

    if($@){
          my $msg_error = "ERORROROROR $@";
          C4::AR::Debug::debug($msg_error);
    }
}
else {

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
}
