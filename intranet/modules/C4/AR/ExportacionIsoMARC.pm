package C4::AR::ExportacionIsoMARC;

#
#para la exportacion de registros a marc
#

use strict;
require Exporter;

use C4::Context;
use MARC::Record;
use MARC::File::USMARC;
use MARC::File::XML;

use C4::Modelo::CatRegistroMarcN1;
use C4::Modelo::CatRegistroMarcN1::Manager;

use C4::Modelo::CatRegistroMarcN2;
use C4::Modelo::CatRegistroMarcN2::Manager;

use C4::Modelo::CatRegistroMarcN3;
use C4::Modelo::CatRegistroMarcN3::Manager;


use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(

);


=item sub marc_record_to_ISO

  pasa un marc_record_array_to_ISO a un arhivo ISO
=cut
sub marc_record_array_to_ISO {
    my ($marc_record_array_ref) = @_;

    foreach my $marc_record (@$marc_record_array_ref){
#             $marc_record->encoding( 'UTF-8' );
          print $marc_record->as_usmarc();
    }
}

sub limpiar_enter_para_roble {
    my ($marc_record_unido) = @_;
    #Para ROBLE limpio de \n y \r de los campos de notas (520a,534a,500a)
        #Un solo campo
        if (( $marc_record_unido->field('520') )&&( $marc_record_unido->field('520')->subfield('a') )) {
            my $nota=$marc_record_unido->field('520')->subfield('a');
            $nota =~ s/\n//ig;
            $nota =~ s/\r/ /ig;
            $marc_record_unido->field('520')->update( 'a' => $nota );
        }
        #Un solo campo
        if (( $marc_record_unido->field('534') )&&( $marc_record_unido->field('534')->subfield('a') )) {
            my $nota=$marc_record_unido->field('534')->subfield('a');
            $nota =~ s/\n//ig;
            $nota =~ s/\r/ /ig;
            $marc_record_unido->field('534')->update( 'a' => $nota );
        }
        #Varios campos
        if (( $marc_record_unido->field('500') )&&( $marc_record_unido->field('500')->subfield('a') )) {
            my @campos = $marc_record_unido->field('500');
            $marc_record_unido->delete_fields(@campos);
            foreach my $field (@campos){
                my @notas=$field->subfield('a');
                $field->delete_subfield(code => 'a');
                foreach my $nota (@notas){
                    $nota =~ s/\n//ig;
                    $nota =~ s/\r/ /ig;
                    $field->add_subfields( 'a' => $nota );
                }
             $marc_record_unido->append_fields($field);
            }
        }
    return $marc_record_unido;
}

=item sub marc_record_to_ISO_from_range
  exporta un rago de registros pasados por parametro a un archivo ISO
=cut
sub marc_record_to_ISO_from_range {
    my ( $query ) = @_;

    my $records_array = C4::AR::ExportacionIsoMARC::getRecordsFromRange( $query );
    my $marc_record_array_ref;
    my $field_ident_universidad = MARC::Field->new('040','','','a' => C4::AR::Preferencias::getValorPreferencia("origen_catalogacion"));
    
    foreach my $nivel1 (@$records_array){
        
        
            if($query->param('tipo_nivel3_name') eq "REV") {
                #REVISTAS!!! Un registro por título (Formato RELAP)
                 my $marc_record_relap =  $nivel1->getMarcRecordConDatosForRobleExportRELAP();
                 
                #Para ROBLE limpio de \n y \r de los campos de notas (520a,534a,500a,995u)
                $marc_record_relap = C4::AR::ExportacionIsoMARC::limpiar_enter_para_roble($marc_record_relap);
                my $registro_final = C4::AR::ExportacionIsoMARC::convertMarcRecordToMoose($marc_record_relap,'iso');
                print $registro_final;
                
            }else { 
                #Formato MARC, un registro por edición
                
                my $grupos = $nivel1->getGrupos();
                #Se exporta cad nivel2 a un registro para  Roble
                foreach my $nivel2 (@$grupos){

                    my $marc_record_n2 =  $nivel2->getMarcRecordForRobleExport($query->param('exportar_ejemplares'));
                    
                    my $marc_record_unido = MARC::Record->new();

                
                    #Genero el ID par Exportar
                    my $field_id   = MARC::Field->new('001', $nivel2->getId2);
                    
                    if($nivel2->getTipoDocumento() eq "REV") {
                            $field_id   = MARC::Field->new('100', $nivel2->getId2);
                    }
                    
                    #Sigla de la Biblioteca + Ubicación Geográfica
                    my $signaturas = $nivel2->getSignaturas();
                    my $primera_signatura = $signaturas->[0];
                    
                    my $id_biblio = C4::AR::Preferencias::getValorPreferencia("defaultUI")." ".$primera_signatura;

                    my $field_ident_biblioteca  = MARC::Field->new("910",'','','a' => $id_biblio);
                    
                    
                    $marc_record_unido->append_fields($field_id );
                    $marc_record_unido->append_fields($field_ident_biblioteca);
                    $marc_record_unido->append_fields($field_ident_universidad);
                        
                        
                    #Borro el tipo de documento
                    $marc_record_n2->delete_fields($marc_record_n2->field("910"));
                    
                    $marc_record_unido->append_fields($marc_record_n2->fields());
                    
                    #C4::AR::Debug::debug("marc_record_to_ISO_from_range =>>>>>>>>> \n ". $marc_record_unido->as_formatted );
                    
                    #Para ROBLE limpio de \n y \r de los campos de notas (520a,534a,500a,995u)
                    $marc_record_unido = C4::AR::ExportacionIsoMARC::limpiar_enter_para_roble($marc_record_unido);

                    my $registro_final = C4::AR::ExportacionIsoMARC::convertMarcRecordToMoose($marc_record_unido,'iso');
                
                    print $registro_final;
                }
            }
    }
}

=item sub getRecordsFromRange

Retorna todos los registros para exportar
=cut
sub getRecordsFromRange {
    my ( $params ) = @_;

    my @filtros;

    
    C4::AR::Debug::debug("getRecordsFromRange => : ".$params->param('registro_ini'));
    
    if ($params->param('tipo_nivel3_name') ne "") {
        #filtro por tipo de ejemplar
    C4::AR::Debug::debug("getRecordsFromRange => : TIPO ".$params->param('tipo_nivel3_name'));
        push (@filtros, ( template => { eq => $params->param('tipo_nivel3_name')}));
    } 


    if ( ($params->param('registro_ini') ne "") && ($params->param('registro_fin') ne "") ){
        #filtro por rango de blbionumber
        push (@filtros, ( id => { ge => $params->param('registro_ini')}));
        push (@filtros, ( id => { le => $params->param('registro_fin')}));
    } 
      
    if ($params->param('busqueda')){
        push (@filtros, ( marc_record => { like => '%'.$params->param('busqueda').'%'}));
    }
     my $registros_array_ref;
    if($params->param('limit')){
        
            C4::AR::Debug::debug("getRecordsFromRange => : ".$params->param('limit'));
            
        $registros_array_ref= C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1( query => \@filtros, limit => $params->param('limit'),offset  => 0);
    }
    else{
        
            C4::AR::Debug::debug("getRecordsFromRange => : no limit ");
        $registros_array_ref= C4::Modelo::CatRegistroMarcN1::Manager->get_cat_registro_marc_n1( query => \@filtros);
        
        
        C4::AR::Debug::debug("getRecordsFromRange => : no limit ".@$registros_array_ref);
    }
    return  $registros_array_ref;
}

sub convertMarcRecordToMoose {
    my ($marc_record) = @_;
    
    
    use MARC::Moose::Record;
    use MARC::Moose::Parser::Isis;
    use MARC::Moose::Record;
    use MARC::Moose::Formater::Iso2709;

  #CODIFICACION WINDOWS!!!
  my $converter   = Text::Iconv->new( "utf8", "cp850");
  
    my $record = MARC::Moose::Record->new();
    
    foreach my $field ($marc_record->fields) {
        my $new_field;
        
        if($field->is_control_field){
            #ES DE CONTROL
            $new_field= MARC::Moose::Field::Control->new(tag => $field->tag() , value =>  $converter->convert($field->data()));
            
            }
        else{
                my @new_subfields;
                my $i=0;
                #proceso todos los subcampos del campo
               foreach my $subfield ($field->subfields()) {
                    $new_subfields[$i]= [$subfield->[0] => $converter->convert($subfield->[1])];
                    $i++;
               }
               
               $new_field=  MARC::Moose::Field::Std->new( tag  => $field->tag , subf =>\@new_subfields);
               
            }
        $record->append($new_field);
    }

    my $registro_roble = C4::AR::ExportacionIsoMARC::formatearIso2709( $record );   
    return $registro_roble;
    }


sub formatearIso2709 {
    my ($record) = @_;
    my ( $directory, $fields, $from ) = ( '', '', 0 );
    use YAML;
    for my $field ( @{$record->fields} ) {
        my $str = do {
            if ( ref($field) eq 'MARC::Moose::Field::Control' ) {
                $field->value."#";
            }
            else {
                my $str = '';
                $str .= "^".$_->[0].$_->[1] for @{$field->subf};
                $str = $str."#";
            }
        };
        $fields .= $str;
        #FIXME: Which of this lines is the correct one?
        my $len = bytes::length($str);
        #my $len = length($str);
        $directory .= sprintf( "%03s%04d%05d", $field->tag, $len, $from );
        $from += $len;
    }

    # Update leader with calculated offset (data begining) and total length of
    # record
    my $offset = 24 + 12 * @{$record->fields} + 1;
    my $length = $offset + $from + 1;
    $record->set_leader_length( $length, $offset );

    return $record->leader . $directory . "#" . $fields . "#";
}

1;
