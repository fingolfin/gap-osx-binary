#############################################################################
##
##  HAPPRIME - basemat.gd
##  Functions, Operations and Methods for matrices representing vector spaces
##  Paul Smith
##
##  Copyright (C)  2007
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
##  $Id: basemat.gd 170 2007-09-24 16:47:42Z pas $
##
#############################################################################

DeclareOperation("SumIntersectionMatDestructive", 
  [IsMatrix and IsMutable, IsMatrix and IsMutable]);
DeclareOperation("SumIntersectionMatDestructiveSE", 
  [IsMatrix and IsMutable, IsVector, IsMatrix and IsMutable, IsVector]);
DeclareOperation("IsSameSubspace", [IsMatrix, IsMatrix]);
DeclareOperation("SolutionMatDestructive",
  [IsOrdinaryMatrix and IsMutable, IsMatrix and IsMutable]);
DeclareOperation("SolutionMat",
  [IsOrdinaryMatrix, IsMatrix]);
DeclareOperation("PrintDimensionsMat", [IsMatrix]);
