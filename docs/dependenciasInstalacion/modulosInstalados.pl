#!/usr/bin/perl

use ExtUtils::Installed;
use CPAN;

printf("%-20s %10s %10s\n", "Module", "Installed", "CPAN");

my $instmod = ExtUtils::Installed->new();
my @modulos_instalados=$instmod->modules();


foreach $a (@modulos_instalados) {
    print "MODULO: ".$a."\n";
  foreach $mod (CPAN::Shell->expand("Module", $a)){
    printf("%-20s %10s %10s %s\n",
      $mod->id,
      $mod->inst_version eq "undef" || !defined($mod->inst_version)
        ? "-" : $mod->inst_version,
      $mod->cpan_version eq "undef" || !defined($mod->cpan_version)
        ? "-" : $mod->cpan_version,
      $mod->uptodate ? "" : "*"
    );
  }
}
