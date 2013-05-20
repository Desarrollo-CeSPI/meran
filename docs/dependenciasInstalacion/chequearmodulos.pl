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
 #!/usr/local/bin/perl
 use strict;
 use ExtUtils::Installed;
 
 my %modulos=('File::LibMagic'=>'0.96','Date::Manip'=>'5.54','HTML::Template'=>'2.9','MARC::Record'=>'2.0.0','Mail::Sendmail'=>'0.79','Net::Z3950::ZOOM'=>'1.24','Net::LDAP'=>'0.36','PDF::Report'=>'1.30','GD'=>'2.39','Chart::Pie'=>'2.4.1','HTML::Template::Expr'=>'0.05','Archive::Zip'=>'1.18','HTML::Template::Expr'=>'0.05','DBD::mysql'=>'4.007','OpenOffice::OODoc'=>'2.124','Image::Size'=>'3.100001','Encode'=>'2.39','Net::SMTP::TLS'=>'0.12', 'Net::SSLeay'=>'1.35', 'Net::SMTP::SSL'=>'1.01', 'HTTP::OAI' => '3.23');

 my $instmod = ExtUtils::Installed->new();
 my @modulos_instalados=$instmod->modules();

print "Chequeando modulos de PERL";
print "\n";
my $instalar;
foreach my $mod (keys(%modulos)) {
   eval("use $mod");
   my $version_instalada= $mod->VERSION;
   my $version_necesaria=$modulos{$mod};
   if (($version_instalada ne "")&&($version_instalada ge $version_necesaria)){ print "$mod ok";}
				elsif($version_instalada ne ""){
				print "PROBLEMA\n";
   				print "$mod ---- instalada $version_instalada------necesaria  $version_necesaria";
				}
				else{
				print "PROBLEMA, no esta instalado.\n Instalar automaticamente (S/N)?";
				$instalar= readline(STDIN);
				chomp($instalar);
				if (($instalar eq "S")||($instalar eq "s")||($instalar eq "Y")){
				system "cpan -i $mod";}
				}
   print "\n";
}