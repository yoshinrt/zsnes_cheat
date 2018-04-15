#!/usr/bin/perl

$ManNo = 12;
$Addr = 0xE91D6;

#他のキャラは+3Chです
$_ = << '----';
800E91D6  6363
800E91D8  6363
----

for( $i = 0; $i < $ManNo; ++$i ){
	Cheat( $_ );
	$Addr += 0x3C;
}

#まで他のキャラは+64hです。
$Addr = 0x300ECDB1;

$_ = << '----';
300ECDB1  0063  ファイトLV99
800ECDB2  6363  ロングLV99・ショートLV99
800ECDB4  7FFF   ファイトEXP
800ECDB6  7FFF   ショートEXP
800ECDB8  7FFF   ロングEXP
800ECDBA  03E7  オーナーポイント999
800ECDBC  FFFF
800ECDBC  FFFF
800ECDC0  FFFF
800ECDC2  FFFF
800ECDC4  FFFF
800ECDC6  FFFF
800ECDC8  FFFF
800ECDCA  FFFF
800ECDCC  FFFF
800ECDCE  FFFF
800ECDD0  FFFF
800ECDD2  FFFF
800ECDD4  FFFF
800ECDD6  FFFF
800ECDD8 FFFF 
300ECDDA 007F
300ECCCC 0001 
----

for( $i = 0; $i < $ManNo; ++$i ){
	Cheat( $_ );
	$Addr += 0x64;
}


sub Cheat {
	local( $_ ) = @_;
	my( $Base );
	$Addr &= 0x0FFFFFFF;
	
	foreach $_ ( split( /\n/, $_ )){
		/(\S+)\s+(\S+)/;
		
		if( !defined( $Base )){
			$Base = hex( $1 ) & 0x0FFFFFFF;
		}
		
		printf( "%X%07X\t$2\n",
			hex( $1 ) >> 28,
			( hex( $1 ) & 0x0FFFFFFF ) - $Base + $Addr
		);
	}
}
