package C4::AR::OAI::Record;

use strict;
use warnings;
use diagnostics;
use HTTP::OAI;
use HTTP::OAI::Metadata::OAI_DC;
use MARC::File::XML ( BinaryEncoding => 'utf8');

use base ("HTTP::OAI::Record");

sub new {
    my ($class, $repository, $marc_record, $id, %args) = @_;

die;
    my $self = $class->SUPER::new(%args);
#     $timestamp =~ s/ /T/, $timestamp .= 'Z';
    $self->header( new HTTP::OAI::Header(
        identifier  => $args{identifier},
        datestamp   => $id,
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
         $self->metadata(HTTP::OAI::Metadata::OAI_DC->new(dc => getOAI_DCfromMARC_Record($marc_record) ));

    }


    return $self;
}

sub getOAI_DCfromMARC_Record {
    my ($marc_record) = @_;
    my $dc = {};

    # DC:Title ==> Titulo: Subtitulo
    my @title;
    if($marc_record->subfield('245','a')) {
        my $titulo=$marc_record->subfield('245','a');
        if ($marc_record->subfield('245','b')) {
            $titulo.=": ".$marc_record->subfield('245','b');
        }
        push (@title, $titulo);
    }
    push (@{$dc->{ 'title' }}, @title);

    # DC:Creator => Autor
    my @autor;
    if ($marc_record->subfield('100',"a")){
        push (@autor, $marc_record->subfield('100',"a"));
    }
    if ($marc_record->subfield('110',"a")){
        push (@autor, $marc_record->subfield('110',"a"));
    }
    if ($marc_record->subfield('111',"a")){
        push (@autor, $marc_record->subfield('111',"a"));
    }
    #Autores Adicionales
    if ($marc_record->subfield('700',"a")){
        push (@autor, $marc_record->subfield('700',"a"));
    }
    push (@{$dc->{ 'creator' }}, @autor);

    # DC:Subject => Temas
    my @subject;
    if ($marc_record->subfield('650',"a")){
        push (@subject, $marc_record->subfield('650',"a"));
    }
    if ($marc_record->subfield('651',"a")){
        push (@subject, $marc_record->subfield('651',"a"));
    }
    if ($marc_record->subfield('653',"a")){
        push (@subject, $marc_record->subfield('653',"a"));
    }
    push (@{$dc->{ 'subject' }}, @subject);

    # DC:Description ==> Resumen;
    if($marc_record->subfield('520','a')) {
        push (@{$dc->{ 'description' }}, $marc_record->subfield('520','a'));
    }

    # DC:Publisher => Editor
    my @publisher;
    if ($marc_record->subfield('260',"b")){
        my @editores=$marc_record->subfield('260',"b");
        foreach my $editor (@editores){
             if ($marc_record->subfield('260',"a")){
                $editor.=" - ".$marc_record->subfield('260',"a");
             }
            push (@publisher,$editor);
        }
    }
    push (@{$dc->{ 'publisher' }}, @publisher);

    # DC:Date => Año de publicacion
    if($marc_record->subfield('260','c')) {
        push (@{$dc->{ 'date' }}, $marc_record->subfield('260','c'));
    }


    # DC:Contributor => Colaboradores
    my @colaboradores;
    if ($marc_record->subfield('710',"a")){
        my @colabs=$marc_record->subfield('710','a');
        my @tiposcolabs=$marc_record->subfield('710','4');
        #Los colaboradores y sus funciones
        for (my $i=0; $i < scalar(@colabs); $i++){
            if($tiposcolabs[$i]){
                $colabs[$i].=" (".$tiposcolabs[$i].")";
            }
            push (@colaboradores,$colabs[$i]);
        }
    }
    push (@{$dc->{ 'contributor' }}, @colaboradores);

    # DC:Type => Tipo de Documento
    if($marc_record->subfield('910','a')) {
        push (@{$dc->{ 'type' }}, C4::Biblio::getItemType($marc_record->subfield('910','a')));
    }

    # DC:Format => Formato 
    if($marc_record->subfield('856','q')) {
        push (@{$dc->{ 'format' }}, $marc_record->subfield('856','q'));
    }

    # DC:Identifier => ISBN + ISSN 
    #isbn
    if($marc_record->subfield('020','a')) {
        my @isbns=$marc_record->subfield('020','a');
        for (my $i=0; $i < scalar(@isbns); $i++){
            push (@{$dc->{ 'identifier' }}, "ISBN: ".$isbns[$i]);
        }
    }
    #issn
    if($marc_record->subfield('022','a')) {
        push (@{$dc->{ 'identifier' }}, "ISSN: ".$marc_record->subfield('022','a'));
    }

   # DC:Relation
    #url
        push (@{$dc->{ 'relation' }}, C4::Context->preference("OAI-PMH:URL").$marc_record->subfield('090','c'));

    # DC:Language => Lenguaje 
    if($marc_record->subfield('041','a')) {
        my %lang=C4::Biblio::getlanguages();
         push (@{$dc->{ 'language' }},$lang{$marc_record->subfield('041','a')});
#         push (@{$dc->{ 'language' }},$marc_record->subfield('041','a'));
    }


    return $dc;
}



# __END__ C4::AR::OAI::Record
1;
