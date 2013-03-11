#!/bin/sh
for i in $(cat jsss); do 
	echo "reemplazando espacios en $i"
#	sed 's/\"\[\% url_prefix \%\]\/koha/\"\[\% url_prefix \%\]/g'  $i > /tmp/a 
#	sed "s/'\[\% url_prefix \%\]\/koha/'\[\% url_prefix \%\]/g"  /tmp/a >/tmp/aa 
	sed 's/\"URL_PREFIX/URL_PREFIX\+\"/g'  $i > /tmp/a 
	sed "s/'URL_PREFIX/URL_PREFIX\+'/g"  /tmp/a > /tmp/aa 
	cp /tmp/aa  $i
done;
