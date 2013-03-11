package C4::AR::ObjetoCacheMeran;


sub new{
    my $this=shift; #Cogemos la clase que somos o una referencia a la clase (si soy un objeto)
    my $class = ref($this) || $this; #Averiguo la clase a la que pertenezco
    my $self={};
    bless $self, $class; 
    return ($self);
}

sub get{
    my ($self,$parent,$key)= @_;

    # (defined $self->{$parent}->{$key})?C4::AR::Debug::debug("ObjetoCacheMeran => get => CACHED!!!!!!! key => ".$key." => valor ".$self->{$parent}->{$key}):C4::AR::Debug::debug("ObjetoCacheMeran => get => NOOOOOOT CACHED!!!!!!! key => ".$key);

    return ($self->{$parent}->{$key}||undef);
}


sub set{
    my ($self,$parent,$key,$valor)= @_;
    $self->{$parent}->{$key}=$valor; 
}

sub clean{
    $parent = shift; 
    $self->{$parent}={};
}

sub cleanAll{
    $self=shift;
    return CacheMeran->new;
}



1;
