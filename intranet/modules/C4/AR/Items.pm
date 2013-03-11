package C4::AR::Proveedores;

use strict;
require Exporter;
use DBI;
use C4::Modelo::AdqProveedor;
use C4::Modelo::AdqProveedor::Manager;

use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(   
    &getItemsPorProveedor;
);


sub getItemsPorProveedor {

    use C4::Modelo::AdqItem;
    use C4::Modelo::AdqItem::Manager;
    my ($id_proveedor,$orden,$ini,$cantR,$inicial) = @_;
    my @filtros;
    my $itemTemp = C4::Modelo::AdqItem->new();

    push (@filtros, (or   => [   nombre => { like => '%'.$proveedor.'%'},]) );




    if (!defined $habilitados){
        $habilitados = 1;
    }

    push(@filtros, ( activo => { eq => $habilitados}));
 #   push(@filtros, ( es_socio => { eq => $habilitados}));
    my $ordenAux= $proveedorTemp->sortByString($orden);





    my $proveedores_array_ref = C4::Modelo::AdqProveedor::Manager->get_adq_proveedor(   query => \@filtros,
                                                                            sort_by => $ordenAux,
                                                                            limit   => $cantR,
                                                                            offset  => $ini,
#                                                               require_objects => ['nombre','direccion','telefono',
#                                                                                  'email'],
     ); 

C4::AR::Debug::debug("|" . @filtros . "|");

    #Obtengo la cant total de socios para el paginador
    my $proveedores_array_ref_count = C4::Modelo::AdqProveedor::Manager->get_adq_proveedor_count( query => \@filtros,
#                                                              require_objects => ['nombre','direccion','telefono',
#                                                                                  'email'],
                                                                     );

    if(scalar(@$proveedores_array_ref) > 0){
        return ($proveedores_array_ref_count, $proveedores_array_ref);
    }else{
        return (0,0);
    }
}
