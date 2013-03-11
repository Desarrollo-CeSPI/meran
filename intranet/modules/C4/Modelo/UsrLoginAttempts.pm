package C4::Modelo::UsrLoginAttempts;

use strict;


use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'usr_login_attempts',

    columns => [
        nro_socio    => { type => 'varchar', overflow => 'truncate', length => 16, not_null => 1, overflow => 'truncate' },
        attempts     => { type => 'integer', overflow => 'truncate', length => 32, default => 0, overflow => 'truncate' },
    ],

    primary_key_columns => [ 'nro_socio' ],
);



sub increase{
	my ($self) = shift;
	
	my $attempts = $self->attempts;

	$attempts++;

	$self->attempts($attempts);
	
	$self->save();
}

sub reset{
    my ($self) = shift;
    
    $self->attempts(0);
    
    $self->save();
}


1;