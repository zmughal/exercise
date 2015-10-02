#!/usr/bin/env perl6

my $int_regex = / \d+ /;
my $float_regex = /  $int_regex  | (\d+)? \. \d\{2\}/;
subset UKPence of Int where * >= 0;

grammar Currency {
	token TOP { <currency-pence> | <currency-pound> };
	token currency-pence { <value=.integer> <pence-sign> };
	token currency-pound { <pound-sign> <value=.number> };
	token pence-sign { p };
	token pound-sign { \£ };
	token integer { \d+ };
	token decimal { (\d+)? \. \d\{2\} };
	token number { <.integer> | <.decimal> };
}

my $pound_to_pence = 100;
#my %CurrencyUK_coinage_to_pence = (
	 #"1p"  => 1,    "2p"  => 2,   "5p" =>  5,
	 #"10p" => 10,   "20p" => 20,  "50p" => 50,
	#"£1"   => 100, "£2"   => 200,
#);

#%CurrencyUK_coinage_to_pence.perl.say;

sub MAIN( Str $currency  ) {
	my $currency_ast = Currency.parse($currency);
	die "Could not parse currency string $currency" unless $currency_ast;
	my $currency_in_pence;
	if $currency_ast<currency-pence>:exists {
		$currency_in_pence = ~$currency_ast<currency-pence><value>
	} elsif $currency_ast<currency-pound>:exists {
		$currency_in_pence = $pound_to_pence * ~$currency_ast<currency-pound><value>
	}
	say $currency_in_pence;
	#make-change(  );
}

#sub make-change( UKPence $amount ) {
#}


