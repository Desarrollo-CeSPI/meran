#!/usr/bin/perl

use utf8;
use lib "/usr/share/meran/dev/intranet/modules/";
use C4::Context;



  sub aplicarSQL {
    my ($sql)=@_;

    my $PASSWD = C4::Context->config("pass");
    my $USER = C4::Context->config("user");
    my $BASE = C4::Context->config("database");

    system("mysql -f --default-character-set=utf8 $BASE -u$USER -p$PASSWD < $sql ") == 0 or print "Fallo el sql ".$sql." \n";

    }



    sub buscarReferenciaColaborador
    { my ($tipo) = @_;
        #No existe aún la tabla de referencias y el campo en Koha no está normalizado!
        #Se recata los que se pueden
        if($tipo eq 'rev.') { return 'rev';}
        if(($tipo eq 'ed.')||($tipo eq 'ed')||($tipo eq 'Editor')) { return 'edt';}
        if(($tipo eq 'dir.')||($tipo eq 'dir. y  re')||($tipo eq 'director')) { return 'drt';}
        if($tipo eq 'tr.') { return 'trl';}
        if($tipo eq 'pref.') { return 'prf';}
        if($tipo eq 'il.')   { return 'ill';}
        if(($tipo eq 'com.')||($tipo eq 'comp.')) { return 'com';}
        #indefinido!!
        return 'oth';
    }
    
    
print "Agregando tabla colaboradores \n";
aplicarSQL("../scripts/reparar_colaboradores_migracion_conjunta.sql");

my $dbh = C4::Context->dbh;


use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;
use MARC::Record;

my $n1s = C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1();
my $cant=0;
my $cant_colabs=0;

foreach my $n1 (@$n1s){

   my $marc_record_base    = MARC::Record->new_from_usmarc($n1->getMarcRecord());
   my $registro_erroneo=0;
   my $log="";
   my @campo700= $marc_record_base->field("700");
   
      # Elimino todos los colaboradores
      foreach my $f700 (@campo700){
          if(($f700->subfield('e')) || ($f700->subfield('a') eq 'cat_autor@')){
              #si tiene función lo elimino, sino es un autor secundario
                $marc_record_base->delete_fields($f700);
                $registro_erroneo=1;
          }
      }
      
   if($registro_erroneo){
        $log="Eliminando colaboradores del registro id1=".$n1->getId1." => " .$n1->getTitulo." (".scalar(@campo700)." colaboradores) ";
        #Busco de nuevo los colaboradores de la tabla de KOHA colaboradores
        my $colaboradores=$dbh->prepare("SELECT * FROM colaboradores where biblionumber= ?;");
        $colaboradores->execute($n1->getId1);
        
        while (my $colabs=$colaboradores->fetchrow_hashref ) {
            
          my $colaborador='cat_autor@'.$colabs->{'idColaborador'};
          print "COLABORADOR NUEVO!!! ".$colaborador."\n";
          
         #Y la referencia?? =>> 700 e
          my $tipo_colaborador= buscarReferenciaColaborador($colabs->{'tipo'});
          if ($tipo_colaborador){
            print "REFERENCIA COLABORADOR!!! ".'ref_colaborador@'.$tipo_colaborador."\n";
          }
            
            my $field700 = MARC::Field->new('700','','','a' => $colaborador);
            $field700->add_subfields( 'e' => 'ref_colaborador@'.$tipo_colaborador );

            $marc_record_base->append_fields($field700);
            $cant_colabs=$cant_colabs+1;
        }
        
        $colaboradores->finish();
        
        $cant =$cant+1;
        print $log."\n";
        print $marc_record_base->as_formatted()."\n";
        
        $n1->setMarcRecord($marc_record_base->as_usmarc());
        $n1->save();
       }
}

print "Eliminando tabla colaboradores \n";
my $dropear=$dbh->prepare("DROP TABLE IF EXISTS `colaboradores`;");
   $dropear->execute();
    
    
print "Procesados ".$cant_colabs." colaboradores";
print "Errores en ".$cant." registros";
1;
