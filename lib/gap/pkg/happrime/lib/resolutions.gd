#############################################################################
##
##  HAPPRIME - resolutions.gd
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
##  $Id: resolutions.gd 351 2008-11-27 13:10:26Z pas $
##
#############################################################################






# In resolutions.gi
DeclareOperation("LengthOneResolutionPrimePowerGroup",[IsGroup]);
DeclareOperation("LengthZeroResolutionPrimePowerGroup",[IsFpGModuleGF]);

DeclareOperation("ExtendResolutionPrimePowerGroupRadical", [IsHapResolution]);
DeclareOperation("ExtendResolutionPrimePowerGroupGF", [IsHapResolution]);
DeclareOperation("ExtendResolutionPrimePowerGroupGF2", [IsHapResolution]);
DeclareOperation("ExtendResolutionPrimePowerGroupAutoMem", [IsHapResolution]);

DeclareOperation("ResolutionPrimePowerGroupRadical", [IsGroup, IsPosInt]);
DeclareOperation("ResolutionPrimePowerGroupGF", [IsGroup, IsPosInt]);
DeclareOperation("ResolutionPrimePowerGroupAutoMem", [IsGroup, IsPosInt]);
DeclareOperation("ResolutionPrimePowerGroupGF2", [IsGroup, IsPosInt]);
DeclareOperation("ResolutionPrimePowerGroupRadical", [IsFpGModuleGF, IsPosInt]);
DeclareOperation("ResolutionPrimePowerGroupGF", [IsFpGModuleGF, IsPosInt]);
DeclareOperation("ResolutionPrimePowerGroupAutoMem", [IsFpGModuleGF, IsPosInt]);
DeclareOperation("ResolutionPrimePowerGroupGF2", [IsFpGModuleGF, IsPosInt]);

DeclareOperation("ResolutionLength",
  [IsHapResolution]);
DeclareOperation("ResolutionGroup",
  [IsHapResolution]);
DeclareOperation("ResolutionFpGModuleGF",
  [IsHapResolution, IsInt]);
DeclareOperation("ResolutionModuleRank",
  [IsHapResolution, IsInt]);
DeclareOperation("ResolutionModuleRanks",
  [IsHapResolution]);
DeclareOperation("BoundaryFpGModuleHomomorphismGF",
  [IsHapResolution, IsInt]);

DeclareOperation("ResolutionsAreEqual", [IsHapResolution, IsHapResolution]);
  
DeclareOperation("BestCentralSubgroupForResolutionFiniteExtension", [IsGroup, IsPosInt]);

DeclareOperation("HAPPRIME_WordToVector",
  [IsVector, IsPosInt, IsPosInt]);
DeclareOperation("HAPPRIME_VectorToWord",
  [IsVector, IsPosInt]);
DeclareAttribute("HAPPRIME_BoundaryMatrices",
  IsHapResolution);  
DeclareOperation("HAPPRIME_BoundaryMapMatrix",
  [IsHapResolution, IsInt]);
DeclareOperation("HAPPRIME_AddNextResolutionBoundaryMapNC",
  [IsHapResolution, IsMatrix]);
DeclareOperation("HAPPRIME_CreateResolutionWithBoundaryMapMatsNC",
  [IsGroup, IsList]);

  