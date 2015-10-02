#############################################################################
##
#W  bipartition.tst
#Y  Copyright (C) 2014-15                                 Attila Egri-Nagy
##                                                       James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##
gap> START_TEST("Semigroups package: bipartition.tst");
gap> LoadPackage("semigroups", false);;

#
gap> SemigroupsStartTest();

#T# BipartitionTest1: IsomorphismTransformationMonoid, IsomorphismTransformationSemigroup
gap> S:=DualSymmetricInverseMonoid(4);                                
<inverse bipartition monoid on 4 pts with 3 generators>
gap> IsomorphismTransformationMonoid(S);
MappingByFunction( <inverse bipartition monoid of size 339, 
 on 4 pts with 3 generators>, <transformation monoid 
 on 339 pts with 3 generators>, function( x ) ... end, function( x ) ... end )
gap> S:=Semigroup( Bipartition( [ [ 1, 2, 3, 4, -2, -3 ], [ -1 ], [ -4 ] ] ), 
>  Bipartition( [ [ 1, 2, -1, -3 ], [ 3, 4, -2, -4 ] ] ), 
>  Bipartition( [ [ 1, 3, -1 ], [ 2, 4, -2, -3 ], [ -4 ] ] ), 
>  Bipartition( [ [ 1, -4 ], [ 2 ], [ 3, -2 ], [ 4, -1 ], [ -3 ] ] ) );;
gap> IsomorphismTransformationSemigroup(S);
MappingByFunction( <bipartition semigroup of size 284, 
 on 4 pts with 4 generators>, <transformation semigroup 
 on 285 pts with 4 generators>, function( x ) ... end, function( x ) ... end )
gap> S:=Monoid(Bipartition( [ [ 1, 2, -2 ], [ 3 ], [ 4, -3, -4 ], [ -1 ] ] ), 
>  Bipartition( [ [ 1, 3, -3, -4 ], [ 2, 4, -1, -2 ] ] ), 
>  Bipartition( [ [ 1, -1, -2 ], [ 2, 3, -3, -4 ], [ 4 ] ] ), 
>  Bipartition( [ [ 1, 4, -4 ], [ 2, -1 ], [ 3, -2, -3 ] ] ) );;
gap> IsomorphismTransformationMonoid(S);
MappingByFunction( <bipartition monoid of size 41, on 4 pts with 4 generators>
 , <transformation monoid on 41 pts with 4 generators>
 , function( x ) ... end, function( x ) ... end )

# the number of iterations, change here to get faster test
gap> N := 333;;

#T# BipartitionTest2: BASICS
gap> classes:=[[1,2,3, -2], [4, -5], [5, -7], [6, -3, -4], [7], [-1], [-6]];;
gap> f:=BipartitionNC(classes);
<bipartition: [ 1, 2, 3, -2 ], [ 4, -5 ], [ 5, -7 ], [ 6, -3, -4 ], [ 7 ], 
 [ -1 ], [ -6 ]>
gap> LeftProjection(f);
<bipartition: [ 1, 2, 3, -1, -2, -3 ], [ 4, -4 ], [ 5, -5 ], [ 6, -6 ], 
 [ 7 ], [ -7 ]>

#T# BipartitionTest3: different order of classes
gap> classes2:=[[-6], [1,2,3, -2], [4, -5], [5, -7], [6, -3, -4], [-1], [7]];;
gap> f = Bipartition(classes2);
true
gap> f:=BipartitionNC([[1,2,-3,-5, -6], [3,-2,-4], [4,7], [5, -7, -8, -9], 
> [6], [8,9,-1]]);
<bipartition: [ 1, 2, -3, -5, -6 ], [ 3, -2, -4 ], [ 4, 7 ], [ 5, -7, -8, -9 ]
  , [ 6 ], [ 8, 9, -1 ]>
gap> LeftProjection(f);
<bipartition: [ 1, 2, -1, -2 ], [ 3, -3 ], [ 4, 7 ], [ 5, -5 ], [ 6 ], 
 [ 8, 9, -8, -9 ], [ -4, -7 ], [ -6 ]>

#T# BipartitionTest4: ASSOCIATIVITY
gap> l := List([1..3*N], i->RandomBipartition(17));;
gap> triples := List([1..N], i -> [l[i],l[i+1],l[i+2]]);;
gap> ForAll(triples, x-> ((x[1]*x[2])*x[3]) = (x[1]*(x[2]*x[3])));
true

#T# BipartitionTest5: EMBEDDING into T_n
gap> l := List([1,2,3,4,5,15,35,1999,64999,65000],i->RandomTransformation(i));;
gap> ForAll(l,t->t=AsTransformation(AsBipartition(t)));
true

#T# BipartitionTest6: checking IsTransBipartitition
gap> l := List([1,2,3,4,5,15,35,1999,30101,54321],i->RandomTransformation(i));;
gap> ForAll(l,t->IsTransBipartition(AsBipartition(t)));
true

#T# BipartitionTest7: check big size, identity, multiplication
gap> bp := RandomBipartition(70000);;bp*One(bp)=bp;One(bp)*bp=bp;
true
true

#T# BipartitionTest8: check BlocksIdempotentTester, first a few little examples
gap> l := BlocksByIntRepNC( [ 3, 1, 2, 3, 3, 0, 0, 0 ]);;
gap> r := BlocksByIntRepNC( [ 2, 1, 2, 2, 2, 0, 0 ]) ;;
gap> BlocksIdempotentTester(l,r);
true
gap> e := BlocksIdempotentCreator(l,r);
<bipartition: [ 1 ], [ 2, 3, 4 ], [ -1 ], [ -2 ], [ -3, -4 ]>
gap> IsIdempotent(e);
true

#T# BipartitionTest9: JDM is this the right behaviour?
gap> RightBlocks(e) = l;
true
gap> LeftBlocks(e) = r;
true

#T# BipartitionTest10: AsBipartition for a bipartition
gap> f:=Bipartition( [ [ 1, 2, 3 ], [ 4, -1, -3 ], [ 5, 6, -4, -5 ], 
> [ -2 ], [ -6 ] ] );;
gap> AsBipartition(f, 8);
<bipartition: [ 1, 2, 3 ], [ 4, -1, -3 ], [ 5, 6, -4, -5 ], [ 7 ], [ 8 ], 
 [ -2 ], [ -6 ], [ -7 ], [ -8 ]>
gap> AsBipartition(f, 6);
<bipartition: [ 1, 2, 3 ], [ 4, -1, -3 ], [ 5, 6, -4, -5 ], [ -2 ], [ -6 ]>
gap> AsBipartition(f, 4);
<bipartition: [ 1, 2, 3 ], [ 4, -1, -3 ], [ -2 ], [ -4 ]>

#T# BipartitionTest11: AsPartialPerm for bipartitions
gap> S:=DualSymmetricInverseMonoid(4);;
gap> Number(S, IsPartialPermBipartition);
24
gap> S:=PartitionMonoid(4);;
gap> Number(S, IsPartialPermBipartition);
209
gap> Size(SymmetricInverseMonoid(4));
209
gap> S:=SymmetricInverseMonoid(4);;
gap> ForAll(S, x-> AsPartialPerm(AsBipartition(x))=x);
true
gap> elts:=Filtered(PartitionMonoid(4), IsPartialPermBipartition);;
gap> ForAll(elts, x-> AsBipartition(AsPartialPerm(x),4)=x);
true

#T# BipartitionTest12: AsPermutation for bipartitions
gap> G:=SymmetricGroup(5);;
gap> ForAll(G, x-> AsPermutation(AsBipartition(x))=x);
true
gap> G:=GroupOfUnits(PartitionMonoid(5));                   
<bipartition group on 5 pts with 2 generators>
gap> ForAll(G, x-> AsBipartition(AsPermutation(x), 5)=x);
true

#T# BipartitionTest13: IsomorphismBipartitionSemigroup for a generic semigroup
gap> S:=Semigroup( 
> Bipartition( [ [ 1, 2, 3, -3 ], [ 4, -4, -5 ], [ 5, -1 ], [ -2 ] ] ), 
> Bipartition( [ [ 1, 4, -2, -3 ], [ 2, 3, 5, -5 ], [ -1, -4 ] ] ), 
> Bipartition( [ [ 1, 5 ], [ 2, 4, -3, -5 ], [ 3, -1, -2 ], [ -4 ] ] ), 
> Bipartition( [ [ 1 ], [ 2 ], [ 3, 5, -1, -2 ], [ 4, -3 ], [ -4, -5 ] ] ), 
> Bipartition( [ [ 1 ], [ 2 ], [ 3 ], [ 4, -1, -4 ], [ 5 ], [ -2, -3 ], 
>      [ -5 ] ] ));;
gap> D:=DClass(S, Bipartition( [ [ 1 ], [ 2 ], [ 3 ], [ 4, -1, -4 ], 
> [ 5 ], [ -2, -3 ], [ -5 ] ] ));;
gap> IsRegularDClass(D);
true
gap> R:=PrincipalFactor(D);
<Rees 0-matrix semigroup 12x15 over Group(())>
gap> f:=IsomorphismBipartitionSemigroup(R);
MappingByFunction( <Rees 0-matrix semigroup 12x15 over Group(())>, 
<bipartition semigroup on 182 pts with 181 generators>
 , function( x ) ... end, function( x ) ... end )
gap> g:=InverseGeneralMapping(f);;
gap> ForAll(R, x-> (x^f)^g=x);
true
gap> x:=RMSElement(R, 12,(),8);;
gap> ForAll(R, y-> (x^f)*(y^f)=(x*y)^f);               
true

#T# BipartitionTest14: IsomorphismBipartitionSemigroup
# for a transformation semigroup
gap> gens:=[ Transformation( [ 3, 4, 1, 2, 1 ] ), 
>   Transformation( [ 4, 2, 1, 5, 5 ] ), 
>   Transformation( [ 4, 2, 2, 2, 4 ] ) ];;
gap> s:=Semigroup(gens);;
gap> S:=Range(IsomorphismBipartitionSemigroup(s));
<bipartition semigroup on 5 pts with 3 generators>
gap> f:=IsomorphismBipartitionSemigroup(s);
MappingByFunction( <transformation semigroup on 5 pts with 3 generators>, 
<bipartition semigroup on 5 pts with 3 generators>
 , function( x ) ... end, <Attribute "AsTransformation"> )
gap> g:=InverseGeneralMapping(f);;
gap> ForAll(s, x-> (x^f)^g=x);                   
true
gap> ForAll(S, x-> (x^g)^f=x);
true
gap> Size(s);
731
gap> Size(S);
731
gap> x:=Transformation( [ 3, 1, 3, 3, 3 ] );;
gap> ForAll(s, y-> (x^f)*(y^f)=(x*y)^f);
true

#T# BipartitionTest15: IsomorphismTransformationSemigroup for a bipartition
# semigroup consisting of IsTransBipartition
gap> S:=Semigroup( Transformation( [ 1, 3, 4, 1, 3 ] ), 
> Transformation( [ 2, 4, 1, 5, 5 ] ), 
> Transformation( [ 2, 5, 3, 5, 3 ] ), 
> Transformation( [ 4, 1, 2, 2, 1 ] ), 
> Transformation( [ 5, 5, 1, 1, 3 ] ) );;
gap> T:=Range(IsomorphismBipartitionSemigroup(S));
<bipartition semigroup on 5 pts with 5 generators>
gap> f:=IsomorphismTransformationSemigroup(T);
MappingByFunction( <bipartition semigroup on 5 pts with 5 generators>, 
<transformation semigroup on 5 pts with 5 generators>
 , <Attribute "AsTransformation">, function( x ) ... end )
gap> g:=InverseGeneralMapping(f);;      
gap> ForAll(T, x-> (x^f)^g=x);
true
gap> ForAll(S, x-> (x^g)^f=x);
true
gap> Size(T);
602
gap> Size(S);
602
gap> Size(Range(f));
602

#T# BipartitionTest16: IsomorphismBipartitionSemigroup
# for a partial perm semigroup
gap> S:=Semigroup(
> [ PartialPerm( [ 1, 2, 3 ], [ 1, 3, 4 ] ), 
>  PartialPerm( [ 1, 2, 3 ], [ 2, 5, 3 ] ), 
>  PartialPerm( [ 1, 2, 3 ], [ 4, 1, 2 ] ), 
>  PartialPerm( [ 1, 2, 3, 4 ], [ 2, 4, 1, 5 ] ), 
>  PartialPerm( [ 1, 3, 5 ], [ 5, 1, 3 ] ) ]);;
gap> T:=Range(IsomorphismBipartitionSemigroup(S));
<bipartition semigroup on 5 pts with 5 generators>
gap> Generators(S);
[ [2,3,4](1), [1,2,5](3), [3,2,1,4], [3,1,2,4,5], (1,5,3) ]
gap> Generators(T);
[ <bipartition: [ 1, -1 ], [ 2, -3 ], [ 3, -4 ], [ 4 ], [ 5 ], [ -2 ], [ -5 ]>
    , <bipartition: [ 1, -2 ], [ 2, -5 ], [ 3, -3 ], [ 4 ], [ 5 ], [ -1 ], 
     [ -4 ]>, <bipartition: [ 1, -4 ], [ 2, -1 ], [ 3, -2 ], [ 4 ], [ 5 ], 
     [ -3 ], [ -5 ]>, 
  <bipartition: [ 1, -2 ], [ 2, -4 ], [ 3, -1 ], [ 4, -5 ], [ 5 ], [ -3 ]>, 
  <bipartition: [ 1, -5 ], [ 2 ], [ 3, -1 ], [ 4 ], [ 5, -3 ], [ -2 ], [ -4 ]>
 ]
gap> Size(S);
156
gap> Size(T);
156
gap> IsInverseSemigroup(S);
false
gap> IsInverseSemigroup(T);
false
gap> f:=IsomorphismBipartitionSemigroup(S);;
gap> g:=InverseGeneralMapping(f);;
gap> ForAll(S, x-> (x^f)^g=x);
true
gap> ForAll(T, x-> (x^g)^f=x);
true
gap> Size(S);
156
gap> ForAll(S, x-> ForAll(S, y-> (x*y)^f=(x^f)*(y^f)));
true

#T# BipartitionTest17: IsomorphismPartialPermSemigroup
# for a semigroup of bipartitions consisting of IsPartialPermBipartition
gap> f:=IsomorphismPartialPermSemigroup(T);;
gap> g:=InverseGeneralMapping(f);;
gap> ForAll(T, x-> ForAll(T, y-> (x*y)^f=(x^f)*(y^f)));
true
gap> Size(S); Size(T);
156
156
gap> ForAll(T, x-> (x^f)^g=x);                         
true
gap> ForAll(S, x-> (x^g)^f=x);
true

#T# BipartitionTest18
# Testing the cases to which the new methods for 
# IsomorphismPartialPermSemigroup and IsomorphismTransformationSemigroup
# don't apply
gap> S:=Semigroup(
> Bipartition( [ [ 1, 2, 3, 4, -1, -2, -5 ], [ 5 ], [ -3, -4 ] ] ), 
> Bipartition( [ [ 1, 2, 3 ], [ 4, -2, -4 ], [ 5, -1, -5 ], [ -3 ] ] ), 
> Bipartition( [ [ 1, 3, 5 ], [ 2, 4, -1, -2, -5 ], [ -3 ], [ -4 ] ] ), 
> Bipartition( [ [ 1, -5 ], [ 2, 3, 4, 5 ], [ -1 ], [ -2 ], [ -3, -4 ] ] ), 
> Bipartition( [ [ 1, -4 ], [ 2 ], [ 3, -2 ], [ 4, 5, -1 ], [ -3, -5 ] ] ) );;
gap> IsomorphismPartialPermSemigroup(S);
fail
gap> Range(IsomorphismTransformationSemigroup(S));
<transformation semigroup on 208 pts with 5 generators>

#T# BipartitionTest19: IsomorphismBipartitionSemigroup for a perm group
gap> G:=DihedralGroup(IsPermGroup, 10);;
gap> f:=IsomorphismBipartitionSemigroup(G);;
gap> g:=InverseGeneralMapping(f);;
gap> ForAll(G, x-> (x^f)^g=x);
true
gap> ForAll(G, x-> ForAll(G, y-> (x*y)^f=x^f*y^f));
true
gap> ForAll(Range(f), x-> (x^g)^f=x);                     
true

#T# BipartitionTest20: IsomorphismPermGroup
gap> G:=GroupOfUnits(PartitionMonoid(5));
<bipartition group on 5 pts with 2 generators>
gap> IsomorphismPermGroup(G);
MappingByFunction( <bipartition group on 5 pts with 2 generators>, Group([ (1,
2,3,4,5), (1,2) ]), <Attribute "AsPermutation">, function( x ) ... end )
gap> f:=last;; g:=InverseGeneralMapping(f);;           
gap> ForAll(G, x-> ForAll(G, y-> (x*y)^f=x^f*y^f));
true
gap> ForAll(G, x-> (x^f)^g=x);                     
true
gap> ForAll(Range(f), x-> (x^g)^f=x);
true
gap> D:=DClass(PartitionMonoid(5), 
> Bipartition( [ [ 1 ], [ 2, -3 ], [ 3, -4 ], [ 4, -5 ], [ 5 ], [ -1 ],
>   [ -2 ] ]));;
gap> G:=GroupHClass(D);
{Bipartition( [ [ 1 ], [ 2, -2 ], [ 3, -3 ], [ 4, -4, -5 ], [ 5 ], [ -1 ] ] )}
gap> IsomorphismPermGroup(G);
MappingByFunction( {Bipartition( [ [ 1 ], [ 2, -2 ], [ 3, -3 ], 
 [ 4, -4, -5 ], [ 5 ], [ -1 ] ] )}, Group([ (2,4,3), (3,
4) ]), function( x ) ... end, function( x ) ... end )

#T# BipartitionTest21: IsomorphismBipartitionSemigroup
# for an inverse semigroup of partial perms
gap> S:=InverseSemigroup(
> PartialPerm( [ 1, 3, 5, 7, 9 ], [ 7, 6, 5, 10, 1 ] ), 
> PartialPerm( [ 1, 2, 3, 4, 6, 10 ], [ 9, 10, 4, 2, 5, 6 ] ) );;
gap> T:=Range(IsomorphismBipartitionSemigroup(S));
<inverse bipartition semigroup on 10 pts with 2 generators>
gap> Size(S);
281
gap> Size(T);
281
gap> IsomorphismPartialPermSemigroup(T);
MappingByFunction( <inverse bipartition semigroup of size 281, 
 on 10 pts with 2 generators>, <inverse partial perm semigroup on 9 pts
 with 4 generators>, <Operation "AsPartialPerm">, function( x ) ... end )
gap> Size(Range(last));
281
gap> f:=last2;; g:=InverseGeneralMapping(f);;
gap> ForAll(T, x-> (x^f)^g=x);
true

#T# BipartitionTest22: AsBlockBijection and IsomorphismBlockBijectionSemigroup
# for an inverse semigroup of partial perms
gap> S:=InverseSemigroup(
> PartialPerm( [ 1, 2, 3, 6, 8, 10 ], [ 2, 6, 7, 9, 1, 5 ] ), 
> PartialPerm( [ 1, 2, 3, 4, 6, 7, 8, 10 ], [ 3, 8, 1, 9, 4, 10, 5, 6 ] ) );;
gap> AsBlockBijection(S.1);
<block bijection: [ 1, -2 ], [ 2, -6 ], [ 3, -7 ], 
 [ 4, 5, 7, 9, 11, -3, -4, -8, -10, -11 ], [ 6, -9 ], [ 8, -1 ], [ 10, -5 ]>
gap> S.1;
[3,7][8,1,2,6,9][10,5]
gap> T:=Range(IsomorphismBlockBijectionSemigroup(S));
<inverse bipartition semigroup on 11 pts with 2 generators>
gap> f:=IsomorphismBlockBijectionSemigroup(S);;
gap> g:=InverseGeneralMapping(f);;
gap> ForAll(S, x-> (x^f)^g=x);
true
gap> ForAll(T, x-> (x^g)^f=x);
true
gap> Size(S);
2657
gap> Size(T);
2657
gap> x:=PartialPerm( [ 1, 2, 3, 8 ], [ 8, 4, 10, 3 ] );;
gap> ForAll(S, y-> x^f*y^f=(x*y)^f);
true

#T# BipartitionTest23: Same as last for non-inverse partial perm semigroup
gap> S:=Semigroup(
> PartialPerm( [ 1, 2, 3, 6, 8, 10 ], [ 2, 6, 7, 9, 1, 5 ] ), 
> PartialPerm( [ 1, 2, 3, 4, 6, 7, 8, 10 ], [ 3, 8, 1, 9, 4, 10, 5, 6 ] ) );;
gap> Size(S);
90
gap> IsInverseSemigroup(S);
false
gap> T:=Range(IsomorphismBlockBijectionSemigroup(S));
<bipartition semigroup on 11 pts with 2 generators>
gap> Size(T);
90
gap> IsInverseSemigroup(T);
false
gap> f:=IsomorphismBlockBijectionSemigroup(S);;
gap> g:=InverseGeneralMapping(f);;
gap> ForAll(S, x-> (x^f)^g=x);
true
gap> ForAll(T, x-> (x^g)^f=x);
true
gap> x:=PartialPerm( [ 1, 3 ], [ 3, 1 ] );;
gap> ForAll(S, y-> x^f*y^f=(x*y)^f);
true

#T# BipartitionTest24: NaturalLeqBlockBijection
gap> S:=DualSymmetricInverseMonoid(4);;
gap> f:=Bipartition([ [ 1, -2 ], [ 2, -1 ], [ 3, -3 ], [ 4, -4 ]] );;
gap> g:=Bipartition([ [ 1, 4, -3 ], [ 2, -1, -2 ], [ 3, -4 ] ]);;
gap> NaturalLeqBlockBijection(f, g);
false
gap> NaturalLeqBlockBijection(f, f);
true
gap> NaturalLeqBlockBijection(f, g);
false
gap> NaturalLeqBlockBijection(g, f);
false
gap> NaturalLeqBlockBijection(g, g);
true
gap> f:=Bipartition([[1,4,2,-1,-2,-3], [3,-4]]);
<block bijection: [ 1, 2, 4, -1, -2, -3 ], [ 3, -4 ]>
gap> NaturalLeqBlockBijection(f, g);
true
gap> NaturalLeqBlockBijection(g, f);
false
gap> First(Idempotents(S), e-> e*g=f);
<block bijection: [ 1, 2, -1, -2 ], [ 3, -3 ], [ 4, -4 ]>
gap> Filtered(S, f-> NaturalLeqBlockBijection(f, g));
[ <block bijection: [ 1, 4, -3 ], [ 2, -1, -2 ], [ 3, -4 ]>, 
  <block bijection: [ 1, 2, 4, -1, -2, -3 ], [ 3, -4 ]>, 
  <block bijection: [ 1, 3, 4, -3, -4 ], [ 2, -1, -2 ]>, 
  <block bijection: [ 1, 2, 3, 4, -1, -2, -3, -4 ]>, 
  <block bijection: [ 1, 4, -3 ], [ 2, 3, -1, -2, -4 ]> ]
gap> Filtered(S, f-> ForAny(Idempotents(S), e-> e*f=g));
[ <block bijection: [ 1, 4, -3 ], [ 2, -1, -2 ], [ 3, -4 ]> ]
gap> Filtered(S, f-> ForAny(Idempotents(S), e-> e*g=f));
[ <block bijection: [ 1, 4, -3 ], [ 2, -1, -2 ], [ 3, -4 ]>, 
  <block bijection: [ 1, 2, 4, -1, -2, -3 ], [ 3, -4 ]>, 
  <block bijection: [ 1, 3, 4, -3, -4 ], [ 2, -1, -2 ]>, 
  <block bijection: [ 1, 2, 3, 4, -1, -2, -3, -4 ]>, 
  <block bijection: [ 1, 4, -3 ], [ 2, 3, -1, -2, -4 ]> ]

#T# BipartitionTest25: Factorization/EvaluateWord
gap> S:=DualSymmetricInverseMonoid(6);;
gap> f:=S.1*S.2*S.3*S.2*S.1;
<block bijection: [ 1, 6, -4 ], [ 2, -2, -3 ], [ 3, -5 ], [ 4, -6 ], 
 [ 5, -1 ]>
gap> Factorization(S, f);
[ -2, -2, -2, -2, -2, 4, 2 ]
gap> EvaluateWord(GeneratorsOfSemigroup(S), last);
<block bijection: [ 1, 6, -4 ], [ 2, -2, -3 ], [ 3, -5 ], [ 4, -6 ], 
 [ 5, -1 ]>
gap> S:=PartitionMonoid(5);;
gap> f:= Bipartition( [ [ 1, 4, -2, -3 ], [ 2, 3, 5, -5 ], [ -1, -4 ] ] );;
gap> Factorization(S, f);
[ 2, 3, 2, 5, 2, 2, 5, 2, 5, 4, 3, 4, 2, 4, 2, 2, 2, 5, 2, 5, 2, 1, 2, 3, 2, 
  4, 2, 4, 5, 2, 3, 2, 2, 5, 2 ]
gap> EvaluateWord(GeneratorsOfSemigroup(S), last);
<bipartition: [ 1, 4, -2, -3 ], [ 2, 3, 5, -5 ], [ -1, -4 ]>
gap> S:=Range(IsomorphismBipartitionSemigroup(SymmetricInverseMonoid(5)));
<inverse bipartition monoid on 5 pts with 3 generators>
gap> f:=S.1*S.2*S.3*S.2*S.1;
<bipartition: [ 1 ], [ 2, -2 ], [ 3, -4 ], [ 4, -5 ], [ 5, -3 ], [ -1 ]>
gap> Factorization(S, f);
[ -1, 1, 3, 2, 1, 2, -1, -1, 2, 1, 2, -1, -1, 1 ]
gap> EvaluateWord(GeneratorsOfSemigroup(S), last);
<bipartition: [ 1 ], [ 2, -2 ], [ 3, -4 ], [ 4, -5 ], [ 5, -3 ], [ -1 ]>
gap> S:=Semigroup(
> [ Bipartition( [ [ 1, 2, 3, 5, -1, -4 ], [ 4 ], [ -2, -3 ], [ -5 ] ] ), 
>   Bipartition( [ [ 1, 2, 4 ], [ 3, 5, -1, -4 ], [ -2, -5 ], [ -3 ] ] ), 
>   Bipartition( [ [ 1, 2 ], [ 3, -1, -3 ], [ 4, 5, -4, -5 ], [ -2 ] ] ), 
>   Bipartition( [ [ 1, 3, 4, -4 ], [ 2 ], [ 5 ], [ -1, -2, -3 ], [ -5 ] ] ), 
>   Bipartition( [ [ 1, -3 ], [ 2, -5 ], [ 3, -1 ], [ 4, 5 ],
>     [ -2, -4 ] ] ) ] );;
gap> x:=S.1*S.2*S.3*S.4*S.5;
<bipartition: [ 1, 2, 3, 5 ], [ 4 ], [ -1, -3, -5 ], [ -2, -4 ]>
gap> Factorization(S, x);
[ 1, 4, 1, 4, 5 ]
gap> EvaluateWord(GeneratorsOfSemigroup(S), last);
<bipartition: [ 1, 2, 3, 5 ], [ 4 ], [ -1, -3, -5 ], [ -2, -4 ]>
gap> IsInverseSemigroup(S);
false

#T# BipartitionTest26:
# Tests of things in greens.xml in the order they appear in that file. 
gap> S:=Semigroup(
> Bipartition( [ [ 1, -1 ], [ 2, -2 ], [ 3, -3 ], [ 4, -4 ], [ 5, -8 ], 
>      [ 6, -9 ], [ 7, -10 ], [ 8, -11 ], [ 9, -12 ], [ 10, -13 ], [ 11, -5 ], 
>      [ 12, -6 ], [ 13, -7 ] ] ), 
>  Bipartition( [ [ 1, -2 ], [ 2, -5 ], [ 3, -8 ], [ 4, -11 ], [ 5, -1 ], 
>      [ 6, -4 ], [ 7, -3 ], [ 8, -7 ], [ 9, -10 ], [ 10, -13 ], [ 11, -6 ], 
>      [ 12, -12 ], [ 13, -9 ] ] ), 
>  Bipartition( [ [ 1, 7, -10, -12 ], [ 2, 3, 4, 6, 10, 13, -13 ], 
>      [ 5, 12, -1 ], [ 8, 9, 11 ], [ -2, -9 ], [ -3, -7, -8 ], [ -4 ], 
>      [ -5 ], [ -6, -11 ] ] ) );
<bipartition semigroup on 13 pts with 3 generators>
gap> f:=Bipartition( [ [ 1, 2, 3, 4, 7, 8, 11, 13 ], [ 5, 9 ], [ 6, 10, 12 ], 
> [ -1, -2, -6 ], [ -3 ], [ -4, -8 ], [ -5, -11 ], [ -7, -10, -13 ], [ -9 ], 
>  [ -12 ] ] );;
gap> H:=HClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 7, 8, 11, 13 ], [ 5, 9 ], [ 6, 10, 12 ], 
 [ -1, -2, -6 ], [ -3 ], [ -4, -8 ], [ -5, -11 ], [ -7, -10, -13 ], [ -9 ], 
 [ -12 ] ] )}
gap> IsGreensClassNC(H);
true
gap> MultiplicativeNeutralElement(H);
<bipartition: [ 1, 2, 3, 4, 7, 8, 11, 13 ], [ 5, 9 ], [ 6, 10, 12 ], 
 [ -1, -2, -6 ], [ -3 ], [ -4, -8 ], [ -5, -11 ], [ -7, -10, -13 ], [ -9 ], 
 [ -12 ]>
gap> IsBipartitionSemigroupGreensClass(H);
true
gap> StructureDescription(H);
"1"
gap> H:=HClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 7, 8, 11, 13 ], [ 5, 9 ], [ 6, 10, 12 ], 
 [ -1, -2, -6 ], [ -3 ], [ -4, -8 ], [ -5, -11 ], [ -7, -10, -13 ], [ -9 ], 
 [ -12 ] ] )}
gap> f:=Bipartition([ [ 1, 2, 5, 6, 7, 8, 9, 10, 11, 12, -1, -10, -12, -13 ], 
> [ 3, 4, 13 ], [ -2, -9 ], [ -3, -7, -8 ], [ -4 ], [ -5 ], [ -6, -11 ]]);;
gap> HH:=HClassNC(S, f);
{Bipartition( [ [ 1, 2, 5, 6, 7, 8, 9, 10, 11, 12, -1, -10, -12, -13 ], 
 [ 3, 4, 13 ], [ -2, -9 ], [ -3, -7, -8 ], [ -4 ], [ -5 ], [ -6, -11 ] ] )}
gap> HH<H;
false
gap> H<HH;
true
gap> H=HH;
false
gap> D:=DClass(H);
{Bipartition( [ [ 1, 2, 3, 4, 7, 8, 11, 13 ], [ 5, 9 ], [ 6, 10, 12 ], 
 [ -1, -2, -6 ], [ -3 ], [ -4, -8 ], [ -5, -11 ], [ -7, -10, -13 ], [ -9 ], 
 [ -12 ] ] )}
gap> DD:=DClass(HH);
{Bipartition( [ [ 1, 2, 5, 6, 7, 8, 9, 10, 11, 12, -1, -10, -12, -13 ], 
 [ 3, 4, 13 ], [ -2, -9 ], [ -3, -7, -8 ], [ -4 ], [ -5 ], [ -6, -11 ] ] )}
gap> DD<D;
false
gap> D<DD;
true
gap> D=DD;
false
gap> S:=Semigroup(
> [ Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -2, -4, -5 ], [ -3 ] ] ), 
>  Bipartition( [ [ 1, 2, 3, 4, -2, -3, -4 ], [ 5 ], [ -1, -5 ] ] ), 
>  Bipartition( [ [ 1, 2, 3, -3, -5 ], [ 4, -1 ], [ 5, -2, -4 ] ] ), 
>  Bipartition( [ [ 1, 5, -1, -3 ], [ 2, 3 ], [ 4, -2 ], [ -4, -5 ] ] ), 
>  Bipartition( [ [ 1, 4, -3 ], [ 2 ], [ 3 ], [ 5, -1, -2, -5 ], [ -4 ] ] ) ]);;
gap> IsGreensLessThanOrEqual(DClass(S, S.1), DClass(S, S.2));
true
gap> IsGreensLessThanOrEqual(DClass(S, S.2), DClass(S, S.1));
false
gap> f:=S.1*S.2*S.3;
<bipartition: [ 1, 2, 3, 4, 5 ], [ -1, -2, -3, -4, -5 ]>
gap> f:=S.1*S.2;
<bipartition: [ 1, 2, 3, 4, 5 ], [ -1, -5 ], [ -2, -3, -4 ]>
gap> H:=HClass(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -5 ], [ -2, -3, -4 ] ] )}
gap> LClass(H);
{Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -5 ], [ -2, -3, -4 ] ] )}
gap> RClass(H);
{Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -2, -4, -5 ], [ -3 ] ] )}
gap> DClass(RClass(H));
{Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -2, -4, -5 ], [ -3 ] ] )}
gap> DClass(LClass(H));
{Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -2, -4, -5 ], [ -3 ] ] )}
gap> DClass(H);
{Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -2, -4, -5 ], [ -3 ] ] )}
gap> f:=Bipartition([[ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ]]);
<bipartition: [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ]>
gap> H:=HClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> LClass(H);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> RClass(H);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> DClass(RClass(H));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> DClass(LClass(H));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> DClass(H);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> 
gap> DClasses(S);
[ {Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -2, -4, -5 ], [ -3 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, -2, -3, -4 ], [ 5 ], [ -1, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, -3, -5 ], [ 4, -1 ], [ 5, -2, -4 ] ] )}, 
  {Bipartition( [ [ 1, 5, -1, -3 ], [ 2, 3 ], [ 4, -2 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4, -3 ], [ 2 ], [ 3 ], [ 5, -1, -2, -5 ], [ -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, -1, -2, -5 ], [ 4, 5, -3 ], [ -4 ] ] )} ]
gap> H:=HClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> RClasses(DClass(H));
[ {Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, -2 ], [ 5 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4, 5, -2 ], [ 2, 3 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4, 5, -2 ], [ 2 ], [ 3 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 5, -2 ], [ 2, 3 ], [ 4 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4 ], [ 2 ], [ 3 ], [ 5, -2 ], [ -1, -3 ], 
     [ -4, -5 ] ] )}, {Bipartition( [ [ 1, 2, 3, -2 ], [ 4, 5 ], [ -1, -3 ], 
     [ -4, -5 ] ] )} ]
gap> LClasses(DClass(H));
[ {Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -3, -5 ], [ -1, -2, -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -3, -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -3, -5 ], [ -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -5 ], [ -3 ], [ -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4, -5 ], [ -1 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -3 ], [ -2 ], [ -4, -5 ] ] )} ]
gap> HClasses(LClass(H));
[ {Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, -2 ], [ 5 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4, 5, -2 ], [ 2, 3 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4, 5, -2 ], [ 2 ], [ 3 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 5, -2 ], [ 2, 3 ], [ 4 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4 ], [ 2 ], [ 3 ], [ 5, -2 ], [ -1, -3 ], 
     [ -4, -5 ] ] )}, {Bipartition( [ [ 1, 2, 3, -2 ], [ 4, 5 ], [ -1, -3 ], 
     [ -4, -5 ] ] )} ]
gap> HClasses(RClass(H));
[ {Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -3, -5 ], [ -1, -2, -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -3 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -3, -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -3, -5 ], [ -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -2, -5 ], [ -3 ], [ -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4, -5 ], [ -1 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, 5, -1, -3 ], [ -2 ], [ -4, -5 ] ] )} ]
gap> JClasses(S);
[ {Bipartition( [ [ 1, 2, 3, 4, 5 ], [ -1, -2, -4, -5 ], [ -3 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, 4, -2, -3, -4 ], [ 5 ], [ -1, -5 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, -3, -5 ], [ 4, -1 ], [ 5, -2, -4 ] ] )}, 
  {Bipartition( [ [ 1, 5, -1, -3 ], [ 2, 3 ], [ 4, -2 ], [ -4, -5 ] ] )}, 
  {Bipartition( [ [ 1, 4, -3 ], [ 2 ], [ 3 ], [ 5, -1, -2, -5 ], [ -4 ] ] )}, 
  {Bipartition( [ [ 1, 2, 3, -1, -2, -5 ], [ 4, 5, -3 ], [ -4 ] ] )} ]
gap> S:=Semigroup(S);
<bipartition semigroup on 5 pts with 5 generators>
gap> D:=DClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> D:=[D];
[ {Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )} ]
gap> D[2]:=DClass(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> D[3]:=DClass(RClass(S, f));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> D[4]:=DClass(RClass(S, f));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> D[5]:=DClass(LClass(S, f));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> D[6]:=DClass(HClass(S, f));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> D[7]:=DClass(LClass(HClass(S, f)));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> D[8]:=DClass(RClass(HClass(S, f)));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> ForAll(Combinations([1..8], 2), x-> D[x[1]]=D[x[2]]);
true
gap> List(D, IsGreensClassNC);
[ true, false, false, false, false, false, false, false ]
gap> D[7]:=DClass(LClass(HClassNC(S, f)));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> D[6]:=DClass(RClass(HClassNC(S, f)));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> D[5]:=DClass(HClassNC(S, f));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> D[4]:=DClass(LClassNC(S, f));
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> ForAll(Combinations([1..8], 2), x-> D[x[1]]=D[x[2]]);
true
gap> List(D, IsGreensClassNC);
[ true, false, false, true, true, true, true, false ]
gap> S:=Semigroup(S);
<bipartition semigroup on 5 pts with 5 generators>
gap> D:=DClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> LClassNC(D, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> Size(last);
7
gap> Size(LClass(S, f));
7
gap> LClass(S, f)=LClassNC(D, f);
true
gap> LClass(D, f)=LClassNC(S, f);
true
gap> LClassNC(D, f)=LClassNC(S, f);
true
gap> LClassNC(D, f)=LClass(S, f);
true
gap> S:=Semigroup(S);
<bipartition semigroup on 5 pts with 5 generators>
gap> D:=DClass(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> LClassNC(D, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> Size(last);
7
gap> Size(LClass(S, f));
7
gap> LClass(S, f)=LClassNC(D, f);
true
gap> LClass(D, f)=LClassNC(S, f);
true
gap> LClassNC(D, f)=LClassNC(S, f);
true
gap> LClassNC(D, f)=LClass(S, f);
true
gap> S:=Semigroup(S);
<bipartition semigroup on 5 pts with 5 generators>
gap> D:=DClass(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> RClassNC(D, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> Size(last);
9
gap> Size(RClass(S, f));
9
gap> RClass(S, f)=RClassNC(D, f);
true
gap> RClass(D, f)=RClassNC(S, f);
true
gap> RClassNC(D, f)=RClassNC(S, f);
true
gap> RClassNC(D, f)=RClass(S, f);
true
gap> S:=Semigroup(S);
<bipartition semigroup on 5 pts with 5 generators>
gap> D:=DClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> RClassNC(D, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> Size(last);
9
gap> Size(RClass(S, f));
9
gap> RClass(S, f)=RClassNC(D, f);
true
gap> RClass(D, f)=RClassNC(S, f);
true
gap> RClassNC(D, f)=RClassNC(S, f);
true
gap> RClassNC(D, f)=RClass(S, f);
true
gap> S:=Semigroup(S);
<bipartition semigroup on 5 pts with 5 generators>
gap> D:=DClass(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ] ] )}
gap> HClassNC(D, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> Size(last);
1
gap> Size(HClass(S, f));
1
gap> HClass(S, f)=HClassNC(D, f);
true
gap> HClass(D, f)=HClassNC(S, f);
true
gap> HClassNC(D, f)=HClassNC(S, f);
true
gap> HClassNC(D, f)=HClass(S, f);
true
gap> S:=Semigroup(S);
<bipartition semigroup on 5 pts with 5 generators>
gap> D:=DClassNC(S, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> HClassNC(D, f);
{Bipartition( [ [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ] ] )}
gap> Size(last);
1
gap> Size(HClass(S, f));
1
gap> HClass(S, f)=HClassNC(D, f);
true
gap> HClass(D, f)=HClassNC(S, f);
true
gap> HClassNC(D, f)=HClassNC(S, f);
true
gap> HClassNC(D, f)=HClass(S, f);
true
gap> S:=Semigroup([ 
>  Bipartition( [ [ 1, 2, 3, 4, 5, -2, -4 ], [ 6, 7 ], [ 8, -1, -6 ], 
>      [ -3, -5, -7 ], [ -8 ] ] ), 
>  Bipartition( [ [ 1, 2, 3, 4, -1, -2 ], [ 5, 6, -5 ], [ 7, 8, -4, -6 ], 
>      [ -3, -7 ], [ -8 ] ] ), 
>  Bipartition( [ [ 1, 2, 3, 7, -7 ], [ 4, 5, 6, 8 ], [ -1, -2 ], 
>      [ -3, -6, -8 ], [ -4 ], [ -5 ] ] ), 
>  Bipartition( [ [ 1, 2, 4, 7, -1, -2, -4 ], [ 3, -7 ], [ 5, -5 ], [ 6, 8 ], 
>      [ -3 ], [ -6, -8 ] ] ), 
>  Bipartition( [ [ 1, 2, 8, -2 ], [ 3, 4, 5, -5 ], [ 6, 7, -4 ], [ -1, -7 ], 
>      [ -3, -6, -8 ] ] ), 
>  Bipartition( [ [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -5 ], [ 4 ], 
>      [ -1, -2, -3, -6 ], [ -7 ], [ -8 ] ] ), 
>  Bipartition( [ [ 1, 3, 4, 5, 6, 8, -1, -5 ], [ 2, -4 ], [ 7, -3, -8 ], 
>      [ -2, -6, -7 ] ] ), 
>  Bipartition( [ [ 1, 3, 4, 5, -1, -7 ], [ 2, -6 ], [ 6 ], [ 7, -3 ], 
>      [ 8, -4 ], [ -2, -5, -8 ] ] ), 
>  Bipartition( [ [ 1, 3, 4, 6, 7, -1, -7, -8 ], [ 2, 5, 8, -6 ], [ -2, -4 ], 
>      [ -3, -5 ] ] ), 
>  Bipartition( [ [ 1, 3, 4, -8 ], [ 2, 6, 8, -1 ], [ 5, 7, -2, -3, -4, -7 ], 
>      [ -5 ], [ -6 ] ] ), 
>  Bipartition( [ [ 1, 4, 8, -4, -6, -8 ], [ 2, 3, 6, -3, -5 ], [ 5, -1, -7 ], 
>      [ 7 ], [ -2 ] ] ), 
>  Bipartition( [ [ 1, 5, -1, -2 ], [ 2, 3, 4, 6, 7 ], [ 8, -4 ], [ -3, -5 ], 
>      [ -6 ], [ -7 ], [ -8 ] ] ), 
>  Bipartition( [ [ 1, -6 ], [ 2, 3, 4, -2, -8 ], [ 5, 6, 7, -1, -3 ], [ 8 ], 
>      [ -4, -7 ], [ -5 ] ] ), 
>  Bipartition( [ [ 1, 7, 8, -1, -3, -4, -6 ], [ 2, 3, 4 ], [ 5, -2, -5 ], 
>      [ 6 ], [ -7, -8 ] ] ), 
>  Bipartition( [ [ 1, 8, -3, -5, -6 ], [ 2, 3, 4, -1 ], [ 5, -2 ], [ 6, 7 ], 
>      [ -4, -7 ], [ -8 ] ] ), 
>  Bipartition( [ [ 1, 7, 8, -5 ], [ 2, 3, 5, -6 ], [ 4 ], [ 6, -1, -3 ], 
>      [ -2 ], [ -4, -7, -8 ] ] ), 
>  Bipartition( [ [ 1, 4, -1, -3, -4 ], [ 2, 7, 8, -2, -6 ], [ 3, 5, 6, -8 ], 
>      [ -5, -7 ] ] ), 
>  Bipartition( [ [ 1, 5, 8 ], [ 2, 4, 7, -2 ], [ 3, 6 ], [ -1, -3 ], 
>      [ -4, -5 ], [ -6 ], [ -7 ], [ -8 ] ] ), 
>  Bipartition( [ [ 1 ], [ 2, 4 ], [ 3, 6, -5 ], [ 5, 7, -3, -4, -6 ], 
>      [ 8, -2 ], [ -1, -7 ], [ -8 ] ] ), 
>  Bipartition( [ [ 1, 5, -8 ], [ 2, -4 ], [ 3, 6, 8, -1, -6 ], 
>      [ 4, 7, -2, -3, -5 ], [ -7 ] ] ) ]);;
gap> DClassReps(S);
[ <bipartition: [ 1, 2, 3, 4, 5, -2, -4 ], [ 6, 7 ], [ 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -2 ], [ 5, 6, -5 ], [ 7, 8, -4, -6 ], 
     [ -3, -7 ], [ -8 ]>, <bipartition: [ 1, 2, 3, 7, -7 ], [ 4, 5, 6, 8 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -2, -4 ], [ 3, -7 ], [ 5, -5 ], [ 6, 8 ], 
     [ -3 ], [ -6, -8 ]>, <bipartition: [ 1, 2, 8, -2 ], [ 3, 4, 5, -5 ], 
     [ 6, 7, -4 ], [ -1, -7 ], [ -3, -6, -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -5 ], [ 4 ], [ -1, -2, -3, -6 ]
      , [ -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -5 ], [ 2, -4 ], [ 7, -3, -8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, -1, -7 ], [ 2, -6 ], [ 6 ], 
     [ 7, -3 ], [ 8, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -1, -7, -8 ], [ 2, 5, 8, -6 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 3, 4, -8 ], [ 2, 6, 8, -1 ], 
     [ 5, 7, -2, -3, -4, -7 ], [ -5 ], [ -6 ]>, 
  <bipartition: [ 1, 4, 8, -4, -6, -8 ], [ 2, 3, 6, -3, -5 ], [ 5, -1, -7 ], 
     [ 7 ], [ -2 ]>, 
  <bipartition: [ 1, -6 ], [ 2, 3, 4, -2, -8 ], [ 5, 6, 7, -1, -3 ], [ 8 ], 
     [ -4, -7 ], [ -5 ]>, 
  <bipartition: [ 1, 7, 8, -1, -3, -4, -6 ], [ 2, 3, 4 ], [ 5, -2, -5 ], 
     [ 6 ], [ -7, -8 ]>, <bipartition: [ 1, 8, -3, -5, -6 ], [ 2, 3, 4, -1 ], 
     [ 5, -2 ], [ 6, 7 ], [ -4, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 7, 8, -5 ], [ 2, 3, 5, -6 ], [ 4 ], [ 6, -1, -3 ], 
     [ -2 ], [ -4, -7, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -4 ], [ 2, 7, 8, -2, -6 ], [ 3, 5, 6, -8 ], 
     [ -5, -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -5 ], [ 5, 7, -3, -4, -6 ], 
     [ 8, -2 ], [ -1, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, -8 ], [ 2, -4 ], [ 3, 6, 8, -1, -6 ], 
     [ 4, 7, -2, -3, -5 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -2, -4 ], [ 3, -1, -6 ], [ 6, 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, -1, -6 ], [ 2, 5, 6, 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -2, -4 ], [ 3, 5, 6, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -7, -8 ], [ 3, 8, -6 ], [ 4 ], 
     [ -2, -4 ], [ -3, -5 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -6, -7 ], 
     [ 6 ], [ 7, -3 ], [ -2, -5, -8 ], [ -4 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -7, -8 ], [ 2, 3, 6, -6 ], [ 7 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -5 ], [ -1, -2, -3, -6 ]
      , [ -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -4, -5 ], [ 3, -3, -8 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 8, -4 ], [ 3, 4, 5, 6, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 5, 6, 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 4, -1, -3, -7 ], [ 2, 7, 8, -6 ], 
     [ 3, 5, 6, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, -4 ], [ 2, 3, 4, 6, 7, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -7, -8 ], [ 2, 3, 4, -6 ], [ 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 4, -8 ], [ 2, 3, 5, 6, 7, 8, -1 ], [ -2, -3, -4, -7 ], 
     [ -5 ], [ -6 ]>, <bipartition: [ 1, 2, 3, 4, 7, 8, -3, -4, -5, -6, -8 ], 
     [ 5, 6, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 7 ], [ 4, 5, 6, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -3, -4, -5, -6, -8 ], [ 3 ], [ 5, -1, -7 ], 
     [ 6, 8 ], [ -2 ]>, <bipartition: [ 1, 2, 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ 3, 8, -1, -7 ], [ 4 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 8, -1, -3, -5, -7 ], [ 2, 3, 4, -4, -6, -8 ], 
     [ 6, 7 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7, -8 ], 
     [ 2, 7, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -3, -4, -6 ], [ 5, 6, -2, -5 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -4, -6 ], 
     [ 3, 8, -2, -5 ], [ 4 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 7, 8, -2, -5 ], [ 2, 3, 5 ], [ 4 ], [ 6, -1, -3, -4, -6 ]
      , [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -6 ], [ 2, 7, -1, -7, -8 ], [ 6 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -4, -8 ], [ 7, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 4, -1, -6 ], [ 2, 3, 5, 6, 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6 ], [ 2, 7, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7, -8 ], 
     [ 2 ], [ 7, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -5 ], [ 6, 8 ], [ -1, -2, -3, -6 ]
      , [ -7 ], [ -8 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -5, -8 ], 
     [ 3, 8, -4 ], [ 4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 6, 7, -1, -3, -6, -7 ], 
     [ 2, 5, 8, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, 5, 8, -3, -4, -5, -6, -8 ], [ 2, 3, 6, -1, -7 ], 
     [ 7 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -3, -4, -5, -6, -8 ], 
     [ 2 ], [ 7, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -7 ], [ 3, 8, -3, -4, -5, -6, -8 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 8, -3, -4, -5, -6, -8 ], 
     [ 2, 7, -1, -7 ], [ 6 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -7 ], [ 2, 3, 4, -3, -4, -5, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -6 ], [ 2, 3, 5, 6, 7, 8, -1, -7, -8 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -4, -6 ], [ 2 ], 
     [ 7, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -1, -7, -8 ], [ 2, 7, 8, -6 ], [ 3, 5, 6 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 5, 6, 7, -2, -4 ], [ 2, 3, 4, -1, -6 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -2, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -7, -8 ], [ 3, -6 ], [ 6, 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -8 ], 
     [ 2 ], [ 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -1, -3, -5, -8 ], [ 4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -5, -8 ], 
     [ 2, 7, -4 ], [ 6 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4 ], [ 2, 3, 4, -1, -3, -5, -8 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -6, -7 ], [ 2, 3, 4, -4 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, -1, -6, -7 ], [ 2, 3, 5, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -3, -4, -5, -6, -8 ], [ 2, 7, -1, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 4, 5, 7, -3, -4, -5, -6, -8 ], 
     [ 3, -1, -7 ], [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -5, -7 ], [ 3, 8, -4, -6, -8 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7 ], [ 2 ], 
     [ 7, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -1, -7 ], [ 2, 7, -3, -4, -5, -6, -8 ], 
     [ 6 ], [ -2 ]>, <bipartition: [ 1, 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ 2, 3, 4, -1, -7 ], [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -2, -5 ], [ 3, 8, -1, -3, -4, -6 ], [ 4 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -4, -6 ], 
     [ 2, 7, -2, -5 ], [ 6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -2, -5 ], [ 2, 3, 4, -1, -3, -4, -6 ], [ 8 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -4, -6 ], 
     [ 2, 7, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -4, -6 ], [ 3, -2, -5 ], [ 6, 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -2, -5 ], [ 2, 7, 8, -1, -3, -4, -6 ], [ 3, 5, 6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -2, -5 ], [ 2, 3, 6, -1, -3, -4, -6 ], [ 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -2, -3, -5, -6 ], 
     [ 2, 7, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -6 ], [ 3, 8, -2, -4 ], [ 4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4 ], [ 2, 3, 6, -1, -3, -5, -8 ], [ 7 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -8 ], [ 2, 3, 5, 6, 7, 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -8 ], 
     [ 2, 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -5, -8 ], [ 3, -4 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4 ], [ 2, 7, -1, -3, -5, -8 ], [ 6 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -5, -8 ], [ 2, 3, 4, -4 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -1, -3, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, -1, -7 ], [ 2, 7, 8, -3, -4, -5, -6, -8 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -7 ], [ 2, 3, 6, -3, -4, -5, -6, -8 ], 
     [ 7 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -1, -7 ], [ 2, 3, 5, 6, 7, 8, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7 ], [ 2, 7, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -5, -7 ], [ 2, 3, 6, -4, -6, -8 ], 
     [ 7 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -7 ], 
     [ 2 ], [ 7, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -7 ], [ 3, -3, -4, -5, -6, -8 ], 
     [ 6, 8 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -5 ], [ 2 ], 
     [ 7, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -2, -5 ], [ 2, 7, -1, -3, -4, -6 ], [ 6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -4, -6 ], [ 2, 3, 4, -2, -5 ], [ 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -2, -5 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -5 ], [ 2, 7, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -4, -8 ], [ 2, 3, 5, 6, 7, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6 ], [ 2 ], 
     [ 7, -2, -4 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -2, -4 ], [ 3, 8, -1, -6 ], [ 4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -1, -6 ], [ 2, 7, -2, -4 ], [ 6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -6 ], [ 2, 3, 6, -2, -4 ], [ 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -5, -8 ], [ 2, 3, 6, -4 ], [ 7 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 7, 8, -1, -3, -5, -8 ], [ 3, 5, 6 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -1, -3, -5, -8 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -6, -7 ], 
     [ 3, 8, -4 ], [ 4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4 ], [ 2, 7, -1, -3, -6, -7 ], [ 6 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4 ], [ 2, 3, 6, -1, -3, -6, -7 ], [ 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4 ], [ 2, 3, 6, -1, -6, -7 ], [ 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -3, -4, -5, -6, -8 ], [ 2, 3, 5, 6, 7, 8, -1, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -5, -7 ], 
     [ 3, -4, -6, -8 ], [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -2, -5 ], [ 3, -1, -3, -4, -6 ], [ 6, 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -4, -6 ], [ 2, 3, 5, 6, 7, 8, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -4, -6 ], [ 2, 3, 6, -2, -5 ], [ 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -6 ], [ 3, -2, -4 ], 
     [ 6, 8 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -4 ], [ 2 ], [ 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -2, -4 ], [ 2, 7, -1, -6 ], [ 6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -6 ], [ 2, 3, 4, -2, -4 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -2, -4 ], [ 2, 3, 6, -1, -6 ], [ 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -1, -3, -6, -7 ], [ 6, 8 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -6, -7 ], 
     [ 2 ], [ 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -6, -7 ], [ 2, 7, -4 ], [ 6 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4 ], [ 2, 3, 4, -1, -3, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -6, -7 ], [ 2, 3, 6, -4 ], [ 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -1, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4, -6, -8 ], [ 3, 8, -1, -3, -5, -7 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -5, -7 ], 
     [ 2, 7, -4, -6, -8 ], [ 6 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4, -6, -8 ], [ 2, 3, 4, -1, -3, -5, -7 ], 
     [ 8 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -7 ], 
     [ 2, 7, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -2, -3, -5, -6 ], [ 2, 3, 6, -4, -8 ], 
     [ 7 ], [ -7 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -6, -7 ], 
     [ 3, -4 ], [ 6, 8 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -6, -7 ], [ 3, 8, -4 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4 ], [ 2, 7, -1, -6, -7 ], [ 6 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -6, -7 ], [ 2, 3, 4, -4 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -6, -8 ], 
     [ 2 ], [ 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4, -6, -8 ], [ 2, 7, -1, -3, -5, -7 ], 
     [ 6 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -5, -7 ], [ 2, 3, 4, -4, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -4, -6, -8 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -5, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -6, -8 ], 
     [ 2, 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4, -6, -8 ], [ 2, 3, 6, -1, -3, -5, -7 ], 
     [ 7 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -1, -3, -4, -6 ], [ 2, 7, 8, -2, -5 ], [ 3, 5, 6 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 3, 8, -4, -8 ], [ 4 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -4 ], [ 2, 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -2, -4 ], [ 2, 7, 8, -1, -6 ], [ 3, 5, 6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -8 ], [ 2, 7, 8, -4 ], [ 3, 5, 6 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -1, -3, -6, -7 ], [ 2, 3, 5, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -6, -7 ], 
     [ 2, 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -6, -7 ], [ 2, 7, 8, -4 ], [ 3, 5, 6 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -1, -6, -7 ], 
     [ 6, 8 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6, -7 ], [ 2 ], [ 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -1, -6, -7 ], [ 2, 7, -4 ], [ 6 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4 ], [ 2, 3, 4, -1, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6, -7 ], 
     [ 2, 7, -4 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -6, -7 ], [ 2, 3, 6, -4 ], [ 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -3, -4, -5, -6, -8 ], [ 2, 7, 8, -1, -7 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -4, -6, -8 ], [ 2, 7, 8, -1, -3, -5, -7 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4, -6, -8 ], [ 3, -1, -3, -5, -7 ], 
     [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -7 ], [ 2, 3, 5, 6, 7, 8, -4, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -2, -3, -5, -6 ], [ 2 ], 
     [ 7, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4, -8 ], [ 3, 8, -1, -2, -3, -5, -6 ], 
     [ 4 ], [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -2, -3, -5, -6 ], 
     [ 2, 7, -4, -8 ], [ 6 ], [ -7 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4, -8 ], [ 2, 3, 4, -1, -2, -3, -5, -6 ], 
     [ 8 ], [ -7 ]>, <bipartition: [ 1, 4, -1, -6, -7 ], [ 2, 7, 8, -4 ], 
     [ 3, 5, 6 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -6, -7 ], [ 3, -4 ], [ 6, 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -2, -3, -5, -6 ], [ 3, -4, -8 ], 
     [ 6, 8 ], [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -8 ], [ 2 ], 
     [ 7, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4, -8 ], [ 2, 7, -1, -2, -3, -5, -6 ], 
     [ 6 ], [ -7 ]>, <bipartition: [ 1, 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 2, 3, 4, -4, -8 ], [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -8 ], [ 2, 7, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4, -8 ], [ 2, 3, 6, -1, -2, -3, -5, -6 ], 
     [ 7 ], [ -7 ]>, <bipartition: [ 1, 4, -1, -6 ], [ 2, 7, 8, -2, -4 ], 
     [ 3, 5, 6 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 7, 8, -1, -3, -6, -7 ], [ 3, 5, 6 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -7 ], [ 2, 7, 8, -4, -6, -8 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -4, -8 ], [ 2, 7, 8, -1, -2, -3, -5, -6 ], 
     [ 3, 5, 6 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4, -8 ], [ 3, -1, -2, -3, -5, -6 ], 
     [ 6, 8 ], [ -7 ]>, 
  <bipartition: [ 1, 4, -1, -2, -3, -5, -6 ], [ 2, 3, 5, 6, 7, 8, -4, -8 ], 
     [ -7 ]>, <bipartition: [ 1, 4, -4 ], [ 2, 7, 8, -1, -6, -7 ], 
     [ 3, 5, 6 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -1, -2, -3, -5, -6 ], [ 2, 7, 8, -4, -8 ], 
     [ 3, 5, 6 ], [ -7 ]> ]
gap> RClassReps(S);
[ <bipartition: [ 1, 2, 3, 4, 5, -2, -4 ], [ 6, 7 ], [ 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -2 ], [ 5, 6, -5 ], [ 7, 8, -4, -6 ], 
     [ -3, -7 ], [ -8 ]>, <bipartition: [ 1, 2, 3, 7, -7 ], [ 4, 5, 6, 8 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -2, -4 ], [ 3, -7 ], [ 5, -5 ], [ 6, 8 ], 
     [ -3 ], [ -6, -8 ]>, <bipartition: [ 1, 2, 8, -2 ], [ 3, 4, 5, -5 ], 
     [ 6, 7, -4 ], [ -1, -7 ], [ -3, -6, -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -5 ], [ 4 ], [ -1, -2, -3, -6 ]
      , [ -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -5 ], [ 2, -4 ], [ 7, -3, -8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, -1, -7 ], [ 2, -6 ], [ 6 ], 
     [ 7, -3 ], [ 8, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -1, -7, -8 ], [ 2, 5, 8, -6 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 3, 4, -8 ], [ 2, 6, 8, -1 ], 
     [ 5, 7, -2, -3, -4, -7 ], [ -5 ], [ -6 ]>, 
  <bipartition: [ 1, 4, 8, -4, -6, -8 ], [ 2, 3, 6, -3, -5 ], [ 5, -1, -7 ], 
     [ 7 ], [ -2 ]>, <bipartition: [ 1, 5, -1, -7, -8 ], [ 2, 3, 4, 6, 7 ], 
     [ 8, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, -6 ], [ 2, 3, 4, -2, -8 ], [ 5, 6, 7, -1, -3 ], [ 8 ], 
     [ -4, -7 ], [ -5 ]>, 
  <bipartition: [ 1, 7, 8, -1, -3, -4, -6 ], [ 2, 3, 4 ], [ 5, -2, -5 ], 
     [ 6 ], [ -7, -8 ]>, <bipartition: [ 1, 8, -3, -5, -6 ], [ 2, 3, 4, -1 ], 
     [ 5, -2 ], [ 6, 7 ], [ -4, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 7, 8, -5 ], [ 2, 3, 5, -6 ], [ 4 ], [ 6, -1, -3 ], 
     [ -2 ], [ -4, -7, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -4 ], [ 2, 7, 8, -2, -6 ], [ 3, 5, 6, -8 ], 
     [ -5, -7 ]>, <bipartition: [ 1, 5, 8 ], [ 2, 4, 7, -7 ], [ 3, 6 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -5 ], [ 5, 7, -3, -4, -6 ], 
     [ 8, -2 ], [ -1, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, -8 ], [ 2, -4 ], [ 3, 6, 8, -1, -6 ], 
     [ 4, 7, -2, -3, -5 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -7 ], [ 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, 7, 8, -7 ], [ -1, -2 ], [ -3, -6, -8 ], 
     [ -4 ], [ -5 ]>, <bipartition: [ 1, 2, 4, 5, 7, -2, -4 ], [ 3, -1, -6 ], 
     [ 6, 8 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 5, 6, 7, 8, -7 ], [ 4 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 7, 8, -7 ], [ 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, -1, -6 ], [ 2, 5, 6, 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, 8, -7 ], [ 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, 8, -7 ], [ 2, 3, 4, 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, 7, -7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, 7, 8, -7 ], [ 2, 3, 4 ], [ 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -2, -4 ], [ 3, 5, 6, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, -1, -6 ], [ 2, 3, 4, 6, 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -6 ], [ 3, 5, -1, -7, -8 ], [ 6, 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, -1, -7, -8 ], [ 2, 3, 4, 5, 6, 7, -6 ], [ 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -7, -8 ], 
     [ 4 ], [ 6, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 5, -6 ], [ 2, 3, 4, 6, 7, 8, -1, -7, -8 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 2, 3, 4, -7 ], [ 5, 6, 7, 8 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 7, -7 ], [ 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -7, -8 ], [ 5, 6, -6 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 2, 3, 4, 7, -1, -7, -8 ], [ 5, -6 ], 
     [ 6, 8 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -1, -7, -8 ], [ 3, 4, 5, -6 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -7, -8 ], [ 3, 8, -6 ], 
     [ 4 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -6, -7 ], [ 6 ], [ 7, -3 ], 
     [ -2, -5, -8 ], [ -4 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 5, 6, 7, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -7, -8 ], [ 2, 3, 6, -6 ], [ 7 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 8, -6 ], [ 2, 3, 4, 5, -1, -7, -8 ], [ 6, 7 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 7, 8, -6 ], [ 2, 3, 5, 6, -1, -7, -8 ], [ 4 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -6 ], [ 5, 7, 8, -1, -7, -8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, -6 ], [ 5, 6, 7, 8, -1, -7, -8 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 2, 5, 6, 7 ], [ 3, 8, -7 ], [ 4 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -5 ], [ -1, -2, -3, -6 ]
      , [ -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 7, -7 ], [ 6 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, -7 ], [ 2, 3, 4, 6, 7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -7 ], [ 2 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -4, -5 ], [ 3, -3, -8 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 8, -4 ], [ 3, 4, 5, 6, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 3, 4, 8, -1, -3, -5, -8 ], 
     [ 5, -4 ], [ 6, 7 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -3, -5, -8 ], [ 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -6, -7 ], [ 3, -3 ], 
     [ 6, 8 ], [ -2, -5, -8 ], [ -4 ]>, 
  <bipartition: [ 1, 2, 8, -6 ], [ 3, 4, 5, 6, 7, -1, -7, -8 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 3, 4, 5, 7, 8, -7 ], [ 2 ], [ 6 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -7 ], [ 2, 5, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 5, 6, 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -6 ], [ 5, 6, 7, -1, -7, -8 ], [ 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -1, -7, -8 ], [ 5, -6 ], [ 6, 7 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 6, 7, 8, -7 ], [ 2, 3, 5 ], [ 4 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, -1, -3, -7 ], [ 2, 7, 8, -6 ], [ 3, 5, 6, -4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -7, -8 ], [ 8, -6 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 5, -4 ], [ 2, 3, 4, 6, 7, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -7, -8 ], [ 2, 3, 4, -6 ], [ 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -6 ], 
     [ 5, 7, -1, -7, -8 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -7, -8 ], [ 5, 6, 7, -6 ], [ 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 4, -8 ], [ 2, 3, 5, 6, 7, 8, -1 ], [ -2, -3, -4, -7 ], 
     [ -5 ], [ -6 ]>, <bipartition: [ 1, 2, 3, 4, 7, 8, -3, -4, -5, -6, -8 ], 
     [ 5, 6, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 7 ], [ 4, 5, 6, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -3, -4, -5, -6, -8 ], [ 3 ], [ 5, -1, -7 ], 
     [ 6, 8 ], [ -2 ]>, <bipartition: [ 1, 2, 6, 7, 8, -3, -4, -5, -6, -8 ], 
     [ 3, 4, 5, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -3, -4, -5, -6, -8 ], [ 3, 8, -1, -7 ], 
     [ 4 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 8, -1, -3, -5, -7 ], [ 2, 3, 4, -4, -6, -8 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 7, 8, -1, -7 ], [ 2, 3, 5, 6, -3, -4, -5, -6, -8 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -7 ], 
     [ 5, 7, 8, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7, -8 ], [ 2, 7, -6 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 3, 4, -6 ], [ 2, 6, 8, -1, -7, -8 ], 
     [ 5, 7 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -1, -7, -8 ], [ 3, 5, 6, -6 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -7, -8 ], 
     [ 5, 7, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 5, 8, -6 ], [ 2, 3, 4, -1, -7, -8 ], [ 6, 7 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -7 ], [ 3, 5, 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5 ], [ 2, 3, 4, 6, 7, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -3, -4, -6 ], [ 5, 6, -2, -5 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 4, 7, -1, -3, -4, -6 ], 
     [ 5, -2, -5 ], [ 6, 8 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -1, -3, -4, -6 ], [ 3, 4, 5, -2, -5 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -4, -6 ], 
     [ 3, 8, -2, -5 ], [ 4 ], [ -7, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, 5, 6, 7, -7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 7, 8, -2, -5 ], [ 2, 3, 5 ], [ 4 ], [ 6, -1, -3, -4, -6 ]
      , [ -7, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -7 ], [ 5, 7, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -4, -6 ], [ 2, 4, 7, -2, -5 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -7, -8 ], 
     [ 5, 7, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -6 ], [ 2, 4, 7, -1, -7, -8 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -7, -8 ], 
     [ 7, 8, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -7, -8 ], [ 2, -6 ], [ 6 ], [ 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -7, -8 ], [ 2, 3, 5, -6 ], [ 4 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -7, -8 ], [ 2 ], [ 4, 7, -6 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -7 ], [ 2, 7 ], [ 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8 ], [ 5, 7, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8 ], [ 5, -7 ], [ 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5 ], [ 6, 7 ], [ 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 7 ], [ 3, 5, -7 ], [ 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8 ], [ 3, 4, 5, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -6 ], [ 2, 7, -1, -7, -8 ], [ 6 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 4, -6 ], [ 2, 6, 8 ], [ 5, 7, -1, -7, -8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 5, 8 ], [ 2, 3, 4, 6, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5, 8, -7 ], [ 2, 3, 4 ], [ 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -4, -8 ], [ 7, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -7, -8 ], [ 2, 6, 8, -6 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -7, -8 ], [ 2, -6 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -2, -4 ], [ 6 ], 
     [ 7, -1, -6 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -1, -6 ], [ 2, 3, 5, 6, 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -7 ], [ 3 ], [ 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -7 ], [ 5, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -2, -4 ], [ 2, 5, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 8, -1, -6 ], [ 2, 3, 4, 5, -2, -4 ], [ 6, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -7 ], [ 2, 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6 ], [ 2, 7, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -2, -4 ], [ 2, 6, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -7 ], [ 3, 5 ], [ 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7, -8 ], [ 2 ], [ 7, -6 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 4 ], [ 2, 3, 5, 6, 7, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8 ], [ 2 ], [ 7, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -5 ], [ 6, 8 ], [ -1, -2, -3, -6 ]
      , [ -7 ], [ -8 ]>, <bipartition: [ 1, 2, 8 ], [ 3, 4, 5, 6, 7, -7 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -7 ], [ 5 ], [ 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, 8 ], [ 2, 4, 7 ], [ 3, 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -7 ], [ 2, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -7 ], [ 5, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -4, -5 ], [ 6 ], [ 7, -3, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4 ], [ 5, 6, 7, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, -4 ], [ 2, 3, 4, 6, 7 ], [ 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 8, -1, -3, -5, -8 ], [ 2, 3, 4, 5, -4 ], [ 6, 7 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -3, -5, -8 ], 
     [ 5, 6, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -1, -3, -5, -8 ], [ 5, -4 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 6, 7, 8, -1, -3, -5, -8 ], 
     [ 3, 4, 5, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -5, -8 ], [ 3, 8, -4 ], [ 4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 7, 8, -4 ], [ 2, 3, 5, 6, -1, -3, -5, -8 ], [ 4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -4 ], [ 5, 7, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 6, 8 ], [ 5, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 4, 7, 8, -1, -3, -5, -8 ], 
     [ 3, 5, 6, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, -4 ], [ 2, 3, 4, 6, 7, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, -7 ], [ 2, 7, 8 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, 6, 7, -7 ], [ 2, 3, 4 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8 ], [ 5, 7, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8 ], [ 5, 7, -7 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, 5, 8, -7 ], [ 2, 3, 6 ], [ 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -7 ], [ 2 ], [ 4, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -1, -3, -6, -7 ], [ 2, 5, 8, -4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 8, -4 ], [ 2, 3, 4, 5, -1, -3, -6, -7 ], [ 6, 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -6, -7 ], [ 2, 6, 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, -1, -7 ], [ 2, 3, 4, 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ 8 ], [ -2 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -7 ], [ 4 ], 
     [ 6, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8 ], [ 6, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4 ], [ 5, 6, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 7 ], [ 6, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 5, 6, 7, 8 ], [ 4 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 7, 8 ], [ 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, 8 ], [ 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, 7 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5, 7, 8 ], [ 2, 3, 4 ], [ 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -3, -4, -5, -6, -8 ], [ 5, -1, -7 ], 
     [ 6, 8 ], [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -7 ], [ 6 ], [ 7 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, 5, 8, -3, -4, -5, -6, -8 ], [ 2, 3, 6, -1, -7 ], 
     [ 7 ], [ -2 ]>, 
  <bipartition: [ 1, 8, -1, -7 ], [ 2, 3, 4, 5, -3, -4, -5, -6, -8 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 5, -3, -4, -5, -6, -8 ], [ 2, 3, 4, 6, 7 ], 
     [ 8, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -3, -4, -5, -6, -8 ], [ 2 ], 
     [ 7, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -3, -5, -7 ], [ 5, 7, -4, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -1, -7 ], [ 2, 5, 8, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 5, 8, -3, -4, -5, -6, -8 ], [ 2, 3, 4, -1, -7 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -7 ], [ 3, 8, -3, -4, -5, -6, -8 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 8, -3, -4, -5, -6, -8 ], 
     [ 2, 7, -1, -7 ], [ 6 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -7 ], [ 2, 3, 4, -3, -4, -5, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 7, 8, -3, -4, -5, -6, -8 ], [ 2, 3, 5, 6, -1, -7 ], 
     [ 4 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -1, -7 ], [ 3, 5, 6, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -3, -4, -5, -6, -8 ], 
     [ 5, 7, 8, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -7 ], [ 3, 8 ], [ 4 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, -6 ], [ 2, 3, 5, 6, 7, 8, -1, -7, -8 ], [ -2, -4 ], 
     [ -3, -5 ]>, <bipartition: [ 1, 8 ], [ 2, 3, 4, 5, -7 ], [ 6, 7 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8 ], [ 2, 7, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, -2, -5 ], [ 2, 3, 4, 5, 6, 7, -1, -3, -4, -6 ], [ 8 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -2, -5 ], [ 4 ], 
     [ 6, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 7, 8, -2, -5 ], [ 2, 3, 5, 6, -1, -3, -4, -6 ], [ 4 ], 
     [ -7, -8 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -2, -5 ], 
     [ 5, 7, 8, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 5, -1, -3, -4, -6 ], [ 2, 3, 4, 6, 7 ], [ 8, -2, -5 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -4, -6 ], [ 2 ], 
     [ 7, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -2, -5 ], [ 7, 8, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -2, -5 ], [ 2, -1, -3, -4, -6 ], [ 6 ], 
     [ 8 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -2, -5 ], [ 2, 5, 8, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, -1, -3, -4, -6 ], [ 2, 3, 4, 5, 6, 7, -2, -5 ], [ 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 5, 8, -1, -3, -4, -6 ], [ 2, 3, 4, -2, -5 ], [ 6, 7 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 6, 7, 8, -2, -5 ], [ 2, 3, 5, -1, -3, -4, -6 ], [ 4 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 8 ], [ 2, 7, -7 ], [ 6 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 7, 8 ], [ 2, 3, 5, 6, -7 ], [ 4 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6 ], [ 5, 7, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -1, -3, -4, -6 ], [ 5, -2, -5 ], [ 6, 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 4, -1, -7, -8 ], [ 2, 7, 8, -6 ], 
     [ 3, 5, 6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8 ], [ 5, 6, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7 ], [ 5, -7 ], [ 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 7, 8, -7 ], [ 2, 3, 5, 6 ], [ 4 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7 ], [ 3, -7 ], [ 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, -7 ], [ 2, 5, 6, 7, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8 ], [ 3, 5, 6, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, -7 ], [ 2, 3, 4, 6, 7, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, 5, 8 ], [ 2, 3, 6, -7 ], [ 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 8, -7 ], [ 2, 3, 4, 5 ], [ 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5 ], [ 2, 3, 4, 6, 7 ], [ 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4 ], [ 5, 6, 7, -7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, -7 ], [ 2, 3, 5, 6, 7, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8 ], [ 5, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5, -1, -2, -3, -5, -6 ], [ 2, 3, 4, 6, 7, 8, -4, -8 ], 
     [ -7 ]>, <bipartition: [ 1, 5, 6, 7, -2, -4 ], [ 2, 3, 4, -1, -6 ], 
     [ 8 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -6 ], [ 5, 7, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -6 ], [ 5, 7, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, 8, -2, -4 ], [ 2, 3, 4, -1, -6 ], [ 6, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -6 ], [ 2, 4, 7, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -6 ], [ 5, 6, 7, -2, -4 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -2, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -7 ], [ 5 ], [ 6, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -7 ], [ 3, 4, 5 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -7, -8 ], [ 3, -6 ], [ 6, 8 ], 
     [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -4 ], [ 6 ], [ 7, -5 ], [ -1, -2, -3, -6 ]
      , [ -7 ], [ -8 ]>, <bipartition: [ 1, 2, 3, 4 ], [ 5, 6, 7, 8, -7 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -7 ], [ 5, 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8 ], [ 2, 7 ], [ 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8 ], [ 5 ], [ 6, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -7 ], [ 5, 6, 7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, -4 ], [ 3, 5, -1, -3, -5, -8 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, -1, -3, -5, -8 ], [ 2, 6, 8, -4 ], [ 5, 7 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -4 ], [ 3, 5, 6, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, -1, -3, -5, -8 ], [ 2, 3, 4, 6, 7, 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -3, -5, -8 ], 
     [ 5, 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, 8, -4 ], [ 2, 3, 4, -1, -3, -5, -8 ], [ 6, 7 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -5, -8 ], 
     [ 2, 4, 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, -4 ], [ 2, 3, 4, 5, 6, 7, -1, -3, -5, -8 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -4 ], [ 4 ], [ 6, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, -1, -3, -5, -8 ], [ 2, 3, 4, 6, 7 ], [ 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -8 ], 
     [ 2 ], [ 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -4 ], [ 2, 5, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, 8, -1, -3, -5, -8 ], [ 2, 3, 4, -4 ], [ 6, 7 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -1, -3, -5, -8 ], [ 4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -5, -8 ], 
     [ 2, 7, -4 ], [ 6 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4 ], [ 2, 3, 4, -1, -3, -5, -8 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 7, 8, -1, -3, -5, -8 ], [ 2, 3, 5, 6, -4 ], [ 4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -3, -5, -8 ], [ 5, 7, 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 6, 7, -1, -3, -5, -8 ], 
     [ 2, 5, 8, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 8, -4 ], [ 2, 3, 4, 5, -1, -3, -5, -8 ], [ 6, 7 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -5, -8 ], 
     [ 2, 6, 8, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4 ], [ 2, 3, 5, 6, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -6, -7 ], [ 2, 3, 4, -4 ], [ 8 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -4 ], 
     [ 5, 7, -1, -3, -6, -7 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -4 ], [ 5, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, 8, -1, -3, -6, -7 ], [ 2, 3, 4, -4 ], [ 6, 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4 ], [ 2, 4, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4 ], [ 5, 6, 7, -1, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -1, -6, -7 ], [ 2, 3, 5, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -7 ], 
     [ 5, 7, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -7 ], [ 7, 8, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -7 ], [ 2, -3, -4, -5, -6, -8 ], [ 6 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, -3, -4, -5, -6, -8 ], [ 2, 3, 4, 5, 6, 7, -1, -7 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -7 ], [ 2, 3, 5, -3, -4, -5, -6, -8 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 2, 4, 7 ], [ 3, 5 ], [ 6, 8 ], 
     [ -1, -7 ], [ -2 ], [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 5, 6, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7 ], [ 3, 8 ], [ 4 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8 ], [ 2 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 7 ], [ 6 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5 ], [ 2, 3, 4, 6, 7 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, 8 ], [ 2 ], [ 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7 ], [ 2, 5, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, 5, 6, 7 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 6, 7, 8 ], [ 2, 3, 5 ], [ 4 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7 ], [ 3 ], [ 6, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8 ], [ 3, 5, 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5 ], [ 2, 3, 4, 6, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6 ], [ 5, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5 ], [ 6, 7 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8 ], [ 3, 4, 5 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7 ], [ 2, 6, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5, 8 ], [ 2, 3, 4 ], [ 6, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -7 ], [ 5, 7, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -7 ], [ 2, 4, 7, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -3, -4, -5, -6, -8 ], 
     [ 2, 7, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, -1, -7 ], [ 2, 6, 8, -3, -4, -5, -6, -8 ], 
     [ 5, 7 ], [ -2 ]>, <bipartition: [ 1, 2, 4, 7, 8, -3, -4, -5, -6, -8 ], 
     [ 3, 5, 6, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 5, -1, -7 ], [ 2, 3, 4, 6, 7, 8, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 4, 5, 7, -3, -4, -5, -6, -8 ], 
     [ 3, -1, -7 ], [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -3, -5, -7 ], [ 3, 5, -4, -6, -8 ], 
     [ 6, 8 ], [ -2 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -5, -7 ], 
     [ 3, 8, -4, -6, -8 ], [ 4 ], [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -3, -4, -5, -6, -8 ], 
     [ 5, 7, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -3, -4, -5, -6, -8 ], [ 5, 7, -1, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7 ], [ 2 ], 
     [ 7, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -3, -4, -5, -6, -8 ], [ 2, 5, 8, -1, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 5, 8, -1, -7 ], [ 2, 3, 4, -3, -4, -5, -6, -8 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 8, -3, -4, -5, -6, -8 ], [ 2, 3, 4, 5, -1, -7 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -1, -7 ], [ 2, 7, -3, -4, -5, -6, -8 ], 
     [ 6 ], [ -2 ]>, <bipartition: [ 1, 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ 2, 3, 4, -1, -7 ], [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -7 ], [ 2 ], [ 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8 ], [ 2, 4, 7, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -2, -5 ], [ 5, 7, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -2, -5 ], [ 3, 8, -1, -3, -4, -6 ], [ 4 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -4, -6 ], 
     [ 2, 7, -2, -5 ], [ 6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -2, -5 ], [ 2, 3, 4, -1, -3, -4, -6 ], [ 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 7, 8, -1, -3, -4, -6 ], [ 2, 3, 5, 6, -2, -5 ], [ 4 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -2, -5 ], [ 3, 5, 6, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -3, -4, -6 ], 
     [ 5, 7, 8, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -4, -6 ], [ 2, 7, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, -2, -5 ], [ 2, 6, 8, -1, -3, -4, -6 ], [ 5, 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 4, 7, 8, -1, -3, -4, -6 ], 
     [ 3, 5, 6, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 5, -2, -5 ], [ 2, 3, 4, 6, 7, 8, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -4, -6 ], 
     [ 3, -2, -5 ], [ 6, 8 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 5, -1, -3, -4, -6 ], [ 2, 3, 4, 6, 7, 8, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 8, -1, -3, -4, -6 ], [ 3, 4, 5, 6, 7, -2, -5 ], 
     [ -7, -8 ]>, <bipartition: [ 1 ], [ 2, 3, 4, -1, -3, -4, -6 ], 
     [ 5, 6, 7, -2, -5 ], [ 8 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -2, -5 ], [ 5, -1, -3, -4, -6 ], [ 6, 7 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -2, -5 ], [ 2, 7, 8, -1, -3, -4, -6 ], [ 3, 5, 6 ], 
     [ -7, -8 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -2, -5 ], 
     [ 8, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -3, -4, -6 ], [ 5, 7, -2, -5 ]
      , [ -7, -8 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -3, -4, -6 ], 
     [ 5, 7, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 5, 8, -2, -5 ], [ 2, 3, 4, -1, -3, -4, -6 ], [ 6, 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -3, -4, -6 ], 
     [ 5, 7, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -2, -5 ], [ 2, 3, 6, -1, -3, -4, -6 ], [ 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 5, 6, 8, -2, -5 ], [ 2 ], 
     [ 4, 7, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7 ], [ 2, 5, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, 6, 7 ], [ 2, 3, 4, -7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, -7 ], [ 2, 3, 4, 5, 6, 7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -7 ], [ 4 ], [ 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 5, 8 ], [ 2, 3, 4, -7 ], [ 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8 ], [ 6 ], [ 7, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7 ], [ 2, 6, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -7 ], [ 2, 4, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, -7 ], [ 2, 6, 8 ], [ 5, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -2, -3, -5, -6 ], [ 2, 7, -4, -8 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4, -8 ], [ 2, 6, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -6 ], [ 3, 8, -2, -4 ], 
     [ 4 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -2, -4 ], [ 5, 7, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -6 ], [ 3, 5, -2, -4 ], [ 6, 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -2, -4 ], [ 5, 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -1, -6 ], [ 5, -2, -4 ], [ 6, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -7, -8 ], 
     [ 6 ], [ 7, -6 ], [ -2, -4 ], [ -3, -5 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8 ], [ 4 ], [ 6, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8 ], [ 5, 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7 ], [ 5 ], [ 6, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 7, 8 ], [ 2, 3, 5, 6 ], [ 4 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -4 ], [ 5, -1, -3, -5, -8 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -4 ], [ 3, 4, 5, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4 ], [ 2, 3, 6, -1, -3, -5, -8 ], [ 7 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4 ], [ 5, 6, 7, -1, -3, -5, -8 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -8 ], [ 2, 3, 5, 6, 7, 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -8 ], 
     [ 2, 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4 ], [ 2, 6, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -3, -5, -8 ], [ 3, 5, -4 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -4 ], [ 5, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -4 ], [ 5, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -4 ], [ 7, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4 ], [ 2, -1, -3, -5, -8 ], [ 6 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, -1, -3, -5, -8 ], [ 2, 3, 4, 5, 6, 7, -4 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 6, 7, 8, -4 ], [ 2, 3, 5, -1, -3, -5, -8 ], [ 4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 6, 8, -1, -3, -5, -8 ], [ 5, 7 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -5, -8 ], 
     [ 3, -4 ], [ 6, 8 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -3, -5, -8 ], [ 5, 7, -4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4 ], [ 2, 7, -1, -3, -5, -8 ], [ 6 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -5, -8 ], [ 2, 3, 4, -4 ], [ 8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -4 ], 
     [ 5, 7, -1, -3, -5, -8 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4 ], [ 2, 4, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -1, -3, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -3, -6, -7 ], [ 5, 7, 8, -4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -4 ], [ 3, 5, -1, -3, -6, -7 ], [ 6, 8 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -3, -6, -7 ], 
     [ 5, 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -4 ], [ 5, -1, -3, -6, -7 ], [ 6, 7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 4, 7, -4 ], [ 3, 5, -1, -6, -7 ], 
     [ 6, 8 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -7 ], [ 3, 5, -3, -4, -5, -6, -8 ], 
     [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -7 ], [ 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 5, -3, -4, -5, -6, -8 ], [ 2, 3, 4, 6, 7, 8, -1, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 2, 8, -3, -4, -5, -6, -8 ], [ 3, 4, 5, 6, 7, -1, -7 ], 
     [ -2 ]>, <bipartition: [ 1 ], [ 2, 3, 4, -3, -4, -5, -6, -8 ], 
     [ 5, 6, 7, -1, -7 ], [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -1, -7 ], [ 5, -3, -4, -5, -6, -8 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -1, -7 ], [ 2, 7, 8, -3, -4, -5, -6, -8 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -7 ], 
     [ 8, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -3, -4, -5, -6, -8 ], [ 5, 7, -1, -7 ]
      , [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -7 ], [ 2, 3, 6, -3, -4, -5, -6, -8 ], 
     [ 7 ], [ -2 ]>, <bipartition: [ 1, 3, 5, 6, 8, -1, -7 ], [ 2 ], 
     [ 4, 7, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8 ], [ 2, 3, 6 ], [ 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 8 ], [ 2, 3, 4, 5 ], [ 6, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8 ], [ 2 ], [ 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 8 ], [ 3, 4, 5, 6, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8 ], [ 2, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8 ], [ 5, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6 ], [ 2, 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7 ], [ 2, 3, 4 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8 ], [ 5, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8 ], [ 2 ], [ 4, 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8 ], [ 6 ], [ 7 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4 ], [ 5, 6, 7 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -3, -4, -5, -6, -8 ], [ 5, 6, 7, -1, -7 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -1, -7 ], [ 2, 3, 5, 6, 7, 8, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -7 ], [ 2, 7, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 7, -3, -4, -5, -6, -8 ], 
     [ 2, 6, 8, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -3, -4, -5, -6, -8 ], [ 6 ], 
     [ 7, -1, -7 ], [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 7, -1, -3, -5, -7 ], 
     [ 5, -4, -6, -8 ], [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -1, -3, -5, -7 ], [ 3, 4, 5, -4, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -5, -7 ], [ 2, 3, 6, -4, -6, -8 ], 
     [ 7 ], [ -2 ]>, 
  <bipartition: [ 1, 8, -4, -6, -8 ], [ 2, 3, 4, 5, -1, -3, -5, -7 ], 
     [ 6, 7 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -7 ], 
     [ 2 ], [ 7, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 7, -3, -4, -5, -6, -8 ], [ 3, 5, -1, -7 ], 
     [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -7 ], [ 3, -3, -4, -5, -6, -8 ], 
     [ 6, 8 ], [ -2 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -7 ], 
     [ 5, 7, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -3, -4, -5, -6, -8 ], [ 2, 4, 7, -1, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 4, 7, -2, -5 ], [ 3, 5, -1, -3, -4, -6 ], 
     [ 6, 8 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -2, -5 ], [ 5, 6, 7, -1, -3, -4, -6 ], [ 8 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -5 ], [ 2 ], 
     [ 7, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -1, -3, -4, -6 ], [ 2, 5, 8, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 8, -1, -3, -4, -6 ], [ 2, 3, 4, 5, -2, -5 ], [ 6, 7 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -2, -5 ], [ 2, 7, -1, -3, -4, -6 ], [ 6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -4, -6 ], [ 2, 3, 4, -2, -5 ], [ 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -4, -6 ], [ 5, 6, 7, -2, -5 ], [ 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -2, -5 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 8, -2, -5 ], [ 2, 3, 4, 5, -1, -3, -4, -6 ], [ 6, 7 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -5 ], [ 2, 7, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -4, -6 ], 
     [ 2, 6, 8, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -3, -4, -6 ], [ 6 ], [ 7, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -2, -5 ], [ 2, 6, 8, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -4, -6 ], [ 5, 6, 7, 8, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -3, -4, -6 ], [ 3, 5, -2, -5 ], [ 6, 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -2, -5 ], [ 5, 6, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -2, -5 ], [ 5, -1, -3, -4, -6 ], [ 6, 8 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -2, -5 ], [ 3, 4, 5, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, -1, -3, -4, -6 ], [ 2, 6, 8 ], 
     [ 5, 7, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -2, -5 ], [ 5, 7, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 5, -2, -5 ], [ 2, 3, 4, 6, 7 ], 
     [ 8, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -2, -5 ], [ 2, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -7 ], [ 5, 7 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -7 ], [ 7, 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -7 ], [ 2 ], [ 6 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -2, -3, -5, -6 ], [ 5, 6, 7, -4, -8 ], 
     [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 4, -4, -8 ], [ 2, 3, 5, 6, 7, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6 ], [ 2 ], 
     [ 7, -2, -4 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -2, -4 ], [ 3, 8, -1, -6 ], [ 4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -1, -6 ], [ 2, 7, -2, -4 ], [ 6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 7, 8, -1, -6 ], [ 2, 3, 5, 6, -2, -4 ], [ 4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -6 ], [ 5, 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -1, -6 ], [ 5, -2, -4 ], [ 6, 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -1, -6 ], [ 3, 4, 5, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -6 ], [ 2, 3, 6, -2, -4 ], [ 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 8, -2, -4 ], [ 2, 3, 4, 5, -1, -6 ], [ 6, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -2, -4 ], [ 3, 5, -1, -6 ], [ 6, 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -6 ], [ 5, 6, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 7, 8, -2, -4 ], [ 2, 3, 5, 6, -1, -6 ], [ 4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6 ], [ 7, 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7 ], [ 2, -7 ], [ 6 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 6, 7, 8 ], [ 2, 3, 5, -7 ], [ 4 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8 ], [ 4 ], [ 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -4 ], [ 5, 6, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -5, -8 ], [ 5, 6, 7, -4 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -5, -8 ], [ 2, 3, 6, -4 ], [ 7 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 8, -1, -3, -5, -8 ], [ 3, 4, 5, 6, 7, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1 ], [ 2, 3, 4, -1, -3, -5, -8 ], 
     [ 5, 6, 7, -4 ], [ 8 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -4 ], [ 5, -1, -3, -5, -8 ], [ 6, 7 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 7, 8, -1, -3, -5, -8 ], [ 3, 5, 6 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -4 ], 
     [ 8, -1, -3, -5, -8 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -3, -5, -8 ], [ 5, 7, -4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4 ], [ 2 ], [ 4, 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -3, -5, -8 ], 
     [ 6 ], [ 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -1, -3, -5, -8 ], [ 6, 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 5, 6, 7, -1, -3, -6, -7 ], 
     [ 3, 8, -4 ], [ 4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4 ], [ 2, 7, -1, -3, -6, -7 ], [ 6 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 7, 8, -4 ], [ 2, 3, 5, 6, -1, -3, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 4, 7, 8, -1, -3, -6, -7 ], 
     [ 3, 5, 6, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -4 ], [ 5, 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -4 ], [ 5, -1, -3, -6, -7 ], [ 6, 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -4 ], [ 3, 4, 5, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4 ], [ 2, 3, 6, -1, -3, -6, -7 ], [ 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 8, -1, -3, -6, -7 ], [ 2, 3, 4, 5, -4 ], [ 6, 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -3, -6, -7 ], [ 3, 5, -4 ], [ 6, 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -4 ], [ 5, 6, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 7, 8, -1, -3, -6, -7 ], [ 2, 3, 5, 6, -4 ], [ 4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 3, 4, 7, -4 ], [ 5, -1, -6, -7 ], 
     [ 6, 8 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -4 ], [ 3, 4, 5, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4 ], [ 2, 3, 6, -1, -6, -7 ], [ 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 8, -1, -6, -7 ], [ 2, 3, 4, 5, -4 ], [ 6, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -1, -7 ], [ 5, -3, -4, -5, -6, -8 ], 
     [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -1, -7 ], [ 3, 4, 5, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -7 ], [ 2, 6, 8, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 3, 4, -3, -4, -5, -6, -8 ], 
     [ 5, 6, 7, 8, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -7 ], [ 5, 6, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, -3, -4, -5, -6, -8 ], [ 2, 6, 8 ], 
     [ 5, 7, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 5, -1, -7 ], [ 2, 3, 4, 6, 7 ], [ 8, -3, -4, -5, -6, -8 ]
      , [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -7 ], [ 2, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 5, 6, 8 ], [ 2, 4, 7 ], [ -1, -7 ], 
     [ -2 ], [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 4, -3, -4, -5, -6, -8 ], [ 2, 3, 5, 6, 7, 8, -1, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -3, -5, -7 ], 
     [ 5, 6, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 7, 8, -4, -6, -8 ], [ 2, 3, 5, 6, -1, -3, -5, -7 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -4, -6, -8 ], 
     [ 5, 7, 8, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 5, -1, -3, -5, -7 ], [ 2, 3, 4, 6, 7 ], [ 8, -4, -6, -8 ]
      , [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 6, 8, -4, -6, -8 ], 
     [ 5, 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4, -6, -8 ], [ 2, 4, 7, -1, -3, -5, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -5, -7 ], 
     [ 3, -4, -6, -8 ], [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -7 ], [ 6 ], [ 7, -3, -4, -5, -6, -8 ]
      , [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 8, -3, -4, -5, -6, -8 ], 
     [ 5, -1, -7 ], [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -2, -5 ], [ 3, -1, -3, -4, -6 ], [ 6, 8 ], 
     [ -7, -8 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -2, -5 ], 
     [ 5, 7, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -2, -5 ], [ 2, 4, 7, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -4, -6 ], [ 2, 3, 5, 6, 7, 8, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -4, -6 ], [ 2, 3, 6, -2, -5 ], [ 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -3, -4, -6 ], [ 4 ], 
     [ 6, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, -1, -3, -4, -6 ], [ 2, 6, 8, -2, -5 ], [ 5, 7 ], 
     [ -7, -8 ]>, <bipartition: [ 1 ], [ 2, 3, 4 ], [ 5, 6, 7, -7 ], [ 8 ], 
     [ -1, -2 ], [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4, -7 ], [ 2, 7, 8 ], [ 3, 5, 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -2, -3, -5, -6 ], [ 3, 5, -4, -8 ], 
     [ 6, 8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -6 ], [ 3, -2, -4 ], [ 6, 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -4 ], [ 2 ], [ 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -1, -6 ], [ 2, 5, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -2, -4 ], [ 2, 7, -1, -6 ], [ 6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -6 ], [ 2, 3, 4, -2, -4 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -1, -6 ], [ 3, 5, 6, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, -1, -6 ], [ 2, 3, 4, 6, 7 ], [ 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, 8, -1, -6 ], [ 2, 3, 4, -2, -4 ], [ 6, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -2, -4 ], [ 2, 4, 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -2, -4 ], [ 5, -1, -6 ], [ 6, 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -2, -4 ], [ 3, 4, 5, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -2, -4 ], [ 2, 3, 6, -1, -6 ], [ 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, -2, -4 ], [ 2, 3, 4, 5, 6, 7, -1, -6 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -2, -4 ], [ 4 ], [ 6, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 8, -7 ], [ 3, 4, 5, 6, 7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -7 ], [ 5, 6, 7 ], [ 8 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 4 ], [ 2, 7, 8, -7 ], [ 3, 5, 6 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7 ], [ 8, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8 ], [ 2 ], [ 4, 7, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6 ], [ 7, 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7 ], [ 2 ], [ 6 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -3, -5, -8 ], [ 4 ], [ 6, -4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -5, -8 ], [ 5, 6, 7, 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, -1, -3, -5, -8 ], [ 2, 6, 8 ], 
     [ 5, 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -4 ], [ 2, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -4 ], [ 6 ], [ 7, -1, -3, -5, -8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -1, -3, -6, -7 ], [ 6, 8 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -6, -7 ], 
     [ 2 ], [ 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -4 ], [ 2, 5, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -6, -7 ], 
     [ 2, 7, -4 ], [ 6 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4 ], [ 2, 3, 4, -1, -3, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -4 ], [ 3, 5, 6, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, -4 ], [ 2, 3, 4, 6, 7 ], [ 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, 8, -4 ], [ 2, 3, 4, -1, -3, -6, -7 ], [ 6, 7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -6, -7 ], 
     [ 2, 4, 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -1, -3, -6, -7 ], [ 5, -4 ], [ 6, 8 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 6, 7, 8, -1, -3, -6, -7 ], 
     [ 3, 4, 5, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -3, -6, -7 ], [ 2, 3, 6, -4 ], [ 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, -1, -3, -6, -7 ], [ 2, 3, 4, 5, 6, 7, -4 ], [ 8 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -3, -6, -7 ], 
     [ 4 ], [ 6, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -4 ], [ 5, 6, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4 ], [ 3, 8, -1, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 7, 8, -1, -6, -7 ], [ 2, 3, 5, 6, -4 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -6, -7 ], [ 5, 7, 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, -4 ], [ 2, 3, 4, 6, 7 ], [ 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -6, -7 ], 
     [ 5, 7, -4 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 8, -4 ], [ 2, 3, 4, -1, -6, -7 ], [ 6, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -6, -7 ], [ 2, 4, 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -3, -4, -5, -6, -8 ], [ 4 ], 
     [ 6, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, -3, -4, -5, -6, -8 ], [ 2, 6, 8, -1, -7 ], 
     [ 5, 7 ], [ -2 ]>, 
  <bipartition: [ 1, -4, -6, -8 ], [ 2, 3, 4, 5, 6, 7, -1, -3, -5, -7 ], 
     [ 8 ], [ -2 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -4, -6, -8 ], [ 4 ], 
     [ 6, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -4, -6, -8 ], [ 2, 5, 8, -1, -3, -5, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4, -6, -8 ], [ 3, 8, -1, -3, -5, -7 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -3, -5, -7 ], 
     [ 2, 7, -4, -6, -8 ], [ 6 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4, -6, -8 ], [ 2, 3, 4, -1, -3, -5, -7 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 7, 8, -1, -3, -5, -7 ], [ 2, 3, 5, 6, -4, -6, -8 ], 
     [ 4 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -4, -6, -8 ], [ 3, 5, 6, -1, -3, -5, -7 ], 
     [ -2 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -3, -5, -7 ], 
     [ 5, 7, 8, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -5, -7 ], [ 2, 7, -4, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, -4, -6, -8 ], [ 2, 6, 8, -1, -3, -5, -7 ], 
     [ 5, 7 ], [ -2 ]>, <bipartition: [ 1, 2, 4, 7, 8, -1, -3, -5, -7 ], 
     [ 3, 5, 6, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 5, -4, -6, -8 ], [ 2, 3, 4, 6, 7, 8, -1, -3, -5, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 7, -4, -6, -8 ], [ 3, 5, -1, -3, -5, -7 ], 
     [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -4, -6, -8 ], [ 5, -1, -3, -5, -7 ], 
     [ 6, 7 ], [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -3, -5, -7 ], 
     [ 6 ], [ 7, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -2, -5 ], [ 6 ], [ 7, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -3, -4, -6 ], 
     [ 7, 8, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -4, -6 ], [ 2, -2, -5 ], [ 6 ], 
     [ 8 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -3, -4, -6 ], [ 2, 3, 5, -2, -5 ], [ 4 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 4, 7, -1, -2, -3, -5, -6 ], 
     [ 5, -4, -8 ], [ 6, 8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -1, -2, -3, -5, -6 ], [ 3, 4, 5, -4, -8 ], 
     [ -7 ]>, <bipartition: [ 1, 4, 5, 8, -1, -2, -3, -5, -6 ], 
     [ 2, 3, 6, -4, -8 ], [ 7 ], [ -7 ]>, 
  <bipartition: [ 1, 8, -4, -8 ], [ 2, 3, 4, 5, -1, -2, -3, -5, -6 ], 
     [ 6, 7 ], [ -7 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -6 ], [ 6 ], 
     [ 7, -2, -4 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -2, -4 ], [ 5, 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, -2, -4 ], [ 2, 6, 8, -1, -6 ], [ 5, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, -2, -4 ], [ 2, 3, 4, 6, 7, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -2, -4 ], [ 5, -1, -6 ], [ 6, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -2, -4 ], [ 5, 6, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 5, -2, -4 ], [ 2, 3, 4, 6, 7 ], [ 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -2, -4 ], 
     [ 5, 7, -1, -6 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -2, -4 ], [ 7, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -2, -4 ], [ 2, -1, -6 ], [ 6 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, -1, -6 ], [ 2, 3, 4, 5, 6, 7, -2, -4 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 6, 7, 8, -2, -4 ], [ 2, 3, 5, -1, -6 ], [ 4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8 ], [ 2, -7 ], [ -1, -2 ], 
     [ -3, -6, -8 ], [ -4 ], [ -5 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4 ], [ 5, 6, 7 ], [ 8 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 4 ], [ 2, 7, 8 ], [ 3, 5, 6 ], [ -1, -7 ], [ -2 ], 
     [ -3, -4, -5, -6, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -3, -5, -8 ], [ 7, 8, -4 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -5, -8 ], 
     [ 2, -4 ], [ 6 ], [ 8 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -3, -5, -8 ], [ 2, 3, 5, -4 ], [ 4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -4 ], [ 6 ], [ 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -3, -6, -7 ], 
     [ 3, -4 ], [ 6, 8 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -3, -6, -7 ], [ 5, 7, -4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, -1, -3, -6, -7 ], [ 2, 6, 8, -4 ], [ 5, 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, -1, -3, -6, -7 ], [ 2, 3, 4, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 2, 3, 4, 8, -1, -3, -6, -7 ], 
     [ 5, -4 ], [ 6, 7 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -3, -6, -7 ], [ 5, 6, -4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, -1, -3, -6, -7 ], [ 2, 3, 4, 6, 7 ], [ 8, -4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -3, -6, -7 ], 
     [ 5, 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -3, -6, -7 ], [ 7, 8, -4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -6, -7 ], 
     [ 2, -4 ], [ 6 ], [ 8 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, -4 ], [ 2, 3, 4, 5, 6, 7, -1, -3, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -3, -6, -7 ], [ 2, 3, 5, -4 ], [ 4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, -1, -6, -7 ], [ 2, 3, 4, 5, 6, 7, -4 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -6, -7 ], 
     [ 4 ], [ 6, -4 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4 ], [ 2 ], [ 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -1, -6, -7 ], [ 2, 5, 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -6, -7 ], [ 3, 8, -4 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4 ], [ 2, 7, -1, -6, -7 ], [ 6 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -6, -7 ], [ 2, 3, 4, -4 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 7, 8, -4 ], [ 2, 3, 5, 6, -1, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -1, -6, -7 ], [ 3, 5, 6, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -4 ], [ 5, 7, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, -1, -6, -7 ], [ 2, 6, 8, -4 ], [ 5, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -4 ], [ 3, 5, 6, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, -1, -6, -7 ], [ 2, 3, 4, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 7, -1, -6, -7 ], [ 3, 5, -4 ], [ 6, 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -4 ], [ 5, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -1, -6, -7 ], [ 5, -4 ], [ 6, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -3, -4, -5, -6, -8 ], [ 7, 8, -1, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 7, -3, -4, -5, -6, -8 ], 
     [ 2, -1, -7 ], [ 6 ], [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 6, 7, 8, -3, -4, -5, -6, -8 ], [ 2, 3, 5, -1, -7 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -4, -6, -8 ], 
     [ 5, 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -4, -6, -8 ], [ 7, 8, -1, -3, -5, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4, -6, -8 ], [ 2, -1, -3, -5, -7 ], [ 6 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, -1, -3, -5, -7 ], [ 2, 3, 4, 5, 6, 7, -4, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 6, 7, 8, -4, -6, -8 ], [ 2, 3, 5, -1, -3, -5, -7 ], 
     [ 4 ], [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -3, -5, -7 ], 
     [ 5, 7, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -6, -8 ], [ 2 ], [ 7, -1, -3, -5, -7 ]
      , [ -2 ]>, <bipartition: [ 1, 3, 4, 6, 7, -1, -3, -5, -7 ], 
     [ 2, 5, 8, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 8, -4, -6, -8 ], [ 2, 3, 4, -1, -3, -5, -7 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 8, -1, -3, -5, -7 ], [ 2, 3, 4, 5, -4, -6, -8 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4, -6, -8 ], [ 2, 7, -1, -3, -5, -7 ], 
     [ 6 ], [ -2 ]>, 
  <bipartition: [ 1, 5, 6, 7, -1, -3, -5, -7 ], [ 2, 3, 4, -4, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -5, -7 ], [ 5, 6, 7, -4, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -4, -6, -8 ], [ 2, 3, 5, 6, 7, 8, -1, -3, -5, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -6, -8 ], 
     [ 2, 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -5, -7 ], [ 2, 6, 8, -4, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -4, -6, -8 ], [ 5, -1, -3, -5, -7 ], 
     [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -4, -6, -8 ], [ 3, 4, 5, -1, -3, -5, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4, -6, -8 ], [ 2, 3, 6, -1, -3, -5, -7 ], 
     [ 7 ], [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 7, 8, -4, -6, -8 ], 
     [ 5, 6, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 8, -2, -5 ], [ 3, 4, 5, 6, 7, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -2, -5 ], [ 5, 6, 7, -1, -3, -4, -6 ], 
     [ 8 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -4, -6 ], [ 2, 7, 8, -2, -5 ], [ 3, 5, 6 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -3, -4, -6 ], 
     [ 8, -2, -5 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -4, -6 ], [ 2 ], [ 4, 7, -2, -5 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -2, -3, -5, -6 ], 
     [ 5, 6, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -1, -2, -3, -5, -6 ], [ 3, 8, -4, -8 ], 
     [ 4 ], [ -7 ]>, 
  <bipartition: [ 1, 7, 8, -4, -8 ], [ 2, 3, 5, 6, -1, -2, -3, -5, -6 ], 
     [ 4 ], [ -7 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -4, -8 ], 
     [ 5, 7, 8, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 5, -1, -2, -3, -5, -6 ], [ 2, 3, 4, 6, 7 ], 
     [ 8, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -4, -8 ], [ 5, 7, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 5, 8, -1, -2, -3, -5, -6 ], [ 2, 3, 4, -4, -8 ], 
     [ 6, 7 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4, -8 ], [ 2, 4, 7, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -2, -4 ], [ 2, 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -6 ], [ 2, 6, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -6 ], [ 4 ], [ 6, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, -1, -6 ], [ 2, 6, 8, -2, -4 ], [ 5, 7 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -2, -4 ], [ 5, 6, 7, -1, -6 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 8, -1, -6 ], [ 3, 4, 5, 6, 7, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -1, -6 ], [ 5, 6, 7, -2, -4 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -2, -4 ], [ 2, 7, 8, -1, -6 ], [ 3, 5, 6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -2, -4 ], [ 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -6 ], 
     [ 5, 7, -2, -4 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -2, -4 ], [ 2 ], [ 4, 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -4 ], [ 5, 6, 7, -1, -3, -5, -8 ], [ 8 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -8 ], [ 2, 7, 8, -4 ], [ 3, 5, 6 ], 
     [ -2, -6, -7 ]>, <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -5, -8 ], [ 2 ], 
     [ 4, 7, -4 ], [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -3, -6, -7 ], [ 6 ], [ 7, -4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4 ], [ 5, 6, 7, -1, -3, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -6, -7 ], [ 2, 3, 5, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -3, -6, -7 ], 
     [ 2, 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4 ], [ 2, 6, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -4 ], [ 4 ], [ 6, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 6, 8, -1, -3, -6, -7 ], [ 5, 7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 5, -4 ], [ 2, 3, 4, 6, 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -6, -7 ], [ 5, 6, 7, -4 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 8, -4 ], [ 3, 4, 5, 6, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -4 ], [ 5, 6, 7, -1, -3, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, -1, -3, -6, -7 ], [ 2, 7, 8, -4 ], [ 3, 5, 6 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -3, -6, -7 ], [ 8, -4 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -4 ], [ 5, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -6, -7 ], [ 2 ], 
     [ 4, 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -6, -7 ], [ 5, 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -6, -7 ], 
     [ 7, 8, -4 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -6, -7 ], [ 2, -4 ], [ 6 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, -4 ], [ 2, 3, 4, 5, 6, 7, -1, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -6, -7 ], [ 2, 3, 5, -4 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4 ], [ 3, -1, -6, -7 ], [ 6, 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -4 ], 
     [ 5, 7, -1, -6, -7 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6, -7 ], [ 2 ], [ 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -4 ], [ 2, 5, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 8, -1, -6, -7 ], [ 2, 3, 4, -4 ], [ 6, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 8, -4 ], [ 2, 3, 4, 5, -1, -6, -7 ], [ 6, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -1, -6, -7 ], [ 2, 7, -4 ], [ 6 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4 ], [ 2, 3, 4, -1, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -6, -7 ], 
     [ 2, 7, -4 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4 ], [ 2, 6, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -1, -6, -7 ], [ 5, -4 ], [ 6, 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -1, -6, -7 ], [ 3, 4, 5, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, 5, 8, -1, -6, -7 ], [ 2, 3, 6, -4 ], [ 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 2, 3, 4, 7, 8, -1, -6, -7 ], 
     [ 5, 6, -4 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 8, -1, -7 ], [ 3, 4, 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -1, -7 ], [ 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -3, -4, -5, -6, -8 ], [ 2, 7, 8, -1, -7 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -3, -4, -5, -6, -8 ], 
     [ 8, -1, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -3, -4, -5, -6, -8 ], [ 2 ], [ 4, 7, -1, -7 ]
      , [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4, -6, -8 ], [ 5, 6, 7, -1, -3, -5, -7 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 5, -1, -3, -5, -7 ], [ 2, 3, 4, 6, 7, 8, -4, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 2, 8, -1, -3, -5, -7 ], [ 3, 4, 5, 6, 7, -4, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1 ], [ 2, 3, 4, -1, -3, -5, -7 ], 
     [ 5, 6, 7, -4, -6, -8 ], [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -4, -6, -8 ], [ 2, 7, 8, -1, -3, -5, -7 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -4, -6, -8 ], 
     [ 8, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -3, -5, -7 ], [ 5, 7, -4, -6, -8 ]
      , [ -2 ]>, <bipartition: [ 1, 3, 5, 6, 8, -4, -6, -8 ], [ 2 ], 
     [ 4, 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4, -6, -8 ], [ 3, -1, -3, -5, -7 ], 
     [ 6, 8 ], [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -4, -6, -8 ], 
     [ 5, 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -5, -7 ], [ 2, 4, 7, -4, -6, -8 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -7 ], [ 2, 3, 5, 6, 7, 8, -4, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 5, -4, -6, -8 ], [ 2, 3, 4, 6, 7 ], 
     [ 8, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -3, -5, -7 ], [ 4 ], [ 6, -4, -6, -8 ]
      , [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, -2, -5 ], [ 5, 6, 7, 8, -1, -3, -4, -6 ], 
     [ -7, -8 ]>, <bipartition: [ 1, 3, 4, -2, -5 ], [ 2, 6, 8 ], 
     [ 5, 7, -1, -3, -4, -6 ], [ -7, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -3, -4, -6 ], [ 2, -2, -5 ], 
     [ -7, -8 ]>, 
  <bipartition: [ 1, -4, -8 ], [ 2, 3, 4, 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 8 ], [ -7 ]>, <bipartition: [ 1, 2, 3, 5, 7, 8, -4, -8 ], [ 4 ], 
     [ 6, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -1, -2, -3, -5, -6 ], [ 2 ], 
     [ 7, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 6, 7, -4, -8 ], [ 2, 5, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 2, 5, 6, 7, -4, -8 ], [ 3, 8, -1, -2, -3, -5, -6 ], 
     [ 4 ], [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 8, -1, -2, -3, -5, -6 ], 
     [ 2, 7, -4, -8 ], [ 6 ], [ -7 ]>, 
  <bipartition: [ 1, 5, 6, 7, -4, -8 ], [ 2, 3, 4, -1, -2, -3, -5, -6 ], 
     [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 7, 8, -1, -2, -3, -5, -6 ], [ 2, 3, 5, 6, -4, -8 ], 
     [ 4 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 4, 7, 8, -4, -8 ], [ 3, 5, 6, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, -1, -2, -3, -5, -6 ], 
     [ 5, 7, 8, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, -4, -8 ], [ 2, 6, 8, -1, -2, -3, -5, -6 ], 
     [ 5, 7 ], [ -7 ]>, <bipartition: [ 1, 2, 4, 7, 8, -1, -2, -3, -5, -6 ], 
     [ 3, 5, 6, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 5, -4, -8 ], [ 2, 3, 4, 6, 7, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 2, 4, 7, -4, -8 ], [ 3, 5, -1, -2, -3, -5, -6 ], 
     [ 6, 8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 6, 8, -1, -2, -3, -5, -6 ], [ 5, 7, -4, -8 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -4, -8 ], [ 5, -1, -2, -3, -5, -6 ], 
     [ 6, 7 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -6 ], [ 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -6 ], [ 2, -2, -4 ], [ 6 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -6 ], [ 2, 3, 5, -2, -4 ], [ 4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -6 ], [ 5, 6, 7, 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, <bipartition: [ 1, 3, 4, -1, -6 ], [ 2, 6, 8 ], 
     [ 5, 7, -2, -4 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -2, -4 ], [ 2, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -3, -5, -8 ], [ 2, -4 ], 
     [ -2, -6, -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -4 ], [ 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4 ], [ 2, -1, -3, -6, -7 ], [ 6 ], [ 8 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 6, 7, 8, -4 ], [ 2, 3, 5, -1, -3, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -6, -7 ], 
     [ 2, 6, 8, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4 ], [ 5, 6, 7, 8, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 6, 8 ], [ 5, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -3, -6, -7 ], 
     [ 2, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -6, -7 ], [ 5, 6, 7, -4 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 8, -4 ], [ 3, 4, 5, 6, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -4 ], [ 5, 6, 7, -1, -6, -7 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -1, -6, -7 ], [ 2, 7, 8, -4 ], [ 3, 5, 6 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -6, -7 ], [ 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -4 ], [ 5, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -6, -7 ], [ 2 ], [ 4, 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -4 ], [ 6 ], [ 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -1, -6, -7 ], [ 3, -4 ], [ 6, 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -6, -7 ], [ 5, 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4 ], [ 2, 4, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 3, 5, 6, 7, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 5, -1, -6, -7 ], [ 2, 3, 4, 6, 7 ], [ 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -4 ], [ 4 ], [ 6, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -7 ], [ 5, 6, 7, 8, -3, -4, -5, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, -1, -7 ], [ 2, 6, 8 ], 
     [ 5, 7, -3, -4, -5, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -3, -4, -5, -6, -8 ], [ 2, -1, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4, -6, -8 ], [ 2, 6, 8, -1, -3, -5, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -5, -7 ], [ 5, 6, 7, 8, -4, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, -1, -3, -5, -7 ], [ 2, 6, 8 ], 
     [ 5, 7, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -4, -6, -8 ], [ 2, -1, -3, -5, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -4, -6, -8 ], [ 6 ], 
     [ 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -1, -3, -5, -7 ], [ 5, -4, -6, -8 ], 
     [ 6, 7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, -1, -3, -5, -7 ], [ 2, 6, 8, -4, -6, -8 ], 
     [ 5, 7 ], [ -2 ]>, <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -3, -5, -7 ], 
     [ 7, 8, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -1, -3, -5, -7 ], [ 2, -4, -6, -8 ], [ 6 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -3, -5, -7 ], [ 2, 3, 5, -4, -6, -8 ], 
     [ 4 ], [ -2 ]>, <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -4, -8 ], 
     [ 5, 7, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4, -8 ], [ 2, -1, -2, -3, -5, -6 ], [ 6 ], 
     [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, -1, -2, -3, -5, -6 ], [ 2, 3, 4, 5, 6, 7, -4, -8 ], 
     [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 6, 7, 8, -4, -8 ], [ 2, 3, 5, -1, -2, -3, -5, -6 ], 
     [ 4 ], [ -7 ]>, <bipartition: [ 1, 2, 4, 5, 7, -1, -2, -3, -5, -6 ], 
     [ 3, -4, -8 ], [ 6, 8 ], [ -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -2, -3, -5, -6 ], 
     [ 5, 7, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -8 ], [ 2 ], [ 7, -1, -2, -3, -5, -6 ]
      , [ -7 ]>, <bipartition: [ 1, 3, 4, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 2, 5, 8, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 5, 8, -4, -8 ], [ 2, 3, 4, -1, -2, -3, -5, -6 ], 
     [ 6, 7 ], [ -7 ]>, 
  <bipartition: [ 1, 8, -1, -2, -3, -5, -6 ], [ 2, 3, 4, 5, -4, -8 ], 
     [ 6, 7 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 8, -4, -8 ], [ 2, 7, -1, -2, -3, -5, -6 ], 
     [ 6 ], [ -7 ]>, <bipartition: [ 1, 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 2, 3, 4, -4, -8 ], [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 8, -4, -8 ], [ 2, 7, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -2, -3, -5, -6 ], 
     [ 2, 6, 8, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, -4, -8 ], [ 5, -1, -2, -3, -5, -6 ], 
     [ 6, 8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 6, 7, 8, -4, -8 ], [ 3, 4, 5, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 4, 5, 8, -4, -8 ], [ 2, 3, 6, -1, -2, -3, -5, -6 ], 
     [ 7 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 7, 8, -4, -8 ], [ 5, 6, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 2, 8, -2, -4 ], [ 3, 4, 5, 6, 7, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -2, -4 ], [ 5, 6, 7, -1, -6 ], [ 8 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 4, -1, -6 ], [ 2, 7, 8, -2, -4 ], [ 3, 5, 6 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -6 ], [ 8, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, <bipartition: [ 1, 3, 5, 6, 8, -1, -6 ], [ 2 ], 
     [ 4, 7, -2, -4 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 8, -1, -3, -6, -7 ], [ 3, 4, 5, 6, 7, -4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1 ], [ 2, 3, 4, -1, -3, -6, -7 ], 
     [ 5, 6, 7, -4 ], [ 8 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 7, 8, -1, -3, -6, -7 ], [ 3, 5, 6 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -4 ], 
     [ 8, -1, -3, -6, -7 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4 ], [ 2 ], [ 4, 7, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4 ], [ 5, 6, 7, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 6, 8 ], [ 5, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -6, -7 ], [ 2, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -6, -7 ], 
     [ 6 ], [ 7, -4 ], [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -4 ], [ 5, -1, -6, -7 ], [ 6, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, -4 ], [ 2, 6, 8, -1, -6, -7 ], [ 5, 7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -4 ], [ 7, 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 7, -4 ], [ 2, -1, -6, -7 ], [ 6 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 6, 7, 8, -4 ], [ 2, 3, 5, -1, -6, -7 ], [ 4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 8, -4, -6, -8 ], [ 3, 4, 5, 6, 7, -1, -3, -5, -7 ], 
     [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -4, -6, -8 ], [ 5, 6, 7, -1, -3, -5, -7 ], 
     [ 8 ], [ -2 ]>, 
  <bipartition: [ 1, 4, -1, -3, -5, -7 ], [ 2, 7, 8, -4, -6, -8 ], 
     [ 3, 5, 6 ], [ -2 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -3, -5, -7 ], 
     [ 8, -4, -6, -8 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -3, -5, -7 ], [ 2 ], [ 4, 7, -4, -6, -8 ]
      , [ -2 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4, -8 ], [ 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 8, -1, -2, -3, -5, -6 ], [ 3, 4, 5, 6, 7, -4, -8 ], 
     [ -7 ]>, <bipartition: [ 1 ], [ 2, 3, 4, -1, -2, -3, -5, -6 ], 
     [ 5, 6, 7, -4, -8 ], [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 4, -4, -8 ], [ 2, 7, 8, -1, -2, -3, -5, -6 ], 
     [ 3, 5, 6 ], [ -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -4, -8 ], 
     [ 8, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4 ], [ 2, 6, 8, -1, -2, -3, -5, -6 ], [ 5, 7, -4, -8 ]
      , [ -7 ]>, <bipartition: [ 1, 3, 5, 6, 8, -4, -8 ], [ 2 ], 
     [ 4, 7, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 8, -1, -2, -3, -5, -6 ], [ 6 ], 
     [ 7, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 4, 5, 7, -4, -8 ], [ 3, -1, -2, -3, -5, -6 ], 
     [ 6, 8 ], [ -7 ]>, <bipartition: [ 1 ], [ 2, 4 ], [ 3, 6, 8, -4, -8 ], 
     [ 5, 7, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -2, -3, -5, -6 ], [ 2, 4, 7, -4, -8 ], 
     [ -7 ]>, 
  <bipartition: [ 1, 4, -1, -2, -3, -5, -6 ], [ 2, 3, 5, 6, 7, 8, -4, -8 ], 
     [ -7 ]>, <bipartition: [ 1, 5, -4, -8 ], [ 2, 3, 4, 6, 7 ], 
     [ 8, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 5, 7, 8, -1, -2, -3, -5, -6 ], [ 4 ], 
     [ 6, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, -2, -4 ], [ 5, 6, 7, 8, -1, -6 ], 
     [ -3, -5, -7 ], [ -8 ]>, <bipartition: [ 1, 3, 4, -2, -4 ], [ 2, 6, 8 ], 
     [ 5, 7, -1, -6 ], [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -6 ], [ 2, -2, -4 ], 
     [ -3, -5, -7 ], [ -8 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -3, -6, -7 ], [ 5, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ]>, <bipartition: [ 1, 3, 4, -1, -3, -6, -7 ], [ 2, 6, 8 ], 
     [ 5, 7, -4 ], [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -4 ], [ 2, -1, -3, -6, -7 ], 
     [ -2, -5, -8 ]>, 
  <bipartition: [ 1, 2, 8, -1, -6, -7 ], [ 3, 4, 5, 6, 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -1, -6, -7 ], [ 5, 6, 7, -4 ], [ 8 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 4, -4 ], [ 2, 7, 8, -1, -6, -7 ], [ 3, 5, 6 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -4 ], [ 8, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -4 ], [ 2 ], [ 4, 7, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4, -6, -8 ], [ 5, 6, 7, 8, -1, -3, -5, -7 ], 
     [ -2 ]>, <bipartition: [ 1, 3, 4, -4, -6, -8 ], [ 2, 6, 8 ], 
     [ 5, 7, -1, -3, -5, -7 ], [ -2 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -3, -5, -7 ], [ 2, -4, -6, -8 ], 
     [ -2 ]>, <bipartition: [ 1, 2, 3, 4, -1, -2, -3, -5, -6 ], 
     [ 5, 6, 7, 8, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, -1, -2, -3, -5, -6 ], [ 2, 6, 8 ], [ 5, 7, -4, -8 ]
      , [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -4, -8 ], [ 2, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 2, 3, 4, 5, 8, -4, -8 ], [ 6 ], 
     [ 7, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 8, -1, -2, -3, -5, -6 ], [ 5, -4, -8 ], 
     [ 6, 7 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, -1, -2, -3, -5, -6 ], [ 2, 6, 8, -4, -8 ], 
     [ 5, 7 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, 6, -1, -2, -3, -5, -6 ], [ 7, 8, -4, -8 ], 
     [ -7 ]>, <bipartition: [ 1, 3, 4, 5, 7, -1, -2, -3, -5, -6 ], 
     [ 2, -4, -8 ], [ 6 ], [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 6, 7, 8, -1, -2, -3, -5, -6 ], [ 2, 3, 5, -4, -8 ], 
     [ 4 ], [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, -1, -6, -7 ], [ 5, 6, 7, 8, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, -1, -6, -7 ], [ 2, 6, 8 ], [ 5, 7, -4 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -4 ], [ 2, -1, -6, -7 ], 
     [ -2, -5, -8 ], [ -3 ]>, 
  <bipartition: [ 1, 2, 8, -4, -8 ], [ 3, 4, 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, 
  <bipartition: [ 1 ], [ 2, 3, 4, -4, -8 ], [ 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 8 ], [ -7 ]>, 
  <bipartition: [ 1, 4, -1, -2, -3, -5, -6 ], [ 2, 7, 8, -4, -8 ], 
     [ 3, 5, 6 ], [ -7 ]>, 
  <bipartition: [ 1 ], [ 2, 4 ], [ 3, 5, 6, 7, -1, -2, -3, -5, -6 ], 
     [ 8, -4, -8 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 5, 6, 8, -1, -2, -3, -5, -6 ], [ 2 ], [ 4, 7, -4, -8 ]
      , [ -7 ]>, 
  <bipartition: [ 1, 2, 3, 4, -4, -8 ], [ 5, 6, 7, 8, -1, -2, -3, -5, -6 ], 
     [ -7 ]>, <bipartition: [ 1, 3, 4, -4, -8 ], [ 2, 6, 8 ], 
     [ 5, 7, -1, -2, -3, -5, -6 ], [ -7 ]>, 
  <bipartition: [ 1, 3, 4, 5, 6, 7, 8, -1, -2, -3, -5, -6 ], [ 2, -4, -8 ], 
     [ -7 ]> ]
gap> LClassReps(D);
[ <bipartition: [ 1, 2, 3, 4, 5, -2 ], [ -1, -3 ], [ -4, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, -2, -3, -4 ], [ -1, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, -3, -5 ], [ -1, -2, -4 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, -1, -2, -3 ], [ -4, -5 ]>, 
  <block bijection: [ 1, 2, 3, 4, 5, -1, -2, -3, -4, -5 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, -1, -2, -3, -5 ], [ -4 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, -1, -2, -5 ], [ -3 ], [ -4 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, -2, -3, -4, -5 ], [ -1 ]>, 
  <bipartition: [ 1, 2, 3, 4, 5, -1, -3 ], [ -2 ], [ -4, -5 ]> ]
gap> x:=Bipartition( [ [ 1, 3, 4, 6, 7, -3, -4, -5, -6, -8 ], 
> [ 2, 5, 8, -1, -7 ], [ -2 ] ]);;
gap> D:=DClass(S, x);
{Bipartition( [ [ 1, 3, 4, 6, 7, -3, -4, -5, -6, -8 ], [ 2, 5, 8, -1, -7 ], 
 [ -2 ] ] )}
gap> LClassReps(D);
[ <bipartition: [ 1, 3, 4, 6, 7, -3, -4, -5, -6, -8 ], [ 2, 5, 8, -1, -7 ], 
     [ -2 ]> ]
gap> L:=LClass(S, Bipartition([[ 1 ], [ 2, 4 ], [ 3, 6, -3, -4, -5, -6, -8 ],
> [ 5, 7, 8, -1, -7 ], [ -2 ]]));
{Bipartition( [ [ 1, 3, 4, 6, 7, -3, -4, -5, -6, -8 ], [ 2, 5, 8, -1, -7 ], 
 [ -2 ] ] )}
gap> LL:=LClassNC(S, Bipartition([[ 1, 3, 4, 6, 7, -3, -4, -5, -6, -8 ], [ 2,
> 5, 8, -1, -7 ], [ -2 ]]));
{Bipartition( [ [ 1, 3, 4, 6, 7, -3, -4, -5, -6, -8 ], [ 2, 5, 8, -1, -7 ], 
 [ -2 ] ] )}
gap> LL=L;
true
gap> L=LL;
true
gap> Size(L);
64
gap> Size(LL);
64
gap> x:=Bipartition( [ [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -3, -5, -7 ], 
>  [ 5, 7, -4, -6, -8 ], [ -2 ] ] );;
gap> D:=DClass(RClassNC(S, x));
{Bipartition( [ [ 1 ], [ 2, 4 ], [ 3, 6, 8, -1, -3, -5, -7 ], 
 [ 5, 7, -4, -6, -8 ], [ -2 ] ] )}
gap> GroupHClass(D);
fail
gap> IsRegularDClass(D);
false
gap> D:=DClass(S, x);
{Bipartition( [ [ 1, 3, 4, 6, 7, -4, -6, -8 ], [ 2, 5, 8, -1, -3, -5, -7 ], 
 [ -2 ] ] )}
gap> IsRegularDClass(D);
false
gap> x:=Bipartition([[ 1, 7, 8, -2, -5 ], [ 2, 3, 5, 6, -1, -3, -4, -6 ], 
> [ 4 ], [ -7, -8 ]]);;
gap> IsRegularDClass(DClass(S, x));
false
gap> NrRegularDClasses(S);
4
gap> First(DClasses(S), IsRegularDClass);
{Bipartition( [ [ 1, 2, 3, 7, -7 ], [ 4, 5, 6, 8 ], [ -1, -2 ], 
 [ -3, -6, -8 ], [ -4 ], [ -5 ] ] )}
gap> Size(last);
12078
gap> GroupHClass(last2);
{Bipartition( [ [ 1, 2, 3, 7, -7 ], [ 4, 5, 6, 8 ], [ -1, -2 ], 
 [ -3, -6, -8 ], [ -4 ], [ -5 ] ] )}
gap> StructureDescription(last);
"1"
gap> D:=First(DClasses(S), IsRegularDClass);
{Bipartition( [ [ 1, 2, 3, 7, -7 ], [ 4, 5, 6, 8 ], [ -1, -2 ], 
 [ -3, -6, -8 ], [ -4 ], [ -5 ] ] )}
gap> NrRClasses(D);
99
gap> NrLClasses(D);
122
gap> R:=PrincipalFactor(D);
<Rees 0-matrix semigroup 99x122 over 1>
gap> Length(Idempotents(S, 1));
11209
gap> Length(Idempotents(S, 0));
4218
gap> NrIdempotents(S);
15529
gap> last2+last3;
15427
gap> Length(Idempotents(S, 2));
102
gap> NrRClasses(D);
99
gap> NrDClasses(S);
190
gap> PartialOrderOfDClasses(S);
[ [ 3, 19, 20, 21 ], [ 3, 9, 33, 39, 43 ], [ 3, 34 ], 
  [ 3, 9, 19, 22, 23, 24, 26, 35, 39 ], [ 3, 9, 27, 33, 39 ], 
  [ 3, 22, 25, 36, 40 ], [ 3, 25, 26, 27, 38 ], [ 3, 9, 23, 28, 29, 30, 42 ], 
  [ 3, 9, 21, 22, 24, 27, 30, 31, 33, 34, 37, 38, 39, 42, 43, 50, 57, 59 ], 
  [ 3, 9, 20, 22, 28, 32 ], [ 3, 24, 33, 34, 35, 36, 37 ], [ 3, 9, 31 ], 
  [ 3, 39, 40, 41 ], [ 3, 9, 22, 27, 37 ], [ 3, 9, 24, 33, 41 ], 
  [ 3, 9, 21, 29, 32 ], [ 3, 9, 22, 27, 31, 33, 34, 42 ], 
  [ 3, 9, 21, 22, 30, 38, 39, 43 ], [ 3, 19 ], [ 3, 44 ], 
  [ 3, 21, 34, 44, 45, 60, 61, 84, 107, 108, 109, 126, 127, 128, 154, 155, 
      183 ], 
  [ 3, 22, 34, 36, 40, 46, 48, 54, 65, 72, 76, 84, 92, 107, 115, 134, 135, 
      143, 153, 171 ], [ 3, 19, 23, 26 ], 
  [ 3, 24, 34, 52, 82, 85, 94, 97, 109, 111, 117, 118, 123, 128, 133, 139, 
      151, 165, 182 ], [ 3, 34, 46, 47, 53, 58 ], [ 3, 26, 47 ], 
  [ 3, 27, 34, 48, 63, 65, 66, 67, 85, 86, 87, 90, 91, 110, 111, 112, 156 ], 
  [ 3, 49 ], [ 3, 50, 59 ], 
  [ 3, 30, 34, 51, 69, 118, 134, 143, 144, 145, 162, 163, 164, 165, 174, 176, 
      189 ], 
  [ 3, 31, 34, 56, 60, 67, 68, 75, 78, 91, 102, 127, 132, 137, 145, 148, 163, 
      173, 180 ], [ 3, 34, 44, 49, 57 ], 
  [ 3, 33, 34, 36, 52, 54, 55, 56, 70, 74, 75, 93, 94, 95, 96, 119, 166 ], 
  [ 34 ], [ 3, 33, 36, 52 ], [ 3, 53 ], 
  [ 3, 34, 37, 72, 97, 135, 136, 137, 138, 147, 148, 149, 150, 151, 167, 169, 
      185 ], [ 3, 34, 38, 45, 51, 63, 70, 79, 83, 87, 96, 104, 138, 141, 150, 
      154, 158, 164, 181 ], 
  [ 3, 34, 39, 40, 76, 77, 78, 79, 81, 82, 101, 102, 103, 104, 122, 123, 152 ]
    , [ 3, 58 ], [ 3, 39 ], 
  [ 3, 34, 42, 55, 66, 74, 77, 90, 101, 108, 116, 126, 131, 136, 144, 147, 
      162, 172, 179 ], 
  [ 3, 34, 43, 83, 105, 139, 153, 171, 172, 173, 179, 180, 181, 182, 186, 
      188, 190 ], [ 3 ], [ 3 ], 
  [ 3, 34, 46, 53, 58, 62, 64, 73, 89, 98, 100, 106, 114, 125, 130, 142, 146, 
      161, 170, 178 ], [ 3, 47, 62, 71, 80 ], [ 3, 64 ], [ 3 ], 
  [ 3, 34, 49, 50, 68, 92, 115, 116, 117, 131, 132, 133, 141, 157, 158, 159, 
      184 ], [ 3 ], [ 3, 34 ], [ 3, 34, 71 ], [ 3, 73 ], [ 3 ], [ 3 ], 
  [ 3, 34, 44, 49, 57, 61, 69, 86, 95, 103, 105, 110, 119, 122, 149, 157, 
      169, 176, 188 ], [ 3, 34, 80 ], 
  [ 3, 34, 59, 81, 93, 112, 152, 155, 156, 159, 166, 167, 174, 183, 184, 185, 
      186, 189, 190 ], [ 3 ], [ 3 ], 
  [ 3, 19, 34, 62, 71, 80, 88, 99, 113, 120, 121, 124, 129, 140, 160, 168, 
      175, 177, 187 ], [ 3 ], [ 3, 34, 88 ], [ 3, 89 ], [ 3 ], [ 3 ], [ 3 ], 
  [ 3 ], [ 3 ], [ 3, 71 ], [ 3, 98 ], [ 3, 34, 99 ], [ 3 ], [ 3 ], 
  [ 3, 100 ], [ 3 ], [ 3 ], [ 3 ], [ 3, 80 ], [ 3 ], [ 3, 34 ], [ 3 ], 
  [ 3, 106 ], [ 3, 34 ], [ 3 ], [ 3 ], [ 3, 88 ], [ 3, 34, 113 ], [ 3 ], 
  [ 3 ], [ 3, 114 ], [ 3 ], [ 3, 34 ], [ 3 ], [ 3 ], [ 3, 34 ], 
  [ 3, 34, 120 ], [ 3, 99 ], [ 3, 34, 121 ], [ 3 ], [ 3 ], [ 3 ], [ 3 ], 
  [ 3 ], [ 3, 34, 124 ], [ 3, 125 ], [ 3 ], [ 3, 34 ], [ 3 ], [ 3, 34 ], 
  [ 3 ], [ 3, 113 ], [ 3, 34, 129 ], [ 3, 130 ], [ 3 ], [ 3, 34 ], [ 3, 34 ], 
  [ 3 ], [ 3, 120 ], [ 3, 121 ], [ 3 ], [ 3, 34 ], [ 3, 124 ], [ 3, 19, 34 ], 
  [ 3 ], [ 3 ], [ 3, 34 ], [ 3, 129 ], [ 3, 34, 140 ], [ 3 ], [ 3 ], 
  [ 3, 34 ], [ 3, 142 ], [ 3, 146 ], [ 3 ], [ 3 ], [ 3 ], [ 3, 34 ], 
  [ 3, 140 ], [ 3 ], [ 3, 34, 160 ], [ 3, 161 ], [ 3 ], [ 3 ], 
  [ 3, 34, 168 ], [ 3 ], [ 3 ], [ 3 ], [ 3 ], [ 3, 34 ], [ 3 ], [ 3, 170 ], 
  [ 3 ], [ 3 ], [ 3 ], [ 3 ], [ 3 ], [ 3 ], [ 3, 160 ], [ 3, 34, 175 ], 
  [ 3 ], [ 3 ], [ 3 ], [ 3, 34 ], [ 3 ], [ 3 ], [ 3, 168 ], [ 3 ], 
  [ 3, 34, 177 ], [ 3, 178 ], [ 3 ], [ 3 ], [ 3 ], [ 3, 175 ], [ 3 ], 
  [ 3, 177 ], [ 3, 34, 187 ], [ 3 ], [ 3 ], [ 3 ], [ 3, 34 ], [ 3 ], [ 3 ], 
  [ 3 ], [ 3 ], [ 3, 187 ], [ 3 ], [ 3 ], [ 3 ] ]
gap> StructureDescriptionMaximalSubgroups(S);
[ "1", "C2" ]
gap> StructureDescriptionSchutzenbergerGroups(S);
[ "1", "C2" ]

#T# BipartitionTest27: IsomorphismPermGroup for a block bijection group
gap> S:=Semigroup( 
>  Bipartition( [ [ 1, 2, -3 ], [ 3, -4 ], [ 4, -8 ], [ 5, -1, -2 ], 
>      [ 6, -5 ], [ 7, -6 ], [ 8, -7 ] ] ), 
>  Bipartition( [ [ 1, 2, -7 ], [ 3, -1, -2 ], [ 4, -8 ], [ 5, -4 ], 
>     [ 6, -5 ], [ 7, -3 ], [ 8, -6 ] ] )  );;
gap> iso:=IsomorphismPermGroup(S);
MappingByFunction( <bipartition group on 8 pts with 2 generators>, Group([ (1,
2,3,7,6,5,4), (1,6,2)
(3,7,5,4) ]), function( x ) ... end, function( x ) ... end )
gap> inv:=InverseGeneralMapping(iso);;
gap> ForAll(S, x-> x^iso in Range(iso));
true
gap> ForAll(S, x-> (x^iso)^inv=x);
true

#T# SEMIGROUPS_UnbindVariables
gap> Unbind(elts);
gap> Unbind(DD);
gap> Unbind(gens);
gap> Unbind(HH);
gap> Unbind(LL);
gap> Unbind(r);
gap> Unbind(inv);
gap> Unbind(triples);
gap> Unbind(D);
gap> Unbind(G);
gap> Unbind(H);
gap> Unbind(L);
gap> Unbind(N);
gap> Unbind(S);
gap> Unbind(R);
gap> Unbind(bp);
gap> Unbind(T);
gap> Unbind(e);
gap> Unbind(g);
gap> Unbind(classes2);
gap> Unbind(f);
gap> Unbind(l);
gap> Unbind(s);
gap> Unbind(classes);
gap> Unbind(iso);
gap> Unbind(x);

#E# 
gap> STOP_TEST( "Semigroups package: bipartition.tst");
