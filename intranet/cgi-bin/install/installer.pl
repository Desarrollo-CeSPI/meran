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
use strict;
use warnings;
use CGI::Session;
use Template;
use File::Basename;
use DBI;
use DBD::mysql;

sub persistConfig{
    my $session = shift;


# SE ARMA meran.conf 

    my @config_array = ();

    push (@config_array,"database=".$session->param('dbname'));
    push (@config_array,"hostname=".$session->param('dbaddress'));
    push (@config_array,"user=".$session->param('dbuser'));
    push (@config_array,"pass=".$session->param('dbpassword'));
    push (@config_array,"use_socket=".'1');
    push (@config_array,"socket=".'/var/run/mysqld/mysqld.sock');
    push (@config_array,"intranetdir=".'/usr/share/meran/intranet');
    push (@config_array,"opacdir=".'/usr/share/meran/opac');
    push (@config_array,"intrahtdocs=".'/usr/share/meran/intranet/htdocs/intranet-tmpl');
    push (@config_array,"opachtdocs=".'/usr/share/meran/opac/htdocs/opac-tmpl');
    push (@config_array,"meranlogdir=".'/var/log/meran/');
    push (@config_array,"version=".'0.5');
    push (@config_array,"httpduser=".'www-data');
    push (@config_array,"locale=".'/usr/share/meran/intranet/locale/');
    push (@config_array,"defaultLang=".'es_ES');
    push (@config_array,"debug=".'128');
    push (@config_array,"debug_file=".'/var/log/meran/debug_file.txt');
    push (@config_array,"userAdmin=".'userAdmin');
    push (@config_array,"passAdmin=".'kohaadmin');
    push (@config_array,"userOPAC=".'userOPAC');
    push (@config_array,"passOPAC=".'opac');
    push (@config_array,"userINTRA=".'userINTRA');
    push (@config_array,"passINTRA=".'intra');
    push (@config_array,"userDevelop=".'userDevelop');
    push (@config_array,"passDevelop=".'dev');
    push (@config_array,"charset=".'utf-8');
    push (@config_array,"tema=".'default');
    push (@config_array,"temas=".'/intranet-tmpl/temas');
    push (@config_array,"temasOPAC=".'/opac-tmpl/temas');
    push (@config_array,"sphinx_conf=".'/usr/share/meran/bin/etc/sphinx.conf');
    push (@config_array,"includes_general=".'/usr/share/meran/includes/');
    push (@config_array,"token=".'0');
    push (@config_array,"plainPassword=".'0');
    push (@config_array,"agregarDesdeLDAP=".'1');
    push (@config_array,"url_prefix=".'/meran');
    push (@config_array,"picturesdir=".'/usr/share/meran/intranet/htdocs/uploads/pictures');
    push (@config_array,"picturesdir_opac=".'/usr/share/meran/intranet/htdocs/uploads/pictures-opac');
    push (@config_array,"reports_dir=".'/usr/share/meran/intranet/htdocs/uploads/reports');
    push (@config_array,"covers=".'/usr/share/meran/intranet/htdocs/uploads/covers');
    push (@config_array,"edocsdir=".'/usr/share/meran/intranet/htdocs/private-uploads/edocs');
    push (@config_array,"importsdir=".'/usr/share/meran/intranet/htdocs/private-uploads/imports');
    push (@config_array,"novedadesOpacPath=".'/usr/share/meran/intranet/htdocs/uploads/novedades');
    push (@config_array,"logosOpacPath=".'/usr/share/meran/opac/htdocs/logos');
    push (@config_array,"portadasNivel2Path=".'/usr/share/meran/intranet/htdocs/uploads/covers-added');
    push (@config_array,"logosIntraPath=".'/usr/share/meran/intranet/htdocs/private-uploads/logos');



    open (MERAN_CONF, '>/etc/meran/meran.conf');


    foreach my $config (@config_array){
        print MERAN_CONF "$config\n";
    }

    close (MERAN_CONF);


#SE AGREGA EL USUARIO ADMIN


}

sub checkDB{
    my $params = shift;
    my $session = shift;

    # CONFIG VARIABLES
    my $platform    = "mysql";
    my $database    = $params->{'dbname'};
    my $host        = $params->{'dbaddress'};
    my $port        = "3306";
    my $user        = $params->{'dbuser'};
    my $pw          = $params->{'dbpassword'};

    #DATA SOURCE NAME
    my $dsn = "dbi:mysql:$database:$host:3306";
    my $dbstore;
    # PERL DBI CONNECT (RENAMED HANDLE)
    if ($dbstore = DBI->connect($dsn, $user, $pw)){

        $session->param('dbname',$database);
        $session->param('dbuser',$user);
        $session->param('dbpassword',$pw);
        $session->param('dbaddress',$host);
        $session->flush();

        return 1;
    }else{
        return $DBI::errstr;    
    }
}

sub checkDependencies{



    my @dep = ();

    if (scalar(@dep)){
        return \@dep;
    }else{
        return 0;
    }

}



my $path = dirname(__FILE__);
my $query= CGI->new();
my $params = $query->Vars;
my $file;
my $vars;

my $template = Template->new({  ABSOLUTE    => 1,
                                INCLUDE_PATH    => [
                                                    $path.'/templates/',
                                            ],
                             });

my $session = CGI::Session->load() || CGI::Session->new(undef,undef, undef);

my $action  = $params->{'action'} || 'default';


if ($action eq 'base'){
    $file = 'base.tmpl';
}elsif($action eq 'checkbase'){
    $file = 'base.tmpl';
    my $msj = checkDB($params,$session);    
    if ($msj != 1){
        $vars->{'mensaje'} = $msj;
        $vars->{'alert_class'} = 'alert-error';
    }else{
        $vars->{'mensaje'} = "La conexi&oacute;n con la base de datos se ha realizado correctamente.";
        $vars->{'alert_class'} = 'alert-success';    
        $vars->{'next'} = 1;
    }

    $vars->{'dbname'}       = $session->param('dbname');
    $vars->{'dbpassword'}   = $session->param('dbpassword');
    $vars->{'dbaddress'}    = $session->param('dbaddress');
    $vars->{'dbuser'}       = $session->param('dbuser');

}elsif($action eq 'nextbase'){
    my $msj = checkDB($params,$session);    
    if ($msj != 1){
        $file = 'base.tmpl';
        $vars->{'mensaje'}      = $msj;
        $vars->{'alert_class'}  = 'alert-error';
        $vars->{'dbname'}       = $params->{'dbname'};
        $vars->{'dbpassword'}   = $params->{'dbpassword'};
        $vars->{'dbaddress'}    = $params->{'dbaddress'};
        $vars->{'dbuser'}       = $params->{'dbuser'};
    }else{
        $file = 'uiconfig.tmpl';
    }
}elsif($action eq 'uiconfig'){
    $session->param('uiname',$params->{'uiname'});
    $session->param('uicode',$params->{'uicode'});
    $session->flush();


    $file = 'userconfig.tmpl';

}elsif($action eq 'adduser'){
    $session->param('sysuser',$params->{'sysuser'});
    $session->param('sysuserpassword',$params->{'sysuserpassword'});
    $session->flush();


    $vars->{'dbname'}           = $session->param('dbname');
    $vars->{'dbaddress'}        = $session->param('dbaddress');
    $vars->{'dbuser'}           = $session->param('dbuser');
    $vars->{'dbpassword'}       = $session->param('dbpassword');
    $vars->{'uiname'}           = $session->param('uiname');
    $vars->{'uicode'}           = $session->param('uicode');
    $vars->{'sysuser'}          = $session->param('sysuser');
    $vars->{'sysuserpassword'}  = $session->param('sysuserpassword');

    $file = 'finalstage.tmpl';
}elsif($action eq 'start'){
    my $msj = checkDB($params,$session);    
    if ($msj != 1){
        $file = 'base.tmpl';
        $vars->{'mensaje'} = $msj;
        $vars->{'alert_class'} = 'alert-error';
        $vars->{'dbname'} = $params->{'dbname'};
        $vars->{'dbpassword'} = $params->{'dbpassword'};
        $vars->{'dbaddress'} = $params->{'dbaddress'};
        $vars->{'dbuser'} = $params->{'dbuser'};
    }else{
        persistConfig($session);

    }
}else{
    $file = 'index.tmpl';

    if (checkDependencies()){
        $vars->{'dependencies_not_satisfied'} = checkDependencies();

        $vars->{'mensaje'} = "Su sistema no cumple con los requisitos para que Meran pueda funcionar.";
        $vars->{'alert_class'} = 'alert-error';
    }

}


my $cookie = new CGI::Cookie(  
                                -secure     => 1, 
                                -httponly   => 1, 
                                -name       =>$session->name, 
                                -value      =>$session->id, 
                                -expires    => '+' .$session->expire. 's', 
                            );
            

print $query->header(   -cookie=>$cookie, 
                        -type=>'text/html', 
                         charset => C4::Context->config("charset")||'UTF-8', 
                         "Cache-control: public",
                     );


$vars->{'session_id'} = $session->id();

$template->process($path.'/templates/'.$file, $vars)
    || die "Template process failed: ", $template->error(), "\n";

1;