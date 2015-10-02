#############################################################################
##
#W  read.g          GAP 4 package `Browse'        Thomas Breuer, Frank Lübeck
##
#Y  Copyright (C) 2006-2007, Lehrstuhl D für Mathematik, RWTH Aachen, Germany
##

ReadPackage("browse", "lib/ncurses.gi");
ReadPackage("browse", "lib/helpoverwrite.g");
ReadPackage( "browse", "lib/getpackagename.g" );
ReadPackage("browse", "lib/browse.gi");
ReadPackage( "browse", "lib/brgrids.g" );

# example applications
if IsPackageMarkedForLoading( "atlasrep", "1.5.0" ) then
  ReadPackage( "browse", "app/atlasbrowse.g" );
fi;
ReadPackage("browse", "app/matdisp.g");
ReadPackage("browse", "app/ctbldisp.g");
ReadPackage("browse", "app/tomdisp.g");
ReadPackage("browse", "app/gapbibl.g");
ReadPackage("browse", "app/knight.g");
ReadPackage("browse", "app/manual.g");
if IsPackageMarkedForLoading( "io", "" ) then
  ReadPackage("browse", "app/filetree.g");
fi;
ReadPackage("browse", "app/puzzle.g");
ReadPackage("browse", "app/rubik.g");
ReadPackage("browse", "app/solitair.g");
ReadPackage("browse", "app/sudoku.g");
ReadPackage("browse", "app/pkgvar.g");
ReadPackage("browse", "app/gapdata.g");

# applications called by `BrowseGapData'
ReadPackage("browse", "app/conwaypols.g");
ReadPackage("browse", "app/methods.g");
ReadPackage("browse", "app/packages.g");
ReadPackage( "browse", "app/profile.g" );
if IsPackageMarkedForLoading( "tomlib", "1.2.0" ) then
  ReadPackage( "browse", "app/tmdbattr.g" );
fi;
ReadPackage( "browse", "app/userpref.g" );

# demo
ReadPackage("browse", "app/demo.g");
ReadPackage("browse", "app/mouse.g");

# support for database attributes
ReadPackage( "browse", "lib/brdbattr.gi" );
ReadPackage( "browse", "app/transbrowse.g" );

