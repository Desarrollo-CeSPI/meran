#!/usr/bin/perl
  use SOAP::Lite;
  print SOAP::Lite
    -> uri('http://www.soaplite.com/Demo')
    -> proxy('http://intranet-koha.linti.unlp.edu.ar'.C4::AR::Utilidades::getUrlPrefix().'/server.pl')
    -> isRegularBorrower($ARGV[0])
    -> result;
  print "\n\n";
