#!/bin/sh
chown -R www-data.www-data $1/intranet/htdocs/intranet-tmpl/blue/es2/pictures/
chown -R www-data.www-data $1/intranet/htdocs/intranet-tmpl/blue/es2/images/
chown -R www-data.www-data $1/intranet/cgi-bin/reports/plantillas/
chown -R www-data.www-data $1/intranet/htdocs/intranet-tmpl/blue/es2/includes/xslt/
find $1 -name *.pl | xargs chmod o+x 