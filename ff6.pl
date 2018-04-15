#!/usr/bin/perl -w
require './pl2cht.pl';
Cheat( << '-----' );
@7E1969	63		'ITEM 1
@7E1860	FFFF FF	'MONEY

@7E2E78	270F	'HP 1 BATTLE
		270F	'HP 2
		270F	'HP 3
		270F	'HP 4
-----

for( $i = 0; $i < 8; ++$i ){
	$Addr = 0x7E1609 + 0x25 * $i;
	Cheat( << '-----' );
	270F	'HP
	270F	'MP
	967F 98	'EXP
-----
}
