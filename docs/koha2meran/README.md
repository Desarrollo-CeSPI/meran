Migrar Koha a Meran:
================================

Los scripts de migración se encuentran en el respositorio de github de meran: https://github.com/Desarrollo-CeSPI/meran
Dentro de la carpeta docs/koha2meran/ hay 2 scripts que de deben correr en una máquina con Koha para transformar la base a Meran:
    * koha2meran.pl 
    * koha2meran-2do-paso.pl

koha2meran.pl:
--------------

Ejecuta sin tener ORM, solo con la conexión a la base de Koha.

Las tareas que se realizan son:

1. Creando tablas necesarias.
2. Creando nuevas referencias.
3. Modificando ciudades y Agregando ciudades inexistentes.
4. Procesar el catálogo y convertirlo de Koha a Meran (Este es el paso más importante).
5. Renombrar tablas a las utilizadas en Meran.
6. Quitar tablas de mas.
7. Hashear passwords de los usuarios para que sea comaptible con las passwords utilizadas en Meran.
8. Limpiamos las tablas de circulacion.
9. Reparar las referencias de usuarios en circulacion.
10. Reparar relacion usuario-persona.
11. Crear nuevas claves foraneas.
12. Creando la estructura MARC.
13. Traducción Estructura MARC.
14. Agregando preferencias del sistema.
15. Procesandoe Analíticas.
16. Cambiar base a codificación a UTF8.
17. Aplicar las actualizaciones de Meran hasta el final.


koha2meran-2do-paso.pl
----------------------
Ejecuta con ORM (Rose::DB) y realiza las tareas finales.

1. Dar Permisos a Usuarios.
2. Reparar Templates del Catálogo.
3. Volver a Bajar las Portadas de los Registros.
4. Generar Indice.
