package C4::AR::ImportacionIso;

#
#Este modulo sera el encargado de interactuar con la tabla ISO2709 donde estan los datos 
#para la importacion de codigos iso a marc y donde estan las descripciones de cada campo y sus
#subcampos
#

use strict;
require Exporter;

use C4::Context;
use vars qw(@EXPORT_OK @ISA);
@ISA=qw(Exporter);
@EXPORT_OK=qw(&ui
           &campoIso
	   &subCampoIso
	   &datosCompletos
	   &insertDescripcion
	   &mostrarTablas
	   &mostrarCampos
	   &insertTablaKoha
	   &listadoDeCodigosDeCampo
	   &list
	   &insertNuevo
);

#
#Dado una Unid. de Informacion sus campos y subcampos ISO me devuelve la descripcion correspondiente
#
sub checkDescription{
	my $dbh = C4::Context->dbh;
	my $query ="Select descripcion 
	              From pref_iso2709 
        	      Where (campoIso=? and subCampoIso=?  and ui=?) ";
	my $sth=$dbh->prepare($query);
	$sth->execute(&ui,&campoIso,&subCampoIso);
 
	return ($sth->fetchrow_hashref);
}


#
#Dado una Unid. de Informacion  inserto la descripcion correspondiente

sub insertDescripcion{ 
        my ($descripcion,$id)=@_; 
        my $dbh = C4::Context->dbh;
	my $query ="update  pref_iso2709 set descripcion=?
	    	     Where (id=?)";
 	my $sth=$dbh->prepare($query);
	$sth->execute($descripcion,$id);
        $sth-> finish;                                                                                             
}


sub insertUnidadInformacion{
	my $dbh = C4::Context->dbh;
	my $query ="Insert into pref_iso2709 (ui) values (?)";
	my $sth=$dbh->prepare($query);
	$sth->execute(&ui);
	$sth->finish;
}

#Datos para mostrar que estan en la tabla iso2709, para que carguen las descripciones de los
#campos y subcampos asi despues se puede hacer la importacion
#
sub datosCompletos{
	my ($campoIso,$branchcode)=@_;
	my $dbh = C4::Context->dbh;
	my @results;
	my $query ="Select * from pref_iso2709 ";
	$query.= "where campoIso = ".$campoIso." and ui='".$branchcode."'"; #Comentar para lograr el listado completo
	my $sth=$dbh->prepare($query);
	$sth->execute();
        while (my $data=$sth->fetchrow_hashref){
		 #if ($data->{'ui'} eq "") {
		#	$data->{'ui'}="-" };
		 if ($data->{'subCampoIso'} eq "") {
                        $data->{'subCampoIso'}="-" };
             	push(@results,$data);
		} 
	return (@results);
}

#Muestro todas las tablas de la base de datos

sub mostrarTablas{
        my $dbh = C4::Context->dbh;
        my @results;
        my $query ="show tables";
        my $sth=$dbh->prepare($query);
        $sth->execute();
	push(@results,""); #Agrago un primer elemento vacio
        while (my @data=$sth->fetchrow_array){
	#	if (($data->{'Tables_in_Econo'} eq 'items') 
	#		|| ($data->{'Tables_in_Econo'} eq 'biblio')
	#		|| ($data->{'Tables_in_Econo'} eq 'biblioitems')
	#	) {
			my $nombre = $data[0];#->{'Tables_in_Econo'};
 			push(@results,$nombre);
	#	}
	}
	return (@results);
}

#Dado el nombre de una tabla me devuelve todos sus campos
#

sub mostrarCampos{
        my $dbh = C4::Context->dbh;
        my @results;
	my ($nombre)=@_;
        if ($nombre ne '') {
	my $query ="show fields from $nombre";
        my $sth=$dbh->prepare($query);
        $sth->execute();
 	while (my @data=$sth->fetchrow_array){
		my $campos = $data[0];
		push(@results,$campos);
	}
	}
	else
	{push(@results,'');
	}
        return (@results);
}
#Dado un campo y subcampo inserto la tabla koha al cual pertenece 
                                                                                                                             
sub insertTablaKoha{
        my ($kohaTabla,$id)=@_;
        my $dbh = C4::Context->dbh;
        my $query ="update  pref_iso2709 set kohaTabla=?
                     Where (id=?)";
        my $sth=$dbh->prepare($query);
        $sth->execute($kohaTabla,$id);
        $sth-> finish;
}


#Inserto una tupla completa nueva
#
sub insertNuevo{
        my ($descripcion,$kohaTabla,$campoIso,$subCampoIso,$campoKoha,$orden,$separador,$id,$campoK)=@_;
	if ($descripcion eq "") {$descripcion= undef;}
	if ($kohaTabla eq "") {$kohaTabla= undef;}
	if ($campoKoha eq "") {$campoKoha= undef;}
        my $dbh = C4::Context->dbh;
        my $query ="update  pref_iso2709 set descripcion=?,kohaTabla=?,kohaCampo=?,orden=?,separador=?,interfazWeb=?
                     Where (id=?)";
        my $sth=$dbh->prepare($query);
        $sth->execute($descripcion,$kohaTabla,$campoKoha,$orden,$separador,$campoK,$id);
        $sth-> finish;
}

sub listadoDeCodigosDeCampo{
        my $dbh = C4::Context->dbh;
        my @results;
        my $query ="select campoIso from pref_iso2709 group by campoIso order by campoIso";
        my $sth=$dbh->prepare($query);
        $sth->execute();
        while (my $data=$sth->fetchrow_hashref){
                push(@results,$data);
        }
        return (@results);
}
sub list{
        my $dbh = C4::Context->dbh;
        my %results;
        my $query ="select campoIso,subCampoIso,kohaCampo,kohaTabla from pref_iso2709 order by campoIso";
        my $sth=$dbh->prepare($query);
        $sth->execute();
        while (my $data=$sth->fetchrow_hashref){
		my @resp;
		@resp= ($data->{'kohaTabla'},$data->{'kohaCampo'});
		$results{$data->{'campoIso'},$data->{'subCampoIso'}}=@resp; 
	        }
        return (%results);
}


END { }       # module clean-up code here (global destructor)

1;
__END__