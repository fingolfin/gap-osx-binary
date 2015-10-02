#############################################################################
##
##  HAPPRIME - resolutions.gi
##  Functions, Operations and Methods for resolutions
##  Paul Smith
##
##  Copyright (C) 2007-2008
##  Paul Smith
##  National University of Ireland Galway
##
##  This file is part of HAPprime. 
## 
##  HAPprime is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
## 
##  HAPprime is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
## 
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
## 
##  $Id: resolutions.gi 351 2008-11-27 13:10:26Z pas $
##
#############################################################################

#####################################################################
##  <#GAPDoc Label="ResolutionPrimePowerGroupGF_manResolution">
##  <ManSection Label="ResolutionPrimePowerGroup">
##  <Heading>ResolutionPrimePowerGroup</Heading>
##  <Oper Name="ResolutionPrimePowerGroupRadical" Arg="G, n" Label="for group"/>
##  <Oper Name="ResolutionPrimePowerGroupGF" Arg="G, n" Label="for group"/>
##  <Oper Name="ResolutionPrimePowerGroupAutoMem" Arg="G, n" Label="for group"/>
##  <Oper Name="ResolutionPrimePowerGroupGF2" Arg="G, n" Label="for group"/>
##  <Oper Name="ResolutionPrimePowerGroupRadical" Arg="M, n" Label="for module"/>
##  <Oper Name="ResolutionPrimePowerGroupGF" Arg="M, n" Label="for module"/>
##  <Oper Name="ResolutionPrimePowerGroupAutoMem" Arg="M, n" Label="for module"/>
##  <Oper Name="ResolutionPrimePowerGroupGF2" Arg="M, n" Label="for module"/>
##
##  <Returns>
##  <K>HAPResolution</K>
##  </Returns>
##  <Description>
##  Returns <A>n</A> terms of a minimal free &FG;-resolution for either the 
##  ground ring of a prime power group <A>G</A> or of a module <A>M</A>. 
##  For the module version, <A>M</A> must be passed as an <K>FpGModuleGF</K> 
##  object - 
##  see <Ref Chap="FG-modules" BookName="HAPprime Datatypes"/> in the
##  &HAPprime; datatypes reference manual.
##  <P/>
##  Three versions of this function are provided:
##  <List>
##    <Mark><K>ResolutionPrimePowerGroupRadical</K></Mark><Item>uses the same 
##      resolution-building method as the &HAP; function
##      <Ref Func="ResolutionPrimePowerGroup" BookName="HAP"/>, but stores the 
##      resolution in a different format that takes only about half the memory of 
##      the &HAP; version.</Item>
##    <Mark><K>ResolutionPrimePowerGroupGF</K></Mark><Item>calculates the 
##      resolution using &HAPprime;'s &G;-generator form of modules, which
##      reduces memory use by around a factor of two over 
##      <K>ResolutionPrimePowerGroupRadical</K>,
##      but is slower by an order of magnitude.</Item>
##    <Mark><K>ResolutionPrimePowerGroupAutoMem</K></Mark><Item> automatically 
##      switches between the two previous versions based on the available memory. 
##      It uses the <C>Radical</C> version until it gets close to the limit of the 
##      available memory, and then switches to the <C>GF</C> version.</Item>
##    <Mark><K>ResolutionPrimePowerGroupGF2</K></Mark><Item>calculates the 
##      resolution by &FG;-matrix partitioning. The amount of partitioning
##      is governed by the <Ref Chap="Options Stack" BookName="ref"/> option
##      <C>MaxFGExpansionSize</C>. The default value means that until the 
##      boundary map takes about 128Mb, the method is equivalent to 
##      <K>ResolutionPrimePowerGroupRadical</K>, and then it tends towards
##      <K>ResolutionPrimePowerGroupGF</K> in terms of time, but saves less
##      memory.</Item>
##  </List>
##  See the &HAPprime; datatypes reference manual for details of 
##  the different algorithms, in particular the chapters on the &G;-generator
##  form of &FG;-modules 
##  <Ref Chap="FG-modules" BookName="HAPprime Datatypes"/>
##  and &FG;-module homomorphisms 
##  <Ref Chap="FG-module homomorphisms" BookName="HAPprime Datatypes"/>
##  and on resolutions 
##  <Ref Chap="Resolutions" BookName="HAPprime Datatypes"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ResolutionPrimePowerGroupRadical,
  "generic method",
  [IsGroup, IsPosInt],
  function(G, n)
  local R, i;

  R := LengthOneResolutionPrimePowerGroup(G);

  for i in [2..n] do
    R := ExtendResolutionPrimePowerGroupRadical(R);
  od;

  return R;

end);
#####################################################################
InstallMethod(ResolutionPrimePowerGroupGF,
  [IsGroup, IsPosInt],
  function(G, n)
  local R, i;

  R := LengthOneResolutionPrimePowerGroup(G);

  for i in [2..n] do
    R := ExtendResolutionPrimePowerGroupGF(R);
  od;

  return R;

end);
#####################################################################
InstallMethod(ResolutionPrimePowerGroupAutoMem,
  [IsGroup, IsPosInt],
  function(G, n)
  local R, i;

  R := LengthOneResolutionPrimePowerGroup(G);

  for i in [2..n] do
    R := ExtendResolutionPrimePowerGroupAutoMem(R);
  od;

  return R;

end);
#####################################################################
InstallMethod(ResolutionPrimePowerGroupGF2,
  [IsGroup, IsPosInt],
  function(G, n)
  local R, i;

  R := LengthOneResolutionPrimePowerGroup(G);

  for i in [2..n] do
    R := ExtendResolutionPrimePowerGroupGF2(R);
  od;

  return R;

end);
#####################################################################
InstallMethod(ResolutionPrimePowerGroupRadical,
  [IsFpGModuleGF, IsPosInt],
  function(M, n)
  local R, i;

  R := LengthZeroResolutionPrimePowerGroup(M);

  for i in [1..n] do
    R := ExtendResolutionPrimePowerGroupRadical(R);
  od;

  return R;

end);
#####################################################################
InstallMethod(ResolutionPrimePowerGroupGF,
  [IsFpGModuleGF, IsPosInt],
  function(M, n)
  local R, i;

  R := LengthZeroResolutionPrimePowerGroup(M);

  for i in [1..n] do
    R := ExtendResolutionPrimePowerGroupGF(R);
  od;

  return R;

end);
#####################################################################
InstallMethod(ResolutionPrimePowerGroupAutoMem,
  [IsFpGModuleGF, IsPosInt],
  function(M, n)
  local R, i;

  R := LengthZeroResolutionPrimePowerGroup(M);

  for i in [1..n] do
    R := ExtendResolutionPrimePowerGroupAutoMem(R);
  od;

  return R;

end);
#####################################################################
InstallMethod(ResolutionPrimePowerGroupGF2,
  [IsFpGModuleGF, IsPosInt],
  function(M, n)
  local R, i;

  R := LengthZeroResolutionPrimePowerGroup(M);

  for i in [1..n] do
    R := ExtendResolutionPrimePowerGroupGF2(R);
  od;

  return R;

end);
#####################################################################





#####################################################################
##  <#GAPDoc Label="ExtendResolutionPrimePowerGroup_manResolution">
##  <ManSection Label="ExtendResolutionPrimePowerGroup">
##  <Heading>ExtendResolutionPrimePowerGroup</Heading>
##  <Oper Name="ExtendResolutionPrimePowerGroupRadical" Arg="R"/>
##  <Oper Name="ExtendResolutionPrimePowerGroupGF" Arg="R"/>
##  <Oper Name="ExtendResolutionPrimePowerGroupAutoMem" Arg="R"/>
##  <Oper Name="ExtendResolutionPrimePowerGroupGF2" Arg="R"/>
##
##  <Returns>
##    <K>HAPResolution</K>
##  </Returns>
##  <Description>
##    Returns the resolution <A>R</A> extended by one term. 
##    The three variants offer a choice between memory and speed, and correspond
##    to the different versions of <K>ResolutionPrimePowerGroup</K> in 
##    &HAPprime;. See the documentation 
##    (<Ref Label="ResolutionPrimePowerGroup" Text="above"/>) for those 
##    functions for a description of the different variants.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ExtendResolutionPrimePowerGroupRadical,
  "generic method",
  [IsHapResolution],
  function(R)

    local phi, kernel;

    # Get the boundary homomorphism for the last stage in the resolution
    phi := BoundaryFpGModuleHomomorphismGF(R, ResolutionLength(R));

    # Now find its kernel
    kernel := KernelOfModuleHomomorphism(phi);

    # and get the minimal generators using the radical
    kernel := HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive(
      ModuleGenerators(kernel), ModuleGroupAndAction(kernel));

    Info(InfoHAPprime, 1, "Dimension ", ResolutionLength(R)+1, 
      ": rank ", ModuleRank(kernel));
    # And define the next homomorphism to be the one that maps onto
    # this kernel, i.e. the matrix generators for the kernel is the 
    # generating matrix for the homomorphism
    return HAPPRIME_AddNextResolutionBoundaryMapNC(R, ModuleGenerators(kernel));
end);
#####################################################################
InstallMethod(ExtendResolutionPrimePowerGroupGF,
  "generic method",
  [IsHapResolution],
  function(R)

    local kernel, phi;

    # Get the boundary homomorphism for the last stage in the resolution
    phi := BoundaryFpGModuleHomomorphismGF(R, ResolutionLength(R));

    # Now find its kernel
    kernel := MinimalGeneratorsModuleGF(KernelOfModuleHomomorphismSplit(phi));
    kernel := ReverseEchelonModuleGeneratorsDestructive(kernel);

    Info(InfoHAPprime, 1, "Dimension ", ResolutionLength(R)+1, 
      ": rank ", ModuleRank(kernel));
    # And define the next homomorphism to be the one that maps onto
    # this kernel, i.e. the matrix generators for the kernel is the 
    # generating matrix for the homomorphism
    return HAPPRIME_AddNextResolutionBoundaryMapNC(R, ModuleGenerators(kernel));
end);
#####################################################################
InstallMethod(ExtendResolutionPrimePowerGroupGF2,
  [IsHapResolution],
  function(R)

    local kernel, phi, maxsize;

    # Get the boundary homomorphism for the last stage in the resolution
    phi := BoundaryFpGModuleHomomorphismGF(R, ResolutionLength(R));

    # Now find its kernel
    Info(InfoHAPprime, 2, "Computing kernel");
    kernel := KernelOfModuleHomomorphismGF(phi);
    
    Info(InfoHAPprime, 2, "Kernel found. Finding minimal generators");
    # Now find the minimal generators. Use the MaxFGExpansionSize option to
    # choose whether to use Radical or not
    maxsize := HAPPRIME_ValueOptionMaxFGExpansionSize(
      ModuleField(kernel), ModuleGroup(kernel));
    if Product(DimensionsMat(ModuleGenerators(kernel)))*
      ModuleGroupAndAction(kernel).actionBlockSize < maxsize then
        kernel := MinimalGeneratorsModuleRadical(kernel);
    else
      kernel := MinimalGeneratorsModuleGF(kernel);
    fi;

    Info(InfoHAPprime, 1, "Dimension ", ResolutionLength(R)+1, 
      ": rank ", ModuleRank(kernel));
    # And define the next homomorphism to be the one that maps onto
    # this kernel, i.e. the matrix generators for the kernel is the 
    # generating matrix for the homomorphism
    return HAPPRIME_AddNextResolutionBoundaryMapNC(R, ModuleGenerators(kernel));
end);
#####################################################################
InstallMethod(ExtendResolutionPrimePowerGroupAutoMem,
  "generic method",
  [IsHapResolution],
  function(R)

    local size, radicalcomputebyes, memfree, orderG, nGgens;

    # Radical needs about 2.1*10^-3 Mb/dim^2 to compute the next one 
    # (where dim is the dimension of the most recent stage)
    # or 1.9*10^-3 Mb/dim^2 to compute the next one 
    # (where dim is the dimension of the stage it's computing)

    # GF needs about 0.6*10^-3 Mb/dim^2 to compute the next one 
    # (where dim is the dimension of the most recent or next stage)

    orderG := Order(ResolutionGroup(R));
    nGgens := Length(MinimalGeneratingSet(ResolutionGroup(R)));
    # How big is the current one?
    size := ResolutionModuleRank(R, ResolutionLength(R));
    radicalcomputebyes := Int(orderG * orderG * nGgens * size * size / 5); # In bytes
    GASMAN("collect");
    memfree := GasmanStatistics().full.freekb;
    memfree := memfree + GasmanLimits().max - GasmanStatistics().full.totalkb;
    memfree := memfree * 1024; # convert to bytes
    # Allow a factor of two spare
    if memfree > (radicalcomputebyes * 2) then
      return ExtendResolutionPrimePowerGroupRadical(R);
    else
      return ExtendResolutionPrimePowerGroupGF(R);
    fi;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="LengthOneResolutionPrimePowerGroup_DTmanResolution_Con">
##  <ManSection>
##  <Func Name="LengthOneResolutionPrimePowerGroup" Arg="G"/>
##
##  <Returns>
##  <K>HAPResolution</K>
##  </Returns>
##  <Description>
##  Returns a free &FG;-resolution of length 1 for group <A>G</A> 
##  (which must be of a prime power), i.e. the resolution
##  <Alt Only="LaTeX">
##  <Display>
##  \mathbb{F}G^{k_1} \rightarrow \mathbb{F}G \twoheadrightarrow \mathbb{F}
##  </Display>
##  </Alt>
##  <Alt Not="LaTeX">
##  <Display>
##  FG^k ---> FG --->> F
##  </Display>
##  </Alt>
##  This function requires very little calculation: the first 
##  stage of the resolution can simply be stated given a set of minimal 
##  generators for the group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(LengthOneResolutionPrimePowerGroup,
  "method for prime power groups",
  [IsGroup],
  function(G)
  
  local 
    field,
    orderG,
    eltsG,
    gensGpos,
    one,
    BoundaryMatrices,
    x;

  # Check that this group is a prime power group
  if IsPGroup(G) = false then
    Error("<G> must be a small prime power group");
  fi;

  # Remember various useful things
  orderG := Order(G);
  field := GaloisField(PrimePGroup(G));
  one := Identity(field);

  # Which elements in Elements(G) are the generators of the group?
  eltsG := Elements(G);
  gensGpos := List(MinimalGeneratingSet(G), x->Position(eltsG, x));

  # We know what the boundary is for the first degree
  # It's e1 -> 1 - g1
  #      e2 -> 1 - g2
  # and so on, for all of the generating set
  BoundaryMatrices := [[], NullMat(Length(gensGpos), orderG, field)];
  for x in [1..Length(gensGpos)] do
    BoundaryMatrices[2][x][1] := one;
    BoundaryMatrices[2][x][gensGpos[x]] := one;
  od;
  ConvertToMatrixRepNC(BoundaryMatrices[1], field);

  return HAPPRIME_CreateResolutionWithBoundaryMapMatsNC(G, BoundaryMatrices);

end);

#####################################################################
##  <#GAPDoc Label="LengthZeroResolutionPrimePowerGroup_DTmanResolution_Con">
##  <ManSection>
##  <Func Name="LengthZeroResolutionPrimePowerGroup" Arg="M"/>
##
##  <Returns>
##  <K>HAPResolution</K>
##  </Returns>
##  <Description>
##  Returns a minimal free &FG;-resolution of length 0 for the 
##  <K>FpGModuleGF</K> module <A>M</A>, i.e. the resolution 
##  <Alt Only="LaTeX">
##  <Display>
##  \mathbb{F}G^{k_0} \twoheadrightarrow M
##  </Display>
##  </Alt>
##  <Alt Not="LaTeX">
##  <Display>
##  FG^k --->> M
##  </Display>
##  </Alt>
##  This function requires little calculation since the the first 
##  stage of the resolution can simply be stated if the module has minimal 
##  generators: each standard generator of the zeroth-degree module <M>M_0</M>
##  maps onto a generator of <A>M</A>. If <A>M</A> does not have minimal 
##  generators, they are calculated using 
##  <Ref Oper="MinimalGeneratorsModuleRadical"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(LengthZeroResolutionPrimePowerGroup,
  "method for prime power groups",
  [IsFpGModuleGF],
  function(M)
  
  local N, gens, G;

  # Find the minimal generators of the module. If it's already minimal,
  # this will do nothing
  N := MinimalGeneratorsModuleRadical(M);
  gens := ModuleGenerators(N);
  G := ModuleGroup(N);
  
  # We can now state the boundary homomorphism: it's the one that maps the
  # standard generators of the free module onto this module
  # It's e1 -> g1
  #      e2 -> g2
  # and so on
  return HAPPRIME_CreateResolutionWithBoundaryMapMatsNC(G, [gens]);
      
end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="ResolutionLength_DTmanResolution_Dat">
##  <ManSection>
##  <Meth Name="ResolutionLength" Arg="R"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the length (i.e. the maximum index <M>k</M>) in the resolution 
##  <A>R</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ResolutionLength,
  [IsHapResolution],
  function(R)

    local length;

    length := EvaluateProperty(R, "length");
    if IsInt(length) = false then
      Error("no valid length property in resolution <R>");
    fi;

    return length;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ResolutionGroup_DTmanResolution_Dat">
##  <ManSection>
##  <Meth Name="ResolutionGroup" Arg="R"/>
##
##  <Returns>
##  Group
##  </Returns>
##  <Description>
##  Returns the group of the resolution <A>R</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ResolutionGroup,
  "generic method",
  [IsHapResolution],
  function(R)

    return R!.group;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ResolutionFpGModuleGF_DTmanResolution_Dat">
##  <ManSection>
##  <Meth Name="ResolutionFpGModuleGF" Arg="R, k"/>
##
##  <Returns>
##  <K>FpGModuleGF</K>
##  </Returns>
##  <Description>
##  Returns the module <M>M_k</M> in the resolution <A>R</A>, as a
##  <K>FpGModuleGF</K> (see Chapter <Ref Chap="FpGModuleGF"/>), assuming the 
##  canonical action.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ResolutionFpGModuleGF,
  "generic method",
  [IsHapResolution, IsInt],
  function(R, k)
    local gens;
    # The modules in the resolution are all FG^n except (possibly) for the
    # zeroth one, which might be any module (if the resolution is the 
    # resolution of a module). But the homomorphism phi_1 onto the 
    # zeroth module is an 'onto' mapping, so we can just look at the
    # image of that one to find what the module is in that case
    if k >= 0 then
      return FpGModuleGF(ResolutionGroup(R), ResolutionModuleRank(R, k));
    elif k = -1 then
      return FpGModuleGFNC(
        HAPPRIME_BoundaryMapMatrix(R, 0), 
        CanonicalGroupAndAction(ResolutionGroup(R)),
        "minimal");
    else; 
      Error("<k> must be greater or equal to zero (or -1 for module resolutions)");
    fi; 
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ResolutionModuleRank_DTmanResolution_Dat">
##  <ManSection>
##  <Meth Name="ResolutionModuleRank" Arg="R, k"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the &FG; rank of the <A>k</A>th module <M>M_k</M> in the 
##  resolution.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ResolutionModuleRank,
  "generic method",
  [IsHapResolution, IsInt],
  function(R, k)
    return R!.dimension(k);
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ResolutionModuleRanks_DTmanResolution_Dat">
##  <ManSection>
##  <Meth Name="ResolutionModuleRanks" Arg="R"/>
##
##  <Returns>
##  List of integers
##  </Returns>
##  <Description>
##  Returns a list containg the &FG; rank of the each of the 
##  modules <M>M_k</M> in the resolution <A>R</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ResolutionModuleRanks,
  "generic method",
  [IsHapResolution],
  function(R)
    return List([1..ResolutionLength(R)], i->R!.dimension(i));
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="BoundaryFpGModuleHomomorphismGF_DTmanResolution_Dat">
##  <ManSection>
##  <Meth Name="BoundaryFpGModuleHomomorphismGF" Arg="R, k"/>
##
##  <Returns>
##  <K>FpGModuleHomomorphismGF</K>
##  </Returns>
##  <Description>
##  Returns the <A>k</A>th boundary map in the resolution <A>R</A>, 
##  as a <K>FpGModuleHomomorphismGF</K>. This represents the linear homomorphism 
##  <M>d_k: M_k \rightarrow M_{k-1}</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(BoundaryFpGModuleHomomorphismGF,
  "generic method",
  [IsHapResolution, IsInt],
  function(R, k) 

    local G, gensmat;

    if k > ResolutionLength(R) then
      Error("<k> must be no greater than the length of the resolution <R>");
    fi;

    G := ResolutionGroup(R);
    gensmat := HAPPRIME_BoundaryMapMatrix(R, k);
    # gensmat is the boundary map matrix. It has as many rows as the generators
    # of the source FG module and as many columns as the ambient dimension 
    # of the target FG module

    return FpGModuleHomomorphismGFNC(
      ResolutionFpGModuleGF(R, k), ResolutionFpGModuleGF(R, k-1), gensmat);
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ResolutionsAreEqual_DTmanResolution_Dat">
##  <ManSection>
##  <Oper Name="ResolutionsAreEqual" Arg="R, S"/>
##
##  <Returns>
##    Boolean
##  </Returns>
##  <Description>
##  Returns <K>true</K> if the resolutions appear to be equal, <K>false</K> 
##  otherwise.
##  This compares the torsion coefficients of the homology from the two
##  resolutions.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ResolutionsAreEqual,
  [IsHapResolution, IsHapResolution],
  function(R, S)

    local kR, kS, 
    dimR, dimS, 
    boundaryR, boundaryS,
    i;
  
    kR := ResolutionLength(R);
    if kR < 2 then
      Error("Resolution <R> must be of at least length 2.\n");
    fi;
  
    kS := ResolutionLength(S);
    if kS < 2 then
      Error("Resolution <S> must be of at least length 2.\n");
    fi;

    if kS <> kR then
      return false;
    fi;

    # Make sure they're over the field of 2
    R := TensorWithIntegersModP(R, 2);
    S := TensorWithIntegersModP(S, 2);

    dimR := List([1..(kR-1)], i->Homology(R, i));
    dimS := List([1..(kS-1)], i->Homology(S, i));

    if dimR = dimS then
      return true;
    else
      return false;
    fi;

  end
);
######################################################


#####################################################################
##  <#GAPDoc Label="BestCentralSubgroupForResolutionFiniteExtension_DTmanResolution_Misc">
##  <ManSection>
##  <Oper Name="BestCentralSubgroupForResolutionFiniteExtension" Arg="G [, n]"/>
##
##  <Returns>
##    Group
##  </Returns>
##  <Description>
##  Returns the central subgroup of <A>G</A> that is likely to give the smallest
##  module ranks when using the &HAP; function 
##  <Ref Func="ResolutionFiniteExtension" BookName="HAP"/>. That function 
##  computes a non-minimal resolution for <A>G</A> from the twisted tensor
##  product of resolutions for a normal subgroup 
##  <Alt Only="LaTeX"><M>N \vartriangleleft G</M></Alt>
##  <Alt Not="LaTeX"><M>N</M></Alt>
##  and the quotient group <M>G/N</M>. The ranks of the modules in the 
##  resolution for <M>G</M> are the products of the module ranks of the
##  resolutions for these smaller groups. This function tests <A>n</A> terms
##  of the minimal resolutions for all the central subgroups of <M>G</M> and
##  the corresponding quotients to find the subgroup/quotient pair with the
##  smallest module ranks. If <A>n</A> is not provided, then <M>n=5</M> is used.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallOtherMethod(BestCentralSubgroupForResolutionFiniteExtension,
  [IsGroup],
  function(G)
    return BestCentralSubgroupForResolutionFiniteExtension(G, 5);
  end
);
#####################################################################
InstallMethod(BestCentralSubgroupForResolutionFiniteExtension,
  [IsGroup, IsPosInt],
  function(G, n)

    local Ns, sizes, i, R, S;
    
    if not IsPGroup(G) then
      Error("<G> must be a p-group");
    fi;

    # Get all (non-trivial) subgroups
    Ns := NormalSubgroups(Centre(G));
    Ns := Filtered(Ns, x->(Order(x) > 1 and Order(x) < Order(G)));

    if Order(G) = 2 then
      Error("no non-trivial normal subgroup of <G>");
    fi;
      
    
    sizes := [];
    for i in Ns do
      R := ResolutionPrimePowerGroup(i, n);
      S := ResolutionPrimePowerGroup(G/i, n);
      Add(sizes, ResolutionModuleRanks(R) * ResolutionModuleRanks(S));
    od;
    
    return Ns[Position(sizes, Minimum(sizes))];
  end
);
######################################################


  
#####################################################################
#####################################################################
#####################################################################
##
##     INTERNAL FUNCTIONS
##
#####################################################################
#####################################################################
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_WordToVector_DTmanResolutionInt">
##  <ManSection>
##  <Meth Name="HAPPRIME_WordToVector" Arg="w, dim, orderG"/>
##
##  <Returns>
##    &HAP; word (list of lists)
##  </Returns>
##  <Description>
##  Returns the boundary map vector that corresponds to the &HAP;
##  word vector <A>w</A> with module ambient dimension <A>dim</A> and 
##  group order <A>orderG</A> (assumed to be the <C>actionBlockSize</C>). 
##  A &HAP; word vector has the following format: 
##  <C>[ [block, elm], [block, elm], ... ]</C> where <C>block</C> is
##  a block number and <C>elm</C> is a group element index (see example below).
##  <P/>
##  See also <Ref Func="HAPPRIME_VectorToWord"/>
##  </Description>
##  </ManSection>
##  <Example><![CDATA[
##  gap> G := CyclicGroup(4);;
##  gap> v := HAPPRIME_WordToVector([ [1,2],[2,3] ], 2, Order(G));
##  <a GF2 vector of length 8>
##  gap> HAPPRIME_DisplayGeneratingRows([v], CanonicalGroupAndAction(G));
##  [.1..|..1.]
##  gap> HAPPRIME_VectorToWord(v, Order(G));
##  [ [ 1, 2 ], [ 2, 3 ] ]
##  ]]></Example>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_WordToVector,
  "generic method",
  [IsVector, IsPosInt, IsPosInt],
  function(w, dim, orderG)
    local v, x, a, idx, primeG;
  
    # Make an set of vectors of the correct size initialised to zero
    # i.e. Dimension(k) set of vectors of size orderG
    v := ListWithIdenticalEntries(dim * orderG, 0);
  
    # Now increment counts in the vectors according to the information
    # in the words
    for x in w do
      a := AbsoluteValue(x[1]);
      idx := (a-1)*orderG + x[2];
      v[idx] := v[idx] + SignInt(x[1]);
    od;
  
    # What is the prime for this group order?
    primeG := SSortedList(Factors(orderG))[1];
    # And make sure that the counts are still within the field
    v := (v mod primeG) * Identity(GaloisField(primeG));
    ConvertToVectorRepNC(v, primeG);
    return v;
  end);
#####################################################################

  
#####################################################################
##  <#GAPDoc Label="HAPPRIME_VectorToWord_DTmanResolutionInt">
##  <ManSection>
##  <Func Name="HAPPRIME_VectorToWord" Arg="vec, orderG"/>
##
##  <Returns>
##    Vector
##  </Returns>
##  <Description>
##  The <Package>HAP</Package> word format vector that corresponds to the 
##  boundary vector <A>vec</A> with <C>actionBlockSize</C> assumed to be 
##  <A>orderG</A>. 
##  <P/>
##  See <Ref Func="HAPPRIME_WordToVector"/> for a few more details and an
##  example.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_VectorToWord,
  "generic method",
  [IsVector, IsPosInt],
  function(vec, orderG)
    local v, w, grp, elt, x;

    # Convert the vector to integers rather than field elements
    v := ShallowCopy(vec);
    Apply(v, i->IntFFE(i));

    # Build up the words. We will add a word (or words) for each
    # non-zero element in the vector.
    w := [];
    grp := 0;
    for x in [1..Length(v)] do
      # Which group element is this and which set of the group
      elt := (x-1) mod orderG + 1;
      if elt = 1 then
        grp := grp + 1; 
      fi;
      if v[x] <> 0 then 
        Append(w, MultiplyWord(v[x], [ [grp, elt] ]));
      fi;
    od;
  
    return w;
  end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="HAPPRIME_BoundaryMatrices_DTmanResolutionInt">
##  <ManSection>
##  <Attr Name="HAPPRIME_BoundaryMatrices" Arg="R"/>
##
##  <Returns>
##    List of matrices
##  </Returns>
##  <Description>
##  If <A>R</A> is a resolution which stores its boundaries as a list of 
##  matrices (e.g. one created by &HAPprime;, this list is 
##  returned. Otherwise, <C>fail</C> is returned. Note that the first matrix
##  in this list corresponds to the zeroth degree: for resolutions of modules,
##  this is the generators of the module; for resolutions of groups, this is
##  the empty matrix. The second matrix corresponds to the first degree, and 
##  so on.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_BoundaryMatrices,
  [IsHapResolution],
  function(R) 
    local store, BndMats;  
  
  store := EvaluateProperty(R, "boundaryStore");
  if store = "matrix" then  
    return R!.boundaryMatrices;
  else
    return fail;
  fi;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_BoundaryMapMatrix_DTmanResolutionInit">
##  <ManSection>
##  <Meth Name="HAPPRIME_BoundaryMapMatrix" Arg="R, k"/>
##
##  <Description>
##  The list of generating vectors for the <A>k</A>th boundary 
##  homomorphism from the resolution <A>R</A> 
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_BoundaryMapMatrix,
  "generic method",
  [IsHapResolution, IsInt],
  function(R, k) 
  local Be, i;

  Be := HAPPRIME_BoundaryMatrices(R);
  if Be <> fail then  
    if k < Length(Be) then
      if k <> 0 then 
        return Be[k+1];
      elif k = 0 then 
        if not IsEmpty(Be[1]) then
          return Be[1];
        else
          Error("unable to return the boundary matrix for the 0th boundary in a group resolution");
        fi;
      else
        Error("<k> must be greater than (or maybe equal to) zero");
      fi;
    else  
      Error("<k> must be less than or equal to the length of <R>");
    fi;
  else
    Be := []; # The boundary matrix that maps the identity of each group
              # This is given directly from the boundary maps we have
  
    # Boundary(k,i) gives the ith boundary map for degree k.
    # There are Dimension(k) of these
    # and each one gives mappings into degree k-1
    for i in [1..R!.dimension(k)] do
      # Convert each Boundary into vector representation
      Be[i] := HAPPRIME_WordToVector(
        R!.boundary(k, i), R!.dimension(k-1), Order(R!.group));
    od;
    return Be;
  fi;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_AddNextResolutionBoundaryMapMatNC_DTmanResolutionInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_AddNextResolutionBoundaryMapMatNC" Arg="R, BndMat"/>
##
##  <Returns>
##    <C>HapResolution</C>
##  </Returns>
##  <Description>
##  Returns the resolution <A>R</A> extended by one term, where that term is given 
##  by the boundary map matrix <A>BndMat</A>. If <A>BndMat</A> is not already in
##  compressed matrix form, it will be converted into this form, and if the 
##  boundaries in <A>R</A> are not already in matrix form, they are all 
##  converted into this form.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_AddNextResolutionBoundaryMapNC,
  "generic",
  [IsHapResolution, IsMatrix],
  function(R, BndMat)

  local
    G,              # The group
    orderG,         # The order of the group
    primeG,         # The field size (the prime of the order of the group)
    BoundaryMatrices, # The set of all the boundary words
    length,         # The length of the input resolution
    i, j;

  # Remember various useful things
  G := R!.group;
  orderG := Order(G);
  primeG := PrimePGroup(G);
  
  # Are the boundary matrices stored in this resolution?
  BoundaryMatrices := ShallowCopy(HAPPRIME_BoundaryMatrices(R));

  if BoundaryMatrices = fail then
    # If we don't have them as matrices already, get them from the resolution
    # and convert them to matrices
    length := ResolutionLength(R);
  
    # Check that the boundary matrix is in the correct field
    if Field(BndMat[1][1]) <> GaloisField(primeG) then
      Error("<BndMat> has elements in the wrong field for resolution <R>");
    fi;
  
    # And copy the Boundaries (as words) from the previous resolution into
    # the new one
    BoundaryMatrices := [];
    for i in [1..(length)] do
      BoundaryMatrices[i]:=[];
    od;
    for i in [1..length] do
      for j in [1..R!.dimension(i)] do
        Add(BoundaryMatrices[i], 
          HAPPRIME_WordToVector(R!.boundary(i,j), R!.dimension(i-1), orderG));
      od;
      ConvertToMatrixRepNC(BoundaryMatrices[i], primeG);
    od;
  fi;
    
  # Now add the new one
  ConvertToMatrixRepNC(BndMat, primeG);
  Add(BoundaryMatrices, BndMat);
  
  return HAPPRIME_CreateResolutionWithBoundaryMapMatsNC(G, BoundaryMatrices);
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_CreateResolutionWithBoundaryMapMatsNC_DTmanResolutionInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_CreateResolutionWithBoundaryMapMatsNC" Arg="G, BndMats"/>
##
##  <Returns>
##    <C>HapResolution</C>
##  </Returns>
##  <Description>
##  Returns a &HAP; resolution object for group <A>G</A> where 
##  the module homomorphisms are given by the boundary matrices in the list
##  <A>BndMats</A>. This list is indexed with the boundary matrix for
##  degree <E>zero</E> as the first element. If the resolution is 
##  the resolution of a module, the module's minimal generators are this
##  first boundary matrix, otherwise (for the resolution of a group), this
##  should be set to be the empty matrix <C>[]</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_CreateResolutionWithBoundaryMapMatsNC,
  "generic method",
  [IsGroup, IsList],
  function(G, BndMats)

  local
  # Global variables
    orderG,         # The order of the group
    primeG,         # The field size (the prime of the order of the group)
    eltsG,          # The elements of the group
    test,
  # Functions
    Dimension,
    Boundary,
    Homotopy;

  #####################################################################
  # What is the dimension of the module of degree i?
  #  This determines the answer by looking at the number of boundary maps
  #  for that degree (there is one for each basis vector, i.e. one for each
  #  dimension)
  Dimension:=function(i);
    if i < 0 then 
      return 0; 
    elif i=0 then 
      if IsEmpty(BndMats[1]) then
        return 1;
      else
        return Length(BndMats[1]);
      fi;
    elif i >= Length(BndMats) then
      return fail;
    else
      return Length(BndMats[i+1]);
    fi;
  end;
  #####################################################################
  
  #####################################################################
  # Returns the jth boundary map for degree i
  # This will be a list of the form of pairs of lists
  # e.g. [ [ 1, 1 ], [ 1, 2 ] ] where the first number in each list
  # is the basis vector number and the second number is the group element 
  # number
  # If j is negative then the basis vector number is negated, indicating
  # that it should be subtracted.
  Boundary := function(i, j);
    if (i > 0 and i < Length(BndMats)) or (i = 0 and not IsEmpty(BndMats[1])) then 
      if j > 0 then
        if j <= Length(BndMats[i+1]) then
          return HAPPRIME_VectorToWord(BndMats[i+1][j], orderG); 
        else
          Error("<j> is larger than the dimension of degree <i>");
        fi;
      else 
        if (-j) <= Length(BndMats[i+1]) then
          return NegateWord(
            HAPPRIME_VectorToWord(BndMats[i+1][-j], orderG));
        else
          Error("<-j> is larger than the dimension of degree <i>");
        fi;
      fi;
    fi;

    return fail;
  end;
  #####################################################################

  #####################################################################
  # Calculate the result of S_k * w where w is a word in dimension k and 
  # S_k is the contracting homotopy at degree k, i.e. a mapping from 
  # the degree k to degree k+1
  # This assumes that w is in the kernel of d_n
  Homotopy := function(k, w)
    local v;

    v := HAPPRIME_WordToVector(w, Dimension(k), orderG);
    v := SolutionMat(HAPPRIME_ExpandGeneratingRows(
      BndMats(k+2), G), v*One(GaloisField(PrimePGroup(G))));
    Apply(v, i->IntFFE(i));

    if v <> fail then 
      v := HAPPRIME_VectorToWord(v, orderG); 
    fi;
    return v;
  end;
  #####################################################################

  #####################################################################
  # THE MAIN FUNCTION

  # Remember various useful things
  orderG := Order(G);
  primeG := PrimePGroup(G);
  eltsG := Elements(G);
  # Check that the BndMats are consistent
  test := 1;
  if IsEmpty(BndMats[1]) then
    if Length(BndMats) = 1 then
      Error("if the first element of <BndMats> is empty, there must be another one");
    fi;
    test := 2;
  fi;
  if Field(BndMats[test][1][1]) <> GaloisField(primeG) then
    Error("the field of <BndMats> is not the same as the prime of <G>");
  fi;
  if not IsInt(Length(BndMats[test][1]) / orderG) then
    Error("the first vector in <BndMats> is not a multiple of order(<G>) in length");
  fi;

  return Objectify(
    HapResolution, rec(
      dimension := Dimension,
      boundary := Boundary,
      homotopy := fail,
      partialHomotopy := Homotopy,
      elts := eltsG,
      group := G,
      boundaryMatrices := BndMats,
      properties :=
      [ ["length", Length(BndMats) - 1],
        ["reduced", true],
        ["type", "resolution"],
        ["characteristic", primeG],
        ["isMinimal", true],
        ["boundaryStore", "matrix"] ]
    ));

end);
#####################################################################


