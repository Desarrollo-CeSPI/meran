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
use CGI;
use C4::AR::Auth;




sub StringSearch  {
	my ($env,$searchstring,$type)=@_;
	my $dbh = C4::Context->dbh;
	$searchstring=~ s/\'/\\\'/g;
	my @data=split(' ',$searchstring);
	my $count=@data;
	my $sth=$dbh->prepare("Select id,category,authorised_value,lib from pref_valor_autorizado where (category like ?) order by category,authorised_value");
	$sth->execute("$data[0]%");
	my @results;
	my $cnt=0;
	while (my $data=$sth->fetchrow_hashref){
	push(@results,$data);
	$cnt ++;
	}
	$sth->finish;
	return ($cnt,\@results);
}

my $input = new CGI;
my $searchfield=$input->param('searchfield');
$searchfield=~ s/\,//g;
my $id = $input->param('id');
my $offset=$input->param('offset');
my $script_name=C4::AR::Utilidades::getUrlPrefix()."/admin/authorised_values.pl";
my $dbh = C4::Context->dbh;

my ($template, $session, $t_params) = C4::AR::Auth::get_template_and_user({
                                    template_name => "admin/global/authorised_values.tmpl",
                                    query => $input,
                                    type => "intranet",
                                    authnotrequired => 0,
                                    flagsrequired => {  ui => 'ANY', 
                                                        tipo_documento => 'ANY',   
                                                        accion => 'CONSULTA', 
                                                        entorno => 'undefined'},
                                    debug => 1,
			    });
my $pagesize=20;
my $op = $input->param('op');

if ($op) {
        $t_params->{'script_name'}= $script_name;
        $t_params->{$op}= 1; # we show only the TMPL_VAR names $op
} else {
    $t_params->{'script_name'} = $script_name || 1; # we show only the TMPL_VAR names $op
}
################## ADD_FORM ##################################
# called by default. Used to create form to add or  modify a record
if ($op eq 'add_form') {
	my $data;
	if ($id) {
		my $dbh = C4::Context->dbh;
		my $sth=$dbh->prepare("select id,category,authorised_value,lib from pref_valor_autorizado where id=?");
		$sth->execute($id);
		$data=$sth->fetchrow_hashref;
		$sth->finish;
	} else {
		$data->{'category'} = $input->param('category');
	}
	if ($searchfield) {
		$t_params->{'action'}= "Modificar Valores Autorizados";
		$t_params->{'heading-modify-authorized-value-p'}= 1;
	} elsif ( ! $data->{'category'} ) {
		$t_params->{'action'}= "Agregar Nueva Categor&iacute;a";
		$t_params->{'heading-add-new-category-p'}= 1;
	} else {
		$t_params->{'action'}= "Agregar Valores Autorizados";
		$t_params->{'heading-add-authorized-value-p'}= 1;
	}
	$t_params->{'use-heading-flags-p'}= 1;
	$t_params->{'category'}= $data->{'category'};
	$t_params->{'authorised_value'}= $data->{'authorised_value'};
	$t_params->{'lib'}= $data->{'lib'};
	$t_params->{'id'}= $data->{'id'};


	if ($data->{'category'}) {
	
	
$t_params->{'category'}= "<input type=\'hidden\'name=\'category\'value=".$data->{'category'}.">".$data->{'category'};
	} else {
		$t_params->{'category'}= "<input type=text name=\'category\' size=8 maxlength=8>";
	}
################## ADD_VALIDATE ##################################
# called by add_form, used to insert/modify data in DB
} elsif ($op eq 'add_validate') {
	my $dbh = C4::Context->dbh;
	my $sth=$dbh->prepare("replace pref_valor_autorizado (id,category,authorised_value,lib) values (?,?,?,?)");
	my $lib = $input->param('lib');
	undef $lib if ($lib eq ""); # to insert NULL instead of a blank string
	
	$sth->execute($input->param('id'), $input->param('category'), $input->param('authorised_value'), $lib);
	$sth->finish;
	print "Content-Type: text/html\n\n<META HTTP-EQUIV=Refresh CONTENT=\"0; URL=authorised_values.pl?searchfield=".$input->param('category')."\"></html>";
	exit;
################## DELETE_CONFIRM ##################################
# called by default form, used to confirm deletion of data in DB
} elsif ($op eq 'delete_confirm') {
	my $dbh = C4::Context->dbh;
	my $sth=$dbh->prepare("select category,authorised_value,lib from pref_valor_autorizado where id=?");
	$sth->execute($id);
	my $data=$sth->fetchrow_hashref;
	$sth->finish;
	$t_params->{'searchfield'}= $searchfield;
	$t_params->{'Tvalue'}= $data->{'authorised_value'};
	$t_params->{'id'}=$id;


#  END $OP eq DELETE_CONFIRM
################## DELETE_CONFIRMED ##################################
# called by delete_confirm, used to effectively confirm deletion of data in DB
} elsif ($op eq 'delete_confirmed') {
	my $dbh = C4::Context->dbh;
	my $sth=$dbh->prepare("delete from pref_valor_autorizado where id=?");
	$sth->execute($id);
	$sth->finish;
	print "Content-Type: text/html\n\n<META HTTP-EQUIV=Refresh CONTENT=\"0; URL=authorised_values.pl?searchfield=$searchfield\"></html>";
	exit;

													# END $OP eq DELETE_CONFIRMED
################## DEFAULT ##################################
} else { # DEFAULT
	# build categories list
	my $sth = $dbh->prepare("select distinct category from pref_valor_autorizado");
	$sth->execute;
	my @category_list;
	while ( my ($category) = $sth->fetchrow_array) {
		push(@category_list,$category);
	}
	# push koha system categories
	my $tab_list = CGI::scrolling_list(-name=>'searchfield',
			-values=> \@category_list,
			-default=>"",
			-size=>1,
			-multiple=>0,
			);
	if (!$searchfield) {
		$searchfield=$category_list[0];
	}
	my $env;
	my ($count,$results)=StringSearch($env,$searchfield,'web');
	my $toggle='par';
	my @loop_data = ();
	# builds value list
	for (my $i=$offset; $i < ($offset+$pagesize<$count?$offset+$pagesize:$count); $i++){
	  	if ($toggle eq 'par'){
			$toggle='impar';
	  	} else {
			$toggle='par';
	  	}
		my %row_data;  # get a fresh hash for the row data
		$row_data{category} = $results->[$i]{'category'};
		$row_data{clase}=$toggle;
		$row_data{authorised_value} = $results->[$i]{'authorised_value'};
		$row_data{lib} = $results->[$i]{'lib'};
		$row_data{edit} = "$script_name?op=add_form&id=".$results->[$i]{'id'};
		$row_data{delete} = "$script_name?op=delete_confirm&searchfield=$searchfield&id=".$results->[$i]{'id'};
		push(@loop_data, \%row_data);
	}

	$t_params->{'loop'}= \@loop_data;
	$t_params->{'tab_list'}= $tab_list;
	$t_params->{'category'}= $searchfield;

	if ($offset>0) {
		my $prevpage = $offset-$pagesize;
		$t_params->{'isprevpage'}= $offset;
		$t_params->{'prevpage'}= $prevpage;
		$t_params->{'searchfield'}= $searchfield;
	        $t_params->{'script_name'}= $script_name;
	}
	if ($offset+$pagesize<$count) {
		my $nextpage =$offset+$pagesize;
		$t_params->{'nextpage'}=$nextpage;
		$t_params->{'searchfield'}= $searchfield;
		$t_params->{'script_name'}= $script_name;
	}
} #---- END $OP eq DEFAULT

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
