package C4::AR::Sphinx;

use strict;

require Exporter;

use C4::Modelo::RefEstado;
use C4::Modelo::RefEstado::Manager;

use C4::Modelo::IndiceBusqueda;
use C4::Modelo::IndiceBusqueda::Manager;

use C4::Modelo::IndiceSugerencia;
use C4::Modelo::IndiceSugerencia::Manager;

use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;


use vars qw(@EXPORT @ISA);
@ISA = qw(Exporter);
@EXPORT = qw(
                generar_indice
                reindexar
                sphinx_start
);


=head2
    sub reindexar
=cut
sub reindexar{
    C4::AR::Debug::debug("Sphinx => reindexar => run_indexer => indexado => ".C4::AR::Preferencias::getValorPreferencia('indexado'));

#    if(C4::AR::Preferencias::getValorPreferencia('indexado')){
 #       C4::AR::Debug::debug("Sphinx => reindexar => EL INDICE SE ENCUENTRA ACTUALIZADO!!!!!!!");
  #  } else {
	C4::AR::Debug::debug("Sphinx => reindexar => EL INDICE SE ENCUENTRA DESACTUALIZADO!!!!!!!!");
	my $mgr = Sphinx::Manager->new({ config_file => C4::Context->config("sphinx_conf") , bindir => C4::Context->config("sphinx_bin_dir"), searchd_bin=> C4::Context->config("sphinx_bin_dir")});
        sphinx_start($mgr);
        my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
        my @args;
        push (@args, $index_to_use);
        push (@args, '--rotate');
        push (@args, '--quiet');
        $mgr->indexer_args(\@args);
        $mgr->run_indexer();
        C4::AR::Debug::debug("Sphinx => reindexar => --all --ro/tate => ");
        C4::AR::Debug::debug("Sphinx => reindexando indice =>". $index_to_use);
        C4::AR::Preferencias::setVariable('indexado', 1);
    # }

}

=head2
    sub sphinx_start
    verifica si sphinx esta levantado, sino lo está lo levanta, sino no hace nada
=cut
sub sphinx_start{
    my ($mgr)= @_;
    if (exists $ENV{MOD_PERL}){
        defined (my $kid = fork) or die "Cannot fork: $!\n";
        if ($kid) {
        # Parent runs this block
      } else {
          # Child runs this block
          # some code comes here
	 $mgr = $mgr || Sphinx::Manager->new({ config_file => C4::Context->config("sphinx_conf") , bindir => C4::Context->config("sphinx_bin_dir"), searchd_bin=> C4::Context->config("sphinx_bin_dir")});
          $mgr->debug(1);
          my $pids = $mgr->get_searchd_pid;
          if(scalar(@$pids) == 0){
               #C4::AR::Debug::debug("Utilidades => generar_indice => el sphinx esta caido!!!!!!! => ");
               #C4::AR::Debug::debug("El paath es ".$mgr->bindir);
              $mgr->start_searchd;
               #C4::AR::Debug::debug("Utilidades => generar_indice => levantó sphinx!!!!!!! => ");
          }
          CORE::exit(0);
      }
  }else{
	 $mgr = $mgr || Sphinx::Manager->new({ config_file => C4::Context->config("sphinx_conf") , bindir => C4::Context->config("sphinx_bin_dir"), searchd_bin=> C4::Context->config("sphinx_bin_dir")});
      $mgr->debug(1);
      #$mgr->searchd_sudo("sudo");
      my $pids = $mgr->get_searchd_pid;
      if(scalar(@$pids) == 0){
#           C4::AR::Debug::debug("Utilidades => generar_indice => el sphinx esta caido!!!!!!! => ");
          $mgr->start_searchd;
#           C4::AR::Debug::debug("Utilidades => generar_indice => levantó sphinx!!!!!!! => ");
      }
  }
}

sub limpiarIndice {

    my $indice_busqueda_array_ref = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda();

    foreach my $indice (@$indice_busqueda_array_ref){
        #si no existe más el nivel 1 se elimina la entrada del índice
        if (!$indice->nivel1){
            $indice->delete();
        }
    }
}


sub getIndiceBusquedaById {
    my ($id)   = @_;

    my @filtros;
    push(@filtros, ( id => { eq => $id }) );
    my $indice_busqueda_array_ref = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda( query => \@filtros );

    if(scalar(@$indice_busqueda_array_ref) > 0){
        return ($indice_busqueda_array_ref->[0]);
    } else {
        return 0;
    }
}

sub getAllIndiceBusqueda {

    my $indice_busqueda_array_ref = C4::Modelo::IndiceBusqueda::Manager->get_indice_busqueda();

    if(scalar(@$indice_busqueda_array_ref) > 0){
        return ($indice_busqueda_array_ref);
    } else {
        return 0;
    }
}

=head2
    sub generar_indice
=cut
sub generar_indice {
    my ($id1, $flag, $action)   = @_;

    $id1 = $id1 || 0;

    if ($flag eq "R_PARTIAL") {
        #Se va a modificar un único nivel 1
        C4::AR::Debug::debug("C4::AR::Sphinx::generar_indice => action ".$action);
        if ($action eq 'DELETE') {
            #se va a eliminar un registro en particular
             my $indice_busueda = C4::AR::Sphinx::getIndiceBusquedaById($id1);

             if($indice_busueda){
                 $indice_busueda->delete();
                 }

            }
        else{
            #se va a modificar un registro en particular
             my $nivel1 =  C4::AR::Nivel1::getNivel1FromId1($id1);
             if($nivel1){
                 eval{
                    $nivel1->generarIndice();
                }; #END eval

                if ($@){
                    C4::AR::Debug::debug("ERROR AL GENERAR EL INDICE EN EL REGISTRO: ". $id1." !!! ( ".$@." )");
                }
            }
        }
    }
    else{
        #Se van a reindexar varios niveles

        #Vaciamos el indice
        C4::AR::Sphinx::limpiarIndice();
        #Obtenemos todos los niveles 1
        my @filtros;
        if ($flag eq "R_ACUMULATIVE"){
            #Si no es R_FULL se hace a partir de un nivel hacia adelante
            push(@filtros, ( id => { ge => $id1 }) );
        }
        my $niveles1 = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1( query => \@filtros );

        foreach my $nivel1 (@$niveles1 ){
            eval{
                $nivel1->generarIndice();
            }; #END eval
            if ($@){
                C4::AR::Debug::debug("ERROR AL GENERAR EL INDICE EN EL REGISTRO: ". $nivel1->getId1." !!! ( ".$@." )");
                next;
            }
        } #END foreach

     } #END else

}
=pod

=back

=cut
sub limpiarIndiceSugerencias{
    my $indice_sugerencia_array_ref = C4::Modelo::IndiceSugerencia::Manager->get_indice_sugerencia();
    foreach my $indice (@$indice_sugerencia_array_ref){
            $indice->delete();
    }
}

sub generar_sugerencias {
  limpiarIndiceSugerencias();
  my $mgr = Sphinx::Manager->new({ config_file => C4::Context->config("sphinx_conf") , bindir => C4::Context->config("sphinx_bin_dir"), searchd_bin=> C4::Context->config("sphinx_bin_dir")});
  sphinx_start($mgr);
  my $index_to_use = C4::AR::Preferencias::getValorPreferencia("nombre_indice_sphinx") || 'test1';
  my @args;
  push (@args, $index_to_use);
  push (@args, '--buildstops');
  push (@args, '/tmp/index_tops.txt');
  push (@args, '100000');
  push (@args, '--buildfreqs');
  push (@args, '--quiet');
  $mgr->indexer_args(\@args);
  $mgr->run_indexer();
  
  if(open(TOPS,'/tmp/index_tops.txt')){
    while (my $top = <TOPS>) {
        my @datos = split ' ',$top;
        #se toman los que tengan alguna frecuencia mayor a la minima configurada al menos y que no sean solo números o tengan al menos 3 caracteres
        if(!($datos[0] =~ /^\d+$/)&&(length($datos[0]) ge 3)&&($datos[1] >= C4::AR::Preferencias::getValorPreferencia('ocurrencia_sugerencia_sphinx'))){          
          my $indice_sugerencia = C4::Modelo::IndiceSugerencia->new();
          $indice_sugerencia->setKeyword($datos[0]);
          $indice_sugerencia->setTrigrams(C4::AR::Busquedas::buildTrigrams($datos[0]));
          $indice_sugerencia->setFreq($datos[1]);
          $indice_sugerencia->save();
        }
    }
  }
}

END { }
1;

__END__
