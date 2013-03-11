#!/usr/bin/perl
use CGI;

use C4::AR::UploadFile;
use C4::AR::Utilidades;


my $input = new CGI;

my $socio= $input->param('userid');
my $filepath= $input->param('filepath');
my $msg_object= C4::AR::UploadFile::uploadPhoto($socio,$filepath);

print $input->redirect(C4::AR::Utilidades::getUrlPrefix()."/opac-user.pl?msg=".$msg_object{'codMsg'});
