#!/usr/bin/perl -w
#
# Este script se usa para extraer las fotos de los usuarios

# Carga los modulos requeridos
use CGI::Session;
use C4::Context;
use Digest::MD5 qw(md5 md5_hex md5_base64);

open (L,">/tmp/sql_fotos.sql");

#
# Abre el archivo cuyo nombre se mando como primer parámetro
open(ARCHIVO,$ARGV[0]) || die("El archivo no abre");

my $dbh = C4::Context->dbh;
my $pictures_dir = C4::Context->config('picturesdir');

my $line;
my @fields;

while ($line = <ARCHIVO>) {
    # Arma un arreglo a partir de una linea del archivo
    @fields = split(/\|/,$line);
    my $nro_documento = $fields[2];
    my $foto =  $fields[4];
    my $file_name = md5_hex($foto).".jpg";
    #print "nro_documento:: ".$nro_documento."\n";
    #print "foto:: ".$foto."\n\n\n";


    my $out = $dbh->prepare("SELECT * from usr_persona where nro_documento= ? ;");
    $out->execute($nro_documento);

    if ($out->rows) {
        my $datos=$out->fetchrow_hashref;
#		if (!$datos->{'foto'}){
            if (length($foto) > 150 ){
            #Hay foto o es muy chica? 
                open(my $out, '>:raw', $pictures_dir.'/'.$file_name) or die "Unable to open: $!";
                print $out pack('H*',$foto);
                close($out);
                print L "UPDATE usr_persona SET foto= '$file_name' where id_persona=$datos->{'id_persona'} ;\n";
            }
#		}
    }
}

