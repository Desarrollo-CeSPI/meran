package C4::Modelo::RepEstadistica;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'rep_estadistica',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', not_null => 1 },
        name            => { type => 'varchar', overflow => 'truncate' , length => 255, not_null => 1},
        query           => { type => 'text', overflow => 'truncate', not_null => 1 },
        category        => { type => 'varchar', overflow => 'truncate', length => 255},
        params          => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 },
        orden           => { type => 'integer', overflow => 'truncate', length => 11, not_null => 1 }
    ],

    primary_key_columns => [ 'id' ],
   
    relationships => [],
);
use C4::Date;

sub getId{

   my ($self) = shift;
   return ($self->id);
}

sub getName{

   my ($self) = shift;
   return ($self->name);
}

sub getParams{

   my ($self) = shift;
   return ($self->params);
}


sub getQuery{

   my ($self) = shift;
   return ($self->query);
}

sub setId{

   my ($self) = shift;
   my ($id) = @_;
   $self->id($id);
}

sub setName{

   my ($self) = shift;
   my ($name) = @_;
   $self->name($name);
}

sub setQuery{

   my ($self) = shift;
   my ($q) = @_;
   $self->query($q);
}

sub getCategory{

   my ($self) = shift;
   return ($self->category);
}
1;

