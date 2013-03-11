#!/usr/bin/perl
use Date::Manip;
use C4::Date;
use C4::AR::Catalogacion;
use C4::AR::Utilidades;
use C4::AR::Reservas;
use C4::AR::Nivel1;
use C4::AR::Nivel2;
use C4::AR::Nivel3;
use C4::AR::PortadasRegistros;
use C4::AR::Busquedas;
use MARC::Record;

my $dbh = C4::Context->dbh;
my $query=" SELECT id1 FROM cat_nivel1";
my $sth=$dbh->prepare($query);
$sth->execute();

my $id1_nuevo;
my $id2_nuevo;

while (my $id1 = $sth->fetchrow){
    C4::AR::Debug::debug('ID1 '.$id1);
    my @result;
    my ($nivel1_object) = C4::AR::Nivel1::getNivel1FromId1($id1);
    if($nivel1_object ne 0){
        C4::AR::Debug::debug('recupero el nivel1');
        my $marc_array_nivel1 = $nivel1_object->nivel1CompletoToMARC;

        my $marc_record = generar_marc_record(@$marc_array_nivel1);
      
        my $query1 = "INSERT INTO cat_registro_marc_n1 (marc_record) VALUES (?) ";
        my $sth1 = $dbh->prepare($query1);
        $sth1->execute($marc_record->as_usmarc);

        my $query_MAX = "SELECT MAX(id) FROM cat_registro_marc_n1";
        my $sth_MAX = $dbh->prepare($query_MAX);
        $sth_MAX->execute();
        $id1_nuevo = $sth_MAX->fetchrow;
        
    }

    my $query2=" SELECT id2 FROM cat_nivel2 where id1=? ";
    my $sth2=$dbh->prepare($query2);
    $sth2->execute($id1_nuevo);

    while (my $id2 = $sth2->fetchrow){
        my ($nivel2_object)= C4::AR::Nivel2::getNivel2FromId2($id2);
        
        if($nivel2_object ne 0){
            C4::AR::Debug::debug('recupero el nivel2 '.$id2);
            my $marc_array_nivel2 = $nivel2_object->nivel2CompletoToMARC;
            C4::AR::Debug::debug('MARCDetail => cant '.scalar(@$marc_array_nivel2));
            my $marc_record = generar_marc_record(@$marc_array_nivel2);
        
            my $query2 = "INSERT INTO cat_registro_marc_n2 (marc_record, id1) VALUES (?,?) ";
            my $sth2 = $dbh->prepare($query2);
            
            $sth2->execute($marc_record->as_usmarc,$id1_nuevo);

            my $query_MAX_n2 = "SELECT MAX(id) FROM cat_registro_marc_n2";
            my $sth_MAX_n2 = $dbh->prepare($query_MAX_n2);
            $sth_MAX_n2->execute();
            $id2_nuevo = $sth_MAX_n2->fetchrow;
        }
            
        my $query3=" SELECT id3 FROM cat_nivel3 where id2=? ";
        my $sth3=$dbh->prepare($query3);
        $sth3->execute($id2);
    
        while (my $id3 = $sth3->fetchrow){
            my ($nivel3_object)= C4::AR::Nivel3::getNivel3FromId3($id3);
            
            if($nivel3_object ne 0){
                C4::AR::Debug::debug('recupero el nivel3');
                my $marc_array_nivel3 = $nivel3_object->nivel3CompletoToMARC;
                my $marc_record = generar_marc_record(@$marc_array_nivel3);
        
                my $query3 = "INSERT INTO cat_registro_marc_n3 (marc_record, id2, id1) VALUES (?,?,?) ";
                my $sth3 = $dbh->prepare($query3);
                
                $sth3->execute($marc_record->as_usmarc,$id2_nuevo,$id1_nuevo);
            }
        }
  
    }# END while (my $id2=$sth2->fetchrow)
      
}# END while (my $id1=$sth->fetchrow)


sub generar_marc_record {
    my (@result)= @_;

    my $marc = MARC::Record->new();
    
    for(my $i=0; $i< scalar(@result); $i++){
		if (@result[$i]->{'dato'}){
			my $field = MARC::Field->new(@result[$i]->{'campo'},'','',@result[$i]->{'subcampo'} => @result[$i]->{'dato'});
			$marc->add_fields($field);
		}
    }

    return $marc;
}
