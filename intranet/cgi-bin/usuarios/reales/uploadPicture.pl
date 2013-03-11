#!/usr/bin/perl
use CGI;
use C4::Context;
use C4::AR::UploadFile;
use C4::AR::Auth;
use JSON;
use strict;
use CGI::Carp qw(fatalsToBrowser);
use Digest::MD5;

my $query       = new CGI;
my $authnotrequired = 0;


my ($nro_socio, $session, $flags) = checkauth( 
                                                        $query, 
                                                        $authnotrequired,
                                                        {   ui              => 'ANY', 
                                                            tipo_documento  => 'ANY', 
                                                            accion          => 'MODIFICACION', 
                                                            entorno         => 'usuarios'},
                                                            "intranet"
                        );  


my ($error,$codMsg,$message) = C4::AR::UploadFile::uploadPhoto($query);


