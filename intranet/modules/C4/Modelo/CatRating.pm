package C4::Modelo::CatRating;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'cat_rating',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 , length => 11},
        nro_socio       => { type => 'varchar', overflow => 'truncate', not_null => 1, length => 32 },
        id2             => { type => 'integer', overflow => 'truncate', not_null => 1, length => 11 },
        review_aprobado => { type => 'integer', overflow => 'truncate', not_null => 1, length => 11, default => 0, },
        rate            => { type => 'float', not_null => 0, },
        review          => { type => 'text', overflow => 'truncate' },
        date            => { type => 'varchar', overflow => 'truncate', length => 10, not_null => 1 },
    ],

    unique_key => [ 'nro_socio','id2' ],
    primary_key_columns => [ 'id' ],

     relationships =>
    [
      socio => 
      {
        class       => 'C4::Modelo::UsrSocio',
        key_columns => { nro_socio => 'nro_socio' },
        type        => 'one to one',
      },
      nivel2 => 
      {
        class       => 'C4::Modelo::CatRegistroMarcN2',
        key_columns => { id2 => 'id' },
        type        => 'one to one',
      },
    ]
);


sub toString{
	my ($self) = shift;

    return ($self->getRate);
}

sub getObjeto{
	my ($self) = shift;
	my ($socio,$id2) = @_;

	my $objecto= C4::Modelo::CatRating->new(nro_socio => $socio, id2 => $id2, date => C4::Date::getCurrentTimestamp());
	$objecto->load();
	return $objecto;
}


sub getId2{
    my ($self) = shift;

    return ($self->id2);
}

sub setId2{
    my ($self) = shift;
    my ($id2) = @_;

    $self->id2($id2);
}


sub getNroSocio{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->nro_socio));
}

sub setNroSocio{
    my ($self) = shift;
    my ($nro_socio) = @_;

    $self->nro_socio($nro_socio);
}

sub getRate{
    my ($self) = shift;

    return ($self->rate);
}

sub setRate{
    my ($self) = shift;
    my ($rate) = @_;

    $self->rate($rate);
}

sub getReview{
    my ($self) = shift;

    return ($self->review);
}

sub setReview{
    my ($self) = shift;
    my ($review) = @_;

    $self->review($review);
}


sub getDate{
    my ($self) = shift;

    my $dateformat = C4::Date::get_date_format();

    return ( C4::Date::format_date($self->date,$dateformat) );

}

sub setDate{
    my ($self) = shift;
    my ($date) = @_;

    $self->review($date);
}

sub getReviewAprobado{
    my ($self) = shift;

    return ($self->review_aprobado);
}

sub setReviewAprobado{
    my ($self) = shift;
    my ($status) = @_;

    $self->review_aprobado($status);
}
1;

