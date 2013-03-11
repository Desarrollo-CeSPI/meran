package C4::AR::MailChecker;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

@EXPORT_OK = qw( valid validlist );

@EXPORT = qw(
    
);
$VERSION = '0.4';


my $rfc822re;

# Preloaded methods go here.
my $lwsp = "(?:(?:\\r\\n)?[ \\t])";

my $char = '[\\000-\\177]';

sub make_rfc822re {
#   Basic lexical tokens are specials, domain_literal, quoted_string, atom, and
#   comment.  We must allow for lwsp (or comments) after each of these.
#   This regexp will only work on addresses which have had comments stripped 
#   and replaced with lwsp.

    my $specials = '()<>@,;:\\\\".\\[\\]';
    my $controls = '\\000-\\037\\177';

    my $dtext = "[^\\[\\]\\r\\\\]";
    my $domain_literal = "\\[(?:$dtext|\\\\.)*\\]$lwsp*";

    my $quoted_string = "\"(?:[^\\\"\\r\\\\]|\\\\.|$lwsp)*\"$lwsp*";

#   Use zero-width assertion to spot the limit of an atom.  A simple 
#   $lwsp* causes the regexp engine to hang occasionally.
    my $atom = "[^$specials $controls]+(?:$lwsp+|\\Z|(?=[\\[\"$specials]))";
    my $word = "(?:$atom|$quoted_string)";
    my $localpart = "$word(?:\\.$lwsp*$word)*";

    my $sub_domain = "(?:$atom|$domain_literal)";
    my $domain = "$sub_domain(?:\\.$lwsp*$sub_domain)*";

    my $addr_spec = "$localpart\@$lwsp*$domain";

    my $phrase = "$word*";
    my $route = "(?:\@$domain(?:,\@$lwsp*$domain)*:$lwsp*)";
    my $route_addr = "\\<$lwsp*$route?$addr_spec\\>$lwsp*";
    my $mailbox = "(?:$addr_spec|$phrase$route_addr)";

    my $group = "$phrase:$lwsp*(?:$mailbox(?:,\\s*$mailbox)*)?;\\s*";
    my $address = "(?:$mailbox|$group)";

    return "$lwsp*$address";
}

sub strip_comments {
    my $s = shift;
#   Recursively remove comments, and replace with a single space.  The simpler
#   regexps in the Email Addressing FAQ are imperfect - they will miss escaped
#   chars in atoms, for example.

    while ($s =~ s/^((?:[^"\\]|\\.)*
                    (?:"(?:[^"\\]|\\.)*"(?:[^"\\]|\\.)*)*)
                    \((?:[^()\\]|\\.)*\)/$1 /osx) {}
    return $s;
}

#   valid: returns true if the parameter is an RFC822 valid address
#
sub valid ($) {
    my $s = strip_comments(shift);

    if (!$rfc822re) {
        $rfc822re = make_rfc822re();
    }

    return $s =~ m/^$rfc822re$/so && $s =~ m/^$char*$/;
}

#   validlist: In scalar context, returns true if the parameter is an RFC822 
#              valid list of addresses.
#
#              In list context, returns an empty list on failure (an invalid
#              address was found); otherwise a list whose first element is the
#              number of addresses found and whose remaining elements are the
#              addresses.  This is needed to disambiguate failure (invalid)
#              from success with no addresses found, because an empty string is
#              a valid list.

sub validlist ($) {
    my $s = strip_comments(shift);

    if (!$rfc822re) {
        $rfc822re = make_rfc822re();
    }
    # * null list items are valid according to the RFC
    # * the '1' business is to aid in distinguishing failure from no results

    my @r;
    if($s =~ m/^(?:$rfc822re)?(?:,(?:$rfc822re)?)*$/so && $s =~ m/^$char*$/) {
        while($s =~ m/(?:^|,$lwsp*)($rfc822re)/gos) {
            push @r, $1;
        }
        return wantarray ? (scalar(@r), @r) : 1;
    }
    else {
        return wantarray ? () : 0;
    }
}

1;

__END__
