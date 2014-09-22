#!/usr/bin/perl -w
#
# Este script se usa para generar los inserts y los updates de los datos que se encuentran en Guarani
# para poder incluirlos en la Base de Datos MySql de Meran. 
# El origen de los datos es un archivo de texto que este script recibe como parametro.
# En total el script recibe 5 parametros en el siguiente orden:
# 1 nombreARCHIVOGUARANI
# 2 baseConexion
# 3 usuarioConexion
# 4 passdbConexion
# 5 branchcode
# 6 debug 

# Carga los modulos requeridos
use strict;
use CGI qw(:standard);
use DBI;
use Text::ParseWords;
use Date::Manip::DM5;
use Digest::MD5 qw(md5_base64);
use MIME::Base64;
use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );

=item sub obtenerCategoria
 funcion que recibe dos parametros, el nrodesocio de guarani y el campo 18 
 que identifica si es egresado o estudiante aun, 
 devolviendo como resultado aquella que se considere mas reelevante.
 Esto sirve para resolver a aquellos que son alumnos de mas de una carrera
=cut 


sub obtenerCategoria
{
    my($cardnumber,$categorycode)=@_;
    if($cardnumber =~ /D/) {
        #si tiene una D el documento quiere decir que es Docente
        $cardnumber=~ s/D//g ;
        $categorycode='DO';} 
    else{ 
        if ($categorycode eq 'E') {
            #Es egresado
            $categorycode='EG'; }
        else{
            #Es estudiante
            $categorycode='ES';}
        }
    return($cardnumber, $categorycode);
}

=item sub calcularEntreDosCategorias
 funcion que recibe dos categorias y decide cual es la que vale al compararlas, 
 devolviendo como resultado aquella que se considere mas reelevante.
 Esto sirve para resolver a aquellos que son alumnos de mas de una carrera
 
=cut 


sub calcularEntreDosCategorias
{
    my $aux1;
    my $aux2;
    ($aux1,$aux2)=@_;
    if ($aux1 eq 'DO'|| $aux2 eq 'DO'){ return 'DO';}
    if ($aux1 eq 'EG'|| $aux2 eq 'EG') {return 'EG';}
    return 'ES';
}

sub calcularEstado
{
    #field18 puede ser A= Activo - E= Egresado, N = No activo P=pasivo 
    my ($regular,$field18)=@_;
	my $key='';
    if ($field18 eq 'A') 
        {$key='ACTIVO '}
         elsif($field18 eq 'N')
            {$key='INACTIVO '}
        	elsif($field18 eq 'P')
            	   {$key='PASIVO '}
            	  	else{$key='EGRESADO '}
    if ($regular eq 1) {$key.='REGULAR' }
        else{$key.='IRREGULAR'}
    return $key;
}

#sub calcularEntreEstados
# recibe 2 estados y devuelve el que corresponde entre los 2

sub calcularEntreEstados
{
    #field18 puede ser A= Activo - E= Egresado, N = No activo P=pasivo 
    my ($field18old,$field18new)=@_;
    if ($field18old eq 'E'|| $field18new eq 'E'){ return 'E';}
    if ($field18old eq 'A'|| $field18new eq 'A'){ return 'A';}
    if ($field18old eq 'N'|| $field18new eq 'N'){ return 'N';}
    return 'P';
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

#
# Abre el archivo cuyo nombre se mando como primer parámetro
open(ARCHIVO,$ARGV[0]) || die("El archivo no abre");
#print "\n\nbase $ARGV[1] user $ARGV[2] pass $ARGV[3]";
my $baseConexion=$ARGV[1];
my $usuarioConexion=$ARGV[2];
my $passdbConexion=$ARGV[3];
my $branchcode=$ARGV[4];
my $debug=$ARGV[5];
# Se conecta con la base de datos para determinar si el usuario ya existe
	#DATA SOURCE NAME
	#$dsn = "dbi:mysql:$database:localhost:3306";
	# PERL DBI CONNECT
	#$DBIconnect = DBI->connect($dsn, $user, $pw);

my $dbh = DBI->connect($baseConexion, $usuarioConexion, $passdbConexion);

#Obtengo las referencias que voy a utilizar en el resto del script para no tener que hacerlo cada vez
$dbh->{FetchHashKeyName} = 'NAME_lc';
#Los tipos de documento
my $tipos_de_documento = $dbh->selectall_hashref("SELECT * from usr_ref_tipo_documento", 'nombre');
     # for my $k1 ( sort keys %$tipos_de_documento ) {
      #  print "k1: $k1\n"; }
#Los estados
my $tipos_de_estados=  $dbh->selectall_hashref("SELECT * from usr_estado where fuente='GUARANI'",'nombre');
my $tipos_de_estados_por_id=  $dbh->selectall_hashref("SELECT * from usr_estado where fuente='GUARANI'",'id_estado');
#Los tipos de usuarios
my $tipos_de_usuarios=  $dbh->selectall_hashref("SELECT * from usr_ref_categoria_socio",'categorycode');
#Los tipos de regularidad
my @claves=('usr_estado_id','usr_ref_categoria_id');
#my $tipos_de_regularidad=  $dbh->selectall_hashref("SELECT * from usr_regularidad",\@claves);

my $line;
my @fields;
my $regular=0;
my $anterior='';
my $anterior_dni='';
my $anterior_tipo_doc='';
my $upgrade='';
my ($uuserPassword, $ucardnumber,$usurname,$ufirstname,$udateofbirth,$usex,$ustreetaddress,$ucity,$uzipcode,$uphone,$uemailaddress,$ustudentnumber,$udocumentnumber,$udocumenttype,$uregular,$ucategorycode,$uestado);
my ($userPassword,$cardnumber,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$categorycode,$estado);
my $paso=0;
# Realiza un loop por cada una de las lineas del archivo
if ($debug){open (L,">/tmp/aca");}

while ($line = <ARCHIVO>) {
    # Arma un arreglo a partir de una linea del archivo
    # Comenzando en el primer caraceter y usando el <TAB> como separador de campos
    @fields = split(/\|/,$line);
    # Setea variables correspondientes a los valores del arreglo
    $cardnumber = $fields[1];

   # PASSWORD DE GUARANI, hay que transformarla de md5 
    $userPassword = $fields[2];
    #print "userPassword:: ".$userPassword."\n";

    #Esto es lo que comente para que no rompa los cardnumber con caracteres alfanumericos
    #Los docentes empiezan con D, tal vez habria que pensar en sacarlos directamente para no tener problemas con la oficina de alumnos.
    if ($debug) {print L 'cardnumber'.$cardnumber.'estado '.$fields[18]."\n";}
    ($cardnumber,$categorycode)=&obtenerCategoria($cardnumber,$fields[18]);
    if ($debug) {print L $cardnumber."\n";}
    $surname = $fields[3];
    $firstname = $fields[4];
    $documenttype = ($fields[20] eq '')?'NULL':$fields[20];
    $documentnumber = ($fields[21] eq '')?'NULL':(split(/\./,$fields[21]))[0];
    #IMPORTANTE el valor del DATEFormat debe cambiar segun sea la entrada
    Date_Init("DateFormat=US");
    my $olddate = ParseDate($fields[5]); 
    my $newdate = UnixDate($olddate, '%Y-%m-%d');
    $dateofbirth= ($fields[5] eq '')?'NULL':$newdate;
    $sex= $fields[6];
    $sex =~ tr/12/MF/;
    $streetaddress= "CALLE: ".(($fields[7])?$fields[7]:"-")." NUMERO: ".(($fields[8])?$fields[8]:"-")." PISO: ".(($fields[9])?$fields[9]:"-")." DPTO: ".(($fields[10])?$fields[10]:"-");
    $city= ($fields[12] eq '')?'NULL':$fields[12];
    $zipcode= ($fields[13] eq '')?'NULL':$fields[13];
    $phone= ($fields[14] eq '')?'NULL':$fields[14];
    $emailaddress= ($fields[15] eq '')?'NULL':$fields[15];
    $studentnumber= ($fields[17] eq '')?'NULL':$fields[17];
    $fields[19]=~ tr/SN/10/;
    $estado= $fields[18];
    # CALIDAD $fields[18] A: Activo - E: Egresado - N: No activo ?
    # Ejecuta la consulta para buscar al usuario
    # Si el usuario ya esta hace un UPDATE
    if ($anterior eq $cardnumber){
        $regular= $uregular ||$fields[19];
        $estado= &calcularEntreEstados($uestado,$fields[18]);
        $categorycode=&calcularEntreDosCategorias($ucategorycode,$categorycode);
        ($uuserPassword,$ucardnumber,$usurname,$ufirstname,$udateofbirth,$usex,$ustreetaddress,$ucity,$uzipcode,$uphone,$uemailaddress,$ustudentnumber,$udocumentnumber,$udocumenttype,$uregular,$uestado,$ucategorycode)=($userPassword,$cardnumber,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$regular,$estado,$categorycode);
        $paso=1;
          }
    else{
        if ($anterior ne ""){
            if ($paso eq 0){
                ($uuserPassword,$ucardnumber,$usurname,$ufirstname,$udateofbirth,$usex,$ustreetaddress,$ucity,$uzipcode,$uphone,$uemailaddress,$ustudentnumber,$udocumentnumber,$udocumenttype,$uregular,$uestado,$ucategorycode)=($userPassword,$cardnumber,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$fields[19],$estado,$categorycode);
                $paso=2;
            }#if paso==0
            my $out = $dbh->prepare("SELECT usr_socio.id_estado, usr_socio.id_categoria, usr_socio.id_persona, usr_persona.nro_documento, usr_persona.id_persona, usr_persona.tipo_documento from usr_socio inner join usr_persona on usr_socio.id_persona=usr_persona.id_persona where nro_socio= ? ");#and tipo_documento=?"); 
            $out->execute($anterior);#,$tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'});
            my $id_uestado= $tipos_de_estados->{&calcularEstado($uregular,$uestado)}->{'id_estado'};
            my $id_categoria=$tipos_de_usuarios->{$ucategorycode}->{'id'};               
#          for my $k1 ( sort keys %$tipos_de_regularidad ) {
#        print "k1: $k1\n"; }

            if ($out->rows) {
                my $datos=$out->fetchrow_hashref;
		if ( ($datos->{'id_estado'} ne $id_uestado) or ($datos->{'id_categoria'} ne $id_categoria)){
	               print("UPDATE usr_socio SET id_estado= $id_uestado, id_categoria=$id_categoria where id_persona=$datos->{'id_persona'} ;\n");
		}	
 		if( ($datos->{'nro_documento'} ne $anterior_dni) or ($datos->{'tipo_documento'} ne $tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'}))
		{
                #El estado calculado no es igual al que estaba
                #Hay que ver si el tipo es automatico
	               print("UPDATE usr_persona SET tipo_documento=$tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'}, nro_documento='$anterior_dni' where id_persona=$datos->{'id_persona'} ;\n");
                }
                }
            else{#no existe lo tengo que agregar ACA voy
	#print ("UPDATE usr_socio set nro_socio='".$udocumentnumber."' where id_persona=(select id_persona from usr_persona where nro_documento='".$udocumentnumber."');\n");
	#print L $ucardnumber."\n";
                my $out2 = $dbh->prepare("select * from usr_persona where nro_documento=? and tipo_documento=?");
                $out2->execute($udocumentnumber,$tipos_de_documento->{uc($udocumenttype)}->{'id'});#,$tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'});
                if (! $out2->rows ){
                    print ("INSERT INTO usr_persona (nro_documento, tipo_documento, apellido, nombre, nacimiento, sexo, calle, ciudad,  codigo_postal, telefono, email, legajo, es_socio) values ('$udocumentnumber','$tipos_de_documento->{uc($udocumenttype)}->{'id'}','$usurname','$ufirstname','$udateofbirth','$usex','$ustreetaddress','$ucity','$uzipcode','$uphone','$uemailaddress','$ustudentnumber',0);\n");
                }
                    print ("INSERT INTO usr_socio (id_persona, id_socio, nro_socio, id_ui, fecha_alta, expira, flags, password, last_login, last_change_password, change_password, nombre_apellido_autorizado, dni_autorizado, telefono_autorizado, is_super_user, credential_type, activo, note, agregacion_temp, theme, theme_intra, locale, lastValidation, id_categoria, id_estado, recover_password_hash, client_ip_recover_pwd, recover_date_of, last_auth_method, remindFlag) VALUES ((select id_persona from usr_persona where nro_documento='$udocumentnumber' and tipo_documento=$tipos_de_documento->{uc($udocumenttype)}->{'id'} ) , NULL, '$anterior', '$branchcode', NOW(), NULL, NULL, '$uuserPassword' , NOW(), NULL, '0', NULL, NULL, NULL, '0', NULL, 0, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP,$id_categoria,$id_uestado , NULL, NULL, NOW(), 'mysql', '1');\n");
            } #else
            if ($paso){
                ($uuserPassword,$ucardnumber,$usurname,$ufirstname,$udateofbirth,$usex,$ustreetaddress,$ucity,$uzipcode,$uphone,$uemailaddress,$ustudentnumber,$udocumentnumber,$udocumenttype,$uregular,$uestado,$ucategorycode)=($userPassword,$cardnumber,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$fields[19],$estado,$categorycode);
            } #if $paso
        }#if anterior ne ""
        else{
        ($uuserPassword, $ucardnumber,$usurname,$ufirstname,$udateofbirth,$usex,$ustreetaddress,$ucity,$uzipcode,$uphone,$uemailaddress,$ustudentnumber,$udocumentnumber,$udocumenttype,$uregular,$uestado,$ucategorycode)=($userPassword,$cardnumber,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$fields[19],$estado,$categorycode);
        $paso=1;
        }
    }
    $anterior=$cardnumber;
    $anterior_dni=$documentnumber;
    $anterior_tipo_doc=$documenttype;

}#while
if ($anterior eq $cardnumber){
	$regular= $regular ||$uregular;
	$estado= &calcularEntreEstados($uestado,$fields[18]);
	$categorycode=&calcularEntreDosCategorias($ucategorycode,$categorycode);

}
($uuserPassword, $ucardnumber,$usurname,$ufirstname,$udateofbirth,$usex,$ustreetaddress,$ucity,$uzipcode,$uphone,$uemailaddress,$ustudentnumber,$udocumentnumber,$udocumenttype,$uregular,$uestado,$ucategorycode)=($userPassword,$cardnumber,$surname,$firstname,$dateofbirth,$sex,$streetaddress,$city,$zipcode,$phone,$emailaddress,$studentnumber,$documentnumber,$documenttype,$regular,$estado,$categorycode);

            my $out = $dbh->prepare("select usr_socio.id_estado, usr_socio.id_categoria, usr_socio.id_persona, usr_persona.nro_documento, usr_persona.id_persona, usr_persona.tipo_documento from usr_socio inner join usr_persona on usr_socio.id_persona=usr_persona.id_persona where nro_socio= ? ");#and tipo_documento=?"); 
            $out->execute($anterior);#,$tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'});
            my $id_uestado= $tipos_de_estados->{&calcularEstado($uregular,$uestado)}->{'id_estado'};
            my $id_categoria=$tipos_de_usuarios->{$ucategorycode}->{'id'};               
#          for my $k1 ( sort keys %$tipos_de_regularidad ) {
#        print "k1: $k1\n"; }

            if ($out->rows) {
                my $datos=$out->fetchrow_hashref;
                if ( ($datos->{'id_estado'} ne $id_uestado) or ($datos->{'id_categoria'} ne $id_categoria)){
                        print("UPDATE usr_socio SET id_estado= $id_uestado, id_categoria=$id_categoria where id_persona=$datos->{'id_persona'} ;\n");
        }       
                if( ($datos->{'nro_documento'} ne $anterior_dni) or ($datos->{'tipo_documento'} ne $tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'}))
                {
                #El estado calculado no es igual al que estaba
                #Hay que ver si el tipo es automatico
                        print("UPDATE usr_persona SET tipo_documento=$tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'}, nro_documento='$anterior_dni' where id_persona=$datos->{'id_persona'} ;\n");

		}

	}#si no hay filas	
	else{#no existe lo tengo que agregar
	#print ("UPDATE usr_socio set nro_socio='".$udocumentnumber."' where id_persona=(select id_persona from usr_persona where nro_documento='".$udocumentnumber."');\n");
	#print L $ucardnumber."\n";
        my $out2 = $dbh->prepare("select * from usr_persona where nro_documento=? and tipo_documento=?");
        $out2->execute($udocumentnumber,$tipos_de_documento->{uc($udocumenttype)}->{'id'});#,$tipos_de_documento->{uc($anterior_tipo_doc)}->{'id'});
         if (! $out2->rows ){
            print ("INSERT INTO usr_persona (nro_documento,tipo_documento, apellido, nombre, nacimiento, sexo, calle, ciudad,  codigo_postal, telefono, email, legajo, es_socio) values ('$udocumentnumber',$tipos_de_documento->{uc($udocumenttype)}->{'id'},'$usurname','$ufirstname','$udateofbirth','$usex','$ustreetaddress','$ucity','$uzipcode','$uphone','$uemailaddress','$ustudentnumber',0);\n");
        }
            print ("INSERT INTO usr_socio (id_persona, id_socio, nro_socio, id_ui, fecha_alta, expira, flags, password, last_login, last_change_password, change_password,  nombre_apellido_autorizado, dni_autorizado, telefono_autorizado, is_super_user, credential_type, activo, note, agregacion_temp, theme, theme_intra, locale, lastValidation, id_categoria, id_estado, recover_password_hash, client_ip_recover_pwd, recover_date_of, last_auth_method, remindFlag) VALUES ((select id_persona from usr_persona where nro_documento='$udocumentnumber' and tipo_documento=$tipos_de_documento->{uc($udocumenttype)}->{'id'} ) , NULL, '$anterior', '$branchcode', NOW(), NULL, NULL, '$uuserPassword' , NOW(), NULL, '0', NULL, NULL, NULL, '0', NULL, 0, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, $id_categoria, $id_uestado , NULL, NULL, NOW(), 'mysql', '1');\n");
		}
	
# Si el usuario no esta hace un INSERT

# fin del if
#}
#close L;
# fin del while
#exit 1;
