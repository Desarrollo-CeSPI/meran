package C4::AR::SphinxStarter;

=head1 NAME
  SphinxStarter -  Modulo para arrancar el Sphinx, dependiendo del Apache


=head1 SYNOPSIS

    use C4::AR::SphinxStarter;

    
=head1 DESCRIPTION

    Este módulo esta diseñado para funcionar sólo al inicio de Apache y que el sphinx 
    dependa exclusivamente de Meran, independientemente de si hay o no otra cosa 
    funcionando en el server.

=cut

use vars qw($VERSION);
$VERSION = 0.01;

use Sphinx::Manager;
use strict;
=over 12
=item C<sphinx_start>
        verifica si sphinx esta levantado, sino lo está lo levanta, sino no hace nada
=cut


sub sysdebug{
    my ($string) = @_;
    
    open(Z, ">>".C4::Context->config("debug_file"));
    print Z "[STARTING SEARCHD STATUS] ".$string." (".C4::Context->config("intranetdir").")\n";
    close(Z);    
}

sub sphinx_start{
    my ($mgr,$conf)= @_;
    my $context = new C4::Context($conf);
    my $hash= $context->{'config'};
    my $sphinx_conf= $hash->{'sphinx_conf'};
    my $sphinx_bin_dir= $hash->{'sphinx_bin_dir'};
    defined (my $kid = fork) or die "Cannot fork: $!\n";
    if ($kid) {
    # Parent runs this block

    } else {
        # Child runs this block
        # some code comes here
        $mgr = Sphinx::Manager->new({ config_file => $sphinx_conf ,
          bindir => $sphinx_bin_dir});
        $mgr->debug(1);
        my $pids = $mgr->get_searchd_pid;
        if(scalar(@$pids) == 0){
            $mgr->start_searchd;
            sysdebug("El proceso ".$mgr->get_searchd_pid->[0]." acaba de prender por primera vez el servicio");
}else{
            sysdebug("Ya existe otro proceso de searchd");
            foreach my  $value (@$pids) {
                my $string = `ps aux | grep $value`;
                sysdebug("searchd actual: ".$string);
            }
        }

        CORE::exit(0);
    }
}

#BEGIN
#{
 # sphinx_start();
#};



END { }
1;

__END__
