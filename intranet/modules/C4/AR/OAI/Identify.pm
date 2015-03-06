package C4::AR::OAI::Identify;

use strict;
use warnings;
use diagnostics;
use HTTP::OAI;
use C4::Context;

use base ("HTTP::OAI::Identify");

sub new {
    my ($class, $repository) = @_;
    my ($baseURL) = $repository->self_url() =~ /(.*)\?.*/;
    my $self = $class->SUPER::new(
        baseURL             => $baseURL,
        repositoryName      => C4::AR::Preferencias::getValorPreferencia("titulo_nombre_ui"),
        adminEmail          => C4::AR::Preferencias::getValorPreferencia("mailFrom"),
        MaxCount            => C4::AR::Preferencias::getValorPreferencia("OAI-PMH:MaxCount"),
        granularity         => 'YYYY-MM-DD',
        earliestDatestamp   => C4::Modelo::IndiceBusqueda::Manager->get_minimum_timestamp(),
    );
    $self->description(C4::AR::Preferencias::getValorPreferencia("OAI-PMH:archiveID"));
    $self->compression( 'gzip' );

    return $self;
}

# __END__ C4::AR::OAI::Identify
1;