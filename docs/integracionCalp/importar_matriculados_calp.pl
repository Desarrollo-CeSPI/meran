#!/usr/bin/perl -w
#
# Este script se usa para generar los inserts y los updates de los datos que se encuentran en el sistema de matriculados de CALP
# para poder incluirlos en la Base de Datos MySql de Meran. 


use lib qw(/usr/local/share/meran/dev/intranet/modules/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl5/);

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
use C4::Modelo::RefLocalidad;
use C4::AR::Utilidades;

sub trim{
    my ($string) = @_;
    if($string){
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
    }
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
    if($text){
        $text =~ s/\\/\\\\/g;
        $text =~ s/'/\\'/g;
        $text =~ s/"/\\"/g;
        $text =~ s/\\0/\\\\0/g;
    }
    return $text;
}



my $db_driver =  "mysql";
my $db_name   = 'calp_matriculas';
my $db_host   = 'db';
my $db_user   = 'root';
my $db_passwd = 'dev';

my $db_calp= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_calp->do('SET NAMES utf8');

my $dbh = C4::Context->dbh;

#Los tipos de documento
my $tipos_de_documento = $dbh->selectall_hashref("SELECT * from usr_ref_tipo_documento", 'nombre');
my $tipos_de_estados =  $dbh->selectall_hashref("SELECT * from usr_estado",'nombre');
#Los tipos de usuarios
my $tipos_de_usuarios=  $dbh->selectall_hashref("SELECT * from usr_ref_categoria_socio",'categorycode');



sub migrarMatriculados {

        my $matriculados_calp=$db_calp->prepare("SELECT people.name,people.lastname,people.document_number,document_types.name as document_type, people.cuit, people.date_of_birth, people.email, people.gender, degrees.name as degree, universities.name as university, enrollments.graduation_date, enrollments.degree_emission_date, enrollments.emission_date, enrollments.file_number, enrollments.volume, enrollments.folio, enrollments.enabled, enrollments.active,enrollments.deleted, addresses.street,addresses.number, addresses.phone_number,cities.name as city, cities.zip_code FROM people left join enrollments on people.id = enrollments.person_id left join degrees on enrollments.degree_id = degrees.id left join universities on universities.id = enrollments.university_id left join document_types on people.document_type_id = document_types.id left join addresses on people.id = addresses.addressable_id left join cities on addresses.city_id = cities.id  where addresses.addressable_type = 'Person' and addresses.tag_for_address = 'real' GROUP BY people.id;");
    $matriculados_calp->execute();

    my ($userPassword,$nro_socio,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$categorycode,$estado);
    my $id_estado = $tipos_de_estados->{'HABILITADO'}->{'id_estado'};
    my $branchcode = 'GL';

    while (my $matriculado=$matriculados_calp->fetchrow_hashref) {

        if($matriculado->{'degree'} eq 'Abogado'){
            $categorycode = 'AB';
        }elsif($matriculado->{'degree'} eq 'Procurador'){
            $categorycode = 'PR';
        }
        my $id_categoria = $tipos_de_usuarios->{$categorycode}->{'id'};  

        # Ingresan con DNI
        $nro_socio = trim(addSlashes($matriculado->{'document_number'}));
        $emailaddress= (trim($matriculado->{'email'}))?trim(addSlashes($matriculado->{'email'})):'NULL';

        #Generamos la pass con el DNI Esto no riría si usamos LDAP
        $userPassword = hashearPassword(md5_hex($matriculado->{'document_number'}));

        $surname = trim(addSlashes($matriculado->{'lastname'}));
        $firstname = trim(addSlashes($matriculado->{'name'}));
        $documenttype =  trim(addSlashes($matriculado->{'document_type'}));
        my $documenttype_id = $tipos_de_documento->{uc($documenttype)}->{'id'};
        $documentnumber = trim(addSlashes($matriculado->{'document_number'}));
        $sex= (trim($matriculado->{'gender'}))?'F':'M';
        $dateofbirth = trim(addSlashes($matriculado->{'date_of_birth'}));

        $streetaddress = (trim(addSlashes($matriculado->{'street'})))?trim(addSlashes($matriculado->{'street'})):'NULL';
        $city = (trim(addSlashes($matriculado->{'city'})))?trim(addSlashes($matriculado->{'city'})):'NULL';
      
        my $ciudad_object = C4::Modelo::RefLocalidad->new();
        my ($ref_cantidad,$ref_valores) = $ciudad_object->getAll(1,0,0,$city);

        if ($ref_cantidad){
          #REFERENCIA ENCONTRADA
            $city =  $ref_valores->[0]->get_key_value;
        }
        else { #no existe la referencia, hay que crearla
          $city = "NULL";
        }


        $zipcode = (trim(addSlashes($matriculado->{'zip_code'})))?trim(addSlashes($matriculado->{'zip_code'})):'NULL';
        $phone = (trim(addSlashes($matriculado->{'phone_number'})))?trim(addSlashes($matriculado->{'phone_number'})):'NULL';
        
        $studentnumber= trim(addSlashes($matriculado->{'file_number'})); # Legajo
        $estado= 'A';
        my $volumen_folio = "TOMO - FOLIO: ".trim(addSlashes($matriculado->{'volume'}))."-".trim(addSlashes($matriculado->{'folio'}));
        print ("INSERT INTO usr_persona (nro_documento, tipo_documento, apellido, nombre, nacimiento, sexo, calle, ciudad,  codigo_postal, telefono, email, legajo, es_socio) values ('$documentnumber','$tipos_de_documento->{uc($documenttype)}->{'id'}','$surname','$firstname','$dateofbirth','$sex','$streetaddress','$city','$zipcode','$phone','$emailaddress','$studentnumber',0);\n");
        print ("INSERT INTO usr_socio (id_persona, id_socio, nro_socio, id_ui, fecha_alta, expira, flags, password, last_login, last_change_password, change_password, cumple_requisito, nombre_apellido_autorizado, dni_autorizado, telefono_autorizado, is_super_user, credential_type, activo, note, agregacion_temp, theme, theme_intra, locale, lastValidation, id_categoria, id_estado, recover_password_hash, client_ip_recover_pwd, recover_date_of, last_auth_method, remindFlag) VALUES ((select id_persona from usr_persona where nro_documento='$documentnumber' and tipo_documento=$tipos_de_documento->{uc($documenttype)}->{'id'} ) , NULL, '$nro_socio', '$branchcode', NOW(), NULL, NULL, '$userPassword' , NOW(), NULL, '1', NOW(), NULL, NULL, NULL, '0', NULL, 0, '$volumen_folio', NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP,$id_categoria,$id_estado , NULL, NULL, NOW(), 'LDAP', '1');\n");
    }
}

migrarMatriculados();
exit 1;
