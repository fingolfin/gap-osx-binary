#############################################################################
##
#W  testauto.g           GAP 4 package CTblLib                  Thomas Breuer
##
#Y  Copyright (C)  2012,   Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  Running these tests requires only a few minutes of CPU time,
##  contrary to `tst/testall.g'.
##  Therefore, this testfile is listed in `PackageInfo.g',
##  and `tst/testall.g' is not.
##

dirs:= DirectoriesPackageLibrary( "ctbllib", "tst" );

Test( Filename( dirs, "docxpl.tst" ) );   # manual examples


#############################################################################
##
#E

