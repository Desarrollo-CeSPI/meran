package C4::AR::Utilidades;

#Este modulo provee funcionalidades varias sobre las tablas de referencias en general, ademas de funciones que sirven como
#apoyo a la funcionalidad de Meran. No existe una division clara de lo que incluye y lo que no, por lo tanto resta leer los comentarios de
#cada funcion.
#Escrito el 8/9/2006 por einar@info.unlp.edu.ar
#Update por Carbone Migue, Rajoy Gaspar
#
#Copyright (C) 2003-2006  Linti, Facultad de Informática, UNLP

use strict;
require Exporter;

use C4::AR::Referencias;

use C4::AR::ControlAutoridades;
use C4::Date;
use Encode;
use HTML::Entities;
use POSIX qw(ceil floor);
use JSON;
use C4::AR::Preferencias;
use C4::AR::PedidoCotizacion;
use C4::AR::Filtros;
use URI::Escape;
use File::Copy;
use C4::Modelo::RefLocalidad;
use MARC::Record;

# FIXME Matiasp: Comentado por error de carga de modulos (Attempt to reload %s aborted.)
# use C4::AR::Presupuestos;
# use C4::AR::PedidoCotizacion;

#Einar use Digest::SHA  qw(sha1 sha1_hex sha1_base64 sha256_base64 );

use vars qw(@EXPORT_OK @ISA);
@ISA=qw(Exporter);
@EXPORT_OK=qw(
    generarComboCategoriasDeSocioConCodigoCat
    generarComboCategoriasDeSocio
    setHeaders
    generarComboPresupuestos
    generarComboProveedoresMultiple
    generarComboFormasDeEnvio
    generarComboTipoDeMaterial
    monedasAutocomplete
    ASCIItoHEX
    aplicarParches
    obtenerParches
    obtenerTiposDeColaboradores
    obtenerReferencia
    obtenerTemas
    obtenerEditores
    noaccents
    saveholidays
    getholidays
    savedatemanip
    obtenerValores
    actualizarCampos
    buscarTablasdeReferencias
    listadoTabla
    obtenerCampos
    valoresTabla
    tablasRelacionadas
    valoresSimilares
    asignar
    obtenerDefaults
    guardarDefaults
    mailDeUsuarios
    obtenerAutores
    obtenerPaises
    crearComponentes
    obtenerTemas2
    obtenerBiblios
    verificarValor
    cantidadRenglones
    armarPaginas
    crearPaginador
    InitPaginador
    from_json_ISO
    UTF8toISO
    obtenerIdentTablaRef
    obtenerValoresTablaRef
    obtenerValoresAutorizados
    obtenerDatosValorAutorizado
    cambiarLibreDeuda
    checkdigit
    checkvalidisbn
    quitarduplicados
    trim
    validateString
    joinArrayOfString
    buscarLenguajes
    buscarSoportes
    buscarNivelesBibliograficos
    getNivelBibliograficoByCode
    generarComboTipoPrestamo
    generarComboDeSocios
    generarComboPermisos
    generarComboPerfiles
    generarComboNivel2
    generarComboTipoDeOperacion
    generarComboDeEstados
    existeInArray
    paginarArreglo
    capitalizarString
    ciudadesAutocomplete
    catalogoAutocomplete
    redirectAndAdvice
    generarComboDeAnios
    generarComboDeCredentials
    generarComboTemasOPAC
    generarComboTemasINTRA
    generarComboRecomendaciones
    generarComboPedidosCotizacion
    generarComboTipoPermisos
    getFeriados
    bbl_sort
    createSphinxInstance
    getSphinxMatchMode
    getToday
    dateDiff
    generarComboEstantes
    generarComboTipoDeDocConValuesIds
    isValidFile
    escapeURL
    getUrlPrefix
    getUrlOpac
    addParamToUrl
    escapeHashData
    armarIniciales
    generarComboCamposPersona
    str_replace
    generarComboTablasDeReferenciaByNombreTabla
    serverName
    translateTipoCredencial
    translateYesNo_fromNumber
    translateYesNo_toNumber
    printAjaxPercent
    checkFileMagic
    isnan
);


# para los combos que no usan tablas de referencia
my @VALUES_COMPONENTS = (   "-1", "text", "texta", "combo", "auto", "calendar" );
my %LABELS_COMPONENTS = (   "-1"            => C4::AR::Filtros::i18n("SIN SELECCIONAR"),
                            "text"          => C4::AR::Filtros::i18n("Texto simple"),
                            "texta"         => C4::AR::Filtros::i18n("Texto ampliado"),
                            "combo"         => C4::AR::Filtros::i18n("Lista desplegable"),
                            "auto"          => C4::AR::Filtros::i18n("Autocompletable"),
                            "calendar"      => C4::AR::Filtros::i18n("Calendario"),
                            # "anio"          => C4::AR::Filtros::i18n("Anual"),
                            # "rango_anio"    => C4::AR::Filtros::i18n("Anual rango")
                        );



sub isnan { return (!defined( $_[0] <=> 9**9**9 )) }

=item
    Crea un radio button para bootstrap
=cut
sub crearRadioButtonBootstrap{

    my ($id,$values,$labels,$valor) = @_;

    my $radio   = '<div id="radios_' . $id . '" class="btn-group" data-toggle="buttons-radio">';

    my $i       = 0;

    foreach my $label (@$labels){

        #es la seleccionada
        if(@$values[$i] eq $valor){
            $radio = $radio . '<button type="button" class="btn btn-primary active">' . $label . '</button>';
        }else{
            $radio = $radio . '<button type="button" class="btn btn-primary">' . $label . '</button>';
        }

        $i++;
        
    }

    $radio = $radio . '</div>';

    #agrego un input hidden para poder agarrar en el POST del form el valor del radio
    $radio = $radio . '<input type="hidden" id="' . $id . '" name="' . $id . '"value="">';

    return $radio;
}

=item
    Recibe un archivo y devuelve el magic number.
    Tambien recibe un array con los tipos de archivos permitidos.
    Lo escribe en /temp para esto.
    Si no es del tipo permitido lo borra y devuelve 0.
    En cambio, si es correcto devuelve el tipo del archivo.
    Tambien devuelve si el archivo hay que escribirlo en modo binario o no.
=cut
sub checkFileMagic{

    my ($file, @filesAllowed) = @_;

    use File::LibMagic;
    
    my $flm         = File::LibMagic->new();
    my $hash_unique = Digest::MD5::md5_hex(localtime());   
    my $path        = "/tmp";
    my $notBinary   = 0;

    #escribimos el archivo
    open ( FILE_TO_CHECK, ">$path/$hash_unique" ) or die "$!"; 
    binmode FILE_TO_CHECK; 
    while ( <$file> ) { 
    	print FILE_TO_CHECK; 
    }
    close(FILE_TO_CHECK);
    
    my $mime    = $flm->checktype_filename($path . "/" . $hash_unique);
    
    #el archivo vino en binario, hay que escribirlo de otra forma
    if($mime =~ m/application\/x-empty; charset=binary/i){
    
        #indicamos que hay que escribirlo sin modo binario
        $notBinary = 1;
        #borramos el archivo y lo escribimos de nuevo
        unlink($path . "/" . $hash_unique);
    
        open(FILE_TO_CHECK, ">$path/$hash_unique") or die "Cant write to $path/$hash_unique. Reason: $!";
            print FILE_TO_CHECK $file;
        close(FILE_TO_CHECK);
    
    }
    
    $mime    = $flm->checktype_filename($path . "/" . $hash_unique);

    #vemos si esta en la whitelist
    my $ok      = 0;
    my $type    = '';
    
    foreach my $t (@filesAllowed){

        C4::AR::Debug::debug("mime del archivo : " . $mime . " type : " . $t);

        if($mime =~ m/$t/i) {
            $ok = 1;
            $type = $t;
            
        }
    
    }
    
    unlink($path . "/" . $hash_unique);
    
    if (!$ok){
        C4::AR::Debug::debug("el tipo de archivo no estaba en la whitelist");
        #no esta, borramos el archivo y devolvemos 0
        return 0;
    
    }
    
    return ($type,$notBinary); 

}



=item
    Devuelve el nombre del servidor.
=cut
sub serverName{

   return (C4::AR::Preferencias::getValorPreferencia('serverName'));

}

=item
    Genera un combo con los campos que tiene una persona, de usr_persona
=cut
sub generarComboCamposPersona{
    my ($params) = @_;

    use CGI::Session;

    my @select_campos_array;
    my %select_campos_hash;
    my ($categorias_array_ref)  = C4::AR::Referencias::obtenerCategoriaDeSocio();
    my $session                 = CGI::Session->load();
    my $persona                 = C4::AR::Usuarios::getSocioInfoPorNroSocio($session->param('nro_socio'));

    my $campos_persona          = C4::Modelo::UsrPersona::Manager->get_usr_persona(
                                                query => [ id_persona  => { eq => $persona->getId_persona() } ],
    );

    my %hash = @$campos_persona[0];

    foreach my $campo (@$campos_persona) {
        while (my ($key,$value) = each(%$campo)) {
                push(@select_campos_array, $key);
                $select_campos_hash{$key} = $key;
        }
    }

    shift(@select_campos_array);

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'} || 'campos_persona';
    $options_hash{'id'}         = $params->{'id'} || 'campos_persona';
    $options_hash{'size'}       = $params->{'size'} || 1;
    $options_hash{'multiple'}   = $params->{'multiple'} || 0;
    $options_hash{'defaults'}   = $params->{'default'} || "";

    push (@select_campos_array, '');
    $select_campos_hash{''}     = "SIN SELECCIONAR";
    $options_hash{'values'}     = \@select_campos_array;
    $options_hash{'labels'}     = \%select_campos_hash;

    my $comboDeCamposPersona    = CGI::scrolling_list(\%options_hash);

    return $comboDeCamposPersona;
}

=item
    Devuelve los headers con aplicacion y nombre de archivo recibidos por parametros
    parametros: HASH (para que se pueda extender)
=cut
sub setHeaders{
    my ($params)        = @_;

    my ($filename)      = $params->{'file_name'};
    my ($aplication)    = $params->{'aplicacion'};

    $filename           = $filename || "presupuesto_export.xls";
    $aplication         = $aplication || "application/vnd.ms-excel";

    my $session         = CGI::Session->load();
    my $header          = $session->header( -type => $aplication, -attachment => $filename );

    return ($header);
}


=item sub getStringFor
    Devuelve el texto de la clave pasada por parametro
=cut
sub getStringFor{
    my ($key) = @_;

    if(defined $LABELS_COMPONENTS{$key}){
        return C4::AR::Filtros::i18n($LABELS_COMPONENTS{$key});
    }else{
        return "INDEFINIDO";
    }
}

sub generarComboComponentes{
    my ($params) = @_;


    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}           = $params->{'name'}||'disponibilidad_name';
    $options_hash{'id'}             = $params->{'id'}||'tipo_input';
    $options_hash{'size'}           = $params->{'size'}||1;
    $options_hash{'multiple'}       = $params->{'multiple'}||0;
    $options_hash{'defaults'}       = $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultComboComponentes");
    $options_hash{'values'}         = \@VALUES_COMPONENTS;
    $options_hash{'labels'}         = \%LABELS_COMPONENTS;

    my $comboDeComponentes          = CGI::scrolling_list(\%options_hash);

    return $comboDeComponentes;
}

=item
crearComponentes
Crea los componentes que van a ir al tmpl.
$tipoInput es el tipo de componente que se va a crear en el tmpl.
$id el id del componente para poder recuperarlo.
$values los valores o que puede devolver el componente (combo, radiobotton y checkbox)
$labels lo que va a mostrar el componente (combo, radiobotton y checkbox).
$valor es el valor por defecto que tiene el componente, si es que tiene.
=cut

sub generarComboDeAnios{
    my ($notChange) = @_;
    my @localtime = localtime();
    my $anio_actual = 1900+$localtime[5];

    my $year_Default=$anio_actual;

    my @years;
    my @yearsValues;
    my %labels;
    my $onChange = $notChange?'null':'consultar()';
    push (@years,0);
    $labels{0}=C4::AR::Filtros::i18n("Seleccione");
    for (my $i =2000 ; $i < 2036; $i++){
        push (@years,$i);
        $labels{$i} = $i;
    }
    my $year_select=CGI::scrolling_list(   -name      => 'year',
                    -id    => 'year',
                                    -values    => \@years,
                                    -labels    => \%labels,
                                    -defaults  => $year_Default,
                                    -size      => 1,
                                    -onChange  =>$onChange,
                                );
    return ($year_select);
}


sub generarComboTemasOPAC{

    my (@label,@values);
    my $temas = C4::AR::Preferencias::getPreferenciasByCategoria("temas_opac");
    my %labels;
    my %options_hash;

    foreach my $pref (@$temas){
        push (@values,$pref->getValue());
        $labels{$pref->getValue()} = $pref->getValue();
    }

    my ($session) = CGI::Session->load();
    my $socio     = C4::AR::Auth::getSessionSocioObject();

    $options_hash{'values'}     = \@values;
    $options_hash{'labels'}     = \%labels;
    $options_hash{'defaults'}   = $socio->getTheme() || C4::AR::Preferencias::getPreferenciasByCategoria('defaultUI') || 'default';
    $options_hash{'size'}       = 1;
    $options_hash{'name'}       = 'temas_opac';
    $options_hash{'id'}         = 'temas_opac';

    my $select = CGI::scrolling_list(\%options_hash);

    return($select);

}


sub generarComboTemasINTRA{
    my (@label,@values);
    my $temas = C4::AR::Preferencias::getPreferenciasByCategoria("temas_intra");
    my %labels;
    my %options_hash;

    foreach my $pref (@$temas){
        push (@values,$pref->getValue());
        $labels{$pref->getValue()} = $pref->getValue();
    }

    my ($session) = CGI::Session->load();

    $options_hash{'values'}     = \@values;
    $options_hash{'labels'}     = \%labels;
    $options_hash{'defaults'}   = $session->param('usr_theme_intra') || C4::AR::Preferencias::getPreferenciasByCategoria('defaultUI') || 'default';
    $options_hash{'size'}       = 1;
    $options_hash{'name'}       = 'temas_intra';
    $options_hash{'id'}         = 'temas_intra';

    my $select = CGI::scrolling_list(\%options_hash);

    return($select);

}

sub generarComboDeCredentials{
    my ($params) = @_;

    my @select_credentials;
    my %select_credentials;

    push @select_credentials, 'estudiante';
    push @select_credentials, 'librarian';
    push @select_credentials, 'superLibrarian';
    $select_credentials{'estudiante'}       = 'Usuario';
    $select_credentials{'librarian'}        = 'Bibliotecario';
    $select_credentials{'superLibrarian'}   = 'Directivo';

    my ($session)           = CGI::Session->load();

    my $default_credential  = $params->{'default'} || 'estudiante';


    my $CGIregular = CGI::scrolling_list(       -name      => 'credential',
                                                -id        => 'credential',
                                                -values    => \@select_credentials,
                                                -defaults  => $default_credential,
                                                -labels    => \%select_credentials,
                                                -size      => 1,
                                      );
    return ($CGIregular);
}

sub generarComboRegular{

    my @select_regular;
    my %select_regular;

    push @select_regular, '1';
    push @select_regular, '0';
    push @select_regular, 'Todos';
    $select_regular{'1'} = 'Regular';
    $select_regular{'0'} = 'Irregular';
    $select_regular{'Todos'} = 'Todos';

    my $CGIregular=CGI::scrolling_list(  -name      => 'regular',
                                            -id        => 'regular',
                                            -values    => \@select_regular,
                                            -defaults  => 'Todos',
                                            -labels    => \%select_regular,
                                            -size      => 1,
                                      );
    return ($CGIregular);
}


sub crearComponentes{

    my ($tipoInput,$id,$values,$labels,$valor)=@_;
    my $inputCampos;
    if ($tipoInput eq 'combo'){
        $inputCampos=CGI::scrolling_list(
            -name      => $id,
            -id    => $id,
            -values    => $values,
            -labels    => $labels,
            -default   => $valor,
            -size      => 1,
                );
    }
    elsif($tipoInput eq 'radio'){
        $inputCampos=CGI::radio_group(
            -name      =>$id,
            -id        =>$id,
            -values    => $values,
            -labels    => $labels,
            -default   => $valor,
        );

        #el CGI::radio_group devuelve el radio entre tags <label>, se rompe el estilo, asi q se le saca los tags <label>
        $inputCampos = reemplazarEnString($inputCampos, '<label>', '');
        $inputCampos = reemplazarEnString($inputCampos, '<\/label>', '');
    }
    elsif($tipoInput eq 'check'){
        $inputCampos=CGI::checkbox_group(
            -name   =>$id,
            -id =>$id,
            -values    => $values,
            -labels    => $labels,
            -default   => $valor,
        );
    }
    elsif($tipoInput eq 'text'){
        $inputCampos=CGI::textfield(
            -name   =>$id,
            -id =>$id,
            -value  =>$valor,
            -size   =>$values,
                );
    }
    elsif($tipoInput eq 'texta'){

        my $class_texta = "";
        if ( ($id ne "google_map") && ($id ne "twitter_follow_button") && ($id ne "piwik_code") ){
            $class_texta = "input-xxlarge editable_wysiwyg",
        }else{
            $class_texta = "input-xxlarge",    
        }

        $inputCampos=CGI::textarea(
            -name    =>$id,
            -id  =>$id,
            -value   =>$valor,
            -rows    =>10,
            -cols    =>$values,
            -class   => $class_texta,    
        );
    }
    else{
        $inputCampos= CGI::hidden(-id=>$id,);
    }
    return($inputCampos);
}


#Obtiene los mail de todos los usuarios
# FIXME deprecated, o pasar a Rose y hacer el reporte
=item
sub mailDeUsuarios {
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT emailaddress
                FROM  borrowers
                WHERE (emailaddress IS NOT NULL) AND (emailaddress <> '')");
    $sth->execute();
    my @results;
    while (my $data = $sth->fetchrow_hashref) {
        push(@results, $data);
    }

    $sth->finish;

    return(@results);
}
=cut
sub in_array{

    my $val = shift @_ || return 0;
    my @array = @_;
    foreach (@array)
            { return 1 if ($val eq $_); }
    return 0;
}


=item
Esta funcion reemplaza en string lo indicado por cadena_a_reemplazar por cadena_reemplazo, con expresiones regulares
tener en cuenta escapar algunos caracteres como <\label> => <\/label>
=cut
sub reemplazarEnString{
    my ($string, $cadena_a_reemplazar, $cadena_reemplazo) = @_;

    $string =~ s/$cadena_a_reemplazar/$cadena_reemplazo/g;

    return $string;
}

sub array_diff{

# A $array1 le resta $array2
    my ($array1_ref,@array2) = @_;
    my @array_res;
    foreach (@$array1_ref) {
        push(@array_res, $_) unless (&in_array($_,@array2));
    }
    return(@array_res);
}

sub saveholidays{

    my ($hol) = @_;
    if ($hol){ # FIXME falla si borro todos los feriados
        my @feriados = split(/,/, $hol);
        savedatemanip(@feriados);
        my ($cant,@feriados_anteriores)= &getholidays();
        my @feriados_nuevos= &array_diff(\@feriados,@feriados_anteriores);
        my @feriados_borrados= &array_diff(\@feriados_anteriores,@feriados);
        foreach (@feriados_nuevos) { updateForHoliday($_,"+"); }
        foreach (@feriados_borrados) { updateForHoliday($_,"-"); }
        my $dbh = C4::Context->dbh;
#Se borran todos los feriados de la tabla
        if (scalar(@feriados_borrados)) {
            my $sth=$dbh->prepare(" DELETE FROM pref_feriado
                                    WHERE fecha IN (".join(',',map {"('".$_."')"} @feriados_borrados).")");
            $sth->execute();
            $sth->finish;
        }
#Se dan de alta todos los feriados
        if (scalar(@feriados_nuevos)) {
            my $sth=$dbh->prepare(" INSERT INTO pref_feriado (fecha)
                                    VALUES ".join(',',map {"('".$_."')"} @feriados_nuevos));
            $sth->execute();
            $sth->finish;
        }
    }
}


sub obtenerTiposDeColaboradores{

    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT codigo,descripcion
                            FROM cat_ref_colaborador
                            ORDER BY (descripcion)");
    $sth->execute();
    my %results;
    while (my $data = $sth->fetchrow_hashref) {#push(@results, $data);
    $results{$data->{'codigo'}}=$data->{'descripcion'};
    }
    # while
    $sth->finish;
    return(%results);#,@results);
}

=item obtenerParches
la funcion obtenerParches devuelve toda la informacion sobre los parches de actualizacion que hay que aplpicar, con esto se logra cambiar de la version 2 a las versiones futuras sin problemas, via web
=cut
sub obtenerParches{

    my ($version)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT *
                            FROM parches
                            WHERE (corresponde > ?)
                            ORDER BY (id)");
    $sth->execute($version);
    my @results;
    while (my $data = $sth->fetchrow_hashref) {#push(@results, $data);
        push(@results,$data);
    }
    # while
    $sth->finish;
    return(@results);
}

=item aplicarParches
la funcion aplicarParches aplica el parche que le llega por parametro.
Para hacer esto lo que hace es leer la base de datos y aplicar las instrucciones mysql que corresponden con ese parche
=cut
sub aplicarParches{

    my ($parche)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT *
                            FROM parches_scripts
                            WHERE (parche= ?)
                            ORDER BY (id)");
    $sth->execute($parche);
    my $sth2;
    my $error='';
    while (my $data = $sth->fetchrow_hashref) {#push(@results, $data);
        $sth2=$dbh->prepare($data->{'sql'});
        $sth2->execute();
        if ($sth2 -> errstr){
            $error=$sth2 -> errstr;
        }
        # while
        $sth->finish;
        if (not $error){
            my $sth3=$dbh->prepare("UPDATE parches
                                    SET aplicado='1'
                                    WHERE id=?");
            $sth3->execute($parche);
        }
    }
    $sth2->finish;
    return($error);
}


sub getholidays{

    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT *
                            FROM pref_feriado");
    $sth->execute();

    my @results;

    while (my $data = $sth->fetchrow) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(scalar(@results),@results);
}

#27/03/07 Miguel - Cuando agregaba un autor en Colaboradores
#obtenerReferencia devuelve los autores cuyos apellidos sean like el parametro
sub obtenerReferencia{

    my ($dato)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT UPPER(concat_ws(', ',apellido,nombre))
                            FROM cat_autor
                            WHERE apellido LIKE ?
                            ORDER BY apellido
                            LIMIT 0,15");
    $sth->execute($dato.'%');

    my @results;

    while (my $data = $sth->fetchrow) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(@results);
}

#obtenerReferencia devuelve los autores cuyos apellidos sean like el parametro
sub obtenerAutores{

    my ($dato)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT completo, id
                            FROM cat_autor
                            WHERE apellido LIKE ?
                            ORDER BY (apellido)");
    $sth->execute($dato.'%');

    my @results;

    while (my $data = $sth->fetchrow_hashref) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(@results);
}

=head2
    sub obtenerPaises
=cut
sub obtenerPaises{
    my ($pais) = @_;

    my @filtros;

    push(@filtros, ( nombre_largo => { like => $pais.'%'}) );
    my $limit = C4::AR::Preferencias::getValorPreferencia('limite_resultados_autocompletables') || 20;

    my $paises_array_ref = C4::Modelo::RefPais::Manager->get_ref_pais(

        query   => \@filtros,
        select  => ['*'],
        sort_by => 'nombre_largo ASC',
        limit   => $limit,
        offset  => 0,
    );

    return (scalar(@$paises_array_ref), $paises_array_ref);


}

=head2
    sub obtenerCiudades
=cut
sub obtenerCiudades{
    my ($ciudad) = @_;

    my @filtros;
        my @filtros_or;
        push(@filtros_or, (NOMBRE => {like => '%'.$ciudad.'%'}) );
        push(@filtros_or, (NOMBRE_ABREVIADO => {like => '%'.$ciudad.'%'}) );
    push(@filtros, (or => \@filtros_or) );

    my $limit = C4::AR::Preferencias::getValorPreferencia('limite_resultados_autocompletables') || 200;

    my $ciudades_array_ref = C4::Modelo::RefLocalidad::Manager->get_ref_localidad(

        query   => \@filtros,
        select  => ['*'],
        sort_by => 'nombre ASC',
        limit   => $limit,
        offset  => 0,
    );

    return (scalar(@$ciudades_array_ref), $ciudades_array_ref);


}

#obtenerTemas devuelve los temas que sean like el parametro
sub obtenerTemas{

    my ($dato)=@_;
    my $dbh = C4::Context->dbh;
#   my $sth=$dbh->prepare("select catalogueentry from catalogueentry where catalogueentry LIKE ? order by catalogueentry limit 0,15");
    my $sth=$dbh->prepare(" SELECT nombre
                            FROM cat_tema
                            WHERE nombre LIKE ?
                            ORDER BY nombre
                            LIMIT 0,15");

    $sth->execute($dato.'%');

    my @results;

    while (my $data = $sth->fetchrow) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(@results);
}

sub obtenerTemas2{

    my ($dato)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT nombre, id
                            FROM cat_tema
                            WHERE nombre LIKE ?
                            ORDER BY nombre");

    $sth->execute($dato.'%');

    my @results;

    while (my $data = $sth->fetchrow_hashref) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(@results);
}

#obtenerEditores devuelve los editores que sean like el parametro
sub obtenerEditores{

    my ($dato)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT UPPER(concat_ws(', ',apellido,nombre))
                            FROM cat_autor
                            WHERE apellido LIKE ?
                            ORDER BY (apellido)
                            LIMIT 0,15");

    $sth->execute($dato.'%');

    my @results;

    while (my $data = $sth->fetchrow) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(@results);
}

sub obtenerBiblios{

    my ($dato)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT branchname, branchcode AS id
                            FROM pref_unidad_informacion
                            WHERE branchname LIKE ?
                            ORDER BY branchname");

    $sth->execute($dato.'%');

    my @results;

    while (my $data = $sth->fetchrow_hashref) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(@results);
}

sub noaccents{

    my $word = @_[0];
    my @chars = split(//,$word);
    my $newstr = "";
    foreach my $ch (@chars) {
        if (ord($ch) == 225 || ord($ch) == 193) {$newstr.= 'a'}
        elsif (ord($ch) == 233 || ord($ch) == 201) {$newstr.= 'e'}
        elsif (ord($ch) == 237 || ord($ch) == 205) {$newstr.= 'i'}
        elsif (ord($ch) == 243 || ord($ch) == 211) {$newstr.= 'o'}
        elsif (ord($ch) == 250 || ord($ch) == 218) {$newstr.= 'u'}
        else {$newstr.= $ch}
    }
    return(uc($newstr));
}

sub savedatemanip{

    my @feriados= @_;
#Actualizo el archivo de configuracion de DateManip
    open (F,'>/var/www/.DateManip.cnf'); #FIXME hay que sacar /var/www/ y poner algo asi como $ENV{HOME}
    printf F "*Holiday\n\n";
    foreach my $f (@feriados) {
        my @fecha = split('-',$f);
        my $fnue = $fecha[2].'/'.$fecha[1].'/'.$fecha[0];

        printf F $fnue."\t= Feriado\n\n";
    }
    close F;
}


sub listadoTabla{

    my($tabla,$ind,$cant,$id,$orden,$search,$bloqueIni,$bloqueFin)=@_;
    #$cant=$cant+$ind;
    ($id||($id=0));

    $search=$search.'%';

    my $dbh = C4::Context->dbh;
    # my $sth=$dbh->prepare("select count(*) from $tabla  where $orden like '$search'");
    # $sth->execute();
    my $sth;
    my @cantidad;

    if( ($bloqueIni ne "")&&($bloqueFin ne "") ){
        $sth=$dbh->prepare("    SELECT count(*)
                                FROM $tabla
                                WHERE $orden BETWEEN  '$bloqueIni%' AND '$bloqueFin%' ");

        $sth->execute();
        @cantidad=$sth->fetchrow_array;

        $sth=$dbh->prepare("    SELECT *
                                FROM $tabla
                                WHERE $orden BETWEEN  '$bloqueIni%' AND '$bloqueFin%'
                                ORDER BY $orden limit $ind,$cant ");
        $sth->execute();
    }else{
        $sth=$dbh->prepare("  SELECT COUNT(*)
                                FROM $tabla
                                WHERE $orden LIKE '$search'");
        $sth->execute();

        @cantidad=$sth->fetchrow_array;
        $sth=$dbh->prepare("    SELECT *
                                FROM $tabla
                                WHERE $orden LIKE '$search'
                                ORDER BY $orden LIMIT $ind,$cant");
        $sth->execute();
    }

    my @results;

    while (my @data=$sth->fetchrow_array){
        my @results2;
        my $i;

        for ($i=0;$i<@data;$i++) {
            my $aux;
            $aux->{'campo'} = $data[$i];
                push(@results2,$aux);
        }

        my $aux2;

        $aux2->{'registro'}=\@results2;
        $aux2->{'id'}=$data[$id];
        push(@results,$aux2);
    }

    $sth->finish;
    return ($cantidad[0],@results);
}

#devuelve los valores de un elemento en particular de la tabla de referencia que se esta editando
#recibe la tabla, el nombre del campo que es identificador y el valor que debe buscar
#estos tres parametros se obtienen anteriorimente de la tabla tablasDeReferencias
sub valoresTabla{

    my ($tabla,$indice,$valor)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare("SHOW FIELDS FROM $tabla");

    $sth->execute();

    my @results;

    while (my @data=$sth->fetchrow_array){
        my $aux;
        $aux->{'campo'} = $data[0];
            push(@results,$aux);
    }

    $sth=$dbh->prepare("    SELECT *
                            FROM $tabla
                            WHERE $indice=?");
    $sth->execute($valor);

    my @results2;

    while (my $data=$sth->fetchrow_hashref){
        my $i;
        foreach $i (@results){
            my $aux;
            $aux->{'campo'} = $i->{'campo'};
            $aux->{'valor'}=$data->{$i->{'campo'}};
            push(@results2,$aux);
        }
    }
    $sth->finish;
    return @results2;
}


sub tablasRelacionadas{

    my ($tabla,$indice,$valor)=@_;

    my $dbh = C4::Context->dbh;

    #Se verfica si tiene referencias
    #Tabla referencias
    #referencia nomcamporeferencia camporeferencia referente             camporeferente
    #autores    id      0       biblio          author
    #autores    id      0       colaboradores       idColaborador
    #autores    id      0       additionalauthors   author
    #autores    id      0       analyticalauthors   author
    my $sth=$dbh->prepare(" SELECT *
                            FROM pref_tabla_referencia
                            WHERE referencia= ?");
    $sth->execute($tabla);

    my @results;

    while (my $data=$sth->fetchrow_hashref){
        my $aux;
        my $sth2=$dbh->prepare("SELECT $data->{'nomcamporeferencia'}
                                FROM $data->{'referencia'}
                                WHERE $indice = ?");
        $sth2->execute($valor);

        my $identificador=$sth2->fetchrow_array;

        $sth2=$dbh->prepare("   SELECT COUNT(*)
                                FROM $data->{'referente'}
                                WHERE $data->{'camporeferente'}= ?");
        $sth2->execute($identificador);
        $aux->{'relacionadoTabla'} = $data->{'referente'};
        if (my $canti= $sth2->fetchrow_array){
            $aux->{'relacionadoTablaCantidad'}=$canti;
            push(@results,$aux);
        }
    }
    return @results;
}



#devuelve los valores similares de un elemento en particular de la tabla de referencia que se esta editando basandose en la tablaDeReferenciaInfo
#recibe la tabla, el nombre del campo que es identificador y el valor que debe buscar
#estos tres parametros se obtienen anteriorimente de la tabla tablasDeReferencias
sub valoresSimilares{

    my($tabla,$camporeferencia,$id)=@_;
    ($id||($id=0));
    my $dbh = C4::Context->dbh;
    #Obtengo que campo voy a utilizar para buscar similares, es en tablasDeReferenciasInfo
    my $sth=$dbh->prepare(" SELECT similares
                FROM pref_tabla_referencia_info
                WHERE referencia=? ");

    $sth->execute($tabla);

    my $similar=$sth->fetchrow_array;
    #Busco el valor del campo similar que corresponde al registro para el cual estoy buscando similares

    $sth=$dbh->prepare("    SELECT $similar
                FROM $tabla
                WHERE $camporeferencia = ?
                LIMIT 0,1");
    $sth->execute($id);

    my $valorAbuscarSimil=$sth->fetchrow_array;
    my $tamano=(length($valorAbuscarSimil))-1;
    #Busco los valores similares, con una expresion regular que busca aquellas tuplas que coincidan en campo similar en todos los caracteres-1 del original

    $sth=$dbh->prepare("    SELECT *
                            FROM $tabla
                            WHERE $similar REGEXP '[$valorAbuscarSimil]{$tamano,}' AND $camporeferencia  != ?
                            ORDER BY $similar
                            LIMIT 0,15");
    $sth->execute($id);

    my $sth3=$dbh->prepare("SELECT camporeferencia
                            FROM pref_tabla_referencia
                            WHERE referencia=?
                            LIMIT 0,1");
    $sth3->execute($tabla);

    my $idnum=$sth3->fetchrow_array;
    my @results;

    while (my @data=$sth->fetchrow_array){
        my @results2;
        my $i;
        for ($i=0;$i<@data;$i++) {
            my $aux;
            $aux->{'campo'} = $data[$i];
            push(@results2,$aux);
        }
        my $aux2;

        $aux2->{'registro'}=\@results2;
        $aux2->{'id'}=$data[$idnum];
        push(@results,$aux2);
    }
    $sth->finish;
    return (@results);
}

#Busca todas las tablas relacionadas con $tabla y actualiza la referencia a el nuevo valor que esta en valorNuevo. Ej: actualiza todos los libros para que hayan sido escritos por autor id=58 y le pone que fueron esvcritos por autor id=60
sub asignar{

    my ($tabla,$indice,$identificador,$valorNuevo,$borrar)=@_;
    #ACa hay q hacer q sea una transaccion
    my $dbh = C4::Context->dbh;
    my $asignar;
    my $sthT=$dbh->prepare("START TRANSACTION");

    $sthT->execute();

    my $sth=$dbh->prepare(" SELECT *
                            FROM pref_tabla_referencia
                            WHERE referencia= ?");
    $sth->execute($tabla);

    my @results;
    my $asignar=0;

    while (my $data=$sth->fetchrow_hashref){
        $asignar=1;
        my $aux;
        my $sth2=$dbh->prepare("SELECT $data->{'nomcamporeferencia'}
                                FROM $data->{'referencia'}
                                WHERE $indice = ?");
        $sth2->execute($identificador);
        my $identificador2=$sth2->fetchrow_array;

        $sth2=$dbh->prepare("   UPDATE $data->{'referente'}
                                SET $data->{'camporeferente'}= ?
                                WHERE $data->{'camporeferente'}= ?");
        $sth2->execute($valorNuevo,$identificador2);
    }
    if ($borrar){
        my $sth3=$dbh->prepare("DELETE FROM $tabla
                                WHERE $indice= ?");
        $sth3->execute($identificador);
        $borrar=1;
    }
    $sthT=$dbh->prepare("COMMIT");
    $sthT->execute();
    return ($asignar,$borrar);
}

sub obtenerValores{

    my ($tabla,$indice,$valor)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare("SHOW FIELDS FROM ?");

    $sth->execute($tabla);
    my @data=$sth->fetchrow_array;

    $sth=$dbh->prepare("    SELECT *
                            FROM ?
                            WHERE ?=?");
    $sth->execute($tabla,$indice,$valor);
    my $data2=$sth->fetchrow_hashref;

    $sth->finish;
    my %row;

    foreach my $campo (@data) {
        my %row = ($campo => $data2->{$campo});
    }
    return \%row;
}

#Esta funcion recibe tres parametros, el nombre de la tabla que se esta editando, el campo identificador de la tabla y un hash de los campos y valores que se van a actualizar en esa tabla
sub actualizarCampos{

    my ($tabla,$id,%valores)=@_;
    my $dbh = C4::Context->dbh;
    my $sql='';

    foreach my $key (keys(%valores)){
        $sql.=', '.$key.'="'.$valores{$key}.'"';
    }
    $sql=substr($sql,2);
    my $sth=$dbh->prepare(" UPDATE $tabla
                            SET $sql
                            WHERE $id=?");

    $sth->execute($valores{$id});
    $sth->finish;
}

#obtenerTemas devuelve los temas que sean like el parametro
sub obtenerDefaults{

    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" SELECT *
                FROM defaultbiblioitem");

    $sth->execute();
    my @results;

    while (my $data = $sth->fetchrow_hashref) {
        push(@results, $data);
    } # while
    $sth->finish;
    return(@results);
}
sub guardarDefaults{

    my ($biblioitem)=@_;
    my $dbh = C4::Context->dbh;
    my $sth=$dbh->prepare(" UDPATE defaultbiblioitem
                            SET valor = ?
                            WHERE campo=?");

    $sth->execute($biblioitem->{'volume'},'volume');
    $sth->execute($biblioitem->{'number'},'number');
    $sth->execute($biblioitem->{'classification'},'selectlevel');
    $sth->execute($biblioitem->{'itemtype'},'selectitem');
    $sth->execute($biblioitem->{'isbncode'},'isbn');
    $sth->execute($biblioitem->{'issn'},'issn');
    $sth->execute($biblioitem->{'lccn'},'lccn');
    $sth->execute($biblioitem->{'publishercode'},'publishercode');
    $sth->execute($biblioitem->{'publicationyear'},'publicationyear');
    $sth->execute($biblioitem->{'dewey'},'dewey');
    $sth->execute($biblioitem->{'url'},'url');
    $sth->execute($biblioitem->{'volumeddesc'},'volumeddesc');
    $sth->execute($biblioitem->{'illus'},'illus');
    $sth->execute($biblioitem->{'pages'},'pages');
    $sth->execute($biblioitem->{'bnotes'},'notes');
    $sth->execute($biblioitem->{'size'},'size');
    $sth->execute($biblioitem->{'place'},'place');
    $sth->execute($biblioitem->{'language'},'selectlang');
    $sth->execute($biblioitem->{'support'},'selectsuport');
    $sth->execute($biblioitem->{'country'},'selectcountry');
    $sth->execute($biblioitem->{'serie'},'serie');
}

=item
verificarValor
Verifica que el valor que ingresado no tenga sentencias peligrosas, se filtran.
=cut
sub verificarValor {
    my ($valor) = @_;

  # C4::AR::Debug::debug("antes de limpiar => ".$valor);

    $valor=~ s/\b(SELECT|SHOW|ALL|WHERE|INSERT|SHUTDOWN|DROP|UNION|DELETE|UPDATE|FROM|BETWEEN|information_schema|table_name)\b/ /gi;

#     C4::AR::Debug::debug("despues de limpiar => ".$valor);

#    $valor=~ s/%|"|=|\*|-(<,>)//g;
#    $valor=~ s/%3b|%3d|%27|%25//g;#Por aca no entra llegan los caracteres ya traducidos
#    $valor=~ s/\<SCRIPT>|\<\/SCRIPT>//gi;

    return $valor;
}

#*****************************************Paginador*********************************
#Funciones para paginar en el Servidor
#

sub InitPaginador{

    my ($iniParam,$obj)=@_;
    my $pageNumber;
    my $ini;
    my $cantR=cantidadRenglones();

    if (($iniParam eq "")|($iniParam <= 0)){
            $ini=0;
            $pageNumber=1;
    } else {
            $ini= ($iniParam-1)* $cantR;
            $pageNumber= $iniParam;
    };

    return ($ini,$pageNumber,$cantR);
}

sub crearPaginador{

    my ($cantResult, $cantRenglones, $pagActual, $funcion,$t_params)=@_;

    my ($paginador, $cantPaginas)=C4::AR::Utilidades::armarPaginas($pagActual, $cantResult, $cantRenglones,$funcion,$t_params);

    return $paginador;

}

sub armarPaginas{
#@actual, es la pagina seleccionada por el usuario
#@cantRegistros, cant de registros que se van a paginar
#@$cantRenglones, cantidad de renglones maximo a mostrar
#@$t_params, para obtener el path para las imagenes

# FIXME falta pasar las imagenes al estilo
    my ($actual, $cantRegistros, $cantRenglones,$funcion, $t_params)=@_;

    my $pagAMostrar=C4::AR::Preferencias::getValorPreferencia("paginas") || 10;
    my $numBloq=floor($actual / $pagAMostrar);
    my $limInf=($numBloq * $pagAMostrar);
    my $limSup=$limInf + $pagAMostrar;
    my $previous_text = "« ".C4::AR::Filtros::i18n('Anterior');
    my $next_text = C4::AR::Filtros::i18n('Siguiente')." »";
    my $first_text = "« ".C4::AR::Filtros::i18n('Primero');
    my $last_text = C4::AR::Filtros::i18n('&Uacute;ltimo')." »";
    if($limInf == 0){
        $limInf= 1;
        $limSup=$limInf + $pagAMostrar -1;
    }
    my $totalPaginas = ceil($cantRegistros/$cantRenglones);

    my $themelang= $t_params->{'themelang'};

    my $paginador= "<div class='pagination pagination-centered'><ul>";
    my $class="paginador";

    if($actual > 1){
        #a la primer pagina
        my $ant= $actual-1;
        $paginador .= "<li class='prev click'><a  onClick='".$funcion."(1)' title='".$first_text."'> ".$first_text."</a></li>";
        $paginador .= "<li class='prev click'><a  onClick='".$funcion."(".$ant.")' title='".$previous_text."'> ".$previous_text."</a></li>";

    }

    for (my $i=$limInf; ($totalPaginas >1 and $i <= $totalPaginas and $i <= $limSup) ; $i++ ) {
        my $onClick = "";
        if($actual == $i){
            $class="'active click'";
        }else{
            $class="'click'";
            $onClick = "onClick='".$funcion."(".$i.")'";
        }
        $paginador .= "<li class=".$class."><a class=".$class."$onClick> ".$i." </a></li>";
    }

    if($actual >= 1 && $actual < $totalPaginas){
        my $sig= $actual+1;
        $paginador .= "<li class='next'><a class='click next' onClick='".$funcion."(".$sig.")' title='".$next_text."'>".$next_text."</a></li>";
        $paginador .= "<li class='next'><a class='click next' onClick='".$funcion."(".$totalPaginas.")' title='".$last_text."'>".$last_text."</a></li>";

    }

    $paginador .= "</ul></div>";

    if ($totalPaginas <= 1){
      $paginador="";
    }


    return($paginador, $totalPaginas);
}

#
#Cantidad de renglones seteado en las preferencias del sistema para ver por cada pagina
sub cantidadRenglones{
    return(C4::AR::Preferencias::getValorPreferencia('paginas') || 10);
}

#**************************************Fins***Paginador*********************************

=item
cambiarLibreDeuda
guarda el nuevo valor de la variable libreDeuda de la tabla de las preferencias
NOTA: cambiar de PM a uno donde esten todo lo referido a las preferencias de sistema, esta funcion se utiliza en los archivos adminLibreDeuda.pl y libreDeuda.pl
=cut
sub cambiarLibreDeuda{

    my ($valor)=@_;

    C4::AR::Preferencias::setVariable('libreDeuda',$valor);
    C4::AR::Preferencias::reloadAllPreferences();

    return (1);

}

=item
checkdigit
  $valid = &checkdigit($env, $cardnumber $nounique);
Takes a card number, computes its check digit, and compares it to the
checkdigit at the end of C<$cardnumber>. Returns a true value iff
C<$cardnumber> has a valid check digit.
C<$env> is ignored.
VIENE DEL PM INPUT QUE FUE ELIMINADO
=cut
sub checkdigit{

    my ($env,$infl, $nounique) =  @_;
    $infl = uc $infl;
    #Check to make sure the cardnumber is unique
    #FIXME: We should make the error for a nonunique cardnumber
    #different from the one where the checkdigit on the number is
    #not correct
    unless ( $nounique ){
        my $dbh=C4::Context->dbh;
        my $query=qq{   SELECT *
                        FROM borrowers
                        WHERE cardnumber=?};
        my $sth=$dbh->prepare($query);

        $sth->execute($infl);
        my %results = $sth->fetchrow_hashref();

        if ( $sth->rows != 0 ){
            return 0;
        }
    }
    if (C4::AR::Preferencias::getValorPreferencia("checkdigit") eq "none") {
        return 1;
    }
    my @weightings = (8,4,6,3,5,2,1);
    my $sum;
    my $i = 1;
    my $valid = 0;

    foreach $i (1..7) {
        my $temp1 = $weightings[$i-1];
        my $temp2 = substr($infl,$i,1);

        $sum += $temp1 * $temp2;
    }

    my $rem = ($sum%11);

    if ($rem == 10) {
        $rem = "X";
    }
    if ($rem eq substr($infl,8,1)) {
        $valid = 1;
    }
    return $valid;
} # sub checkdigit

=item
checkvalidisbn
  $valid = &checkvalidisbn($isbn);
Returns a true value iff C<$isbn> is a valid ISBN: it must be ten
digits long (counting "X" as a digit), and must have a valid check
digit at the end.
VIENE DEL PM INPUT QUE FUE ELIMINADO
=cut
#--------------------------------------
# Determine if a number is a valid ISBN number, according to length
#   of 10 digits and valid checksum
# VIENE DEL PM INPUT QUE FUE ELIMINADO
sub checkvalidisbn{

    my ($q)=@_ ;    # Input: ISBN number
    my $isbngood = 0; # Return: true or false

    $q=~s/x$/X/g;           # upshift lower case X
    $q=~s/[^X\d]//g;
    $q=~s/X.//g;
    #return 0 if $q is not ten digits long
    if (length($q)!=10) {
        return 0;
    }
    #If we get to here, length($q) must be 10
    my $checksum=substr($q,9,1);
    my $isbn=substr($q,0,9);
    my $i;
    my $c=0;

    for ($i=0; $i<9; $i++) {
        my $digit=substr($q,$i,1);

        $c+=$digit*(10-$i);
    }
    $c %= 11;
    ($c==10) && ($c='X');
    $isbngood = $c eq $checksum;

    return ($isbngood);
} # sub checkvalidisbn

=item
quitarduplicados
simplemente devuelve el arreglo que recibe sin elementos duplicados
=cut
sub quitarduplicados{

    my (@arreglo)=@_;
    my @arreglosin=();

    for(my $i=0;$i<scalar(@arreglo);$i++){
        my $ok=1;

        for(my $j=0;$j<scalar(@arreglosin);$j++){
            if ($arreglo[$i] == $arreglosin[$j] ){
                $ok=0;
            }
        }

        if ($ok eq 1) {
            push(@arreglosin, $arreglo[$i] );
        }
    }
    return (@arreglosin);
}

#pasa de codificacion UTF8 a ISO-8859-1,
#Se usa $_[0] para no copiar el string a una var local
sub UTF8toISO {

#TODO: POR QUE ROMPE LOS ACENTOS???? VERRRRRRRRRRRRRRRRRRRRRRR
    return $_[0] = Encode::decode('utf8', $_[0]);
    return ($_[0]);
}

=head2
    sub from_json_ISO
    Se usa $_[0] para no copiar el string a una var local
=cut
sub from_json_ISO {
    eval {
        # C4::AR::Debug::debug("JSON => Utilidades.pm => " . $_[0]);
        #quita el caracter tab en todo el string $data
        $_[0] =~ s/\t//g;
        #quita campos separadores ante un eventual marc_record roto
        $_[0] =~ s/\N{U+001E}//g;
        $_[0] =~ s/\N{U+001D}//g;
        $_[0] = UTF8toISO($_[0]);
        #C4::AR::Debug::debug("Data JSON ===> ".$data);
        return from_json($_[0], {latin1 => 1});
    }
    or do{
        #FIXME falta generar un codigo de error para error de sistema
        C4::AR::Debug::debug("Utilidades => from_json_ISO => ERROR");
        &C4::AR::Mensajes::printErrorDB($@, 'UT001','INTRA');
        return "0";
    }
}

=head2
    sub ASCIItoHEX
=cut
sub ASCIItoHEX {
    my ($char) = @_;

    use Switch;

    switch ($char) {
        case "#"    { $char =  "\x".C4::AR::Utilidades::dec2hex(32)   }
        else        { $char =  $char }
    }

    return $char;
}

=head2
    sub HEXtoASCII
=cut
sub HEXtoASCII {
    my ($char) = @_;

    require Switch;

    switch ($char) {
        case "\x20"     { $char =  "#"   }
        else            { $char =  $char }
    }

    return $char;
}


sub dec2hex {
    # parameter passed to
    # the subfunction
    my $decnum = $_[0];
    # the final hex number
    my $hexnum;
    my $tempval;
    while ($decnum != 0) {
        # get the remainder (modulus function)
        # by dividing by 16
        $tempval = $decnum % 16;
        # convert to the appropriate letter
        # if the value is greater than 9
        if ($tempval > 9) {
            $tempval = chr($tempval + 55);
        }
        # 'concatenate' the number to
        # what we have so far in what will
        # be the final variable
        $hexnum = $tempval . $hexnum ;
        # new actually divide by 16, and
        # keep the integer value of the
        # answer
        $decnum = int($decnum / 16);
        # if we cant divide by 16, this is the
        # last step
        if ($decnum < 16) {
        # convert to letters again..
            if ($decnum > 9) {
                $decnum = chr($decnum + 55);
            }

            # add this onto the final answer..
            # reset decnum variable to zero so loop
            # will exit
            $hexnum = $decnum . $hexnum;
            $decnum = 0
        }
    }

    return $hexnum;
} # end sub

=item
obtenerValoresAutorizados
Obtiene todas las categorias, sin repetición de la tabla authorised_values.
=cut
sub obtenerValoresAutorizados{

    require C4::Modelo::PrefValorAutorizado;
    require C4::Modelo::PrefValorAutorizado::Manager;

    my $valAuto_array_ref;
    my @filtros;
    my $valTemp = C4::Modelo::PrefValorAutorizado->new();

    $valAuto_array_ref = C4::Modelo::PrefValorAutorizado::Manager->get_pref_valor_autorizado(
                                        select => ['category'],
                                        group_by => ['category'],
                                    );

    return ($valAuto_array_ref);

}

=item
obtenerDatosValorAutorizado
Obtiene todos los valores de una categoria.
=cut
sub obtenerDatosValorAutorizado{

    my ($categoria)= @_;

    require C4::Modelo::PrefValorAutorizado;
    my $valAuto_array_ref = C4::Modelo::PrefValorAutorizado::Manager->get_pref_valor_autorizado( query => [ category => { eq => $categoria} ]);
    my %autoValueHash;

    foreach my $av (@$valAuto_array_ref){
       $autoValueHash{trim($av->getAuthorisedValue)}= trim($av->getLib);
    }
    return (%autoValueHash);
}

=item
buscarMonedas
Busca las monedas con todas la relaciones. Se usa para el autocomplete en la parte de agregar proveedor.
=cut
# TODO usar Ros::DB
sub buscarMonedas{

    my ($moneda) = @_;
    my $dbh = C4::Context->dbh;
    my $query = "   SELECT  ref_adq_moneda.id, ref_adq_moneda.nombre

                    FROM ref_adq_moneda

                    WHERE (ref_adq_moneda.nombre LIKE ?)

                    ORDER BY (ref_adq_moneda.nombre)";
    my $sth = $dbh->prepare($query);

    $sth->execute('%'.$moneda.'%');
    my @results;
    my $cant;

    while (my $data=$sth->fetchrow_hashref){
        push(@results,$data);
        $cant++;
    }
    $sth->finish;
    return ($cant, \@results);
}

=item
buscarLenguajes
=cut
sub buscarLenguajes{

      my ($lenguaje) = @_;

      my $lenguajes = C4::Modelo::RefIdioma::Manager->get_ref_idioma(   query => [ description => { like => '%'.$lenguaje.'%' } ],
                                                                        sort_by => 'description ASC'

                                                                     );

      return (scalar(@$lenguajes), $lenguajes);
}

=item
buscarSoportes
=cut
sub buscarSoportes{

      my ($soporte) = @_;

      my $soportes = C4::Modelo::RefSoporte::Manager->get_ref_soporte(query => [ description => { like => '%'.$soporte.'%' } ],
                                                                      sort_by => 'description ASC'
                                                                        );

      return (scalar(@$soportes), $soportes);
}

=item
buscarSoportes
=cut
sub buscarNivelesBibliograficos{

      my ($nivelBibliografico) = @_;

      my $nivelesBibliograficos = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico(
                                                                          query => [ description => { like => '%'.$nivelBibliografico.'%' } ],
#                                                                           sort_by => 'description ASC'
                                                                          );

      return (scalar(@$nivelesBibliograficos), $nivelesBibliograficos);
}

=item
getNivelBibliograficoById
=cut
sub getNivelBibliograficoByCode{

      my ($code) = @_;

      my $nivelBibliografico = C4::Modelo::RefNivelBibliografico::Manager->get_ref_nivel_bibliografico(
                                                                          query => [ code => { eq => $code } ]
                                                                                );

    if( scalar(@$nivelBibliografico) > 0){
        return ($nivelBibliografico->[0]);
    }else{
        return 0;
    }
}

=item
getNombreFromEstadoByCodigo
=cut
sub getNombreFromEstadoByCodigo{
    my ($codigo)   = @_;

    my @filtros;

    push(@filtros, ( codigo => { eq => $codigo }) );

    my $estado = C4::Modelo::RefEstado::Manager->get_ref_estado( query => \@filtros );

    if(scalar(@$estado) > 0){
        return ($estado->[0]->nombre);
    } else {
        return "NULL";
    }
}


=head2
# Esta funcioin remueve los blancos del principio y el final del string
=cut
sub trim{
    my ($string) = @_;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;

    return $string;
}

#FUNCION QUE VALIDA QUE UN STRING NO SEA SOLAMENTE UNA SECUENCIA DE BLANCOS (USA Trim())
sub validateString{
    my ($string) = @_;

    $string = trim($string);
    if (length($string) == 0){
        return 0; #EL STRING ERA SOLO BLANCOS, FALSE
    }
    return 1; # TODO OK, TRUE
}

#FUNCION QUE VALIDA QUE UN STRING NO SEA SOLAMENTE UNA SECUENCIA DE BLANCOS (USA Trim())
sub validateBarcode{
    my ($barcode)=@_;
# TODO recupear desde una preferencia de sistema la expresion regular que indique como es un barcode valido para la UI en particular

    return validateString($barcode);
}


#********************************************************Generacion de Combos****************************************************
sub generarComboPermisos{

    my (@label,$values);
    require C4::Modelo::PermCatalogo;
    push (@label,"Unidad De Informaci&oacute;n");
    push (@label,"Tipo de Documento");
    push (@label,"Datos Nivel 1");
    push (@label,"Datos Nivel 2");
    push (@label,"Datos Nivel 3");
    push (@label,"Estantes Virtuales");
    push (@label,"Estructura de Catalogaci&oacute;n Nivel 1");
    push (@label,"Estructura de Catalogaci&oacute;n Nivel 2");
    push (@label,"Estructura de Catalogaci&oacute;n Nivel 3");
    push (@label,"Tablas de Referencia");
    push (@label,"Control de Autoridades");

    $values = C4::Modelo::PermCatalogo->new()->meta->columns;

    my %labels;

    my %options_hash;
    foreach my $permiso (@$values) {
        $labels{$permiso}= $permiso;
    }

    $options_hash{'values'}     = $values;
    $options_hash{'labels'}     =\%labels;
    $options_hash{'defaults'}   = "ui";
    $options_hash{'size'}       = 1;
    $options_hash{'name'}       = 'permisos';
    $options_hash{'id'}         = 'permisos';

    my $select = CGI::scrolling_list(\%options_hash);

    return($select);

}


sub translateTipoCredencial{
    my ($credencial) = @_;

    my %labels = {};

    $labels{"superLibrarian"}= C4::AR::Filtros::i18n('Directivo');
    $labels{"librarian"}= C4::AR::Filtros::i18n('Bibliotecario');
    $labels{"estudiante"}= C4::AR::Filtros::i18n('Usuario');


    return ($labels{$credencial});


}

sub generarComboPerfiles{
    my ($params) = @_;

    my (@label,@values);
# FIXME podria ir a tabla PERFILES, pero se vera en un futuro...
    push (@label,C4::AR::Filtros::i18n('Directivo'));
    push (@label,C4::AR::Filtros::i18n('Bibliotecario'));

    my %labels;
    my %options_hash;
    @values[0]='SL';
    @values[1]='L';
    @values[2]='E';
    @values[3]='custom';
    $labels{"SL"}= C4::AR::Filtros::i18n('Directivo');
    $labels{"L"}= C4::AR::Filtros::i18n('Bibliotecario');
    $labels{"E"}= C4::AR::Filtros::i18n('Usuario');
    $labels{"custom"}= 'Actual';

    $options_hash{'onChange'}= $params->{'onChange'};
    $options_hash{'values'}= \@values;
    $options_hash{'labels'}=\%labels;
    $options_hash{'defaults'}= 'custom';
    $options_hash{'size'}= 1;
    $options_hash{'name'}= 'perfiles';
    $options_hash{'id'}= 'perfiles';

    my $select = CGI::scrolling_list(\%options_hash);

    return($select);

}

sub generarComboTipoPermisos{
    my ($params) = @_;

    my (@values);

    my %labels;
    my %options_hash;

    @values[0]='PCAT';
    @values[1]='PCIR';
    @values[2]='PGEN';

    $labels{"PCAT"}= C4::AR::Filtros::i18n('Permisos Catalogo');
    $labels{"PCIR"}= C4::AR::Filtros::i18n('Permisos Circulacion');
    $labels{"PGEN"}= C4::AR::Filtros::i18n('Permisos Generales');

    $options_hash{'onChange'}= $params->{'onChange'};
    $options_hash{'values'}= \@values;
    $options_hash{'labels'}=\%labels;
    $options_hash{'defaults'}= 'PCAT';
    $options_hash{'size'}= 1;
    $options_hash{'name'}= 'tipo_permisos';
    $options_hash{'id'}= 'tipo_permisos';

    my $select = CGI::scrolling_list(\%options_hash);

    return($select);

}

sub generarComboDeDisponibilidad{

    my ($params) = @_;

    my @select_estados_array;
    my %select_estados_hash;
    my ($disponibilidades_array_ref)= C4::AR::Referencias::obtenerDisponibilidades();

    foreach my $disponibilidad (@$disponibilidades_array_ref) {
        push(@select_estados_array, $disponibilidad->getCodigo);
        $select_estados_hash{$disponibilidad->getCodigo}= $disponibilidad->nombre;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}= $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}= $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}= $params->{'onBlur'};
    }

    $options_hash{'name'}= $params->{'name'}||'disponibilidad_name';
    $options_hash{'id'}= $params->{'id'}||'disponibilidad_id';
    $options_hash{'size'}=  $params->{'size'}||1;
    $options_hash{'multiple'}= $params->{'multiple'}||0;
    $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultDisponibilidad");

    push (@select_estados_array, 'SIN SELECCIONAR');
    $options_hash{'values'}= \@select_estados_array;
    $options_hash{'labels'}= \%select_estados_hash;

    my $comboDeDisponibilidades= CGI::scrolling_list(\%options_hash);

    return $comboDeDisponibilidades;
}


sub generarComboDeDisponibilidadTexto{

    my ($params) = @_;

    my @select_estados_array;
    my %select_estados_hash;
    my ($disponibilidades_array_ref)= C4::AR::Referencias::obtenerDisponibilidades();

    foreach my $disponibilidad (@$disponibilidades_array_ref) {
        push(@select_estados_array, $disponibilidad->nombre);
        $select_estados_hash{$disponibilidad->nombre}= $disponibilidad->nombre;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}= $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}= $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}= $params->{'onBlur'};
    }

    $options_hash{'name'}= $params->{'name'}||'disponibilidad_name';
    $options_hash{'id'}= $params->{'id'}||'disponibilidad_id';
    $options_hash{'size'}=  $params->{'size'}||1;
    $options_hash{'multiple'}= $params->{'multiple'}||0;
    $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultDisponibilidad");

    push (@select_estados_array, 'SIN SELECCIONAR');
    $options_hash{'values'}= \@select_estados_array;
    $options_hash{'labels'}= \%select_estados_hash;

    my $comboDeDisponibilidades= CGI::scrolling_list(\%options_hash);

    return $comboDeDisponibilidades;
}



#GENERA EL COMBO CON LAS CATEGORIAS, CON IDs EN EL LA LISTA EL CODIGO DE CATEGORIA (ES, DO, etc)
sub generarComboCategoriasDeSocioConCodigoCat{
    my ($params) = @_;

    my @select_categorias_array;
    my %select_categorias_hash;
    my ($categorias_array_ref)  = &C4::AR::Referencias::obtenerCategoriaDeSocio();

    foreach my $categoria (@$categorias_array_ref) {
        push(@select_categorias_array, $categoria->getCategory_code);
        $select_categorias_hash{$categoria->getCategory_code}= $categoria->description;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'categoria_socio_id';
    $options_hash{'id'}         = $params->{'id'}||'categoria_socio_id';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultCategoriaSocio");

    if (!$params->{'no_default'}){
        push (@select_categorias_array, '');
        $select_categorias_hash{''} = "SIN SELECCIONAR";
    }

    $options_hash{'values'}     = \@select_categorias_array;
    $options_hash{'labels'}     = \%select_categorias_hash;

    my $comboDeCategorias       = CGI::scrolling_list(\%options_hash);

    return $comboDeCategorias;
}

#GENERA EL COMBO CON LAS CATEGORIAS, Y SETEA COMO DEFAULT EL PARAMETRO (QUE DEBE SER EL VALUE), SINO HAY PARAMETRO, SE TOMA LA PRIMERA
#ID DE LA LISTA EL ID_CATEGORIA
sub generarComboCategoriasDeSocio{
    my ($params) = @_;

    my @select_categorias_array;
    my %select_categorias_hash;
    my ($categorias_array_ref)  = C4::AR::Referencias::obtenerCategoriaDeSocio();

    foreach my $categoria (@$categorias_array_ref) {
        push(@select_categorias_array, $categoria->getId);
        $select_categorias_hash{$categoria->getId}= $categoria->description;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'categoria_socio_id';
    $options_hash{'id'}         = $params->{'id'}||'categoria_socio_id';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultCategoriaSocio");

    push (@select_categorias_array, '');
    $select_categorias_hash{''} = "SIN SELECCIONAR";
    $options_hash{'values'}     = \@select_categorias_array;
    $options_hash{'labels'}     = \%select_categorias_hash;

    my $comboDeCategorias       = CGI::scrolling_list(\%options_hash);

    return $comboDeCategorias;
}

#GENERA EL COMBO CON LOS DOCUMENTOS, Y SETEA COMO DEFAULT EL PARAMETRO (QUE DEBE SER EL VALUE), SINO HAY PARAMETRO, SE TOMA LA PRIMERA
sub generarComboTipoDeDoc{
    my ($params) = @_;

    my @select_docs_array;
    my %select_docs;
    my $docs        = &C4::AR::Referencias::obtenerTiposDeDocumentos();

    foreach my $doc (@$docs) {
        push(@select_docs_array, $doc->getNombre);
        $select_docs{$doc->getNombre}  = $doc->getNombre;
    }

    $select_docs{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'tipo_documento_id';
    $options_hash{'id'}         = $params->{'id'}||'tipo_documento_id';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultTipoDoc");

    push (@select_docs_array, '');
    $options_hash{'values'}     = \@select_docs_array;
    $options_hash{'labels'}     = \%select_docs;

    my $combo_tipo_documento    = CGI::scrolling_list(\%options_hash);

    return $combo_tipo_documento;
}

# genera el combo de documentos con los values del select los id del tipo de documento.
sub generarComboTipoDeDocConValuesIds{
    my ($params) = @_;

    my @select_docs_array;
    my %select_docs;
    my $docs        = &C4::AR::Referencias::obtenerTiposDeDocumentos();

    foreach my $doc (@$docs) {
        push(@select_docs_array, $doc->getId);
        $select_docs{$doc->getId}  = $doc->getNombre;
    }
    $select_docs{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'tipo_documento_id';
    $options_hash{'id'}         = $params->{'id'}||'tipo_documento_id';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || 1;

    push (@select_docs_array, '');
    $options_hash{'values'}     = \@select_docs_array;
    $options_hash{'labels'}     = \%select_docs;

    my $combo_tipo_documento    = CGI::scrolling_list(\%options_hash);

    return $combo_tipo_documento;
}

#genera el combo multiselect de formas de envio

sub generarComboFormasDeEnvio{
    my ($params) = @_;

    my @select_formas_envio_array;
    my %select_formas_envio;
    my $formas_envio        = &C4::AR::Referencias::obtenerFormasDeEnvio();

    foreach my $forma_envio (@$formas_envio) {
        push(@select_formas_envio_array, $forma_envio->getId);
        $select_formas_envio{$forma_envio->getId}  = $forma_envio->getNombre;
    }

    $select_formas_envio{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'forma_envio_id';
    $options_hash{'id'}         = $params->{'id'}||'forma_envio_id';
    $options_hash{'size'}       = $params->{'size'}||4;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||1;

    push (@select_formas_envio_array, '');
    $options_hash{'values'}     = \@select_formas_envio_array;
    $options_hash{'labels'}     = \%select_formas_envio;

    my $combo_formas_envio   = CGI::scrolling_list(\%options_hash);

    return $combo_formas_envio;
}

#genera el combo multiselect de tipo de materiales
sub generarComboTipoDeMaterial{
    my ($params) = @_;

    my @select_tipo_material_array;
    my %select_tipo_material;
    my $materiales        = &C4::AR::Referencias::obtenerTiposDeMaterial();

    foreach my $material (@$materiales) {
        push(@select_tipo_material_array, $material->getId);
        $select_tipo_material{$material->getId}  = $material->getNombre;
    }

    $select_tipo_material{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'tipo_material_id';
    $options_hash{'id'}         = $params->{'id'}||'tipo_material_id';
    $options_hash{'size'}       = $params->{'size'}||4;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||1;

    push (@select_tipo_material_array, '');
    $options_hash{'values'}     = \@select_tipo_material_array;
    $options_hash{'labels'}     = \%select_tipo_material;

    my $combo_tipo_materiales   = CGI::scrolling_list(\%options_hash);

    return $combo_tipo_materiales;
}

sub generarComboProveedoresMultiple{
    my ($params) = @_;

    my @select_proveedores_array;
    my %select_proveedores;
    my $proveedores        = &C4::AR::Referencias::obtenerProveedores();

    foreach my $prov (@$proveedores) {
        push(@select_proveedores_array, $prov->getId);
        if ($prov-> getNombre eq "") {
             $select_proveedores{$prov->getId}  = $prov->getRazonSocial;
        } else {
            $select_proveedores{$prov->getId}  = $prov->getNombre;
        }
    }

    $select_proveedores{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'proveedor_id';
    $options_hash{'id'}         = $params->{'id'}||'proveedor';
    $options_hash{'size'}       = $params->{'size'}||6;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||1;
    $options_hash{'defaults'}   = $params->{'default'} || 0;

    push (@select_proveedores_array, '');
    $options_hash{'values'}     = \@select_proveedores_array;
    $options_hash{'labels'}     = \%select_proveedores;

    my $combo_proveedores    = CGI::scrolling_list(\%options_hash);

    return $combo_proveedores;
}


sub generarComboProveedores{
    my ($params) = @_;

    my @select_proveedores_array;
    my %select_proveedores;
    my $proveedores        = &C4::AR::Referencias::obtenerProveedores();

    foreach my $prov (@$proveedores) {
        push(@select_proveedores_array, $prov->getId);
        if ($prov-> getNombre eq "") {
             $select_proveedores{$prov->getId}  = $prov->getRazonSocial;
        } else {
            $select_proveedores{$prov->getId}  = $prov->getNombre;
        }
    }

    $select_proveedores{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'proveedor_id';
    $options_hash{'id'}         = $params->{'id'}||'proveedor';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || 0;

    push (@select_proveedores_array, '');
    $options_hash{'values'}     = \@select_proveedores_array;
    $options_hash{'labels'}     = \%select_proveedores;

    my $combo_proveedores    = CGI::scrolling_list(\%options_hash);

    return $combo_proveedores;
}


sub generarComboPresupuestos{
    my ($params) = @_;
    use C4::AR::Presupuestos;

    my @select_presupuestos_array;
    my %select_presupuestos;
    my $presupuestos  = C4::AR::Presupuestos::getAdqPresupuestos();

    push (@select_presupuestos_array, '');


    foreach my $presupuesto (@$presupuestos) {
        push(@select_presupuestos_array, $presupuesto->getId);

# FIXME (ver si es persona fisica o razxon social)
        $select_presupuestos{$presupuesto->getId}  = $presupuesto->getId." - ".$presupuesto->ref_proveedor->getNombre." - ".$presupuesto->getFecha;

    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

     $options_hash{'name'}       = $params->{'name'}||'combo_presupuesto';
     $options_hash{'id'}         = $params->{'id'}||'combo_presupuesto';
     $options_hash{'size'}       = $params->{'size'}||1;
     $options_hash{'class'}      = 'required';
     $options_hash{'multiple'}   = $params->{'multiple'}||0;
     $options_hash{'defaults'}   = $params->{'default'} || 0;


    $options_hash{'values'}     = \@select_presupuestos_array;
    $options_hash{'labels'}     = \%select_presupuestos;

    my $combo_presupuestos  = CGI::scrolling_list(\%options_hash);

    return $combo_presupuestos;
}

sub generarComboPedidosCotizacion {
    my ($params) = @_;

    my @select_pedidos_array;
    my %select_pedidos;
    my $cotizaciones  = &C4::AR::PedidoCotizacion::getAdqPedidosCotizacion();

#     C4::AR::Debug::debug("RECOMENDACIONES:".$recomendaciones);

    push(@select_pedidos_array, 0);
    $select_pedidos{'0'}                = 'SIN SELECCIONAR';

    foreach my $cotizacion (@$cotizaciones) {
        push(@select_pedidos_array, $cotizacion->getId);
        $select_pedidos{$cotizacion->getId}  = $cotizacion->getId." - ".$cotizacion->getFecha
    }

    my %options_hash;



    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }




    $options_hash{'name'}       = $params->{'name'}||'combo_pedidos';
    $options_hash{'id'}         = $params->{'id'}||'combo_pedidos';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || 0;


    $options_hash{'values'}     = \@select_pedidos_array;
    $options_hash{'labels'}     = \%select_pedidos;

    my $combo_pedidos  = CGI::scrolling_list(\%options_hash);

    return $combo_pedidos;


}



sub generarComboRecomendaciones{
    my ($params) = @_;

    my @select_recomendaciones_array;
    my %select_recomendaciones;
    my $recomendaciones  = &C4::AR::Recomendaciones::getRecomendaciones();

    push (@select_recomendaciones_array, '');

#     C4::AR::Debug::debug("RECOMENDACIONES:".$recomendaciones);

    foreach my $recomendacion (@$recomendaciones) {
        push(@select_recomendaciones_array, $recomendacion->getId);
        $select_recomendaciones{$recomendacion->getId}  = $recomendacion->getId." - ".$recomendacion->ref_usr_socio->[0]->persona->nombre." - ".$recomendacion->getFecha;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

     $options_hash{'name'}       = $params->{'name'}||'combo_recomendaciones';
     $options_hash{'id'}         = $params->{'id'}||'combo_recomendaciones';
     $options_hash{'size'}       = $params->{'size'}||1;
     $options_hash{'class'}      = 'required';
     $options_hash{'multiple'}   = $params->{'multiple'}||0;
     $options_hash{'defaults'}   = $params->{'default'} || 0;


    $options_hash{'values'}     = \@select_recomendaciones_array;
    $options_hash{'labels'}     = \%select_recomendaciones;

    my $combo_recomendaciones  = CGI::scrolling_list(\%options_hash);

    return $combo_recomendaciones;
}


sub generarComboTipoNivel3ByEnable{

    my ($params) = @_;

    my @select_tipo_nivel3_array;
    my %select_tipo_nivel3_hash;
    my ($tipoNivel3_array_ref)  = &C4::AR::Referencias::obtenerEsquemaParaAltaRegistro($params->{'enable'});

    foreach my $tipoNivel3 (@$tipoNivel3_array_ref) {
        push(@select_tipo_nivel3_array, $tipoNivel3->id_tipo_doc);
        $select_tipo_nivel3_hash{$tipoNivel3->id_tipo_doc}= $tipoNivel3->nombre;
    }

    push (@select_tipo_nivel3_array, '');
    $select_tipo_nivel3_hash{''}    = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}  = $params->{'onChange'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'} = $params->{'class'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}  = $params->{'onFocus'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}   = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'tipo_nivel3_name';
    $options_hash{'id'}         = $params->{'id'}||'tipo_nivel3_id';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");

    push (@select_tipo_nivel3_array, 'ALL');
    $select_tipo_nivel3_hash{'ALL'} = 'TODOS';

    $options_hash{'values'}     = \@select_tipo_nivel3_array;
    $options_hash{'labels'}     = \%select_tipo_nivel3_hash;

    my $comboTipoNivel3         = CGI::scrolling_list(\%options_hash);

    return $comboTipoNivel3;
}

sub generarComboTipoNivel3{

    my ($params) = @_;

    my @select_tipo_nivel3_array;
    my %select_tipo_nivel3_hash;
    my ($tipoNivel3_array_ref)  = &C4::AR::Referencias::obtenerTiposNivel3();

    foreach my $tipoNivel3 (@$tipoNivel3_array_ref) {
        push(@select_tipo_nivel3_array, $tipoNivel3->id_tipo_doc);
        $select_tipo_nivel3_hash{$tipoNivel3->id_tipo_doc}= $tipoNivel3->nombre;
    }

    push (@select_tipo_nivel3_array, '');
    $select_tipo_nivel3_hash{''}    = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}  = $params->{'onChange'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'} = $params->{'class'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}  = $params->{'onFocus'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}   = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'tipo_nivel3_name';
    $options_hash{'id'}         = $params->{'id'}||'tipo_nivel3_id';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");

    # push (@select_tipo_nivel3_array, 'ALL');
    # $select_tipo_nivel3_hash{'ALL'} = 'TODOS';

    $options_hash{'values'}     = \@select_tipo_nivel3_array;
    $options_hash{'labels'}     = \%select_tipo_nivel3_hash;

    my $comboTipoNivel3         = CGI::scrolling_list(\%options_hash);

    return $comboTipoNivel3;
}

sub generarComboTipoPrestamo{

    my ($params) = @_;

    my @select_tipo_nivel3_array;
    my %select_tipo_prestamo_hash;

    require C4::Modelo::CircRefTipoPrestamo::Manager;
    my ($tipoPrestamo_array)= C4::Modelo::CircRefTipoPrestamo::Manager->get_circ_ref_tipo_prestamo();

    foreach my $tipoPrestamo (@$tipoPrestamo_array) {
        push(@select_tipo_nivel3_array, $tipoPrestamo->id_tipo_prestamo);
        $select_tipo_prestamo_hash{$tipoPrestamo->id_tipo_prestamo}= $tipoPrestamo->descripcion;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}= $params->{'onChange'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}= $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}= $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}= $params->{'onBlur'};
    }

    $options_hash{'name'}= $params->{'name'}||'tipo_prestamo_name';
    $options_hash{'id'}= $params->{'id'}||'tipo_prestamo_id';
    $options_hash{'size'}=  $params->{'size'}||1;
    $options_hash{'multiple'}= $params->{'multiple'}||0;

    $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultissuetype");

    push (@select_tipo_nivel3_array, '');
    $select_tipo_prestamo_hash{''} = "SIN SELECCIONAR";
    $options_hash{'values'}= \@select_tipo_nivel3_array;
    $options_hash{'labels'}= \%select_tipo_prestamo_hash;

    my $comboTipoNivel3= CGI::scrolling_list(\%options_hash);

    return $comboTipoNivel3;
}


sub generarComboTablasDeReferencia{

    my ($params) = @_;

    my @select_tabla_ref_array;
    my %select_tabla_ref_array;

    require C4::Modelo::PrefTablaReferencia::Manager;
    my ($tabla_ref_array)= C4::Modelo::PrefTablaReferencia::Manager->get_pref_tabla_referencia();

    foreach my $tabla (@$tabla_ref_array) {
        if(($tabla->isEditable) || ($params->{'ALL'})){
            push(@select_tabla_ref_array, $tabla->getAlias_tabla);
            $select_tabla_ref_array{$tabla->getAlias_tabla}= C4::AR::Filtros::i18n(Encode::decode_utf8(Encode::encode_utf8($tabla->getClient_title)));
        }
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}  = $params->{'onChange'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}      = $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}     = $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}       = $params->{'onBlur'};
    }

    $options_hash{'name'}           = $params->{'name'}||'tablas_ref';
    $options_hash{'id'}             = $params->{'id'}||'tablas_ref';
    $options_hash{'size'}           = $params->{'size'}||1;
    $options_hash{'multiple'}       = $params->{'multiple'}||0;
    $options_hash{'defaults'}       = $params->{'default'} || 'SIN SELECCIONAR';

#FIXME falta un default no?
#     $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");


    push (@select_tabla_ref_array, '-1');
    $select_tabla_ref_array{'-1'}   = 'SIN SELECCIONAR';
    $options_hash{'values'}         = \@select_tabla_ref_array;
    $options_hash{'labels'}         = \%select_tabla_ref_array;

    my $comboTipoNivel3             = CGI::scrolling_list(\%options_hash);

    return $comboTipoNivel3;
}

=item
    Igual que la de arriba, pero arma el select con los nombres de las tablas, en vez de su alias
=cut
sub generarComboTablasDeReferenciaByNombreTabla{

    my ($params) = @_;

    my @select_tabla_ref_array;
    my %select_tabla_ref_array;

    require C4::Modelo::PrefTablaReferencia::Manager;
    my ($tabla_ref_array)= C4::Modelo::PrefTablaReferencia::Manager->get_pref_tabla_referencia();


    foreach my $tabla (@$tabla_ref_array) {
        push(@select_tabla_ref_array, $tabla->getNombre_tabla);
        $select_tabla_ref_array{$tabla->getAlias_tabla}= C4::AR::Filtros::i18n($tabla->getClient_title);
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}  = $params->{'onChange'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}      = $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}     = $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}       = $params->{'onBlur'};
    }

    $options_hash{'name'}           = $params->{'name'}||'tablas_ref';
    $options_hash{'id'}             = $params->{'id'}||'tablas_ref';
    $options_hash{'size'}           = $params->{'size'}||1;
    $options_hash{'multiple'}       = $params->{'multiple'}||0;
    $options_hash{'defaults'}       = $params->{'default'} || 'SIN SELECCIONAR';

#FIXME falta un default no?
#     $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");


    push (@select_tabla_ref_array, '-1');
    $select_tabla_ref_array{'-1'}   = 'SIN SELECCIONAR';
    $options_hash{'values'}         = \@select_tabla_ref_array;
    $options_hash{'labels'}         = \%select_tabla_ref_array;

    my $comboTipoNivel3             = CGI::scrolling_list(\%options_hash);

    return $comboTipoNivel3;
}

# deprecated
sub generarComboDePerfilesOPAC{

    my ($params) = @_;

    my @select_perfil_ref_array;
    my %select_perfil_ref_array;

    require C4::Modelo::CatPerfilOpac::Manager;
    my ($perfiles)= C4::Modelo::CatPerfilOpac::Manager->get_cat_perfil_opac();


    foreach my $perfil (@$perfiles) {
        push(@select_perfil_ref_array, $perfil->id);
        $select_perfil_ref_array{$perfil->id}= $perfil->getNombre;
    }

    my %options_hash;

    $params->{'onChange'} = $params->{'onChange'} || 'eleccionDePerfil()';
    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}  = $params->{'onChange'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}      = $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}     = $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}       = $params->{'onBlur'};
    }

    $options_hash{'name'}           = $params->{'name'}||'perfiles_ref';
    $options_hash{'id'}             = $params->{'id'}||'perfiles_ref';
    $options_hash{'size'}           =  $params->{'size'}||1;
    $options_hash{'multiple'}       = $params->{'multiple'}||0;
    $options_hash{'defaults'}       = 'SIN SELECCIONAR';

#FIXME falta un default no?
#     $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");


    push (@select_perfil_ref_array, 'SIN SELECCIONAR');
    $options_hash{'values'}         = \@select_perfil_ref_array;
    $options_hash{'labels'}         = \%select_perfil_ref_array;

    my $combo_perfiles              = CGI::scrolling_list(\%options_hash);

    return $combo_perfiles;
}

#GENERA EL COMBO CON LOS BRANCHES, Y SETEA COMO DEFAULT EL PARAMETRO (QUE DEBE SER EL VALUE), SINO HAY PARAMETRO, SE TOMA LA PRIMERA
sub generarComboUI{

    my ($params) = @_;
    my @select_ui;
    my %select_ui;

    my $unidades_de_informacion= C4::AR::Referencias::obtenerUnidadesDeInformacion();

    foreach my $ui (@$unidades_de_informacion) {
        push(@select_ui, $ui->id_ui);
        $select_ui{$ui->id_ui}= $ui->nombre;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}= $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}= $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}= $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}= $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'name_ui';
    $options_hash{'id'}         = $params->{'id'}||'id_ui';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'multiple'}   = $params->{'multiple'}||0;
    $options_hash{'defaults'}   = $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultUI");

    if ($params->{'optionALL'}){
        push (@select_ui, 'ALL');
        $select_ui{'ALL'}='TODOS';
    }else{
        push (@select_ui, '');
        $select_ui{''}='SIN SELECCIONAR';
    }
    $options_hash{'values'}= \@select_ui;
    $options_hash{'labels'}= \%select_ui;

    my $CGIunidadDeInformacion= CGI::scrolling_list(\%options_hash);

    return $CGIunidadDeInformacion;
}

sub generarComboNivelBibliografico{

    my ($params) = @_;
    my @select_niveles;
    my %select_niveles;

    my $niveles_bibliograficos = C4::AR::Referencias::obtenerNivelesBibliograficos();

    foreach my $nivel (@$niveles_bibliograficos) {
# TODO ver si va el id o el code
        push(@select_niveles, $nivel->id);
        $select_niveles{$nivel->id}= $nivel->description;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'} = $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'} = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'name_nivel_bibliografico';
    $options_hash{'id'}         = $params->{'id'}||'id_nivel_bibliografico';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'multiple'}   = $params->{'multiple'}||0;

    my $nb;
    if(!$params->{'default'}) {
        $nb =C4::AR::Utilidades::getNivelBibliograficoByCode(C4::AR::Preferencias::getValorPreferencia('defaultNivelBibliografico'));
    }

    $options_hash{'defaults'}   = $params->{'default'} || $nb->getId;

    if ($params->{'optionALL'}){
        push (@select_niveles, 'ALL');
        $select_niveles{'ALL'}  = 'TODOS';
    }else{
        push (@select_niveles, '');
        $select_niveles{''}     = 'SIN SELECCIONAR';
    }
    $options_hash{'values'}     = \@select_niveles;
    $options_hash{'labels'}     = \%select_niveles;

    my $CGI_Nivel_Bibliografico = CGI::scrolling_list(\%options_hash);

    return $CGI_Nivel_Bibliografico;
}

sub generarComboDeSocios{

    my ($params) = @_;
    my @select_socios;
    my %select_socios;
    my $socios  = C4::Modelo::UsrSocio::Manager->get_usr_socio( query => [
                                                                          activo => {eq => 1},
                                                                       ],);

    foreach my $socio (@$socios) {
        push(@select_socios, $socio->getNro_socio);
        $select_socios{$socio->getNro_socio}= $socio->persona->getApeYNom." (".$socio->getNro_socio.")" ;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}     = $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}           = $params->{'name'}||'ui_name';
    $options_hash{'id'}             = $params->{'id'}||'socios';
    $options_hash{'size'}           =  $params->{'size'}||1;
    $options_hash{'multiple'}       = $params->{'multiple'}||0;
    $options_hash{'defaults'}       = $params->{'default'} || '-1';

    push (@select_socios, '-1');
    $select_socios{'-1'}            ='SIN SELECCIONAR';
    $options_hash{'values'}         = \@select_socios;
    $options_hash{'labels'}         = \%select_socios;

    my $CGIsocios                   = CGI::scrolling_list(\%options_hash);

    return $CGIsocios;
}


sub generarComboCampoX{

    my $onReadyFunction = shift;
    my $defaultCampoX = shift;
    my $idCombo = shift;
    #Filtro de numero de campo
    my %camposX;
    my @values;

    push (@values, -1);
    $camposX{-1}="Elegir";
    my $option;

    for (my $i =0 ; $i <= 9; $i++){
        push (@values, $i);
        $option= $i."xx";
        $camposX{$i}=$option;
    }
    my $defaulCX= $defaultCampoX || 'Elegir';
    my $idCX= $idCombo || 'campoX';
    my $selectCampoX=CGI::scrolling_list(  -name      => $idCX,
                    -id    => $idCX,
                    -values    => \@values,
                    -labels    => \%camposX,
                    -defaults  => $defaulCX,
                    -size      => 1,
                    -onChange  => $onReadyFunction,
    );

    return ($selectCampoX);
}

sub generarComboTipoDeOperacion{

    my ($params) = @_;

    require C4::Modelo::RefTipoOperacion::Manager;
    my @select_tipoOperacion_Values;
    my %select_tipoOperacion_Labels;
    my $result = C4::Modelo::RefTipoOperacion::Manager->get_ref_tipo_operacion();

    foreach my $tipoOperacion (@$result) {
        if ( $params->{'clone_values'} ){
        #si el label y el ID son iguales
            push (@select_tipoOperacion_Values, $tipoOperacion->descripcion);
            $select_tipoOperacion_Labels{$tipoOperacion->descripcion} = $tipoOperacion->descripcion;
        }else{
            push (@select_tipoOperacion_Values, $tipoOperacion->id);
            $select_tipoOperacion_Labels{$tipoOperacion->id} = $tipoOperacion->descripcion;
        }
    }

    my $CGISelectTipoOperacion=CGI::scrolling_list(    -name      => 'tipoOperacion',
                                                        -id        => 'tipoOperacion',
                                                        -values    => \@select_tipoOperacion_Values,
                                                        -labels    => \%select_tipoOperacion_Labels,
                                                        -size      => 1,
                                                        -defaults  => 'SIN SELECCIONAR'
                                                    );

    return $CGISelectTipoOperacion;
}


sub generarComboEsquemasImportacion {

    my ($params) = @_;

    require C4::Modelo::IoImportacionIsoEsquema::Manager;
    my @select_esquemasImportacion_Values;
    my %select_esquemasImportacion_Labels;
    my $result = C4::Modelo::IoImportacionIsoEsquema::Manager->get_io_importacion_iso_esquema();
    my $result_count = C4::Modelo::IoImportacionIsoEsquema::Manager->get_io_importacion_iso_esquema_count();

    if ($result_count){
        foreach my $esquemaImportacion (@$result) {
                push (@select_esquemasImportacion_Values, $esquemaImportacion->id);
                $select_esquemasImportacion_Labels{$esquemaImportacion->id} = $esquemaImportacion->nombre;
        }


        my %options_hash;

        if ( $params->{'onChange'} ){
             $options_hash{'onChange'}  = $params->{'onChange'};
        }

        if ( $params->{'onFocus'} ){
          $options_hash{'onFocus'}      = $params->{'onFocus'};
        }

        if ( $params->{'class'} ){
             $options_hash{'class'}     = $params->{'class'};
        }

        if ( $params->{'onBlur'} ){
          $options_hash{'onBlur'}       = $params->{'onBlur'};
        }

        $options_hash{'name'}           = $params->{'name'}||'esquemaImportacion';
        $options_hash{'id'}             = $params->{'id'}||'esquemaImportacion';
        $options_hash{'size'}           =  $params->{'size'}||1;
        $options_hash{'multiple'}       = $params->{'multiple'}||0;

        $options_hash{'values'}         = \@select_esquemasImportacion_Values;
        $options_hash{'labels'}         = \%select_esquemasImportacion_Labels;

        my $CGISelectEsquemaImportacion                   = CGI::scrolling_list(\%options_hash);
        return $CGISelectEsquemaImportacion;
    }else{
        return 0;
    }
}

sub generarComboFormatosImportacion {

    my ($params) = @_;

    my @select_formatosImportacion_Values;
    my %select_formatosImportacion_Labels;

    my %options_hash;

    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}  = $params->{'onChange'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}      = $params->{'onFocus'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}     = $params->{'class'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}       = $params->{'onBlur'};
    }

    $options_hash{'name'}           = $params->{'name'}||'formatoImportacion';
    $options_hash{'id'}             = $params->{'id'}||'formatoImportacion';
    $options_hash{'size'}           =  $params->{'size'}||1;
    $options_hash{'multiple'}       = $params->{'multiple'}||0;
    $options_hash{'defaults'}       = 'ISO 2709';

    push (@select_formatosImportacion_Values, 'iso');
    $select_formatosImportacion_Labels{'iso'}            ='ISO 2709';
    push (@select_formatosImportacion_Values, 'isis');
    $select_formatosImportacion_Labels{'isis'}            ='ISIS';
    push (@select_formatosImportacion_Values, 'xml');
    $select_formatosImportacion_Labels{'xml'}            ='XML';
    
    push (@select_formatosImportacion_Values, 'xls');
    $select_formatosImportacion_Labels{'xls'}            ='Planilla de Cálculo';

    $options_hash{'values'}         = \@select_formatosImportacion_Values;
    $options_hash{'labels'}         = \%select_formatosImportacion_Labels;

    my $CGISelectFormatosImportacion                   = CGI::scrolling_list(\%options_hash);
    return $CGISelectFormatosImportacion;
}

sub generarComboNiveles{

    my ($params) = @_;
    my @nivel;
    my $cantNivel=3;

#     push(@nivel, "Niveles");
    for (my $i=1; $i<=$cantNivel; $i++){
        push(@nivel, $i);
    }
    my @select_niveles;
    my %select_niveles;

    foreach my $nivel (@nivel) {
        push(@select_niveles, $nivel);
        $select_niveles{$nivel}= $nivel;
    }
    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}= $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}= $params->{'onFocus'};
    }
    if ( $params->{'class'} ){
         $options_hash{'class'}= $params->{'class'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}= $params->{'onBlur'};
    }

    $options_hash{'name'}= 'niveles_name';
    $options_hash{'id'}= 'niveles_id';
    $options_hash{'size'}=  $params->{'size'}||1;
    $options_hash{'multiple'}= $params->{'multiple'}||0;
    $options_hash{'defaults'}= $params->{'default'} || 'SIN SELECCIONAR';

    push (@select_niveles, 'SIN SELECCIONAR');
    $options_hash{'values'}= \@select_niveles;
    $options_hash{'labels'}= \%select_niveles;

    my $CGINiveles= CGI::scrolling_list(\%options_hash);

    return $CGINiveles;
}

# GENERA COMBO CON LAS EDICIONES PARA UN ID DADO

# FIXME debe recibir una hash con parametros
sub generarComboNivel2{
    my ($params) = @_;

    my @select_ediciones_array;
    my %select_ediciones_hash;

    my ($ediciones_array_ref)= C4::AR::Nivel2::getNivel2FromId1($params);

    foreach my $edicion (@$ediciones_array_ref) {
        push(@select_ediciones_array, $edicion->getId2);
        $select_ediciones_hash{$edicion->getId2}= $edicion->toString;
    }

    my %options_hash;

# FIXME esto tiene q estar
#     if ( $params->{'onChange'} ){
#         $options_hash{'onChange'}   = $params->{'onChange'};
#     }
#     if ( $params->{'onFocus'} ){
#         $options_hash{'onFocus'}    = $params->{'onFocus'};
#     }
#     if ( $params->{'onBlur'} ){
#         $options_hash{'onBlur'}     = $params->{'onBlur'};
#     }

    $options_hash{'name'}       = 'edicion_id';
    $options_hash{'id'}         = 'edicion_id';
    $options_hash{'size'}       = 1;
    $options_hash{'multiple'}   = 0;
    $options_hash{'defaults'}   = C4::AR::Preferencias::getValorPreferencia("defaultEdicion");

    push (@select_ediciones_array, '');
    $select_ediciones_hash{''} = "OTRA";
    $options_hash{'values'}     = \@select_ediciones_array;
    $options_hash{'labels'}     = \%select_ediciones_hash;

    my $comboDeEdiciones       = CGI::scrolling_list(\%options_hash);

    return $comboDeEdiciones;
}


# GENERA COMBO CON LAS EDICIONES PARA UN ID DADO. POR AHORA SE USA EN ANALITICAS

sub generarComboNivel2Detalle{
    my ($params) = @_;

    my @select_ediciones_array;
    my %select_ediciones_hash;

    my ($ediciones_array_ref)= C4::AR::Nivel2::getNivel2FromId1($params);

    foreach my $edicion (@$ediciones_array_ref) {
        push(@select_ediciones_array, $edicion->getId2);
        $select_ediciones_hash{$edicion->getId2}= $edicion->toString;
    }

    my %options_hash;
    $options_hash{'name'}       = 'edicion_id';
    $options_hash{'id'}         = 'edicion_id';
    $options_hash{'size'}       = 1;
    $options_hash{'multiple'}   = 0;
    $options_hash{'values'}     = \@select_ediciones_array;
    $options_hash{'labels'}     = \%select_ediciones_hash;

    my $comboDeEdiciones       = CGI::scrolling_list(\%options_hash);

    return $comboDeEdiciones;
}



#****************************************************Fin****Generacion de Combos**************************************************

#sub getToday{

#   my @datearr = localtime(time);
#   my $today =(1900+$datearr[5])."-".($datearr[4]+1)."-".$datearr[3];
#   my $dateformat = C4::Date::get_date_format();

#   return (format_date($today,$dateformat));
#}

sub printARRAY{

    my ($array_ref) = @_;

    C4::AR::Debug::debug("PRINT ARRAY: \n");

    if($array_ref){
        foreach my  $value (@$array_ref) {
                C4::AR::Debug::debug("value: $value\n");
            }
    }
}


sub printHASH{

    my ($hash_ref) = @_;

    C4::AR::Debug::debug("PRINT HASH: \n");

    if($hash_ref){
        while ( my ($key, $value) = each(%$hash_ref) ) {
                C4::AR::Debug::debug("key: $key => value: $value\n");
            }
    }
}

sub escapeHashData{

    my ($hash_ref) = @_;
    C4::AR::Debug::debug("ENTRO A escapeHashData ================================>");
    if($hash_ref){
        while ( my ($key, $value) = each(%$hash_ref) ) {
                C4::AR::Debug::debug("key: $key => value: $value\n");
                if($value =~ /[<>]/){
                    $value = encode_entities($value);
                }
                $hash_ref->{$key} = $value;

                C4::AR::Debug::debug("ENCODED key: $key => value: $value\n");
            }
    }

    return ($hash_ref);
}

sub escapeData{

    my ($data) = @_;
    if($data){
        # Pasa a entidades HTML los caracteres especiales, para que no sean interpretados como otra cosa
        #FIX: EL encode funciona bien con todas las vocales con diéresis menos la Ü(?)
        $data =~ s/Ü/#U#/g;
        $data = encode_entities($data, '<>&"“”\'');
        $data =~ s/#U#/Ü/g;
        
    }
    return ($data);
}


sub cleanPunctuation{
    my ($data) = @_;
    if($data){
        # Pasa a entidades HTML los caracteres especiales, para que no sean interpretados como otra cosa
        $data =~ s/[[:punct:]]/ /g; 
        $data =~ s/[¿,¡,“,”]/ /g; # estos no lo elimina el anterior
    }
    return ($data);
}

sub initHASH{

    my ($hash_ref) = @_;
    my @keys = keys(%$hash_ref);

    foreach my $key (@keys) {
        C4::AR::Debug::debug("key ".$key.": has the value ".$hash_ref->{$key}."\n");
        $hash_ref->{$key}= undef;
    }

    $hash_ref= \{};
}

sub joinArrayOfString{

    my (@columns) = @_;
    my ($fieldsString) = "";

    foreach my $campo (@columns){
        $fieldsString.= $campo." ";
    }

    return ($fieldsString);
}

=item
Esta funcion convierte el arreglo de objetos (Rose::DB) a JSON
=cut
sub arrayObjectsToJSONString{

    my ($objects_array) = @_;
    my @objects_array_JSON;

    require utf8;

    for(my $i=0; $i<scalar(@$objects_array); $i++ ){
        push (@objects_array_JSON, $objects_array->[$i]->as_json);
    }

    my $infoJSON= '[' . join(',' ,@objects_array_JSON) . ']';

    utf8::decode($infoJSON);

    return $infoJSON;
}

=item
Esta funcion convierte el arreglo de valores a JSON {campo->campo}
=cut
sub arrayToJSONString{

    my ($array) = @_;
    my @array_JSON;

    for(my $i=0; $i<scalar(@$array); $i++ ){
        push (@array_JSON,"{'campo':'".$array->[$i]->{'campo'}."'}");
    }

    my $infoJSON= '[' . join(',' ,@array_JSON) . ']';

    return $infoJSON;
}

=item
Esta funcion convierte el arreglo de los pares clave/valor a JSON {clave->clave,valor->valor}
=cut
sub arrayClaveValorToJSONString{

    my ($array) = @_;
    my @array_JSON;

    for(my $i=0; $i<scalar(@$array); $i++ ){
        push (@array_JSON,"{'clave':'".$array->[$i]->{'clave'}."',valor':'".$array->[$i]->{'valor'}."'}");
    }

    my $infoJSON= '[' . join(',' ,@array_JSON) . ']';

    return $infoJSON;
}


=head2
sub existeInArray

   Esta funcion recibe un string seguido de un arreglo y busca en el arreglo el string, y devuelve 1 o 0
=cut
sub existeInArray{
    my ($string,@array) = @_;

    if (grep {$_ eq $string} @array) {
#         C4::AR::Debug::debug("Utilidades => existeInArray => EXISTE => ".$string." en el arreglo");
        return 1;
    }

#         C4::AR::Debug::debug("Utilidades => existeInArray => NO EXISTE => ".$string." en el arreglo");
    return 0;
}

sub getIndexFromArrayByString{
    my ($string, $array_ref) = @_;
# TODO mejorarlo!!!!!!!!!
    for(my $i=0;$i< scalar(@$array_ref);$i++){
        if(trim($array_ref->[$i]->{'campo'}) eq trim($string)){
            return $i;
        }
    }

    return -1;
}

=item
Esta funcion verifica si el user_agent es un browser
=cut
sub isBrowser{

    my $browser= $ENV{'HTTP_USER_AGENT'};
    my $ok=1;

    if ( $browser =~ s/Mozilla// ) {
        if ($browser =~ s/(MSIE)//){
            # print Z "IE \n";
        }
        if($browser =~ s/(Chrome)//){
            # print Z "Chrome \n";
        }

        if($browser =~ s/(Iceweasel)//){
            # print Z "Iceweasel \n";
        }
    }elsif( $browser =~ s/(Opera)//) {
        # print Z "Opera \n";
    }else{
        # print Z "otro \n";
        $ok= 0;
    }
    return $ok;
}

=item
Esta funcion "corta" un arreglo desde ini hasta fin
se la utiliza cuando se realiza una consulta a la base, se recupera la info y deben procesarse todos los resultados si o si
o sea cuando no se puede limitar con MYSQL
=cut
sub paginarArreglo{

    #La variable $ini, no es el numero de pagina, sino es la posicion ya calculada (la que devuelve InitPaginador)
    my ($ini,$fin,@array) = @_;
    C4::AR::Debug::debug(" Utilidades::paginarArreglo => INI: ".$ini." FIN: ".$fin);
    C4::AR::Debug::debug(" Utilidades::paginarArreglo => CANT ARRAY antes de paginar: ".scalar(@array));

    my $cant_total = scalar(@array);
    my $division_temp  = floor ($cant_total / $fin);
    my $resto = $cant_total - ($division_temp * $fin);
    my $numPagina = ceil($ini / $fin) + 1;

    if ( ($numPagina > $division_temp) ){
        @array = @array[$ini..($ini + $resto-1)];
        C4::AR::Debug::debug(" Utilidades::paginarArreglo => CANT ARRAY if: ".scalar(@array));
    }else{
        @array = @array[$ini..($ini + $fin-1)];
        C4::AR::Debug::debug(" Utilidades::paginarArreglo => CANT ARRAY else: ".scalar(@array));
    }

    C4::AR::Debug::debug(" Utilidades::paginarArreglo => CANT ARRAY despues de paginar: ".scalar(@array));

    return ($cant_total,@array);
}

=item
Esta funcion recibe un string separado por 1 o mas blancos, y devuelve un arreglo de las palabras que se ingresaron
para realizar la busqueda
=cut
sub obtenerBusquedas{

    my ($searchstring) = @_;
    my @search_array;
    my @busqueda= split(/ /,$searchstring); #splitea por blancos, retorna un arreglo de substring, puede estar
    my $pal;

    foreach my  $b (@busqueda){
        $pal= trim($b);
        if( length($pal) > 0 ){
#             C4::AR::Debug::debug('agrego: '.$pal);
            push(@search_array, $pal);
        }
    }

    return (@search_array);
}

=item
obtenerCoincidenciasDeBusqueda
=cut
sub obtenerCoincidenciasDeBusqueda{

    my ($string, $search_array) = @_;
    my $cant= 0;
    my $cont= 0;

    $string= lc $string;
    foreach my $search (@$search_array){
        $cant= 0;
        $search= lc $search;
        while ($string =~ /$search/g) {
            $cant++;
        }
        $cont += $cant;
    }

    return $cont;
}


#CAPITALIZAR UN STRING (primer letra en mayuscula, el resto en minuscula

sub capitalizarString{

    my ($string) = @_;

    my @words = split(/ /,$string);
    my $final_string = "";
    
    foreach my $word (@words){
        $final_string .= ucfirst(lc($word))." ";
    }

    return (C4::AR::Utilidades::trim($final_string)); #Quitamos el último espacio
}
=item
Esta funcion ordena una HASH de strings
orden: es el orden por el que se va a ordenar la HASH
DESC: 1 si es descendente, 0 = ascendente
info: la informacion de la HASH a ordenar
devuelve un arreglo de HASHES listo para enviar al template
=cut
sub sortHASHString {
    my ($params) = @_;

    my $desc        = $params->{'DESC'};
    my $orden       = $params->{'orden'};
    my $info        = $params->{'info'};
    my @keys        = keys %$info;

    if($desc){
    #ordena la HASH de strings de manera DESC
        @keys= sort{$info->{$a}->{$orden} cmp $info->{$b}->{$orden}} @keys;
    }else{
    #ordena la HASH de strings de manera ASC
        @keys= sort{$info->{$b}->{$orden} cmp $info->{$a}->{$orden}} @keys;
    }
    my @resultsarray;

    foreach my $row (@keys){
        push (@resultsarray, $info->{$row});
    }

    return @resultsarray;
}

=item
Esta funcion ordena una HASH de numericos
orden: es el orden por el que se va a ordenar la HASH
DESC: 1 si es descendente, 0 = ascendente
info: la informacion de la HASH a ordenar
devuelve un arreglo de HASHES listo para enviar al template
=cut
sub sortHASHNumber{

    my ($params) = @_;
    my $desc= $params->{'DESC'};
    my $orden= $params->{'orden'};
    my $info= $params->{'info'};
    my @keys=keys %$info;

    if($desc){
    #ordena la HASH de strings de manera DESC
        @keys= sort{$info->{$b}->{$orden} <=> $info->{$a}->{$orden}} @keys;
    }else{
    #ordena la HASH de strings de manera ASC
        @keys= sort{$info->{$a}->{$orden} <=> $info->{$b}->{$orden}} @keys;
    }
    my @resultsarray;

    foreach my $row (@keys){
        push (@resultsarray, $info->{$row});
    }

    return @resultsarray;
}

sub stringToArray{

    my ($string);

    return( split(/\b/,$string) );
}

############################## Funciones para AUTOCOMPLETABLES #############################################################

sub monedasAutocomplete{
    my ($moneda)= @_;

C4::AR::Debug::debug("moneda".$moneda);
    my $textout;
    my @result;
    if ($moneda){
        my($cant, $result) = C4::AR::Utilidades::buscarMonedas($moneda);# agregado sacar
        $textout= "";
        for (my $i; $i<$cant; $i++){
            $textout.= $result->[$i]->{'id'}."|".$result->[$i]->{'nombre'}."\n";
        }
    }


    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}


sub autorAutocomplete{

    my ($autorStr) = @_;
    my $textout;
    my $autores_array_ref= C4::AR::Referencias::obtenerAutoresLike($autorStr);

    foreach my $autor (@$autores_array_ref){
        $textout.= $autor->getId."|".$autor->getCompleto."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
#     return ($textout eq '')?"-1|".$autorStr:$textout;
}

sub obtenerDescripcionDeSubCampos{

    my ($campo)= @_;
    my ($sub_campos_marc_array_ref) = &C4::AR::Referencias::obtenerSubCamposDeCampo($campo);
    my $textout;

    foreach my $sub_campo_marc (@$sub_campos_marc_array_ref) {
        $textout .= $sub_campo_marc->getSubcampo."/".$sub_campo_marc->getSubcampo." - ".$sub_campo_marc->getLiblibrarian."#";
    }

    return $textout;
}

sub ayudaCampoMARCAutocomplete{
    my ($campo) = @_;

    my $campos_marc_array_ref= &C4::AR::Referencias::obtenerCamposLike($campo);
    my $textout;

    foreach my $campo_marc (@$campos_marc_array_ref){
        $textout.= $campo_marc->getCampo."| (".$campo_marc->getCampo.") ".$campo_marc->getLiblibrarian."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub uiAutocomplete{
    my ($uiStr) = @_;

    my $textout;
    my $autores_array_ref= C4::AR::Referencias::obtenerUILike($uiStr);

    foreach my $ui (@$autores_array_ref){
        $textout.= $ui->getId_ui."|".$ui->getNombre."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub nivel2Autocomplete{
    my ($n2Str) = @_;

    my $textout;
    my $n2_array_ref= C4::AR::Referencias::obtenerNivel2Like($n2Str);

    foreach my $n2 (@$n2_array_ref){
        $textout.= $n2->getId."|".$n2->getId."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub gruposAutocomplete{
    my ($n2Str) = @_;

    my $textout;
    my $n2_array_ref= C4::AR::Referencias::obtenerNivel2Like($n2Str);

    foreach my $n2 (@$n2_array_ref){
        $textout.= $n2->getId."|".$n2->getId."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub bibliosAutocomplete{

    my ($biblioStr) = @_;
    my $textout="";
    my @result=C4::AR::Utilidades::obtenerBiblios($biblioStr);

    foreach my $biblio (@result){
        $textout.=$biblio->{'branchname'}."|".$biblio->{'id'}."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub autocompleteTemas{

    my ($tema) = @_;
    my $i=0;
    my ($cant, $temas_array_ref)= &C4::AR::ControlAutoridades::search_temas($tema);
    my $resultado="";

    foreach my $tema (@$temas_array_ref){
        $resultado .=  $tema->getId."|". $tema->getNombre. "\n";
    }

        return ($resultado eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$resultado;
}


=head2
    sub autoresAutocomplete

=cut
sub autoresAutocomplete{
    my ($autor) = @_;

    my ($cant, $autores_array_ref) = C4::AR::ControlAutoridades::search_autores($autor);
    my $resultado = "";

    foreach my $autor (@$autores_array_ref){
        $resultado .=  $autor->getId."|". $autor->getCompleto. "\n";
    }

    return ($resultado eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$resultado;
#     return ($resultado eq '')?"-1|".$autor:$resultado;
}

sub autocompleteEditoriales{

    my ($editorial) = @_;
    my $resultado="";
    my ($cant, $editoriales_array_ref)= &C4::AR::ControlAutoridades::search_editoriales($editorial);
    my $resultado="";

    foreach my $editorial (@$editoriales_array_ref){
                      $resultado .=  $editorial->getId."|". $editorial->getEditorial. "\n";

    }

    return ($resultado eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$resultado;

}

sub autocompleteAyudaMarc{

    my ($editorial) = @_;
    my ($cant, @results)= &C4::AR::ControlAutoridades::search_editoriales($editorial);
    my $i=0;
    my $resultado="";
    my $field;
    my $data;

    for ($i; $i<$cant; $i++){
        $field=$results[$i]->{'campo'};
        $data=$results[$i]->{'liblibrarian'};
        $resultado .= $field."|".$data. "\n";
    }

    return ($resultado eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$resultado;

}

sub lenguajesAutocomplete{

    my ($lenguaje) = @_;
    my $textout;
    my @result;

    if ($lenguaje){
        my($cant, $result) = C4::AR::Utilidades::buscarLenguajes($lenguaje);# agregado sacar
        $textout= "";
        for (my $i; $i<$cant; $i++){
            $textout.= $result->[$i]->{'idLanguage'}."|".$result->[$i]->{'description'}."\n";
        }
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;

#    my ($cant, $lenguajes_array_ref)= C4::AR::Utilidades::buscarLenguaje($lenguaje);
#    my $resultado="";

#    foreach my $lenguaje (@$lenguajes_array_ref){
#        $resultado .=  $lenguaje->getId."|". $lenguaje->getDescription. "\n";
#    }

#    return ($resultado eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$resultado;

}

sub nivelBibliograficoAutocomplete{

    my ($nivelBibliografico) = @_;
    my $textout;
    my @result;

    if ($nivelBibliografico){
        my($cant, $result) = C4::AR::Utilidades::buscarNivelesBibliograficos($nivelBibliografico);
        $textout= "";
        for (my $i; $i<$cant; $i++){
            $textout.= $result->[$i]->{'code'}."|".$result->[$i]->{'description'}."\n";
        }
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub paisesAutocomplete{

    my ($paisesStr)= @_;;
    my $textout="";
    my ($cant, $paises_array_ref)=C4::AR::Utilidades::obtenerPaises($paisesStr);

    foreach my $pais (@$paises_array_ref){
        $textout.=$pais->getIso."|".$pais->getNombre_largo."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}


sub ciudadesAutocomplete{

    my ($ciudad)= @_;
    my $textout="";
    my ($cant, $ciudades_array_ref)=C4::AR::Utilidades::obtenerCiudades($ciudad);

    foreach my $localidad (@$ciudades_array_ref){
        $textout.=$localidad->getIdLocalidad."|".$localidad->getNombre."\n";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

# sub catalogoBibliotecaAutocomplete{
#
#     my ($busquedaStr)= @_;;
#     my $textout="";
#     my ($cant, $busqueda_array_ref)=C4::AR::Utilidades::obtenerCatalogo($busquedaStr);
#
#     foreach my $item (@$busqueda_array_ref){
#         $textout.=$pais->getIso."|".$pais->getNombre_largo."\n";
#     }
#
#     return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
#
# }

sub getSphinxMatchMode{
  my ($tipo) = @_;
  use Sphinx::Search;

  #por defecto se setea este match_mode
  my $tipo_match = SPH_MATCH_ANY;

  if($tipo eq 'SPH_MATCH_ANY'){
    #Match any words
    $tipo_match = SPH_MATCH_ANY;
  }elsif($tipo eq 'SPH_MATCH_PHRASE'){
    #Exact phrase match
    $tipo_match = SPH_MATCH_PHRASE;
  }elsif($tipo eq 'SPH_MATCH_BOOLEAN'){
    #Boolean match, using AND (&), OR (|), NOT (!,-) and parenthetic grouping
    $tipo_match = SPH_MATCH_BOOLEAN;
  }elsif($tipo eq 'SPH_MATCH_EXTENDED'){
    #Extended match, which includes the Boolean syntax plus field, phrase and proximity operators
    $tipo_match = SPH_MATCH_EXTENDED;
  }elsif($tipo eq 'SPH_MATCH_ALL'){
    #Match all words
    $tipo_match = SPH_MATCH_ALL;
  }

  return ($tipo_match);
}

sub createSphinxInstance{
    my ($string_array,$tipo) = @_;

    use Sphinx::Search;
    my $sphinx = Sphinx::Search->new();

    my $server_address = C4::Context->config("sphinx_server") || 'localhost';

    my $server_port = C4::Context->config("server_port") || '3312';

    $sphinx->SetServer($server_address, $server_port);

    my $query = '';

    my $tipo_match  = getSphinxMatchMode($tipo);

    #se arma el query string
    foreach my $string (@$string_array){

        if($tipo eq 'SPH_MATCH_PHRASE'){
            $query .=  " ".$string;
        } else {
            $query .=  " ".$string."*";
        }
    }

    $sphinx->SetMatchMode($tipo_match);
    $sphinx->SetSortMode(SPH_SORT_RELEVANCE);
    $sphinx->SetEncoders(\&Encode::encode_utf8, \&Encode::decode_utf8);

    return ($sphinx,$query);

}

sub catalogoAutocomplete{

     my ($string_utf8_encoded) = @_;

     $string_utf8_encoded       = Encode::decode_utf8($string_utf8_encoded);
     my @data_array;
     my %params                 = {};

     $params{'tipo'}            = "normal";
     $params{'ini'}             = 0;
     $params{'cantR'}           = 20;
     $params{'from_suggested'}  = 1;

     my $session = CGI::Session->load();
     my ($cantidad, $resultado_busquedas, $suggested)= C4::AR::Busquedas::busquedaCombinada_newTemp($string_utf8_encoded, $session, \%params, 0);

     my $textout = "";


      foreach my $documento (@$resultado_busquedas){
            my %has_temp;
            $has_temp{'id'}     = $documento->{'id1'};
            # C4::AR::Debug::debug("CANTIDAD DE NIVELES ENCONTRADOS EN AUTOCOMPLETE ==============> ".$cantidad);
            $has_temp{'dato'}   = $documento->{'titulo'};
            
            if($documento->{'nomCompleto'}){ 
                    $has_temp{'dato'} .= " (".$documento->{'nomCompleto'}.")";
            }
            
            $has_temp{'dato'} .= "\n";
            push (@data_array, \%has_temp);

#              C4::AR::Debug::debug("CANTIDAD DE NIVELES ENCONTRADOS EN AUTOCOMPLETE ==============> ".$cantidad);
#              $textout.= $documento->{'id1'}."|".$documento->{'titulo'}."\n";
      }

     $textout= getTextOutSorted(\@data_array, {'DESC' => 1, 'ORDER_BY' => 'dato'});

     return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub catalogoAutocompleteId{

     my ($string_utf8_encoded) = @_;

     $string_utf8_encoded       = Encode::decode_utf8($string_utf8_encoded);
     my @data_array;
     my %params                 = {};

     $params{'tipo'}            = "normal";
     $params{'ini'}             = 0;
     $params{'cantR'}           = 20;
     $params{'from_suggested'}  = 1;

     my $session = CGI::Session->load();
     my ($cantidad, $resultado_busquedas, $suggested)= C4::AR::Busquedas::busquedaPorId($string_utf8_encoded, $session);

     my $textout = "";


      foreach my $documento (@$resultado_busquedas){
            my %has_temp;
            $has_temp{'id'}     = $documento->{'id1'};
            # C4::AR::Debug::debug("CANTIDAD DE NIVELES ENCONTRADOS EN AUTOCOMPLETE ==============> ".$cantidad);
            $has_temp{'dato'}   = $documento->{'titulo'};
            if($documento->{'nomCompleto'}){ $has_temp{'dato'} .= " (".$documento->{'nomCompleto'}.")";}
            $has_temp{'dato'} .= "\n";
            push (@data_array, \%has_temp);

#              C4::AR::Debug::debug("CANTIDAD DE NIVELES ENCONTRADOS EN AUTOCOMPLETE ==============> ".$cantidad);
#              $textout.= $documento->{'id1'}."|".$documento->{'titulo'}."\n";
      }

     $textout= getTextOutSorted(\@data_array, {'DESC' => 1, 'ORDER_BY' => 'dato'});

     return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}


sub gruposAutocomplete{

     my ($string_utf8_encoded) = @_;

     $string_utf8_encoded       = Encode::decode_utf8($string_utf8_encoded);
     my @data_array;
     my %params                 = {};

     $params{'tipo'}            = "normal";
     $params{'ini'}             = 0;
     $params{'cantR'}           = 20;
     $params{'from_suggested'}  = 1;

     my $session = CGI::Session->load();
     my ($cantidad, $resultado_busquedas, $suggested)= C4::AR::Busquedas::busquedaCombinada_newTemp($string_utf8_encoded, $session, \%params, 0);

     my $textout = "";


    foreach my $documento (@$resultado_busquedas){
        my %has_temp;
        $has_temp{'id'}     = $documento->{'id1'};
        # C4::AR::Debug::debug("CANTIDAD DE NIVELES ENCONTRADOS EN AUTOCOMPLETE ==============> ".$cantidad);
        $has_temp{'dato'}   = $documento->{'titulo'};
        
        if($documento->{'nomCompleto'}){ 
                $has_temp{'dato'} .= " (".$documento->{'nomCompleto'}.")";
        }
        
        my $nivel2_array_ref = C4::AR::Nivel2::getNivel2FromId1($documento->{'id1'});

        foreach my $n2 (@$nivel2_array_ref){
            my %has_temp_aux;

            $has_temp_aux{'dato'}   = $has_temp{'dato'} . ' - ' . $n2->getEdicion() . " " . $n2->getAnio_publicacion() . "\n";
            $has_temp_aux{'id'}     = $n2->getId2();#$documento->{'id1'};
            $has_temp_aux{'id2'}    = $n2->getId2();
            push (@data_array, \%has_temp_aux);
        }

    #              C4::AR::Debug::debug("CANTIDAD DE NIVELES ENCONTRADOS EN AUTOCOMPLETE ==============> ".$cantidad);
    #              $textout.= $documento->{'id1'}."|".$documento->{'titulo'}."\n";
    }

    $textout= getTextOutSorted(\@data_array, {'DESC' => 1, 'ORDER_BY' => 'dato'});

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub temasAutocomplete{

    my ($temaStr,$campos,$separador) = @_;
    my $textout="";
    my @result=C4::AR::Utilidades::obtenerTemas2($temaStr);
    my @arrayCampos=split(",",$campos);
    my $texto="";

    foreach my $tema (@result){
        foreach my $valor(@arrayCampos){
            if($texto eq ""){
                $texto.=$tema->{$valor};
            }
            else{
                $texto.=$separador.$tema->{$valor};
            }
        }
        $textout.=$texto."|".$tema->{'id'}."\n";
        $texto="";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub soportesAutocomplete{

    my ($soporte) = @_;
    my $textout;
    my @result;

    if ($soporte){
        my($cant, $result) = C4::AR::Utilidades::buscarSoportes($soporte);# agregado sacar
        $textout= "";
        for (my $i; $i<$cant; $i++){
            $textout.= $result->[$i]->{'idSupport'}."|".$result->[$i]->{'description'}."\n";
        }
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub temasAutocomplete{

    my ($temaStr,$campos,$separador) = @_;
    my $textout="";
    my @result=C4::AR::Utilidades::obtenerTemas2($temaStr);
    my @arrayCampos=split(",",$campos);
    my $texto="";

    foreach my $tema (@result){
        foreach my $valor(@arrayCampos){
            if($texto eq ""){
                $texto.=$tema->{$valor};
            }
            else{
                $texto.=$separador.$tema->{$valor};
            }
        }
        $textout.=$texto."|".$tema->{'id'}."\n";
        $texto="";
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub usuarioAutocomplete{
    my ($usuarioStr, $mostrar_regularidad)    = @_;
    my @data_array;
    my $textout         = "";
    my ($cant, $usuarios_array_ref) = C4::AR::Usuarios::getSocioLike($usuarioStr, 'apellido, nombre');

    if ($cant > 0){
        foreach my $usuario (@$usuarios_array_ref){
            my %has_temp;
            $has_temp{'id'}= $usuario->getNro_socio;
            if ($mostrar_regularidad) {
                 $has_temp{'dato'}   = $usuario->persona->getApeYNom." (".$usuario->getNro_socio.")"." - ".$usuario->esRegularToString."\n";

             } else {
                 $has_temp{'dato'}   = $usuario->persona->getApeYNom." (".$usuario->getNro_socio.")"."\n";
            }
            push (@data_array, \%has_temp);
        }
        $textout = getTextOutSorted(\@data_array, {'DESC' => 1, 'ORDER_BY' => 'dato'});
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

=item
    Autocomplete para usuarios filtrando por una credencial
=cut
sub usuarioAutocompleteByCredentialType{
    my ($usuarioStr, $credential)    = @_;
    my @data_array;
    my $textout         = "";
    my ($cant, $usuarios_array_ref) = C4::AR::Usuarios::getSocioLikeByCredentialType($usuarioStr, $credential);

    if ($cant > 0){

        foreach my $usuario (@$usuarios_array_ref){

            my %has_temp;

            $has_temp{'id'}     = $usuario->getNro_socio;

            $has_temp{'dato'}   = $usuario->persona->getApeYNom." (".$usuario->getNro_socio.")"."\n";
            
            push (@data_array, \%has_temp);
        }

        $textout = getTextOutSorted(\@data_array, {'DESC' => 1, 'ORDER_BY' => 'dato'});
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

=item
busca barcodeStr sobre todos los barcodes
=cut
sub barcodeAutocomplete{
    my ($barcodeStr) = @_;

    my $textout = "";
    my ($cant, $cat_nivel3_array_ref) = C4::AR::Nivel3::getBarcodesLike($barcodeStr);
    my @data_array;

    if ($cant > 0){
        foreach my $nivel3 (@$cat_nivel3_array_ref){
            my %has_temp;
            $has_temp{'id'}     = $nivel3->getBarcode;
            $has_temp{'dato'}   = $nivel3->getBarcode;

            push (@data_array, \%has_temp);
        }

        $textout = getTextOutSorted(\@data_array, {'DESC' => 1, 'ORDER_BY' => 'dato'});
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub barcodeAutocompleteBySphinx{

     my ($string_utf8_encoded) = @_;

     $string_utf8_encoded = Encode::decode_utf8($string_utf8_encoded);

     my %params = {};

     $params{'tipo'}            = "normal";
     $params{'ini'}             = 0;
     $params{'cantR'}           = 20;
#      $params{'from_suggested'}  = 1;

     my $session = CGI::Session->load();
     my ($cantidad, $resultado_busquedas, $suggested)= C4::AR::Busquedas::busquedaPorBarcodeBySphinx($string_utf8_encoded, $session, \%params);

     my $textout = "";


     foreach my $s (@$resultado_busquedas){

#              C4::AR::Debug::debug("CANTIDAD DE NIVELES ENCONTRADOS EN AUTOCOMPLETE ==============> ".$cantidad);
             $textout.= $s->{'id1'}."|".$s->{'id1'}."\n";
     }


     return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}

sub barcodePrestadoAutocomplete{
    my ($barcodeStr) = @_;

    my $textout = "";
    #busco el barcode en el conj. de los barcodes prestados
    my ($cant, $circ_prestamo_array_ref) = C4::AR::Nivel3::getBarcodesPrestadoLike($barcodeStr);
    my @data_array;
    #devuelve un arreglo de objetos prestamos con cat_nivel3

    if ($cant > 0){
        foreach my $prestamo (@$circ_prestamo_array_ref){
            #se muestra el barcode, pero en el hidden queda el usuario al que se le realizo el prestamo
            my %has_temp;
            $has_temp{'id'}     = $prestamo->getId_prestamo;
            $has_temp{'dato'}   = $prestamo->nivel3->getBarcode;

            push (@data_array, \%has_temp);
        }

        $textout = getTextOutSorted(\@data_array, {'DESC' => 1, 'ORDER_BY' => 'dato'});
    }

    return ($textout eq '')?"-1|".C4::AR::Filtros::i18n("SIN RESULTADOS"):$textout;
}


=item
sub getTextOutSorted

@params

$params->{'orden'} el orden id or dato
$params->{'DESC'} DESC => descendente, ASC => ascendete
=cut
sub getTextOutSorted{
    my ($data_array_ref, $params) = @_;

    my $orden       = ($params->{'orden'})?$params->{'orden'}:'dato';
    my $textout     = "";
    my @return_array_sorted;

    if($params->{'DESC'}){
    #ordena la HASH de strings de manera DESC
        @return_array_sorted = sort{$a->{$orden} cmp $b->{$orden}} @$data_array_ref;
    }else{
    #ordena la HASH de strings de manera ASC
        @return_array_sorted = sort{$b->{$orden} cmp $a->{$orden}} @$data_array_ref;
    }

    foreach my $e (@return_array_sorted){
        $textout.= $e->{'id'}."|".$e->{'dato'}."\n";
    }

    return $textout;
}
############################## Fin funciones para AUTOCOMPLETABLES #############################################################


#######################################FUNCIONES PARA TRABAJAR CON BINARIOS##########################################
sub bin2dec {
    return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

sub dec2bin {
    my $str = unpack("B32", pack("N", shift));
    $str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
    return $str;
}
####################################FIN###FUNCIONES PARA TRABAJAR CON BINARIOS#######################################

=item sub isAjaxRequest

    verifica si el request fue realizado con AJAX
    Parametros:

=cut
sub isAjaxRequest {
    if($ENV{'HTTP_X_REQUESTED_WITH'} eq 'XMLHttpRequest'){
        return 1;
    }else { return 0}
}

=item sub md5ToSHA_B64_256

    Esta funcion se utiliza para actualizar las passwords de los socios de MD5 a SHA256_base64
=cut
sub md5ToSHA_B64_256 {

    my $socios_array_ref = C4::Modelo::UsrSocio::Manager->get_usr_socio( );

    foreach my $socio (@$socios_array_ref){
        if($socio->getPassword() ne undef){
            $socio->setPassword(sha256_base64($socio->getPassword()));
        }
        $socio->save();
    }
}


sub crearPaginadorOPAC{

    my ($cantResult, $cantRenglones, $pagActual, $url, $t_params)=@_;

    my ($paginador, $cantPaginas)=C4::AR::Utilidades::armarPaginasOPAC($pagActual, $cantResult, $cantRenglones,$url,$t_params);
    return $paginador;

}
sub armarPaginasOPAC{
#@actual, es la pagina seleccionada por el usuario
#@cantRegistros, cant de registros que se van a paginar
#@$cantRenglones, cantidad de renglones maximo a mostrar
#@$t_params, para obtener el path para las imagenes

# FIXME falta pasar las imagenes al estilo
    my ($actual, $cantRegistros, $cantRenglones, $url, $t_params)=@_;

    my $pagAMostrar=C4::AR::Preferencias::getValorPreferencia("paginas") || 10;
    my $numBloq=floor($actual / $pagAMostrar);
    my $limInf=($numBloq * $pagAMostrar);
    my $limSup=$limInf + $pagAMostrar;
    my $previous_text = "« ".C4::AR::Filtros::i18n('Anterior');
    my $next_text = C4::AR::Filtros::i18n('Siguiente')." »";
    my $first_text = "« ".C4::AR::Filtros::i18n('Primero');
    my $last_text = C4::AR::Filtros::i18n('&Uacute;ltimo')." »";

    if($limInf == 0){
        $limInf= 1;
        $limSup=$limInf + $pagAMostrar -1;
    }
    my $totalPaginas = ceil($cantRegistros/$cantRenglones);

    my $themelang= $t_params->{'themelang'};

    my $paginador= "<div class='pagination pagination-centered'><ul>";
    my $class="paginador";

    if($actual > 1){
        #a la primer pagina
        my $ant= $actual-1;
        $paginador .= "<li class='prev'><a href='".$url."&page=1' class='previous' title='".$first_text."'> ".$first_text."</a></li>";
        $paginador .= "<li class='prev'><a href='".$url."&page=".$ant."' class='previous' title='".$previous_text."'> ".$previous_text."</a></li>";

    }

    for (my $i=$limInf; ($totalPaginas >1 and $i <= $totalPaginas and $i <= $limSup) ; $i++ ) {
        if($actual == $i){
            $class="'active click'";
        }else{
            $class="'click'";
        }
        $paginador .= "<li class=".$class."><a href='".$url."&page=".$i."' class=".$class."> ".$i." </a></li>";
    }

    if($actual >= 1 && ($actual < $totalPaginas)){
        my $sig= $actual+1;
        $paginador .= "<li class='next'><a href='".$url."&page=".$sig."' class='next' title='".$next_text."'>".$next_text."</a></li>";
        $paginador .= "<li class='next'><a href='".$url."&page=".$totalPaginas."' class='next' title='".$last_text."'>".$last_text."</a></li>";

    }
    $paginador .= "</div>";

    if ($totalPaginas <= 1){
      $paginador="";
    }
    return($paginador, $totalPaginas);
}

sub getDate{

    my @datearr = localtime(time);
    my %date_hash = {};

    $date_hash{'year'}          = 1900 + $datearr[5];
    $date_hash{'month'}         = $datearr[4] + 1;
    $date_hash{'month_name'}    = C4::Date::mesString( $date_hash{'month'} );
    $date_hash{'day'}           = $datearr[3];
    $date_hash{'day_name'}      = C4::Date::diaString( $datearr[6] );

    return (\%date_hash);
}


sub getFeriados{
    require C4::Modelo::PrefFeriado;
    require C4::Modelo::PrefFeriado::Manager;

    my $feriados = C4::Modelo::PrefFeriado::Manager->get_pref_feriado(sort_by => ['fecha DESC']);
    my @dates;

    foreach my $date (@$feriados){
        push (@dates, $date);
    }

    return (\@dates);
}

sub getProximosFeriados{

    my ($desde) = @_;
    require C4::Modelo::PrefFeriado;
    require C4::Modelo::PrefFeriado::Manager;

    my $hoy = C4::AR::Utilidades::getToday();

    $desde = $desde || $hoy;

    my $feriados = C4::Modelo::PrefFeriado::Manager->get_pref_feriado(query => [ fecha => { ge => $desde } ], sort_by => ['fecha ASC']);

    return ($feriados);
}

sub setFeriado{

    my ($fecha, $status, $texto_feriado) = @_;

    require C4::Modelo::PrefFeriado;
    require C4::Modelo::PrefFeriado::Manager;

    my $dateformat  = C4::Date::get_date_format();
    $texto_feriado  = Encode::encode_utf8($texto_feriado);

    $fecha          = C4::Date::format_date_in_iso($fecha, $dateformat);
    my $feriado     = C4::Modelo::PrefFeriado::Manager->get_pref_feriado(query => [ fecha => { eq => $fecha } ] );

    if (scalar(@$feriado)){

        #El feriado ya existe!! se modifica el texto o se elimina dependiendo del status
        $feriado->[0]->setFecha($fecha,$status,$texto_feriado);

    }else{

        $feriado = C4::Modelo::PrefFeriado->new();
        eval{
            $feriado->agregar($fecha,$status,$texto_feriado);
        };
    }
    
    return (1);
}

=item
    Setea uno o mas feriados, dependiendo de cuantas fechas reciba por parametro
=cut
sub setFeriadoFromArray{

    my ($fechas, $status, $texto_feriado) = @_;

    require C4::Modelo::PrefFeriado;
    require C4::Modelo::PrefFeriado::Manager;

    my $dateformat      = C4::Date::get_date_format();
    $texto_feriado      = Encode::encode_utf8($texto_feriado);

    foreach my $fecha (@$fechas){

        $fecha      = C4::Date::format_date_in_iso($fecha, $dateformat);
        my $feriado = C4::Modelo::PrefFeriado::Manager->get_pref_feriado(query => [ fecha => { eq => $fecha } ] );

        if (scalar(@$feriado)){

            #El feriado ya existe!! se modifica el texto o se elimina dependiendo del status
            $feriado->[0]->setFecha($fecha,$status,$texto_feriado);

        }else{

            $feriado = C4::Modelo::PrefFeriado->new();
            eval{
                $feriado->agregar($fecha,$status,$texto_feriado);
            };
        }
    }

    return (1);
}



sub redirectAndAdvice{

    my ($cod_msg)= @_;
    my ($session) = CGI::Session->load();

    $session->param('codMsg',$cod_msg);
    C4::AR::Auth::redirectTo(C4::AR::Utilidades::getUrlPrefix().'/informacion.pl');
#     exit;
}


sub bbl_sort {
    my $array = shift;
    my $array2 = shift;
    my $array3 = shift;
    my $not_complete = 1;
    my $index;
    my $len = ((scalar @$array) - 2);
    while ($not_complete) {
        $not_complete = 0;
        foreach $index (0 .. $len) {
            if (@$array[$index] < @$array[$index + 1]) {
                my $temp = @$array[$index + 1];
                @$array[$index + 1] = @$array[$index];
                @$array[$index] = $temp;

                $temp = @$array2[$index + 1];
                @$array2[$index + 1] = @$array2[$index];
                @$array2[$index] = $temp;

                $temp = @$array3[$index + 1];
                @$array3[$index + 1] = @$array3[$index];
                @$array3[$index] = $temp;

                $not_complete = 1;
            }
        }
    }
}

sub getToday{

    use Date::Manip;

    my $dateformat = C4::Date::get_date_format();

    return  C4::Date::format_date_in_iso(DateCalc(ParseDate("today"),"+ 0 days"),$dateformat);
}


sub daysToNow{
    my ($date) = @_;

    use Date::Calc qw(Delta_Days);

    my @today = (localtime)[5,4,3];
    $today[0] += 1900;
    $today[1]++;

    my @date_to_cmp = (split '-',$date);

    my $days = 0;

    eval{
        $days = Delta_Days(@date_to_cmp,@today);
    };

    return ($days);
}

sub paginarArrayResult {
    my ($params_hash_ref, @array_to_paginate) = @_;

    my $cantFila = $params_hash_ref->{'cantR'} - 1 + $params_hash_ref->{'ini'};
    my @results2;

    if($params_hash_ref->{'cant_total'} < $cantFila ){
        @results2 = @array_to_paginate[$params_hash_ref->{'ini'}..$params_hash_ref->{'cant_total'}];
#         C4::AR::Debug::debug(" cant < cantFila ");
    }
    else{
        @results2 = @array_to_paginate[$params_hash_ref->{'ini'}..$params_hash_ref->{'cantR'} - 1 + $params_hash_ref->{'ini'}];
#         C4::AR::Debug::debug(" cant > cantFila ");
    }

    return @results2;
}

sub generarComboEstantes{

    my ($params) = @_;

    my @select_estante_array;
    my %select_estante_array;
    my ($tipoNivel3_array_ref)= &C4::AR::Referencias::obtenerEstantes();

    foreach my $estante (@$tipoNivel3_array_ref) {
        push(@select_estante_array, $estante->id);
        $select_estante_array{$estante->id}= $estante->estante;
    }

    push (@select_estante_array, '');
    $select_estante_array{''}= 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
         $options_hash{'onChange'}= $params->{'onChange'};
    }

    if ( $params->{'class'} ){
         $options_hash{'class'}= $params->{'class'};
    }

    if ( $params->{'onFocus'} ){
      $options_hash{'onFocus'}= $params->{'onFocus'};
    }

    if ( $params->{'onBlur'} ){
      $options_hash{'onBlur'}= $params->{'onBlur'};
    }

    $options_hash{'name'}= $params->{'name'}||'estante_name';
    $options_hash{'id'}= $params->{'id'}||'estante_id';
    $options_hash{'size'}=  $params->{'size'}||1;
    $options_hash{'multiple'}= $params->{'multiple'}||0;
    $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultTipoNivel3");


    $options_hash{'values'}= \@select_estante_array;
    $options_hash{'labels'}= \%select_estante_array;

    my $comboTipoNivel3= CGI::scrolling_list(\%options_hash);

    return $comboTipoNivel3;
}


sub isValidFile{

    my ($file_path) = @_;
    my $return_value = 1;
    my $file_type;

    use File::LibMagic;
    my $flm = File::LibMagic->new();

    open(FILE, "<$file_path") or die "Can't open $file_path : $!\n";
    close(FILE);

    $file_type = $flm->checktype_filename($file_path);

    my @extensiones_permitidas=("bmp","jpg","gif","png","jpeg","msword","docx","odt","pdf","xls","xlsx","zip","rar");
    my @nombreYextension=split('\.',$file_path);

    C4::AR::Debug::debug("UploadDocument ====== > FileType: ".$file_type);
    C4::AR::Debug::debug("UploadDocument ====== > FilePath: ".$file_path);
    C4::AR::Debug::debug("UploadDocument ====== > Extension: ".@nombreYextension[1]);
    my $size = scalar(@nombreYextension) - 1;

    if (!( @nombreYextension[$size] =~ m/bmp|jpg|gif|png|jpeg|msword|docx|odt|ods|pdf|xls|xlsx|zip/i) ) {
        $return_value = 0;
    }

    $return_value = trim(split(';', $file_type));
    C4::AR::Debug::debug("FILE TYPE RESULT: ".$return_value);
    C4::AR::Debug::debug("FILE PATH ///////////////: ".$file_path);
    return ($return_value);
}

sub escapeURL{
    my ($url) = @_;

    $url = URI::Escape::uri_escape_utf8($url);

    return ($url);
}

sub getUrlPrefix{
    return ("".C4::Context->config('url_prefix'));

}

sub getUrlOpac{


    my $url_server      = C4::AR::Preferencias::getValorPreferencia('serverName');
    my $opac_port       = ":".(C4::Context->config('opac_port')||'80');
    my $server_port     = ":".$ENV{'SERVER_PORT'};

    if ( ($server_port == 80) || ($server_port == 443) ){
            $server_port = "";
    }

    my $SERVER_URL_OPAC  =(C4::AR::Utilidades::trim($url_server)||($ENV{'SERVER_NAME'})).$opac_port;

    return $SERVER_URL_OPAC.getUrlPrefix();
}

sub addParamToUrl{
    my ($url,$param,$value) = @_;

    $param = $param."=".$value;

    my $status = index($url,'?');

    if (C4::AR::Utilidades::validateString($value)){
        if ($status == -1){
            $url .= '?'.$param;
        }else{
            $url .= '&'.$param;
        }
    }

    return ($url);

}

sub hash_params_to_url_params{
    my ($url, $hash_ref) = @_;

    if($hash_ref){
        while ( my ($key, $value) = each(%$hash_ref) ) {
                $url = addParamToUrl($url, $key, $value);
        }
    }

    return $url;
}

sub url_for{
    my ($url_base, $hash_ref) = @_;

    my $url             = hash_params_to_url_params($url_base, $hash_ref);
    my $server          = $ENV{'SERVER_NAME'};
    my $proto           = ($ENV{'SERVER_PORT'} eq 443)?"https://":"http://";
    my $server_port     = ":".$ENV{'SERVER_PORT'};

    if ( ($server_port == 80) || ($server_port == 443) ){
            $server_port = "";
    }

    my $url_final   = $proto.$server.$server_port.getUrlPrefix().$url;

    return $url_final;
}

sub armarIniciales{
    my ($params) = @_;

    my @split_nombre   = split(/ /,$params->{'nombre'});
    my @split_apellido = split(/ /,$params->{'apellido'});
    my $iniciales = '';

    foreach my $name (@split_nombre){
        $name  = uc trim($name);
        $iniciales.= substr($name,0,1);
    }

    foreach my $surname (@split_apellido){
        $surname  = uc trim($surname);
        $iniciales.= substr($surname,0,1);
    }

    return ($iniciales);

}

#Replace a string without using RegExp.
sub str_replace {
    my $replace_this = shift;
    my $with_this  = shift;
    my $string   = shift;

    my $length = length($string);
    my $target = length($replace_this);

    for(my $i=0; $i<$length - $target + 1; $i++) {
        if(substr($string,$i,$target) eq $replace_this) {
            $string = substr($string,0,$i) . $with_this . substr($string,$i+$target);
            return $string; #Comment this if you what a global replace
        }
    }
    return $string;
}


# sub moveFileToReports{
#     my ($path) = @_;
#     use C4::Context;
#
#     my $url_base=$path;
#
#     my @array= split(/\//,$path);
#     my $filename= pop(@array);
#
#     my $context = new C4::Context;
# #     my $reports_dir = $context->config('reports_dir');
#
#     my $reports_dir = C4::AR::Utilidades::getUrlPrefix()."/intranet/reports/";
#     C4::AR::Debug::debug($reports_dir);
#
#     move($url_base, $reports_dir.$filename);
#
#     return($reports_dir.$filename);
#
# }

=item
sub modificarCampoGlobalmente

$campo_origen Campo que se va a modifcar en TODOS los registros del nivel $nivel
$campo_destino Campo por el cual se va a cambiar $campo_origen
$nivel nivel donde se encuentran los campos $campo_origen y $campo_destino
=cut
sub modificarCampoGlobalmente {
    my ($campo_origen, $campo_destino, $nivel) = @_;

 my $registros_array_ref;

    if ($nivel eq 1) {
        $registros_array_ref = C4::AR::Nivel1::getNivel1Completo();
    } elsif ($nivel eq 2) {
        $registros_array_ref = C4::AR::Nivel2::getAllNivel2();
    } elsif ($nivel eq 3) {
        $registros_array_ref = C4::AR::Nivel3::getNivel3Completo();
    }
 print "Modificando el campo $campo_origen al $campo_destino del nivel $nivel \n";
 my $st1 = time();
 #Procesamos los registros
 my $cantidad = scalar(@$registros_array_ref);
 my $registro=1;
   foreach my $nivel (@$registros_array_ref){
         my $marc_record = MARC::Record->new_from_usmarc($nivel->getMarcRecord());
         my $porcentaje= int (($registro * 100) / $cantidad );
         print "Procesando registro: $registro de $cantidad ($porcentaje%) \r";

        my $field = $marc_record->field($campo_origen);
        if(($field)&&(!$marc_record->field($campo_destino))){
            #Existe el campo y no existe el campo destino
            my $indentificador_1        = C4::AR::Utilidades::ASCIItoHEX($field->indicator(1));
            my $indentificador_2        = C4::AR::Utilidades::ASCIItoHEX($field->indicator(2));
            my @subcampos_array;
            foreach  my $subfield ($field->subfields()){
                push(@subcampos_array, ($subfield->[0] => $subfield->[1]));
            }
            my $new_field = new MARC::Field($campo_destino,$indentificador_1,$indentificador_2, @subcampos_array);
            $field->replace_with($new_field);
             C4::AR::Debug::debug($marc_record->as_formatted);
            $nivel->setMarcRecord($marc_record->as_usmarc);
            $nivel->save();
        }
     $registro++;
    }

 #Fin Proceso
 my $end1 = time();
 my $tardo1=($end1 - $st1);
 my $min= $tardo1/60;
 print "Tardo $min minutos !!!\n";

}

sub translateYesNo_fromNumber{
    my ($value) = @_;

    if ($value == 1){
        return C4::AR::Filtros::i18n('Si');
    }else{
        return C4::AR::Filtros::i18n('No');
    }
}

sub translateYesNo_toNumber{
    my ($value) = @_;

    if ($value eq C4::AR::Filtros::i18n('Si')){
        return 1;
    }else{
        return 0
    }
}

sub printAjaxPercent{
	my ($total,$actual) = @_;
	
	my $percent = 0;
	
	eval{
	   $percent = ($actual * 100) / $total;
	};
    
    my $session = CGI::Session->load();

    C4::AR::Auth::print_header($session);
    print $percent;
    
    return ($percent);
}

sub demo_test{
    
    my ($job) = @_;
    
    use C4::AR::BackgroundJob;
    
    if (!$job){
        $job = C4::AR::BackgrounJob->new("DEMO","NULL",10);        
    }
     
    for (my $x=1; $x<=30; $x++){
        sleep(1);
        my $percent = printAjaxPercent(30,$x);
        $job->progress($percent);
        C4::AR::Debug::debug("-------------------------- JOB -------------- \n\n\n\n\n");
    }
    
}

sub generarComboDeEstados{
	
    my ($params) = @_;

	my ($estados) = C4::AR::Referencias::obtenerEstados();

    my @select_estados_array;
    my %select_estados_hash;

    foreach my $estado (@$estados) {
        push(@select_estados_array, $estado->getId_estado);
        $select_estados_hash{$estado->getId_estado}= $estado->nombre;
    }

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}= $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}= $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}= $params->{'onBlur'};
    }

    $options_hash{'name'}= $params->{'name'}||'estado_name';
    $options_hash{'id'}= $params->{'id'}||'estado_id';
    $options_hash{'size'}=  $params->{'size'}||1;
    $options_hash{'multiple'}= $params->{'multiple'}||0;
    $options_hash{'defaults'}= $params->{'default'} || C4::AR::Preferencias::getValorPreferencia("defaultUsrEstado") ||1;


    push (@select_estados_array, 0);
    $select_estados_hash{0} = "SIN SELECCIONAR";
    $options_hash{'values'}= \@select_estados_array;
    $options_hash{'labels'}= \%select_estados_hash;

    my $comboDeDisponibilidades= CGI::scrolling_list(\%options_hash);

    return $comboDeDisponibilidades;
	
	
}

sub generarComboEstadoEjemplares{

      my ($params) = @_;

    my @select_estados_array;
    my %select_estados;
    my $estados        = &C4::AR::Referencias::obtenerEstadosEjemplares();

    foreach my $estado (@$estados) {
        push(@select_estados_array, $estado->getCodigo);
        $select_estados{$estado->getCodigo}  = $estado->getNombre;
    }

    $select_estados{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'estado';
    $options_hash{'id'}         = $params->{'id'}||'estado';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||0;

    push (@select_estados_array, '');
    $options_hash{'values'}     = \@select_estados_array;
    $options_hash{'labels'}     = \%select_estados;

    my $combo_estados = CGI::scrolling_list(\%options_hash);

    return $combo_estados;
}


sub generarComboEstadoEjemplaresTexto{

      my ($params) = @_;

    my @select_estados_array;
    my %select_estados;
    my $estados        = &C4::AR::Referencias::obtenerEstadosEjemplares();

    foreach my $estado (@$estados) {
        push(@select_estados_array, $estado->getNombre);
        $select_estados{$estado->getNombre}  = $estado->getNombre;
    }

    $select_estados{''}                = 'SIN SELECCIONAR';

    my %options_hash;

    if ( $params->{'onChange'} ){
        $options_hash{'onChange'}   = $params->{'onChange'};
    }
    if ( $params->{'onFocus'} ){
        $options_hash{'onFocus'}    = $params->{'onFocus'};
    }
    if ( $params->{'onBlur'} ){
        $options_hash{'onBlur'}     = $params->{'onBlur'};
    }

    $options_hash{'name'}       = $params->{'name'}||'estado';
    $options_hash{'id'}         = $params->{'id'}||'estado';
    $options_hash{'size'}       = $params->{'size'}||1;
    $options_hash{'class'}      = 'required';
    $options_hash{'multiple'}   = $params->{'multiple'}||0;

    push (@select_estados_array, '');
    $options_hash{'values'}     = \@select_estados_array;
    $options_hash{'labels'}     = \%select_estados;

    my $combo_estados = CGI::scrolling_list(\%options_hash);

    return $combo_estados;
}



END { }       # module clean-up code here (global destructor)

1;
__END__
