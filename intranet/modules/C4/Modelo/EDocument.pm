package C4::Modelo::EDocument;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);
=item
#SQL Export de la tabla

DROP TABLE IF EXISTS `e_document`;
CREATE TABLE IF NOT EXISTS `e_document` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) CHARACTER SET utf8 NOT NULL,
  `title` varchar(255) CHARACTER SET utf8 NOT NULL,
  `id2` int(11) NOT NULL,
  `file_type` varchar(10) CHARACTER SET utf8 NOT NULL DEFAULT 'pdf',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=UTF8 AUTO_INCREMENT=0 ;

=cut

__PACKAGE__->meta->setup(
    table   => 'e_document',

    columns => [
        id              => { type => 'serial', overflow => 'truncate', length => 11, },
        filename        => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        title           => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
        id2             => { type => 'int', overflow => 'truncate', length => 11, not_null => 1 },
        file_type       => { type => 'varchar', overflow => 'truncate', length => 64, not_null => 1, default=>"pdf" },
    ],

    primary_key_columns => [ 'id' ],
);


sub agregar(){
	my ($self) = shift;
	my ($id2) = shift;
    my ($filename) = shift;
    my ($type) = shift;
    my ($name) = shift;
	
	$self->setId2($id2);
	$self->setFilename($filename);
    $self->setFileType($type);
    $self->setTitle($name);
    
    $self->save();
	
}

sub getIconType(){
    my ($self) = shift;

    my $file_type = $self->getFileType;
    
    my @nombreYExtension = split('\/',$file_type);
    
    return (@nombreYExtension[1]);
	
}
# ------GETTERS--------------------
sub getId{
    my ($self) = shift;
    return ($self->id);
}

sub getFilename{
    my ($self) = shift;
    return ($self->filename);
}

sub getTitle{
    my ($self) = shift;
    return ($self->title);
}

sub getId2{
    my ($self) = shift;
    return ($self->id2);
}

sub getFileType{
    my ($self) = shift;
    return ($self->file_type);
}



# ------SETTERS--------------------

sub setFilename{
    my ($self)   = shift;
    my ($filename) = @_;
    $self->filename($filename);
}

sub setTitle{
    my ($self)   = shift;
    my ($title) = @_;
    $self->title($title);
}

sub setId2{
    my ($self)   = shift;
    my ($id2) = @_;
    $self->id2($id2);
}

sub setFileType{
    my ($self)   = shift;
    my ($file_type) = @_;
    $self->file_type($file_type);
}
