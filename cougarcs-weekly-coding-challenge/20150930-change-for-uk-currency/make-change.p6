#!/usr/bin/env perl6

use Term::ProgressBar;               # panda install Term::ProgressBar
use Inline::Perl5;                   # panda install Inline::Perl5
use Lingua::EN::Inflect:from<Perl5>; # cpanm Lingua::EN::Inflect # Perl5 module

module Currency::UK {

	our grammar Grammar {
		token TOP { <currency-pence> | <currency-pound> };
		token currency-pence { <value=.integer> <pence-sign> };
		token currency-pound { <pound-sign> <value=.number> };
		token pence-sign { p };
		token pound-sign { \£ };
		token nonzero-digit { <[ 1 .. 9 ]> };
		token digit { <[ 0 .. 9 ]> };
		token integer { <nonzero-digit> <digit>+ | <digit> };
		token decimal { <.integer>? \. <.digit> <.digit> };
		token number { <.integer> | <.decimal> };
	}
	our $pound-to-pence = 100;
	our %coinage-to-pence = (
		 "1p"  => 1,    "2p"  => 2,   "5p" =>  5,
		 "10p" => 10,   "20p" => 20,  "50p" => 50,
		"£1"   => 100, "£2"   => 200,
	);

	our sub str-to-pence( Str $currency ) {
		my $currency-ast = Currency::UK::Grammar.parse($currency);
		die "Could not parse currency string $currency" unless $currency-ast;
		my $currency-in-pence;
		if $currency-ast<currency-pence>:exists {
			$currency-in-pence = $currency-ast<currency-pence><value>.Int;
		} elsif $currency-ast<currency-pound>:exists {
			$currency-in-pence = $pound-to-pence * ~$currency-ast<currency-pound><value>.Rat;
		}
		return $currency-in-pence;
	}

	our sub make-change-count( Int $amount where $amount >= 0  ) {
		# count the ways to make change
		sub make-change-helper-count( Int $amount, @denominations ) is cached {
			return 0 if $amount < 0 or not @denominations; # if the $amount is invalid or no more coins left
			return 1 if $amount == 0; # if the $amount is reached

			# head and tail of @denominations array
			my ($current-denomination, *@denominations-rest) = @denominations;
			return make-change-helper-count($amount - $current-denomination.value, @denominations )
				+ make-change-helper-count( $amount, @denominations-rest );
		}

		return make-change-helper-count( $amount, %coinage-to-pence.sort( { .value } ).reverse.Array );
	}

	our sub make-change-list( Int $amount where $amount >= 0 ) {
		# array to store the list of change combinations
		my @coin-list;

		my $bar = Term::ProgressBar.new( count => make-change-count( $amount ), :t, :p );
		say "Calculating a list of ways to make change:";
		# nested function that will modify @coin-list
		sub make-change-helper-list( Int $amount, @denominations, %coins-used = {} ) {
			if $amount < 0 or not @denominations {
				# if the $amount is invalid or no more coins left
				return;
			}
			if $amount == 0 {
				# if the $amount is reached
				#say %coins-used.perl;#DEBUG
				$bar.update(@coin-list.elems);
				push @coin-list, %coins-used;
				return;
			}

			# head and tail of @denominations array
			my ($current-denomination, *@denominations-rest) = @denominations;

			# use up the current denomination
			my %coins-used-next = %coins-used;
			%coins-used-next{$current-denomination.key}++;
			make-change-helper-list($amount - $current-denomination.value, @denominations, %coins-used-next  );

			# do not use the current denomination
			make-change-helper-list( $amount, @denominations-rest, %coins-used );

			return
		}

		make-change-helper-list( $amount, %coinage-to-pence.sort( { .value } ).reverse.Array );

		say "\n"; # end of $bar

		return @coin-list;
	}


	our sub coinage() { return %coinage-to-pence }
}

sub MAIN( Str $currency  ) {
	my $currency-in-pence = Currency::UK::str-to-pence( $currency );

	my $ways-to-make-change = Currency::UK::make-change-count( $currency-in-pence  );
	say "There { Lingua::EN::Inflect::PL_V("is", $ways-to-make-change) } { Lingua::EN::Inflect::NO("way", $ways-to-make-change ) }"
		~ " to make change for $currency using"
		~ " the { Lingua::EN::Inflect::PL_N("coin", Currency::UK::coinage.elems) } { Lingua::EN::Inflect::WORDLIST(Currency::UK::coinage.sort({.value})>>.keys) }.";
	my @coin-list = Currency::UK::make-change-list( $currency-in-pence  );
	say @coin-list.perl;
}



