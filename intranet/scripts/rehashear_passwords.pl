#!/usr/bin/perl
use strict;
require Exporter;
use C4::Context;
use C4::AR::Auth;

 my $dbh = C4::Context->dbh;

#Re Hasear Pass con sha256
    my $usuarios=$dbh->prepare("SELECT * FROM usr_socio;");
    $usuarios->execute();
    while (my $usuario=$usuarios->fetchrow_hashref) {
      if($usuario->{'password'}){
          my $upus=$dbh->prepare(" UPDATE usr_socio SET password='".C4::AR::Auth::hashear_password($usuario->{'password'},'SHA_256_B64')."' WHERE nro_socio='". $usuario->{'nro_socio'} ."' ;");
          $upus->execute();
      }
    }

