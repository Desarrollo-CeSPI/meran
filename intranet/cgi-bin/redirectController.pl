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
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI;
use CGI::Session;

my $query = new CGI;

C4::AR::Debug::debug("redirectController=>");

#recupero la session
my $session = CGI::Session->load();

#esta indireccion es pq een el cliente esta fija la url cuando es un CLIENT_REDIRECT
##entonces se fijaria el redirectContrller.pl en el AjaxxHelper y este redirige segun
#lo indicado en el session->param('redirectTo')
C4::AR::Debug::debug("redirectContrller=> redirect: ".$session->param('redirectTo'));
# C4::AR::Debug::debug("redirectController=> session->dump(): ".$session->dump());;

# FIXME location esta fijo si no hay session '/auth.pl'

my $input = CGI->new(); 
print $input->redirect( 
            -location => $session->param('redirectTo')||C4::AR::Utilidades::getUrlPrefix().'/auth.pl', 
            -status => 301,
); 
exit;