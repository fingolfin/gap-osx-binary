#############################################################################
##
##  HAPPRIME - fpgmodulehomG.gi
##  Functions, Operations and Methods to implement FG module homomorphisms
##  Paul Smith
##
##  Copyright (C)  2007-2008
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
##  $Id: fpgmodulehomG.gi 354 2008-12-09 17:38:12Z pas $
##
#############################################################################

#####################################################################
##  <#GAPDoc Label="FpGModuleHomomorphismGFRep_DTmanFpGModuleHomNODOC">
##  <ManSection>
##  <Filt Name="IsFpGModuleHomomorphismGFRep" Arg="O" Type="Representation"/>
##  <Description>
##  Returns <K>true</K> if <A>O</A> is in the internal representation used for 
##  a <K>FpGModuleHomomorphismGF</K>, or <K>false</K> otherwise
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
DeclareRepresentation(
  "IsFpGModuleHomomorphismGFRep",
  IsComponentObjectRep,
  ["source", "target", "generatormatrix"]);
# Note this also defines the function IsFpGModuleHomomorphismGFRep
#####################################################################

#####################################################################
# The type for FpGModuleHomomorphismGF is a 
# FpGModuleHomomorphismGF in 
# FpGModuleHomomorphismGFRep representation, in the 
# FpGModuleHomomorphismGF family
FpGModuleHomomorphismGFType := 
  NewType(NewFamily("FpGModuleHomomorphismGFFamily"), 
    IsFpGModuleHomomorphismGF and 
    IsFpGModuleHomomorphismGFRep);
#####################################################################
  
  

#####################################################################
##  <#GAPDoc Label="FpGModuleHomomorphismGF_DTmanFpGModuleHom_Con">
##  <ManSection>
##  <Heading>FpGModuleHomomorphismGF construction functions</Heading>
##  <Oper Name="FpGModuleHomomorphismGF" Arg="S, T, gens"/>
##  <Oper Name="FpGModuleHomomorphismGFNC" Arg="S, T, gens"/>
##
##  <Returns>
##  <K>FpGModuleHomomorphismGF</K>
##  </Returns>
##  <Description>
##  Creates and returns an <K>FpGModuleHomomorphismGF</K> module 
##  homomorphism object. This represents the homomorphism from the module 
##  <A>S</A> to the module <A>T</A> with a list of vectors <A>gens</A> whose 
##  rows are the images in <A>T</A> of the generators of <A>S</A>. The modules
##  must (currently) be over the same group.
##  <P/>
##  The standard constructor checks that the homomorphism is compatible with the modules,
##  i.e. that the vectors in <A>gens</A> have the correct dimension and that they 
##  lie within the target module <A>T</A>. It also checks whether the 
##  generators of <A>S</A> are minimal. If they are not, then the homomorphism 
##  is created with a copy of <A>S</A> that has minimal generators (using 
##  <Ref Oper="MinimalGeneratorsModuleRadical"/>), and <A>gens</A> 
##  is also copied and converted to agree with the new form of <A>S</A>. 
##  If you wish to skip these checks then use the <C>NC</C> version of this 
##  function.
##  <P/>
##  IMPORTANT: The generators of the module <A>S</A> and the generator matrix 
##  <A>gens</A> must be remain consistent for the lifetime of this homomorphism.
##  If the homomorphism is constructed with a mutable source module or generator
##  matrix, then you must be careful not to modify them while the homomorphism
##  is needed.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(FpGModuleHomomorphismGF,
  "generic method",
  [IsFpGModuleGF, IsFpGModuleGF, IsMatrix],
  function(S, T, gens)

    local Tspace, solns, s, minS, coeffs, minA, phi, im;

    # Check that the groups are the same
    if ModuleGroup(S) <> ModuleGroup(T) then
      Error("the groups of the modules <S> and <T> are not the same");
    fi;

    # Check that gens is the correct length for the number of generators
    if Length(gens) <> Length(ModuleGenerators(S)) then
      Error("<A> must have as many vectors as the number of generators of <S>");
    fi;

    # Check that vectors in A have the correct length
    if Length(gens[1]) <> ModuleAmbientDimension(T) then
      Error("vectors in <A> must be the same length as the ambient dimension of <T>");
    fi;

    Tspace := ModuleVectorSpaceBasis(T);
    solns := SolutionMat(Tspace, gens);
    for s in solns do
      if s = fail then
        Error("a vector in <A> does not lie in the target module <T>");
      fi;
    od;

    # If S are not minimal generators then we need to convert them and the
    # matrix A to minimal form
    if not ModuleGeneratorsAreMinimal(S) then
      minS := MinimalGeneratorsModuleRadical(S);

      # How do we express these minimal generators in terms of the orginal 
      # generators we were given?
      coeffs := HAPPRIME_ModuleGeneratorCoefficients(S, ModuleGenerators(minS));
      # Apply the same coeffs to the matrix we were given
      minA := HAPPRIME_GenerateFromGeneratingRowsCoefficients(
        gens, ModuleGroupAndAction(T), coeffs);

      # Now as a sanity check, let's make sure that the orginal generators of 
      # S map to the original rows of A using our new set of generators and
      phi := FpGModuleHomomorphismGFNC(minS, T, minA);
      im := ImageOfModuleHomomorphism(phi, ModuleGenerators(S));
      if im <> gens then
        Error("The generators of <S> are not minimal and the matrix <gens> is not consistent with them");  
      fi;
      return phi;
    else  
      return FpGModuleHomomorphismGFNC(S, T, gens);
    fi;
  end
);
#####################################################################
InstallOtherMethod(FpGModuleHomomorphismGF,
  "empty homomorphism",
  [IsFpGModuleGF, IsFpGModuleGF, IsEmpty],
  function(S, T, gens)

    local gensS, Tspace, s, solns;
  
    # Check that the groups are the same
    if ModuleGroup(S) <> ModuleGroup(T) then
      Error("the groups of the modules <S> and <T> are not the same");
    fi;

    # There should be no generators for S
    gensS := ModuleGenerators(S);
    if Length(gensS) <> 0 then
      Error("<gens> is empty, so <S> must have no generators");
    fi;

    # And the ambient dimension of T should be zero as well
    if ModuleAmbientDimension(T) <> 0 then
      Error("<gens> is empty, so the generators of <T> must be zero length");
    fi;
    return FpGModuleHomomorphismGFNC(S, T, gens);
  end
);
#####################################################################
InstallMethod(FpGModuleHomomorphismGFNC,
  "creates a object explicitly without checking",
  [IsFpGModuleGF, IsFpGModuleGF, IsMatrix],
  function(S, T, gens)

    return Objectify( 
      FpGModuleHomomorphismGFType, 
      rec(
        source := S, 
        target := T, 
        generatormatrix := gens));
  end
);
#####################################################################
InstallOtherMethod(FpGModuleHomomorphismGFNC,
  "creates a object explicitly without checking",
  [IsFpGModuleGF, IsFpGModuleGF, IsEmpty],
  function(S, T, A)

    # There should be no generators for S
    return Objectify( 
      FpGModuleHomomorphismGFType, 
      rec(
        source := S, 
        target := T, 
        generatormatrix := []));
  end
);
#####################################################################


#####################################################################
##  <#GAPDoc Label="SourceModule_DTmanFpGModuleHom_Dat">
##  <ManSection>
##  <Oper Name="SourceModule" Arg="phi"/>
##
##  <Returns>
##  <K>FpGModuleGF</K>
##  </Returns>
##  <Description>
##  Returns the source module for the homomorphism <A>phi</A>, as an
##  <K>FpGModuleGF</K>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  SourceModule,
  "generic method",
  [IsFpGModuleHomomorphismGF],
  function(phi)
    return phi!.source;
  end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="TargetModule_DTmanFpGModuleHom_Dat">
##  <ManSection>
##  <Oper Name="TargetModule" Arg="phi"/>
##
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns the targetmodule for the homomorphism <A>phi</A>, as an
##  <K>FpGModuleGF</K>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  TargetModule,
  "generic method",
  [IsFpGModuleHomomorphismGF],
  function(phi)
    return phi!.target;
  end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="ModuleHomomorphismGeneratorMatrix_DTmanFpGModuleHom_Dat">
##  <ManSection>
##  <Oper Name="ModuleHomomorphismGeneratorMatrix" Arg="phi"/>
##
##  <Returns>
##  List of vectors
##  </Returns>
##  <Description>
##  Returns the generating vectors <C>gens</C> of the representation of the 
##  homomorphism <A>phi</A>.
##  These vectors are the images in the target module of the
##  generators of the source module.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleHomomorphismGeneratorMatrix,
  "generic method",
  [IsFpGModuleHomomorphismGF],
  function(phi)
    return phi!.generatormatrix;
  end);
#####################################################################




#####################################################################
##  <#GAPDoc Label="ViewObj_DTmanFpGModuleHomNODOC">
##  <ManSection>
##  <Meth Name="ViewObj" Arg="phi" Label="for FpGModuleHomomorphismGF"/>
##
##  <Description>
##  Prints a short description of the module homomorphism <A>phi</A>. 
##  This is the usual description printed by &GAP;.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ViewObj,
  "for FpGModuleHomomorphismGF object",
  [IsFpGModuleHomomorphismGF],
  function(obj)
    Print("<Module homomorphism>\n");
  end);
#####################################################################


#####################################################################
# # <#GAPDoc Label="PrintObj_DTmanFpGModuleHomNODOC">
# # <ManSection>
# # <Meth Name="PrintObj" Arg="phi" Label="for FpGModuleHomomorphismGF"/>
# # 
# # <Description>
# # Prints a detailed description of the module homomorphism <A>phi</A>.
# # </Description>
# # </ManSection>
# # <#/GAPDoc>
#####################################################################
InstallMethod(
  PrintObj,
  "for FpGModuleHomomorphismGF object",
  [IsFpGModuleHomomorphismGF],
  function(obj)
    Print("Module homomorphism with source:\n");
    Print(SourceModule(obj));
    Print("and target:\n");
    Print(TargetModule(obj));
    Print("and generator matrix:\n");
    Print(ModuleHomomorphismGeneratorMatrix(obj));
    Print("\n");
  end);
#####################################################################

  
#####################################################################
# # <#GAPDoc Label="Display_DTmanFpGModuleHomNODOC">
# # <ManSection>
# # <Meth Name="Display" Arg="phi" Label="for FpGModuleHomomorphismGF"/>
# # 
# # <Description>
# # Prints a detailed description of the module homomorphism <A>phi</A> in 
# # human-readable form.
# # </Description>
# # </ManSection>
# # <#/GAPDoc>
#####################################################################
InstallMethod(
  Display,
  "for FpGModuleHomomorphismGF object",
  [IsFpGModuleHomomorphismGF],
  function(obj)
    Print("Module homomorphism with source:\n");
    Display(SourceModule(obj));
    Print("\nand target:\n");
    Display(TargetModule(obj));
    Print("\nand generator matrix:\n");
    HAPPRIME_DisplayGeneratingRows(
      ModuleHomomorphismGeneratorMatrix(obj), 
      ModuleGroupAndAction(TargetModule(obj)));
    Print("\n");
  end);
#####################################################################

  
#####################################################################
# # <#GAPDoc Label="DisplayBlocks_DTmanFpGModuleHom_Dat">
# # <ManSection>
# # <Meth Name="DisplayBlocks" Arg="phi" Label="for FpGModuleHomomorphismGF"/>
# # 
# #  <Returns>
# #  nothing
# #  </Returns>
# # <Description>
# # Prints a detailed description of the module in human-readable form,
# # with the module generators and generator matrix shown in block form.
# # The standard &GAP; methods <Ref Oper="View" BookName="ref"/>, 
# # <Ref Oper="Print" BookName="ref"/> and <Ref Oper="Display" BookName="ref"/>
# # are also available.)
# # </Description>
# # </ManSection>
# # <#/GAPDoc>
#####################################################################
InstallMethod(
  DisplayBlocks,
  "for FpGModuleHomomorphismGF object",
  [IsFpGModuleHomomorphismGF],
  function(obj)
    Print("Module homomorphism with source:\n");
    DisplayBlocks(SourceModule(obj));
    Print("\nand target:\n");
    DisplayBlocks(TargetModule(obj));
    Print("\nand generator matrix:\n");
    HAPPRIME_DisplayGeneratingRowsBlocks(
      ModuleHomomorphismGeneratorMatrix(obj), 
      ModuleGroupAndAction(TargetModule(obj)));
    Print("\n");
  end);
#####################################################################

  
#####################################################################
# # <#GAPDoc Label="DisplayModuleHomomorphismGeneratorMatrix_DTmanFpGModuleHom_Dat">
# # <ManSection>
# # <Meth Name="DisplayModuleHomomorphismGeneratorMatrix" Arg="phi"/>
# # 
# #  <Returns>
# #  nothing
# #  </Returns>
# # <Description>
# # Prints a detailed description of the module homomorphism generating vectors
# # <C>gens</C> in human-readable form. This is the display method used
# # in the <Ref Oper="Display" BookName="ref"/> method for this datatype.
# # </Description>
# # </ManSection>
# # <#/GAPDoc>
#####################################################################
InstallMethod(
  DisplayModuleHomomorphismGeneratorMatrix,
  "for FpGModuleHomomorphismGF object",
  [IsFpGModuleHomomorphismGF],
  function(obj)
    HAPPRIME_DisplayGeneratingRows(
      ModuleHomomorphismGeneratorMatrix(obj), 
      ModuleGroupAndAction(TargetModule(obj)));
    Print("\n");
  end);
#####################################################################

  

#####################################################################
# # <#GAPDoc Label="DisplayModuleHomomorphismGeneratorMatrixBlocks_DTmanFpGModuleHom_Dat">
# # <ManSection>
# # <Meth Name="DisplayModuleHomomorphismGeneratorMatrixBlocks" Arg="phi"/>
# # 
# #  <Returns>
# #  nothing
# #  </Returns>
# # <Description>
# # Prints a detailed description of the module homomorphism generating vectors
# # <C>gens</C> in human-readable form. This is the function used in the
# # <Ref Oper="DisplayBlocks" Label="for FpGModuleHomomorphismGF"/> method.
# # </Description>
# # </ManSection>
# # <#/GAPDoc>
#####################################################################
InstallMethod(
  DisplayModuleHomomorphismGeneratorMatrixBlocks,
  "for FpGModuleHomomorphismGF object",
  [IsFpGModuleHomomorphismGF],
  function(obj)
    HAPPRIME_DisplayGeneratingRowsBlocks(
      ModuleHomomorphismGeneratorMatrix(obj), 
      ModuleGroupAndAction(TargetModule(obj)));
    Print("\n");
  end);
#####################################################################

  

#####################################################################
# # <#GAPDoc Label="ImageOfModuleHomomorphism_DTmanFpGModuleHom_Ima">
# # <ManSection>
# # <Heading>ImageOfModuleHomomorphism</Heading>
# # <Oper Name="ImageOfModuleHomomorphism" Arg="phi" Label="image of homomorphism"/>
# # <Oper Name="ImageOfModuleHomomorphism" Arg="phi, M" Label="of module"/>
# # <Oper Name="ImageOfModuleHomomorphism" Arg="phi, elm" Label="of element"/>
# # <Oper Name="ImageOfModuleHomomorphism" Arg="phi, coll" Label="of collections of elements"/>
# # <Oper Name="ImageOfModuleHomomorphismDestructive" Arg="phi, elm" Label="of element"/>
# # <Oper Name="ImageOfModuleHomomorphismDestructive" Arg="phi, coll" Label="of collection of elements"/>
# # 
# #  <Returns>
# #  <K>FpGModuleGF</K>, vector or list of vectors depending on argument
# #  </Returns>
# # <Description>
# # For a module homomorphism <A>phi</A>, the one-argument function returns
# # the module that is the image of the homomorphism, while the two-argument
# # versions return the result of mapping of an <C>FpGModuleGF</C> <A>M</A>, a 
# # module element <A>elm</A> (given as a vector), or a collection of module 
# # elements <A>coll</A> through the homomorphism.
# # This uses standard linear algebra to find the image of elements from
# # the source module.
# # <P/>
# # The <C>Destructive</C> versions of the function will corrupt the
# # second parameter, which must be mutable as a result. The version of
# # this operation that returns a module does not guarantee that the module
# # will be in
# # minimal form, and one of &TheMinGenFuncs; should be used on the 
# # result if a minimal set of generators is needed. 
# # </Description>
# # </ManSection>
# # <#/GAPDoc>
#####################################################################
InstallMethod(
  ImageOfModuleHomomorphism,
  "method for homomorphism image",
  [IsFpGModuleHomomorphismGF],
  function(phi)
    return FpGModuleGFNC(
      ModuleHomomorphismGeneratorMatrix(phi),
      ModuleGroupAndAction(TargetModule(phi)), 
      "unknown");
  end);
#####################################################################
InstallMethod(
  ImageOfModuleHomomorphismDestructive,
  "method for mutable vector",
  [IsFpGModuleHomomorphismGF, IsVector and IsMutable],
  function(phi, elm)
    local Fbasis, w;

    # Find how to express v in terms of my module generators
    w := HAPPRIME_ModuleGeneratorCoefficientsDestructive(
      SourceModule(phi), elm);

    if w = fail then
      return fail;
    fi;

    return HAPPRIME_GenerateFromGeneratingRowsCoefficients(
      ModuleHomomorphismGeneratorMatrix(phi), 
      ModuleGroupAndAction(TargetModule(phi)), w);
  end);
#####################################################################
InstallMethod(
   ImageOfModuleHomomorphism,
  "method for vector",
  [IsFpGModuleHomomorphismGF, IsVector],
  function(phi, elm)
    local copy;
    copy := ShallowCopy(elm);
    return ImageOfModuleHomomorphismDestructive(phi, copy);
end);
#####################################################################
InstallMethod(
  ImageOfModuleHomomorphismDestructive,
  "method for mutable list of vectors",
  [IsFpGModuleHomomorphismGF, IsMatrix and IsMutable],
  function(phi, coll)
    local Fbasis, W, havefail, w, im;

    # Find how to express coll in terms of my module generators
    W := HAPPRIME_ModuleGeneratorCoefficientsDestructive(
      SourceModule(phi), coll);

    if IsMatrix(W) then
      return HAPPRIME_GenerateFromGeneratingRowsCoefficients(
        ModuleHomomorphismGeneratorMatrix(phi), 
        ModuleGroupAndAction(TargetModule(phi)), W);
    else
      im := [];
      for w in W do
        if w <> fail then
        Add(im, HAPPRIME_GenerateFromGeneratingRowsCoefficients(
            ModuleHomomorphismGeneratorMatrix(phi), 
            ModuleGroupAndAction(TargetModule(phi)), w));
        else
          Add(im, fail);
        fi;
      od;
      return im;
    fi;
  end);
#####################################################################
InstallMethod(
  ImageOfModuleHomomorphism,
  "method for list of vectors",
  [IsFpGModuleHomomorphismGF, IsMatrix],
  function(phi, coll)
    local copy;
    copy := MutableCopyMat(coll);
    return ImageOfModuleHomomorphismDestructive(phi, copy);
end);
#####################################################################
InstallMethod(
  ImageOfModuleHomomorphismDestructive,
  "method for modules",
  [IsFpGModuleHomomorphismGF, IsFpGModuleGF],
  function(phi, M)
    local gens;
    gens := ImageOfModuleHomomorphismDestructive(phi, ModuleGenerators(M));
    if not IsMatrix(gens) then
      return fail;
    fi;
    return FpGModuleGFNC(
      gens, ModuleGroupAndAction(TargetModule(phi)), "unknown");
end);
#####################################################################
InstallMethod(
  ImageOfModuleHomomorphism,
  "method for modules",
  [IsFpGModuleHomomorphismGF, IsFpGModuleGF],
  function(phi, M)
    return ImageOfModuleHomomorphismDestructive(phi, MutableCopyModule(M));
end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="PreImageRepresentativeOfModuleHomomorphism_DTmanFpGModuleHom_Ima">
##  <ManSection>
##  <Heading>PreImageRepresentativeOfModuleHomomorphism</Heading>
##  <Oper Name="PreImageRepresentativeOfModuleHomomorphism" Arg="phi, elm" Label="for element"/>
##  <Oper Name="PreImageRepresentativeOfModuleHomomorphism" Arg="phi, coll" Label="for collection of elements"/>
##  <Oper Name="PreImageRepresentativeOfModuleHomomorphism" Arg="phi, M" Label="for module"/>
##  <Oper Name="PreImageRepresentativeOfModuleHomomorphismGF" Arg="phi, elm" Label="for element"/>
##  <Oper Name="PreImageRepresentativeOfModuleHomomorphismGF" Arg="phi, coll" Label="for collection of elements"/>
##
##  <Description>
##  For an element <A>elm</A> in the image of <A>phi</A>, this returns a
##  representative of the set of preimages of <A>elm</A> under <A>phi</A>, 
##  otherwise it returns <C>fail</C>. If a list of vectors 
##  <A>coll</A> is provided then the function 
##  returns a list of preimage representatives, one for each element in the list
##  (the returned list can contain <C>fail</C> entries if there are vectors with 
##  no solution). For an <K>FpGModuleGF</K> module <A>M</A>, this returns a module 
##  whose image under <A>phi</A> is <A>M</A> (or <C>fail</C>). The module returned will
##  not necessarily have minimal generators, and one of &TheMinGenFuncs; 
##  should be used on the result if a minimal set of generators is needed. 
##  <P/>
##  The standard functions use linear algebra, expanding the generator matrix 
##  into a full matrix and using <Ref Func="SolutionMat" BookName="ref"/> to 
##  calculate a preimage of <A>elm</A>. In the case where a list of vectors is 
##  provided, the matrix decomposition is only performed once, which can save 
##  significant time.
##  <P/>
##  The <C>GF</C> versions of the functions can give a large memory saving
##  when the generators of the homomorphism <A>phi</A> are in echelon form,
##  and operate by doing back-substitution using the generator form of the 
##  matrices.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallOtherMethod(
  PreImageRepresentativeOfModuleHomomorphism,
  [IsFpGModuleHomomorphismGF, IsVector],
  function(phi, elm)
    local coeffs;
    coeffs := HAPPRIME_CoefficientsOfGeneratingRows(
      ModuleHomomorphismGeneratorMatrix(phi), 
      ModuleGroupAndAction(TargetModule(phi)), 
      elm);
    if coeffs <> fail then
      return HAPPRIME_ModuleElementFromGeneratorCoefficients(
        SourceModule(phi), coeffs);
    else
      return fail;
    fi;
  end);
#####################################################################
InstallMethod(
  PreImageRepresentativeOfModuleHomomorphism,
  [IsFpGModuleHomomorphismGF, IsMatrix],
  function(phi, coll)
    local coeffs, preim, c;
    coeffs := HAPPRIME_CoefficientsOfGeneratingRows(
      ModuleHomomorphismGeneratorMatrix(phi), 
      ModuleGroupAndAction(TargetModule(phi)), 
      coll);
    if IsMatrix(coeffs) then
      return HAPPRIME_ModuleElementFromGeneratorCoefficients(
        SourceModule(phi), coeffs);
    else
      preim := [];
      for c in coeffs do
        if c <> fail then
          Add(preim, HAPPRIME_ModuleElementFromGeneratorCoefficients(
            SourceModule(phi), c));
        else
          Add(preim, fail);
        fi;
      od;
      return preim;
    fi;
  end);
#####################################################################
InstallMethod(
  PreImageRepresentativeOfModuleHomomorphism,
  "generic method",
  [IsFpGModuleHomomorphismGF, IsFpGModuleGF],
  function(phi, M)
  
    local gens;
  
    gens := ModuleGenerators(M);
    gens := PreImageRepresentativeOfModuleHomomorphism(phi, gens);
    if not IsMatrix(gens) then
      return fail;
    else
      return FpGModuleGFNC(gens, ModuleGroupAndAction(SourceModule(phi)));
    fi;
  end);
#####################################################################
InstallMethod(
  PreImageRepresentativeOfModuleHomomorphismGF,
  [IsFpGModuleHomomorphismGF, IsMatrix],
  function(phi, coll)

    local coeffs, m, n;
    coeffs := HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2(
      MutableCopyMat(ModuleHomomorphismGeneratorMatrix(phi)), 
      ModuleGroupAndAction(TargetModule(phi)), 
      MutableCopyMat(coll), []);
    return HAPPRIME_ModuleElementFromGeneratorCoefficients(
      SourceModule(phi), coeffs);
  end
);
#####################################################################
InstallOtherMethod(
  PreImageRepresentativeOfModuleHomomorphismGF,
  [IsFpGModuleHomomorphismGF, IsVector],
  function(phi, elm)

    local coeffs, m, n;
    coeffs := HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2(
      MutableCopyMat(ModuleHomomorphismGeneratorMatrix(phi)), 
      ModuleGroupAndAction(TargetModule(phi)), 
      [ShallowCopy(elm)], [])[1];
    return HAPPRIME_ModuleElementFromGeneratorCoefficients(
      SourceModule(phi), coeffs);
  end
);
#####################################################################

  


#####################################################################
##  <#GAPDoc Label="KernelOfModuleHomomorphism_DTmanFpGModuleHom_Ima">
##  <ManSection>
##  <Oper Name="KernelOfModuleHomomorphism" Arg="phi"/>
##  <Oper Name="KernelOfModuleHomomorphismSplit" Arg="phi"/>
##  <Oper Name="KernelOfModuleHomomorphismIndependentSplit" Arg="phi"/>
##  <Oper Name="KernelOfModuleHomomorphismGF" Arg="phi"/>
##
##  <Returns>
##  <K>FpGModuleGF</K>
##  </Returns>
##  <Description>
##  Returns the kernel of the module homomorphism <A>phi</A>, as an 
##  <K>FpGModuleGF</K> module.
##  There are three independent algorithms for calculating the kernel, 
##  represented by different versions of this function:
##  <List>
##  <Item> 
##    The standard version calculates the kernel by the obvious vector-space
##    method. The homomorphism's generators are expanded into a full
##    vector-space basis and the kernel of that vector space homomorphism is found.
##    The generators of the returned module are in fact a vector space basis for 
##    the kernel module. 
##  </Item>
##  <Item> 
##    The <C>Split</C> version divides the homomorphism into two (using the first 
##    half and the second half of the generating vectors), and uses the 
##    preimage of the intersection of the images of the two halves to calculate 
##    the kernel (see Section <Ref Sect="FpGModuleHomGFkernel"/>).
##    If the generating vectors for <A>phi</A> are in block echelon form (see
##    Section <Ref Sect="FpGModuleGFalgo"/>),
##    then this approach provides a considerable memory saving over the standard approach.
##  </Item>
##  <Item> 
##    The <C>IndependentSplit</C> version splits the generating vectors into
##    sets that generate vector spaces which have no intersection, and calculates the
##    kernel as the sum of the kernels of those independent rows. If the 
##    generating vectors can be decomposed in this manner (i.e. the
##    the generator matrix is in a diagonal form), this will provide a very large
##    memory saving over the standard approach. 
##  </Item>
##  <Item> 
##    The <C>GF</C> version performs column reduction and partitioning of the 
##    generator matrix to enable a recursive approach to computing the kernel
##    (see Section <Ref Sect="FpGModuleHomGFkernel2"/>). The level of 
##    partitioning is governed by the option <C>MaxFGExpansionSize</C>, which 
##    defaults to <M>10^9</M>, allowing about 128Mb of memory to be used 
##    for standard linear algebra before partitioning starts.
##    See <Ref Chap="Options Stack" BookName="ref"/> for details of using
##    options in &GAP;
##  </Item>
##  </List>
##  None of these basis versions of the functions guarantee to return a minimal
##  set of generators, and one of &TheMinGenFuncs; should be used on the 
##  result if a minimal set of generators is needed. 
##  All of the functions leave the input homomorphism <A>phi</A> unchanged.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(KernelOfModuleHomomorphism, 
  "generic method",
  [IsFpGModuleHomomorphismGF],
  function(phi)

    local gens, Fbasis, NS;

    gens := ModuleHomomorphismGeneratorMatrix(phi);

    if IsEmpty(gens) then
      # With no generators, the source module must also be empty,
      # so there can be no kernel
      Error("Empty generators for homomorphism <phi>. There can be no kernel");
    fi;
    if IsZero(gens) then
      # With zero generators, the whole source module is the kernel  
      return SourceModule(phi);
    fi;

    Fbasis := HAPPRIME_ExpandGeneratingRows(
      gens, ModuleGroupAndAction(TargetModule(phi)));;
    NS := NullspaceMatDestructive(Fbasis);;
    Unbind(Fbasis);
    if IsEmpty(NS) then
      return FpGModuleGFNC(
        ModuleGroupAndAction(SourceModule(phi)), 
        ModuleAmbientDimension(SourceModule(phi)));
    else
      return FpGModuleGFNC(
        HAPPRIME_ModuleElementFromGeneratorCoefficients(SourceModule(phi), NS), 
        ModuleGroupAndAction(SourceModule(phi)) );
    fi;
end);
#####################################################################
InstallMethod(KernelOfModuleHomomorphismSplit, 
  "generic method",
  [IsFpGModuleHomomorphismGF],
  function(phi)

  local gens, field, zero, kernelgens, sourceGA,
    m, Uset, Vset, Uhom, Vhom, zeros, g, r, preim, preimV, source, form,
    SUgens, SUgenblocks, SVgens, SVgenblocks;

  # Extract the generators 
  gens := ModuleHomomorphismGeneratorMatrix(phi);
  sourceGA := ModuleGroupAndAction(SourceModule(phi));
  # And calculate some other stuff.
  field := Field(gens[1][1]);
  zero := Zero(field);

  kernelgens := [];

  if Length(gens) < 2 then
    # If there are fewer than two generators we can't split
    Info(InfoHAPprime, 2, "Finding kernel of homomorphism without splitting");
    GASMAN("collect");
    return KernelOfModuleHomomorphism(phi);
  elif Length(gens) > 1 then
    Info(InfoHAPprime, 2, "Finding kernel of homomorphism by splitting:");
    # Split the homomorphism into two halves, U and V  
    m := QuoInt(Length(gens), 2);
    Uset := [1..m];
    Vset := [m+1..Length(gens)];
    source := SourceModule(phi);
    if ModuleIsFullCanonical(source) then
      form := "echelon";
    else
      form := ModuleGeneratorsForm(source);
    fi;

    # Uhom is the top half of the homomorphism generators, and goes with
    # the top half of the source module generators (which we'll call SU)
    SUgens := ModuleGenerators(source){Uset};
    # To save memory (and time), we'll remove any zero blocks from these 
    # generators
    SUgenblocks := HAPPRIME_RemoveZeroBlocks(SUgens, sourceGA);
    Uhom := FpGModuleHomomorphismGFNC(
      FpGModuleGFNC(SUgens, sourceGA, form),
      TargetModule(phi),
      gens{Uset});
    SVgens := ModuleGenerators(source){Vset};
    SVgenblocks := HAPPRIME_RemoveZeroBlocks(SVgens, sourceGA);
    Vhom := FpGModuleHomomorphismGFNC(
      FpGModuleGFNC(SVgens, sourceGA, form),
      TargetModule(phi),
      gens{Vset});

    # First find the kernel of U
    Info(InfoHAPprime, 2, " - Finding kernel of U");
    GASMAN("collect");
    gens := ModuleGenerators(
      MinimalGeneratorsModuleGFDestructive(
        KernelOfModuleHomomorphism(Uhom)));
    # Now add the zero blocks back in
    gens := HAPPRIME_AddZeroBlocks(gens, SUgenblocks, sourceGA);
    Append(kernelgens, gens);

    # Now find the kernel of V
    Info(InfoHAPprime, 2, " - Finding kernel of V");
    GASMAN("collect");
    gens := ModuleGenerators(
      MinimalGeneratorsModuleGFDestructive(
        KernelOfModuleHomomorphism(Vhom)));
    gens := HAPPRIME_AddZeroBlocks(gens, SVgenblocks, sourceGA);
    Append(kernelgens, gens);

    # Now find the kernel of the preimage of the intersection of U and V
    Info(InfoHAPprime, 2, " - Finding intersection of U and V");
    GASMAN("collect");
    gens := ModuleGenerators(
      MinimalGeneratorsModuleGFDestructive(
        IntersectionModulesGF(
          ImageOfModuleHomomorphism(Uhom), ImageOfModuleHomomorphism(Vhom))));

    if not IsEmpty(gens) then
      # Now find the preimages
      Info(InfoHAPprime, 2, " - Finding intersection preimages");
      # In U first
      GASMAN("collect");
      preim := PreImageRepresentativeOfModuleHomomorphism(Uhom, gens);
      preim := HAPPRIME_AddZeroBlocks(preim, SUgenblocks, sourceGA);
      Unbind(Uhom);
      # Now V
      GASMAN("collect");
      preimV := PreImageRepresentativeOfModuleHomomorphism(Vhom, gens);
      preimV := HAPPRIME_AddZeroBlocks(preimV, SVgenblocks, sourceGA);
      Unbind(Vhom);
  
      # Now add the difference to the kernelgens
      Append(kernelgens, preim - preimV);
    fi;
    return FpGModuleGF(kernelgens, sourceGA);
  fi;
    
end);
#####################################################################
InstallMethod(KernelOfModuleHomomorphismIndependentSplit, 
  "generic method",
  [IsFpGModuleHomomorphismGF],
  function(phi)

    local gens, rows, source, sourceGA, form, kernelgens, r, smallphi, kgens;

    gens := ModuleHomomorphismGeneratorMatrix(phi);

    rows := HAPPRIME_IndependentGeneratingRows(
      HAPPRIME_GeneratingRowsBlockStructure(
        gens, 
        ModuleGroupAndAction(TargetModule(phi))));

    source := SourceModule(phi);
    sourceGA := ModuleGroupAndAction(source);  
    if ModuleIsFullCanonical(source) then
      form := "echelon";
    else
      form := ModuleGeneratorsForm(source);
    fi;
    kernelgens := [];  
    for r in rows do
      smallphi := FpGModuleHomomorphismGFNC(
        FpGModuleGFNC(ModuleGenerators(source){r}, sourceGA, form),
        TargetModule(phi),
        gens{r});

      kgens := ModuleGenerators(
        MinimalGeneratorsModuleGFDestructive(
          KernelOfModuleHomomorphism(smallphi)));
      Append(kernelgens, kgens);
    od;

    return FpGModuleGFNC(kernelgens, sourceGA);
end);
#####################################################################
InstallMethod(KernelOfModuleHomomorphismGF,
  [IsFpGModuleHomomorphismGF],
  function(phi)
    local gens, GA, rowlengths, i, j, row;
    
    gens := MutableCopyMat(ModuleHomomorphismGeneratorMatrix(phi));
    GA := ModuleGroupAndAction(TargetModule(phi));

    return HAPPRIME_KernelOfGeneratingRowsDestructive(gens, GA);
  end
);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_ValueOptionMaxFGExpansionSize_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_ValueOptionMaxFGExpansionSize" Arg="field, group"/>
##
##  <Returns>
##    Integer
##  </Returns>
##  <Description>
##     Returns the maximum matrix expansion size. This is read from the 
##     <C>MaxFGExpansionSize</C> option from the &GAP; options stack 
##     <Ref Chap="Options Stack" BookName="ref"/>, computed using the 
##     <C>MaxFGExpansionMemoryLimit</C> option.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallGlobalFunction(HAPPRIME_ValueOptionMaxFGExpansionSize,
  function(field, group)
    local maxsize, maxmem, parseOK, mult, gasman, totalmem, freemem, n, v, 
      vmemory;
    
    maxsize := ValueOption("MaxFGExpansionSize");
    if maxsize = fail then
      maxsize := 10^9; # The default is about 128Mb
    fi;
    maxmem := ValueOption("MaxFGExpansionMemoryLimit");
    if maxmem = fail then
      return maxsize;
    fi;
    
    # Parse maxmem if it is a string
    parseOK := true;
    if not IsInt(maxmem) then
      if IsString(maxmem) then
        maxmem := ShallowCopy(maxmem);
        if Int(maxmem) <> fail then
          maxmem := Int(maxmem);
        else
          # It presumably has a multiplier suffix
          mult := Remove(maxmem, Length(maxmem));
          if mult = 'G' or mult = 'g' then
            mult := 1024*1024*1024;
          elif mult = 'M' or mult = 'm' then
            mult := 1024*1024;
          elif mult = 'K' or mult = 'k' then
            mult := 1024;
          else
            parseOK := false;
          fi;
          maxmem := Int(maxmem);
          if maxmem = fail then
            parseOK := false;
          fi;
          maxmem := maxmem * mult;
        fi;
      else
        parseOK := false;
      fi;
    fi;
    if not parseOK then
      Info(InfoWarning, 
        "option MaxFGExpansionMemoryLimit:=", maxmem, " not recognised.");
      return maxsize;
    fi;
        
    # Find out how much memory GAP is currently using (in kb, so times by 1024)
    gasman := GasmanStatistics();
    if IsBound(gasman.partial) then
      freemem := gasman.partial.freekb * 1024;
      totalmem := gasman.partial.totalkb * 1024;
    elif IsBound(gasman.full) then
      freemem := gasman.full.freekb * 1024;
      totalmem := gasman.full.totalkb * 1024;
    else
      freemem := 0;
      totalmem := 0;
    fi;
#    Print("freemem = ", QuoInt(freemem, 1024), 
#      "kb, totalmem = ", QuoInt(totalmem, 1024), 
#      "kb, maxmem = ", QuoInt(maxmem, 1024), "kb\n");
    # So how much memory is left before we hit our own maxmem?
    if totalmem > maxmem then
      return 0;
    fi;
    freemem := maxmem - totalmem + freemem;
    
    # Find out how much memory 1000 elements of a vector of this field takes up
    n := 1000;
    v := ListWithIdenticalEntries(n, Zero(field));;
    ConvertToVectorRepNC(v, field);
    
    if not IsBound(MemoryUsage)then
      if Characteristic(field) = 2 then
        vmemory := 168;
      else
        Error("MemoryUsage() function not available. Please use GAP version >= 4.4.10");
      fi;
    else
      vmemory := MemoryUsage(v);
    fi;
    if vmemory = 0 then 
      if Characteristic(field) = 2 then
        vmemory := 168;
      else
        Error("MemoryUsage() function returned zero!");
      fi;
    fi;

    # We might need to do Radical on the expanded matrix
    # We'll allow a factor of four for matrix overheads, plus the number 
    # of minimal generators of the group (to allow us to use the Radical)
    # And then see how many elements we can get with this memory
    maxmem := 
      QuoInt(freemem*n, 2*Length(MinimalGeneratingSet(group))*vmemory);
#    Print("real freemem = ", QuoInt(freemem, 1024), 
#      "kb, GensGroup = ", Length(MinimalGeneratingSet(group)), 
#      ", vmemory = ", vmemory, " field=", field, "\n");
    if ValueOption("MaxFGExpansionSize") <> fail then
      maxmem := Maximum(maxsize, maxmem);
    fi;
      
#    Info(InfoHAPprime, 2, freemem, 
#      " bytes available. Setting MaxFGExpansionSize:=", maxmem);
    
    return maxmem;
  end
);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_KernelOfGeneratingRowsDestructive_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_KernelOfGeneratingRowsDestructive" Arg="gens, rowlengths, GA"/>
##
##  <Returns>
##    List
##  </Returns>
##  <Description>
##    Returns a list of generating vectors for the kernel of the
##    &FG;-module homomorphism defined by the generating rows <A>gens</A> using
##    the group and action <A>GA</A>.
##    <P/>
##    This function computes the kernel recursively by partitioning the
##    generating rows into
##    <Alt Only="LaTeX">
##      <Display><![CDATA[
##        \begin{pmatrix} B & 0 \\ C & D \end{pmatrix}
##      ]]></Display>
##    </Alt>
##    <Alt Not="LaTeX">
##      <Display>
##        [ B  0 ]
##        [ C  D ]
##      </Display>
##    </Alt>
##    doing column reduction if necessary to get the zero block at the top
##    right. The matrices <M>B></M> and <M>C</M> are small enough to be
##    expanded, while the kernel of <M>D</M> is calculated by recursion.
##    The argument <A>rowlengths</A> lists the number of non-zero blocks
##    in each row; the rest of each row is taken to be zero. This allows
##    the partitioning to be more efficiently performed (i.e. column
##    reduction is not always required).
##    <P/>
##    The &GAP; options stack <Ref Chap="Options Stack" BookName="ref"/>
##    variable <C>MaxFGExpansionSize</C> can be
##    used to specify the maximum allowable expanded matrix size. This
##    governs the size of the <M>B</M> and <M>C</M> matrices, and thus the
##    number of recursions before the kernel of <M>D</M> is also computed by
##    recursion. A high value for will allow larger expansions and so faster
##    computation at the cost of more memory.
##    The <C>MaxFGExpansionMemoryLimit</C> option can also be used, which
##    sets the maximum amount of memory that &GAP; is allowed to use
##    (as a string containing an integer with the suffix <C>k</C>, <C>M</C> or
##    <C>G</C> to indicate kilobyes, megabytes or gigabytes respectively).
##    In this case, the function looks at the free memory available to &GAP;
##    and computes an appropriate value for <C>MaxFGExpansionSize</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallGlobalFunction(HAPPRIME_KernelOfGeneratingRowsDestructive,
  function(gens, GA)

    local maxsize, blocksize, n, m, field, Fbasis, NS, Bn, t, firstrowmod,
      smallsetgens, smallsetgenspos, BC, BCT, i, j, row, rows, c, BCTexpanded, 
      BCTOneexpanded, diffgens, x, col, DE, Eextra, kerDE, B, C, Cexpanded, K, 
      Bexpanded, L, kerB, zeros, permutation, reversepermutation,
      rowpermutation, rowlengths,
      KernelFromWholeMatrix, ExtractBCandBCT, VectorToFGcols, FGcolsToVector,
      FindSmallGeneratingSet, ReduceGeneratorsByLeavingSomeOut;

    field := Field(gens[1][1]);
    # The option MaxFGExpansionSize tells us what the largest size of
    # a fully-expanded matrix that we will allow
    maxsize := HAPPRIME_ValueOptionMaxFGExpansionSize(field, GA.group);  

    # What's the size of the matrix?
    blocksize := GA.actionBlockSize;
    n := Length(gens[1]) / blocksize;
    m := Length(gens);

    ##############################
    # Returns the null space computed using the whole matrix
    KernelFromWholeMatrix := function(gens)
      local Fbasis, NS;
      Fbasis := HAPPRIME_ExpandGeneratingRows(gens, GA);;
      NS := NullspaceMatDestructive(Fbasis);;
      # Return the module generators for the null space, and the list of row
      # lengths assuming that they are all full-length
      return HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive(
        NS, GA);
    end;
    ##############################

    # If we can afford to, or if we only have one column, then
    # just expand the whole matrix
    if m*n*blocksize*blocksize <= maxsize or m = 1 then
      return KernelFromWholeMatrix(gens);
    fi;


    # Work out the row lengths
    rowlengths := [];
    for i in gens do
      row := Reversed(i);
      j := PositionNonZero(row);
      j := QuoInt(Length(row) - j, GA.actionBlockSize) + 1;
      Add(rowlengths, j);
    od;

    # Do a permutation of the rows to get the row lengths to be in order
    permutation := [1..Length(gens)];
    SortParallel(rowlengths, permutation);
    gens := gens{permutation};
    # and what permutation of the kernel vectors is needed?
    reversepermutation := [1..Length(gens)];
    SortParallel(permutation, reversepermutation);
    rowpermutation := List(reversepermutation, i->(i-1)*blocksize+1);
    rowpermutation := Flat(List(rowpermutation, i->[i..i+blocksize-1]));


    # So we ought to try a partition. Can we find a nice partition directly
    # from the row lengths?
    if Length(rowlengths) <> Length(gens) then
      Error("<rowlengths> must be the same length as <gens>");
    fi;

    Bn := 1;
    t := rowlengths[1];

    ##############################
    # Convert a FG row vector (a row vector of FG elements) into an
    # FG column vector (a list of FG vectors)
    VectorToFGcols := function(v)
      local b, col;
      b := 1;
      col := [];
      while b < Length(v) do
        Add(col, v{[b..(b+blocksize-1)]});
        b := b + blocksize;
      od;
      ConvertToMatrixRepNC(col, field);
      return col;
    end;
    ##############################
    ##############################
    # Convert a FG column vector (a list of FG vectors) into an
    # FG row vector (a row vector of FG elements)
    FGcolsToVector := function(M)
      local v;
      v := Flat(M);;
      ConvertToVectorRepNC(v, field);
      return v;
    end;
    ##############################
    ##############################
    # Extract BC from gens and also form BC^T
    ExtractBCandBCT := function(gens, blocks)
      local removegenspos, keepgenspos, BC, BCT, i, j, row, c;
      # convert the block numbers into column numbers
      removegenspos := List(blocks, i->(i-1)*blocksize+1);
      removegenspos := Flat(List(removegenspos, i->[i..i+blocksize-1]));
      keepgenspos := Difference([1..Length(gens[1])], removegenspos);
      # Now do the extraction
      BC := [];
      BCT := List([1..t], i->[]);
      for i in [1..Length(gens)] do
        row := gens[i]{removegenspos};
        Add(BC, row);
        gens[i] := gens[i]{keepgenspos};
        c := VectorToFGcols(row);
        for j in [1..t] do
          Append(BCT[j], c[j]);
        od;
      od;
      ConvertToMatrixRepNC(BC, field);
      ConvertToMatrixRepNC(BCT, field);
      return [BC, BCT];
    end;
    ##############################
    ##############################
    # Gradually expand the generators to find a small generating set
    # returns a list with the entries
    #  [1] the small generating set
    #  [2] the expansions of those generators
    #  [3] the Fbasis rank of the module generated by the generating set
    FindSmallGeneratingSet := function(gens)
      local len, i, Fbasis, heads, row, rowexpanded, j, rowneeded, ech, p, q,
      smallgens, smallgensexpanded;

      len := Length(gens[1]);

      # Always take the first non-zero row
      i := 1;
      while IsZero(gens[i]) and i <= Length(gens) do
        i := i + 1;
      od;
      if i > Length(gens) then
        return [gens[1], gens[1], 0];
      fi;
      
      rowexpanded := HAPPRIME_ExpandGeneratingRowOnRight(gens[i], GA);;
      smallgens := [gens[i]];
      smallgensexpanded := [MutableCopyMat(rowexpanded)];;
      ech := SemiEchelonMatDestructive(rowexpanded);;
      Fbasis := ech.vectors;;
      heads := ech.heads;

      i := i+1;
      while Length(Fbasis) < len and i <= Length(gens) do
        # Reduce the next row to see if it adds anything new
        row := ShallowCopy(gens[i]);
        if not IsZero(row) then
          for j in [1..len] do 
            p := row[j];
            if not IsZero(p) then
              q := heads[j];
              if IsZero(q) then
                # We can't reduce this, so stop trying
                break;
              else
                AddRowVector(row, Fbasis[q], p);
              fi;
            fi;
          od;
        fi;
        if not IsZero(row) then
          rowexpanded := HAPPRIME_ExpandGeneratingRowOnRight(gens[i], GA);;
          Add(smallgens, gens[i]);
          Add(smallgensexpanded, MutableCopyMat(rowexpanded));
          Append(Fbasis, rowexpanded);
          ech := SemiEchelonMatDestructive(Fbasis);;
          Fbasis := ech.vectors;;
          heads := ech.heads;
        fi;
        i := i+1;
      od;
      return [smallgens, smallgensexpanded, Length(Fbasis)];
    end;
    ##############################
    ##############################
    # Reduce the generating set by trying to leave some out.
    # Inputs: 
    #  gens - the generating set
    #  gensexpanded - the expansion of each of the generators
    #  rank - the rank of the module that gens spans
    # Returns a subset of gens that spans a module of the same rank
    ReduceGeneratorsByLeavingSomeOut := function(gens, gensexpanded, rank)
      local dim, rowsneeded, r, previousrowsneeded;

      # Start by assuming that all the rows are needed
      rowsneeded := [1..Length(gens)];
      r := 1; # The row to try leaving out
      while r <= Length(rowsneeded) and Length(rowsneeded) > 1 do
        # Remember our current list of rows
        previousrowsneeded := ShallowCopy(rowsneeded);
        # now remove one
        Remove(rowsneeded, r);
        # Take the expansions of those rows and work out their rank
        if RankMat(Concatenation(gensexpanded{rowsneeded})) = rank then
          # This row is not needed. We next try the one that is now in position r
        else
          # This row is needed. Go back to where we were and move on to the next
          rowsneeded := ShallowCopy(previousrowsneeded);
          r := r + 1;
        fi;
      od;
      return gens{rowsneeded};
    end;
    ##############################
    
    
    if t*m*blocksize*blocksize < maxsize and Bn < m then
      # The first row works fine. Can we add any further rows to B while
      # still being fine?
      while Maximum(t, rowlengths[Bn+1])*m*blocksize*blocksize < maxsize and
        Bn < m do
          Bn := Bn + 1;
          t := Maximum(t, rowlengths[Bn]);
      od;
      # Could we take even more columns while still being within maxsize? 
      # If so, do so
      t := Maximum(t, QuoInt(maxsize, blocksize*blocksize*m));
      # Now extract the first t columns as BC
      BC := ExtractBCandBCT(gens, [1..t]);
      BCT := BC[2];
      BC := BC[1];
      BCTexpanded := HAPPRIME_ExpandGeneratingRowsOnRight(BCT, GA);;
      Unbind(BCT);
    else
      # Even just taking the first row as B is not good. Do column
      # reduction to get a smaller B, and we shall take the first row only
      Bn := 1;

      # Make a module from the elements of the first row
      firstrowmod := VectorToFGcols(gens[1]);
      # And find a small set that still generates this row
      smallsetgens := FindSmallGeneratingSet(firstrowmod);;
      t := Length(smallsetgens[1]);

      # if t too large, take a minimal set instead
      if blocksize*blocksize*Bn*t > maxsize then
        smallsetgens := ReduceGeneratorsByLeavingSomeOut(
          smallsetgens[1], smallsetgens[2], smallsetgens[3]);
        t := Length(smallsetgens);
      else
        smallsetgens := smallsetgens[1];
      fi;

      # if t is the same length as n, then we can't do any column reduction,
      # so we're stuck with using the whole matrix
      if t >= n then
        return KernelFromWholeMatrix(gens{reversepermutation});
      fi;

      # Find each of mingens in firstrowmod. This tells us which columns
      # of gens we will need
      smallsetgenspos := List(smallsetgens, i->Position(firstrowmod, i));
      Sort(smallsetgenspos);

      # We have to take at least t columns to form BC, and these are mingenspos. 
      # Could we take even more while still being within maxsize? If so, do so
      t := Maximum(t, QuoInt(maxsize, blocksize*blocksize*m));
      j := Difference([1..n], smallsetgenspos);
      for i in [1..(t - Length(smallsetgens))] do
        Add(smallsetgenspos, Remove(j, 1));
      od;


      # Remove these columns from gens and form BC and BCT
      BC := ExtractBCandBCT(gens, smallsetgenspos);
      BCT := BC[2];
      BC := BC[1];
      # And leave firstrowmod with just the first row of the new gens
      firstrowmod := 
        firstrowmod{Difference([1..Length(firstrowmod)], smallsetgenspos)};
      Unbind(smallsetgens);

      BCTexpanded := HAPPRIME_ExpandGeneratingRowsOnRight(BCT, GA);;
      BCTOneexpanded := HAPPRIME_ExpandGeneratingRowsOnRight(
        List(BCT, i->i{[1..blocksize]}), GA);;
      Unbind(BCT);

      # Now we reduce the columns in gens. To do this, we solve
      # x * BCTOneexpanded = b where b is the top entry in a column,
      # and then compute x * BCTexpanded. Concatenate all of these into
      # a matrix diffgens, which we then subtract from gens at the end
      x := SolutionMatDestructive(BCTOneexpanded, firstrowmod);
      rows := x * BCTexpanded;
      Unbind(x);
      # We now want to do an FG-transpose of this
      diffgens := [];
      while Length(rows) > 0 do
        row := Remove(rows, 1);
        col := VectorToFGcols(row);
        if IsEmpty(diffgens) then
          diffgens := MutableCopyMat(col);
        else
          for j in [1..m] do
            Append(diffgens[j], col[j]);
          od;
        fi;
        if not IsGF2VectorRep(diffgens[1]) then
          Error("Not GF2VectorRep");
        fi;
      od;
      gens := gens - diffgens;
      Unbind(diffgens);
      Unbind(BCTOneexpanded);
    fi;

    Info(InfoHAPprime, 1, "Finding kernel by splitting into B (", Bn, "x", t, 
      "), C (", m - Bn, "x", t, ") and D (", m - Bn, "x", n - t, ")");
    
    # We have now removed BC from gens, so what will be left in gens is
    # Bn rows of zero, and then the rest which we shall call D.
    # Remove the top t rows, and check that they are zero
    for i in [1..Bn] do
      row := Remove(gens, 1);
      if not IsZero(row) then
        Error("Column reduction failed - don't have the expected zero rows");
      fi;
    od;
    # What is left we shall call D (soon to be augmented with Eextra)
    DE := gens;

    # Find an echelon basis for BCTexpanded
    Fbasis := SemiEchelonMatDestructive(BCTexpanded).vectors;
    Unbind(BCTexpanded);
    # We want to keep the rows that are zero in the first Bn blocks since those
    # will get appended to D
    for i in [Length(Fbasis), Length(Fbasis)-1 .. 1] do
      if IsZero(Fbasis[i]{[1..Bn*blocksize]}) then
        Fbasis[i] := Fbasis[i]{[Bn*blocksize+1..Length(Fbasis[i])]};
      else
        Remove(Fbasis, i);
      fi;
    od;
    # And find a minimal set of module generators
    if not IsEmpty(Fbasis) then
      Eextra := ModuleGenerators(
        HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsOnRightDestructive(
          Fbasis, GA));
    else
      Eextra := [];
    fi;
    Unbind(Fbasis);

    # Add the rows of Eextra as extra columns of DE 
    for i in Eextra do
      c := VectorToFGcols(i);
      for j in [1..Length(DE)] do
        DE[j] := Concatenation(DE[j], c[j]);
      od;
    od;
    ConvertToMatrixRepNC(DE, field);
    Unbind(Eextra);

    # And find the kernel of DE
    kerDE := ModuleGenerators(
      HAPPRIME_KernelOfGeneratingRowsDestructive(DE, GA));
    Unbind(DE);
    rowlengths := [];

    # Now split BC into B (the first Bn rows) and C (the rest)
    B := [];
    C := [];
    for i in [1..Bn] do
      Add(B, Remove(BC, 1));
    od;
    C := BC;
    Unbind(BC);

    # And solve to find the extra bits we need for the kernel
    Cexpanded := HAPPRIME_ExpandGeneratingRows(C, GA);
    Unbind(C);
    K := kerDE * Cexpanded;
    Unbind(Cexpanded);

    Bexpanded := HAPPRIME_ExpandGeneratingRows(B, GA);
    L := SolutionMat(Bexpanded, K);
    Unbind(K);

    # Find the kernel for B
    Unbind(B);
    NS := NullspaceMatDestructive(Bexpanded);;
    Unbind(Bexpanded);
    kerB := ModuleGenerators(
      HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive(NS, GA));
    Unbind(NS);

    # And now we can finally construct the solution
    NS := [];
    zeros := ListWithIdenticalEntries((m - Bn)*blocksize, Zero(field));
    ConvertToVectorRepNC(zeros, field);
    for row in kerB do
      Add(NS, Concatenation(row, zeros){rowpermutation});
    od;
    for i in [1..Length(L)] do
      Add(NS, Concatenation(L[i], kerDE[i]){rowpermutation});
    od;

    return FpGModuleGFNC(NS, GA);
  end
);
#####################################################################

