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

LoadPackage("gbnp");

# GP2NP

A1:=FreeAssociativeAlgebraWithOne(Rationals,"a","b");;
GP2NP(One(A1)) = [[[]],[1]];
GP2NP(Zero(A1)) = [[],[]];

A2:=FreeAssociativeAlgebraWithOne(GF(2),"a");;
GP2NP(One(A2)) = [[[]],[Z(2)^0]];

GP2NPList([])=[];

# NP2GP
NP2GP([[[]],[Z(2)^0]],A2)=One(A2);
NP2GP([[],[]],A2)=Zero(A2);
NP2GP([[],[]],A1)=Zero(A1);

NP2GPList([],A1)=[];
