create database reemplazarDATABASE;
grant all on reemplazarDATABASE.* to reemplazarUSER@reemplazarHOST identified by 'reemplazarPASS';
use reemplazarDATABASE;
grant select on reemplazarDATABASE.indice_busqueda to reemplazarIUSER@reemplazarHOST identified by 'reemplazarIPASS';
