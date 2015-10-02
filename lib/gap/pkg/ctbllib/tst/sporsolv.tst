# This file was created from xpl/sporsolv.xpl, do not edit!
# -> $3^{1+4}_+:4S_5$ type subgroups of $U_4(3).2_3$ ???

#############################################################################
##
#W  sporsolv.tst                GAP applications              Thomas Breuer
##
#Y  Copyright 2006,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,   Germany
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `ReadTest( "sporsolv.tst" );`.
##

gap> START_TEST( "sporsolv.tst" );

gap> LoadPackage( "CTblLib", "1.2" );
true
gap> LoadPackage( "TomLib" );
true
gap> MaxSolv:= rec();;
gap> MaximalSolvableSubgroupInfoFromTom:= function( name )
>     local tom,          # table of marks for `name'
>           n,            # maximal order of a solvable subgroup
>           maxsubs,      # numbers of the classes of subgroups of order `n'
>           orders,       # list of orders of the classes of subgroups
>           i,            # loop over the classes of subgroups
>           maxes,        # list of positions of the classes of max. subgroups
>           subs,         # `SubsTom' value
>           cont;         # list of list of positions of max. subgroups
> 
>     tom:= TableOfMarks( name );
>     if tom = fail then
>       return false;
>     fi;
>     n:= 1;
>     maxsubs:= [];
>     orders:= OrdersTom( tom );
>     for i in [ 1 .. Length( orders ) ] do
>       if IsSolvableTom( tom, i ) then
>         if orders[i] = n then
>           Add( maxsubs, i );
>         elif orders[i] > n then
>           n:= orders[i];
>           maxsubs:= [ i ];
>         fi;
>       fi;
>     od;
>     maxes:= MaximalSubgroupsTom( tom )[1];
>     subs:= SubsTom( tom );
>     cont:= List( maxsubs, j -> Filtered( maxes, i -> j in subs[i] ) );
> 
>     return [ name, n, List( cont, l -> orders{ l } ) ];
> end;;
gap> SolvableSubgroupInfoFromCharacterTable:= function( tblM, minorder )
>     local maxindex,  # index of subgroups of order `minorder'
>           N,         # class positions describing a solvable normal subgroup
>           fact,      # character table of the factor by `N'
>           classes,   # class sizes in `fact'
>           nsg,       # list of class positions of normal subgroups
>           i;         # loop over the possible indices
> 
>     maxindex:= Int( Size( tblM ) / minorder );
>     if   maxindex = 0 then
>       return false;
>     elif IsSolvableCharacterTable( tblM ) then
>       return [ tblM, maxindex, 1 ];
>     elif maxindex < 5 then
>       return false;
>     fi;
> 
>     N:= [ 1 ];
>     fact:= tblM;
>     repeat
>       fact:= fact / N;
>       classes:= SizesConjugacyClasses( fact );
>       nsg:= Difference( ClassPositionsOfNormalSubgroups( fact ), [ [ 1 ] ] );
>       N:= First( nsg, x -> IsPrimePowerInt( Sum( classes{ x } ) ) );
>     until N = fail;
> 
>     for i in [ 5 .. maxindex ] do
>       if Length( PermChars( fact, rec( torso:= [ i ] ) ) ) > 0 then
>         return [ tblM, maxindex, i ];
>       fi;
>     od;
> 
>     return false;
> end;;
gap> solvinfo:= Filtered( List(
>         AllCharacterTableNames( IsSporadicSimple, true,
>                                 IsDuplicateTable, false ),
>         MaximalSolvableSubgroupInfoFromTom ), x -> x <> false );;
gap> for entry in solvinfo do
>      MaxSolv.( entry[1] ):= entry[2];
>    od;
gap> for entry in solvinfo do                                 
>      Print( String( entry[1], 5 ), String( entry[2], 7 ),
>             String( entry[3], 28 ), "\n" );
>    od;
  Co3  69984     [ [ 3849120, 699840 ] ]
   HS   2000      [ [ 252000, 252000 ] ]
   He  13824  [ [ 138240 ], [ 138240 ] ]
   J1    168                 [ [ 168 ] ]
   J2   1152                [ [ 1152 ] ]
   J3   1944                [ [ 1944 ] ]
  M11    144                 [ [ 144 ] ]
  M12    432        [ [ 432 ], [ 432 ] ]
  M22    576                [ [ 5760 ] ]
  M23   1152         [ [ 40320, 5760 ] ]
  M24  13824              [ [ 138240 ] ]
  McL  11664      [ [ 3265920, 58320 ] ]
gap> MaxSolv.( "HS.2" ):= 2 * MaxSolv.( "HS" );;
gap> n:= 2^(4+4) * ( 6 * 6 ) * 2;  MaxSolv.( "He.2" ):= n;;
18432
gap> List( [ Size( CharacterTable( "S4(4).4" ) ),
>            Factorial( 5 )^2 * 2,
>            Size( CharacterTable( "2^2.L3(4).D12" ) ),
>            2^7 * Size( CharacterTable( "L3(2)" ) ) * 2,
>            7^2 * 2 * Size( CharacterTable( "L2(7)" ) ) * 2,
>            3 * Factorial( 7 ) * 2 ], i -> Int( i / n ) );
[ 212, 1, 52, 2, 1, 1 ]
gap> MaxSolv.( "J2.2" ):= 2 * MaxSolv.( "J2" );;
gap> MaxSolv.( "J3.2" ):= 2 * MaxSolv.( "J3" );;
gap> info:= MaximalSolvableSubgroupInfoFromTom( "M12.2" );
[ "M12.2", 432, [ [ 95040 ] ] ]
gap> MaxSolv.( "M12.2" ):= info[2];;
gap> MaxSolv.( "M22.2" ):= 2 * MaxSolv.( "M22" );;
gap> MaxSolv.( "McL.2" ):= 2 * MaxSolv.( "McL" );;
gap> t:= CharacterTable( "Ru" );;
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 49152;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "2^3+8:L3(2)" ), 7, 7 ], 
  [ CharacterTable( "2.2^4+6:S5" ), 5, 5 ] ]
gap> MaxSolv.( "Ru" ):= n;;
gap> s:= info[1][1];;
gap> cls:= SizesConjugacyClasses( s );;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( s ),
>                    x -> Sum( cls{ x } ) = 2^3 );
[ [ 1, 2 ] ]
gap> cls{ nsg[1] };
[ 1, 7 ]
gap> GetFusionMap( s, t ){ nsg[1] };
[ 1, 2 ]
gap> t:= CharacterTable( "Suz" );;
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 139968;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "G2(4)" ), 1797, 416 ], 
  [ CharacterTable( "3_2.U4(3).2_3'" ), 140, 72 ], 
  [ CharacterTable( "3^5:M11" ), 13, 11 ], 
  [ CharacterTable( "2^4+6:3a6" ), 7, 6 ], 
  [ CharacterTable( "3^2+4:2(2^2xa4)2" ), 1, 1 ] ]
gap> MaxSolv.( "Suz" ):= n;;
gap> MaxSolv.( "Suz.2" ):= 2 * n;;
gap> t:= CharacterTable( "ON" );;                                            
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 25920;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "L3(7).2" ), 144, 114 ], 
  [ CharacterTable( "ONM2" ), 144, 114 ], 
  [ CharacterTable( "3^4:2^(1+4)D10" ), 1, 1 ] ]
gap> MaxSolv.( "ON" ):= n;;
gap> MaxSolv.( "ON.2" ):= 2 * n;;
gap> t:= CharacterTable( "Co2" );;                                           
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 2359296;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "U6(2).2" ), 7796, 672 ], 
  [ CharacterTable( "2^10:m22:2" ), 385, 22 ], 
  [ CharacterTable( "McL" ), 380, 275 ], 
  [ CharacterTable( "2^1+8:s6f2" ), 315, 28 ], 
  [ CharacterTable( "2^1+4+6.a8" ), 17, 8 ], 
  [ CharacterTable( "U4(3).D8" ), 11, 8 ], 
  [ CharacterTable( "2^(4+10)(S5xS3)" ), 5, 5 ] ]
gap> s:= info[7][1];
CharacterTable( "2^(4+10)(S5xS3)" )
gap> cls:= SizesConjugacyClasses( s );;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( s ),
>                    x -> Sum( cls{ x } ) = 2^4 );
[ [ 1, 2, 3 ] ]
gap> cls{ nsg[1] };
[ 1, 5, 10 ]
gap> GetFusionMap( s, t ){ nsg[1] };
[ 1, 2, 3 ]
gap> MaxSolv.( "Co2" ):= n;;
gap> t:= CharacterTable( "Fi22" );;
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 5038848;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "2.U6(2)" ), 3650, 672 ], 
  [ CharacterTable( "O7(3)" ), 910, 351 ], 
  [ CharacterTable( "Fi22M3" ), 910, 351 ], 
  [ CharacterTable( "O8+(2).3.2" ), 207, 6 ], 
  [ CharacterTable( "2^10:m22" ), 90, 22 ], 
  [ CharacterTable( "3^(1+6):2^(3+4):3^2:2" ), 1, 1 ] ]
gap> MaxSolv.( "Fi22" ):= n;;
gap> MaxSolv.( "Fi22.2" ):= 2 * n;;
gap> t:= CharacterTable( "HN" );; 
gap> mx:= List( Maxes( t ), CharacterTable );;                               
gap> n:= 2000000;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "A12" ), 119, 12 ], 
  [ CharacterTable( "5^(1+4):2^(1+4).5.4" ), 1, 1 ] ]
gap> MaxSolv.( "HN" ):= n;;
gap> MaxSolv.( "HN.2" ):= 2 * n;;
gap> t:= CharacterTable( "Ly" );;                                            
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 900000;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "G2(5)" ), 6510, 3906 ], 
  [ CharacterTable( "3.McL.2" ), 5987, 275 ], 
  [ CharacterTable( "5^3.psl(3,5)" ), 51, 31 ], 
  [ CharacterTable( "2.A11" ), 44, 11 ], 
  [ CharacterTable( "5^(1+4):4S6" ), 10, 6 ] ]
gap> MaxSolv.( "Ly" ):= n;;
gap> t:= CharacterTable( "Th" );;
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 944784;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "2^5.psl(5,2)" ), 338, 31 ], 
  [ CharacterTable( "2^1+8.a9" ), 98, 9 ], 
  [ CharacterTable( "U3(8).6" ), 35, 6 ], [ CharacterTable( "ThN3B" ), 1, 1 ],
  [ CharacterTable( "ThM7" ), 1, 1 ] ]
gap> MaxSolv.( "Th" ):= n;;
gap> t:= CharacterTable( "Fi23" );;
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 3265173504;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "2.Fi22" ), 39545, 3510 ], 
  [ CharacterTable( "O8+(3).3.2" ), 9100, 6 ], 
  [ CharacterTable( "3^(1+8).2^(1+6).3^(1+2).2S4" ), 1, 1 ] ]
gap> MaxSolv.( "Fi23" ):= n;;
gap> t:= CharacterTable( "Co1" );;                                           
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 84934656;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "Co2" ), 498093, 2300 ], 
  [ CharacterTable( "3.Suz.2" ), 31672, 1782 ], 
  [ CharacterTable( "2^11:M24" ), 5903, 24 ], 
  [ CharacterTable( "Co3" ), 5837, 276 ], 
  [ CharacterTable( "2^(1+8)+.O8+(2)" ), 1050, 120 ], 
  [ CharacterTable( "U6(2).3.2" ), 649, 6 ], 
  [ CharacterTable( "2^(2+12):(A8xS3)" ), 23, 8 ], 
  [ CharacterTable( "2^(4+12).(S3x3S6)" ), 10, 6 ] ]
gap> MaxSolv.( "Co1" ):= n;;
gap> t:= CharacterTable( "J4" );; 
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 28311552;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );
[ [ CharacterTable( "mx1j4" ), 17710, 24 ], 
  [ CharacterTable( "c2aj4" ), 770, 22 ], 
  [ CharacterTable( "2^10:L5(2)" ), 361, 31 ], 
  [ CharacterTable( "J4M4" ), 23, 5 ] ]
gap> s:= info[1][1];
CharacterTable( "mx1j4" )
gap> cls:= SizesConjugacyClasses( s );;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( s ),
>                    x -> Sum( cls{ x } ) = 2^11 );
[ [ 1, 2, 3 ] ]
gap> cls{ nsg[1] };
[ 1, 276, 1771 ]
gap> GetFusionMap( s, t ){ nsg[1] };
[ 1, 3, 2 ]
gap> MaxSolv.( "J4" ):= n;;
gap> t:= CharacterTable( "Fi24'" );;
gap> mx:= List( Maxes( t ), CharacterTable );;
gap> n:= 29386561536;;
gap> info:= List( mx, x -> SolvableSubgroupInfoFromCharacterTable( x, n ) );;
gap> info:= Filtered( info, IsList );                                        
[ [ CharacterTable( "Fi23" ), 139161244, 31671 ], 
  [ CharacterTable( "2.Fi22.2" ), 8787, 3510 ], 
  [ CharacterTable( "(3xO8+(3):3):2" ), 3033, 6 ], 
  [ CharacterTable( "O10-(2)" ), 851, 495 ], 
  [ CharacterTable( "3^(1+10):U5(2):2" ), 165, 165 ], 
  [ CharacterTable( "2^2.U6(2).3.2" ), 7, 6 ] ]
gap> MaxSolv.( "Fi24'" ):= n;;
gap> MaxSolv.( "Fi24'.2" ):= 2 * n;;
gap> n:= 29686813949952;;
gap> n = 2^(2+10+20) * 2^4 * 3^2 * 8 * 6;
true
gap> n = 2^(2+10+20) * MaxSolv.( "M22.2" ) * 6;
true
gap> b:= CharacterTable( "B" );;
gap> mx:= List( Maxes( b ), CharacterTable );;
gap> Filtered( mx, x -> Size( x ) >= n );
[ CharacterTable( "2.2E6(2).2" ), CharacterTable( "2^(1+22).Co2" ), 
  CharacterTable( "Fi23" ), CharacterTable( "2^(9+16).S8(2)" ), 
  CharacterTable( "Th" ), CharacterTable( "(2^2xF4(2)):2" ), 
  CharacterTable( "2^(2+10+20).(M22.2xS3)" ), CharacterTable( "[2^30].L5(2)" )
    , CharacterTable( "S3xFi22.2" ), CharacterTable( "[2^35].(S5xL3(2))" ), 
  CharacterTable( "HN.2" ), CharacterTable( "O8+(3).S4" ) ]
gap> List( [ 2^(1+22) * MaxSolv.( "Co2" ),
>            MaxSolv.( "Fi23" ),
>            MaxSolv.( "Th" ),
>            6 * MaxSolv.( "Fi22.2" ),
>            MaxSolv.( "HN.2" ) ], i -> Int( i / n ) );
[ 0, 0, 0, 0, 0 ]
gap> List( [ Size( CharacterTable( "2.2E6(2).2" ) ),
>            2^(9+16) * Size( CharacterTable( "S8(2)" ) ),
>            2^3 * Size( CharacterTable( "F4(2)" ) ),
>            2^(2+10+20) * Size( CharacterTable( "M22.2" ) ) * 6,
>            2^30 * Size( CharacterTable( "L5(2)" ) ),
>            2^35 * Factorial(5) * Size( CharacterTable( "L3(2)" ) ),
>            Size( CharacterTable( "O8+(3)" ) ) * 24 ],
>          i -> Int( i / n ) );
[ 10311982931, 53550, 892, 770, 361, 23, 4 ]
gap> List( [ 2^(1+20) * Size( CharacterTable( "U6(2)" ) ),
>            2^(8+16) * Size( CharacterTable( "O8-(2)" ) ),
>            Size( CharacterTable( "F4(2)" ) ),
>            2^(2+9+18) * Size( CharacterTable( "L3(4)" ) ) * 6,
>            Size( CharacterTable( "Fi22" ) ),
>            Size( CharacterTable( "O10-(2)" ) ),
>            2^(3+12+15) * 120 * Size( CharacterTable( "L3(2)" ) ),
>            6 * Size( CharacterTable( "U6(2)" ) ) ],
>          i -> Int( i / ( n / 4 ) ) );
[ 2598, 446, 446, 8, 8, 3, 2, 0 ]
gap> 2^(9+16+3+8) * 6 * 72 = n;
true
gap> index:= Int( 2^(9+16) * Size( CharacterTable( "S8(2)" ) ) / n );
53550
gap> List( [ 120, 136, 255, 2295 ], i -> Int( index / i ) );
[ 446, 393, 210, 23 ]
gap> MaxSolv.( "B" ):= n;;
gap> h:= mx[2];
CharacterTable( "2^(1+22).Co2" )
gap> pos:= Positions( GetFusionMap( h, b ), 3 );
[ 2, 4, 11, 20 ]
gap> pos:= Filtered( Difference( pos, [ 2 ] ), i -> ForAny( pos,
>             j -> NrPolyhedralSubgroups( h, 2, i, j ).number <> 0 ) );
[ 4, 11 ]
gap> SizesConjugacyClasses( h ){ pos };
[ 93150, 7286400 ]
gap> nr:= NrPolyhedralSubgroups( b, 3, 3, 3 );
rec( number := 14399283809600746875, type := "V4" )
gap> n0:= nr.number;;
gap> cand:= List( pos, i -> Size( b ) / SizesCentralizers( h )[i] / 6 );
[ 181758140654146875, 14217525668946600000 ]
gap> Sum( cand ) = n0;
true
gap> List( cand, x -> Size( b ) / x );
[ 22858846741463040, 292229574819840 ]
gap> m:= mx[7];
CharacterTable( "2^(2+10+20).(M22.2xS3)" )
gap> Size( m );
22858846741463040
gap> nsg:= ClassPositionsOfMinimalNormalSubgroups( m );
[ [ 1, 2 ] ]
gap> SizesConjugacyClasses( m ){ nsg[1] };
[ 1, 3 ]
gap> GetFusionMap( m, b ){ nsg[1] };
[ 1, 3 ]
gap> List( cand, x -> Size( b ) / ( n * x ) );
[ 770, 315/32 ]
gap> m:= mx[4];
CharacterTable( "2^(9+16).S8(2)" )
gap> nsg:= ClassPositionsOfMinimalNormalSubgroups( m );
[ [ 1, 2 ] ]
gap> SizesConjugacyClasses( m ){ nsg[1] };
[ 1, 255 ]
gap> GetFusionMap( m, b ){ nsg[1] };
[ 1, 3 ]
gap> CharacterDegrees( CharacterTable( "S8(2)" ) mod 2 );
[ [ 1, 1 ], [ 8, 1 ], [ 16, 1 ], [ 26, 1 ], [ 48, 1 ], [ 128, 1 ], 
  [ 160, 1 ], [ 246, 1 ], [ 416, 1 ], [ 768, 1 ], [ 784, 1 ], [ 2560, 1 ], 
  [ 3936, 1 ], [ 4096, 1 ], [ 12544, 1 ], [ 65536, 1 ] ]
gap> permg:= AtlasGroup( "S8(2)", NrMovedPoints, 5355 );
<permutation group of size 47377612800 with 2 generators>
gap> matg:= AtlasGroup( "S8(2)", Dimension, 8 );
<matrix group of size 47377612800 with 2 generators>
gap> hom:= GroupHomomorphismByImagesNC( matg, permg,
>              GeneratorsOfGroup( matg ), GeneratorsOfGroup( permg ) );;
gap> max:= PreImages( hom, Stabilizer( permg, 1 ) );;
gap> m:= GModuleByMats( GeneratorsOfGroup( max ), GF(2) );;
gap> comp:= MTX.CompositionFactors( m );;
gap> List( comp, r -> r.dimension );
[ 2, 4, 2 ]
gap> n:= 2^25 * MaxSolv.( "Co1" );
2849934139195392
gap> 2^(2+11+22) * MaxSolv.( "M24" ) * 6 = n;    
true
gap> 2^39 * 24 * 3 * 72 = n;                 
true
gap> cand:= [ "L2(13)", "Sz(8)", "U3(4)", "U3(8)" ];;
gap> List( cand, nam -> ExtensionInfoCharacterTable( 
> CharacterTable( nam ) ) );
[ [ "2", "2" ], [ "2^2", "3" ], [ "", "4" ], [ "3", "(3xS3)" ] ]
gap> ll:= List( cand, x -> Size( CharacterTable( x ) ) );
[ 1092, 29120, 62400, 5515776 ]
gap> 18* ll[4];
99283968
gap> 2^39 * 24 * 3 * 72;
2849934139195392
gap> List( [ 2 * MaxSolv.( "B" ),
>            6 * MaxSolv.( "Fi24'" ),
>            3^13 * 2 * MaxSolv.( "Suz" ) * 2,
>            6 * MaxSolv.( "Th" ),
>            10 * MaxSolv.( "HN" ) * 2 ], i -> Int( i / n ) );
[ 0, 0, 0, 0, 0 ]
gap> n / MaxSolv.( "B" );
96
gap> Int( 3^8 * Size( CharacterTable( "O8-(3)" ) ) * 2 / n );
46
gap> Int( 2^(10+16) * Size( CharacterTable( "O10+(2)" ) ) / n );    
553350
gap> Int( 2^(5+10+20) * 6 * Size( CharacterTable( "L5(2)" ) ) / n );  
723
gap> Int( 723 / 31 );
23
gap> index:= Int( 2^(10+16) * Size( CharacterTable( "O10+(2)" ) ) / n );    
553350
gap> List( [ 496, 527, 2295, 19840, 23715, 118575 ], i -> Int( index / i ) );
[ 1115, 1050, 241, 27, 23, 4 ]
gap> MaxSolv.( "M" ):= n;;
gap> m:= CharacterTable( "M" );;
gap> h:= CharacterTable( "2^1+24.Co1" );
CharacterTable( "2^1+24.Co1" )
gap> pos:= Positions( GetFusionMap( h, m ), 3 );
[ 2, 4, 7, 9, 16 ]
gap> pos:= Filtered( Difference( pos, [ 2 ] ), i -> ForAny( pos,
>             j -> NrPolyhedralSubgroups( h, 2, i, j ).number <> 0 ) );
[ 4, 9, 16 ]
gap> SizesConjugacyClasses( h ){ pos };
[ 16584750, 3222483264000, 87495303168000 ]
gap> nr:= NrPolyhedralSubgroups( m, 3, 3, 3 );
rec( number := 87569110066985387357550925521828244921875, type := "V4" )
gap> n0:= nr.number;;
gap> cand:= List( pos, i -> Size( m ) / SizesCentralizers( h )[i] / 6 );
[ 16009115629875684006343550944921875, 
  3110635203347364905168577322802100000000, 
  84458458854522392576698341855475200000000 ]
gap> Sum( cand ) = n0;
true
gap> List( cand, x -> Size( m ) / x );
[ 50472333605150392320, 259759622062080, 9567039651840 ]
gap> g:= AtlasGroup( "2^(2+11+22).(M24xS3)" );
<permutation group of size 50472333605150392320 with 2 generators>
gap> NrMovedPoints( g );
294912
gap> bl:= Blocks( g, MovedPoints( g ) );;
gap> Length( bl );
147456
gap> hom1:= ActionHomomorphism( g, bl, OnSets );;
gap> act1:= Image( hom1 );;
gap> Size( g ) / Size( act1 );
8192
gap> bl2:= Blocks( act1, MovedPoints( act1 ) );;
gap> Length( bl2 );
72
gap> hom2:= ActionHomomorphism( act1, bl2, OnSets );;
gap> act2:= Image( hom2 );;
gap> Size( act2 );
1468938240
gap> Size( MathieuGroup( 24 ) ) * 6;
1468938240
gap> bl3:= AllBlocks( act2 );;
gap> List( bl3, Length );                                             
[ 24, 3 ]
gap> bl3:= Orbit( act2, bl3[2], OnSets );;
gap> hom3:= ActionHomomorphism( act2, bl3, OnSets );;
gap> act3:= Image( hom3 );;
gap> tom:= TableOfMarks( "M24" );;
gap> tomgroup:= UnderlyingGroup( tom );;
gap> iso:= IsomorphismGroups( act3, tomgroup );;
gap> pos:= Positions( OrdersTom( tom ), 13824 );
[ 1508 ]
gap> sub:= RepresentativeTom( tom, pos[1] );;
gap> pre:= PreImages( iso, sub );;
gap> pre:= PreImages( hom3, pre );;
gap> pre:= PreImages( hom2, pre );;
gap> pre:= PreImages( hom1, pre );;
gap> Size( pre ) = n;
true
gap> pciso:= IsomorphismPcGroup( pre );;
gap> Size( Centre( Image( pciso ) ) );
1
gap> Filtered( Set( RecNames( MaxSolv ) ), 
>              x -> MaxSolv.( x )^2 >= Size( CharacterTable( x ) ) );
[ "Fi23", "J2", "J2.2", "M11", "M12", "M22.2" ]

gap> STOP_TEST( "sporsolv.tst", 3000000000 );

#############################################################################
##
#E

