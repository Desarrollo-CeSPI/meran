#!/usr/bin/perl
use C4::Context;
use CGI::Session;

my $base = C4::Context->config('database');

my $dbh = C4::Context->dbh;
my @tables = $dbh->tables;

my $sql_base = "ALTER DATABASE $base DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;";
my $sth0=$dbh->prepare($sql_base);
   $sth0->execute();

foreach my $table (@tables){
	my @t = split(/\./,$table);
	chop($t[1]);
	my $tabla=substr($t[1],1);

	my $sql_tabla = "ALTER TABLE $tabla CONVERT TO CHARACTER SET utf8;";
  	my $sth1=$dbh->prepare($sql_tabla);
  	$sth1->execute();

	my $desc = $dbh->selectall_arrayref("DESCRIBE $tabla", { Columns=>{} });
  	foreach my $row (@$desc) {
       		my $tipo = $row->{'Type'};
       		my $columna = $row->{'Field'};
		if(($tipo =~ m/char/) || ($mystring =~ m/text/)){
			my $sql_columna1="ALTER TABLE $tabla CHANGE $columna $columna BLOB;";
			my $sth2=$dbh->prepare($sql_columna1);
  			$sth2->execute();

			my $sql_columna2="ALTER TABLE $tabla CHANGE $columna $columna $tipo CHARACTER SET utf8 COLLATE utf8_general_ci ;";
			my $sth3=$dbh->prepare($sql_columna2);
  			$sth3->execute();
		}
   	}
}
