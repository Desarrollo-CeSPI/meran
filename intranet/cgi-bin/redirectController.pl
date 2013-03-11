#!/usr/bin/perl

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
