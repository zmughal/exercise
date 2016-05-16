#!/usr/bin/env perl

use v5.016;
use strict;
use warnings;
use POSIX qw(pow);

sub First_Kind_Sum_It_Up {
	my ($n, $k) = @_;
	my $powerset_sz = pow(2,$n);

	my $sum = 0;
	for( my $set = 1; $set < $powerset_sz; $set++) {
		# convert to binary
		my $set_bin = sprintf("%0${n}b", $set);

		# skip sets that don't have $k elements
		my $popcount = (my $set_bin_cp = $set_bin) =~ tr/1//;
		next unless $popcount == $k;

		my @subset;
		push @subset, pos($set_bin) while( $set_bin =~ m/1/g );

		my $prod = 1;
		$prod *= $_ for @subset;

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
