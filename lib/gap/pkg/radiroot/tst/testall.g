LoadPackage( "radiroot" );
dirs := DirectoriesPackageLibrary( "radiroot", "tst" );
ReadTest( Filename( dirs, "docexmpl.tst" ) );
ReadTest( Filename( dirs, "trivial.tst" ) );
