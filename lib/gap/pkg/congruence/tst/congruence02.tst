# congruence, chapter 2

# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 65, 88 ]

gap> G_8:=PrincipalCongruenceSubgroup(8);
<principal congruence subgroup of level 8 in SL_2(Z)>
gap> IsGroup(G_8);
true
gap> IsMatrixGroup(G_8);
true
gap> DimensionOfMatrixGroup(G_8);
2
gap> MultiplicativeNeutralElement(G_8);
[ [ 1, 0 ], [ 0, 1 ] ]
gap> One(G);
[ [ 1, 0 ], [ 0, 1 ] ]
gap> [[1,2],[3,4]] in G_8;
false
gap> [[1,8],[8,65]] in G_8;
true
gap> SL_2:=SL(2,Integers);
SL(2,Integers)
gap> IsSubgroup(SL_2,G_8);
true


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 122, 127 ]

gap> G0_4:=CongruenceSubgroupGamma0(4);
<congruence subgroup CongruenceSubgroupGamma_0(4) in SL_2(Z)>


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 161, 166 ]

gap> GU0_2:=CongruenceSubgroupGammaUpper0(2);
<congruence subgroup CongruenceSubgroupGamma^0(2) in SL_2(Z)>


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 200, 205 ]

gap> G1_6:=CongruenceSubgroupGamma1(6);
<congruence subgroup CongruenceSubgroupGamma_1(6) in SL_2(Z)>


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 239, 244 ]

gap> GU1_4:=CongruenceSubgroupGammaUpper1(4);
<congruence subgroup CongruenceSubgroupGamma^1(4) in SL_2(Z)>


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 273, 280 ]

gap> I:=IntersectionOfCongruenceSubgroups(G0_4,GU1_4);
<principal congruence subgroup of level 4 in SL_2(Z)>
gap> J:=IntersectionOfCongruenceSubgroups(G0_4,G1_6);
<intersection of congruence subgroups of resulting level 12 in SL_2(Z)>


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 307, 316 ]

gap> IsPrincipalCongruenceSubgroup(G_8);
true
gap> IsPrincipalCongruenceSubgroup(G0_4);
false
gap> IsPrincipalCongruenceSubgroup(I);
true


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 380, 387 ]

gap> IsIntersectionOfCongruenceSubgroups(I);
false
gap> IsIntersectionOfCongruenceSubgroups(J);
true


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 407, 418 ]

gap> LevelOfCongruenceSubgroup(G_8);
8
gap> LevelOfCongruenceSubgroup(G1_6);
6
gap> LevelOfCongruenceSubgroup(I);
4
gap> LevelOfCongruenceSubgroup(J);
12


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 429, 440 ]

gap> IndexInSL2Z(G_8);
384
gap> G_2:=PrincipalCongruenceSubgroup(2);
<principal congruence subgroup of level 2 in SL_2(Z)>
gap> IndexInSL2Z(G_2);
12
gap> IndexInSL2Z(GU1_4);
12


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 456, 470 ]

gap> DefiningCongruenceSubgroups(J);
[ <congruence subgroup CongruenceSubgroupGamma_0(4) in SL_2(Z)>,
  <congruence subgroup CongruenceSubgroupGamma_1(6) in SL_2(Z)> ]
gap> P:=PrincipalCongruenceSubgroup(6);
<principal congruence subgroup of level 6 in SL_2(Z)>
gap> Q:=PrincipalCongruenceSubgroup(10); 
<principal congruence subgroup of level 10 in SL_2(Z)>
gap> G:=IntersectionOfCongruenceSubgroups(Q,P);  
<principal congruence subgroup of level 30 in SL_2(Z)>
gap> DefiningCongruenceSubgroups(G);
[ <principal congruence subgroup of level 30 in SL_2(Z)> ] 


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 497, 504 ]

gap> Random(G_2) in G_2;
true
gap> Random(G_8,2) in G_8;
true


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 516, 523 ]

gap> \in([ [ 21, 10 ], [ 2, 1 ] ],G_2);
true
gap> \in([ [ 21, 10 ], [ 2, 1 ] ],G_8);
false


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 545, 550 ]

gap> CanEasilyCompareCongruenceSubgroups(G_8,I);
false


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 564, 582 ]

gap> IsSubset(G_2,G_8);
true
gap> IsSubset(G_8,G_2);
false
gap> f:=[PrincipalCongruenceSubgroup,CongruenceSubgroupGamma1,CongruenceSubgroupGammaUpper1,CongruenceSubgroupGamma0,CongruenceSubgroupGammaUpper0];;
gap> g1:=List(f, t -> t(2));;
gap> g2:=List(f, t -> t(4));;
gap> for g in g2 do
> Print( List( g1, x -> IsSubgroup(x,g) ), "\n");
> od;
[ true, true, true, true, true ]
[ false, true, false, true, false ]
[ false, false, true, false, true ]
[ false, false, false, true, false ]
[ false, false, false, false, true ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/cong.xml", 595, 600 ]

gap> Index(G_2,G_8);
32

