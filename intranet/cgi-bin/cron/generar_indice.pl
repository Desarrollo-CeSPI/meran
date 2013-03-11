#!/usr/bin/perl
use C4::AR::Sphinx;
use C4::AR::CacheMeran;

	my $id1 = $ARGV[0] || '0'; #id1 del registro
	my $flag = $ARGV[1] || 'R_FULL'; #id1 del registro

	 my $tt1 = time();

	C4::AR::Sphinx::generar_indice($id1,$flag);
	 
	 my $end1 = time();
	 my $tardo1=($end1 - $tt1);
	 my $min= $tardo1/60;
	 my $hour= $min/60;
 
	use C4::AR::Preferencias;
	use C4::AR::Mail;

	my %mail;                    

	$mail{'mail_from'}      = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('mailFrom'));
	$mail{'mail_to'}        = Encode::decode_utf8(C4::AR::Preferencias::getValorPreferencia('KohaAdminEmailAddress'));  
	$mail{'mail_subject'}   = "Generar Indice"; 
	$mail{'mail_message'}   = "Termino de generar el indice!! \n Tardo ".$hour." horas.";

	C4::AR::Mail::send_mail(\%mail);
1;
