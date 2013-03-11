#!/bin/sh
if [ $(uname -a|grep amd64|wc -l) -gt 0 ]
	then 
		 PATH=$PATH:$(pwd)/node64/bin/;
	else
		 PATH=$PATH:$(pwd)/node/bin/;
fi;
export PATH;
npm install -g less uglify-js
