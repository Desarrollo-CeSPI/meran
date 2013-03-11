package XMLDBI;
use DBI qw/:sql_types/;
# use XML::Parser;
use XML::Checker::Parser;

use vars qw(@ISA @EXPORT $table $dbh $sth @col_vals);

# @ISA= ("XML::Parser");
@ISA= ("XML::Checker::Parser");

sub IsNumber {
    my ($value) = @_;

    return ($value =~ /^-?(?:\d+(?:\.\d*)?|\.\d+)$/); # Regexp taken from the perlfaq4
}

sub new {
    my($proto) = shift @_;
    my($class) = ref($proto) || $proto;
    # C4::AR::Debug::debug("averrr : " . @_); die();
    my($self) = $class->SUPER::new(@_);

    my $driver = shift;
    my $datasource = shift;
    my $userid = shift;
    my $passwd = shift;
    $table = shift; # Not sure if we want to limit to individual tables yet
    my $dbname = shift;

    bless($self, $class);
    $self->setHandlers('Start' => $self->can('Start'),
                        'Init' => $self->can('Init'),
                        'End'  => $self->can('End'),
                        'Char' => $self->can('Char'),
                        'Proc' => $self->can('Proc'),
                        'Final' =>$self->can('Final'),
                        );

    # Setup the DB Connection

    $dbh = DBI->connect("dbi:$driver:$datasource", $userid, $passwd, { AutoCommit => 0 }) or die "Can't connect to datasource";
    if ($dbname) {
        $dbh->do("use $dbname") || die $dbh->errstr;
    }

    return($self);
}

sub execute {
    my ($self, $sql) = @_;

    eval{
        C4::AR::Debug::debug("entro al evaaaaaaaaaaaaaaaaaaaaal");
       $dbh->do($sql);
       C4::AR::Debug::debug("paso el do");
    };
    if($@){
        C4::AR::Debug::debug("entro al rollbacjkkkkkkkkkkkk------------------");
        $dbh->rollback;
        die $@;
    }

    C4::AR::Debug::debug("fin del execute");
}

sub Init {
    my $expat = shift;

    # OK, here we setup the insert statement.
    # We use the prepare method because it offers us _very_ fast inserts.

    $sth = $dbh->prepare("select * from $table where 1=2") || die $dbh->errstr;
    $sth->execute() || die $dbh->errstr; # Get column names
    my $names = $sth->{NAME};

    #por los acentos 
    $dbh->do('SET CHARACTER SET "utf8"');

    my $sql = "insert into $table ( " . (join ", ", @$names) . " ) values ( ";
    my $colnum = 1;
    eval {
        $sql .= (join ", ",
                    (map {
                            $expat->{ __PACKAGE__ . "columns"}->{uc($_)} = $colnum++;
                            '?';
                        } @{$names})
                );
        };
    if ($@) {
        $dbh->rollback;
        die $@;
    }

    $sql .= " )";
#   print $sql, "\n\n";

    $sth = $dbh->prepare($sql) || die;

#   my $count = 1;
#   foreach my $f (keys(%{$expat->{ __PACKAGE__ . "columns"}})) {
#       $sth->bind_param( $count++ , undef );
#   }

    # Possibly add begin transaction code here.
    C4::AR::Debug::debug("en el prepareee");
}

sub Start {
    my ($expat, $element, %attrs) = @_;
    C4::AR::Debug::debug("en el start expat " . $expat);
    C4::AR::Debug::debug("en el start element " . $element);
    C4::AR::Debug::debug("en el start attrs " . %attrs);

    # Structure goes: DSN->Table->Column
    if ($expat->within_element("ROW")) {
        # OK, got a column, reset the data within that column
        undef $expat->{ __PACKAGE__ . "currentData"};
    }
    C4::AR::Debug::debug("en el start");
}

sub _rollBack{

    C4::AR::Debug::debug("entro a rollbackkkkk !!!!!!!!!!!!!!!!!!!!!!!");
    $sth->rollback;

    die();
}

sub End {
    my ($expat, $element) = @_;
    C4::AR::Debug::debug("elemento del end " . $element);
    if ($element eq "ROW") {

        # Found the end of a row
        # print "Inserting a row...\n";
                shift @col_vals;

                #kip: handy for debugging.
                #DBI->trace(5);
        #print "colvals are @col_vals\n";
        C4::AR::Debug::debug("en el end");

        $sth->execute(@col_vals);
            @col_vals = ();

                # kip:
        # the following is no longer needed but I'll leave it just in case I'm wrong.
        # Re-bind to undef (makes sure things are NULL)
        #my $count = 1;
        #foreach my $f (keys(%{$expat->{ __PACKAGE__ . "columns"}})) {
        #   $sth->bind_param( $count++ , undef );
        #}
    }
    elsif ($expat->within_element("ROW")) {
        $element = uc($element);
        return unless $expat->{ __PACKAGE__ . "columns"}->{$element};
                $col_vals[$expat->{ __PACKAGE__ . "columns"}->{$element}] = 
                  $expat->{ __PACKAGE__. "currentData"};
    }

    C4::AR::Debug::debug("fin del end");
}

sub Char {
    my ($expat, $string) = @_;
    # The only Char is the data. (AFAIK) Otherwise this will break (sorry!)
    my @context = $expat->context;
    my $column = pop @context;
    my $curtable = pop @context;

    if (($curtable) && ($curtable eq "ROW")) {
        $expat->{ __PACKAGE__ . "currentData"} .= $string;
    }
}

sub Proc {
    my $expat = shift;
    my $target = shift;
    my $text = shift;
}

sub Final {
    my $expat = shift;
    $dbh->commit;
}

1;