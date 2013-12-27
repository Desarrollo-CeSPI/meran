package C4::Modelo::RepHistorialBusqueda;

use strict;

use base qw(C4::Modelo::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'rep_historial_busqueda',

    columns => [
        idHistorial        => { type => 'serial', overflow => 'truncate', not_null => 1 },
        idBusqueda         => { type => 'integer', overflow => 'truncate', not_null => 1 },
        campo              => { type => 'varchar', overflow => 'truncate', length => 100, not_null => 1 },
        valor              => { type => 'varchar', overflow => 'truncate', length => 100, not_null => 1 },
        tipo               => { type => 'varchar', overflow => 'truncate', length => 10 },
        agent              => { type => 'varchar', overflow => 'truncate', length => 500},
        agregacion_temp     => { type => 'varchar', overflow => 'truncate', length => 255},
    ],

   primary_key_columns => [ 'idHistorial' ],

   relationships => [
         busqueda =>  {
            class       => 'C4::Modelo::RepBusqueda',
            key_columns => { idBusqueda => 'idBusqueda' },
            type        => 'one to one',
      },

    ],
);


sub agregarSimple{
   my $self = shift;

   my($id_rep_busqueda,$tipo_busqueda,$valor,$desde,$user_agent)=@_;

   $self->setIdBusqueda($id_rep_busqueda);
   $self->setCampo($tipo_busqueda);
   $self->setValor($valor);
   $self->setTipo($desde);
   $self->setAgent($user_agent);
   $self->save();

}


sub agregar{
   my $self = shift;
   my($nro_socio,$desde,$http_user_agent,$search_array)=@_;

   my $db = $self->db;
   my $rep_busqueda = C4::Modelo::RepBusqueda->new(db => $db);
   my $socio;
   if ($nro_socio){
      $socio = C4::AR::Usuarios::getSocioInfoPorNroSocio($nro_socio);
      if ($socio){
          $rep_busqueda->categoria_socio($socio->categoria->getCategory_code);
      }
  }
  $rep_busqueda->agregar($nro_socio);
# FIXME ver si se puede mejorar esta muy largo, se puede hacer generico???
# parace q lo unico q es variable seria  'keyword', $search->{'keyword'}
   foreach my $search (@$search_array){
		if (!C4::AR::Utilidades::isBrowser($http_user_agent)) { 
				$http_user_agent =  'ROBOT';
		}
	
		my $historial_temp = C4::Modelo::RepHistorialBusqueda->new(db => $db);

		if (C4::AR::Utilidades::validateString($search->{'keyword'}) ){
	#EN CADA IF HAY QUE CREAR DE NUEVO SINO SOLAMENTE SE ACTUALIZA
			
			$historial_temp->agregarSimple($rep_busqueda->getIdBusqueda, 'keyword', $search->{'keyword'}, $desde,$http_user_agent);
		}

	
		if (C4::AR::Utilidades::validateString($search->{'signature'}) ){
			$historial_temp->agregarSimple($rep_busqueda->getIdBusqueda, 'signature', $search->{'signature'}, $desde, $http_user_agent);
		}  

	
		if (C4::AR::Utilidades::validateString($search->{'isbn'}) ){
			$historial_temp->agregarSimple($rep_busqueda->getIdBusqueda, 'isbn', $search->{'isbn'}, $desde, $http_user_agent);
		}
	
		if (C4::AR::Utilidades::validateString($search->{'autor'}) ){
			$historial_temp->agregarSimple($rep_busqueda->getIdBusqueda, 'autor', $search->{'autor'}, $desde, $http_user_agent);
		}
	
		if (C4::AR::Utilidades::validateString($search->{'titulo'}) ){
C4::AR::Debug::debug("logueo de busqueda => busco por titulo: ".$search->{'titulo'});
			$historial_temp->agregarSimple($rep_busqueda->getIdBusqueda, 'titulo', $search->{'titulo'}, $desde, $http_user_agent);
		}
	
		if (C4::AR::Utilidades::validateString($search->{'tipo_documento'}) ){
			$historial_temp->agregarSimple($rep_busqueda->getIdBusqueda, 'tipo_documento', $search->{'tipo_documento'}, $desde, $http_user_agent);
		}
	
		if (C4::AR::Utilidades::validateString($search->{'barcode'}) ){
			$historial_temp->agregarSimple($rep_busqueda->getIdBusqueda, 'barcode', $search->{'barcode'}, $desde, $http_user_agent);
		}
		
		if (C4::AR::Utilidades::validateString($search->{'filtrarPorAutor'}) ){
			$historial_temp->agregarSimple(	
											$rep_busqueda->getIdBusqueda, 
											'filtrarPorAutor', 
											$search->{'filtrarPorAutor'}, 
											$desde, 
											$http_user_agent
										);
		}	
   }
}# END agregar

sub getIdBusqueda{

   my ($self) = shift;
   return ($self->idBusqueda);
}

sub setIdBusqueda{

   my ($self) = shift;
   my ($id_busqueda) = @_;
   $self->idBusqueda($id_busqueda);
}


sub getAgent{

   my ($self) = shift;
   return ($self->agent);
}

sub setAgent{

   my ($self) = shift;
   my ($http_user_agent) = @_;
   $self->agent($http_user_agent);
}

sub getCampo{

   my ($self) = shift;
   return ($self->campo);
}

sub setCampo{

   my ($self) = shift;
   my ($campo) = @_;
   $self->campo($campo);
}

sub getValor{

   my ($self) = shift;
   return ($self->valor);
}

sub setValor{

   my ($self) = shift;
   my ($valor) = @_;
   $self->valor($valor);
}

sub getTipo{

   my ($self) = shift;
   return ($self->tipo);
}

sub setTipo{

   my ($self) = shift;
   my ($tipo) = @_;
   $self->tipo($tipo);
}

END { }       # module clean-up code here (global destructor)

1;
__END__


