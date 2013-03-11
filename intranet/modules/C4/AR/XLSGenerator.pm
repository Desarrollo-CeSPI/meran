package C4::AR::XLSGenerator;


use strict;
use C4::AR::Auth;
use Spreadsheet::WriteExcel::Simple;


my $input = new CGI;
my $authnotrequired= 0;


use vars qw(@EXPORT @ISA);
@ISA=qw(Exporter);
@EXPORT=qw(  
    &exportarMejorPresupuesto;
    &exportarPesupuesto;
    &exportarReporteCircGeneral;
);

=item
    Devuelve la planilla xls con los datos pasados por parametro
=cut
sub getXLS{
    my ($tabla_a_exportar, $headers_tabla, $headers_planilla, $campos_hidden, $nombre_proveedor)    = @_;
    my $msg_object                                                                                  = C4::AR::Mensajes::create();
    my $spread_sheet                                                                                = Spreadsheet::WriteExcel::Simple->new;
    
    # headers planilla
    $spread_sheet->write_bold_row($headers_planilla); 
    
    # campo hidden, id_proveedor FIXME no lo oculta
    $spread_sheet->write_bold_row($campos_hidden);   
    
    # headers tabla
    $spread_sheet->write_bold_row($headers_tabla); 
    
    #tabla
    foreach my $celda (@$tabla_a_exportar){
        $spread_sheet->write_row($celda);       
    }
    my $data;
  
    $data = $spread_sheet->data; 

    return ($data);
}

sub exportarReporteCircGeneral{

     my ($tabla_a_exportar, $headers_tabla) = @_;
     my $msg_object= C4::AR::Mensajes::create();
     
     my $ss = Spreadsheet::WriteExcel::Simple->new;

#-------- Se escriben los headers en el excel con lo q contiene el array headers_tabla ------------

     $ss->write_bold_row($headers_tabla);   

#-------- Se escriben los datos en el excel con lo q contiene el array $tabla_a_exportar ------------
     
     foreach my $celda (@$tabla_a_exportar){
        $ss->write_row($celda);       
     }

     eval{
          $ss->save("/usr/share/meran/intranet/htdocs/intranet-tmpl/reports/reporte_circ_general.xls"); 
     };

     if ($@){
           $msg_object->{'error'}= 1;
           C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A037', 'params' => []} ) ;  
     } else {
           $msg_object->{'error'}= 0;
           C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A036', 'params' => []} ) ;  
    }
    return ($msg_object);

}
# ----- Exporta los datos de la tabla a un archivo .xls, recibe como parametros un array con los datos y otro con los headers de la tabla ---- 

sub exportarMejorPresupuesto{

     my ($tabla_a_exportar, $headers_tabla) = @_;
     my $msg_object= C4::AR::Mensajes::create();
     
     my $ss = Spreadsheet::WriteExcel::Simple->new;

#-------- Se escriben los headers en el excel con lo q contiene el array headers_tabla ------------

     $ss->write_bold_row($headers_tabla);   

#-------- Se escriben los datos en el excel con lo q contiene el array $tabla_a_exportar ------------
     
     foreach my $celda (@$tabla_a_exportar){
        $ss->write_row($celda);       
     }

     eval{
          $ss->save("/usr/share/meran/intranet/htdocs/intranet-tmpl/reports/mejor_presupuesto.xls"); 
     };

     if ($@){
           $msg_object->{'error'}= 1;
           C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A037', 'params' => []} ) ;  
     } else {
           $msg_object->{'error'}= 0;
           C4::AR::Mensajes::add($msg_object, {'codMsg'=> 'A036', 'params' => []} ) ;  
    }
    return ($msg_object);

}

      
END { }       # module clean-up code here (global destructor)

1;
__END__    
