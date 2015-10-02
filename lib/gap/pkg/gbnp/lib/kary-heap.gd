######################### BEGIN COPYRIGHT MESSAGE #########################
# GBNP - computing Gröbner bases of noncommutative polynomials
# Copyright 2001-2010 by Arjeh M. Cohen, Dié A.H. Gijsbers, Jan Willem
# Knopper, Chris Krook. Address: Discrete Algebra and Geometry (DAM) group
# at the Department of Mathematics and Computer Science of Eindhoven
# University of Technology.
# 
# For acknowledgements see the manual. The manual can be found in several
# formats in the doc subdirectory of the GBNP distribution. The
# acknowledgements formatted as text can be found in the file chap0.txt.
# 
# GBNP is free software; you can redistribute it and/or modify it under
# the terms of the Lesser GNU General Public License as published by the
# Free Software Foundation (FSF); either version 2.1 of the License, or
# (at your option) any later version. For details, see the file 'LGPL' in
# the doc subdirectory of the GBNP distribution or see the FSF's own site:
# http://www.gnu.org/licenses/lgpl.html
########################## END COPYRIGHT MESSAGE ##########################

# file that defines a kary-heap object KaryHeap
# supported operations: 
# Add, Remove, List, Set, ELM_LIST, 
# treerenum/treeswap needed aswell (OT.arr2tree/OT.tree2arr)

DeclareCategory("IsTHeapOT", IsObject);
THeapOTFam:=NewFamily("THeapOT");
IsTHeapOTRep:=NewRepresentation("IsTHeapOT", IsDataObjectRep, [ "list", 
"OT" ]); # add lterms ??, not storing ?
THeapOTType:=NewType(THeapOTFam, IsTHeapOT and IsTHeapOTRep);

DeclareOperation("Add", 		[IsTHeapOT, IsObject]);
DeclareOperation("ELM_LIST", 		[IsTHeapOT, IsInt]);
DeclareAttribute("Length", 		IsTHeapOT);
DeclareOperation("Remove", 		[IsTHeapOT, IsInt]);
DeclareOperation("Replace", 		[IsTHeapOT, IsInt, IsObject]);
DeclareOperation("HeapMin", 		[IsTHeapOT]);
DeclareOperation("IsTHeapOTEmpty", 	[IsTHeapOT]);
DeclareGlobalFunction("THeapOT");
