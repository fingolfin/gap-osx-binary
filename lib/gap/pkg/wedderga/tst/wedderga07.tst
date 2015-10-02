# wedderga, chapter 7

# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 22, 41 ]

gap> G:=SmallGroup(48,15);
<pc group of size 48 with 5 generators>
gap> R:=GroupRing(Rationals,G);       
<algebra-with-one over Rationals, with 5 generators>
gap> WedderburnDecompositionInfo(R);
[ [ 1, Rationals ], [ 1, Rationals ], [ 1, Rationals ], [ 1, Rationals ], 
  [ 2, Rationals ], [ 1, Rationals, 3, [ 2, 2, 0 ] ], [ 2, CF(3) ], 
  [ 1, Rationals, 6, [ 2, 5, 0 ] ], [ 1, NF(8,[ 1, 7 ]), 8, [ 2, 7, 0 ] ], 
  [ 1, Rationals, 12, [ [ 2, 5, 9 ], [ 2, 7, 0 ] ], [ [ 9 ] ] ] ]
gap> WedderburnDecompositionWithDivAlgParts(R);
[ [ 1, Rationals ], [ 1, Rationals ], [ 1, Rationals ], [ 1, Rationals ], 
  [ 2, Rationals ], [ 2, Rationals ], [ 2, CF(3) ], [ 2, Rationals ], 
  [ 2, NF(8,[ 1, 7 ]) ], 
  [ 2, 
      rec( Center := Rationals, DivAlg := true, 
          LocalIndices := [ [ 2, 2 ], [ 3, 2 ] ], SchurIndex := 2 ) ] ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 59, 83 ]

gap> G:=SmallGroup(240,89);
<permutation group of size 240 with 2 generators>
gap> R:=GroupRing(Rationals,G);
<algebra-with-one over Rationals, with 2 generators>
gap> W:=WedderburnDecompositionInfo(R);
Wedderga: Warning!!! 
Some of the Wedderburn components displayed are FRACTIONAL MATRIX ALGEBRAS!!!

[ [ 1, Rationals ], [ 1, Rationals ], [ 1, Rationals, 10, [ 4, 3, 5 ] ], 
  [ 4, Rationals ], [ 4, Rationals ], [ 5, Rationals ], [ 5, Rationals ], 
  [ 6, Rationals ], [ 1, NF(12,[ 1, 11 ]), 10, [ 4, 3, 5 ] ], 
  [ 3/2, NF(8,[ 1, 7 ]), 10, [ 4, 3, 5 ] ] ]
gap> CyclotomicAlgebraWithDivAlgPart(W[3]);
[ 2, rec( Center := Rationals, DivAlg := true, 
      LocalIndices := [ [ 5, 2 ], [ infinity, 2 ] ], SchurIndex := 2 ) ]
gap> CyclotomicAlgebraWithDivAlgPart(W[9]);
[ 2, rec( Center := NF(12,[ 1, 11 ]), DivAlg := true, 
      LocalIndices := [ [ infinity, 2 ] ], SchurIndex := 2 ) ]
gap> CyclotomicAlgebraWithDivAlgPart(W[10]);
[ 3, rec( Center := NF(8,[ 1, 7 ]), DivAlg := true, 
      LocalIndices := [ [ infinity, 2 ] ], SchurIndex := 2 ) ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 115, 137 ]

gap> G:=SmallGroup(63,1);  
<pc group of size 63 with 3 generators>
gap> R:=GroupRing(Rationals,G);
<algebra-with-one over Rationals, with 3 generators>
gap> W:=WedderburnDecompositionInfo(R);
[ [ 1, Rationals ], [ 1, CF(3) ], [ 1, CF(9) ], 
  [ 1, NF(7,[ 1, 2, 4 ]), 7, [ 3, 2, 0 ] ], 
  [ 1, NF(21,[ 1, 4, 16 ]), 21, [ 3, 4, 7 ] ] ]
gap> SchurIndex(W[5]);
3

gap> G:=SmallGroup(40,1);              
<pc group of size 40 with 4 generators>
gap> Size(Irr(G));                          
16
gap> SchurIndexByCharacter(GaussianRationals,G,16);
2
gap> SchurIndexByCharacter(CF(5),G,16);         
1


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 159, 166 ]

gap> PPartOfN(2275,5);
25
gap> PDashPartOfN(2275,5);
91


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 179, 186 ]

gap> PSplitSubextension(Rationals,60,5);  
GaussianRationals
gap> PSplitSubextension(NF(5,[1,4]),70,2);
NF(35,[ 1, 4, 9, 11, 16, 29 ])


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 202, 222 ]

gap> F:=CF(12);
CF(12)
gap> K:=NF(120,[1,49]) # Note that F is a subfield of K, with index 4.
> ; # Then we can find e, f, and g for the extension K/F at the prime 5. 
NF(120,[ 1, 49 ])
gap> RamificationIndexAtP(F,120,5); RamificationIndexAtP(K,120,5); last2/last;
4
2
2
gap> ResidueDegreeAtP(F,120,5); ResidueDegreeAtP(K,120,5); last2/last;
1
1
1
gap> SplittingDegreeAtP(F,120,5); SplittingDegreeAtP(K,120,5); last2/last;
2
1
2


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 243, 250 ]

gap> A:=[1,Rationals,6,[2,5,3]];
[ 1, Rationals, 6, [ 2, 5, 3 ] ]
gap> LocalIndicesOfCyclicCyclotomicAlgebra(A);
[ [ 3, 2 ], [ infinity, 2 ] ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 278, 293 ]

gap> A:=[1,CF(4),20,[4,13,15]];
[ 1, GaussianRationals, 20, [ 4, 13, 15 ] ]
gap> LocalIndexAtOddP(A,5);
4
gap> A:=[1,NF(8,[1,7]),8,[2,7,4]];
[ 1, NF(8,[ 1, 7 ]), 8, [ 2, 7, 4 ] ]
gap> LocalIndexAtInfty(A);
2
gap> A:=[1,CF(7),28,[2,15,14]];                        
[ 1, CF(7), 28, [ 2, 15, 14 ] ]
gap> LocalIndexAtTwo(A);     
2


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 316, 329 ]

gap> G:=SmallGroup(480,600);
<pc group of size 480 with 7 generators>
gap> W:=WedderburnDecompositionInfo(GroupRing(Rationals,G));;
gap> Size(W); 
27
gap> W[27]; 
[ 1, NF(5,[ 1, 4 ]), 60, [ [ 2, 11, 0 ], [ 2, 19, 30 ], [ 2, 31, 30 ] ], 
      [ [ 0, 45 ], [ 15 ] ] ]
gap> LocalIndicesOfCyclotomicAlgebra(W[27]);
[ [ infinity, 2 ] ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 341, 348 ]

gap> A:=[3,Rationals,12,[[2,5,3],[2,7,0]],[[3]]];
[ 3, Rationals, 12, [ [ 2, 5, 3 ], [ 2, 7, 0 ] ], [ [ 3 ] ] ]
gap> RootOfDimensionOfCyclotomicAlgebra(A);      
12


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 370, 389 ]

gap> G:=SmallGroup(48,15);
<pc group of size 48 with 5 generators>
gap> R:=GroupRing(Rationals,G);                
<algebra-with-one over Rationals, with 5 generators>
gap> W:=WedderburnDecompositionInfo(R);;  
gap> A:=W[10];
[ 1, Rationals, 12, [ [ 2, 5, 3 ], [ 2, 7, 0 ] ], [ [ 3 ] ] ]
gap> g:=DefiningGroupOfCyclotomicAlgebra(A);
Group([ f3*f4*f5, f1, f2 ])
gap> IdSmallGroup(g);
[ 48, 15 ]
gap> DefiningCharacterOfCyclotomicAlgebra(A);
12
gap> SimpleComponentOfGroupRingByCharacter(Rationals,G,12)
> ;#Note:this cyclotomic algebra is isomorphic to the other by a change of basis. 
[ 1, Rationals, 12, [ [ 2, 5, 9 ], [ 2, 7, 0 ] ], [ [ 9 ] ] ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 401, 413 ]

gap> G:=SmallGroup(48,16);
<pc group of size 48 with 5 generators>
gap> Size(Irr(G));                          
12
gap> LocalIndexAtInftyByCharacter(Rationals,G,12);
2
gap> LocalIndexAtInftyByCharacter(CF(3),G,12);    
1



# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 438, 459 ]

gap> G:=SmallGroup(80,28);                                 
<pc group of size 80 with 5 generators>
gap> Size(Irr(G));
20
gap> LocalIndexAtPByBrauerCharacter(Rationals,G,20,5);
2 

gap> G:=SmallGroup(72,21);
<pc group of size 72 with 5 generators>
gap> Size(Irr(G));                                            
18
gap> B:=SimpleComponentOfGroupRingByCharacter(Rationals,G,18);
[ 2, Rationals, 6, [ 2, 5, 0 ] ]
gap> LocalIndexAtPByBrauerCharacter(Rationals,G,18,3);
[ 2, "DGnotCyclic" ]
gap> LocalIndexAtOddPByCharacter(Rationals,G,18,3);
1



# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 462, 498 ]

gap> G:=SmallGroup(72,20);
<pc group of size 72 with 5 generators>
gap> T:=CharacterTable(G);
CharacterTable( <pc group of size 72 with 5 generators> )
gap> S:=T mod 3;
BrauerTable( <pc group of size 72 with 5 generators>, 3 )
gap> b:=BlocksInfo(S);
[ rec( defect := 2, modchars := [ 1, 2, 3, 4 ], 
      ordchars := [ 1, 2, 3, 4, 10, 12, 13, 14, 17 ] ), 
  rec( defect := 2, modchars := [ 5, 6, 7, 8 ], 
      ordchars := [ 5, 6, 7, 8, 9, 11, 15, 16, 18 ] ) ]
gap> FinFieldExt(Rationals,G,3,11,8);
2
gap> D:=PossibleDefectGroups(G,16,3);
[ Group( [ f4, f5 ] )^G ]
gap> IsCyclic(Elements(D[1])[1]);
false
gap> S:=T mod 2;                     
BrauerTable( <pc group of size 72 with 5 generators>, 2 )
gap> b:=BlocksInfo(S);
[ rec( defect := 3, modchars := [ 1 ], 
      ordchars := [ 1, 2, 3, 4, 5, 6, 7, 8 ] ), 
  rec( defect := 2, modchars := [ 2 ], ordchars := [ 9, 10, 11, 12 ] ), 
  rec( defect := 2, modchars := [ 3 ], ordchars := [ 13, 14, 15, 16 ] ), 
  rec( defect := 1, modchars := [ 4 ], ordchars := [ 17, 18 ] ) ]
gap> FinFieldExt(Rationals,G,3,16,3);
1
gap> D:=PossibleDefectGroups(G,16,2);
[ Group( [ f1, f3, f1*f3 ] )^G, Group( [ f2, f3, f2*f3 ] )^G ]
gap> IsCyclic(Elements(D[1])[1]);
false
gap> IsCyclic(Elements(D[2])[1]);
true


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 532, 545 ]

gap> G:=SmallGroup(48,15);
<pc group of size 48 with 5 generators>
gap> Size(Irr(G));
12
gap> LocalIndexAtOddPByCharacter(Rationals,G,12,3);
2
gap> LocalIndexAtTwoByCharacter(Rationals,G,12);  
2
gap> LocalIndexAtTwoByCharacter(CF(3),G,12);    
1


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 578, 597 ]

gap> LocalIndicesOfRationalSymbolAlgebra(-1,-1);
[ [ infinity, 2 ], [ 2, 2 ] ]
gap> LocalIndicesOfRationalSymbolAlgebra(3,-1); 
[ [ 2, 2 ], [ 3, 2 ] ]
gap> LocalIndicesOfRationalSymbolAlgebra(-3,2);
[  ]
gap> LocalIndicesOfRationalSymbolAlgebra(3,7); 
[ [ 2, 2 ], [ 7, 2 ] ]
gap> A:=QuaternionAlgebra(Rationals,-30,-15);   
<algebra-with-one of dimension 4 over Rationals>
gap> LocalIndicesOfRationalQuaternionAlgebra(A);
[ [ 5, 2 ], [ infinity, 2 ] ]
gap> A:=QuaternionAlgebra(CF(5),3,-2);          
<algebra-with-one of dimension 4 over CF(5)>
gap> LocalIndicesOfRationalQuaternionAlgebra(A);
fail


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 614, 629 ]

gap> A:=QuaternionAlgebra(Rationals,-30,-15);           
<algebra-with-one of dimension 4 over Rationals>
gap> IsRationalQuaternionAlgebraADivisionRing(A);
true
gap> LocalIndicesOfRationalQuaternionAlgebra(A);
[ [ 5, 2 ], [ infinity, 2 ] ]
gap> A:=QuaternionAlgebra(Rationals,3,-2);       
<algebra-with-one of dimension 4 over Rationals>
gap> IsRationalQuaternionAlgebraADivisionRing(A);
false
gap> LocalIndicesOfRationalQuaternionAlgebra(A);
[  ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 655, 668 ]

gap> G:=SmallGroup(192,49);
<pc group of size 192 with 7 generators>
gap> W:=WedderburnDecompositionInfo(GroupRing(Rationals,G));;
gap> Size(W);
21
gap> A:=W[20];
[ [ 1, NF(8,[ 1, 7 ]), 24, [ [ 2, 7, 0 ], [ 2, 17, 21 ] ], [ [ 15 ] ] ] ]
gap> DecomposeCyclotomicAlgebra(A);                              
[ [ NF(8,[ 1, 7 ]), CF(8), [ -1 ] ], 
  [ NF(8,[ 1, 7 ]), NF(24,[ 1, 7 ]), [ -2-E(8)+E(8)^3 ] ] ]


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 687, 707 ]

gap> A:=[NF(24,[1,11]),CF(24),[-1]];
[ NF(24,[ 1, 11 ]), CF(24), [ -1 ] ]
gap> ConvertCyclicAlgToCyclicCyclotomicAlg(A);
[ 1, NF(24,[ 1, 11 ]), 24, [ 2, 11, 12 ] ]
gap> LocalIndicesOfCyclicCyclotomicAlgebra(last);
[  ]
gap> ConvertQuadraticAlgToQuaternionAlg(A);
<algebra-with-one of dimension 4 over NF(24,[ 1, 11 ])>
gap> b:=Basis(last);
CanonicalBasis( <algebra-with-one of dimension 4 over NF(24,[ 1, 11 ])> )
gap> b[1]^2; b[2]^2; b[3]^2; b[4]^2;
e
(-1)*e
(-1)*e
(-1)*e
gap> b[2]*b[3]+b[3]*b[2];
0*e


# [ "/Users/alexk/gap4r7p1pre/pkg/wedderga/doc/div-alg.xml", 728, 749 ]

gap> A:=QuaternionAlgebra(CF(5),-3,-1);
<algebra-with-one of dimension 4 over CF(5)>
gap> ConvertQuaternionAlgToQuadraticAlg(A);
[ CF(5), CF(15), [ -1 ] ]
gap> ConvertCyclicAlgToCyclicCyclotomicAlg(last);
[ 1, CF(5), 30, [ 2, 11, 15 ] ]
gap> SchurIndex(last);
1
gap> ConvertCyclicCyclotomicAlgToCyclicAlg(last2);
[ 1, [ CF(5), CF(15), [ -1 ] ] ]
gap> ConvertQuadraticAlgToQuaternionAlg(last[2]);
<algebra-with-one of dimension 4 over CF(5)>
gap> b:=Basis(last); b[1]^2; b[2]^2; b[3]^2; b[4]^2;
Basis( <algebra-with-one of dimension 4 over CF(5)>, ... )
e
(-3)*e
(-1)*e
(-3)*e

