#############################################################################
##
##  HomalgMap.gd                Modules package              Mohamed Barakat
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Declaration stuff for homalg maps ( = module homomorphisms ).
##
#############################################################################

####################################
#
# categories:
#
####################################

# two new categories:

##  <#GAPDoc Label="IsHomalgMap">
##  <ManSection>
##    <Filt Type="Category" Arg="phi" Name="IsHomalgMap"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The &GAP; category of &homalg; maps. <P/>
##      (It is a subcategory of the &GAP; categories
##      <C>IsHomalgModuleOrMap</C> and <C>IsHomalgStaticMorphism</C>.)
##    <Listing Type="Code"><![CDATA[
DeclareCategory( "IsHomalgMap",
        IsHomalgModuleOrMap and
        IsHomalgStaticMorphism );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

##  <#GAPDoc Label="IsHomalgSelfMap">
##  <ManSection>
##    <Filt Type="Category" Arg="phi" Name="IsHomalgSelfMap"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      The &GAP; category of &homalg; self-maps. <P/>
##      (It is a subcategory of the &GAP; categories
##       <C>IsHomalgMap</C> and <C>IsHomalgEndomorphism</C>.)
##    <Listing Type="Code"><![CDATA[
DeclareCategory( "IsHomalgSelfMap",
        IsHomalgMap and
        IsHomalgEndomorphism );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

####################################
#
# global functions and operations:
#
####################################

# constructors:

DeclareGlobalFunction( "HomalgMap" );

DeclareGlobalFunction( "HomalgZeroMap" );

DeclareGlobalFunction( "HomalgIdentityMap" );

DeclareOperation( "OnAFreeSource",
        [ IsHomalgMap ] );

# basic operations:

DeclareOperation( "MatrixOfMap",
        [ IsHomalgMap, IsInt, IsInt ] );

DeclareOperation( "MatrixOfMap",
        [ IsHomalgMap, IsPosInt ] );

DeclareOperation( "MatrixOfMap",
        [ IsHomalgMap ] );

DeclareOperation( "UnionOfRelations",
        [ IsHomalgMap ] );

DeclareOperation( "SyzygiesGenerators",
        [ IsHomalgMap ] );

DeclareOperation( "ReducedSyzygiesGenerators",
        [ IsHomalgMap ] );

DeclareOperation( "Preimage",
        [ IsHomalgMatrix, IsHomalgMap ] );

DeclareOperation( "SuccessivePreimages",
        [ IsHomalgMatrix, IsHomalgSelfMap ] );
