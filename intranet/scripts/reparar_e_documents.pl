#!/usr/bin/perl
#
# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.
#

use C4::Modelo::EDocument;
use C4::Modelo::EDocument::Manager;
use C4::AR::Auth;

my @allowed_extensions_array  = C4::AR::UploadFile::getAllowedExtensionsArray();
my $eDocsDir                  = C4::Context->config("edocsdir");
my $db                        = C4::Modelo::EDocument->new()->db();
my $e_edocuments_array_ref    = C4::Modelo::EDocument::Manager->get_e_document(
                                                                    db => $db,
                                                                    query => [ ],
                                                            );

C4::AR::Debug::debug("Procesando carpeta " . $eDocsDir);

foreach my $e_doc (@$e_edocuments_array_ref){
  C4::AR::Debug::debug("Filename " . $e_doc->filename);
  my $filename = $e_doc->filename;

  foreach my $extension (@allowed_extensions_array){
    my $uc_extension = uc $extension;
    C4::AR::Debug::debug("Procesando extension " . $extension);
    
    if (($filename =~ m/$extension/)||($filename =~ m/$uc_extension/)) {
      C4::AR::Debug::debug("Econtré la extensión " . $extension . " para el archivo " . $filename);  
      $new_filename = $filename . "." . $extension;
      C4::AR::Debug::debug("Muevo archivo " . $filename . " a " . $new_filename);
      rename $eDocsDir."/".$filename, $eDocsDir."/".$new_filename;  
      $e_doc->setFilename($new_filename); 
      $e_doc->save;   
      last;
    }
  }

}

1;