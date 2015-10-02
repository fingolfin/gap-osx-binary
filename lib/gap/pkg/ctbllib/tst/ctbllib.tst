#############################################################################
##
#W  ctbllib.tst         GAP character table library             Thomas Breuer
##
#Y  Copyright (C)  2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##

gap> LoadPackage( "ctbllib", false );
true
gap> START_TEST( "ctbllib.tst");

#
gap> tbl:= CharacterTable( "A5" );;
gap> Print( CASString( tbl ), "\n" );
'A5'
00/00/00. 00.00.00.
(5,5,0,5,-1,0)
text:
(#origin: ATLAS of finite groups, tests: 1.o.r., pow[2,3,5]#),
order=60,
centralizers:(
60,4,3,5,5
),
reps:(
1,2,3,5,5
),
powermap:2(
1,1,3,5,4
),
powermap:3(
1,2,1,5,4
),
powermap:5(
1,2,3,1,1
),
fusion:'A5.2'(
1,2,3,4,4
),
fusion:'J2'(
1,3,5,9,10
),
characters:
(1,1,1,1,1
,0:0)
(3,-1,0,
<w5,-w1-w4
>
,
<w5,-w2-w3
>

,0:0)
(3,-1,0,
<w5,-w2-w3
>
,
<w5,-w1-w4
>

,0:0)
(4,0,1,-1,-1
,0:0)
(5,1,-1,0,0
,0:0);
/// converted from GAP

# Try `CharacterTableDirectProduct' in all four combinations.
gap> t1:= CharacterTable( "Cyclic", 2 );
CharacterTable( "C2" )
gap> t2:= CharacterTable( "Cyclic", 3 );
CharacterTable( "C3" )
gap> t1 * t1;
CharacterTable( "C2xC2" )
gap> ( t1 mod 2 ) * ( t1 mod 2 );
BrauerTable( "C2xC2", 2 )
gap> ( t1 mod 2 ) * t2;
BrauerTable( "C2xC3", 2 )
gap> t2 * ( t1 mod 2 );
BrauerTable( "C3xC2", 2 )

# Check that all ordinary tables can be loaded without problems,
# are internally consistent, and have power maps and automorphisms stored.
gap> easytest:= function( ordtbl )
>       if not IsInternallyConsistent( ordtbl ) then
>         Print( "#E  not internally consistent: ", ordtbl, "\n" );
>       elif ForAny( Factors( Size( ordtbl ) ),
>                p -> not IsBound( ComputedPowerMaps( ordtbl )[p] ) ) then
>         Print( "#E  some power maps are missing: ", ordtbl, "\n" );
>       elif not HasAutomorphismsOfTable( ordtbl ) then
>         Print( "#E  table automorphisms missing: ", ordtbl, "\n" );
>       fi;
>       return true;
> end;;
gap> AllCharacterTableNames( easytest, false );;

# Check that all Brauer tables can be loaded without problems,
# are internally consistent, and have automorphisms stored.
# (This covers the tables that belong to the library via `MBT' calls
# as well as $p$-modular tables of $p$-solvable ordinary tables
# and tables of groups $G$ for which the Brauer table of $G/O_p(G)$ is
# contained in the library and the corresponding factor fusion is stored
# on the table of $G$.)
gap> brauernames:= function( ordtbl )
>       local primes;
>       primes:= Set( Factors( Size( ordtbl ) ) );
>       return List( primes, p -> Concatenation( Identifier( ordtbl ),
>                                     "mod", String( p ) ) );
> end;;
gap> easytest:= function( modtbl )
>       if not IsInternallyConsistent( modtbl ) then
>         Print( "#E  not internally consistent: ", modtbl, "\n" );
>       elif not HasAutomorphismsOfTable( modtbl ) then
>         Print( "#E  table automorphisms missing: ", modtbl, "\n" );
>       fi;
>       return true;
> end;;
gap> AllCharacterTableNames( OfThose, brauernames, IsCharacterTable, true,
>                            easytest, false );;

##
gap> STOP_TEST( "ctbllib.tst", 200000000000 );

#############################################################################
##
#E
