#!/usr/bin/perl


use CGI::Session;
use CGI;

my $input = new CGI;
my $session = CGI::Session->load();

use Chart::OFC2;
use Chart::OFC2::Axis;
use Chart::OFC2::Pie;
use C4::AR::Reportes;


my $params = $input->Vars;
my ($tipos_item,$colours,$cantidad) = C4::AR::Reportes::getConsultasOPAC($params);


    
my $chart = Chart::OFC2->new(
    'title'  => C4::AR::Filtros::i18n('Consultas al OPAC'),
    x_axis => {
      labels => {
          labels => [@$tipos_item],
      }
    },
);

my $tip = '#val# '.C4::AR::Filtros::i18n('of').' #total#<br>#percent# '.C4::AR::Filtros::i18n('of').' 100%';

my $chart_type = Chart::OFC2::Pie->new(
    tip          => $tip,
);

$chart_type->values([@$cantidad]);
$chart_type->values->labels([@$tipos_item]);
$chart_type->values->colours([@$colours]);

$chart->add_element($chart_type);
# $chart->set_y_axis($y_axis);
print $session->header();
print $chart->render_chart_data();
