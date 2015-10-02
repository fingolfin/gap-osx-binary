#############################################################################
##
#W  semigrp.tst                 GAP library                    Andrew Solomon
##
##
#Y  Copyright (C)  1996,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  To be listed in testinstall.g
##
gap> START_TEST("semigrp.tst");
gap> ###############################################
gap> ##
gap> ##  AsTransformation - changing representation
gap> ##
gap> ##  s := GeneralMappingByElements(g, g, [...]);
gap> ##  t := AsTransformation(g);
gap> ##
gap> ##  t*t; t + t; etc.
gap> ##
gap> ###############################################
gap> a := (1,2,3,4);;
gap> g := Group(a);;
gap> 
gap> u := TransformationRepresentation(
> GeneralMappingByElements(g, g,
> [DirectProductElement([a^1, a^1]), DirectProductElement([a^2, a^1]), 
>  DirectProductElement([a^3, a^3]), DirectProductElement([a^4, a^4])]));;
gap> 
gap> u*u;;
gap> ()^u;;
gap> 
gap> 
gap> 
gap> a := (1,2,3,4);;
gap> g := Group(a);;
gap> 
gap> s1 := GeneralMappingByElements(g, g,
> [DirectProductElement([a^1, a^1]), DirectProductElement([a^2, a^1]), 
> DirectProductElement([a^3, a^3]), DirectProductElement([a^4, a^4])]);;
gap> s1 := TransformationRepresentation(s1);;
gap> 
gap> t1 := GeneralMappingByElements(g, g,
> [DirectProductElement([a^1, a^2]), DirectProductElement([a^2, a^2]), 
> DirectProductElement([a^3, a^3]), DirectProductElement([a^4, a^4])]);;
gap> t1 := TransformationRepresentation(t1);;
gap> 
gap> s2 := GeneralMappingByElements(g, g,
> [DirectProductElement([a^1, a^1]), DirectProductElement([a^2, a^2]), 
> DirectProductElement([a^3, a^2]), DirectProductElement([a^4, a^4])]);;
gap> s2 := TransformationRepresentation(s2);;
gap> 
gap> t2 := GeneralMappingByElements(g, g,
> [DirectProductElement([a^1, a^1]), DirectProductElement([a^2, a^3]), 
> DirectProductElement([a^3, a^3]), DirectProductElement([a^4, a^4])]);;
gap> t2 := TransformationRepresentation(t2);;
gap> 
gap> s3 := GeneralMappingByElements(g, g,
> [DirectProductElement([a^1, a^1]), DirectProductElement([a^2, a^2]), 
> DirectProductElement([a^3, a^3]), DirectProductElement([a^4, a^3])]);;
gap> s3 := TransformationRepresentation(s3);;
gap> 
gap> t3 := GeneralMappingByElements(g, g,
> [DirectProductElement([a^1, a^1]), DirectProductElement([a^2, a^2]),
> DirectProductElement([a^3, a^4]), DirectProductElement([a^4, a^4])]);;
gap> t3 := TransformationRepresentation(t3);;
gap> 
gap> o4 := Semigroup([s1,s2,s3,t1,t2,t3]);;
gap> Size(o4);
34
gap> 
gap> IsSimpleSemigroup(o4);
false
gap> 
gap> 
gap> ##############################################################
gap> ##  To play with the semigroup as a transformation semigroup:
gap> ##############################################################
gap> i := IsomorphismTransformationSemigroup(o4);;
gap> Size(Range(i));
34
gap> 
gap> IsSimpleSemigroup(Range(i));
false
gap> 
gap> ########################
gap> #
gap> # Ideals
gap> #
gap> ########################
gap> a := Transformation([2,3,1]);;
gap> b := Transformation([2,2,1]);;
gap> M := Monoid([a,b]);;
gap> IsTransformationSemigroup(M);
true
gap> IsTransformationMonoid(M);
true
gap> K := MagmaIdealByGenerators(M, [b]);;
gap> L := SemigroupIdealByGenerators(M,[b]);;
gap> K = L;
true
gap> ########################
gap> #
gap> # Congruences
gap> #
gap> ########################
gap> # O_4 test
gap> a := Transformation([1,1,3,4]);;
gap> b := Transformation([2,2,3,4]);;
gap> c := Transformation([1,2,2,4]);;
gap> d := Transformation([1,3,3,4]);;
gap> e := Transformation([1,2,3,3]);;
gap> f := Transformation([1,2,4,4]);;
gap> O4 := Monoid([a,b,c,d,e,f]);;
gap> 
gap> J := MagmaIdealByGenerators(O4, [a*f]);;
gap> C := SemigroupCongruenceByGeneratingPairs(O4, [[a*f, a*e]]);;
gap> erp := EquivalenceRelationPartition(C);;
gap> AsSSortedList(J) = AsSSortedList(erp[1]);     # true
true
gap> Length(erp);
1
gap> IsReesCongruence(C);              # true
true
gap> ########################
gap> #
gap> # More Congruences
gap> #
gap> ########################
gap> f := FreeGroup("a");;
gap> g := f/[f.1^4];;
gap> phi := InjectionZeroMagma(g);
MappingByFunction( <fp group of size 4 on the generators 
[ a ]>, <<fp group of size 4 on the generators 
[ a ]> with 0 adjoined>, function( elt ) ... end, function( x ) ... end )
gap> m := Range(phi);
<<fp group of size 4 on the generators [ a ]> with 0 adjoined>
gap> el := Elements(m);;
gap> Size(m)=5;
true
gap> c := MagmaCongruenceByGeneratingPairs(m,[[el[2],el[3]]]);;
gap> EquivalenceRelationPartition(c);
[ [ <group with 0 adjoined elt: <identity ...>>, 
      <group with 0 adjoined elt: a>, <group with 0 adjoined elt: a^2>, 
      <group with 0 adjoined elt: a^-1> ] ]
gap> IsReesCongruence(c);
false
gap> MagmaIdealByGenerators(m,EquivalenceRelationPartition(c)[1]);
<semigroup ideal with 4 generators>
gap> Size(last);
5
gap> ###############################
gap> ##
gap> ##  testing generic factoring methods in semigrp.gd
gap> ##
gap> ##
gap> 
gap> f := FreeSemigroup(["a","b","c"]);;
gap> gens := GeneratorsOfSemigroup(f);;
gap> rels:= [[gens[1],gens[2]]];;
gap> cong := SemigroupCongruenceByGeneratingPairs(f, rels);;
gap> g1 := HomomorphismFactorSemigroup(f, cong);;
gap> g2 := HomomorphismFactorSemigroupByClosure(f, rels);;
gap> g3 := FactorSemigroup(f, cong);;
gap> g4 := FactorSemigroupByClosure(f, rels);;
gap> # quotient of an fp semigroup
gap> gens3 := GeneratorsOfSemigroup(g3);;
gap> rels3 := [[gens3[1],gens3[2]]];;
gap> cong3 := SemigroupCongruenceByGeneratingPairs(g3, rels3);;
gap> q3 := FactorSemigroup(g3, cong3);;
gap> # quotient of a transformation semigroup
gap> a := Transformation([2,3,1,2]);;
gap> s := Semigroup([a]);;
gap> rels := [[a,a^2]];;
gap> cong := SemigroupCongruenceByGeneratingPairs(s,rels);;
gap> s/rels;;
gap> s/cong;;
gap> ##################################
gap> # Basic finite examples
gap> #
gap> ##################################
gap> 
gap> f := FreeSemigroup("x1","x2");;
gap> x1 := GeneratorsOfSemigroup(f)[1];;
gap> x2 := GeneratorsOfSemigroup(f)[2];;
gap> g := f/[[x1^2,x1],[x2^2,x2],[x1*x2,x2*x1]];;
gap> y1 := GeneratorsOfSemigroup(g)[1];;
gap> y2 := GeneratorsOfSemigroup(g)[2];;
gap> y1*y2 = y2*y1;                      # true
true
gap> y1 = y2;                            # false
false
gap> AsSSortedList(g);;                        # [ x1, x2, x1*x2 ]
gap> k := KnuthBendixRewritingSystem(g);;
gap> IsConfluent(k);                     # true
true
gap> phi := IsomorphismTransformationSemigroup(g);;
gap> Size(Source(phi)) = Size(Range(phi));   # true
true
gap> csi := HomomorphismTransformationSemigroup(g,
>   RightMagmaCongruenceByGeneratingPairs(g, [[y1,y2]]));;
gap> Size(Source(csi)) >= Size(Range(csi));    # true
true
gap> 
gap> a := Transformation([1,1,3,4]);;
gap> b := Transformation([2,2,3,4]);;
gap> c := Transformation([1,2,2,4]);;
gap> d := Transformation([1,3,3,4]);;
gap> e := Transformation([1,2,3,3]);;
gap> f := Transformation([1,2,4,4]);;
gap> M4 := Monoid([a,b,c,d,e,f]);;
gap> eM4 := AsSSortedList(M4);;
gap> Size(M4);
35
gap> congM4 := SemigroupCongruenceByGeneratingPairs(M4, [[eM4[6],eM4[9]]]);;
gap> QM4 := M4/congM4;;
gap> One(a);;
gap> One(QM4);;
gap> One(eM4[2]);;
gap> eqm4 := AsSSortedList(QM4);;
gap> Size(QM4);
2
gap> One(eqm4[2]);;
gap> 
gap> #################################
gap> ## Testing equivalence relations
gap> ##################################
gap> 
gap> # first a set example
gap> x := Domain([1,2,3]);;
gap> er := EquivalenceRelationByPartition(x,[[1,2],[3]]);;
gap> e2 := EquivalenceClassOfElement(er,2);;
gap> f2 := EquivalenceClassOfElement(er,2);;
gap> e2 = f2; 
true
gap> f3 := EquivalenceClassOfElement(er,3);;
gap> f3=f2; # should be false
false
gap> 
gap> # A semigroup example
gap> t := Transformation([2,3,1]);;
gap> s := Transformation([3,3,1]);;
gap> S := Semigroup(s,t);;
gap> e := AsSSortedList(S);;
gap> c := SemigroupCongruenceByGeneratingPairs(S,[[e[9],e[12]]]);;
gap> cc1 := EquivalenceClassOfElement(c,e[1]);;
gap> cc2 := EquivalenceClassOfElement(c,e[2]);;
gap> cc1=cc2;
true
gap> EquivalenceRelationPartition(c);;
gap> cc1=cc2;   # works
true
gap> Set([cc1,cc2]);;
gap> 
gap> ############# Zeros
gap> a := Transformation([1,2,1]);;
gap> b := Transformation([1,1,1]);;
gap> s := Semigroup([a,b]);;
gap> HasMultiplicativeZero(s);
false
gap> IsMultiplicativeZero(s,a);
false
gap> IsMultiplicativeZero(s,b);
true
gap> HasMultiplicativeZero(s);
true
gap> MultiplicativeZero(s);;
gap> 
gap> ## Adding zero to a magma
gap> ###########################################
gap> G := Group((1,2,3));;
gap> i := InjectionZeroMagma(G);;
gap> G0 := Range(i);;
gap> IsMonoid(G0);
true
gap> g := AsSSortedList(G0);;
gap> g[1]*g[2];
<group with 0 adjoined elt: 0>
gap> g[3]*g[2];;
gap> g[3]*g[4];;
gap> IsZeroGroup(G0);
true
gap> m := Monoid(g[3],g[4]);;
gap> CategoryCollections(IsMultiplicativeElementWithZero)(m);
true
gap> 
gap> 
gap> STOP_TEST( "semigrp.tst", 11200000 );

#############################################################################
##
#E
