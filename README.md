MERAN UNLP
================================


MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog, Circulation and User's Management.
It's written in Perl, and uses Apache2 Web-Server, MySQL database and Sphinx 2 indexing.


Quick start
-----------

Clone the repo, `git clone git@github.com:Desarrollo-CeSPI/meran.git`

Installation
------------

You can install MERAN it three ways:

1. With the Installer (Sandboxed)
2. Directly from the sources
3. Combined (Sandbox for modules, and sources)


*It's mandatory to install MERAN in Debian Squeeze (6.0), other distributions of Linux are unsupported.*


1) Installer
------------

Once that you have cloned the repo, go to MERAN_REPO/docs/generacionInstalador.

```
chmod +x instalar.pl
./instalar -i MERAN_ID
```

And follow the steps. MERAN_ID it's an identifier for the installation, since you can have multiples MERAN installed.

2) Directly from the sources
----------------------------

This type of installation is for advanced users.

Once that you have cloned the repo, go to MERAN_REPO/docs/dependenciasInstalacion

```
chmod +x INSTALAR_MERAN.pl
./INSTALAR_MERAN.pl
```
