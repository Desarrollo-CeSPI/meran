package C4::Modelo::CircPrestamoVencidoTemp;

use strict;
use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(

	table => 'circ_prestamo_vencido_temp',

	columns => [
	    id          => { type => 'integer', overflow => 'truncate', not_null => 1 },
		  id_prestamo => { type => 'integer', overflow => 'truncate', not_null => 1 },
	],

	primary_key_columns => ['id'],
	
	);
	
sub getIdPrestamo{
    my ($self) = shift;
    return ($self->id_prestamo);
}

sub setIdPrestamo{
    my ($self) = shift;
    my ($id_prestamo) = @_;
    $self->id_prestamo($id_prestamo);
}

sub agregarPrestamo{
    my ($self)   = shift;
    my ($id_prestamo) = @_;
    
    $self->setIdPrestamo($id_prestamo);

    $self->save();
}
