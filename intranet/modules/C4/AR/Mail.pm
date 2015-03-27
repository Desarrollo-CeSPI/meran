package C4::AR::Mail;

#Este modulo provee funcionalidades varias para el mail
#Escrito el 03/05/2010


use strict;
require Exporter;
use Mail::Sendmail 0.75;
use C4::AR::Debug;
use Net::SMTP;
use Net::SMTP::SSL;
use Net::SMTP::TLS;
use C4::AR::Preferencias;
use C4::Output;
use Digest::MD5 qw(md5_hex);

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw( send_mail );


# TODO pasar a preferencias????

use constant SMTP_TIME_OUT  => 5;
use constant DEBUG          => 1;
use MIME::Lite::TT::HTML;

sub send_mail_TLS {
    my ($mail_hash_ref) = @_;


    my $mailer          = 0;
    my $ok              = 0;
    my $msg_error       = 0;
    my $html_mail       = $mail_hash_ref->{'html_content'};
    my $mail_from       = $mail_hash_ref->{'mail_from'};
    my $mail_to         = $mail_hash_ref->{'mail_to'};
    my $mail_data       = $mail_hash_ref->{'mail_message'};
    
    eval{
        $mailer = new Net::SMTP::TLS (  
                                            $mail_hash_ref->{'smtp_server'},  
                                            Hello       => $mail_hash_ref->{'smtp_server'},  
                                            Port        => $mail_hash_ref->{'smtp_port'},  
                                            User        => $mail_hash_ref->{'smtp_user'},  
                                            Password    => $mail_hash_ref->{'smtp_pass'},
                                            Timeout     => SMTP_TIME_OUT,    
                                            Debug       => DEBUG,
                                    );
    

        if ( not $mailer ) {
            $ok = 0;
            $msg_error = "Mail => send_mail_TLS => No se pudo conectar con el servidor: ".$mail_hash_ref->{'smtp_server'};
            C4::AR::Debug::debug($msg_error);  
        } else {
            $mailer->mail($mail_from);
            $mailer->to($mail_to);
            $mailer->data();  

            if ($html_mail){
                $mailer->datasend($mail_data->as_string());
            }else{
            	$mailer->datasend($mail_data);
            }

            $mailer->dataend;  
            $mailer->quit;
            $ok = 1;
        }  
    };

    if($@){
        $msg_error = "Mail => send_mail_TLS => error => $@";
        C4::AR::Debug::debug($msg_error);
        $ok = 0;
    }

    C4::AR::Debug::debug("Mail => send_mail_TLS => return => ".$ok);

    return ($ok, $msg_error);
}


sub send_mail_SSL {
    my ($mail_hash_ref) = @_;


    my $mailer          = 0;
    my $ok              = 0;
    my $msg_error       = 0;
    my $html_mail       = $mail_hash_ref->{'html_content'};
    my $mail_from       = $mail_hash_ref->{'mail_from'};
    my $mail_to         = $mail_hash_ref->{'mail_to'};
    my $mail_data       = $mail_hash_ref->{'mail_message'};

    eval {
        $mailer = new Net::SMTP::SSL (  
                                            $mail_hash_ref->{'smtp_server'},  
                                            Hello       => $mail_hash_ref->{'smtp_server'},  
                                            Port        => $mail_hash_ref->{'smtp_port'},  
                                            User        => $mail_hash_ref->{'smtp_user'},  
                                            Password    => $mail_hash_ref->{'smtp_pass'},
                                            Timeout     => SMTP_TIME_OUT,
                                            Debug       => DEBUG
                                    );
    
        if ( not $mailer ) {
            $ok = 0;
            $msg_error = "Mail => send_mail_SSL => No se pudo conectar con el servidor: ".$mail_hash_ref->{'smtp_server'};
            C4::AR::Debug::debug($msg_error);  
        } else {
            $mailer->mail($mail_from);
            $mailer->to($mail_to);
            $mailer->data();  

            if ($html_mail){
                $mailer->datasend($mail_data->as_string());
            }else{
                $mailer->datasend($mail_data);
            }

            $mailer->dataend;  
            $mailer->quit;
            $ok = 1;
        }  
    };

    if($@){
        $msg_error = "Mail => send_mail_SSL => error => $@";
        C4::AR::Debug::debug($msg_error);
    }

    C4::AR::Debug::debug("Mail => send_mail_SSL => return => ".$ok);

    return ($ok, $msg_error);
}


sub send_mail_PLANO {
    my ($mail_hash_ref) = @_;


    my $mailer          = 0;
    my $ok              = 0;
    my $msg_error       = 0;
    my $html_mail       = $mail_hash_ref->{'html_content'};
    my $mail_from       = $mail_hash_ref->{'mail_from'};
    my $mail_to         = $mail_hash_ref->{'mail_to'};
    my $mail_data       = $mail_hash_ref->{'mail_message'};

    eval {
        $mailer = new Net::SMTP (  
                                            $mail_hash_ref->{'smtp_server'},  
                                            Hello       => $mail_hash_ref->{'smtp_server'},  
                                            Port        => $mail_hash_ref->{'smtp_port'},  
                                            User        => $mail_hash_ref->{'smtp_user'},  
                                            Password    => $mail_hash_ref->{'smtp_pass'},
                                            Timeout     => SMTP_TIME_OUT,
                                            Debug       => DEBUG
                                    );
    
        if ( not $mailer ) {
            $ok = 0;
            $msg_error = "Mail => send_mail_PLANO => No se pudo conectar con el servidor: ".$mail_hash_ref->{'smtp_server'};
            C4::AR::Debug::debug($msg_error);  
        } else {
            $ok = $mailer->mail($mail_from);
            if (!$ok) {
                $msg_error = " Error en mail_from: ".$mail_hash_ref->{'mail_from'};
                return ($ok, $msg_error);
            }

            $ok = $mailer->recipient($mail_to);
            if (!$ok) {
                $msg_error = " Error en mail_to: ".$mail_hash_ref->{'mail_to'};
                return ($ok, $msg_error);
            }

            $mailer->to($mail_to);
            $mailer->data();  

            if ($html_mail){
                $mailer->datasend($mail_data->as_string());
            }else{
                $mailer->datasend($mail_data);
            }

            $mailer->quit;
        }  
    };

    if($@){
        $msg_error = "Mail => send_mail_PLANO => error => $@";
        C4::AR::Debug::debug($msg_error);
    }

    C4::AR::Debug::debug("Mail => send_mail_PLANO => return => ".$ok);

    return ($ok, $msg_error);
}

sub send_mail_SENDMAIL {
    my ($mail_hash_ref) = @_;

    C4::AR::Debug::debug("Mail => send_mail_SENDMAIL => mail_from:       ".$mail_hash_ref->{'mail_from'});
    C4::AR::Debug::debug("Mail => send_mail_SENDMAIL => mail_to:         ".$mail_hash_ref->{'mail_to'});
    C4::AR::Debug::debug("Mail => send_mail_SENDMAIL => mail_subject:    ".$mail_hash_ref->{'mail_subject'});
    C4::AR::Debug::debug("Mail => send_mail_SENDMAIL => mail_message:    ".$mail_hash_ref->{'mail_message'});

    my $mailer = 0;
    my $ok;
    my $msg_error;

    eval {

        if($mail_hash_ref->{'smtp_server_sendmail'}) {
            #se envia el mail con SENDMAIL
            my %mail = (    To      => $mail_hash_ref->{'mail_to'},
                            From    => $mail_hash_ref->{'mail_from'},
                            Subject => $mail_hash_ref->{'mail_subject'},
                            Message => $mail_hash_ref->{'mail_message'}
                        );

            if ($mail_hash_ref->{'mail_to'} && $mail_hash_ref->{'mail_from'} ){

                if(sendmail(%mail)) {
                    C4::AR::Debug::debug("Mail => send_mail_SENDMAIL => SE ENVIO MAIL A: ".$mail_hash_ref->{'mail_to'});
                    $ok = 1;
                } else {
                    C4::AR::Debug::debug("Mail => send_mail_SENDMAIL => FALLO EL SENDMAIL !!");
                    $ok = 0;
                }
            }
        }
    };

    if($@){
        $msg_error = "Mail => send_mail_SENDMAIL => error => $@";
        C4::AR::Debug::debug($msg_error);
    }

    C4::AR::Debug::debug("Mail => send_mail_SENDMAIL => return => ".$ok);

    return ($ok, $msg_error);
}

sub send_mail_TEST {
    my ($mail_to) = @_;

    my %mail;
    my $ok          = 0;
    my $msg_error   = "Error inesperado";

    $mail{'mail_from'}              =   Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('mailFrom'));
    $mail{'mail_to'}                = $mail_to;
    $mail{'mail_subject'}           = "Prueba de configuración de mail";
    $mail{'mail_message'}           = "Esta es una prueba de configuración del mail";

    $mail{'page_title'} = C4::AR::Filtros::i18n("Titulo header del mail");
    $mail{'link'} = "google.com";

    eval {

        ($ok, $msg_error)           = C4::AR::Mail::send_mail(\%mail);

        if($ok){    
            $msg_error              = Encode::decode('utf8',"Se envió el mail a la cuenta (".$mail_to.")");
        }

    };


    return ($ok, $msg_error);
}

=item
    sub send_mail

    Envia un mail a $mail_to con subject $mail_subject, mensaje $mail_message

@params
    $info_smtp_hash_ref => para enviar datos para testear la configuracion

    $mail_hash_ref->{'smtp_server'}     =>  servidor SMTP al que se va a conectar
    $mail_hash_ref->{'smtp_metodo'}     =>  metodo de encriptacion para autenticacion SSL/TLS/PLANO
    $mail_hash_ref->{'smtp_port'}       =>  puerto del servidor SMTP al que se va a conectar
    $mail_hash_ref->{'smtp_user'}       =>  usuario del mail en el servidor SMTP al cual se va a conectar
    $mail_hash_ref->{'smtp_pass'}       =>  password del usuario del mail en el servidor SMTP al cual se va a conectar
    $mail_hash_ref->{'mail_from'}       =>  from del mail a enviar (de quien es el mail)
    $mail_hash_ref->{'mail_to'})        =>  to del mail a enviar (a quien va dirigido)
    $mail_hash_ref->{'mail_subject'}    =>  asunto del mail
    $mail_hash_ref->{'mail_message'}    =>  mensaje del mail

=cut
sub send_mail {
    my ($info_smtp_hash_ref) = @_;

    C4::AR::Debug::debug("Mail => send_mail");


    my $mailer          = 0;
    my $ok              = 0;
    my $msg_error;

    # Servidores SMTP
    # yahoo     => smtp.mail.yahoo.com.ar 465 SSL
    # gmail     => smtp.gmail.com 587 TLS
    # hotmail   => smtp.live.com 25 TLS
    # hotmail   => smtp.live.com 587 SSL
    # linti     => mail.linti.unlp.edu.ar 25 TLS
    # linti     => mail.linti.unlp.edu.ar 993 SSL

    my @preferencias = ('smtp_server', 'smtp_metodo', 'port_mail', 'username_mail', 'password_mail', 'smtp_server_sendmail');

    my ($existe, $variable) = C4::AR::Preferencias::verificar_preferencias(\@preferencias);

    if (!$existe) { 
      $msg_error   = "NO EXISTE la preferencia ".$variable;
	C4::AR::Debug::debug("Mail => send_mail  ERROR=>".$msg_error);
      return (0, $msg_error);
    }

    $info_smtp_hash_ref->{'smtp_server'}           = C4::AR::Preferencias::getValorPreferencia("smtp_server");
    $info_smtp_hash_ref->{'smtp_metodo'}           = C4::AR::Preferencias::getValorPreferencia("smtp_metodo");
    $info_smtp_hash_ref->{'smtp_port'}             = C4::AR::Preferencias::getValorPreferencia("port_mail");
    $info_smtp_hash_ref->{'smtp_user'}             = C4::AR::Preferencias::getValorPreferencia("username_mail");
    $info_smtp_hash_ref->{'smtp_pass'}             = C4::AR::Preferencias::getValorPreferencia("password_mail");
    $info_smtp_hash_ref->{'smtp_server_sendmail'}  = C4::AR::Preferencias::getValorPreferencia("smtp_server_sendmail");

    my ($template, $t_params) = C4::Output::gettemplate("includes/opac-mail.tmpl", "OPAC", 1);

    $t_params->{'mail_content'} = Encode::decode_utf8($info_smtp_hash_ref->{'mail_message'});
    $t_params->{'page_title'}   = $info_smtp_hash_ref->{'page_title'};
    $t_params->{'link'}         = $info_smtp_hash_ref->{'link'};
    
    #nombre de la UI
    my $ui                      = C4::AR::Referencias::obtenerDefaultUI() || C4::AR::Referencias::getFirstDefaultUI();
    my $nombre_ui               = Encode::decode_utf8($ui->getNombre());
    $t_params->{'nombre_ui'}    = $nombre_ui;
    
    #link de la pagina web
    my $server_name             = C4::AR::Preferencias::getValorPreferencia('serverName');
    $server_name                = 'http://' . $server_name;
    $t_params->{'server_name'}  = $server_name;
    
    my $out= C4::AR::Auth::get_html_content($template, $t_params);
    
    $info_smtp_hash_ref->{'html_content'}           = 1;

    my $unique_hash = md5_hex(localtime());
    my $mail_file   = "/tmp/mail.html.".$unique_hash;

    open FILE, ">".$mail_file or die $!;
    print FILE $out;
    close FILE;

    my $mail_from       = $info_smtp_hash_ref->{'mail_from'};
    my $mail_to         = $info_smtp_hash_ref->{'mail_to'};
    my $mail_subject    = $info_smtp_hash_ref->{'mail_subject'};
    
        
    my $msg = MIME::Lite::TT::HTML->new(
         From         => $mail_from,
         To           => $mail_to,
         Subject      => $mail_subject,
         Template     => {
              html    => $mail_file,
         },
         TmplOptions => {ABSOLUTE => 1,},
         Encoding     =>  '8bit',
         Charset      => 'utf8',
    );

    $info_smtp_hash_ref->{'mail_message'} = $msg;

    if ($info_smtp_hash_ref->{'smtp_server_sendmail'}) {
        #se envia el mail con SENDMAIL
        ($ok, $msg_error) =  send_mail_SENDMAIL($info_smtp_hash_ref);
    } else {
        if ($info_smtp_hash_ref->{'smtp_metodo'} eq "TLS") {
            ($ok, $msg_error) =  send_mail_TLS($info_smtp_hash_ref);
        }elsif ($info_smtp_hash_ref->{'smtp_metodo'} eq "SSL") {
            ($ok, $msg_error) =  send_mail_SSL($info_smtp_hash_ref);
        }elsif ($info_smtp_hash_ref->{'smtp_metodo'} eq "PLANO") {
            ($ok, $msg_error) =  send_mail_PLANO($info_smtp_hash_ref);
        }#END if($mail_metodo eq "PLANO")
    }

    unlink($mail_file);
    
    return ($ok, $msg_error);
}


END { }       # module clean-up code here (global destructor)

1;
__END__

