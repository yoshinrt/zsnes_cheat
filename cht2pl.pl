#!/usr/bin/perl -w

open( fpIn, "< $ARGV[0]" ) || die( "Can't open file '$ARGV[0]'\n" );

print( << '-----' );
#!/usr/bin/perl -w
require './pl2cht.pl';
Cheat( << '-----' );
-----

while( read( fpIn, $_, 28 ) == 28 ){
	( undef, $Val, $Addr, undef, $Comment ) = unpack( 'CCISa20', $_ );
	
	$Addr &= 0xFFFFFF;
	$Comment =~ s/\x00.*//g;
	
	push( @Data, { Addr => $Addr, Val => $Val, Comment => $Comment });
}

$Addr = 0;

for( $i = 0; $i <= $#Data; ){
	
	$Val = sprintf( "%02X", $Data[ $i ]{ Val });
	
	for( $Size = 1; $i + $Size <= $#Data; ++$Size ){
		last if(
			$Data[ $i ]{ Addr } + $Size != $Data[ $i + $Size ]{ Addr } ||
			$Data[ $i ]{ Comment } ne $Data[ $i + $Size ]{ Comment }
		);
		
		$Val .= sprintf( "%02X", $Data[ $i + $Size ]{ Val });
	}
	
	# アドレス
	if( $Addr != $Data[ $i ]{ Addr } ){
		if( $Data[ $i ]{ Addr } < $Addr || $Data[ $i ]{ Addr } > $Addr + 16 ){
			printf( "@%X", $Data[ $i ]{ Addr } );
		}else{
			printf( "+%X", $Data[ $i ]{ Addr } - $Addr );
		}
		$Addr = $Data[ $i ]{ Addr };
	}
	
	# データ
	print( "\t" );
	
	while( $Val ){
		$Val =~ s/(..)(..)?(..)?(..)?(.*)/$5/;
		print(( $4 || '' ) . ( $3 || '' ) . ( $2 || '' ) . $1 );
		print( ' ' ) if( $Val );
	}
	
	# コメント
	if( $Data[ $i ]{ Comment } ne '' ){
		print( "\t'$Data[ $i ]{ Comment }\n" );
	}else{
		print( "\n" );
	}
	
	$Addr += $Size;
	$i += $Size;
}
print( "-----\n" );
