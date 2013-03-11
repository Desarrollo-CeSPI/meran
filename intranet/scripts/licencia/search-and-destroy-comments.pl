#!/usr/bin/perl

# Se eliminan los comentarios y se reemplazan las licencias de los *.pl y *.pm de un directorio.
# USO:
#  perl search-and-destroy-comments.pl PATH_COMPLETO_DIRECTORIO_A_ESCANEAR ARCHIVO_NUEVA_LICENCIA
# EJ:
# perl search-and-destroy-comments.pl /usr/local/koha/ licencia.txt

use File::Find;
use Tie::File;
use strict;

my $directory = $ARGV[0]; #Directorios a escanear
my $licenceFile = $ARGV[1]; #archivo con la licencia a reemplazar

my @licenceLines;

tie @licenceLines, 'Tie::File', $licenceFile or die "No se pudo abrir el archivo de licencia: $!\n";

#Procesamos
find (\&process, $directory);

sub process
{
    my @lines;      #Linea leida.

    if (( $File::Find::name =~ /\.pm$/)or( $File::Find::name =~ /\.pl$/)) {

   print "Procesando $File::Find::name\n";
   #Abrimos el archivo a modificar
   tie @lines, 'Tie::File', $File::Find::name or die "No se pudo abrir el archivo: $!\n";
   my $i=0; 
   #Sacamos los comentarios incluso la 1er linea si es un pl !!!  ----> #!/usr/bin/perl

   while ($i < scalar(@lines)) {

	if ( length ($lines[$i]) ne 0){ #Ya era blanco
		$lines[$i] =~ s/^\s*#.*//;

		if ( length ($lines[$i]) eq 0){ #Se puso en blanco
			splice(@lines,$i,1);
		}
		else{$i++;}
  	}
	else{$i++;}
    }

   # Agregamos  la nueva licencia al principio

   for (my $j = scalar(@licenceLines)-1; $j ge 0;$j--) {
   	unshift(@lines, $licenceLines[$j]);
   }
   # Tenemos que volver a agregar el  #!/usr/bin/perl si es un pl!!!
   if ( $File::Find::name =~ /\.pl$/) {
   	unshift(@lines, "#!/usr/bin/perl");
    }
    untie @lines;
   }
 }
