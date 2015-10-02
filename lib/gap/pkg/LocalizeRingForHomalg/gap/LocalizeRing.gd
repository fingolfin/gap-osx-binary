#############################################################################
##
##  LocalizeRing.gd                            LocalizeRingForHomalg package
##
##  Copyright 2009-2011, Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH-Aachen University
##
##  Declarations of procedures for localized rings.
##
#############################################################################

####################################
#
# attributes:
#
####################################

##  <#GAPDoc Label="GeneratorsOfMaximalLeftIdeal">
##  <ManSection>
##    <Attr Arg="R" Name="GeneratorsOfMaximalLeftIdeal"/>
##    <Returns>a &homalg; matrix</Returns>
##    <Description>
##      Returns the generators of the maximal ideal, at which R was created. The generators are given as a column over the associated global ring.
##   </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "GeneratorsOfMaximalLeftIdeal",
        IsHomalgRing );

##  <#GAPDoc Label="GeneratorsOfMaximalRightIdeal">
##  <ManSection>
##    <Attr Arg="R" Name="GeneratorsOfMaximalRightIdeal"/>
##    <Returns>a &homalg; matrix</Returns>
##    <Description>
##      Returns the generators of the maximal ideal, at which R was created. The generators are given as a row over the associated global ring.
##   </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "GeneratorsOfMaximalRightIdeal",
        IsHomalgRing );

####################################
#
# global functions and operations:
#
####################################

# constructor methods:

DeclareOperation( "LocalizeAt",
        [ IsHomalgRing, IsList ] );

DeclareOperation( "LocalizeAtZero",
        [ IsHomalgRing ] );

DeclareGlobalFunction( "HomalgLocalRingElement" );

DeclareOperation( "BlindlyCopyMatrixPropertiesToLocalMatrix",
        [ IsHomalgMatrix, IsHomalgMatrix ] );

DeclareOperation( "HomalgLocalMatrix",
        [ IsHomalgMatrix, IsRingElement, IsHomalgRing ] );

DeclareOperation( "HomalgLocalMatrix",
        [ IsHomalgMatrix, IsHomalgRing ] );

# basic operations:

DeclareOperation( "AssociatedComputationRing",
        [ IsHomalgRing ] );

DeclareOperation( "AssociatedComputationRing",
        [ IsHomalgRingElement ] );

DeclareOperation( "AssociatedComputationRing",
        [ IsHomalgMatrix ] );

DeclareOperation( "AssociatedGlobalRing",
        [ IsHomalgRing ] );

DeclareOperation( "AssociatedGlobalRing",
        [ IsHomalgRingElement ] );

DeclareOperation( "AssociatedGlobalRing",
        [ IsHomalgMatrix ] );

DeclareOperation( "Cancel",
        [ IsRingElement, IsRingElement ] );
