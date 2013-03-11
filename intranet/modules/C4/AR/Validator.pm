package C4::AR::Validator;


=item
################################### About PM ######################################################
Author: Gaspar Rajoy
Version: 3.0 (Meran)
Synopsis:   Este PM tiene como fin contener todas las funciones que estén dedicadas a validar
            algún patrón específico sobre un string (generalmente). Si se cree que se puede
            contener alguna otra función que valide otro tipo de dato, y ésta ultima se utiliza
            en diferentes modulos, se incluye
################################## END About PM ####################################################
=cut
use strict;
use C4::AR::Utilidades qw(validateString trim);
use C4::AR::Address;
use C4::AR::MailChecker;
#EINAR use CGI::Session;

use vars qw(@EXPORT @ISA);

@ISA=qw(Exporter);
@EXPORT=qw( 
    checkPassword,
    checkLength,
    countUpperChars,
    countLowerChars,
    countNumericChars,
    countAlphaNumericChars,
    countAlphaChars,
    countSymbolChars,
    isValidReal,
    isValidMail,
    isValidDocument
    validateParams
    checkParams
    validateObjectInstance
  
);



################################# FUNCIONES PARA PASSSWORD ########################

=item
    Funcion que cuenta la cantidad de caracteres en mayuscula
    de un string, al cual recibe como parametro.
=cut
sub countUpperChars{

    my($string)=@_;
    my($stringLength)=length($string);
    my($count)=0;
    my($fragment);
    my $charCount;

    for ($charCount = 0; $charCount < $stringLength; $charCount += 1) {
        $fragment = substr $string,$charCount,1;
        if ($fragment =~ tr/A-Z//){
        $count++;
    }
    }
    return $count;
}

=item
    Funcion que cuenta la cantidad de caracteres en minuscula 
    de un string, al cual recibe como parametro.
=cut
sub countLowerChars{

    my($string)=@_;
    my($stringLength)=length($string);
    my($count)=0;
    my($fragment);
    my $charCount=0;
    for ($charCount = 0; $charCount < $stringLength; $charCount += 1) {
        $fragment = substr $string,$charCount,1;
        if ($fragment =~ tr/a-z//){
            $count++;
        }
    }
    return $count;
}

=item
    Funcion que cuenta la cantidad de caracteres numericos 
    de un string, al cual recibe como parametro.
=cut
sub countNumericChars{

    my($string)=@_;
    my $stringLength=length($string);
    my $count=0;
    my $fragment;
    my $charCount;

    for ($charCount = 0; $charCount < $stringLength; $charCount += 1) {
        $fragment = substr $string,$charCount,1;
        if ($fragment =~ tr/0-9//){
            $count++;
        }
    }
    return $count;
}


=item
    Funcion que cuenta la cantidad de caracteres alfanumericos 
    de un string, al cual recibe como parametro.
=cut
sub countAlphaNumericChars{

    my($string)=@_;
    my($stringLength)=length($string);
    my($count)=0;
    my($fragment);
    my $charCount=0;

    for ($charCount = 0; $charCount < $stringLength; $charCount += 1) {
        $fragment = substr $string,$charCount,1;
        if (($fragment =~ tr/a-z//) 
                or 
            ($fragment =~ tr/A-Z//) 
                or 
            ($fragment =~ tr/0-9//)
                or 
            ($fragment =~ tr/\-//)
            
            ){

                $count++;
            }
    }
    return $count;
}

=item
    Funcion que cuenta la cantidad de caracteres alfabeticos 
    de un string, al cual recibe como parametro.
=cut
sub countAlphaChars{

    my($string)=@_;
    my($stringLength)=length($string);
    my($count)=0;
    my($fragment);
    my $charCount=0;
    for ($charCount = 0; $charCount < $stringLength; $charCount += 1) {
        $fragment = substr $string,$charCount,1;
        if (($fragment =~ tr/a-z//)
                or 
            ($fragment =~ tr/A-Z//)){
                $count++;
            }
    }
    return $count;
}

# FIXME------------------------------------------------------

sub isValidReal{
    my ($real)=@_;
    my @parts= split(/\./,$real);
    if (scalar(@parts) > 2){
        return 0;
    } else {
            if (countSymbolChars(@parts[0])!= 0 || countSymbolChars(@parts[0])!= 0){
                return 0;
            }
    }
    return 1;
}


=item
    Funcion que cuenta la cantidad de simbolos 
    de un string, al cual recibe como parametro.
=cut
sub countSymbolChars{

    my($string)=@_;
    my($stringLength)=length($string);
    my($count)=0;
    my($fragment);
    my $charCount=0;
    for ($charCount = 0; $charCount < $stringLength; $charCount += 1) {
        $fragment = substr $string,$charCount,1;
        if ($fragment =~ tr/#-.//){
            $count++;
        }
    }
    return $count;
}

=item
    Funcion que cuenta la cantidad de caracteres
    de un string, al cual recibe como parametro.
=cut
sub checkLength{

    my($string,$min_length)=@_;

    if (length($string) >= $min_length) {
        return 1;
    }
    return 0;
}


=item
    Funcion que checkea que un password cumpla con todo lo anterior,
    especificado segun la db.
=cut
sub checkPassword{

    my($password)=@_;
    C4::AR::Debug::debug("password en checkPassword : " . $password);
    my $msg_object=C4::AR::Mensajes::create();

    if (!(C4::AR::Utilidades::validateString($password))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U314', 'params' => []} ) ;
        return ($msg_object);
    }

    if (!(&checkLength($password, C4::AR::Preferencias::getValorPreferencia('minPassLength')))) {
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U316', 'params' => []} ) ;
        return ($msg_object);
    }

    if (!(&countSymbolChars($password) >= C4::AR::Preferencias::getValorPreferencia('minPassSymbol'))) {
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U319', 'params' => []} ) ;
        return ($msg_object);
    }

    if (!(&countAlphaNumericChars($password) >= C4::AR::Preferencias::getValorPreferencia('minPassAlphaNumeric'))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U324', 'params' => []} ) ;
        return ($msg_object);
    }

    if (!(&countAlphaChars($password) >= C4::AR::Preferencias::getValorPreferencia('minPassAlpha'))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U325', 'params' => []} ) ;
        return ($msg_object);
    }

    if (!(&countNumericChars($password) >= C4::AR::Preferencias::getValorPreferencia('minPassNumeric'))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U326', 'params' => []} ) ;
        return ($msg_object);
    }

    if (!(&countLowerChars($password) >= C4::AR::Preferencias::getValorPreferencia('minPassLower'))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U327', 'params' => []} ) ;
        return ($msg_object);
    }

    if (!(&countUpperChars($password) >= C4::AR::Preferencias::getValorPreferencia('minPassUpper'))){
        $msg_object->{'error'}= 1;
        C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'U328', 'params' => []} ) ;
        return ($msg_object);
    }

    return ($msg_object);
}

# FIXME podria reutilizarse todas, porque recibe el pattern como parametro ;) 
# sub checkPattern{
# 
# 	my($string,$pattern)=@_;
# 	my($stringLength)=length($string);
# 	my($count)=0;
# 	my($fragment);
# 	my $charCount=0; 
#  	foreach $specificPattern $pattern {
# 		for ($charCount = 0; $charCount < $stringLength; $charCount += 1) {
# 			$fragment = substr $string,$charCount,1;
# 			if ($string =~ tr/$specificPattern/){
# 				$count++;
# 			}
# 		}
#     	}
# }

################################# FIN FUNCIONES PARA PASSSWORD ########################

=item sub toValidDate
    toma una fecha (valida o invalida) y la pasa a fecha valida
=cut
sub toValidDate {
    my $date = shift;


    use DateTime::Format::DateManip; 
    my $dt = DateTime::Format::DateManip->parse_datetime( Date::Manip::ParseDate($date));
#     C4::AR::Debug::debug("isValidDate 1ero!!!!!!!!!!!!! ".$dt);
    $date = C4::Date::format_date($date, 'metric');
#     C4::AR::Debug::debug("dateeeeeee formated ".$date);

    return $date;
}


################################# FUNCIONES PARA MAIL ##################################

=item
    Funcion que checkea que una direccion de mail cumpla con un patron estandar
    para mail address. recibe un unico string.
=cut
sub isValidMail{

    my ($address) = @_;

    return C4::AR::MailChecker::valid($address);
}

################################# FIN FUNCIONES PARA MAIL ##################################

=item
    Funcion que valida que un numero de documento sea valido; recibe por parametro el tipo y el numero (en ese orden).
    para los que no son de tipo dni, se comprueba solo que la longitud en caracteres numericos sea igual a la longitud total.
=cut
sub isValidDocument {

    my($docType,$docNumber) = @_;
    my($checkResult) = 0;
    $docType    = C4::AR::Utilidades::trim($docType);
    $docNumber  = C4::AR::Utilidades::trim($docNumber);
    
    if (countAlphaNumericChars($docNumber) == (length($docNumber)) ){
        $checkResult = 1;
    }

    return ($checkResult);
}

=item
    Funcion para validar que la hash de parametros (formato ISO) pasada contenga, en todas las key que indique array_params_name, un string valido
    Parametros:
                HASH (1): conteniendo la hash con los parametros y sus valores
                ARRAY (2): conteniendo solo las keys que hay que checkear
=cut
sub validateParams {
	my ($cod_msg,$params_hash_ref,$array_params_name) = @_;

    my $flag = ($params_hash_ref != 0);
    if ($flag){
        foreach my $nombreParam (@$array_params_name){
            $flag = $flag && C4::AR::Utilidades::validateString($params_hash_ref->{$nombreParam}) && (uc($params_hash_ref->{$nombreParam}) ne "SIN SELECCIONAR");
#             C4::AR::Debug::debug("Analizando ".$nombreParam." valor ".$params_hash_ref->{$nombreParam}." , con resultado ".$flag);
        }
    }

    if (!$flag){
        C4::AR::Auth::redirectAndAdvice($cod_msg);
    }

}

sub checkParams {
    my ($cod_msg,$params_hash_ref,$array_params_name) = @_;

    my $flag = ($params_hash_ref != 0);
    if ($flag){
        foreach my $nombreParam (@$array_params_name){
            $flag = $flag && C4::AR::Utilidades::validateString($params_hash_ref->{$nombreParam});

            #SOLO PARA DEBUG, QUITAR EN PRODUCCION
            (!$flag) && C4::AR::Debug::debug("Error en (checkParams) ".$nombreParam);
            
            if (!(C4::AR::Utilidades::validateString($params_hash_ref->{$nombreParam}))){
                $params_hash_ref->{$nombreParam} = "";
            }
        }
    }
    return $flag;
}

sub validateObjectInstance{

    my ($object) = @_;
    my $session = CGI::Session->new();

    if ( (!$object) || ($object == 0) ){
        C4::AR::Auth::print_header($session);
        print 0;
        exit;
    }
}

END { }       # module clean-up code here (global destructor)

1;
__END__
