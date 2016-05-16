#!/usr/bin/env perl

use v5.016;
use strict;
use warnings;

sub generate_combos {
	my ($n, $k) = @_;
	my @com;
	for (my $i = 0; $i < $k; $i++) { $com[$i] = $i };
	return sub {
		return unless $com[$k - 1] < $n;

		my @copy = @com;

		my $t = $k - 1;
		while ($t != 0 && $com[$t] == $n - $k + $t) { $t-- };
		$com[$t]++;
		for (my $i = $t + 1; $i < $k; $i++) { $com[$i] = $com[$i - 1] + 1 };

		return \@copy;
	};
}

sub prod_idx {
	my ($list) = @_;
	my $prod = 1;
	$prod *= ( $_ + 1 ) for @$list;
	return $prod;
}

sub First_Kind_Sum_It_Up {
	my ($n, $k) = @_;

	my $sum = 0;

	my $prod_denom = prod_idx( [ 1..$n-1 ] );
	# use symmetry to compute the smaller number of elements
	if( $k < $n - $k ) {
		my $iter = generate_combos($n,$k);
		while( defined(  my $subset = $iter->() ) ) {
			my $prod = prod_idx( $subset );
			$sum += 1 / ( $prod );
		}

	} else {
		my $iter = generate_combos($n,$n - $k);
		while( defined(  my $subset = $iter->() ) ) {
			my $prod = prod_idx( $subset );
			$sum += $prod / $prod_denom;
		}
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
