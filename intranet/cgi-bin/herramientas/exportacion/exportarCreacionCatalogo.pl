#!/usr/bin/perl

use strict;
use C4::AR::Auth;
use CGI;
use DBI;
use DBIx::XML_RDB;
use warnings;
use C4::Context;

my $query   = new CGI;
my $context = new C4::Context;

my $user    = $context->config('userINTRA');
my $pass    = $context->config('passINTRA');
my $db      = $context->config('database');

my $dsn     = "dbi:mysql:dbname=" . $db .";host=localhost";

eval{

    my $xmlout  = DBIx::XML_RDB->new ($dsn, "mysql", $user, $pass, $db) or die "Failed to make new xmlout";

    $xmlout->DoSql("select campo, subcampo, itemtype, liblibrarian, tipo, referencia, nivel, obligatorio, "
            ."intranet_habilitado, visible, edicion_grupal, idinforef, idCompCliente, fijo, repetible, "
            ."rules, grupo FROM cat_estructura_catalogacion");

    my $file = $xmlout->GetData;
    my $path = '/tmp/MERAN-creacionCatalogo.xml';

    #escribirlo en /tmp
    open(WRITEIT, ">:encoding(UTF-8)", $path) or die "\nCant write to $path Reason: $!\n";
    print WRITEIT $file;
    close(WRITEIT);

    open INF, $path or die "\nCan't open $path for reading: $!\n";

    print $query->header(
                          -type           => 'application/xml', 
                          -attachment     => 'estructuraCatalogacion.xml',
                          -expires        => '0',
                      );
    my $buffer;

    while (read (INF, $buffer, 65536) and print $buffer ) {};

};

if($@){
  C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/mainpage.pl');
}