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
##  $Id: fpgmodulehomG.gd 345 2008-11-21 12:56:17Z pas $
##
#############################################################################


#####################################################################
##  <#GAPDoc Label="IsFpGModuleHomomorphismGF_DTmanFpGModuleHomNODOC">
##  <ManSection>
##  <Filt Name="IsFpGModuleHomomorphismGF" Arg="O" Type="Category"/>
##  <Description>
##  Returns <K>true</K> if <A>O</A> is an <K>FpGModuleHomomorphismGF</K>, or 
##  <K>false</K> otherwise
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
DeclareCategory("IsFpGModuleHomomorphismGF", IsObject);
# Note this also defines the function IsFpGModuleHomomorphismGF
#####################################################################

#####################################################################
##  <#GAPDoc Label="FpGModuleHomomorphismGFAttr_DTmanFpGModuleHomNODOC">
##  <ManSection>
##  <Fam Name="FpGModuleHomomorphismGFFamily"/>
##  <Description>
##  The family to which <K>FpGModuleHomomorphismGF</K> objects belong.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
DeclareAttribute("FpGModuleHomomorphismGFFamily", IsFamily);
# Note this also defines the function FpGModuleHomomorphismGFFamily
#####################################################################


#######################################################################
#
# Declarations for Operations in fpgmodulehomG.gi
#

DeclareOperation("FpGModuleHomomorphismGF", 
  [IsFpGModuleGF, IsFpGModuleGF, IsMatrix]);
DeclareOperation("FpGModuleHomomorphismGFNC", 
  [IsFpGModuleGF, IsFpGModuleGF, IsMatrix]);

DeclareOperation("SourceModule", [IsFpGModuleHomomorphismGF]);
DeclareOperation("TargetModule", [IsFpGModuleHomomorphismGF]);
DeclareOperation("TargetModuleMinGenerators", 
  [IsFpGModuleHomomorphismGF]);
DeclareOperation("ModuleHomomorphismGeneratorMatrix", 
  [IsFpGModuleHomomorphismGF]);

  
DeclareOperation("DisplayBlocks", 
  [IsFpGModuleHomomorphismGF]);
DeclareOperation("DisplayModuleHomomorphismGeneratorMatrix", 
  [IsFpGModuleHomomorphismGF]);
DeclareOperation("DisplayModuleHomomorphismGeneratorMatrixBlocks", 
  [IsFpGModuleHomomorphismGF]);
  
DeclareOperation("ImageOfModuleHomomorphism", 
  [IsFpGModuleHomomorphismGF]);
DeclareOperation("ImageOfModuleHomomorphismDestructive",
  [IsFpGModuleHomomorphismGF, IsVector and IsMutable]);
DeclareOperation("ImageOfModuleHomomorphism",
  [IsFpGModuleHomomorphismGF, IsVector]);
DeclareOperation("ImageOfModuleHomomorphismDestructive",
  [IsFpGModuleHomomorphismGF, IsFpGModuleGF]);
DeclareOperation("ImageOfModuleHomomorphism",
  [IsFpGModuleHomomorphismGF, IsFpGModuleGF]);
  
DeclareOperation("PreImageRepresentativeOfModuleHomomorphism", 
  [IsFpGModuleHomomorphismGF, IsMatrix]);
DeclareOperation("PreImageRepresentativeOfModuleHomomorphism", 
  [IsFpGModuleHomomorphismGF, IsFpGModuleGF]);
DeclareOperation("PreImageRepresentativeOfModuleHomomorphismGF", 
  [IsFpGModuleHomomorphismGF, IsMatrix]);

  
DeclareOperation("KernelOfModuleHomomorphism", 
  [IsFpGModuleHomomorphismGF]);
DeclareOperation("KernelOfModuleHomomorphismSplit", 
  [IsFpGModuleHomomorphismGF]);
DeclareOperation("KernelOfModuleHomomorphismIndependentSplit", 
  [IsFpGModuleHomomorphismGF]);
DeclareOperation("KernelOfModuleHomomorphismGF",
  [IsFpGModuleHomomorphismGF]);

DeclareOperation("GeneratorsNullspaceTriangulizedModule", 
  [IsMatrix, IsGroup, IsList, IsList]);
DeclareGlobalFunction("GensNullspaceGModuleNew");

DeclareOperation("SolutionTriangulizedModuleMat",
  [IsMatrix and IsMutable, IsGroup, IsVector]);

DeclareGlobalFunction("HAPPRIME_ValueOptionMaxFGExpansionSize");
DeclareGlobalFunction("HAPPRIME_KernelOfGeneratingRowsDestructive");

