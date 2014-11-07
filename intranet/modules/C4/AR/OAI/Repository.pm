package C4::AR::OAI::Repository;

use base ("HTTP::OAI::Repository");

use strict;
use warnings;
use diagnostics;

use HTTP::OAI;
use HTTP::OAI::Repository qw/:validate/;

use XML::SAX::Writer;
use XML::LibXML;
use XML::LibXSLT;
use CGI qw/:standard -oldstyle_urls/;

use C4::Context;

use C4::AR::OAI::Identify;
use C4::AR::OAI::ListMetadataFormats;
use C4::AR::OAI::GetRecord;
use C4::AR::OAI::ListRecords;
use C4::AR::OAI::ListIdentifiers;

=head1 NAME

C4::OAI::Repository - Handles OAI-PMH requests for a Koha database.

=head1 SYNOPSIS

  use C4::OAI::Repository;

  my $repository = C4::OAI::Repository->new();

=head1 DESCRIPTION

This object extend HTTP::OAI::Repository object.

=cut



sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(%args);

    $self->{ meran_identifier      } = C4::AR::Preferencias::getValorPreferencia("OAI-PMH:archiveID");
    $self->{ meran_max_count       } = C4::AR::Preferencias::getValorPreferencia("OAI-PMH:MaxCount");
    $self->{ meran_metadata_format } = ['oai_dc', 'marcxml'];

    # Check for grammatical errors in the request
    my @errs = validate_request(CGI::Vars());

    # Is metadataPrefix supported by the respository?
    my $mdp = param('metadataPrefix') || '';
    if ( $mdp && !grep { $_ eq $mdp } @{$self->{ meran_metadata_format }} ) {
        push @errs, new HTTP::OAI::Error(
            code    => 'cannotDisseminateFormat',
            message => "Dissemination as '$mdp' is not supported",
        );
    }

    my $response;
    if ( @errs ) {
        $response = HTTP::OAI::Response->new(
            requestURL  => self_url(),
            errors      => \@errs,
        );

    }
    else {
        my %attr = CGI::Vars();
        my $verb = delete( $attr{verb} );
        if ( grep { $_ eq $verb } qw( ListSets ) ) {
            $response = HTTP::OAI::Response->new(
                requestURL  => $self->self_url(),
                errors      => [ new HTTP::OAI::Error(
                    code    => 'noSetHierarchy',
                    message => "Repository doesn't have sets",
                    ) ] ,
            );
        }
        elsif ( $verb eq 'Identify' ) {
            $response = C4::AR::OAI::Identify->new( $self );
        }
        elsif ( $verb eq 'ListMetadataFormats' ) {
            $response = C4::AR::OAI::ListMetadataFormats->new( $self );
        }
        elsif ( $verb eq 'GetRecord' ) {
            $response = C4::AR::OAI::GetRecord->new( $self, %attr );
        }
        elsif ( $verb eq 'ListRecords' ) {
            $response = C4::AR::OAI::ListRecords->new( $self, %attr );
        }
        elsif ( $verb eq 'ListIdentifiers' ) {
            $response = C4::AR::OAI::ListIdentifiers->new( $self, %attr );
        }  
    }

   $response->set_handler( XML::SAX::Writer->new( Output => *STDOUT, EncodeTo =>'UTF-8') );
   $response->xslt("/includes/oai2.xsl");

    $response->generate;

    bless $self, $class;
    return $self;
}
1;
