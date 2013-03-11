#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use JSON;
use Time::HiRes;
use CGI;
use C4::AR::Busquedas qw(busquedaPorBarcode armarBuscoPor busquedaCombinada_newTemp);
use C4::AR::Preferencias;

my $external_search_enabled = C4::AR::Preferencias::getValorPreferencia('external_search');
my $input = new CGI;
my $session    =   CGI::Session->load();

if ($external_search_enabled){
	my $obj=$input->param('obj');
	$obj = C4::AR::Utilidades::from_json_ISO($obj);
	
	my $ini= $obj->{'ini'};
	my $tipoAccion= $obj->{'tipoAccion'}||"";
	my $start = [ Time::HiRes::gettimeofday( ) ]; #se toma el tiempo de inicio de la busqueda
	
	
	my $dateformat = C4::Date::get_date_format();
	my ($ini,$pageNumber,$cantR)=C4::AR::Utilidades::InitPaginador($ini);
	
	$obj->{'page'} = $input->param('page') || 0;
	
	$obj->{'ini'} = $ini;
	$obj->{'cantR'} = $cantR;
	$obj->{'type'}          = 'OPAC';
	$obj->{'isOAI_search'}  = 1;
	
	my $keyword                     = $obj->{'keyword'};        
	my $search;
	$search->{'keyword'}            = $keyword;
	
	my %sphinx_options              = {};
	$sphinx_options{'only_sphinx'}       = 0;
	        
	my ($cantidad, $resultId1, $suggested)      = C4::AR::Busquedas::busquedaCombinada_newTemp($search->{'keyword'}, undef, $obj,\%sphinx_options);
	my $xml = C4::AR::Busquedas::toOAI($resultId1);

	C4::AR::Auth::print_header($session);
    print $xml;
}else{
    my $xml = C4::AR::Filtros::i18n("400 NOT AUTHORIZED");

    C4::AR::Auth::print_header($session);
    print $xml;
}

            

