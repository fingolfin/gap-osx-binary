# This file was created from xpl/probgen.xpl, do not edit!
#########################################################################
##
#W  probgen.tst               GAP applications              Thomas Breuer
##
#Y  Copyright 2006,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,   Germany
##
##  In order to run the tests, one starts GAP from the `tst` subdirectory
##  of the `pkg/ctbllib` directory, and calls `ReadTest( "probgen.tst" );`.
##

gap> START_TEST( "probgen.tst" );

#############################################################################
##
##  The examples use the {\GAP} Character Table Library,
##  the {\GAP} Library of Tables of Marks,
##  and the {\GAP} interface to the {\ATLAS} of Group Representations,
##  so we first load these three packages in the required versions.
##  Also, we force the assertion level to zero;
##  this is the default in interactive {\GAP} sessions
##  but the level is automatically set to $1$ when a file is read with
##  `ReadTest'.
##
gap> CompareVersionNumbers( GAPInfo.Version, "4.5.0" );
true
gap> LoadPackage( "ctbllib", "1.2" );
true
gap> LoadPackage( "tomlib", "1.2" );
true
gap> LoadPackage( "atlasrep", "1.5" );
true
gap> SetAssertionLevel( 0 );
gap> max:= GAPInfo.CommandLineOptions.o;;
gap> IsSubset( max, "m" ) and Int( Filtered( max, IsDigitChar ) ) >= 800;
true
gap> staterandom:= [ State( GlobalRandomSource ),
>                    State( GlobalMersenneTwister ) ];;
gap> ResetGlobalRandomNumberGenerators:= function()
>     Reset( GlobalRandomSource, staterandom[1] );
>     Reset( GlobalMersenneTwister, staterandom[2] );
> end;;
#############################################################################
##
#A  PositionsProperty( <list>, <prop> )
##
##  Let <list> be a dense list and <prop> be a unary function that returns
##  `true' or `false' when applied to the entries of <list>.
##  `PositionsProperty' returns the set of positions in <list> for which
##  `true' is returned.
##
gap> if not IsBound( PositionsProperty ) then
>      PositionsProperty:= function( list, prop )
>        return Filtered( [ 1 .. Length( list ) ], i -> prop( list[i] ) );
>      end;
>    fi;
#############################################################################
##
#F  TripleWithProperty( <threelists>, <prop> )
#F  QuadrupleWithProperty( <fourlists>, <prop> )
##
##  Let <threelists> be a list of three lists $l_1, l_2, l_3$,
##  and <prop> be a unary function that takes a triple $[ x_1, x_2, x_3 ]$
##  with $x_i \in l_i$ as its argument and returns either `true' or `false'.
##  `TripleWithProperty' returns a triple for which `prop' returns `true'
##  if such a triple exists, and `fail' otherwise.
##
##  Analogously, the first argument of `QuadrupleWithProperty' is a list
##  <fourlists> of four lists, and the second argument <prop> takes a
##  quadruple as its argument.
##
gap> BindGlobal( "TripleWithProperty", function( threelists, prop )
>     local i, j, k, test;
> 
>     for i in threelists[1] do
>       for j in threelists[2] do
>         for k in threelists[3] do
>           test:= [ i, j, k ];
>           if prop( test ) then
>               return test;
>           fi;
>         od;
>       od;
>     od;
> 
>     return fail;
> end );

gap> BindGlobal( "QuadrupleWithProperty", function( fourlists, prop )
>     local i, j, k, l, test;
> 
>     for i in fourlists[1] do
>       for j in fourlists[2] do
>         for k in fourlists[3] do
>           for l in fourlists[4] do
>             test:= [ i, j, k, l ];
>             if prop( test ) then
>               return test;
>             fi;
>           od;
>         od;
>       od;
>     od;
> 
>     return fail;
> end );
#############################################################################
##
#F  PrintFormattedArray( <array> )
##
##  Let <array> be a rectangular table.
##  `PrintFormattedArray' prints <array> such that each column is right
##  aligned.
##  The only difference to the {\GAP} library function `PrintArray'
##  is that the latter prints all columns at the same width.
##
gap> BindGlobal( "PrintFormattedArray", function( array )
>      local colwidths, n, row;
>      array:= List( array, row -> List( row, String ) );
>      colwidths:= List( TransposedMat( array ),
>                        col -> Maximum( List( col, Length ) ) );
>      n:= Length( array[1] );
>      for row in List( array, row -> List( [ 1 .. n ],
>                   i -> FormattedString( row[i], colwidths[i] ) ) ) do
>        Print( "  ", JoinStringsWithSeparator( row, " " ), "\n" );
>      od;
> end );
gap> BindGlobal( "NeededVariables", NamesUserGVars() );
gap> BindGlobal( "CleanWorkspace", function()
>       local name, record;
> 
>       for name in Difference( NamesUserGVars(), NeededVariables ) do
>        if not IsReadOnlyGlobal( name ) then
>          UnbindGlobal( name );
>        fi;
>      od;
>      for record in [ LIBTOMKNOWN, LIBTABLE ] do
>        for name in RecNames( record.LOADSTATUS ) do
>          Unbind( record.LOADSTATUS.( name ) );
>          Unbind( record.( name ) );
>        od;
>      od;
> end );
#############################################################################
##
#F  PossiblePermutationCharacters( <sub>, <tbl> )
##
##  For two ordinary character tables <sub> and <tbl>,
##  `PossiblePermutationCharacters' returns the set of all induced class
##  functions of the trivial character of <sub> to <tbl>,
##  w.r.t.~the possible class fusions from <sub> to <tbl>.
##
gap> BindGlobal( "PossiblePermutationCharacters", function( sub, tbl )
>     local fus, triv;
> 
>     fus:= PossibleClassFusions( sub, tbl );
>     if fus = fail then
>       return fail;
>     fi;
>     triv:= [ TrivialCharacter( sub ) ];
> 
>     return Set( List( fus, map -> Induced( sub, tbl, triv, map )[1] ) );
> end );
#############################################################################
##
#A  PrimitivePermutationCharacters( <tbl> )
##
##  For an ordinary character table <tbl> for which either the value of one
##  of the attributes `Maxes' or `UnderlyingGroup' is stored or the table of
##  marks is contained in the {\GAP} library of tables of marks,
##  `PrimitivePermutationCharacters' returns the list of all primitive
##  permutation characters of <tbl>.
##  Otherwise `fail' is returned.
##
gap> DeclareAttribute( "PrimitivePermutationCharacters", IsCharacterTable );
gap> InstallMethod( PrimitivePermutationCharacters,
>     [ IsCharacterTable ],
>     function( tbl )
>     local maxes, tom, G;
> 
>     if HasMaxes( tbl ) then
>       maxes:= List( Maxes( tbl ), CharacterTable );
>       if ForAll( maxes, s -> GetFusionMap( s, tbl ) <> fail ) then
>         return List( maxes, subtbl -> TrivialCharacter( subtbl )^tbl );
>       fi;
>     elif HasFusionToTom( tbl ) then
>       tom:= TableOfMarks( tbl );
>       maxes:= MaximalSubgroupsTom( tom );
>       return PermCharsTom( tbl, tom ){ maxes[1] };
>     elif HasUnderlyingGroup( tbl ) then
>       G:= UnderlyingGroup( tbl );
>       return List( MaximalSubgroupClassReps( G ),
>                    M -> TrivialCharacter( M )^tbl );
>     fi;
> 
>     return fail;
> end );
#############################################################################
##
#F  ApproxP( <primitives>, <spos> )
##
##  Let <primitives> be a list of primitive permutation characters of a group
##  $G$, say, and <spos> the position of the conjugacy class of the element
##  $s \in G$.
##  Assume that the elements in <primitives> have the form $1_M^G$,
##  for suitable maximal subgroups $M$ of $G$,
##  and let $\MM$ be the set of these groups $M$.
##  `ApproxP' returns the class function $\psi$ of $G$ that is defined by
##  $\psi(1) = 0$ and
##  \[
##     \psi(g) = \sum_{M \in \MM}
##                   \frac{1_M^G(s) \cdot 1_M^G(g)}{1_M^G(1)}
##  \]
##  otherwise.
##
##  If <primitives> contains all those primitive permutation characters
##  $1_M^G$ of $G$ (with multiplicity according to the number of conjugacy
##  classes of these maximal subgroups) that do not vanish at $s$,
##  and if all these $M$ are self-normalizing in $G$
##  --this holds for example if $G$ is a finite simple group--
##  then $\psi(g) = \total( g, s )$ holds.
##
##  The latter is an upper bound for the proportion
##  $\prop( g, s )$ of elements in the conjugacy class of $s$ that generate
##  together with $g$ a proper subgroup of $G$.
##
##  Note that if $\prop( g, s )$ is less than $1/k$ for all
##  $g \in G^{\times}$ then $G$ has spread at least $k$.
##
gap> BindGlobal( "ApproxP", function( primitives, spos )
>     local sum;
> 
>     sum:= ShallowCopy( Sum( List( primitives,
>                                   pi -> pi[ spos ] * pi / pi[1] ) ) );
>     sum[1]:= 0;
> 
>     return sum;
> end );
#############################################################################
##
#F  ProbGenInfoSimple( <tbl> )
##
##  Let <tbl> be the ordinary character table of a finite simple group $S$.
##  If the full list of primitive permutation characters of <tbl> cannot be
##  computed with `PrimitivePermutationCharacters' then `fail' is returned.
##  Otherwise `ProbGenInfoSimple' returns a list of length $5$, containing
##  the identifier of <tbl>,
##  the value $\total(S)$,
##  the value $\sprtotal( S )$,
##  a list of {\ATLAS} names of the classes of elements $s$ for which
##  $\total(S) = \total( S, s )$ holds,
##  and the list of the corresponding cardinalities $|\M(S,s)|$.
##
gap> BindGlobal( "ProbGenInfoSimple", function( tbl )
>     local prim, max, min, bound, s;
>     prim:= PrimitivePermutationCharacters( tbl );
>     if prim = fail then
>       return fail;
>     fi;
>     max:= List( [ 1 .. NrConjugacyClasses( tbl ) ],
>                 i -> Maximum( ApproxP( prim, i ) ) );
>     min:= Minimum( max );
>     bound:= Inverse( min );
>     if IsInt( bound ) then
>       bound:= bound - 1;
>     else
>       bound:= Int( bound );
>     fi;
>     s:= PositionsProperty( max, x -> x = min );
>     s:= List( Set( List( s, i -> ClassOrbit( tbl, i ) ) ), i -> i[1] );
>     return [ Identifier( tbl ),
>              min,
>              bound,
>              AtlasClassNames( tbl ){ s },
>              Sum( List( prim, pi -> pi{ s } ) ) ];
> end );
#############################################################################
##
#F  ProbGenInfoAlmostSimple( <tblS>, <tblG>, <sposS> )
##
##  Let <tblS> be the ordinary character table of a finite simple group $S$,
##  <tblG> be the character table of an automorphic extension $G$ of $S$
##  in which $S$ has prime index,
##  and <sposS> a list of class positions in <tblS>.
##
##  If the full list of primitive permutation characters of <tblG> cannot be
##  computed with `PrimitivePermutationCharacters' then `fail' is returned.
##  Otherwise `ProbGenInfoAlmostSimple' returns a list of length five,
##  containing
##  the identifier of <tblG>,
##  the maximum $m$ of $\total^{\prime}( G, s )$,
##  for $s$ in the classes described by <sposS>,
##  a list of {\ATLAS} names (w.r.t. $G$) of the classes of elements $s$
##  for which this maximum is attained,
##  and the list of the corresponding cardinalities $|\M^{\prime}(G,s)|$.
##
gap> BindGlobal( "ProbGenInfoAlmostSimple", function( tblS, tblG, sposS )
>     local p, fus, inv, prim, sposG, outer, approx, l, max, min,
>           s, cards, i, names;
> 
>     p:= Size( tblG ) / Size( tblS );
>     if not IsPrimeInt( p )
>        or Length( ClassPositionsOfNormalSubgroups( tblG ) ) <> 3 then
>       return fail;
>     fi;
>     fus:= GetFusionMap( tblS, tblG );
>     if fus = fail then
>       return fail;
>     fi;
>     inv:= InverseMap( fus );
>     prim:= PrimitivePermutationCharacters( tblG );
>     if prim = fail then
>       return fail;
>     fi;
>     sposG:= Set( fus{ sposS } );
>     outer:= Difference( PositionsProperty(
>                 OrdersClassRepresentatives( tblG ), IsPrimeInt ), fus );
>     approx:= List( sposG, i -> ApproxP( prim, i ){ outer } );
>     if IsEmpty( outer ) then
>       max:= List( approx, x -> 0 );
>     else
>       max:= List( approx, Maximum );
>     fi;
>     min:= Minimum( max);
>     s:= sposG{ PositionsProperty( max, x -> x = min ) };
>     cards:= List( prim, pi -> pi{ s } );
>     for i in [ 1 .. Length( prim ) ] do
>       # Omit the character that is induced from the simple group.
>       if ForAll( prim[i], x -> x = 0 or x = prim[i][1] ) then
>         cards[i]:= 0;
>       fi;
>     od;
>     names:= AtlasClassNames( tblG ){ s };
>     Perform( names, ConvertToStringRep );
> 
>     return [ Identifier( tblG ),
>              min,
>              names,
>              Sum( cards ) ];
> end );
#############################################################################
##
#F  SigmaFromMaxes( <tbl>, <sname>, <maxes>, <numpermchars> )
#F  SigmaFromMaxes( <tbl>, <sname>, <maxes>, <numpermchars>, <choice> )
##
##  Let <tbl> be the ordinary character table of a finite almost simple group
##  $G$ with socle $S$,
##  <sname> be the name of a class in <tbl>,
##  <maxes> be a list of character tables of all those maximal subgroups
##  of $G$ which contain elements $s$ in the class with the name <sname>.
##  Further let <numpermchars> be a list of integers such that the $i$-th
##  entry in <maxes> induces `<numpermchars>[i]' different permutation
##  characters.
##  (So if several classes of maximal subgroups in $G$ induce the same
##  permutation character then the table of this subgroup must occur with
##  this multiplicity in <maxes>, and the corresponding entries in
##  <numpermchars> must be $1$.
##  Conversely, if there are $n$ classes of isomorphic maximal subgroups
##  which induce $n$ different permutation characters then the table must
##  occur only once in <maxes>, and the corresponding multiplicity in
##  <numpermchars> must be $n$.)
##
##  The return value is `fail' if there is an entry `<maxes>[i]' such that
##  `PossiblePermutationCharacters' does not return a list of length
##  `<numpermchars>[i]' when its arguments are `<maxes>[i]' and <tbl>.
##
##  If the string `"outer"' is entered as the optional argument <choice> then
##  $G$ is assumed to be an automorphic extension of $S$,
##  with $[G:S]$ a prime,
##  and $\total^{\prime}(G,s)$ is returned.
##
##  Otherwise `SigmaFromMaxes' returns $\total(G,s)$.
##
gap> BindGlobal( "SigmaFromMaxes", function( arg )
>     local t, sname, maxes, numpermchars, prim, spos, outer;
> 
>     t:= arg[1];
>     sname:= arg[2];
>     maxes:= arg[3];
>     numpermchars:= arg[4];
>     prim:= List( maxes, s -> PossiblePermutationCharacters( s, t ) );
>     spos:= Position( AtlasClassNames( t ), sname );
>     if ForAny( [ 1 .. Length( maxes ) ],
>                i -> Length( prim[i] ) <> numpermchars[i] ) then
>       return fail;
>     elif Length( arg ) = 5 and arg[5] = "outer" then
>       outer:= Difference(
>           PositionsProperty( OrdersClassRepresentatives( t ), IsPrimeInt ),
>           ClassPositionsOfDerivedSubgroup( t ) );
>       return Maximum( ApproxP( Concatenation( prim ), spos ){ outer } );
>     else
>       return Maximum( ApproxP( Concatenation( prim ), spos ) );
>     fi;
> end );
#############################################################################
##
#F  DisplayProbGenMaxesInfo( <tbl>, <snames> )
##
##  For a character table <tbl> with known `Maxes' value and a list <snames>
##  of class names in <tbl>,
##  `DisplayProbGenMaxesInfo' prints a description of the maximal subgroups
##  of <tbl> that contain an element $s$ in the classes with names in the
##  list <snames>.
##  Printed are the `Identifier' values of the tables of the maximal
##  subgroups and the number of conjugate subgroups in this class
##  that contain $s$.
##
gap> BindGlobal( "DisplayProbGenMaxesInfo", function( tbl, snames )
>     local mx, prim, i, spos, nonz, indent, j;
> 
>     if not HasMaxes( tbl ) then
>       Print( Identifier( tbl ), ": fail\n" );
>       return;
>     fi;
> 
>     mx:= List( Maxes( tbl ), CharacterTable );
>     prim:= List( mx, s -> TrivialCharacter( s )^tbl );
>     Assert( 1, SortedList( prim ) =
>                SortedList( PrimitivePermutationCharacters( tbl ) ) );
>     for i in [ 1 .. Length( prim ) ] do
>       # Deal with the case that the subgroup is normal.
>       if ForAll( prim[i], x -> x = 0 or x = prim[i][1] ) then
>         prim[i]:= prim[i] / prim[i][1];
>       fi;
>     od;
> 
>     spos:= List( snames,
>                  nam -> Position( AtlasClassNames( tbl ), nam ) );
>     nonz:= List( spos, x -> PositionsProperty( prim, pi -> pi[x] <> 0 ) );
>     for i in [ 1 .. Length( spos ) ] do
>       Print( Identifier( tbl ), ", ", snames[i], ": " );
>       indent:= ListWithIdenticalEntries(
>           Length( Identifier( tbl ) ) + Length( snames[i] ) + 4, ' ' );
>       if not IsEmpty( nonz[i] ) then
>         Print( Identifier( mx[ nonz[i][1] ] ), "  (",
>                prim[ nonz[i][1] ][ spos[i] ], ")\n" );
>         for j in [ 2 .. Length( nonz[i] ) ] do
>           Print( indent, Identifier( mx[ nonz[i][j] ] ), "  (",
>                prim[ nonz[i][j] ][ spos[i] ], ")\n" );
>         od;
>       else
>         Print( "\n" );
>       fi;
>     od;
> end );
#############################################################################
##
#F  PcConjugacyClassReps( <G> )
##
##  Let <G> be a finite solvable group.
##  `PcConjugacyClassReps' returns a list of representatives of
##  the conjugacy classes of <G>,
##  which are computed using a polycyclic presentation for <G>.
##
gap> BindGlobal( "PcConjugacyClassReps", function( G )
>      local iso;
> 
>      iso:= IsomorphismPcGroup( G );
>      return List( ConjugacyClasses( Image( iso ) ),
>               c -> PreImagesRepresentative( iso, Representative( c ) ) );
> end );
#############################################################################
##
#F  ClassesOfPrimeOrder( <G>, <primes>, <N> )
##
##  Let <G> be a finite group, <primes> be a list of primes,
##  and <N> be a normal subgroup of <G>.
##  `ClassesOfPrimeOrder' returns a list of those conjugacy classes of <G>
##  that are not contained in <N>
##  and whose elements' orders occur in <primes>.
##
##  For each prime $p$ in <primes>, first class representatives of order $p$
##  in a Sylow $p$ subgroup of <G> are computed,
##  then the representatives in <N> are discarded,
##  and then representatives w. r. t. conjugacy in <G> are computed.
##
##  (Note that this approach may be inappropriate if an elementary abelian
##  Sylow $p$ subgroup for a large prime $p$ occurs, and if the conjugacy
##  tests in <G> are expensive.)
##
gap> BindGlobal( "ClassesOfPrimeOrder", function( G, primes, N )
>      local ccl, p, syl, reps;
> 
>      ccl:= [];
>      for p in primes do
>        syl:= SylowSubgroup( G, p );
>        reps:= Filtered( PcConjugacyClassReps( syl ),
>                   r -> Order( r ) = p and not r in N );
>        Append( ccl, DuplicateFreeList( List( reps,
>                                          r -> ConjugacyClass( G, r ) ) ) );
>      od;
> 
>      return ccl;
> end );
#############################################################################
##
#F  IsGeneratorsOfTransPermGroup( <G>, <list> )
##
##  Let <G> be a finite group that acts *transitively* on its moved points,
##  and <list> a list of elements in <G>.
##
##  `IsGeneratorsOfTransPermGroup' returns `true' if the elements in <list>
##  generate <G>, and `false' otherwise.
##  The main point is that the return value `true' requires the group
##  generated by `list' to be transitive, and the check for transitivity
##  is much cheaper than the test whether this group is equal to `G'.
##
gap> BindGlobal( "IsGeneratorsOfTransPermGroup", function( G, list )
>     local S;
> 
>     if not IsTransitive( G ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
>     S:= SubgroupNC( G, list );
> 
>     return IsTransitive( S, MovedPoints( G ) ) and Size( S ) = Size( G );
> end );
#############################################################################
##
#F  RatioOfNongenerationTransPermGroup( <G>, <g>, <s> )
##
##  Let <G> be a finite group that acts *transitively* on its moved points,
##  and <g> and <s> be two elements in <G>.
##
##  `RatioOfNongenerationTransPermGroup' returns the proportion
##  $\prop(g,s)$.
##
gap> BindGlobal( "RatioOfNongenerationTransPermGroup", function( G, g, s )
>     local nongen, pair;
> 
>     if not IsTransitive( G ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
>     nongen:= 0;
>     for pair in DoubleCosetRepsAndSizes( G, Centralizer( G, g ),
>                     Centralizer( G, s ) ) do
>       if not IsGeneratorsOfTransPermGroup( G, [ s, g^pair[1] ] ) then
>         nongen:= nongen + pair[2];
>       fi;
>     od;
> 
>     return nongen / Size( G );
> end );
#############################################################################
##
#F  DiagonalProductOfPermGroups( <groups> )
##
##  Let $G$ be a group, and let <groups> be a list
##  $[ G_1, G_2, \ldots, G_n ]$ of permutation groups such that $G_i$
##  describes the action of $G$ on a set $\Omega_i$, say.
##  Moreover, we require that for $1 \leq i, j \leq n$,
##  mapping the `GeneratorsOfGroup' list of $G_i$ to that of $G_j$
##  defines an isomorphism.
##
##  `DiagonalProductOfPermGroups' takes `groups' as its argument,
##  and returns the action of $G$ on the disjoint union of
##  $\Omega_1, \Omega_2, \ldots \Omega_n$.
##
gap> BindGlobal( "DiagonalProductOfPermGroups", function( groups )
>     local prodgens, deg, i, gens, D, pi;
> 
>     prodgens:= GeneratorsOfGroup( groups[1] );
>     deg:= NrMovedPoints( prodgens );
>     for i in [ 2 .. Length( groups ) ] do
>       gens:= GeneratorsOfGroup( groups[i] );
>       D:= MovedPoints( gens );
>       pi:= MappingPermListList( D, [ deg+1 .. deg+Length( D ) ] );
>       deg:= deg + Length( D );
>       prodgens:= List( [ 1 .. Length( prodgens ) ],
>                        i -> prodgens[i] * gens[i]^pi );
>     od;
> 
>     return Group( prodgens );
> end );
#############################################################################
##
#F  RepresentativesMaximallyCyclicSubgroups( <tbl> )
##
##  For an ordinary character table <tbl>,
##  `RepresentativesMaximallyCyclicSubgroups' returns a list of class
##  positions containing exactly one class of generators for each class of
##  maximally cyclic subgroups.
##
gap> BindGlobal( "RepresentativesMaximallyCyclicSubgroups", function( tbl )
>     local n, result, orders, p, pmap, i, j;
> 
>     # Initialize.
>     n:= NrConjugacyClasses( tbl );
>     result:= BlistList( [ 1 .. n ], [ 1 .. n ] );
> 
>     # Omit powers of smaller order.
>     orders:= OrdersClassRepresentatives( tbl );
>     for p in Set( Factors( Size( tbl ) ) ) do
>       pmap:= PowerMap( tbl, p );
>       for i in [ 1 .. n ] do
>         if orders[ pmap[i] ] < orders[i] then
>           result[ pmap[i] ]:= false;
>         fi;
>       od;
>     od;
> 
>     # Omit Galois conjugates.
>     for i in [ 1 .. n ] do
>       if result[i] then
>         for j in ClassOrbit( tbl, i ) do
>           if i <> j then
>             result[j]:= false;
>           fi;
>         od;
>       fi;
>     od;
> 
>     # Return the result.
>     return ListBlist( [ 1 .. n ], result );
> end );
#############################################################################
##
#F  ClassesPerhapsCorrespondingToTableColumns( <G>, <tbl>, <cols> )
##
##  For a group <G>, its ordinary character table <tbl>, and a list <cols>
##  of class positions in <tbl>,
##  `ClassesPerhapsCorrespondingToTableColumns' returns the sublist
##  of those conjugacy classes of `G' for which the corresponding column
##  in `tbl' can be contained in `cols',
##  according to element order and class length.
##
gap> BindGlobal( "ClassesPerhapsCorrespondingToTableColumns",
>    function( G, tbl, cols )
>     local orders, classes, invariants;
> 
>     orders:= OrdersClassRepresentatives( tbl );
>     classes:= SizesConjugacyClasses( tbl );
>     invariants:= List( cols, i -> [ orders[i], classes[i] ] );
> 
>     return Filtered( ConjugacyClasses( G ),
>         c -> [ Order( Representative( c ) ), Size(c) ] in invariants );
> end );
#############################################################################
##
#F  UpperBoundFixedPointRatios( <G>, <maxesclasses>, <truetest> )
##
##  Let <G> be a finite group, and <maxesclasses> be a list
##  $[ l_1, l_2, ..., l_n ]$ such that each $l_i$ is a list of conjugacy
##  classes of maximal subgroups $M_i$ of <G>, such that all classes of
##  prime element order in $M_i$ are contained in $l_i$,
##  and such that the $M_i$ are all those maximal subgroups of <G>
##  (in particular, \emph{not} only conjugacy class representatives of
##  subgroups) that contain a fixed element $s \in G$.
##
##  `UpperBoundFixedPointRatios' returns a list $[ x, y ]$, where
##  \[
##     x = \max_{1 \not= p \mid |G|} \max_{g \in G \setminus Z(G), |g|=p}
##            \sum_{i=1}^n \sum_{h \in S(i,p,g)} |h^{M_i}| / |g^G|,
##  \]
##  and $S(i,p,g)$ is a set of representatives $h$ of all those classes in
##  $l_i$ that satisfy $|h| = p$ and $|C_G(h)| = |C_G(g)|$,
##  and in the case that $G$ is a permutation group additionally that
##  $h$ and $g$ move the same number of points.
##  Since $S(i,p,g) \supseteq g^G \cap M_i$ holds,
##  $x$ is an upper bound for $\total(G,s)$.
##
##  The second entry is `true' if the first value is in fact equal to
##  $\max_{g \in G \setminus Z(G)} \fpr(g,G/M}$, and `false' otherwise.
##
##  The third argument <truetest> must be `true' or `false',
##  where `true' means that the exact value of $\total(G,s)$ is computed
##  not just an upper bound; this can be much more expensive.
##  (We try to reduce the number of conjugacy tests in this case,
##  the second half of the code is not completely straightforward.)
##
##  If $G$ is an automorphic extension of a simple group $S$,
##  with $[G:S] = p$ a prime, then `UpperBoundFixedPointRatios' can be used
##  to compute $\total^{\prime}(G,s)$,
##  by choosing $M_i$ the maximal subgroups of $G$ containing $s$,
##  except $S$, such that $l_i$ contains only the classes of element order
##  $p$ in $M_i \setminus (M_i \cap S)$.
##
##  Note that in the case $n = 1$, we have $\total(G,s) = \prop(G,s)$,
##  so in this case the second entry `true' means that the first entry is
##  equal to $\max_{g \in G \setminus Z(G)} \fpr(g,G/M_1}$.
##
gap> BindGlobal( "UpperBoundFixedPointRatios",
>    function( G, maxesclasses, truetest )
>     local myIsConjugate, invs, info, c, r, o, inv, pos, sums, max, maxpos,
>           maxlen, reps, split, i, found, j;
> 
>     myIsConjugate:= function( G, x, y )
>       local movx, movy;
> 
>       movx:= MovedPoints( x );
>       movy:= MovedPoints( y );
>       if movx = movy then
>         G:= Stabilizer( G, movx, OnSets );
>       fi;
>       return IsConjugate( G, x, y );
>     end;
> 
>     invs:= [];
>     info:= [];
> 
>     # First distribute the classes according to invariants.
>     for c in Concatenation( maxesclasses ) do
>       r:= Representative( c );
>       o:= Order( r );
>       # Take only prime order representatives.
>       if IsPrimeInt( o ) then
>         inv:= [ o, Size( Centralizer( G, r ) ) ];
>         # Omit classes that are central in `G'.
>         if inv[2] <> Size( G ) then
>           if IsPerm( r ) then
>             Add( inv, NrMovedPoints( r ) );
>           fi;
>           pos:= First( [ 1 .. Length( invs ) ], i -> inv = invs[i] );
>           if pos = fail then
>             # This class is not `G'-conjugate to any of the previous ones.
>             Add( invs, inv );
>             Add( info, [ [ r, Size( c ) * inv[2] ] ] );
>           else
>             # This class may be conjugate to an earlier one.
>             Add( info[ pos ], [ r, Size( c ) * inv[2] ] );
>           fi;
>         fi;
>       fi;
>     od;
> 
>     if info = [] then
>       return [ 0, true ];
>     fi;
> 
>     repeat
>       # Compute the contributions of the classes with the same invariants.
>       sums:= List( info, x -> Sum( List( x, y -> y[2] ) ) );
>       max:= Maximum( sums );
>       maxpos:= Filtered( [ 1 .. Length( info ) ], i -> sums[i] = max );
>       maxlen:= List( maxpos, i -> Length( info[i] ) );
> 
>       # Split the sets with the same invariants if necessary
>       # and if we want to compute the exact value.
>       if truetest and not 1 in maxlen then
>         # Make one conjugacy test.
>         pos:= Position( maxlen, Minimum( maxlen ) );
>         reps:= info[ maxpos[ pos ] ];
>         if myIsConjugate( G, reps[1][1], reps[2][1] ) then
>           # Fuse the two classes.
>           reps[1][2]:= reps[1][2] + reps[2][2];
>           reps[2]:= reps[ Length( reps ) ];
>           Unbind( reps[ Length( reps ) ] );
>         else
>           # Split the list. This may require additional conjugacy tests.
>           Unbind( info[ maxpos[ pos ] ] );
>           split:= [ reps[1], reps[2] ];
>           for i in [ 3 .. Length( reps ) ] do
>             found:= false;
>             for j in split do
>               if myIsConjugate( G, reps[i][1], j[1] ) then
>                 j[2]:= reps[i][2] + j[2];
>                 found:= true;
>                 break;
>               fi;
>             od;
>             if not found then
>               Add( split, reps[i] );
>             fi;
>           od;
> 
>           info:= Compacted( Concatenation( info,
>                                            List( split, x -> [ x ] ) ) );
>         fi;
>       fi;
>     until 1 in maxlen or not truetest;
> 
>     return [ max / Size( G ), 1 in maxlen ];
> end );
#############################################################################
##
#F  OrbitRepresentativesProductOfClasses( <G>, <classreps> )
##
##  For a finite group <G> and a list
##  $<classreps> = [ g_1, g_2, \ldots, g_n ]$ of elements in <G>,
##  `OrbitRepresentativesProductOfClasses' returns a list of representatives
##  of <G>-orbits on the Cartesian product
##  $g_1^{<G>} \times g_2^{<G>} \times \cdots \times g_n^{<G>}$.
##
##  The idea behind this function is to choose $R(<G>, g_1) = \{ ( g_1 ) \}$
##  in the case $n = 1$,
##  and, for $n > 1$,
##  \[
##     R(<G>, g_1, g_2, \ldots, g_n) = \{ (h_1, h_2, \ldots, h_n);
##        (h_1, h_2, \ldots, h_{n-1}) \in R(<G>, g_1, g_2, \ldots, g_{n-1}),
##        k_n = g_n^d, \mbox{\rm\ for\ } d \in D \} ,
##  \]
##  where $D$ is a set of representatives of double cosets
##  $C_{<G>}(g_n) \setminus <G> / \cap_{i=1}^{n-1} C_{<G>}(h_i)$.
##
gap> BindGlobal( "OrbitRepresentativesProductOfClasses",
>    function( G, classreps )
>     local cents, n, orbreps;
> 
>     cents:= List( classreps, x -> Centralizer( G, x ) );
>     n:= Length( classreps );
> 
>     orbreps:= function( reps, intersect, pos )
>       if pos > n then
>         return [ reps ];
>       fi;
>       return Concatenation( List(
>           DoubleCosetRepsAndSizes( G, cents[ pos ], intersect ),
>             r -> orbreps( Concatenation( reps, [ classreps[ pos ]^r[1] ] ),
>                  Intersection( intersect, cents[ pos ]^r[1] ), pos+1 ) ) );
>     end;
> 
>     return orbreps( [ classreps[1] ], cents[1], 2 );
> end );
#############################################################################
##
#F  RandomCheckUniformSpread( <G>, <classreps>, <s>, <N> )
##
##  Let <G> be a finite permutation group that is transitive on its moved
##  points,
##  <classreps> be a list of elements in <G>,
##  <s> be an element in <G>,
##  and <N> be a positive integer.
##
##  `RandomCheckUniformSpread' computes representatives $X$ of <G>-orbits
##  on the Cartesian product of the conjugacy classes of <classreps>;
##  for each of them, up to <N> random conjugates $s^{\prime}$ of <s> are
##  checked whether $s^{\prime}$ generates <G> with each element in the
##  $n$-tuple of elements in $X$.
##  If such an element $s^{\prime}$ is found this way, for all $X$,
##  the function returns `true',
##  otherwise a representative $X$ is returned for which no good conjugate
##  of <s> is found.
##
gap> BindGlobal( "RandomCheckUniformSpread", function( G, classreps, s, try )
>     local elms, found, i, conj;
> 
>     if not IsTransitive( G, MovedPoints( G ) ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
> 
>     # Compute orbit representatives of G on the direct product,
>     # and try to find a good conjugate of s for each representative.
>     for elms in OrbitRepresentativesProductOfClasses( G, classreps ) do
>       found:= false;
>       for i in [ 1 .. try ] do
>         conj:= s^Random( G );
>         if ForAll( elms,
>               x -> IsGeneratorsOfTransPermGroup( G, [ x, conj ] ) ) then
>           found:= true;
>           break;
>         fi;
>       od;
>       if not found then
>         return elms;
>       fi;
>     od;
> 
>     return true;
> end );
#############################################################################
##
#F  CommonGeneratorWithGivenElements( <G>, <classreps>, <tuple> )
##
##  Let <G> be a finite group,
##  and <classreps> and <tuple> be lists of elements in <G>.
##  `CommonGeneratorWithGivenElements' returns an element $g$ in the
##  <G>-conjugacy class of one of the elements in <classreps> with the
##  property that each element in <tuple> together with $g$ generates <G>,
##  if such an element $g$ exists.
##  Otherwise `fail' is returned.
##
gap> BindGlobal( "CommonGeneratorWithGivenElements",
>    function( G, classreps, tuple )
>     local inter, rep, repcen, pair;
> 
>     if not IsTransitive( G, MovedPoints( G ) ) then
>       Error( "<G> must be transitive on its moved points" );
>     fi;
> 
>     inter:= Intersection( List( tuple, x -> Centralizer( G, x ) ) );
>     for rep in classreps do
>       repcen:= Centralizer( G, rep );
>       for pair in DoubleCosetRepsAndSizes( G, repcen, inter ) do
>         if ForAll( tuple,
>            x -> IsGeneratorsOfTransPermGroup( G, [ x, rep^pair[1] ] ) ) then
>           return rep;
>         fi;
>       od;
>     od;
> 
>     return fail;
> end );
gap> sporinfo:= [];;
gap> spornames:= AllCharacterTableNames( IsSporadicSimple, true,
>                                        IsDuplicateTable, false );;
gap> for tbl in List( spornames, CharacterTable ) do
>      info:= ProbGenInfoSimple( tbl );
>      if info <> fail then
>        Add( sporinfo, info );
>      fi;
>    od;
gap> PrintFormattedArray( sporinfo );
   Co1    421/1545600         3671        [ "35A" ]    [ 4 ]
   Co2          1/270          269        [ "23A" ]    [ 1 ]
   Co3        64/6325           98        [ "21A" ]    [ 4 ]
   F3+ 1/269631216855 269631216854        [ "29A" ]    [ 1 ]
  Fi22         43/585           13        [ "16A" ]    [ 7 ]
  Fi23   2651/2416635          911        [ "23A" ]    [ 2 ]
    HN        4/34375         8593        [ "19A" ]    [ 1 ]
    HS        64/1155           18        [ "15A" ]    [ 2 ]
    He          3/595          198        [ "14C" ]    [ 3 ]
    J1           1/77           76        [ "19A" ]    [ 1 ]
    J2           5/28            5        [ "10C" ]    [ 3 ]
    J3          2/153           76        [ "19A" ]    [ 2 ]
    J4   1/1647124116   1647124115        [ "29A" ]    [ 1 ]
    Ly     1/35049375     35049374        [ "37A" ]    [ 1 ]
   M11            1/3            2        [ "11A" ]    [ 1 ]
   M12            1/3            2        [ "10A" ]    [ 3 ]
   M22           1/21           20        [ "11A" ]    [ 1 ]
   M23         1/8064         8063        [ "23A" ]    [ 1 ]
   M24       108/1265           11        [ "21A" ]    [ 2 ]
   McL      317/22275           70 [ "15A", "30A" ] [ 3, 3 ]
    ON       10/30723         3072        [ "31A" ]    [ 2 ]
    Ru         1/2880         2879        [ "29A" ]    [ 1 ]
   Suz       141/5720           40        [ "14A" ]    [ 3 ]
    Th       2/267995       133997 [ "27A", "27B" ] [ 2, 2 ]
gap> for entry in sporinfo do
>      DisplayProbGenMaxesInfo( CharacterTable( entry[1] ), entry[4] );
> od;
Co1, 35A: (A5xJ2):2  (1)
          (A6xU3(3)):2  (2)
          (A7xL2(7)):2  (1)
Co2, 23A: M23  (1)
Co3, 21A: U3(5).3.2  (2)
          L3(4).D12  (1)
          s3xpsl(2,8).3  (1)
F3+, 29A: 29:14  (1)
Fi22, 16A: 2^10:m22  (1)
           (2x2^(1+8)):U4(2):2  (1)
           2F4(2)'  (4)
           2^(5+8):(S3xA6)  (1)
Fi23, 23A: 2..11.m23  (1)
           L2(23)  (1)
HN, 19A: U3(8).3_1  (1)
HS, 15A: A8.2  (1)
         5:4xa5  (1)
He, 14C: 2^1+6.psl(3,2)  (1)
         7^2:2psl(2,7)  (1)
         7^(1+2):(S3x3)  (1)
J1, 19A: 19:6  (1)
J2, 10C: 2^1+4b:a5  (1)
         a5xd10  (1)
         5^2:D12  (1)
J3, 19A: L2(19)  (1)
         J3M3  (1)
J4, 29A: frob  (1)
Ly, 37A: 37:18  (1)
M11, 11A: L2(11)  (1)
M12, 10A: A6.2^2  (1)
          M12M4  (1)
          2xS5  (1)
M22, 11A: L2(11)  (1)
M23, 23A: 23:11  (1)
M24, 21A: L3(4).3.2_2  (1)
          2^6:(psl(3,2)xs3)  (1)
McL, 15A: 3^(1+4):2S5  (1)
          2.A8  (1)
          5^(1+2):3:8  (1)
McL, 30A: 3^(1+4):2S5  (1)
          2.A8  (1)
          5^(1+2):3:8  (1)
ON, 31A: L2(31)  (1)
         ONM8  (1)
Ru, 29A: L2(29)  (1)
Suz, 14A: J2.2  (2)
          (a4xpsl(3,4)):2  (1)
Th, 27A: ThN3B  (1)
         ThM7  (1)
Th, 27B: ThN3B  (1)
         ThM7  (1)
gap> SigmaFromMaxes( CharacterTable( "B" ), "47A",
>        [ CharacterTable( "47:23" ) ], [ 1 ] );
1/174702778623598780219392000000
gap> t:= CharacterTable( "M" );;
gap> s:= CharacterTable( "L2(59)" );;
gap> pi:= PossiblePermutationCharacters( s, t );;
gap> Length( pi );
5
gap> spos:= Position( OrdersClassRepresentatives( t ), 59 );
152
gap> Set( List( pi, x -> Maximum( ApproxP( [ x ], spos ) ) ) );
[ 1/3385007637938037777290625 ]
gap> sporautnames:= AllCharacterTableNames( IsSporadicSimple, true,
>                       IsDuplicateTable, false,
>                       OfThose, AutomorphismGroup );;
gap> sporautnames:= Difference( sporautnames, spornames );
[ "F3+.2", "Fi22.2", "HN.2", "HS.2", "He.2", "J2.2", "J3.2", "M12.2",
  "M22.2", "McL.2", "ON.2", "Suz.2" ]
gap> sporautinfo:= [];;
gap> fails:= [];;
gap> for name in sporautnames do
>      tbl:= CharacterTable( name{ [ 1 .. Position( name, '.' ) - 1 ] } );
>      tblG:= CharacterTable( name );
>      info:= ProbGenInfoSimple( tbl );
>      info:= ProbGenInfoAlmostSimple( tbl, tblG,
>          List( info[4], x -> Position( AtlasClassNames( tbl ), x ) ) );
>      if info = fail then
>        Add( fails, name );
>      else
>        Add( sporautinfo, info );
>      fi;
>    od;
gap> PrintFormattedArray( sporautinfo );
   F3+.2         0         [ "29AB" ]    [ 1 ]
  Fi22.2  251/3861         [ "16AB" ]    [ 7 ]
    HN.2    1/6875         [ "19AB" ]    [ 1 ]
    HS.2    36/275          [ "15A" ]    [ 2 ]
    He.2   37/9520         [ "14CD" ]    [ 3 ]
    J2.2      1/15         [ "10CD" ]    [ 3 ]
    J3.2    1/1080         [ "19AB" ]    [ 1 ]
   M12.2      4/99          [ "10A" ]    [ 1 ]
   M22.2      1/21         [ "11AB" ]    [ 1 ]
   McL.2      1/63 [ "15AB", "30AB" ] [ 3, 3 ]
    ON.2   1/84672         [ "31AB" ]    [ 1 ]
   Suz.2 661/46332          [ "14A" ]    [ 3 ]
gap> for entry in sporautinfo do
>      DisplayProbGenMaxesInfo( CharacterTable( entry[1] ), entry[3] );
> od;
F3+.2, 29AB: F3+  (1)
             frob  (1)
Fi22.2, 16AB: Fi22  (1)
              Fi22.2M4  (1)
              (2x2^(1+8)):(U4(2):2x2)  (1)
              2F4(2)'.2  (4)
              2^(5+8):(S3xS6)  (1)
HN.2, 19AB: HN  (1)
            U3(8).6  (1)
HS.2, 15A: HS  (1)
           S8x2  (1)
           5:4xS5  (1)
He.2, 14CD: He  (1)
            2^(1+6)_+.L3(2).2  (1)
            7^2:2.L2(7).2  (1)
            7^(1+2):(S3x6)  (1)
J2.2, 10CD: J2  (1)
            2^(1+4).S5  (1)
            (A5xD10).2  (1)
            5^2:(4xS3)  (1)
J3.2, 19AB: J3  (1)
            19:18  (1)
M12.2, 10A: M12  (1)
            (2^2xA5):2  (1)
M22.2, 11AB: M22  (1)
             L2(11).2  (1)
McL.2, 15AB: McL  (1)
             3^(1+4):4S5  (1)
             Isoclinic(2.A8.2)  (1)
             5^(1+2):(24:2)  (1)
McL.2, 30AB: McL  (1)
             3^(1+4):4S5  (1)
             Isoclinic(2.A8.2)  (1)
             5^(1+2):(24:2)  (1)
ON.2, 31AB: ON  (1)
            31:30  (1)
Suz.2, 14A: Suz  (1)
            J2.2x2  (2)
            (A4xL3(4):2_3):2  (1)
gap> SigmaFromMaxes( CharacterTable( "Fi24'.2" ), "29AB",
>        [ CharacterTable( "29:28" ) ], [ 1 ], "outer" );
0
gap> 16 in OrdersClassRepresentatives( CharacterTable( "U4(2).2" ) );
false
gap> 16 in OrdersClassRepresentatives( CharacterTable( "G2(3).2" ) );
false
gap> t2:= CharacterTable( "Fi22.2" );;
gap> prim:= List( [ "Fi22.2M4", "(2x2^(1+8)):(U4(2):2x2)", "2F4(2)" ],
>        n -> PossiblePermutationCharacters( CharacterTable( n ), t2 ) );;
gap> t:= CharacterTable( "Fi22" );;
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "2^(5+8):(S3xA6)" ), t );
[ Character( CharacterTable( "Fi22" ), [ 3648645, 56133, 10629, 2245, 567, 
      729, 405, 81, 549, 165, 133, 37, 69, 20, 27, 81, 9, 39, 81, 19, 1, 13, 
      33, 13, 1, 0, 13, 13, 5, 1, 0, 0, 0, 8, 4, 0, 0, 9, 3, 15, 3, 1, 1, 1, 
      1, 3, 3, 1, 0, 0, 0, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 2 ] ) ]
gap> torso:= CompositionMaps( pi[1], InverseMap( GetFusionMap( t, t2 ) ) );
[ 3648645, 56133, 10629, 2245, 567, 729, 405, 81, 549, 165, 133, 37, 69, 20, 
  27, 81, 9, 39, 81, 19, 1, 13, 33, 13, 1, 0, 13, 13, 5, 1, 0, 0, 0, 8, 4, 0, 
  9, 3, 15, 3, 1, 1, 1, 3, 3, 1, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 1, 1, 2 ]
gap> ext:= PermChars( t2, rec( torso:= torso ) );;
gap> Add( prim, ext );
gap> prim:= Concatenation( prim );;  Length( prim );
4
gap> spos:= Position( OrdersClassRepresentatives( t2 ), 16 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1, 4, 1 ]
gap> sigma:= ApproxP( prim, spos );;
gap> Maximum( sigma{ Difference( PositionsProperty(
>                        OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>                        ClassPositionsOfDerivedSubgroup( t2 ) ) } );
251/3861
gap> SigmaFromMaxes( CharacterTable( "HN.2" ), "19AB",
>        [ CharacterTable( "U3(8).6" ) ], [ 1 ], "outer" );
1/6875
gap> SigmaFromMaxes( CharacterTable( "HS.2" ), "15A",
>      [ CharacterTable( "S8x2" ),
>        CharacterTable( "5:4" ) * CharacterTable( "A5.2" ) ], [ 1, 1 ],
>      "outer" );
36/275
gap> t:= CharacterTable( "He" );;
gap> t2:= CharacterTable( "He.2" );;
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( AtlasClassNames( t ), "14C" );;
gap> prim:= Filtered( prim, x -> x[ spos ] <> 0 );;
gap> map:= InverseMap( GetFusionMap( t, t2 ) );;
gap> torso:= List( prim, pi -> CompositionMaps( pi, map ) );
[ [ 187425, 945, 449, 0, 21, 21, 25, 25, 0, 0, 5, 0, 0, 7, 1, 0, 0, 1, 0, 1, 
      0, 0, 0, 0, 0, 0 ], 
  [ 244800, 0, 64, 0, 84, 0, 0, 16, 0, 0, 4, 24, 45, 3, 4, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0 ], 
  [ 652800, 0, 512, 120, 72, 0, 0, 0, 0, 0, 8, 8, 22, 1, 0, 0, 0, 0, 0, 1, 0, 
      0, 1, 1, 2, 0 ] ]
gap> ext:= List( torso, x -> PermChars( t2, rec( torso:= x ) ) );
[ [ Character( CharacterTable( "He.2" ), [ 187425, 945, 449, 0, 21, 21, 25, 
          25, 0, 0, 5, 0, 0, 7, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 315, 15, 
          0, 0, 3, 7, 7, 3, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0 ] ) ], 
  [ Character( CharacterTable( "He.2" ), [ 244800, 0, 64, 0, 84, 0, 0, 16, 0, 
          0, 4, 24, 45, 3, 4, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 360, 0, 0, 0, 
          6, 0, 0, 0, 0, 0, 3, 2, 2, 0, 0, 0, 0, 0, 0 ] ) ], 
  [ Character( CharacterTable( "He.2" ), [ 652800, 0, 512, 120, 72, 0, 0, 0, 
          0, 0, 8, 8, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 2, 0, 480, 0, 120, 
          0, 12, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 1, 1 ] ) ] ]
gap> spos:= Position( AtlasClassNames( t2 ), "14CD" );;
gap> sigma:= ApproxP( Concatenation( ext ), spos );;
gap> Maximum( sigma{ Difference( PositionsProperty(
>                        OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>                        ClassPositionsOfDerivedSubgroup( t2 ) ) } );
37/9520
gap> SigmaFromMaxes( CharacterTable( "ON.2" ), "31AB",
>        [ CharacterTable( "P:Q", [ 31, 30 ] ) ], [ 1 ], "outer" );
1/84672
gap> sporautinfo2:= [];;
gap> for name in List( sporautinfo, x -> x[1] ) do
>      Add( sporautinfo2, ProbGenInfoSimple( CharacterTable( name ) ) );
>    od;
gap> PrintFormattedArray( sporautinfo2 );
   F3+.2    19/5684  299        [ "42E" ]   [ 10 ] 
  Fi22.2 1165/20592   17        [ "24G" ]    [ 3 ] 
    HN.2     1/1425 1424        [ "24B" ]    [ 4 ] 
    HS.2     21/550   26        [ "20C" ]    [ 4 ] 
    He.2    33/4165  126        [ "24A" ]    [ 2 ] 
    J2.2       1/15   14        [ "14A" ]    [ 1 ] 
    J3.2   77/10260  133        [ "34A" ]    [ 1 ] 
   M12.2    113/495    4        [ "12B" ]    [ 3 ] 
   M22.2       8/33    4        [ "10A" ]    [ 4 ] 
   McL.2      1/135  134        [ "22A" ]    [ 1 ] 
    ON.2  61/109368 1792 [ "22A", "38A" ] [ 1, 1 ] 
   Suz.2      1/351  350        [ "28A" ]    [ 1 ]
gap> for entry in sporautinfo2 do
>      DisplayProbGenMaxesInfo( CharacterTable( entry[1] ), entry[4] );
> od;
F3+.2, 42E: 2^12.M24  (2)
            2^2.U6(2):S3x2  (1)
            2^(3+12).(L3(2)xS6)  (2)
            (S3xS3xG2(3)):2  (1)
            S6xL2(8):3  (1)
            7:6xS7  (1)
            7^(1+2)_+:(6xS3).2  (2)
Fi22.2, 24G: Fi22.2M4  (1)
             2^(5+8):(S3xS6)  (1)
             3^5:(2xU4(2).2)  (1)
HN.2, 24B: 2^(1+8)_+.(A5xA5).2^2  (1)
           5^2.5.5^2.4S5  (2)
           HN.2M13  (1)
HS.2, 20C: (2xA6.2^2).2  (1)
           HS.2N5  (2)
           5:4xS5  (1)
He.2, 24A: 2^(1+6)_+.L3(2).2  (1)
           S4xL3(2).2  (1)
J2.2, 14A: L3(2).2x2  (1)
J3.2, 34A: L2(17)x2  (1)
M12.2, 12B: L2(11).2  (1)
            D8.(S4x2)  (1)
            3^(1+2):D8  (1)
M22.2, 10A: M22.2M4  (1)
            A6.2^2  (1)
            L2(11).2  (2)
McL.2, 22A: 2xM11  (1)
ON.2, 22A: J1x2  (1)
ON.2, 38A: J1x2  (1)
Suz.2, 28A: (A4xL3(4):2_3):2  (1)
gap> sporautchoices:= [
>        [ "Fi22",  "Fi22.2",  42 ],
>        [ "Fi24'", "Fi24'.2", 46 ],
>        [ "He",    "He.2",    42 ],
>        [ "HN",    "HN.2",    44 ],
>        [ "HS",    "HS.2",    30 ],
>        [ "ON",    "ON.2",    38 ], ];;
gap> for triple in sporautchoices do
>      tbl:= CharacterTable( triple[1] );
>      tbl2:= CharacterTable( triple[2] );
>      spos2:= PowerMap( tbl2, 2,
>          Position( OrdersClassRepresentatives( tbl2 ), triple[3] ) );
>      spos:= Position( GetFusionMap( tbl, tbl2 ), spos2 );
>      DisplayProbGenMaxesInfo( tbl, AtlasClassNames( tbl ){ [ spos ] } );
>    od;
Fi22, 21A: O8+(2).3.2  (1)
           S3xU4(3).2_2  (1)
           A10.2  (1)
           A10.2  (1)
F3+, 23A: Fi23  (1)
          F3+M7  (1)
He, 21B: 3.A7.2  (1)
         7^(1+2):(S3x3)  (1)
         7:3xpsl(3,2)  (2)
HN, 22A: 2.HS.2  (1)
HS, 15A: A8.2  (1)
         5:4xa5  (1)
ON, 19B: L3(7).2  (1)
         ONM2  (1)
         J1  (1)
gap> 42 in OrdersClassRepresentatives( CharacterTable( "G2(3).2" ) );
false
gap> Size( CharacterTable( "U4(2)" ) ) mod 7 = 0;
false
gap> SigmaFromMaxes( CharacterTable( "Fi22.2" ), "42A",
>     [ CharacterTable( "O8+(2).3.2" ) * CharacterTable( "Cyclic", 2 ),
>       CharacterTable( "S3" ) * CharacterTable( "U4(3).(2^2)_{122}" ) ],
>     [ 1, 1 ] );
163/1170
gap> SigmaFromMaxes( CharacterTable( "Fi24'.2" ), "46A",
>      [ CharacterTable( "Fi23" ) * CharacterTable( "Cyclic", 2 ),
>        CharacterTable( "2^12.M24" ) ],
>      [ 1, 1 ] );
566/5481
gap> SigmaFromMaxes( CharacterTable( "He.2" ), "42A",
>      [ CharacterTable( "3.A7.2" ) * CharacterTable( "Cyclic", 2 ),
>        CharacterTable( "7^(1+2):(S3x6)" ),
>        CharacterTable( "7:6" ) * CharacterTable( "L3(2)" ) ],
>      [ 1, 1, 1 ] );
1/119
gap> SigmaFromMaxes( CharacterTable( "HN.2" ), "44A",
>      [ CharacterTable( "4.HS.2" ) ],
>      [ 1 ] );
997/192375
gap> SigmaFromMaxes( CharacterTable( "HS.2" ), "30A",
>      [ CharacterTable( "S8" ) * CharacterTable( "C2" ),
>        CharacterTable( "5:4" ) * CharacterTable( "S5" ) ],
>      [ 1, 1 ] );
36/275
gap> SigmaFromMaxes( CharacterTable( "ON.2" ), "38A",
>      [ CharacterTable( "J1" ) * CharacterTable( "C2" ) ],
>      [ 1 ] );
61/109368
gap> names:= AllCharacterTableNames( IsSimple, true,
>                                    IsDuplicateTable, false );;
gap> names:= Difference( names, spornames );;
gap> fails:= [];;
gap> lessthan3:= [];;
gap> atleast3:= [];;
gap> for name in names do
>      tbl:= CharacterTable( name );
>      info:= ProbGenInfoSimple( tbl );
>      if info = fail then
>        Add( fails, name );
>      elif info[3] < 3 then
>        Add( lessthan3, info );
>      else
>        Add( atleast3, info );
>      fi;
>    od;
gap> fails;
[ "2E6(2)", "2F4(8)", "A14", "A15", "A16", "A17", "A18", "E6(2)", "F4(2)", 
  "L4(4)", "L4(5)", "L4(9)", "L5(3)", "L6(2)", "L8(2)", "O10+(2)", "O10-(2)",
  "O10-(3)", "O7(5)", "O8-(3)", "O9(3)", "R(27)", "S10(2)", "S12(2)",
  "S4(7)", "S4(8)", "S4(9)", "S6(4)", "S6(5)", "S8(3)", "U4(4)", "U4(5)",
  "U5(3)", "U5(4)", "U7(2)" ]
gap> PrintFormattedArray( lessthan3 );
      A5      1/3 2                [ "5A" ]       [ 1 ]
      A6      2/3 1                [ "5A" ]       [ 2 ]
      A7      2/5 2                [ "7A" ]       [ 2 ]
   O7(3)  199/351 1               [ "14A" ]       [ 3 ]
  O8+(2)  334/315 0 [ "15A", "15B", "15C" ] [ 7, 7, 7 ]
  O8+(3) 863/1820 2 [ "20A", "20B", "20C" ] [ 8, 8, 8 ]
   S6(2)      4/7 1                [ "9A" ]       [ 4 ]
   S8(2)     8/15 1               [ "17A" ]       [ 3 ]
   U4(2)    21/40 1               [ "12A" ]       [ 2 ]
   U4(3)   53/135 2                [ "7A" ]       [ 7 ]
gap> PrintFormattedArray( Filtered( atleast3, l -> l[1] <> "L7(2)" ) );
  2F4(2)' 118/1755   14                           [ "16A" ]             [ 2 ]
   3D4(2)   1/5292 5291                           [ "13A" ]             [ 1 ]
      A10     3/10    3                           [ "21A" ]             [ 1 ]
      A11    2/105   52                           [ "11A" ]             [ 2 ]
      A12      2/9    4                           [ "35A" ]             [ 1 ]
      A13   4/1155  288                           [ "13A" ]             [ 5 ]
       A8     3/14    4                           [ "15A" ]             [ 1 ]
       A9     9/35    3                      [ "9A", "9B" ]          [ 4, 4 ]
    G2(3)      1/7    6                           [ "13A" ]             [ 3 ]
    G2(4)     1/21   20                           [ "13A" ]             [ 2 ]
    G2(5)     1/31   30                     [ "7A", "21A" ]         [ 10, 1 ]
  L2(101)    1/101  100                    [ "51A", "17A" ]          [ 1, 1 ]
  L2(103)  53/5253   99             [ "52A", "26A", "13A" ]       [ 1, 1, 1 ]
  L2(107)  55/5671  103 [ "54A", "27A", "18A", "9A", "6A" ] [ 1, 1, 1, 1, 1 ]
  L2(109)    1/109  108                    [ "55A", "11A" ]          [ 1, 1 ]
   L2(11)     7/55    7                            [ "6A" ]             [ 1 ]
  L2(113)    1/113  112                    [ "57A", "19A" ]          [ 1, 1 ]
  L2(121)    1/121  120                           [ "61A" ]             [ 1 ]
  L2(125)    1/125  124        [ "63A", "21A", "9A", "7A" ]    [ 1, 1, 1, 1 ]
   L2(13)     1/13   12                            [ "7A" ]             [ 1 ]
   L2(16)     1/15   14                           [ "17A" ]             [ 1 ]
   L2(17)     1/17   16                            [ "9A" ]             [ 1 ]
   L2(19)   11/171   15                           [ "10A" ]             [ 1 ]
   L2(23)   13/253   19                     [ "6A", "12A" ]          [ 1, 1 ]
   L2(25)     1/25   24                           [ "13A" ]             [ 1 ]
   L2(27)    5/117   23                     [ "7A", "14A" ]          [ 1, 1 ]
   L2(29)     1/29   28                           [ "15A" ]             [ 1 ]
   L2(31)   17/465   27                     [ "8A", "16A" ]          [ 1, 1 ]
   L2(32)     1/31   30              [ "3A", "11A", "33A" ]       [ 1, 1, 1 ]
   L2(37)     1/37   36                           [ "19A" ]             [ 1 ]
   L2(41)     1/41   40                     [ "21A", "7A" ]          [ 1, 1 ]
   L2(43)   23/903   39                    [ "22A", "11A" ]          [ 1, 1 ]
   L2(47)  25/1081   43        [ "24A", "12A", "8A", "6A" ]    [ 1, 1, 1, 1 ]
   L2(49)     1/49   48                           [ "25A" ]             [ 1 ]
   L2(53)     1/53   52                     [ "27A", "9A" ]          [ 1, 1 ]
   L2(59)  31/1711   55       [ "30A", "15A", "10A", "6A" ]    [ 1, 1, 1, 1 ]
   L2(61)     1/61   60                           [ "31A" ]             [ 1 ]
   L2(64)     1/63   62                    [ "65A", "13A" ]          [ 1, 1 ]
   L2(67)  35/2211   63                    [ "34A", "17A" ]          [ 1, 1 ]
   L2(71)  37/2485   67 [ "36A", "18A", "12A", "9A", "6A" ] [ 1, 1, 1, 1, 1 ]
   L2(73)     1/73   72                           [ "37A" ]             [ 1 ]
   L2(79)  41/3081   75       [ "40A", "20A", "10A", "8A" ]    [ 1, 1, 1, 1 ]
    L2(8)      1/7    6                      [ "3A", "9A" ]          [ 1, 1 ]
   L2(81)     1/81   80                           [ "41A" ]             [ 1 ]
   L2(83)  43/3403   79 [ "42A", "21A", "14A", "7A", "6A" ] [ 1, 1, 1, 1, 1 ]
   L2(89)     1/89   88              [ "45A", "15A", "9A" ]       [ 1, 1, 1 ]
   L2(97)     1/97   96                     [ "49A", "7A" ]          [ 1, 1 ]
   L3(11)   1/6655 6654                   [ "19A", "133A" ]          [ 1, 1 ]
    L3(2)      1/4    3                            [ "7A" ]             [ 1 ]
    L3(3)     1/24   23                           [ "13A" ]             [ 1 ]
    L3(4)      1/5    4                            [ "7A" ]             [ 3 ]
    L3(5)    1/250  249                           [ "31A" ]             [ 1 ]
    L3(7)   1/1372 1371                           [ "19A" ]             [ 1 ]
    L3(8)   1/1792 1791                           [ "73A" ]             [ 1 ]
    L3(9)   1/2880 2879                           [ "91A" ]             [ 1 ]
    L4(3)  53/1053   19                           [ "20A" ]             [ 1 ]
    L5(2)   1/5376 5375                           [ "31A" ]             [ 1 ]
   O8-(2)     1/63   62                           [ "17A" ]             [ 1 ]
    S4(4)     4/15    3                           [ "17A" ]             [ 2 ]
    S4(5)      1/5    4                           [ "13A" ]             [ 1 ]
    S6(3)    1/117  116                           [ "14A" ]             [ 2 ]
   Sz(32)   1/1271 1270                     [ "5A", "25A" ]          [ 1, 1 ]
    Sz(8)     1/91   90                            [ "5A" ]             [ 1 ]
   U3(11)   1/6655 6654                           [ "37A" ]             [ 1 ]
    U3(3)    16/63    3                     [ "6A", "12A" ]          [ 2, 2 ]
    U3(4)    1/160  159                           [ "13A" ]             [ 1 ]
    U3(5)   46/525   11                           [ "10A" ]             [ 2 ]
    U3(7)   1/1372 1371                           [ "43A" ]             [ 1 ]
    U3(8)   1/1792 1791                           [ "19A" ]             [ 1 ]
    U3(9)   1/3600 3599                           [ "73A" ]             [ 1 ]
    U5(2)     1/54   53                           [ "11A" ]             [ 1 ]
    U6(2)     5/21    4                           [ "11A" ]             [ 4 ]
gap> First( atleast3, l -> l[1] = "L7(2)" );
[ "L7(2)", 1/4388290560, 4388290559, [ "127A" ], [ 1 ] ]
gap> list:= [
>   [ "A5", "A5.2" ],
>   [ "A6", "A6.2_1" ],
>   [ "A6", "A6.2_2" ],
>   [ "A6", "A6.2_3" ],
>   [ "A7", "A7.2" ],
>   [ "A8", "A8.2" ],
>   [ "A9", "A9.2" ],
>   [ "A11", "A11.2" ],
>   [ "L3(2)", "L3(2).2" ],
>   [ "L3(3)", "L3(3).2" ],
>   [ "L3(4)", "L3(4).2_1" ],
>   [ "L3(4)", "L3(4).2_2" ],
>   [ "L3(4)", "L3(4).2_3" ],
>   [ "L3(4)", "L3(4).3" ],
>   [ "S4(4)", "S4(4).2" ],
>   [ "U3(3)", "U3(3).2" ],
>   [ "U3(5)", "U3(5).2" ],
>   [ "U3(5)", "U3(5).3" ],
>   [ "U4(2)", "U4(2).2" ],
>   [ "U4(3)", "U4(3).2_1" ],
>   [ "U4(3)", "U4(3).2_3" ],
> ];;
gap> autinfo:= [];;
gap> fails:= [];;
gap> for pair in list do
>      tbl:= CharacterTable( pair[1] );
>      tblG:= CharacterTable( pair[2] );
>      info:= ProbGenInfoSimple( tbl );
>      spos:= List( info[4], x -> Position( AtlasClassNames( tbl ), x ) );
>      Add( autinfo, ProbGenInfoAlmostSimple( tbl, tblG, spos ) );
>    od;
gap> PrintFormattedArray( autinfo );
       A5.2      0        [ "5AB" ]    [ 1 ]
     A6.2_1    2/3        [ "5AB" ]    [ 2 ]
     A6.2_2    1/6         [ "5A" ]    [ 1 ]
     A6.2_3      0        [ "5AB" ]    [ 1 ]
       A7.2   1/15        [ "7AB" ]    [ 1 ]
       A8.2  13/28       [ "15AB" ]    [ 1 ]
       A9.2    1/4        [ "9AB" ]    [ 1 ]
      A11.2  1/945       [ "11AB" ]    [ 1 ]
    L3(2).2    1/4        [ "7AB" ]    [ 1 ]
    L3(3).2   1/18       [ "13AB" ]    [ 1 ]
  L3(4).2_1   3/10        [ "7AB" ]    [ 3 ]
  L3(4).2_2  11/60         [ "7A" ]    [ 1 ]
  L3(4).2_3   1/12        [ "7AB" ]    [ 1 ]
    L3(4).3   1/64         [ "7A" ]    [ 1 ]
    S4(4).2      0       [ "17AB" ]    [ 2 ]
    U3(3).2    2/7 [ "6A", "12AB" ] [ 2, 2 ]
    U3(5).2   2/21        [ "10A" ]    [ 2 ]
    U3(5).3 46/525        [ "10A" ]    [ 2 ]
    U4(2).2  16/45       [ "12AB" ]    [ 2 ]
  U4(3).2_1 76/135         [ "7A" ]    [ 3 ]
  U4(3).2_3 31/162        [ "7AB" ]    [ 3 ]
gap> t:= CharacterTable( "L4(3)" );;
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( AtlasClassNames( t ), "20A" );;
gap> prim:= Filtered( prim, x -> x[ spos ] <> 0 );
[ Character( CharacterTable( "L4(3)" ), [ 2106, 106, 42, 0, 27, 27, 0, 46, 6, 
      6, 1, 7, 7, 0, 3, 3, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1 ] ) ]
gap> for name in [ "L4(3).2_1", "L4(3).2_2", "L4(3).2_3" ] do
>      t2:= CharacterTable( name );
>      map:= InverseMap( GetFusionMap( t, t2 ) );
>      torso:= List( prim, pi -> CompositionMaps( pi, map ) );
>      ext:= Concatenation( List( torso,
>                              x -> PermChars( t2, rec( torso:= x ) ) ) );
>      sigma:= ApproxP( ext, Position( OrdersClassRepresentatives( t2 ), 20 ) );
>      max:= Maximum( sigma{ Difference( PositionsProperty(
>                           OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>                           ClassPositionsOfDerivedSubgroup( t2 ) ) } );
>      Print( name, ":\n", ext, "\n", max, "\n" );
> od;
L4(3).2_1:
[ Character( CharacterTable( "L4(3).2_1" ), [ 2106, 106, 42, 0, 27, 0, 46, 6, 
      6, 1, 7, 0, 3, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 4, 0, 0, 6, 6, 6, 6, 
      2, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 ] ) ]
0
L4(3).2_2:
[ Character( CharacterTable( "L4(3).2_2" ), 
    [ 2106, 106, 42, 0, 27, 27, 0, 46, 6, 6, 1, 7, 7, 0, 3, 3, 0, 0, 0, 1, 1, 
      1, 0, 0, 0, 1, 306, 306, 42, 6, 10, 10, 0, 0, 15, 15, 3, 3, 3, 3, 0, 0, 
      1, 1, 0, 1, 1, 0, 0 ] ) ]
17/117
L4(3).2_3:
[ Character( CharacterTable( "L4(3).2_3" ), [ 2106, 106, 42, 0, 27, 0, 46, 6, 
      6, 1, 7, 0, 3, 0, 0, 1, 1, 0, 0, 0, 1, 36, 0, 0, 6, 6, 2, 2, 2, 1, 1, 
      0, 0, 0 ] ) ]
2/117
gap> SigmaFromMaxes( CharacterTable( "O8-(2).2" ), "17AB",
>        [ CharacterTable( "L2(16).4" ) ], [ 1 ], "outer" );
0
gap> t:= CharacterTable( "S6(3)" );;
gap> t2:= CharacterTable( "S6(3).2" );;
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( AtlasClassNames( t ), "14A" );;
gap> prim:= Filtered( prim, x -> x[ spos ] <> 0 );;
gap> map:= InverseMap( GetFusionMap( t, t2 ) );;
gap> torso:= List( prim, pi -> CompositionMaps( pi, map ) );;
gap> ext:= List( torso, pi -> PermChars( t2, rec( torso:= pi ) ) );
[ [ Character( CharacterTable( "S6(3).2" ), [ 155520, 0, 288, 0, 0, 0, 216, 
          54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 1, 0, 0, 0, 0, 0, 6, 
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 144, 
          288, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1, 1, 1, 
          1, 0, 0 ] ) ],
  [ Character( CharacterTable( "S6(3).2" ), [ 189540, 1620, 568, 0, 486, 0, 
          0, 27, 540, 84, 24, 0, 0, 0, 0, 0, 54, 0, 0, 10, 0, 7, 1, 6, 6, 0, 
          0, 0, 0, 0, 0, 18, 0, 0, 0, 6, 12, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 
          0, 0, 234, 64, 30, 8, 0, 3, 90, 6, 0, 4, 10, 6, 0, 2, 1, 0, 0, 0, 
          0, 0, 0, 0, 1, 1, 0, 0 ] ) ] ]
gap> spos:= Position( AtlasClassNames( t2 ), "14A" );;
gap> sigma:= ApproxP( Concatenation( ext ), spos );;
gap> Maximum( sigma{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
7/3240
gap> SigmaFromMaxes( CharacterTable( "U5(2).2" ), "11AB",
>        [ CharacterTable( "L2(11).2" ) ], [ 1 ], "outer" );
1/288
gap> CleanWorkspace();
gap> SigmaFromMaxes( CharacterTable( "O8-(3)" ), "41A",
>    [ CharacterTable( "L2(81).2_1" ) ], [ 1 ] );
1/567
gap> ForAny( [ "S8(2)", "O8+(2)", "L5(2)", "O8-(2)", "A8" ],
>            x -> 45 in OrdersClassRepresentatives( CharacterTable( x ) ) );
false
gap> t:= CharacterTable( "O10+(2)" );;
gap> t2:= CharacterTable( "O10+(2).2" );;
gap> s2:= CharacterTable( "A5.2" ) * CharacterTable( "U4(2).2" );
CharacterTable( "A5.2xU4(2).2" )
gap> pi:= PossiblePermutationCharacters( s2, t2 );;
gap> spos:= Position( OrdersClassRepresentatives( t2 ), 45 );;
gap> approx:= ApproxP( pi, spos );;
gap> Maximum( approx{ ClassPositionsOfDerivedSubgroup( t2 ) } );
43/4216
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
23/248
gap> SigmaFromMaxes( t2, "45AB", [ s2 ], [ 1 ], "outer" );
23/248
gap> SigmaFromMaxes( CharacterTable( "O10-(2)" ), "33A",
>    [ CharacterTable( "Cyclic", 3 ) * CharacterTable( "U5(2)" ) ], [ 1 ] );
1/119
gap> tblG:= CharacterTable( "U5(2)" );;
gap> tblMG:= CharacterTable( "Cyclic", 3 ) * tblG;;
gap> tblGA:= CharacterTable( "U5(2).2" );;
gap> acts:= PossibleActionsForTypeMGA( tblMG, tblG, tblGA );;
gap> poss:= Concatenation( List( acts, pi ->
>            PossibleCharacterTablesOfTypeMGA( tblMG, tblG, tblGA, pi,
>                "(3xU5(2)).2" ) ) );
[ rec( MGfusMGA := [ 1, 2, 3, 4, 4, 5, 5, 6, 7, 8, 9, 10, 11, 12, 12, 13, 13,
          14, 14, 15, 15, 16, 17, 17, 18, 18, 19, 20, 21, 21, 22, 22, 23, 23,
          24, 24, 25, 25, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 32, 33, 34,
          35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
          52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68,
          69, 70, 71, 72, 73, 74, 75, 76, 77, 31, 32, 33, 35, 34, 37, 36, 38,
          39, 40, 41, 42, 43, 45, 44, 47, 46, 49, 48, 51, 50, 52, 54, 53, 56,
          55, 57, 58, 60, 59, 62, 61, 64, 63, 66, 65, 68, 67, 69, 71, 70, 73,
          72, 75, 74, 77, 76 ], table := CharacterTable( "(3xU5(2)).2" ) ) ]
gap> SigmaFromMaxes( CharacterTable( "O10-(2).2" ), "33AB",
>        [ poss[1].table ], [ 1 ], "outer" );
1/595
gap> CharacterTable( "O12+(2)" );
fail
gap> t:= CharacterTable( "O12+(2).2" );;
gap> h1:= CharacterTable( "L4(4).2^2" );;
gap> psi:= PossiblePermutationCharacters( h1, t );;
gap> Length( psi );
1
gap> ForAny( psi[1], IsOddInt );
true
gap> SizesCentralizers( t ){ PositionsProperty(
>        OrdersClassRepresentatives( t ), x -> x = 17 ) } / 25;
[ 408/5, 408/5 ]
gap> h2:= CharacterTable( "S5" ) * CharacterTable( "O8-(2).2" );;
gap> phi:= PossiblePermutationCharacters( h2, t );;
gap> Length( phi );
1
gap> prim:= Concatenation( psi, phi );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 85 );
213
gap> List( prim, x -> x[ spos ] );
[ 2, 1 ]
gap> approx:= ApproxP( prim, spos );;
gap> Maximum( approx{ ClassPositionsOfDerivedSubgroup( t ) } );
7675/1031184
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t ) ) } );
73/1008
gap> t:= CharacterTable( "O12-(2)" );
fail
gap> t:= CharacterTable( "O12-(2).2" );;
gap> s1:= CharacterTable( "U4(4).4" );;
gap> pi1:= PossiblePermutationCharacters( s1, t );;
gap> s2:= CharacterTable( "L2(64).6" );;
gap> pi2:= PossiblePermutationCharacters( s2, t );;
gap> prim:= Concatenation( pi1, pi2 );;  Length( prim );
2
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1 ]
gap> approx:= ApproxP( prim, spos );;
gap> Maximum( approx{ ClassPositionsOfDerivedSubgroup( t ) } );
1/1023
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t ) ) } );
1/347820
gap> t:= CharacterTable( "S6(4)" );;
gap> degree:= Size( t ) / ( 2 * Size( CharacterTable( "U4(4)" ) ) );;
gap> pi1:= PermChars( t, rec( torso:= [ degree ] ) );;
gap> Length( pi1 );
1
gap> CharacterTable( "L2(64).3" );  CharacterTable( "U4(4).2" );
fail
fail
gap> s:= CharacterTable( "L2(64)" );;
gap> subpi:= PossiblePermutationCharacters( s, t );;
gap> Length( subpi );
1
gap> scp:= MatScalarProducts( t, Irr( t ), subpi );;
gap> nonzero:= PositionsProperty( scp[1], x -> x <> 0 );
[ 1, 11, 13, 14, 17, 18, 32, 33, 56, 58, 59, 73, 74, 77, 78, 79, 80, 93, 95, 
  96, 103, 116, 117, 119, 120 ]
gap> const:= RationalizedMat( Irr( t ){ nonzero } );;
gap> degree:= Size( t ) / ( 3 * Size( s ) );
5222400
gap> pi2:= PermChars( t, rec( torso:= [ degree ], chars:= const ) );;
gap> Length( pi2 );
1
gap> prim:= Concatenation( pi1, pi2 );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1 ]
gap> Maximum( ApproxP( prim, spos ) );
16/63
gap> t2:= CharacterTable( "S6(4).2" );;
gap> tfust2:= GetFusionMap( t, t2 );;
gap> cand:= List( prim, x -> CompositionMaps( x, InverseMap( tfust2 ) ) );;
gap> ext:= List( cand, pi -> PermChars( t2, rec( torso:= pi ) ) );
[ [ Character( CharacterTable( "S6(4).2" ), [ 2016, 512, 96, 128, 32, 120, 0, 
          6, 16, 40, 24, 0, 8, 136, 1, 6, 6, 1, 32, 0, 8, 6, 2, 0, 2, 0, 0, 
          4, 0, 16, 32, 1, 8, 2, 6, 2, 1, 2, 4, 0, 0, 1, 6, 0, 1, 10, 0, 1, 
          1, 0, 10, 10, 4, 0, 1, 0, 2, 0, 2, 1, 2, 2, 1, 1, 0, 0, 0, 1, 1, 1, 
          1, 0, 0, 0, 0, 0, 32, 0, 0, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 0, 
          0, 0, 2, 2, 0, 2, 2, 0, 2, 2, 2, 0, 0 ] ) ], 
  [ Character( CharacterTable( "S6(4).2" ), [ 5222400, 0, 0, 0, 1280, 0, 960, 
          120, 0, 0, 0, 0, 0, 0, 1600, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 1, 0, 0, 
          15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 10, 0, 
          0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 
          0, 0, 0, 960, 0, 0, 0, 16, 0, 24, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0, 4, 1, 0, 0, 3, 0, 0, 0, 0, 0 ] ) ] ]
gap> spos2:= Position( OrdersClassRepresentatives( t2 ), 65 );;
gap> sigma:= ApproxP( Concatenation( ext ), spos2 );;
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
0
gap> SigmaFromMaxes( CharacterTable( "S6(4)" ), "85A",
>    [ CharacterTable( "L4(4).2_2" ),
>      CharacterTable( "A5" ) * CharacterTable( "S4(4)" ) ], [ 1, 1 ] );
142/455
gap> 16/63 < 142/455;
true
gap> t:= CharacterTable( "S6(5)" );;
gap> s1:= CharacterTable( "2.A5" );;
gap> s2:= CharacterTable( "2.S4(5)" );;
gap> dp:= s1 * s2;
CharacterTable( "2.A5x2.S4(5)" )
gap> c:= Difference( ClassPositionsOfCentre( dp ), Union(
>                        GetFusionMap( s1, dp ), GetFusionMap( s2, dp ) ) );
[ 62 ]
gap> s:= dp / c;
CharacterTable( "2.A5x2.S4(5)/[ 1, 62 ]" )
gap> SigmaFromMaxes( t, "78A", [ s ], [ 1 ] );
9/217
gap> t:= CharacterTable( "S8(3)" );;
gap> pi:= List( [ "S4(9).2_1", "S4(9).2_2", "S4(9).2_3" ],
>               name -> PossiblePermutationCharacters(
>                           CharacterTable( name ), t ) );;
gap> List( pi, Length );
[ 1, 0, 0 ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 41 );;
gap> pi[1][1][ spos ];
1
gap> Maximum( ApproxP( pi[1], spos ) );
1/546
gap> g:= SU(4,4);;
gap> orbs:= Orbits( g, NormedRowVectors( GF(16)^4 ), OnLines );;
gap> orblen:= List( orbs, Length );
[ 1105, 3264 ]
gap> List( orblen, x -> x mod 13 );
[ 0, 1 ]
gap> t:= CharacterTable( "U4(4)" );;
gap> pi:= PermChars( t, rec( torso:= [ orblen[2] ] ) );;
gap> Length( pi );
1
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> Maximum( ApproxP( pi, spos ) );
209/3264
gap> t:= CharacterTable( "U6(2)" );;
gap> s1:= CharacterTable( "U5(2)" );;
gap> pi1:= PossiblePermutationCharacters( s1, t );;
gap> Length( pi1 );
1
gap> s2:= CharacterTable( "M22" );;
gap> pi2:= PossiblePermutationCharacters( s2, t );
[ Character( CharacterTable( "U6(2)" ), [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 
      0, 0, 48, 0, 16, 6, 0, 0, 0, 0, 0, 0, 6, 0, 2, 0, 0, 0, 4, 0, 0, 0, 0, 
      1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "U6(2)" ), [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 
      0, 48, 0, 0, 16, 6, 0, 0, 0, 0, 0, 0, 6, 0, 2, 0, 0, 4, 0, 0, 0, 0, 0, 
      1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "U6(2)" ), [ 20736, 0, 384, 0, 0, 0, 54, 0, 0, 
      48, 0, 0, 0, 16, 6, 0, 0, 0, 0, 0, 0, 6, 0, 2, 0, 4, 0, 0, 0, 0, 0, 0, 
      1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> imgs:= Set( List( pi2, x -> Position( x, 48 ) ) );
[ 10, 11, 12 ]
gap> AtlasClassNames( t ){ imgs };
[ "4C", "4D", "4E" ]
gap> GetFusionMap( t, CharacterTable( "U6(2).3" ) ){ imgs };
[ 10, 10, 10 ]
gap> prim:= Concatenation( pi1, pi2 );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 11 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1, 1, 1 ]
gap> Maximum( ApproxP( prim, spos ) );
5/21
gap> PossibleClassFusions(
>        CharacterTable( "Cyclic", 3 ) * CharacterTable( "M22" ),
>        CharacterTable( "3.U6(2)" ) );
[  ]
gap> SigmaFromMaxes( CharacterTable( "U6(2).2" ), "11AB",
>        [ CharacterTable( "U5(2).2" ), CharacterTable( "M22.2" ) ],
>        [ 1, 1 ], "outer" );
5/96
gap> SigmaFromMaxes( CharacterTable( "U6(2).3" ), "11A",
>        [ CharacterTable( "U5(2)" ) * CharacterTable( "Cyclic", 3 ) ],
>        [ 1 ], "outer" );
59/224
gap> CleanWorkspace();
gap> PrimitivesInfoForOddDegreeAlternatingGroup:= function( n )
>     local G, max, cycle, spos, prim, nonz;
> 
>     G:= AlternatingGroup( n );
> 
>     # Compute representatives of the classes of maximal subgroups.
>     max:= MaximalSubgroupClassReps( G );
> 
>     # Omit subgroups that cannot contain an `n'-cycle.
>     max:= Filtered( max, m -> IsTransitive( m, [ 1 .. n ] ) );
> 
>     # Compute the permutation characters.
>     cycle:= [];
>     cycle[ n-1 ]:= 1;
>     spos:= PositionProperty( ConjugacyClasses( CharacterTable( G ) ),
>                c -> CycleStructurePerm( Representative( c ) ) = cycle );
>     prim:= List( max, m -> TrivialCharacter( m )^G );
>     nonz:= PositionsProperty( prim, x -> x[ spos ] <> 0 );
> 
>     # Compute the subgroup names and the multiplicities.
>     return rec( spos := spos,
>                 prim := prim{ nonz },
>                 grps := List( max{ nonz },
>                               m -> TransitiveGroup( n,
>                                        TransitiveIdentification( m ) ) ),
>                 mult := List( prim{ nonz }, x -> x[ spos ] ) );
> end;;
gap> for n in [ 5, 7 .. 23 ] do
>      prim:= PrimitivesInfoForOddDegreeAlternatingGroup( n );
>      bound:= Maximum( ApproxP( prim.prim, prim.spos ) );
>      Print( n, ": ", prim.grps, ", ", prim.mult, ", ", bound, "\n" );
> od;
5: [ D(5) = 5:2 ], [ 1 ], 1/3
7: [ L(7) = L(3,2), L(7) = L(3,2) ], [ 1, 1 ], 2/5
9: [ 1/2[S(3)^3]S(3), L(9):3=P|L(2,8) ], [ 1, 3 ], 9/35
11: [ M(11), M(11) ], [ 1, 1 ], 2/105
13: [ F_78(13)=13:6, L(13)=PSL(3,3), L(13)=PSL(3,3) ], [ 1, 2, 2 ], 4/1155
15: [ 1/2[S(3)^5]S(5), 1/2[S(5)^3]S(3), L(15)=A_8(15)=PSL(4,2), 
  L(15)=A_8(15)=PSL(4,2) ], [ 1, 1, 1, 1 ], 29/273
17: [ L(17):4=PYL(2,16), L(17):4=PYL(2,16) ], [ 1, 1 ], 2/135135
19: [ F_171(19)=19:9 ], [ 1 ], 1/6098892800
21: [ t21n150, t21n161, t21n91 ], [ 1, 1, 2 ], 29/285
23: [ M(23), M(23) ], [ 1, 1 ], 2/130945815
gap> t:= CharacterTable( "A5" );;
gap> ProbGenInfoSimple( t );
[ "A5", 1/3, 2, [ "5A" ], [ 1 ] ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 5, 5 ]
gap> PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "A5" ), [ 5, 1, 2, 0, 0 ] ), 
  Character( CharacterTable( "A5" ), [ 6, 2, 0, 1, 1 ] ), 
  Character( CharacterTable( "A5" ), [ 10, 2, 1, 0, 0 ] ) ]
gap> g:= AlternatingGroup( 5 );;
gap> inv:= g.1^2 * g.2;
(1,4)(2,5)
gap> cclreps:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( cclreps, Order ), cclreps );
gap> List( cclreps, Order );
[ 1, 2, 3, 5, 5 ]
gap> Size( ConjugacyClass( g, inv ) );
15
gap> prop:= List( cclreps,
>                 r -> RatioOfNongenerationTransPermGroup( g, inv, r ) );
[ 1, 1, 3/5, 1/3, 1/3 ]
gap> Minimum( prop );
1/3
gap> triple:= [ (1,2)(3,4), (1,3)(2,4), (1,4)(2,3) ];;
gap> CommonGeneratorWithGivenElements( g, cclreps, triple );
fail
gap> t:= CharacterTable( "A6" );;
gap> ProbGenInfoSimple( t );
[ "A6", 2/3, 1, [ "5A" ], [ 2 ] ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 4, 5, 5 ]
gap> prim:= PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "A6" ), [ 6, 2, 3, 0, 0, 1, 1 ] ), 
  Character( CharacterTable( "A6" ), [ 6, 2, 0, 3, 0, 1, 1 ] ), 
  Character( CharacterTable( "A6" ), [ 10, 2, 1, 1, 2, 0, 0 ] ), 
  Character( CharacterTable( "A6" ), [ 15, 3, 3, 0, 1, 0, 0 ] ), 
  Character( CharacterTable( "A6" ), [ 15, 3, 0, 3, 1, 0, 0 ] ) ]
gap> S:= AlternatingGroup( 6 );;
gap> inv:= (S.1*S.2)^2;
(1,3)(2,5)
gap> cclreps:= List( ConjugacyClasses( S ), Representative );;
gap> SortParallel( List( cclreps, Order ), cclreps );
gap> List( cclreps, Order );
[ 1, 2, 3, 3, 4, 5, 5 ]
gap> C:= ConjugacyClass( S, inv );;
gap> Size( C );
45
gap> prop:= List( cclreps,
>                 r -> RatioOfNongenerationTransPermGroup( S, inv, r ) );
[ 1, 1, 1, 1, 29/45, 5/9, 5/9 ]
gap> Minimum( prop );
5/9
gap> ApproxP( prim, 6 );
[ 0, 2/3, 1/2, 1/2, 0, 1/3, 1/3 ]
gap> triple:= [ (1,2)(3,4), (1,3)(2,4), (1,4)(2,3) ];;
gap> CommonGeneratorWithGivenElements( S, cclreps, triple );
fail
gap> triple:= [ (1,3)(2,4), (1,5)(2,6), (3,6)(4,5) ];;
gap> CommonGeneratorWithGivenElements( S, cclreps, triple );
fail
gap> TripleWithProperty( [ [ inv ], C, C ],
>        l -> ForAll( S, elm ->
>   ForAny( l, x -> not IsGeneratorsOfTransPermGroup( S, [ elm, x ] ) ) ) );
[ (1,3)(2,5), (1,3)(2,6), (1,3)(2,4) ]
gap> s:= (1,2,3,4)(5,6);;
gap> reps:= Filtered( cclreps, x -> Order( x ) > 1 );;
gap> ResetGlobalRandomNumberGenerators();
gap> for pair in UnorderedTuples( reps, 2 ) do
>      if RandomCheckUniformSpread( S, pair, s, 40 ) <> true then
>        Print( "#E  nongeneration!\n" );
>      fi;
>    od;
gap> G:= SymmetricGroup( 6 );;
gap> RatioOfNongenerationTransPermGroup( G, s, (1,2) );
1
gap> goods:= Filtered( Elements( G ),
>      s -> IsGeneratorsOfTransPermGroup( G, [ s, (1,2) ] ) and
>           IsGeneratorsOfTransPermGroup( G, [ s, (3,4) ] ) );;
gap> Collected( List( goods, CycleStructurePerm ) );
[ [ [ ,,,, 1 ], 24 ] ]
gap> goods:= Filtered( Elements( G ),
>      s -> IsGeneratorsOfTransPermGroup( G, [ s, (1,2)(3,4)(5,6) ] ) and
>           IsGeneratorsOfTransPermGroup( G, [ s, (1,3)(2,4)(5,6) ] ) );;
gap> Collected( List( goods, CycleStructurePerm ) );
[ [ [ 1, 1 ], 24 ] ]
gap> Sgens:= GeneratorsOfGroup( S );;
gap> primord:= Filtered( List( ConjugacyClasses( G ), Representative ),
>                        x -> IsPrimeInt( Order( x ) ) );;
gap> for x in primord do
>      for y in primord do
>        for pair in DoubleCosetRepsAndSizes( G, Centralizer( G, y ),
>                        Centralizer( G, x ) ) do
>          if not ForAny( G, s -> IsSubset( Group( x,s ), S ) and 
>                                 IsSubset( Group( y^pair[1], s ), S ) ) then
>            Error( [ x, y ] );
>          fi;
>        od;
>      od;
>    od;
gap> filt:= Filtered( S, s -> IsSubset( Group( (1,2), s ), S ) );;
gap> Collected( List( filt, Order ) );
[ [ 5, 48 ] ]
gap> ProbGenInfoSimple( CharacterTable( "A6.2_2" ) );
[ "A6.2_2", 1/6, 5, [ "10A" ], [ 1 ] ]
gap> ProbGenInfoSimple( CharacterTable( "A6.2_3" ) );
[ "A6.2_3", 1/9, 8, [ "8C" ], [ 1 ] ]
gap> t:= CharacterTable( "A6" );;
gap> t2:= CharacterTable( "A6.2_2" );;
gap> spos:= PositionsProperty( OrdersClassRepresentatives( t ), x -> x = 5 );;
gap> ProbGenInfoAlmostSimple( t, t2, spos );
[ "A6.2_2", 1/6, [ "5A", "5B" ], [ 1, 1 ] ]
gap> t:= CharacterTable( "A7" );;
gap> ProbGenInfoSimple( t );
[ "A7", 2/5, 2, [ "7A" ], [ 2 ] ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 4, 5, 6, 7, 7 ]
gap> prim:= PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "A7" ), [ 7, 3, 4, 1, 1, 2, 0, 0, 0 ] ), 
  Character( CharacterTable( "A7" ), [ 15, 3, 0, 3, 1, 0, 0, 1, 1 ] ), 
  Character( CharacterTable( "A7" ), [ 15, 3, 0, 3, 1, 0, 0, 1, 1 ] ), 
  Character( CharacterTable( "A7" ), [ 21, 5, 6, 0, 1, 1, 2, 0, 0 ] ), 
  Character( CharacterTable( "A7" ), [ 35, 7, 5, 2, 1, 0, 1, 0, 0 ] ) ]
gap> g:= AlternatingGroup( 7 );;
gap> inv:= (g.1^3*g.2)^3;
(2,6)(3,7)
gap> ccl:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 3, 3, 4, 5, 6, 7, 7 ]
gap> Size( ConjugacyClass( g, inv ) );
105
gap> prop:= List( ccl, r -> RatioOfNongenerationTransPermGroup( g, inv, r ) );
[ 1, 1, 1, 1, 89/105, 17/21, 19/35, 2/5, 2/5 ]
gap> Minimum( prop );
2/5
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 4, 5, 6, 7, 7 ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 7 );;
gap> SizesCentralizers( t );
[ 2520, 24, 36, 9, 4, 5, 12, 7, 7 ]
gap> ApproxP( prim, spos );
[ 0, 2/5, 0, 2/5, 2/15, 0, 0, 2/15, 2/15 ]
gap> s:= (1,2,3,4,5,6,7);;
gap> 3B:= (1,2,3)(4,5,6);;
gap> C3B:= ConjugacyClass( g, 3B );;
gap> Size( C3B );
280
gap> ResetGlobalRandomNumberGenerators();
gap> for triple in UnorderedTuples( [ inv, 3B ], 3 ) do
>      if RandomCheckUniformSpread( g, triple, s, 80 ) <> true then
>        Print( "#E  nongeneration!\n" );
>      fi;
>    od;
gap> tom:= TableOfMarks( "A7" );;
gap> a7:= UnderlyingGroup( tom );;
gap> tommaxes:= MaximalSubgroupsTom( tom );
[ [ 39, 38, 37, 36, 35 ], [ 7, 15, 15, 21, 35 ] ]
gap> index15:= List( tommaxes[1]{ [ 2, 3 ] },
>                    i -> RepresentativeTom( tom, i ) );
[ Group([ (1,3)(2,7), (1,5,7)(3,4,6) ]), 
  Group([ (1,4)(2,3), (2,4,6)(3,5,7) ]) ]
gap> deg15:= List( index15, s -> RightTransversal( a7, s ) );;
gap> reps:= List( deg15, l -> Action( a7, l, OnRight ) );
[ Group([ (1,5,7)(2,9,10)(3,11,4)(6,12,8)(13,14,15), 
      (1,8,15,5,12)(2,13,11,3,10)(4,14,9,7,6) ]), 
  Group([ (1,2,3)(4,6,5)(7,8,9)(10,12,11)(13,15,14), 
      (1,12,3,13,10)(2,9,15,4,11)(5,6,14,7,8) ]) ]
gap> g:= DiagonalProductOfPermGroups( reps );;
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 7;
gap> NrMovedPoints( s );
28
gap> mpg:= MovedPoints( g );;
gap> fixs:= Difference( mpg, MovedPoints( s ) );;
gap> orb_s:= Orbit( g, fixs, OnSets );;
gap> Length( orb_s );
120
gap> SizesCentralizers( t );
[ 2520, 24, 36, 9, 4, 5, 12, 7, 7 ]
gap> repeat 2a:= Random( g ); until Order( 2a ) = 2;
gap> repeat 3b:= Random( g );
>    until Order( 3b ) = 3 and Size( Centralizer( g, 3b ) ) = 9;
gap> orb2a:= Orbit( g, Difference( mpg, MovedPoints( 2a ) ), OnSets );;
gap> orb3b:= Orbit( g, Difference( mpg, MovedPoints( 3b ) ), OnSets );;
gap> orb2aor3b:= Union( orb2a, orb3b );;
gap> TripleWithProperty( [ [ orb2a[1], orb3b[1] ], orb2aor3b, orb2aor3b ],
>        l -> ForAll( orb_s,
>                 f -> not IsEmpty( Intersection( Union( l ), f ) ) ) );
fail
gap> QuadrupleWithProperty( [ [ orb2a[1] ], orb2a, orb2a, orb2a ],
>        l -> ForAll( orb_s,
>                 f -> not IsEmpty( Intersection( Union( l ), f ) ) ) );
[ [ 2, 11, 15, 19, 24, 29 ], [ 4, 9, 13, 21, 22, 28 ], 
  [ 3, 10, 14, 20, 23, 30 ], [ 1, 5, 7, 25, 26, 27 ] ]
gap> has6A:= List( tommaxes[1]{ [ 4, 5 ] },
>                  i -> RepresentativeTom( tom, i ) );
[ Group([ (1,2)(3,7), (2,6,5,4)(3,7) ]), 
  Group([ (2,3)(5,7), (1,2)(4,5,6,7), (2,3)(5,6) ]) ]
gap> trans:= List( has6A, s -> RightTransversal( a7, s ) );;
gap> reps:= List( trans, l -> Action( a7, l, OnRight ) );
[ Group([ (1,16,12)(2,17,13)(3,18,11)(4,19,14)(15,20,21), 
      (1,4,7,9,10)(2,5,8,3,6)(11,12,15,14,13)(16,20,19,17,18) ]), 
  Group([ (2,16,6)(3,17,7)(4,18,8)(5,19,9)(10,20,26)(11,21,27)(12,22,28)(13,
        23,29)(14,24,30)(15,25,31), (1,2,3,4,5)(6,10,13,15,9)(7,11,14,8,
        12)(16,20,23,25,19)(17,21,24,18,22)(26,32,35,31,28)(27,33,29,34,30) 
     ]) ]
gap> g:= DiagonalProductOfPermGroups( reps );;
gap> repeat s:= Random( g );
>    until Order( s ) = 6;
gap> NrMovedPoints( s );
53
gap> mpg:= MovedPoints( g );;
gap> fixs:= Difference( mpg, MovedPoints( s ) );;
gap> orb_s:= Orbit( g, fixs, OnSets );;
gap> Length( orb_s );
105
gap> repeat 3a:= Random( g );
>    until Order( 3a ) = 3 and Size( Centralizer( g, 3a ) ) = 36;
gap> orb3a:= Orbit( g, Difference( mpg, MovedPoints( 3a ) ), OnSets );;
gap> Length( orb3a );
35
gap> TripleWithProperty( [ [ orb3a[1] ], orb3a, orb3a ],
>        l -> ForAll( orb_s,
>                 f -> not IsEmpty( Intersection( Union( l ), f ) ) ) );
[ [ 5, 7, 9, 17, 18, 19, 31, 32, 34, 40, 53 ], 
  [ 5, 7, 9, 11, 13, 14, 30, 41, 42, 44, 53 ], 
  [ 2, 3, 4, 5, 7, 9, 26, 47, 48, 50, 53 ] ]
#############################################################################
##
#F  RelativeSigmaL( <d>, <B> )
##
##  Let <d> be a positive integer and <B> a basis for a field extension
##  of degree $n$, say, over the field $F$ with $q$ elements.
##  `RelativeSigmaL' returns a group of $<d> n \times <d> n$ matrices
##  over $F$, which is the intersection of $\SL(<d> n, q)$ and the split
##  extension of an extension field type subgroup isomorphic with
##  $\GL(<d>, q^n)$ by the Frobenius automorphism that maps each matrix
##  entry to its $q$-th power.
##
##  (If $q$ is a prime then the return value is isomorphic with the
##  semilinear group $\SigmaL(<d>, q^n)$.)
##
gap> RelativeSigmaL:= function( d, B )
>     local n, F, q, glgens, diag, pi, frob, i;
> 
>     n:= Length( B );
>     F:= LeftActingDomain( UnderlyingLeftModule( B ) );
>     q:= Size( F );
> 
>     # Create the generating matrices inside the linear subgroup.
>     glgens:= List( GeneratorsOfGroup( SL( d, q^n ) ),
>                    m -> BlownUpMat( B, m ) );
> 
>     # Create the matrix of a diagonal part that maps to determinant 1.
>     diag:= IdentityMat( d*n, F );
>     diag{ [ 1 .. n ] }{ [ 1 .. n ] }:= BlownUpMat( B, [ [ Z(q^n)^(q-1) ] ] );
>     Add( glgens, diag );
> 
>     # Create the matrix that realizes the Frobenius action,
>     # and adjust the determinant.
>     pi:= List( B, b -> Coefficients( B, b^q ) );
>     frob:= NullMat( d*n, d*n, F );
>     for i in [ 0 .. d-1 ] do
>       frob{ [ 1 .. n ] + i*n }{ [ 1 .. n ] + i*n }:= pi;
>     od;
>     diag:= IdentityMat( d*n, F );
>     diag{ [ 1 .. n ] }{ [ 1 .. n ] }:= BlownUpMat( B, [ [ Z(q^n) ] ] );
>     diag:= diag^LogFFE( Inverse( Determinant( frob ) ), Determinant( diag ) );
> 
>     # Return the result.
>     return Group( Concatenation( glgens, [ diag * frob ] ) );
> end;;
#############################################################################
##
#F  ApproxPForSL( <d>, <q> )
##
##  For a positive integer <d> and a prime power <q>,
##  `ApproxPForSL' returns $[ \M(G,s), \total( G, s ) ]$,
##  where $G = \PSL( <d>, <q> )$, $s \in G$ is the image of a Singer cycle
##  in $\SL(d,q)$,
##  and $\M(G,s)$ is the list of names of those maximal subgroups of $G$
##  that contain $s$.
##
gap> ApproxPForSL:= function( d, q )
>     local G, epi, PG, primes, maxes, names, ccl;
> 
>     # Check whether this is an admissible case (see [Be00]).
>     if ( d = 2 and q in [ 2, 5, 7, 9 ] ) or ( d = 3 and q = 4 ) then
>       return fail;
>     fi;
> 
>     # Create the group SL(d,q), and the map to PSL(d,q).
>     G:= SL( d, q );
>     epi:= ActionHomomorphism( G, NormedRowVectors( GF(q)^d ), OnLines );
>     PG:= ImagesSource( epi );
> 
>     # Create the subgroups corresponding to the prime divisors of `d'.
>     primes:= Set( Factors( d ) );
>     maxes:= List( primes, p -> RelativeSigmaL( d/p,
>                                  Basis( AsField( GF(q), GF(q^p) ) ) ) );
>     names:= List( primes, p -> Concatenation( "GL(", String( d/p ), ",",
>                                  String( q^p ), ").", String( p ) ) );
>     if 2 < q then
>       names:= List( names, name -> Concatenation( name, " cap G" ) );
>     fi;
> 
>     # Compute the conjugacy classes of prime order elements in the maxes.
>     # (In order to avoid computing all conjugacy classes of these subgroups,
>     # we work in Sylow subgroups.)
>     ccl:= List( List( maxes, x -> ImagesSet( epi, x ) ),
>             M -> ClassesOfPrimeOrder( M, Set( Factors( Size( M ) ) ),
>                                       TrivialSubgroup( M ) ) );
> 
>     return [ names, UpperBoundFixedPointRatios( PG, ccl, true )[1] ];
> end;;
gap> pairs:= [ [ 3, 2 ], [ 3, 3 ], [ 4, 2 ], [ 4, 3 ], [ 4, 4 ],
>            [ 6, 2 ], [ 6, 3 ], [ 6, 4 ], [ 6, 5 ], [ 8, 2 ], [ 10, 2 ] ];;
gap> array:= [];;
gap> for pair in pairs do
>      d:= pair[1];  q:= pair[2];
>      approx:= ApproxPForSL( d, q );
>      Add( array, [ Concatenation( "SL(", String(d), ",", String(q), ")" ),
>                    (q^d-1)/(q-1),
>                    approx[1], approx[2] ] );
>    od;
gap> PrintFormattedArray( array );
   SL(3,2)    7                             [ "GL(1,8).3" ]             1/4
   SL(3,3)   13                      [ "GL(1,27).3 cap G" ]            1/24
   SL(4,2)   15                             [ "GL(2,4).2" ]            3/14
   SL(4,3)   40                       [ "GL(2,9).2 cap G" ]         53/1053
   SL(4,4)   85                      [ "GL(2,16).2 cap G" ]           1/108
   SL(6,2)   63                [ "GL(3,4).2", "GL(2,8).3" ]       365/55552
   SL(6,3)  364   [ "GL(3,9).2 cap G", "GL(2,27).3 cap G" ] 22843/123845436
   SL(6,4) 1365  [ "GL(3,16).2 cap G", "GL(2,64).3 cap G" ]         1/85932
   SL(6,5) 3906 [ "GL(3,25).2 cap G", "GL(2,125).3 cap G" ]        1/484220
   SL(8,2)  255                             [ "GL(4,4).2" ]          1/7874
  SL(10,2) 1023               [ "GL(5,4).2", "GL(2,32).5" ]        1/129794
gap> t:= CharacterTable( "L6(2)" );;
gap> s1:= CharacterTable( "3.L3(4).3.2_2" );;
gap> s2:= CharacterTable( "(7xL2(8)).3" );;
gap> SigmaFromMaxes( t, "63A", [ s1, s2 ], [ 1, 1 ] );
365/55552
gap> UpperBoundForSL:= function( d, q )
>     local G, Msize, ccl;
> 
>     if not IsPrimeInt( d ) then
>       Error( "<d> must be a prime" );
>     fi;
> 
>     G:= SL( d, q );
>     Msize:= (q^d-1) * d;
>     ccl:= Filtered( ConjugacyClasses( G ),
>                     c ->     Msize mod Order( Representative( c ) ) = 0
>                          and Size( c ) <> 1 );
> 
>     return Msize / Minimum( List( ccl, Size ) );
> end;;
gap> NrConjugacyClasses( SL(11,4) );
1397660
gap> pairs:= [ [ 3, 2 ], [ 3, 3 ], [ 5, 2 ], [ 5, 3 ], [ 5, 4 ],
>              [ 7, 2 ], [ 7, 3 ], [ 7, 4 ],
>              [ 11, 2 ], [ 11, 3 ] ];;
gap> array:= [];;
gap> for pair in pairs do
>      d:= pair[1];  q:= pair[2];
>      approx:= UpperBoundForSL( d, q );
>      Add( array, [ Concatenation( "SL(", String(d), ",", String(q), ")" ),
>                    (q^d-1)/(q-1),
>                    approx ] );
>    od;
gap> PrintFormattedArray( array );
   SL(3,2)     7                                   7/8
   SL(3,3)    13                                   3/4
   SL(5,2)    31                              31/64512
   SL(5,3)   121                                 10/81
   SL(5,4)   341                                15/256
   SL(7,2)   127                             7/9142272
   SL(7,3)  1093                                14/729
   SL(7,4)  5461                               21/4096
  SL(11,2)  2047 2047/34112245508649716682268134604800
  SL(11,3) 88573                              22/59049
gap> SigmaFromMaxes( CharacterTable( "L5(2)" ), "31A",
>        [ CharacterTable( "31:5" ) ], [ 1 ] );
1/5376
gap> t:= CharacterTable( "L7(2)" );;
gap> s:= CharacterTable( "P:Q", [ 127, 7 ] );;
gap> pi:= PossiblePermutationCharacters( s, t );;
gap> Length( pi );
2
gap> ord7:= PositionsProperty( OrdersClassRepresentatives( t ), x -> x = 7 );
[ 38, 45, 76, 77, 83 ]
gap> sizes:= SizesCentralizers( t ){ ord7 };
[ 141120, 141120, 3528, 3528, 49 ]
gap> List( pi, x -> x[83] );
[ 42, 0 ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 127 );;
gap> Maximum( ApproxP( pi{ [ 1 ] }, spos ) );
1/4388290560
#############################################################################
##
#F  SymmetricBasis( <q>, <n> )
##
##  For a positive integer <n> and a prime power <q>,
##  `SymmetricBasis' returns a basis $B$ for the `GF(<q>)'-vector space
##  `GF(<q>^<n>)' with the property that $`BlownUpMat'( B, x )$
##  is symmetric for each element $x$ in `GF(<q>^<n>)'.
##
gap> SymmetricBasis:= function( q, n )
>     local vectors, B, issymmetric;
> 
>     if   q = 2 and n = 2 then
>       vectors:= [ Z(2)^0, Z(2^2) ];
>     elif q = 2 and n = 3 then
>       vectors:= [ Z(2)^0, Z(2^3), Z(2^3)^5 ];
>     elif q = 2 and n = 5 then
>       vectors:= [ Z(2)^0, Z(2^5), Z(2^5)^4, Z(2^5)^25, Z(2^5)^26 ];
>     elif q = 3 and n = 2 then
>       vectors:= [ Z(3)^0, Z(3^2) ];
>     elif q = 3 and n = 3 then
>       vectors:= [ Z(3)^0, Z(3^3)^2, Z(3^3)^7 ];
>     elif q = 4 and n = 2 then
>       vectors:= [ Z(2)^0, Z(2^4)^3 ];
>     elif q = 4 and n = 3 then
>       vectors:= [ Z(2)^0, Z(2^3), Z(2^3)^5 ];
>     elif q = 5 and n = 2 then
>       vectors:= [ Z(5)^0, Z(5^2)^2 ];
>     elif q = 5 and n = 3 then
>       vectors:= [ Z(5)^0, Z(5^3)^9, Z(5^3)^27 ];
>     else
>       Error( "sorry, no basis for <q> and <n> stored" );
>     fi;
> 
>     B:= Basis( AsField( GF(q), GF(q^n) ), vectors );
> 
>     # Check that the basis really has the required property.
>     issymmetric:= M -> M = TransposedMat( M );
>     if not ForAll( B, b -> issymmetric( BlownUpMat( B, [ [ b ] ] ) ) ) then
>       Error( "wrong basis!" );
>     fi;
> 
>     # Return the result.
>     return B;
> end;;
#############################################################################
##
#F  EmbeddedMatrix( <F>, <mat>, <func> )
##
##  For a field <F>, a matrix <mat> and a function <func> that takes a matrix
##  and returns a matrix of the same shape,
##  `EmbeddedMatrix' returns a block diagonal matrix over the field <F>
##  whose diagonal blocks are <mat> and `<func>( <mat> )'.
##
gap> BindGlobal( "EmbeddedMatrix", function( F, mat, func )
>   local d, result;
> 
>   d:= Length( mat );
>   result:= NullMat( 2*d, 2*d, F );
>   result{ [ 1 .. d ] }{ [ 1 .. d ] }:= mat;
>   result{ [ d+1 .. 2*d ] }{ [ d+1 .. 2*d ] }:= func( mat );
> 
>   return result;
> end );
#############################################################################
##
#F  ApproxPForOuterClassesInExtensionOfSLByGraphAut( <d>, <q> )
##
##  For a positive integer <d> and a prime power <q>,
##  `ApproxPForOuterClassesInExtensionOfSLByGraphAut' returns
##  $[ \M(G,s), \total^{\prime}( G, s ) ]$,
##  where $G$ is $\PSL( <d>, <q> )$ extended by a graph automorphism,
##  $s \in G$ is the image of a Singer cycle in $\SL(d,q)$,
##  and $\M(G,s)$ is the list of names of those maximal subgroups of
##  $\PGL( <d>, <q> )$ that contain $s$.
##
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut:= function( d, q )
>     local embedG, swap, G, orb, epi, PG, Gprime, primes, maxes, ccl, names;
> 
>     # Check whether this is an admissible case (see [Be00],
>     # note that a graph automorphism exists only for `d > 2').
>     if d = 2 or ( d = 3 and q = 4 ) then
>       return fail;
>     fi;
> 
>     # Provide a function that constructs a block diagonal matrix.
>     embedG:= mat -> EmbeddedMatrix( GF( q ), mat,
>                                     M -> TransposedMat( M^-1 ) );
> 
>     # Create the matrix that exchanges the two blocks.
>     swap:= NullMat( 2*d, 2*d, GF(q) );
>     swap{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );
>     swap{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );
> 
>     # Create the group SL(d,q).2, and the map to the projective group.
>     G:= ClosureGroupDefault( Group( List( GeneratorsOfGroup( SL( d, q ) ),
>                                           embedG ) ),
>                       swap );
>     orb:= Orbit( G, One( G )[1], OnLines );
>     epi:= ActionHomomorphism( G, orb, OnLines );
>     PG:= ImagesSource( epi );
>     Gprime:= DerivedSubgroup( PG );
> 
>     # Create the subgroups corresponding to the prime divisors of `d'.
>     primes:= Set( Factors( d ) );
>     maxes:= List( primes,
>               p -> ClosureGroupDefault( Group( List( GeneratorsOfGroup(
>                          RelativeSigmaL( d/p, SymmetricBasis( q, p ) ) ),
>                          embedG ) ),
>                      swap ) );
> 
>     # Compute conjugacy classes of outer involutions in the maxes.
>     # (In order to avoid computing all conjugacy classes of these subgroups,
>     # we work in the Sylow $2$ subgroups.)
>     maxes:= List( maxes, M -> ImagesSet( epi, M ) );
>     ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );
>     names:= List( primes, p -> Concatenation( "GL(", String( d/p ), ",",
>                                    String( q^p ), ").", String( p ) ) );
> 
>     return [ names, UpperBoundFixedPointRatios( PG, ccl, true )[1] ];
> end;;
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 4, 3 );
[ [ "GL(2,9).2" ], 17/117 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 4, 4 );
[ [ "GL(2,16).2" ], 73/1008 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 2 );
[ [ "GL(3,4).2", "GL(2,8).3" ], 41/1984 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 3 );
[ [ "GL(3,9).2", "GL(2,27).3" ], 541/352836 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 4 );
[ [ "GL(3,16).2", "GL(2,64).3" ], 3265/12570624 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 6, 5 );
[ [ "GL(3,25).2", "GL(2,125).3" ], 13001/195250000 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 8, 2 );
[ [ "GL(4,4).2" ], 367/1007872 ]
gap> ApproxPForOuterClassesInExtensionOfSLByGraphAut( 10, 2 );
[ [ "GL(5,4).2", "GL(2,32).5" ], 609281/476346056704 ]
#############################################################################
##
#F  RelativeGammaL( <d>, <B> )
##
##  Let the arguments be as for `RelativeSigmaL'.
##  Then `RelativeGammaL' returns the extension field type subgroup of
##  $\GL(d,q)$ that corresponds to the subgroup of $\SL(d,q)$ returned by
##  `RelativeSigmaL'.
##
gap> RelativeGammaL:= function( d, B )
>     local n, F, q, diag;
> 
>     n:= Length( B );
>     F:= LeftActingDomain( UnderlyingLeftModule( B ) );
>     q:= Size( F );
>     diag:= IdentityMat( d * n, F );
>     diag{[ 1 .. n ]}{[ 1 .. n ]}:= BlownUpMat( B, [ [ Z(q^n) ] ] );
>     return ClosureGroup( RelativeSigmaL( d, B ),  diag );
> end;;
#############################################################################
##
#F  ApproxPForOuterClassesInGL( <d>, <q> )
##
##  Let the arguments be as for `ApproxPForSL'.
##  Then `ApproxPForOuterClassesInGL' returns the list of names of the
##  extension field type subgroups of $\GL(<d>,<q>)$,
##  and $\total^{\prime}(\GL(<d>,<q>),s)$,
##  for a Singer cycle $s \in \SL(d,q)$.
##
gap> ApproxPForOuterClassesInGL:= function( d, q )
>     local G, epi, PG, Gprime, primes, maxes, names;
> 
>     # Check whether this is an admissible case (see [Be00]).
>     if ( d = 2 and q in [ 2, 5, 7, 9 ] ) or ( d = 3 and q = 4 ) then
>       return fail;
>     fi;
> 
>     # Create the group GL(d,q), and the map to PGL(d,q).
>     G:= GL( d, q );
>     epi:= ActionHomomorphism( G, NormedRowVectors( GF(q)^d ), OnLines );
>     PG:= ImagesSource( epi );
>     Gprime:= ImagesSet( epi, SL( d, q ) );
> 
>     # Create the subgroups corresponding to the prime divisors of `d'.
>     primes:= Set( Factors( d ) );
>     maxes:= List( primes, p -> RelativeGammaL( d/p,
>                                    Basis( AsField( GF(q), GF(q^p) ) ) ) );
>     maxes:= List( maxes, M -> ImagesSet( epi, M ) );
>     names:= List( primes, p -> Concatenation( "M(", String( d/p ), ",",
>                                    String( q^p ), ")" ) );
> 
>     return [ names,
>              UpperBoundFixedPointRatios( PG, List( maxes,
>                  M -> ClassesOfPrimeOrder( M,
>                           Set( Factors( Index( PG, Gprime ) ) ), Gprime ) ),
>                  true )[1] ];
> end;;
gap> ApproxPForOuterClassesInGL( 6, 3 );
[ [ "M(3,9)", "M(2,27)" ], 41/882090 ]
gap> ApproxPForOuterClassesInGL( 4, 3 );
[ [ "M(2,9)" ], 0 ]
gap> ApproxPForOuterClassesInGL( 6, 4 );
[ [ "M(3,16)", "M(2,64)" ], 1/87296 ]
gap> ApproxPForOuterClassesInGL( 6, 5 );
[ [ "M(3,25)", "M(2,125)" ], 821563/756593750000 ]
gap> matgrp:= SL(6,4);;
gap> dom:= NormedRowVectors( GF(4)^6 );;
gap> Gprime:= Action( matgrp, dom, OnLines );;
gap> pi:= PermList( List( dom, v -> Position( dom, List( v, x -> x^2 ) ) ) );;
gap> G:= ClosureGroup( Gprime, pi );;
gap> maxes:= List( [ 2, 3 ], p -> Normalizer( G,
>              Action( RelativeSigmaL( 6/p,
>                Basis( AsField( GF(4), GF(4^p) ) ) ), dom, OnLines ) ) );;
gap> ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 0, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 1/34467840, true ]
gap> embedFG:= function( F, mat )
>      return EmbeddedMatrix( F, mat,
>                 M -> List( TransposedMat( M^-1 ),
>                            row -> List( row, x -> x^2 ) ) );
>    end;;
gap> d:= 6;;  q:= 4;;
gap> alpha:= NullMat( 2*d, 2*d, GF(q) );;
gap> alpha{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );;
gap> alpha{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );;
gap> Gprime:= Group( List( GeneratorsOfGroup( SL(d,q) ),
>                          mat -> embedFG( GF(q), mat ) ) );;
gap> G:= ClosureGroupDefault( Gprime, alpha );;
gap> orb:= Orbit( G, One( G )[1], OnLines );;
gap> G:= Action( G, orb, OnLines );;
gap> Gprime:= Action( Gprime, orb, OnLines );;
gap> maxes:= List( Set( Factors( d ) ), p -> Group( List( GeneratorsOfGroup(
>              RelativeSigmaL( d/p, Basis( AsField( GF(q), GF(q^p) ) ) ) ),
>                mat -> embedFG( GF(q), mat ) ) ) );;
gap> maxes:= List( maxes, x -> Action( x, orb, OnLines ) );;
gap> maxes:= List( maxes, x -> Normalizer( G, x ) );;
gap> ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 0, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 1/10792960, true ]
gap> d:= 6;;  q:= 3;;
gap> diag:= IdentityMat( d, GF(q) );;
gap> diag[1][1]:= Z(q);;
gap> embedDG:= mat -> EmbeddedMatrix( GF(q), mat,
>                                     M -> TransposedMat( M^-1 )^diag );;
gap> Gprime:= Group( List( GeneratorsOfGroup( SL(d,q) ), embedDG ) );;
gap> alpha:= NullMat( 2*d, 2*d, GF(q) );;
gap> alpha{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );;
gap> alpha{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );;
gap> G:= ClosureGroupDefault( Gprime, alpha );;
gap> maxes:= List( Set( Factors( d ) ), p -> Group( List( GeneratorsOfGroup(
>              RelativeSigmaL( d/p, Basis( AsField( GF(q), GF(q^p) ) ) ) ),
>                embedDG ) ) );;
gap> orb:= Orbit( G, One( G )[1], OnLines );;
gap> G:= Action( G, orb, OnLines );;
gap> Gprime:= Action( Gprime, orb, OnLines );;
gap> maxes:= List( maxes, M -> Normalizer( G, Action( M, orb, OnLines ) ) );;
gap> ccl:= List( maxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 1, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 25/352836, true ]
gap> d:= 6;;  q:= 5;;
gap> embedG:= mat -> EmbeddedMatrix( GF(q),
>                                    mat, M -> TransposedMat( M^-1 ) );;
gap> Gprime:= Group( List( GeneratorsOfGroup( SL(d,q) ), embedG ) );;
gap> maxes:= List( Set( Factors( d ) ), p -> Group( List( GeneratorsOfGroup(
>              RelativeSigmaL( d/p, Basis( AsField( GF(q), GF(q^p) ) ) ) ),
>                embedG ) ) );;
gap> diag:= IdentityMat( d, GF(q) );;
gap> diag[1][1]:= Z(q);;
gap> diag:= embedG( diag );;
gap> alpha:= NullMat( 2*d, 2*d, GF(q) );;
gap> alpha{ [ 1 .. d ] }{ [ d+1 .. 2*d ] }:= IdentityMat( d, GF(q) );;
gap> alpha{ [ d+1 .. 2*d ] }{ [ 1 .. d ] }:= IdentityMat( d, GF(q) );;
gap> G:= ClosureGroupDefault( Gprime, alpha * diag );;
gap> orb:= Orbit( G, One( G )[1], OnLines );;
gap> Gprime:= Action( Gprime, orb, OnLines );;
gap> G:= Action( G, orb, OnLines );;
gap> maxes:= List( maxes, M -> Action( M, orb, OnLines ) );;
gap> extmaxes:= List( maxes, M -> Normalizer( G, M ) );;
gap> ccl:= List( extmaxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 2, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 3863/6052750000, true ]
gap> diag:= Permutation( diag, orb, OnLines );;
gap> G:= ClosureGroupDefault( Gprime, diag );;
gap> extmaxes:= List( maxes, M -> Normalizer( G, M ) );;
gap> ccl:= List( extmaxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 3, 1 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 821563/756593750000, true ]
gap> alpha:= Permutation( alpha, orb, OnLines );;
gap> G:= ClosureGroupDefault( Gprime, alpha );;
gap> extmaxes:= List( maxes, M -> Normalizer( G, M ) );;
gap> ccl:= List( extmaxes, M -> ClassesOfPrimeOrder( M, [ 2 ], Gprime ) );;
gap> List( ccl, Length );
[ 2, 2 ]
gap> UpperBoundFixedPointRatios( G, ccl, true );
[ 13001/195250000, true ]
gap> t:= CharacterTable( "L3(2)" );;
gap> ProbGenInfoSimple( t );
[ "L3(2)", 1/4, 3, [ "7A" ], [ 1 ] ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 4, 7, 7 ]
gap> PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "L3(2)" ), [ 7, 3, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "L3(2)" ), [ 7, 3, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "L3(2)" ), [ 8, 0, 2, 0, 1, 1 ] ) ]
gap> tom:= TableOfMarks( "L3(2)" );;
gap> g:= UnderlyingGroup( tom );
Group([ (2,4)(5,7), (1,2,3)(4,5,6) ])
gap> mx:= MaximalSubgroupsTom( tom );
[ [ 14, 13, 12 ], [ 7, 7, 8 ] ]
gap> maxes:= List( mx[1], i -> RepresentativeTom( tom, i ) );;
gap> tr:= List( maxes, s -> RightTransversal( g, s ) );;
gap> acts:= List( tr, x -> Action( g, x, OnRight ) );;
gap> g7:= acts[1];
Group([ (3,4)(6,7), (1,3,2)(4,6,5) ])
gap> g8:= acts[3];
Group([ (1,6)(2,5)(3,8)(4,7), (1,7,3)(2,5,8) ])
gap> g14:= DiagonalProductOfPermGroups( acts{ [ 1, 2 ] } );
Group([ (3,4)(6,7)(11,13)(12,14), (1,3,2)(4,6,5)(8,11,9)(10,12,13) ])
gap> g15:= DiagonalProductOfPermGroups( acts{ [ 2, 3 ] } );
Group([ (4,6)(5,7)(8,13)(9,12)(10,15)(11,14), 
  (1,4,2)(3,5,6)(8,14,10)(9,12,15) ])
gap> ccl:= List( ConjugacyClasses( g7 ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 3, 4, 7, 7 ]
gap> Size( ConjugacyClass( g7, ccl[3] ) );
56
gap> prop:= List( ccl,
>                 r -> RatioOfNongenerationTransPermGroup( g7, ccl[3], r ) );
[ 1, 5/7, 19/28, 2/7, 1/4, 1/4 ]
gap> Minimum( prop );
1/4
gap> x:= g7.1;
(3,4)(6,7)
gap> fix:= Difference( MovedPoints( g7 ), MovedPoints( x ) );
[ 1, 2, 5 ]
gap> orb:= Orbit( g7, fix, OnSets );
[ [ 1, 2, 5 ], [ 1, 3, 4 ], [ 2, 3, 6 ], [ 2, 4, 7 ], [ 1, 6, 7 ], 
  [ 3, 5, 7 ], [ 4, 5, 6 ] ]
gap> Union( orb{ [ 1, 2, 5 ] } ) = [ 1 .. 7 ];
true
gap> three:= g8.2;
(1,7,3)(2,5,8)
gap> fix:= Difference( MovedPoints( g8 ), MovedPoints( three ) );
[ 4, 6 ]
gap> orb:= Orbit( g8, fix, OnSets );;
gap> QuadrupleWithProperty( [ [ fix ], orb, orb, orb ],
>        list -> Union( list ) = [ 1 .. 8 ] );
[ [ 4, 6 ], [ 1, 7 ], [ 3, 8 ], [ 2, 5 ] ]
gap> x:= g15.1;
(4,6)(5,7)(8,13)(9,12)(10,15)(11,14)
gap> fixx:= Difference( MovedPoints( g15 ), MovedPoints( x ) );
[ 1, 2, 3 ]
gap> orbx:= Orbit( g15, fixx, OnSets );
[ [ 1, 2, 3 ], [ 1, 4, 5 ], [ 1, 6, 7 ], [ 2, 4, 6 ], [ 3, 4, 7 ], 
  [ 3, 5, 6 ], [ 2, 5, 7 ] ]
gap> y:= g15.2;
(1,4,2)(3,5,6)(8,14,10)(9,12,15)
gap> fixy:= Difference( MovedPoints( g15 ), MovedPoints( y ) );
[ 7, 11, 13 ]
gap> orby:= Orbit( g15, fixy, OnSets );;
gap> QuadrupleWithProperty( [ [ fixy ], orby, orby, orby ],
>        l -> Difference( [ 1 .. 15 ], Union( l ) ) in orbx );
[ [ 7, 11, 13 ], [ 5, 8, 14 ], [ 1, 10, 15 ], [ 3, 9, 12 ] ]
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g14 );
>    until Order( s ) = 4;
gap> s;
(2,3,5,4)(6,7)(8,9)(11,12,14,13)
gap> fixs:= Difference( MovedPoints( g14 ), MovedPoints( s ) );
[ 1, 10 ]
gap> orbs:= Orbit( g14, fixs, OnSets );;
gap> Length( orbs );
21
gap> three:= g14.2;
(1,3,2)(4,6,5)(8,11,9)(10,12,13)
gap> fix:= Difference( MovedPoints( g14 ), MovedPoints( three ) );
[ 7, 14 ]
gap> orb:= Orbit( g14, fix, OnSets );;
gap> Length( orb );
28
gap> QuadrupleWithProperty( [ [ fix ], orb, orb, orb ],
>        l -> ForAll( orbs, o -> not IsEmpty( Intersection( o,
>                        Union( l ) ) ) ) );
fail
gap> t:= CharacterTable( "M11" );;
gap> ProbGenInfoSimple( t );
[ "M11", 1/3, 2, [ "11A" ], [ 1 ] ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 4, 5, 6, 8, 8, 11, 11 ]
gap> PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "M11" ), [ 11, 3, 2, 3, 1, 0, 1, 1, 0, 0 ] ),
  Character( CharacterTable( "M11" ), [ 12, 4, 3, 0, 2, 1, 0, 0, 1, 1 ] ),
  Character( CharacterTable( "M11" ), [ 55, 7, 1, 3, 0, 1, 1, 1, 0, 0 ] ),
  Character( CharacterTable( "M11" ), [ 66, 10, 3, 2, 1, 1, 0, 0, 0, 0 ] ),
  Character( CharacterTable( "M11" ), [ 165, 13, 3, 1, 0, 1, 1, 1, 0, 0 ] ) ]
gap> Maxes( t );
[ "A6.2_3", "L2(11)", "3^2:Q8.2", "A5.2", "2.S4" ]
gap> gens11:= OneAtlasGeneratingSet( "M11", NrMovedPoints, 11 );
rec( charactername := "1a+10a",
  generators := [ (2,10)(4,11)(5,7)(8,9), (1,4,3,8)(2,5,6,9) ],
  groupname := "M11", id := "",
  identifier := [ "M11", [ "M11G1-p11B0.m1", "M11G1-p11B0.m2" ], 1, 11 ],
  isPrimitive := true, maxnr := 1, p := 11, rankAction := 2,
  repname := "M11G1-p11B0", repnr := 1, size := 7920, stabilizer := "A6.2_3",
  standardization := 1, transitivity := 4, type := "perm" )
gap> g11:= GroupWithGenerators( gens11.generators );;
gap> gens12:= OneAtlasGeneratingSet( "M11", NrMovedPoints, 12 );;
gap> g12:= GroupWithGenerators( gens12.generators );;
gap> g23:= DiagonalProductOfPermGroups( [ g11, g12 ] );
Group([ (2,10)(4,11)(5,7)(8,9)(12,17)(13,20)(16,18)(19,21), 
  (1,4,3,8)(2,5,6,9)(12,17,18,15)(13,19)(14,20)(16,22,23,21) ])
gap> inv:= g11.1;
(2,10)(4,11)(5,7)(8,9)
gap> ccl:= List( ConjugacyClasses( g11 ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 3, 4, 5, 6, 8, 8, 11, 11 ]
gap> Size( ConjugacyClass( g11, inv ) );
165
gap> prop:= List( ccl,
>                 r -> RatioOfNongenerationTransPermGroup( g11, inv, r ) );
[ 1, 1, 1, 149/165, 25/33, 31/55, 23/55, 23/55, 1/3, 1/3 ]
gap> Minimum( prop );
1/3
gap> inv:= g12.1;
(1,6)(2,9)(5,7)(8,10)
gap> moved:= MovedPoints( inv );
[ 1, 2, 5, 6, 7, 8, 9, 10 ]
gap> orb12:= Orbit( g12, moved, OnSets );;
gap> Length( orb12 );
165
gap> TripleWithProperty( [ orb12{[1]}, orb12, orb12 ],
>        list -> IsEmpty( Intersection( list ) ) );
fail
gap> inv:= g23.1;
(2,10)(4,11)(5,7)(8,9)(12,17)(13,20)(16,18)(19,21)
gap> moved:= MovedPoints( inv );
[ 2, 4, 5, 7, 8, 9, 10, 11, 12, 13, 16, 17, 18, 19, 20, 21 ]
gap> orb23:= Orbit( g23, moved, OnSets );;
gap> three:= ( g23.1*g23.2^2 )^2;
(2,6,10)(4,8,7)(5,9,11)(12,17,23)(15,18,16)(19,21,22)
gap> movedthree:= MovedPoints( three );;
gap> QuadrupleWithProperty( [ [ movedthree ], orb23, orb23, orb23 ],
>        list -> IsEmpty( Intersection( list ) ) );
[ [ 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 21, 22, 23 ], 
  [ 1, 3, 4, 5, 6, 8, 9, 10, 12, 13, 14, 16, 17, 18, 20, 21 ], 
  [ 1, 2, 3, 4, 5, 6, 7, 11, 12, 13, 14, 15, 18, 19, 20, 23 ], 
  [ 1, 2, 3, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 20, 22, 23 ] ]
gap> t:= CharacterTable( "M12" );;
gap> ProbGenInfoSimple( t );
[ "M12", 1/3, 2, [ "10A" ], [ 3 ] ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 10 );
13
gap> prim:= PrimitivePermutationCharacters( t );;
gap> List( prim, x -> x{ [ 1, spos ] } );
[ [ 12, 0 ], [ 12, 0 ], [ 66, 1 ], [ 66, 1 ], [ 144, 0 ], [ 220, 0 ], 
  [ 220, 0 ], [ 396, 1 ], [ 495, 0 ], [ 495, 0 ], [ 1320, 0 ] ]
gap> Maxes( t );
[ "M11", "M12M2", "A6.2^2", "M12M4", "L2(11)", "3^2.2.S4", "M12M7", "2xS5", 
  "M8.S4", "4^2:D12", "A4xS3" ]
gap> g:= MathieuGroup( 12 );
Group([ (1,2,3,4,5,6,7,8,9,10,11), (3,7,11,8)(4,10,5,6), 
  (1,12)(2,11)(3,6)(4,8)(5,9)(7,10) ])
gap> approx:= ApproxP( prim, spos );
[ 0, 3/11, 1/3, 1/11, 1/132, 13/99, 13/99, 13/396, 1/132, 1/33, 1/33, 1/33, 
  13/396, 0, 0 ]
gap> 2B:= g.2^2;
(3,11)(4,5)(6,10)(7,8)
gap> Size( ConjugacyClass( g, 2B ) );
495
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 10;
gap> prop:= RatioOfNongenerationTransPermGroup( g, 2B, s );
31/99
gap> Filtered( approx, x -> x >= prop );
[ 1/3 ]
gap> x:= g.2^2;
(3,11)(4,5)(6,10)(7,8)
gap> ccl:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> prop:= List( ccl, r -> RatioOfNongenerationTransPermGroup( g, x, r ) );
[ 1, 1, 1, 1, 39/55, 1, 1, 29/33, 7/55, 43/55, 383/495, 383/495, 31/99, 5/9,
  5/9 ]
gap> bad:= Filtered( prop, x -> x < 31/99 );
[ 7/55 ]
gap> pos:= Position( prop, bad[1] );;
gap> [ Order( ccl[ pos ] ), NrMovedPoints( ccl[ pos ] ) ];
[ 6, 12 ]
gap> x:= g.3;
(1,12)(2,11)(3,6)(4,8)(5,9)(7,10)
gap> s:= ccl[ pos ];;
gap> prop:= RatioOfNongenerationTransPermGroup( g, x, s );
17/33
gap> prop > 31/99;
true
gap> t:= CharacterTable( "O7(3)" );;
gap> someprim:= [];;
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "2.U4(3).2_2" ), t );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PermChars( t, rec( torso:= [ 364 ] ) );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "L4(3).2_2" ), t );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "G2(3)" ), t );
[ Character( CharacterTable( "O7(3)" ), [ 1080, 0, 0, 24, 108, 0, 0, 0, 27, 
      18, 9, 0, 12, 4, 0, 0, 0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 3, 6, 0, 3, 
      2, 2, 2, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 4, 0, 3, 0, 1, 1, 0, 0, 0, 0, 0, 
      0, 0 ] ), Character( CharacterTable( "O7(3)" ), 
    [ 1080, 0, 0, 24, 108, 0, 0, 27, 0, 18, 9, 0, 12, 4, 0, 0, 0, 0, 0, 0, 0, 
      0, 12, 0, 0, 0, 0, 3, 0, 0, 6, 3, 2, 2, 2, 0, 0, 3, 0, 0, 0, 0, 0, 0, 
      0, 4, 3, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0 ] ) ]
gap> Append( someprim, pi );
gap> pi:= PermChars( t, rec( torso:= [ 1120 ] ) );;  Length( pi );
1
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "S6(2)" ), t );
[ Character( CharacterTable( "O7(3)" ), [ 3159, 567, 135, 39, 0, 81, 0, 0, 
      27, 27, 0, 15, 3, 3, 7, 4, 0, 27, 0, 0, 0, 0, 0, 9, 3, 0, 9, 0, 3, 9, 
      3, 0, 2, 1, 1, 0, 0, 0, 3, 0, 2, 0, 0, 0, 3, 0, 0, 3, 1, 0, 0, 0, 1, 0, 
      0, 0, 0, 0 ] ), Character( CharacterTable( "O7(3)" ), 
    [ 3159, 567, 135, 39, 0, 81, 0, 27, 0, 27, 0, 15, 3, 3, 7, 4, 0, 27, 0, 
      0, 0, 0, 0, 9, 3, 0, 9, 3, 0, 3, 9, 0, 2, 1, 1, 0, 0, 3, 0, 0, 2, 0, 0, 
      0, 3, 0, 3, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0 ] ) ]
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "S9" ), t );
[ Character( CharacterTable( "O7(3)" ), [ 12636, 1296, 216, 84, 0, 81, 0, 0, 
      108, 27, 0, 6, 0, 12, 10, 1, 0, 27, 0, 0, 0, 0, 0, 9, 3, 0, 9, 0, 12, 
      9, 3, 0, 1, 0, 2, 0, 0, 0, 3, 1, 1, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 1, 1, 
      0, 0, 0, 0, 1 ] ), Character( CharacterTable( "O7(3)" ), 
    [ 12636, 1296, 216, 84, 0, 81, 0, 108, 0, 27, 0, 6, 0, 12, 10, 1, 0, 27, 
      0, 0, 0, 0, 0, 9, 3, 0, 9, 12, 0, 3, 9, 0, 1, 0, 2, 0, 0, 3, 0, 1, 1, 
      0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1 ] ) ]
gap> Append( someprim, pi );
gap> t2:= CharacterTable( "O7(3).2" );;
gap> s2:= CharacterTable( "Dihedral", 8 ) * CharacterTable( "U4(2).2" );
CharacterTable( "Dihedral(8)xU4(2).2" )
gap> pi:= PossiblePermutationCharacters( s2, t2 );;  Length( pi );
1
gap> pi:= RestrictedClassFunctions( pi, t );;
gap> Append( someprim, pi );
gap> pi:= PossiblePermutationCharacters(
>             CharacterTable( "2^6:A7" ), t );;  Length( pi );
1
gap> Append( someprim, pi );
gap> List( someprim, x -> x[1] );
[ 351, 364, 378, 1080, 1080, 1120, 3159, 3159, 12636, 12636, 22113, 28431 ]
gap> cl:= PositionsProperty( AtlasClassNames( t ),
>                            x -> x in [ "3D", "3E" ] );
[ 8, 9 ]
gap> List( Filtered( someprim, x -> x[1] = 12636 ), pi -> pi{ cl } );
[ [ 0, 108 ], [ 108, 0 ] ]
gap> GetFusionMap( t, t2 ){ cl };
[ 8, 8 ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 14 );
52
gap> Maximum( ApproxP( someprim, spos ) );
199/351
gap> approx:= List( [ 1 .. NrConjugacyClasses( t ) ],
>       i -> Maximum( ApproxP( someprim, i ) ) );;
gap> PositionsProperty( approx, x -> x <= 199/351 );
[ 52 ]
gap> pos:= PositionsProperty( someprim, x -> x[ spos ] <> 0 );
[ 1, 9, 10 ]
gap> List( someprim{ pos }, x -> x{ [ 1, spos ] } );
[ [ 351, 1 ], [ 12636, 1 ], [ 12636, 1 ] ]
gap> so73:= SpecialOrthogonalGroup( 7, 3 );;
gap> o73:= DerivedSubgroup( so73 );;
gap> orbs:= Orbits( o73, Elements( GF(3)^7 ) );;
gap> Set( List( orbs, Length ) );
[ 1, 702, 728, 756 ]
gap> g:= Action( o73, First( orbs, x -> Length( x ) = 702 ) );;
gap> Size( g ) = Size( t );
true
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 14;
gap> 2A:= s^7;;
gap> bad:= RatioOfNongenerationTransPermGroup( g, 2A, s );
155/351
gap> bad > 1/3;
true
gap> approx:= ApproxP( someprim, spos );;
gap> PositionsProperty( approx, x -> x >= 1/3 );
[ 2 ]
gap> consider:= RepresentativesMaximallyCyclicSubgroups( t );
[ 18, 19, 25, 26, 27, 30, 31, 32, 34, 35, 38, 39, 41, 42, 43, 44, 45, 46, 47, 
  48, 49, 50, 52, 53, 54, 56, 57, 58 ]
gap> Length( consider );
28
gap> consider:= ClassesPerhapsCorrespondingToTableColumns( g, t, consider );;
gap> Length( consider );
31
gap> consider:= List( consider, Representative );;
gap> SortParallel( List( consider, Order ), consider );
gap> app2A:= List( consider, c ->
>       RatioOfNongenerationTransPermGroup( g, 2A, c ) );
[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 85/117, 1, 10/13, 10/13, 1, 1, 23/39, 23/39, 1,
  1, 1, 1, 1, 1/3, 1/3, 155/351, 67/117, 1, 1, 1, 1, 191/351 ]
gap> test:= PositionsProperty( app2A, x -> x <= 155/351 );
[ 23, 24, 25 ]
gap> List( test, i -> Order( consider[i] ) );
[ 13, 13, 14 ]
gap> C3A:= First( ConjugacyClasses( g ),
>               c -> Order( Representative( c ) ) = 3 and Size( c ) = 7280 );;
gap> repeat ss:= Random( g );
>    until Order( ss ) = 13;
gap> bad:= RatioOfNongenerationTransPermGroup( g, Representative( C3A ), ss );
17/35
gap> bad > 155/351;
true
gap> approx:= ApproxP( someprim, spos );;
gap> max:= Maximum( approx{ [ 3 .. Length( approx ) ] } );
59/351
gap> 155 + 2*59 < 351;
true
gap> third:= PositionsProperty( approx, x -> 2 * 155/351 + x >= 1 );
[ 2, 3, 6 ]
gap> ClassNames( t ){ third };
[ "2a", "2b", "3b" ]
gap> ord20:= PositionsProperty( OrdersClassRepresentatives( t ),
>                               x -> x = 20 );
[ 58 ]
gap> PowerMap( t, 10 ){ ord20 };
[ 3 ]
gap> repeat x:= Random( g );
>    until Order( x ) = 20;
gap> 2B:= x^10;;
gap> C2B:= ConjugacyClass( g, 2B );;
gap> ord15:= PositionsProperty( OrdersClassRepresentatives( t ),
>                               x -> x = 15 );
[ 53 ]
gap> PowerMap( t, 10 ){ ord15 };
[ 6 ]
gap> repeat x:= Random( g );
>    until Order( x ) = 15;
gap> 3B:= x^5;;
gap> C3B:= ConjugacyClass( g, 3B );;
gap> repeat s:= Random( g );
>    until Order( s ) = 14;
gap> RandomCheckUniformSpread( g, [ 2A, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 2B, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 3B, 2A, 2A ], s, 50 );
true
gap> prim:= someprim{ [ 1 ] };
[ Character( CharacterTable( "O7(3)" ), [ 351, 127, 47, 15, 27, 45, 36, 0, 0, 
      9, 0, 15, 3, 3, 7, 6, 19, 19, 10, 11, 12, 8, 3, 5, 3, 6, 1, 0, 0, 3, 3, 
      0, 1, 1, 1, 6, 3, 0, 0, 2, 2, 0, 3, 0, 3, 3, 0, 0, 1, 0, 0, 1, 0, 4, 4, 
      1, 2, 0 ] ) ]
gap> spos:= Position( AtlasClassNames( t ), "14A" );;
gap> t2:= CharacterTable( "O7(3).2" );;
gap> map:= InverseMap( GetFusionMap( t, t2 ) );;
gap> torso:= List( prim, pi -> CompositionMaps( pi, map ) );;
gap> ext:= List( torso, x -> PermChars( t2, rec( torso:= x ) ) );
[ [ Character( CharacterTable( "O7(3).2" ), [ 351, 127, 47, 15, 27, 45, 36, 
          0, 9, 0, 15, 3, 3, 7, 6, 19, 19, 10, 11, 12, 8, 3, 5, 3, 6, 1, 0, 
          3, 0, 1, 1, 1, 6, 3, 0, 2, 2, 0, 3, 0, 3, 3, 0, 1, 0, 0, 1, 0, 4, 
          1, 2, 0, 117, 37, 21, 45, 1, 13, 5, 1, 9, 9, 18, 15, 1, 7, 9, 6, 4, 
          0, 3, 0, 3, 3, 6, 2, 2, 9, 6, 1, 3, 1, 4, 1, 2, 1, 1, 0, 3, 1, 0, 
          0, 0, 0, 1, 1, 0, 0 ] ) ] ]
gap> approx:= ApproxP( Concatenation( ext ),
>        Position( AtlasClassNames( t2 ), "14A" ) );;
gap> Maximum( approx{ Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) ) } );
1/3
gap> t:= CharacterTable( "O8+(2)" );;
gap> ProbGenInfoSimple( t );
[ "O8+(2)", 334/315, 0, [ "15A", "15B", "15C" ], [ 7, 7, 7 ] ]
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 15 );;
gap> List( Filtered( prim, x -> x[ spos ] <> 0 ), l -> l{ [ 1, spos ] } );
[ [ 120, 1 ], [ 135, 2 ], [ 960, 2 ], [ 1120, 1 ], [ 12096, 1 ] ]
gap> matgroup:= DerivedSubgroup( GeneralOrthogonalGroup( 1, 8, 2 ) );;
gap> points:= NormedRowVectors( GF(2)^8 );;
gap> orbs:= Orbits( matgroup, points );;
gap> List( orbs, Length );
[ 135, 120 ]
gap> g:= Action( matgroup, orbs[2] );;
gap> Size( g );
174182400
gap> pi:= Sum( Irr( t ){ [ 1, 3, 7 ] } );
Character( CharacterTable( "O8+(2)" ), [ 120, 24, 32, 0, 0, 8, 36, 0, 0, 3, 
  6, 12, 4, 8, 0, 0, 0, 10, 0, 0, 12, 0, 0, 8, 0, 0, 3, 6, 0, 0, 2, 0, 0, 2, 
  1, 2, 2, 3, 0, 0, 2, 0, 0, 0, 0, 0, 3, 2, 0, 0, 1, 0, 0 ] )
gap> approx:= ApproxP( prim, spos );;
gap> testpos:= PositionsProperty( approx, x -> x >= 1/3 );
[ 2, 3, 7 ]
gap> AtlasClassNames( t ){ testpos };
[ "2A", "2B", "3A" ]
gap> approx{ testpos };
[ 254/315, 334/315, 1093/1120 ]
gap> ForAll( approx{ testpos }, x -> x > 1/2 );
true
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 15 and NrMovedPoints( g ) = 1 + NrMovedPoints( s );
gap> 3A:= s^5;;
gap> repeat x:= Random( g ); until Order( x ) = 8;
gap> 2A:= x^4;;
gap> repeat x:= Random( g ); until Order( x ) = 12 and
>      NrMovedPoints( g ) = 32 + NrMovedPoints( x^6 );
gap> 2B:= x^6;;
gap> prop15A:= List( [ 2A, 2B, 3A ],
>                    x -> RatioOfNongenerationTransPermGroup( g, x, s ) );
[ 23/35, 29/42, 149/224 ]
gap> Maximum( prop15A );
29/42
gap> test:= List( [ 2A, 2B, 3A ], x -> ConjugacyClass( g, x ) );;
gap> ccl:= ConjugacyClasses( g );;
gap> consider:= Filtered( ccl, c -> Size( c ) in List( test, Size ) );;
gap> Length( consider );
7
gap> filt:= Filtered( ccl, c -> ForAll( consider, cc ->
>       RatioOfNongenerationTransPermGroup( g, Representative( cc ),
>           Representative( c ) ) <= 29/42 ) );;
gap> Length( filt );
3
gap> List( filt, c -> Order( Representative( c ) ) );
[ 15, 15, 15 ]
gap> SizesConjugacyClasses( t );
[ 1, 1575, 3780, 3780, 3780, 56700, 2240, 2240, 2240, 89600, 268800, 37800,
  340200, 907200, 907200, 907200, 2721600, 580608, 580608, 580608, 100800,
  100800, 100800, 604800, 604800, 604800, 806400, 806400, 806400, 806400,
  2419200, 2419200, 2419200, 7257600, 24883200, 5443200, 5443200, 6451200,
  6451200, 6451200, 8709120, 8709120, 8709120, 1209600, 1209600, 1209600,
  4838400, 7257600, 7257600, 7257600, 11612160, 11612160, 11612160 ]
gap> NrPolyhedralSubgroups( t, 2, 2, 2 );
rec( number := 14175, type := "V4" )
gap> repeat x:= Random( g );
>    until     Order( x ) mod 2 = 0
>          and NrMovedPoints( x^( Order(x)/2 ) ) = 120 - 24;
gap> x:= x^( Order(x)/2 );;
gap> repeat y:= x^Random( g );
>    until NrMovedPoints( x*y ) = 120 - 24;
gap> v4:= SubgroupNC( g, [ x, y ] );;
gap> n:= Normalizer( g, v4 );;
gap> Index( g, n );
14175
gap> maxorder:= RepresentativesMaximallyCyclicSubgroups( t );;
gap> maxorderreps:= List( ClassesPerhapsCorrespondingToTableColumns( g, t,
>        maxorder ), Representative );;
gap> Length( maxorderreps );
28
gap> CommonGeneratorWithGivenElements( g, maxorderreps, [ x, y, x*y ] );
fail
gap> reps:= List( ccl, Representative );;
gap> bading:= List( testpos, i -> Filtered( reps,
>        r -> Order( r ) = OrdersClassRepresentatives( t )[i] and
>             NrMovedPoints( r ) = 120 - pi[i] ) );;
gap> List( bading, Length );
[ 1, 1, 1 ]
gap> bading:= List( bading, x -> x[1] );;
gap> for pair in UnorderedTuples( bading, 2 ) do
>      test:= RandomCheckUniformSpread( g, pair, s, 80 );
>      if test <> true then
>        Error( test );
>      fi;
>    od;
gap> matgrp:= SO(1,8,2);;
gap> g2:= Image( IsomorphismPermGroup( matgrp ) );;
gap> IsTransitive( g2, MovedPoints( g2 ) );
true
gap> repeat x:= Random( g2 ); until Order( x ) = 14;
gap> 2F:= x^7;;
gap> Size( ConjugacyClass( g2, 2F ) );
120
gap> der:= DerivedSubgroup( g2 );;
gap> cclreps:= List( ConjugacyClasses( der ), Representative );;
gap> nongen:= List( cclreps,
>               x -> RatioOfNongenerationTransPermGroup( g2, 2F, x ) );;
gap> goodpos:= PositionsProperty( nongen, x -> x < 1 );;
gap> invariants:= List( goodpos, i -> [ Order( cclreps[i] ),
>      Size( Centralizer( g2, cclreps[i] ) ), nongen[i] ] );;
gap> SortedList( invariants );
[ [ 10, 20, 1/3 ], [ 10, 20, 1/3 ], [ 12, 24, 2/5 ], [ 12, 24, 2/5 ],
  [ 15, 15, 0 ], [ 15, 15, 0 ] ]
gap> aut:= Group( AtlasGenerators( "Fi22", 1, 4 ).generators );;
gap> Size( aut ) = 6 * Size( t );
true
gap> g3:= DerivedSubgroup( aut );;
gap> orbs:= Orbits( g3, MovedPoints( g3 ) );;
gap> List( orbs, Length );
[ 3150, 360 ]
gap> g3:= Action( g3, orbs[2] );;
gap> repeat s:= Random( g3 ); until Order( s ) = 15;
gap> repeat x:= Random( g3 ); until Order( x ) = 21;
gap> 3F:= x^7;;
gap> RatioOfNongenerationTransPermGroup( g3, 3F, s );
0
gap> repeat x:= Random( g3 );
>    until Order( x ) = 12 and Size( Centralizer( g3, x^4 ) ) = 648;
gap> 3G:= x^4;;
gap> RatioOfNongenerationTransPermGroup( g3, 3G, s );
0
gap> t2:= CharacterTable( "O8+(2).2" );;
gap> s:= CharacterTable( "S6(2)" ) * CharacterTable( "Cyclic", 2 );;
gap> pi:= PossiblePermutationCharacters( s, t2 );;
gap> prim:= pi;;
gap> pi:= PermChars( t2, rec( torso:= [ 135 ] ) );;
gap> Append( prim, pi );
gap> pi:= PossiblePermutationCharacters( CharacterTable( "A9.2" ), t2 );;
gap> Append( prim, pi );
gap> s:= CharacterTable( "Dihedral(6)" ) * CharacterTable( "U4(2).2" );;
gap> pi:= PossiblePermutationCharacters( s, t2 );;
gap> Append( prim, pi );
gap> s:= CharacterTableWreathSymmetric( CharacterTable( "S5" ), 2 );;
gap> pi:= PossiblePermutationCharacters( s, t2 );;
gap> Append( prim, pi );
gap> Length( prim );
5
gap> ord15:= PositionsProperty( OrdersClassRepresentatives( t2 ),
>                               x -> x = 15 );
[ 39, 40 ]
gap> List( prim, pi -> pi{ ord15 } );
[ [ 1, 0 ], [ 2, 0 ], [ 2, 0 ], [ 1, 0 ], [ 1, 0 ] ]
gap> List( ord15, i -> Maximum( ApproxP( prim, i ) ) );
[ 307/120, 0 ]
gap> CleanWorkspace();
gap> t:= CharacterTable( "O8+(3)" );;
gap> ProbGenInfoSimple( t );
[ "O8+(3)", 863/1820, 2, [ "20A", "20B", "20C" ], [ 8, 8, 8 ] ]
gap> prim:= PrimitivePermutationCharacters( t );;
gap> ord:= OrdersClassRepresentatives( t );;
gap> spos:= Position( ord, 20 );;
gap> filt:= PositionsProperty( prim, x -> x[ spos ] <> 0 );
[ 1, 2, 7, 15, 18, 19, 24 ]
gap> Maxes( t ){ filt };
[ "O7(3)", "O8+(3)M2", "3^6:L4(3)", "2.U4(3).(2^2)_{122}", "(A4xU4(2)):2", 
  "O8+(3)M19", "(A6xA6):2^2" ]
gap> prim{ filt }{ [ 1, spos ] };
[ [ 1080, 1 ], [ 1080, 1 ], [ 1120, 2 ], [ 189540, 1 ], [ 7960680, 1 ], 
  [ 7960680, 1 ], [ 9552816, 1 ] ]
gap> ord:= OrdersClassRepresentatives( t );;
gap> ord20:= PositionsProperty( ord, x -> x = 20 );;
gap> cand:= [];;
gap> for i in ord20 do
>      approx:= ApproxP( prim, i );
>      Add( cand, PositionsProperty( approx, x -> x >= 1/3 ) );
>    od;
gap> cand;
[ [ 2, 6, 7, 10 ], [ 3, 6, 8, 11 ], [ 4, 6, 9, 12 ] ]
gap> AtlasClassNames( t ){ cand[1] };
[ "2A", "3A", "3B", "3E" ]
gap> t3:= CharacterTable( "O8+(3).3" );;
gap> tfust3:= GetFusionMap( t, t3 );;
gap> List( cand, x -> tfust3{ x } );
[ [ 2, 4, 5, 6 ], [ 2, 4, 5, 6 ], [ 2, 4, 5, 6 ] ]
gap> g:= Action( SO(1,8,3), NormedRowVectors( GF(3)^8 ), OnLines );;
gap> Size( g );
9904359628800
gap> g:= DerivedSubgroup( g );;  Size( g );
4952179814400
gap> orbs:= Orbits( g, MovedPoints( g ) );;
gap> List( orbs, Length );
[ 1080, 1080, 1120 ]
gap> g:= Action( g, orbs[1] );;
gap> PositionProperty( Irr( t ), chi -> chi[1] = 819 );
9
gap> permchar:= Sum( Irr( t ){ [ 1, 2, 9 ] } );
Character( CharacterTable( "O8+(3)" ), [ 1080, 128, 0, 0, 24, 108, 135, 0, 0, 
  108, 0, 0, 27, 27, 0, 0, 18, 9, 12, 16, 0, 0, 4, 15, 0, 0, 20, 0, 0, 12, 
  11, 0, 0, 20, 0, 0, 15, 0, 0, 12, 0, 0, 2, 0, 0, 3, 3, 0, 0, 6, 6, 0, 0, 3, 
  2, 2, 2, 18, 0, 0, 9, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 3, 0, 0, 12, 0, 0, 3, 
  0, 0, 0, 0, 0, 4, 3, 3, 0, 0, 1, 0, 0, 4, 0, 0, 1, 1, 2, 0, 0, 0, 0, 0, 3, 
  0, 0, 2, 0, 0, 5, 0, 0, 1, 0, 0 ] )
gap> permchar{ ord20 };
[ 1, 0, 0 ]
gap> AtlasClassNames( t )[ PowerMap( t, 10 )[ ord20[1] ] ];
"2A"
gap> ord18:= PositionsProperty( ord, x -> x = 18 );;
gap> Set( AtlasClassNames( t ){ PowerMap( t, 6 ){ ord18 } } );
[ "3A" ]
gap> ord15:= PositionsProperty( ord, x -> x = 15 );;
gap> PowerMap( t, 5 ){ ord15 };
[ 7, 8, 9, 10, 11, 12 ]
gap> AtlasClassNames( t ){ [ 7 .. 12 ] };
[ "3B", "3C", "3D", "3E", "3F", "3G" ]
gap> permchar{ [ 7 .. 12 ] };
[ 135, 0, 0, 108, 0, 0 ]
gap> mp:= NrMovedPoints( g );;
gap> ResetGlobalRandomNumberGenerators();
gap> repeat 20A:= Random( g );
>    until Order( 20A ) = 20 and mp - NrMovedPoints( 20A ) = 1;
gap> 2A:= 20A^10;;
gap> repeat x:= Random( g ); until Order( x ) = 18;
gap> 3A:= x^6;;
gap> repeat x:= Random( g );
>    until Order( x ) = 15 and mp - NrMovedPoints( x^5 ) = 135;
gap> 3B:= x^5;;
gap> repeat x:= Random( g );
>    until Order( x ) = 15 and mp - NrMovedPoints( x^5 ) = 108;
gap> 3E:= x^5;;
gap> nongen:= List( [ 2A, 3A, 3B, 3E ],
>                   c -> RatioOfNongenerationTransPermGroup( g, c, 20A ) );
[ 3901/9477, 194/455, 451/1092, 451/1092 ]
gap> Maximum( nongen );
194/455
gap> maxorder:= RepresentativesMaximallyCyclicSubgroups( t );;
gap> Length( maxorder );
57
gap> autt:= CharacterTable( "O8+(3).S4" );;
gap> fus:= PossibleClassFusions( t, autt );;
gap> orbreps:= Set( List( fus, map -> Set( ProjectionMap( map ) ) ) );
[ [ 1, 2, 5, 6, 7, 13, 17, 18, 19, 20, 23, 24, 27, 30, 31, 37, 43, 46, 50, 
      54, 55, 56, 57, 58, 64, 68, 72, 75, 78, 84, 85, 89, 95, 96, 97, 100, 
      106, 112 ] ]
gap> totest:= Intersection( maxorder, orbreps[1] );
[ 43, 50, 54, 56, 57, 64, 68, 75, 78, 84, 85, 89, 95, 97, 100, 106, 112 ]
gap> Length( totest );
17
gap> AtlasClassNames( t ){ totest };
[ "6Q", "6X", "6B1", "8A", "8B", "9G", "9K", "12A", "12D", "12J", "12K", 
  "12O", "13A", "14A", "15A", "18A", "20A" ]
gap> elementstotest:= [];;
gap> for elord in [ 13, 14, 15, 18 ] do
>      repeat s:= Random( g );
>      until Order( s ) = elord;
>      Add( elementstotest, s );
>    od;
gap> ordcent:= [ [ 6, 162 ], [ 9, 729 ], [ 9, 81 ], [ 12, 1728 ],
>                [ 12, 432 ], [ 12, 192 ], [ 12, 108 ], [ 12, 72 ] ];;
gap> cents:= SizesCentralizers( t );;
gap> for pair in ordcent do
>      Print( pair, ": ", AtlasClassNames( t ){
>          Filtered( [ 1 .. Length( ord ) ],
>                    i -> ord[i] = pair[1] and cents[i] = pair[2] ) }, "\n" );
>      repeat s:= Random( g );
>      until Order( s ) = pair[1] and Size( Centralizer( g, s ) ) = pair[2];
>      Add( elementstotest, s );
>    od;
[ 6, 162 ]: [ "6B1" ]
[ 9, 729 ]: [ "9G", "9H", "9I", "9J" ]
[ 9, 81 ]: [ "9K", "9L", "9M", "9N" ]
[ 12, 1728 ]: [ "12A", "12B", "12C" ]
[ 12, 432 ]: [ "12D", "12E", "12F", "12G", "12H", "12I" ]
[ 12, 192 ]: [ "12J" ]
[ 12, 108 ]: [ "12K", "12L", "12M", "12N" ]
[ 12, 72 ]: [ "12O", "12P", "12Q", "12R", "12S", "12T" ]
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> cents[i] = 648 and cents[ PowerMap( t, 2 )[i] ] = 52488
>                            and cents[ PowerMap( t, 3 )[i] ] = 26127360 ) };
[ "6Q", "6R", "6S" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 6 and Size( Centralizer( g, s ) ) = 648
>      and Size( Centralizer( g, s^2 ) ) = 52488
>      and Size( Centralizer( g, s^3 ) ) = 26127360;
gap> Add( elementstotest, s );
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> cents[i] = 648 and cents[ PowerMap( t, 2 )[i] ] = 52488
>                            and cents[ PowerMap( t, 3 )[i] ] = 331776 ) };
[ "6X", "6Y", "6Z", "6A1" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 6 and Size( Centralizer( g, s ) ) = 648
>      and Size( Centralizer( g, s^2 ) ) = 52488
>      and Size( Centralizer( g, s^3 ) ) = 331776;
gap> Add( elementstotest, s );
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> ord[i] = 8 and cents[ PowerMap( t, 2 )[i] ] = 13824 ) };
[ "8A" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 8 and Size( Centralizer( g, s^2 ) ) = 13824;
gap> Add( elementstotest, s );
gap> AtlasClassNames( t ){ Filtered( [ 1 .. Length( ord ) ],
>        i -> ord[i] = 8 and cents[ PowerMap( t, 2 )[i] ] = 1536 ) };
[ "8B" ]
gap> repeat s:= Random( g );
>    until Order( s ) = 8 and Size( Centralizer( g, s^2 ) ) = 1536;
gap> Add( elementstotest, s );
gap> nongen:= List( elementstotest,
>                   s -> RatioOfNongenerationTransPermGroup( g, 3A, s ) );;
gap> smaller:= PositionsProperty( nongen, x -> x < 194/455 );
[ 2, 3 ]
gap> nongen{ smaller };
[ 127/325, 1453/3640 ]
gap> repeat s:= Random( g );
>    until Order( s ) = 14 and NrMovedPoints( s ) = 1078;
gap> 2A:= s^7;;
gap> nongen:= RatioOfNongenerationTransPermGroup( g, 2A, s );
1573/3645
gap> nongen > 194/455;
true
gap> repeat s:= Random( g );
>    until Order( s ) = 15 and NrMovedPoints( s ) = 1080 - 3;
gap> nongen:= RatioOfNongenerationTransPermGroup( g, 2A, s );
490/1053
gap> nongen > 194/455;
true
gap> for tup in UnorderedTuples( [ 2A, 3A, 3B, 3E ], 3 ) do
>      cl:= ShallowCopy( tup );
>      test:= RandomCheckUniformSpread( g, cl, 20A, 100 );
>      if test <> true then
>        Error( test );
>      fi;
>    od;
gap> der:= DerivedSubgroup( SO(1,8,3) );;
gap> repeat x:= PseudoRandom( der ); until Order( x ) = 40;
gap> 40 in ord;
false
gap> u42:= CharacterTable( "U4(2)" );;
gap> Filtered( OrdersClassRepresentatives( u42 ), x -> x mod 5 = 0 );
[ 5 ]
gap> u:= CharacterTable( Maxes( t )[18] );
CharacterTable( "(A4xU4(2)):2" )
gap> 2u42:= CharacterTable( "2.U4(2)" );;
gap> OrdersClassRepresentatives( 2u42 )[4];
4
gap> GetFusionMap( 2u42, u42 )[4];
3
gap> OrdersClassRepresentatives( u42 )[3];
2
gap> List( PossibleClassFusions( u42, u ), x -> x[3] );
[ 8 ]
gap> PositionsProperty( SizesConjugacyClasses( u ), x -> x = 3 );
[ 2 ]
gap> ForAll( PossibleClassFusions( u, t ), x -> x[2] = x[8] );
true
gap> u:= CharacterTable( Maxes( t )[24] );
CharacterTable( "(A6xA6):2^2" )
gap> ClassPositionsOfDerivedSubgroup( u );
[ 1 .. 22 ]
gap> PositionsProperty( OrdersClassRepresentatives( u ), x -> x = 20 );
[ 8 ]
gap> List( ClassPositionsOfNormalSubgroups( u ),
>          x -> Sum( SizesConjugacyClasses( u ){ x } ) );
[ 1, 129600, 259200, 259200, 259200, 518400 ]
gap> t2:= CharacterTable( "O8+(3).2_1" );;
gap> ord20:= PositionsProperty( OrdersClassRepresentatives( t2 ),
>                x -> x = 20 );;
gap> ord20:= Intersection( ord20, ClassPositionsOfDerivedSubgroup( t2 ) );
[ 84, 85, 86 ]
gap> List( ord20, x -> x in PowerMap( t2, 2 ) );
[ false, true, true ]
gap> tfust2:= GetFusionMap( t, t2 );;
gap> tfust2{ PositionsProperty( OrdersClassRepresentatives( t ),
>                x -> x = 20 ) };
[ 84, 85, 86 ]
gap> primt2:= [];;
gap> poss:= PossiblePermutationCharacters( CharacterTable( "O7(3)" ), t );;
gap> invfus:= InverseMap( tfust2 );;
gap> List( poss, pi -> ForAll( CompositionMaps( pi, invfus ), IsInt ) );
[ false, false, false, false, true, true ]
gap> PossiblePermutationCharacters(
>        CharacterTable( "O7(3)" ) * CharacterTable( "Cyclic", 2 ), t2 );
[  ]
gap> ext:= PossiblePermutationCharacters( CharacterTable( "O7(3).2" ), t2 );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 1, 0, 0 ], [ 1, 0, 0 ] ]
gap> Append( primt2, ext );
gap> ext:= PossiblePermutationCharacters( CharacterTable( "L4(3).2^2" ), t2 );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 0, 0, 1 ], [ 0, 1, 0 ] ]
gap> Append( primt2, ext );
gap> List( PossiblePermutationCharacters( CharacterTable( "L4(3).2_2" ) *
>              CharacterTable( "Cyclic", 2 ), t2 ), pi -> pi{ ord20 } );
[ [ 1, 0, 0 ] ]
gap> ext:= PermChars( t2, rec( torso:= [ 1120 ] ) );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 2, 0, 0 ], [ 0, 0, 2 ], [ 0, 2, 0 ] ]
gap> Append( primt2, ext );
gap> filt:= Filtered( prim, x -> x[1] = 189540 );;
gap> cand:= List( filt, x -> CompositionMaps( x, invfus ) );;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
gap> Append( primt2, ext );
gap> ext:= PossiblePermutationCharacters( CharacterTable( "Symmetric", 4 ) *
>              CharacterTable( "U4(2).2" ), t2 );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0, 0 ], [ 1, 0, 0 ] ]
gap> Append( primt2, ext );
gap> filt:= Filtered( prim, x -> x[1] = 9552816 );;
gap> cand:= List( filt, x -> CompositionMaps( x, InverseMap( tfust2 ) ));;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
gap> Append( primt2, ext );
gap> Length( primt2 );
15
gap> approx:= List( ord20, x -> ApproxP( primt2, x ) );;
gap> outer:= Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) );;
gap> List( approx, l -> Maximum( l{ outer } ) );
[ 574/1215, 83/567, 83/567 ]
gap> t2:= CharacterTable( "O8+(3).2_2" );;
gap> ord20:= PositionsProperty( OrdersClassRepresentatives( t2 ),
>                x -> x = 20 );;
gap> ord20:= Intersection( ord20, ClassPositionsOfDerivedSubgroup( t2 ) );
[ 82, 83 ]
gap> tfust2:= GetFusionMap( t, t2 );;
gap> tfust2{ PositionsProperty( OrdersClassRepresentatives( t ),
>                x -> x = 20 ) };
[ 82, 83, 83 ]
gap> primt2:= [];;
gap> ext:= PermChars( t2, rec( torso:= [ 1080 ] ) );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 1, 0 ], [ 1, 0 ] ]
gap> Append( primt2, ext );
gap> ext:= PermChars( t2, rec( torso:= [ 1120 ] ) );;
gap> List( ext, pi -> pi{ ord20 } );
[ [ 2, 0 ] ]
gap> Append( primt2, ext );
gap> filt:= Filtered( prim, x -> x[1] = 189540 );;
gap> cand:= List( filt, x -> CompositionMaps( x, InverseMap( tfust2 ) ));;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0 ] ]
gap> Append( primt2, ext );
gap> filt:= Filtered( prim, x -> x[1] = 7960680 );;
gap> cand:= List( filt, x -> CompositionMaps( x, InverseMap( tfust2 ) ));;
gap> ext:= Concatenation( List( cand,
>              pi -> PermChars( t2, rec( torso:= pi ) ) ) );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0 ], [ 1, 0 ] ]
gap> Append( primt2, ext );
gap> ext:= PossiblePermutationCharacters( CharacterTableWreathSymmetric(
>              CharacterTable( "S6" ), 2 ), t2 );;
gap> List( ext, x -> x{ ord20 } );
[ [ 1, 0 ] ]
gap> Append( primt2, ext );
gap> Length( primt2 );
7
gap> approx:= List( ord20, x -> ApproxP( primt2, x ) );;
gap> outer:= Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) );;
gap> List( approx, l -> Maximum( l{ outer } ) );
[ 14/9, 0 ]
gap> approx:= ApproxP( primt2, ord20[1] );;
gap> bad:= Filtered( outer, i -> approx[i] >= 1/2 );
[ 84 ]
gap> OrdersClassRepresentatives( t2 ){ bad };
[ 2 ]
gap> SizesConjugacyClasses( t2 ){ bad };
[ 1080 ]
gap> Number( SizesConjugacyClasses( t2 ), x -> x = 1080 );
1
gap> go:= GO(1,8,3);;
gap> so:= SO(1,8,3);;
gap> outerelm:= First( GeneratorsOfGroup( go ), x -> not x in so );;
gap> g2:= ClosureGroup( DerivedSubgroup( so ), outerelm );;
gap> Size( g2 );
19808719257600
gap> dom:= NormedVectors( GF(3)^8 );;
gap> orbs:= Orbits( g2, dom, OnLines );;
gap> List( orbs, Length );
[ 1080, 1080, 1120 ]
gap> act:= Action( g2, orbs[1], OnLines );;
gap> Order( outerelm );
26
gap> g:= Permutation( outerelm^13, orbs[1], OnLines );;
gap> Size( ConjugacyClass( act, g ) );
1080
gap> ord20;
[ 82, 83 ]
gap> SizesCentralizers( t2 ){ ord20 };
[ 40, 20 ]
gap> der:= DerivedSubgroup( act );;
gap> repeat 20A:= Random( der );
>    until Order( 20A ) = 20 and Size( Centralizer( act, 20A ) ) = 40;
gap> RatioOfNongenerationTransPermGroup( act, g, 20A );
1
gap> repeat 20BC:= Random( der );
>    until Order( 20BC ) = 20 and Size( Centralizer( act, 20BC ) ) = 20;
gap> RatioOfNongenerationTransPermGroup( act, g, 20BC );
0
gap> ccl:= ConjugacyClasses( act );;
gap> der:= DerivedSubgroup( act );;
gap> reps:= Filtered( List( ccl, Representative ), x -> x in der );;
gap> Length( reps );
83
gap> ratios:= List( reps,
>                   s -> RatioOfNongenerationTransPermGroup( act, g, s ) );;
gap> cand:= PositionsProperty( ratios, x -> x < 1 );;
gap> ratios:= ratios{ cand };;
gap> SortParallel( ratios, cand );
gap> ratios;
[ 0, 1/10, 1/10, 16/135, 1/3, 1/3, 11/27, 7/15, 7/15 ]
gap> invs:= List( cand,
>       x -> [ Order( reps[x] ), Size( Centralizer( der, reps[x] ) ) ] );
[ [ 20, 20 ], [ 18, 108 ], [ 18, 108 ], [ 14, 28 ], [ 15, 45 ], [ 15, 45 ], 
  [ 10, 40 ], [ 12, 72 ], [ 12, 72 ] ]
gap> t3:= CharacterTable( "O8+(3).3" );;
gap> tfust3:= GetFusionMap( t, t3 );;
gap> inv:= InverseMap( tfust3 );;
gap> filt:= PositionsProperty( prim, x -> x[ spos ] <> 0 );;
gap> ForAll( prim{ filt },
>            pi -> ForAny( CompositionMaps( pi, inv ), IsList ) );
true
gap> outer:= Difference( [ 1 .. NrConjugacyClasses( t3 ) ],
>                ClassPositionsOfDerivedSubgroup( t3 ) );
[ 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 
  72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 
  91, 92, 93, 94 ]
gap> Set( OrdersClassRepresentatives( t3 ){ outer } );      
[ 3, 6, 9, 12, 18, 21, 24, 27, 36, 39 ]
gap> CleanWorkspace();
gap> q:= 4;;  n:= 8;;
gap> G:= DerivedSubgroup( SO( 1, n, q ) );;
gap> points:= NormedRowVectors( GF(q)^n );;
gap> orbs:= Orbits( G, points, OnLines );;
gap> List( orbs, Length );
[ 5525, 16320 ]
gap> hom:= ActionHomomorphism( G, orbs[1], OnLines );;
gap> G:= Image( hom );;
gap> Collected( Factors( Size( G ) ) );
[ [ 2, 24 ], [ 3, 5 ], [ 5, 4 ], [ 7, 1 ], [ 13, 1 ], [ 17, 2 ] ]
gap> ResetGlobalRandomNumberGenerators();
gap> repeat x:= Random( G );
>    until Order( x ) mod 13 = 0;
gap> x:= x^( Order( x ) / 13 );;
gap> c:= Centralizer( G, x );;
gap> IsAbelian( c );  AbelianInvariants( c );
true
[ 5, 5, 13 ]
gap> t:= CharacterTable( "S6(4)" );;
gap> ord65:= PositionsProperty( OrdersClassRepresentatives( t ),
>                               x -> x = 65 );
[ 105, 106, 107, 108, 109, 110, 111, 112 ]
gap> ord65 = ClassOrbit( t, ord65[1] );
true
gap> t:= CharacterTable( "U4(4)" );;
gap> ords:= OrdersClassRepresentatives( t );;
gap> ord65:= PositionsProperty( ords, x -> x = 65 );;
gap> ord65 = ClassOrbit( t, ord65[1] );
true
gap> syl5:= SylowSubgroup( c, 5 );;
gap> elms:= Filtered( Elements( syl5 ), y -> Order( y ) = 5 );;
gap> reps:= Set( List( elms, SmallestGeneratorPerm ) );;  Length( reps );
6
gap> reps65:= List( reps, y -> SubgroupNC( G, [ y * x ] ) );;
gap> pairs:= Filtered( UnorderedTuples( [ 1 .. 6 ], 2 ),
>                      p -> p[1] <> p[2] );;
gap> ForAny( pairs, p -> IsConjugate( G, reps65[ p[1] ], reps65[ p[2] ] ) );
false
gap> cand:= List( reps, y -> Normalizer( G, SubgroupNC( G, [ y ] ) ) );;
gap> cand:= Filtered( cand, y -> Size( y ) = 10 * Size( t ) );;
gap> Length( cand );
3
gap> norms:= List( reps65, y -> Normalizer( G, y ) );;
gap> ForAll( norms, y -> ForAll( cand, M -> IsSubset( M, y ) ) );
true
gap> syl5:= SylowSubgroup( cand[1], 5 );;
gap> Size( syl5 );  IsElementaryAbelian( syl5 );
625
true
gap> UpperBoundFixedPointRatios( G, List( cand, ConjugacyClasses ), false );
[ 34817/1645056, false ]
gap> frob:= PermList( List( orbs[1], v -> Position( orbs[1],
>              List( v, x -> x^2 ) ) ) );;
gap> G2:= ClosureGroupDefault( G, frob );;
gap> cand2:= List( cand, M -> Normalizer( G2, M ) );;
gap> ccl:= List( cand2,
>                M2 -> PcConjugacyClassReps( SylowSubgroup( M2, 2 ) ) );;
gap> List( ccl, l -> Number( l, x -> Order( x ) = 2 and not x in G ) );
[ 0, 0, 0 ]
gap> CleanWorkspace();
gap> g:= SO( 9, 3 );;
gap> g:= DerivedSubgroup( g );;
gap> Size( g );
65784756654489600
gap> orbs:= Orbits( g, NormedRowVectors( GF(3)^9 ), OnLines );;
gap> List( orbs, Length ) / 41;
[ 3240/41, 81, 80 ]
gap> Size( SO( 9, 3 ) ) / Size( GO( -1, 8, 3 ) );
3240
gap> t:= CharacterTable( "O9(3)" );;
gap> pi:= PermChars( t, rec( torso:= [ 3240 ] ) );
[ Character( CharacterTable( "O9(3)" ), [ 3240, 1080, 380, 132, 48, 324, 378,
      351, 0, 0, 54, 27, 54, 27, 0, 118, 0, 36, 46, 18, 12, 2, 8, 45, 0, 108,
      108, 135, 126, 0, 0, 56, 0, 0, 36, 47, 38, 27, 39, 36, 24, 12, 18, 18,
      15, 24, 2, 18, 15, 9, 0, 0, 0, 2, 0, 18, 11, 3, 9, 6, 6, 9, 6, 3, 6, 3,
      0, 6, 16, 0, 4, 6, 2, 45, 36, 0, 0, 0, 0, 0, 0, 0, 9, 9, 6, 3, 0, 0,
      15, 13, 0, 5, 7, 36, 0, 10, 0, 10, 19, 6, 15, 0, 0, 0, 0, 12, 3, 10, 0,
      3, 3, 7, 0, 6, 6, 2, 8, 0, 4, 0, 2, 0, 1, 3, 0, 0, 3, 0, 3, 2, 2, 3, 3,
      6, 2, 2, 9, 6, 3, 0, 0, 18, 9, 0, 0, 12, 0, 0, 8, 0, 6, 9, 5, 0, 0, 0,
      0, 0, 0, 0, 0, 3, 3, 3, 2, 1, 3, 3, 1, 0, 0, 4, 1, 0, 0, 1, 0, 3, 3, 1,
      1, 2, 2, 0, 0, 1, 3, 4, 0, 1, 2, 0, 0, 1, 0, 4, 1, 0, 0, 0, 0, 1, 0, 0,
      1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0 ] ) ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 41 );
208
gap> approx:= ApproxP( pi, spos );;
gap> Maximum( approx );
1/3
gap> PositionsProperty( approx, x -> x = 1/3 );
[ 2 ]
gap> SizesConjugacyClasses( t )[2];
3321
gap> OrdersClassRepresentatives( t )[2];
2
gap> g:= Action( g, orbs[1], OnLines );;
gap> repeat
>      repeat x:= Random( g ); ord:= Order( x ); until ord mod 2 = 0;
>      y:= x^(ord/2);
> until NrMovedPoints( y ) = 3240 - 1080;
gap> fp:= Difference( MovedPoints( g ), MovedPoints( y ) );;
gap> orb:= Orbit( g, fp, OnSets );;
gap> ForAny( orb, l -> IsEmpty( Intersection( l, fp ) ) );
false
gap> Size( GO(5,9) ) / 61;
6886425600/61
gap> t:= CharacterTable( "O10-(3)" );  s:= CharacterTable( "U5(3)" );
CharacterTable( "O10-(3)" )
CharacterTable( "U5(3)" )
gap> SigmaFromMaxes( t, "61A", [ s ], [ 1 ] );
1/1066
gap> m:= SU(5,3);;
gap> so:= SO(-1,10,3);;
gap> omega:= DerivedSubgroup( so );;
gap> om:= InvariantBilinearForm( so ).matrix;;
gap> Display( om );
 . 1 . . . . . . . .
 1 . . . . . . . . .
 . . 1 . . . . . . .
 . . . 2 . . . . . .
 . . . . 2 . . . . .
 . . . . . 2 . . . .
 . . . . . . 2 . . .
 . . . . . . . 2 . .
 . . . . . . . . 2 .
 . . . . . . . . . 2
gap> b:= Basis( GF(9), [ Z(3)^0, Z(3^2)^2 ] );
Basis( GF(3^2), [ Z(3)^0, Z(3^2)^2 ] )
gap> blow:= List( GeneratorsOfGroup( m ), x -> BlownUpMat( b, x ) );;
gap> form:= BlownUpMat( b, InvariantSesquilinearForm( m ).matrix );;
gap> ForAll( blow, x -> x * form * TransposedMat( x ) = form );
true
gap> Display( form );
 . . . . . . . . 1 .
 . . . . . . . . . 1
 . . . . . . 1 . . .
 . . . . . . . 1 . .
 . . . . 1 . . . . .
 . . . . . 1 . . . .
 . . 1 . . . . . . .
 . . . 1 . . . . . .
 1 . . . . . . . . .
 . 1 . . . . . . . .
gap> T1:= IdentityMat( 10, GF(3) );;
gap> T1{[1..3]}{[1..3]}:= [[1,1,0],[1,-1,1],[1,-1,-1]]*Z(3)^0;;
gap> pi:= PermutationMat( (1,10)(3,8), 10, GF(3) );;
gap> tr:= NullMat( 10,10,GF(3) );;
gap> tr{[1, 2]}{[1, 2]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[3, 4]}{[3, 4]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[7, 8]}{[7, 8]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[9,10]}{[9,10]}:= [[1,1],[1,-1]]*Z(3)^0;;
gap> tr{[5, 6]}{[5, 6]}:= [[1,0],[0,1]]*Z(3)^0;;
gap> tr2:= IdentityMat( 10,GF(3) );;
gap> tr2{[1,3]}{[1,3]}:= [[-1,1],[1,1]]*Z(3)^0;;
gap> tr2{[7,9]}{[7,9]}:= [[-1,1],[1,1]]*Z(3)^0;;
gap> T2:= tr2 * tr * pi;;
gap> D:= T1^-1 * T2;;
gap> tblow:= List( blow, x -> D * x * D^-1 );;
gap> IsSubset( omega, tblow );
true
gap> orbs:= Orbits( omega, NormedRowVectors( GF(3)^10 ), OnLines );;
gap> List( orbs, Length );
[ 9882, 9882, 9760 ]
gap> permgrp:= Action( omega, orbs[3], OnLines );;
gap> M:= SubgroupNC( permgrp,
>            List( tblow, x -> Permutation( x, orbs[3], OnLines ) ) );;
gap> ccl:= ClassesOfPrimeOrder( M, Set( Factors( Size( M ) ) ),
>                               TrivialSubgroup( M ) );;
gap> UpperBoundFixedPointRatios( permgrp, [ ccl ], false );
[ 1/1066, true ]
gap> CleanWorkspace();
gap> o:= SO(-1,14,2);;
gap> g:= SU(7,2);;
gap> b:= Basis( GF(4) );;
gap> blow:= List( GeneratorsOfGroup( g ), x -> BlownUpMat( b, x ) );;
gap> form:= NullMat( 14, 14, GF(2) );;
gap> for i in [ 1 .. 14 ] do form[i][ 15-i ]:= Z(2); od;
gap> ForAll( blow, x -> x * form * TransposedMat( x ) = form );
true
gap> pi:= PermutationMat( (1,13)(3,11)(5,9), 14, GF(2) );;
gap> pi * form * TransposedMat( pi ) = InvariantBilinearForm( o ).matrix;
true
gap> pi2:= PermutationMat( (7,3)(8,4), 14, GF(2) );;
gap> D:= pi2 * pi;;
gap> tblow:= List( blow, x -> D * x * D^-1 );;
gap> IsSubset( o, tblow );
true
gap> omega:= DerivedSubgroup( o );;
gap> IsSubset( omega, tblow );
true
gap> z:= Z(4) * One( g );;
gap> tz:= D * BlownUpMat( b, z ) * D^-1;;
gap> tz in omega;
true
gap> orbs:= Orbits( omega, NormedVectors( GF(2)^14 ), OnLines );;
gap> List( orbs, Length );
[ 8127, 8256 ]
gap> omega:= Action( omega, orbs[1], OnLines );;
gap> gens:= List( GeneratorsOfGroup( g ),
>             x -> Permutation( D * BlownUpMat( b, x ) * D^-1, orbs[1] ) );;
gap> g:= Group( gens );;
gap> ccl:= ClassesOfPrimeOrder( g, Set( Factors( Size( g ) ) ),
>                               TrivialSubgroup( g ) );;
gap> tz:= Permutation( tz, orbs[1] );;
gap> primereps:= List( ccl, Representative );;
gap> Add( primereps, () );
gap> reps:= Concatenation( List( primereps,
>               x -> List( [ 0 .. 2 ], i -> x * tz^i ) ) );;
gap> primereps:= Filtered( reps, x -> IsPrimeInt( Order( x ) ) );;
gap> Length( primereps );
48
gap> M:= ClosureGroup( g, tz );;
gap> bccl:= List( primereps, x -> ConjugacyClass( M, x ) );;
gap> UpperBoundFixedPointRatios( omega, [ bccl ], false );
[ 1/2015, true ]
gap> CleanWorkspace();
gap> so:= SO(+1,12,3);;
gap> Display( InvariantBilinearForm( so ).matrix );
 . 1 . . . . . . . . . .
 1 . . . . . . . . . . .
 . . 1 . . . . . . . . .
 . . . 2 . . . . . . . .
 . . . . 2 . . . . . . .
 . . . . . 2 . . . . . .
 . . . . . . 2 . . . . .
 . . . . . . . 2 . . . .
 . . . . . . . . 2 . . .
 . . . . . . . . . 2 . .
 . . . . . . . . . . 2 .
 . . . . . . . . . . . 2
gap> g:= GO(+1,6,9);;
gap> Z(9)^2 = Z(3)^0 + Z(9);
true
gap> b:= Basis( GF(9), [ Z(3)^0, Z(9) ] );
Basis( GF(3^2), [ Z(3)^0, Z(3^2) ] )
gap> blow:= List( GeneratorsOfGroup( g ), x -> BlownUpMat( b, x ) );;
gap> m:= BlownUpMat( b, InvariantBilinearForm( g ).matrix );;
gap> Display( m );
 . . 1 . . . . . . . . .
 . . . 1 . . . . . . . .
 1 . . . . . . . . . . .
 . 1 . . . . . . . . . .
 . . . . 2 . . . . . . .
 . . . . . 2 . . . . . .
 . . . . . . 2 . . . . .
 . . . . . . . 2 . . . .
 . . . . . . . . 2 . . .
 . . . . . . . . . 2 . .
 . . . . . . . . . . 2 .
 . . . . . . . . . . . 2
gap> pi:= PermutationMat( (2,3), 12, GF(3) );;
gap> tr:= IdentityMat( 12, GF(3) );;
gap> tr{[3,4]}{[3,4]}:= [[1,-1],[1,1]]*Z(3)^0;;
gap> D:= tr * pi;;
gap> D * m * TransposedMat( D ) = InvariantBilinearForm( so ).matrix;
true
gap> tblow:= List( blow, x -> D * x * D^-1 );;
gap> IsSubset( so, tblow );
true
gap> orbs:= Orbits( so, NormedVectors( GF(3)^12 ), OnLines );;
gap> List( orbs, Length );
[ 88452, 88452, 88816 ]
gap> act:= Action( so, orbs[1], OnLines );;
gap> SetSize( act, Size( so ) / 2 );
gap> u:= SubgroupNC( act,
>            List( tblow, x -> Permutation( x, orbs[1], OnLines ) ) );;
gap> n:= Normalizer( act, u );;
gap> Size( n ) / Size( u );
2
gap> norbs:= Orbits( n, MovedPoints( n ) );;
gap> List( norbs, Length );
[ 58968, 29484 ]
gap> hom:= ActionHomomorphism( n, norbs[2] );;
gap> nact:= Image( hom );;
gap> Size( nact ) = Size( n );
true
gap> ccl:= ClassesOfPrimeOrder( nact, Set( Factors( Size( nact ) ) ),
>                               TrivialSubgroup( nact ) );;
gap> Length( ccl );
26
gap> preim:= List( ccl,
>        x -> PreImagesRepresentative( hom, Representative( x ) ) );;
gap> pccl:= List( preim, x -> ConjugacyClass( n, x ) );;
gap> for i in [ 1 .. Length( pccl ) ] do
>      SetSize( pccl[i], Size( ccl[i] ) );
>    od;
gap> UpperBoundFixedPointRatios( act, [ pccl ], false );
[ 2/88209, true ]
gap> sp:= SP(4,8);;
gap> Display( InvariantBilinearForm( sp ).matrix );
 . . . 1
 . . 1 .
 . 1 . .
 1 . . .
gap> z:= Z(64);;
gap> f:= AsField( GF(8), GF(64) );;
gap> repeat
>      b:= Basis( f, [ z, z^8 ] );
>      z:= z * Z(64);
> until b <> fail;
gap> sub:= SP(2,64);;
gap> Display( InvariantBilinearForm( sub ).matrix );
 . 1
 1 .
gap> ext:= Group( List( GeneratorsOfGroup( sub ),
>                       x -> BlownUpMat( b, x ) ) );;
gap> tr:= PermutationMat( (3,4), 4, GF(2) );;
gap> conj:= ConjugateGroup( ext, tr );;
gap> IsSubset( sp, conj );
true
gap> inv:= [[0,1,0,0],[1,0,0,0],[0,0,0,1],[0,0,1,0]] * Z(2);;
gap> inv in sp;
true
gap> inv in conj;
false
gap> Length( NullspaceMat( inv - inv^0 ) );
2
gap> so:= SO(-1,4,8);;
gap> der:= DerivedSubgroup( so );;
gap> x:= First( GeneratorsOfGroup( so ), x -> not x in der );;
gap> x:= x^( Order(x)/2 );;
gap> Length( NullspaceMat( x - x^0 ) );
3
gap> CharacterTable( "L2(64).2" );
fail
gap> t:= CharacterTable( "S4(8)" );;
gap> degree:= Size( t ) / ( 2 * Size( SL(2,64) ) );;
gap> pi:= PermChars( t, rec( torso:= [ degree ] ) );
[ Character( CharacterTable( "S4(8)" ), [ 2016, 0, 256, 32, 0, 36, 0, 8, 1, 
      0, 4, 0, 0, 0, 28, 28, 28, 0, 0, 0, 0, 0, 0, 36, 36, 36, 0, 0, 0, 0, 0, 
      0, 1, 1, 1, 0, 0, 0, 4, 4, 4, 0, 0, 0, 4, 4, 4, 0, 0, 0, 1, 1, 1, 0, 0, 
      0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
      1, 1, 1, 1 ] ), Character( CharacterTable( "S4(8)" ), 
    [ 2016, 256, 0, 32, 36, 0, 0, 8, 1, 4, 0, 28, 28, 28, 0, 0, 0, 0, 0, 0, 
      36, 36, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 4, 4, 4, 0, 0, 0, 4, 4, 
      4, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 
      0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ) ]
gap> spos:= Position( OrdersClassRepresentatives( t ), 65 );;
gap> List( pi, x -> x[ spos ] );
[ 1, 1 ]
gap> Maximum( ApproxP( pi, spos ) );
8/63
gap> CleanWorkspace();
gap> t:= CharacterTable( "S6(2)" );;
gap> ProbGenInfoSimple( t );
[ "S6(2)", 4/7, 1, [ "9A" ], [ 4 ] ]
gap> prim:= PrimitivePermutationCharacters( t );;
gap> ord:= OrdersClassRepresentatives( t );;
gap> spos:= Position( ord, 9 );;
gap> filt:= PositionsProperty( prim, x -> x[ spos ] <> 0 );
[ 1, 8 ]
gap> Maxes( t ){ filt };
[ "U4(2).2", "L2(8).3" ]
gap> List( prim{ filt }, x -> x[ spos ] );
[ 1, 3 ]
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos9:= Position( ord, 9 );;
gap> approx9:= ApproxP( prim, spos9 );;
gap> filt9:= PositionsProperty( approx9, x -> x >= 1/3 );
[ 2, 6 ]
gap> AtlasClassNames( t ){ filt9 };
[ "2A", "3A" ]
gap> approx9{ filt9 };
[ 4/7, 5/14 ]
gap> List( Filtered( prim, x -> x[ spos9 ] <> 0 ), x -> x{ filt9 } );
[ [ 16, 10 ], [ 0, 0 ] ]
gap> spos15:= Position( ord, 15 );;
gap> approx15:= ApproxP( prim, spos15 );;
gap> filt15:= PositionsProperty( approx15, x -> x >= 1/3 );
[ 2, 3 ]
gap> PositionsProperty( ApproxP( prim{ [ 2 ] }, spos15 ), x -> x >= 1/3 );
[ 2, 3 ]
gap> AtlasClassNames( t ){ filt15 };
[ "2A", "2B" ]
gap> approx15{ filt15 };
[ 46/63, 8/21 ]
gap> transvection:= function( d )
>     local mat;
>     mat:= IdentityMat( d, Z(2) );
>     mat{ [ 1, d ] }{ [ 1, d ] }:= [ [ 0, 1 ], [ 1, 0 ] ] * Z(2);
>     return mat;
> end;;
gap> PositionsProperty( SizesConjugacyClasses( t ), x -> x in [ 63, 315 ] );
[ 2, 3 ]
gap> d:= 6;;
gap> matgrp:= Sp(d,2);;
gap> hom:= ActionHomomorphism( matgrp, NormedRowVectors( GF(2)^d ) );;
gap> g:= Image( hom, matgrp );;
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s15:= Random( g );
>    until Order( s15 ) = 15;
gap> 2A:= Image( hom, transvection( d ) );;
gap> Size( ConjugacyClass( g, 2A ) );
63
gap> IsTransitive( g, MovedPoints( g ) );
true
gap> RatioOfNongenerationTransPermGroup( g, 2A, s15 );
11/21
gap> repeat 12C:= Random( g );
>    until Order( 12C ) = 12 and Size( Centralizer( g, 12C ) ) = 12;
gap> 2B:= 12C^6;;
gap> Size( ConjugacyClass( g, 2B ) );
315
gap> RatioOfNongenerationTransPermGroup( g, 2B, s15 );
8/21
gap> ccl:= ConjugacyClasses( g );;
gap> reps:= List( ccl, Representative );;
gap> nongen2A:= List( reps,
>        x -> RatioOfNongenerationTransPermGroup( g, 2A, x ) );;
gap> min:= Minimum( nongen2A );
11/21
gap> Number( nongen2A, x -> x = min );
1
gap> nongen2B:= List( reps,
>        x -> RatioOfNongenerationTransPermGroup( g, 2B, x ) );;
gap> 3A:= s15^5;;
gap> nongen3A:= List( reps,
>        x -> RatioOfNongenerationTransPermGroup( g, 3A, x ) );;
gap> bad:= List( [ 1 .. NrConjugacyClasses( t ) ],
>                i -> Number( [ nongen2A, nongen2B, nongen3A ],
>                             x -> x[i] > 1/3 ) );;
gap> Minimum( bad );
2
gap> PositionsProperty( approx9, x -> x + approx9[2] >= 1 );
[ 2 ]
gap> repeat s9:= Random( g );
>    until Order( s9 ) = 9;
gap> RandomCheckUniformSpread( g, [ 2A, 2A ], s9, 20 );
true
gap> t:= CharacterTable( "S8(2)" );;
gap> pi1:= PossiblePermutationCharacters( CharacterTable( "O8-(2).2" ), t );;
gap> pi2:= PossiblePermutationCharacters( CharacterTable( "S4(4).2" ), t );;
gap> pi3:= [ TrivialCharacter( CharacterTable( "L2(17)" ) )^t ];;
gap> prim:= Concatenation( pi1, pi2, pi3 );;
gap> Length( prim );
3
gap> spos:= Position( OrdersClassRepresentatives( t ), 17 );;
gap> List( prim, x -> x[ spos ] );
[ 1, 1, 1 ]
gap> approx:= ApproxP( prim, spos );;
gap> PositionsProperty( approx, x -> x >= 1/3 );
[ 2 ]
gap> Number( prim, pi -> pi[2] <> 0 and pi[ spos ] <> 0 );
1
gap> approx[2];
8/15
gap> PositionsProperty( approx, x -> x + approx[2] >= 1 );
[ 2 ]
gap> d:= 8;;
gap> matgrp:= Sp(d,2);;
gap> hom:= ActionHomomorphism( matgrp, NormedRowVectors( GF(2)^d ) );;
gap> x:= Image( hom, transvection( d ) );;
gap> g:= Image( hom, matgrp );;
gap> C:= ConjugacyClass( g, x );;  Size( C );
255
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 17;
gap> RandomCheckUniformSpread( g, [ x, x ], s, 20 );
true
gap> t:= CharacterTable( "S10(2)" );;
gap> pi1:= PossiblePermutationCharacters( CharacterTable( "O10-(2).2" ), t );;
gap> pi2:= PossiblePermutationCharacters( CharacterTable( "L2(32).5" ), t );;
gap> prim:= Concatenation( pi1, pi2 );;  Length( prim );
2
gap> spos:= Position( OrdersClassRepresentatives( t ), 33 );;
gap> approx:= ApproxP( prim, spos );;
gap> PositionsProperty( approx, x -> x >= 1/3 );
[ 2 ]
gap> Number( prim, pi -> pi[2] <> 0 and pi[ spos ] <> 0 );
1
gap> approx[2];
16/31
gap> d:= 10;;
gap> matgrp:= Sp(d,2);;
gap> hom:= ActionHomomorphism( matgrp, NormedRowVectors( GF(2)^d ) );;
gap> x:= Image( hom, transvection( d ) );;
gap> g:= Image( hom, matgrp );;
gap> C:= ConjugacyClass( g, x );;  Size( C );
1023
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 33;
gap> RandomCheckUniformSpread( g, [ x, x ], s, 20 );
true
gap> t:= CharacterTable( "U4(2)" );;
gap> ProbGenInfoSimple( t );
[ "U4(2)", 21/40, 1, [ "12A" ], [ 2 ] ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 6, 6, 6, 9, 9, 12, 12 ]
gap> prim:= PrimitivePermutationCharacters( t );
[ Character( CharacterTable( "U4(2)" ), [ 27, 3, 7, 0, 0, 9, 0, 3, 1, 2, 0, 
      0, 3, 3, 0, 1, 0, 0, 0, 0 ] ), Character( CharacterTable( "U4(2)" ), 
    [ 36, 12, 8, 0, 0, 6, 3, 0, 2, 1, 0, 0, 0, 0, 3, 2, 0, 0, 0, 0 ] ), 
  Character( CharacterTable( "U4(2)" ), [ 40, 8, 0, 13, 13, 4, 4, 4, 0, 0, 5, 
      5, 2, 2, 2, 0, 1, 1, 1, 1 ] ), Character( CharacterTable( "U4(2)" ), 
    [ 40, 16, 4, 4, 4, 1, 7, 0, 2, 0, 4, 4, 1, 1, 1, 1, 1, 1, 0, 0 ] ), 
  Character( CharacterTable( "U4(2)" ), [ 45, 13, 5, 9, 9, 6, 3, 1, 1, 0, 1, 
      1, 4, 4, 1, 2, 0, 0, 1, 1 ] ) ]
gap> g:= SU(4,2);;
gap> orbs:= Orbits( g, NormedRowVectors( GF(4)^4 ), OnLines );;
gap> List( orbs, Length );
[ 45, 40 ]
gap> g:= Action( g, orbs[2], OnLines );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 9 );
17
gap> approx:= ApproxP( prim, spos );
[ 0, 3/5, 1/10, 17/40, 17/40, 1/8, 11/40, 1/10, 1/20, 0, 9/40, 9/40, 3/40, 
  3/40, 3/40, 1/40, 1/20, 1/20, 1/40, 1/40 ]
gap> badpos:= PositionsProperty( approx, x -> x >= 2/5 );
[ 2, 4, 5 ]
gap> PowerMap( t, 2 )[4];
5
gap> OrdersClassRepresentatives( t );
[ 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 6, 6, 6, 9, 9, 12, 12 ]
gap> SizesConjugacyClasses( t );
[ 1, 45, 270, 40, 40, 240, 480, 540, 3240, 5184, 360, 360, 720, 720, 1440, 
  2160, 2880, 2880, 2160, 2160 ]
gap> PowerMap( t, 3 )[ spos ];
4
gap> ResetGlobalRandomNumberGenerators();
gap> repeat s:= Random( g );
>    until Order( s ) = 9;
gap> Size( ConjugacyClass( g, s^3 ) );
40
gap> prop:= RatioOfNongenerationTransPermGroup( g, s^3, s );
13/40
gap> repeat x:= Random( g ); until Order( x ) = 12;
gap> Size( ConjugacyClass( g, x^6 ) );
45
gap> prop:= RatioOfNongenerationTransPermGroup( g, x^6, s );
2/5
gap> ccl:= List( ConjugacyClasses( g ), Representative );;
gap> SortParallel( List( ccl, Order ), ccl );
gap> List( ccl, Order );
[ 1, 2, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 6, 6, 6, 9, 9, 12, 12 ]
gap> prop:= List( ccl, r -> RatioOfNongenerationTransPermGroup( g, x^6, r ) );
[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 5/9, 1, 1, 1, 1, 1, 1, 2/5, 2/5, 7/15, 7/15 ]
gap> Minimum( prop );
2/5
gap> approx[2]:= 2/5;;
gap> approx[4]:= 13/40;;
gap> primeord:= PositionsProperty( OrdersClassRepresentatives( t ),
>                                  IsPrimeInt );
[ 2, 3, 4, 5, 6, 7, 10 ]
gap> RemoveSet( primeord, 5 );
gap> primeord;
[ 2, 3, 4, 6, 7, 10 ]
gap> approx{ primeord };
[ 2/5, 1/10, 13/40, 1/8, 11/40, 0 ]
gap> AtlasClassNames( t ){ primeord };
[ "2A", "2B", "3A", "3C", "3D", "5A" ]
gap> triples:= Filtered( UnorderedTuples( primeord, 3 ),
>                  t -> Sum( approx{ t } ) >= 1 );
[ [ 2, 2, 2 ], [ 2, 2, 4 ], [ 2, 2, 7 ], [ 2, 4, 4 ], [ 2, 4, 7 ] ]
gap> repeat 6E:= Random( g );
>    until Order( 6E ) = 6 and Size( Centralizer( g, 6E ) ) = 18;
gap> 2A:= 6E^3;;
gap> 3A:= s^3;;
gap> 3D:= 6E^2;;
gap> RandomCheckUniformSpread( g, [ 2A, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 2A, 2A, 3A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 3D, 2A, 2A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 2A, 3A, 3A ], s, 50 );
true
gap> RandomCheckUniformSpread( g, [ 3D, 3A, 2A ], s, 50 );
true
gap> t:= CharacterTable( "U4(2)" );;
gap> t2:= CharacterTable( "U4(2).2" );;
gap> spos:= PositionsProperty( OrdersClassRepresentatives( t ), x -> x = 9 );;
gap> ProbGenInfoAlmostSimple( t, t2, spos );
[ "U4(2).2", 7/20, [ "9AB" ], [ 2 ] ]
gap> t:= CharacterTable( "U4(3)" );;
gap> ProbGenInfoSimple( t );
[ "U4(3)", 53/135, 2, [ "7A" ], [ 7 ] ]
gap> prim:= PrimitivePermutationCharacters( t );;
gap> spos:= Position( OrdersClassRepresentatives( t ), 7 );
13
gap> List( Filtered( prim, x -> x[ spos ] <> 0 ), l -> l{ [ 1, spos ] } );
[ [ 162, 1 ], [ 162, 1 ], [ 540, 1 ], [ 1296, 1 ], [ 1296, 1 ], [ 1296, 1 ], 
  [ 1296, 1 ] ]
gap> matgrp:= DerivedSubgroup( SO( -1, 6, 3 ) );;
gap> orbs:= Orbits( matgrp, NormedRowVectors( GF(3)^6 ), OnLines );;
gap> List( orbs, Length );
[ 126, 126, 112 ]
gap> G:= Action( matgrp, orbs[3], OnLines );;
gap> approx:= ApproxP( prim, spos );
[ 0, 53/135, 1/10, 1/24, 1/24, 7/45, 4/45, 1/27, 1/36, 1/90, 1/216, 1/216, 
  7/405, 7/405, 1/270, 0, 0, 0, 0, 1/270 ]
gap> Filtered( approx, x -> x >= 43/135 );
[ 53/135 ]
gap> OrdersClassRepresentatives( t );
[ 1, 2, 3, 3, 3, 3, 4, 4, 5, 6, 6, 6, 7, 7, 8, 9, 9, 9, 9, 12 ]
gap> ResetGlobalRandomNumberGenerators();
gap> repeat g:= Random( G ); until Order(g) = 2;
gap> repeat s:= Random( G );
>    until Order(s) = 7;
gap> bad:= RatioOfNongenerationTransPermGroup( G, g, s );
43/135
gap> bad < 1/3;
true
gap> 4t:= CharacterTable( "4.U4(3)" );;
gap> Length( PossibleClassFusions( CharacterTable( "L3(4)" ), 4t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "2.L3(4)" ), 4t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "4_1.L3(4)" ), 4t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "4_2.L3(4)" ), 4t ) );
4
gap> 2t:= CharacterTable( "2.U4(3)" );;
gap> Length( PossibleClassFusions( CharacterTable( "2.A7" ), 2t ) );
0
gap> Length( PossibleClassFusions( CharacterTable( "A7" ), 4t ) );
0
gap> t2:= CharacterTable( "U4(3).2_2" );;
gap> pi1:= PossiblePermutationCharacters( CharacterTable( "U3(3).2" ), t2 );
[ Character( CharacterTable( "U4(3).2_2" ), [ 540, 12, 54, 0, 0, 9, 8, 0, 0, 
      6, 0, 0, 1, 2, 0, 0, 0, 2, 0, 24, 4, 0, 0, 0, 0, 0, 0, 3, 2, 0, 4, 0, 
      0, 0 ] ) ]
gap> pi2:= PossiblePermutationCharacters( CharacterTable( "A7.2" ), t2 );
[ Character( CharacterTable( "U4(3).2_2" ), [ 1296, 48, 0, 27, 0, 9, 0, 4, 1, 
      0, 3, 0, 1, 0, 0, 0, 0, 0, 216, 24, 0, 4, 0, 0, 0, 9, 0, 3, 0, 1, 0, 1, 
      0, 0 ] ) ]
gap> prim:= Concatenation( pi1, pi2, pi2 );;
gap> outer:= Difference(
>      PositionsProperty( OrdersClassRepresentatives( t2 ), IsPrimeInt ),
>      ClassPositionsOfDerivedSubgroup( t2 ) );;
gap> spos:= Position( OrdersClassRepresentatives( t2 ), 7 );;
gap> Maximum( ApproxP( prim, spos ){ outer } );
1/3
gap> matgrp:= SO( -1, 6, 3 );
SO(-1,6,3)
gap> orbs:= Orbits( matgrp, NormedRowVectors( GF(3)^6 ), OnLines );;
gap> List( orbs, Length );
[ 126, 126, 112 ]
gap> G:= Action( matgrp, orbs[3], OnLines );;
gap> repeat s:= Random( G );
>    until Order( s ) = 7;
gap> repeat
>      repeat 2B:= Random( G ); until Order( 2B ) mod 2 = 0;
>      2B:= 2B^( Order( 2B ) / 2 );
>      c:= Centralizer( G, 2B );
>    until Size( c ) = 12096;
gap> RatioOfNongenerationTransPermGroup( G, 2B, s );
13/27
gap> repeat
>      repeat 2C:= Random( G ); until Order( 2C ) mod 2 = 0;
>      2C:= 2C^( Order( 2C ) / 2 );
>      c:= Centralizer( G, 2C );
>    until Size( c ) = 1440;
gap> RatioOfNongenerationTransPermGroup( G, 2C, s );
0
gap> CharacterTable( "U6(3)" );
fail
gap> g:= SU(6,3);;
gap> orbs:= Orbits( g, NormedRowVectors( GF(9)^6 ), OnLines );;
gap> List( orbs, Length );
[ 22204, 44226 ]
gap> repeat x:= PseudoRandom( g ); until Order( x ) = 244;
gap> List( orbs, o -> Number( o, v -> OnLines( v, x ) = v ) );
[ 0, 1 ]
gap> g:= Action( g, orbs[2], OnLines );;
gap> M:= Stabilizer( g, 1 );;
gap> elms:= [];;
gap> for p in Set( Factors( Size( M ) ) ) do
>      syl:= SylowSubgroup( M, p );
>      Append( elms, Filtered( PcConjugacyClassReps( syl ),
>                              r -> Order( r ) = p ) );
>    od;
gap> 1 - Minimum( List( elms, NrMovedPoints ) ) / Length( orbs[2] );
353/3159
gap> CharacterTable( "U8(2)" );
fail
gap> g:= SU(8,2);;
gap> orbs:= Orbits( g, NormedRowVectors( GF(4)^8 ), OnLines );;
gap> List( orbs, Length );
[ 10965, 10880 ]
gap> repeat x:= PseudoRandom( g ); until Order( x ) = 129;
gap> List( orbs, o -> Number( o, v -> OnLines( v, x ) = v ) );
[ 0, 1 ]
gap> g:= Action( g, orbs[2], OnLines );;
gap> M:= Stabilizer( g, 1 );;
gap> elms:= [];;
gap> for p in Set( Factors( Size( M ) ) ) do
>      syl:= SylowSubgroup( M, p );
>      Append( elms, Filtered( PcConjugacyClassReps( syl ),
>                              r -> Order( r ) = p ) );
>    od;
gap> Length( elms );
611
gap> 1 - Minimum( List( elms, NrMovedPoints ) ) / Length( orbs[2] );
2753/10880

gap> STOP_TEST( "probgen.tst", 75612500 );

#############################################################################
##
#E

