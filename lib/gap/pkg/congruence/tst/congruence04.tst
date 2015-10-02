# congruence, chapter 4

# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/gens.xml", 30, 47 ]

gap> FareySymbol(PrincipalCongruenceSubgroup(8));
[ infinity, 0, 1/4, 1/3, 3/8, 2/5, 1/2, 3/5, 5/8, 2/3, 3/4, 1, 5/4, 4/3, 
  11/8, 7/5, 3/2, 8/5, 13/8, 5/3, 7/4, 2, 9/4, 7/3, 19/8, 12/5, 5/2, 13/5, 
  21/8, 8/3, 11/4, 3, 13/4, 10/3, 27/8, 17/5, 7/2, 18/5, 29/8, 11/3, 15/4, 4, 
  17/4, 13/3, 9/2, 14/3, 19/4, 5, 21/4, 16/3, 11/2, 17/3, 23/4, 6, 25/4, 
  19/3, 13/2, 20/3, 27/4, 7, 29/4, 22/3, 15/2, 23/3, 31/4, 8, infinity ]
[ 1, 17, 10, 26, 32, 18, 19, 27, 30, 5, 2, 2, 13, 28, 26, 20, 21, 29, 27, 7, 
  3, 3, 16, 31, 28, 22, 23, 33, 29, 9, 4, 4, 5, 30, 31, 24, 25, 32, 33, 12, 
  6, 6, 7, 19, 18, 15, 8, 8, 9, 21, 20, 10, 11, 11, 12, 23, 22, 13, 14, 14, 
  15, 25, 24, 16, 17, 1 ]
gap> FareySymbol(CongruenceSubgroupGamma0(20));
[ infinity, 0, 1/5, 1/4, 2/7, 3/10, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 1, 
  infinity ]
[ 1, 3, 4, 6, 7, 7, 5, 2, 2, 3, 6, 4, 5, 1 ]  


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/gens.xml", 128, 140 ]

gap> H:=CongruenceSubgroupGamma0(5); 
<congruence subgroup CongruenceSubgroupGamma_0(5) in SL_2(Z)>
gap> fs:=FareySymbol(H);
[ infinity, 0, 1/2, 1, infinity ]
[ 1, "even", "even", 1 ]
gap> gfs:=GeneralizedFareySequence(fs);
[ infinity, 0, 1/2, 1, infinity ]
gap> MatrixByEvenInterval(gfs,2);      
[ [ 2, -1 ], [ 5, -2 ] ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/gens.xml", 152, 160 ]

gap> fs_oo:=FareySymbolByData([infinity,0,infinity],["odd","odd"]);;
gap> gfs_oo:=GeneralizedFareySequence(fs_oo);
[ infinity, 0, infinity ]
gap> MatrixByOddInterval(gfs_oo,1);
[ [ -1, -1 ], [ 1, 0 ] ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/gens.xml", 172, 179 ]

gap> fs_free:=FareySymbolByData([infinity,0,1,2,infinity],[1,2,2,1]);;
gap> gfs_free:=GeneralizedFareySequence(fs_free);;
gap> MatrixByFreePairOfIntervals(gfs_free,2,3);                                                        
[ [ 3, -2 ], [ 2, -1 ] ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/gens.xml", 191, 203 ]

gap> fs_eo:=FareySymbolByData([infinity,0,infinity],["even","odd"]);;
gap> GeneratorsByFareySymbol(last);                                  
[ [ [ 0, -1 ], [ 1, 0 ] ], [ [ 0, -1 ], [ 1, -1 ] ] ]
gap> GeneratorsByFareySymbol(fs); 
[ [ [ 1, 1 ], [ 0, 1 ] ], [ [ 2, -1 ], [ 5, -2 ] ], [ [ 3, -2 ], [ 5, -3 ] ] ]
gap> GeneratorsByFareySymbol(fs_oo);
[ [ [ -1, -1 ], [ 1, 0 ] ], [ [ 0, -1 ], [ 1, -1 ] ] ]
gap> GeneratorsByFareySymbol(fs_free);                                                        
[ [ [ 1, 2 ], [ 0, 1 ] ], [ [ 3, -2 ], [ 2, -1 ] ] ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/gens.xml", 215, 241 ]

gap> G:=PrincipalCongruenceSubgroup(2);
<principal congruence subgroup of level 2 in SL_2(Z)>
gap> FareySymbol(G);
[ infinity, 0, 1, 2, infinity ]
[ 2, 1, 1, 2 ]
gap> GeneratorsOfGroup(G);
#I  Using the Congruence package for GeneratorsOfGroup ...
[ [ [ 1, 2 ], [ 0, 1 ] ], [ [ 3, -2 ], [ 2, -1 ] ] ]
gap> H:=CongruenceSubgroupGamma0(5);        
<congruence subgroup CongruenceSubgroupGamma_0(5) in SL_2(Z)>
gap> GeneratorsOfGroup(H);
#I  Using the Congruence package for GeneratorsOfGroup ...
[ [ [ 1, 1 ], [ 0, 1 ] ], [ [ 2, -1 ], [ 5, -2 ] ], [ [ 3, -2 ], [ 5, -3 ] ] ]
gap> I:=IntersectionOfCongruenceSubgroups(PrincipalCongruenceSubgroup(2),CongruenceSubgroupGamma0(3));
<intersection of congruence subgroups of resulting level 6 in SL_2(Z)>
gap> FareySymbol(I);
[ infinity, 0, 1/3, 1/2, 2/3, 1, 4/3, 3/2, 5/3, 2, infinity ]
[ 1, 5, 4, 3, 2, 2, 3, 4, 5, 1 ]
gap> GeneratorsOfGroup(I);                                                          
#I  Using the Congruence package for GeneratorsOfGroup ...
[ [ [ 1, 2 ], [ 0, 1 ] ], [ [ 11, -2 ], [ 6, -1 ] ], 
  [ [ 19, -8 ], [ 12, -5 ] ], [ [ 17, -10 ], [ 12, -7 ] ], 
  [ [ 7, -6 ], [ 6, -5 ] ] ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/gens.xml", 262, 271 ]

gap> IndexInPSL2ZByFareySymbol(fs);
6
gap> IndexInPSL2ZByFareySymbol(fs_oo);
2
gap> IndexInPSL2ZByFareySymbol(fs_free);
6

