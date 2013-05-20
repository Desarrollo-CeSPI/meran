#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use C4::AR::Auth;
use C4::Context;
use C4::AR::Proveedores;
use C4::AR::Recomendaciones;
use CGI;
use C4::AR::PdfGenerator;

my $input                   = new CGI;
my $id_pedido_cotizacion    = $input->param('id_pedido_cotizacion');

my ($template, $session, $t_params) = get_template_and_user({
    template_name => "adquisiciones/generatePresupuesto.tmpl",
    query => $input,
    type => "intranet",
    authnotrequired => 0,
    flagsrequired => {  ui => 'ANY', 
                        tipo_documento => 'ANY', 
                        accion => 'ALTA', 
                        tipo_permiso => 'general',
                        entorno => 'adq_intra'}, # FIXME
    debug => 1,
});

my $recomendaciones_activas   = C4::AR::Recomendaciones::getRecomendacionesActivas();

if($recomendaciones_activas){
    my @resultsdata;
      
    for my $recomendacion (@$recomendaciones_activas){   
        my %row = ( recomendacion => $recomendacion, );
        push(@resultsdata, \%row);
    }

    $t_params->{'resultsloop'}   = \@resultsdata;   
}
    
my $combo_proveedores               = &C4::AR::Utilidades::generarComboProveedoresMultiple();

$t_params->{'combo_proveedores'}    = $combo_proveedores;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);