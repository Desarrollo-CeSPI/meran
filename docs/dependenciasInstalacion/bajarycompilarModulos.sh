#!/bin/bash
#rm -fr  modulos/*
#cd modulos
#sh ../meranJaula.sh
#cd ..
export PERL5LIB=/home/einar/meran/intranet/modules/externos/lib/perl5/:/home/einar/meran/intranet/modules/externos/usr/local/lib/perl5/site_perl/ 
for i in $(ls modulos|grep -v tar.gz); do 
	cd modulos/$i;
	perl Makefile.PL `cat ../../PREFIX`
	make
	make test
    echo "¿Termino bien el test?"
    select OPCION in 'Si' 'No'
    do
    case $OPCION in
      Si)
        make install
        echo "¿Termino bien la instalacion?"
        select OPCION in 'Si' 'No'
        do
            case $OPCION in
              Si)
              cd $OLDPWD
              rm -fr modulos/$i
              break;;
              No)	  
              echo "no termino bien"
              cd $OLDPWD
              break;;
            esac
        done
        break;;
      No)	  
      echo "no termino bien"
      cd $OLDPWD
      break;;
    esac
    done
	
done; 

