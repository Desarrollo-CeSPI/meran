package C4::Modelo::PrefTablaReferencia;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_tabla_referencia',

    columns => [
        id                  => { type => 'serial', overflow => 'truncate'},
        nombre_tabla        => { type => 'varchar', overflow => 'truncate', length => 40, not_null => 1 },
        alias_tabla         => { type => 'varchar', overflow => 'truncate', length => 20, not_null => 1 },
        campo_busqueda      => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        client_title        => { type => 'varchar', overflow => 'truncate', length => 255},
        is_editable         => { type => 'integer', overflow => 'truncate', length => 1, not_null => 0, default => 1 },       
    ],

    primary_key_columns => [ 'id' ],
);

use C4::Modelo::PrefTablaReferencia::Manager;

sub getAliasForTable {
    my ($self) = shift;
    my ($nombre_tabla) = @_;
    my $db = C4::Modelo::PrefTablaReferencia::Manager->get_pref_tabla_referencia(
                                                                                query => [
                                                                                           nombre_tabla => { eq  => $nombre_tabla } ,
                                                                                         ],
                                                                            );
    return ($db->[0]->getAlias_tabla);
}


#SE REDEFINE createFromAlias PORQUE ES QUIEN DEFINE CUAL ES LA PRIMER CLASE (TABLA) DE LA CADENA

#EL ORDEN DE LA CADENA ESTA COMPRENDIDO POR: CatAutor, CatTema, 

sub createFromAlias{

    my ($self)=shift;
    my $classAlias = shift;
    my $firstTable = C4::Modelo::CatAutor->new();
       
	return( $firstTable->createFromAlias($classAlias) );
}

sub getObjeto{
	my ($self)=shift;
    my $classAlias = shift;
    my $firstTable = C4::Modelo::CatAutor->new();
       
	return( $firstTable->createFromAlias($classAlias) );
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}


sub getNombre_tabla{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->nombre_tabla));
}

sub setNombre_tabla{
    my ($self) = shift;
    my ($nombre_tabla) = @_;
    $self->nombre_tabla($nombre_tabla);
}

sub getAlias_tabla{
    my ($self) = shift;
    return ($self->alias_tabla);
}

sub setAlias_tabla{
    my ($self) = shift;
    my ($alias_tabla) = @_;
    $self->alias_tabla($alias_tabla);
}

sub getClient_title{
    my ($self) = shift;
    return ($self->client_title);
}

sub setClient_title{
    my ($self) = shift;
    my ($client_title) = @_;
    $self->client_title($client_title);
}

sub getCampo_busqueda{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->campo_busqueda));
}

sub obtenerValoresTablaRef{
	my ($self) = shift;
	my ($alias_tabla, $campo, $orden) = @_;
	
	my $ref = $self->createFromAlias($alias_tabla);
#     C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => ref: ".$ref);
#     C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => campo: ".$campo);
#     C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => orden: ".$orden);
#     C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => alias_tabla: ".$alias_tabla);

	if ($ref){
        my ($cantidad, $valores) = $ref->obtenerValoresCampo($campo, $orden);
#         C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => dentro del if cantidad: ".$cantidad);
#         C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => dentro del if valores: ".$valores);
        my $default_value = $ref->getDefaultValue($alias_tabla);
        C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => ".$default_value." para tabla => ".$alias_tabla);
		return ($cantidad, $valores, $default_value);
    }else{
#         C4::AR::Debug::debug("PrefTablaReferencia => obtenerValoresTablaRef => ERROR en la conf de la tabla 'pref_informacion_referencia'!!!!!");
        return 0;
    }
	
}

sub obtenerValorDeReferencia{
	my ($self) = shift;
	my ($alias_tabla, $campo , $id) = @_;
	
	my $ref=$self->createFromAlias($alias_tabla);
	if ($ref){
		my $valor=$ref->obtenerValorCampo($campo,$id);
		return $valor;
		}
	else {
	return 0;
	}
	
}

sub obtenerIdentTablaRef{
	my ($self) = shift;
	my ($alias_tabla) = @_;
	my $ref=$self->createFromAlias($alias_tabla);
	return ($ref->meta->primary_key);
}

sub getIsEditable{
    my ($self) = shift;
    return ($self->is_editable);
}

sub isEditable{
    my ($self) = shift;
    return ($self->is_editable == 1);
}

1;

