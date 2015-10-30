#!/usr/bin/env perl

use strict;
use warnings;


my %bigram;
my %trigram;
{
	local $/ = undef; # read in whole file at once
	while(<>) {
		my $line = $_;

		$line =~ s/(?=(..))/{ $bigram{$1}++ }/sge;

		$line = $_; # reset line for trigrams
		$line =~ s/(?=(...))/{ $trigram{$1}++ }/sge;
	}
}

sub print_gram {
	my ($gram_counts) = @_;
	my @gram_sorted_by_count = sort
		{ $gram_counts->{$b} <=> $gram_counts->{$a} } 
		keys %$gram_counts;
	for my $gram (@gram_sorted_by_count) {
		my $clean_gram = $gram =~ s/\n/<NL>/gr;
		print sprintf "%-8s %d\n", $clean_gram, $gram_counts->{$gram};
	}
}

print "Bigrams\n";
print_gram \%bigram;

print "=======================\n";

print "Trigram\n";
print_gram \%trigram;
