package C4::Modelo::SysMetodoAuth;

use strict;


use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'sys_metodo_auth',

    columns => [
        id          => { type => 'serial', overflow => 'truncate', length => 12, not_null => 1 },
        metodo      => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        orden       => { type => 'integer', overflow => 'truncate', length => 12, not_null => 1 },
        enabled     => { type => 'integer', overflow => 'truncate', length => 12, default => 1, not_null => 1 },
    ],

    primary_key_columns => [ 'id' ],
    unique_key          => [ 'metodo' ],
);

sub agregarMetodo{
    my ($self)      = shift;
    my ($string)    = @_; 
    my $orden       = C4::Modelo::SysMetodoAuth::Manager->get_max_orden() + 1;
    
    $self->metodo($string);
    $self->enabled("0");
    $self->orden($orden);
    
    $self->save();
}


sub getMetodo{
    my ($self) = shift;
    return ($self->metodo);
}

sub setMetodo{
    my ($self) = shift;
    my ($string) = @_;    
    
    $self->metodo($string);
    $self->save();    
}

sub getOrden{
    my ($self) = shift;
    return ($self->orden);
}

sub setOrden{
    my ($self) = shift;
    my ($number) = @_;    
    
    $self->orden($number);
    $self->save();    
}

sub isEnabled{
    my ($self) = shift;
    return ($self->enabled);
}

sub enable{
    my ($self) = shift;
    $self->enabled("1");
    $self->save();    
}

sub disable{
    my ($self) = shift;
    $self->enabled("0"); 
    $self->save();     
}

1;

