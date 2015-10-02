# This file was created from xpl/ctblj4.xpl, do not edit!
#############################################################################
##
#W  ctblj4.tst                GAP applications              Thomas Breuer
##
#Y  Copyright 1999,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,   Germany
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `ReadTest( "ctblj4.tst" );`.
##

gap> START_TEST( "ctblj4.tst" );

gap> LoadPackage( "ctbllib" );
true
gap> tbl:= CharacterTable( "J4" );
CharacterTable( "J4" )
gap> NrConjugacyClasses( tbl );
62
gap> irreducibles:= Irr( tbl ){ [ 1, 2 ] };
[ Character( CharacterTable( "J4" ), [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
      1 ] ), Character( CharacterTable( "J4" ), 
    [ 1333, 53, -11, 10, -11, 5, -3, 3, -10, 2, -2, E(7)+E(7)^2+E(7)^4, 
      E(7)^3+E(7)^5+E(7)^6, 1, -3, 1, 3, -1, 2, 2, -2, 2, 0, 
      -E(7)-E(7)^2-E(7)^4, -E(7)^3-E(7)^5-E(7)^6, E(7)+E(7)^2+E(7)^4, 
      E(7)^3+E(7)^5+E(7)^6, 0, -1, -1, -1, E(7)+E(7)^2+E(7)^4, 
      E(7)^3+E(7)^5+E(7)^6, -2, 0, -1, 0, 0, -E(7)-E(7)^2-E(7)^4, 
      -E(7)^3-E(7)^5-E(7)^6, -1, 0, 0, 0, 0, -1, -1, E(7)+E(7)^2+E(7)^4, 
      E(7)^3+E(7)^5+E(7)^6, 1, 1, 1, 1, 1, -E(7)-E(7)^2-E(7)^4, 
      -E(7)^3-E(7)^5-E(7)^6, 0, 0, 0, 0, 1, 1 ] ) ]
gap> max:= CharacterTable( Maxes( tbl )[1] );;
gap> pi:= TrivialCharacter( max ) ^ tbl;
Character( CharacterTable( "J4" ), [ 173067389, 52349, 8317, 737, 957, 253, 
  141, 14, 77, 41, 37, 5, 5, 5, 13, 13, 14, 2, 0, 11, 9, 13, 3, 3, 3, 1, 1, 
  2, 1, 2, 2, 2, 2, 0, 1, 2, 1, 1, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] )
gap> AddSet( irreducibles, ComplexConjugate( irreducibles[2] ) );
gap> indcyc:= InducedCyclic( tbl, "all" );;
gap> sym2:= Symmetrizations( tbl, irreducibles, 2 );;
gap> sym3:= Symmetrizations( tbl, irreducibles, 3 );;
gap> SetInfoLevel( InfoCharacterTable, 2 );
gap> chars:= Concatenation( indcyc, [ pi ], sym2, sym3 );;
gap> Length( chars );
220
gap> chars:= ReducedCharacters( tbl, irreducibles, chars );;
#I  ReducedCharacters: irreducible character of degree 887778 found
#I  ReducedCharacters: irreducible character of degree 889111 found
#I  ReducedCharacters: irreducible character of degree 887778 found
#I  ReducedCharacters: irreducible character of degree 393877506 found
#I  ReducedCharacters: irreducible character of degree 789530568 found
gap> Length( chars.irreducibles );
5
gap> Length( chars.remainders );
206
gap> newirr:= chars.irreducibles;;
gap> lll:= LLL( tbl, chars.remainders );;
#I  LLL: 4 irreducibles found
gap> List( lll.irreducibles, Degree );
[ 1981808640, 1981808640, 1981808640, 2267824128 ]
gap> Append( newirr, lll.irreducibles );
gap> chars:= ReducedCharacters( tbl, lll.irreducibles, chars.remainders );;
gap> Length( lll.remainders );
50
gap> lll.norms;
[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 2, 5, 4, 5, 4, 4, 5, 3,
  6, 6, 8, 4, 6, 6, 4, 8, 8, 7, 9, 7, 6, 7, 7, 8, 6, 9, 7, 7, 4, 6, 7, 8, 5 ]
gap> lll:= ReducedClassFunctions( tbl, lll.irreducibles, lll.remainders );;
gap> Append( irreducibles, newirr );
gap> Length( irreducibles );
12
gap> sym2:= Symmetrizations( tbl, newirr, 2 );;
gap> sym3:= Symmetrizations( tbl, newirr, 3 );;
gap> newchars:= Concatenation( sym2, sym3 );;
gap> newchars:= ReducedCharacters( tbl, irreducibles, newchars );;
gap> chars:= Concatenation( chars.remainders, newchars.remainders );;
gap> lll:= LLL( tbl, chars );;
#I  LLL: 35 irreducibles found
gap> lll.norms;
[ 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2 ]
gap> Append( irreducibles, lll.irreducibles );
gap> Length( irreducibles );
47
gap> dn:= DnLatticeIterative( tbl, lll );;
#I  ReducedClassFunctions: irreducible character of degree 786127419 found
#I  ReducedClassFunctions: irreducible character of degree 786127419 found
#I  ReducedClassFunctions: irreducible character of degree 1579061136 found
#I  ReducedClassFunctions: irreducible character of degree 2727495848 found
#I  ReducedClassFunctions: irreducible character of degree 3403149 found
#I  ReducedClassFunctions: irreducible character of degree 786127419 found
#I  ReducedClassFunctions: irreducible character of degree 230279749 found
#I  ReducedClassFunctions: irreducible character of degree 1842237992 found
gap> Length( dn.irreducibles );
9
gap> Append( irreducibles, dn.irreducibles );
gap> Length( irreducibles );
56
gap> dn.norms;
[ 2, 2, 2, 2, 2, 2 ]
gap> gram:= MatScalarProducts( tbl, dn.remainders, dn.remainders );
[ [ 2, 0, 0, 0, 0, 0 ], [ 0, 2, 0, 0, -1, 0 ], [ 0, 0, 2, 0, -1, 0 ], 
  [ 0, 0, 0, 2, 0, 0 ], [ 0, -1, -1, 0, 2, 1 ], [ 0, 0, 0, 0, 1, 2 ] ]
gap> emb:= OrthogonalEmbeddingsSpecialDimension( tbl, dn.remainders, gram, 6 );;
#I  Decreased : computation of 2nd character failed
gap> Length( emb.irreducibles );
2
gap> Append( irreducibles, emb.irreducibles );
gap> chars:= emb.remainders;;
gap> gram:= MatScalarProducts( tbl, chars, chars );
[ [ 2, 0, -1, 0 ], [ 0, 2, -1, 0 ], [ -1, -1, 2, 1 ], [ 0, 0, 1, 2 ] ]
gap> emb:= OrthogonalEmbeddings( gram, 4 );
rec( vectors := [ [ -1, -1, 1, 0 ], [ -1, 1, 0, 0 ], [ -1, 0, 1, 1 ],
      [ -1, 0, 1, 0 ], [ 1, 0, 0, 1 ], [ 1, 0, 0, 0 ], [ 0, -1, 1, 1 ],
      [ 0, -1, 1, 0 ], [ 0, 1, 0, 1 ], [ 0, 1, 0, 0 ], [ 0, 0, 1, 1 ],
      [ 0, 0, 0, 1 ] ], norms := [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
  solutions := [ [ 1, 2, 11, 12 ], [ 3, 5, 8, 10 ], [ 4, 6, 7, 9 ] ] )
gap> dec1:= Decreased( tbl, chars, emb.vectors{ emb.solutions[1] } );
#I  Decreased : computation of 1st character failed
fail
gap> dec2:= Decreased( tbl, chars, emb.vectors{ emb.solutions[2] } );;
gap> Length( dec2.irreducibles );
4
gap> dec3:= Decreased( tbl, chars, emb.vectors{ emb.solutions[3] } );;
gap> Length( dec3.irreducibles );
4
gap> Intersection( dec2.irreducibles, dec3.irreducibles );
[  ]
gap> sym2:= Symmetrizations( tbl, dec2.irreducibles, 2 );;
gap> ScalarProduct( dec2.irreducibles[1], sym2[1] );
7998193/2
gap> irr:= Concatenation( irreducibles, dec2.irreducibles );;
gap> pow:= PossiblePowerMaps( tbl, 2, rec( chars:= irr, subchars:= irr ) );
#I  PossiblePowerMaps: 2nd power map initialized; congruences, kernels and
#I    maps for smaller primes considered,
#I    the current indeterminateness is 839808.
#I  PossiblePowerMaps: no test of decomposability allowed
#I  PossiblePowerMaps: test scalar products of minus-characters
#I  PowerMapsAllowedBySymmetrizations: no character with indeterminateness
#I    between 1 and 100000 significant now
#I  PossiblePowerMaps: 1 solution(s)
[ [ 1, 1, 1, 4, 2, 2, 3, 8, 4, 4, 4, 12, 13, 5, 6, 6, 8, 8, 19, 20, 10, 10, 
      11, 12, 13, 12, 13, 28, 16, 17, 17, 32, 33, 19, 20, 36, 22, 22, 26, 27, 
      41, 28, 43, 44, 45, 46, 47, 48, 49, 51, 52, 50, 30, 31, 32, 33, 57, 58, 
      59, 34, 46, 47 ] ]
gap> pow[1] = PowerMap( tbl, 2 );
false
gap> irr:= Concatenation( irreducibles, dec3.irreducibles );;
gap> Set( irr ) = Set( Irr( tbl ) );
true
gap> SetInfoLevel( InfoCharacterTable, 0 );

gap> STOP_TEST( "ctblj4.tst", 3000000000 );

#############################################################################
##
#E

