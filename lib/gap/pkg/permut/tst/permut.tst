############################################################################
##
#W  permut.tst                GAP tests                    ABB&ECL&RER
##
##
#Y  Copyright (C)  2014,  Adolfo Ballester-Bolinches, Enric Cosme-Ll\'opez,
##                        and Ramon Esteban-Romero
##
##  This  file  tests  some functions that  deal with permutability
##
gap> START_TEST("permut.tst");

gap> LoadPackage("permut", false);;
#I Package ``permut'' has been loaded.
gap> sym4:=SymmetricGroup(4);
Sym( [ 1 .. 4 ] )
gap> ArePermutableSubgroups(sym4, Subgroup(sym4, [(1,2)(3,4)]), Subgroup(sym4, [(1,2,3)]));
false
gap> Set(AllSubnormalSubgroups(sym4));
[ Group(()), Sym( [ 1 .. 4 ] ), Group([ (2,4,3), (1,4)(2,3), (1,3)(2,4) ]), 
  Group([ (1,2)(3,4) ]), Group([ (1,4)(2,3), (1,3)(2,4) ]), Group([ (1,3)
  (2,4) ]), Group([ (1,4)(2,3) ]) ]
gap> IsTGroup(SymmetricGroup(3));
true
gap> IsPTGroup(ExtraspecialGroup(125, 5));
false
gap> IsPTGroup(ExtraspecialGroup(125, 25));
true
gap> IdsOfAllSmallGroups(Size, 48, IsPTGroup, true) =
> [ [ 48, 1 ], [ 48, 2 ], [ 48, 4 ], [ 48, 5 ], [ 48, 9 ], [ 48, 10 ], 
>   [ 48, 11 ], [ 48, 20 ], [ 48, 23 ], [ 48, 24 ], [ 48, 34 ], [ 48, 35 ], 
>   [ 48, 40 ], [ 48, 42 ], [ 48, 44 ], [ 48, 46 ], [ 48, 51 ], [ 48, 52 ] ];
true
gap> IsSCGroup(Group((3,7,5)(4,8,6), (1,2,6)(3,4,8), (9,10,11,12,13)));
true
gap> ArePermutableSubgroups(sym4, AlternatingGroup(4), Subgroup(sym4, [(1,2,3,4), (1,3)]));
true
gap> OnePairShowingNotTotallyPermutableSubgroups(sym4, AlternatingGroup(4), Subgroup(sym4, [(1,2,3,4), (1,3)]));
[ Group([ (2,4,3) ]), Group([ (1,2)(3,4) ]) ]
gap> Size(Permutizer(sym4, Subgroup(sym4, [(1,2,3)])));
6
gap> STOP_TEST( "permut.tst", 7000000 );
permut.tst

##############################################################################
##
#E
