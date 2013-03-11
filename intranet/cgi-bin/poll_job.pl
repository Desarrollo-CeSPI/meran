#!/usr/bin/perl
use strict;
require Exporter;
use C4::AR::Auth;
use CGI;
use JSON;
use C4::AR::BackgroundJob;
use Proc::Simple;
use C4::AR::Utilidades;

my $input = new CGI;
my $obj=$input->param('obj');
my $job;

$obj=C4::AR::Utilidades::from_json_ISO($obj);

my $jobID = $obj->{'jobID'};

eval {
	$job = C4::AR::BackgroundJob->fetch($jobID);
	C4::AR::Auth::printValue($job->progress);
};

if ($@){
	C4::AR::Auth::printValue("-1");
}


