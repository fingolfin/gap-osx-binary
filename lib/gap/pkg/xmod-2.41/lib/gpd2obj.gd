##############################################################################
##
#W  gpd2obj.gd                 GAP4 package `XMod'               Chris Wensley
##
##  version 2.41, 05/06/2015 
##
#Y  Copyright (C) 2001-2015, Murat Alp and Chris Wensley,  
#Y  School of Computer Science, Bangor University, U.K. 

#############################################################################
## 
#C  Is2dDomainWithObjects( <obj> )
##  
DeclareCategory( "Is2dDomainWithObjects", Is2dDomain and IsDomainWithObjects ); 

############################################################################# 
## 
#C  Is2dMagmaWithObjects( <m2d> ) . . . . category of 2d magmas with objects
#C  Is2dMagmaWithObjectsAndOnes( <m2d> ) . . . . . . . . . . . and with ones
#C  Is2dMagmaWithObjectsAndInverses( <m2d> ) . .  and some inverses
#C  Is2dGroupWithObjects( <m2d> )  . . . . . . . . . . . .  and all inverses
##
DeclareCategory( "Is2dMagmaWithObjects", Is2dDomainWithObjects and 
    IsMagmaWithObjects ); 
DeclareCategoryCollections( "Is2dMagmaWithObjects" ); 
DeclareCategory( "Is2dMagmaWithObjectsAndOne", Is2dMagmaWithObjects and 
    CategoryCollections( IsMultiplicativeElementWithObjectsAndOnes ) ); 
DeclareCategory( "Is2dMagmaWithObjectsAndInverses", 
    Is2dMagmaWithObjectsAndOne and CategoryCollections( 
        IsMultiplicativeElementWithObjectsAndInverses ) ); 
DeclareCategory( "Is2dGroupWithObjects", Is2dMagmaWithObjectsAndInverses and 
    CategoryCollections( IsAssociativeElement ) ); 

############################################################################# 
##  
#V  Family2dGroupWithObjects  . . . . . . . family for 2d-groups with objects
##  
BindGlobal( "Family2dGroupWithObjects", 
    NewFamily( "Family2dGroupWithObjects", Is2dGroupWithObjects, 
                CanEasilySortElements, CanEasilySortElements ) ); 

#############################################################################
##
#P  IsPreXModWithObjects( <PM> ) . . . . . . . . for a 2d-domain with objects 
#P  IsXModWithObjects( <PM> )
##
DeclareProperty( "IsPreXModWithObjects", IsPreXMod and Is2dDomainWithObjects );
DeclareProperty( "IsXModWithObjects", IsPreXModWithObjects ); 

#############################################################################
##
#R  IsPreXModWithObjectsObj( <obj> ) . . . . for objects, boundary and action 
##  
##  A pre-crossed module of groupoids is a morphism preserving an action
##
DeclareRepresentation( "IsPreXModWithObjectsObj", 
    Is2dDomainWithObjects and IsAttributeStoringRep, 
    [ "objects", "boundary", "action" ] );

#############################################################################
## 
#O  PreXModWithObjectsObj( <obs>, <bdy>, <act> )  . . for obs, bdy and action 
## 
##  ?? should require IsGroupoidHomomorphism, but at present 
##  ?? HomomorphismByUnion(NC) does not return such! 
##  
DeclareOperation( "PreXModWithObjectsObj",
    [ IsHomogeneousList, IsGeneralMappingWithObjects, 
      IsGeneralMappingWithObjects ] );

#############################################################################
##
#O  DiscreteNormalPreXModWithObjects( <gpd>, <gp> ) .. for groupoid and group
##  
DeclareOperation( "DiscreteNormalPreXModWithObjects",
    [ IsSinglePiece, IsGroup ] );

############################################################################## 
## 
#E  gpd2obj.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
## 
