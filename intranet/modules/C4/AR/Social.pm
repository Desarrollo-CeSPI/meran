package C4::AR::Social;

use strict;
require Exporter;
use C4::Context;
use Net::Twitter;
use C4::AR::Preferencias;
use WWW::Google::URLShortener;
use Net::Twitter::Role::OAuth;
use Scalar::Util 'blessed';
use WWW::Shorten::Bitly;


use vars qw(@EXPORT_OK @ISA);

@ISA=qw(Exporter);

@EXPORT_OK=qw(
          twitterConsumerKey
          twitterConsumerSecret
          twitterToken
          twitterTokenSecret
          connectTwitter
          sendPost
          twitterEnabled
);


sub shortenUrl{
          my ($id) = @_; 
          my $api_key = C4::AR::Preferencias::getValorPreferencia("google_shortener_api_key");
          my $novedad_url  = WWW::Google::URLShortener->new($api_key);
          my $link= $novedad_url->shorten_url("http://".$ENV{'SERVER_NAME'}.C4::AR::Utilidades::getUrlPrefix().'/ver_novedad.pl?id='.$id);

          return $link;
}


sub twitterEnabled{
    
    my $twitter_enabled= C4::AR::Preferencias::getValorPreferencia("twitter_enabled");
    
    return $twitter_enabled;
}

sub sendPost{
    my ($post) = @_;
    
    my $cant_caracteres= length($post);
    
    C4::AR::Debug::debug("POST TWITTER ---------------> ".$post);
    
    my $mensaje=C4::AR::Mensajes::create();
    my $result;
    
    if (twitterEnabled()){
                  my $nt= connectTwitter();

                  eval{
	                  $result = $nt->update($post);
	                  if ( my $err = $@ ) {
	                    C4::AR::Mensajes::add($mensaje, {'codMsg'=> 'SC001'.$err->isa('Net::Twitter::Error') , 'params' => []} ) ;
	                    C4::AR::Debug::debug("\n\n\n Twitter Error: ".$err->error." \n\n\n");
	                  } else {
	                    C4::AR::Mensajes::add($mensaje, {'codMsg'=> 'SC000' , 'params' => []} ) ;
	                  }
                  };
                  if ($@){
                  	my $err          = $@;
                  	my @err_array    = split(/. at /, $err);
                  	
                  	C4::AR::Mensajes::add($mensaje, {'codMsg'=> 'SC004' , 'params' => [@err_array[0]]} ) ;
                  }
                  
    } else {
        C4::AR::Mensajes::add($mensaje, {'codMsg'=> 'SC003' , 'params' => []} ) ;
    }


    return $mensaje;
}

sub twitterConsumerKey{
    my ($self) = shift;
    my $valor_consumer_key= C4::AR::Preferencias::getValorPreferencia("twitter_consumer_key");
    return $valor_consumer_key;
}

sub twitterConsumerSecret{
    my ($self) = shift;
    my $valor_consumer_secret= C4::AR::Preferencias::getValorPreferencia("twitter_consumer_secret");
    return $valor_consumer_secret;
}

sub twitterToken{
    my ($self) = shift;
    my $valor_token= C4::AR::Preferencias::getValorPreferencia("twitter_token");
    return $valor_token;
}

sub twitterTokenSecret{
    my ($self) = shift;
    my $valor_token_secret= C4::AR::Preferencias::getValorPreferencia("twitter_token_secret");
    return $valor_token_secret;
}

sub connectTwitter{
    my ($self) = shift;
    my $consumer_key= twitterConsumerKey();
    my $consumer_secret= twitterConsumerSecret();
    my $token= twitterToken();
    my $token_secret= twitterTokenSecret();


    my $nt = Net::Twitter->new(
        traits   => [qw/API::RESTv1_1/],
        consumer_key        => $consumer_key,
        consumer_secret     => $consumer_secret,
        access_token        => $token,
        access_token_secret => $token_secret,
        ssl                 => 1,  ## enable SSL! ##
    );
    
    return $nt;

}


END { }       # module clean-up code here (global destructor)

1;
__END__