#!/usr/bin/env perl6

my $int_regex = / \d+ /;
my $float_regex = /  $int_regex  | (\d+)? \. \d\{2\}/;
subset UKPence of Int where * >= 0;

grammar Currency {
	token TOP { <currency-pence> | <currency-pound> }
	token currency-pence { <value=.integer> <pence-sign> }
	token currency-pound { <pound-sign> <value=.number> }
	token pence-sign { p }
	token pound-sign { \£ }
	token integer { \d+ }
	token decimal { (\d+)? \. \d\{2\} } 
	token number { <.integer> | <.decimal> } 
}

say Currency.parse("10p");
say Currency.parse("20p");
say Currency.parse("10 p");
say Currency.parse("£2");

#my $pound_to_pence = 100;
#my %CurrencyUK_coinage_to_pence = (
	 #"1p"  => 1,    "2p"  => 2,   "5p" =>  5,
	 #"10p" => 10,   "20p" => 20,  "50p" => 50,
	#"£1"   => 100, "£2"   => 200,
#);

#%CurrencyUK_coinage_to_pence.perl.say;

#multi MAIN( CurrencyPence $change  ) { make-change( Int($change)                   ); }
#multi MAIN( CurrencyPound $change  ) { make-change( Int($change) * $pound_to_pence ); }

#sub make-change( UKPence $amount ) {
#}


