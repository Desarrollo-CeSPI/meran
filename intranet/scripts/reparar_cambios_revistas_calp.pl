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
use lib qw(/usr/local/share/meran/dev/intranet/modules/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10/ /usr/local/share/meran/main/intranet/modules/C4/Share/share/perl/5.10.1/ /usr/local/share/meran/main/intranet/modules/C4/Share/lib/perl5/);

use DBI;

use CGI::Session;
use C4::Context;
use Switch;
use C4::AR::Utilidades;
use C4::Modelo::CatAutor;
use MARC::Record;
use C4::Modelo::CatRegistroMarcN2;
use C4::AR::Nivel2;

my $db_driver =  "mysql";
my $db_name   = 'meran_calp_2018';
my $db_host   = 'db';
my $db_user   = 'root';
my $db_passwd = 'dev';
my $dbh = C4::Context->dbh;

my $db_calp= DBI->connect("DBI:mysql:$db_name:$db_host",$db_user, $db_passwd);
$db_calp->do('SET NAMES utf8');

my $cant=0;
my $encontrado=0;
my $distintos=0;
my @id_cambiados=();

my $id1 = $ARGV[0] || 41825;

my $old = "SELECT * FROM  cat_registro_marc_n2 WHERE  id1 = ".$id1."; ";
my $old_rec = $db_calp->prepare($old);
$old_rec->execute();
my $cant_old_rec =  $old_rec->rows;
print "Grupos de la revista ".$cant_old_rec."\n";

  while (my $nivel2_old = $old_rec->fetchrow_hashref){
    $encontrado++;
    my $nivel2   = C4::AR::Nivel2::getNivel2FromId2($nivel2_old->{'id'});
    my $mc_old = MARC::Record->new_from_usmarc($nivel2_old->{'marc_record'}); 
    my $mc_new = $nivel2->getMarcRecordObject();


    if ( $mc_old->as_usmarc() ne $mc_new->as_usmarc()){
    $distintos++;
    print "\n OLD = \n";
    print $mc_old->as_formatted();
    print "\n NEW = \n";
    print $mc_new->as_formatted();
    push(@id_cambiados,$nivel2_old->{'id'});
    
    $nivel2->setMarcRecord($mc_old->as_usmarc());
   # $nivel2->save();
    }
  }

print "\n\n\n";

print join(',',@id_cambiados);

print "\n\n\n";