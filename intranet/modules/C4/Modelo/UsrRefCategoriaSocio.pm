package C4::Modelo::UsrRefCategoriaSocio;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup
  (
    table   => 'usr_ref_categoria_socio',
    columns =>
        [
            id                      => { type => 'integer', overflow => 'truncate', not_null => 1 }, 
            categorycode            => { type => 'char', overflow => 'truncate', not_null => 1 , length => 2},
            description             => { type => 'varchar', overflow => 'truncate', length => 255, not_null => 1 },
            enrolmentperiod         => { type => 'integer', overflow => 'truncate', length => 6 },
            upperagelimit           => { type => 'integer', overflow => 'truncate', length => 6 },
            dateofbirthrequired     => { type => 'integer', overflow => 'truncate', length => 128 },
            finetype                => { type => 'varchar', overflow => 'truncate', length => 30 },
            bulk                    => { type => 'integer', overflow => 'truncate', length => 128 },
            enrolmentfee            => { type => 'decimal', overflow => 'truncate' },
            overduenoticerequired   => { type => 'integer', overflow => 'truncate', length => 128 },
            issuelimit              => { type => 'integer', overflow => 'truncate', length => 128 },
            reservefee              => { type => 'decimal', overflow => 'truncate' },
            borrowingdays           => { type => 'integer', overflow => 'truncate', length => 30, not_null => 1, default   => '14' },           
        ],
        
    primary_key_columns => ['id'], 
    unique_key => ['categorycode'],

);

use C4::Modelo::UsrRefTipoDocumento;
use C4::Modelo::UsrRefCategoriaSocio::Manager;
use Text::LevenshteinXS;
    

sub toString{
    my ($self) = shift;

    return ($self->getDescription);
}


sub nextMember{
    
    return(C4::Modelo::UsrRefTipoDocumento->new());
}


sub conformarUsrRegularidad{
    my ($self)=shift;

    my ($estados_array_ref)  = C4::AR::Referencias::obtenerEstados();

    foreach my $estado (@$estados_array_ref) {
        my $regularidad = C4::Modelo::UsrRegularidad->new();
        my %data_hash ={};

        $data_hash{'usr_estado_id'} = $estado->getId_estado;
        $data_hash{'usr_ref_categoria_id'} = $self->getId();
        $data_hash{'Condicion'} = 0;
        $regularidad->agregar(\%data_hash);
    }    
    
}

sub getId{
    my ($self) = shift;
    return ($self->id);    
}

sub getCategory_code{
    my ($self) = shift;
    return ($self->categorycode);
}

sub setCategory_code{
    my ($self) = shift;
    my ($category_code) = @_;
    $self->categorycode($category_code);
}


sub getDescription{
    my ($self) = shift;
    return (C4::AR::Utilidades::trim($self->description));
}

sub setDescription{
    my ($self) = shift;
    my ($description) = @_;
    $self->description($description);
}

sub getEnrolment_period{
    my ($self) = shift;
    return ($self->enrolment_period);
}

sub setEnrolment_period{
    my ($self) = shift;
    my ($enrolment_period) = @_;
    $self->enrolment_period($enrolment_period);
}

sub getUpper_age_limit{
    my ($self) = shift;
    return ($self->upper_age_limit);
}

sub setUpper_age_limit{
    my ($self) = shift;
    my ($upper_age_limit) = @_;
    $self->upper_age_limit($upper_age_limit);
}

sub getDate_of_birth_required{
    my ($self) = shift;
    return ($self->date_of_birth_required);
}

sub setDate_of_birth_required{
    my ($self) = shift;
    my ($date_of_birth_required) = @_;
    $self->date_of_birth_required($date_of_birth_required);
}

sub getFine_type{
    my ($self) = shift;
    return ($self->fine_type);
}

sub setFine_type{
    my ($self) = shift;
    my ($fine_type) = @_;
    $self->fine_type($fine_type);
}

sub getBulk{
    my ($self) = shift;
    return ($self->bulk);
}

sub setBulk{
    my ($self) = shift;
    my ($bulk) = @_;
    $self->bulk($bulk);
}

sub getEnrolment_fee{
    my ($self) = shift;
    return ($self->enrolment_fee);
}

sub setEnrolment_fee{
    my ($self) = shift;
    my ($enrolment_fee) = @_;
    $self->enrolment_fee($enrolment_fee);
}

sub getOver_due_notice_required{
    my ($self) = shift;
    return ($self->over_due_notice_required);
}

sub setOver_due_notice_required{
    my ($self) = shift;
    my ($over_due_notice_required) = @_;
    $self->over_due_notice_required($over_due_notice_required);
}

sub getIssue_limit{
    my ($self) = shift;
    return ($self->issue_limit);
}

sub setIssue_limit{
    my ($self) = shift;
    my ($issue_limit) = @_;
    $self->issue_limit($issue_limit);
}

sub getReserve_fee{
    my ($self) = shift;
    return ($self->reserve_fee);
}

sub setReserve_fee{
    my ($self) = shift;
    my ($reserve_fee) = @_;
    $self->reserve_fee($reserve_fee);
}

sub getBorrowing_days{
    my ($self) = shift;
    return ($self->borrowing_days);
}

sub setBorrowing_days{
    my ($self) = shift;
    my ($borrowing_days) = @_;
    $self->borrowing_days($borrowing_days);
}


sub obtenerValoresCampo {
    my ($self)              = shift;
    my ($campo, $orden)     = @_;

    my @array_valores;
    my @fields  = ($campo, $orden);
    my $v       = $self->validate_fields(\@fields);

    if($v){
    
        my $ref_valores = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio
                            ( select   => [$self->meta->primary_key ,$campo],
                              sort_by => ($orden) );


        for(my $i=0; $i<scalar(@$ref_valores); $i++ ){
            my $valor;
            $valor->{"clave"}=$ref_valores->[$i]->getCategory_code;
            $valor->{"valor"}=$ref_valores->[$i]->getCampo($campo);
            push (@array_valores, $valor);
        }
    }
    
    return (scalar(@array_valores), \@array_valores);
}

sub obtenerValorCampo {
    my ($self)=shift;
    my ($campo,$id)=@_;
    my $ref_valores = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio
                        ( select   => [$campo],
                          query =>[ categorycode => { eq => $id} ]);
        
#   return ($ref_valores->[0]->getCampo($campo));
  if(scalar(@$ref_valores) > 0){
    return ($ref_valores->[0]->getCampo($campo));
  }else{
    #no se pudo recuperar el objeto por el id pasado por parametro
    return undef;
  }
}

sub getCampo{
    my ($self) = shift;
    my ($campo)=@_;
    
    if ($campo eq "categorycode") {return $self->getCategory_code;}
    if ($campo eq "description") {return $self->getDescription;}

    return (0);
}


sub getAll{

    my ($self) = shift;
    my ($limit,$offset,$matchig_or_not,$filtro)=@_;
    $matchig_or_not = $matchig_or_not || 0;
    my @filtros;
    if ($filtro){
        my @filtros_or;
        push(@filtros_or, (categorycode => {like => '%'.$filtro.'%'}) );
        push(@filtros_or, (description => {like => '%'.$filtro.'%'}) );
        push(@filtros, (or => \@filtros_or) );
    }
    my $ref_valores;
    if ($matchig_or_not){ #ESTOY BUSCANDO SIMILARES, POR LO TANTO NO TENGO QUE LIMITAR PARA PERDER RESULTADOS
        push(@filtros, ($self->getPk => {ne => $self->getPkValue}) );
        $ref_valores = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio(query => \@filtros,);
    }else{
        $ref_valores = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio(query => \@filtros,
                                                                    limit => $limit, 
                                                                    offset => $offset, 
                                                                    sort_by => ['description'] 
                                                                   );
    }
    my $ref_cant = C4::Modelo::UsrRefCategoriaSocio::Manager->get_usr_ref_categoria_socio_count(query => \@filtros,);
    my $self_descripcion = $self->getDescription;

    my $match = 0;
    if ($matchig_or_not){
        my @matched_array;
        foreach my $each (@$ref_valores){
          $match = ((distance($self_descripcion,$each->getDescription)<=1));
          if ($match){
            push (@matched_array,$each);
          }
        }
        return (scalar(@matched_array),\@matched_array);
    }
    else{
      return($ref_cant,$ref_valores);
    }
}

sub getCamposAsArray{
    my ($self)=shift;

    my @camposArray;

    push(@camposArray, "Código de Categoría");
    push(@camposArray, "Descripción");

    return(\@camposArray);
}

#ESTA HORRIBLE!!! HAY QUE VER COMO HACERLO MAS PROLIJO
sub printAsTableElement{

    my ($self)=shift;

    my $td;
      
    $td.="<td class='editable' id='".$self->getAlias."___"."categorycode"."___".$self->getPkValue."___".$editId."'>".$self->{'categorycode'}."</td>";
    $td.="<td class='editable' id='".$self->getAlias."___"."description"."___".$self->getPkValue."___".$editId."'>".$self->{'description'}."</td>";

    return ($td);
}

#ESTA HORRIBLE!!! HAY QUE VER COMO HACERLO MAS PROLIJO
sub addNewRecord{
    my ($self) = shift;

    $self->{"categorycode"} = C4::AR::Filtros::i18n('_SIN_VALOR_');
    $self->{"description"} = C4::AR::Filtros::i18n('_SIN_VALOR_');
    
    $self->save();
    
    #parche loco
    
    if ($self->meta->table eq "usr_ref_categoria_socio"){
        $self->conformarUsrRegularidad();
    }
    #elsif ($self->meta->table eq "ref_estado"){
    #  $self->setCodigo('STATE002');
    #}
    
    return $self;

}


1;
