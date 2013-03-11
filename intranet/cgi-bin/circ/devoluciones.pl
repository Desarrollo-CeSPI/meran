#!/usr/bin/perl
# Please use 8-character tabs for this file (indents are every 4 characters)

#written 8/5/2002 by Finlay
#script to execute issuing of books

# Copyright 2000-2002 Katipo Communications
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Koha; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA  02111-1307 USA

use strict;
use CGI;
use C4::AR::Auth;


my $input       = new CGI;

my ($template, $session, $t_params) =  get_template_and_user ({
			template_name	=> 'circ/devoluciones.tmpl',
			query		=> $input,
			type		=> "intranet",
			authnotrequired	=> 0,
			flagsrequired	=> {    ui => 'ANY', 
                                    tipo_documento => 'ANY', 
                                    accion => 'CONSULTA', 
                                    entorno => 'undefined'},
    });


# FIXME para que esta todo esto?????????????????????????
my $obj         = $input->param('obj');
my $usuarioID   ="";
my $usuarioText = "";

if($obj ne ""){
	$obj                        = C4::AR::Utilidades::from_json_ISO($obj);
	my $array                   = $obj->{'array_ids3'};
	$usuarioID                  = $obj->{'usuario'}->{'ID'};
	$usuarioText                = $obj->{'usuario'}->{'text'};

    $t_params->{'usuarioText'}  = $usuarioText;
    $t_params->{'array'}        = $array;
    $t_params->{'accion'}       = $obj->{'accion'};

}

$t_params->{'usuarioID'}        = $usuarioID;

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);