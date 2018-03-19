#!/bin/bash

crontab -l >/tmp/$ID.crontab

echo "
			0 7 * * *    export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/recordatorio_prestamos_vto.pl 2>&1
			0 * * * *    export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/mail_prestamos_vencidos.pl  2>&1
			* * * * *    export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/procesarColaZ3950.pl  2>&1
			* * * * *    export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/reindexar.pl 2>&1
			0 0 * * *    export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/obtener_portadas_de_registros.pl  2>&1
			0 0 * * 6    export MERAN_CONF=$CONFIGURACION_MERAN/meran$ID.conf; cd $DESTINO_MERAN/$ID/intranet/modules/ ; perl ../cgi-bin/cron/generar_indice.pl  2>&1" >>/tmp/$ID.crontab

crontab /tmp/$ID.crontab