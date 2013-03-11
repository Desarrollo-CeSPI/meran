#!/usr/bin/perl

# use strict;
use C4::AR::Auth;
use CGI;
use C4::AR::UploadFile;
use Spreadsheet::Read;
use Spreadsheet::ParseExcel;

 
my $input           = new CGI;
my $authnotrequired = 0;
my $obj             = $input->param('obj');
my $prov            = $obj->{'id_proveedor'}||"";
my $tipoAccion      = $obj->{'tipoAccion'}||"";
my $authnotrequired = 0;
my $presupuestos_dir= "/usr/share/meran/intranet/htdocs/intranet-tmpl/proveedores";

$obj                = C4::AR::Utilidades::from_json_ISO($obj);

($template, $session, $t_params) =  C4::AR::Auth::get_template_and_user ({
                      template_name     => '/adquisiciones/mostrarPresupuesto.tmpl',
                      query             => $input,
                      type              => "intranet",
                      authnotrequired   => 0,
                      flagsrequired     => {    ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                tipo_permiso => 'general',
                                                entorno => 'adq_intra'}, # FIXME
                });

my $filepath    = $input->param('planilla');
my $write_file  = $presupuestos_dir."/".$filepath;

my ($error,$codMsg,$message)    = &C4::AR::UploadFile::uploadFile($prov,$write_file,$filepath,$presupuestos_dir);
$t_params->{'page_sub_title'}   = C4::AR::Filtros::i18n("Presupuestos");

C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);
