#############################################################################
##
#A  edim.gd              EDIM-mini-package                     Frank Lübeck
##
##  
#Y  Copyright (C) 1999  Lehrstuhl D f\"ur Mathematik, RWTH Aachen
##  
##  In this file   we declare names for  the  main functions  of  the EDIM
##  package, as well as an Info class.
##  

DeclareInfoClass("InfoEDIM");
##  Since 'Info' does unwanted formatting, we will use:
DeclareGlobalFunction("InfoInfoEDIM");
InstallGlobalFunction(InfoInfoEDIM, function(arg)
  if InfoLevel(InfoEDIM)>0 then
    CallFuncList(Print, arg);
  fi;
end);

DeclareGlobalFunction("PAdicLinComb");
DeclareGlobalFunction("InverseRatMat");
DeclareGlobalFunction("RationalSolutionIntMat");
DeclareGlobalFunction("ExponentSquareIntMatFullRank");
DeclareGlobalFunction("ElementaryDivisorsPPartRk");
DeclareGlobalFunction("ElementaryDivisorsPPartRkI");
DeclareGlobalFunction("ElementaryDivisorsPPartRkII");
DeclareGlobalFunction("ElementaryDivisorsPPartRkExp");
DeclareGlobalFunction("ElementaryDivisorsSquareIntMatFullRank");
DeclareGlobalFunction("ElementaryDivisorsIntMatDeterminant");
DeclareGlobalFunction("ElementaryDivisorsPPartHavasSterling");

# load kernel function if it is installed 
if (not IsBound(ElementaryDivisorsPPartRkExpSmall)) and 
   ("ediv" in SHOW_STAT()) then
  # try static module
  LoadStaticModule("ediv");
fi;
if (not IsBound(ElementaryDivisorsPPartRkExpSmall)) and 
   (Filename(DirectoriesPackagePrograms("edim"), "ediv.so") <> fail) then
  LoadDynamicModule(Filename(DirectoriesPackagePrograms("edim"), "ediv.so"));
fi;

