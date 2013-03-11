#!/usr/bin/perl
  
use strict;
use C4::AR::Auth;

use CGI;
use C4::AR::PdfGenerator;
use C4::AR::Busquedas;
 
my $input = new CGI;
 
my $op=$input->param('op');

if ($op eq 'pdf') {

    my $obj;
    $obj->{'orden'}=$input->param('orden')||'apellido';
    $obj->{'apellido1'}=$input->param('surname1');
    $obj->{'apellido2'}=$input->param('surname2');
    $obj->{'legajo1'}=$input->param('legajo1');
    $obj->{'legajo2'}=$input->param('legajo2');
    $obj->{'categoria_socio'}=$input->param('categoria_socio');
    $obj->{'export'}=1;

    my ($cantidad,$results)=C4::AR::Usuarios::BornameSearchForCard($obj);

    C4::AR::Utilidades::printARRAY($results);
     #HAY QUE GENERAR EL PDF CON LOS CARNETS
    C4::AR::PdfGenerator::batchCardsGenerator($cantidad,$results);

}
