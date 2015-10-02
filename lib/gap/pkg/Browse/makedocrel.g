##  this creates the documentation, needs: GAPDoc package, latex, pdflatex,
##  mkindex, dvips, gs
##

SetInfoLevel( InfoGAPDoc, 2 );

pathtodoc:= "doc";;
pathtopkg:= ".";;
main:= "main.xml";;
pkgname:= "Browse";;
bookname:= "Browse";;
if not IsBound(pathtoroot) then
  pathtoroot:= "../../..";
fi;

files:= [
    "../app/atlasbrowse.g",
    "../app/ctbldisp.g",
    "../app/demo.g",
    "../app/filetree.g",
    "../app/gapbibl.g",
    "../app/gapdata.g",
    "../app/knight.g",
    "../app/manual.g",
    "../app/matdisp.g",
    "../app/pkgvar.g",
    "../app/profile.g",
    "../app/puzzle.g",
    "../app/rubik.g",
    "../app/solitair.g",
    "../app/sudoku.g",
    "../app/tmdbattr.g",
    "../app/tomdisp.g",
    "../app/transbrowse.g",
    "../app/transdbattr.g",
    "../app/userpref.g",
    "../lib/brdbattr.gd",
    "../lib/browse.gd",
    "../lib/browse.gi",
    "../lib/brutils.g",
    "../lib/ncurses.gd",
    "../lib/ncurses.gi",
  ];;

AddHandlerBuildRecBibXMLEntry( "Wrap:Package", "BibTeX",
  function( entry, r, restype, strings, options )
    return Concatenation( "\\textsf{", ContentBuildRecBibXMLEntry(
               entry, r, restype, strings, options ), "}" );
  end );

AddHandlerBuildRecBibXMLEntry( "Wrap:Package", "HTML",
  function( entry, r, restype, strings, options )
    return Concatenation( "<strong class='pkg'>", ContentBuildRecBibXMLEntry(
               entry, r, restype, strings, options ), "</strong>" );
  end );


# Fetch GAP's current 'manualbib.xml'.
bibfile:= Filename( DirectoriesLibrary( "doc" ), "manualbib.xml" );
if bibfile = fail then
  Error( "cannot access GAP's current 'manualbib.xml'" );
fi;
Exec( Concatenation( "cp ", bibfile, " ", pathtodoc ) );

tree := MakeGAPDocDoc( pathtodoc, main, files, bookname, pathtoroot );;

# Remove GAP's current 'manualbib.xml'.
Exec( Concatenation( "rm ", pathtodoc, "/", "manualbib.xml" ) );

CopyHTMLStyleFiles(pathtodoc);

GAPDocManualLabFromSixFile( bookname, 
    Concatenation( pathtodoc, "/manual.six" ) );


#############################################################################

# Create/update the testfile (manual examples).
pathtotst:= "tst";
tstfilename:= "test.tst";
authors:= [ "Thomas Breuer", "Frank Lübeck" ];
copyrightyear:= "2013";
tstheadertext:= Concatenation( "\
This file contains the GAP code of the examples in the package\n\
documentation files.\n\
\n\
In order to run the tests, one starts GAP from the `tst' subdirectory\n\
of the `pkg/", pkgname, "' directory, and calls `Test( \"", tstfilename,
"\" );'.\n" );

ExampleFileHeader:= function( filename, pkgname, authors, copyrightyear,
                              text, linelen )
    local free1, free2, str, i;

    free1:= Int( ( linelen - Length( pkgname ) - 14 ) / 2 );
    free2:= linelen - free1 - 14 - Length( pkgname ) - Length( authors[1] );

    str:= RepeatedString( "#", linelen );
    Append( str, "\n##\n#W  " );
    Append( str, filename );
    Append( str, RepeatedString( " ", free1 - Length( filename ) - 4 ) );
    Append( str, "GAP 4 package " );
    Append( str, pkgname );
    Append( str, RepeatedString( " ", free2 ) );
    Append( str, authors[1] );
    for i in [ 2 .. Length( authors ) ] do
      Append( str, "\n#W" );
      Append( str, RepeatedString( " ", linelen - Length( authors[i] ) - 2 ) );
      Append( str, authors[i] );
    od;
    Append( str, "\n##\n#Y  Copyright (C)  " );
    Append( str, String( copyrightyear ) );
    Append( str, ",   Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany" );
    Append( str, "\n##\n##  " );
    Append( str, ReplacedString( text, "\n", "\n##  " ) );

    Append( str, "\n\ngap> LoadPackage( \"" );
    Append( str, pkgname );
    Append( str, "\", false );\ntrue" );
    Append( str, "\ngap> save:= SizeScreen();;" );
    Append( str, "\ngap> SizeScreen( [ 72 ] );;" );
    Append( str, "\ngap> START_TEST( \"Input file: " );
    Append( str, filename );
    Append( str, "\" );\n" );

    return str;
end;

ExampleFileFooter:= function( filename, linelen )
    local str;

    str:= "\n##\ngap> STOP_TEST( \"";
    Append( str, filename );
    Append( str, "\", 10000000 );\n" );
    Append( str, "gap> SizeScreen( save );;\n\n" );
    Append( str, RepeatedString( "#", linelen ) );
    Append( str, "\n##\n#E\n" );

    return str;
end;


# create the test file with manual examples
# (for a package: combined for all chapters)
CreateManualExamplesFile:= function( pkgname, authors, copyrightyear, text,
                                     path, main, files, tstpath, tstfilename )
    local linelen, str, r, l, tstfilenameold;

    linelen:= 77;
    str:= "# This file was created automatically, do not edit!\n";
    Append( str, ExampleFileHeader( tstfilename, pkgname, authors,
                                    copyrightyear, text, linelen ) );
    Append( str, "\n##\ngap> oldinterval:= BrowseData.defaults.dynamic.replayDefaults.replayInterval;;\ngap> BrowseData.defaults.dynamic.replayDefaults.replayInterval:= 1;;\n" );
    for r in ExtractExamples( path, main, files, "Chapter" ) do
      for l in r do
        Append( str, Concatenation( "\n##  ", l[2][1],
                " (", String( l[2][2] ), "-", String( l[2][3] ), ")" ) );
        Append( str, l[1] );
      od;
    od;
    Append( str, "\n##\ngap> BrowseData.defaults.dynamic.replayDefaults.replayInterval:= oldinterval;;\n" );
    Append( str, ExampleFileFooter( tstfilename, linelen ) );

    tstfilename:= Concatenation( tstpath, "/", tstfilename );
    tstfilenameold:= Concatenation( tstfilename, "~" );
    if IsExistingFile( tstfilename ) then
      Exec( Concatenation( "rm -f ", tstfilenameold ) );
      Exec( Concatenation( "mv ", tstfilename, " ", tstfilenameold ) );
    fi;
    FileString( tstfilename, str );
    if IsExistingFile( tstfilenameold ) then
      Print( "#I  differences in `", tstfilename, "':\n" );
      Exec( Concatenation( "diff ", tstfilenameold, " ", tstfilename ) );
    fi;
    Exec( Concatenation( "chmod 444 ", tstfilename ) );
end;


CreateManualExamplesFile( pkgname, authors, copyrightyear, tstheadertext,
                          pathtodoc, main, files, pathtotst, tstfilename );


#############################################################################

# Create the necessary `png' files.
CreatePictures:= function( filenames, pathtodoc )
  local filename, str, pos, pos2, sub, nam;

  for filename in filenames do
    str:= ReplacedString( StringFile( filename ), "\n##  ", "\n" );
    pos:= PositionSublist( str, "<!-- BP " );
    pos2:= PositionSublist( str, "]]>\n<!-- EP" );
    while pos <> fail and pos2 <> fail do
      sub:= str{ [ pos + 8 .. pos2-1 ] };
      nam:= sub{ [ 1 .. Position( sub, ' ' ) - 1 ] };
      pos:= Position( sub, '\n' );
      pos:= Position( sub, '\n', pos );
      sub:= sub{ [ pos .. Length( sub ) ] };
      PrintTo( nam, "\\batchmode\\documentclass{article}\n",
                    "\\usepackage{graphicx}\\usepackage{epsfig}\n",
                    "\\pagestyle{empty}\\begin{document}\n",
                    sub,
                    "\n\\end{document}\n" );
      Exec( Concatenation( "latex ", nam ) );
      Exec( Concatenation( "dvips -o ", nam, ".ps ", nam ) );
      Exec( Concatenation( "gs -sDEVICE=ppmraw -sOutputFile=- -sNOPAUSE -q ",
                nam, ".ps -c showpage -c quit | pnmcrop| pnmmargin ",
                "-white 10 | pnmtopng > ", nam, ".png" ) );
      Exec( Concatenation( "rm -rf ", nam, " ", nam, ".aux ", nam, ".dvi ",
                nam, ".log ", nam, ".ps" ) );
      if pathtodoc <> "." then
        Exec( Concatenation( "mv ", nam, ".png ", pathtodoc ) );
      fi;

      pos:= PositionSublist( str, "<!-- BP", pos2 );
      pos2:= PositionSublist( str, "]]>\n<!-- EP", pos2 );
    od;
  od;
end;

CreatePictures( [ "app/rubik.g", "app/solitair.g" ], pathtodoc );


