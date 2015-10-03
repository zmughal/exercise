#!/usr/bin/env perl6

module Currency::UK {

	our grammar Grammar {
		token TOP { <currency-pence> | <currency-pound> };
		token currency-pence { <value=.integer> <pence-sign> };
		token currency-pound { <pound-sign> <value=.number> };
		token pence-sign { p };
		token pound-sign { \£ };
		token integer { \d+ };
		token decimal { <.integer>? \. \d\{2\} };
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
			$currency-in-pence = ~$currency-ast<currency-pence><value>
		} elsif $currency-ast<currency-pound>:exists {
			$currency-in-pence = $pound-to-pence * ~$currency-ast<currency-pound><value>
		}
	}

	our sub make-change( Int $amount where $amount >= 0 ) {
		say %coinage-to-pence.sort( { .value } ).reverse>>.key;
		return make-change-helper( $amount, %coinage-to-pence.sort( { .value } ).reverse.Array );
	}

	our sub make-change-helper( Int $amount, @denominations ) {
		return 1 if $amount == 0; # if the $amount is reached
		return 0 if $amount < 0 or not @denominations; # if the $amount is invalid or no more coins left
		my ($denom, *@denom-rest) = @denominations;

		return make-change-helper($amount - $denom.value, @denominations ) + make-change-helper( $amount, @denom-rest );

		#my @list = ();
		#for ^($amount div $denom.value) -> $n {
			#@list.push:  { $denom.key => $n } X, make-change-helper( $amount - $n * $denom.value, @denom-rest );
			#say @list;
		#}
		#return @list;
	}

	our sub coinage() { return %coinage-to-pence }
}


sub MAIN( Str $currency  ) {
	my $currency-in-pence = Currency::UK::str-to-pence( $currency );
	say $currency-in-pence;

	my %us-coinage-to-cents = (
		"penny" => 1,
		"nickel" => 5,
		"dime" => 10,
		"quarter" => 25,
	);
	say Currency::UK::make-change-helper( 100, %us-coinage-to-cents.sort({ .value }).reverse.Array );
	#say Currency::UK::make-change( $currency-in-pence  );
}



