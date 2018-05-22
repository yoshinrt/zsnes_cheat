#!/usr/bin/perl -w

$0 =~ /(.*)\./;
open( fpOut, "> $1.cht" );

$Addr = 0;
my $Magic = 0xFCFE;

sub Cheat {
	local( $_ ) = @_;
	my @Data = split( /[\x0D\x0A]+/, $_ );
	my( $Val, $Size );
	my( $i );
	
	foreach $_ ( @Data ){
		s/#.*//g;
		
		$Comment = '';
		
		# cht のコメント
		if( /'(.*)/ ){
			$Comment = $1;
			$_ = $`;
		}
		
		s/^\s+//g;
		s/\s+$//g;
		
		@_ = split( /\s+/, $_ );
		
		foreach $_ ( @_ ){
			if( /^@(.*)/ ){
				# アドレス (絶対)
				$Addr = ( ToNum( $1 ))[ 0 ];
			}elsif( /^\+(.*)/ ){
				# アドレス (相対)
				$Addr += ( ToNum( $1 ))[ 0 ];
			}else{
				# 値
				( $Val, $Size ) = ToNum( $_ );
				
				print( "Error: no size: $_\n" ) if( !defined( $Size ));
				
				for( $i = 0; $i < $Size; ++$i ){
					print( fpOut pack( 'CCISa20',
						0,			# use
						$Val & 0xFF,
						$Addr,
						$Magic,
						$Comment
					));
					++$Addr;
					$Magic = 0;
					$Val >>= 8;
				}
			}
		}
	}
}

sub ToNum {
	local( $_ ) = @_;
	
	if( /^#(bwd)?(\d+)/ ){
		return( $2,
			!defined( $1 ) ? undef :
			uc $1 eq 'b' ? 1 :
			uc $1 eq 'w' ? 2 :
			uc $1 eq 'd' ? 4 : undef
		);
	}else{
		my $len = ~~(( length( $_ ) + 1 ) / 2 );
		return ( hex( $_ ), $len > 4 ? 4 : $len );
	}
}

1;
