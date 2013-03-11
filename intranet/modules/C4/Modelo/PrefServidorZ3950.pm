package C4::Modelo::PrefServidorZ3950;

use strict;
use base qw(C4::Modelo::DB::Object::AutoBase2);
use C4::Modelo::RefColaborador;
use C4::Modelo::PrefServidorZ3950::Manager;
use Text::LevenshteinXS;

__PACKAGE__->meta->setup(
    table   => 'pref_servidor_z3950',

    columns => [
        servidor    => { type => 'varchar', overflow => 'truncate', length => 255 },
        puerto      => { type => 'integer', overflow => 'truncate' },
        base        => { type => 'varchar', overflow => 'truncate', length => 255 },
        usuario     => { type => 'varchar', overflow => 'truncate', length => 255 },
        password    => { type => 'varchar', overflow => 'truncate', length => 255 },
        nombre      => { type => 'text', overflow => 'truncate', length => 65535 },
        id          => { type => 'serial', overflow => 'truncate', not_null => 1 },
        habilitado  => { type => 'integer', overflow => 'truncate', not_null => 1 },
        sintaxis    => { type => 'varchar', overflow => 'truncate', length => 80 },
    ],

    primary_key_columns => [ 'id' ],
);

sub agregarServidorZ3950{

    my ($self)   = shift;
    my ($params) = @_;

    $self->setNombre($params->{'nombre'});
    $self->setServidor($params->{'servidor'});
    $self->setPuerto($params->{'puerto'});
    $self->setBase($params->{'base'});
    $self->setUsuario($params->{'usuario'});
    $self->setPassword($params->{'password'});
        my $habilitado;
    if($params->{'habilitado'} == 'true'){
        $habilitado = 1
    }else{
        $habilitado = 0
    }
    $self->setHabilitado($habilitado);
    $self->setSintaxis($params->{'sintaxis'});

    $self->save();
}

sub editarServidorZ3950{

    my ($self)   = shift;
    my ($params) = @_;

    $self->setNombre($params->{'nombre'});
    $self->setServidor($params->{'servidor'});
    $self->setPuerto($params->{'puerto'});
    $self->setBase($params->{'base'});
    $self->setUsuario($params->{'usuario'});
    $self->setPassword($params->{'password'});
    my $habilitado;
    if($params->{'habilitado'} eq 'true'){
        $habilitado = 1
    }else{
        $habilitado = 0
    }
    C4::AR::Debug::debug("habilitado : ".$params->{'habilitado'});
    $self->setHabilitado($habilitado);
    $self->setSintaxis($params->{'sintaxis'});

    $self->save();
}

sub desactivar{

    my ($self) = shift;
    $self->setHabilitado(0);
    $self->save();
}

sub nextMember{
    return(C4::Modelo::RefColaborador->new());
}

sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub setId{
    my ($self) = shift;
    my ($id) = @_;
    $self->id($id);
}

sub getServidor{
    my ($self) = shift;
    return ($self->servidor);
}

sub setServidor{
    my ($self) = shift;
    my ($servidor) = @_;
    $self->servidor($servidor);
}

sub getPuerto{
    my ($self) = shift;
    return ($self->puerto);
}

sub setPuerto{
    my ($self) = shift;
    my ($puerto) = @_;
    $self->puerto($puerto);
}

sub getBase{
    my ($self) = shift;
    return ($self->base);
}

sub setBase{
    my ($self) = shift;
    my ($base) = @_;
    $self->base($base);
}

sub getUsuario{
    my ($self) = shift;
    return ($self->usuario);
}

sub setUsuario{
    my ($self) = shift;
    my ($usuario) = @_;
    $self->usuario($usuario);
}

sub getPassword{
    my ($self) = shift;
    return ($self->password);
}

sub setPassword{
    my ($self) = shift;
    my ($password) = @_;
    $self->password($password);
}

sub getNombre{
    my ($self) = shift;
    return ($self->nombre);
}

sub setNombre{
    my ($self) = shift;
    my ($nombre) = @_;
    $self->nombre($nombre);
}

sub getHabilitado{
    my ($self) = shift;
    return ($self->habilitado);
}

sub setHabilitado{
    my ($self) = shift;
    my ($habilitado) = @_;
    $self->habilitado($habilitado);
}

sub getSintaxis{
    my ($self) = shift;
    return ($self->sintaxis);
}

sub setSintaxis{
    my ($self) = shift;
    my ($sintaxis) = @_;
    $self->sintaxis($sintaxis);
}

sub getConexion{
    my ($self) = shift;

	my $conexion= $self->getServidor.":".$self->getPuerto;
	
	if($self->getBase ne '') {
		$conexion .= "/".$self->getBase;
	}
	
    if ($self->getUsuario ne ''){
		$conexion.="/".$self->getUsuario."/".$self->getPassword;
     }

    return $conexion;
}

sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (NOMBRE => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::PrefServidorZ3950::Manager->get_pref_servidor_z3950(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::PrefServidorZ3950::Manager->get_pref_servidor_z3950(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['nombre'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::PrefServidorZ3950::Manager->get_pref_servidor_z3950_count(query => \@filtros,);
    my $self_nombre = $self->getNombre;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = (distance($self_nombre,$each->getNombre)<=1);
          if ($match){
            push (@matched_array,$each);
          }
        }
        return (scalar(@matched_array),\@matched_array);
    }
    else{
      return($ref_cant,$ref_valores);
    }
}


1;

