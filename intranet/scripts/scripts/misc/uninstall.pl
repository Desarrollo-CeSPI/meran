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

sub ReadConfigFile
{
	my $fname = shift;	# Config file to read
	my $retval = {};	# Return value: ref-to-hash holding the configuration
	open (CONF, $fname) or return undef;
	while (<CONF>) {
		my $var;		# Variable name
		my $value;		# Variable value
		chomp;
		s/#.*//;		# Strip comments
		next if /^\s*$/;	# Ignore blank lines
		next if (!/^\s*(\w+)\s*=\s*(.*?)\s*$/);
		$var = $1;
		$value = $2;
		$retval->{$var} = $value;
	}
	close CONF;
	return $retval;
}

my $config = ReadConfigFile("/etc/koha.conf");
# to remove web sites:
system("rm -rf ".$config->{intranetdir});
system("\nrm -rf ".$config->{opacdir});
# remove mySQL stuff
# user
print "enter mySQL root password, please\n";
my $response=<STDIN>;
chomp $response;
# DB
system("mysqladmin -f -uroot -p$response drop ".$config->{database});
system("mysql -uroot -p$response -Dmysql -e\"delete from user where user='".$config->{user}.'\'"');
system("mysql -uroot -p$response -Dmysql -e\"delete from db where user='".$config->{user}.'\'"');
# reload mysql
system("mysqladmin -uroot -p$response reload");
system("rm -f /etc/koha-httpd.conf");
system("rm -f /etc/koha.conf");
print "EDIT httpd.conf to remove /etc/koha-httpd.conf\n";