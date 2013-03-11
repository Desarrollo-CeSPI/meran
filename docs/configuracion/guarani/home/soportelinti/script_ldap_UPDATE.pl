#!/usr/bin/perl -T -w 
#
# Este script general las entradas ldif a partir de un archivo de texto. Recibe 2 parametros, el 1ero es el archivo de guarani y la rama del arbol de ldap donde se alojaran los usuarios
#

# Carga los modulos requeridos
use Digest::MD5 qw(md5_base64);
use Net::LDAP;
use MIME::Base64;

# Abre el archivo cuyo nombre se mando como primer parametro
open(ARCHIVO,$ARGV[0]) || die("El archivo no abre");
#$/ = "";
#Saca la linea que tiene los nombres de columna
#$line = <ARCHIVO>; 	
my $anterior="";
# Realiza un loop por cada una de las lineas del archivo
#open (L,">arbolLDIF");
# Realiza un loop por cada una de las lineas del archivo
my $db = Net::LDAP->new("localhost");
my $res = $db->bind( 'anonymous', password => '') or die "$@";
while ($line = <ARCHIVO>) {
    # Arma un arreglo a partir de una linea del archivo
    # Comenzando en el primer caraceter y usando el | como separador de campos
    @fields = split '\|',$line;
    # Setea variables correspondientes a los valores del arreglo
    my $uid = $fields[1];
    #my $sn = $fields[3]; 
    #my $givenName = $fields[4];
    my $userPassword = $fields[2];
    #my $localityName = $fields[11];
    #my $postalCode = $fields[12];
    #my $street = $fields[7]." ".$fields[8]." ".$fields[9]." ".$fields[10];
    my %bindargs;
    #print L "Buscando $uid en $ARGV[1].\n";
    my $entries = $db->search(
            base   => "$ARGV[1]",
            filter => "(uid = $uid)"
		);
    unless ($entries->all_entries){
    	#print L "El uid es $uid .\n";
    	#print L "El anteriro es $anterior .\n";
        if ($anterior ne $uid) {
            # Imprime la entrada ldif
            print "dn: uid=$uid,$ARGV[1]\n";
            print  "uid: $uid\n";
            #print "cn: $sn $givenName\n";
            #print "givenName: $givenName\n";
            #print "sn: $sn\n";
            #if ($localityName ne "") {print "l: $localityName\n";}
            #if ($postalCode ne "") {print "postalCode: $postalCode\n";}
            #if ($street ne "") {print "street: $street\n";}
            print  "objectClass: top\n";
            print  "objectClass: account\n";
            print  "objectClass: simpleSecurityObject\n";
            #print "userPassword: ".md5_base64($userPassword)."\n";
            $userPassword =~ s/([a-fA-F0-9][a-fA-F0-9])/chr(hex($1))/eg;
            $string = encode_base64($userPassword);
            $userPassword=substr $string, 0, -3;
            $userPassword = encode_base64($userPassword);
            chomp $userPassword;
            print "userPassword:: ".$userPassword."\n";
            print "structuralObjectClass: account\n";
            print "\n";
            $anterior=$uid;
        }
    }
# Fin del while
}
close ARCHIVO;
#exit;
