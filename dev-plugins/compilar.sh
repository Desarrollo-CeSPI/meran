#!/bin/sh
if [ $(uname -a|grep amd64|wc -l) -gt 0 ]
	then 
		 PATH=$PATH:$(pwd)/node64/bin/;
	else
		 PATH=$PATH:$(pwd)/node/bin/;
fi;
if [ $# -eq 0 ] 
	then
		TEMA="default";
	else
		TEMA=$1;
	fi
	
export PATH;
cd bootstrapless/opac/$TEMA/
mkdir temp
cp ../../*.less temp/
for i in $(cat meranFiles.less); do cp $i temp/; done;
cp meran.less temp/
OLD=$OLDPWD
cd temp
lessc --compress meran.less > $OLD/../opac/htdocs/opac-tmpl/temas/$TEMA/includes/opac.css
cd ..
rm temp -fr
cd $OLD
##Cuando se hagan los temas para las distintas bibliotecas para la intranet esta #asignacion variable TEMA debe borrars
TEMA="default";
##Hasta aca
#
cd bootstrapless/intranet/$TEMA/ 
mkdir temp
cp ../../*.less temp/
for i in $(cat meranFiles.less); do cp $i temp/; done;
cp meran.less temp/
OLD=$OLDPWD
cd temp
lessc --compress meran.less > $OLD/../intranet/htdocs/intranet-tmpl/temas/$TEMA/includes/intranet.css
cd ..
rm temp -fr
cd $OLD
