gap> START_TEST("HAPprime version 0.6 datatypes reference manual examples");
gap> HAPprimeInfoLevel := InfoLevel(InfoHAPprime);;
gap> SetInfoLevel(InfoHAPprime, 0);;
gap> #
# from paragraph [ 2, 5, 0, 8 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/resolution.xml", 177 ]

gap> G := DirectProduct(DihedralGroup(8), SmallGroup(8, 4));
<pc group of size 64 with 6 generators>
gap> R := LengthOneResolutionPrimePowerGroup(G);
Resolution of length 1 in characteristic 2 for <pc group of size 64 with
6 generators> .
No contracting homotopy available.
A partial contracting homotopy is available.

gap> R := ExtendResolutionPrimePowerGroupRadical(R);;
gap> R := ExtendResolutionPrimePowerGroupRadical(R);;
gap> R := ExtendResolutionPrimePowerGroupRadical(R);
Resolution of length 4 in characteristic 2 for <pc group of size 64 with
6 generators> .
No contracting homotopy available.
A partial contracting homotopy is available.

gap> #
gap> ResolutionLength(R);
4
gap> ResolutionGroup(R);
<pc group of size 64 with 6 generators>
gap> ResolutionModuleRanks(R);
[ 4, 9, 15, 22 ]
gap> ResolutionModuleRank(R, 3);
15
gap> M2 := ResolutionFpGModuleGF(R, 2);
Full canonical module FG^9 over the group ring of <pc group of size 64 with
6 generators> in characteristic 2

gap> d3 := BoundaryFpGModuleHomomorphismGF(R, 3);
<Module homomorphism>

gap> ImageOfModuleHomomorphism(d3);
Module over the group ring of <pc group of size 64 with
6 generators> in characteristic 2 with 15 generators in FG^9.

gap> #
gap> S := ResolutionPrimePowerGroupGF(G, 4);
Resolution of length 4 in characteristic 2 for <pc group of size 64 with
6 generators> .
No contracting homotopy available.
A partial contracting homotopy is available.

gap> ResolutionsAreEqual(R, S);
true
gap> T := ResolutionPrimePowerGroupGF2(G, 4);
Resolution of length 4 in characteristic 2 for <pc group of size 64 with
6 generators> .
No contracting homotopy available.
A partial contracting homotopy is available.

gap> ResolutionsAreEqual(R, T);
true

# from paragraph [ 3, 4, 11, 9 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodule.xml", 462 ]

gap> R := ResolutionPrimePowerGroupRadical(DihedralGroup(8), 2);
Resolution of length 2 in characteristic 2 for <pc group of size 8 with
3 generators> .
No contracting homotopy available.
A partial contracting homotopy is available.

gap> phi := BoundaryFpGModuleHomomorphismGF(R, 2);
<Module homomorphism>

gap> M := KernelOfModuleHomomorphism(phi);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 15 generators in FG^3.

gap> # Now find out things about this module M
gap> ModuleGroup(M);
<pc group of size 8 with 3 generators>
gap> ModuleGroupOrder(M);
8
gap> ModuleAction(M);
function( g, v ) ... end
gap> ModuleActionBlockSize(M);
8
gap> ModuleGroupAndAction(M);
rec( group := <pc group of size 8 with 3 generators>,
  action := function( g, v ) ... end,
  actionOnRight := function( g, v ) ... end, actionBlockSize := 8 )
gap> ModuleCharacteristic(M);
2
gap> ModuleField(M);
GF(2)
gap> ModuleAmbientDimension(M);
24
gap> AmbientModuleDimension(M);
3

# from paragraph [ 3, 5, 11, 5 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodule.xml", 533 ]

gap> R := ResolutionPrimePowerGroupRadical(DihedralGroup(8), 2);;
gap> phi := BoundaryFpGModuleHomomorphismGF(R, 2);;
gap> M := KernelOfModuleHomomorphism(phi);;
gap> #
gap> ModuleGenerators(M);
[ <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24> ]
gap> ModuleGeneratorsAreMinimal(M);
false
gap> ModuleGeneratorsForm(M);
"unknown"
gap> #
gap> N := MinimalGeneratorsModuleGF(M);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 4 generators in FG^
3. Generators are in minimal echelon form.

gap> M = N;    # Check that the new module spans the same space
true
gap> ModuleGeneratorsAreEchelonForm(N);
true
gap> ModuleIsFullCanonical(N);
false
gap> M = N;
true
gap> ModuleVectorSpaceBasis(N);
[ <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24>, <a GF2 vector of length 24>,
  <a GF2 vector of length 24> ]
gap> ModuleVectorSpaceDimension(N);
15
gap> #
gap> N2 := MinimalGeneratorsModuleRadical(M);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 4 generators in FG^
3. Generators are minimal.

gap> #
gap> R := RadicalOfModule(M);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 120 generators in FG^3.

gap> N2 = N;
true

# from paragraph [ 3, 6, 3, 4 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodule.xml", 627 ]

gap> R := ResolutionPrimePowerGroupRadical(SmallGroup(32, 10), 3);;
gap> phi := BoundaryFpGModuleHomomorphismGF(R, 3);;
gap> #
gap> M := KernelOfModuleHomomorphism(phi);
Module over the group ring of <pc group of size 32 with
5 generators> in characteristic 2 with 65 generators in FG^4.

gap> #
gap> N := SemiEchelonModuleGenerators(M);
rec( module := Module over the group ring of <pc group of size 32 with
    5 generators> in characteristic 2 with 5 generators in FG^
    4. Generators are in minimal semi-echelon form.
    , headblocks := [ 2, 3, 1, 1, 3 ] )
gap> DisplayBlocks(N.module);
Module over the group ring of Group( [ f1, f2, f3, f4, f5 ] )
 in characteristic 2 with 5 generators in FG^4.
[.*.*]
[..**]
[***.]
[****]
[..**]
Generators are in minimal semi-echelon form.
gap> N2 := SemiEchelonModuleGeneratorsMinMem(M);
rec( module := Module over the group ring of <pc group of size 32 with
    5 generators> in characteristic 2 with 9 generators in FG^4. 
    , headblocks := [ 2, 1, 3, 1, 1, 4, 1, 3, 4 ] )
gap> DisplayBlocks(N2.module);
Module over the group ring of Group( [ f1, f2, f3, f4, f5 ] )
 in characteristic 2 with 9 generators in FG^4.
[.*..]
[**..]
[..**]
[****]
[****]
[...*]
[****]
[..**]
[...*]

gap> #
gap> EchelonModuleGeneratorsDestructive(M);;
gap> DisplayBlocks(M);
Module over the group ring of Group( [ f1, f2, f3, f4, f5 ] )
 in characteristic 2 with 5 generators in FG^4.
[***.]
[****]
[.*.*]
[..**]
[..**]
Generators are in minimal echelon form.
gap> ReverseEchelonModuleGeneratorsDestructive(M);
Module over the group ring of <pc group of size 32 with
5 generators> in characteristic 2 with 5 generators in FG^
4. Generators are in minimal echelon form.

gap> DisplayBlocks(M);
Module over the group ring of Group( [ f1, f2, f3, f4, f5 ] )
 in characteristic 2 with 5 generators in FG^4.
[***.]
[****]
[.*..]
[..*.]
[..**]
Generators are in minimal echelon form.

# from paragraph [ 3, 7, 5, 8 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodule.xml", 727 ]

gap> G := CyclicGroup(64);;
gap> FG := FpGModuleGF(G, 1);
Full canonical module FG^1 over the group ring of <pc group of size 64 with
6 generators> in characteristic 2

gap> FG2 := FpGModuleGF(G, 2);
Full canonical module FG^2 over the group ring of <pc group of size 64 with
6 generators> in characteristic 2

gap> M := DirectSumOfModules(FG2, FG);
Full canonical module FG^3 over the group ring of <pc group of size 64 with
6 generators> in characteristic 2

gap> DirectDecompositionOfModule(M);
[ Module over the group ring of <pc group of size 64 with
    6 generators> in characteristic 2 with 1 generator in FG^
    1. Generators are in minimal echelon form.
    , Module over the group ring of <pc group of size 64 with
    6 generators> in characteristic 2 with 1 generator in FG^
    1. Generators are in minimal echelon form.
    , Module over the group ring of <pc group of size 64 with
    6 generators> in characteristic 2 with 1 generator in FG^
    1. Generators are in minimal echelon form.
     ]

# from paragraph [ 3, 7, 5, 11 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodule.xml", 771 ]

gap> G := DihedralGroup(4);;
gap> M := FpGModuleGF([[1,1,0,0]]*One(GF(2)), G);
Module over the group ring of <pc group of size 4 with
2 generators> in characteristic 2 with 1 generator in FG^
1. Generators are in minimal echelon form.

gap> N := FpGModuleGF([[1,1,1,1]]*One(GF(2)), G);
Module over the group ring of <pc group of size 4 with
2 generators> in characteristic 2 with 1 generator in FG^
1. Generators are in minimal echelon form.

gap> #
gap> S := SumModules(M,N);
Module over the group ring of <pc group of size 4 with
2 generators> in characteristic 2 with 2 generators in FG^1.

gap> I := IntersectionModules(M,N);
Module over the group ring of <pc group of size 4 with
2 generators> in characteristic 2 with 1 generator in FG^1.

gap> #
gap> S = M and I = N;
true

# from paragraph [ 4, 4, 2, 4 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodulehom.xml", 212 ]

gap> G := SmallGroup(8, 4);;
gap> im := [1,0,0,0,0,0,0,0]*One(GF(2));
[ Z(2)^0, 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ]
gap> phi := FpGModuleHomomorphismGF(
>              FpGModuleGF(G, 2),
>              FpGModuleGF(G, 1),
>              [im, im]);
<Module homomorphism>

# from paragraph [ 4, 5, 7, 4 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodulehom.xml", 253 ]

gap> R := ResolutionPrimePowerGroupRadical(SmallGroup(64, 141), 3);;
#I  Dimension 2: rank 5
#I  Dimension 3: rank 7
gap> d3 := BoundaryFpGModuleHomomorphismGF(R, 3);;
gap> SourceModule(d3);
Full canonical module FG^7 over the group ring of <pc group of size 64 with
6 generators> in characteristic 2

gap> TargetModule(d3);
Full canonical module FG^5 over the group ring of <pc group of size 64 with
6 generators> in characteristic 2

gap> ModuleHomomorphismGeneratorMatrix(d3);
<an immutable 7x320 matrix over GF2>
gap> DisplayBlocks(d3);
Module homomorphism with source:
Full canonical module FG^7 over the group ring of Group(
[ f1, f2, f3, f4, f5, f6 ] )
 in characteristic 2

and target:
Full canonical module FG^5 over the group ring of Group(
[ f1, f2, f3, f4, f5, f6 ] )
 in characteristic 2

and generator matrix:
[*.*.*]
[*****]
[.**..]
[.**..]
[..**.]
[...**]
[...*.]


# from paragraph [ 4, 6, 4, 10 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/fpgmodulehom.xml", 356 ]

gap> R := ResolutionPrimePowerGroupRadical(SmallGroup(8, 3), 3);;
gap> d2 := BoundaryFpGModuleHomomorphismGF(R, 2);;
gap> d3 := BoundaryFpGModuleHomomorphismGF(R, 3);;
gap> #
gap> I := ImageOfModuleHomomorphism(d3);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 4 generators in FG^3.

gap> K := KernelOfModuleHomomorphism(d2);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 15 generators in FG^3.

gap> I = K;
true
gap> #
gap> e := ModuleGenerators(K)[1];;
gap> PreImageRepresentativeOfModuleHomomorphism(d3, e);
<a GF2 vector of length 32>
gap> f := PreImageRepresentativeOfModuleHomomorphism(d3, e);
<a GF2 vector of length 32>
gap> ImageOfModuleHomomorphism(d3, f);
<a GF2 vector of length 24>
gap> last = e;
true
gap> #
gap> L := KernelOfModuleHomomorphismSplit(d2);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 5 generators in FG^3.

gap> K = L;
true
gap> M := KernelOfModuleHomomorphismGF(d2);
Module over the group ring of <pc group of size 8 with
3 generators> in characteristic 2 with 4 generators in FG^
3. Generators are minimal.

gap> K = M;
true

# from paragraph [ 5, 1, 5, 4 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/GAPfunctions.xml", 55 ]

gap> U := [[1,2,3],[4,5,6]];;
gap> V := [[3,3,3],[5,7,9]];;
gap> SolutionMat(U, V);
[ [ -1, 1 ], [ 1, 1 ] ]
gap> IsSameSubspace(U, V);
true
gap> SumIntersectionMatDestructive(U, V);
[ [ [ 1, 2, 3 ], [ 0, 1, 2 ] ], [ [ 0, 1, 2 ], [ 1, 0, -1 ] ] ]
gap> IsSameSubspace(last[1], last[2]);
true
gap> PrintDimensionsMat(V);
"2x3"

# from paragraph [ 5, 2, 1, 8 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/../../lib/groups.gi", 49 ]

gap> HallSeniorNumber(32, 5);
20
gap> HallSeniorNumber(SmallGroup(64, 1));
11

# from paragraph [ 6, 3, 1, 5 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/datatypes/../../lib/resolutions.gi", 817 ]

gap> G := CyclicGroup(4);;
gap> v := HAPPRIME_WordToVector([ [1,2],[2,3] ], 2, Order(G));
<a GF2 vector of length 8>
gap> HAPPRIME_DisplayGeneratingRows([v], CanonicalGroupAndAction(G));
[.1..|..1.]
gap> HAPPRIME_VectorToWord(v, Order(G));
[ [ 1, 2 ], [ 2, 3 ] ]

gap> #
gap> SetInfoLevel(InfoHAPprime, HAPprimeInfoLevel);
gap> STOP_TEST("HAPprime/tst/datatypesexamples.tst", 2000000000);
