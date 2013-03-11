#/bin/bash
apt-get update -y
apt-get install apache2 mysql-server libpdf-report-perl libhtml-template-expr-perl  libhtml-template-perl libnet-ldap-perl libdbd-mysql-perl libmail-sendmail-perl libmarc-record-perl libgd-gd2-perl libarchive-zip-perl libapache2-mod-perl2 libapache-db-perl libooolib-perl libpdf-report-perl  libchart-perl libtemplate-perl libnet-amazon-perl libnet-z3950-zoom-perl  aspell-es libtext-aspell-perl libnet-smtp-ssl-perl libspreadsheet-writeexcel-perl htmldoc libyaml-dev libcaptcha-recaptcha-perl libemail-mime-encodings-perl libproc-simple-perl libjson-perl libjson-xs-perl librose-db-perl librose-db-object-perl sphinxsearch libsphinx-search-perl libdigest-sha-perl libcrypt-cbc-perl libtext-levenshtein-perl  libnet-smtp-tls-perl libnet-ssleay-perl libnet-twitter-perl libwww-facebook-api-perl libspreadsheet-read-perl libyaml-perl libcgi-session-perl libdate-manip-perl liblocale-maketext-gettext-perl libspreadsheet-writeexcel-perl libfile-libmagic-perl libhttp-browserdetect-perl libtext-unaccent-perl libmarc-crosswalk-dublincore-perl libmarc-xml-perl libimage-size-perl  libdatetime-format-mysql-perl libfile-libmagic-perl libxml-checker-perl libdbix-xml-rdb-perl libdbi-perl libmoosex-types-perl libtest-compile-perl libwww-shorten-perl -y

# MUCHOS ESTAN EN SQUEEZE!!!
#apt-get install libjson-perl libjson-xs-perl librose-db-perl librose-db-object-perl sphinxsearch libsphinx-search-perl libdigest-sha-perl libcrypt-cbc-perl libtext-levenshtein-perl  libnet-smtp-tls-perl libnet-ssleay-perl libnet-twitter-perl libwww-facebook-api-perl libspreadsheet-read-perl libyaml-perl -y

#apt-get install libcgi-session-perl libdate-manip-perl liblocale-maketext-gettext-perl libspreadsheet-writeexcel-perl libfile-libmagic-perl -y
#apt-get install libhttp-browserdetect-perl libtext-unaccent-perl -y
#apt-get install libmarc-crosswalk-dublincore-perl libmarc-xml-perl -y
#apt-get install libimage-size-perl -y
#apt-get install libdatetime-format-mysql-perl -y
#apt-get install libfile-libmagic-perl -y
#apt-get install libxml-checker-perl -y
#apt-get install libdbix-xml-rdb-perl -y
#apt-get install libdbi-perl -y
#apt-get install libmoosex-types-perl libtest-compile-perl -y
# OTROS AUN NO!!!
apt-get install make gcc -y
cpan -i CPAN 
cpan -i Bundle::CPAN
cpan -i YAML
cpan -i MIME::Lite::TT::HTML
cpan -i Spreadsheet::WriteExcel::Simple
cpan -i Sphinx::Manager
cpan -i Image::Resize
cpan -i Text::LevenshteinXS
cpan -i Chart::OFC2
cpan -i WWW::Shorten::Bitly
cpan -i HTML::HTMLDoc
cpan -i MARC::File::XML
cpan -i DateTime::Format::DateManip
cpan -i WWW::Google::URLShortener
cpan -i Apache::Session::Lock::Semaphore
cpan -i Moose
cpan -i Date::Manip

# ESTA DA ERROR AUN EN SQUEEZE (anda la 0.18) bajarla y compilar a mano ==>  http://search.cpan.org/CPAN/authors/id/F/FR/FREDERICD/marc-moose-0.018.tar.gz
cpan -i MARC::Moose::Record


