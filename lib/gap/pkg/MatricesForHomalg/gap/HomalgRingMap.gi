#############################################################################
##
##  HomalgRingMaps.gi           MatricesForHomalg package    Mohamed Barakat
##
##  Copyright 2009, Mohamed Barakat, Universität des Saarlandes
##
##  Implementations of procedures for ring maps.
##
#############################################################################

##  <#GAPDoc Label="RingMaps:intro">
##  A &homalg; ring map is a data structure for maps between finitely generated rings. &homalg; more or less provides the basic
##  declarations and installs the generic methods for ring maps, but it is up to other high level packages to install methods
##  applicable to specific rings. For example, the package &Sheaves; provides methods for ring maps of (finitely generated) affine rings.
##  <#/GAPDoc>

####################################
#
# representations:
#
####################################

##  <#GAPDoc Label="IsHomalgRingMapRep">
##  <ManSection>
##    <Filt Type="Representation" Arg="phi" Name="IsHomalgRingMapRep"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The &GAP; representation of &homalg; ring maps. <P/>
##      (It is a representation of the &GAP; category <Ref Filt="IsHomalgRingMap"/>.)
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsHomalgRingMapRep",
        IsHomalgRingMap,
        [ ] );

# a new family:
BindGlobal( "TheFamilyOfHomalgRingMaps",
        NewFamily( "TheFamilyOfHomalgRingMaps" ) );

# two new types:
BindGlobal( "TheTypeHomalgRingMap",
        NewType( TheFamilyOfHomalgRingMaps,
                IsHomalgRingMapRep ) );

BindGlobal( "TheTypeHomalgRingSelfMap",
        NewType( TheFamilyOfHomalgRingMaps,
                IsHomalgRingMapRep and IsHomalgRingSelfMap ) );

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( ImagesOfRingMap,
        "for homalg ring maps",
        [ IsHomalgRingMap ],
        
  function( phi )
    
    return phi!.images;
    
end );

####################################
#
# constructor functions and methods:
#
####################################

##  <#GAPDoc Label="RingMap">
##  <ManSection>
##    <Oper Arg="images, S, T" Name="RingMap" Label="constructor for ring maps"/>
##    <Returns>a &homalg; ring map</Returns>
##    <Description>
##      This constructor returns a ring map (homomorphism) of finitely generated rings/algebras. It is represented by the
##      images <A>images</A> of the set of generators of the source &homalg; ring <A>S</A> in terms of the
##      generators of the target ring <A>T</A> (&see; <Ref Sect="Rings:Constructors"/>). Unless the source ring is free
##      <E>and</E> given on free ring/algebra generators the returned map will cautiously be indicated using
##      parenthesis: <Q>homomorphism</Q>. To verify if the result is indeed a well defined map use
##      <Ref Prop="IsMorphism" Label="for ring maps"/>.
##      If source and target are identical objects, and only then, the ring map is created as a selfmap.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
InstallMethod( RingMap,
        "constructor for homalg ring maps",
        [ IsList, IsHomalgRing, IsHomalgRing ],
        
  function( images, S, T )
    local map, type;
    
    map := rec( images := images );
    
    if IsIdenticalObj( S, T ) then
        type := TheTypeHomalgRingSelfMap;
    else
        type := TheTypeHomalgRingMap;
    fi;
    
    ## Objectify:
    ObjectifyWithAttributes(
            map, type,
            Source, S,
            Range, T );
    
    return map;
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingMap ],
        
  function( o )
    
    Print( "<A" );
    
    if HasIsMorphism( o ) then
        if IsMorphism( o ) then
            Print( " homomorphism of" );
        else
            Print( " non-well-defined map of" );
        fi;
    else
        Print( " \"homomorphism\" of" );
    fi;
    
    Print( " rings>" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingMap and IsMonomorphism ], 996,
        
  function( o )
    
    Print( "<A monomorphism of rings>" );
    
end );    

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingMap and IsEpimorphism ], 997,
        
  function( o )
    
    Print( "<An epimorphism of rings>" );
    
end );    

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingMap and IsIsomorphism ], 1000,
        
  function( o )
    
    Print( "<An isomorphism of rings>" );
    
end );    

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingSelfMap ],
        
  function( o )
    
    Print( "<A" );
    
    if HasIsZero( o ) then ## if this method applies and HasIsZero is set we already know that o is a non-zero map of homalg rings
        Print( " non-zero" );
    elif not ( HasIsMorphism( o ) and not IsMorphism( o ) ) then
        Print( "n" );
    fi;
    
    if HasIsMorphism( o ) then
        if IsMorphism( o ) then
            Print( " endomorphism of" );
        else
            Print( " non-well-defined self-map of" );
        fi;
    else
        Print( " endo\"morphism\" of" );
    fi;
    
    Print( " rings>" );
    
end );

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingSelfMap and IsMonomorphism ],
        
  function( o )
    
    Print( "<A monic endomorphism of a ring>" );
    
end );    

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingSelfMap and IsEpimorphism ], 996,
        
  function( o )
    
    Print( "<An epic endomorphism a ring>" );
    
end );    

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingSelfMap and IsAutomorphism ], 999,
        
  function( o )
    
    Print( "<An automorphism of a ring>" );
    
end );    

##
InstallMethod( ViewObj,
        "for homalg ring maps",
        [ IsHomalgRingSelfMap and IsIdentityMorphism ], 1000,
        
  function( o )
    
    Print( "<The identity morphism of a ring>" );
    
end );    

##
InstallMethod( Display,
        "for homalg ring maps",
        [ IsHomalgRingMapRep ],
        
  function( o )
    
    ViewObj( Range( o ) );
    Print( "\n\  ^\n  |\n" );
    ViewObj( ImagesOfRingMap( o ) );
    Print( "\n  |\n  |\n" );
    ViewObj( Source( o ) );
    Print( "\n" );
    
end );

