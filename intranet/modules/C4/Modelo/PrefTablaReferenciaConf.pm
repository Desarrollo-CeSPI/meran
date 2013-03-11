package C4::Modelo::PrefTablaReferenciaConf;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'pref_tabla_referencia_conf',

    columns => [
        id                  => { type => 'serial', overflow => 'truncate'},
        tabla               => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        campo               => { type => 'varchar', overflow => 'truncate', length => 20, not_null => 1 },
        campo_alias         => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        visible             => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1},
    ],

    primary_key_columns => [ 'id' ],
);

use C4::Modelo::PrefTablaReferenciaConf::Manager;


=head1
    Obtiene toda la tabla filtrada por nombre_tabla
=cut
sub getConfTabla{

    my ($nombre_tabla) = @_;

    my $data = C4::Modelo::PrefTablaReferenciaConf::Manager->get_pref_tabla_referencia_conf(   query =>  [ 
                                                                                    tabla  => { eq => $nombre_tabla  },
                                                                                   ],
   
                                                    );
    
    if(scalar(@$data) > 0){
        return $data;
    } else {
        return 0;
    }

}

sub getConf{
    my ($self)          = shift;
    my ($tabla, $campo) = @_;
    my @filtros;

    push (@filtros, (campo => {eq => $campo}) );
    push (@filtros, (tabla => {eq => $tabla}) );

    my $configuarcion = C4::Modelo::PrefTablaReferenciaConf::Manager->get_pref_tabla_referencia_conf(  query => \@filtros,
#                                                                                     select    => ['id1'],
                                                                                  );

    if(scalar(@$configuarcion) > 0){
        return $configuarcion->[0];
    } else {
        return 0;
    }
}

=item
    Idem al de arriba pero sin hacer el shift, se rompia
=cut
sub getConfig{
    my ($tabla, $campo) = @_;
    my @filtros;

    push (@filtros, (campo => {eq => $campo}) );
    push (@filtros, (tabla => {eq => $tabla}) );

    my $configuarcion = C4::Modelo::PrefTablaReferenciaConf::Manager->get_pref_tabla_referencia_conf(  query => \@filtros,
#                                                                                     select    => ['id1'],
                                                                                  );

    if(scalar(@$configuarcion) > 0){
        return $configuarcion->[0];
    } else {
        return 0;
    }
}

sub cambiarVisivilidad{

    my ($tabla, $campo) = @_;
    my $conf            = getConfig($tabla, $campo);
    
    if($conf->getVisible()){
    
        $conf->setVisible(0);
    
    }else{
    
        $conf->setVisible(1);
    
    }
}


#-------------------------------------- GETTER Y SETTER -------------------------------------#
#getter

sub getVisible{
    my ($self) = shift;

    return ($self->visible);
}

sub getCampoAlias{
    my ($self) = shift;

    return ($self->campo_alias);
}

sub getCampo{
    my ($self) = shift;

    return ($self->campo);
}

sub getTabla{
    my ($self) = shift;

    return ($self->tabla);
}

#setter

sub setCampoAlias{
    my ($self)          = shift;
    my ($campo_alias)   = @_;
    
    $self->campo_alias($campo_alias);
    $self->save();
}

sub setVisible{
    my ($self)      = shift;
    my ($visible)   = @_;
    
    $self->visible($visible);
    $self->save();
}

#------------------------------------ FIN GETTER Y SETTER -------------------------------------#

1;
