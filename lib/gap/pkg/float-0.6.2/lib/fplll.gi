#############################################################################
##
#W  fplll.gi                      GAP library               Laurent Bartholdi
##
#Y  Copyright (C) 2012 Laurent Bartholdi
##
##  This file deals with fplll's implementation of LLL lattice reduction
##

#!!! implement all options, arguments etc. to control quality of reduction
InstallMethod(FPLLLReducedBasis, [IsMatrix], function(m)
    while not ForAll(m,r->IsSubset(Integers,r)) do
        Error(m," must be an integer matrix");
    od;
    return @FPLLL(m,0,true,fail);
end);

InstallMethod(FPLLLShortestVector, [IsMatrix], function(m)
    while not ForAll(m,r->IsSubset(Integers,r)) do
        Error(m," must be an integer matrix");
    od;
    return @FPLLL(m,0,true,true);
end);

#############################################################################
##
#E
