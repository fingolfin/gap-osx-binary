#############################################################################
##
#W helpers.gd                                               Laurent Bartholdi
##
#H   @(#)$Id$
##
#Y Copyright (C) 2006, Laurent Bartholdi
##
#############################################################################
##
##  This file contains helper code for functionally recursive groups,
##  in particular related to the geometry of groups.
##
#############################################################################

#############################################################################
##
#F Products
##
## <#GAPDoc Label="TensorSum">
## <ManSection>
##   <Func Name="TensorSum" Arg="objects,..."/>
##   <Description>
##     This function is similar in syntax to <Ref Func="DirectProduct"
##     BookName="ref"/>, and delegates to <C>TensorSumOp</C>; its meaning
##     depends on context, see e.g.
##     <Ref Meth="TensorSumOp" Label="FR Machines"/>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="TensorProduct" Arg="objects,..."/>
##   <Description>
##     This function is similar in syntax to <Ref Func="DirectProduct"
##     BookName="ref"/>, and delegates to <C>TensorProductOp</C>; its meaning
##     depends on context, see e.g.
##     <Ref Meth="TensorProductOp" Label="FR Machines"/>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="DirectSum" Arg="objects,..."/>
##   <Description>
##     This function is similar in syntax to <Ref Func="DirectProduct"
##     BookName="ref"/>, and delegates to <C>DirectSumOp</C>; its meaning
##     depends on context, see e.g.
##     <Ref Meth="DirectSumOp" Label="FR Machines"/>.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareGlobalFunction("TensorSum");
#############################################################################

#############################################################################
##
#F SolutionMatModN
##
## <#GAPDoc Label="solutionmatmodn">
## <ManSection>
##   <Oper Name="SolutionMatModN" Arg="mat,vec,N"/>
##   <Description>
##     Solve the linear system <C>sol*mat=vec</C> modulo <A>N</A>.
##     The arguments are assumed to be an integer matrix and vector.
##     Either returns an integer solution, or <K>fail</K> if no such
##     solution exists.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="SolutionMatMod1" Arg="mat,vec"/>
##   <Description>
##     Solve the linear system <C>sol*mat=vec</C> in <M>Q/Z</M>.
##     The arguments are assumed to be rational matrices.
##     Assuming there are finitely many solutions, returns them all.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="CyclotomicByArgument" Arg="q"/>
##   <Returns>The cyclotomic field element equal to <M>\exp(2\pi i q)</M>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Oper Name="ArgumentOfCyclotomic" Arg="z"/>
##   <Returns>The rational <M>q</M> such that <M>\exp(2\pi i q)=z</M>.</Returns>
## </ManSection>
## <#/GAPDoc>
##
DeclareOperation("SolutionMatModN", [IsMatrix,IsVector,IsPosInt]);
DeclareOperation("SolutionMatMod1", [IsMatrix,IsVector]);

DeclareOperation("CyclotomicByArgument", [IsRat]);
DeclareOperation("ArgumentOfCyclotomic", [IsCyc]);
#############################################################################

#############################################################################
##
#F Projective representations
##
## <#GAPDoc Label="projreps">
## <ManSection>
##   <Prop Name="IsProjectiveRepresentation" Arg="rep"/>
##   <Prop Name="IsLinearRepresentation" Arg="rep"/>
##   <Description>
##     A projective representation is a mapping to matrices, that is
##     multiplicative up to scalars. This property is set by the following
##     functions that create projective representations.
##     <P/>
##     The second property describes those projective representations
##     that are in fact homomorphisms.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="ProjectiveRepresentationByFunction" Arg="group matrixgroup function"/>
##   <Returns>A projective representation of <A>group</A>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Oper Name="LinearRepresentationByImages" Arg="group matrixgroup src dst"/>
##   <Returns>A linear representation of <A>group</A>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Oper Name="DegreeOfProjectiveRepresentation" Arg="rep"/>
##   <Returns>The dimension of the matrices in the image of <A>rep</A>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Oper Name="ProjectiveExtension" Arg="rep group"/>
##   <Returns>A projective representation of <A>group</A> whose restriction to <A>Source(rep)</A> (which is a subgroup of <A>group</A>) is <A>rep</A>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Oper Name="ProjectiveQuotient" Arg="rep hom"/>
##   <Returns>A projective representation of <A>Image(hom)</A> that comes from <A>rep</A>.</Returns>
## </ManSection>
## <#/GAPDoc>
##
DeclareProperty("IsProjectiveRepresentation", IsMapping);
DeclareProperty("IsLinearRepresentation", IsProjectiveRepresentation);
InstallTrueMethod(IsProjectiveRepresentation, IsLinearRepresentation);

DeclareAttribute("IrreducibleRepresentations@", IsGroup);

DeclareOperation("ProjectiveRepresentationByFunction", [IsDomain,IsDomain,IsFunction]);
DeclareOperation("LinearRepresentationByImages", [IsDomain,IsDomain,IsList,IsList]);

DeclareAttribute("DegreeOfProjectiveRepresentation", IsProjectiveRepresentation);
DeclareOperation("TensorProductOp", [IsProjectiveRepresentation,IsProjectiveRepresentation]);

DeclareOperation("ProjectiveExtension", [IsProjectiveRepresentation,IsGroup]);
DeclareOperation("ProjectiveQuotient", [IsProjectiveRepresentation,IsGroupHomomorphism]);

DeclareAttribute("CoboundaryMatrix", IsGroup);
DeclareOperation("AreCohomologous", [IsList,IsList,IsGroup]);

DeclareAttribute("EpimorphismSchurCover@", IsGroup);

#############################################################################

#############################################################################
##
#H WordGrowth(g)
##
## <#GAPDoc Label="WordGrowth">
## <ManSection>
##   <Func Name="WordGrowth" Arg="g,rec(options...)"/>
##   <Func Name="WordGrowth" Arg="g:options..." Label="1arg"/>
##   <Func Name="OrbitGrowth" Arg="g,point[,limit]"/>
##   <Func Name="Ball" Arg="g,radius"/>
##   <Func Name="Sphere" Arg="g,radius"/>
##   <Returns>The word growth of the semigroup <A>g</A>.</Returns>
##   <Description>
##     This function computes the first terms of growth series associated
##     with the semigroup <A>g</A>. The argument <A>g</A> can actually be
##     a group/monoid/semigroup, or a list representing that semigroup's
##     generating set.
##
##     <P/> The behaviour of <C>WordGrowth</C> is controlled via options
##     passed in the second argument, which is a record. They can be combined
##     when reasonable, and are: <List>
##     <Mark><C>limit:=n</C></Mark> <Item> to specify a limit
##       radius;</Item>
##     <Mark><C>sphere:=radius</C></Mark> <Item> to return the sphere
##       of the specified radius, unless a radius was specified in
##       <C>limit</C>, in which case the value is ignored;</Item>
##     <Mark><C>spheres:=maxradius</C></Mark> <Item> to return the list
##       of spheres of radius between 0 and the specified limit;</Item>
##     <Mark><C>spheresizes:=maxradius</C></Mark> <Item> to return the list
##       sizes of spheres of radius between 0 and the specified limit;</Item>
##     <Mark><C>ball:=radius</C></Mark> <Item> to return the ball
##       of the specified radius;</Item>
##     <Mark><C>balls:=maxradius</C></Mark> <Item> to return the list
##       of balls of radius between 0 and the specified limit;</Item>
##     <Mark><C>ballsizes:=maxradius</C></Mark> <Item> to return the list
##       sizes of balls of radius between 0 and the specified limit;</Item>
##     <Mark><C>indet:=z</C></Mark> <Item> to return the
##       <C>spheresizes</C>, as a polynomial in <C>z</C> (or the first
##       indeterminate if <C>z</C> is not a polynomial;</Item>
##     <Mark><C>draw:=filename</C></Mark> <Item> to create a
##       rendering of the Cayley graph of <A>g</A>. Edges are
##       given colours according to the cyclic ordering "red", "blue",
##       "green", "gray", "yellow", "cyan", "orange", "purple".
##       If <C>filename</C> is a string, the graph is appended,
##       in <K>dot</K> format, to that file. Otherwise, the output is converted
##       to Postscript using the program <K>neato</K> from the
##       <Package>graphviz</Package> package, and displayed in a separate
##       X window using the program <Package>display</Package> or
##       <Package>rsvg-view</Package>.
##       This works on UNIX systems.
##       <P/> It is assumed, but not checked, that <Package>graphviz</Package>
##       and <Package>display</Package>/<Package>rsvg-view</Package> are
##       properly installed on the system. The option <K>usesvg</K> requests
##       the use of <Package>rsvg-view</Package>; by default,
##       <Package>display</Package> is used.
##       </Item>
##     <Mark><C>point:=p</C></Mark> <Item> to compute the
##       growth of the orbit of <C>p</C> under <A>g</A>, rather than the growth
##       of <A>g</A>.</Item>
##     <Mark><C>track:=true</C></Mark> <Item> to keep track of a word in the
##       generators that gives the element. This affects the "ball", "balls",
##       "sphere" and "spheres" commands, where the result returned is a
##       3-element list: the first entry is the original results; the
##       second entry is a homomorphism from a free group/monoid/semigroup;
##       and the third entry contains the words corresponding to the first
##       entry via the homomorphism.</Item>
##     </List>
##
##     If the first argument is an integer <C>n</C> and not a record,
##     the command is interpreted as
##     <C>WordGrowth(...,rec(spheresizes:=n))</C>.
##
##     <P/> <C>WordGrowth(...,rec(draw:=true))</C> may be abbreviated as
##     <C>Draw(...)</C>; <C>WordGrowth(...,rec(ball:=n))</C> may be
##     abbreviated as <C>Ball(...,n)</C>; <C>WordGrowth(...,rec(sphere:=n))</C>
##     may be abbreviated as <C>Sphere(...,n)</C>;
## <Example><![CDATA[
## gap> WordGrowth(GrigorchukGroup,4);
## [ 1, 4, 6, 12, 17 ]
## gap> WordGrowth(GrigorchukGroup,rec(limit:=4,indet:=true));
## 17*x_1^4+12*x_1^3+6*x_1^2+4*x_1+1
## gap> WordGrowth(GrigorchukGroup,rec(limit:=1,spheres:=true));
## [ [ <Mealy element on alphabet [ 1, 2 ] with 1 state, initial state 1> ],
##   [ d, b, c, a ] ]
## gap> WordGrowth(GrigorchukGroup,rec(point:=[2,2,2]));
## [ 1, 1, 1, 1, 1, 1, 1, 1 ]
## gap> OrbitGrowth(GrigorchukGroup,[1,1,1]);
## [ 1, 2, 2, 1, 1, 1 ]
## gap> WordGrowth(GrigorchukGroup,rec(spheres:=4,point:=PeriodicList([],[2])));
## [ [ [/ 2 ] ], [ [ 1, / 2 ] ], [ [ 1, 1, / 2 ] ], [ [ 2, 1, / 2 ] ],
##   [ [ 2, 1, 1, / 2 ] ] ]
## gap> WordGrowth([(1,2),(2,3)],rec(spheres:=infinity,track:=true));
## [ [ [  ], [ (2,3), (1,2) ], [ (), (1,2,3), (1,3,2) ], [ (1,3) ] ],
##   MappingByFunction( <free semigroup on the generators [ s1, s2 ]>, <group>, function( w ) ... end ),
##   [ [  ], [ s2, s1 ], [ s2^2, s2*s1, s1*s2 ], [ s2*s1*s2 ] ] ]
## ]]></Example>
##     Note that the orbit growth of <C>[/2]</C> is constant 1, while
##     that of <C>[/1]</C> is constant 2.
##     The following code would find the point with maximal orbit growth
##     of a semigroup acting on the integers (for example, constructed with
##     <Ref Meth="PermGroup"/>):
## <Listing>
## MaximalOrbitGrowth := function(g)
##     local maxpt, growth, max;
##     maxpt := LargestMovedPoint(g);
##     growth := List([1..maxpt],n->WordGrowth(g:point:=n));
##     max := Maximum(growth);
##     return [max,Filtered([1..maxpt],n->growth[n]=max)];
## end;
## </Listing>
##
##     <P/> For example, the command
##     <C>Draw(BasilicaGroup,rec(point:=PeriodicList([],[2,1]),limit:=3));</C>
##     produces (in a new window) the following picture:
##     <Alt Only="LaTeX"><![CDATA[
##       \includegraphics[height=5cm,keepaspectratio=true]{basilica-ball.jpg}
##     ]]></Alt>
##     <Alt Only="HTML"><![CDATA[
##       <img alt="Nucleus" src="basilica-ball.jpg">
##     ]]></Alt>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareGlobalFunction("WordGrowth");
DeclareGlobalFunction("OrbitGrowth");
DeclareOperation("Ball",[IsObject,IsInt]);
DeclareOperation("Sphere",[IsObject,IsInt]);
#############################################################################

#############################################################################
##
#H StringByInt
##
## <#GAPDoc Label="Helpers">
## <ManSection>
##   <Func Name="StringByInt" Arg="n[,b]"/>
##   <Returns>A string representing <A>n</A> in base <A>b</A>.</Returns>
##   <Description>
##     This function converts a positive integer to string. It accepts
##     an optional second argument, which is a base in which to
##     print <A>n</A>. By default, <A>b</A> is 2.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="PositionInTower" Arg="t,x"/>
##   <Returns>The largest index such that <C>t[i]</C> contains <A>x</A>.</Returns>
##   <Description>
##     This function assumes <A>t</A> is a descending tower of domains, such
##     as that constructed by <C>LowerCentralSeries</C>. It returns the largest
##     integer <C>i</C> such that <C>t[i]</C> contains <A>x</A>; in case the
##     tower ends precisely with <A>x</A>, the value <K>infinity</K> is
##     returned.
##
##     <P/> <A>x</A> can be an element or a subdomain of <C>t[1]</C>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="RenameSubobjects" Arg="obj,refobj"/>
##   <Description>
##     This function traverses <A>obj</A> if it is a list or a record, and,
##     when it finds an element which has no name, but is equal (in the sense
##     of <C>=</C>) to an element of <A>refobj</A>, assigns it the name of
##     that element.
## <Example><![CDATA[
## gap> trivial := Group(());; SetName(trivial,"trivial");
## gap> a := List([1..10],i->Group(Random(SymmetricGroup(3))));
## [ Group([ (2,3) ]), Group([ (2,3) ]), Group([ (1,3) ]), Group([ (1,3) ]),
##   Group([ (1,3,2) ]), Group([ (1,3,2) ]), Group([ (1,2) ]), Group(()),
##   Group([ (2,3) ]), Group([ (1,3,2) ]) ]
## gap> RenameSubobjects(a,[trivial]); a;
## [ Group([ (2,3) ]), Group([ (2,3) ]), Group([ (1,3) ]), Group([ (1,3) ]),
##   Group([ (1,3,2) ]), Group([ (1,3,2) ]), Group([ (1,2) ]), trivial,
##   Group([ (2,3) ]), Group([ (1,3,2) ]) ]
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="CoefficientsInAbelianExtension" Arg="x,b,G"/>
##   <Returns>The coefficients in <A>b</A> of the element <A>x</A>, modulo <A>G</A>.</Returns>
##   <Description>
##     If <A>b</A> is a list of group elements <M>b_1,\ldots,b_k</M>, and
##     <M>H=\langle G,b_1,\ldots,b_k\rangle</M> contains <A>G</A> as a
##     normal subgroup, and <M>H/G</M> is abelian and <M>x\in H</M>,
##     then this function computes exponents <M>e_1,\ldots,e_k</M> such that
##     <M>\prod b_i^{e_i}G=xG</M>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="MagmaEndomorphismByImagesNC" Arg="f,im"/>
##   <Returns>An endomorphism of <A>f</A>.</Returns>
##   <Description>
##     This function constructs an endomorphism of the group,monoid or
##     semigroup <A>f</A> specified by sending generator number <M>i</M>
##     to the <M>i</M>th entry in <A>im</A>. It is a shortcut for a call
##     to <C>GroupHomomorphismByImagesNC</C> or
##     <C>MagmaHomomorphismByFunctionNC(...,MappedWord(...))</C>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="MagmaHomomorphismByImagesNC" Arg="f,g,im"/>
##   <Returns>An homomorphism from <A>f</A> to <A>g</A>.</Returns>
##   <Description>
##     This function constructs a homomorphism of the group,monoid or
##     semigroup <A>f</A> specified by sending generator number <M>i</M>
##     to the <M>i</M>th entry in <A>im</A>. It is a shortcut for a call
##     to <C>GroupHomomorphismByImagesNC</C> or
##     <C>MagmaHomomorphismByFunctionNC(...,MappedWord(...))</C>.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareGlobalFunction("StringByInt");
DeclareGlobalFunction("PositionInTower");
DeclareOperation("RenameSubobjects",[IsObject,IsList]);
DeclareOperation("Draw",[IsBinaryRelation]);
DeclareOperation("Draw",[IsBinaryRelation,IsString]);
DeclareGlobalFunction("CoefficientsInAbelianExtension");
DeclareGlobalFunction("MagmaEndomorphismByImagesNC");
DeclareGlobalFunction("MagmaHomomorphismByImagesNC");
#############################################################################

#############################################################################
##
#H ShortMonoidRelations
##
## <#GAPDoc Label="ShortMonoidRelations">
## <ManSection>
##   <Oper Name="ShortGroupRelations" Arg="g,n"/>
##   <Oper Name="ShortMonoidRelations" Arg="g,n"/>
##   <Returns>A list of relations between words over <A>g</A>, of length at most <A>n</A>.</Returns>
##   <Description>
##     This function assumes that <A>g</A> is a list of monoid elements.
##     it searches for products of at most <A>n</A> elements over <A>g</A>
##     that are equal.
##
##     <P/> In its first form, it returns a list of words in a free group
##     <C>f</C> of rank the length of <A>g</A>, that are trivial in <A>g</A>.
##     The first argument may be a group, in which case its symmetric
##     generating set is considered.
##
##     <P/> In its second form, it returns a list of pairs
##     <C>[l,r]</C>, where <C>l</C> and <C>r</C> are words in a free
##     monoid <C>f</C> of rank the length of <A>g</A>, that are equal in
##     <A>g</A>. The first argument may be a monoid, in which case its monoid
##     generating set is considered.
##
##     <P/> This command does not construct all such pairs; rather, it returns
##     a small set, in the hope that it may serve as a presentation for
##     the monoid generated by <A>g</A>.
##
##     <P/> The first element of the list returned is actually not a relation:
##     it is a homomorphism from <C>f</C> to [the group/monoid
##     generated by] <A>g</A>.
## <Example><![CDATA[
## gap> ShortGroupRelations(GrigorchukGroup,10);
## [ [ x1, x2, x3, x4 ] -> [ a, b, c, d ],
##   x1^2, x2^2, x3^2, x4^2, x2*x3*x4, x4*x1*x4*x1*x4*x1*x4*x1,
##   x3*x1*x3*x1*x3*x1*x3*x1*x3*x1*x3*x1*x3*x1*x3*x1 ]
## gap> ShortGroupRelations(GuptaSidkiGroup,9);
## [ [ x1, x2 ] -> [ x, gamma ],
##   x1^3, x2^3, x2*x1^-1*x2*x1^-1*x2*x1^-1*x2*x1^-1*x2*x1^-1*x2*x1^-1*
##      x2*x1^-1*x2*x1^-1*x2*x1^-1,    x1^-1*x2^-1*x1^-1*x2^-1*x1^-1*x2^-1*
## x1^-1*x2^-1*x1^-1*x2^-1*x1^-1*x2^-1*x1^-1*x2^-1*x1^-1*x2^-1*x1^-1*x2^-1 ]
## ]]></Example>
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="ShortGroupWordInSet" Arg="g,s,n"/>
##   <Oper Name="ShortMonoidWordInSet" Arg="g,s,n"/>
##   <Oper Name="ShortSemigroupWordInSet" Arg="g,s,n"/>
##   <Returns>Words over <A>g</A> that express elements of <A>s</A>.</Returns>
##   <Description>
##     This command produces words in the free group/monoid/semigroup
##     generated by <A>g</A>'s generators that express elements of the set
##     <A>s</A>. Elements of length at most <A>AbsoluteValue(n)</A> are
##     searched; if <A>n</A> is non-negative then at most one element is
##     returned. The value <C><A>n</A>=infinity</C> is allowed.
##
##     <P/> The second argument may be either a list, a predicate
##     (i.e. a function returning <K>true</K> or <K>false</K>) or an element.
##
##     <P/> The function returns a list of words in the free
##     group/monoid/semigroup; the first entry of the list is a
##     homomorphism from the free group/monoid/semigroup to <A>g</A>.
## <Example><![CDATA[
## gap> l := ShortMonoidWordInSet(Group((1,2),(2,3),(3,4)),
##             [(1,2,3,4),(4,3,2,1)],-3);
## [ MappingByFunction( <free monoid on the generators [ m1, m2, m3 ]>, Group(
##     [ (1,2), (2,3), (3,4) ]), function( w ) ... end ), m3*m2*m1, m1*m2*m3 ]
## gap> f := Remove(l,1);;
## gap> List(l,x->x^f);
## [ (1,2,3,4), (1,4,3,2) ]
## gap> ShortMonoidWordInSet(GrigorchukGroup,
##        [Comm(GrigorchukGroup.1,GrigorchukGroup.2)],4);
## [ MappingByFunction( <free monoid on the generators [ m1, m2, m3, m4
##      ]>, <self-similar monoid over [ 1 .. 2 ] with
##     4 generators>, function( w ) ... end ), m1*m2*m1*m2 ]
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareOperation("ShortMonoidRelations",[IsObject,IsInt]);
DeclareOperation("ShortGroupRelations",[IsObject,IsInt]);
DeclareOperation("ShortGroupWordInSet",[IsGroup,IsObject,IsObject]);
DeclareOperation("ShortMonoidWordInSet",[IsMonoid,IsObject,IsObject]);
DeclareOperation("ShortSemigroupWordInSet",[IsSemigroup,IsObject,IsObject]);
#############################################################################

#############################################################################
##
#H Braid groups
##
## <#GAPDoc Label="Braids">
## <ManSection>
##   <Func Name="SurfaceBraidFpGroup" Arg="n,g,p"/>
##   <Func Name="PureSurfaceBraidFpGroup" Arg="n,g,p"/>
##   <Returns>The [pure] surface braid group on <A>n</A> strands.</Returns>
##   <Description>
##     This function creates a finitely presented group, isomorphic to the
##     [pure] braid group on <A>n</A> strands of the surface of genus <A>g</A>,
##     with <A>p</A> punctures. In particular,
##     <C>SurfaceBraidFpGroup(n,0,1)</C> is the usual braid group
##     (on the disc).
##
##     <P/> The presentation comes from <Cite Key="MR2043362"/>. The first
##     <M>2g</M> generators are the standard <M>a_i,b_i</M> surface
##     generators; the next <M>n-1</M> are the standard <M>s_i</M> braid
##     generators; and the last are the extra <M>z</M> generators.
##
##     <P/> The pure surface braid group is the kernel of the natural map
##     from the surface braid group to the symmetric group on <A>n</A>
##     points, defined by sending <M>a_i,b_i,z</M> to the identity and
##     <M>s_i</M> to the transposition <C>(i,i+1)</C>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="CharneyBraidFpGroup" Arg="n"/>
##   <Returns>The braid group on <A>n</A> strands.</Returns>
##   <Description>
##     This function creates a finitely presented group, isomorphic to the
##     braid group on <A>n</A> strands (on the disc). It is isomorphic to
##     <C>SurfaceBraidFpGroup(n,0,1)</C>, but has a different presentation,
##     due to Charney (<Cite Key="MR1314589"/>), with one generator per
##     non-trivial permutation of <A>n</A> points.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="ArtinRepresentation" Arg="n"/>
##   <Returns>The braid group's representation on <C>FreeGroup(n)</C>.</Returns>
##   <Description>
##     This function creates a Artin's representatin, a homomorphism from the
##     braid group on <A>n</A> strands (on the disc) into the automorphism
##     group of a free group of rank <A>n</A>.
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareGlobalFunction("SurfaceBraidFpGroup");
DeclareGlobalFunction("PureSurfaceBraidFpGroup");
DeclareGlobalFunction("CharneyBraidFpGroup");
DeclareGlobalFunction("ArtinRepresentation");
#############################################################################

#############################################################################
##
#H Posets
##
## <#GAPDoc Label="Posets">
## <ManSection>
##   <Func Name="Draw" Arg="p" Label="poset"/>
##   <Func Name="HeightOfPoset" Arg="p"/>
##   <Returns>The length of a maximal chain in the poset.</Returns>
##   <Description>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareAttribute("HeightOfPoset", IsBinaryRelation);
#############################################################################

#############################################################################
##
#H Find incompressible elements
##
## <#GAPDoc Label="">
## <ManSection>
##   <Func Name="" Arg=""/>
##   <Returns>.</Returns>
##   <Description>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
if false then
G := BinaryKneadingGroup(1/6);
S := [G.1,G.2,G.3];
pi := DecompositionOfFRElement(G);

EasyReduce := function(x)
  local e, i, verygeod, geod;
  e := ShallowCopy(ExtRepOfObj(x));
  verygeod := true;
  geod := true;
  for i in [2,4..Length(e)] do
    if e[i]=-1 then e[i] := 1; fi;
    if e[i] >= 2 or e[i] <= -2 then
      e[i] := RemInt(RemInt(e[i],2)+2,2);
      verygeod := false;
      if e[i-1] >= 2 then geod := false; fi;
    fi;
  od;
  return [ObjByExtRep(FamilyObj(x),e),geod,verygeod];
end;

MakeIncompressible := function(n)
  local inc, ginc, i;

  inc := [[One(G)],[G.1,G.2,G.3],Difference(Ball(G,2),Ball(G,1))];
  ginc := Ball(G,2);

  for i in [3..n] do
    inc[i+1] := Filtered(List(Cartesian(inc[i],[G.1,G.2,G.3]),p->p[1]*p[2]),function(g)
      local x;
      x := pi(g);
      return EasyReduce(g)[3] and x[1][1] in ginc and x[1][2] in ginc and EasyReduce(x[1][1])[2] and EasyReduce(x[1][2])[2];
    end);
    Append(ginc,inc[i+1]);
  od;
  return ginc;
end;
fi;
#############################################################################

#############################################################################
##
#M LowerCentralSeries etc. for algebras
##
## <#GAPDoc Label="LowerCentralSeries">
## <ManSection>
##   <Func Name="ProductIdeal" Arg="a,b"/>
##   <Func Name="ProductBOIIdeal" Arg="a,b"/>
##   <Returns>the product of the ideals <A>a</A> and <A>b</A>.</Returns>
##   <Description>
##     The first command computes the product of the left ideal <A>a</A> and
##     the right ideal <A>b</A>. If they are not appropriately-sided ideals,
##     the command first attempts to convert them.
##
##     <P/> The second command assumes that the ring of these ideals has a
##     basis made of invertible elements. It is then much easier to compute
##     the product.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Func Name="DimensionSeries" Arg="a[,n]"/>
##   <Returns>A nested list of ideals in the algebra-with-one <A>a</A>.</Returns>
##   <Description>
##     This command computes the powers of the augmentation ideal of <A>a</A>,
##     and returns their list. The list stops when the list becomes
##     stationary.
##
##     <P/> The optional second argument gives a limit to the number of
##     terms to put in the series.
## <Example><![CDATA[
## gap> a := ThinnedAlgebraWithOne(GF(2),GrigorchukGroup);
## <self-similar algebra-with-one on alphabet GF(2)^2 with 4 generators>
## gap> q := MatrixQuotient(a,3);
## <algebra-with-one of dimension 22 over GF(2)>
## gap> l := DimensionSeries(q);
## [ <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (5 generators)>,
##   <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (dimension 21)>,
##   <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (dimension 18)>,
##   <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (dimension 14)>,
##   <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (dimension 10)>,
##   <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (dimension 6)>,
##   <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (dimension 3)>,
##   <two-sided ideal in <algebra-with-one of dimension 22 over GF(2)>, (dimension 1)>,
##   <algebra of dimension 0 over GF(2)> ]
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
##
DeclareOperation("ProductIdeal",[IsAlgebra,IsAlgebra]);
DeclareOperation("ProductBOIIdeal",[IsAlgebra,IsAlgebra]);
DeclareOperation("DimensionSeries",[IsAlgebra]);
DeclareOperation("DimensionSeries",[IsAlgebra,IsInt]);
#############################################################################

#############################################################################
## <#GAPDoc Label="dirichlet">
## <ManSection>
##   <Oper Name="DirichletSeries" Arg="" Label="0"/>
##   <Oper Name="DirichletSeries" Arg="maxdeg" Label="md"/>
##   <Oper Name="DirichletSeries" Arg="indices, coeffs [maxdeg]" Label="ic"/>
##   <Oper Name="DirichletSeries" Arg="series, maxdeg" Label="sm"/>
##   <Description>
##     Creates a new Dirichlet series, namely, a formal power series
##     of the form <M>f(s)=\sum_{n\ge1} a(n) n^{-s}</M>. Such series have
##     a maximal degree, which may be <K>infinity</K>, and may be added
##     or multiplied as polynomials.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Attr Name="DegreeDirichletSeries" Arg="f"/>
##   <Returns>The maximal degree of a non-zero coefficient of <A>f</A>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Attr Name="SpreadDirichletSeries" Arg="f,n"/>
##   <Returns>The series <M>f(ns)</M>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Attr Name="ShiftDirichletSeries" Arg="s,n"/>
##   <Returns>The series <M>n^{-s}f(s)</M>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Attr Name="ShrunkDirichletSeries" Arg="f"/>
##   <Returns>The series <A>f</A>, with maximal precision set to its maximal degree.</Returns>
## </ManSection>
##
## <ManSection>
##   <Attr Name="ZetaSeriesOfGroup" Arg="G"/>
##   <Returns>The series <A>\sum_{\chi\in\widehat G}(\dim G)^{-s}</A>.</Returns>
## </ManSection>
##
## <ManSection>
##   <Attr Name="ValueOfDirichletSeries" Arg="f, s"/>
##   <Returns>The evaluation of <A>f</A> at <A>s</A>. Synonym for <C>Value</C>.</Returns>
## </ManSection>
##
## <#/GAPDoc>
DeclareCategory("IsDirichletSeries",IsRingElementWithOne);
BindGlobal("DS_FAMILY", NewFamily("DS_FAMILY", IsDirichletSeries));
DeclareOperation("DirichletSeries", [IsInt]);
DeclareOperation("DirichletSeries", []);
DeclareOperation("DirichletSeries", [IsList,IsList]);
DeclareOperation("DirichletSeries", [IsList,IsList,IsInt]);
DeclareOperation("DirichletSeries", [IsDirichletSeries,IsInt]);
DeclareAttribute("DegreeOfDirichletSeries", IsDirichletSeries);
DeclareOperation("SpreadDirichletSeries", [IsDirichletSeries,IsInt]);
DeclareOperation("ShiftDirichletSeries", [IsDirichletSeries,IsInt]);
DeclareOperation("ShrunkDirichletSeries", [IsDirichletSeries]);
DeclareOperation("ZetaSeriesOfGroup", [IsGroup]);
DeclareOperation("ValueDirichletSeries", [IsDirichletSeries,IsRingElement]);
#############################################################################

#############################################################################
## <#GAPDoc Label="fpliealgebra">
## <ManSection>
##   <Filt Name="IsFpLieAlgebra"/>
##   <Description>
##     The category of Lie algebras coming from a finitely presented group.
##     They appear as the <Ref Oper="JenningsLieAlgebra" BookName="ref"/>
##     of a finitely presented group.
##
##     <P/> If <C>G</C> is an infinite, finitely presented group, then
##     the original implementation of <Ref Oper="JenningsLieAlgebra"
##     BookName="ref"/> does not return. On the other hand, the implementation
##     in <Package>FR</Package> constructs a graded object, for which
##     the graded components are computed on-demand; see
##     <Ref Oper="JenningsLieAlgebra"/>.
##   </Description>
## </ManSection>
##
## <ManSection>
##   <Oper Name="JenningsLieAlgebra" Arg="ring, fpgroup"/>
##   <Returns>The Jennings Lie algebra of <A>fpgroup</A>.</Returns>
##   <Description>
##     This method does not compute the Jennings Lie algebra <E>per se</E>;
##     it merely constructs a placeholder to contain the result.
## <Example><![CDATA[
## gap> f := FreeGroup(4);
## <free group on the generators [ f1, f2, f3, f4 ]>
## gap> surfacegp := f/[Comm(f.1,f.2)*Comm(f.3,f.4)];
## <fp group of size infinity on the generators [ f1, f2, f3, f4 ]>
## gap> j := JenningsLieAlgebra(Rationals,surfgp);
## <FP Lie algebra over Rationals>
## gap> List([1..4],Grading(j).hom_components);
## [ <vector space over Rationals, with 4 generators>,
##   <vector space over Rationals, with 5 generators>,
##   <vector space over Rationals, with 16 generators>,
##   <vector space over Rationals, with 45 generators> ]
## gap> B := Basis(Grading(j).hom_components(1));
## gap> B[1]*B[2]+B[3]*B[4];
## <zero Lie element>
## ]]></Example>
##   </Description>
## </ManSection>
## <#/GAPDoc>
DeclareRepresentation("IsLieFpElementRep",
        IsPositionalObjectRep and IsAttributeStoringRep,[]);
DeclareCategory("IsFpLieAlgebra",IsLieAlgebra);

DeclareHandlingByNiceBasis("IsLieFpElementSpace",
        "FR: for FP Lie algebras");
#############################################################################

#E helpers.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
