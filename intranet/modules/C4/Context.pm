package C4::Context;

use strict;
use DBI;

use vars qw($VERSION $AUTOLOAD),
	qw($context),
	qw(@context_stack);
our @ISA = qw (Exporter);
our @EXPORT = qw (camel);
our @EXPORT_OK = qw(1024);

$VERSION = do { my @v = '$Revision: 1.14 $' =~ /\d+/g;
		shift(@v) . "." . join("_", map {sprintf "%03d", $_ } @v); };


use constant CONFIG_FNAME => "/etc/meran/meran.conf";
				# Default config file, if none is specified

$context = undef;		# Initially, no context is set
@context_stack = ();		# Initially, no saved contexts

# read_config_file
# Reads the specified Koha config file. Returns a reference-to-hash
# whose keys are the configuration variables, and whose values are the
# configuration values (duh).
# Returns undef in case of error.
sub read_config_file
{
	my $fname = shift;	# Config file to read
	my $retval = {};	# Return value: ref-to-hash holding the
				# configuration

	open (CONF, $fname) or return undef;

	while (<CONF>)
	{
		my $var;		# Variable name
		my $value;		# Variable value

		chomp;
		s/#.*//;		# Strip comments
		next if /^\s*$/;	# Ignore blank lines

		# Look for a line of the form
		#	var = value
		if (!/^\s*(\w+)\s*=\s*(.*?)\s*$/)
		{
			# FIXME - Complain about bogus line
			next;
		}

		# Found a variable assignment
		# FIXME - Ought to complain is this line sets a
		# variable that was already set.
		$var = $1;
		$value = $2;
		$retval->{$var} = $value;
	}
	close CONF;

	return $retval;
}

sub import
{
	my $package = shift;
	my $conf_fname = shift;		# Config file name
	my $context;

	# Create a new context from the given config file name, if
	# any, then set it as the current context.
	$context = new C4::Context($conf_fname);
	return undef if !defined($context);
	$context->set_context;
}

sub new
{
	my $class = shift;
	my $conf_fname = shift;		# Config file to load
	my $self = {};

	# check that the specified config file exists
	undef $conf_fname unless (defined $conf_fname && -e $conf_fname);
	# Figure out a good config file to load if none was specified.
	if (!defined($conf_fname))
	{
		# If the $KOHA_CONF environment variable is set, use
		# that. Otherwise, use the built-in default.
		$conf_fname = $ENV{"MERAN_CONF"} || CONFIG_FNAME;
		
	}
	$self->{"config_file"} = $conf_fname;

	# Load the desired config file.
	$self->{"config"} = &read_config_file($conf_fname);
	return undef if !defined($self->{"config"});

	$self->{"dbh"} = undef;		# Database handle
	$self->{"stopwords"} = undef; # stopwords list
	$self->{"version"} = undef; #version


	bless $self, $class;
	return $self;
}

=item set_context

  $context = new C4::Context;
  $context->set_context();
or
  set_context C4::Context $context;

  ...
  restore_context C4::Context;

In some cases, it might be necessary for a script to use multiple
contexts. C<&set_context> saves the current context on a stack, then
sets the context to C<$context>, which will be used in future
operations. To restore the previous context, use C<&restore_context>.

=cut
#'
sub set_context
{
	my $self = shift;
	my $new_context;	# The context to set

	# Figure out whether this is a class or instance method call.
	#
	# We're going to make the assumption that control got here
	# through valid means, i.e., that the caller used an instance
	# or class method call, and that control got here through the
	# usual inheritance mechanisms. The caller can, of course,
	# break this assumption by playing silly buggers, but that's
	# harder to do than doing it properly, and harder to check
	# for.
	if (ref($self) eq "")
	{
		# Class method. The new context is the next argument.
		$new_context = shift;
	} else {
		# Instance method. The new context is $self.
		$new_context = $self;
	}

	# Save the old context, if any, on the stack
	push @context_stack, $context if defined($context);

	# Set the new context
	$context = $new_context;
}

=item restore_context

  &restore_context;

Restores the context set by C<&set_context>.

=cut
#'
sub restore_context
{
	my $self = shift;

	if ($#context_stack < 0)
	{
		# Stack underflow.
		die "Context stack underflow";
	}

	# Pop the old context and set it.
	$context = pop @context_stack;

	# FIXME - Should this return something, like maybe the context
	# that was current when this was called?
}

=item config

  $value = C4::Context->config("config_variable");

  $value = C4::Context->config_variable;

Returns the value of a variable specified in the configuration file
from which the current context was created.

The second form is more compact, but of course may conflict with
method names. If there is a configuration variable called "new", then
C<C4::Config-E<gt>new> will not return it.

=cut
#'
sub config
{
	my $self = shift;
	my $var = shift;		# The config variable to return

	return undef if !defined($context->{"config"});
			# Presumably $self->{config} might be
			# undefined if the config file given to &new
			# didn't exist, and the caller didn't bother
			# to check the return value.

	# Return the value of the requested config variable
	return $context->{"config"}{$var};
}

=item preference

  $sys_preference = C4::Context->preference("some_variable");

Looks up the value of the given system preference in the
systempreferences table of the Koha database, and returns it. If the
variable is not set, or in case of error, returns the undefined value.

=cut
# FIXME - No usar!
sub preference
{
#	my $self = shift;
#	my ($valueName) = @_;
#	my $dbh = C4::Context->dbh;
#	my $query;
#	my $sth;
#	
#	$query="SELECT value
#		FROM pref_preferencia_sistema
#		WHERE variable=?";

#	$sth = $dbh->prepare($query);

#	$sth->execute($valueName);

#	return ($sth->fetchrow);
}

sub preferences {
	
	my $query;
	my $dbh = C4::Context->dbh;
	my $sth;
	
	$query="SELECT * FROM pref_preferencia_sistema";

	$sth = $dbh->prepare($query);

	$sth->execute();

	return ($sth->fetchrow_hashref);
}
	

# sub boolean_preference ($) {
# 	my $self = shift;
# 	my $var = shift;		# The system preference to return
# 	my $it = preference($self, $var);
# 	return defined($it)? C4::Boolean::true_p($it): undef;
# }

# AUTOLOAD
# This implements C4::Config->foo, and simply returns
# C4::Context->config("foo"), as described in the documentation for
# &config, above.

# FIXME - Perhaps this should be extended to check &config first, and
# then &preference if that fails. OTOH, AUTOLOAD could lead to crappy
# code, so it'd probably be best to delete it altogether so as not to
# encourage people to use it.
sub AUTOLOAD
{
	my $self = shift;

	$AUTOLOAD =~ s/.*:://;		# Chop off the package name,
					# leaving only the function name.
	return $self->config($AUTOLOAD);
}

# _new_dbh
# Internal helper function (not a method!). This creates a new
# database connection from the data given in the current context, and
# returns it.
sub _new_dbh
{
	use CGI::Session;
	
	my $db_driver = $context->{"config"}{"db_scheme"} || "mysql";


	my $session = CGI::Session->load();

	my $db_name   = $context->{"config"}{"database"};
	my $db_host   = $context->{"config"}{"hostname"};
	my $db_user   = $context->{"config"}{"userOPAC"};
	my $db_passwd = $context->{"config"}{"passOPAC"};

	if($session->param('type') eq 'intranet'){
	C4::AR::Debug::debug("_new_dbh => type: ".$session->param('type'));
	C4::AR::Debug::debug("_new_dbh => userINTRA");
		$db_user   = $context->{"config"}{"userINTRA"};
		$db_passwd = $context->{"config"}{"passINTRA"};
	}

	my $dbh= DBI->connect("DBI:$db_driver:$db_name:$db_host",$db_user, $db_passwd);
	$dbh->do('SET NAMES utf8');

	return $dbh;
# 	return DBI->connect("DBI:$db_driver:$db_name:$db_host",$db_user, $db_passwd);
}


=item dbh

  $dbh = C4::Context->dbh;

Returns a database handle connected to the Koha database for the
current context. If no connection has yet been made, this method
creates one, and connects to the database.

This database handle is cached for future use: if you call
C<C4::Context-E<gt>dbh> twice, you will get the same handle both
times. If you need a second database handle, use C<&new_dbh> and
possibly C<&set_dbh>.

=cut
#'
sub dbh
{
	my $self = shift;

	# If there's already a database handle, return it.
	return $context->{"dbh"} if defined($context->{"dbh"});

	# No database handle yet. Create one.
	$context->{"dbh"} = &_new_dbh();

	return $context->{"dbh"};
}


=item new_dbh

  $dbh = C4::Context->new_dbh;

Creates a new connection to the Koha database for the current context,
and returns the database handle (a C<DBI::db> object).

The handle is not saved anywhere: this method is strictly a
convenience function; the point is that it knows which database to
connect to so that the caller doesn't have to know.

=cut
#'
sub new_dbh
{
	my $self = shift;

	return &_new_dbh();
}

=item set_dbh

  $my_dbh = C4::Connect->new_dbh;
  C4::Connect->set_dbh($my_dbh);
  ...
  C4::Connect->restore_dbh;

C<&set_dbh> and C<&restore_dbh> work in a manner analogous to
C<&set_context> and C<&restore_context>.

C<&set_dbh> saves the current database handle on a stack, then sets
the current database handle to C<$my_dbh>.

C<$my_dbh> is assumed to be a good database handle.

=cut
#'
sub set_dbh
{
	my $self = shift;
	my $new_dbh = shift;

	# Save the current database handle on the handle stack.
	# We assume that $new_dbh is all good: if the caller wants to
	# screw himself by passing an invalid handle, that's fine by
	# us.
	push @{$context->{"dbh_stack"}}, $context->{"dbh"};
	$context->{"dbh"} = $new_dbh;
}

=item restore_dbh

  C4::Context->restore_dbh;

Restores the database handle saved by an earlier call to
C<C4::Context-E<gt>set_dbh>.

=cut
#'
sub restore_dbh
{
	my $self = shift;

	if ($#{$context->{"dbh_stack"}} < 0)
	{
		# Stack underflow
		die "DBH stack underflow";
	}

	# Pop the old database handle and set it.
	$context->{"dbh"} = pop @{$context->{"dbh_stack"}};

	# FIXME - If it is determined that restore_context should
	# return something, then this function should, too.
}

=item stopwords

  $dbh = C4::Context->stopwords;

Returns a hash with stopwords.

This hash is cached for future use: if you call
C<C4::Context-E<gt>stopwords> twice, you will get the same hash without real DB access

=cut
#'
sub stopwords
{
	my $retval = {};

	# If the hash already exists, return it.
	return $context->{"stopwords"} if defined($context->{"stopwords"});

	# No hash. Create one.
	$context->{"stopwords"} = &_new_stopwords();

	return $context->{"stopwords"};
}

# _new_stopwords
# Internal helper function (not a method!). This creates a new
# hash with stopwords
sub _new_stopwords
{
	my $dbh = C4::Context->dbh;
	my $stopwordlist;
	my $sth = $dbh->prepare("select word from pref_palabra_frecuente");
	$sth->execute;
	while (my $stopword = $sth->fetchrow_array) {
		my $retval = {};
		$stopwordlist->{$stopword} = uc($stopword);
	}
	return $stopwordlist;
}


sub version
{
	my $retval = {};

	# If the hash already exists, return it.
	return $context->{"version"} if defined($context->{"version"});

	# No hash. Create one.
	$context->{"version"} = &_read_version();

	return $context->{"version"};
}


# Read VERSION

sub _read_version
{
	my $version= undef;

	if ( open my $vf, '<', $context->config('intranetdir')."/../VERSION") 
	{ 
	 $version = <$vf>; 
	close $vf;
	}
	return $version;
}


BEGIN{
      new C4::Context;
};

1;

__END__


