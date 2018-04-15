#!/usr/bin/perl -w

open( fpIn, "< $ARGV[0]" ) || die( "Can't open file '$ARGV[0]'\n" );

print( << '-----' );
#!/usr/bin/perl -w
require 'pl2cht.pl';
Cheat( << '-----' );
-----

while( read( fpIn, $_, 28 ) == 28 ){
	( undef, $Val, $Addr, undef, $Comment ) = unpack( 'CCISa20', $_ );
	
	$Addr &= 0xFFFFFF;
	$Comment =~ s/\x00.*//g;
	
	push( @Data, [ $Addr, $Val, $Comment ] );
}

$Addr = 0;

for( $i = 0; $i <= $#Data; ++$i ){
	if(
		defined( $Data[ $i + 1 ] ) &&
		$Data[ $i ][ 0 ] + 1 == $Data[ $i + 1 ][ 0 ] &&
		uc $Data[ $i ][ 2 ] eq uc $Data[ $i + 1 ][ 2 ]
	){
		if(
			defined( $Data[ $i + 3 ] ) &&
			$Data[ $i ][ 0 ] + 2 == $Data[ $i + 2 ][ 0 ] &&
			uc $Data[ $i ][ 2 ] eq uc $Data[ $i + 2 ][ 2 ] &&
			$Data[ $i ][ 0 ] + 3 == $Data[ $i + 3 ][ 0 ] &&
			uc $Data[ $i ][ 2 ] eq uc $Data[ $i + 3 ][ 2 ]
		){
			# 4B パック
			$Val = sprintf( '%08X',
				( $Data[ $i + 0 ][ 1 ] <<  0 ) |
				( $Data[ $i + 1 ][ 1 ] <<  8 ) |
				( $Data[ $i + 2 ][ 1 ] << 16 ) |
				( $Data[ $i + 3 ][ 1 ] << 24 )
			);
			$Size = 4;
		}else{
			# 2B パック
			$Val = sprintf( '%04X',
				( $Data[ $i + 0 ][ 1 ] <<  0 ) |
				( $Data[ $i + 1 ][ 1 ] <<  8 )
			);
			$Size = 2;
		}
	}else{
		# 1B
		$Val = sprintf( '%02X',
			( $Data[ $i + 0 ][ 1 ] <<  0 )
		);
		$Size = 1;
	}
	
	# アドレス
	if( $Addr != $Data[ $i ][ 0 ] ){
		printf( "@%X", $Data[ $i ][ 0 ] );
		$Addr = $Data[ $i ][ 0 ];
	}
	
	# データ
	print( "\t$Val" );
	
	# コメント
	if( $Data[ $i ][ 2 ] ne '' ){
		print( "\t'$Data[ $i ][ 2 ]\n" );
	}else{
		print( "\n" );
	}
	
	$Addr += $Size;
	$i += $Size - 1;
}
print( "-----\n" );
