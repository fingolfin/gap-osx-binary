#############################################################################
##
#W  read.g               GAP 4 package CTblLib                  Thomas Breuer
##
#Y  Copyright (C)  2001,   Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##

# Notify functions concerning Deligne-Lusztig names.
DeclareAutoreadableVariables( "ctbllib", "dlnames/dllib.g",
    [ "DeltigLibUnipotentCharacters", "DeltigLibGetRecord" ] );

# Read the implementation part.
ReadPackage( "ctbllib", "gap4/ctadmin.tbi" );
ReadPackage( "ctbllib", "gap4/construc.gi" );
ReadPackage( "ctbllib", "gap4/ctblothe.gi" );
ReadPackage( "ctbllib", "gap4/test.g" );

# Read functions concerning Deligne-Lusztig names.
ReadPackage( "ctbllib", "dlnames/dlnames.gi" );
if IsPackageMarkedForLoading( "chevie", ">= 1.0" ) then
  DeclareAutoreadableVariables( "ctbllib", "dlnames/dlconstr.g",
      [ "DeltigConstructionFcts" ] );
  DeclareAutoreadableVariables( "ctbllib", "dlnames/dltest.g",
      [ "DeltigTestFcts", "DeltigTestFunction" ] );
fi;

# Notify database attributes
# and Browse overviews of tables, irrationalities, and differences of data.
ReadPackage( "ctbllib", "gap4/ctbltoct.g" );
if IsPackageMarkedForLoading( "Browse", "" ) then
  ReadPackage( "ctbllib", "gap4/ctdbattr.g" );
  DeclareAutoreadableVariables( "ctbllib", "gap4/ctbltocb.g",
      [ "BrowseCTblLibInfo" ] );
  DeclareAutoreadableVariables( "ctbllib", "gap4/brctdiff.g",
      [ "BrowseCTblLibDifferences" ] );
  ReadPackage( "ctbllib", "gap4/brirrat.g" );
else
  CTblLib.Data.IdEnumerator:= rec( attributes:= rec() );
  CTblLib.Data.attributesRelevantForGroupInfoForCharacterTable:= [];
fi;


#############################################################################
##
#E

