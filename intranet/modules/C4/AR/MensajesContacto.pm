package C4::AR::MensajesContacto;

use strict;
require Exporter;
use C4::Modelo::Contacto;
use C4::Modelo::Contacto::Manager;

use vars qw(@EXPORT_OK @ISA);
@ISA=qw(Exporter);

@EXPORT_OK=qw( 

    marcarLeido
    marcarRespondido
    marcarNoLeido
    eliminar
    noLeidos
    ver
    listar
    marcar
);


sub marcarLeido{

    my ($id_mensaje) = @_;
    my @filtros;

    push (@filtros, (id => {eq =>$id_mensaje}) );

    my  $contacto = C4::Modelo::Contacto::Manager->get_contacto(query => \@filtros,);

    if (scalar(@$contacto)){
        $contacto->[0]->setLeido(1);
    }

}

sub marcarRespondido{

    my ($id_mensaje) = @_;
    my @filtros;

    push (@filtros, (id => {eq =>$id_mensaje}) );

    my  $contacto = C4::Modelo::Contacto::Manager->get_contacto(query => \@filtros,);

    my $socio = C4::AR::Auth::getSessionNroSocio();
    
    if (scalar(@$contacto)){
        $contacto->[0]->setRespondido($socio);
        $contacto->[0]->setLeido(1);
        $contacto->[0]->save();
    }

}

# Devuelve los mensajes no leidos
sub noLeidos{

    my ($params) = @_;
    my @filtros;

    push (@filtros, (leido => {eq =>0}) );

    my  $noLeidos = C4::Modelo::Contacto::Manager->get_contacto(query => \@filtros,
                                                                sort_by => ['id']);
    

    
    my $cant_noLeidos= scalar(@$noLeidos);


    return ($noLeidos, $cant_noLeidos);

}



# Devuelve los ultimos mensajes sin leer para mostrar en mainpage (3 o menos)
sub ultimosNoLeidos {
    my ($no_leidos)= @_;

    my @ultimos_no_leidos;

    my $i;
    for($i = 1; $i < 4; $i++) {
        if (scalar(@$no_leidos) > 0){
            push(@ultimos_no_leidos, pop(@$no_leidos));
        }
    }
    return(\@ultimos_no_leidos);
}


sub marcarNoLeido{

    my ($id_mensaje) = @_;
    my @filtros;

    push (@filtros, (id => {eq =>$id_mensaje}) );

    my $contacto = C4::Modelo::Contacto::Manager->get_contacto(query => \@filtros,);
    
    if (scalar(@$contacto)){
        $contacto->[0]->setNoLeido();
    }

}

sub eliminar{

    my ($id_mensaje) = @_;
    my @filtros;

    push (@filtros, (id => {eq =>$id_mensaje}) );

    my $contacto = C4::Modelo::Contacto::Manager->get_contacto(query => \@filtros,);

    if (scalar(@$contacto)){
        $contacto->[0]->delete();
    }
}

sub ver{

    my ($id_mensaje) = @_;
    my @filtros;

    push (@filtros, (id => {eq =>$id_mensaje}) );

    my  $contacto = C4::Modelo::Contacto::Manager->get_contacto(query => \@filtros,);

    if (scalar(@$contacto)){
        return ($contacto->[0]);
    }else{
        return (0);
    }

}

sub listar{

    my ($orden,$ini,$cantR) = @_;

    my $mensajes_array_ref = C4::Modelo::Contacto::Manager->get_contacto(   limit   => $cantR,
                                                                            offset  => $ini,
                                                                            sort_by => ['leido','id DESC']
     );

    #Obtengo la cant total de contactos para el paginador
    my $mensajes_array_ref_count = C4::Modelo::Contacto::Manager->get_contacto_count();
    if(scalar(@$mensajes_array_ref) > 0){
        return ($mensajes_array_ref_count, $mensajes_array_ref);
    }else{
        return (0,0);
    }
}


sub marcar{

    my ($id_mensaje) = @_;
    my @filtros;

    push (@filtros, (id => {eq =>$id_mensaje}) );

    my  $contacto = C4::Modelo::Contacto::Manager->get_contacto(query => \@filtros,);

    if (scalar(@$contacto)){
        $contacto->[0]->switchState();
    }
}
1;
