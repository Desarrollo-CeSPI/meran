package C4::Modelo::CatVisualizacionOpac;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_visualizacion_opac',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 },
        campo           => { type => 'character', overflow => 'truncate', length => 3, not_null => 1 },
        subcampo        => { type => 'character', overflow => 'truncate', length => 1, not_null => 1 },
        vista_opac      => { type => 'varchar', overflow => 'truncate', length => 255 },
        tipo_ejemplar   => { type => 'char', overflow => 'truncate', length => 3 },
        orden           => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        pre             => { type => 'varchar', overflow => 'truncate', length => 255 },
        inter           => { type => 'varchar', overflow => 'truncate', length => 255 },
        post            => { type => 'varchar', overflow => 'truncate', length => 255 },
	    nivel           => { type => 'integer', overflow => 'truncate', length => 1 },
	    vista_campo     => { type => 'varchar', overflow => 'truncate', length => 255 },
	    orden_subcampo  => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 }
    ],
                    
    primary_key_columns => [ 'id' ],
);

use utf8;
sub agregar{

    my ($self)=shift;
    my ($params) = @_;

    $self->campo($params->{'campo'});
    $self->nivel($params->{'nivel'});
    $self->pre($params->{'pre'});
    $self->post($params->{'post'});    
    $self->subcampo($params->{'subcampo'});
    $self->vista_opac($params->{'liblibrarian'});  
    
# FIXME WF!!!!!!!!!! para q esta esto??
    # my $vista_campo_temp = C4::AR::EstructuraCatalogacionBase::getLabelByCampo($params->{'campo'});
    # C4::AR::Debug::debug("vista_campo en el modelo, agregando : ".$vista_campo_temp);
    # $self->vista_campo($vista_campo_temp);
    $self->vista_campo($params->{'liblibrarian'});
    
#   este chequeo no se para que serviria ahora. Se agrega el tipo de ejemplar de una con el nivel que ya viene
#    if(C4::AR::EstructuraCatalogacionBase::getNivelFromEstructuraBaseByCampoSubcampo($params->{'campo'}, $params->{'subcampo'}) <= 1){
#        $self->setTipoEjemplar('ALL');
#    }else{
#        $self->setTipoEjemplar($params->{'ejemplar'});
#    }

    $self->tipo_ejemplar($params->{'ejemplar'});

    my $orden = C4::Modelo::CatVisualizacionOpac::Manager->get_max_orden() + 1;
    $self->orden($orden);
    
    my $orden_subcampo  = C4::Modelo::CatVisualizacionOpac::Manager->get_max_orden_subcampo($params->{'campo'}) + 1;
    $self->orden_subcampo($orden);

    $self->save();
}

sub modificar{

    my ($self)=shift;
    my ($string) = @_;
    $string = Encode::decode_utf8($string);
    $self->setVistaOpac($string);

    $self->save();
}

sub modificarNivel{

    my ($self)      = shift;
    my ($string)    = @_;
    $self->setNivel($string);

    $self->save();
}

sub modificarPre{

    my ($self)=shift;
    my ($string) = @_;
    $string = Encode::decode_utf8($string);
    $self->setPre($string);

    $self->save();
}

sub modificarPost{

    my ($self)=shift;
    my ($string) = @_;
    $string = Encode::decode_utf8($string);
    $self->setPost($string);

    $self->save();
}

sub modificarInter{

    my ($self)      = shift;
    my ($string)    = @_;
    $string         = Encode::decode_utf8($string);
    $self->setInter($string);

    $self->save();
}

sub getPre{
    my ($self) = shift;
    return $self->pre;
}

sub getPreLimpio{
    my ($self) = shift;
    my $tmp= $self->pre;
    $tmp =~ s/&nbsp;/ /g; #se limpian las entidades HTML
    return $tmp;
}

sub setPre{
    my ($self)  = shift;
    my ($pre)   = @_;
    $pre =~ s/ /&nbsp;/g;
    $self->pre($pre); # se modifican los espacios (PROBLEMA DE STRINGS EN MYSQL: QUITA LOS ESPACIOS FINALES)
}

sub getPost{
    my ($self) = shift;
    return $self->post;
}


sub getPostLimpio{
    my ($self) = shift;
    my $tmp= $self->post;
    $tmp =~ s/&nbsp;/ /g; #se limpian las entidades HTML
    return $tmp;
}


sub setPost{
    my ($self) = shift;
    my ($post) = @_;
    $post =~ s/ /&nbsp;/g;
    $self->post($post); # se modifican los espacios (PROBLEMA DE STRINGS EN MYSQL: QUITA LOS ESPACIOS FINALES)
}


sub getInter{
    my ($self) = shift;
    return $self->inter;
}


sub getInterLimpio{
    my ($self) = shift;
    my $tmp= $self->inter;
    $tmp =~ s/&nbsp;/ /g; #se limpian las entidades HTML
    return $tmp;
}

sub setInter{
    my ($self) = shift;
    my ($inter) = @_;
    $inter =~ s/ /&nbsp;/g;
    $self->inter($inter); # se modifican los espacios (PROBLEMA DE STRINGS EN MYSQL: QUITA LOS ESPACIOS FINALES)
}

sub getNivel{
    my ($self) = shift;

    return $self->nivel;
}

sub setNivel{
    my ($self)  = shift;
    my ($nivel) = @_;
    $self->nivel($nivel);
}

sub getVistaOpac{
    my ($self)=shift;

    return $self->vista_opac;
}

sub getVistaCampo{
    my ($self) = shift;

    return $self->vista_campo;
}

sub setVistaCampo{
    my ($self)          = shift;
    my ($vista_campo)   = @_;
    $self->vista_campo($vista_campo);
    $self->save();
}

sub setOrdenSubCampo{
    my ($self)  = shift;
    my ($orden) = @_;
    $self->orden_subcampo($orden);
    $self->save();
}


sub setVistaOpac{
    my ($self) = shift;
    my ($vista_opac) = @_;
    utf8::encode($vista_opac);
    $self->vista_opac($vista_opac);
}

sub getSubCampo{
    my ($self)=shift;

    return $self->subcampo;
}

sub setSubCampo{
    my ($self) = shift;
    my ($subcampo) = @_;
    $self->subcampo($subcampo);
}

sub getCampo{
    my ($self)=shift;

    return $self->campo;
}

sub getId{
    my ($self)=shift;

    return $self->id;
}

sub setCampo{
    my ($self) = shift;
    my ($campo) = @_;
    $self->campo($campo);
}

sub getTipoEjemplar{
    my ($self) = shift;

    return $self->tipo_ejemplar;
}

sub setTipoEjemplar{
    my ($self) = shift;
    my ($tipo_ejemplar) = @_;

    $self->tipo_ejemplar($tipo_ejemplar);
}

sub getOrden{
    my ($self) = shift;

    return $self->orden;
}

sub setOrden{
    my ($self) = shift;
    my ($orden) = @_;
    $self->orden($orden);
    $self->save();
}

sub getOrdenSubCampo{
    my ($self) = shift;

    return $self->orden_subcampo;
}

1;
