^^Jgap> LoadPackage("format");;^^J
^^Jgap> G := SymmetricGroup(4);^^JSym( [ 1 .. 4 ] )^^Jgap> SystemNormalizer(G);  CarterSubgroup(G);^^JGroup([ (3,4) ])^^JGroup([ (3,4), (1,3)(2,4), (1,2)(3,4) ])^^J
^^Jgap> sup := Formation("Supersolvable");^^Jformation of Supersolvable groups^^Jgap> KnownAttributesOfObject(sup); KnownPropertiesOfObject(sup);^^J[ "NameOfFormation", "ScreenOfFormation" ]^^J[ "IsIntegrated" ]^^J
^^Jgap> ScreenOfFormation(sup);^^J<Operation "AbelianExponentResidual">^^Jgap> ScreenOfFormation(sup)(G,2); ScreenOfFormation(sup)(G,3);^^JGroup([ (3,4), (2,4,3), (1,4)(2,3), (1,3)(2,4) ])^^JGroup([ (2,4,3), (1,4)(2,3), (1,3)(2,4) ])^^J
^^Jgap> ResidualWrtFormation(G, sup);^^JGroup([ (1,2)(3,4), (1,4)(2,3) ])^^Jgap> KnownAttributesOfObject(sup);^^J[ "NameOfFormation", "ScreenOfFormation", "ResidualFunctionOfFormation" ]^^J
^^Jgap> FNormalizerWrtFormation(G, sup);^^JGroup([ (3,4), (2,4,3) ])^^Jgap> CoveringSubgroupWrtFormation(G, sup);^^JGroup([ (3,4), (2,4,3) ])^^Jgap> KnownAttributesOfObject(G);^^J[ "Size", "OneImmutable", "SmallestMovedPoint", "NrMovedPoints",^^J  "MovedPoints", "GeneratorsOfMagmaWithInverses", "TrivialSubmagmaWithOne",^^J  "MultiplicativeNeutralElement", "DerivedSubgroup", "IsomorphismPcGroup",^^J  "IsomorphismSpecialPcGroup", "PcgsElementaryAbelianSeries", "Pcgs",^^J  "GeneralizedPcgs", "StabChainOptions", "ComputedResidualWrtFormations",^^J  "ComputedAbelianExponentResiduals", "ComputedFNormalizerWrtFormations",^^J  "ComputedCoveringSubgroup1s", "ComputedCoveringSubgroup2s",^^J  "SystemNormalizer", "CarterSubgroup" ]^^J
^^Jgap> ComputedResidualWrtFormations(G);^^J[ formation of Supersolvable groups , Group([ (1,2)(3,4), (1,4)(2,3) ]) ]^^Jgap> ComputedFNormalizerWrtFormations(G);^^J[ formation of Nilpotent groups , Group([ (3,4) ]),^^J  formation of Supersolvable groups , Group([ (3,4), (2,4,3) ]) ]^^Jgap> ComputedCoveringSubgroup2s(G);^^J[  ]^^Jgap> ComputedCoveringSubgroup1s(G);^^J[ formation of Nilpotent groups , Group([ (3,4), (1,3)(2,4), (1,2)(3,4) ]),^^J  formation of Supersolvable groups , Group([ (3,4), (2,4,3) ]) ]^^J
^^Jgap> s4 := SmallGroup(IdGroup(G));^^J<pc group of size 24 with 4 generators>^^J
^^Jgap> SystemNormalizer(s4); CarterSubgroup(s4);^^JGroup([ f1 ])^^JGroup([ f1, f4, f3*f4 ])^^J
^^Jgap> sl := SpecialLinearGroup(2,3);^^JSL(2,3)^^Jgap> h := SmallGroup(IdGroup(sl));^^J<pc group of size 24 with 4 generators>^^J
^^Jgap> CarterSubgroup(sl); Size(last);^^J<group of 2x2 matrices in characteristic 3>^^J6^^Jgap> SystemNormalizer(h); CarterSubgroup(h);^^JGroup([ f1, f4 ])^^JGroup([ f1, f4 ])^^J
^^Jgap> ab := Formation("Abelian");^^Jformation of Abelian groups^^Jgap> KnownPropertiesOfObject(ab); KnownAttributesOfObject(ab);^^J[  ]^^J[ "NameOfFormation", "ResidualFunctionOfFormation" ]^^Jgap> nil2 := Formation("PNilpotent",2);^^Jformation of 2Nilpotent groups^^Jgap> KnownPropertiesOfObject(nil2); KnownAttributesOfObject(nil2);^^J[ "IsIntegrated" ]^^J[ "NameOfFormation", "ScreenOfFormation", "ResidualFunctionOfFormation" ]^^J
^^Jgap> form := ProductOfFormations(ab, nil2);^^Jformation of (AbelianBy2Nilpotent) groups^^Jgap> KnownAttributesOfObject(form);^^J[ "NameOfFormation", "ResidualFunctionOfFormation" ]^^J
^^Jgap> form2 := ProductOfFormations(nil2, ab);^^Jformation of (2NilpotentByAbelian) groups^^Jgap> KnownAttributesOfObject(form2);^^J[ "NameOfFormation", "ScreenOfFormation", "ResidualFunctionOfFormation" ]^^J
^^Jgap> ResidualWrtFormation(G, form);  ResidualWrtFormation(G, form2);^^JGroup(())^^JGroup([ (1,3)(2,4), (1,2)(3,4) ])^^Jgap> KnownPropertiesOfObject(form2);^^J[  ]^^J
^^Jgap> Integrated(form2);^^Jformation of (2NilpotentByAbelian)Int groups^^J
^^Jgap> FNormalizerWrtFormation(G, form2); CoveringSubgroupWrtFormation(G, form2);^^JGroup([ (3,4), (2,4,3) ])^^JGroup([ (3,4), (2,4,3) ])^^Jgap> KnownPropertiesOfObject(form2);^^J[  ]^^Jgap> ComputedCoveringSubgroup1s(G);^^J[ formation of (2NilpotentByAbelian)Int groups , Group([ (3,4), (2,4,3) ]),^^J  formation of Nilpotent groups , Group([ (3,4), (1,3)(2,4), (1,2)(3,4) ]),^^J  formation of Supersolvable groups , Group([ (3,4), (2,4,3) ]) ]^^Jgap> ComputedResidualWrtFormations(G);^^J[ formation of (2NilpotentByAbelian) groups ,^^J  Group([ (1,4)(2,3), (1,2)(3,4) ]),^^J  formation of (AbelianBy2Nilpotent) groups , Group(()),^^J  formation of 2Nilpotent groups , Group([ (1,2)(3,4), (1,3)(2,4) ]),^^J  formation of Abelian groups , Group([ (2,4,3), (1,4)(2,3), (1,3)(2,4) ]),^^J  formation of Supersolvable groups , Group([ (1,2)(3,4), (1,4)(2,3) ]) ]^^J
^^Jgap> pig := Formation("PiGroups", [2,5]);^^Jformation of (2,5)-Group groups with support [ 2, 5 ]^^Jgap> form := Intersection(pig, nil2);^^Jformation of ((2,5)-GroupAnd2Nilpotent) groups with support [ 2, 5 ]^^Jgap> KnownAttributesOfObject(form);^^J[ "NameOfFormation", "ScreenOfFormation", "SupportOfFormation",^^J  "ResidualFunctionOfFormation" ]^^J
^^Jgap> form3 := ChangedSupport(nil2, [2,5]);^^Jformation of Changed2Nilpotent[ 2, 5 ] groups^^Jgap> SupportOfFormation(form3);^^J[ 2, 5 ]^^Jgap> form = form3;^^Jfalse^^J
^^Jgap> ProductOfFormations(Intersection(pig, nil2), sup);^^Jformation of (((2,5)-GroupAnd2Nilpotent)BySupersolvable) groups^^Jgap> Intersection(pig, ProductOfFormations(nil2, sup));^^Jformation of ((2,5)-GroupAnd(2NilpotentBySupersolvable)) groups with support^^J[ 2, 5 ]^^J
^^Jgap> preform := rec( name := "MyOwn",^^J>  fScreen := function( G, p)^^J>  return DerivedSubgroup( G );^^J>  end);^^Jrec( fScreen := function( G, p ) ... end, name := "MyOwn" )^^Jgap> form := Formation(preform);^^Jformation of MyOwn groups^^Jgap> KnownAttributesOfObject(form); KnownPropertiesOfObject(form);^^J[ "NameOfFormation", "ScreenOfFormation" ]^^J[  ]^^J
^^Jgap> SetIsIntegrated(form, true);^^Jgap> ResidualWrtFormation(G, form);^^JGroup([ (1,4)(2,3), (1,2)(3,4) ])^^Jgap> FNormalizerWrtFormation(G, form);^^JGroup([ (3,4), (2,4,3) ])^^Jgap> CoveringSubgroup1(G, form);^^JGroup([ (3,4), (2,4,3) ])^^J