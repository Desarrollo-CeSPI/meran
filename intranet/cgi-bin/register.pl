#!/usr/bin/perl
use strict;
require Exporter;
use C4::AR::Auth;
use C4::AR::Preferencias;
use CGI;


C4::AR::Preferencias::setVariable('registradoMeran', 1);
C4::AR::Auth::redirectTo("http://meran.unlp.edu.ar/registrarse/");


1;