#!/usr/bin/perl

use strict;
use C4::AR::Auth;

use JSON;
use CGI;

C4::AR::Auth::_destruirSession('U400');