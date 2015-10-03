#!/usr/bin/env perl6



module Currency::UK {
	# we do not want negative pence
	our subset UKPence of Int where * >= 0;

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

	our sub make-change( UKPence $amount ) {

	}

	our sub coinage() { return %coinage-to-pence }
}


sub MAIN( Str $currency  ) {
	my $currency-in-pence = Currency::UK::str-to-pence( $currency );
	say $currency-in-pence;

	say Currency::UK::coinage;
	#make-change(  );
}



