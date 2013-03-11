#!/usr/bin/perl

use CGI::Session;
use CGI;

my $input = new CGI;
my $session = CGI::Session->load();

use Chart::OFC2;
use Chart::OFC2::Pie;
use C4::AR::Reportes;


my $params = $input->Vars;
my ($tipos_item,$colours,$cantidad) = C4::AR::Reportes::getItemTypes($params);


C4::AR::Utilidades::printARRAY($tipos_item);


my $chart = Chart::OFC2->new(
    'title'  => C4::AR::Filtros::i18n('Colecciones'),
    x_axis => {
        labels => {
            labels => [@$tipos_item],
        }
    },
);

my $tip = '#val# '.C4::AR::Filtros::i18n('of').' #total#<br>#percent# '.C4::AR::Filtros::i18n('of').' 100%';

my $chart_pie = Chart::OFC2::Pie->new(
    tip          => $tip,
);

$chart_pie->values([@$cantidad]);
$chart_pie->values->labels([@$tipos_item]);
$chart_pie->values->colours([@$colours]);

$chart->add_element($chart_pie);

print $session->header();
print $chart->render_chart_data({'wmode' => 'opaque'});
