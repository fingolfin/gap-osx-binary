# This file was created from xpl/ctblcons.xpl, do not edit!
#############################################################################
##
#W  ctblcons.tst              GAP applications              Thomas Breuer
##
#Y  Copyright 2004,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,   Germany
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `ReadTest( "ctblcons.tst" );`.
##

gap> START_TEST( "ctblcons.tst" );

gap> LoadPackage( "ctbllib", "1.1.4" );
true
gap> RepresentativesCharacterTables:= function( list )
>    local reps, i, found, r;
> 
>    reps:= [];
>    for i in [ 1 .. Length( list ) ] do
>      if ForAll( reps, r -> ( IsCharacterTable( r ) and
>             TransformingPermutationsCharacterTables( list[i], r ) = fail )
>           or ( IsRecord( r ) and TransformingPermutationsCharacterTables(
>                                    list[i].table, r.table ) = fail ) ) then
>        Add( reps, list[i] );
>      fi;
>    od;
>    return reps;
>    end;;
gap> t:= CharacterTable( "2.A6.2_1" );
CharacterTable( "2.A6.2_1" )
gap> TransformingPermutationsCharacterTables( t,
>        CharacterTableIsoclinic( t ) );
rec( columns := (4,6)(5,7)(11,12)(14,16)(15,17), 
  group := Group([ (16,17), (14,15) ]), rows := (3,5)(4,6)(10,11)(12,15,13,
    14) )
gap> t:= CharacterTable( "2.L2(25).2_2" );
CharacterTable( "2.L2(25).2_2" )
gap> TransformingPermutationsCharacterTables( t,
>        CharacterTableIsoclinic( t ) );
rec( columns := (7,9)(8,10)(20,21)(23,24)(25,27)(26,28), 
  group := <permutation group with 4 generators>, 
  rows := (3,5)(4,6)(14,15)(16,17)(19,22,20,21) )
gap> tbls:= [];;
gap> for m in [ "4_1", "4_2" ] do
>      for a in [ "2_1", "2_2", "2_3" ] do
>        Add( tbls, CharacterTable( Concatenation( m, ".L3(4).", a ) ) );
>      od;
>    od;
gap> tbls;
[ CharacterTable( "4_1.L3(4).2_1" ), CharacterTable( "4_1.L3(4).2_2" ), 
  CharacterTable( "4_1.L3(4).2_3" ), CharacterTable( "4_2.L3(4).2_1" ), 
  CharacterTable( "4_2.L3(4).2_2" ), CharacterTable( "4_2.L3(4).2_3" ) ]
gap> case1:= Filtered( tbls, t -> Size( ClassPositionsOfCentre( t ) ) = 2 );
[ CharacterTable( "4_1.L3(4).2_1" ), CharacterTable( "4_1.L3(4).2_2" ), 
  CharacterTable( "4_2.L3(4).2_1" ), CharacterTable( "4_2.L3(4).2_3" ) ]
gap> case2:= Filtered( tbls, t -> Size( ClassPositionsOfCentre( t ) ) = 4 );
[ CharacterTable( "4_1.L3(4).2_3" ), CharacterTable( "4_2.L3(4).2_2" ) ]
gap> isos1:= List( case1, CharacterTableIsoclinic );;
gap> List( [ 1 .. 4 ], i -> Irr( case1[i] ) = Irr( isos1[i] ) );
[ true, true, true, true ]
gap> List( [ 1 .. 4 ],
>      i -> TransformingPermutationsCharacterTables( case1[i], isos1[i] ) );
[ fail, fail, fail, fail ]
gap> isos2:= List( case2, CharacterTableIsoclinic );;
gap> List( [ 1, 2 ],
>      i -> TransformingPermutationsCharacterTables( case2[i], isos2[i] ) );
[ rec( columns := (26,27,28,29)(30,31,32,33)(38,39,40,41)(42,43,44,45), 
      group := <permutation group with 5 generators>, 
      rows := (16,17)(18,19)(20,21)(22,23)(28,29)(32,33)(36,37)(40,41) ), 
  rec( columns := (28,29,30,31)(32,33)(34,35,36,37)(38,39,40,41)(42,43,44,
        45)(46,47,48,49), group := <permutation group with 3 generators>, 
      rows := (15,16)(17,18)(20,21)(22,23)(24,25)(26,27)(28,29)(34,35)(38,
        39)(42,43)(46,47) ) ]
gap> isos3:= List( case2, t -> CharacterTableIsoclinic( t,
>                                ClassPositionsOfCentre( t ) ) );;
gap> List( [ 1, 2 ],
>      i -> TransformingPermutationsCharacterTables( case2[i], isos3[i] ) );
[ fail, fail ]
gap> tblMG:= CharacterTable( "Cyclic", 3 );;
gap> tblG:= CharacterTable( "Cyclic", 1 );;
gap> tblGA:= CharacterTable( "Cyclic", 2 );;
gap> StoreFusion( tblMG, [ 1, 1, 1 ], tblG );
gap> StoreFusion( tblG, [ 1 ], tblGA );
gap> elms:= Elements( AutomorphismsOfTable( tblMG ) );
[ (), (2,3) ]
gap> orbs:= [ [ 1 ], [ 2, 3 ] ];;
gap> new:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, orbs,
>              "S3" );
[ rec( MGfusMGA := [ 1, 2, 2 ], table := CharacterTable( "S3" ) ) ]
gap> Display( new[1].table );
S3

     2  1  .  1
     3  1  1  .

       1a 3a 2a
    2P 1a 3a 1a
    3P 1a 1a 2a

X.1     1  1  1
X.2     1  1 -1
X.3     2 -1  .
gap> tblMG:= CharacterTable( "Cyclic", 4 );;
gap> tblG:= CharacterTable( "Cyclic", 2 );;
gap> tblGA:= CharacterTable( "2^2" );;           
gap> OrdersClassRepresentatives( tblMG );
[ 1, 4, 2, 4 ]
gap> StoreFusion( tblMG, [ 1, 2, 1, 2 ], tblG ); 
gap> StoreFusion( tblG, [ 1, 2 ], tblGA );      
gap> elms:= Elements( AutomorphismsOfTable( tblMG ) );
[ (), (2,4) ]
gap> orbs:= Orbits( Group( elms[2] ), [ 1 ..4 ] );;
gap> new:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, orbs,
>              "order8" );
[ rec( MGfusMGA := [ 1, 2, 3, 2 ], table := CharacterTable( "order8" ) ),
  rec( MGfusMGA := [ 1, 2, 3, 2 ], table := CharacterTable( "order8" ) ) ]
gap> List( new, x -> OrdersClassRepresentatives( x.table ) );
[ [ 1, 4, 2, 2, 2 ], [ 1, 4, 2, 4, 4 ] ]
gap> Display( new[1].table );
order8

     2  3  2  3  2  2

       1a 4a 2a 2b 2c
    2P 1a 2a 1a 1a 1a

X.1     1  1  1  1  1
X.2     1  1  1 -1 -1
X.3     1 -1  1  1 -1
X.4     1 -1  1 -1  1
X.5     2  . -2  .  .
gap> tblMG:= CharacterTable( "7:3" ) * CharacterTable( "A5" );;
gap> nsg:= ClassPositionsOfNormalSubgroups( tblMG );
[ [ 1 ], [ 1, 6 .. 11 ], [ 1 .. 5 ], [ 1, 6 .. 21 ], [ 1 .. 15 ], [ 1 .. 25 ]
 ]
gap> List( nsg, x -> Sum( SizesConjugacyClasses( tblMG ){ x } ) );
[ 1, 7, 60, 21, 420, 1260 ]
gap> tblG:= tblMG / nsg[2];;
gap> tblGA:= CharacterTable( "Cyclic", 3 ) * CharacterTable( "A5.2" );;
gap> GfusGA:= PossibleClassFusions( tblG, tblGA );
[ [ 1, 2, 3, 4, 4, 8, 9, 10, 11, 11, 15, 16, 17, 18, 18 ],
  [ 1, 2, 3, 4, 4, 15, 16, 17, 18, 18, 8, 9, 10, 11, 11 ] ]
gap> reps:= RepresentativesFusions( Group(()), GfusGA, tblGA );
[ [ 1, 2, 3, 4, 4, 8, 9, 10, 11, 11, 15, 16, 17, 18, 18 ] ]
gap> StoreFusion( tblG, reps[1], tblGA );
gap> acts:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4, 5 ], [ 6, 11 ], [ 7, 12 ], [ 8, 13 ],
      [ 9, 15 ], [ 10, 14 ], [ 16 ], [ 17 ], [ 18 ], [ 19, 20 ], [ 21 ],
      [ 22 ], [ 23 ], [ 24, 25 ] ] ]
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA,
>               acts[1], "A12N7" );
[ rec( MGfusMGA := [ 1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 5, 6, 7, 9, 8, 10, 11, 12, 
          13, 13, 14, 15, 16, 17, 17 ], table := CharacterTable( "A12N7" ) ) ]
gap> g:= AlternatingGroup( 12 );;
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                CharacterTable( Normalizer( g, SylowSubgroup( g, 7 ) ) ) ) );
true
gap> tblh1:= CharacterTable( "7:3" );;
gap> tblg1:= CharacterTable( "7:6" );;
gap> tblh2:= CharacterTable( "A5" );;
gap> tblg2:= CharacterTable( "A5.2" );;
gap> subdir:= CharacterTableOfIndexTwoSubdirectProduct( tblh1, tblg1,
>                 tblh2, tblg2, "(7:3xA5).2" );;
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                subdir.table ) );
true
gap> listMGA:= [
> [ "3.A6",        "A6",        "A6.2_1",        "3.A6.2_1"       ],
> [ "3.A6",        "A6",        "A6.2_2",        "3.A6.2_2"       ],
> [ "6.A6",        "2.A6",      "2.A6.2_1",      "6.A6.2_1"       ],
> [ "6.A6",        "2.A6",      "2.A6.2_2",      "6.A6.2_2"       ],
> [ "3.A7",        "A7",        "A7.2",          "3.A7.2"         ],
> [ "6.A7",        "2.A7",      "2.A7.2",        "6.A7.2"         ],
> [ "3.L3(4)",     "L3(4)",     "L3(4).2_2",     "3.L3(4).2_2"    ],
> [ "3.L3(4)",     "L3(4)",     "L3(4).2_3",     "3.L3(4).2_3"    ],
> [ "6.L3(4)",     "2.L3(4)",   "2.L3(4).2_2",   "6.L3(4).2_2"    ],
> [ "6.L3(4)",     "2.L3(4)",   "2.L3(4).2_3",   "6.L3(4).2_3"    ],
> [ "12_1.L3(4)",  "4_1.L3(4)", "4_1.L3(4).2_2", "12_1.L3(4).2_2" ],
> [ "12_1.L3(4)",  "4_1.L3(4)", "4_1.L3(4).2_3", "12_1.L3(4).2_3" ],
> [ "12_2.L3(4)",  "4_2.L3(4)", "4_2.L3(4).2_2", "12_2.L3(4).2_2" ],
> [ "12_2.L3(4)",  "4_2.L3(4)", "4_2.L3(4).2_3", "12_2.L3(4).2_3" ],
> [ "3.U3(5)",     "U3(5)",     "U3(5).2",       "3.U3(5).2"      ],
> [ "3.M22",       "M22",       "M22.2",         "3.M22.2"        ],
> [ "6.M22",       "2.M22",     "2.M22.2",       "6.M22.2"        ],
> [ "12.M22",      "4.M22",     "4.M22.2",       "12.M22.2"       ],
> [ "3.L3(7)",     "L3(7)",     "L3(7).2",       "3.L3(7).2"      ],
> [ "3_1.U4(3)",   "U4(3)",     "U4(3).2_1",     "3_1.U4(3).2_1"  ],
> [ "3_1.U4(3)",   "U4(3)",     "U4(3).2_2'",    "3_1.U4(3).2_2'" ],
> [ "3_2.U4(3)",   "U4(3)",     "U4(3).2_1",     "3_2.U4(3).2_1"  ],
> [ "3_2.U4(3)",   "U4(3)",     "U4(3).2_3'",    "3_2.U4(3).2_3'" ],
> [ "6_1.U4(3)",   "2.U4(3)",   "2.U4(3).2_1",   "6_1.U4(3).2_1"  ],
> [ "6_1.U4(3)",   "2.U4(3)",   "2.U4(3).2_2'",  "6_1.U4(3).2_2'" ],
> [ "6_2.U4(3)",   "2.U4(3)",   "2.U4(3).2_1",   "6_2.U4(3).2_1"  ],
> [ "6_2.U4(3)",   "2.U4(3)",   "2.U4(3).2_3'",  "6_2.U4(3).2_3'" ],
> [ "12_1.U4(3)",  "4.U4(3)",   "4.U4(3).2_1",   "12_1.U4(3).2_1" ],
> [ "12_2.U4(3)",  "4.U4(3)",   "4.U4(3).2_1",   "12_2.U4(3).2_1" ],
> [ "3.G2(3)",     "G2(3)",     "G2(3).2",       "3.G2(3).2"      ],
> [ "3.U3(8)",     "U3(8)",     "U3(8).2",       "3.U3(8).2"      ],
> [ "3.U3(8).3_1", "U3(8).3_1", "U3(8).6",       "3.U3(8).6"      ],
> [ "3.J3",        "J3",        "J3.2",          "3.J3.2"         ],
> [ "3.U3(11)",    "U3(11)",    "U3(11).2",      "3.U3(11).2"     ],
> [ "3.McL",       "McL",       "McL.2",         "3.McL.2"        ],
> [ "3.O7(3)",     "O7(3)",     "O7(3).2",       "3.O7(3).2"      ],
> [ "6.O7(3)",     "2.O7(3)",   "2.O7(3).2",     "6.O7(3).2"      ],
> [ "3.U6(2)",     "U6(2)",     "U6(2).2",       "3.U6(2).2"      ],
> [ "6.U6(2)",     "2.U6(2)",   "2.U6(2).2",     "6.U6(2).2"      ],
> [ "3.Suz",       "Suz",       "Suz.2",         "3.Suz.2"        ],
> [ "6.Suz",       "2.Suz",     "2.Suz.2",       "6.Suz.2"        ],
> [ "3.ON",        "ON",        "ON.2",          "3.ON.2"         ],
> [ "3.Fi22",      "Fi22",      "Fi22.2",        "3.Fi22.2"       ],
> [ "6.Fi22",      "2.Fi22",    "2.Fi22.2",      "6.Fi22.2"       ],
> [ "3.2E6(2)",    "2E6(2)",    "2E6(2).2",      "3.2E6(2).2"     ],
> [ "6.2E6(2)",    "2.2E6(2)",  "2.2E6(2).2",    "6.2E6(2).2"     ],
> [ "3.F3+",       "F3+",       "F3+.2",         "3.F3+.2"        ],
> ];;
gap> Append( listMGA, [
> [ "(2^2x3).L3(4)",  "2^2.L3(4)",   "2^2.L3(4).2_2", "(2^2x3).L3(4).2_2" ],
> [ "(2^2x3).L3(4)",  "2^2.L3(4)",   "2^2.L3(4).2_3", "(2^2x3).L3(4).2_3" ],
> [ "(2^2x3).U6(2)",  "2^2.U6(2)",   "2^2.U6(2).2",   "(2^2x3).U6(2).2"   ],
> [ "(2^2x3).2E6(2)", "2^2.2E6(2)",  "2^2.2E6(2).2",  "(2^2x3).2E6(2).2"  ],
> ] );
gap> Append( listMGA, [
> [ "3.A6.2_3",       "A6.2_3",    "A6.2^2",      "3.A6.2^2"          ],
> [ "3.L3(4).2_1",    "L3(4).2_1", "L3(4).2^2",   "3.L3(4).2^2"       ],
> [ "3_1.U4(3).2_2",  "U4(3).2_2", "U4(3).(2^2)_{122}",
>                                             "3_1.U4(3).(2^2)_{122}" ],
> [ "3_2.U4(3).2_3",  "U4(3).2_3", "U4(3).(2^2)_{133}",
>                                             "3_2.U4(3).(2^2)_{133}" ],
> [ "3^2.U4(3).2_3'", "3_2.U4(3).2_3'", "3_2.U4(3).(2^2)_{133}",
>                                             "3^2.U4(3).(2^2)_{133}" ],
> [ "2^2.L3(4)",      "L3(4)",     "L3(4).3",     "2^2.L3(4).3"       ],
> [ "(2^2x3).L3(4)",  "3.L3(4)",   "3.L3(4).3",   "(2^2x3).L3(4).3"   ],
> [ "2^2.L3(4).2_1",  "L3(4).2_1", "L3(4).6",     "2^2.L3(4).6"       ],
> [ "2^2.Sz(8)",      "Sz(8)",     "Sz(8).3",     "2^2.Sz(8).3"       ],
> [ "2^2.U6(2)",      "U6(2)",     "U6(2).3",     "2^2.U6(2).3"       ],
> [ "(2^2x3).U6(2)",  "3.U6(2)",   "3.U6(2).3",   "(2^2x3).U6(2).3"   ],
> [ "2^2.O8+(2)",     "O8+(2)",    "O8+(2).3",    "2^2.O8+(2).3"      ],
> [ "2^2.O8+(3)",     "O8+(3)",    "O8+(3).3",    "2^2.O8+(3).3"      ],
> [ "2^2.2E6(2)",     "2E6(2)",    "2E6(2).3",    "2^2.2E6(2).3"      ],
> ] );
gap> ConstructOrdinaryMGATable:= function( tblMG, tblG, tblGA, name, lib )
>      local acts, poss, trans;
> 
>      acts:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
>      poss:= Concatenation( List( acts, pi ->
>                 PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, pi,
>                     name ) ) );
>      poss:= RepresentativesCharacterTables( poss );
>      if Length( poss ) = 1 then
>        # Compare the computed table with the library table.
>        if not IsCharacterTable( lib ) then
>          List( poss, x -> AutomorphismsOfTable( x.table ) );
>          Print( "#I  no library table for ", name, "\n" );
>        else
>          trans:= TransformingPermutationsCharacterTables( poss[1].table,
>                      lib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>          # Compare the computed fusion with the stored one.
>          if OnTuples( poss[1].MGfusMGA, trans.columns )
>                 <> GetFusionMap( tblMG, lib ) then
>            Print( "#E  computed and stored fusion for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      elif Length( poss ) = 0 then
>        Print( "#E  no solution for ", name, "\n" );
>      else
>        Print( "#E  ", Length( poss ), " possibilities for ", name, "\n" );
>      fi;
>      return poss;
>    end;;
gap> ConstructModularMGATables:= function( tblMG, tblGA, ordtblMGA )
>    local name, poss, p, modtblMG, modtblGA, modtblMGA, modlib, trans;
> 
>    name:= Identifier( ordtblMGA );
>    poss:= [];
>    for p in Set( Factors( Size( ordtblMGA ) ) ) do
>      modtblMG := tblMG mod p;
>      modtblGA := tblGA mod p;
>      if ForAll( [ modtblMG, modtblGA ], IsCharacterTable ) then
>        modtblMGA:= BrauerTableOfTypeMGA( modtblMG, modtblGA, ordtblMGA );
>        Add( poss, modtblMGA );
>        modlib:= ordtblMGA mod p;
>        if IsCharacterTable( modlib ) then
>          trans:= TransformingPermutationsCharacterTables( modtblMGA.table,
>                      modlib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " mod ", p, " differ\n" );
>          fi;
>        else
>          AutomorphismsOfTable( modtblMGA.table );
>          Print( "#I  no library table for ", name, " mod ", p, "\n" );
>        fi;
>      else
>        Print( "#I  not all input tables for ", name, " mod ", p,
>               " available\n" );
>      fi;
>    od;
> 
>    return poss;
>    end;;
gap> for  input in listMGA do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      if 1 <> Length( poss ) then
>        Print( "#I  ", Length( poss ), " possibilities for ", name, "\n" );
>      elif lib = fail then
>        Print( "#I  no library table for ", input[4], "\n" );
>      else
>        ConstructModularMGATables( tblMG, tblGA, lib );
>      fi;
>    od;
#I  not all input tables for 6.Suz.2 mod 13 available
#I  not all input tables for 3.ON.2 mod 3 available
#I  not all input tables for 3.2E6(2).2 mod 2 available
#I  not all input tables for 3.2E6(2).2 mod 3 available
#I  not all input tables for 3.2E6(2).2 mod 5 available
#I  not all input tables for 3.2E6(2).2 mod 7 available
#I  not all input tables for 3.2E6(2).2 mod 11 available
#I  not all input tables for 3.2E6(2).2 mod 13 available
#I  not all input tables for 3.2E6(2).2 mod 17 available
#I  not all input tables for 3.2E6(2).2 mod 19 available
#I  not all input tables for 6.2E6(2).2 mod 2 available
#I  not all input tables for 6.2E6(2).2 mod 3 available
#I  not all input tables for 6.2E6(2).2 mod 5 available
#I  not all input tables for 6.2E6(2).2 mod 7 available
#I  not all input tables for 6.2E6(2).2 mod 11 available
#I  not all input tables for 6.2E6(2).2 mod 13 available
#I  not all input tables for 6.2E6(2).2 mod 17 available
#I  not all input tables for 6.2E6(2).2 mod 19 available
#I  not all input tables for 3.F3+.2 mod 2 available
#I  not all input tables for 3.F3+.2 mod 3 available
#I  not all input tables for 3.F3+.2 mod 5 available
#I  not all input tables for 3.F3+.2 mod 7 available
#I  not all input tables for 3.F3+.2 mod 13 available
#I  not all input tables for 3.F3+.2 mod 17 available
#I  not all input tables for 3.F3+.2 mod 29 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 2 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 3 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 5 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 7 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 11 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 13 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 17 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 19 available
#I  not all input tables for 3^2.U4(3).(2^2)_{133} mod 2 available
#I  not all input tables for 3^2.U4(3).(2^2)_{133} mod 5 available
#I  not all input tables for 3^2.U4(3).(2^2)_{133} mod 7 available
#I  not all input tables for 2^2.O8+(3).3 mod 3 available
#I  not all input tables for 2^2.O8+(3).3 mod 5 available
#I  not all input tables for 2^2.O8+(3).3 mod 7 available
#I  not all input tables for 2^2.O8+(3).3 mod 13 available
#I  not all input tables for 2^2.2E6(2).3 mod 2 available
#I  not all input tables for 2^2.2E6(2).3 mod 3 available
#I  not all input tables for 2^2.2E6(2).3 mod 5 available
#I  not all input tables for 2^2.2E6(2).3 mod 7 available
#I  not all input tables for 2^2.2E6(2).3 mod 11 available
#I  not all input tables for 2^2.2E6(2).3 mod 13 available
#I  not all input tables for 2^2.2E6(2).3 mod 17 available
#I  not all input tables for 2^2.2E6(2).3 mod 19 available
gap> listMGA2:= [
> [ "4_1.L3(4)",  "2.L3(4)",   "2.L3(4).2_1",   "4_1.L3(4).2_1"  ],
> [ "4_1.L3(4)",  "2.L3(4)",   "2.L3(4).2_2",   "4_1.L3(4).2_2"  ],
> [ "4_2.L3(4)",  "2.L3(4)",   "2.L3(4).2_1",   "4_2.L3(4).2_1"  ],
> [ "4.M22",      "2.M22",     "2.M22.2",       "4.M22.2"        ],
> [ "4.U4(3)",    "2.U4(3)",   "2.U4(3).2_2",   "4.U4(3).2_2"    ],
> [ "4.U4(3)",    "2.U4(3)",   "2.U4(3).2_3",   "4.U4(3).2_3"    ],
> ];;
gap> Append( listMGA2, [
> [ "2^2.L3(4)",     "2.L3(4)",     "2.L3(4).2_2",         "2^2.L3(4).2_2" ],
> [ "2^2.L3(4)",     "2.L3(4)",     "2.L3(4).2_3",         "2^2.L3(4).2_3" ],
> [ "2^2.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{123}", "2^2.L3(4).2^2" ],
> [ "2^2.O8+(2)",    "2.O8+(2)",    "2.O8+(2).2",          "2^2.O8+(2).2"  ],
> [ "2^2.U6(2)",     "2.U6(2)",     "2.U6(2).2",           "2^2.U6(2).2"   ],
> [ "2^2.2E6(2)",    "2.2E6(2)",    "2.2E6(2).2",          "2^2.2E6(2).2"  ],
> ] );
gap> Append( listMGA2, [
> [ "12_1.L3(4)", "6.L3(4)", "6.L3(4).2_1", "12_1.L3(4).2_1" ],
> [ "12_2.L3(4)", "6.L3(4)", "6.L3(4).2_1", "12_2.L3(4).2_1" ],
> ] );
gap> Append( listMGA2, [
> [ "12.M22",     "6.M22",     "6.M22.2",       "12.M22.2"       ],
> [ "12_1.L3(4)", "6.L3(4)",   "6.L3(4).2_2",   "12_1.L3(4).2_2" ],
> [ "12_1.U4(3)", "6_1.U4(3)", "6_1.U4(3).2_2", "12_1.U4(3).2_2" ],
> [ "12_2.U4(3)", "6_2.U4(3)", "6_2.U4(3).2_3", "12_2.U4(3).2_3" ],
> ] );
gap> Append( listMGA2, [
> [ "(2^2x3).L3(4)",  "6.L3(4)",   "6.L3(4).2_2", "(2^2x3).L3(4).2_2" ],
> [ "(2^2x3).L3(4)",  "6.L3(4)",   "6.L3(4).2_3", "(2^2x3).L3(4).2_3" ],
> [ "(2^2x3).U6(2)",  "6.U6(2)",   "6.U6(2).2",   "(2^2x3).U6(2).2"   ],
> [ "(2^2x3).2E6(2)", "6.2E6(2)",  "6.2E6(2).2",  "(2^2x3).2E6(2).2"  ],
> ] );
gap> for  input in listMGA2 do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      if Length( poss ) = 2 then
>        iso:= CharacterTableIsoclinic( poss[1].table );
>        if IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                         iso ) ) then
>          Unbind( poss[2] );
>        fi;
>      elif Length( poss ) = 1 then
>        Print( "#I  unique up to permutation equivalence: ", name, "\n" );
>      fi;
>      if 1 <> Length( poss ) then
>        Print( "#I  ", Length( poss ), " possibilities for ", name, "\n" );
>      elif lib = fail then
>        Print( "#I  no library table for ", input[4], "\n" );
>      else
>        ConstructModularMGATables( tblMG, tblGA, lib );
>      fi;
>    od;
#E  2 possibilities for new4_1.L3(4).2_1
#E  2 possibilities for new4_1.L3(4).2_2
#E  2 possibilities for new4_2.L3(4).2_1
#E  2 possibilities for new4.M22.2
#E  2 possibilities for new4.U4(3).2_2
#E  2 possibilities for new4.U4(3).2_3
#I  unique up to permutation equivalence: new2^2.L3(4).2_2
#I  unique up to permutation equivalence: new2^2.L3(4).2_3
#I  unique up to permutation equivalence: new2^2.L3(4).2^2
#I  unique up to permutation equivalence: new2^2.O8+(2).2
#I  unique up to permutation equivalence: new2^2.U6(2).2
#I  unique up to permutation equivalence: new2^2.2E6(2).2
#I  not all input tables for 2^2.2E6(2).2 mod 2 available
#I  not all input tables for 2^2.2E6(2).2 mod 3 available
#I  not all input tables for 2^2.2E6(2).2 mod 5 available
#I  not all input tables for 2^2.2E6(2).2 mod 7 available
#E  2 possibilities for new12_1.L3(4).2_1
#E  2 possibilities for new12_2.L3(4).2_1
#E  2 possibilities for new12.M22.2
#E  2 possibilities for new12_1.L3(4).2_2
#E  2 possibilities for new12_1.U4(3).2_2
#E  2 possibilities for new12_2.U4(3).2_3
#I  unique up to permutation equivalence: new(2^2x3).L3(4).2_2
#I  unique up to permutation equivalence: new(2^2x3).L3(4).2_3
#I  unique up to permutation equivalence: new(2^2x3).U6(2).2
#I  unique up to permutation equivalence: new(2^2x3).2E6(2).2
#I  not all input tables for (2^2x3).2E6(2).2 mod 2 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 3 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 5 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 7 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 11 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 13 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 17 available
#I  not all input tables for (2^2x3).2E6(2).2 mod 19 available
gap> tblMG := CharacterTable( "4_2.L3(4)" );;
gap> tblG  := CharacterTable( "2.L3(4)" );;
gap> tblGA := CharacterTable( "2.L3(4).2_3" );;
gap> name  := "new4_2.L3(4).2_3";;
gap> lib   := CharacterTable( "4_2.L3(4).2_3" );;
gap> poss  := ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
#E  4 possibilities for new4_2.L3(4).2_3
[ rec( MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 12, 13, 
          14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 21, 20 ], 
      table := CharacterTable( "new4_2.L3(4).2_3" ) ), 
  rec( MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 12, 13, 
          14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 21, 20 ], 
      table := CharacterTable( "new4_2.L3(4).2_3" ) ), 
  rec( MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 12, 13, 
          14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 21, 20 ], 
      table := CharacterTable( "new4_2.L3(4).2_3" ) ), 
  rec( MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 11, 10, 12, 12, 13, 
          14, 15, 14, 16, 17, 18, 17, 19, 20, 21, 22, 19, 22, 21, 20 ], 
      table := CharacterTable( "new4_2.L3(4).2_3" ) ) ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                  CharacterTableIsoclinic( poss[4].table ) ) );
true
gap> IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                  CharacterTableIsoclinic( poss[3].table ) ) );
true
gap> List( poss, x -> PowerMap( x.table, 2 ) );
[ [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 21, 19, 
      21, 1, 1, 6, 6, 9, 9, 11, 11, 16, 16, 13, 13 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 21, 19, 
      21, 1, 1, 6, 6, 11, 11, 9, 9, 16, 16, 13, 13 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 21, 19, 
      21, 3, 3, 8, 8, 9, 9, 11, 11, 18, 18, 15, 15 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 21, 19, 
      21, 3, 3, 8, 8, 11, 11, 9, 9, 18, 18, 15, 15 ] ]
gap> PossiblePowerMaps( poss[1].table, 2 );
[ [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 21, 19, 
      21, 1, 1, 6, 6, 11, 11, 9, 9, 16, 16, 13, 13 ], 
  [ 1, 3, 1, 1, 3, 6, 8, 6, 4, 4, 4, 5, 16, 18, 16, 13, 15, 13, 19, 21, 19, 
      21, 1, 1, 6, 6, 9, 9, 11, 11, 16, 16, 13, 13 ] ]
gap> t:= CharacterTable( "4.U4(3)" );;
gap> List( [ "L3(4)", "2.L3(4)", "4_1.L3(4)", "4_2.L3(4)" ], name ->
>          Length( PossibleClassFusions( CharacterTable( name ), t ) ) );
[ 0, 0, 0, 4 ]
gap> t2:= CharacterTable( "4.U4(3).2_3" );;
gap> List( poss, x -> Length( PossibleClassFusions( x.table, t2 ) ) );
[ 0, 16, 0, 0 ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                  lib ) );
true
gap> ConstructModularMGATables( tblMG, tblGA, lib );;
gap> tblMG := CharacterTable( "12_2.L3(4)" );;
gap> tblG  := CharacterTable( "6.L3(4)" );;
gap> tblGA := CharacterTable( "6.L3(4).2_3" );;
gap> name  := "new12_2.L3(4).2_3";;
gap> lib   := CharacterTable( "12_2.L3(4).2_3" );;
gap> poss  := ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );;
#E  4 possibilities for new12_2.L3(4).2_3
gap> Length( poss );
4
gap> nsg:= ClassPositionsOfNormalSubgroups( poss[1].table );
[ [ 1 ], [ 1, 5 ], [ 1, 7 ], [ 1, 4 .. 7 ], [ 1, 3 .. 7 ], [ 1 .. 7 ], 
  [ 1 .. 50 ], [ 1 .. 62 ] ]
gap> List( nsg, x -> Sum( SizesConjugacyClasses( poss[1].table ){ x } ) );
[ 1, 3, 2, 4, 6, 12, 241920, 483840 ]
gap> factlib:= CharacterTable( "4_2.L3(4).2_3" );;
gap> List( poss, x -> IsRecord( TransformingPermutationsCharacterTables(
>                         x.table / [ 1, 5 ], factlib ) ) );
[ false, true, false, false ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[2].table,
>                  lib ) );
true
gap> ConstructModularMGATables( tblMG, tblGA, lib );;
gap> f42:= CharacterTable( "F4(2)" );;
gap> v4:= CharacterTable( "2^2" );;
gap> dp:= v4 * f42;
CharacterTable( "V4xF4(2)" )
gap> b:= CharacterTable( "B" );;
gap> f42fusb:= PossibleClassFusions( f42, b );;
gap> Length( f42fusb );
1
gap> f42fusdp:= GetFusionMap( f42, dp );;
gap> comp:= CompositionMaps( f42fusb[1], InverseMap( f42fusdp ) );
[ 1, 3, 3, 3, 5, 6, 6, 7, 9, 9, 9, 9, 14, 14, 13, 13, 10, 14, 14, 12, 14, 17,
  15, 18, 22, 22, 22, 22, 26, 26, 22, 22, 27, 27, 28, 31, 31, 39, 39, 36, 36,
  33, 33, 39, 39, 35, 41, 42, 47, 47, 49, 49, 49, 58, 58, 56, 56, 66, 66, 66,
  66, 58, 58, 66, 66, 69, 69, 60, 72, 72, 75, 79, 79, 81, 81, 85, 86, 83, 83,
  91, 91, 94, 94, 104, 104, 109, 109, 116, 116, 114, 114, 132, 132, 140, 140 ]
gap> v4fusdp:= GetFusionMap( v4, dp );
[ 1, 96 .. 286 ]
gap> comp[ v4fusdp[2] ]:= 4;;
gap> dpfusb:= PossibleClassFusions( dp, b, rec( fusionmap:= comp ) );;
gap> Length( dpfusb );
4
gap> Set( List( dpfusb, x -> x{ v4fusdp } ) );
[ [ 1, 4, 2, 2 ] ]
gap> tblG:= dp / v4fusdp{ [ 1, 2 ] };;
gap> tblMG:= dp;;
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblGA:= c2 * CharacterTable( "F4(2).2" );
CharacterTable( "C2xF4(2).2" )
gap> GfusGA:= PossibleClassFusions( tblG, tblGA );;
gap> Length( GfusGA );
4
gap> Length( RepresentativesFusions( tblG, GfusGA, tblGA ) );
1
gap> Length( RepresentativesFusions( Group( () ), GfusGA, tblGA ) );
1
gap> StoreFusion( tblG, GfusGA[1], tblGA );
gap> elms:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );;
gap> Length( elms );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, elms[1],
>               "(2^2xF4(2)):2" );;
gap> Length( poss );
1
gap> tblMGA:= poss[1].table;;
gap> IsRecord( TransformingPermutationsCharacterTables( tblMGA,
>                  CharacterTable( "(2^2xF4(2)):2" ) ) );
true
gap> s3:= CharacterTable( "Dihedral", 6 );;
gap> fi222:= CharacterTable( "Fi22.2" );;
gap> tblMbar:= s3 * fi222;;
gap> b:= CharacterTable( "B" );;
gap> Mbarfusb:= PossibleClassFusions( tblMbar, b );;
gap> Length( Mbarfusb );
1
gap> 2b:= CharacterTable( "2.B" );;
gap> PossibleClassFusions( CharacterTable( "Fi22" ), 2b );
[  ]
gap> c3:= CharacterTable( "Cyclic", 3 );;
gap> 2fi222:= CharacterTable( "2.Fi22.2" );;
gap> PossibleClassFusions( c3 * CharacterTableIsoclinic( 2fi222 ), 2b );
[  ]
gap> s3inMbar:= GetFusionMap( s3, tblMbar );
[ 1, 113 .. 225 ]
gap> s3inb:= Mbarfusb[1]{ s3inMbar };
[ 1, 6, 2 ]
gap> 2bfusb:= GetFusionMap( 2b, b );;
gap> 2s3in2B:= InverseMap( 2bfusb ){ s3inb };
[ [ 1, 2 ], [ 8, 9 ], 3 ]
gap> CompositionMaps( OrdersClassRepresentatives( 2b ), 2s3in2B );
[ [ 1, 2 ], [ 3, 6 ], 2 ]
gap> PossibleClassFusions( s3 * 2fi222, 2b );
[  ]
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> 2fi22:= CharacterTable( "2.Fi22" );;
gap> tblNmodY:= c2 * 2fi22;;
gap> centre:= GetFusionMap( 2fi22, tblNmodY ){
>                 ClassPositionsOfCentre( 2fi22 ) };
[ 1, 2 ]
gap> tblNmod6:= tblNmodY / centre;;
gap> tblMmod6:= c2 * fi222;;
gap> fus:= PossibleClassFusions( tblNmod6, tblMmod6 );;
gap> Length( fus );
1
gap> StoreFusion( tblNmod6, fus[1], tblMmod6 );
gap> elms:= PossibleActionsForTypeMGA( tblNmodY, tblNmod6, tblMmod6 );;
gap> Length( elms );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblNmodY, tblNmod6, tblMmod6,
>               elms[1], "2^2.Fi22.2" );;
gap> Length( poss );
1
gap> tblMmodY:= poss[1].table;
CharacterTable( "2^2.Fi22.2" )
gap> tblU:= c3 * 2fi222;;
gap> tblUmodY:= tblU / GetFusionMap( c3, tblU );;
gap> fus:= PossibleClassFusions( tblUmodY, tblMmodY );;
gap> Length( RepresentativesFusions( Group( () ), fus, tblMmodY ) );
1
gap> StoreFusion( tblUmodY, fus[1], tblMmodY );
gap> elms:= PossibleActionsForTypeMGA( tblU, tblUmodY, tblMmodY );;
gap> Length( elms );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( tblU, tblUmodY, tblMmodY,
>               elms[1], "(S3x2.Fi22).2" );;
gap> Length( poss );
1
gap> tblM:= poss[1].table;
CharacterTable( "(S3x2.Fi22).2" )
gap> mfus2b:= PossibleClassFusions( tblM, 2b );;
gap> Length( RepresentativesFusions( tblM, mfus2b, 2b ) );
1
gap> Irr( tblM / ClassPositionsOfCentre( tblM ) ) = Irr( tblMbar );
true
gap> IsRecord( TransformingPermutationsCharacterTables( tblM,
>                  CharacterTable( "(S3x2.Fi22).2" ) ) );
true
gap> fi24:= CharacterTable( "Fi24" );;
gap> t:= CharacterTable( "2^2.Fi22.2" );;
gap> fus:= PossibleClassFusions( t, fi24 );;
gap> Length( fus );
4
gap> Length( RepresentativesFusions( t, fus, fi24 ) );
1
gap> t:= CharacterTable( "(S3x2.Fi22).2" );;
gap> 3fi24:= CharacterTable( "3.Fi24" );;                        
gap> fus:= PossibleClassFusions( t, 3fi24 );;
gap> Length( fus );
16
gap> Length( RepresentativesFusions( t, fus, 3fi24 ) );
1
gap> GetFusionMap( t, 3fi24 ) in fus; 
true
gap> m:= CharacterTable( "M" );;
gap> tfusm:= PossibleClassFusions( t, m );;
gap> Length( tfusm );
4
gap> Length( RepresentativesFusions( t, tfusm, m ) );
1
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>        x -> Sum( SizesConjugacyClasses( t ){ x } ) = 6 );
[ [ 1, 2, 142, 143 ] ]
gap> Set( List( tfusm, x -> x{ nsg[1] } ) );
[ [ 1, 2, 4, 13 ] ]
gap> OrdersClassRepresentatives( t ){ nsg[1] };
[ 1, 2, 3, 6 ]
gap> PowerMap( m, -1 )[13];
13
gap> Size( t ) = 2 * SizesCentralizers( m )[13];
true
gap> 2Fi22:= CharacterTable( "2.Fi22" );;
gap> ClassPositionsOfCentre( 2Fi22 );
[ 1, 2 ]
gap> 2 in PowerMap( 2Fi22, 2 );
false
gap> PossibleClassFusions( CharacterTable( "U4(3)" ), 2Fi22 );
[  ]
gap> tblU:= CharacterTable( "2.U4(3).2_2" );;
gap> iso:= CharacterTableIsoclinic( tblU );
CharacterTable( "Isoclinic(2.U4(3).2_2)" )
gap> PossibleClassFusions( iso, 2Fi22 );                      
[  ]
gap> derpos:= ClassPositionsOfDerivedSubgroup( tblU );;
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( tblU ) ], derpos );;
gap> 2 in OrdersClassRepresentatives( tblU ){ outer };
true
gap> tblM:= CharacterTable( "Dihedral", 6 ) * tblU;;
gap> fus:= PossibleClassFusions( tblM, 2Fi22 );;
gap> Length( RepresentativesFusions( tblM, fus, 2Fi22 ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( tblM,
>                  CharacterTable( "2.Fi22M8" ) ) );
true
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblC:= CharacterTableIsoclinic( CharacterTable( "2.HS" ) * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblCbar:= tblC / ord2[1];;
gap> tblNbar:= CharacterTable( "HS.2" ) * c2;;
gap> fus:= PossibleClassFusions( tblCbar, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
      21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 29, 30, 31, 32, 33, 34, 35, 36, 
      35, 36, 37, 38, 39, 40, 41, 42, 41, 42 ] ]
gap> StoreFusion( tblCbar, fus[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblCbar, tblNbar );
[ [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6, 8 ], [ 7 ], [ 9 ], [ 10 ], [ 11 ],
      [ 12, 14 ], [ 13 ], [ 15 ], [ 16, 18 ], [ 17 ], [ 19 ], [ 20 ], [ 21 ],
      [ 22 ], [ 23 ], [ 24, 26 ], [ 25 ], [ 27 ], [ 28, 30 ], [ 29 ], [ 31 ],
      [ 32, 34 ], [ 33 ], [ 35 ], [ 36, 38 ], [ 37 ], [ 39 ], [ 40, 42 ],
      [ 41 ], [ 43 ], [ 44, 46 ], [ 45 ], [ 47 ], [ 48, 50 ], [ 49 ],
      [ 51, 53 ], [ 52, 54 ], [ 55 ], [ 56, 58 ], [ 57 ], [ 59 ], [ 60 ],
      [ 61, 65 ], [ 62, 68 ], [ 63, 67 ], [ 64, 66 ], [ 69 ], [ 70, 72 ],
      [ 71 ], [ 73 ], [ 74, 76 ], [ 75 ], [ 77, 81 ], [ 78, 84 ], [ 79, 83 ],
      [ 80, 82 ] ],
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6, 8 ], [ 7 ], [ 9 ], [ 10 ], [ 11 ],
      [ 12, 14 ], [ 13 ], [ 15, 17 ], [ 16 ], [ 18 ], [ 19 ], [ 20 ], [ 21 ],
      [ 22 ], [ 23 ], [ 24, 26 ], [ 25 ], [ 27 ], [ 28, 30 ], [ 29 ], [ 31 ],
      [ 32, 34 ], [ 33 ], [ 35, 37 ], [ 36 ], [ 38 ], [ 39 ], [ 40, 42 ],
      [ 41 ], [ 43 ], [ 44, 46 ], [ 45 ], [ 47, 49 ], [ 48 ], [ 50 ],
      [ 51, 53 ], [ 52, 54 ], [ 55 ], [ 56, 58 ], [ 57 ], [ 59 ], [ 60 ],
      [ 61, 65 ], [ 62, 68 ], [ 63, 67 ], [ 64, 66 ], [ 69, 71 ], [ 70 ],
      [ 72 ], [ 73 ], [ 74, 76 ], [ 75 ], [ 77, 83 ], [ 78, 82 ], [ 79, 81 ],
      [ 80, 84 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblCbar, tblNbar, pi, "4.HS.2" ) );;
gap> List( poss, Length );
[ 0, 2 ]
gap> result:= poss[2];;
gap> hn2:= CharacterTable( "HN.2" );;
gap> possfus:= List( result, r -> PossibleClassFusions( r.table, hn2 ) );;
gap> List( possfus, Length );
[ 32, 0 ]
gap> RepresentativesFusions( result[1].table, possfus[1], hn2 );
[ [ 1, 46, 2, 2, 47, 3, 7, 45, 4, 58, 13, 6, 46, 47, 6, 47, 7, 48, 10, 62, 
      20, 9, 63, 21, 12, 64, 24, 27, 49, 50, 13, 59, 14, 16, 70, 30, 18, 53, 
      52, 17, 54, 20, 65, 22, 36, 56, 26, 76, 39, 77, 28, 59, 58, 31, 78, 41, 
      34, 62, 35, 65, 2, 45, 3, 45, 6, 48, 7, 47, 17, 54, 13, 49, 13, 50, 14, 
      50, 18, 53, 18, 52, 21, 56, 25, 57, 27, 59, 30, 60, 44, 72, 34, 66, 35, 
      66, 41, 71 ] ]
gap> libtbl:= CharacterTable( "4.HS.2" );;
gap> IsRecord( TransformingPermutationsCharacterTables( result[1].table,
>                  libtbl ) );
true
gap> StoreFusion( tblC, result[1].MGfusMGA, result[1].table );
gap> ForAll( Set( Factors( Size( result[1].table ) ) ),
>            p -> IsRecord( TransformingPermutationsCharacterTables(
>                     BrauerTableOfTypeMGA( tblC mod p, tblNbar mod p,
>                         result[1].table ).table, libtbl mod p ) ) );
true
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> 2a6:= CharacterTable( "2.A6" );;
gap> tblC:= CharacterTableIsoclinic( 2a6 * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "A6.2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 5, 6, 7, 8, 9, 10, 9, 10 ] ]
gap> StoreFusion( tblG, fus[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 12 ],
      [ 9, 13 ], [ 10, 14 ], [ 15, 17 ], [ 16, 18 ], [ 19, 23 ], [ 20, 24 ],
      [ 21, 25 ], [ 22, 26 ] ],
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], [ 9, 13 ],
      [ 10, 12 ], [ 15 ], [ 16, 18 ], [ 17 ], [ 19, 23 ], [ 20, 26 ],
      [ 21, 25 ], [ 22, 24 ] ],
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], [ 9, 13 ],
      [ 10, 12 ], [ 15, 17 ], [ 16 ], [ 18 ], [ 19, 23 ], [ 20, 26 ],
      [ 21, 25 ], [ 22, 24 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "4.A6.2_3" ) );
[ [  ], [  ], 
  [
      rec( MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 9, 6, 9, 8, 7, 10, 11, 10,
              12, 13, 14, 15, 16, 13, 16, 15, 14 ],
          table := CharacterTable( "4.A6.2_3" ) ) ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[3][1].table,
>                  CharacterTable( "4.A6.2_3" ) ) );
true
gap> tblC:= 2a6 * c2;;
gap> z:= GetFusionMap( 2a6, tblC ){ ClassPositionsOfCentre( 2a6 ) };
[ 1, 3 ]
gap> tblG:= tblC / z;;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "A6.2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 5, 6, 7, 8, 9, 10, 9, 10 ] ]
gap> StoreFusion( tblG, fus[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 12 ], 
      [ 9, 13 ], [ 10, 14 ], [ 15, 17 ], [ 16, 18 ], [ 19, 23 ], [ 20, 24 ], 
      [ 21, 25 ], [ 22, 26 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], [ 9, 13 ], 
      [ 10, 12 ], [ 15 ], [ 16, 18 ], [ 17 ], [ 19, 23 ], [ 20, 26 ], 
      [ 21, 25 ], [ 22, 24 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7, 11 ], [ 8, 14 ], [ 9, 13 ], 
      [ 10, 12 ], [ 15, 17 ], [ 16 ], [ 18 ], [ 19, 23 ], [ 20, 26 ], 
      [ 21, 25 ], [ 22, 24 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "2^2.A6.2_3" ) );
[ [  ], [  ], 
  [ 
      rec( MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 9, 6, 9, 8, 7, 10, 11, 10, 
              12, 13, 14, 15, 16, 13, 16, 15, 14 ], 
          table := CharacterTable( "2^2.A6.2_3" ) ) ] ]
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblC:= CharacterTableIsoclinic( CharacterTable( "6.A6" ) * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 7 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "3.A6.2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 13, 14, 15, 16, 17, 18, 
      19, 20, 21, 22, 23, 24, 25, 26, 21, 22, 23, 24, 25, 26 ], 
  [ 1, 2, 5, 6, 3, 4, 7, 8, 11, 12, 9, 10, 13, 14, 13, 14, 15, 16, 19, 20, 
      17, 18, 21, 22, 25, 26, 23, 24, 21, 22, 25, 26, 23, 24 ] ]
gap> rep:= RepresentativesFusions( Group( () ), fus, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 13, 14, 15, 16, 17, 18, 
      19, 20, 21, 22, 23, 24, 25, 26, 21, 22, 23, 24, 25, 26 ] ]
gap> StoreFusion( tblG, rep[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ], [ 9 ], [ 10 ], 
      [ 11 ], [ 12 ], [ 13 ], [ 14 ], [ 15 ], [ 16 ], [ 17 ], [ 18 ], 
      [ 19, 23 ], [ 20, 24 ], [ 21, 25 ], [ 22, 26 ], [ 27, 33 ], [ 28, 34 ], 
      [ 29, 35 ], [ 30, 36 ], [ 31, 37 ], [ 32, 38 ], [ 39, 51 ], [ 40, 52 ], 
      [ 41, 53 ], [ 42, 54 ], [ 43, 55 ], [ 44, 56 ], [ 45, 57 ], [ 46, 58 ], 
      [ 47, 59 ], [ 48, 60 ], [ 49, 61 ], [ 50, 62 ] ], 
  [ [ 1 ], [ 2, 8 ], [ 3 ], [ 4, 10 ], [ 5 ], [ 6, 12 ], [ 7 ], [ 9 ], 
      [ 11 ], [ 13 ], [ 14 ], [ 15 ], [ 16 ], [ 17 ], [ 18 ], [ 19, 23 ], 
      [ 20, 26 ], [ 21, 25 ], [ 22, 24 ], [ 27 ], [ 28, 34 ], [ 29 ], 
      [ 30, 36 ], [ 31 ], [ 32, 38 ], [ 33 ], [ 35 ], [ 37 ], [ 39, 51 ], 
      [ 40, 58 ], [ 41, 53 ], [ 42, 60 ], [ 43, 55 ], [ 44, 62 ], [ 45, 57 ], 
      [ 46, 52 ], [ 47, 59 ], [ 48, 54 ], [ 49, 61 ], [ 50, 56 ] ], 
  [ [ 1 ], [ 2, 8 ], [ 3 ], [ 4, 10 ], [ 5 ], [ 6, 12 ], [ 7 ], [ 9 ], 
      [ 11 ], [ 13 ], [ 14 ], [ 15 ], [ 16 ], [ 17 ], [ 18 ], [ 19, 23 ], 
      [ 20, 26 ], [ 21, 25 ], [ 22, 24 ], [ 27, 33 ], [ 28 ], [ 29, 35 ], 
      [ 30 ], [ 31, 37 ], [ 32 ], [ 34 ], [ 36 ], [ 38 ], [ 39, 51 ], 
      [ 40, 58 ], [ 41, 53 ], [ 42, 60 ], [ 43, 55 ], [ 44, 62 ], [ 45, 57 ], 
      [ 46, 52 ], [ 47, 59 ], [ 48, 54 ], [ 49, 61 ], [ 50, 56 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "12.A6.2_3" ) );
[ [  ], [  ], 
  [
      rec( MGfusMGA := [ 1, 2, 3, 4, 5, 6, 7, 2, 8, 4, 9, 6, 10, 11, 12, 13, 14,
              15, 16, 17, 18, 19, 16, 19, 18, 17, 20, 21, 22, 23, 24, 25, 20,
              26, 22, 27, 24, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
              40, 29, 36, 31, 38, 33, 40, 35, 30, 37, 32, 39, 34 ],
          table := CharacterTable( "12.A6.2_3" ) ) ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[3][1].table,
>                  CharacterTable( "12.A6.2_3" ) ) );
true
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> tblC:= CharacterTableIsoclinic( CharacterTable( "2.L2(25)" ) * c2 );;
gap> ord2:= Filtered( ClassPositionsOfNormalSubgroups( tblC ),
>               x -> Length( x ) = 2 );
[ [ 1, 3 ] ]
gap> tblG:= tblC / ord2[1];;
gap> tblNbar:= CharacterTableIsoclinic( CharacterTable( "L2(25).2_3" ) * c2 );;
gap> fus:= PossibleClassFusions( tblG, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 15, 16, 15, 
      16, 17, 18, 17, 18, 19, 20, 19, 20 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 17, 18, 17, 
      18, 19, 20, 19, 20, 15, 16, 15, 16 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 19, 20, 19, 
      20, 15, 16, 15, 16, 17, 18, 17, 18 ] ]
gap> rep:= RepresentativesFusions( Group( () ), fus, tblNbar );
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 14, 15, 16, 15, 
      16, 17, 18, 17, 18, 19, 20, 19, 20 ] ]
gap> StoreFusion( tblG, rep[1], tblNbar );
gap> elms:= PossibleActionsForTypeMGA( tblC, tblG, tblNbar );
[ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ], [ 7 ], [ 8 ], [ 9 ], [ 10 ], 
      [ 11, 13 ], [ 12, 14 ], [ 15, 19 ], [ 16, 20 ], [ 17, 21 ], [ 18, 22 ], 
      [ 23, 25 ], [ 24, 26 ], [ 27, 33 ], [ 28, 34 ], [ 29, 31 ], [ 30, 32 ], 
      [ 35, 39 ], [ 36, 40 ], [ 37, 41 ], [ 38, 42 ], [ 43, 47 ], [ 44, 48 ], 
      [ 45, 49 ], [ 46, 50 ], [ 51, 55 ], [ 52, 56 ], [ 53, 57 ], [ 54, 58 ] ]
    , [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7 ], [ 8, 10 ], [ 9 ], 
      [ 11 ], [ 12, 14 ], [ 13 ], [ 15, 19 ], [ 16, 22 ], [ 17, 21 ], 
      [ 18, 20 ], [ 23, 25 ], [ 24 ], [ 26 ], [ 27, 31 ], [ 28, 34 ], 
      [ 29, 33 ], [ 30, 32 ], [ 35, 39 ], [ 36, 42 ], [ 37, 41 ], [ 38, 40 ], 
      [ 43, 47 ], [ 44, 50 ], [ 45, 49 ], [ 46, 48 ], [ 51, 55 ], [ 52, 58 ], 
      [ 53, 57 ], [ 54, 56 ] ], 
  [ [ 1 ], [ 2, 4 ], [ 3 ], [ 5 ], [ 6 ], [ 7 ], [ 8, 10 ], [ 9 ], 
      [ 11, 13 ], [ 12 ], [ 14 ], [ 15, 19 ], [ 16, 22 ], [ 17, 21 ], 
      [ 18, 20 ], [ 23, 25 ], [ 24 ], [ 26 ], [ 27, 33 ], [ 28, 32 ], 
      [ 29, 31 ], [ 30, 34 ], [ 35, 39 ], [ 36, 42 ], [ 37, 41 ], [ 38, 40 ], 
      [ 43, 47 ], [ 44, 50 ], [ 45, 49 ], [ 46, 48 ], [ 51, 55 ], [ 52, 58 ], 
      [ 53, 57 ], [ 54, 56 ] ] ]
gap> poss:= List( elms, pi -> PossibleCharacterTablesOfTypeMGA(
>                 tblC, tblG, tblNbar, pi, "4.L2(25).2_3" ) );
[ [  ], [  ], 
  [
      rec( MGfusMGA := [ 1, 2, 3, 2, 4, 5, 6, 7, 8, 7, 9, 10, 9, 11, 12, 13, 14,
              15, 12, 15, 14, 13, 16, 17, 16, 18, 19, 20, 21, 22, 21, 20, 19,
              22, 23, 24, 25, 26, 23, 26, 25, 24, 27, 28, 29, 30, 27, 30, 29,
              28, 31, 32, 33, 34, 31, 34, 33, 32 ],
          table := CharacterTable( "4.L2(25).2_3" ) ) ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[3][1].table,
>                  CharacterTable( "4.L2(25).2_3" ) ) );
true
gap> tblMG := CharacterTable( "3.A6" );;
gap> tblG  := CharacterTable( "A6" );;
gap> tblGA := CharacterTable( "A6.2_3" );;
gap> elms:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );  
[ [ [ 1 ], [ 2, 3 ], [ 4 ], [ 5, 6 ], [ 7, 8 ], [ 9 ], [ 10, 11 ],
      [ 12, 15 ], [ 13, 17 ], [ 14, 16 ] ] ]
gap> poss:= PossibleCharacterTablesOfTypeMGA(                  
>                 tblMG, tblG, tblGA, elms[1], "pseudo" );    
[ rec( MGfusMGA := [ 1, 2, 2, 3, 4, 4, 5, 5, 6, 7, 7, 8, 9, 10, 8, 10, 9 ],
      table := CharacterTable( "pseudo" ) ) ]
gap> pseudo:= poss[1].table;
CharacterTable( "pseudo" )
gap> Display( pseudo );
pseudo

      2  4   3  4  3  .  3   2  .   .   .  2  3  3
      3  3   3  1  1  2  1   1  1   1   1  .  .  .
      5  1   1  .  .  .  .   .  1   1   1  .  .  .

        1a  3a 2a 6a 3b 4a 12a 5a 15a 15b 4b 8a 8b
     2P 1a  3a 1a 3a 3b 2a  6a 5a 15a 15b 2a 4a 4a
     3P 1a  1a 2a 2a 1a 4a  4a 5a  5a  5a 4b 8a 8b
     5P 1a  3a 2a 6a 3b 4a 12a 1a  3a  3a 4b 8b 8a

X.1      1   1  1  1  1  1   1  1   1   1  1  1  1
X.2      1   1  1  1  1  1   1  1   1   1 -1 -1 -1
X.3     10  10  2  2  1 -2  -2  .   .   .  .  .  .
X.4     16  16  .  . -2  .   .  1   1   1  .  .  .
X.5      9   9  1  1  .  1   1 -1  -1  -1  1 -1 -1
X.6      9   9  1  1  .  1   1 -1  -1  -1 -1  1  1
X.7     10  10 -2 -2  1  .   .  .   .   .  .  B -B
X.8     10  10 -2 -2  1  .   .  .   .   .  . -B  B
X.9      6  -3 -2  1  .  2  -1  1   A  /A  .  .  .
X.10     6  -3 -2  1  .  2  -1  1  /A   A  .  .  .
X.11    12  -6  4 -2  .  .   .  2  -1  -1  .  .  .
X.12    18  -9  2 -1  .  2  -1 -2   1   1  .  .  .
X.13    30 -15 -2  1  . -2   1  .   .   .  .  .  .

A = -E(15)-E(15)^2-E(15)^4-E(15)^8
  = (-1-Sqrt(-15))/2 = -1-b15
B = E(8)+E(8)^3
  = Sqrt(-2) = i2
gap> IsInternallyConsistent( pseudo );
true
gap> irr:= Irr( pseudo );;
gap> test:= Concatenation( List( [ 2 .. 5 ],
>               n -> Symmetrizations( pseudo, irr, n ) ) );;
gap> Append( test, Set( Tensored( irr, irr ) ) );
gap> fail in Decomposition( irr, test, "nonnegative" );
false
gap> if ForAny( Tuples( [ 1 .. NrConjugacyClasses( pseudo ) ], 3 ),        
>      t -> not ClassMultiplicationCoefficient( pseudo, t[1], t[2], t[3] )   
>               in NonnegativeIntegers ) then                           
>      Error( "contradiction" );
> fi;
gap> tblMG := CharacterTable( "3.L3(4)" );;
gap> tblG  := CharacterTable( "L3(4)" );;
gap> tblGA := CharacterTable( "L3(4).2_1" );;
gap> elms:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[ [ [ 1 ], [ 2, 3 ], [ 4 ], [ 5, 6 ], [ 7 ], [ 8 ], [ 9, 10 ], [ 11 ], 
      [ 12, 13 ], [ 14 ], [ 15, 16 ], [ 17, 20 ], [ 18, 22 ], [ 19, 21 ], 
      [ 23, 26 ], [ 24, 28 ], [ 25, 27 ] ] ]
gap> PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, elms[1], "?" );
[  ]
gap> tblG  := CharacterTable( "U4(3)" );;
gap> tblMG := CharacterTable( "3_1.U4(3)" );;
gap> tblGA := CharacterTable( "U4(3).2_2" );;
gap> PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[  ]
gap> tblMG:= CharacterTable( "3_2.U4(3)" );;
gap> tblGA:= CharacterTable( "U4(3).2_3" );;
gap> PossibleActionsForTypeMGA( tblMG, tblG, tblGA );
[  ]
gap> FindExtraordinaryCase:= function( tblMGA )
>    local result, der, nsg, tblMGAclasses, orders, tblMG,
>          tblMGfustblMGA, tblMGclasses, pos, M, Mimg, tblMGAfustblGA, tblGA,
>          outer, inv, filt, other, primes, p;
>    result:= [];
>    der:= ClassPositionsOfDerivedSubgroup( tblMGA );
>    nsg:= ClassPositionsOfNormalSubgroups( tblMGA );
>    tblMGAclasses:= SizesConjugacyClasses( tblMGA );
>    orders:= OrdersClassRepresentatives( tblMGA );
>    if Length( der ) < NrConjugacyClasses( tblMGA ) then
>      # Look for tables of normal subgroups of the form $M.G$.
>      for tblMG in Filtered( List( NamesOfFusionSources( tblMGA ),
>                                   CharacterTable ), x -> x <> fail ) do
>        tblMGfustblMGA:= GetFusionMap( tblMG, tblMGA );
>        tblMGclasses:= SizesConjugacyClasses( tblMG );
>        pos:= Position( nsg, Set( tblMGfustblMGA ) );
>        if pos <> fail and
>           Size( tblMG ) = Sum( tblMGAclasses{ nsg[ pos ] } ) then
>          # Look for normal subgroups of the form $M$.
>          for M in Difference( ClassPositionsOfNormalSubgroups( tblMG ),
>                       [ [ 1 ], [ 1 .. NrConjugacyClasses( tblMG ) ] ] ) do
>            Mimg:= Set( tblMGfustblMGA{ M } );
>            if Sum( tblMGAclasses{ Mimg } ) = Sum( tblMGclasses{ M } ) then
>              tblMGAfustblGA:= First( ComputedClassFusions( tblMGA ),
>                  r -> ClassPositionsOfKernel( r.map ) = Mimg );
>              if tblMGAfustblGA <> fail then
>                tblGA:= CharacterTable( tblMGAfustblGA.name );
>                tblMGAfustblGA:= tblMGAfustblGA.map;
>                outer:= Difference( [ 1 .. NrConjugacyClasses( tblGA ) ],
>                    CompositionMaps( tblMGAfustblGA, tblMGfustblMGA ) );
>                inv:= InverseMap( tblMGAfustblGA ){ outer };
>                filt:= Flat( Filtered( inv, IsList ) );
>                if not IsEmpty( filt ) then
>                  other:= Filtered( inv, IsInt );
>                  primes:= Filtered( Set( Factors( Size( tblMGA ) ) ),
>                     p -> ForAll( orders{ filt }, x -> x mod p = 0 )
>                          and ForAny( orders{ other }, x -> x mod p <> 0 ) );
>                  for p in primes do
>                    Add( result, [ Identifier( tblMG ),
>                                   Identifier( tblMGA ),
>                                   Identifier( tblGA ), p ] );
>                  od;
>                fi;
>              fi;
>            fi;
>          od;
>        fi;
>      od;
>    fi;
>    return result;
> end;;
gap> cases:= [];;
gap> for name in AllCharacterTableNames() do
>      Append( cases, FindExtraordinaryCase( CharacterTable( name ) ) );
>    od;
gap> for i in Set( cases ) do
>      Print( i, "\n" ); 
>    od;
[ "2.A6", "2.A6.2_1", "A6.2_1", 3 ]
[ "2.Fi22", "2.Fi22.2", "Fi22.2", 3 ]
[ "2.L2(25)", "2.L2(25).2_2", "L2(25).2_2", 5 ]
[ "2.L2(49)", "2.L2(49).2_2", "L2(49).2_2", 7 ]
[ "2.L2(81)", "2.L2(81).2_1", "L2(81).2_1", 3 ]
[ "2.L2(81)", "2.L2(81).4_1", "L2(81).4_1", 3 ]
[ "2.L2(81).2_1", "2.L2(81).4_1", "L2(81).4_1", 3 ]
[ "2.L4(3)", "2.L4(3).2_2", "L4(3).2_2", 3 ]
[ "2.L4(3)", "2.L4(3).2_3", "L4(3).2_3", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{12*2*}", "U4(3).(2^2)_{122}", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{122}", "U4(3).(2^2)_{122}", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{13*3*}", "U4(3).(2^2)_{133}", 3 ]
[ "2.U4(3).2_1", "2.U4(3).(2^2)_{133}", "U4(3).(2^2)_{133}", 3 ]
[ "3.U3(8)", "3.U3(8).3_1", "U3(8).3_1", 2 ]
[ "3.U3(8)", "3.U3(8).6", "U3(8).6", 2 ]
[ "3.U3(8)", "3.U3(8).6", "U3(8).6", 3 ]
[ "3.U3(8).2", "3.U3(8).6", "U3(8).6", 2 ]
[ "5^(1+2):8:4", "2.HS.2N5", "HS.2N5", 5 ]
[ "6.A6", "6.A6.2_1", "3.A6.2_1", 3 ]
[ "6.A6", "6.A6.2_1", "A6.2_1", 3 ]
[ "6.Fi22", "6.Fi22.2", "3.Fi22.2", 3 ]
[ "6.Fi22", "6.Fi22.2", "Fi22.2", 3 ]
[ "Isoclinic(2.U4(3).2_1)", "2.U4(3).(2^2)_{1*2*2}", "U4(3).(2^2)_{122}", 3 ]
[ "Isoclinic(2.U4(3).2_1)", "2.U4(3).(2^2)_{1*3*3}", "U4(3).(2^2)_{133}", 3 ]
gap> Display( CharacterTable( "2.A6.2_1" ) mod 3 );
2.A6.2_1mod3

     2  5   5  4  3  1   1  4  4  3
     3  2   2  .  .  .   .  1  1  .
     5  1   1  .  .  1   1  .  .  .

       1a  2a 4a 8a 5a 10a 2b 4b 8b
    2P 1a  1a 2a 4a 5a  5a 1a 2a 4a
    3P 1a  2a 4a 8a 5a 10a 2b 4b 8b
    5P 1a  2a 4a 8a 1a  2a 2b 4b 8b

X.1     1   1  1  1  1   1  1  1  1
X.2     1   1  1  1  1   1 -1 -1 -1
X.3     6   6 -2  2  1   1  .  .  .
X.4     4   4  . -2 -1  -1  2 -2  .
X.5     4   4  . -2 -1  -1 -2  2  .
X.6     9   9  1  1 -1  -1  3  3 -1
X.7     9   9  1  1 -1  -1 -3 -3  1
X.8     4  -4  .  . -1   1  .  .  .
X.9    12 -12  .  .  2  -2  .  .  .
gap> for input in cases do
>      p:= input[4];
>      modtblMG:=  CharacterTable( input[1] ) mod p;
>      ordtblMGA:= CharacterTable( input[2] );
>      modtblGA:=  CharacterTable( input[3] ) mod p;
>      name:= Concatenation( Identifier( ordtblMGA ), " mod ", String(p) );
>      if ForAll( [ modtblMG, modtblGA ], IsCharacterTable ) then
>        poss:= BrauerTableOfTypeMGA( modtblMG, modtblGA, ordtblMGA );
>        modlib:= ordtblMGA mod p;
>        if IsCharacterTable( modlib ) then
>          trans:= TransformingPermutationsCharacterTables( poss.table,
>                      modlib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>        else
>          Print( "#I  no library table for ", name, "\n" );
>        fi;
>      else
>        Print( "#I  not all input tables for ", name, " available\n" );
>      fi;
>    od;
#I  not all input tables for 2.L2(49).2_2 mod 7 available
#I  not all input tables for 2.L2(81).2_1 mod 3 available
#I  not all input tables for 2.L2(81).4_1 mod 3 available
#I  not all input tables for 2.L2(81).4_1 mod 3 available
gap> c2:= CharacterTable( "Cyclic", 2 );;
gap> t:= c2 * c2;;
gap> tC:= CharacterTable( "Dihedral", 8 );;
gap> tK:= CharacterTable( "Alternating", 4 );;
gap> tfustC:= PossibleClassFusions( t, tC );
[ [ 1, 3, 4, 4 ], [ 1, 3, 5, 5 ], [ 1, 4, 3, 4 ], [ 1, 4, 4, 3 ], 
  [ 1, 5, 3, 5 ], [ 1, 5, 5, 3 ] ]
gap> StoreFusion( t, tfustC[1], tC );
gap> tfustK:= PossibleClassFusions( t, tK );
[ [ 1, 2, 2, 2 ] ]
gap> StoreFusion( t, tfustK[1], tK );
gap> elms:= PossibleActionsForTypeGS3( t, tC, tK );
[ (3,4) ]
gap> new:= CharacterTableOfTypeGS3( t, tC, tK, elms[1], "S4" );
rec( table := CharacterTable( "S4" ), tblCfustblKC := [ 1, 4, 2, 2, 5 ], 
  tblKfustblKC := [ 1, 2, 3, 3 ] )
gap> Display( new.table );
S4

     2  3  3  .  2  2
     3  1  .  1  .  .

       1a 2a 3a 4a 2b
    2P 1a 1a 3a 2a 1a
    3P 1a 2a 1a 4a 2b

X.1     1  1  1  1  1
X.2     1  1  1 -1 -1
X.3     3 -1  .  1 -1
X.4     3 -1  . -1  1
X.5     2  2 -1  .  .
gap> t:= CharacterTable( "Cyclic", 2 );;
gap> tC:= CharacterTable( "Cyclic", 6 );;
gap> tK:= CharacterTable( "Quaternionic", 8 );;
gap> tfustC:= PossibleClassFusions( t, tC );
[ [ 1, 4 ] ]
gap> StoreFusion( t, tfustC[1], tC );
gap> tfustK:= PossibleClassFusions( t, tK );
[ [ 1, 3 ] ]
gap> StoreFusion( t, tfustK[1], tK );
gap> elms:= PossibleActionsForTypeGS3( t, tC, tK );
[ (2,5,4) ]
gap> new:= CharacterTableOfTypeGS3( t, tC, tK, elms[1], "SL(2,3)" );
rec( table := CharacterTable( "SL(2,3)" ), 
  tblCfustblKC := [ 1, 4, 5, 3, 6, 7 ], tblKfustblKC := [ 1, 2, 3, 2, 2 ] )
gap> Display( new.table );
SL(2,3)

     2  3  2  3  1   1   1  1
     3  1  .  1  1   1   1  1

       1a 4a 2a 6a  3a  3b 6b
    2P 1a 2a 1a 3a  3b  3a 3b
    3P 1a 4a 2a 2a  1a  1a 2a

X.1     1  1  1  1   1   1  1
X.2     1  1  1  A  /A   A /A
X.3     1  1  1 /A   A  /A  A
X.4     3 -1  3  .   .   .  .
X.5     2  . -2 /A  -A -/A  A
X.6     2  . -2  1  -1  -1  1
X.7     2  . -2  A -/A  -A /A

A = E(3)
  = (-1+Sqrt(-3))/2 = b3
gap> listGS3:= [
> [ "U3(5)",      "U3(5).2",      "U3(5).3",      "U3(5).S3"        ],
> [ "3.U3(5)",    "3.U3(5).2",    "3.U3(5).3",    "3.U3(5).S3"      ],
> [ "L3(4)",      "L3(4).2_2",    "L3(4).3",      "L3(4).3.2_2"     ],
> [ "L3(4)",      "L3(4).2_3",    "L3(4).3",      "L3(4).3.2_3"     ],
> [ "3.L3(4)",    "3.L3(4).2_2",  "3.L3(4).3",    "3.L3(4).3.2_2"   ],
> [ "2^2.L3(4)",  "2^2.L3(4).2_2","2^2.L3(4).3",  "2^2.L3(4).3.2_2" ],
> [ "2^2.L3(4)",  "2^2.L3(4).2_3","2^2.L3(4).3",  "2^2.L3(4).3.2_3" ],
> [ "U6(2)",      "U6(2).2",      "U6(2).3",      "U6(2).3.2"       ],
> [ "3.U6(2)",    "3.U6(2).2",    "3.U6(2).3",    "3.U6(2).3.2"     ],
> [ "2^2.U6(2)",  "2^2.U6(2).2",  "2^2.U6(2).3",  "2^2.U6(2).3.2"   ],
> [ "O8+(2)",     "O8+(2).2",     "O8+(2).3",     "O8+(2).3.2"      ],
> [ "2^2.O8+(2)", "2^2.O8+(2).2", "2^2.O8+(2).3", "2^2.O8+(2).3.2"  ],
> [ "L3(7)",      "L3(7).2",      "L3(7).3",      "L3(7).S3"        ],
> [ "3.L3(7)",    "3.L3(7).2",    "3.L3(7).3",    "3.L3(7).S3"      ],
> [ "U3(8)",      "U3(8).2",      "U3(8).3_2",    "U3(8).S3"        ],
> [ "3.U3(8)",    "3.U3(8).2",    "3.U3(8).3_2",  "3.U3(8).S3"      ],
> [ "U3(11)",     "U3(11).2",     "U3(11).3",     "U3(11).S3"       ],
> [ "3.U3(11)",   "3.U3(11).2",   "3.U3(11).3",   "3.U3(11).S3"     ],
> [ "O8+(3)",     "O8+(3).2_2",   "O8+(3).3",     "O8+(3).S3"       ],
> [ "2E6(2)",     "2E6(2).2",     "2E6(2).3",     "2E6(2).S3"       ],
> [ "2^2.2E6(2)", "2^2.2E6(2).2", "2^2.2E6(2).3", "2^2.2E6(2).S3"   ],
> ];;
gap> Append( listGS3, [
> [ "L3(4).2_1",          "L3(4).2^2",     "L3(4).6",     "L3(4).D12"     ],
> [ "2^2.L3(4).2_1",      "2^2.L3(4).2^2", "2^2.L3(4).6", "2^2.L3(4).D12" ],
> [ "O8+(3).(2^2)_{111}", "O8+(3).D8",     "O8+(3).A4",   "O8+(3).S4"     ],
> ] );
gap> ProcessGS3Example:= function( t, tC, tK, identifier, pi )
>    local tF, lib, trans, p, tmodp, tCmodp, tKmodp, modtF;
> 
>    tF:= CharacterTableOfTypeGS3( t, tC, tK, pi,
>             Concatenation( identifier, "new" ) );
>    lib:= CharacterTable( identifier );
>    if lib <> fail then
>      trans:= TransformingPermutationsCharacterTables( tF.table, lib );
>      if not IsRecord( trans ) then
>        Print( "#E  computed table and library table for `", identifier,
>               "' differ\n" );
>      fi;
>    else
>      Print( "#I  no library table for `", identifier, "'\n" );
>    fi;
>    StoreFusion( tC, tF.tblCfustblKC, tF.table );
>    StoreFusion( tK, tF.tblKfustblKC, tF.table );
>    for p in Set( Factors( Size( t ) ) ) do
>      tmodp := t  mod p;
>      tCmodp:= tC mod p;
>      tKmodp:= tK mod p;
>      if IsCharacterTable( tmodp ) and
>         IsCharacterTable( tCmodp ) and
>         IsCharacterTable( tKmodp ) then
>        modtF:= CharacterTableOfTypeGS3( tmodp, tCmodp, tKmodp,
>                    tF.table,
>                    Concatenation(  identifier, "mod", String( p ) ) );
>        if   Length( Irr( modtF.table ) ) <>
>             Length( Irr( modtF.table )[1] ) then
>          Print( "#E  nonsquare result table for `",
>                 identifier, " mod ", p, "'\n" );
>        elif lib <> fail and IsCharacterTable( lib mod p ) then
>          trans:= TransformingPermutationsCharacterTables( modtF.table,
>                                                           lib mod p );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for `",
>                   identifier, " mod ", p, "' differ\n" );
>          fi;
>        else
>          Print( "#I  no library table for `", identifier, " mod ",
>                 p, "'\n" );
>        fi;
>      else
>        Print( "#I  not all inputs available for `", identifier,
>               " mod ", p, "'\n" );
>      fi;
>    od;
> end;;
gap> for input in listGS3 do
>      t := CharacterTable( input[1] );
>      tC:= CharacterTable( input[2] );
>      tK:= CharacterTable( input[3] );
>      identifier:= input[4];
>      elms:= PossibleActionsForTypeGS3( t, tC, tK );
>      if Length( elms ) = 1 then
>        ProcessGS3Example( t, tC, tK, identifier, elms[1] );
>      else
>        Print( "#I  ", Length( elms ), " actions possible for `",
>               identifier, "'\n" );
>      fi;
>    od;
#I  not all inputs available for `O8+(3).S3 mod 3'
#I  not all inputs available for `2E6(2).S3 mod 2'
#I  not all inputs available for `2E6(2).S3 mod 3'
#I  not all inputs available for `2E6(2).S3 mod 5'
#I  not all inputs available for `2E6(2).S3 mod 7'
#I  not all inputs available for `2E6(2).S3 mod 11'
#I  not all inputs available for `2E6(2).S3 mod 13'
#I  not all inputs available for `2E6(2).S3 mod 17'
#I  not all inputs available for `2E6(2).S3 mod 19'
#I  not all inputs available for `2^2.2E6(2).S3 mod 2'
#I  not all inputs available for `2^2.2E6(2).S3 mod 3'
#I  not all inputs available for `2^2.2E6(2).S3 mod 5'
#I  not all inputs available for `2^2.2E6(2).S3 mod 7'
#I  not all inputs available for `2^2.2E6(2).S3 mod 11'
#I  not all inputs available for `2^2.2E6(2).S3 mod 13'
#I  not all inputs available for `2^2.2E6(2).S3 mod 17'
#I  not all inputs available for `2^2.2E6(2).S3 mod 19'
#I  not all inputs available for `O8+(3).S4 mod 3'
gap> input:= [ "O8+(3)", "O8+(3).3", "O8+(3).(2^2)_{111}", "O8+(3).A4" ];;
gap> t := CharacterTable( input[1] );;
gap> tC:= CharacterTable( input[2] );;
gap> tK:= CharacterTable( input[3] );;
gap> identifier:= input[4];;
gap> elms:= PossibleActionsForTypeGS3( t, tC, tK );;
gap> Length( elms );
4
gap> differ:= MovedPoints( Group( List( elms, x -> x / elms[1] ) ) );;
gap> List( elms, x -> RestrictedPerm( x, differ ) );
[ (118,216,169)(119,217,170)(120,218,167)(121,219,168), 
  (118,216,170)(119,217,169)(120,219,168)(121,218,167), 
  (118,217,169)(119,216,170)(120,218,168)(121,219,167), 
  (118,217,170)(119,216,169)(120,219,167)(121,218,168) ]
gap> poss:= List( elms, pi -> CharacterTableOfTypeGS3( t, tC, tK, pi,
>             Concatenation( identifier, "new" ) ) );;
gap> lib:= CharacterTable( identifier );;
gap> ForAll( poss, r -> IsRecord(
>        TransformingPermutationsCharacterTables( r.table, lib ) ) );
true
gap> ProcessGS3Example( t, tC, tK, identifier, elms[1] );
#I  not all inputs available for `O8+(3).A4 mod 3'
gap> tblG:= CharacterTable( "A6" );;
gap> tblsG2:= List( [ "A6.2_1", "A6.2_2", "A6.2_3" ], CharacterTable );;
gap> List( tblsG2, NrConjugacyClasses );
[ 11, 11, 8 ]
gap> possact:= List( tblsG2, x -> Filtered( Elements( 
>        AutomorphismsOfTable( x ) ), y -> Order( y ) <= 2 ) );
[ [ (), (3,4)(7,8)(10,11) ], [ (), (8,9), (5,6)(10,11), (5,6)(8,9)(10,11) ], 
  [ (), (7,8) ] ]
gap> List( tblsG2, x -> GetFusionMap( tblG, x ) );
[ [ 1, 2, 3, 4, 5, 6, 6 ], [ 1, 2, 3, 3, 4, 5, 6 ], [ 1, 2, 3, 3, 4, 5, 5 ] ]
gap> acts:= PossibleActionsForTypeGV4( tblG, tblsG2 );    
[ [ (3,4)(7,8)(10,11), (5,6)(8,9)(10,11), (7,8) ] ]
gap> poss:= PossibleCharacterTablesOfTypeGV4( tblG, tblsG2, acts[1], "A6.2^2" );
[ rec(
      G2fusGV4 := [ [ 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 8 ],
          [ 1, 2, 3, 4, 5, 5, 9, 10, 10, 11, 11 ],
          [ 1, 2, 3, 4, 5, 12, 13, 13 ] ],
      table := CharacterTable( "A6.2^2" ) ) ]
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                  CharacterTable( "A6.2^2" ) ) );
true
gap> PossibleCharacterTablesOfTypeGV4( tblG mod 3,
>        List( tblsG2, t -> t mod 3 ), poss[1].table );
[ rec(
      G2fusGV4 := [ [ 1, 2, 3, 4, 5, 5, 6 ], [ 1, 2, 3, 4, 4, 7, 8, 8, 9, 9 ],
          [ 1, 2, 3, 4, 10, 11, 11 ] ], table := BrauerTable( "A6.2^2", 3 ) )
 ]
gap> listGV4:= [
> [ "A6",      "A6.2_1",      "A6.2_2",      "A6.2_3",      "A6.2^2"      ],
> [ "3.A6",    "3.A6.2_1",    "3.A6.2_2",    "3.A6.2_3",    "3.A6.2^2"    ],
> [ "L2(25)",  "L2(25).2_1",  "L2(25).2_2",  "L2(25).2_3",  "L2(25).2^2"  ],
> [ "L3(4)",   "L3(4).2_1",   "L3(4).2_2",   "L3(4).2_3",   "L3(4).2^2"   ],
> [ "2^2.L3(4)", "2^2.L3(4).2_1", "2^2.L3(4).2_2", "2^2.L3(4).2_3",
>                                                         "2^2.L3(4).2^2" ],
> [ "3.L3(4)", "3.L3(4).2_1", "3.L3(4).2_2", "3.L3(4).2_3", "3.L3(4).2^2" ],
> [ "U4(3)",   "U4(3).2_1",   "U4(3).2_2",   "U4(3).2_2'",
>                                                     "U4(3).(2^2)_{122}" ],
> [ "U4(3)",   "U4(3).2_1",   "U4(3).2_3",   "U4(3).2_3'",
>                                                     "U4(3).(2^2)_{133}" ],
> [ "3_1.U4(3)", "3_1.U4(3).2_1", "3_1.U4(3).2_2", "3_1.U4(3).2_2'",
>                                                 "3_1.U4(3).(2^2)_{122}" ],
> [ "3_2.U4(3)", "3_2.U4(3).2_1", "3_2.U4(3).2_3", "3_2.U4(3).2_3'",
>                                                 "3_2.U4(3).(2^2)_{133}" ],
> [ "L2(49)",  "L2(49).2_1",  "L2(49).2_2",  "L2(49).2_3",  "L2(49).2^2"  ],
> [ "L2(81)",  "L2(81).2_1",  "L2(81).2_2",  "L2(81).2_3",  "L2(81).2^2"  ],
> [ "L3(9)",   "L3(9).2_1",   "L3(9).2_2",   "L3(9).2_3",   "L3(9).2^2"   ],
> [ "O8+(3)",  "O8+(3).2_1",  "O8+(3).2_2",  "O8+(3).2_2'",
>                                                    "O8+(3).(2^2)_{122}" ],
> [ "O8-(3)",  "O8-(3).2_1",  "O8-(3).2_2",  "O8-(3).2_3",  "O8-(3).2^2"  ],
> ];;
gap> Append( listGV4, [
> [ "L3(4).3", "L3(4).6",     "L3(4).3.2_2", "L3(4).3.2_3", "L3(4).D12"   ],
> [ "2^2.L3(4).3", "2^2.L3(4).6", "2^2.L3(4).3.2_2", "2^2.L3(4).3.2_3",
>                                                         "2^2.L3(4).D12" ],
> [ "U4(3).2_1", "U4(3).4", "U4(3).(2^2)_{122}", "U4(3).(2^2)_{133}",
>                                                              "U4(3).D8" ],
> [ "O8+(3).2_1", "O8+(3).(2^2)_{111}", "O8+(3).(2^2)_{122}", "O8+(3).4",
>                                                             "O8+(3).D8" ],
> [ "L4(4)",   "L4(4).2_1",   "L4(4).2_2",   "L4(4).2_3",   "L4(4).2^2"   ],
> [ "U4(5)",   "U4(5).2_1",   "U4(5).2_2",   "U4(5).2_3",   "U4(5).2^2"   ],
> ] );
gap> ConstructOrdinaryGV4Table:= function( tblG, tblsG2, name, lib )
>      local acts, nam, poss, reps, i, trans;
> 
>      # Compute the possible actions for the ordinary tables.
>      acts:= PossibleActionsForTypeGV4( tblG, tblsG2 );
>      # Compute the possible ordinary tables for the given actions.
>      nam:= Concatenation( "new", name );
>      poss:= Concatenation( List( acts, triple -> 
>          PossibleCharacterTablesOfTypeGV4( tblG, tblsG2, triple, nam ) ) );
>      # Test the possibilities for permutation equivalence.
>      reps:= RepresentativesCharacterTables( poss );
>      if 1 < Length( reps ) then
>        Print( "#I  ", name, ": ", Length( reps ),
>               " equivalence classes\n" );
>      elif Length( reps ) = 0 then
>        Print( "#E  ", name, ": no solution\n" );
>      else
>        # Compare the computed table with the library table.
>        if not IsCharacterTable( lib ) then
>          Print( "#I  no library table for ", name, "\n" );
>          PrintToLib( name, poss[1].table );
>          for i in [ 1 .. 3 ] do
>            Print( LibraryFusion( tblsG2[i],
>                       rec( name:= name, map:= poss[1].G2fusGV4[i] ) ) );
>          od;
>        else
>          trans:= TransformingPermutationsCharacterTables( poss[1].table,
>                      lib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>          # Compare the computed fusions with the stored ones.
>          if List( poss[1].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>                 <> List( tblsG2, x -> GetFusionMap( x, lib ) ) then
>            Print( "#E  computed and stored fusions for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      return poss;
>    end;;
gap> ConstructModularGV4Tables:= function( tblG, tblsG2, ordposs,
>                                          ordlibtblGV4 )
>      local name, modposs, primes, checkordinary, i, record, p, tmodp,
>            t2modp, poss, modlib, trans, reps;
> 
>      if not IsCharacterTable( ordlibtblGV4 ) then
>        Print( "#I  no ordinary library table ...\n" );
>        return [];
>      fi;
>      name:= Identifier( ordlibtblGV4 );
>      modposs:= [];
>      primes:= Set( Factors( Size( tblG ) ) );
>      ordposs:= ShallowCopy( ordposs );
>      checkordinary:= false;
>      for i in [ 1 .. Length( ordposs ) ] do
>        modposs[i]:= [];
>        record:= ordposs[i];
>        for p in primes do
>          tmodp := tblG  mod p;
>          t2modp:= List( tblsG2, t2 -> t2 mod p );
>          if IsCharacterTable( tmodp ) and
>             ForAll( t2modp, IsCharacterTable ) then
>            poss:= PossibleCharacterTablesOfTypeGV4( tmodp, t2modp,
>                       record.table, record.G2fusGV4 );
>            poss:= RepresentativesCharacterTables( poss );
>            if   Length( poss ) = 0 then
>              Print( "#I  excluded cand. ", i, " (out of ",
>                     Length( ordposs ), ") for ", name, " by ", p,
>                     "-mod. table\n" );
>              Unbind( ordposs[i] );
>              Unbind( modposs[i] );
>              checkordinary:= true;
>              break;
>            elif Length( poss ) = 1 then
>              # Compare the computed table with the library table.
>              modlib:= ordlibtblGV4 mod p;
>              if IsCharacterTable( modlib ) then
>                trans:= TransformingPermutationsCharacterTables(
>                            poss[1].table, modlib );
>                if not IsRecord( trans ) then
>                  Print( "#E  computed table and library table for ",
>                         name, " mod ", p, " differ\n" );
>                fi;
>              else
>                Print( "#I  no library table for ",
>                       name, " mod ", p, "\n" );
>                PrintToLib( name, poss[1].table );
>              fi;
>            else
>              Print( "#I  ", name, " mod ", p, ": ", Length( poss ),
>                     " equivalence classes\n" );
>            fi;
>            Add( modposs[i], poss );
>          else
>            Print( "#I  not all input tables for ", name, " mod ", p,
>                   " available\n" );
>            primes:= Difference( primes, [ p ] );
>          fi;
>        od;
>      od;
>      if checkordinary then
>        # Test whether the ordinary table is admissible.
>        ordposs:= Compacted( ordposs );
>        modposs:= Compacted( modposs );
>        reps:= RepresentativesCharacterTables( ordposs );
>        if 1 < Length( reps ) then
>          Print( "#I  ", name, ": ", Length( reps ),
>                 " equivalence classes (ord. table)\n" );
>        elif Length( reps ) = 0 then
>          Print( "#E  ", name, ": no solution (ord. table)\n" );
>        else
>          # Compare the computed table with the library table.
>          trans:= TransformingPermutationsCharacterTables(
>                      ordposs[1].table, ordlibtblGV4 );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>          # Compare the computed fusions with the stored ones.
>          if List( ordposs[1].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>               <> List( tblsG2, x -> GetFusionMap( x, ordlibtblGV4 ) ) then
>            Print( "#E  computed and stored fusions for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      return rec( ordinary:= ordposs, modular:= modposs );
>    end;;
gap> for input in listGV4 do
>      tblG   := CharacterTable( input[1] );
>      tblsG2 := List( input{ [ 2 .. 4 ] }, CharacterTable );
>      lib    := CharacterTable( input[5] );
>      poss   := ConstructOrdinaryGV4Table( tblG, tblsG2, input[5], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>    od;
#I  excluded cand. 2 (out of 2) for L3(4).2^2 by 3-mod. table
#I  excluded cand. 2 (out of 8) for 2^2.L3(4).2^2 by 7-mod. table
#I  excluded cand. 3 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 4 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 5 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 6 (out of 8) for 2^2.L3(4).2^2 by 5-mod. table
#I  excluded cand. 7 (out of 8) for 2^2.L3(4).2^2 by 7-mod. table
#I  excluded cand. 2 (out of 2) for 3.L3(4).2^2 by 3-mod. table
#I  not all input tables for L2(49).2^2 mod 7 available
#I  not all input tables for L2(81).2^2 mod 3 available
#I  excluded cand. 2 (out of 2) for L3(9).2^2 by 7-mod. table
#I  not all input tables for O8+(3).(2^2)_{122} mod 3 available
#I  not all input tables for O8-(3).2^2 mod 2 available
#I  not all input tables for O8-(3).2^2 mod 3 available
#I  not all input tables for O8-(3).2^2 mod 5 available
#I  not all input tables for O8-(3).2^2 mod 7 available
#I  not all input tables for O8-(3).2^2 mod 13 available
#I  not all input tables for O8-(3).2^2 mod 41 available
#I  excluded cand. 2 (out of 2) for L3(4).D12 by 3-mod. table
#I  excluded cand. 2 (out of 2) for 2^2.L3(4).D12 by 7-mod. table
#I  not all input tables for O8+(3).D8 mod 3 available
#I  not all input tables for L4(4).2^2 mod 3 available
#I  not all input tables for L4(4).2^2 mod 5 available
#I  not all input tables for L4(4).2^2 mod 7 available
#I  not all input tables for L4(4).2^2 mod 17 available
#I  not all input tables for U4(5).2^2 mod 2 available
#I  not all input tables for U4(5).2^2 mod 3 available
#I  not all input tables for U4(5).2^2 mod 5 available
#I  not all input tables for U4(5).2^2 mod 7 available
#I  not all input tables for U4(5).2^2 mod 13 available
gap> tblG:= CharacterTable( "S4(9)" );;
gap> tblsG2:= List( [ "S4(9).2_1", "S4(9).2_2", "S4(9).2_3" ],
>                   CharacterTable );;
gap> lib:= CharacterTable( "S4(9).2^2" );;
gap> poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, "newS4(9).2^2", lib );;
#I  newS4(9).2^2: 2 equivalence classes
gap> poss:= RepresentativesCharacterTables( poss );;
gap> order80:= PositionsProperty( OrdersClassRepresentatives( tblsG2[2] ),
>                  x -> x = 80 );
[ 98, 99, 100, 101, 102, 103, 104, 105 ]
gap> List( poss, r -> r.G2fusGV4[2]{ order80 } );
[ [ 77, 77, 78, 79, 80, 78, 79, 80 ], [ 77, 78, 79, 79, 77, 80, 80, 78 ] ]
gap> PowerMap( tblsG2[2], 3 ){ order80 };
[ 99, 98, 103, 104, 105, 100, 101, 102 ]
gap> PowerMap( tblsG2[2], 13 ){ order80 };
[ 102, 105, 101, 100, 98, 104, 103, 99 ]
gap> List( tblsG2, x -> 80 in OrdersClassRepresentatives( x ) );
[ false, true, false ]
gap> tbl:= poss[1].table;;
gap> IsRecord( TransformingPermutationsCharacterTables( tbl, lib ) );
true
gap> names:= List( [ 1 .. 3 ],
>                  i -> Concatenation( "2.L3(4).2_", String( i ) ) );;
gap> tbls:= List( names, CharacterTable );
[ CharacterTable( "2.L3(4).2_1" ), CharacterTable( "2.L3(4).2_2" ), 
  CharacterTable( "2.L3(4).2_3" ) ]
gap> isos:= List( names, nam -> CharacterTable( Concatenation( nam, "*" ) ) );
[ CharacterTable( "Isoclinic(2.L3(4).2_1)" ), 
  CharacterTable( "Isoclinic(2.L3(4).2_2)" ), 
  CharacterTable( "Isoclinic(2.L3(4).2_3)" ) ]
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "2.L3(4).(2^2)_{123}" ],
> [ tbls[1], isos[2], tbls[3], "2.L3(4).(2^2)_{12*3}" ],
> [ tbls[1], tbls[2], isos[3], "2.L3(4).(2^2)_{123*}" ],
> [ tbls[1], isos[2], isos[3], "2.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], tbls[2], tbls[3], "2.L3(4).(2^2)_{1*23}" ],
> [ isos[1], isos[2], tbls[3], "2.L3(4).(2^2)_{1*2*3}" ],
> [ isos[1], tbls[2], isos[3], "2.L3(4).(2^2)_{1*23*}" ],
> [ isos[1], isos[2], isos[3], "2.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "2.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 2.L3(4).(2^2)_{1*23*} by 5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new2.L3(4).(2^2)_{1*2*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 39, 33, 33, 39, 33, 39, 39, 33 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 7, 6 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 8, 5 ]
gap> l34:= CharacterTable( "L3(4)" );;
gap> u:= CharacterTable( "U6(2)" );;
gap> 2u:= CharacterTable( "2.U6(2)" );;
gap> cand:= PossibleClassFusions( l34, 2u );
[ [ 1, 5, 12, 16, 22, 22, 23, 23, 41, 41 ], 
  [ 1, 5, 12, 22, 16, 22, 23, 23, 41, 41 ], 
  [ 1, 5, 12, 22, 22, 16, 23, 23, 41, 41 ] ]
gap> OrdersClassRepresentatives( l34 );
[ 1, 2, 3, 4, 4, 4, 5, 5, 7, 7 ]
gap> GetFusionMap( 2u, u ){ [ 16, 22 ] };
[ 10, 14 ]
gap> ClassNames( u, "ATLAS" ){ [ 10, 14 ] };
[ "4C", "4G" ]
gap> GetFusionMap( u, CharacterTable( "U6(2).3" ) );
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
  20, 21, 22, 23, 24, 24, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 
  36, 36, 37, 38, 39, 40 ]
gap> 2u2:= CharacterTable( "2.U6(2).2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2u2 ) );;
gap> List( fus, Length );
[ 4, 0, 0, 0, 0, 0, 0, 0 ]
gap> 2u2iso:= CharacterTableIsoclinic( 2u2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2u2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 4, 0, 0, 0, 0 ]
gap> h2:= CharacterTable( "HS.2" );;
gap> 2h2:= CharacterTable( "2.HS.2" );;
gap> PossibleClassFusions( l34, 2h2 );
[  ]
gap> fus:= List( result, x -> PossibleClassFusions( x, 2h2 ) );;
gap> List( fus, Length );
[ 0, 0, 0, 0, 4, 0, 0, 0 ]
gap> 2h2iso:= CharacterTableIsoclinic( 2h2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2h2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 0, 0, 0, 0, 4 ]
gap> tbls:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "6.L3(4).2_", i ) ) );
[ CharacterTable( "6.L3(4).2_1" ), CharacterTable( "6.L3(4).2_2" ), 
  CharacterTable( "6.L3(4).2_3" ) ]
gap> isos:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "6.L3(4).2_", i, "*" ) ) );
[ CharacterTable( "Isoclinic(6.L3(4).2_1)" ), 
  CharacterTable( "Isoclinic(6.L3(4).2_2)" ), 
  CharacterTable( "Isoclinic(6.L3(4).2_3)" ) ]
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "6.L3(4).(2^2)_{123}" ],
> [ tbls[1], isos[2], tbls[3], "6.L3(4).(2^2)_{12*3}" ],
> [ tbls[1], tbls[2], isos[3], "6.L3(4).(2^2)_{123*}" ],
> [ tbls[1], isos[2], isos[3], "6.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], tbls[2], tbls[3], "6.L3(4).(2^2)_{1*23}" ],
> [ isos[1], isos[2], tbls[3], "6.L3(4).(2^2)_{1*2*3}" ],
> [ isos[1], tbls[2], isos[3], "6.L3(4).(2^2)_{1*23*}" ],
> [ isos[1], isos[2], isos[3], "6.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "6.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{12*3*} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 6.L3(4).(2^2)_{1*23*} by 5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new6.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 59, 53, 53, 59, 53, 59, 59, 53 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 7, 6, 4 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 8, 5, 3 ]
gap> 2l34:= CharacterTable( "2.L3(4)" );;
gap> 6u:= CharacterTable( "6.U6(2)" );;
gap> cand:= PossibleClassFusions( 2l34, 6u );
[  ]
gap> 6u2:= CharacterTable( "6.U6(2).2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 6u2 ) );;
gap> List( fus, Length );
[ 8, 0, 0, 0, 0, 0, 0, 0 ]
gap> 6u2iso:= CharacterTableIsoclinic( 6u2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 6u2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 8, 0, 0, 0, 0 ]
gap> 3l34:= CharacterTable( "3.L3(4)" );;
gap> g2:= CharacterTable( "G2(4).2" );;
gap> 2g2:= CharacterTable( "2.G2(4).2" );;
gap> PossibleClassFusions( 3l34, 2g2 );
[  ]
gap> fus:= List( result, x -> PossibleClassFusions( x, 2g2 ) );;
gap> List( fus, Length );
[ 0, 0, 16, 0, 0, 0, 0, 0 ]
gap> 2g2iso:= CharacterTableIsoclinic( 2g2 );;
gap> fus:= List( result, x -> PossibleClassFusions( x, 2g2iso ) );;
gap> List( fus, Length );
[ 0, 0, 0, 0, 0, 0, 0, 16 ]
gap> names:= [ "L3(4).(2^2)_{123}", "L3(4).(2^2)_{12*3}",
>              "L3(4).(2^2)_{123*}", "L3(4).(2^2)_{12*3*}" ];;
gap> inputs1:= List( names, nam -> [ "6.L3(4).2_1", "2.L3(4).2_1",
>                Concatenation( "2.", nam ), Concatenation( "6.", nam ) ] );;
gap> names:= List( names, nam -> ReplacedString( nam, "1", "1*" ) );;
gap> inputs2:= List( names, nam -> [ "6.L3(4).2_1*", "2.L3(4).2_1*",
>                Concatenation( "2.", nam ), Concatenation( "6.", nam ) ] );;
gap> inputs:= Concatenation( inputs1, inputs2 );
[ [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{123}", 
      "6.L3(4).(2^2)_{123}" ], 
  [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{12*3}", 
      "6.L3(4).(2^2)_{12*3}" ], 
  [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{123*}", 
      "6.L3(4).(2^2)_{123*}" ], 
  [ "6.L3(4).2_1", "2.L3(4).2_1", "2.L3(4).(2^2)_{12*3*}", 
      "6.L3(4).(2^2)_{12*3*}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*23}", 
      "6.L3(4).(2^2)_{1*23}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*2*3}", 
      "6.L3(4).(2^2)_{1*2*3}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*23*}", 
      "6.L3(4).(2^2)_{1*23*}" ], 
  [ "6.L3(4).2_1*", "2.L3(4).2_1*", "2.L3(4).(2^2)_{1*2*3*}", 
      "6.L3(4).(2^2)_{1*2*3*}" ] ]
gap> result2:= [];;
gap> for  input in inputs do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      Append( result2, poss );
>    od;
gap> result2:= List( result2, x -> x.table );
[ CharacterTable( "new6.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new6.L3(4).(2^2)_{1*2*3*}" ) ]
gap> trans:= List( [ 1 .. 8 ], i ->
>        TransformingPermutationsCharacterTables( result[i], result2[i] ) );;
gap> ForAll( trans, IsRecord );
true
gap> tbls:= List( [ "1", "2", "2'" ], i ->
>      CharacterTable( Concatenation( "2.U4(3).2_", i ) ) );;
gap> isos:= List( [ "1", "2", "2'" ], i ->
>      CharacterTable( Concatenation( "Isoclinic(2.U4(3).2_", i, ")" ) ) );;
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{122}" ],
> [ isos[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{1*22}" ],
> [ tbls[1], isos[2], tbls[3], "2.U4(3).(2^2)_{12*2}" ],
> [ isos[1], isos[2], tbls[3], "2.U4(3).(2^2)_{1*2*2}" ],
> [ tbls[1], isos[2], isos[3], "2.U4(3).(2^2)_{12*2*}" ],
> [ isos[1], isos[2], isos[3], "2.U4(3).(2^2)_{1*2*2*}" ] ];;
gap> tblG:= CharacterTable( "2.U4(3)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new2.U4(3).(2^2)_{122}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*22}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{12*2}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*2*2}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{12*2*}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*2*2*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 87, 102, 102, 87, 87, 102 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 4, 5 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 3, 6 ]
gap> u:= CharacterTable( "O8+(3)" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, u ) );;
gap> List( fus, Length );
[ 24, 0, 0, 0, 0, 0 ]
gap> u:= CharacterTable( "O7(3).2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, u ) );;
gap> List( fus, Length );
[ 0, 16, 0, 0, 0, 0 ]
gap> tbls:= List( [ "1", "3", "3'" ],
>      i -> CharacterTable( Concatenation( "2.U4(3).2_", i ) ) );;
gap> isos:= List( [ "1", "3", "3'" ], i ->
>      CharacterTable( Concatenation( "Isoclinic(2.U4(3).2_", i, ")" ) ) );;
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{133}" ],
> [ isos[1], tbls[2], tbls[3], "2.U4(3).(2^2)_{1*33}" ],
> [ tbls[1], isos[2], tbls[3], "2.U4(3).(2^2)_{13*3}" ],
> [ isos[1], isos[2], tbls[3], "2.U4(3).(2^2)_{1*3*3}" ],
> [ tbls[1], isos[2], isos[3], "2.U4(3).(2^2)_{13*3*}" ],
> [ isos[1], isos[2], isos[3], "2.U4(3).(2^2)_{1*3*3*}" ] ];;
gap> tblG:= CharacterTable( "2.U4(3)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 4) for 2.U4(3).(2^2)_{1*33} by 3-mod. table
#I  excluded cand. 3 (out of 4) for 2.U4(3).(2^2)_{1*33} by 3-mod. table
#I  excluded cand. 2 (out of 4) for 2.U4(3).(2^2)_{13*3} by 3-mod. table
#I  excluded cand. 3 (out of 4) for 2.U4(3).(2^2)_{13*3} by 3-mod. table
#I  excluded cand. 2 (out of 4) for 2.U4(3).(2^2)_{1*3*3*} by 3-mod. table
#I  excluded cand. 3 (out of 4) for 2.U4(3).(2^2)_{1*3*3*} by 3-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new2.U4(3).(2^2)_{133}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*33}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{13*3}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*3*3}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{13*3*}" ), 
  CharacterTable( "new2.U4(3).(2^2)_{1*3*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 69, 72, 72, 69, 69, 72 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 4, 5 ]
gap> t:= result[2];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 3, 6 ]
gap> tbls:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "4_1.L3(4).2_", i ) ) );
[ CharacterTable( "4_1.L3(4).2_1" ), CharacterTable( "4_1.L3(4).2_2" ), 
  CharacterTable( "4_1.L3(4).2_3" ) ]
gap> isos:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "4_1.L3(4).2_", i, "*" ) ) );
[ CharacterTable( "Isoclinic(4_1.L3(4).2_1)" ), 
  CharacterTable( "Isoclinic(4_1.L3(4).2_2)" ), 
  CharacterTable( "4_1.L3(4).2_3*" ) ]
gap> List( tbls, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ], [ 1, 2, 3, 4 ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( tbls[3],
>        CharacterTableIsoclinic( tbls[3] ) ) );
true
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "4_1.L3(4).(2^2)_{123}" ],
> [ isos[1], tbls[2], tbls[3], "4_1.L3(4).(2^2)_{1*23}" ],
> [ tbls[1], isos[2], tbls[3], "4_1.L3(4).(2^2)_{12*3}" ],
> [ isos[1], isos[2], tbls[3], "4_1.L3(4).(2^2)_{1*2*3}" ],
> [ tbls[1], tbls[2], isos[3], "4_1.L3(4).(2^2)_{123*}" ],
> [ isos[1], tbls[2], isos[3], "4_1.L3(4).(2^2)_{1*23*}" ],
> [ tbls[1], isos[2], isos[3], "4_1.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], isos[2], isos[3], "4_1.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "4_1.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{12*3} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_1.L3(4).(2^2)_{1*2*3} by 5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{1*2*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 48, 48, 48, 48, 42, 42, 42, 42 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 3, 2, 4 ]
gap> t:= result[5];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 7, 6, 8 ]
gap> facts:= [ CharacterTable( "2.L3(4).(2^2)_{123}" ), 
>              CharacterTable( "2.L3(4).(2^2)_{123*}" ) ];;
gap> factresults:= List( result, t -> t / ClassPositionsOfCentre( t ) );;
gap> List( factresults, t -> PositionProperty( facts, f ->
>            IsRecord( TransformingPermutationsCharacterTables( t, f ) ) ) );
[ 1, 1, 1, 1, 2, 2, 2, 2 ]
gap> test:= [ CharacterTable( "4_1.L3(4).2_1" ),
>             CharacterTable( "4_1.L3(4).2_1*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true
gap> test:= [ CharacterTable( "4_1.L3(4).2_2" ),
>             CharacterTable( "4_1.L3(4).2_2*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true
gap> names:= [ "L3(4).(2^2)_{123}", "L3(4).(2^2)_{1*23}",
>              "L3(4).(2^2)_{12*3}", "L3(4).(2^2)_{1*2*3}" ];;
gap> inputs1:= List( names, nam -> [ "4_1.L3(4).2_3", "2.L3(4).2_3",
>      Concatenation( "2.", nam ), Concatenation( "4_1.", nam ) ] );;
gap> names:= List( names, nam -> ReplacedString( nam, "3}", "3*}" ) );;
gap> inputs2:= List( names, nam -> [ "4_1.L3(4).2_3*", "2.L3(4).2_3*",
>      Concatenation( "2.", nam ), Concatenation( "4_1.", nam ) ] );;
gap> inputs:= Concatenation( inputs1, inputs2 );
[ [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{123}", 
      "4_1.L3(4).(2^2)_{123}" ], 
  [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{1*23}", 
      "4_1.L3(4).(2^2)_{1*23}" ], 
  [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{12*3}", 
      "4_1.L3(4).(2^2)_{12*3}" ], 
  [ "4_1.L3(4).2_3", "2.L3(4).2_3", "2.L3(4).(2^2)_{1*2*3}", 
      "4_1.L3(4).(2^2)_{1*2*3}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{123*}", 
      "4_1.L3(4).(2^2)_{123*}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{1*23*}", 
      "4_1.L3(4).(2^2)_{1*23*}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{12*3*}", 
      "4_1.L3(4).(2^2)_{12*3*}" ], 
  [ "4_1.L3(4).2_3*", "2.L3(4).2_3*", "2.L3(4).(2^2)_{1*2*3*}", 
      "4_1.L3(4).(2^2)_{1*2*3*}" ] ]
gap> result2:= [];;
gap> for  input in inputs do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      Append( result2, poss );
>    od;
#E  4 possibilities for new4_1.L3(4).(2^2)_{123}
#E  no solution for new4_1.L3(4).(2^2)_{1*23}
#E  no solution for new4_1.L3(4).(2^2)_{12*3}
#E  no solution for new4_1.L3(4).(2^2)_{1*2*3}
#E  4 possibilities for new4_1.L3(4).(2^2)_{123*}
#E  no solution for new4_1.L3(4).(2^2)_{1*23*}
#E  no solution for new4_1.L3(4).(2^2)_{12*3*}
#E  no solution for new4_1.L3(4).(2^2)_{1*2*3*}
gap> Length( result2 );
8
gap> result2:= List( result2, x -> x.table );
[ CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_1.L3(4).(2^2)_{123*}" ) ]
gap> List( result, t1 -> PositionsProperty( result2, t2 -> IsRecord(
>      TransformingPermutationsCharacterTables( t1, t2 ) ) ) );
[ [ 1 ], [ 4 ], [ 3 ], [ 2 ], [ 7 ], [ 6 ], [ 5 ], [ 8 ] ]
gap> tbls:= List( [ "1", "2", "3" ],
>      i -> CharacterTable( Concatenation( "4_2.L3(4).2_", i ) ) );
[ CharacterTable( "4_2.L3(4).2_1" ), CharacterTable( "4_2.L3(4).2_2" ), 
  CharacterTable( "4_2.L3(4).2_3" ) ]
gap> isos:= List( [ "1", "2", "3" ], 
>      i -> CharacterTable( Concatenation( "4_2.L3(4).2_", i, "*" ) ) );
[ CharacterTable( "Isoclinic(4_2.L3(4).2_1)" ), 
  CharacterTable( "4_2.L3(4).2_2*" ), 
  CharacterTable( "Isoclinic(4_2.L3(4).2_3)" ) ]
gap> List( tbls, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 2, 3, 4 ], [ 1, 3 ] ]
gap> IsRecord( TransformingPermutationsCharacterTables( tbls[2],
>        CharacterTableIsoclinic( tbls[2] ) ) );
true
gap> inputs:= [
> [ tbls[1], tbls[2], tbls[3], "4_2.L3(4).(2^2)_{123}" ],
> [ isos[1], tbls[2], tbls[3], "4_2.L3(4).(2^2)_{1*23}" ],
> [ tbls[1], isos[2], tbls[3], "4_2.L3(4).(2^2)_{12*3}" ],
> [ tbls[1], tbls[2], isos[3], "4_2.L3(4).(2^2)_{123*}" ],
> [ isos[1], isos[2], tbls[3], "4_2.L3(4).(2^2)_{1*2*3}" ],
> [ isos[1], tbls[2], isos[3], "4_2.L3(4).(2^2)_{1*23*}" ],
> [ tbls[1], isos[2], isos[3], "4_2.L3(4).(2^2)_{12*3*}" ],
> [ isos[1], isos[2], isos[3], "4_2.L3(4).(2^2)_{1*2*3*}" ] ];;
gap> tblG:= CharacterTable( "4_2.L3(4)" );;
gap> result:= [];;
gap> for input in inputs do
>      tblsG2:= input{ [ 1 .. 3 ] };
>      lib:= CharacterTable( input[4] );
>      poss:= ConstructOrdinaryGV4Table( tblG, tblsG2, input[4], lib );
>      ConstructModularGV4Tables( tblG, tblsG2, poss, lib );
>      Append( result, RepresentativesCharacterTables( poss ) );
>    od;
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{123} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{123} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{1*23} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{123*} by 5-mod. table
#I  excluded cand. 2 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 3 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 4 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 7-mod. table
#I  excluded cand. 5 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 7-mod. table
#I  excluded cand. 6 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 5-mod. table
#I  excluded cand. 7 (out of 8) for 4_2.L3(4).(2^2)_{1*23*} by 5-mod. table
gap> result:= List( result, x -> x.table );
[ CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*23}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123*}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*2*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*23*}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3*}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{1*2*3*}" ) ]
gap> List( result, NrConjugacyClasses );
[ 50, 50, 44, 50, 44, 50, 44, 44 ]
gap> t:= result[1];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 4, 2, 6 ]
gap> t:= result[3];;
gap> nsg:= Filtered( ClassPositionsOfNormalSubgroups( t ),
>            x -> Sum( SizesConjugacyClasses( t ){ x } ) = Size( t ) / 2 );;
gap> iso:= List( nsg, x -> CharacterTableIsoclinic( t, x ) );;
gap> List( iso, x -> PositionProperty( result, y ->
>            TransformingPermutationsCharacterTables( x, y ) <> fail ) );
[ 7, 5, 8 ]
gap> facts:= [ CharacterTable( "2.L3(4).(2^2)_{123}" ),
>              CharacterTable( "2.L3(4).(2^2)_{12*3}" ) ];;
gap> factresults:= List( result, t -> t / ClassPositionsOfCentre( t ) );;
gap> List( factresults, t -> PositionProperty( facts, f ->
>            IsRecord( TransformingPermutationsCharacterTables( t, f ) ) ) );
[ 1, 1, 2, 1, 2, 1, 2, 2 ]
gap> test:= [ CharacterTable( "4_2.L3(4).2_1" ),
>             CharacterTable( "4_2.L3(4).2_1*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true
gap> test:= [ CharacterTable( "4_2.L3(4).2_3" ),
>             CharacterTable( "4_2.L3(4).2_3*" ) ];;
gap> List( test, ClassPositionsOfCentre );
[ [ 1, 3 ], [ 1, 3 ] ]
gap> fact:= List( test, t -> t / ClassPositionsOfCentre( t ) );;
gap> IsRecord( TransformingPermutationsCharacterTables( fact[1], fact[2] ) );
true
gap> names:= [ "L3(4).(2^2)_{123}", "L3(4).(2^2)_{1*23}",
>              "L3(4).(2^2)_{123*}", "L3(4).(2^2)_{1*23*}" ];;
gap> inputs1:= List( names, nam -> [ "4_2.L3(4).2_2", "2.L3(4).2_2",
>      Concatenation( "2.", nam ), Concatenation( "4_2.", nam ) ] );;
gap> names:= List( names, nam -> ReplacedString( nam, "23", "2*3" ) );;
gap> inputs2:= List( names, nam -> [ "4_2.L3(4).2_2*", "2.L3(4).2_2*",
>      Concatenation( "2.", nam ), Concatenation( "4_2.", nam ) ] );;
gap> inputs:= Concatenation( inputs1, inputs2 );
[ [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{123}", 
      "4_2.L3(4).(2^2)_{123}" ], 
  [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{1*23}", 
      "4_2.L3(4).(2^2)_{1*23}" ], 
  [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{123*}", 
      "4_2.L3(4).(2^2)_{123*}" ], 
  [ "4_2.L3(4).2_2", "2.L3(4).2_2", "2.L3(4).(2^2)_{1*23*}", 
      "4_2.L3(4).(2^2)_{1*23*}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{12*3}", 
      "4_2.L3(4).(2^2)_{12*3}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{1*2*3}", 
      "4_2.L3(4).(2^2)_{1*2*3}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{12*3*}", 
      "4_2.L3(4).(2^2)_{12*3*}" ], 
  [ "4_2.L3(4).2_2*", "2.L3(4).2_2*", "2.L3(4).(2^2)_{1*2*3*}", 
      "4_2.L3(4).(2^2)_{1*2*3*}" ] ]
gap> result2:= [];;
gap> for  input in inputs do
>      tblMG := CharacterTable( input[1] );
>      tblG  := CharacterTable( input[2] );
>      tblGA := CharacterTable( input[3] );
>      name  := Concatenation( "new", input[4] );
>      lib   := CharacterTable( input[4] );
>      poss:= ConstructOrdinaryMGATable( tblMG, tblG, tblGA, name, lib );
>      Append( result2, poss );
>    od;
#E  4 possibilities for new4_2.L3(4).(2^2)_{123}
#E  no solution for new4_2.L3(4).(2^2)_{1*23}
#E  no solution for new4_2.L3(4).(2^2)_{123*}
#E  no solution for new4_2.L3(4).(2^2)_{1*23*}
#E  4 possibilities for new4_2.L3(4).(2^2)_{12*3}
#E  no solution for new4_2.L3(4).(2^2)_{1*2*3}
#E  no solution for new4_2.L3(4).(2^2)_{12*3*}
#E  no solution for new4_2.L3(4).(2^2)_{1*2*3*}
gap> Length( result2 );
8
gap> result2:= List( result2, x -> x.table );
[ CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{123}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ), 
  CharacterTable( "new4_2.L3(4).(2^2)_{12*3}" ) ]
gap> List( result, t1 -> PositionsProperty( result2, t2 -> IsRecord(
>      TransformingPermutationsCharacterTables( t1, t2 ) ) ) );
[ [ 1 ], [ 4 ], [ 7 ], [ 3 ], [ 6 ], [ 2 ], [ 5 ], [ 8 ] ]
gap> on2:= CharacterTable( "ON.2" );;
gap> fus:= List( result, x -> PossibleClassFusions( x, on2 ) );;
gap> List( fus, Length );
[ 0, 0, 16, 0, 0, 0, 0, 0 ]
gap> input:= [ "L2(81).2_1", "L2(81).4_1", "L2(81).4_2", "L2(81).2^2",
>                                                        "L2(81).(2x4)" ];;
gap> tblG   := CharacterTable( input[1] );;
gap> tblsG2 := List( input{ [ 2 .. 4 ] }, CharacterTable );;
gap> name   := Concatenation( "new", input[5] );;
gap> lib    := CharacterTable( input[5] );;
gap> poss   := ConstructOrdinaryGV4Table( tblG, tblsG2, name, lib );;
#I  newL2(81).(2x4): 2 equivalence classes
gap> reps:= RepresentativesCharacterTables( poss );;
gap> Length( reps );
2
gap> ord:= OrdersClassRepresentatives( reps[1].table );;
gap> ord = OrdersClassRepresentatives( reps[2].table ); 
true
gap> pos:= Position( ord, 80 );
33
gap> PowerMap( reps[1].table, 3 )[ pos ];
34
gap> PowerMap( reps[2].table, 3 )[ pos ];
33
gap> trans:= TransformingPermutationsCharacterTables( reps[2].table, lib );;
gap> IsRecord( trans );
true
gap> List( reps[2].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>  = List( tblsG2, x -> GetFusionMap( x, lib ) );
true
gap> ConstructModularGV4Tables( tblG, tblsG2, poss, lib );;
#I  not all input tables for L2(81).(2x4) mod 3 available
#I  not all input tables for L2(81).(2x4) mod 5 available
#I  not all input tables for L2(81).(2x4) mod 41 available
gap> input:= [ "O8+(3)", "O8+(3).2_1",  "O8+(3).2_1'", "O8+(3).2_1''",
>                                                  "O8+(3).(2^2)_{111}" ];;
gap> tblG   := CharacterTable( input[1] );;
gap> tblsG2 := List( input{ [ 2 .. 4 ] }, CharacterTable );;
gap> name   := Concatenation( "new", input[5] );;
gap> lib    := CharacterTable( input[5] );;
gap> poss   := ConstructOrdinaryGV4Table( tblG, tblsG2, name, lib );;
#I  newO8+(3).(2^2)_{111}: 2 equivalence classes
gap> Length( poss );
64
gap> reps:= RepresentativesCharacterTables( poss );;
gap> Length( reps );
2
gap> t:= reps[1].table;;
gap> ord7:= Filtered( [ 1 .. NrConjugacyClasses( t ) ],                        
>               i -> OrdersClassRepresentatives( t )[i] = 7 );
[ 37 ]
gap> SizesCentralizers( t ){ ord7 };
[ 112 ]
gap> ord28:= Filtered( [ 1 .. NrConjugacyClasses( t ) ],
>               i -> OrdersClassRepresentatives( t )[i] = 28 );
[ 112, 113, 114, 115, 161, 162, 163, 164, 210, 211, 212, 213 ]
gap> List( reps[1].G2fusGV4, x -> Intersection( ord28, x ) );
[ [ 112, 113, 114, 115 ], [ 161, 162, 163, 164 ], [ 210, 211, 212, 213 ] ]
gap> sub:= CharacterTable( "Cyclic", 28 ) * CharacterTable( "Cyclic", 4 );;
gap> List( reps, x -> Length( PossibleClassFusions( sub, x.table ) ) );
[ 0, 96 ]
gap> trans:= TransformingPermutationsCharacterTables( reps[2].table, lib );;
gap> IsRecord( trans );
true
gap> List( reps[2].G2fusGV4, x -> OnTuples( x, trans.columns ) )
>  = List( tblsG2, x -> GetFusionMap( x, lib ) );
true
gap> ConstructModularGV4Tables( tblG, tblsG2, poss, lib );;
#I  not all input tables for O8+(3).(2^2)_{111} mod 3 available
gap> t:= CharacterTable( "Sz(8)" );;
gap> 2t:= CharacterTable( "2.Sz(8)" );;
gap> aut:= AutomorphismsOfTable( t );;
gap> elms:= Set( List( Filtered( aut, x -> Order( x ) in [ 1, 3 ] ),           
>                      SmallestGeneratorPerm ) );
[ (), (9,10,11), (6,7,8), (6,7,8)(9,10,11), (6,7,8)(9,11,10) ]
gap> poss:= List( elms,                                         
>       pi -> PossibleCharacterTablesOfTypeV4G( t, 2t, pi, "2^2.Sz(8)" ) );
[ [ CharacterTable( "2^2.Sz(8)" ) ], [ CharacterTable( "2^2.Sz(8)" ) ], 
  [ CharacterTable( "2^2.Sz(8)" ) ], [ CharacterTable( "2^2.Sz(8)" ) ], 
  [ CharacterTable( "2^2.Sz(8)" ) ] ]
gap> reps:= RepresentativesCharacterTables( Concatenation( poss ) );
[ CharacterTable( "2^2.Sz(8)" ) ]
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1],
>        CharacterTable( "2^2.Sz(8)" ) ) );
true
gap> GetFusionMap( poss[1][1], 2t, "1" );
[ 1, 1, 2, 2, 3, 4, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 
  13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19 ]
gap> GetFusionMap( poss[1][1], 2t, "2" );
[ 1, 2, 1, 2, 3, 4, 5, 6, 7, 6, 7, 8, 9, 8, 9, 10, 11, 10, 11, 12, 13, 12, 
  13, 14, 15, 14, 15, 16, 17, 16, 17, 18, 19, 18, 19 ]
gap> GetFusionMap( poss[1][1], 2t, "3" );
[ 1, 2, 2, 1, 3, 4, 5, 6, 7, 7, 6, 8, 9, 9, 8, 10, 11, 11, 10, 12, 13, 13, 
  12, 14, 15, 15, 14, 16, 17, 17, 16, 18, 19, 19, 18 ]
gap> Set( Factors( Size( t ) ) );
[ 2, 5, 7, 13 ]
gap> cand:= List( poss, l -> BrauerTableOfTypeV4G( l[1], 2t mod 5,
>      ConstructionInfoCharacterTable( l[1] )[3] ) );
[ BrauerTable( "2^2.Sz(8)", 5 ), BrauerTable( "2^2.Sz(8)", 5 ), 
  BrauerTable( "2^2.Sz(8)", 5 ), BrauerTable( "2^2.Sz(8)", 5 ), 
  BrauerTable( "2^2.Sz(8)", 5 ) ]
gap> Length( RepresentativesCharacterTables( cand ) );
2
gap> List( cand, CTblLib.Test.TensorDecomposition );
[ false, true, false, true, true ]
gap> Length( RepresentativesCharacterTables( cand{ [ 2, 4, 5 ] } ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( cand[2],
>        CharacterTable( "2^2.Sz(8)" ) mod 5 ) );
true
gap> cand:= List( poss, l -> BrauerTableOfTypeV4G( l[1], 2t mod 7,
>      ConstructionInfoCharacterTable( l[1] )[3] ) );
[ BrauerTable( "2^2.Sz(8)", 7 ), BrauerTable( "2^2.Sz(8)", 7 ), 
  BrauerTable( "2^2.Sz(8)", 7 ), BrauerTable( "2^2.Sz(8)", 7 ), 
  BrauerTable( "2^2.Sz(8)", 7 ) ]
gap> Length( RepresentativesCharacterTables( cand ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( cand[1],      
>        CharacterTable( "2^2.Sz(8)" ) mod 7 ) );
true
gap> elms:= elms{ [ 2, 4, 5 ] };
[ (9,10,11), (6,7,8)(9,10,11), (6,7,8)(9,11,10) ]
gap> poss:= poss{ [ 2, 4, 5 ] };;                                     
gap> cand:= List( poss, l -> BrauerTableOfTypeV4G( l[1], 2t mod 13,
>      ConstructionInfoCharacterTable( l[1] )[3] ) );
[ BrauerTable( "2^2.Sz(8)", 13 ), BrauerTable( "2^2.Sz(8)", 13 ), 
  BrauerTable( "2^2.Sz(8)", 13 ) ]
gap> Length( RepresentativesCharacterTables( cand ) );
2
gap> List( cand, CTblLib.Test.TensorDecomposition );                      
[ true, true, true ]
gap> mod2:= CharacterTable( "Sz(8)" ) mod 2;
BrauerTable( "Sz(8)", 2 )
gap> AutomorphismsOfTable( mod2 );
Group([ (3,4,5)(6,7,8) ])
gap> OrdersClassRepresentatives( mod2 );
[ 1, 5, 7, 7, 7, 13, 13, 13 ]
gap> Length( RepresentativesCharacterTables( cand{ [ 2, 3 ] } ) );
1
gap> IsRecord( TransformingPermutationsCharacterTables( cand[2],
>        CharacterTable( "2^2.Sz(8)" ) mod 13 ) );
true
gap> listV4G:= [
>      [ "2^2.L3(4)",         "2.L3(4)",     "L3(4)"       ],
>      [ "2^2.L3(4).2_1",     "2.L3(4).2_1", "L3(4).2_1"   ],
>      [ "(2^2x3).L3(4)",     "6.L3(4)",     "3.L3(4)"     ],
>      [ "(2^2x3).L3(4).2_1", "6.L3(4).2_1", "3.L3(4).2_1" ],
>      [ "2^2.O8+(2)",        "2.O8+(2)",    "O8+(2)"      ],
>      [ "2^2.U6(2)",         "2.U6(2)",     "U6(2)"       ],
>      [ "(2^2x3).U6(2)",     "6.U6(2)",     "3.U6(2)"     ],
>      [ "2^2.2E6(2)",        "2.2E6(2)",    "2E6(2)"      ],
>      [ "(2^2x3).2E6(2)",    "6.2E6(2)",    "3.2E6(2)"    ],
> ];;
gap> ConstructOrdinaryV4GTable:= function( tblG, tbl2G, name, lib )
>      local ord3, nam, poss, reps, trans;
> 
>      # Compute the possible actions for the ordinary tables.
>      ord3:= Set( List( Filtered( AutomorphismsOfTable( tblG ),
>                                  x -> Order( x ) = 3 ),
>                        SmallestGeneratorPerm ) );
>      if 1 < Length( ord3 ) then
>        Print( "#I  ", name,
>               ": the action of the automorphism is not unique" );
>      fi;
>      # Compute the possible ordinary tables for the given actions.
>      nam:= Concatenation( "new", name );
>      poss:= Concatenation( List( ord3, pi ->
>             PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi, nam ) ) );
>      # Test the possibilities for permutation equivalence.
>      reps:= RepresentativesCharacterTables( poss );
>      if 1 < Length( reps ) then
>        Print( "#I  ", name, ": ", Length( reps ),
>               " equivalence classes\n" );
>      elif Length( reps ) = 0 then
>        Print( "#E  ", name, ": no solution\n" );
>      else
>        # Compare the computed table with the library table.
>        if not IsCharacterTable( lib ) then
>          Print( "#I  no library table for ", name, "\n" );
>          PrintToLib( name, poss[1].table );
>        else
>          trans:= TransformingPermutationsCharacterTables( reps[1], lib );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      return poss;
>    end;;
gap> ConstructModularV4GTables:= function( tblG, tbl2G, ordposs,
>                                          ordlibtblV4G )
>      local name, modposs, primes, checkordinary, i, p, tmodp, 2tmodp, aut,
>            poss, modlib, trans, reps;
> 
>      if not IsCharacterTable( ordlibtblV4G ) then
>        Print( "#I  no ordinary library table ...\n" );
>        return [];
>      fi;
>      name:= Identifier( ordlibtblV4G );
>      modposs:= [];
>      primes:= Set( Factors( Size( tblG ) ) );
>      ordposs:= ShallowCopy( ordposs );
>      checkordinary:= false;
>      for i in [ 1 .. Length( ordposs ) ] do
>        modposs[i]:= [];
>        for p in primes do
>          tmodp := tblG  mod p;
>          2tmodp:= tbl2G mod p;
>          if IsCharacterTable( tmodp ) and IsCharacterTable( 2tmodp ) then
>            aut:= ConstructionInfoCharacterTable( ordposs[i] )[3];
>            poss:= BrauerTableOfTypeV4G( ordposs[i], 2tmodp, aut );
>            if CTblLib.Test.TensorDecomposition( poss, false ) = false then
>              Print( "#I  excluded cand. ", i, " (out of ",
>                     Length( ordposs ), ") for ", name, " by ", p,
>                     "-mod. table\n" );
>              Unbind( ordposs[i] );
>              Unbind( modposs[i] );
>              checkordinary:= true;
>              break;
>            fi;
>            Add( modposs[i], poss );
>          else
>            Print( "#I  not all input tables for ", name, " mod ", p,
>                   " available\n" );
>            primes:= Difference( primes, [ p ] );
>          fi;
>        od;
>        if IsBound( modposs[i] ) then
>          # Compare the computed Brauer tables with the library tables.
>          for poss in modposs[i] do
>            p:= UnderlyingCharacteristic( poss );
>            modlib:= ordlibtblV4G mod p;
>            if IsCharacterTable( modlib ) then
>              trans:= TransformingPermutationsCharacterTables(
>                          poss, modlib );
>              if not IsRecord( trans ) then
>                Print( "#E  computed table and library table for ",
>                       name, " mod ", p, " differ\n" );
>              fi;
>            else
>              Print( "#I  no library table for ",
>                     name, " mod ", p, "\n" );
>              PrintToLib( name, poss );
>            fi;
>          od;
>        fi;
>      od;
>      if checkordinary then
>        # Test whether the ordinary table is admissible.
>        ordposs:= Compacted( ordposs );
>        modposs:= Compacted( modposs );
>        reps:= RepresentativesCharacterTables( ordposs );
>        if 1 < Length( reps ) then
>          Print( "#I  ", name, ": ", Length( reps ),
>                 " equivalence classes (ord. table)\n" );
>        elif Length( reps ) = 0 then
>          Print( "#E  ", name, ": no solution (ord. table)\n" );
>        else
>          # Compare the computed table with the library table.
>          trans:= TransformingPermutationsCharacterTables( reps[1],
>                      ordlibtblV4G );
>          if not IsRecord( trans ) then
>            Print( "#E  computed table and library table for ", name,
>                   " differ\n" );
>          fi;
>        fi;
>      fi;
>      # Test the uniqueness of the Brauer tables.
>      for poss in TransposedMat( modposs ) do
>        reps:= RepresentativesCharacterTables( poss );
>        if Length( reps ) <> 1 then
>          Print( "#I  ", name, ": ", Length( reps ), " candidates for the ",
>                 UnderlyingCharacteristic( reps[1] ), "-modular table\n" );
>        fi;
>      od;
>      return rec( ordinary:= ordposs, modular:= modposs );
>    end;;
gap> for input in listV4G do
>      tblG  := CharacterTable( input[3] );
>      tbl2G := CharacterTable( input[2] );
>      lib   := CharacterTable( input[1] );
>      poss  := ConstructOrdinaryV4GTable( tblG, tbl2G, input[1], lib );
>      ConstructModularV4GTables( tblG, tbl2G, poss, lib );
>    od;
#I  excluded cand. 1 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 2 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 7 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 10 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 15 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 16 (out of 16) for 2^2.L3(4).2_1 by 7-mod. table
#I  excluded cand. 1 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 2 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 7 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 10 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 15 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  excluded cand. 16 (out of 16) for (2^2x3).L3(4).2_1 by 7-mod. table
#I  not all input tables for 2^2.2E6(2) mod 2 available
#I  not all input tables for 2^2.2E6(2) mod 3 available
#I  not all input tables for 2^2.2E6(2) mod 5 available
#I  not all input tables for 2^2.2E6(2) mod 7 available
#I  not all input tables for (2^2x3).2E6(2) mod 2 available
#I  not all input tables for (2^2x3).2E6(2) mod 3 available
#I  not all input tables for (2^2x3).2E6(2) mod 5 available
#I  not all input tables for (2^2x3).2E6(2) mod 7 available
#I  not all input tables for (2^2x3).2E6(2) mod 11 available
#I  not all input tables for (2^2x3).2E6(2) mod 13 available
#I  not all input tables for (2^2x3).2E6(2) mod 17 available
#I  not all input tables for (2^2x3).2E6(2) mod 19 available
gap> entry:= [ "2^2.O8+(3)", "2.O8+(3)", "O8+(3)" ];;
gap> tblG:= CharacterTable( entry[3] );;
gap> aut:= AutomorphismsOfTable( tblG );;
gap> ord3:= Set( List( Filtered( aut, x -> Order( x ) = 3 ),
>                      SmallestGeneratorPerm ) );;
gap> Length( ord3 );
4
gap> poss:= [];;
gap> tbl2G:= CharacterTable( entry[2] );
CharacterTable( "2.O8+(3)" )
gap> for pi in ord3 do
>   Append( poss,
>           PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi, entry[1] ) );
> od;
gap> Length( poss );
32
gap> poss:= RepresentativesCharacterTables( poss );;
gap> Length( poss );
1
gap> lib:= CharacterTable( entry[1] );;
gap> if TransformingPermutationsCharacterTables( poss[1], lib ) = fail then
>      Print( "#E  differences for ", entry[1], "\n" );
>    fi;
gap> tblG:= CharacterTable( "2.L3(4)" );;
gap> tbls2G:= List( [ "4_1.L3(4)", "4_2.L3(4)", "2^2.L3(4)"],
>                   CharacterTable );;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbls2G, "(2x4).L3(4)" );;
gap> Length( poss );
2
gap> reps:= RepresentativesCharacterTables( poss );
[ CharacterTable( "(2x4).L3(4)" ) ]
gap> lib:= CharacterTable( "(2x4).L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true
gap> tblG:= tbls2G[3];
CharacterTable( "2^2.L3(4)" )
gap> tbl2G:= lib;       
CharacterTable( "(2x4).L3(4)" )
gap> aut:= AutomorphismsOfTable( tblG );;
gap> ord3:= Set( List( Filtered( aut, x -> Order( x ) = 3 ),
>                  SmallestGeneratorPerm ) );
[ (2,3,4)(6,7,8)(10,11,12)(13,15,17)(14,16,18)(20,21,22)(24,25,26)(28,29,
    30)(32,33,34) ]
gap> pi:= ord3[1];;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi, "4^2.L3(4)" );;
gap> Length( poss );
4
gap> reps:= RepresentativesCharacterTables( poss );        
[ CharacterTable( "4^2.L3(4)" ) ]
gap> lib:= CharacterTable( "4^2.L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true
gap> tblG:= CharacterTable( "6.L3(4)" );;
gap> tbls2G:= List( [ "12_1.L3(4)", "12_2.L3(4)", "(2^2x3).L3(4)"],            
>                   CharacterTable );;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbls2G, "(2x12).L3(4)" );;
gap> Length( poss );
2
gap> reps:= RepresentativesCharacterTables( poss );
[ CharacterTable( "(2x12).L3(4)" ) ]
gap> lib:= CharacterTable( "(2x12).L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true
gap> tblG:= CharacterTable( "(2^2x3).L3(4)" ); 
CharacterTable( "(2^2x3).L3(4)" )
gap> tbl2G:= CharacterTable( "(2x12).L3(4)" );
CharacterTable( "(2x12).L3(4)" )
gap> aut:= AutomorphismsOfTable( tblG );;
gap> ord3:= Set( List( Filtered( aut, x -> Order( x ) = 3 ),
>                  SmallestGeneratorPerm ) );
[ (2,7,8)(3,4,10)(6,11,12)(14,19,20)(15,16,22)(18,23,24)(26,27,28)(29,35,
    41)(30,37,43)(31,39,45)(32,36,42)(33,38,44)(34,40,46)(48,53,54)(49,50,
    56)(52,57,58)(60,65,66)(61,62,68)(64,69,70)(72,77,78)(73,74,80)(76,81,
    82)(84,89,90)(85,86,92)(88,93,94) ]
gap> pi:= ord3[1];;
gap> poss:= PossibleCharacterTablesOfTypeV4G( tblG, tbl2G, pi,
>                                             "(4^2x3).L3(4)" );;
gap> Length( poss );
4
gap> reps:= RepresentativesCharacterTables( poss );
[ CharacterTable( "(4^2x3).L3(4)" ) ]
gap> lib:= CharacterTable( "(4^2x3).L3(4)" );;
gap> IsRecord( TransformingPermutationsCharacterTables( reps[1], lib ) );
true
gap> for input in listMGA do
>      ordtblMG  := CharacterTable( input[1] );
>      ordtblG   := CharacterTable( input[2] );
>      ordtblGA  := CharacterTable( input[3] );
>      ordtblMGA := CharacterTable( input[4] );
>      p:= Size( ordtblGA ) / Size( ordtblG );
>      if IsPrimeInt( p ) then
>        modtblG:= ordtblG mod p;
>        if modtblG <> fail then
>          modtblGA := CharacterTableRegular( ordtblGA, p );
>          SetIrr( modtblGA, IBrOfExtensionBySingularAutomorphism( modtblG,
>                                ordtblGA ) );
>          if TransformingPermutationsCharacterTables( modtblGA,
>                 ordtblGA mod p ) = fail then
>            Print( "#E  computed table and library table for ", input[3],
>                   " mod ", p, " differ\n" );
>          fi;
>        fi;
>        modtblMG:= ordtblMG mod p;
>        if modtblMG <> fail then
>          modtblMGA := CharacterTableRegular( ordtblMGA, p );
>          SetIrr( modtblMGA, IBrOfExtensionBySingularAutomorphism( modtblMG,
>                                 ordtblMGA ) );
>          if TransformingPermutationsCharacterTables( modtblMGA,
>                 ordtblMGA mod p ) = fail then
>            Print( "#E  computed table and library table for ", input[4],
>                   " mod ", p, " differ\n" );
>          fi;
>        fi;
>      fi;
>    od;
gap> for input in listGS3 do
>      modtblG:= CharacterTable( input[1] ) mod 2;
>      if modtblG <> fail then
>        ordtblG2 := CharacterTable( input[2] );
>        modtblG2 := CharacterTableRegular( ordtblG2, 2 );
>        SetIrr( modtblG2, IBrOfExtensionBySingularAutomorphism( modtblG,
>                              ordtblG2 ) );
>        if TransformingPermutationsCharacterTables( modtblG2,
>               ordtblG2 mod 2 ) = fail then
>          Print( "#E  computed table and library table for ", input[2],
>                 " mod 2 differ\n" );
>        fi;
>      fi;
>      modtblG:= CharacterTable( input[1] ) mod 3;
>      if modtblG <> fail then
>      ordtblG3 := CharacterTable( input[3] );
>        modtblG3 := CharacterTableRegular( ordtblG3, 3 );
>        SetIrr( modtblG3, IBrOfExtensionBySingularAutomorphism( modtblG,
>                              ordtblG3 ) );
>        if TransformingPermutationsCharacterTables( modtblG3,
>               ordtblG3 mod 3 ) = fail then
>          Print( "#E  computed table and library table for ", input[3],
>                 " mod 3 differ\n" );
>        fi;
>      fi;
>      modtblG3:= CharacterTable( input[3] ) mod 2;
>      if modtblG3 <> fail then
>        ordtblGS3 := CharacterTable( input[4] );
>        modtblGS3 := CharacterTableRegular( ordtblGS3, 2 );
>        SetIrr( modtblGS3, IBrOfExtensionBySingularAutomorphism( modtblG3,
>                               ordtblGS3 ) );
>        if TransformingPermutationsCharacterTables( modtblGS3,
>               ordtblGS3 mod 2 ) = fail then
>          Print( "#E  computed table and library table for ", input[4],
>                 " mod 2 differ\n" );
>        fi;
>      fi;
>    od;
gap> for input in listGV4 do
>      modtblG   := CharacterTable( input[1] ) mod 2;
>      if modtblG <> fail then
>        ordtblsG2 := List( input{ [ 2 .. 4 ] }, CharacterTable );
>        ordtblGV4 := CharacterTable( input[5] );
>        for tblG2 in ordtblsG2 do
>          modtblG2:= CharacterTableRegular( tblG2, 2 );
>          SetIrr( modtblG2, IBrOfExtensionBySingularAutomorphism( modtblG,
>                                tblG2 ) );
>          if TransformingPermutationsCharacterTables( modtblG2,
>                 tblG2 mod 2 ) = fail then
>            Print( "#E  computed table and library table for ",
>                   Identifier( tblG2 ), " mod 2 differ\n" );
>          fi;
>          modtblGV4:= CharacterTableRegular( ordtblGV4, 2 );
>          SetIrr( modtblGV4, IBrOfExtensionBySingularAutomorphism( modtblG2,
>                                ordtblGV4 ) );
>          if TransformingPermutationsCharacterTables( modtblGV4,
>                 ordtblGV4 mod 2 ) = fail then
>            Print( "#E  computed table and library table for ", input[5],
>                   " mod 2 differ\n" );
>          fi;
>        od;
>      fi;
>    od;
gap> tblh1:= CharacterTable( "C3" );;
gap> tblg1:= CharacterTable( "S3" );;
gap> StoreFusion( tblh1, PossibleClassFusions( tblh1, tblg1 )[1], tblg1 );
gap> tblh2:= CharacterTable( "C5" );;
gap> tblg2:= CharacterTable( "D10" );;
gap> StoreFusion( tblh2, PossibleClassFusions( tblh2, tblg2 )[1], tblg2 );
gap> subdir:= CharacterTableOfIndexTwoSubdirectProduct( tblh1, tblg1,
>                 tblh2, tblg2, "D30" );;
gap> IsRecord( TransformingPermutationsCharacterTables( subdir.table,
>                  CharacterTable( "Dihedral", 30 ) ) );
true
gap> tblh1:= CharacterTable( "D10" );;
gap> tblg1:= CharacterTable( "5:4" );;
gap> tblh2:= CharacterTable( "HN" );;
gap> tblg2:= CharacterTable( "HN.2" );;
gap> subdir:= CharacterTableOfIndexTwoSubdirectProduct( tblh1, tblg1,
>                 tblh2, tblg2, "(D10xHN).2" );;
gap> IsRecord( TransformingPermutationsCharacterTables( subdir.table,
>                  CharacterTable( "(D10xHN).2" ) ) );
true
gap> m:= CharacterTable( "M" );;
gap> fus:= PossibleClassFusions( subdir.table, m );;
gap> Length( fus );
16
gap> Length( RepresentativesFusions( subdir.table, fus, m ) );
1
gap> c2:= CharacterTable( "C2" );;
gap> hn:= CharacterTable( "HN" );;
gap> g:= c2 * hn;;
gap> d10:= CharacterTable( "D10" );;
gap> mg:= d10 * hn;;
gap> nsg:= ClassPositionsOfNormalSubgroups( mg );
[ [ 1 ], [ 1, 55 .. 109 ], [ 1, 55 .. 163 ], [ 1 .. 54 ], [ 1 .. 162 ], 
  [ 1 .. 216 ] ]
gap> SizesConjugacyClasses( mg ){ nsg[2] };
[ 1, 2, 2 ]
gap> g:= mg / nsg[2];
CharacterTable( "D10xHN/[ 1, 55, 109 ]" )
gap> help:= c2 * CharacterTable( "HN.2" );
CharacterTable( "C2xHN.2" )
gap> ga:= CharacterTableIsoclinic( help ); 
CharacterTable( "Isoclinic(C2xHN.2)" )
gap> gfusga:= PossibleClassFusions( g, ga ); 
[ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
      20, 21, 22, 23, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 32, 32, 33, 33, 
      34, 35, 36, 37, 37, 38, 39, 40, 40, 41, 42, 42, 43, 43, 44, 44, 79, 80, 
      81, 82, 83, 84, 85, 86, 87, 88, 89, 89, 90, 91, 92, 93, 94, 95, 96, 97, 
      98, 99, 100, 101, 101, 102, 103, 103, 104, 105, 106, 107, 108, 109, 
      110, 110, 111, 111, 112, 113, 114, 115, 115, 116, 117, 118, 118, 119, 
      120, 120, 121, 121, 122, 122 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 
      20, 21, 22, 23, 23, 24, 25, 25, 26, 27, 28, 29, 30, 31, 32, 32, 33, 33, 
      35, 34, 36, 37, 37, 38, 39, 40, 40, 41, 42, 42, 43, 43, 44, 44, 79, 80, 
      81, 82, 83, 84, 85, 86, 87, 88, 89, 89, 90, 91, 92, 93, 94, 95, 96, 97, 
      98, 99, 100, 101, 101, 102, 103, 103, 104, 105, 106, 107, 108, 109, 
      110, 110, 111, 111, 113, 112, 114, 115, 115, 116, 117, 118, 118, 119, 
      120, 120, 121, 121, 122, 122 ] ]
gap> StoreFusion( g, gfusga[1], ga );
gap> acts:= PossibleActionsForTypeMGA( mg, g, ga );;
gap> Length( acts );
1
gap> poss:= PossibleCharacterTablesOfTypeMGA( mg, g, ga, acts[1],       
>               "(D10xHN).2" );;
gap> Length( poss );
1
gap> IsRecord( TransformingPermutationsCharacterTables( poss[1].table,
>                  CharacterTable( "(D10xHN).2" ) ) );
true

gap> STOP_TEST( "ctblcons.tst", 612923095 );

#############################################################################
##
#E

