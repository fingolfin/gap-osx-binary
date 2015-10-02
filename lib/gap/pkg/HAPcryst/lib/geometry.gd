#############################################################################
##
#W geometry.gd 			 HAPcryst package		 Marc Roeder
##
##  

##
#H @(#)$Id: geometry.gd, v 0.1.11 2013/10/27 18:31:09 gap Exp $
##
#Y	 Copyright (C) 2006 Marc Roeder 
#Y 
#Y This program is free software; you can redistribute it and/or 
#Y modify it under the terms of the GNU General Public License 
#Y as published by the Free Software Foundation; either version 2 
#Y of the License, or (at your option) any later version. 
#Y 
#Y This program is distributed in the hope that it will be useful, 
#Y but WITHOUT ANY WARRANTY; without even the implied warranty of 
#Y MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
#Y GNU General Public License for more details. 
#Y 
#Y You should have received a copy of the GNU General Public License 
#Y along with this program; if not, write to the Free Software 
#Y Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
##
Revision.("geometry_gd"):=
	"@(#)$Id: geometry.gd, v 0.1.11 2013/10/27   18:31:09  gap Exp $";
DeclareOperation("BisectorInequalityFromPointPair",
        [IsVector,IsVector,IsMatrix]);
DeclareOperation("BisectorInequalityFromPointPair",
        [IsVector,IsVector]);
DeclareOperation("WhichSideOfHyperplane",
        [IsVector,IsVector]);
DeclareOperation("WhichSideOfHyperplaneNC",
        [IsVector,IsVector]);
DeclareOperation("RelativePositionPointAndPolygon",
        [IsVector,IsPolymakeObject]);


