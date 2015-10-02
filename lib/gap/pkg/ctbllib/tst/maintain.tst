# This file was created from xpl/maintain.xpl, do not edit!
#############################################################################
##
#W  maintain.tst                GAP applications              Thomas Breuer
##
#Y  Copyright 2006,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,   Germany
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `ReadTest( "maintain.tst" );`.
##

gap> START_TEST( "maintain.tst" );

gap> tbl:= rec(
>   Identifier:= "P41/G1/L1/V4/ext2",
>   InfoText:= Concatenation( [
>     "origin: Hanrath library,\n",
>     "structure is 2^7.L2(8),\n",
>     "characters sorted with permutation (12,14,15,13)(19,20)" ] ),
>   UnderlyingCharacteristic:= 0,
>   SizesCentralizers:= [64512,1024,1024,64512,64,64,64,64,128,128,64,64,128,
>     128,18,18,14,14,14,14,14,14,18,18,18,18,18,18],
>   ComputedPowerMaps:= [,[1,1,1,1,2,3,3,2,3,2,2,1,3,2,16,16,20,20,22,22,18,
>     18,26,26,27,27,23,23],[1,2,3,4,5,6,7,8,9,10,11,12,13,14,4,1,21,22,17,
>     18,19,20,16,15,15,16,16,15],,,,[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
>     4,1,4,1,4,1,26,25,28,27,23,24]],
>   Irr:= 0,
>   AutomorphismsOfTable:= Group( [(23,26,27)(24,25,28),(9,13)(10,14),
>     (17,19,21)(18,20,22)] ),
>   ConstructionInfoCharacterTable:= ["ConstructClifford",[[[1,2,3,4,5,6,7,8,
>     9],[1,7,8,3,9,2],[1,4,5,6,2],[1,2,2,2,2,2,2,2]],[["L2(8)"],["Dihedral",
>     18],["Dihedral",14],["2^3"]],[[[1,2,3,4],[1,1,1,1],["elab",4,25]],[[1,
>     2,3,4,4,4,4,4,4,4],[2,6,5,2,3,4,5,6,7,8],["elab",10,17]],[[1,2],[3,4],[
>     [1,1],[-1,1]]],[[1,3],[4,2],[[1,1],[-1,1]]],[[1,3],[5,3],[[1,1],[-1,1]]
>     ],[[1,3],[6,4],[[1,1],[-1,1]]],[[1,2],[7,2],[[1,1],[1,-1]]],[[1,2],[8,
>     3],[[1,1],[-1,1]]],[[1,2],[9,5],[[1,1],[1,-1]]]]]],
>   );;
gap> ConstructClifford( tbl, tbl.ConstructionInfoCharacterTable[2] );
gap> ConvertToLibraryCharacterTableNC( tbl );;
gap> Length( LinearCharacters( tbl ) );
1
gap> IsPerfectCharacterTable( tbl );
true
gap> IsInternallyConsistent( tbl );
true
gap> irr:= Irr( tbl );;
gap> test:= Concatenation( List( [ 2 .. 7 ],
>               n -> Symmetrizations( tbl, irr, n ) ) );;
gap> Append( test, Set( Tensored( irr, irr ) ) );
gap> fail in Decomposition( irr, test, "nonnegative" );
false
gap> if ForAny( Tuples( [ 1 .. NrConjugacyClasses( tbl ) ], 3 ),
>      t -> not ClassMultiplicationCoefficient( tbl, t[1], t[2], t[3] )
>               in NonnegativeIntegers ) then
>      Error( "contradiction" );
> fi;
gap> n:= Size( tbl );
64512
gap> NumberPerfectGroups( n );
4
gap> grps:= List( [ 1 .. 4 ], i -> PerfectGroup( IsPermGroup, n, i ) );
[ L2(8) 2^6 E 2^1, L2(8) N 2^6 E 2^1 I, L2(8) N 2^6 E 2^1 II, 
  L2(8) N 2^6 E 2^1 III ]
gap> tbls:= List( grps, CharacterTable );;
gap> List( tbls, x -> TransformingPermutationsCharacterTables( x, tbl ) );
[ fail, fail, fail, fail ]
gap> List( tbls, t -> TransformingPermutations( Irr( t ), Irr( tbl ) ) );
[ fail, fail, fail, fail ]
gap> testchars:= List( tbls,
>   t -> Filtered( Irr( t ),
>          x -> x[1] = 63 and Set( x ) = [ -1, 0, 7, 63 ] ) );;
gap> List( testchars, Length );
[ 1, 1, 1, 1 ]
gap> List( testchars, l -> Number( l[1], x -> x = 7 ) );
[ 2, 2, 2, 2 ]
gap> testchars:= List( [ tbl ],
>   t -> Filtered( Irr( t ),
>          x -> x[1] = 63 and Set( x ) = [ -1, 0, 7, 63 ] ) );;
gap> List( testchars, Length );
[ 1 ]
gap> List( testchars, l -> Number( l[1], x -> x = 7 ) );
[ 1 ]
gap> Filtered( [ 1 .. 4 ], i ->
>        TransformingPermutationsCharacterTables( tbls[i],
>            CharacterTable( "P41/G1/L1/V1/ext2" ) ) <> fail );
[ 1 ]
gap> Filtered( [ 1 .. 4 ], i ->
>        TransformingPermutationsCharacterTables( tbls[i],
>            CharacterTable( "P41/G1/L1/V2/ext2" ) ) <> fail );
[ 3 ]
gap> TransformingPermutations( Irr( tbls[1] ), Irr( tbls[3] ) ) <> fail;
true
gap> Filtered( [ 1 .. 4 ], i ->
>        TransformingPermutationsCharacterTables( tbls[i],
>            CharacterTable( "P41/G1/L1/V4/ext2" ) ) <> fail );
[ 4 ]
gap> TransformingPermutations( Irr( tbls[2] ), Irr( tbls[4] ) ) <> fail;
true 

gap> STOP_TEST( "maintain.tst", 3000000000 );

#############################################################################
##
#E

