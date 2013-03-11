package C4::Modelo::DB::AutoBase1;

use strict;
use C4::Context;
use base 'Rose::DB';
#    use C4::Context;
__PACKAGE__->use_private_registry;

    my $context = new C4::Context;
    
    my $driverDB= 'mysql';
    my $database;
    my $hostname;
    my $user;
    my $pass;

    my $use_socket;
    my $socket;
    
    my $dsn;
    
    my $DB=undef;
  
=item
 if (defined($context)){
    $driverDB = 'mysql';
    $database = $context->config('database');
    $hostname = $context->config('hostname');
    $user = $context->config('user');
    $pass = $context->config('pass');
}
=cut
 if (defined($context)){
    $driverDB = 'mysql';
	use CGI::Session;
	use C4::AR::Debug;

	my $session = CGI::Session->load();
    
=item
$context->config('userINTRA') y/o $context->config('userOPAC') pueden ser:
admin = usuario Aministrador (TODOS los permisos sobre la base)
dev = Desarrollador
intra = usuario comun de la INTRA
opac = ususario comun de OPAC (MENOR cant. de permisos sobre la base)
=cut
# FIXME cuando esten los permisos de la INTRA descomentar esto
	$user = $context->config('userOPAC');
	$pass = $context->config('passOPAC');
	if($session->param('type') eq 'intranet'){
		$user = $context->config('userINTRA');
		$pass = $context->config('passINTRA');
	}

#  $user = $context->config('user');
    
    $database = $context->config('database');
    
    $use_socket = $context->config('use_socket');
    
    if ($use_socket){
        $socket   = $context->config('socket');
        $dsn="dbi:mysql:dbname=".$database.";mysql_socket=".$socket;
    }
    else{
        $hostname = $context->config('hostname');
        $dsn="dbi:mysql:dbname=".$database.";host=".$hostname;
    }
    
}
        
__PACKAGE__->register_db
(
  connect_options => {RaiseError => 1},
  driver          => $driverDB,
  dsn             => $dsn,
  username        => $user,
  password        => $pass,
  #mysql_enable_utf8 => 1,
  post_connect_sql => ["SET NAMES utf8"], 
);


1;
