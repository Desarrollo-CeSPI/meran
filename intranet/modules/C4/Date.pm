package C4::Date;

use strict;
#EINAR use C4::Context;

use Date::Manip;
use C4::AR::Preferencias;

require Exporter;

use vars qw($VERSION @ISA @EXPORT %EXPORT_TAGS);

$VERSION = 0.01;

@ISA = qw(Exporter);

@EXPORT = qw(
    display_date_format
    format_date
    format_date_hour
    format_date_in_iso
	updateForHoliday
    updateForNonHoliday
    calc_beginES
    calc_endES
    proximosHabiles
    mesString
    UnixDate
    getCurrentTimestamp
    get_date_format
    format_date_complete
    esHabil
);

sub get_date_format
{
	#Get the database handle
	return (C4::AR::Utilidades::trim(C4::AR::Preferencias::getValorPreferencia('dateformat'))||'metric');
}

sub esHabil{
    my ($date) = @_;
    use Date::Manip::Date;
    my $date_manip = new Date::Manip::Date;
     
    $date_manip->parse($date);
    
    return $date_manip->is_business_day;
	
}

sub display_date_format
{
# 	my $dateformat = get_date_format();
	my ($dateformat)=@_;

	if ( $dateformat eq "us" )
	{
		return "mm/dd/aaaa";
	}
	elsif ( $dateformat eq "metric" )
	{
		return "dd/mm/aaaa";
	}
	elsif ( $dateformat eq "iso" )
	{
		return "aaaa-mm-dd";
	}
	else
	{
		return "Invalid date format: $dateformat. Please change in system preferences";
	}
}

# Miguel - cambie esta funcion para que no se llame dentro get_date_format, idem format_date_hour format_date_in_iso, display_date_format
sub format_date
{

	my ($olddate, $dateformat)=@_;

	my $newdate;

	if ( ! $olddate )
	{
		return "";
	}

	if ( $dateformat eq "us" )
	{
		Date_Init("DateFormat=US");
		$olddate = ParseDate($olddate);
		$newdate = UnixDate($olddate,'%m/%d/%Y');
	}
	elsif ( $dateformat eq "metric" )
	{
		Date_Init("DateFormat=metric");
		$olddate = ParseDate($olddate);
		$newdate = UnixDate($olddate,'%d/%m/%Y');
	}
	elsif ( $dateformat eq "iso" )
	{
		Date_Init("DateFormat=iso");
		$olddate = ParseDate($olddate);
		$newdate = UnixDate($olddate,'%Y-%m-%d');
	}
	else
	{
		return "Invalid date format: $dateformat. Please change in system preferences";
	}
}

sub format_date_complete
{
    my ($olddate, $dateformat)=@_;

    my $newdate;

    if ( ! $olddate )
    {
        return "";
    }

    if ( $dateformat eq "us" )
    {
        Date_Init("DateFormat=US");
        $olddate = ParseDate($olddate);
        $newdate = UnixDate($olddate,'%m/%d/%Y %H:%M:%S');
    }
    elsif ( $dateformat eq "metric" )
    {
        Date_Init("DateFormat=metric");
        $olddate = ParseDate($olddate);
        $newdate = UnixDate($olddate,'%d/%m/%Y %H:%M:%S');
    }
    elsif ( $dateformat eq "iso" )
    {
        Date_Init("DateFormat=iso");
        $olddate = ParseDate($olddate);
        $newdate = UnixDate($olddate,'%Y-%m-%d %H:%M:%S');
    }
    else
    {
        return "Invalid date format: $dateformat. Please change in system preferences";
    }
}


sub format_date_hour
{
	my ($olddate, $dateformat)=@_;

	my $newdate;

	if ( ! $olddate )
	{
		return "";
	}

	if ( $dateformat eq "us" )
	{
		Date_Init("DateFormat=US");
		$olddate = ParseDate($olddate);
		$newdate = UnixDate($olddate,'%m/%d/%Y %H:%M');
	}
	elsif ( $dateformat eq "metric" )
	{
		Date_Init("DateFormat=metric");
		$olddate = ParseDate($olddate);
		$newdate = UnixDate($olddate,'%d/%m/%Y %H:%M');
	}
	elsif ( $dateformat eq "iso" )
	{
		Date_Init("DateFormat=iso");
		$olddate = ParseDate($olddate);
		$newdate = UnixDate($olddate,'%Y-%m-%d %H:%M');
	}
	else
	{
		return "Invalid date format: $dateformat. Please change in system preferences";
	}
}

sub calc_beginES
{
	my $close = C4::AR::Preferencias::getValorPreferencia("close");
	my $beginESissue = C4::AR::Preferencias::getValorPreferencia("beginESissue");
	my $err;
	my  $time = ParseDate($close);
	my $hour = DateCalc($close,"- $beginESissue minutes",\$err);	
	return $hour;
}


sub calc_endES
{
	my $open = C4::AR::Preferencias::getValorPreferencia("open");
	my $endESissue = C4::AR::Preferencias::getValorPreferencia("endESissue");
	my $err;
	my  $time = ParseDate($open);
	my $hour = DateCalc($open,"+ $endESissue minutes",\$err);
			      
	return $hour;
}




sub format_date_in_iso
{
	my ($olddate, $dateformat)=@_;
    my $newdate;
   
    if ( ! $olddate )
    {
            return "";
    }

    if ( $dateformat eq "us" )
    {
            Date_Init("DateFormat=US");
            $olddate = ParseDate($olddate);
    }
    elsif ( $dateformat eq "metric" )
    {
            Date_Init("DateFormat=metric");
            $olddate = ParseDate($olddate);
    }
    elsif ( $dateformat eq "iso" )
    {
            Date_Init("DateFormat=iso");
            $olddate = ParseDate($olddate);
    }
    else
    {
            return "9999-99-99";
    }

	$newdate = UnixDate($olddate, '%Y-%m-%d');

	return $newdate;
}

sub updateForHoliday{
#Recibe una fecha que es la que se puso o se saco como feriado
#Si $sign es "+" entonces se puso como feriado
#Si $sign es "-" entonces se saco como feriado
#Este procedimiento actualiza las fechas que corresponden cuando se setea/dessetea un feriado
	my ($fecha,$sign)= @_;
	my $err= "Error con la fecha";
	my $dateformat = C4::Date::get_date_format();

	my $fecha_nueva_inicio = C4::Date::format_date_in_iso(DateCalc($fecha,"$sign 1 business days",\$err),$dateformat);
	my $daysOfSanctions= C4::AR::Preferencias::getValorPreferencia("daysOfSanctionReserves");
	my $fecha_nueva_fin = C4::Date::format_date_in_iso(DateCalc($fecha_nueva_inicio,"+ $daysOfSanctions days",\$err),$dateformat);
	my $dbh = C4::Context->dbh;

	my $sth = $dbh->prepare("update circ_sancion set startdate=?, enddate=? where sanctiontypecode is null and startdate = ?");

	$sth->execute($fecha_nueva_inicio,$fecha_nueva_fin,$fecha);
}


sub proximosHabiles {
	my ($cantidad,$todosHabiles,$desde)=@_;
	my $apertura               =C4::AR::Preferencias::getValorPreferencia("open");
	my $cierre                 =C4::AR::Preferencias::getValorPreferencia("close");
	my $first_day_week         =C4::AR::Preferencias::getValorPreferencia("primer_dia_semana");
	my $last_day_week          =C4::AR::Preferencias::getValorPreferencia("ultimo_dia_semana");
	my ($actual,$min,$hora)    = localtime;
	
	$actual=($hora).':'.$min;
	Date_Init("WorkDayBeg=".$apertura,"WorkDayEnd=".$cierre);
    Date_Init("WorkWeekBeg=".$first_day_week,"WorkWeekEnd=".$last_day_week);

	my $err= "Error con la fecha";
	my $hoy= ParseDate("today");

    $desde= ($desde || $hoy);

	my $hasta;

	if ($todosHabiles) {
		#esto es si todos los dias del periodo deben ser habiles
        #Los dias Habiles se contolan desde el archivo .DateManip.pm que lee el modulo Date.pm, habria que ver como esquematizarlo
        #OLD WAY anda mejor con 		Date_NextWorkDay
		#$hasta=DateCalc($desde,"+ ".$cantidad. " days",\$err,2);
		$hasta = $desde;
# 		C4::AR::Debug::debug("********** HASTA ANTES DEL CALCULO ".$hasta);
		for (my $iter_habil = 1; $iter_habil <= $cantidad; $iter_habil++ ){
			$hasta = DateCalc($hasta,"+ 1 business days",\$err);
		}
	}else{
        #esto es si no importa quetodos los dias del periodo sean habiles, los que deben ser habiles son el 1ero y el ultimo		
		$hasta = DateCalc($desde,"+ ".$cantidad. " days",\$err);
	    if (!esHabil($hasta)){
	        $hasta = Date_NextWorkDay($hasta);
	    } 
	}
	#Se sume un dia si es feriado el ultimo dia.
	my $dateformat= C4::Date::get_date_format();
	$hasta = C4::Date::format_date_in_iso($hasta, $dateformat);
	
	my $proximos_feriados = C4::AR::Utilidades::getProximosFeriados($hasta);
	
	foreach my $feriado (@$proximos_feriados) {
# 		C4::AR::Debug::debug("_______________________________________ HASTA __________________________________ ".C4::Date::format_date($hasta,$dateformat));
# 		C4::AR::Debug::debug("_______________________________________FERIADO______________________________ ".$feriado->getFecha);
		if( C4::Date::format_date($hasta,$dateformat) eq $feriado->getFecha ) {
			$hasta=DateCalc($hasta,"+ 1 business days",\$err);
# 			C4::AR::Debug::debug("_______________________________________ SUMA 1!!! __________________________________ ");
		}
	}
    
    $desde = C4::Date::format_date_in_iso($desde, $dateformat);
    $hasta = C4::Date::format_date_in_iso($hasta, $dateformat);
    
#     C4::AR::Debug::debug("_______________________________________DESDE __________________________________ ".$desde);
#     C4::AR::Debug::debug("_______________________________________HASTA CANT______________________________ ".$cantidad);
#     C4::AR::Debug::debug("_______________________________________HASTA___________________________________ ".$hasta);

    return (	$desde,
                $hasta,
                $apertura,
                $cierre
	);
}

sub mesString{
	my ($mes)=@_;
	
	if ($mes eq "1") {$mes=C4::AR::Filtros::i18n('Enero')}
	elsif ($mes eq "2") {$mes=C4::AR::Filtros::i18n('Febrero')}
	elsif ($mes eq "3") {$mes=C4::AR::Filtros::i18n('Marzo')}
	elsif ($mes eq "4") {$mes=C4::AR::Filtros::i18n('Abril')}
	elsif ($mes eq "5") {$mes=C4::AR::Filtros::i18n('Mayo')}
	elsif ($mes eq "6") {$mes=C4::AR::Filtros::i18n('Junio')}
	elsif ($mes eq "7") {$mes=C4::AR::Filtros::i18n('Julio')}
	elsif ($mes eq "8") {$mes=C4::AR::Filtros::i18n('Agosto')}
	elsif ($mes eq "9") {$mes=C4::AR::Filtros::i18n('Septiembre')}
	elsif ($mes eq "10") {$mes=C4::AR::Filtros::i18n('Octubre')}
	elsif ($mes eq "11") {$mes=C4::AR::Filtros::i18n('Noviembre')}
	elsif ($mes eq "12") {$mes=C4::AR::Filtros::i18n('Diciembre')};
	return ($mes);
}

sub diaString{
    my ($dia)=@_;
    
    if ($dia eq "0") {$dia=C4::AR::Filtros::i18n('Domingo')}
    elsif ($dia eq "1") {$dia=C4::AR::Filtros::i18n('Lunes')}
    elsif ($dia eq "2") {$dia=C4::AR::Filtros::i18n('Martes')}
    elsif ($dia eq "3") {$dia=C4::AR::Filtros::i18n('Miercoles')}
    elsif ($dia eq "4") {$dia=C4::AR::Filtros::i18n('Jueves')}
    elsif ($dia eq "5") {$dia=C4::AR::Filtros::i18n('Viernes')}
    elsif ($dia eq "6") {$dia=C4::AR::Filtros::i18n('S&aacute;bado')}

    return ($dia);
}

sub getCurrentTimestamp {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
	my $timestamp = sprintf ("%4d-%02d-%02d %02d:%02d:%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec);
	return $timestamp;
}
1;
