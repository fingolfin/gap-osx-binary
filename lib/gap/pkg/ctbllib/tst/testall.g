#############################################################################
##
#W  testall.g            GAP 4 package CTblLib                  Thomas Breuer
##
#Y  Copyright (C)  2002,   Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  Running these tests requires several days of CPU time (at least on my
##  notebook).
##  Therefore, this testfile is not listed in `PackageInfo.g'.
##

dirs:= DirectoriesPackageLibrary( "ctbllib", "tst" );

Test( Filename( dirs, "docxpl.tst" ) );   # manual examples
Test( Filename( dirs, "ctbllib.tst" ) );  # run over all tables
ReadTest( Filename( dirs, "ambigfus.tst" ) );
ReadTest( Filename( dirs, "ctblcons.tst" ) );
ReadTest( Filename( dirs, "ctbldeco.tst" ) );
ReadTest( Filename( dirs, "ctblj4.tst" ) );
ReadTest( Filename( dirs, "ctblpope.tst" ) );
ReadTest( Filename( dirs, "multfree.tst" ) );
ReadTest( Filename( dirs, "multfre2.tst" ) );
ReadTest( Filename( dirs, "ctocenex.tst" ) );
ReadTest( Filename( dirs, "o8p2s3_o8p5s3.tst" ) );
ReadTest( Filename( dirs, "hamilcyc.tst" ) );
ReadTest( Filename( dirs, "dntgap.tst" ) );
ReadTest( Filename( dirs, "probgen.tst" ) );


#############################################################################
##
#E

