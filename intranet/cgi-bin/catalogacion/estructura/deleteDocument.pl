#!/usr/bin/perl



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
#

use strict;
use C4::AR::Auth;
use C4::Output;
use CGI;
use C4::Context;
use C4::AR::UploadFile;
use JSON;

my $input = new CGI;

my ($nro_socio, $session, $flags) = checkauth( 
                                                        $input, 
                                                        0,
                                                        {   ui              => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'MODIFICACION', 
                                                            entorno         => 'usuarios'},
                                                            "intranet"
                        );  

my $params=$input->param('obj');
$params=C4::AR::Utilidades::from_json_ISO($params);

$params->{'nro_socio'} = $nro_socio;

my $msg_object = C4::AR::UploadFile::deleteDocument($input,$params);

my $infoOperacionJSON=to_json $msg_object;

C4::AR::Auth::print_header($session);
print $infoOperacionJSON;

