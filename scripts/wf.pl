#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;
use Encode;
use utf8;
use open ':std', 'encoding(UTF-8)';

binmode STDOUT, ":utf8";
binmode STDIN, ":utf8";
binmode STDERR, ":utf8";

print "\033[2J";   # Clear screen
print "\033[H";    # Move cursor to top-left corner

my $lst_out = qx(bash /etc/wordefin/scripts/lst.sh | sort);

my @lst_out = split(/\n/, $lst_out);

print color ('bold');
print "Enter search term: ";
print color ('reset');

while(1)
{
	my $term = <STDIN>;
	chomp $term;

	print "\033[2J";
	print "\033[H";

	unless ($term eq ":q") {
		foreach my $lst_item (@lst_out) {
			if ($lst_item =~ /$term/) {
				my $found_item = $lst_item;
				my $found = color ('bold green') . $term . color('reset');
				$found_item =~ s/\Q$term\E/$found/g;

				print "$found_item\n";
			}
		}
	}
	else {
		exit()
	}
}