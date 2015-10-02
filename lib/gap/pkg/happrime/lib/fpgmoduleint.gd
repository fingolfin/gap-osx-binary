#############################################################################
##
##  HAPPRIME - fpgmoduleint.gd
##  Various internal Functions, Operations and Methods
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
##  $Id: fpgmoduleint.gd 345 2008-11-21 12:56:17Z pas $
##
#############################################################################



## Internal functions
DeclareOperation("HAPPRIME_GActMatrixColumns",
  [IsObject, IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_GActMatrixColumnsOnRight",
  [IsObject, IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_GactFGvector", [IsPosInt, IsVector, IsMatrix]);

DeclareOperation("HAPPRIME_ExpandGeneratingRow", [IsVector, IsRecord]);
DeclareOperation("HAPPRIME_ExpandGeneratingRows", [IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_ExpandGeneratingRowOnRight", [IsVector, IsRecord]);
DeclareOperation("HAPPRIME_ExpandGeneratingRowsOnRight", [IsMatrix, IsRecord]);

DeclareOperation("HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive",
  [IsMatrix, IsVector, IsRecord]);
DeclareOperation("HAPPRIME_ReduceVectorDestructive",
  [IsVector and IsMutable, IsMatrix, IsVector]);

DeclareOperation("HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelonDestructive",
  [IsMatrix and IsMutable, IsRecord]);
DeclareOperation("HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelon",
  [IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_ReduceGeneratorsOfModuleByLeavingOneOut", 
  [IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_ReduceGeneratorsOnRightByLeavingOneOut", 
  [IsMatrix, IsRecord]);
  
DeclareOperation("HAPPRIME_DisplayGeneratingRows", [IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_GeneratingRowsBlockStructure", [IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_DisplayGeneratingRowsBlocks",  [IsMatrix, IsRecord]);

DeclareOperation("HAPPRIME_CoefficientsOfGeneratingRows", 
  [IsMatrix, IsRecord, IsVector]);
DeclareOperation("HAPPRIME_CoefficientsOfGeneratingRowsDestructive", 
  [IsMatrix and IsMutable, IsRecord, IsVector and IsMutable]);
DeclareOperation("HAPPRIME_CoefficientsOfGeneratingRowsGF", 
  [IsMatrix, IsRecord, IsVector]);
DeclareOperation("HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive", 
  [IsMatrix and IsMutable, IsRecord, IsVector and IsMutable]);

DeclareOperation("HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2", 
  [IsMatrix and IsMutable, IsRecord, IsMatrix and IsMutable, IsList and IsMutable]);

DeclareOperation("HAPPRIME_GenerateFromGeneratingRowsCoefficients", 
  [IsMatrix, IsRecord, IsVector]);
DeclareOperation("HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF", 
  [IsMatrix, IsRecord, IsVector]);

DeclareOperation("HAPPRIME_IndependentGeneratingRows",
  [IsMatrix]);
DeclareOperation("HAPPRIME_IndependentGeneratingRows",
  [IsMatrix, IsMatrix]);

DeclareOperation("HAPPRIME_RemoveZeroBlocks", [IsMatrix, IsRecord]);
DeclareOperation("HAPPRIME_AddZeroBlocks", [IsMatrix, IsVector, IsRecord]);


