#!/usr/bin/perl

use CGI::Session;
use C4::Context;
use  C4::AR::ImportacionIsoMARC;

my $tt1 = time();
my $importacion = $ARGV[0] || 1;
C4::AR::ImportacionIsoMARC::procesarImportacion($importacion);

my $end1 = time();
my $tardo1=($end1 - $st1);
my $min= $tardo1/60;
my $hour= $min/60;
C4::AR::Debug::debug( "AL FIN TERMINO TODO!!! Tardo $tardo1 segundos !!! que son $min minutos !!! o mejor $hour horas !!!");

1;
