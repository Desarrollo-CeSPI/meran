#!/usr/bin/perl
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
