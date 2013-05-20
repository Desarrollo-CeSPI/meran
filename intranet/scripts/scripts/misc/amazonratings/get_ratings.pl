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
# get_ratings.pl
#
# A script to fetch the ratings of a given title, using the isbn number
# Initially just books, but ill expand to handle dvd's and cd's as well

# uses a new table, ratings, pipe the ratings.sql script into mysql to create the table.

use warnings;
use strict;
use HTTP::Cookies;
use LWP::UserAgent;
use C4::Context;

my $dbh = C4::Context->dbh();

my $query =
"SELECT isbn,biblioitemnumber,biblionumber FROM biblioitems where isbn is NOT NULL and isbn <> ''
  group by isbn";
my $sth = $dbh->prepare($query);
$sth->execute();
while ( my $data = $sth->fetchrow_hashref() ) {
    $data->{'isbn'} =~ s/\-//g;
    $data->{'isbn'} =~ s/ +//g;

    # append isbn 
    # isbn must appear without spaces or -
    my $url = "http://www.amazon.com/exec/obidos/search-handle-url/index%3Dbooks%26field-isbn%3D";
    $url .= $data->{'isbn'};
    my $ua      = LWP::UserAgent->new;
    my $content = $ua->get($url)->content;

    #print $content;

    my $rating;

    if ( $content =~ /alt="(.*?) out of 5 stars"/ ) {
        $rating = $1;

    }
    if ($rating) {

       # first check we dont already have a rating, if so, and its different update it
        # otherwise insert a new rating
        my $query2 = "SELECT * FROM ratings WHERE biblioitemnumber=?";
        my $sth2   = $dbh->prepare($query2);
        $sth2->execute( $data->{'biblioitemnumber'} );
        if ( my $ratings = $sth2->fetchrow_hashref() ) {
            if ( $rating ne $ratings->{'rating'} ) {
                my $query3 =
                  "UPDATE ratings SET rating=? WHERE biblioitemnumber=?";
                my $sth3 = $dbh->prepare($query3);
                $sth3->execute( $rating, $data->{'biblioitemnumber'} );
                $sth3->finish();
            }
        }
        else {
            my $query3 =
"INSERT INTO ratings (rating,biblioitemnumber,biblionumber) VALUES (?,?,?)";
            my $sth3 = $dbh->prepare($query3);
            $sth3->execute(
                $rating, $data->{'biblioitemnumber'},
                $data->{'biblionumber'}
            );
            $sth3->finish();
        }
        $sth2->finish();

    }
}