#!/usr/bin/perl

use strict;
require Exporter;

use C4::Output;  # contains gettemplate
use C4::AR::Auth;
use C4::Context;
use CGI;
use CGI::Session;

my $query = new CGI;


#recupero la session
my $session = CGI::Session->load();

#esta indireccion es pq een el cliente esta fija la url cuando es un CLIENT_REDIRECT
##entonces se fijaria el redirectContrller.pl en el AjaxxHelper y este redirige segun
#lo indicado en el session->param('redirectTo')
C4::AR::Debug::debug("OPAC >> redirectController->redirect: ".$session->param('redirectTo'));

# FIXME location esta fijo si no hay session C4::AR::Utilidades::getUrlPrefix().'/auth.pl'

my $url = $session->param('redirectTo')||C4::AR::Utilidades::getUrlPrefix().'/auth.pl';
my $input = CGI->new(); 

if (!C4::AR::Utilidades::validateString($url)){
	$url = C4::AR::Utilidades::getUrlPrefix().'/auth.pl';
}

print $input->redirect( 
#             -location => $session->param('redirectTo'), 
            -location => $url, 
            -status => 301,
); 
exit;
