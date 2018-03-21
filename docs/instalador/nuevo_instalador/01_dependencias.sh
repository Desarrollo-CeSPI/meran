#!/bin/bash

apt-get install apache2 \
mysql-server \
libapache2-mod-perl2 \
libxpm4 \
htmldoc \
libaspell15 \
ntpdate \
libhttp-oai-perl \
libxml-sax-writer-perl \
libxml-libxslt-perl \
libyaml-perl \
sphinxsearch \
libcgi-session-perl \
librose-db-perl \
libsphinx-search-perl \
build-essential \



cpan -i Sphinx:Manager
