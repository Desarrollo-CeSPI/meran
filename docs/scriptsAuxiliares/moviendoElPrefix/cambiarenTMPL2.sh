#!/bin/sh
for i in $(cat templates); do 
	echo "reemplazando espacios en $i"
	sed 's/\"\[\% url_prefix \%\]\/koha/\"\[\% url_prefix \%\]/g'  $i > /tmp/a 
	sed "s/'\[\% url_prefix \%\]\/koha/'\[\% url_prefix \%\]/g"  /tmp/a >/tmp/aa 
	#sed 's/\"\/cgi-bin\/koha/\"\[\% url_prefix \%\]/g'  $i > /tmp/a 
	#sed "s/'\/cgi-bin\/koha/'\[\% url_prefix \%\]/g"  /tmp/a > /tmp/aa 
	cp /tmp/aa  $i
done;
