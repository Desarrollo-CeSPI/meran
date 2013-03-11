package C4::Modelo::BackgroundJob;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'background_job',

    columns => [
        id      => { type => 'serial', overflow => 'truncate', not_null => 1 },
        name    => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0},
        jobID   => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0},
        progress=> { type => 'float', length => 11, overflow => 'truncate', not_null => 0},
        size    => { type => 'integer', overflow => 'truncate', not_null => 0},
        status  => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0},
        invoker => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 0},

    ],

    primary_key_columns => [ 'id' ],
    unique_key => [ 'jobID' ],

);

use C4::Modelo::BackgroundJob::Manager;

    
sub getName{
    my ($self) = shift;

    return (C4::AR::Utilidades::trim($self->name));
}
    
sub setName{
    my ($self) = shift;
    my ($name) = @_;

    $self->name($name);
}


1;

