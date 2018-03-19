#!/bin/bash

sed s/reemplazarID/$(escaparVariable $ID)/g $sources_MERAN/logrotate.d-meran > /etc/logrotate.d/logrotate.d-meran$ID