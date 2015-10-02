#############################################################################
##
##  HAPPRIME - fpgmoduleG.gd
##  Functions, Operations and Methods to implement FG modules
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
##  $Id: fpgmoduleG.gd 345 2008-11-21 12:56:17Z pas $
##
#############################################################################




#####################################################################
##  <#GAPDoc Label="FpGModuleGFFilter_DTmanFpGModuleNODOC">
##  <ManSection>
##  <Filt Name="IsFpGModuleGF" Arg="O" Type="Category"/>
##  <Returns>
##  <K>true</K> if the object is an <K>FpGModuleGF</K>, or 
##  <K>false</K> otherwise
##  </Returns>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
DeclareCategory("IsFpGModuleGF", IsObject);
# Note this also defines the function IsFpGModuleGF
#####################################################################

#####################################################################
##  <#GAPDoc Label="FpGModuleGFAttr_DTmanFpGModuleNODOC">
##  <ManSection>
##  <Fam Name="FpGModuleGFFamily"/>
##  <Description>
##  The family to which <K>FpGModuleGF</K> objects belong.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
DeclareAttribute("FpGModuleGFFamily", IsFamily);
# Note this also defines the function FpGModuleGFFamily
#####################################################################


#######################################################################
#
# Declarations for Attributes in fpgmoduleG.gi
#

DeclareAttribute("CanonicalAction", IsGroup);
DeclareAttribute("CanonicalActionOnRight", IsGroup);
DeclareAttribute("CanonicalGroupAndAction", IsGroup);

#######################################################################
#
# Declarations for Operations in fpgmoduleG.gi
#

DeclareOperation("FpGModuleGF", [IsMatrix, IsGroup]);
DeclareOperation("FpGModuleGF", [IsMatrix, IsGroup, IsFunction, IsPosInt]);
DeclareOperation("FpGModuleGF", [IsMatrix, IsRecord]);
DeclareOperation("FpGModuleGF", [IsPosInt, IsGroup]);
DeclareOperation("FpGModuleGF", [IsPosInt, IsGroup, IsFunction, IsPosInt]);
DeclareOperation("FpGModuleGF", [IsPosInt, IsRecord]);
DeclareOperation("FpGModuleGF", [IsGroup, IsPosInt]);
DeclareOperation("FpGModuleGF", [IsRecord, IsPosInt]);
DeclareOperation("FpGModuleGF", [IsHapFPGModule]);
DeclareOperation("FpGModuleGFNC", 
  [IsMatrix, IsGroup, IsString, IsFunction, IsPosInt]);
DeclareOperation("FpGModuleGFNC", 
  [IsPosInt, IsGroup, IsFunction, IsPosInt]);
DeclareOperation("FpGModuleGFNC", [IsMatrix, IsRecord]);
DeclareOperation("FpGModuleGFNC", [IsMatrix, IsRecord, IsString]);

DeclareOperation("FpGModuleFromFpGModuleGF", 
  [IsFpGModuleGF]);

DeclareOperation("ModuleGroup", [IsFpGModuleGF]);
DeclareOperation("ModuleGroupOrder", [IsFpGModuleGF]);
DeclareOperation("ModuleAction", [IsFpGModuleGF]);
DeclareOperation("ModuleActionBlockSize", [IsFpGModuleGF]);
DeclareOperation("ModuleGroupAndAction", [IsFpGModuleGF]);
DeclareOperation("ModuleCharacteristic", [IsFpGModuleGF]);
DeclareOperation("ModuleField", [IsFpGModuleGF]);
DeclareOperation("ModuleAmbientDimension", [IsFpGModuleGF]);
DeclareOperation("ModuleGenerators", [IsFpGModuleGF]);
DeclareOperation("ModuleGeneratorsAreMinimal", [IsFpGModuleGF]);
DeclareOperation("ModuleGeneratorsAreEchelonForm", [IsFpGModuleGF]);
DeclareOperation("ModuleRank", [IsFpGModuleGF]);
DeclareOperation("ModuleRankDestructive", [IsFpGModuleGF]);
DeclareOperation("ModuleIsFullCanonical", [IsFpGModuleGF]);
DeclareOperation("ModuleGeneratorsForm", [IsFpGModuleGF]);
DeclareOperation("AmbientModuleDimension", [IsFpGModuleGF]);
DeclareOperation("ModuleVectorSpaceBasis", [IsFpGModuleGF]);
DeclareOperation("ModuleVectorSpaceDimension", [IsFpGModuleGF]);

DeclareOperation("MutableCopyModule", [IsFpGModuleGF]);

DeclareOperation("DisplayBlocks", [IsFpGModuleGF]);

DeclareOperation("IsModuleElement", [IsFpGModuleGF, IsVector]);
#DeclareOperation("IsModuleElement", [IsFpGModuleGF, IsMatrix]);
DeclareOperation("IsSubModule", 
  [IsFpGModuleGF, IsFpGModuleGF]);

DeclareOperation("RandomElement", 
  [IsFpGModuleGF]);
DeclareOperation("RandomElement", 
  [IsFpGModuleGF, IsPosInt]);
DeclareOperation("RandomSubmodule", 
  [IsFpGModuleGF, IsPosInt]);

DeclareOperation("MinimalGeneratorsModuleGFDestructive",
  [IsFpGModuleGF]);
DeclareOperation("MinimalGeneratorsModuleGF",
  [IsFpGModuleGF]);
DeclareOperation("MinimalGeneratorsModuleRadical",
  [IsFpGModuleGF]);

DeclareOperation("RadicalOfModule",
  [IsFpGModuleGF]);
  
DeclareOperation("SemiEchelonModuleGeneratorsDestructive", 
  [IsFpGModuleGF]);
DeclareOperation("SemiEchelonModuleGenerators", [IsFpGModuleGF]);
DeclareOperation("EchelonModuleGeneratorsDestructive", 
  [IsFpGModuleGF]);
DeclareOperation("EchelonModuleGenerators", [IsFpGModuleGF]);

DeclareOperation("SemiEchelonModuleGeneratorsMinMem", 
  [IsFpGModuleGF]);
DeclareOperation("SemiEchelonModuleGeneratorsMinMemDestructive", 
  [IsFpGModuleGF]);
DeclareOperation("EchelonModuleGeneratorsMinMem", [IsFpGModuleGF]);
DeclareOperation("EchelonModuleGeneratorsMinMemDestructive", 
  [IsFpGModuleGF]);
  
DeclareOperation("ReverseEchelonModuleGeneratorsDestructive", 
  [IsFpGModuleGF]);
DeclareOperation("ReverseEchelonModuleGenerators", [IsFpGModuleGF]);

DeclareOperation("IntersectionModulesGFDestructive", 
  [IsFpGModuleGF, IsFpGModuleGF]);
DeclareOperation("IntersectionModulesGF", [IsFpGModuleGF, IsFpGModuleGF]);
DeclareOperation("IntersectionModules", [IsFpGModuleGF, IsFpGModuleGF]);
DeclareOperation("IntersectionModulesGF2", [IsFpGModuleGF, IsFpGModuleGF]);

DeclareOperation("SumModules", 
  [IsFpGModuleGF, IsFpGModuleGF]);

DeclareOperation("DirectSumOfModules",
  [IsFpGModuleGF, IsFpGModuleGF]);
DeclareOperation("DirectSumOfModules",
  [IsList]);
DeclareOperation("DirectSumOfModules",
  [IsFpGModuleGF, IsPosInt]);

DeclareOperation("DirectDecompositionOfModule",
  [IsFpGModuleGF]);
DeclareOperation("DirectDecompositionOfModuleDestructive",
  [IsFpGModuleGF]);
  
DeclareOperation("HAPPRIME_IsGroupAndAction", [IsRecord]);

DeclareOperation("HAPPRIME_DirectSumForm", [IsString, IsString]);
DeclareOperation("HAPPRIME_PrintModuleDescription",
  [IsFpGModuleGF, IsString]);
DeclareOperation("HAPPRIME_ModuleGeneratorCoefficientsDestructive",
  [IsFpGModuleGF, IsVector]);
DeclareOperation("HAPPRIME_ModuleGeneratorCoefficients",
  [IsFpGModuleGF, IsVector]);
#DeclareOperation("HAPPRIME_ModuleGeneratorCoefficientsDestructive",
#  [IsFpGModuleGF, IsMatrix]);
#DeclareOperation("HAPPRIME_ModuleGeneratorCoefficients",
#  [IsFpGModuleGF, IsMatrix]);

DeclareOperation("HAPPRIME_ModuleElementFromGeneratorCoefficients",
  [IsFpGModuleGF, IsVector]);
#DeclareOperation("HAPPRIME_ModuleElementFromGeneratorCoefficients",
#  [IsFpGModuleGF, IsMatrix]);

DeclareOperation("HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive",
  [IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsOnRightDestructive",
  [IsMatrix, IsRecord]);
  