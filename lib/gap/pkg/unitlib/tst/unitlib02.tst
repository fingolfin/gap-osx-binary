# unitlib, chapter 2

# [ "/Users/alexk/gap4r6p1/pkg/unitlib/doc/funct.xml", 59, 64 ]

gap> PcNormalizedUnitGroupSmallGroup(128,161);
<pc group of size 170141183460469231731687303715884105728 with 127 generators>


# [ "/Users/alexk/gap4r6p1/pkg/unitlib/doc/funct.xml", 87, 108 ]

gap> V:=PcNormalizedUnitGroup(GroupRing(GF(2),SmallGroup(8,3)));
<pc group of size 128 with 7 generators>
gap> V1:=PcNormalizedUnitGroupSmallGroup(8,3);                   
<pc group of size 128 with 7 generators>
gap> V1=V;     # two isomorphic groups but not identical objects
false
gap> IdGroup(V)=IdGroup(V1);
true
gap> IsomorphismGroups(V,V1);
[ f1, f2, f3, f4, f5, f6, f7 ] -> [ f1, f2, f3, f4, f5, f6, f7 ]
gap> KG:=UnderlyingGroupRing(V1);  # now the correct way
<algebra-with-one over GF(2), with 3 generators>
gap> V1=PcNormalizedUnitGroup(KG); # V1 is an attribute of KG
true
gap> K:=UnderlyingField(KG);
GF(2)
gap> G:=UnderlyingGroup(KG);     
<pc group of size 8 with 3 generators>


# [ "/Users/alexk/gap4r6p1/pkg/unitlib/doc/funct.xml", 115, 126 ]

gap> f:=Embedding(G,V1); 
[ f1, f2, f3 ] -> [ f2, f1, f3 ]
gap> g:=List(GeneratorsOfGroup(G), x -> x^f ); 
[ f2, f1, f3 ]
gap> G1:=Subgroup(V1,g);
Group([ f2, f1, f3 ])
gap> IdGroup(G1);
[ 8, 3 ]


# [ "/Users/alexk/gap4r6p1/pkg/unitlib/doc/funct.xml", 201, 217 ]

gap> SavePcNormalizedUnitGroup( SmallGroup( 256, 56092 ) );
true
gap> PcNormalizedUnitGroupSmallGroup( 256, 56092 );
WARNING : the library of V(KG) for groups of order 
256 is not available yet !!! 
You can use only groups from the unitlib/userdata directory 
in case if you already computed their descriptions 
(See the manual for SavePcNormalizedUnitGroup).
#I  Description of V(KG) for G=SmallGroup(256,
56092) accepted, started its generation...
<pc group of size 
57896044618658097711785492504343953926634992332820282019728792003956564819968
  with 255 generators>

