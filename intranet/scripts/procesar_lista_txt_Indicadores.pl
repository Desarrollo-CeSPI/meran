#!/usr/local/perl
sub trim($)
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

open(DATOS,'ecadlist.txt');
my %datos;
my $campo;
while(<DATOS>){
    chomp; 
    if ($_ =~ m/Indicators/ ){
        my $line=$_;
        while((!($line =~ m/Subfield Codes/))&&($line)){
            $line=<DATOS>;
            chomp($line);
            #print "Indicators.$line";
            if ($line =~ m/First/){
                $datos{$campo}->{"FIRST"}->{'descripcion'}= trim((split('-',$line))[1]) ;
                #print  $datos{$campo}->{"FIRST"};
                $line=<DATOS>;
                chomp($line);
                while ((!($line =~ m/Second/))&&($line)){
          my @dato=split('-',$line);
          $datos{$campo}->{"FIRST"}->{'elementos'}->{trim($dato[0])}=trim($dato[1]);
          $line=<DATOS>;
          chomp($line);
      } 
      $datos{$campo}->{"SECOND"}->{'descripcion'}=trim((split('-',$line))[1]);
      $line=<DATOS>;
      chomp($line);

      while((!($line =~ m/Subfield Codes/))&&($line)){
          my @dato=split('-',$line);
          $datos{$campo}->{"SECOND"}->{'elementos'}->{trim($dato[0])}=trim($dato[1]);
          $line=<DATOS>;
          chomp($line);
          #print $campo;
      }
      while((!($line eq "\n"))&&($line)){
          $line=<DATOS>;
          chomp($line);


      }
      }	

  }

  }
  else{ if (substr($_,0,1) =~ m/[0-9]/ ){
          $campo= substr($_,0,3);
          }
  }
}
while ( my ($key, $value) = each(%datos) ) {
    print "UPDATE pref_estructura_campo_marc set indicadorPrimario=".'"'.$value->{"FIRST"}->{'descripcion'}.'"'.", IndicadorSecundario=".'"'.$value->{"SECOND"}->{'descripcion'}.'"'." where campo=".$key.";\n";
    
    # print "campo".$key."\n";
    #print "descripcion del first".($value->{"FIRST"}->{'descripcion'})."\n";

    my $first=$value->{"FIRST"}->{'elementos'};
    while ( my ($keyF, $valueF) = each(%$first) ){
        print "INSERT into pref_indicadores_primarios (indicador,dato, campo_marc) values (".'"'.$keyF.'"'.",".'"'.$valueF.'"'.",".$key.");\n"}
    #print "descripcion del second".$value->{"SECOND"}->{'descripcion'}."\n";
    my $second=$value->{"SECOND"}->{'elementos'};
    while ( my ($keyS, $valueS) = each(%$second) ) {
    #print "Indicador ".$keyS." es igual a ".$valueS."\n";}
        print "INSERT into pref_indicadores_secundarios (indicador,dato, campo_marc) values  (".'"'.$keyS.'"'.",".'"'.$valueS.'"'.",".$key.");\n"}

}
