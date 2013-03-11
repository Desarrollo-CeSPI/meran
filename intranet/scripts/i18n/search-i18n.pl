#!/usr/bin/perl

use File::Find;
use Locale::PO;
use strict;

my $directory = $ARGV[0]; #Directorios a escanear
my $output_po = $ARGV[1]; #Archivo PO resultado 
my @outLines;  #Arreglo de POs

#Levantamos el archivo
my $ot = Locale::PO->load_file_asarray($output_po);
 @outLines=@$ot;
# my $i=0;
#     while ($i<@outLines)
#     {  print $outLines[$i]->msgid()." \n";
#         $i++;
#     }

#Procesamos
find (\&process, $directory);

#Salvamos el po
Locale::PO->save_file_fromarray($output_po,\@outLines);

# open( OUT, ">>$output_po" ) or return undef;
# foreach (@outLines)  { print OUT $_->dump();}
# close OUT;

undef( @outLines );

sub trim
{
 my ($string)=@_;
$string =~ s/^\s+//;
$string =~ s/\s+$//;
return $string;
}

sub process
{
    my $line;      #Linea leida.
    my @matches;
    #Buscamos solo los  .tmpl
    if (( $File::Find::name =~ /\.tmpl$/ ) or( $File::Find::name =~ /\.inc$/)) {
	print "Procesando $File::Find::name\n";
        open (FILE, $File::Find::name ) or die "No se pudo abrir el archivo: $!";

        while ( $line = <FILE> ) {
	@matches = ($line =~ /\[%\s*['"]*\s*([^{",\|,'}]*)\s*['"]*\s*\|\s*i18n\s*%]/g);
	foreach my $m (@matches)
	{
	my $str=&trim($m);
	my $exists=0;
 	my $po = new Locale::PO();
 	$po->msgid($str);
       	$po->msgstr("");
       	$po->comment("$File::Find::name");
	
	#Reviso si no existe!!!
	my $i=0;
	while ($i<@outLines)
  	{	if ($outLines[$i]->msgid() eq $po->msgid()) {
			$exists=1; 
 			print $outLines[$i]->msgid()." ya existe \n";
		}
		$i++;
	}
	 if($exists == 0){ push(@outLines, $po);}
	}
        }
        close FILE;
    }
    elsif ( $File::Find::name =~ /\.pm$/) {

     print "Procesando PM $File::Find::name\n";
     open (FILE, $File::Find::name ) or die "No se pudo abrir el archivo: $!";

        while ( $line = <FILE> ) {
    @matches = ($line =~ /i18n\(['"]*\s*([^{",\|,'}]*)\s*['"]\)/g);
    foreach my $m (@matches)
    {
    my $str=&trim($m);
    my $exists=0;
    my $po = new Locale::PO();
        $po->msgid($str);
        $po->msgstr("");
        $po->comment("$File::Find::name");

    print "MATCH PM $str\n";

    #Reviso si no existe!!!
    my $i=0;
    while ($i<@outLines)
    {   if ($outLines[$i]->msgid() eq $po->msgid()) {
            $exists=1; 
            print $outLines[$i]->msgid()." ya existe PM\n";
        }
        $i++;
    }
     if($exists == 0){ push(@outLines, $po);}
    }
    }
        close FILE;
    }
}
