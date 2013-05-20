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
use CGI;
use C4::AR::Auth;
use C4::Output;

my $input = new CGI;

my ($template, $session, $t_params) = get_template_and_user({
                        template_name   => "admin/global/ldapConfig.tmpl",
                        query           => $input,
                        type            => "intranet",
                        authnotrequired => 0,
                        flagsrequired   => {    ui => 'ANY', 
                                                tipo_documento => 'ANY', 
                                                accion => 'CONSULTA', 
                                                entorno => 'undefined'},
                        debug           => 1,
			    });

#preguntamos si esta guardando la informacion o mostrando el tmpl normalmente 
if($input->param('adding') == 1){

#    FIXME: pasar a una hash     
    
    C4::AR::Authldap::setVariableLdap('ldap_version',$input->param('version'));
    C4::AR::Authldap::setVariableLdap('ldap_server',$input->param('host_url'));
    C4::AR::Authldap::setVariableLdap('ldap_port',$input->param('host_port'));
    C4::AR::Authldap::setVariableLdap('ldap_type',$input->param('host_type'));
    C4::AR::Authldap::setVariableLdap('ldap_user_prefijo',$input->param('user_prefijo'));
    C4::AR::Authldap::setVariableLdap('ldap_prefijo_base',$input->param('prefijo_base'));
    C4::AR::Authldap::setVariableLdap('ldap_agregar_user',$input->param('agregar_user_ldap'));    
    C4::AR::Authldap::setVariableLdap('ldap_encoding',$input->param('ldapencoding'));
    C4::AR::Authldap::setVariableLdap('ldap_bind_dn',$input->param('bind_dn'));
    C4::AR::Authldap::setVariableLdap('ldap_bind_pw',$input->param('bind_pw'));
    C4::AR::Authldap::setVariableLdap('ldap_user_type',$input->param('user_type'));
    C4::AR::Authldap::setVariableLdap('ldap_contexts',$input->param('contexts'));
    C4::AR::Authldap::setVariableLdap('ldap_search_sub',$input->param('search_sub'));
    C4::AR::Authldap::setVariableLdap('ldap_opt_deref',$input->param('opt_deref'));
    C4::AR::Authldap::setVariableLdap('ldap_user_attribute',$input->param('user_attribute'));
    C4::AR::Authldap::setVariableLdap('ldap_memberattribute',$input->param('memberattribute'));
    C4::AR::Authldap::setVariableLdap('ldap_memberattribute_isdn',$input->param('memberattribute_isdn'));
    C4::AR::Authldap::setVariableLdap('ldap_objectclass',$input->param('objectclass'));
    C4::AR::Authldap::setVariableLdap('ldap_passtype',$input->param('passtype'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_firstnames',$input->param('lockconfig_field_map_firstnames'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_firstname',$input->param('lockconfig_field_updatelocal_firstname'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_firstname',$input->param('lockconfig_field_updateremote_firstname'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_firstname',$input->param('lockconfig_field_lock_firstname'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_lastname',$input->param('lockconfig_field_map_lastname'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_lastname',$input->param('lockconfig_field_updatelocal_lastname'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_lastname',$input->param('lockconfig_field_updateremote_lastname'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_lastname',$input->param('lockconfig_field_lock_lastname'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_email',$input->param('lockconfig_field_map_email'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_email',$input->param('lockconfig_field_updatelocal_email'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_email',$input->param('lockconfig_field_updateremote_email'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_email',$input->param('lockconfig_field_lock_email'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_city',$input->param('lockconfig_field_map_city'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_city',$input->param('lockconfig_field_updatelocal_city'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_city',$input->param('lockconfig_field_updateremote_city'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_city',$input->param('lockconfig_field_lock_city'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_country',$input->param('lockconfig_field_map_country'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_country',$input->param('lockconfig_field_updatelocal_country'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_country',$input->param('lockconfig_field_updateremote_country'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_country',$input->param('lockconfig_field_lock_country'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_lang',$input->param('lockconfig_field_map_lang'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_lang',$input->param('lockconfig_field_updatelocal_lang'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_lang',$input->param('lockconfig_field_updateremote_lang'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_lang',$input->param('lockconfig_field_lock_lang'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_description',$input->param('lockconfig_field_map_description'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_description',$input->param('lockconfig_field_updatelocal_description'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_description',$input->param('lockconfig_field_updateremote_description'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_description',$input->param('lockconfig_field_lock_description'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_url',$input->param('lockconfig_field_map_url'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_url',$input->param('lockconfig_field_updatelocal_url'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_url',$input->param('lockconfig_field_updateremote_url'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_url',$input->param('lockconfig_field_lock_url'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_idnumber',$input->param('lockconfig_field_map_idnumber'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_idnumber',$input->param('lockconfig_field_updatelocal_idnumber'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_idnumber',$input->param('lockconfig_field_updateremote_idnumber'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_idnumber',$input->param('lockconfig_field_lock_idnumber'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_institution',$input->param('lockconfig_field_map_institution'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_institution',$input->param('lockconfig_field_updatelocal_institution'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_institution',$input->param('lockconfig_field_updateremote_institution'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_institution',$input->param('lockconfig_field_lock_institution'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_departament',$input->param('lockconfig_field_map_departament'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_departament',$input->param('lockconfig_field_updatelocal_departament'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_departament',$input->param('lockconfig_field_updateremote_departament'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_departament',$input->param('lockconfig_field_lock_departament'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_phone1',$input->param('lockconfig_field_map_phone1'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_phone1',$input->param('lockconfig_field_updatelocal_phone1'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_phone1',$input->param('lockconfig_field_updateremote_phone1'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_phone1',$input->param('lockconfig_field_lock_phone1'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_phone2',$input->param('lockconfig_field_map_phone2'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_phone2',$input->param('lockconfig_field_updatelocal_phone2'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_phone2',$input->param('lockconfig_field_updateremote_phone2'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_phone2',$input->param('lockconfig_field_lock_phone2'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_map_adress',$input->param('lockconfig_field_map_adress'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updatelocal_adress',$input->param('lockconfig_field_updatelocal_adress'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_updateremote_adress',$input->param('lockconfig_field_updateremote_adress'));
    C4::AR::Authldap::setVariableLdap('ldap_lockconfig_field_lock_adress',$input->param('lockconfig_field_lock_adress'));
    $t_params->{'mensaje'} = "Las preferencias de LDAP se modificaron con exito";
}
# mostramos el template cargando los datos de configuracion ldap desde la db
# lo hacemos siempre asi cuando se guardan los cambios se reflejan en el template tambien
my $variables_ldap_hash             = C4::AR::Authldap::getLdapPreferences();
my %options_hash;
$options_hash{'name'}               = "lockconfig_field_map_firstnames";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_firstnames');
$t_params->{'lockconfig_field_map_firstnames'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_lastname";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_lastname');
$t_params->{'lockconfig_field_map_lastname'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_email";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_email');
C4::AR::Debug::debug("valor : ".C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_email'));
$t_params->{'lockconfig_field_map_email'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_city";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_city');
$t_params->{'lockconfig_field_map_city'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_country";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_country');
$t_params->{'lockconfig_field_map_country'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_lang";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_lang');
$t_params->{'lockconfig_field_map_lang'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_description";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_description');
$t_params->{'lockconfig_field_map_description'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_url";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_url');
$t_params->{'lockconfig_field_map_url'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_idnumber";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_idnumber');
$t_params->{'lockconfig_field_map_idnumber'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_institution";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_institution');
$t_params->{'lockconfig_field_map_institution'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_departament";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_departament');
$t_params->{'lockconfig_field_map_departament'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_phone1";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_phone1');
$t_params->{'lockconfig_field_map_phone1'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_phone2";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_phone2');
$t_params->{'lockconfig_field_map_phone2'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$options_hash{'name'}               = "lockconfig_field_map_adress";
$options_hash{'default'}            = C4::AR::Authldap::_getValorPreferenciaLdap('ldap_lockconfig_field_map_adress');
$t_params->{'lockconfig_field_map_adress'} = C4::AR::Utilidades::generarComboCamposPersona(\%options_hash);

$t_params->{'preferencias'}         = $variables_ldap_hash;
$t_params->{'page_sub_title'}       = C4::AR::Filtros::i18n("Configuraci&oacute;n Servidor LDAP");
C4::AR::Auth::output_html_with_http_headers($template, $t_params, $session);