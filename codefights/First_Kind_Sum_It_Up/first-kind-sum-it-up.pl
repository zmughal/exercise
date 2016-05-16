#!/usr/bin/env perl

use v5.016;
use strict;
use warnings;
use Algorithm::Combinatorics qw/combinations/;

sub generate_combos {
	my ($n, $k) = @_;
	my @com;
	for (my $i = 0; $i < $k; $i++) { $com[$i] = $i };
	while ($com[$k - 1] < $n) {
		for (my $i = 0; $i < $k; $i++) {
			print "$com[$i]  ";
		}
		say;

		my $t = $k - 1;
		while ($t != 0 && $com[$t] == $n - $k + $t) { $t-- };
		$com[$t]++;
		for (my $i = $t + 1; $i < $k; $i++) { $com[$i] = $com[$i - 1] + 1 };
    }
}

sub First_Kind_Sum_It_Up {
	my ($n, $k) = @_;
	generate_combos( $n, $k );

	my $sum = 0;

	my $iter = combinations([1..$n],$k);
	while(  my $subset = $iter->next ) {
		my $prod = 1;
		$prod *= $_ for @$subset;

		$sum += 1 / ( $prod );
	}

	sprintf("%.2E", $sum) =~ s/(E[+-])0(\d)/$1$2/r;
}

sub testing {
	require Test::Most;
	Test::Most->import;

	is( First_Kind_Sum_It_Up(3, 2), "1.00E+0" );
	is( First_Kind_Sum_It_Up(7, 6), "5.56E-3" );
	is( First_Kind_Sum_It_Up(9, 1), "2.83E+0" );
	is( First_Kind_Sum_It_Up(19, 18), "1.56E-15" );
	is( First_Kind_Sum_It_Up(63, 59), "3.05E-76" );

	done_testing();
}

testing if $ENV{HARNESS_ACTIVE} ;
