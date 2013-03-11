#!/usr/bin/perl -T -w
#

# Este script general las entradas ldif a partir de un archivo de texto.
#

# Carga los modulos requeridos
use Digest::MD5 qw(md5_base64);
use Net::LDAP;

# Abre el archivo cuyo nombre se mando como primer parametro
open(ARCHIVO,$ARGV[0]) || die("El archivo no abre");

#Saca la linea que tiene los nombres de columna
#$line = <ARCHIVO>; 	
my $anterior="";
# Realiza un loop por cada una de las lineas del archivo
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
my $db = Net::LDAP->new("localhost");
my $res = $db->bind( 'anonymous', password => '') or die "$@";
my $entries = $db->search(
		base   => "dc=biblio,dc=econo,dc=unlp,dc=edu,dc=ar",
		filter => "(uid = $uid)"
		);
unless ($entries->all_entries){
if ($anterior ne $uid) {
# Imprime la entrada ldif
print "dn: uid=$uid,dc=biblio,dc=econo,dc=unlp,dc=edu,dc=ar\n";
print "uid: $uid\n";
#print "cn: $sn $givenName\n";
#print "givenName: $givenName\n";
#print "sn: $sn\n";
#if ($localityName ne "") {print "l: $localityName\n";}
#if ($postalCode ne "") {print "postalCode: $postalCode\n";}
#if ($street ne "") {print "street: $street\n";}
print "objectClass: top\n";
print "objectClass: account\n";
print "objectClass: simpleSecurityObject\n";
print "userPassword: ".md5_base64($userPassword)."\n";
print "structuralObjectClass: account\n";
print "\n";
$anterior=$uid;
}
}
# Fin del while
}
close ARCHIVO;
exit;
