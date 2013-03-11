#!/bin/sh
echo "Agregar en el Virtualhost que corresponda que van a trabajar";
echo "Alias /dev-plugins/ /usr/share/meran/dev-plugins/";
echo "<Directory /usr/share/meran/dev-plugins/>";
echo "Options  -Indexes";
echo "Order allow,deny";
echo "Allow from all"
echo "</Directory>";

sed 's/<link rel="stylesheet" type="text\/css" href="\[% temas %\]\/default\/includes\/intranet.css">/<link rel="stylesheet\/less" href="\/dev-plugins\/bootstrapless\/meran.less"><script src="\/dev-plugins\/less-1.3.0.min.js"><\/script>/g' /usr/share/meran/intranet/htdocs/intranet-tmpl/includes/intranet-top.inc > prueba.inc
mv prueba.inc /usr/share/meran/intranet/htdocs/intranet-tmpl/includes/intranet-top.inc
