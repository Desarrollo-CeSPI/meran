#!/usr/bin/perl -w
#
# Este script se usa para generar los inserts y los updates de los datos que se encuentran en Kimkelen
# para poder incluirlos en la Base de Datos MySql de Meran. 
# El origen de los datos es un archivo de texto que este script recibe como parametro.
# En total el script recibe 2 parametros en el siguiente orden:
# 1 archivo a importar xls
# 2 tipo_usuarios (1 = docentes, 2 = alumnos)
# 3 Código de la Unidad de Información 

# Carga los modulos requeridos
use strict;
use CGI qw(:standard);
use DBI;
use Text::ParseWords;
use Date::Manip::DM5;
use Digest::MD5 qw(md5_hex md5_base64);
use MIME::Base64;
use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );
use C4::Context;
use Spreadsheet::Read;


sub trim{
    my ($string) = @_;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;

    return $string;
}

#sub hashearPassword
#recive el pass de guarani en md5 y lo devuelve hasheado en  

sub hashearPassword 
{
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
    my ($text) = @_;
    ## Make sure to do the backslash first!
    $text =~ s/\\/\\\\/g;
    $text =~ s/'/\\'/g;
    $text =~ s/"/\\"/g;
    $text =~ s/\\0/\\\\0/g;
    return $text;
}



my $categoriaUsuarios=$ARGV[1];
my $branchcode=$ARGV[2];
my $dbh = C4::Context->dbh;


$dbh->{FetchHashKeyName} = 'NAME_lc';
#Los tipos de documento
my $tipos_de_documento = $dbh->selectall_hashref("SELECT * from usr_ref_tipo_documento", 'nombre');
my $tipos_de_estados =  $dbh->selectall_hashref("SELECT * from usr_estado",'nombre');
#Los tipos de usuarios
my $tipos_de_usuarios=  $dbh->selectall_hashref("SELECT * from usr_ref_categoria_socio",'categorycode');


my $ref = Spreadsheet::Read::ReadData($ARGV[0]);
my @rows = Spreadsheet::Read::rows($ref->[1]);


my ($userPassword,$nro_socio,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$categorycode,$estado);

foreach my $fila (@rows){

    if ($categoriaUsuarios == 1) {
        #Los docentes tienen usuario en el sistema
        if ($fila->[5]){
            $nro_socio = trim(addSlashes($fila->[5]));
        }
        else{
            $nro_socio = trim(addSlashes($fila->[3]));
        }

        $categorycode = 'DO'
    } 
    else {
        # Los alumnos ingresan con DNI
        $nro_socio = trim(addSlashes($fila->[3]));
        $categorycode = 'ES'
    }
    my $id_estado= $tipos_de_estados->{'HABILITADO'}->{'id_estado'};
    my $id_categoria= $tipos_de_usuarios->{$categorycode}->{'id'};   

    $emailaddress= (trim($fila->[4]) eq '')?'NULL':trim(addSlashes($fila->[4]));

    #Generamos la pass con el DNI 

    $userPassword = hashearPassword(md5_hex($fila->[3]));
    $surname = trim(addSlashes($fila->[0]));
    $firstname = trim(addSlashes($fila->[1]));
    $documenttype =  $fila->[2];
    $documentnumber = trim(addSlashes($fila->[3]));
    $streetaddress='NULL';
    $city= 'NULL';
    $sex= 'NULL';
    $dateofbirth = 'NULL';
    $zipcode= 'NULL';
    $phone= 'NULL'; 
    $studentnumber= 'NULL'; # Legajo
    $estado= 'A';

    if ($nro_socio && $documentnumber) {
        my $existe = $dbh->prepare("SELECT usr_socio.id_estado, usr_socio.id_categoria, usr_socio.id_persona, usr_persona.nro_documento, usr_persona.id_persona, usr_persona.tipo_documento from usr_socio inner join usr_persona on usr_socio.id_persona=usr_persona.id_persona where nro_socio= ? ");#and tipo_documento=?"); 
        $existe->execute($nro_socio); 


        my $existe_persona = $dbh->prepare("select * from usr_persona where nro_documento=? and tipo_documento=?");
           $existe_persona->execute($documentnumber,$tipos_de_documento->{uc($documenttype)}->{'id'});#,$tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'});
            if (! $existe_persona->rows ){
                print ("INSERT INTO usr_persona (nro_documento, tipo_documento, apellido, nombre, nacimiento, sexo, calle, ciudad,  codigo_postal, telefono, email, legajo, es_socio) values ('$documentnumber','$tipos_de_documento->{uc($documenttype)}->{'id'}','$surname','$firstname','$dateofbirth','$sex','$streetaddress','$city','$zipcode','$phone','$emailaddress','$studentnumber',0);\n");
            }
                print ("INSERT INTO usr_socio (id_persona, id_socio, nro_socio, id_ui, fecha_alta, expira, flags, password, last_login, last_change_password, change_password, cumple_requisito, nombre_apellido_autorizado, dni_autorizado, telefono_autorizado, is_super_user, credential_type, activo, note, agregacion_temp, theme, theme_intra, locale, lastValidation, id_categoria, id_estado, recover_password_hash, client_ip_recover_pwd, recover_date_of, last_auth_method, remindFlag) VALUES ((select id_persona from usr_persona where nro_documento='$documentnumber' and tipo_documento=$tipos_de_documento->{uc($documenttype)}->{'id'} ) , NULL, '$nro_socio', '$branchcode', NOW(), NULL, NULL, '$userPassword' , NOW(), NULL, '1', NOW(), NULL, NULL, NULL, '0', NULL, 0, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP,$id_categoria,$id_estado , NULL, NULL, NOW(), 'mysql', '1');\n");
    }
}

exit 1;
