#!/usr/bin/perl -w
#
# Este script toma la exportacion de guarani, encripta las passwords y envia el archivo generado generado al servidor que se le indica
# Para esto recibe 4 parametros  el archivo original de la exportacion de guarani, el usuario del servuidor remoto que se utiliza para hacer la copia, la ip del servidor y el directorio donde se va a dejar el archivo
# Ej: ./hashear.pl datos.txt pepe 10.10.1.1 home/pepe 
#

# Carga los modulos requeridos
use Digest::MD5 qw(md5_base64);
use MIME::Base64;
use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );

#sub hashearPassword
#recive el pass de guarani en md5 y lo devuelve hasheado en  

sub hashearPassword {
    my ($passMD5)=@_;

    my $passResult  = $passMD5;
    $passResult =~ s/([a-fA-F0-9][a-fA-F0-9])/chr(hex($1))/eg;
    $passResult = encode_base64($passResult);
    $passResult = substr $passResult, 0, -3;
    $passResult = sha256_base64($passResult);
    chomp $passResult;
    return $passResult;
}


sub addSlashes {
    $text = shift;
    ## Make sure to do the backslash first!
    $text =~ s/\\/\\\\/g;
    $text =~ s/'/\\'/g;
    $text =~ s/"/\\"/g;
    $text =~ s/\\0/\\\\0/g;
    return $text;
}

# Abre el archivo cuyo nombre se mando como primer parametro
open(ARCHIVO,$ARGV[0]) || die("El archivo no abre");
open(ARCHIVO2,">salida") || die("El archivo no abre");

# Realiza un loop por cada una de las lineas del archivo
while ($line = <ARCHIVO>) {
	# Arma un arreglo a partir de una linea del archivo
	# Comenzando en el primer caraceter y usando el | como separador de campos
	
	@fields = split '\|',$line;

	@fields =  map { addSlashes($_) }  @fields;
	
	$fields[2]=hashearPassword($fields[2]);
	$linea=join '|',@fields;

	print ARCHIVO2 $linea; 
}
# Fin del while
close ARCHIVO;
close ARCHIVO2;
$usuario=$ARGV[1];
$server=$ARGV[2];
$path=$ARGV[3];
system('scp salida '.$usuario.'@'.$server.':'.$path);
exit;
