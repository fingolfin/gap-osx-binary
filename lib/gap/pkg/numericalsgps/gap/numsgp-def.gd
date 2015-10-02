#############################################################################
##
#W  numsgp-def.gd           Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro A. Garcia-Sanchez <pedro@ugr.es>
#W                          Jose Morais <josejoao@fc.up.pt>
##
##
#H  @(#)$Id: numsgp-def.gd $
##
#Y  Copyright 2005 by Manuel Delgado,
#Y  Pedro Garcia-Sanchez and Jose Joao Morais
#Y  We adopt the copyright regulations of GAP as detailed in the
#Y  copyright notice in the GAP manual.
##
#############################################################################


DeclareInfoClass("InfoNumSgps");



#############################################################################
##
#R  IsNumericalSemigroupRep
##
##  The representation of a numerical semigroup.
##
#############################################################################
DeclareRepresentation( "IsNumericalSemigroupRep", IsAttributeStoringRep, []);


#############################################################################
##
#C  IsNumericalSemigroup
##
##  The category of numerical semigroups.
##
#############################################################################
DeclareCategory( "IsNumericalSemigroup", IsAdditiveMagma and IsNumericalSemigroupRep);


# Elements of numerical semigroups are integers, so numerical semigroups are
# collections of integers.
BindGlobal( "NumericalSemigroupsType",
        NewType( CollectionsFamily(CyclotomicsFamily),
                 IsNumericalSemigroup));


#############################################################################
##
#F  NumericalSemigroupByGenerators(arg)
##
##  Returns the numerical semigroup generated by arg.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByGenerators" );
#A
DeclareAttribute( "GeneratorsNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupByGenerators", HasGeneratorsNS);


#############################################################################
##
#F  NumericalSemigroupByMinimalGenerators(arg)
##
##  Returns the numerical semigroup minimally generated by arg.
##  If the generators given are not minimal, the minimal ones
##  are computed and used.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByMinimalGenerators" );
#A
DeclareAttribute( "MinimalGeneratorsNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupByMinimalGenerators", HasMinimalGeneratorsNS);



#############################################################################
##
#F  NumericalSemigroupByMinimalGeneratorsNC(arg)
##
##  Returns the numerical semigroup minimally generated by arg.
##  No test is made about args' minimality.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByMinimalGeneratorsNC" );



#############################################################################
##
#F  ModularNumericalSemigroup(a,b)
##
##  Returns the modular numerical semigroup satisfying ax mod b <= x
##
#############################################################################
DeclareGlobalFunction( "ModularNumericalSemigroup" );
#A
DeclareAttribute( "ModularConditionNS", IsNumericalSemigroup);


#############################################################################
##
#F  ProportionallyModularNumericalSemigroup(a,b,c)
##
##  Returns the proportionally modular numerical semigroup
##  satisfying ax mod b <= cx
##
#############################################################################
DeclareGlobalFunction( "ProportionallyModularNumericalSemigroup" );
#A
DeclareAttribute( "ProportionallyModularConditionNS", IsNumericalSemigroup);



#############################################################################
##
#F  NumericalSemigroupByInterval(arg)
##
##  Returns the numerical semigroup
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByInterval" );
#A
DeclareAttribute( "ClosedIntervalNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupByInterval",HasClosedIntervalNS);



#############################################################################
##
#F  NumericalSemigroupByOpenInterval(arg)
##
##  Returns the numerical semigroup
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByOpenInterval" );
#A
DeclareAttribute( "OpenIntervalNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupByOpenInterval",HasOpenIntervalNS);



#############################################################################
##
#F  NumericalSemigroupBySubAdditiveFunction(L)
##
##  Returns the numerical semigroup specified by the subadditive
##  function L.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupBySubAdditiveFunction" );
#A
DeclareAttribute( "SubAdditiveFunctionNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupBySubAdditiveFunction",HasSubAdditiveFunctionNS);



#############################################################################
##
#F  NumericalSemigroupByAperyList(L)
##
##  Returns the numerical semigroup specified by the Apery list L.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByAperyList" );
#A
DeclareAttribute( "AperyListNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupByAperyList",HasAperyListNS);



#############################################################################
##
#F  NumericalSemigroupBySmallElements(L)
##
##  Returns the numerical semigroup specified by L,
##  which must be the list of elements of a numerical semigroup,
##  not greater than the Frobenius number + 1.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupBySmallElements" );
#A
DeclareAttribute( "SmallElementsNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupBySmallElements",HasSmallElementsNS);


#############################################################################
##
#F  NumericalSemigroupBySmallElementsNC(L)
##
## NC version of NumericalSemigroupBySmallElements
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupBySmallElementsNC" );


#############################################################################
##
#F  NumericalSemigroupByGaps(L)
##
##  Returns the numerical semigroup specified by L,
##  which must be the list of gaps of a numerical semigroup.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByGaps" );
#A
DeclareAttribute( "GapsNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupByGaps",HasGapsNS);


#############################################################################
##
#F  NumericalSemigroupByFundamentalGaps(L)
##
##  Returns the numerical semigroup specified by L,
##  which must be the list of fundamental gaps of a numerical semigroup.
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroupByFundamentalGaps" );
#A
DeclareAttribute( "FundamentalGapsNS", IsNumericalSemigroup);
DeclareSynonymAttr( "IsNumericalSemigroupByFundamentalGaps",HasFundamentalGapsNS);

        
#############################################################################
##
#F  NumericalSemigroup(arg)
##
##  This function's first argument may be one of:
##  "generators", "minimalgenerators", "modular",
##  "propmodular", "elements", "gaps",
##  "fundamentalgaps", "subadditive" or "apery" according to
##  how the semigroup is being defined.
##  The following arguments must conform to the arguments of
##  the corresponding function defined above.
##  By default, the option "generators" is used, so,
##  gap> NumericalSemigroup(3,7);
##  <Numerical semigroup with 2 generators>
##
##
#############################################################################
DeclareGlobalFunction( "NumericalSemigroup" );


#############################################################################
##
#P  IsProportionallyModularNumericalSemigroup(S)
##
##  Tests if a numerical semigroup is proportionally modular.
##
#############################################################################
DeclareProperty( "IsProportionallyModularNumericalSemigroup", IsNumericalSemigroup);



#############################################################################
##
#P  IsModularNumericalSemigroup(S)
##
##  Tests if a numerical semigroup is modular.
##
#############################################################################
DeclareProperty( "IsModularNumericalSemigroup", IsNumericalSemigroup);


#############################################################################
