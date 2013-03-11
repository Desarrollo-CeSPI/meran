create database reemplazarDATABASE;
grant all on reemplazarDATABASE.* to reemplazarUSER@localhost identified by 'reemplazarPASS';
use reemplazarDATABASE;
grant select on reemplazarDATABASE.indice_busqueda to reemplazarIUSER@localhost identified by 'reemplazarIPASS';
