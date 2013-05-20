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
use Rose::DB::Object::Loader;

my $loader = Rose::DB::Object::Loader->new(
                   db_dsn       => 'dbi:mysql:dbname=dev;host=localhost',
                   db_username  => 'kohaadmin',
                   db_password  => 'patyalmicro',
                   db_options   => { AutoCommit => 1},
		  class_prefix => 'C4::Modelo'
                    );
$loader->make_modules(  module_dir => "/tmp/modules/",
                                        );