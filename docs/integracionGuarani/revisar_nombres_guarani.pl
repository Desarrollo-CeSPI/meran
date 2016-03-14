#!/usr/bin/perl -w
#
# 0 Archivo para actualizar de guarani

# Carga los modulos requeridos
use strict;

use DBI;
use CGI::Session;
use C4::Context;

# Abre el archivo cuyo nombre se mando como primer parámetro
open(ARCHIVO,$ARGV[0]) || die("El archivo no abre");

my $dbh = C4::Context->dbh;

while (my $line = <ARCHIVO>) {
    # Arma un arreglo a partir de una linea del archivo
    # Comenzando en el primer caraceter y usando el <TAB> como separador de campos
    my @fields = split(/\|/,$line);

    my $surname = $fields[3];
    my $firstname = $fields[4];
    my $documentnumber = ($fields[21] eq '')?'NULL':(split(/\./,$fields[21]))[0];

    my $sth = $dbh->prepare("select * from usr_persona where nro_documento=? ");
    $sth->execute($documentnumber);

    if (! $sth->rows ){
        my $datos=$sth->fetchrow_hashref;
        if (($datos->{'apellido'} ne $surname)||($datos->{'nombre'} ne $firstname)){
            print ("UPDATE usr_persona SET apellido  = '$surname', nombre = '$firstname' WHERE nro_documento = '$documentnumber' );\n");
        }
    }

}   

close L;

# fin del while
exit 1;
