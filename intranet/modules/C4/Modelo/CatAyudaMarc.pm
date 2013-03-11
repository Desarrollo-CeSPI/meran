package C4::Modelo::CatAyudaMarc;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_ayuda_marc',

    columns => [
        id          => { type => 'serial', overflow => 'truncate', not_null => 1 },
        ui          => { type => 'integer', overflow => 'truncate', not_null => 1},
        campo       => { type => 'character', overflow => 'truncate', length => 3, not_null => 1 },
        subcampo    => { type => 'character', overflow => 'truncate', length => 1, not_null => 1 },
        ayuda       => { type => 'text', overflow => 'truncate', not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],

     relationships =>
    [
      unidad_informacion => 
      {
        class       => 'C4::Modelo::PrefUnidadInformacion',
        key_columns => { ui => 'id' },
        type        => 'one to one',
      },
    ]
);

##################### FUNCIONES DEL MODELO #################

sub agregarAyudaMarc{
    
    my ($self)   = shift;
    my ($params) = @_;
    
    $self->setSubCampo($params->{'subcampo'});
    $self->setCampo($params->{'campo'});
    $self->setAyuda($params->{'ayuda'});
    # $self->setUI($params->{'ui'});

    my $ui = C4::Modelo::PrefUnidadInformacion->getByCode(C4::AR::Preferencias::getValorPreferencia('defaultUI'));

    $self->setUI($ui->getId);

    $self->save();
}

sub editarAyudaMarc{

    my ($self)   = shift;
    my ($params) = @_;
    
    $self->setAyuda($params->{'ayuda'});

    $self->save();
}

################ GETTER Y SETTER ######################

sub getUI{
    my ($self) = shift;

    return $self->ui;
}

sub setUI{
    my ($self)  = shift;
    my ($ui)    = @_;

    $self->ui($ui); 
}

sub getSubCampo{
    my ($self) = shift;

    return $self->subcampo;
}

sub setSubCampo{
    my ($self)      = shift;
    my ($subcampo)  = @_;

    $self->subcampo($subcampo);
}

sub getCampo{
    my ($self) = shift;

    return $self->campo;
}

sub setCampo{
    my ($self)  = shift;
    my ($campo) = @_;

    $self->campo($campo);
}

sub getAyuda{
    my ($self) = shift;

    return ($self->ayuda);
}

sub getAyudaShort{
    my ($self) = shift;

    my $subString = substr ($self->ayuda,0,70);

    return ($subString."...");
}

sub setAyuda{
    my ($self) = shift;
    my ($ayuda) = @_;

    $self->ayuda($ayuda);
}


1;