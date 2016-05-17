#!/usr/bin/env perl

use v5.016;
use strict;
use warnings;
use Memoize;

memoize('factorial');
memoize('S');

sub factorial {
	my ($n) = @_;
	if( $n == 0 ) { return 1; }

	return $n * factorial($n-1);
}

sub S {
	my ($n, $m) = @_;
	if ( $m == 1 ) {
		return $n*($n + 1)/2;
	} elsif ( $n == $m ) {
		return factorial($m);
	} else {
		return S($n - 1, $m) + $n*S($n - 1, $m - 1)
	}
}

sub First_Kind_Sum_It_Up {
	my ($n, $k) = @_;
	my $v = S($n, $n-$k);
	my $sum = $v / factorial($n);

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
