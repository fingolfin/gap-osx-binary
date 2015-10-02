#############################################################################
##
#W  rcwagrp.gi                GAP4 Package `RCWA'                 Stefan Kohl
##
##  This file contains implementations of methods and functions for computing
##  with rcwa groups over
##
##    - the ring Z of the integers, over
##    - the ring Z^2, over
##    - the semilocalizations Z_(pi) of the ring of integers, and over
##    - the polynomial rings GF(q)[x] in one variable over a finite field.
##
##  See the definitions given in the file rcwamap.gd.
##
#############################################################################

#############################################################################
##
#S  Implications between the categories of rcwa groups. /////////////////////
##
#############################################################################

InstallTrueMethod( IsGroup,     IsRcwaGroup );
InstallTrueMethod( IsRcwaGroup, IsRcwaGroupOverZOrZ_pi );
InstallTrueMethod( IsRcwaGroupOverZOrZ_pi, IsRcwaGroupOverZ );
InstallTrueMethod( IsRcwaGroupOverZOrZ_pi, IsRcwaGroupOverZ_pi );
InstallTrueMethod( IsRcwaGroup, IsRcwaGroupOverZxZ );
InstallTrueMethod( IsRcwaGroup, IsRcwaGroupOverGFqx );

#############################################################################
##
#S  Implications of `IsRcwaGroup'. //////////////////////////////////////////
##
#############################################################################

InstallTrueMethod( CanComputeSizeAnySubgroup, IsRcwaGroup );
InstallTrueMethod( KnowsHowToDecompose,
                   IsRcwaGroup and HasGeneratorsOfGroup );

#############################################################################
##
#S  Checking whether a list is a set of generators of an rcwa group. ////////
##
#############################################################################

#############################################################################
##
#M  IsGeneratorsOfMagmaWithInverses( <l> ) . . .  for a list of rcwa mappings
##
##  Tests whether all rcwa mappings in the list <l> belong to the same
##  family and are bijective, hence generate a group.
##
InstallMethod( IsGeneratorsOfMagmaWithInverses,
               "for lists of rcwa mappings (RCWA)", true,
               [ IsListOrCollection ], 0,

  function ( l )
    if   ForAll(l,IsRcwaMapping)
    then return     Length(Set(List(l,FamilyObj))) = 1
                and ForAll(l,IsBijective); 
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  IsWholeFamily . . . . . . . . . . . . . for an rcwa group -- return false
##
InstallMethod( IsWholeFamily,
               "for an rcwa group -- return false (RCWA)", true,
               [ IsRcwaGroup ], 0, ReturnFalse );

#############################################################################
##
#S  Conversion of rcwa groups between standard and sparse representation. ///
##
#############################################################################

#############################################################################
##
#M  SparseRepresentation( <G> )
##
InstallMethod( SparseRepresentation,
               "for rcwa groups over Z (RCWA)",
               true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  G_sparse;

    G_sparse := GroupByGenerators(List(GeneratorsOfGroup(G),SparseRep));
    if HasIsTame(G) then SetIsTame(G_sparse,IsTame(G)); fi;
    if   HasModulusOfRcwaMonoid(G)
    then SetModulusOfRcwaMonoid(G_sparse,ModulusOfRcwaMonoid(G)); fi;
    if HasSize(G) then SetSize(G_sparse,Size(G)); fi;
    return G_sparse;
  end );

#############################################################################
##
#M  StandardRepresentation( <G> )
##
InstallMethod( StandardRepresentation,
               "for rcwa groups over Z (RCWA)",
               true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  G_standard;

    G_standard := GroupByGenerators(List(GeneratorsOfGroup(G),StandardRep));
    if HasIsTame(G) then SetIsTame(G_standard,IsTame(G)); fi;
    if   HasModulusOfRcwaMonoid(G)
    then SetModulusOfRcwaMonoid(G_standard,ModulusOfRcwaMonoid(G)); fi;
    if HasSize(G) then SetSize(G_standard,Size(G)); fi;
    return G_standard;
  end );

#############################################################################
##
#S  Methods for `View', `Print', `Display' etc. /////////////////////////////
##
#############################################################################

#############################################################################
##
#M  ViewObj( <G> ) . . . . . . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( ViewObj,
               "for rcwa groups (RCWA)", true,
               [ IsRcwaGroup and HasGeneratorsOfGroup ], 0,

  function ( G )

    local  NrGens, RingString;

    RingString := RingToString(Source(One(G)));
    if   IsTrivial(G)
    then Display(G:NoLineFeed);
    else Print("<");
         if   HasIsTame(G) and not (HasSize(G) and IsInt(Size(G)))
         then if IsTame(G) then Print("tame "); else Print("wild "); fi; fi;
         NrGens := Length(GeneratorsOfGroup(G));
         Print("rcwa group over ",RingString," with ",NrGens," generator");
         if NrGens > 1 then Print("s"); fi;
         if not (HasIsTame(G) and not IsTame(G)) then
           if   HasIdGroup(G)
           then Print(", of isomorphism type ",IdGroup(G));
           elif HasSize(G)
           then Print(", of order ",Size(G)); fi;
         fi;
         Print(">");
    fi;
  end );

#############################################################################
##
#M  ViewObj( <G> ) . . . . . . . . . for rcwa groups without known generators
##
InstallMethod( ViewObj,
               "for rcwa groups without known generators (RCWA)",
               true, [ IsRcwaGroup ], 0,

  function ( G )
    Print("<");
    if   HasIsTame(G)
    then if IsTame(G) then Print("tame "); else Print("wild "); fi; fi;
    Print("rcwa group over ",RingToString(Source(One(G))));
    if   HasElementTestFunction(G)
    then Print(", with membership test"); fi;
    if   not HasGeneratorsOfGroup(G)
    then Print(", without known generators"); fi;
    Print(">");
  end );

#############################################################################
##
#M  ViewString( <G> ) . . . for groups generated by class transpositions of Z
##
InstallMethod( ViewString,
               "for a group generated by class transpositions of Z",
               true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  gens, s, g, gs, cl;

    gens := GeneratorsOfGroup(G);
    if not ForAll(gens,IsClassTransposition) then TryNextMethod(); fi;
    s := "<";
    for g in gens do
      cl := TransposedClasses(g);
      gs := Concatenation(List(["(",Residue(cl[1]),"(",Mod(cl[1]),"),",
                                    Residue(cl[2]),"(",Mod(cl[2]),"))"],
                               String));
      if s <> "<" then s := Concatenation(s,","); fi;
      s := Concatenation(s,gs);
    od;
    s := Concatenation(s,">");
    return s;
  end );

#############################################################################
##
#M  ViewObj( <RG> ) . . . . . . . . . . . . .  for group rings of rcwa groups
##
InstallMethod( ViewObj,
               "for group rings of rcwa groups (RCWA)",
               ReturnTrue, [ IsGroupRing ], 100,

  function ( RG )

    local  R, G;

    R := LeftActingDomain(RG); G := UnderlyingGroup(RG);
    if not IsRcwaGroup(G) or R <> Source(One(G)) then TryNextMethod(); fi;
    Print(RingToString(R)," "); ViewObj(G);
  end );

#############################################################################
##
#M  Print( <G> ) . . . . . . . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( PrintObj,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )
    Print( "Group( ", GeneratorsOfGroup( G ), " )" );
  end );

#############################################################################
##
#M  Display( <G> ) . . . . . . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( Display,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  RingString, g, prefix;

    RingString := RingToString(Source(One(G)));
    if   IsTrivial(G) 
    then Print("Trivial rcwa group over ",RingString);
         if ValueOption("NoLineFeed") <> true then Print("\n"); fi;
    else prefix := false;
         if HasIsTame(G) and not (HasSize(G) and IsInt(Size(G))) then
           if IsTame(G) then Print("\nTame "); else Print("\nWild "); fi;
           prefix := true;
         fi;
         if prefix then Print("rcwa "); else Print("\nRcwa "); fi;
         Print("group over ",RingString);
         if not (HasIsTame(G) and not IsTame(G)) then
           if   HasIdGroup(G) then Print(" of isomorphism type ",IdGroup(G));
           elif HasSize(G)    then Print(" of order ",Size(G)); fi;
         fi;
         Print(", generated by\n\n[\n");
         for g in GeneratorsOfGroup(G) do Display(g); od;
         Print("]\n\n");
    fi;
  end );

#############################################################################
##
#M  LaTeXStringRcwaGroup( <G> ) . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( LaTeXStringRcwaGroup,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  s, g;

    s := "\\langle ";
    for g in GeneratorsOfGroup(G) do
      if s <> "\\langle " then Append(s,", "); fi;
      Append(s,LaTeXStringRcwaMapping(g));
    od;
    Append(s," \\rangle");
    return s;
  end );

#############################################################################
##
#S  The trivial rcwa groups. ////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#V  TrivialRcwaGroupOverZ . . . . . . . . . . . . . trivial rcwa group over Z
#V  TrivialRcwaGroupOverZxZ . . . . . . . . . . . trivial rcwa group over Z^2
##
InstallValue( TrivialRcwaGroupOverZ, Group( IdentityRcwaMappingOfZ ) );
InstallValue( TrivialRcwaGroupOverZxZ, Group( IdentityRcwaMappingOfZxZ ) );

#############################################################################
##
#M  TrivialSubmagmaWithOne( <G> ). . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( TrivialSubmagmaWithOne,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  triv;

    triv := Group(One(G));
    SetParentAttr(triv,G);
    return triv;
  end );

#############################################################################
##
#S  The construction of the groups RCWA(R) of all rcwa permutations of R. ///
##
#############################################################################

#############################################################################
##
#M  RCWACons( IsRcwaGroup, Integers ) . . . . . . . . . . . . . . . RCWA( Z )
##
##  Returns the group which is formed by all bijective rcwa mappings of Z.
##
InstallMethod( RCWACons,
               "natural RCWA(Z) (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsIntegers ], 0,

  function ( filter, R )

    local  G, id;

    id := IdentityRcwaMappingOfZ;
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                              IsRcwaGroupOverZ and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, IdentityRcwaMappingOfZ );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalRCWA( G, true );
    SetIsNaturalRCWA_Z( G, true );
    SetModulusOfRcwaMonoid( G, 0 );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetIsFinitelyGeneratedGroup( G, false );
    SetCentre( G, TrivialRcwaGroupOverZ );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    SetIsPerfectGroup( G, false );
    SetIsSimpleGroup( G, false );
    SetRepresentative( G, RcwaMapping( [ [ -1, 0, 1 ] ] ) );
    SetName( G, "RCWA(Z)" );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#M  RCWACons( IsRcwaGroup, Integers^2 ) . . . . . . . . . . . . . RCWA( Z^2 )
##
##  Returns the group which is formed by all bijective rcwa mappings of Z^2.
##
InstallMethod( RCWACons,
               "natural RCWA(Z^2) (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRowModule ], 0,

  function ( filter, R )

    local  G, id;

    if not IsZxZ( R ) then TryNextMethod( ); fi;

    id := IdentityRcwaMappingOfZxZ;
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                              IsRcwaGroupOverZxZ and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, id );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalRCWA( G, true );
    SetIsNaturalRCWA_ZxZ( G, true );
    SetModulusOfRcwaMonoid( G, [ [ 0, 0 ], [ 0, 0 ] ] );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetIsFinitelyGeneratedGroup( G, false );
    SetCentre( G, TrivialRcwaGroupOverZxZ );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    SetRepresentative( G, RcwaMapping( R, [ [ 1, 0 ], [ 0, 1 ] ],
      [ [ [ 0, 0 ], [ [ [ -1, 0 ], [ 0, -1 ] ], [ 0, 0 ], 1 ] ] ] ) );
    SetName( G, "RCWA(Z^2)" );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#M  RCWACons( IsRcwaGroup, Z_pi( <pi> ) ) . . . . . . . . . .  RCWA( Z_(pi) )
##
##  Returns the group which is formed by all bijective rcwa mappings
##  of Z_(pi).
##
InstallMethod( RCWACons,
               "natural RCWA(Z_(pi)) (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsZ_pi ], 0,

  function ( filter, R )

    local  G, pi, id;

    pi := NoninvertiblePrimes( R );
    id := RcwaMapping( pi, [ [1,0,1] ] ); IsOne( id );
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                                  IsRcwaGroupOverZ_pi
                              and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, id );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalRCWA( G, true );
    SetIsNaturalRCWA_Z_pi( G, true );
    SetModulusOfRcwaMonoid( G, 0 );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetCentre( G, Group( id ) );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    SetRepresentative( G, -id );
    SetName( G, Concatenation( "RCWA(", ViewString(R), ")" ) );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#M  RCWACons( IsRcwaGroup, PolynomialRing( GF( <q> ), 1 ) )  RCWA( GF(q)[x] )
##
##  Returns the group which is formed by all bijective rcwa mappings
##  of GF(q)[x].
##
InstallMethod( RCWACons,
               "natural RCWA(GF(q)[x]) (RCWA)", ReturnTrue, 
               [ IsRcwaGroup, IsUnivariatePolynomialRing ], 0,

  function ( filter, R )

    local  G, q, id, rep;

    q  := Size( CoefficientsRing( R ) );
    id := RcwaMapping( q, One(R), [ [1,0,1] * One(R) ] ); IsOne( id );
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                                  IsRcwaGroupOverGFqx
                              and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, id );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalRCWA( G, true );
    SetIsNaturalRCWA_GFqx( G, true );
    SetModulusOfRcwaMonoid( G, Zero( R ) );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetIsFinitelyGeneratedGroup( G, false );
    SetCentre( G, Group( id ) );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    rep := ClassTransposition(SplittedClass(R,q){[1..2]});
    SetRepresentative( G, rep );
    SetName( G, Concatenation( "RCWA(GF(", String(q), ")[",
                String(IndeterminatesOfPolynomialRing(R)[1]),"])" ) );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#F  RCWA( <R> ) . . . . . . . . . . . . . . . . . . . . . . . . . . RCWA( R )
##
InstallGlobalFunction( RCWA, R -> RCWACons( IsRcwaGroup, R ) );

#############################################################################
##
#M  IsNaturalRCWA( <G> ) . . . . . . . . . . . . . . . . . . . . . .  RCWA(R)
#M  IsNaturalRCWA_Z( <G> ) . . . . . . . . . . . . . . . . . . . . .  RCWA(Z)
#M  IsNaturalRCWA_Z_pi( <G> ) . . . . . . . . . . . . . . . . .  RCWA(Z_(pi))
#M  IsNaturalRCWA_GFqx( <G> ) . . . . . . . . . . . . . . . .  RCWA(GF(q)[x])
##
##  The groups RCWA( <R> ) can only be obtained by the above constructors.
##
Perform( [ IsNaturalRCWA,
           IsNaturalRCWA_Z, IsNaturalRCWA_Z_pi, IsNaturalRCWA_GFqx ],
         function ( property )
           InstallMethod( property, "for rcwa groups (RCWA)", true,
                          [ IsRcwaGroup ], 0, ReturnFalse );
         end );

#############################################################################
##
#S  The construction of the groups CT(R) ////////////////////////////////////
#S  generated by all class transpositions. //////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  CTCons( IsRcwaGroup, Integers ) . . . . . . . . . . . . . . . . . CT( Z )
##
##  Returns the simple group which is generated
##  by the set of all class transpositions of Z.
##
InstallMethod( CTCons,
               "natural CT(Z) (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsIntegers ], 0,

  function ( filter, R )

    local  G, id;

    id := IdentityRcwaMappingOfZ;
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                              IsRcwaGroupOverZ and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, IdentityRcwaMappingOfZ );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalCT( G, true );
    SetIsNaturalCT_Z( G, true );
    SetModulusOfRcwaMonoid( G, 0 );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetIsFinitelyGeneratedGroup( G, false );
    SetCentre( G, TrivialRcwaGroupOverZ );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    SetIsPerfectGroup( G, true );
    SetIsSimpleGroup( G, true );
    SetRepresentative( G, ClassTransposition(0,2,1,2) );
    SetSupport( G, Integers );
    SetName( G, "CT(Z)" );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#M  CTCons( IsRcwaGroup, Integers^2 ) . . . . . . . . . . . . . . . CT( Z^2 )
##
##  Returns the group which is generated by
##  the set of all class transpositions of Z^2.
##
InstallMethod( CTCons,
               "natural CT(Z^2) (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRowModule ], 0,

  function ( filter, R )

    local  G, id;

    if not IsZxZ(R) then TryNextMethod(); fi;

    id := IdentityRcwaMappingOfZxZ;
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                              IsRcwaGroupOverZxZ and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, IdentityRcwaMappingOfZxZ );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalCT( G, true );
    SetIsNaturalCT_ZxZ( G, true );
    SetModulusOfRcwaMonoid( G, [ [ 0, 0 ], [ 0, 0 ] ] );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetIsFinitelyGeneratedGroup( G, false );
    SetCentre( G, TrivialRcwaGroupOverZxZ );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    SetIsPerfectGroup( G, true );
    SetIsSimpleGroup( G, true );
    SetRepresentative( G, ClassTransposition([0,0],[[1,0],[0,2]],
                                             [0,1],[[1,0],[0,2]]) );
    SetSupport( G, R );
    SetName( G, "CT(Z^2)" );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#M  CTCons( IsRcwaGroup, Z_pi( <pi> ) ) . . . . . . . . . . . .  CT( Z_(pi) )
##
##  Returns the group which is generated by
##  the set of all class transpositions of Z_(pi).
##
InstallMethod( CTCons,
               "natural CT(Z_(pi)) (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsZ_pi ], 0,

  function ( filter, R )

    local  G, pi, id, rep;

    pi := NoninvertiblePrimes( R );
    id := RcwaMapping( pi, [ [1,0,1] ] ); IsOne( id );
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                                  IsRcwaGroupOverZ_pi
                              and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, id );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalCT( G, true );
    SetIsNaturalCT_Z_pi( G, true );
    SetModulusOfRcwaMonoid( G, 0 );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetCentre( G, Group( id ) );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    rep := ClassTransposition(AllResidueClassesModulo(R,pi[1]){[1..2]});
    SetRepresentative( G, rep );
    SetSupport( G, R );
    SetName( G, Concatenation( "CT(", ViewString(R), ")" ) );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#M  CTCons( IsRcwaGroup, PolynomialRing( GF( <q> ), 1 ) ) . .  CT( GF(q)[x] )
##
##  Returns the group which is generated by
##  the set of all class transpositions of GF(q)[x].
##
InstallMethod( CTCons,
               "natural CT(GF(q)[x]) (RCWA)", true, 
               [ IsRcwaGroup, IsUnivariatePolynomialRing ], 0,

  function ( filter, R )

    local  G, q, id, rep;

    q  := Size( CoefficientsRing( R ) );
    id := RcwaMapping( q, One(R), [ [1,0,1] * One(R) ] ); IsOne( id );
    G  := Objectify( NewType( FamilyObj( Group( id ) ),
                                  IsRcwaGroupOverGFqx
                              and IsAttributeStoringRep ),
                     rec( ) );
    SetIsTrivial( G, false );
    SetOne( G, id );
    SetIsNaturalRCWA_OR_CT( G, true );
    SetIsNaturalCT( G, true );
    SetIsNaturalCT_GFqx( G, true );
    SetModulusOfRcwaMonoid( G, Zero( R ) );
    SetMultiplier( G, infinity );
    SetDivisor( G, infinity );
    SetIsFinite( G, false );
    SetSize( G, infinity );
    SetIsFinitelyGeneratedGroup( G, false );
    SetCentre( G, Group( id ) );
    SetIsAbelian( G, false );
    SetIsSolvableGroup( G, false );
    rep := ClassTransposition(SplittedClass(R,q){[1..2]});
    SetRepresentative( G, rep );
    SetSupport( G, R );
    SetName( G, Concatenation( "CT(GF(", String(q), ")[",
                String(IndeterminatesOfPolynomialRing(R)[1]),"])" ) );
    SetStructureDescription( G, Name( G ) );
    return G;
  end );

#############################################################################
##
#F  CT( <R> ) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . CT(R)
##
InstallGlobalFunction( CT, R -> CTCons( IsRcwaGroup, R ) );

#############################################################################
##
#M  IsNaturalCT( <G> )  . . . . . . . . . . . . . . . . . . . . . . . . CT(R)
#M  IsNaturalCT_Z( <G> )  . . . . . . . . . . . . . . . . . . . . . . . CT(Z)
#M  IsNaturalCT_Z_pi( <G> ) . . . . . . . . . . . . . . . . . . .  CT(Z_(pi))
#M  IsNaturalCT_GFqx( <G> ) . . . . . . . . . . . . . . . . . .  CT(GF(q)[x])
##
##  The groups CT( <R> ) can only be obtained by the above constructors.
##
Perform( [ IsNaturalCT,
           IsNaturalCT_Z, IsNaturalCT_Z_pi, IsNaturalCT_GFqx ],
         function ( property )
           InstallMethod( property, "for rcwa groups (RCWA)", true,
                          [ IsRcwaGroup ], 0, ReturnFalse );
         end );

#############################################################################
##
#M  IsNaturalRCWA_OR_CT( <G> ) . . . . . . . . . . . . . . . RCWA(R) or CT(R)
##
InstallMethod( IsNaturalRCWA_OR_CT,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,
               ReturnFalse );

#############################################################################
##
#M  Display( <G> ) . . . . . . . . . . . . . . . . . .  for RCWA(R) and CT(R)
##
InstallMethod( Display,
               "for RCWA(R) and CT(R) (RCWA)", true,
               [ IsNaturalRCWA_OR_CT ], 0,
               function ( G ) Print( Name( G ), "\n" ); end );

#############################################################################
##
#S  The membership- / subgroup test for RCWA(R) and CT(R). //////////////////
##
#############################################################################

#############################################################################
##
#M  \in( <g>, RCWA( <R> ) ) . . . . . . . . . for an rcwa mapping and RCWA(R)
##
InstallMethod( \in,
               "for an rcwa mapping and RCWA(R) (RCWA)", ReturnTrue,
               [ IsRcwaMapping, IsNaturalRCWA ], 100,

  function ( g, RCWA_R )
    return FamilyObj(g) = FamilyObj(One(RCWA_R)) and IsBijective(g);
  end );

#############################################################################
##
#M  \in( <g>, CT( <R> ) ) . . . . . . . . . . . for an rcwa mapping and CT(R)
##
InstallMethod( \in,
               "for an rcwa mapping and CT(R) (RCWA)", ReturnTrue,
               [ IsRcwaMapping, IsNaturalCT ], 100,

  function ( g, CT_R )

    local  R, numres;

    if   FamilyObj(g) <> FamilyObj(One(CT_R)) or not IsBijective(g)
    then return false; elif IsOne(g) then return true; fi;
    R := Support(CT_R);
    if IsIntegers(R) or IsZ_pi(R) then 
      if not IsClassWiseOrderPreserving(g) then return false; fi;
      if IsIntegers(R) and Determinant(g) <> 0 then return false; fi;
      if   Minimum([0..Mod(g)-1]^g) < 0
        or Maximum([-Mod(g)..-1]^g) >= 0
      then return false; fi;
    elif IsZxZ(R) then
      numres := AbsInt(DeterminantMat(Modulus(g)));
      if   not IsClassWiseOrderPreserving(g)
        or not ForAll(Coefficients(g),c->IsUpperTriangularMat(c[1]))
        or not ForAll(Coefficients(g),c->c[1][1][1] > 0)
        or not ForAll(Cartesian([0..numres-1],[-numres..numres]),
                      t->t^g*[1,0]>=0)
      then return false; fi;
    fi;
    if   ForAll(FactorizationIntoCSCRCT(g),
                gi ->    IsClassTransposition(gi)
                      or IsPrimeSwitch(gi) or IsPrimeSwitch(gi^-1))
    then return true; fi;
    TryNextMethod();
  end );

#############################################################################
## 
#M  IsSubset( RCWA( <R> ), G ) . . . . . . . .  for RCWA(R) and an rcwa group
## 
InstallMethod( IsSubset,
               "for RCWA(R) and an rcwa group (RCWA)", ReturnTrue,
               [ IsNaturalRCWA, IsRcwaGroup ], SUM_FLAGS,

  function ( RCWA_R, G )
    return FamilyObj(One(RCWA_R)) = FamilyObj(One(G));
  end );

#############################################################################
## 
#M  IsSubset( CT( Integers ), G ) . . . .  for CT(Z) and an rcwa group over Z
## 
InstallMethod( IsSubset,
               "for CT(Z) and an rcwa group over Z (RCWA)", ReturnTrue,
               [ IsNaturalCT_Z, IsRcwaGroupOverZ ], SUM_FLAGS,

  function ( CT_Z, G )
    if not IsClassWiseOrderPreserving(G)
      or ForAny(GeneratorsOfGroup(G),g->Determinant(g)<>0)
      or Minimum(Ball(G,0,4,OnPoints)) < 0
    then return false; fi;
    return ForAll(GeneratorsOfGroup(G),g->g in CT_Z);
  end );

#############################################################################
## 
#M  IsSubset( CT( <R> ), G ) . . . . . . . . . .  for CT(R) and an rcwa group
## 
InstallMethod( IsSubset,
               "for CT(R) and an rcwa group (RCWA)", ReturnTrue,
               [ IsNaturalCT, IsRcwaGroup ], 100,

  function ( CT_R, G )
    if FamilyObj(One(G)) <> FamilyObj(One(CT_R)) then return false; fi;
    return ForAll(GeneratorsOfGroup(G),g->g in CT_R);
  end );

#############################################################################
## 
#M  IsSubset( CT( <R> ), RCWA( <R> ) ) . . . . . . . .  for CT(R) and RCWA(R)
## 
##  Note that it is currently not known e.g. whether
##  CT(GF(2)[x]) = RCWA(GF(2)[x]) or not.
##
InstallMethod( IsSubset,
               "for CT(R) and RCWA(R) (RCWA)", ReturnTrue,
               [ IsNaturalCT, IsNaturalRCWA ], SUM_FLAGS,

  function ( CT_R, RCWA_R )
    if FamilyObj(One(CT_R)) <> FamilyObj(One(RCWA_R)) then return false; fi;
    if IsRcwaGroupOverZOrZ_pi(RCWA_R) then return false; fi;
    if   not IsTrivial(Units(CoefficientsRing(Source(One(RCWA_R)))))
    then return false; fi;
    Error("sorry - this is still an open question!");
    return fail;
  end );

#############################################################################
##
#S  Counting / enumerating certain elements of RCWA(R) and CT(R). ///////////
##
#############################################################################

#############################################################################
##
#V  NrElementsOfCTZWithGivenModulus
##
##  The numbers of elements of CT(Z) of given order m <= 24, subject to the
##  conjecture that CT(Z) is the setwise stabilizer of N_0 in RCWA(Z).
##
BindGlobal( "NrElementsOfCTZWithGivenModulus",
[ 1, 1, 17, 238, 4679, 115181, 3482639, 124225680, 5114793582, 238618996919, 
  12441866975999, 716985401817362, 45251629386163199, 3104281120750130159, 
  229987931693135611303, 18301127616460012222080, 1556718246822087917567999, 
  140958365897067252175843218, 13537012873511994353270783999, 
  1374314160482820530097944198162, 147065220260069766956421116517343, 
  16544413778663040175990602280223999, 1951982126641242370890486633922559999, 
  241014406219744996673035312579811441520 ] );

#############################################################################
## 
#F  AllElementsOfCTZWithGivenModulus( m ) .  elements of CT(Z) with modulus m
##
##  Assumes the conjecture that CT(Z) is the setwise stabilizer of the
##  nonnegative integers in RCWA(Z).
##
InstallGlobalFunction( AllElementsOfCTZWithGivenModulus,

  function ( m )

    local  elems, source, ranges, range, perms, g;

    if not IsPosInt(m) then
      Error("usage: AllElementsOfCTZWithGivenModulus( <m> ) ",
            "for a positive integer m\n");
    fi;
    if m = 1 then return [ IdentityRcwaMappingOfZ ]; fi;
    source := AllResidueClassesModulo(Integers,m);
    ranges := PartitionsIntoResidueClasses(Integers,m);
    perms  := AsList(SymmetricGroup(m));
    elems  := [];
    for range in ranges do
      for g in perms do
        Add(elems,RcwaMapping(source,Permuted(range,g)));
      od;
    od;
    return Filtered(Set(elems),elm->Mod(elm)=m);
  end );

#############################################################################
##
#S  Factoring elm's of RCWA(R) into class shifts/reflections/transpositions.
##
#############################################################################

#############################################################################
##
#M  Factorization( RCWA( <R> ), <g> ) .  for RCWA( R ) and an element thereof
##
InstallMethod( Factorization,
               "into class shifts / reflections / transpositions (RCWA)",
               IsCollsElms, [ IsNaturalRCWA, IsRcwaMapping ], 0,
               function(RCWA_R,g) return FactorizationIntoCSCRCT(g); end );

#############################################################################
##
#M  Factorization( CT( <R> ), <g> ) . . .  for CT( R ) and an element thereof
##
InstallMethod( Factorization,
               "into class shifts / reflections / transpositions (RCWA)",
               IsCollsElms, [ IsNaturalCT, IsRcwaMapping ], 0,

 function( CT_R, g )
   if g in CT_R then return FactorizationIntoCSCRCT(g);
                else return fail; fi;
 end );

############################################################################
##
#S  The epimorphisms RCWA(Z) -> C2 and RCWA+(Z) -> (Z,+). ///////////////////
##
#############################################################################

#############################################################################
##
#M  Sign( <f> ) . . . . . . . . . . . for rcwa mappings of Z in standard rep.
##
InstallMethod( Sign,
               "for rcwa mappings of Z in standard rep. (RCWA)",
               true, [ IsRcwaMappingOfZInStandardRep ], 0,

  function ( f )

    local  m, c, sgn, r, ar, br, cr;

    if not IsBijective(f) then return fail; fi;
    m := Modulus(f); c := Coefficients(f);
    sgn := 0;
    for r in [0..m-1] do
      ar := c[r+1][1]; br := c[r+1][2]; cr := c[r+1][3];
      sgn := sgn + br/AbsInt(ar);
      if ar < 0 then sgn := sgn + (m - 2*r); fi;
    od;
    sgn := (-1)^(sgn/m);
    return sgn;
  end );

#############################################################################
##
#M  Sign( <f> ) . . . . . . . . . . . . for rcwa mappings of Z in sparse rep.
##
InstallMethod( Sign,
               "for rcwa mappings of Z in sparse rep. (RCWA)",
               true, [ IsRcwaMappingOfZInSparseRep ], 0,

  function ( f )

    local  sgn, c, r, m, a, b;

    if not IsBijective(f) then return fail; fi;
    sgn := 0;
    for c in f!.coeffs do
      r := c[1]; m := c[2]; a := c[3]; b := c[4];
      sgn := sgn + b/(m*AbsInt(a));
      if a < 0 then sgn := sgn + (m - 2*r)/m; fi;
    od;
    sgn := (-1)^sgn;
    return sgn;
  end );

#############################################################################
##
#M  Determinant( <f> ) . . . . . . .  for rcwa mappings of Z in standard rep.
##
InstallMethod( Determinant,
               "for rcwa mappings of Z in standard rep. (RCWA)",
               true, [ IsRcwaMappingOfZInStandardRep ], 0,

  function ( f )
    if Mult(f) = 0 then return fail; fi;
    return Sum(List(Coefficients(f),c->c[2]/AbsInt(c[1])))/Modulus(f);
  end );

#############################################################################
##
#M  Determinant( <f> ) . . . . . . . .  for rcwa mappings of Z in sparse rep.
##
InstallMethod( Determinant,
               "for rcwa mappings of Z in sparse rep. (RCWA)",
               true, [ IsRcwaMappingOfZInSparseRep ], 0,

  function ( f )
    if Mult(f) = 0 then return fail; fi;
    return Sum(List(Coefficients(f),c->c[4]/AbsInt(c[3]*c[2])));
  end );

#############################################################################
##
#M  Determinant( <f>, <S> ) .  for rcwa mappings on unions of residue classes
##
InstallOtherMethod( Determinant,
                    "for rcwa mappings on unions of residue classes (RCWA)",
                    true, [ IsRcwaMappingOfZInStandardRep,
                            IsResidueClassUnionOfZ ], 0,

  function ( f, S )

    local  m, c, r, cl;

    m := Modulus(f); c := Coefficients(f);
    return Sum(List([1..m],
                    r->Density(Intersection(S,ResidueClass(Integers,m,r-1)))
                      *c[r][2]/AbsInt(c[r][1])));
  end );

#############################################################################
##
#M  Determinant( <f>, <S> ) .  for rcwa mappings on unions of residue classes
##
InstallOtherMethod( Determinant,
                    "for rcwa mappings on unions of residue classes (RCWA)",
                    true, [ IsRcwaMappingOfZInSparseRep,
                            IsResidueClassUnionOfZ ], 0,

  function ( f, S )
    return Sum(List(f!.coeffs,
                    c -> Density(Intersection(S,ResidueClass(c[1],c[2])))
                       * c[4]/AbsInt(c[3])));
  end );

#############################################################################
##
#S  Generating random elements of RCWA(R) and CT(R). ////////////////////////
##
#############################################################################

#############################################################################
##
#M  Random( RCWA( Integers ) ) . . . . . . . .  a `random' element of RCWA(Z)
##
InstallMethod( Random,
               "for RCWA(Z) (RCWA)", true, [ IsNaturalRCWA_Z ], SUM_FLAGS,

  function ( RCWA_Z )

    local  result, ClassTranspositions, ClassShifts, ClassReflections,
           maxmodct, maxmodcscr, noct, nocs, nocr, genfactors, classes,
           tame, integralpairs, g, i;

    tame       := ValueOption("IsTame") = true;
    noct       := ValueOption("NumberOfCTs");
    nocs       := ValueOption("NumberOfCSs");
    nocr       := ValueOption("NumberOfCRs");
    maxmodcscr := ValueOption("ModulusBoundForCSCRs");
    maxmodct   := ValueOption("ModulusBoundForCTs");
    if noct   = fail then noct := Random([0..2]); fi;
    if nocs   = fail then nocs := Random([0..3]); fi;
    if nocr   = fail then nocr := Random([0..3]); fi;
    if maxmodcscr = fail then maxmodcscr :=  6; fi;
    if maxmodct   = fail then maxmodct   := 14; fi;
    if maxmodct <> CLASS_PAIRS_LARGE[1] then
      MakeReadWriteGlobal("CLASS_PAIRS_LARGE");
      CLASS_PAIRS_LARGE := [maxmodct,ClassPairs(maxmodct)];
      MakeReadOnlyGlobal("CLASS_PAIRS_LARGE");
    fi;
    classes             := Combinations([1..maxmodcscr],2)-1;
    ClassTranspositions := List([1..noct],i->Random(CLASS_PAIRS[2]));
    if   Random([1..4]) = 1 
    then Add(ClassTranspositions,Random(CLASS_PAIRS_LARGE[2])); fi;
    ClassShifts         := List([1..nocs],i->Random(classes));
    ClassReflections    := List([1..nocr],i->Random(classes));
    ClassTranspositions := List(ClassTranspositions,ClassTransposition);
    ClassShifts         := List(ClassShifts,t->ClassShift(t)^Random([-1,1]));
    ClassReflections    := List(ClassReflections,ClassReflection);
    genfactors          := Concatenation(ClassTranspositions,ClassShifts,
                                         ClassReflections);
    result              := Product(genfactors);
    if result = 1 then result := One(RCWA_Z); fi;
    if not tame then SetFactorizationIntoCSCRCT(result,genfactors); fi;
    if tame then
      integralpairs := Filtered(CLASS_PAIRS[2],t->t[2]=t[4]);
      g := One(RCWA_Z);
      for i in [1..Random([1..3])] do
        g := g * ClassTransposition(Random(integralpairs));
      od;
      result := g^result;
      SetIsTame(result,true);
      SetOrder(result,Order(g));
    fi;
    IsBijective(result);
    return result;
  end );

#############################################################################
##
#M  Random( RCWA( <R> ) ) . . . . . . . . . . . a `random' element of RCWA(R)
##
InstallMethod( Random,
               "for RCWA(R) (RCWA)", true, [ IsNaturalRCWA ], 0,

  function ( RCWA_R )
    return Random( CT( Support( RCWA_R ) ) );
  end );

#############################################################################
##
#M  Random( CT( Integers ) ) . . . . . . . . . .  a `random' element of CT(Z)
##
InstallMethod( Random,
               "for CT(Z) (RCWA)", true, [ IsNaturalCT_Z ], SUM_FLAGS,

  function ( CT_Z )

    local  noct;

    noct := ValueOption("NumberOfCTs");
    if noct = fail then noct := RootInt(Random([0..125]),3); fi;
    return Random(RCWA(Integers):NumberOfCTs:=noct,NumberOfCSs:=0,
                                 NumberOfCRs:=0);
  end );

#############################################################################
##
#M  Random( CT( <R> ) ) . . . . . . . . . . . . . a `random' element of CT(R)
##
InstallMethod( Random,
               "for CT(R) (RCWA)", true, [ IsNaturalCT ], 0,

  function ( CT_R )

    local  result, R, tame, noct, ClassTranspositions,
           classpairs, integralpairs, maxm, x, g, i;

    if   IsNaturalCT_Z(CT_R)  # For CT(Z) there is a better method available.
    then TryNextMethod(); fi;
    R := Support(CT_R);
    tame := ValueOption("IsTame") = true;
    noct := ValueOption("NumberOfCTs");
    if noct = fail then if not tame then noct := RootInt(Random([0..100]),3);
                                    else noct := Random([0..2]); fi; fi;
    if IsZ_pi(R) then
      maxm := Maximum(NoninvertiblePrimes(R));
      maxm := Maximum(maxm,Minimum(NoninvertiblePrimes(R))^2);
      classpairs := List(ClassPairs(R,maxm),
                         t->[ResidueClass(R,t[2],t[1]),
                             ResidueClass(R,t[4],t[3])]);
    elif IsFiniteFieldPolynomialRing(R) then
      x          := IndeterminatesOfPolynomialRing(R)[1];
      classpairs := ClassPairs(R,x^3);
    fi;
    ClassTranspositions := List([1..noct],i->Random(classpairs));
    ClassTranspositions := List(ClassTranspositions,ClassTransposition);
    result              := Product(ClassTranspositions);
    if result = 1 then result := One(CT_R); fi;
    if   not tame
    then SetFactorizationIntoCSCRCT(result,ClassTranspositions); fi;
    if tame then
      integralpairs := Filtered(classpairs,t->t[2]=t[4]);
      g := One(CT_R);
      for i in [1..Random([1..3])] do
        g := g * ClassTransposition(Random(integralpairs));
      od;
      result := g^result;
      SetIsTame(result,true);
      SetOrder(result,Order(g));
    fi;
    IsBijective(result);
    return result;
  end );

#############################################################################
##
#S  The action of RCWA(R) and CT(R) on R. ///////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  RepresentativeActionOp( RCWA( <R> ), <n1>, <n2>, <act> )
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(Z) and two integers (RCWA)", ReturnTrue,
               [ IsNaturalRCWA, IsInt, IsInt, IsFunction ], 0,

  function ( RCWA_R, n1, n2, act )

    local  R;

    if act <> OnPoints then TryNextMethod(); fi;
    R := Support(RCWA_R);
    if   Characteristic(R) = 0
    then return ClassShift(R)^(n2-n1);
    else return RcwaMapping(R,One(R),[[One(R),n2-n1,One(R)]]); fi;
  end );

#############################################################################
##
#M  RepresentativeActionOp( RCWA(Integers), <l1>, <l2>, <act> )
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(Z) and two k-tuples of integers (RCWA)", ReturnTrue,
               [ IsNaturalRCWA_Z, IsList, IsList, IsFunction ], 0,

  function ( RCWA_Z, l1, l2, act )

    local  g, range, perm, exp, points, n;

    points := Union(l1,l2);
    if not IsSubset(Integers,points) then return fail; fi;
    range := [1..Maximum(points)-Minimum(points)+1]; n := Length(range);
    exp := -Minimum(points)+1;
    perm := RepresentativeAction(SymmetricGroup(n),l1+exp,l2+exp,act);
    if perm = fail then return fail; fi;
    g := RcwaMapping(perm,range);
    return g^(ClassShift(0,1)^-exp);
  end );

#############################################################################
##
#M  RepresentativeActionOp( RCWA( <R> ), <S1>, <S2>, <act> ) 
##
##  Returns an rcwa mapping <g> of <R> which maps <S1> to <S2>.
##  The sets <S1> and <S2> must be unions of residue classes of <R>.
##  The argument <act> is ignored.
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(R) and two residue class unions (RCWA)",
               ReturnTrue,
               [ IsNaturalRCWA, IsResidueClassUnion,
                 IsResidueClassUnion, IsFunction ], 0,

  function ( RCWA_R, S1, S2, act )

        local  Refine, Refinement, R, S, C, g;

    Refinement := function ( cls, lng )

      local  m, splitcl, parts;

      while Length(cls) <> lng do
        m       := Minimum(List(cls,Modulus));
        splitcl := First(cls,cl->Modulus(cl)=m); RemoveSet(cls,splitcl);
        parts := SplittedClass(splitcl,SizeOfSmallestResidueClassRing(R));
        if Length(parts) > lng - Length(cls) + 1 then return fail; fi;
        cls := Union(cls,parts);
      od;
      return cls;
    end;

    Refine := function ( S )
      if   Length(S[1]) > Length(S[2])
      then S[2] := Refinement(S[2],Length(S[1]));
      elif Length(S[2]) > Length(S[1])
      then S[1] := Refinement(S[1],Length(S[2])); fi;
    end;

    R := Support(RCWA_R);
    if not IsSubset(R,S1) or not IsSubset(R,S2) then return fail; fi;
    S := List([S1,S2],AsUnionOfFewClasses);
    C := List([S1,S2],Si->AsUnionOfFewClasses(Difference(R,Si)));
    Refine(S); Refine(C);
    if fail in S or fail in C then return fail; fi;
    g := RcwaMapping(Concatenation(S[1],C[1]),Concatenation(S[2],C[2]));
    return g;
  end );

#############################################################################
##
#M  RepresentativeActionOp( CT( <R> ), <S1>, <S2>, <act> ) 
##
##  Returns an element <g> of CT(<R>) which maps <S1> to <S2>.
##  The sets <S1> and <S2> must be unions of residue classes of <R>.
##  The argument <act> is ignored.
##
InstallMethod( RepresentativeActionOp,
               "for CT(R) and two residue class unions (RCWA)",
               ReturnTrue,
               [ IsNaturalCT, IsResidueClassUnion,
                 IsResidueClassUnion, IsFunction ], 0,

  function ( CT_R, S1, S2, act )

        local  Refine, Refinement, R, S, D1, D2, length, factors, g;

    Refinement := function ( cls, lng )

      local  m, splitcl, parts;

      while Length(cls) <> lng do
        m       := Minimum(List(cls,Modulus));
        splitcl := First(cls,cl->Modulus(cl)=m); RemoveSet(cls,splitcl);
        parts := SplittedClass(splitcl,SizeOfSmallestResidueClassRing(R));
        if Length(parts) > lng - Length(cls) + 1 then return fail; fi;
        cls := Union(cls,parts);
      od;
      return cls;
    end;

    Refine := function ( S )

      local  maxlength, i;

      maxlength := Maximum(List(S,Length));
      for i in [1..Length(S)] do
        if   Length(S[i]) < maxlength
        then S[i] := Refinement(S[i],maxlength); fi;
      od;
    end;

    R := Support(CT_R);
    if not IsSubset(R,S1) or not IsSubset(R,S2) then return fail; fi;

    if IsSubset(S2,S1) then D1 := Difference(S2,S1);
                       else D1 := Difference(R,S1); fi;
    D2 := Difference(R,Union(D1,S2));

    S := List([S1,D1,D2,S2],AsUnionOfFewClasses);
    Refine(S); if fail in S then return fail; fi;
    length := Length(S[1]);

    factors := List([1..3],
                    i->List([1..length],
                            j->ClassTransposition(S[i][j],S[i+1][j])));
    factors := Flat(factors);

    g := Product(Flat(factors));
    SetFactorizationIntoCSCRCT(g,factors);

    return g;
  end );

#############################################################################
##
#M  RepresentativeActionOp( RCWA( Integers ), <P1>, <P2>, <act> ) 
##
##  Returns an rcwa mapping <g> which maps the partition <P1> to the
##  partition <P2> and which is
##
##  - affine on the elements of <P1>, if the option `IsTame' is not set
##    and all elements of both partitions <P1> and <P2> are single residue
##    classes, and
##
##  - tame, if the option `IsTame' is set.
##
##  The arguments <P1> and <P2> must be partitions of Z into equally many
##  disjoint residue class unions, and the argument <act> is ignored.
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(Z) and two class partitions (RCWA)", true,
               [ IsNaturalRCWA_Z, IsList, IsList, IsFunction ], 100,

  function ( RCWA_Z, P1, P2, act )

    local  SplitClass, g, tame, m, c, P, min, minpos, Phat, Buckets, b,
           k, ri, mi, rtildei, mtildei, ar, br, cr, r, i, j;

    SplitClass := function ( i, j )

      local  mods, pos, m, r, mtilde, r1, r2, j2, pos2;

      mods := List(Buckets[i][j],Modulus);
      m    := Minimum(mods);
      pos  := Position(mods,m);
      r    := Residues(Buckets[i][j][pos])[1];
      mtilde := 2*m; r1 := r; r2 := r + m;
      Buckets[i][j] := Union(Difference(Buckets[i][j],[Buckets[i][j][pos]]),
                             [ResidueClass(Integers,mtilde,r1),
                              ResidueClass(Integers,mtilde,r2)]);
      j2  := Filtered([1..k],
                      j->Position(Buckets[3-i][j],
                                  ResidueClass(Integers,m,r))<>fail)[1];
      pos2 := Position(Buckets[3-i][j2],ResidueClass(Integers,m,r));
      Buckets[3-i][j2] := Union(Difference( Buckets[3-i][j2],
                                           [Buckets[3-i][j2][pos2]]),
                                [ResidueClass(Integers,mtilde,r1),
                                 ResidueClass(Integers,mtilde,r2)]);
    end;

    if   Length(P1) <> Length(P2)
      or not ForAll(P1,IsResidueClassUnionOfZ)
      or not ForAll(P2,IsResidueClassUnionOfZ)
      or [Union(List(P1,IncludedElements)),Union(List(P1,ExcludedElements)),
          Union(List(P2,IncludedElements)),Union(List(P2,ExcludedElements))]
         <> [[],[],[],[]]
      or Sum(List(P1,Density)) <> 1 or Sum(List(P2,Density)) <> 1
      or Union(P1) <> Integers or Union(P2) <> Integers
    then TryNextMethod(); fi;

    if not ForAll(P1,IsResidueClass) or not ForAll(P2,IsResidueClass) then
      P1 := List(P1,AsUnionOfFewClasses);
      P2 := List(P2,AsUnionOfFewClasses);
      P  := [P1,P2];
      for j in [1..Length(P1)] do
        if Length(P[1][j]) <> Length(P[2][j]) then
          if Length(P[1][j]) < Length(P[2][j]) then i := 1; else i := 2; fi;
          repeat
            min    := Minimum(List(P[i][j],Modulus));
            minpos := Position(List(P[i][j],Modulus),min);
            P[i][j][minpos] := SplittedClass(P[i][j][minpos],2);
            P[i][j] := Flat(P[i][j]);
          until Length(P[1][j]) = Length(P[2][j]);
        fi;
      od;
      P1 := Flat(P[1]); P2 := Flat(P[2]);
    fi;

    if ValueOption("IsTame") <> true then
      g := RcwaMapping(P1,P2);
    else
      k       := Length(P1);
      m       := Lcm(List(Union(P1,P2),Modulus));
      P       := [P1,P2];
      Phat    := List([0..m-1],r->ResidueClass(Integers,m,r));
      Buckets := List([1..2],i->List([1..k],j->Filtered(Phat,
                 cl->Residues(cl)[1] mod Modulus(P[i][j]) =
                 Residues(P[i][j])[1])));
      repeat
        for i in [1..k] do
          b := [Buckets[1][i],Buckets[2][i]];
          if Length(b[2]) > Length(b[1]) then
            for j in [1..Length(b[2])-Length(b[1])] do
              SplitClass(1,i);
            od;
          elif Length(b[1]) > Length(b[2]) then
            for j in [1..Length(b[1])-Length(b[2])] do
              SplitClass(2,i);
            od;
          fi;
        od;
      until ForAll([1..k],i->Length(Buckets[1][i]) = Length(Buckets[2][i]));
      g := RcwaMapping(Flat(Buckets[1]),Flat(Buckets[2]));
      SetIsTame(g,true); SetRespectedPartition(g,Set(Flat(Buckets[1])));
    fi;
    return g;
  end );

#############################################################################
##
#M  RepresentativeActionOp( RCWA( <R> ), <P1>, <P2>, <act> ) 
##
##  Returns an rcwa mapping <g> which maps the partition <P1> to the
##  partition <P2> and which is affine on the elements of <P1>.
##
##  The arguments <P1> and <P2> must be partitions of <R> into equally
##  many residue classes, and the argument <act> is ignored.
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(<R>) and two class partitions (RCWA)", true,
               [ IsNaturalRCWA, IsList, IsList, IsFunction ], 0,

  function ( RCWA_R, P1, P2, act )

    local  R, g;

    R := Support(RCWA_R);

    if   Length(P1) <> Length(P2)
      or not ForAll(Union(P1,P2),IsResidueClass)
      or not ForAll(Union(P1,P2),cl->IsSubset(R,cl))
      or not ForAll([P1,P2],P->Sum(List(P,Density))=1)
      or not ForAll([P1,P2],P->Union(P) = R)
    then TryNextMethod(); fi;

    return RcwaMapping(P1,P2);
  end );

#############################################################################
##
#S  Conjugacy of elements in RCWA(R) and CT(R). /////////////////////////////
##
#############################################################################

#############################################################################
##
#M  IsConjugate( RCWA( Integers ), <f>, <g> ) 
##
##  This method checks whether the `standard conjugates' of <f> and <g> are
##  equal, if the mappings are tame, and looks for different lengths of short
##  cycles otherwise. The latter will often not terminate. In particular this
##  is the case if <f> and <g> are conjugate.
##
InstallMethod( IsConjugate,
               "for two rcwa mappings of Z, in RCWA(Z) (RCWA)",
               true, [ IsNaturalRCWA_Z, IsRcwaMappingOfZ,
                       IsRcwaMappingOfZ ], 0,

  function ( RCWA_Z, f, g )

    local  maxlng;

    if f = g then return true; fi;
    if Order(f) <> Order(g) or IsTame(f) <> IsTame(g) then return false; fi;
    if IsTame(f) then
      return StandardConjugate(f) = StandardConjugate(g);
    else
      maxlng := 2;
      repeat
        if    Collected(List(ShortCycles(f,maxlng),Length))
           <> Collected(List(ShortCycles(g,maxlng),Length))
        then return false; fi;
        maxlng := maxlng * 2;
      until false;
    fi;
  end );

#############################################################################
##
#M  IsConjugate( RCWA( Z_pi( <pi> ) ), <f>, <g> ) 
##
##  This method makes only trivial checks. It cannot confirm conjugacy
##  unless <f> and <g> are equal.
##
InstallMethod( IsConjugate,
               "for two rcwa mappings of Z_(pi) in RCWA(Z_(pi)) (RCWA)",
               ReturnTrue, [ IsNaturalRCWA_Z_pi,
                             IsRcwaMappingOfZ_pi, IsRcwaMappingOfZ_pi ], 0,

  function ( RCWA_Z_pi, f, g )

    local  maxlng;

    if not f in RCWA_Z_pi or not g in RCWA_Z_pi then return fail; fi;
    if f = g then return true; fi;
    if Order(f) <> Order(g) or IsTame(f) <> IsTame(g) then return false; fi;
    maxlng := 2;
    repeat
      if    Collected(List(ShortCycles(f,maxlng),Length))
         <> Collected(List(ShortCycles(g,maxlng),Length))
      then return false; fi;
      maxlng := maxlng * 2;
    until false;
  end );

#############################################################################
##
#M  RepresentativeActionOp( RCWA( Integers ), <f>, <g>, <act> ) 
##
##  This method is for tame rcwa mappings of Z under the conjugation action
##  of RCWA(Z). It returns an rcwa mapping <h> such that <f>^<h> = <g> in
##  case such a mapping exists and fail otherwise. The action <act> must be
##  `OnPoints'.
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(Z) and two tame rcwa mappings of Z (RCWA)", true,
               [ IsNaturalRCWA_Z, IsRcwaMappingOfZ, IsRcwaMappingOfZ,
                 IsFunction ], 0,

  function ( RCWA_Z, f, g, act )
    if act <> OnPoints then TryNextMethod(); fi;
    if f = g then return One(f); fi;
    if not ForAll([f,g],IsTame) then TryNextMethod(); fi;
    if Order(f) <> Order(g) then return fail; fi;
    if StandardConjugate(f) <> StandardConjugate(g) then return fail; fi;
    return StandardizingConjugator(f) * StandardizingConjugator(g)^-1;
  end );

#############################################################################
##
#M  RepresentativeActionOp( RCWA( Integers ), <f>, <g>, <act> ) 
##
##  This method is for tame rcwa mappings of Z under the conjugation action
##  of RCWA(Z). It covers the special case of products of the same numbers of
##  class shifts, inverses of class shifts, class reflections and class
##  transpositions, each, whose supports are pairwise disjoint and do not
##  entirely cover Z up to a finite complement.
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(Z) and products of disjoint CS/CR/CT (RCWA)", true,
               [ IsNaturalRCWA_Z, IsRcwaMappingOfZ, IsRcwaMappingOfZ,
                 IsFunction ], 100,

  function ( RCWA_Z, f, g, act )

    local  RefinedPartition, Sorted, maps, facts, P, l, sigma, i;

    RefinedPartition := function ( P, k )

      local  l, mods, min, pos;

      P := ShallowCopy(P); l := Length(P);
      while l < k do
        mods   := List(P,Modulus);
        min    := Minimum(mods);
        pos    := Position(mods,min);
        P[pos] := SplittedClass(P[pos],2);
        P      := Flat(P);
        l      := l + 1;
      od;
      return P;
    end;

    Sorted := l -> [Filtered(l,fact->IsClassShift(fact)
                                  or IsClassShift(fact^-1)),
                    Filtered(l,IsClassReflection),
                    Filtered(l,IsClassTransposition)];              

    if act <> OnPoints then TryNextMethod(); fi;
    if f = g then return One(f); fi;
    if not ForAll([f,g],IsTame) then TryNextMethod(); fi;
    if Order(f) <> Order(g) then return fail; fi;
    maps  := [f,g];
    facts := List(maps,FactorizationIntoCSCRCT);
    if   Length(facts[1]) <> Length(facts[2])
      or 1 in List(maps,map->Density(Support(map)))
      or ForAny([1..2],i->Density(Support(maps[i]))
                       <> Sum(List(facts[i],fact->Density(Support(fact)))))
      or not ForAll(Union(facts),
                    fact ->   IsClassShift(fact) or IsClassShift(fact^-1)
                           or IsClassReflection(fact)
                           or IsClassTransposition(fact))
    then TryNextMethod(); fi;
    facts := List(facts,Sorted);
    if   List(facts[1],Length) <> List(facts[2],Length)
    then TryNextMethod(); fi;
    P := List(maps,
              map->AsUnionOfFewClasses(Difference(Integers,Support(map))));
    l  := Maximum(List(P,Length));
    for i in [1..2] do
      if l > Length(P[i]) then P[i] := RefinedPartition(P[i],l); fi;
    od;
    for i in [1..2] do
      Append(P[i],Flat(List(Flat(facts[i]),
                  fact->Filtered(LargestSourcesOfAffineMappings(fact),
                                 cl->Intersection(Support(fact),cl)<>[]))));
    od;
    sigma := RcwaMapping(P[1],P[2]);
    for i in [1..Length(facts[1][1])] do
      if   Number([facts[1][1][i]^-1,facts[2][1][i]^-1],IsClassShift) = 1
      then sigma := ClassReflection(Support(facts[1][1][i])) * sigma; fi;
    od;
    if f^sigma <> g then Error("`RepresentativeAction' failed.\n"); fi;
    return sigma;
  end );

#############################################################################
##
#M  RepresentativeActionOp( CT( <R> ), <ct1>, <ct2>, <act> ) 
##
##  This is a special method for two class transpositions whose supports have
##  nontrivial complements, under the conjugation action of CT(<R>).
##  The factorization of the result into 6 class transpositions is stored.
##  The existence of such products is used in the proof that the group which
##  is generated by all class transpositions of Z is simple.
##
InstallMethod( RepresentativeActionOp,
               "for CT(R) and two class transpositions (RCWA)", ReturnTrue,
               [ IsNaturalCT, IsClassTransposition, IsClassTransposition,
                 IsFunction ], 50,

  function ( G, ct1, ct2, act )

    local  R, result, sixcts, cls, D, supd, pieces, factors, d, two;

    R := Support(G);

    if act <> OnPoints or Source(ct1) <> R or Source(ct2) <> R
      or R in List([ct1,ct2],Support)
    then TryNextMethod(); fi;

    if   IsRing(R) then two := 2;
    elif IsZxZ(R)  then two := [1,2];
    else TryNextMethod(); fi;

    cls  := Concatenation(List([ct1,ct2],TransposedClasses));
    supd := 1 - Sum(List(cls{[3,4]},Density));
    D := AsUnionOfFewClasses(Difference(R,Union(cls{[1,2]})))[1];
    pieces := Int(Density(D)/supd)+1;
    if   IsZ_pi(R) then
      while not IsSubset(NoninvertiblePrimes(R),Factors(pieces)) do
        pieces := pieces + 1;
      od;
    elif IsFiniteFieldPolynomialRing(R) then
      while SmallestRootInt(pieces) <> Characteristic(R) do
        pieces := pieces + 1;
      od;
    elif IsZxZ(R) then
      d := RootInt(pieces,2);
      repeat
        factors := [d,pieces/d];
        d := d - 1;
      until ForAll(factors,IsInt);
      pieces := factors;
    fi;
    D := SplittedClass(D,pieces)[1];
    Append(cls,SplittedClass(D,two));
    D := AsUnionOfFewClasses(Difference(R,Union(cls{[3..6]})));
    if Length(D) = 1 then D := SplittedClass(D[1],two); fi;
    Append(cls,D{[1,2]});
    sixcts := List([cls{[1,5]},cls{[2,6]},cls{[5,7]},
                    cls{[6,8]},cls{[3,7]},cls{[4,8]}],ClassTransposition);
    result := Product(sixcts);
    SetFactorizationIntoCSCRCT(result,sixcts);
    return result;
  end );

#############################################################################
##
#F  NrConjugacyClassesOfRCWAZOfOrder( <ord> ) . #Ccl of RCWA(Z) / order <ord>
##
InstallGlobalFunction( NrConjugacyClassesOfRCWAZOfOrder,

  function ( ord )
    if   not IsPosInt(ord) then return 0;
    elif ord = 1 then return 1;
    elif ord mod 2 = 0 then return infinity;
    else return Length(Filtered(Combinations(DivisorsInt(ord)),
                                l -> l <> [] and Lcm(l) = ord));
    fi;
  end );

#############################################################################
##
#F  NrConjugacyClassesOfCTZOfOrder( <ord> ) . . . #Ccl of CT(Z) / order <ord>
##
InstallGlobalFunction( NrConjugacyClassesOfCTZOfOrder,

  function ( ord )
    if   not IsPosInt(ord) then return 0;
    elif ord = 1 then return 1;
    else Info(InfoWarning,1,"Function `NrConjugacyClassesOfCTZOfOrder' ",
                            "assumes the conjecture ");
         Info(InfoWarning,1,"that CT(Z) is the setwise ",
                            "stabilizer of N_0 in RCWA(Z).");
         return Length(Filtered(Combinations(DivisorsInt(ord)),
                                l -> l <> [] and Lcm(l) = ord));
    fi;
  end );

#############################################################################
##
#S  Conjugacy of subgroups in RCWA(R) and CT(R). ////////////////////////////
##
#############################################################################

#############################################################################
##
#M  RepresentativeActionOp( RCWA(Integers), <G>, <H>, <act> )
##
InstallMethod( RepresentativeActionOp,
               "for RCWA(Z) and two rcwa groups over Z (RCWA)", ReturnTrue,
               [ IsNaturalRCWA_Z, IsRcwaGroupOverZ, IsRcwaGroupOverZ,
                 IsFunction ], 0,

  function ( RCWA_Z, G, H, act )

    local  PG, PH, Gp, Hp, suppG, suppH, fixG, fixH, d, i, j, m, g, perm,
           dontdelegate;

    if act <> OnPoints then TryNextMethod(); fi;   
    if   (Density(Support(G))  = 1 and Density(Support(H)) <> 1)
      or (Density(Support(G)) <> 1 and Density(Support(H))  = 1)
    then return fail; fi;
    if IsTame(G) <> IsTame(H) or Size(G) <> Size(H) then return fail; fi;

    dontdelegate := ValueOption("dontdelegate") = true;

    if IsTame(G) then
      PG := RespectedPartition(G);
      PH := RespectedPartition(H);
      if IsIntegers(Support(G)) and Length(PG) <> Length(PH) then
        if dontdelegate then
          return "gave up: supp(G) = supp(H) = Z and |P_G| <> |P_H|";
        fi;
        TryNextMethod();
      fi;
      suppG := Filtered(PG,cl->IsSubset(Support(G),cl));
      suppH := Filtered(PH,cl->IsSubset(Support(H),cl));
      if Length(suppG) <> Length(suppH) then
        if dontdelegate then
          return "gave up: #classes in supp(G) and supp(H) are distinct";
        fi;
        TryNextMethod();
      fi;
      d := Length(PG) - Length(PH);
      if d < 0 then
        fixG := Difference(PG,suppG);
        for i in [1..-d] do
          m := Minimum(List(fixG,Mod));
          j := First([1..Length(fixG)],j->Mod(fixG[j])=m);
          fixG[j] := SplittedClass(fixG[j],2);
          fixG := Set(Flat(fixG)); 
        od;
        PG := Concatenation(suppG,fixG);
      elif d > 0 then
        fixH := Difference(PH,suppH);
        for i in [1..d] do
          m := Minimum(List(fixH,Mod));
          j := First([1..Length(fixH)],j->Mod(fixH[j])=m);
          fixH[j] := SplittedClass(fixH[j],2);
          fixH := Set(Flat(fixH)); 
        od;
        PH := Concatenation(suppH,fixH);
      fi;
      Gp := Action(G,PG);
      Hp := Action(H,PH);
      perm := RepresentativeAction(SymmetricGroup(Length(PG)),
                                   Gp,Hp,OnPoints);
      if perm = fail then
        if dontdelegate then
          return "gave up: actions of G on P_G and H on P_H not conjugate";
        fi;
        TryNextMethod();
      fi;
      g := RcwaMapping(PG,Permuted(PH,perm^-1));
      if IsSignPreserving(G) and IsSignPreserving(H) then return g; fi;
      if G^g = H then return g; else
        if dontdelegate then
          return "gave up: conjugation test failed: G^g <> H";
        fi;
        TryNextMethod();
      fi;
    else
      if dontdelegate then return "gave up: both groups are wild"; fi;
      TryNextMethod();
    fi;
  end );

#############################################################################
##
#S  Constructing rcwa groups: ///////////////////////////////////////////////
#S  The general things. /////////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  IsomorphismRcwaGroup( <G>, <R> ) . . . . . . . . . general wrapper method
##
InstallMethod( IsomorphismRcwaGroup,
               "general wrapper method (RCWA)", true,
               [ IsGroup, IsRing ], 0,

  function ( G, R )

    local  phi, phi1, phi2, H, gensG, gensH, pi;

    if   IsIntegers(R) and HasIsomorphismRcwaGroupOverZ(G)
    then return IsomorphismRcwaGroupOverZ(G); fi;
    if IsFinite(G) then TryNextMethod(); fi;  # Handled in a separate method.
    if IsRcwaGroupOverZ(G) and IsZ_pi(R) then # Use "1 to 1" translation.
      gensG := GeneratorsOfGroup(G);
      pi    := NoninvertiblePrimes(R);
      if   not ForAll(gensG,g->IsSubset(pi,Factors(Modulus(g))))
      then TryNextMethod(); fi;
      gensH := List(gensG,g->SemilocalizedRcwaMapping(g,pi));
      if not IsGeneratorsOfMagmaWithInverses(gensH) then TryNextMethod(); fi;
      H     := Group(gensH);
      phi   := EpimorphismByGeneratorsNC(G,H);
      SetIsBijective(phi,true);
      return phi;
    fi;
    if not IsRcwaGroup(G) and IsZ_pi(R) then  # Use rcwa group over Z as an
      phi1 := IsomorphismRcwaGroupOverZ(G);   # intermediate step.
      phi2 := IsomorphismRcwaGroup(Image(phi1),R);
      phi  := CompositionMapping(phi2,phi1);
      return phi;
    fi;
    TryNextMethod();
  end );

#############################################################################
##
#M  IsomorphismRcwaGroup( <G> ) . . . one-argument method, use Z as base ring
##
InstallMethod( IsomorphismRcwaGroup,
               "one-argument method, use Z as base ring (RCWA)", true,
               [ IsGroup ], 0, G -> IsomorphismRcwaGroup( G, Integers ) );

#############################################################################
##
#M  IsomorphismRcwaGroupOverZ( <G> ) . . . dispatch to `IsomorphismRcwaGroup'
##
InstallMethod( IsomorphismRcwaGroupOverZ,
               "dispatch to `IsomorphismRcwaGroup' (RCWA)", true,
               [ IsGroup ], 0, IsomorphismRcwaGroup );

#############################################################################
##
#S  Constructing rcwa groups: ///////////////////////////////////////////////
#S  Tame groups (cyclic, dihedral, finitely generated abelian, finite). /////
##
#############################################################################

#############################################################################
##
#M  CyclicGroupCons( IsRcwaGroupOverZ, <n> )
##
InstallMethod( CyclicGroupCons,
               "rcwa group over Z, for a positive integer (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsPosInt ], 0,

  function ( filter, n )

    local  result;

    if n = 1 then return TrivialRcwaGroupOverZ; fi;
    result := Image(IsomorphismRcwaGroupOverZ(CyclicGroup(IsPermGroup,n)));
    SetSize(result,n); SetIsCyclic(result,true);
    SetIsTame(result,true); SetIsIntegral(result,true);
    return result;
  end );

#############################################################################
##
#M  CyclicGroupCons( IsRcwaGroupOverZ, infinity )
##
InstallOtherMethod( CyclicGroupCons,
                    "(Z,+) as an rcwa group (RCWA)", ReturnTrue,
                    [ IsRcwaGroupOverZ, IsInfinity ], 0,

  function ( filter, infty )

    local  result;

    result := Group(ClassShift(0,1));
    SetSize(result,infinity); SetIsCyclic(result,true);
    SetIsTame(result,true); SetIsIntegral(result,true);
    return result;
  end );

#############################################################################
##
#M  DihedralGroupCons( IsRcwaGroupOverZ, infinity )
##
InstallOtherMethod( DihedralGroupCons,
                    "the rcwa group < n |-> n+1, n |-> -n > (RCWA)",
                    ReturnTrue, [ IsRcwaGroupOverZ, IsInfinity ], 0,

  function ( filter, infty )

    local  result;

    result := Group(ClassShift(0,1),ClassReflection(0,1));
    SetSize(result,infinity);
    SetIsTame(result,true); SetIsIntegral(result,true);
    return result;
  end );

#############################################################################
##
#M  DihedralGroupCons( IsRcwaGroup, <cl> ) . . . . . . .  for a residue class
##
InstallOtherMethod( DihedralGroupCons,
                    "for a residue class (RCWA)",
                    ReturnTrue, [ IsRcwaGroup, IsResidueClass ], 0,

  function ( filter, cl )

    local  result;

    result := Group(ClassShift(cl),ClassReflection(cl));
    SetIsTame(result,true); SetIsIntegral(result,true);
    return result;
  end );

#############################################################################
##
#M  DihedralGroupCons( IsPcGroup, <cl> ) . . . . . . . .  for a residue class
##
##  This is a dirty hack to make DihedralGroup( <cl> ) work.
##
InstallOtherMethod( DihedralGroupCons,
                    "for a residue class (RCWA)",
                    ReturnTrue, [ IsPcGroup, IsResidueClass ], 0,

  function ( filter, cl )

    local  result;

    result := Group(ClassShift(cl),ClassReflection(cl));
    SetIsTame(result,true); SetIsIntegral(result,true);
    return result;
  end );

#############################################################################
##
#M  SymmetricGroupCons( IsRcwaGroup, <P> ) for a part. of a ring into res.cl.
##
InstallOtherMethod( SymmetricGroupCons,
                    "for a partition of a ring into residue classes (RCWA)",
                    ReturnTrue, [ IsRcwaGroup, IsList ], 0,

  function ( filter, P )

    local  Sym, g;

    if    ForAll(P,IsResidueClass)
      and Length(Set(List(P,cl->UnderlyingRing(FamilyObj(cl))))) = 1
    then
      Sym := Group(RcwaMapping([P]),RcwaMapping([P{[1,2]}]));
      SetSize(Sym,Factorial(Length(P)));
      SetIsTame(Sym,true);
      SetRespectedPartition(Sym,P);
      return Sym;
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  SymmetricGroupCons( IsPermGroup, <P> ) for a part. of a ring into res.cl.
##
##  This is a dirty hack to make SymmetricGroup( <P> ) work.
##
InstallOtherMethod( SymmetricGroupCons,
                    "for a partition of a ring into residue classes (RCWA)",
                    ReturnTrue, [ IsPermGroup, IsList ], SUM_FLAGS,

  function ( filter, P )
    if   not IsEmpty(P) and ForAll(P,IsResidueClass)
    then return SymmetricGroupCons(IsRcwaGroup,P);
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  AbelianGroupCons( IsRcwaGroupOverZ, <invs> )
##
InstallMethod( AbelianGroupCons,
               "rcwa group over Z, for list of abelian inv's (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsList ], 0,

  function ( filter, invs )

    local  result;

    if not ForAll(invs,n->IsInt(n) or n=infinity) then TryNextMethod(); fi;
    result := DirectProduct(List(invs,n->CyclicGroup(IsRcwaGroupOverZ,n)));
    SetSize(result,Product(invs)); SetIsAbelian(result,true);
    SetIsTame(result,true); SetIsIntegral(result,true);
    return result;
  end );

#############################################################################
##
#M  IsomorphismRcwaGroup( <gl>, <cl> )  GL(2,Z) on given residue class of Z^2
##
InstallMethod( IsomorphismRcwaGroup,
               "GL(2,Z) on a given residue class of Z^2 (RCWA)", ReturnTrue,
               [ IsIntegerMatrixGroup and IsNaturalGL, IsResidueClassOfZxZ ],
               0,

  function ( gl, cl )

    local  phi, img;

    if DimensionOfMatrixGroup(gl) <> 2 then TryNextMethod(); fi;

    img := Group(List(GeneratorsOfGroup(gl),gen->ClassRotation(cl,gen)));
    phi := EpimorphismByGeneratorsNC(gl,img);

    SetIsBijective(phi,true);
    SetIsNaturalRcwaRepresentationOfGLOrSL(phi,true);

    return phi;
  end );

#############################################################################
##
#M  IsomorphismRcwaGroup( <sl>, <cl> )  SL(2,Z) on given residue class of Z^2
##
InstallMethod( IsomorphismRcwaGroup,
               "SL(2,Z) on a given residue class of Z^2 (RCWA)", ReturnTrue,
               [ IsIntegerMatrixGroup and IsNaturalSL, IsResidueClassOfZxZ ],
               0,

  function ( sl, cl )

    local  phi, img;

    if DimensionOfMatrixGroup(sl) <> 2 then TryNextMethod(); fi;

    img := Group(List(GeneratorsOfGroup(sl),gen->ClassRotation(cl,gen)));
    phi := EpimorphismByGeneratorsNC(sl,img);

    SetIsBijective(phi,true);
    SetIsNaturalRcwaRepresentationOfGLOrSL(phi,true);

    return phi;
  end );

#############################################################################
##
#M  ImagesRepresentative( <phi>, <mat> )  for rcwa rep. of SL(2,Z) or GL(2,Z)
##
InstallMethod( ImagesRepresentative,
               "for rcwa rep. of SL(2,Z) or GL(2,Z) over Z^2 (RCWA)",
               ReturnTrue, [ IsNaturalRcwaRepresentationOfGLOrSL, IsMatrix ],
               0,

  function ( phi, mat )

    local  G, H;

    G := Source(phi); H := Range(phi);

    if   DimensionOfMatrixGroup(G) <> 2 or not IsRcwaGroupOverZxZ(H)
    then TryNextMethod(); fi;

    if not mat in G then return fail; fi;

    return ClassRotation(Support(H),mat);
  end );

#############################################################################
##
#M  IsomorphismRcwaGroup( <G>, <R> ) . . . . default method for finite groups
##
InstallMethod( IsomorphismRcwaGroup,
               "default method for finite groups (RCWA)", true,
               [ IsGroup and IsFinite, IsRing ], 0,

  function ( G, R )

    local  H, Hgens, phi1, phi2, phi, Gperm, n, P, p, pos, maxdensity;

    if   IsRcwaGroup(G) and Source(One(G)) = R
    then return IdentityMapping(G); fi;
    if IsTrivial(G) then
      return GroupHomomorphismByImagesNC(G,TrivialSubgroup(RCWA(R)),
               [One(G)],GeneratorsOfGroup(TrivialSubgroup(RCWA(R))));
    fi;
    if   not IsPermGroup(G) 
    then phi1 := IsomorphismPermGroup(G); Gperm := Image(phi1);
    else phi1 := IdentityMapping(G);      Gperm := G; fi;
    n := LargestMovedPoint(Gperm);
    if IsIntegers(R) then P := AllResidueClassesModulo(Integers,n); else
      p := SizeOfSmallestResidueClassRing(R);
      P := [R];
      while Length(P) < n do
        maxdensity := Maximum(List(P,Density));
        pos := First([1..Length(P)], i -> Density(P[i]) = maxdensity);
        P[pos] := SplittedClass(P[pos],p);
        P := Flat(P);
      od;
      P := Set(P);
    fi;
    Hgens := List(GeneratorsOfGroup(Gperm),
                  g->RcwaMapping(List(Cycles(g,[1..n]),cyc->P{cyc})));
    H    := GroupWithGenerators(Hgens);
    SetIsTame(H,true);
    SetRespectedPartition(H,P);
    phi2 := EpimorphismByGeneratorsNC(Gperm,H);
    phi := Immutable(CompositionMapping(phi2,phi1));
    SetIsInjective(phi,true); SetIsSurjective(phi,true);
    if HasSize(G) then SetSize(Image(phi),Size(G)); fi;
    return phi;
  end );

#############################################################################
##
#S  Constructing rcwa groups: ///////////////////////////////////////////////
#S  Free groups and free products of finite groups. /////////////////////////
##
#############################################################################

#############################################################################
##
#M  IsomorphismRcwaGroup( <F>, Integers ) . . . . . . for free groups, over Z
##
##  This method uses an adaptation of the construction given on page 27
##  of the book Pierre de la Harpe: Topics in Geometric Group Theory from
##  PSL(2,C) to RCWA(Z).
##
InstallMethod( IsomorphismRcwaGroup,
               "for free groups, over Z (RCWA)", ReturnTrue,
               [ IsFreeGroup, IsIntegers ], 0,

  function ( F, ints )

    local  rank, m, D, gamma, RCWA_Z, phi, image, i;

    rank := Length(GeneratorsOfGroup(F));
    if rank = 1 then
      phi := GroupHomomorphismByImagesNC(F,Group(ClassShift(0,1)),
                                         [F.1],[ClassShift(0,1)]);
      SetSize(Image(phi),infinity); SetIsTame(Image(phi),true);
      SetIsBijective(phi,true);
      return phi;
    fi;
    m      := 2 * rank;
    D      := AllResidueClassesModulo(m);
    RCWA_Z := RCWA(Integers);
    gamma  := List([1..rank],
                   k->RepresentativeAction(RCWA_Z,
                                           Difference(Integers,D[2*k-1]),
                                           D[2*k]));
    for i in [1..rank] do
      SetIsTame(gamma[i],false); SetOrder(gamma[i],infinity);
    od;
    image := Group(gamma);
    SetSize(image,infinity); SetIsTame(image,false);
    SetRankOfFreeGroup(image,rank);
    phi := EpimorphismByGeneratorsNC(F,image);
    SetIsBijective(phi,true);
    return phi;
  end );

#############################################################################
##
#M  IsomorphismRcwaGroup( <F>, Integers )  for free products of finite groups
##
##  This method uses the Table-Tennis Lemma -- see e.g. Section II.B. in
##  the book Pierre de la Harpe: Topics in Geometric Group Theory.
##
##  The method uses regular permutation representations of the factors G_r
##  (r = 0..m-1) of the free product on residue classes modulo n_r := |G_r|.
##
##  The basic idea is that since point stabilizers in regular permutation
##  groups are trivial, all non-identity elements map any of the permuted
##  residue classes into their complements.
##
##  To get into a situation where the Table-Tennis Lemma is applicable,
##  the method computes conjugates of the images of the mentioned permutation
##  representations under bijective rcwa mappings g_r which satisfy
##  0(n_r)^g_r = Z \ r(m).
##
InstallMethod( IsomorphismRcwaGroup,
               "for free products of finite groups, over Z (RCWA)",
               ReturnTrue, [ IsFpGroup and HasFreeProductInfo,
                             IsIntegers ], 0,

  function ( F, ints )

    local  phi, img, gens, gensF, info, groups, degs, embs, embsF, embnrs,
           regreps, rcwareps, conjisos, conjelms, r, m, i;

    info   := FreeProductInfo(F);
    groups := info.groups;
    m      := Length(groups);
    degs   := List(groups,Size);
    if   m < 2 or degs = [2,2] # We cannot use the Table-Tennis L. for C2*C2.
      or ForAny(groups,IsTrivial) or not ForAll(groups,IsFinite) 
    then TryNextMethod(); fi;
    regreps  := List(groups,RegularActionHomomorphism);
    rcwareps := List(regreps,phi->IsomorphismRcwaGroupOverZ(Image(phi)));
    conjelms := List([0..m-1],r->RepresentativeAction(RCWA(Integers),
                                 ResidueClass(0,degs[r+1]),
                                 Difference(Integers,ResidueClass(r,m))));
    conjisos := List([1..m],i->ConjugatorIsomorphism(Image(rcwareps[i]),
                                                     conjelms[i]));
    embs     := List([1..m],i->CompositionMapping(conjisos[i],rcwareps[i],
                                                  regreps[i]));
    gensF    := GeneratorsOfGroup(F);
    embsF    := info.embeddings;
    embnrs   := List(gensF,
                     f->First([1..m],
                              i->ForAny(GeneratorsOfGroup(Image(embsF[i])),
                                        g->IsIdenticalObj(f,g))));
    gens     := List([1..Length(gensF)],
                     i->Image(embs[embnrs[i]],
                              PreImagesRepresentative(embsF[embnrs[i]],
                                                      gensF[i])));
    img := Group(gens);
    SetSize(img,infinity); SetIsTame(img,false);
    SetFreeProductInfo(img,info);
    phi := EpimorphismByGeneratorsNC(F,img);
    SetIsBijective(phi,true);
    return phi;
  end );

#############################################################################
##
#M  IsomorphismRcwaGroup( <F>, Integers ) .  for the free product of two C2's
##
##  This method covers the case that the free product is C2 * C2.
##
InstallMethod( IsomorphismRcwaGroup,
               "for free products of cyclic groups of order 2 (RCWA)",
               ReturnTrue, [ IsFpGroup and HasFreeProductInfo,
                             IsIntegers ], 0,

  function ( F, ints )

    local  phi, img, gens, info, groups, degs;

    info   := FreeProductInfo(F);
    groups := Filtered(info.groups,IsNonTrivial);
    degs   := List(groups,Size);
    if degs <> [2,2] then TryNextMethod(); fi;
    gens := [ClassReflection(0,1),ClassReflection(0,1)*ClassShift(0,1)];
    img  := Group(gens);
    SetIsTame(img,true); SetSize(img,infinity);
    SetFreeProductInfo(img,info);
    phi := EpimorphismByGeneratorsNC(F,img);
    SetIsBijective(phi,true);
    return phi;
  end );

#############################################################################
##
#S  Constructing rcwa groups: ///////////////////////////////////////////////
#S  Restriction monomorphisms and induction epimorphisms. ///////////////////
##
#############################################################################

#############################################################################
##
#M  Restriction( <G>, <f> ) . . . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( Restriction,
               "for rcwa groups (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRcwaMapping ], 0,

  function ( G, f )

    local Gf;

    if   Source(One(G)) <> Source(f) or not IsInjective(f)
    then return fail; fi;

    Gf := GroupByGenerators(List(GeneratorsOfGroup(G),g->Restriction(g,f)));

    if HasIsTame(G) then SetIsTame(Gf,IsTame(G)); fi;
    if HasSize(G)   then SetSize(Gf,Size(G)); fi;

    return Gf;
  end );

#############################################################################
##
#M  Induction( <G>, <f> ) . . . . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( Induction,
               "for rcwa groups (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRcwaMapping ], 0,

  function ( G, f )

    local Gf;

    if Source(One(G)) <> Source(f) or not IsInjective(f)
      or not IsSubset(Image(f),MovedPoints(G))
    then return fail; fi;

    Gf := GroupByGenerators(List(GeneratorsOfGroup(G),g->Induction(g,f)));

    if HasIsTame(G) then SetIsTame(Gf,IsTame(G)); fi;
    if HasSize(G)   then SetSize(Gf,Size(G)); fi;

    return Gf;
  end );

#############################################################################
##
#S  The automorphism switching action on negative and nonnegative integers. /
##
#############################################################################

#############################################################################
##
#M  Mirrored( <G> ) . . . . . . . . . . . . . . . . .  for rcwa groups over Z
##
InstallOtherMethod( Mirrored,
                    "for rcwa groups over Z (RCWA)",
                    true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  img;

    img := GroupByGenerators(List(GeneratorsOfGroup(G),Mirrored));
    if HasIsTame(G) then SetIsTame(img,IsTame(G)); fi;
    if HasSize(G)   then SetSize(img,Size(G)); fi;
    return img;
  end );

#############################################################################
##
#S  Constructing rcwa groups: ///////////////////////////////////////////////
#S  Taking direct products and wreath products. /////////////////////////////
##
#############################################################################

#############################################################################
##
#M  DirectProductOp( <groups>, <onegroup> ) . . . . .  for rcwa groups over Z
##
InstallMethod( DirectProductOp,
               "for rcwa groups over Z (RCWA)", ReturnTrue,
               [ IsList, IsRcwaGroupOverZ ], 0,

  function ( groups, onegroup )

    local  D, factors, f, m, G, gens, info, first;

    if   IsEmpty(groups) or not ForAll(groups,IsRcwaGroupOverZ)
    then TryNextMethod(); fi;
    m := Length(groups);
    f := List([0..m-1],r->RcwaMapping([[m,r,1]]));
    factors := List([1..m],r->Restriction(groups[r],f[r]));
    gens := []; first := [1];
    for G in factors do
      gens := Concatenation(gens,GeneratorsOfGroup(G));
      Add(first,Length(gens)+1);
    od;

    D := GroupByGenerators(gens);
    info := rec(groups := groups, first := first,
                embeddings := [ ], projections := [ ]);
    SetDirectProductInfo(D,info);

    if   ForAll(groups,HasIsTame) and ForAll(groups,IsTame)
    then SetIsTame(D,true); fi;
    if   ForAny(groups,grp->HasIsTame(grp) and not IsTame(grp))
    then SetIsTame(D,false); fi;
    if   ForAny(groups,grp->HasSize(grp) and not IsFinite(grp))
    then SetSize(D,infinity); fi;
    if   ForAll(groups,grp->HasSize(grp) and IsInt(Size(grp)))
    then SetSize(D,Product(List(groups,Size))); fi;

    return D;
  end );

#############################################################################
##
#M  WreathProduct( <G>, <P> ) .  for rcwa group over Z and finite perm.-group
##
InstallMethod( WreathProduct,
               "for an rcwa group over Z and a finite perm.-group (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsPermGroup ], 0,

  function ( G, P )

    local  prod, info, m, orbreps, gensonreps, blocks, base, h, nrgensG;

    nrgensG    := Length(GeneratorsOfGroup(G));
    m          := DegreeAction(P);
    orbreps    := List(Orbits(P,MovedPoints(P)),Representative);
    gensonreps := Concatenation(List(orbreps,r->GeneratorsOfGroup(
                                Restriction(G,RcwaMapping([[m,r-1,1]])))));
    blocks     := AllResidueClassesModulo(m);
    base       := DirectProduct(List([0..m-1],r->G));
    h          := Image(IsomorphismRcwaGroup(P,Integers));
    prod       := Group(Concatenation(gensonreps,GeneratorsOfGroup(h)));
    info       := rec( groups := [ G, P ], alpha := IdentityMapping(P),
                       base := base, basegens := GeneratorsOfGroup(base),
                       I := P, degI := m, hgens := GeneratorsOfGroup(h),
                       components := blocks,
                       embeddings := [ GroupHomomorphismByImagesNC( G, prod,
                                         GeneratorsOfGroup(G),
                                         gensonreps{[1..nrgensG]} ),
                                       GroupHomomorphismByImagesNC( P, prod,
                                         GeneratorsOfGroup(P), ~.hgens ) ] );
    SetWreathProductInfo(prod,info);
    if HasIsTame(G) then
      if IsTame(G) then
        SetIsTame(prod,true);
        if HasRespectedPartition(G) then
          SetRespectedPartition(prod,Union(List([0..m-1],
                                     r->m*RespectedPartition(G)+r)));
        fi;
      else SetIsTame(prod,false); fi;
    fi;
    if HasSize(G) then
      if IsFinite(G) then SetSize(prod,Size(G)^m*Size(P));
                     else SetSize(prod,infinity); fi;
    fi;
    return prod;
  end );

#############################################################################
##
#M  WreathProduct( <G>, <Z> ) . . . . . .  for an rcwa group over Z and (Z,+)
##
InstallMethod( WreathProduct,
               "for an rcwa group over Z and an infinite cyclic gp. (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsGroup and IsCyclic ], 0,

  function ( G, Z )

    local  prod, info, Gpi, z;

    if   Length(GeneratorsOfGroup(Z)) <> 1 or IsFinite(Z)
    then TryNextMethod(); fi;
    Gpi := Restriction(G,RcwaMapping([[4,3,1]]));
    z   := ClassTransposition(0,2,1,2) * ClassTransposition(0,2,1,4);
    SetIsTame(z,false); SetOrder(z,infinity);
    prod := Group(Concatenation(GeneratorsOfGroup(Gpi),[z]));
    info := rec( groups := [ G, Z ], alpha := IdentityMapping(Z),
                 I := Z, degI := infinity, hgens := [ z ],
                 embeddings := [ GroupHomomorphismByImagesNC( G, prod,
                                   GeneratorsOfGroup(G),
                                   GeneratorsOfGroup(Gpi)),
                                 GroupHomomorphismByImagesNC( Z, prod,
                                   GeneratorsOfGroup(Z), [z] ) ] );
    SetWreathProductInfo(prod,info);
    SetIsTame(prod,false); SetSize(prod,infinity);
    return prod;
  end );

#############################################################################
##
#M  WreathProduct( <G>, <F2> ) . . . . . . .  for an rcwa group over Z and F2
##
##  This method needs a correction:
##  The generators f1 and f2 need to be adjusted in such a way that the group
##  generated by them is not only free of rank 2, but acts also regularly on
##  a partition of Z into residue classes -- provided that this is possible!
##
InstallMethod( WreathProduct,
               "for an rcwa group over Z and a free group of rank 2 (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsGroup ], 0,

  function ( G, F2 )

    local  prod, info, Gpi, f1, f2;

    if ValueOption("RCWADevel") <> true then TryNextMethod(); fi;

    if not IsFreeGroup(F2) and not HasRankOfFreeGroup(F2)
      or RankOfFreeGroup(F2) <> 2 or Length(GeneratorsOfGroup(F2)) <> 2
    then TryNextMethod(); fi;

    Gpi := Restriction(G,RcwaMapping([[24,2,1]]));
    f1  := ClassTransposition(2,4,3,4) * ClassTransposition(4,6,8,12)
         * ClassTransposition(3,4,4,6);
    f2  := ClassTransposition(0,2,1,2) * ClassTransposition(1,2,2,4);
    SetIsTame(f1,false); SetIsTame(f2,false);
    prod := Group(Concatenation(GeneratorsOfGroup(Gpi),[f1,f2]));
    info := rec( groups := [ G, F2 ], alpha := IdentityMapping(F2),
                 I := F2, degI := infinity, hgens := [ f1, f2 ],
                 embeddings := [ GroupHomomorphismByImagesNC( G, prod,
                                   GeneratorsOfGroup(G),
                                   GeneratorsOfGroup(Gpi)),
                                 GroupHomomorphismByImagesNC( F2, prod,
                                   GeneratorsOfGroup(F2), [ f1, f2 ] ) ] );
    SetWreathProductInfo(prod,info);
    SetIsTame(prod,false); SetSize(prod,infinity);

    return prod;
  end );

#############################################################################
##
#M  Embedding( <W>, <i> ) . . . . . . . . . . for a wreath product and 1 or 2
##
InstallMethod( Embedding,
               "for a wreath product and 1 or 2 (RCWA)",
               ReturnTrue, [ HasWreathProductInfo, IsPosInt ], 0,

  function ( W, i )
    if not i in [1,2] then TryNextMethod(); fi;
    return WreathProductInfo(W).embeddings[i];
  end );

#############################################################################
##
#S  Constructing rcwa groups: ///////////////////////////////////////////////
#S  Group extensions. ///////////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#O  MergerExtension( <G>, <points>, <point> ) . . . . build rcwa group over Z
##
InstallMethod( MergerExtension,
               "build rcwa group over Z (RCWA)",
               ReturnTrue, [ IsPermGroup, IsList, IsPosInt ],

  function ( G, points, point )

    local  P, S1, S2, g, n;

    n := LargestMovedPoint(G);
    if   not IsSubset([1..n],points) or point > n or point in points
    then return fail; fi;

    P  := AllResidueClassesModulo(Integers,n);
    S1 := P{points};
    S2 := SplittedClass(P[point],Length(points));
    g  := Product([1..Length(points)],i->ClassTransposition(S1[i],S2[i]));
    return ClosureGroupAddElm(Image(IsomorphismRcwaGroupOverZ(G)),g); 
  end );

#############################################################################
##
#S  Constructing rcwa groups: ///////////////////////////////////////////////
#S  Getting smaller or otherwise nicer sets of generators. //////////////////
##
#############################################################################

#############################################################################
##
#M  SmallGeneratingSet( <G> ) . . . . . . . . . . . .  for rcwa groups over Z
##
InstallMethod( SmallGeneratingSet,
               "for rcwa groups over Z (RCWA)",
               true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  gens, gensred, H, r, modulusbound, i, shrinked;

    gens         := Set(GeneratorsOfGroup(G));
    modulusbound := Lcm(List(gens,Modulus));

    if ForAll(gens,IsClassTransposition) then
      SortParallel(List(gens,ct->[Modulus(ct),TransposedClasses(ct)]),gens);
    fi;

    Info(InfoRCWA,1,"SmallGeneratingSet: #initial generators = ",
                    Length(gens));
    Info(InfoRCWA,2,"Initial generators = ",gens);

    r := 1;
    repeat
      gensred := gens{[1]};
      for i in [2..Length(gens)] do
        Info(InfoRCWA,3,"i = ",i);
        H := Group(gens{[1..i-1]});
        if   IsEmpty(Intersection(RestrictedBall(H,One(H),r,modulusbound),
                                  RestrictedBall(H,gens[i],r,modulusbound)))
        then Add(gensred,gens[i]); fi;
      od;
      Info(InfoRCWA,1,"SmallGeneratingSet: #generators after reduction ",
                      "with r = ",r,": ",Length(gensred));
      Info(InfoRCWA,2,"Remaining generators = ",gensred);

      shrinked := Length(gensred) < Length(gens);
      gens     := gensred;
      r        := r + 1;
    until not shrinked;    

    return gens;
  end );

#############################################################################
##
#S  Constructing rcwa groups: Other. ////////////////////////////////////////
##
#############################################################################

InstallGlobalFunction( GroupByResidueClasses,

  classes -> Group( List( Filtered( Combinations( classes, 2 ),
                                    cls -> IsEmpty( Intersection( cls ) ) ),
                          ClassTransposition ) ) );

#############################################################################
##
#S  Iterators for rcwa groups. //////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  Iterator( <G> ) . . . .  for rcwa groups (and infinite groups in general)
##
InstallMethod( Iterator,
               "for rcwa groups (and infinite groups in general) (RCWA)",
               true, [ IsGroup ], 0,

  function ( G )
    if   not IsRcwaGroup(G) and HasIsFinite(G) and IsFinite(G)
    then TryNextMethod(); fi;
    return Objectify( NewType( IteratorsFamily, IsIterator
                                            and IsMutable
                                            and IsRcwaGroupsIteratorRep ),
                      rec( G         := G,
                           sphere    := [One(G)],
                           oldsphere := [],
                           pos       := 1 ) );
  end );

#############################################################################
##
#M  NextIterator( <iter> ) . . . . . . . . . . . for iterators of rcwa groups
##
InstallMethod( NextIterator,
               "for iterators of rcwa groups (RCWA)", true,
               [ IsIterator and IsMutable and IsRcwaGroupsIteratorRep ], 5,

  function ( iter )

    local  G, gens, sphere, g;

    G := iter!.G;
    if not HasGeneratorsOfGroup(G) then TryNextMethod(); fi;
    gens := GeneratorsAndInverses(G);
    g := iter!.sphere[iter!.pos];
    if iter!.pos < Length(iter!.sphere) then iter!.pos := iter!.pos + 1; else
      sphere := Difference(Union(List(gens,g->iter!.sphere*g)),
                           Union(iter!.sphere,iter!.oldsphere));
      iter!.oldsphere := iter!.sphere;
      iter!.sphere    := sphere;
      iter!.pos       := 1;
    fi;
    return g;
  end );

#############################################################################
##
#M  NextIterator( <iter> ) . .  for iterators of rcwa groups, by parent group
##
InstallMethod( NextIterator,
               "for iterators of rcwa groups, by parent group (RCWA)", true,
               [ IsIterator and IsMutable and IsRcwaGroupsIteratorRep ], 0,

  function ( iter )

    local  G, P, gens, sphere, g;

    G := iter!.G;
    if   not HasParent(G) or not HasElementTestFunction(G)
    then TryNextMethod(); fi;
    P := Parent(G);
    if not HasGeneratorsOfGroup(P) then TryNextMethod(); fi;
    gens := GeneratorsAndInverses(P);
    g := iter!.sphere[iter!.pos];
    repeat
      iter!.pos := iter!.pos + 1;
    until    iter!.pos > Length(iter!.sphere)
          or ElementTestFunction(G)(iter!.sphere[iter!.pos]) = true;
    while iter!.pos > Length(iter!.sphere) do
      sphere := Difference(Union(List(gens,g->iter!.sphere*g)),
                           Union(iter!.sphere,iter!.oldsphere));
      iter!.oldsphere := iter!.sphere;
      iter!.sphere    := sphere;
      iter!.pos       := 1;
      repeat
        iter!.pos := iter!.pos + 1;
      until    iter!.pos > Length(iter!.sphere)
            or ElementTestFunction(G)(iter!.sphere[iter!.pos]) = true;
    od;
    return g;
  end );

#############################################################################
##
#M  IsDoneIterator( <iter> ) . . . . . . . . . . for iterators of rcwa groups
##
InstallMethod( IsDoneIterator,
               "for iterators of rcwa groups (RCWA)", true,
               [ IsIterator and IsRcwaGroupsIteratorRep ], 0,
               iter -> IsEmpty( iter!.sphere ) );

#############################################################################
##
#M  ShallowCopy( <iter> ) . . . . . . . . . . .  for iterators of rcwa groups
##
InstallMethod( ShallowCopy,
               "for iterators of rcwa groups (RCWA)", true,
               [ IsIterator and IsRcwaGroupsIteratorRep ], 0,

  iter -> Objectify( Subtype( TypeObj( iter ), IsMutable ),
                     rec( G         := iter!.G,
                          sphere    := iter!.sphere,
                          oldsphere := iter!.oldsphere,
                          pos       := iter!.pos ) ) );

#############################################################################
##
#M  ViewObj( <iter> ) . . . . . . . . . . . . .  for iterators of rcwa groups
##
InstallMethod( ViewObj,
               "for iterators of rcwa groups (RCWA)", true,
               [ IsIterator and IsRcwaGroupsIteratorRep ], 0,

  function ( iter )
    Print("Iterator of ");
    ViewObj(iter!.G);
  end );

#############################################################################
##
#S  The support of an rcwa group. ///////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  MovedPoints( <G> ) . . . . . . . . . . . . . . . . . . .  for rcwa groups
##
##  Returns the set of moved points (i.e. the support) of the rcwa group <G>.
##
InstallMethod( MovedPoints,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )
    if IsNaturalRCWA(G) or IsNaturalCT(G) then return Source(One(G)); fi;
    return Union(List(GeneratorsOfGroup(G),MovedPoints));
  end );

#############################################################################
##
#S  Orbits of rcwa groups on the set of residue classes (mod m). ////////////
##
#############################################################################

#############################################################################
##
#M  OrbitsModulo( <G>, <m> ) . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( OrbitsModulo,
               "for rcwa groups (RCWA)", true,
               [ IsRcwaGroup, IsRingElement ], 0,

  function ( G, m )

    local  result, R, gens, orbit, oldorbit, orbitset, img, remaining;

    R := Source(One(G));
    if not m in R then TryNextMethod(); fi;
    gens      := GeneratorsAndInverses(G);
    remaining := AllResidueClassesModulo(R,m); result := [];
    repeat
      orbit := [remaining[1]];
      repeat
        oldorbit := ShallowCopy(orbit);
        orbitset := Union(orbit);
        img      := Union(List(gens,gen->orbitset^gen));
        orbit    := Union(orbit,
                          Filtered(remaining,cl->Intersection(cl,img)<>[]));
      until orbit = oldorbit;
      Add(result,List(orbit,Residue));
      remaining := Difference(remaining,orbit);
    until remaining = [];
    return result;
  end );

#############################################################################
##
#M  OrbitsModulo( <G>, <m> ) . . . . . . . . for rcwa groups over Z or Z_(pi)
##
InstallMethod( OrbitsModulo,
               "for rcwa groups over Z or Z_(pi) (RCWA)", true,
               [ IsRcwaGroupOverZOrZ_pi, IsPosInt ], 0,

  function ( G, m )

    local  result, orbsgen, orbit, oldorbit, remaining;

    orbsgen := Concatenation(List(GeneratorsOfGroup(G),
                                  g->OrbitsModulo(g,m)));
    remaining := [0..m-1]; result := [];
    repeat
      orbit := [remaining[1]];
      repeat
        oldorbit := ShallowCopy(orbit);
        orbit := Union(orbit,
                       Union(Filtered(orbsgen,
                                      orb->Intersection(orbit,orb)<>[])));
      until orbit = oldorbit;
      Add(result,orbit);
      remaining := Difference(remaining,orbit);
    until remaining = [];
    return result;
  end );

#############################################################################
##
#M  ProjectionsToInvariantUnionsOfResidueClasses( <G>, <m> )  for rcwa groups
##
InstallMethod( ProjectionsToInvariantUnionsOfResidueClasses,
               "for rcwa groups (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRingElement ], 0,

  function ( G, m )

    local  R, orbs, gens, groups;

    R := Source(One(G)); if not m in R then TryNextMethod(); fi;
    gens   := GeneratorsOfGroup(G);
    orbs   := List(OrbitsModulo(G,m),orb->ResidueClassUnion(R,m,orb));
    groups := List(orbs,orb->Group(List(gens,gen->RestrictedPerm(gen,orb))));
    return List(groups,grp->EpimorphismByGeneratorsNC(G,grp));
  end );

#############################################################################
##
#S  Tame rcwa groups: ///////////////////////////////////////////////////////
#S  Testing for tameness and computing respected partitions. ////////////////
##
#############################################################################

#############################################################################
##
#M  CheckForWildness( <G>, <max_r>, <cheap> ). for rcwa group & search radius
##
InstallMethod( CheckForWildness,
               "for rcwa groups (RCWA)", true,
               [ IsRcwaGroup, IsPosInt, IsBool ], 0,

  function ( G, max_r, cheap )

    local  B, r, g;

    for r in [1..max_r] do
      B := Ball(G,One(G),r);
      if cheap then
        if   not ForAll(B,IsBalanced) or ForAny(B,g->Loops(g)<>[])
        then SetIsTame(G,false); break; fi;
      else
        if   not ForAll(B,IsBalanced) or not ForAll(B,IsTame)
        then SetIsTame(G,false); break; fi;
      fi;
    od;
  end );

#############################################################################
##
#F  CommonRefinementOfPartitionsOfR_NC( <partitions> ) . . . . . general case
##
InstallGlobalFunction( CommonRefinementOfPartitionsOfR_NC,

  function ( partitions )

    local  table, partition, R, mods, res, m, reps, inds, numreps,
           pow, mj, rj, i, j, k;

    R := partitions[1][1];
    if   not IsRing(R) and not IsZxZ(R)
    then R := UnderlyingRing(FamilyObj(R)); fi;

    mods    := List(partitions,P->List(P,Mod));
    res     := List(partitions,P->List(P,Residues));
    m       := Lcm(R,Concatenation(mods));
    numreps := NumberOfResidues(R,m);
    reps    := AllResidues(R,m);
    table   := List([1..numreps],i->0);
    pow     := 1;
    for i in [1..Length(partitions)] do
      for j in [1..Length(partitions[i])] do
        mj := mods[i][j]; rj := res[i][j];
        for k in [1..numreps] do
          if   reps[k] mod mj in rj
          then table[k] := table[k] + pow; fi;
        od;
        pow := pow + pow;
      od;
    od;

    partition := EquivalenceClasses([1..numreps],k->table[k]);
    return Set(List(partition,inds->ResidueClassUnion(R,m,reps{inds})));
  end );

#############################################################################
##
#F  CommonRefinementOfPartitionsOfZ_NC( <partitions> ) . . special case R = Z
##
InstallGlobalFunction( CommonRefinementOfPartitionsOfZ_NC,

  function ( partitions )

    local  table, partition, mods, res, m,
           pow, mj, r, i, j, k;

    mods  := List(partitions,P->List(P,Mod));
    res   := List(partitions,P->List(P,Residues));
    m     := Lcm(Concatenation(mods));
    table := List([1..m],i->0);
    pow   := 1;
    for i in [1..Length(partitions)] do
      for j in [1..Length(partitions[i])] do
        mj := mods[i][j];
        for r in res[i][j] do
          for k in [r,r+mj..r+(Int(m/mj)-1)*mj] do
            table[k+1] := table[k+1] + pow;
          od;
        od;
        pow := pow + pow;
      od;
    od;
    partition := EquivalenceClasses([1..m],r->table[r]);
    return Set(List(partition,r->ResidueClassUnion(Integers,m,r-1)));
  end );

#############################################################################
##
#M  Modulus( <G> ) . . . . . . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( Modulus, 
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  R, P, m;

    if HasModulusOfRcwaMonoid(G) then return ModulusOfRcwaMonoid(G); fi;

    R := Source(One(G));
    if IsZxZ(R) then R := Integers^[2,2]; fi;

    if IsIntegral(G) then
      Info(InfoRCWA,3,"Modulus: <G> is integral.");
      m := Lcm(R,List(GeneratorsOfGroup(G),Modulus));
      SetModulusOfRcwaMonoid(G,m); return m;
    fi;

    if not HasIsTame(G) then CheckForWildness(G,2,false); fi;

    if   HasIsTame(G) and not IsTame(G)
    then SetModulusOfRcwaMonoid(G,Zero(R)); return Zero(R); fi;

    P := RespectedPartition(G);

    if   P = fail
    then SetModulusOfRcwaMonoid(G,Zero(R)); return Zero(R);
    else m := Lcm(R,List(P,Modulus));
         SetModulusOfRcwaMonoid(G,m);
         return m;
    fi;

  end );

#############################################################################
##
#M  Multiplier( <G> ) . . . . . . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( Multiplier,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  R, orbs, thin, thick, quot, int;

    R := Source(One(G));
    if not IsTame(G) then return infinity; fi;
    orbs  := Orbits(G,RespectedPartition(G));
    thin  := List(orbs,o->First(o,cl->Density(cl)=Minimum(List(o,Density))));
    thick := List(orbs,o->First(o,cl->Density(cl)=Maximum(List(o,Density))));
    quot  := List([1..Length(orbs)],
                  i->Lcm(Mod(thin[i]),Mod(thick[i]))/Mod(thin[i])
                    *Lcm(Mod(thin[i]),Mod(thick[i]))/Mod(thick[i]));
    int   := List(quot,q->Length(AllResidues(R,q)));
    return quot[Position(int,Maximum(int))];
  end );

#############################################################################
##
#M  Divisor( <G> ) . . . . . . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( Divisor,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,
               Multiplier );

#############################################################################
##
#M  RespectedPartition( <G> ) . . . . . . . . . . . . .  for tame rcwa groups
##
InstallMethod( RespectedPartition,
               "for tame rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  P, P_last, CommonRefinementFunction, gens, start;

    if   IsRcwaGroupOverZ(G)
    then CommonRefinementFunction := CommonRefinementOfPartitionsOfZ_NC;
    else CommonRefinementFunction := CommonRefinementOfPartitionsOfR_NC; fi;

    start := Runtime();

    gens  := GeneratorsOfGroup(G);
    P     := List(gens,LargestSourcesOfAffineMappings);
    P     := CommonRefinementFunction(P);

    repeat
      Info(InfoRCWA,2,"RespectedPartition: |P| = ",Length(P));
      P_last := P;
      P      := Concatenation([P],List(gens,g->P^g));
      P      := CommonRefinementFunction(P);
      if ValueOption("AssumeIsTame") <> true then
        if (Length(P) > 256 and Length(P_last) <= 256)
          or   (IsRcwaGroupOverZ(G) and Maximum(List(P,Mod)) > 16384
            and Maximum(List(P_last,Mod)) <= 16384) then
          CheckForWildness(G,3,true);
          if HasIsTame(G) and not IsTame(G) then return fail; fi;
        fi;
      elif Runtime() - start > 30000 # 30s; to be improved:
      then if Loops(Product(gens)^2) <> [] then return fail; fi;
      fi;
    until P = P_last;

    P := Set(Flat(List(P,AsUnionOfFewClasses)));

    if   RespectsPartition(G,P)
    then SetIsTame(G,true); return P;
    else Error("RespectedPartition failed"); fi; # should never happen
  end );

#############################################################################
##
#M  RespectedPartition( <G> ) . . . . . . . . . for finite subgroups of CT(Z)
##
InstallMethod( RespectedPartition,
               "for finite subgroups of CT(Z) (RCWA)", true,
               [ IsRcwaGroupOverZ ], 5,

  function ( G )

    local  P, orbit, gens, coeffs, compute_moduli, moduli, modulibound,
           primes, primes_multdiv, primes_onlymod, powers_impossible,
           orb, orbitlengthbound, modulusbound, density, m, n, r, i, j, k;

    compute_moduli := function (  )
      moduli := AllSmoothIntegers(primes,modulibound);
      moduli := Filtered(moduli,m->ForAll(powers_impossible,q->m mod q<>0));
    end;

    orbit := function ( cl0 )

      local  B, r, cl, img, inter, densitysum, c, i, j;

      B := [[cl0]];
      r := 0;
      densitysum := 1/cl0[2];
      repeat
        r := r + 1;
        Add(B,[]);
        for i in [1..Length(B[r])] do
          for j in [1..Length(coeffs)] do
            cl := B[r][i];
            inter := Filtered(coeffs[j],
                              c->(cl[1]-c[1]) mod Gcd(cl[2],c[2]) = 0);
            if    Length(inter) > 1
              and Length(Set(List(inter,c->c{[3..5]}))) > 1
            then return fail; fi;
            c := inter[1];
            img := [(c[3]*cl[1]+c[4])/c[5],c[3]*cl[2]/c[5]];
            img[1] := img[1] mod img[2];
            if img in B[r] or (r > 1 and img in B[r-1]) then continue; fi;
            if img <> cl0 and (img[1]-cl0[1]) mod Gcd(img[2],cl0[2]) = 0 then
              Info(InfoRCWA,2,"RespectedPartition: loop detected for cl0 = ",
                              cl0[1],"(",cl0[2],"), at r = ",r);
              return "loop";
            fi;
            Add(B[r+1],img);
          od;
        od;
        B[r+1] := Set(B[r+1]);
        densitysum := densitysum + Sum(B[r+1],cl->1/cl[2]);
        if densitysum > 1 then
          Info(InfoRCWA,2,"RespectedPartition: density sum exceeded 1 ",
                          "for cl0 = ",cl0[1],"(",cl0[2],"), at r = ",r);
          return "loop";
        fi;
        if B[r+1] <> [] and Sum(List(B,Length)) > orbitlengthbound then
          Info(InfoRCWA,2,"RespectedPartition: orbit length for ",
                          "for cl0 = ",cl0[1],"(",cl0[2],") exceeded ",
                          orbitlengthbound," at r = ",r);
          return "abort";
        fi;
      until B[r+1] = [];
      return Concatenation(B);
    end;

    if ValueOption("classic") = true then TryNextMethod(); fi;
    orbitlengthbound := ValueOption("orbitlengthbound");
    if orbitlengthbound = fail then orbitlengthbound := infinity; fi;
    modulusbound := ValueOption("modulusbound");
    if modulusbound = fail then modulusbound := infinity; fi;
    if IsTrivial(G) then return [ Integers ]; fi;
    if not IsSignPreserving(G) then TryNextMethod(); fi;
    gens := Set(GeneratorsAndInverses(SparseRep(G)));
    coeffs := List(gens,g->ShallowCopy(Coefficients(g)));
    for i in [1..Length(coeffs)] do
      Sort(coeffs[i],function(c1,c2)
                       return c1{[2,1]} < c2{[2,1]};
                     end);
    od;
    primes := PrimeSet(G);
    primes_multdiv := Union(List(gens,g->Set(Factors(Mult(g)*Div(g)))));
    primes_multdiv := Difference(primes_multdiv,[1]);
    primes_onlymod := Difference(primes,primes_multdiv);
    m := Lcm(List(gens,Mod));
    powers_impossible := List(primes_onlymod,p->p^(ExponentOfPrime(m,p)+1));
    modulibound := 2^16;
    compute_moduli();
    P := List(AsUnionOfFewClasses(Difference(Integers,Support(G))),
              cl->[Residue(cl),Modulus(cl)]);
    repeat
      n := -1;
      repeat
        n := n + 1;
      until ForAll(P,cl->n mod cl[2] <> cl[1]);
      i := 0;
      repeat
        i := i + 1;
        if i > Length(moduli) then
          if modulibound < modulusbound then
            Error("exceeded modulus bound ",modulibound,
                  ", maybe the group is infinite?\n",
                  "Enter return; to proceed with new bound ",
                  16 * modulibound,".\n");
            modulibound := modulibound * 16;
            compute_moduli();
          else
            Info(InfoRCWA,2,"RespectedPartition: exceeded bound ",
                            modulusbound," on the smallest modulus of ",
                            "a residue class in an orbit.");
            return "computation aborted"; 
          fi;
        fi;
        m := moduli[i];
        orb := orbit([n mod m,m]);
      until orb <> fail;
      if orb = "loop" then
        SetModulusOfRcwaMonoid(G,0);
        SetSize(G,infinity);
        return fail; 
      fi;
      if orb = "abort" then
        return "computation aborted"; 
      fi;
      Info(InfoRCWA,3,"RespectedPartition: found orbit of length ",
                      Length(orb),", with representative ",orb[1]);
      P := Union(P,orb);
      density := Sum(List(P,cl->1/cl[2]));
    until density >= 1;
    if density <> 1 then
      # Error("RespectedPartition: internal failure!\n",
      #       "Enter 'return;' to try a different method.\n");
      Info(InfoRCWA,1,"RespectedPartition: advanced method failed. ",
                      " -- Trying standard method ... "); 
      TryNextMethod();
    fi;
    Sort(P,function(c1,c2)
             return c1{[2,1]} < c2{[2,1]};
           end);
    SetModulusOfRcwaMonoid(G,Lcm(List(P,cl->cl[2])));
    return List(P,ResidueClass);
  end );

#############################################################################
##
#M  RespectsPartition( <G>, <P> ) . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( RespectsPartition,
               "for rcwa groups (RCWA)",
               ReturnTrue, [ IsRcwaGroup, IsList ], 0,

  function ( G, P )
    return ForAll(GeneratorsOfGroup(G),g->RespectsPartition(g,P));
  end );

#############################################################################
##
#S  Tame rcwa groups: ///////////////////////////////////////////////////////
#S  Action and kernel of action on respected partitions. ////////////////////
##
#############################################################################

#############################################################################
##
#M  ActionOnRespectedPartition( <G> ) . . . . . . . . .  for tame rcwa groups
##
InstallMethod( ActionOnRespectedPartition,
               "for tame rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  P;

    P := RespectedPartition(G);
    return Group(List(GeneratorsOfGroup(G),
                      g->PermutationOpNC(g,P,OnPoints)));
  end );

#############################################################################
##
#M  RankOfKernelOfActionOnRespectedPartition( <G> ) . .  for tame rcwa groups
##
InstallMethod( RankOfKernelOfActionOnRespectedPartition,
               "for tame rcwa groups (RCWA)", true,
               [ IsRcwaGroup ], 0,

  function ( G )

    local  P, H, Pq, Hq, indices, bound, primepowers;

    if IsTrivial(G) then return 0; fi;

    P     := RespectedPartition(G);
    H     := ActionOnRespectedPartition(G);
    bound := Maximum(List(GeneratorsOfGroup(G),
                          g->Maximum(List(Coefficients(g),
                                          c->AbsInt(c[2])))));
    if bound < 7 then bound := 7; fi;
    primepowers := Filtered([2..bound],IsPrimePowerInt);
    Pq := List(primepowers,q->Flat(List(P,cl->SplittedClass(cl,q))));
    Hq := List(Pq,P->Group(List(GeneratorsOfGroup(G),
                                gen->PermutationOpNC(gen,P,OnPoints))));
    indices := List(Hq,Size)/Size(H);
    SetKernelActionIndices(G,indices);
    SetRefinedRespectedPartitions(G,Pq);
    return Maximum(List(Filtered([2..Length(primepowers)],
                                 i->IsPrime(primepowers[i])),
                        j->Number(Factors(indices[j]),p->p=primepowers[j])));
  end );

#############################################################################
##
#M  KernelOfActionOnRespectedPartition( <G> ) . . for tame rcwa groups over Z
##  
InstallMethod( KernelOfActionOnRespectedPartition,
               "for tame rcwa groups over Z (RCWA)", true,
               [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  P, KFullPoly, KPoly, genKFP, genKPoly, rank, K, H, g, h,
           k, kPoly, genG, genH, genK, cgspar, nrgens, crcs, i;

    P         := RespectedPartition(G);
    H         := ActionOnRespectedPartition(G);
    rank      := RankOfKernelOfActionOnRespectedPartition(G);
    genG      := GeneratorsOfGroup(G);
    genH      := GeneratorsOfGroup(H);
    genK      := [];
    KFullPoly := DirectProduct(List([1..Length(P)],i->DihedralPcpGroup(0)));
    genKFP    := GeneratorsOfGroup(KFullPoly);
    KPoly     := TrivialSubgroup(KFullPoly);
    K         := TrivialSubgroup(G);
    g         := genG[1];
    h         := genH[1];
    nrgens    := Length(genG);
    if Set(KernelActionIndices(G)) <> [1] then
      repeat
        k := g^Order(h);
        if not IsOne(k) then
          kPoly := One(KFullPoly);
          for i in [1..Length(P)] do
            for crcs in Factorization(RestrictedPerm(k,P[i])) do
              if IsClassReflection(crcs) then
                kPoly := kPoly*genKFP[2*i-1];
              elif not IsOne(crcs) then
                kPoly := kPoly*genKFP[2*i]^Determinant(crcs);
              fi;
            od;
          od;
          if not kPoly in KPoly then
            genKPoly := GeneratorsOfGroup(KPoly);
            genK     := GeneratorsOfGroup(K);
            if IsEmpty(genKPoly) then
              genKPoly := [kPoly];
              genK     := [k];
            else
              cgspar   := CgsParallel(genKPoly,genK);
              genKPoly := Concatenation(cgspar[1],[kPoly]);
              genK     := Concatenation(cgspar[2],[k]);
            fi;
            KPoly    := Subgroup(KFullPoly,genKPoly);
            K        := SubgroupNC(G,genK);
            if   ForAll([1..Length(RefinedRespectedPartitions(G))],
                        i->Size(Group(List(GeneratorsOfGroup(K),
                   gen->PermutationOpNC(gen,RefinedRespectedPartitions(G)[i],
                                            OnPoints))))
                 = KernelActionIndices(G)[i])
            then break; fi;
          fi;
        fi;
        i := Random([1..nrgens]);
        g := g * genG[i];
        h := h * genH[i];
      until false;
    fi;
    if not IsBound(genKPoly) then
      genKPoly := [One(KFullPoly)];
      genK     := [One(G)];
    else
      genKPoly := GeneratorsOfGroup(KPoly);
      genK     := GeneratorsOfGroup(K);
      cgspar   := CgsParallel(genKPoly,genK);
      genKPoly := cgspar[1];
      genK     := cgspar[2];
    fi;
    KPoly := Subgroup(KFullPoly,genKPoly);
    K     := SubgroupNC(G,genK);
    SetIndexInParent(K,Size(H));
    SetRespectedPartition(K,P);
    SetRankOfKernelOfActionOnRespectedPartition(K,rank);
    SetKernelOfActionOnRespectedPartition(K,K);
    if   not IsTrivial(K)
    then SetIsomorphismPcpGroup(K,EpimorphismByGeneratorsNC(K,KPoly));
    else SetIsomorphismPcpGroup(K,GroupHomomorphismByImages(K,KPoly,
                                  [One(K)],[One(KPoly)])); fi;
    return K;
  end );

#############################################################################
##
#S  Tame rcwa groups: ///////////////////////////////////////////////////////
#S  Integral conjugates. ////////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  IntegralizingConjugator( <G> ) . . . . . . .  for tame rcwa groups over Z
##
InstallMethod( IntegralizingConjugator,
               "for tame rcwa groups over Z (RCWA)", true,
               [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  P;

    if IsIntegral(G) then return One(G); fi;
    P := RespectedPartition(G); if P = fail then return fail; fi;
    return RepresentativeAction(RCWA(Integers),P,
                                AllResidueClassesModulo(Integers,Length(P)));
  end );

#############################################################################
##
#M  IntegralConjugate( <G> ) . . . . . . . . . . . . . . for tame rcwa groups
##
InstallMethod( IntegralConjugate,
               "for tame rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  result, R, m;

    result := G^IntegralizingConjugator(G);
    R      := Source(One(result));
    m      := Lcm(List(GeneratorsOfGroup(result),Modulus));
    SetRespectedPartition(result,AllResidueClassesModulo(R,m));
    return result;
  end );

#############################################################################
##
#M  IntegralizingConjugator( <sigma> ) . . . . .  for tame bij. rcwa mappings
##
InstallMethod( IntegralizingConjugator,
               "for tame bijective rcwa mappings (RCWA)", true,
               [ IsRcwaMapping ], 0,
               sigma -> IntegralizingConjugator( Group( sigma ) ) );

#############################################################################
##
#M  IntegralConjugate( <sigma> ) . . . . . . . .  for tame bij. rcwa mappings
##
InstallMethod( IntegralConjugate,
               "for tame bijective rcwa mappings (RCWA)", true,
               [ IsRcwaMapping ], 0,

  function ( sigma )

    local  result, R, m;

    result := sigma^IntegralizingConjugator(sigma);
    R      := Source(result);
    m      := Modulus(result);
    SetRespectedPartition(result,AllResidueClassesModulo(R,m));
    return result;
  end );

#############################################################################
##
#S  Tame rcwa groups: ///////////////////////////////////////////////////////
#S  "Canonical" conjugates of tame rcwa permutations. ///////////////////////
##
#############################################################################

#############################################################################
##
#M  StandardizingConjugator( <sigma> )  for tame bijective rcwa mappings of Z
##
InstallMethod( StandardizingConjugator,
               "for tame bijective rcwa mappings of Z (RCWA)", true,
               [ IsRcwaMappingOfZ ], 0,

  function ( sigma )

    local  toint, int, m, mtilde, mTilde, P, r, rtilde, c, cycs, lngs,
           cohorts, cohort, l, nrcycs, res, cyc, n, ntilde, i, j, k;

    if   not IsBijective(sigma) or not IsClassWiseOrderPreserving(sigma)
      or not IsTame(sigma) or Order(sigma) = infinity
    then TryNextMethod(); fi;
    toint   := IntegralizingConjugator(sigma);
    int     := IntegralConjugate(sigma);
    m       := Modulus(int);
    P       := AllResidueClassesModulo(Integers,m);
    cycs    := Cycles(int,P);
    lngs    := Set(List(cycs,Length));
    cohorts := List(lngs,l->Filtered(cycs,cyc->Length(cyc)=l));
    mtilde  := Sum(lngs);
    c       := List([1..m],i->[1,0,1]);
    rtilde  := 0;
    for cohort in cohorts do
      nrcycs := Length(cohort);
      l      := Length(cohort[1]);
      res    := List([1..l],i->List([1..nrcycs],
                                    j->Residues(cohort[j][i])[1]));
      cyc    := List([1..nrcycs],j->Cycle(int,res[1][j]));
      mTilde := nrcycs * mtilde;
      for i in [1..l] do
        for r in res[i] do
          j      := Position(res[i],r);
          n      := cyc[j][i];
          ntilde := (j-1)*mtilde+rtilde;
          k      := (ntilde*m-mTilde*n-m*rtilde+mtilde*r)/(m*mtilde);
          c[r+1] := [mTilde,k*m*mtilde+m*rtilde-mtilde*r,m];
        od;
        rtilde := rtilde + 1;
      od;
    od; 
    return toint * RcwaMapping(c);
  end );

#############################################################################
##
#M  StandardConjugate( <f> ) . . . . . . . . . . . . . . .  for rcwa mappings
##
InstallMethod( StandardConjugate,
               "for rcwa mappings (RCWA)", true, [ IsRcwaMapping ], 0,
               f -> f^StandardizingConjugator( f ) );

#############################################################################
##
#S  Tame rcwa groups: ///////////////////////////////////////////////////////
#S  Permutation- and matrix representations. ////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  IsomorphismPermGroup( <G> ) . . . . . . . . for finite rcwa groups over Z
##
##  This method makes use of the fact that the class reflection on a residue
##  class r(m) interchanges the residue classes r+m(3m) and r+2m(3m).
##
InstallMethod( IsomorphismPermGroup,
               "for finite rcwa groups (RCWA)",
               true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  P, P3, H, phi;

    if not IsFinite(G) then return fail; fi;
    P   := RespectedPartition(G);
    if   IsClassWiseOrderPreserving(G)
    then H := ActionOnRespectedPartition(G);
    else H := Action(G,Flat(List(P,cl->SplittedClass(cl,3)))); fi;
    phi := Immutable(EpimorphismByGeneratorsNC(G,H));
    if   not HasParent(G)
    then SetNiceMonomorphism(G,phi); SetNiceObject(G,H); fi;
    return phi;
  end );

#############################################################################
##
#M  IsomorphismMatrixGroup( <G> ) . . . . . . . . . . .  for tame rcwa groups
##
InstallMethod( IsomorphismMatrixGroup,
               "for tame rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  R, res, q, x, d, P, H, M, ModG, g, h, m, deg, r, b, c, pos, i, j;

    if not IsTame(G) then TryNextMethod(); fi;
    R := Source(One(G)); ModG := Modulus(G);
    if IsRcwaGroupOverGFqx(G) then
      q := Size(CoefficientsRing(R));
      x := IndeterminatesOfPolynomialRing(R)[1];
      res := [];
      for d in [1..DegreeOfLaurentPolynomial(ModG)] do
        res[d] := AllGFqPolynomialsModDegree(q,d,x);
      od;
    fi;
    g := GeneratorsOfGroup(G);
    P := RespectedPartition(G);
    deg := 2 * Length(P);
    H := Action(G,P); h := GeneratorsOfGroup(H);
    m := [];
    for i in [1..Length(g)] do
      m[i] := NullMat(deg,deg,R);
      for j in [1..deg/2] do
        b := [[0,0],[0,1]] * One(R);
        r := Residues(P[j])[1] mod Modulus(g[i]);
        if   IsRcwaGroupOverZOrZ_pi(G)
        then pos := r+1;
        else pos := Position(res[DegreeOfLaurentPolynomial(g[i])],r); fi;
        c := Coefficients(g[i])[pos];
        b[1] := [c[1]/c[3],c[2]/c[3]];
        m[i]{[2*j^h[i]-1..2*j^h[i]]}{[2*j-1..2*j]} := b;
      od;
    od;
    M := Group(m);
    return GroupHomomorphismByImagesNC(G,M,g,m);
  end );

#############################################################################
##
#M  NiceMonomorphism( <G> ) . . . . . . . . . . . . . .  for tame rcwa groups
##
InstallMethod( NiceMonomorphism,
               "for tame rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )
    if   IsTame(G)
    then if   IsTrivial(KernelOfActionOnRespectedPartition(G))
         then return IsomorphismPermGroup(G);
         else return IsomorphismMatrixGroup(G); fi;
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  NiceObject( <G> ) . . . . . . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( NiceObject,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,
               G -> Image( NiceMonomorphism( G ) ) );

#############################################################################
##
#S  Computing the order of an rcwa group. ///////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  Size( <G> ) . . . . . . . . . . . . . . . . . . .  for rcwa groups over Z
##
##  This method checks whether <G> is tame and the kernel of the action of
##  <G> on a respected partition has rank 0 -- if so, it returns the
##  size of the permutation group induced on this partition, and if not it
##  returns infinity.
##
InstallMethod( Size,
               Concatenation("for rcwa groups over Z, use action on ",
                             "respected partition (RCWA)"),
               true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  orbs, orbs_old, gens, g, maxpts;

    # A few `trivial' checks.

    if IsTrivial(G) then return 1; fi;
    if ForAny(GeneratorsOfGroup(G),g->Order(g)=infinity)
    then return infinity; fi;
    if not IsTame(G) then return infinity; fi;

    # On the one hand, an orbit of a finite tame group <G> can intersect
    # in at most 1 resp. 2 points with any residue class in a respected
    # partition, depending on whether <G> is class-wise order-preserving
    # or not. On the other if <G> is infinite, one of its orbits contains
    # an entire residue class from the respected partition.

    orbs := List(RespectedPartition(G),cl->[Representative(cl)]);
    if IsClassWiseOrderPreserving(G) then maxpts := 1; else
      orbs   := Concatenation(orbs,orbs+List(RespectedPartition(G),
                                             cl->[Modulus(cl)]));
      maxpts := 2;
    fi;
    gens := GeneratorsAndInverses(G);
    repeat
      orbs_old := List(orbs,ShallowCopy);
      for g in gens do orbs := List(orbs,orb->Union(orb,orb^g)); od;
    until orbs = orbs_old
       or ForAny(orbs,orb->ForAny(RespectedPartition(G),
                                  cl->Length(Intersection(cl,orb))>maxpts));

    if orbs = orbs_old then return Size(Action(G,Union(orbs)));
                       else return infinity; fi;
  end );

#############################################################################
##
#M  Size( <G> ) . . . . . . . . . . . . . . . . for rcwa groups over GF(q)[x]
##
InstallMethod( Size,
               "for rcwa groups over GF(q)[x] (RCWA)",
               true, [ IsRcwaGroupOverGFqx ], 0,

  function ( G )

    local  R, p, B, P, Pp, H, size, r;

    R := Source(One(G));
    p := Characteristic(R);

    for r in [1..3] do
      B := Ball(G,One(G),r:Spheres)[r+1];
      if ForAny(B,g->Loops(g)<>[]) then
        SetIsTame(G,false);
        return infinity;
      fi;
    od;
  
    P := RespectedPartition(G);
    if P = fail then
      SetIsTame(G,false);
      return infinity;
    else
      SetIsTame(G,true);
      Pp   := Flat(List(P,cl->SplittedClass(cl,p)));
      H    := Action(G,Pp);
      size := Size(H);
      return size;
    fi;

  end );

#############################################################################
##
#M  Size( <G> ) . . . . . . . . . . . . . . . . . . . . . . . for rcwa groups
##
##  This method tests for tameness and looks for elements of infinite order.
##
InstallMethod( Size,
               "for rcwa groups, test for tameness (RCWA)",
               true, [ IsRcwaGroup ], 0,

  function ( G )

    local  gen, k;

    Info(InfoRCWA,1,
         "Size: Test for tameness and look for elements of infinite order.");
    if not IsTame(G) then return infinity; fi;
    if   IsTame(G) and Characteristic(Source(One(G))) <> 0
    then TryNextMethod(); fi; # In this case, <G> is finite.
    gen := GeneratorsOfGroup(G);
    if ForAny(gen,g->Order(g)=infinity) then return infinity; fi;
    if   ForAny(Combinations(gen,2),t->Order(Comm(t[1],t[2]))=infinity)
    then return infinity; fi;
    for k in [2..3] do
      if   ForAny(Tuples(gen,k),t->Order(Product(t))=infinity)
      then return infinity; fi;
    od;
    TryNextMethod();
  end );

#############################################################################
##
#S  The membership- / subgroup test. ////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  \in( <g>, <G> ) . . . . . . for rcwa groups with membership test function
##
InstallMethod( \in,
               "for rcwa groups with membership test function (RCWA)",
               ReturnTrue,
               [ IsRcwaMapping, IsRcwaGroup and HasElementTestFunction ], 0,

  function ( g, G )
    if HasParent(G) and not g in Parent(G) then return false; fi;
    return ElementTestFunction(G)(g);
  end );

#############################################################################
##
#M  \in( <g>, <G> ) . . . . . . . . . . . . . . . . . . . . . for rcwa groups
##
##  This method may run into an infinite loop if <G> is infinite and <g> is
##  not an element of <G>.
##
InstallMethod( \in,
               "for rcwa groups (RCWA)", ReturnTrue,
               [ IsRcwaMapping, IsRcwaGroup and HasGeneratorsOfGroup ], 0,

  function ( g, G )

    local  gens, phi;

    if FamilyObj(g) <> FamilyObj(One(G)) then return false; fi;
    gens := GeneratorsOfGroup(G);
    if IsOne(g) or g in gens or g^-1 in gens then return true; fi;
    if not IsSubset(PrimeSet(G),PrimeSet(g)) then return false; fi;
    if   g in List(Combinations(gens,2), t -> Product(t))
    then return true; fi;
    Info(InfoRCWA,2,"\\in: trying to factor <g> into gen's ...");
    phi := EpimorphismFromFreeGroup(G);
    return PreImagesRepresentative(phi,g) <> fail;
  end );

#############################################################################
##
#M  \in( <g>, <G> ) . . . . . . . . . . . . . . . . .  for rcwa groups over Z
##
##  If <G> is wild this method may run into an infinite loop if <g> is not an
##  element of <G>.
##
InstallMethod( \in,
               "for rcwa groups over Z (RCWA)", ReturnTrue,
               [ IsRcwaMappingOfZ,
                 IsRcwaGroupOverZ and HasGeneratorsOfGroup ], 0,

  function ( g, G )

    local  P, H, h, K, k, KPoly, KFullPoly, genKFP, kPoly, crcs,
           F, phi, gens, orbs, orbsmod, m, max, i;

    Info(InfoRCWA,2,"\\in for an rcwa permutation <g> of Z ",
                    "and an rcwa group <G> over Z");
    if not IsBijective(g)
    then Info(InfoRCWA,4,"<g> is not bijective."); return false; fi;
    gens := GeneratorsOfGroup(G);
    if IsOne(g) or g in gens or g^-1 in gens then
      Info(InfoRCWA,2,"<g> = 1 or one of <g> or <g>^-1 ",
                      "in generator list of <G>.");
      return true;
    fi;
    if not IsSubset(PrimeSet(G),PrimeSet(g)) then
      Info(InfoRCWA,2,"<g> and <G> have incompatible prime sets.");
      return false;
    fi;
    if not IsSubset(Factors(   Product(List(gens,Multiplier))
                             * Product(List(gens,Divisor))),
                    Filtered(Factors(Multiplier(g)*Divisor(g)),p->p<>1))
    then
      Info(InfoRCWA,2,"The multiplier or divisor of <g> has factors which");
      Info(InfoRCWA,2,"no multiplier or divisor of a generator of <G> has.");
      return false;
    fi;
    if        IsClassWiseOrderPreserving(G)
      and not IsClassWiseOrderPreserving(g) then
      Info(InfoRCWA,2,"<G> is class-wise order-preserving, but <g> is not.");
      return false;
    fi;
    if Sign(g) = -1 and Set(gens,Sign) = [1] then
      Info(InfoRCWA,2,"Sign(<g>) is -1, but the sign of all generators ",
                      "of <G> is 1.");
      return false;
    fi;
    if Determinant(g) <> 0 and IsClassWiseOrderPreserving(G)
      and Set(gens,Determinant) = [0]
    then
      Info(InfoRCWA,2,"<G> lies in the kernel of the determinant ",
                      "epimorphism, but <g> does not.");
      return false;
    fi;
    if not IsSubset(Support(G),Support(g)) then
      Info(InfoRCWA,2,"Support(<g>) is not a subset of Support(<G>).");
      return false;
    fi;
    if IsSignPreserving(G) and not IsSignPreserving(g) then
      Info(InfoRCWA,2,"<G> fixes the nonnegative integers setwise,");
      Info(InfoRCWA,2,"but <g> does not.");
      return false;
    fi;
    if not IsTame(G) then
      orbs := ShortOrbits(G,Intersection(Support(G),[-100..100]),50);
      if orbs <> [] then
        if ForAny(orbs,orb->Permutation(g,orb)=fail) then
          Info(InfoRCWA,2,"<g> does not act on some finite orbit of <G>.");
          return false;
        fi;
        if ForAny(orbs,orb->not Permutation(g,orb) in Action(G,orb)) then
          Info(InfoRCWA,2,"<g> induces a permutation on some finite orbit");
          Info(InfoRCWA,2,"of <G> which does not lie in the group induced");
          Info(InfoRCWA,2,"by <G> on this orbit.");
          return false;
        fi;
      fi;
      m       := Lcm(List(Concatenation(gens,[g]),Modulus));
      orbsmod := List(ProjectionsToInvariantUnionsOfResidueClasses(G,m),
                      proj->Support(Image(proj)));
      if ForAny(orbsmod,orb->orb^g<>orb) then
        Info(InfoRCWA,2,"<g> does not leave the partition of Z into unions");
        Info(InfoRCWA,2,"of residue classes (mod ",m,") invariant which is");
        Info(InfoRCWA,2,"fixed by <G>.");
        return false;
      fi;
      Info(InfoRCWA,2,"<G> is wild -- trying to factor <g> into gen's ...");
      phi := EpimorphismFromFreeGroup(G);
      return PreImagesRepresentative(phi,g) <> fail;
    else
      if Modulus(G) mod Modulus(g) <> 0 then
        Info(InfoRCWA,2,"Mod(<g>) does not divide Mod(<G>).");
        return false;
      fi;
      if not IsTame(g) then
        Info(InfoRCWA,2,"<G> is tame, but <g> is wild.");
        return false;
      fi;
      if IsFinite(G) and Order(g) = infinity then
        Info(InfoRCWA,2,"<G> is finite, but <g> has infinite order.");
        return false;
      fi;
      P := RespectedPartition(G);
      H := ActionOnRespectedPartition(G);
      h := Permutation(g,P);
      if h = fail then
        Info(InfoRCWA,2,"<g> does not act on RespectedPartition(<G>).");
        return false;
      fi;
      if not RespectsPartition(g,P) then
        Info(InfoRCWA,2,"<g> does not respect RespectedPartition(<G>).");
        return false;
      fi;
      if not h in H then
        Info(InfoRCWA,2,"The permutation induced by <g> on ",
                        "P := RespectedPartition(<G>)");
        Info(InfoRCWA,2,"is not an element of the permutation group ",
                        "which is induced by <G> on P.");
        return false;
      fi;

      Info(InfoRCWA,2,"Computing an element of <G> which acts like <g>");
      Info(InfoRCWA,2,"on RespectedPartition(<G>).");

      phi := EpimorphismFromFreeGroup(H);
      h   := PreImagesRepresentative(phi,h:NoStabChain);
      if h = fail then return false; fi;
      h   := Product(List(LetterRepAssocWord(h),
                          id->gens[AbsInt(id)]^SignInt(id)));
      k   := g/h;

      Info(InfoRCWA,2,"Checking membership of the quotient in the kernel ");
      Info(InfoRCWA,2,"of the action of <g> on RespectedPartition(<G>).");

      K         := KernelOfActionOnRespectedPartition(G);
      KPoly     := Range(IsomorphismPcpGroup(K));
      KFullPoly := Parent(KPoly);
      genKFP    := GeneratorsOfGroup(KFullPoly);
      kPoly     := One(KFullPoly);
      for i in [1..Length(P)] do
        for crcs in Factorization(RestrictedPerm(k,P[i])) do
          if IsClassReflection(crcs) then
            kPoly := kPoly*genKFP[2*i-1];
          elif not IsOne(crcs) then
            kPoly := kPoly*genKFP[2*i]^Determinant(crcs);
          fi;
        od;
      od;
      return kPoly in KPoly;
    fi;
  end );

#############################################################################
##
#M  \in( <g>, <G> ) . . . . . . . . . . . . . . for rcwa groups over GF(q)[x]
##
##  If <G> is wild this method may run into an infinite loop if <g> is not an
##  element of <G>.
##
InstallMethod( \in,
               "for rcwa groups over GF(q)[x] (RCWA)", ReturnTrue,
               [ IsRcwaMappingOfGFqx, IsRcwaGroupOverGFqx ], 0,

  function ( g, G )

    local  R, x, P, H, h, phi, gens, orbs, orbsmod, m;

    R := Source(g); x := IndeterminatesOfPolynomialRing(R)[1];
    Info(InfoRCWA,2,"\\in for an rcwa permutation <g> of ",RingToString(R));
    Info(InfoRCWA,2,"    and an rcwa group <G> over ",RingToString(R));
    if   not IsBijective(g)
    then Info(InfoRCWA,4,"<g> is not bijective."); return false; fi;
    gens := GeneratorsOfGroup(G);
    if IsOne(g) or g in gens or g^-1 in gens then
      Info(InfoRCWA,2,"<g> = 1 or one of <g> or <g>^-1 ",
                      "in generator list of <G>.");
      return true;
    fi;
    if not IsSubset(PrimeSet(G),PrimeSet(g)) then
      Info(InfoRCWA,2,"<g> and <G> have incompatible prime sets.");
      return false;
    fi;
    if not IsSubset(Factors(   Product(List(gens,Multiplier))
                             * Product(List(gens,Divisor))),
                    Filtered(Factors(Multiplier(g)*Divisor(g)),
                             p->not IsOne(p)))
    then
      Info(InfoRCWA,2,"The multiplier or divisor of <g> has factors which");
      Info(InfoRCWA,2,"no multiplier or divisor of a generator of <G> has.");
      return false;
    fi;
    if not IsSubset(Support(G),Support(g)) then
      Info(InfoRCWA,2,"Support(<g>) is not a subset of Support(<G>).");
      return false;
    fi;
    if not IsTame(G) then
      orbs := ShortOrbits(G,Intersection(Support(G),AllResidues(R,x^4)),30);
      if orbs <> [] then
        if ForAny(orbs,orb->Permutation(g,orb)=fail) then
          Info(InfoRCWA,2,"<g> does not act on some finite orbit of <G>.");
          return false;
        fi;
        if ForAny(orbs,orb->not Permutation(g,orb) in Action(G,orb)) then
          Info(InfoRCWA,2,"<g> induces a permutation on some finite orbit");
          Info(InfoRCWA,2,"of <G> which does not lie in the group induced");
          Info(InfoRCWA,2,"by <G> on this orbit.");
          return false;
        fi;
      fi;
      m       := Lcm(List(Concatenation(gens,[g]),Modulus));
      orbsmod := List(ProjectionsToInvariantUnionsOfResidueClasses(G,m),
                      proj->Support(Image(proj)));
      if ForAny(orbsmod,orb->orb^g<>orb) then
        Info(InfoRCWA,2,"<g> does not leave the partition of ",
                        RingToString(R)," into");
        Info(InfoRCWA,2,"unions of residue classes (mod ",m,") invariant");
        Info(InfoRCWA,2,"which is fixed by <G>.");
        return false;
      fi;
      Info(InfoRCWA,2,"<G> is wild -- trying to factor <g> into gen's ...");
      phi := EpimorphismFromFreeGroup(G);
      return PreImagesRepresentative(phi,g) <> fail;
    else
      if Modulus(G) mod Modulus(g) <> 0 then
        Info(InfoRCWA,2,"Mod(<g>) does not divide Mod(<G>).");
        return false;
      fi;
      if not IsTame(g) then # This covers also the case of infinite order.
        Info(InfoRCWA,2,"<G> is tame, but <g> is wild.");
        return false;
      fi;
      P := RespectedPartition(G);
      H := ActionOnRespectedPartition(G);
      h := Permutation(g,P);
      if h = fail then
        Info(InfoRCWA,2,"<g> does not act on RespectedPartition(<G>).");
        return false;
      fi;
      if not RespectsPartition(g,P) then
        Info(InfoRCWA,2,"<g> does not respect RespectedPartition(<G>).");
        return false;
      fi;
      if not h in H then
        Info(InfoRCWA,2,"The permutation induced by <g> on ",
                        "P := RespectedPartition(<G>)");
        Info(InfoRCWA,2,"is not an element of the permutation group ",
                        "which is induced by <G> on P.");
        return false;
      elif CoefficientsRing(R) = GF(2) # R has no units except of 1.
      then return true; fi;
      Info(InfoRCWA,2,"Trying to factor <g> into gen's ...");
      phi := EpimorphismFromFreeGroup(G);            # <G> is tame -> this
      return PreImagesRepresentative(phi,g) <> fail; # could be improved.
    fi;
  end );

#############################################################################
##
#M  IsSubset( <G>, <H> ) . . . . . . . . . . . . . . . .  for two rcwa groups
##
##  This method checks for a subgroup relation.
##
InstallMethod( IsSubset,
               "for two rcwa groups (RCWA)", true,
               [ IsRcwaGroup and HasGeneratorsOfGroup,
                 IsRcwaGroup and HasGeneratorsOfGroup ], 0,

  function ( G, H )

    if   IsSubset(GeneratorsOfGroup(G),GeneratorsOfGroup(H))
    then return true; fi;
    if not IsSubset(PrimeSet(G),PrimeSet(H)) then return false; fi;
    if not IsSubset(Support(G),Support(H)) then return false; fi;
    if IsTame(G) and not IsTame(H) then return false; fi;
    if IsTame(G) and IsTame(H) then
      if not IsZero(Multiplier(G) mod Multiplier(H)) then return false; fi;
      if   not RespectsPartition(H,RespectedPartition(G))
      then return false; fi;
      if not IsSubgroup(ActionOnRespectedPartition(G),
                        Action(H,RespectedPartition(G)))
      then return false; fi;
      if Size(H) > Size(G) then return false; fi;
    fi;
    return ForAll(GeneratorsOfGroup(H),h->h in G);
  end );

#############################################################################
##
#M  IsSubset( <G>, <H> ) . . . . . . . . . . . . . for two rcwa groups over Z
##
##  This method checks for a subgroup relation.
##
InstallMethod( IsSubset,
               "for two rcwa groups over Z (RCWA)", true,
               [ IsRcwaGroupOverZ and HasGeneratorsOfGroup,
                 IsRcwaGroupOverZ and HasGeneratorsOfGroup ], 0,

  function ( G, H )

    local  gensG, gensH, dG, dH;

    gensG := GeneratorsOfGroup(G); gensH := GeneratorsOfGroup(H);
    if IsSubset(gensG,gensH) then return true; fi;
    if not IsSubset(PrimeSet(G),PrimeSet(H)) then return false; fi;
    if not IsSubset(Support(G),Support(H)) then return false; fi;
    if   ForAll(gensG,g->Sign(g) = 1) and ForAny(gensH,h->Sign(h)=-1)
    then return false; fi;
    if IsClassWiseOrderPreserving(G) then
      if not IsClassWiseOrderPreserving(H) then return false; fi;
      dG := Gcd(List(gensG,Determinant));
      dH := Gcd(List(gensH,Determinant));
      if   dG = 0 and dH <> 0 or dG <> 0 and dH mod dG <> 0
      then return false; fi;
    fi;
    if IsTame(G) and not IsTame(H) then return false; fi;
    if IsTame(G) and IsTame(H) then
      if Multiplier(G) mod Multiplier(H) <> 0 then return false; fi;
      if   not RespectsPartition(H,RespectedPartition(G))
      then return false; fi;
      if not IsSubgroup(ActionOnRespectedPartition(G),
                        Action(H,RespectedPartition(G)))
      then return false; fi;
      if   Size(H) > Size(G)
        or RankOfKernelOfActionOnRespectedPartition(H)
         > RankOfKernelOfActionOnRespectedPartition(G)
      then return false; fi;
    fi;
    return ForAll(gensH,h->h in G);
  end );

#############################################################################
##
#M  \=( <G>, <H> ) . . . . . . . . . . . . . . . . . . .  for two rcwa groups
##
InstallMethod( \=,
               "for two rcwa groups (RCWA)", true,
               [ IsRcwaGroup and HasGeneratorsOfGroup,
                 IsRcwaGroup and HasGeneratorsOfGroup ], 0,

  function ( G, H )

    local  gensG, gensH;

    gensG := Set(GeneratorsOfGroup(G)); gensH := Set(GeneratorsOfGroup(H));
    if gensG = gensH then return true; fi;
    if PrimeSet(G) <> PrimeSet(H) then return false; fi;
    if Support(G) <> Support(H) then return false; fi;
    if IsTame(G) <> IsTame(H) then return false; fi;
    if IsTame(G) and IsTame(H) then
      if Multiplier(G) <> Multiplier(H) then return false; fi;
      if   RespectedPartition(G) <> RespectedPartition(H)
      then return false; fi;
      if   ActionOnRespectedPartition(G) <> ActionOnRespectedPartition(H)
      then return false; fi;
      if Size(G) <> Size(H) then return false; fi;
    fi;
    return ForAll(gensH,h->h in G) and ForAll(gensG,g->g in H);
  end );

#############################################################################
##
#M  \=( <G>, <H> ) . . . . . . . . . . . . . . . . for two rcwa groups over Z
##
InstallMethod( \=,
               "for two rcwa groups over Z (RCWA)", true,
               [ IsRcwaGroupOverZ and HasGeneratorsOfGroup,
                 IsRcwaGroupOverZ and HasGeneratorsOfGroup ], 0,

  function ( G, H )

    local  gensG, gensH, dG, dH;

    gensG := Set(GeneratorsOfGroup(G)); gensH := Set(GeneratorsOfGroup(H));
    if gensG = gensH then return true; fi;
    if PrimeSet(G) <> PrimeSet(H) then return false; fi;
    if Support(G) <> Support(H) then return false; fi;
    if IsSignPreserving(G) <> IsSignPreserving(H) then return false; fi;
    if   (ForAll(gensG,g->Sign(g) = 1) and ForAny(gensH,h->Sign(h)=-1))
      or (ForAll(gensH,h->Sign(h) = 1) and ForAny(gensG,g->Sign(g)=-1))
    then return false; fi;
    if   IsClassWiseOrderPreserving(G) <> IsClassWiseOrderPreserving(H)
    then return false; fi;
    if   IsClassWiseOrderPreserving(G) then
      dG := Gcd(List(gensG,Determinant));
      dH := Gcd(List(gensH,Determinant));
      if dG <> dH then return false; fi;
    fi;
    if IsTame(G) <> IsTame(H) then return false; fi;
    if IsTame(G) then
      if Multiplier(G) <> Multiplier(H) then return false; fi;
      if   RespectedPartition(G) <> RespectedPartition(H)
      then return false; fi;
      if   ActionOnRespectedPartition(G) <> ActionOnRespectedPartition(H)
      then return false; fi;
      if Size(G) <> Size(H) then return false; fi;
      if    RankOfKernelOfActionOnRespectedPartition(G)
         <> RankOfKernelOfActionOnRespectedPartition(H)
      then return false; fi;
    fi;
    return ForAll(gensH,h->h in G) and ForAll(gensG,g->g in H);
  end );

#############################################################################
##
#S  The action of rcwa groups on subsets of the underlying ring. ////////////
##
#############################################################################

#############################################################################
##
#F  ActionHomomorphism( <G>, <S> )  of an rcwa group on a residue class union
##
BindGlobal( "ActionHomomorphism_LIBRARY", ActionHomomorphism ); #
MakeReadWriteGlobal( "ActionHomomorphism" );                    # dirty hack
Unbind( ActionHomomorphism );                                   #
BindGlobal( "ActionHomomorphism",

  function ( arg )

    local  G, H, S, phi, imgs;

    if   not IsRcwaGroup(arg[1]) or Length(arg) <> 2
      or not IsResidueClassUnion(arg[2])
      or not IsSubset(Source(One(arg[1])),arg[2])
    then return CallFuncList(ActionHomomorphism_LIBRARY,arg); fi;
    G := arg[1]; S := arg[2];
    imgs := List(GeneratorsOfGroup(G),g->RestrictedPerm(g,S));
    H := GroupWithGenerators(imgs);
    phi := EpimorphismByGeneratorsNC(G,H);
    return phi;
  end );

#############################################################################
##
#F  Action( <G>, <S> ) . . . . . .  of an rcwa group on a residue class union
#F  Action( <M>, <S> ) . . . . . . of an rcwa monoid on a residue class union
#F  Action( <M>, <l> ) . . . . . . . . . .  of an rcwa monoid on a finite set
##
BindGlobal( "Action_LIBRARY", Action ); #
MakeReadWriteGlobal( "Action" );        # dirty hack ...
Unbind( Action );                       #
BindGlobal( "Action",

  function ( arg )

    local  G, M, S;

    if   not IsRcwaMonoid(arg[1]) or Length(arg) <> 2
      or not (IsResidueClassUnion(arg[2]) or IsList(arg[2]))
      or not IsSubset(Source(One(arg[1])),arg[2])
    then return CallFuncList(Action_LIBRARY,arg); fi;
    if IsRcwaGroup(arg[1]) then
      G := arg[1]; S := arg[2];
      return Image(ActionHomomorphism(G,S));
    else
      M := arg[1]; S := arg[2];
      if IsResidueClassUnion(S) then
        return MonoidByGenerators(List(GeneratorsOfMonoid(M),
                 f->RestrictedMapping(f,S)));
      else
        return MonoidByGenerators(List(GeneratorsOfMonoid(M),
                 f->Transformation(List(OnTuples(S,f),n->Position(S,n)))));
      fi;
    fi;
  end );

#############################################################################
##
#S  Stabilizers. ////////////////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#F  Stabilizer( <arg> ) . . . . . . . . . .  use StabilizerOp for rcwa groups
##
MakeReadWriteGlobal( "Stabilizer" ); Unbind( Stabilizer ); # dirty hack ...
BindGlobal( "Stabilizer",                                  #

  function ( arg )
    if   Length( arg ) = 1   then return StabilizerOfExternalSet( arg[1] );
    elif IsRcwaGroup(arg[1]) then return CallFuncList( StabilizerOp, arg );
    else return CallFuncList( StabilizerFunc, arg ); fi;
    return;
  end );

#############################################################################
##
#M  StabilizerOp( <G>, <n> ) . . . . . . .  point stabilizer in an rcwa group
##
InstallMethod( StabilizerOp,
               "point stabilizer in an rcwa group (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRingElement ], 0,

  function ( G, n )

    local  R, H;

    R := Source(One(G));
    if not n in R then TryNextMethod(); fi;
    H := SubgroupByProperty(G,g->n^g=n);
    SetStabilizerInfo(H, rec(set    := [n],
                             action := OnPoints));
    return H;
  end );

#############################################################################
##
#M  StabilizerOp( <G>, <S>, <action> ) . .  point stabilizer in an rcwa group
##
InstallMethod( StabilizerOp,
               "point stabilizer in an rcwa group (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsListOrCollection, IsFunction ], 0,

  function ( G, S, action )

    local  R, H;

    R := Source(One(G));
    if not IsSubset(R,S) then TryNextMethod(); fi;
    if   not IsFinite(S) and action = OnTuples
    then H := SubgroupByProperty(G,g->IsTrivial(Intersection(Support(g),S)));
    else H := SubgroupByProperty(G,g->action(S,g)=S); fi;
    SetStabilizerInfo(H, rec(set    := S,
                             action := action));
    return H;
  end );

#############################################################################
##
#M  IsTrivial( <G> ) . . . . . . . . . . . . . for stabilizers in rcwa groups
##
InstallMethod( IsTrivial,
               "for stabilizers in rcwa groups", true,
               [ IsRcwaGroup and HasParent and
                 HasElementTestFunction and HasStabilizerInfo ], 0,

  function ( G )

    local  iter;

    if     IsFinite(Difference(Support(Parent(G)),StabilizerInfo(G).set))
       and StabilizerInfo(G).action = OnTuples
    then return true; fi;
    if IsNaturalRCWA_OR_CT(Parent(G)) then return false; fi;
    iter := Iterator(G);
    NextIterator(iter);
    return IsDoneIterator(iter);
  end );

#############################################################################
##
#S  Testing for transitivity. ///////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  IsTransitive( <G>, <S> ) . .  for an rcwa group and a residue class union
##
##  This method might fail or run into an infinite loop.
##
InstallMethod( IsTransitive,
               "for an rcwa group and a residue class union (RCWA)",
               ReturnTrue, [ IsRcwaGroup, IsListOrCollection ], 0,

  function ( G, S )

    local  ShortOrbitsFound, ShiftedClass, ShiftedClassPowers,
           R, H, x, gen, comm, el, WordLng, cl, ranges, range;

    ShortOrbitsFound := function ( range, maxlng )
      
      local  orb;

      orb := ShortOrbits(G,range,maxlng);
      if orb <> [] then
        Info(InfoRCWA,1,"The group has the finite orbits ",orb);
        return true;
      else return false; fi;
    end;

    ShiftedClass := function ( el )

      local  cl, g, c, m, r, res, e;

      e := One(R);
      for g in el do
        c := Coefficients(g); m := Modulus(g);
        res := Filtered( AllResidues(R,m), r ->    c[r+1]{[1,3]} = [e,e]
                                               and not IsZero(c[r+1][2])
                                               and IsZero(c[r+1][2] mod m) );
        if res <> [] then
          r := res[1]; m := StandardAssociate(R,c[r+1][2]);
          cl := ResidueClass(R,m,r);
          if IsSubset(S,cl) then
            Info(InfoRCWA,1,"A cyclic subgroup has been found which acts ",
                 "transitively\n#I  on the residue class ",r,"(",m,").");
            return cl;
          fi;
        fi;
      od;
      return fail;
    end;

    ShiftedClassPowers := function ( el )

      local  g, m, cl, exp, pow, n, e;

      exp := [2,2,3,5,2,7,3,2,11,13,5,3,17,19,2];
      for g in el do
        pow := g; m := Modulus(g); e := 1;
        for n in exp do
          if Length(AllResidues(R,Modulus(pow))) > 4*Length(AllResidues(R,m))
          then break; fi;
          pow := pow^n; e := e * n;
          cl := ShiftedClass([pow]);
          if cl <> fail then return cl; fi;
        od;
      od;
      return fail;
    end;

    R := Source(One(G));

    if not IsSubset(R,S) then TryNextMethod(); fi;
    if not ForAll(GeneratorsOfGroup(G),g->S^g=S) then return false; fi;

    if IsFinite(S) then

      H := Action(G,AsList(S));
      return DegreeAction(H) = Size(S) and IsTransitive(H,MovedPoints(H));

    elif IsRcwaGroupOverZ(G) and IsSignPreserving(G) then

      if IsIntegers(S) or IsResidueClassUnion(S) then
        Info(InfoRCWA,1,"IsTransitive: group is sign-preserving, thus is");
        Info(InfoRCWA,1,"not transitive on Z or a union of residue classes");
        return false;
      else
        TryNextMethod();
      fi;

    else

      Info(InfoRCWA,1,"IsTransitive: ",
                      "finiteness test and search for short orbits ...");

      if   HasIsFinite(G) and IsFinite(G)
      then Info(InfoRCWA,1,"The group is finite."); return false; fi;
      if   (IsRcwaGroupOverGFqx(G) or IsZ_pi(R))
        and IsFinitelyGeneratedGroup(G) and HasIsTame(G) and IsTame(G)
      then return false; fi;

      if   IsIntegers(R) or IsZ_pi(R) then
        ranges := [[-10..10],[-30..30],[-100..100]];
      elif IsZxZ(R) then
        ranges := List([[[2,0],[0,2]],[[4,0],[0,4]],
                        [[8,0],[0,8]],[[16,0],[0,16]]],m->AllResidues(R,m));
      elif IsPolynomialRing(R) then
        x := IndeterminatesOfPolynomialRing(R)[1];
        ranges := [AllResidues(R,x^2),AllResidues(R,x^3),
                   AllResidues(R,x^4),AllResidues(R,x^6)];
      fi;
      ranges := List(ranges,range->Intersection(range,S));
      for range in ranges do
        if ShortOrbitsFound(range,4*Length(range)) then return false; fi;
      od;

      if   IsFinite(G)
      then Info(InfoRCWA,1,"The group is finite."); return false; fi;

      if   (IsRcwaGroupOverGFqx(G) or IsZ_pi(R))
        and IsFinitelyGeneratedGroup(G) and IsTame(G)
      then return false; fi;

      if IsIntegers(R) then 

        Info(InfoRCWA,1,"Searching for class shifts ...");
        Info(InfoRCWA,2,"... in generators");
        gen := GeneratorsOfGroup(G); cl := ShiftedClass(gen);
        if cl <> fail then return OrbitUnion(G,cl) = S; fi;
        Info(InfoRCWA,2,"... in commutators of the generators");
        comm := List(Combinations(gen,2),g->Comm(g[1],g[2]));
        cl := ShiftedClass(comm);
        if cl <> fail then return OrbitUnion(G,cl) = S; fi;
        Info(InfoRCWA,2,"... in powers of the generators");
        cl := ShiftedClassPowers(gen);
        if cl <> fail then return OrbitUnion(G,cl) = S; fi;
        Info(InfoRCWA,2,"... in powers of commutators of the generators");
        cl := ShiftedClassPowers(comm);
        if cl <> fail then return OrbitUnion(G,cl) = S; fi;
        gen := Union(gen,List(gen,Inverse)); el := gen; WordLng := 1;
        repeat
          WordLng := WordLng + 1;
          Info(InfoRCWA,2,"... in powers of words of length ",WordLng,
                          " in the generators");
          el := Union(el,Flat(List(el,g->g*gen)));
          cl := ShiftedClassPowers(el);
          if cl <> fail then return OrbitUnion(G,cl) = S; fi;
        until false;

      else

        Info(InfoRCWA,1,"... this method gives up ...");
        TryNextMethod();

      fi;

    fi;

  end );

#############################################################################
##
#M  IsTransitive( <G>, NonnegativeIntegers ) for an rcwa group over Z and N_0
##
##  This method might fail or run into an infinite loop.
##
InstallMethod( IsTransitive,
               "for an rcwa group over Z and N_0 (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsNonnegativeIntegers ], 0,

  function ( G, N_0 )

    if not IsIntegers(Union(Support(G),ExcludedElements(Support(G))))
      or (    ExcludedElements(Support(G)) <> []
          and Maximum(ExcludedElements(Support(G))) >= 0)
    then return false;
    else return IsTransitiveOnNonnegativeIntegersInSupport(G); fi;

  end );

#############################################################################
##
#M  IsTransitiveOnNonnegativeIntegersInSupport( <G> ) . . . .  default method
##
InstallMethod( IsTransitiveOnNonnegativeIntegersInSupport,
               "for an rcwa group over Z (RCWA)", true,
               [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  info;

    info := TryIsTransitiveOnNonnegativeIntegersInSupport(G,2^24,4);

    Info(InfoRCWA,1,"`IsTransitiveOnNonnegativeIntegersInSupport':");

    if   info = "trivial" then Info(InfoRCWA,1,"group is trivial");
    elif info = "finite"  then Info(InfoRCWA,1,"group is finite");
    elif info = "not sign-preserving"
    then Info(InfoRCWA,1,"group is not sign-preserving");
    elif info = "finite orbits"
    then Info(InfoRCWA,1,"group has finite orbits");
    elif info = "> 1 orbit (mod m)"
    then Info(InfoRCWA,1,"group has >1 orbits (mod m) for some m");
    elif info = "U DecreasingOn stable for <maxeq> steps"
    then Info(InfoRCWA,1,"U DecreasingOn stable for 4 steps");
    elif info = "transitivity on small points unclear"
    then Info(InfoRCWA,1,"cannot decide transitivity on small points");
    elif info = "transitive"
    then Info(InfoRCWA,1,"group acts transitively");
    elif info = "intransitive on small points"
    then Info(InfoRCWA,1,"group acts intransitively on small points");
    elif info = "Mod(U DecreasingOn) exceeded <maxmod>"
    then Info(InfoRCWA,1,"Mod(U DecreasingOn) exceeded 2^24");
    elif info = "exceeded memory bound"
    then Info(InfoRCWA,1,"exceeded memory bound"); fi;

    if   HasIsTransitiveOnNonnegativeIntegersInSupport(G)
    then return IsTransitiveOnNonnegativeIntegersInSupport(G);
    else Error("cannot decide transitivity"); return fail; fi;

  end );

#############################################################################
##
#M  TryIsTransitiveOnNonnegativeIntegersInSupport( <G>, <maxmod>, <maxeq> )
##
InstallMethod( TryIsTransitiveOnNonnegativeIntegersInSupport,
               "for an rcwa group over Z and bounds on efforts (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsPosInt, IsPosInt ], 0,

  function ( G, maxmod, maxeq )

    local  ShortOrbitsFound, gens, S, B, r, B_act, B_act_old, r_act, b, p0,
           D, Ds, range, m, orbmod;

    ShortOrbitsFound := function ( range, maxlng )
      return ShortOrbits(G,Intersection(range,Support(G)),maxlng) <> [];
    end;

    if IsTrivial(G) then
      SetIsTransitiveOnNonnegativeIntegersInSupport(G,true);
      return "trivial";
    fi;

    if HasIsFinite(G) and IsFinite(G) then
      SetIsTransitiveOnNonnegativeIntegersInSupport(G,false);
      return "finite";
    fi;

    if not IsSignPreserving(G) then
      SetIsTransitiveOnNonnegativeIntegersInSupport(G,false);
      return "not sign-preserving";
    fi;

    gens := GeneratorsOfGroup(G);
    S    := Support(G);

    Info(InfoRCWA,2,"The support of the group is ");
    if   InfoLevel(InfoRCWA) >= 2
    then Print("#I  "); View(Support(G)); Print("\n"); fi;

    for range in [[0..15],[0..63],
                  [0..Maximum(255,Lcm(List(gens,Mod)))]] do
      if ShortOrbitsFound(range,32) then
        SetIsTransitiveOnNonnegativeIntegersInSupport(G,false);
        return "finite orbits";
      fi;
    od;

    for m in DivisorsInt(Lcm(List(gens,Mod))) do
      orbmod := List(ProjectionsToInvariantUnionsOfResidueClasses(G,m),
                     pi -> Support(Image(pi)));
      if Number(orbmod,orb->Intersection(S,orb)<>[]) > 1 then
        SetIsTransitiveOnNonnegativeIntegersInSupport(G,false);
        return "> 1 orbit (mod m)";
      fi;
    od;

    r := 0; Ds := [];
    repeat
      r := r + 1;

      Info(InfoRCWA,2,"Ball radius = ",r);

      B := Ball(G,One(G),r);
      D := Union(List(B,g->Union(DecreasingOn(g),ShiftsDownOn(g))));
      Add(Ds,D);

      Info(InfoRCWA,2,"U_(g in G) {DecreasingOn(g),ShiftsDownOn(g)} =");
      if   InfoLevel(InfoRCWA) >= 2
      then Print("#I  "); View(D); Print("\n"); fi;

      if   r >= maxeq and Set(Ds{[r-maxeq+1..r]}) = [D]
      then return "U DecreasingOn stable for <maxeq> steps"; fi;

      if IsSubset(D,S) then
        b := Maximum(List(B,MaximalShift));
        p0 := Minimum(Intersection([0..b],Support(G)));
        Info(InfoRCWA,2,"Checking transitivity on moved points ",
                        "0 <= n <= ",b);
        B_act := [p0]; r_act := 1;
        repeat
          B_act_old := B_act;
          B_act := Ball(G,p0,r_act,OnPoints);
          r_act := r_act + 1;
          if MemoryUsage(B_act) > 2^24 then # 16MB
            return "transitivity on small points unclear";
          fi;
        until IsSubset(B_act,Intersection([0..b],Support(G)))
           or B_act = B_act_old;
        if   IsSubset(B_act,Intersection([0..b],Support(G)))
        then SetIsTransitiveOnNonnegativeIntegersInSupport(G,true);
             return "transitive";
        else SetIsTransitiveOnNonnegativeIntegersInSupport(G,false);
             return "intransitive on small points";
        fi;
      fi;

      if   Modulus(D) > maxmod
      then return "Mod(U DecreasingOn) exceeded <maxmod>"; fi;

    until MemoryUsage(B) > 2^24; # 16MB

    return "exceeded memory bound";         
  end );

#############################################################################
##
#M  DistanceToNextSmallerPointInOrbit( <G>, <n> ) . .  for rcwa groups over Z
##
InstallMethod( DistanceToNextSmallerPointInOrbit,
               "for an rcwa group over Z and an integer (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsInt ], 0,

  function ( G, n )

    local  gens, B, r;

    if n = 0 then return infinity; fi;

    gens := Set(GeneratorsAndInverses(G));

    B := [n]; r := 0;
    repeat
      B := Union(B,Union(List(gens,g->B^g)));
      r := r + 1;
    until Minimum(List(B,AbsInt)) < AbsInt(n);

    return r;
  end );

#############################################################################
##
#M  CollatzLikeMappingByOrbitTree( <G>, <root>, <max_r> )
##
InstallMethod( CollatzLikeMappingByOrbitTree,
               "for rcwa group over Z, point and search radius (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsInt, IsPosInt ], 0,

  function ( G, root, max_r )

    local  f, c, g, B, r, P, n, img, m, i, j;

    g := GeneratorsOfGroup(G);
    P := PrimeSet(G);
    r := 3;
    f := fail;

    repeat
      B := Ball(G,root,r,OnPoints:Spheres);
      Info(InfoRCWA,2,"r = ",r,": sphere sizes = ",List(B,Length));
      if [] in B then
        Info(InfoRCWA,1,"CollatzLikeMappingByOrbitTree: ",
                        "the orbit is finite.");
        return fail;
      fi;
      if Maximum(List(B,Length)) >= 4 then 
        c := [];
        for i in [3..r+1] do
          for j in [1..Length(B[i])] do
            n   := B[i][j];
            img := Intersection(Set(List(g,h->n^h)),B[i-1]);
            if Length(img) > 1 then
              Info(InfoRCWA,1,"CollatzLikeMappingByOrbitTree: ",
                              "the orbit is not tree-like.");
              return fail;
            fi;
            Add(c,[n,img[1]]);
          od;
        od;
        for m in Filtered([2..Int(Length(c)/2)],k->IsSubset(P,Factors(k))) do
          f := RcwaMapping(m,c:BeQuiet);
          if f <> fail then return f; fi;
        od;
      fi;
      r := r + 1;
    until r > max_r;

    return f;
  end );

#############################################################################
##
#S  Testing for primitivity. ////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#M  IsPrimitive( <G>, <S> ) . . . for an rcwa group and a residue class union
##
##  This method might fail or run into an infinite loop.
##
InstallMethod( IsPrimitive,
               "for an rcwa group and a residue class union (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsListOrCollection ], 0,

  function ( G, S )
    if not IsSubset(Source(One(G)),S) then TryNextMethod(); fi;
    if   not ForAll(GeneratorsOfGroup(G),g->S^g=S)
    then Error("IsPrimitive: <G> must act on <S>.\n"); fi;
    if not IsTransitive(G,S) or IsTame(G) then return false; fi;
    TryNextMethod();
  end );

#############################################################################
##
#S  Orbits of rcwa groups. //////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#V  IsRcwaGroupOrbitInStandardRep . .  shorthand for rcwa group orbit objects
##
BindGlobal( "IsRcwaGroupOrbitInStandardRep",
             IsRcwaGroupOrbit and IsRcwaGroupOrbitStandardRep );

#############################################################################
## 
#M  OrbitUnion( <G>, <S> ) . . . . . . . . . . .  for an rcwa group and a set
##
##  This method might run into an infinite loop.
## 
InstallMethod( OrbitUnion,
               "for an rcwa group and a set (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsListOrCollection ], 0,

  function ( G, S )

    local  R, gen, image, oldimage, g;

    if InfoLevel(InfoRCWA) >= 1 then
      Print("#I  OrbitUnion: initial set = "); ViewObj(S); Print("\n");
    fi;
    R     := Source(One(G));
    gen   := GeneratorsAndInverses(G);
    image := S;
    repeat
      oldimage := image;
      for g in gen do image := Union(image,ImagesSet(g,image)); od;
      if InfoLevel(InfoRCWA) >= 2 then
        Print("#I  Image = "); ViewObj(image); Print("\n");
      fi;
    until image = R or image = oldimage;
    return image;
  end );

#############################################################################
##
#M  OrbitOp( <G>, <pnt>, <gens>, <acts>, <act> )
##
InstallOtherMethod( OrbitOp,
                    "for tame rcwa groups over Z (RCWA)", ReturnTrue,
                    [ IsRcwaGroupOverZ, IsInt, IsList, IsList, IsFunction ],
                    0,

  function ( G, pnt, gens, acts, act )

    local  P, K, where, gensrests, noncwoppos, m, S, orbs, i;

    if act <> OnPoints then TryNextMethod(); fi;
    orbs := ShortOrbits(G,[pnt],100);
    if orbs <> [] then return orbs[1]; fi;
    if IsFinite(G) or not IsTame(G) then TryNextMethod(); fi;
    P          := RespectedPartition(G);
    K          := KernelOfActionOnRespectedPartition(G);
    where      := First(P,cl->pnt in cl);
    gensrests  := List(GeneratorsOfGroup(K),g->RestrictedPerm(g,where));
    noncwoppos := Filtered([1..Length(gensrests)],
                           i->not IsClassWiseOrderPreserving(gensrests[i]));
    for i in noncwoppos{[2..Length(noncwoppos)]} do
      gensrests[i] := gensrests[i] * gensrests[noncwoppos[1]];
    od;
    m :=   Gcd(List(Filtered(gensrests,IsClassWiseOrderPreserving),
                    Determinant))
         * Modulus(where);
    S := ResidueClass(Integers,m,pnt);
    if   not IsEmpty(noncwoppos)
    then S := Union(S,S^gensrests[noncwoppos[1]]); fi;
    return OrbitUnion(G,S);
  end );

#############################################################################
##
#M  OrbitOp( <G>, <pnt>, <gens>, <acts>, <act> )  for wild rcwa groups over Z
##
InstallOtherMethod( OrbitOp,
                    "for wild rcwa groups over Z (RCWA)", ReturnTrue,
                    [ IsRcwaGroupOverZ, IsInt, IsList, IsList, IsFunction ],
                    0,

  function ( G, pnt, gens, acts, act )

    local  orbit, ball, oldball, orbs;

    orbs := ShortOrbits(G,[pnt],100);
    if orbs <> [] then return orbs[1]; fi;

    if IsTame(G) and act = OnPoints then TryNextMethod(); fi;

    gens := Union(gens,List(gens,Inverse));
    ball := [pnt];
    repeat    
      oldball := ShallowCopy(ball);
      ball    := Union(oldball,
                       Union(List(gens,gen->List(oldball,pt->act(pt,gen)))));
    until ball = oldball or Length(ball) > 1000;
    if ball = oldball then return Set(ball); fi;
    
    orbit := Objectify( NewType( CollectionsFamily( FamilyObj( pnt ) ),
                                 IsRcwaGroupOrbitInStandardRep ),
                        rec( group          := G,
                             representative := pnt,
                             action         := act ) );
    return orbit;
  end );

#############################################################################
##
#M  UnderlyingGroup( <orbit> ) . . . . . . . . . .  for orbits of rcwa groups
##
InstallMethod( UnderlyingGroup, "for orbits of rcwa groups (RCWA)", true,
               [ IsRcwaGroupOrbitInStandardRep ], 0,
               orbit -> orbit!.group );

#############################################################################
##
#M  Representative( <orbit> ) . . . . . . . . . . . for orbits of rcwa groups
##
InstallMethod( Representative, "for orbits of rcwa groups (RCWA)", true,
               [ IsRcwaGroupOrbitInStandardRep ], 0,
               orbit -> orbit!.representative );

#############################################################################
##
#M  IsSubset( <R>, <orbit> ) . for underlying ring and orbit of an rcwa group
##
InstallMethod( IsSubset,
               "for underlying ring and orbit of an rcwa group (RCWA)",
               ReturnTrue, [ IsRing, IsRcwaGroupOrbitInStandardRep ], 0,

  function ( R, orbit )
    if   IsRcwaGroup(orbit!.group) and IsSubset(R,Source(One(orbit!.group)))
    then return true;
    elif not orbit!.representative in R then return false;
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  ViewObj( <orbit> ) . . . . . . . . . . . . . .  for orbits of rcwa groups
##
InstallMethod( ViewObj,
               "for orbits of rcwa groups (RCWA)", true,
              [ IsRcwaGroupOrbitInStandardRep ], 0,

  function ( orbit )
    Print("<orbit of ");
    ViewObj(orbit!.representative);
    Print(" under ");
    ViewObj(orbit!.group);
    Print(">");
  end );

#############################################################################
##
#M  \=( <orbit1>, <orbit2> ) . . . . . . . . . . .  for orbits of rcwa groups
##
InstallMethod( \=,
               "for orbits of rcwa groups (RCWA)", IsIdenticalObj,
               [ IsRcwaGroupOrbitInStandardRep,
                 IsRcwaGroupOrbitInStandardRep ], 0,

  function ( orbit1, orbit2 )

    local  G, gens, act, reps,
           m, orbs_mod_m, orbs_mod_m_tested,
           balls, oldballs;

    if   orbit1!.group  <> orbit2!.group
      or orbit1!.action <> orbit2!.action
    then return Set(AsList(orbit1)) = Set(AsList(orbit2)); fi;

    G    := orbit1!.group;
    gens := Set(GeneratorsAndInverses(G));
    act  := orbit1!.action;
    reps := [orbit1!.representative,orbit2!.representative];

    balls             := [[reps[1]],[reps[2]]];
    orbs_mod_m_tested := false;
    repeat
      oldballs := List(balls,ShallowCopy);
      balls    := List([1..2],i->Union(oldballs[i],
                       Union(List(gens,gen->List(oldballs[i],
                                                 pt->act(pt,gen))))));
      if   balls[1] = oldballs[1] and Length(balls[2]) > Length(balls[1])
        or balls[2] = oldballs[2] and Length(balls[1]) > Length(balls[2])
      then return false; fi;
      if    not orbs_mod_m_tested
        and act = OnPoints and IsSubset(Source(One(G)),reps)
        and Maximum(List(balls,Length)) > Lcm(List(gens,Modulus))^2
      then
        m          := Lcm(List(gens,Modulus));
        orbs_mod_m := OrbitsModulo(G,m);
        if    First(orbs_mod_m,orb->reps[1] mod m in orb)
           <> First(orbs_mod_m,orb->reps[2] mod m in orb)
        then return false; fi;
        orbs_mod_m_tested := true;
      fi;
    until not IsEmpty(Intersection(balls));
    return true;
  end );

#############################################################################
##
#M  \=( <orbit>, <list> ) . . . . .  for an orbit of an rcwa group and a list
##
InstallMethod( \=,
               "for an orbit of an rcwa group and a list (RCWA)", ReturnTrue,
               [ IsRcwaGroupOrbitInStandardRep, IsList ], 0,

  function ( orbit, list )

    local  ball, act, gens;

    gens := Set(GeneratorsAndInverses(orbit!.group));
    act  := orbit!.action;
    ball := [orbit!.representative];
    repeat    
      ball := Union(ball,Union(List(gens,gen->List(ball,pt->act(pt,gen)))));
      if   ball = list             then return true;
      elif not IsSubset(list,ball) then return false; fi;
    until Length(ball) > Length(list);
    return false;
  end );

#############################################################################
##
#M  \=( <list>, <orbit> ) . . . . .  for a list and an orbit of an rcwa group
##
InstallMethod( \=,
               "for a list and an orbit of an rcwa group (RCWA)", ReturnTrue,
               [ IsList, IsRcwaGroupOrbitInStandardRep ], 0,
               function ( list, orbit ) return orbit = list; end );

#############################################################################
##
#M  AsList( <orbit> ) . . . . . . . . . . . . . . . for orbits of rcwa groups
##
InstallMethod( AsList,
               "for orbits of rcwa groups (RCWA)", true,
               [ IsRcwaGroupOrbitInStandardRep ], 0,

  function ( orbit )

    local  ball, oldball, gens, act;

    gens := Set(GeneratorsAndInverses(orbit!.group));
    act  := orbit!.action;
    ball := [orbit!.representative];
    repeat    
      oldball := ShallowCopy(ball);
      ball    := Union(oldball,
                       Union(List(gens,gen->List(oldball,pt->act(pt,gen)))));
    until ball = oldball;
    return Set(ball);
  end );

#############################################################################
##
#M  \in( <point>, <orbit> ) . . . . for a point and an orbit of an rcwa group
##
InstallMethod( \in,
               "for a point and an orbit of an rcwa group (RCWA)",
               ReturnTrue, [ IsObject, IsRcwaGroupOrbitInStandardRep ], 0,

  function ( point, orbit )
    return Orbit(orbit!.group,point,orbit!.action) = orbit;
  end );

#############################################################################
##
#M  Size( <orbit> ) . . . . . . . . . . . . . . . . for orbits of rcwa groups
##
InstallMethod( Size,
               "for orbits of rcwa groups (RCWA)", true,
               [ IsRcwaGroupOrbitInStandardRep ], 0,

  function ( orbit )
    if HasIsFinite(orbit) and not IsFinite(orbit) then return infinity; fi;
    return Length(AsList(orbit));
  end );

#############################################################################
##
#M  Iterator( <orbit> ) . . . . . . . . . . . . . . for orbits of rcwa groups
##
InstallMethod( Iterator,
               "for orbits of rcwa groups (RCWA)", true,
               [ IsRcwaGroupOrbitInStandardRep ], 0,

  function ( orbit )
    return Objectify( NewType( IteratorsFamily,
                               IsIterator
                           and IsMutable
                           and IsRcwaGroupOrbitsIteratorRep ),
                      rec( orbit     := orbit,
                           sphere    := [Representative(orbit)],
                           oldsphere := [],
                           pos       := 1 ) );
  end );

#############################################################################
##
#M  NextIterator( <iter> ) . . . . . . for iterators of orbits of rcwa groups
##
InstallMethod( NextIterator,
               "for iterators of orbits of rcwa groups (RCWA)", true,
               [     IsIterator and IsMutable
                 and IsRcwaGroupOrbitsIteratorRep ], 0,

  function ( iter )

    local  orbit, G, action, gens, sphere, point;

    if not HasGeneratorsOfGroup(iter!.orbit!.group) then TryNextMethod(); fi;

    orbit  := iter!.orbit;
    G      := orbit!.group;
    action := orbit!.action;
    gens   := GeneratorsAndInverses(G);
    point  := iter!.sphere[iter!.pos];
    if iter!.pos < Length(iter!.sphere) then iter!.pos := iter!.pos + 1; else
      sphere := Difference(Union(List(gens,g->List(iter!.sphere,
                                                   pt->action(pt,g)))),
                           Union(iter!.sphere,iter!.oldsphere));
      iter!.oldsphere := iter!.sphere;
      iter!.sphere    := sphere;
      iter!.pos       := 1;
    fi;
    return point;
  end );

#############################################################################
##
#M  IsDoneIterator( <iter> ) . . . . . for iterators of orbits of rcwa groups
##
InstallMethod( IsDoneIterator,
               "for iterators of orbits of rcwa groups (RCWA)", true,
               [ IsIterator and IsRcwaGroupOrbitsIteratorRep ], 0,
               iter -> IsEmpty( iter!.sphere ) );

#############################################################################
##
#M  ShallowCopy( <iter> ) . . . . . .  for iterators of orbits of rcwa groups
##
InstallMethod( ShallowCopy,
               "for iterators of orbits of rcwa groups (RCWA)", true,
               [ IsIterator and IsRcwaGroupOrbitsIteratorRep ], 0,

  iter -> Objectify( Subtype( TypeObj( iter ), IsMutable ),
                     rec( orbit     := iter!.orbit,
                          sphere    := iter!.sphere,
                          oldsphere := iter!.oldsphere,
                          pos       := iter!.pos ) ) );

#############################################################################
##
#M  ViewObj( <iter> ) . . . . . . . .  for iterators of orbits of rcwa groups
##
InstallMethod( ViewObj,
               "for iterators of orbits of rcwa groups (RCWA)", true,
               [ IsIterator and IsRcwaGroupOrbitsIteratorRep ], 0,

  function ( iter )
    Print("Iterator of ");
    ViewObj(iter!.orbit);
  end );

#############################################################################
##
#F  CyclesOnFiniteOrbit( <G>, <g>, <n> ) . . . cycles of <g> on orbit <n>^<G>
##
InstallMethod( CyclesOnFiniteOrbit,
               "general method (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRcwaMapping and IsBijective, IsObject ], 0,

  function ( G, g, n )

    local  orb, r, cycs, cyc, m;

    if   Source(One(G)) <> Source(g) or not n in Source(g)
    then TryNextMethod(); fi;

    r := 2;
    repeat
      r := 2 * r;
      orb := Ball(G,n,r,OnPoints:Spheres);
    until orb[Length(orb)] = [];
    orb := Union(orb);
    cycs := [];
    repeat
      m := orb[1];
      cyc := Cycle(g,m);
      Add(cycs,cyc);
      orb := Difference(orb,cyc);
    until orb = [];
    return cycs;
  end );

#############################################################################
##
#M  ShortResidueClassOrbits( <G>, <modulusbound>, <maxlng> )
##
InstallMethod( ShortResidueClassOrbits,
               "for an rcwa group over Z and 2 positive integers (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsPosInt, IsPosInt ], 0,

  function ( G, modulusbound, maxlng )

    local  orbits, orbit, sphere, cl, covered, B, B_old,
           gens, affsrc, U, m, p, r, i, j;

    gens   := GeneratorsOfGroup(G);
    affsrc := List(gens,LargestSourcesOfAffineMappings);

    orbits := []; covered := [];
    for m in DivisorsInt(modulusbound) do
      Info(InfoRCWA,2,"ShortResidueClassOrbits: checking modulus m = ",m);
      for p in Difference([0..m-1],covered) do
        r := 0; B := [p];
        repeat
          r     := r + 1;
          B_old := B;
          B     := Ball(G,p,r,OnPoints);
        until B = B_old or Length(B) > maxlng;
        if Length(B) > maxlng then continue; fi;
        if p = Minimum(B) then
          orbit := []; cl := ResidueClass(p,m);
          if ForAny([1..Length(gens)],
                    i->m mod Mod(gens[i])<>0 and
                       Number(affsrc[i],src->Intersection(src,cl)<>[]) > 1)
          then continue; fi;
          sphere := [cl];
          orbit  := sphere;
          repeat 
            sphere := Difference(Union(List(gens,g->sphere^g)),orbit);
            orbit := Union(orbit,sphere);
          until sphere = [] or not ForAll(sphere,IsResidueClass);
          if sphere = [] then
            Add(orbits,orbit);
            covered := Union(covered,Union(orbit));
          fi;
        fi;
      od;
    od;

    for i in [2..Length(orbits)] do
      for j in [1..i-1] do
        if Intersection(orbits[i][1],orbits[j][1]) <> [] then
          if Mod(orbits[i][1]) > Mod(orbits[j][1]) then
            U := Union(orbits[i]);
            orbits[j] := List(orbits[j],cl->Difference(cl,U));
          else
            U := Union(orbits[j]);
            orbits[i] := List(orbits[i],cl->Difference(cl,U));
          fi;
        fi;
      od;
    od;

    if not ForAll(orbits,orb->ForAll(orb,IsResidueClass)) then
      orbits := Orbits(G,Flat(List(Concatenation(orbits),
                                   AsUnionOfFewClasses)));
    fi;

    return orbits;
  end );

#############################################################################
##
#M  ShortResidueClassOrbits( <G>, <modulusbound>, <maxlng> )
##
InstallMethod( ShortResidueClassOrbits,
              "for an rcwa group over Z and 2 positive integers (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsPosInt, IsPosInt ], 5,

  function ( G, modulusbound, maxlng )

    local  orbit, orbits, gens, coeffs, moduli,
           primes, primes_multdiv, primes_onlymod,
           powers_impossible, orb, m, n, r, i, j, k;

    orbit := function ( cl0 )

      local  B, r, cl, img, inter, c, i, j;

      B := [[cl0]];
      r := 0;
      repeat
        r := r + 1;
        Add(B,[]);
        for i in [1..Length(B[r])] do
          for j in [1..Length(coeffs)] do
            cl := B[r][i];
            inter := Filtered(coeffs[j],
                              c->(cl[1]-c[1]) mod Gcd(cl[2],c[2]) = 0);
            if    Length(inter) > 1
              and Length(Set(List(inter,c->c{[3..5]}))) > 1
            then return fail; fi;
            c := inter[1];
            img := [(c[3]*cl[1]+c[4])/c[5],c[3]*cl[2]/c[5]];
            img[1] := img[1] mod img[2];
            if img in B[r] or (r > 1 and img in B[r-1]) then continue; fi; 
            Add(B[r+1],img);
          od;
        od;
        B[r+1] := Set(B[r+1]);
        if Sum(List(B,Length)) > maxlng then return fail; fi;
      until B[r+1] = [];
      return Concatenation(B);
    end;

    if ValueOption("classic") = true then TryNextMethod(); fi;
    if IsTrivial(G) then return [ [ Integers ] ]; fi;
    G := SparseRep(G);
    gens := Set(GeneratorsAndInverses(G));
    coeffs := List(gens,g->ShallowCopy(Coefficients(g)));
    for i in [1..Length(coeffs)] do
      Sort(coeffs[i],function(c1,c2)
                       return c1{[2,1]} < c2{[2,1]};
                     end);
    od;
    primes := PrimeSet(G);
    primes_multdiv := Union(List(gens,g->Set(Factors(Mult(g)*Div(g)))));
    primes_multdiv := Difference(primes_multdiv,[1]);
    primes_onlymod := Difference(primes,primes_multdiv);
    m := Lcm(List(gens,Mod));
    powers_impossible := List(primes_onlymod,p->p^(ExponentOfPrime(m,p)+1));
    moduli := AllSmoothIntegers(primes,modulusbound);
    moduli := Filtered(moduli,m->ForAll(powers_impossible,q->m mod q<>0));
    orbits := [];
    n      := -1;
    repeat
      repeat
        n := n + 1;
      until ForAll(orbits,orb->ForAll(orb,cl->n mod cl[2] <> cl[1]));
      i := 0;
      repeat
        i := i + 1;
        m := moduli[i];
        orb := orbit([n mod m,m]);
      until orb <> fail or i = Length(moduli);
      if orb <> fail then Add(orbits,Set(orb)); fi;
    until n > modulusbound;
    orbits := List(orbits,orb->Set(List(orb,ResidueClass)));
    Sort(orbits,function(orb1,orb2)
                  return [Length(orb1),orb1] < [Length(orb2),orb2];
                end);
    return orbits;
  end );

###################################################################
##
#M  FixedResidueClasses( <G>, <maxmod> )
##
InstallMethod( FixedResidueClasses,
               "for an rcwa group over Z and a positive integer (RCWA)",
               ReturnTrue, [ IsRcwaGroupOverZ, IsPosInt ], 0,

  function ( G, maxmod )
    return Intersection(List(GeneratorsOfGroup(G),
                             g->FixedResidueClasses(g,maxmod)));
  end );

#############################################################################
##
#F  DrawOrbitPicture( <G>, <p0>, <bound>, <height>, <width>, <colored>,
#F                    <palette>, <filename> )
##
InstallGlobalFunction( DrawOrbitPicture,

  function ( G, p0, bound, height, width, colored, palette, filename )

    local  grid, orbits, orbit, balls, spheres, sphere, action, ps, p, k,
           color, white, z, e, offset, i, j;

    if   not (IsRcwaGroupOverZ(G) or IsRcwaGroupOverZxZ(G)) or not IsList(p0)
      or not ForAll(Flat(p0),IsInt)
      or not ForAll([bound,height,width],IsPosInt)
      or not IsBool(colored) or (colored = true and (not IsList(palette)
      or not ForAll(palette,IsList) or not Set(List(palette,Length)) = [3]
      or not IsSubset([0..255],Flat(palette)))) or not IsString(filename)
    then Error("DrawOrbitPicture: For usage, see manual.\n"); fi;

    if   IsRcwaGroupOverZ(G)   then action := OnTuples;
    elif IsRcwaGroupOverZxZ(G) then action := OnPoints; fi;

    offset := [1,1];
    if colored then
      white := 2^24-1;
      grid  := List([1..height],i->List([1..width],j->white));
      if IsInt(p0[1]) then # One orbit, color reflects distance from p0.
        spheres := RestrictedBall(G,p0,infinity,action,bound:Spheres);
        if IsRcwaGroupOverZ(G) then
          if   ForAny(spheres,sphere->sphere<>[] and Minimum(sphere)<0)
          then offset := [Int(height/2)+1,Int(width/2)+1]; fi;
        elif IsRcwaGroupOverZxZ(G) then
          if   ForAny(spheres,sphere->sphere<>[]
                              and ForAny(sphere,p->Minimum(p)<0))
          then offset := [Int(height/2)+1,Int(width/2)+1]; fi;
        fi;
        for k in [1..Length(spheres)] do
          sphere := spheres[k];
          color  := palette[(k-1) mod Length(palette) + 1];
          for p in sphere do
            i := p[1]+offset[1]; j := p[2]+offset[2];
            if   i in [1..height] and j in [1..width]
            then grid[i][j] := color*[65536,256,1]; fi;
          od;
        od;
      else # Multiple orbits, color reflects orbit membership.
        ps := p0; orbits := [];
        while ps <> [] do
          p0    := ps[1];
          orbit := RestrictedBall(G,p0,infinity,action,bound);
          ps    := Difference(ps,orbit);
          Add(orbits,orbit);
        od;
        if   Minimum(Flat(Union(orbits))) < 0
        then offset := [Int(height/2)+1,Int(width/2)+1]; fi;
        for i in [1..Length(orbits)] do
          orbit := orbits[i];
          color := palette[(i-1) mod Length(palette) + 1];
          for p in orbit do
            i := p[1]+offset[1]; j := p[2]+offset[2];
            if   i in [1..height] and j in [1..width]
            then grid[i][j] := color*[65536,256,1]; fi;
          od;
        od;
      fi;
      SaveAsBitmapPicture(grid,filename);
    else
      z := Zero(GF(2)); e := One(GF(2));
      grid := List([1..height],i->List([1..width],j->e));
      for i in [1..height] do ConvertToGF2VectorRep(grid[i]); od;
      orbit := RestrictedBall(G,p0,infinity,action,bound);
      if   Minimum(Flat(orbit)) < 0
      then offset := [Int(height/2)+1,Int(width/2)+1]; fi;
      for p in orbit do
        i := p[1]+offset[1]; j := p[2]+offset[2];
        if i in [1..height] and j in [1..width] then grid[i][j] := z; fi;
      od;
      SaveAsBitmapPicture(grid,filename);
    fi;
    if ValueOption("ReturnPicture") = true then return grid; fi;
  end );

#############################################################################
##
#S  Computing elements which map a given tuple to a given other tuple. //////
##
#############################################################################

#############################################################################
##
#M  RepresentativesActionPreImage( <G>, <src>, <dest>, <act>, <F> )
##
InstallMethod( RepresentativesActionPreImage,
               "for rcwa groups and permutation groups (RCWA)", ReturnTrue,
               [ IsFinitelyGeneratedGroup, IsObject, IsObject,
                 IsFunction, IsFreeGroup ], 0,

  function ( G, src, dest, act, F )

    local  SetOfRepresentatives, Extended, R, gensG, gensF, 
           orbsrc, orbdest, orbitlengthbound, g, extstep, oldorbsizes,
           inter, intersrc, interdest, compatible, quots;

    SetOfRepresentatives := function ( S, rel, less, pref )

      local  reps, elm, pos;

      if IsEmpty(S) then return []; fi;
      Sort(S,less); reps := [S[1]]; pos := 1;
      for elm in S do
        if rel(elm,reps[pos]) then
          if pref(elm,reps[pos]) then reps[pos] := elm; fi;
        else
          pos := pos + 1;
          reps[pos] := elm;
        fi;
      od;
      return reps;
    end;

    Extended := function ( orb, gens )

      local  eq, lt, shorter, nextlayer, g;

      nextlayer := List(gens,g->List(orb,t->[act(t[1],g),
                                     t[2]*gensF[Position(gensG,g)]]));
      orb := Union(Concatenation([orb],nextlayer));
      eq := function(t1,t2) return t1[1] = t2[1]; end;
      lt := function(t1,t2) return t1[1] < t2[1]; end;
      shorter := function(t1,t2) return Length(t1[2]) < Length(t2[2]); end;
      return SetOfRepresentatives(orb,eq,lt,shorter);
    end;

    orbitlengthbound := ValueOption("OrbitLengthBound");
    if orbitlengthbound = fail then orbitlengthbound := infinity; fi;

    if   IsPermGroup(G)
    then R := PositiveIntegers;
    elif IsRcwaGroup(G) then R := Source(One(G));
    else TryNextMethod(); fi;
    if not IsList(src)  then src  := [src];  fi;
    if not IsList(dest) then dest := [dest]; fi;
    if   not IsSubset(R,Union(src,dest))
      or Length(GeneratorsOfGroup(G)) <> Length(GeneratorsOfGroup(F))
    then TryNextMethod(); fi;
    if Length(src) <> Length(dest) then return []; fi;
    gensF := GeneratorsAndInverses(F); gensG := GeneratorsAndInverses(G);
    orbsrc := [[src,One(F)]]; orbdest := [[dest,One(F)]]; extstep := 0;
    repeat
      oldorbsizes := [Length(orbsrc),Length(orbdest)];
      if Maximum(oldorbsizes) > orbitlengthbound then
        Info(InfoRCWA,2,"Orbit lengths exceeded user-specified bound.");
        return [];
      fi;
      orbsrc := Extended(orbsrc,gensG); orbdest := Extended(orbdest,gensG);
      extstep := extstep + 1;
      Info(InfoRCWA,2,"Orbit lengths after extension step ",extstep,": ",
                      [Length(orbsrc),Length(orbdest)]);
      if Maximum(Length(orbsrc),Length(orbdest)) < 100 then
        Info(InfoRCWA,3,"Orbits after extension step ",extstep,":\n",
                        orbsrc,"\n",orbdest);
      fi;
      inter := Intersection(List(orbsrc,t->t[1]),List(orbdest,t->t[1]));
    until inter <> [] or oldorbsizes = [Length(orbsrc),Length(orbdest)];
    if inter = [] then return []; fi;
    intersrc   := Filtered(orbsrc, t->t[1] in inter);
    interdest  := Filtered(orbdest,t->t[1] in inter);
    compatible := Filtered(Cartesian(intersrc,interdest),t->t[1][1]=t[2][1]);
    Info(InfoRCWA,2,"|Candidates| = ",Length(compatible));
    quots := Set(compatible,t->t[1][2]*t[2][2]^-1);
    if IsRcwaGroupOverZ(G) then
      quots := List(quots,quot->ReducedWordByOrdersOfGenerators(quot,
                                  List(GeneratorsOfGroup(G),Order)));
    fi;
    return quots;
  end );

#############################################################################
##
#M  RepresentativeActionPreImage( <G>, <src>, <dest>, <act>, <F> )
##
InstallMethod( RepresentativeActionPreImage,
               "for rcwa groups and permutation groups (RCWA)", ReturnTrue,
               [ IsGroup, IsObject, IsObject, IsFunction, IsFreeGroup ],
               0,

  function ( G, src, dest, act, F )

    local  candidates, minlng, shortest;

    if not IsRcwaGroup(G) and not IsPermGroup(G) then TryNextMethod(); fi;
    candidates := RepresentativesActionPreImage(G,src,dest,act,F);
    if candidates = [] then return fail; fi;
    minlng   := Minimum(List(candidates,Length));
    shortest := Filtered(candidates,cand->Length(cand)=minlng)[1];
    return shortest;
  end );

#############################################################################
##
#M  RepresentativeActionOp( <G>, <src>, <dest>, <act> )
##
InstallMethod( RepresentativeActionOp,
               "for rcwa groups (RCWA)", ReturnTrue,
               [ IsRcwaGroup and IsFinitelyGeneratedGroup,
                 IsObject, IsObject, IsFunction ], 0,

  function ( G, src, dest, act )

    local  F, phi, pre;

     phi := EpimorphismFromFreeGroup(G);
     pre := RepresentativeActionPreImage(G,src,dest,act,Source(phi));
     if pre = fail then return fail; fi;
     return pre^phi;
  end );

#############################################################################
##
#S  Factoring elements of an rcwa group into the generators. ////////////////
##
#############################################################################

#############################################################################
##
#M  EpimorphismFromFreeGroup( <G> ) . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( EpimorphismFromFreeGroup,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  F, gens, gensnames, i;

    gens := GeneratorsOfGroup(G); gensnames := [];
    for i in [1..Length(gens)] do
      if   HasName(gens[i])
      then Add(gensnames,Name(gens[i]));
      else Add(gensnames,Concatenation("f",String(i))); fi;
    od;
    F := FreeGroup(gensnames);
    return EpimorphismByGenerators(F,G);
  end );

#############################################################################
##
#M  PreImagesRepresentatives( <phi>, <g> )
##
InstallMethod( PreImagesRepresentatives,
               "for hom's from free groups to rcwa groups (RCWA)",
               ReturnTrue, [ IsGroupHomomorphism, IsObject ], 0,

  function ( phi, g )

    local  IsCorrect, F, G, R, q, x, candidates, minlng, shortest,
           preimage, image, lng, add;

    IsCorrect := function ( cand )

      local  gens, letters, factors, testrange, f, n, m;

      gens      := GeneratorsOfGroup(G);
      letters   := LetterRepAssocWord(cand);
      factors   := List(letters,i->gens[AbsInt(i)]^SignInt(i));
      testrange := [1..3*Length(letters)+1];
      if   IsRcwaGroupOverGFqx(G)
      then testrange := AllResidues(R,x^(LogInt(Length(testrange),q)+1)); fi;
      for n in testrange do
        m := n; for f in factors do m := m^f; od;
        if m <> n^g then return false; fi;
      od;
      return cand^phi = g;
    end;

    F := Source(phi); G := Range(phi);
    if   not IsFreeGroup(F)
      or not (   IsRcwaGroupOverZOrZ_pi(G) or IsRcwaGroupOverGFqx(G)
              or IsPermGroup(G))
      or FamilyObj(g) <> FamilyObj(One(G))
      or MappingGeneratorsImages(phi) <> List([F,G],GeneratorsOfGroup)
    then TryNextMethod(); fi;
    lng := 1; add := 1;
    repeat
      lng := lng + add; add := add + 1; 
      # formerly: if IsPermGroup(G) then add := add + 1; fi;
      preimage := [1..lng];
      if IsRcwaGroupOverGFqx(G) then
        R        := Source(One(G));
        q        := Size(CoefficientsRing(R));
        x        := IndeterminatesOfPolynomialRing(R)[1];
        preimage := AllResidues(R,x^(LogInt(lng,q)+1)){preimage};
      fi;
      image      := List(preimage,n->n^g);
      candidates := RepresentativesActionPreImage(G,preimage,image,
                                                  OnTuples,F);
      if candidates = [] then return []; fi;
      candidates := Filtered(candidates,IsCorrect);
    until candidates <> [];
    return candidates;
  end );

#############################################################################
##
#M  PreImagesRepresentative( <phi>, <g> )
##
InstallMethod( PreImagesRepresentative,
               "for hom's from free groups to rcwa- or perm.-groups (RCWA)",
               ReturnTrue, [ IsGroupHomomorphism, IsObject ], SUM_FLAGS,

  function ( phi, g )

    local  candidates, minlng, shortest;

    if not IsRcwaMapping(g) and
       not (IsPerm(g) and ValueOption("NoStabChain") = true)
    then TryNextMethod(); fi;
    candidates := PreImagesRepresentatives(phi,g);
    if candidates = [] then return fail; fi;
    minlng   := Minimum(List(candidates,Length));
    shortest := Filtered(candidates,cand->Length(cand)=minlng)[1];
    return shortest;
  end );

#############################################################################
##
#M  Factorization( <G>, <g> ) . . . . . . .  for rcwa mappings in rcwa groups
##
InstallMethod( Factorization,
               "for rcwa mappings in rcwa groups (RCWA)", true,
               [ IsRcwaGroup, IsRcwaMapping ], 0,

  function ( G, g )
    return PreImagesRepresentative(EpimorphismFromFreeGroup(G),g);
  end );

#############################################################################
##
#S  Methods for `IsSolvable', `IsPerfect', `IsSimple' and `Exponent'. ///////
##
#############################################################################

#############################################################################
##
#M  IsSolvable( <G> ) . . . . . . . . . . . . . . . default method for groups
##
InstallMethod( IsSolvable,
               "default method for groups (RCWA)", true, [ IsGroup ],
               SUM_FLAGS,

  function ( G )
    if   HasIsSolvableGroup(G)
    then return IsSolvableGroup(G);
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  IsSolvable( <G> ) . . . . . . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( IsSolvable,
               "for rcwa groups (RCWA)", ReturnTrue, [ IsRcwaGroup ], 0,

  function ( G )
    if IsAbelian(G) then return true; fi;
    if not IsTame(G) then TryNextMethod(); fi;
    return IsSolvable(ActionOnRespectedPartition(G));
  end );

#############################################################################
##
#M  IsPerfect( <G> ) . . . . . . . . . . . . . . .  default method for groups
##
InstallMethod( IsPerfect,
               "default method for groups (RCWA)", true, [ IsGroup ],
               SUM_FLAGS,

  function ( G )
    if   HasIsPerfectGroup(G)
    then return IsPerfectGroup(G);
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  IsPerfect( <G> ) . . . . . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( IsPerfect,
               "for rcwa groups (RCWA)", ReturnTrue, [ IsRcwaGroup ], 0,

  function ( G )

    local  H, orbs, quots;

    if IsTrivial(G) then return true; fi;
    if IsAbelian(G) then return false; fi;

    if IsRcwaGroupOverZ(G) then
      if   ForAny(GeneratorsOfGroup(G),g->Sign(g)<>1)
        or (     IsClassWiseOrderPreserving(G)
             and ForAny(GeneratorsOfGroup(G),g->Determinant(g)<>0))
      then return false; fi;
    fi;

    orbs  := ShortOrbits(G,AllResidues(Source(One(G)),
                                       Lcm(List(GeneratorsOfGroup(G),
                                                Modulus))),64);
    quots := List(orbs,orb->Action(G,orb));
    if not ForAll(quots,IsPerfect) then return false; fi;

    if IsFinite(G) then return IsPerfect(Image(IsomorphismPermGroup(G))); fi;

    if not IsTame(G) then TryNextMethod(); fi;

    H := ActionOnRespectedPartition(G);
    if   IsTransitive(H,[1..LargestMovedPoint(H)])
    then return IsPerfect(H); else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  IsSimple( <G> ) . . . . . . . . . . . . . . . . default method for groups
##
InstallMethod( IsSimple,
               "default method for groups (RCWA)", true, [ IsGroup ],
               SUM_FLAGS,

  function ( G )
    if   HasIsSimpleGroup(G)
    then return IsSimpleGroup(G);
    else TryNextMethod(); fi;
  end );

#############################################################################
##
#M  IsSimpleGroup( <G> ) . . . . . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( IsSimpleGroup,
               "for rcwa groups (RCWA)", ReturnTrue, [ IsRcwaGroup ], 0,

  function ( G )

    local  interval;

    if   IsRcwaGroupOverZ(G) then
      interval := [-Lcm(List(GeneratorsOfGroup(G),Modulus))..
                       Lcm(List(GeneratorsOfGroup(G),Modulus))];
    else
      interval := AllResidues(Source(One(G)),
                              Lcm(List(GeneratorsOfGroup(G),
                                       Modulus)));
    fi;

    if   ShortOrbits(G,interval,64) <> [] or not IsPerfect(G)
    then return false; fi;

    if IsTame(G) then
      if   IsFinite(G)
      then return IsSimpleGroup(Image(IsomorphismPermGroup(G)));
      else return false; fi;
    fi;

    TryNextMethod();
  end );

#############################################################################
##
#M  Exponent( <G> ) . . . . . . . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( Exponent,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )

    local  k;

    if IsNaturalRCWA_OR_CT(G) then return infinity; fi;
    if IsFinite(G) then return Exponent(Image(IsomorphismPermGroup(G))); fi;
    if IsTame(G)   then return infinity; fi;
    if   ForAny(GeneratorsOfGroup(G),g->Order(g)=infinity)
    then return infinity; fi;
    if First(G,g->Order(g)=infinity) <> fail then return infinity; fi;
  end );

#############################################################################
##
#S  Subgroup indices and natural homomorphisms. /////////////////////////////
##
#############################################################################

#############################################################################
##
#M  IndexNC( <G>, <H> ) . . . . . . . . . . . . . . . . . . . for rcwa groups
##
InstallMethod( IndexNC,
               "for rcwa groups (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRcwaGroup ], 0,

  function ( G, H )
    if ForAll([G,H],IsFinite) then return Size(G)/Size(H); fi;
    if IsFinite(H) and not IsFinite(G) then return infinity; fi;
    return Length(RightCosets(G,H));
  end );

#############################################################################
##
#M  IndexNC( <G>, <H> ) . . . . . . . . . . . . . . . . for rcwa groups over Z
##
InstallMethod( IndexNC,
               "for rcwa groups over Z (RCWA)", ReturnTrue,
               [ IsRcwaGroupOverZ, IsRcwaGroupOverZ ], 0,

  function ( G, H )
    if IsClassWiseOrderPreserving(G)
      and Set(List(GeneratorsOfGroup(G),Determinant)) <> [0]
      and Set(List(GeneratorsOfGroup(H),Determinant)) =  [0]
    then return infinity; fi;
    if IsTame(H) and not IsTame(G) then return infinity; fi;
    if IsTame(G) and RankOfKernelOfActionOnRespectedPartition(G)
                   > RankOfKernelOfActionOnRespectedPartition(H)
    then return infinity; fi;
    return Length(RightCosets(G,H));
  end );

#############################################################################
##
#M  NaturalHomomorphismByNormalSubgroupNCOrig( <G>, <N> ) . . for rcwa groups
##
InstallMethod( NaturalHomomorphismByNormalSubgroupNCOrig,
               "for rcwa groups, requiring finite index (RCWA)", ReturnTrue,
               [ IsRcwaGroup, IsRcwaGroup ], 0,

  function ( G, N )

    local  cosets, img;

    if not IsNormal(G,N) then return fail; fi;
    if IndexNC(G,N) = infinity then TryNextMethod(); fi;
    cosets := RightCosets(G,N);
    img    := Action(G,cosets,OnRight);
    return EpimorphismByGeneratorsNC(G,img);
  end );

#############################################################################
##
#S  Rcwa groups as epimorphic images of finitely presented groups. //////////
##
#############################################################################

#############################################################################
##
#M  EpimorphismFromFpGroup( <G>, <r> ) . . . . default method for f.g. groups
##
InstallMethod( EpimorphismFromFpGroup,
               "default method (RCWA)", ReturnTrue,
               [ IsFinitelyGeneratedGroup, IsPosInt ], 0,

  function ( G, r )

    local  Fp, FpS, phi, phiFp, phiFpS, F, BF, BG, BGset, rels, gensF, g, w,
           ShortGroupRelations;

    if IsFpGroup(G) then return IdentityMapping(G); fi;

    phi       := EpimorphismFromFreeGroup(G);
    F         := Source(phi);
    gensF     := GeneratorsOfGroup(F);

    if IsReadOnlyGlobal( "ShortGroupRelations" ) then # FR is loaded.

      ShortGroupRelations := ValueGlobal( "ShortGroupRelations" );

      rels := ShortGroupRelations(G,r);
      rels := rels{[2..Length(rels)]};

    else

      BF        := Ball(F,One(F),r);
      BG        := List(BF,g->Image(phi,g));
      BGset     := Set(BG);

      rels      := [];
      for g in BGset do
        Append(rels,List(Combinations(BF{Positions(BG,g)},2),w->w[1]/w[2]));
        if Order(g) < infinity then
          w := BF[Position(BG,g)];
          if Maximum(ExponentSums(w)) >= 0 then Add(rels,w^Order(g)); fi;
        fi;
      od;
      rels := Difference(rels,[One(F)]);

    fi;

    Fp     := F/rels;
    phiFp  := EpimorphismByGeneratorsNC(Fp,G);
    phiFpS := InverseGeneralMapping(IsomorphismSimplifiedFpGroup(Fp));

    return CompositionMapping(phiFp,phiFpS);
  end );

#############################################################################
##
#M  EpimorphismFromFpGroup( <G>, <r> ) . . . . . . . . . . .  for rcwa groups
##
InstallMethod( EpimorphismFromFpGroup,
               "for rcwa groups over Z (RCWA)", ReturnTrue,
               [ IsRcwaGroup and IsFinitelyGeneratedGroup, IsPosInt ], 10,

  function ( G, r )

    local  gensG, gensF, F, Q, D, rels, relsnew, relsgenspows, relsmain,
           abinvs, invs, d, B, W, phi, n, letters, m, onlyperfect,
           timeout, starttime, involutions, g, h, v, w, i, j, k, pos;

    onlyperfect := ValueOption("onlyperfect") = true
                or ValueOption("OnlyPerfect") = true;
    timeout     := ValueOption("timeout");
    starttime   := Runtime();

    letters := ["a","b","c","d","e","f","g","h","k","l","m","n"];
    gensG   := GeneratorsOfGroup(G);
    n       := Length(gensG);
    if n <= 12 then F := FreeGroup(letters{[1..n]});
               else F := FreeGroup(n); fi;
    gensF   := GeneratorsOfGroup(F);

    involutions := Set(gensG,Order) = [2];

    Info(InfoRCWA,2,"EpimorphismFromFpGroup: computing ball of radius ",
                    r,"\n");

    B := Ball(G,One(G),r:Spheres);
    W := [[One(F)]];
    for i in [2..r+1] do
      W[i] := [];
      for j in [1..Length(B[i-1])] do
        g := B[i-1][j];
        v := W[i-1][j];
        for k in [1..n] do
          h := g*gensG[k];
          w := v*gensF[k];
          pos := Position(B[i],h);
          if pos <> fail then
            W[i][pos] := w;
          fi;
        od;
      od;
    od;

    Info(InfoRCWA,2,"EpimorphismFromFpGroup: searching for relations");

    rels   := [];
    abinvs := [ListWithIdenticalEntries(n,0)];
    for i in [2..r+1] do
      if IsInt(timeout) and Runtime()-starttime >= timeout
      then break; fi;
      Info(InfoRCWA,2,"r = ",i-1,"\n");
      for j in [1..Length(B[i])] do
        if IsInt(timeout) and Runtime()-starttime >= timeout
        then break; fi;
        Info(InfoRCWA,3,"Element number = ",j,"\n");
        g := B[i][j];
        w := W[i][j];
        if involutions 
          and Set(Collected(LetterRepAssocWord(w)),l->l[2]) mod 2 = [0]
        then continue; fi;
        m := Order(g);
        if IsInfinity(m) then continue; fi;
        if   i > 2 and onlyperfect and involutions and m mod 2 = 0
        then continue; fi;
        relsnew := Concatenation(rels,[w^m]);
        Q := F/relsnew; D := Q; d := 1;
        repeat
          invs := AbelianInvariants(D);
          if not IsBound(abinvs[d]) or invs <> abinvs[d] then
            abinvs[d] := invs;
            rels := relsnew;
            break;
          elif invs = [] or 0 in invs then break;
          elif onlyperfect then break;
          else D := DerivedSubgroup(D);
               d := d + 1;
          fi;
        until invs = [] or 0 in invs;
      od;
    od;
    relsgenspows := Filtered(rels,w->Length(ExtRepOfObj(w))=2);
    relsmain     := Difference(rels,relsgenspows);
    rels := Union(relsgenspows,
                  Set(relsmain,w->NormalizedRelator(w,List(gensG,Order))));
    Q := F/rels;
    phi := EpimorphismByGenerators(Q,G);
    return phi;
  end );

#############################################################################
##
#S  Computing structure descriptions for rcwa groups. ///////////////////////
##
#############################################################################

#############################################################################
##
#M  StructureDescription( <G> ). . . . . . . . . . . . for rcwa groups over Z
##
InstallMethod( StructureDescription,
               "for rcwa groups over Z (RCWA)",
               true, [ IsRcwaGroupOverZ ], 0,

  function ( G )

    local  desc, short, P, H, rank, top, bottom, ords, factors, descs, gens,
           bound, domain, induced, commgraph, e, comps, comp, comp_old, rem,
           i;

    if not IsFinitelyGeneratedGroup(G) then TryNextMethod(); fi;
    short := ValueOption("short") <> fail;

    if IsTrivial(G) then return "1"; fi;
    if   IsFinite(G)
    then return StructureDescription(Image(IsomorphismPermGroup(G))); fi;
    if HasDirectProductInfo(G) then
      factors := DirectProductInfo(G)!.groups;
      descs   := Filtered(List(factors,StructureDescription),str->str<>"1");
      for i in [1..Length(descs)] do
        if   Intersection(descs[i],"x:.*wr") <> ""
        then descs[i] := Concatenation("(",descs[i],")"); fi; 
      od;
      desc := descs[1];
      for i in [2..Length(descs)] do
        desc := Concatenation(desc," x ",descs[i]);
      od;
      if short then RemoveCharacters(desc," "); fi;
      return desc;
    fi;
    if HasWreathProductInfo(G) then
      factors := WreathProductInfo(G)!.groups;
      descs   := List(factors,StructureDescription);
      for i in [1..2] do
        if   Intersection(descs[i],"x:.*wr") <> ""
        then descs[i] := Concatenation("(",descs[i],")"); fi; 
      od;
      desc := Concatenation(descs[1]," wr ",descs[2]);
      if short then RemoveCharacters(desc," "); fi;
      return desc;
    fi;
    if HasFreeProductInfo(G) then
      factors := FreeProductInfo(G)!.groups;
      descs   := Filtered(List(factors,StructureDescription),str->str<>"1");
      for i in [1..Length(descs)] do
        if   Intersection(descs[i],"x:.*wr") <> ""
        then descs[i] := Concatenation("(",descs[i],")"); fi; 
      od;
      desc := descs[1];
      for i in [2..Length(descs)] do
        desc := Concatenation(desc," * ",descs[i]);
      od;
      if short then RemoveCharacters(desc," "); fi;
      return desc;
    fi;
    gens := DuplicateFreeList(Filtered(GeneratorsOfGroup(G),
                                       gen->not IsOne(gen)));
    List(gens,IsTame);
    if   Length(gens) = 2 and not IsAbelian(G) and List(gens,Order) = [2,2]
    then if not IsTame(Product(gens)) or Order(Product(gens)) = infinity
         then return "D0"; fi; fi;
    if Length(gens) = 2 and Set(List(gens,Order)) = [2,infinity] then
      if   Order(gens[1]) = infinity and gens[1]^gens[2] = gens[1]^-1
        or Order(gens[2]) = infinity and gens[2]^gens[1] = gens[2]^-1
      then return "D0"; fi;
    fi;
    commgraph := Filtered(Combinations([1..Length(gens)],2),
                          e->not IsEmpty(Intersection(Support(gens[e[1]]),
                                                      Support(gens[e[2]]))));
    comps := []; rem := [1..Length(gens)];
    repeat
      comp := [rem[1]];
      repeat
        comp_old := ShallowCopy(comp);
        for e in commgraph do
          if Intersection(comp,e) <> [] then comp := Union(comp,e); fi;
        od;
      until comp = comp_old;
      Add(comps,comp);
      rem := Difference(rem,comp);
    until rem = [];
    if Length(comps) > 1 then
      descs := List(comps,comp->StructureDescription(Group(gens{comp})));
      desc  := ShallowCopy(descs[1]);
      for i in [2..Length(comps)] do
        Append(desc," x ");
        if Intersection(descs[i],"x:.*wr") <> ""
        then descs[i] := Concatenation("(",descs[i],")"); fi;
        Append(desc,descs[i]);
      od;
      if short then RemoveCharacters(desc," "); fi;
      return desc;
    fi;
    if IsTame(G) then
      if IsFinite(G) then
        return StructureDescription(Image(IsomorphismPermGroup(G)));
      else
        if Length(gens) = 1 then return "Z"; fi;
        rank := RankOfKernelOfActionOnRespectedPartition(G);
        if   IsClassWiseOrderPreserving(G)
        then H := ActionOnRespectedPartition(G);
        else H := Action(G,RefinedRespectedPartitions(G)[2]); fi;
        top := StructureDescription(H);
        if short then bottom := Concatenation("Z^",String(rank)); else
          bottom := "Z";
          for i in [2..rank] do bottom := Concatenation(bottom," x Z"); od;
        fi;
        if not IsTrivial(H) then
          if   Intersection(top,"x:.") <> ""
          then top := Concatenation("(",top,")"); fi;
          if   Position(bottom,'x') <> fail
          then bottom := Concatenation("(",bottom,")"); fi;
          if short then
            desc := Concatenation(bottom,".",top);
          else
            desc := Concatenation(bottom," . ",top);
          fi;
        else desc := bottom; fi;
        return desc;
      fi;
    else
      if Length(gens) = 1 then return "Z"; fi;
      if   HasRankOfFreeGroup(G)
      then return Concatenation("F",String(RankOfFreeGroup(G))); fi;
      bound  := Lcm(List(gens,Modulus)); # some `reasonable' value
      domain := Intersection(Support(G),[-bound..bound]);
      domain := Concatenation(ShortOrbits(G,domain,100));
      if not IsEmpty(domain) then
        induced := Action(G,domain);
        top     := StructureDescription(induced);
        if   Intersection(top,"x:.") <> ""
        then top := Concatenation("(",top,")"); fi;
        desc := Concatenation("<unknown> . ",top);
      else
        if IsClassWiseOrderPreserving(G)
          and not ForAll(gens,gen->Determinant(gen)=0)
        then desc := "<unknown> . Z";
        elif not ForAll(gens,gen->Sign(gen)=1)
        then desc := "<unknown> . 2";
        else desc := "<unknown>"; fi;
      fi;
      if short then RemoveCharacters(desc," "); fi;
      return desc;
    fi;
  end );

#############################################################################
##
#M  StructureDescription( <G> ). . . . . . . . . . . . . . .  for rcwa groups
##
InstallMethod( StructureDescription,
               "for rcwa groups (RCWA)", true, [ IsRcwaGroup ], 0,

  function ( G )
    if   IsNaturalRCWA_Z(G) or IsNaturalRCWA_Z_pi(G) or IsNaturalRCWA_GFqx(G)
    then return Name(G); fi;
    if   IsFinite(G)
    then return StructureDescription(Image(IsomorphismPermGroup(G))); fi;
    return "<unknown>";
  end );

#############################################################################
##
#S  Loading data libraries. /////////////////////////////////////////////////
##
#############################################################################

#############################################################################
##
#F  LoadRCWAExamples( ) . . . . . . . . . . . . . . .  load examples database
##
InstallGlobalFunction( LoadRCWAExamples,

  function ( )
    return ReadAsFunction(
             Concatenation(PackageInfo("rcwa")[1].InstallationPath,
                           "/examples/examples.g"))();
  end );

#############################################################################
##
#F  LoadDatabaseOfProductsOf2ClassTranspositions( )
##
InstallGlobalFunction( LoadDatabaseOfProductsOf2ClassTranspositions,
            
  function ( )
    return ReadAsFunction(
             Concatenation(PackageInfo("rcwa")[1].InstallationPath,
                           "/data/ctprodclass.g"))();
  end );

#############################################################################
##
#F  LoadDatabaseOfNonbalancedProductsOfClassTranspositions( )
##
InstallGlobalFunction(
  LoadDatabaseOfNonbalancedProductsOfClassTranspositions,

  function ( )
    return ReadAsFunction(
             Concatenation(PackageInfo("rcwa")[1].InstallationPath,
                           "/data/ctprods.g"))();
  end );

#############################################################################
##
#F  LoadDatabaseOfGroupsGeneratedBy3ClassTranspositions( )
##
InstallGlobalFunction( LoadDatabaseOfGroupsGeneratedBy3ClassTranspositions,

  function ( )
    return ReadAsFunction(
             Concatenation(PackageInfo("rcwa")[1].InstallationPath,
                           "/data/3ctsgrpdata.g"))();
  end );

#############################################################################
##
#F  LoadDatabaseOfGroupsGeneratedBy4ClassTranspositions( )
##
InstallGlobalFunction( LoadDatabaseOfGroupsGeneratedBy4ClassTranspositions,

  function ( )
    return ReadAsFunction(
             Concatenation(PackageInfo("rcwa")[1].InstallationPath,
                           "/data/4ctsgrpdata.g"))();
  end );

#############################################################################
##
#E  rcwagrp.gi . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here