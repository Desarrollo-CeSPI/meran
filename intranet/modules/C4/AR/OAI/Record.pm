package C4::AR::OAI::Record;

use strict;
use warnings;
use diagnostics;
use HTTP::OAI;
use HTTP::OAI::Metadata::OAI_DC;
use MARC::File::XML ( BinaryEncoding => 'utf8');

use base ("HTTP::OAI::Record");

sub new {
    my ($class, $repository, $marc_record, $timestamp,$id, %args) = @_;
    my $self = $class->SUPER::new(%args);
#     $timestamp =~ s/ /T/, $timestamp .= 'Z';
    $self->header( new HTTP::OAI::Header(
        identifier  => $args{identifier},
        datestamp   => $timestamp,
    ) );

    if ( $args{metadataPrefix} eq 'marcxml' ) {
        #Registro en MARCXML
        my $marcxml     = MARC::File::XML::record( $marc_record );
        my $parser = XML::LibXML->new();
        my $record_dom = $parser->parse_string( $marcxml );
        $self->metadata( HTTP::OAI::Metadata->new( dom => $record_dom ) );
    }
    else {
        #registro en OAI_DC
         $self->metadata(HTTP::OAI::Metadata::OAI_DC->new(dc => getOAI_DCfromMARC_Record($marc_record,$id) ));

    }


    return $self;
}

sub getOAI_DCfromMARC_Record {
    my ($marc_record,$id) = @_;
    my $dc = {};

    # DC:Title ==> Titulo: Subtitulo
    my @title;
    if($marc_record->subfield('245','a')) {
        my $titulo=$marc_record->subfield('245','a');
        if ($marc_record->subfield('245','b')) {
            $titulo.=": ".$marc_record->subfield('245','b');
        }
        push (@title, cleanStrings($titulo));
    }
    push (@{$dc->{ 'title' }}, @title);

    # DC:Creator => Autor

    if ($marc_record->subfield('100',"a")){
        push (@{$dc->{ 'creator' }}, cleanStrings($marc_record->subfield('100',"a")));
    }
    if ($marc_record->subfield('110',"a")){
        push (@{$dc->{ 'creator' }}, cleanStrings($marc_record->subfield('110',"a")));
    }
    if ($marc_record->subfield('111',"a")){
        push (@{$dc->{ 'creator' }}, cleanStrings($marc_record->subfield('111',"a")));
    }

    # DC:Subject => Temas
    foreach my $campo650 ($marc_record->field('650')){
        if ($campo650->subfield("a")){
            push (@{$dc->{ 'subject' }}, cleanStrings($campo650->subfield("a")));
        }
    }
    foreach my $campo651 ($marc_record->field('651')){
        if ($campo651->subfield("a")){
            push (@{$dc->{ 'subject' }}, cleanStrings($campo651->subfield("a")));
        }
    }
    foreach my $campo653 ($marc_record->field('653')){
        if ($campo653->subfield("a")){
            push (@{$dc->{ 'subject' }}, cleanStrings($campo653->subfield("a")));
        }
    }

    # DC:Description ==> Resumen;
    if($marc_record->subfield('520','a')) {
        push (@{$dc->{ 'description' }}, cleanStrings($marc_record->subfield('520','a')));
    }

    # DC:Publisher => Editor
    foreach my $campo260 ($marc_record->field('260')){
        my $editor=$campo260->subfield("b");
        if ($campo260->subfield("a")){
            $editor.=" - ".$campo260->subfield("a");
        }
        push (@{$dc->{ 'publisher' }},cleanStrings($editor));

        # DC:Date => Año de publicacion
        if($campo260->subfield('c')) {
            push (@{$dc->{ 'date' }}, cleanStrings($campo260->subfield('c')));
        }

    }

    # DC:Contributor => Colaboradores
    foreach my $campo700 ($marc_record->field('700')){
        if ($campo700->subfield("a")){
            my $colab = $campo700->subfield('a');
            my $funcion = $campo700->subfield('e');
            #Los colaboradores y sus funciones
            if($funcion){
               $colab.=" (".$funcion.")";
            }
            push (@{$dc->{ 'contributor' }},cleanStrings($colab));
        }
    }
    # DC:Type => Tipo de Documento
    if($marc_record->subfield('910','a')) {
        push (@{$dc->{ 'type' }}, cleanStrings($marc_record->subfield('910','a')));
    }

    # DC:Format => Formato 
    if($marc_record->subfield('856','q')) {
        push (@{$dc->{ 'format' }}, cleanStrings($marc_record->subfield('856','q')));
    }

    # DC:Identifier => ISBN + ISSN + URI
    #url
        push (@{$dc->{ 'identifier' }}, "http://".C4::AR::Preferencias::getValorPreferencia("serverName")."/meran/opac-detail.pl?id1=".$id);

    #isbn
    if($marc_record->subfield('020','a')) {
        my @isbns=$marc_record->subfield('020','a');
        for (my $i=0; $i < scalar(@isbns); $i++){
            push (@{$dc->{ 'identifier' }}, cleanStrings("ISBN: ".$isbns[$i]));
        }
    }
    #issn
    if($marc_record->subfield('022','a')) {
        push (@{$dc->{ 'identifier' }}, cleanStrings("ISSN: ".$marc_record->subfield('022','a')));
    }

    # DC:Language => Lenguaje 

    foreach my $campo41 ($marc_record->field('041')){
        if ($campo41->subfield("a")){
            push (@{$dc->{ 'language' }}, cleanStrings($campo41->subfield("a")));
        }
    }

    return $dc;
}


sub cleanStrings{
    my ($data) = @_;
    if($data){
        $data = Encode::encode_utf8($data);
        $data =~ s/[^[\x20-\xFF]//g;
    }
    return ($data);
}

# __END__ C4::AR::OAI::Record
1;
