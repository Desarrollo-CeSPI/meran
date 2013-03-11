#!/usr/bin/perl


# Copyright 2000-2002 Katipo Communications
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Koha; if not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA  02111-1307 USA

use strict;
require Exporter;
use C4::Context;
use C4::Output;  # contains gettemplate
use C4::BookShelves;
use C4::AR::Auth;

use CGI;
use C4::Output;

my $input       = new CGI;
my $shelfnumber      = $input->param('shelfnumber');
my $shelfname      = $input->param('shelfname');

&modshelf($shelfnumber,$shelfname);

print $input->redirect("shelves.pl?viewshelf=$shelfnumber");

