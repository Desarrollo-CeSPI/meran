#!/usr/bin/perl  
use JavaScript::Minifier qw(minify);

#procesa el archivo archivos_a_comprimir.txt y comprime los js
my $path="/home/magali/proyectos/meran";
open (FILE, $path."/intranet/scripts/archivos_a_comprimir_intranet_top.txt" ) or die "No se pudo abrir el archivo: $!";
system ("rm $path/includes/completo-intranet-top.js");
while ( <FILE> ) {
    
    my($line) = $_;
    chomp($line);
    open(INFILE, $path.$line.'.js') or die;
    open(OUTFILE, '>'.$path.$line.'-min.js') or die $line ;
    minify(input => *INFILE, outfile => *OUTFILE);
    close(INFILE);
    close(OUTFILE);
    system ("cat ".$path.$line."-min.js >> $path/includes/completo-intranet-top.js");
}
#open(INFILE, 'myScript.js') or die;
#open(OUTFILE, '>myScript-min.js') or die;

close(FILE);

#procesa el archivo archivos_a_comprimir_individuales.txt y comprime los js en archivos -min
open (FILE, $path."/intranet/scripts/archivos_a_comprimir_individuales.txt" ) or die "No se pudo abrir el archivo: $!";
while ( <FILE> ) {
    my($line) = $_;
    chomp($line);
    open(INFILE, $path.$line.'.js') or die $line;
    open(OUTFILE, '>'.$path.$line.'-min.js') or die $line ;
    minify(input => *INFILE, outfile => *OUTFILE);
    close(INFILE);
    close(OUTFILE);
}
#open(INFILE, 'myScript.js') or die;
#open(OUTFILE, '>myScript-min.js') or die;

close(FILE);
#procesa el archivo archivos_no_comprimir_individuales.txt y los copia en archivos -min.js
open (FILE, $path."/intranet/scripts/archivos_no_comprimir_individuales.txt" ) or die "No se pudo abrir el archivo: $!";
while ( <FILE> ) {
    my($line) = $_;
    chomp($line);
    system ("cp $path$line.js $path$line-min.js") ;
}
close(FILE);
