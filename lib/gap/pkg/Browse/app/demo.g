#############################################################################
##
#W  demo.g            GAP 4 package `Browse'       Frank Lübeck/Thomas Breuer
##
#Y  Copyright (C) 2006-2007, Lehrstuhl D für Mathematik, RWTH Aachen, Germany
##
##  This file implements the NCurses.Demo() function and installs example
##  applications from this package into a default demo.
##  

NCurses.ReadString := function(s)
  local f;
  f := InputTextString(s);
  Read(f);
  if not IsClosedStream(f) then
    CloseStream(f);
  fi;
end;


#############################################################################
##
#F  NCurses.Demo( [<inputs>] )
##
##  <#GAPDoc Label="Demo_man">
##  <ManSection>
##  <Func Name="NCurses.Demo" Arg="[inputs]"/>
## 
##  <Description>
##  Let <A>inputs</A> be a list of records, each with the components
##  <C>title</C> (a string), <C>inputblocks</C> (a list of strings,
##  each describing some &GAP; statements), and optionally <C>footer</C>
##  (a string) and <C>cleanup</C> (a string describing &GAP; statements).
##  The default is <C>NCurses.DemoDefaults</C>.
##  <P/>
##  <C>NCurses.Demo</C> lets the user choose an entry from <A>inputs</A>,
##  via <Ref Func="NCurses.Select"/>, and then executes the &GAP;
##  statements in the first entry of the <C>inputblocks</C> list of this
##  entry; these strings, together with the values of <C>title</C> and
##  <C>footer</C>, are shown in a window, at the bottom of the screen.
##  The effects of calls to functions using <C>ncurses</C> are shown in the
##  rest of the screen.
##  After the execution of the statements (which may require user input),
##  the user can continue with the next entry of <C>inputblocks</C>,
##  or return to the <C>inputs</C> selection (and thus cancel the current
##  <C>inputs</C> entry), or return to the execution of the beginning of the
##  current <C>inputs</C> entry.
##  At the end of the current entry of <C>inputs</C>,
##  the user returns to the <C>inputs</C> selection.
##  <P/>
##  The &GAP; statements in the <C>cleanup</C> component, if available,
##  are executed whenever the user does not continue;
##  this is needed for deleting panels and windows that are defined in the
##  statements of the current entry.
##  <P/>
##  Note that the &GAP; statements are executed in the <E>global</E> scope,
##  that is, they have the same effect as if they would be entered at the
##  &GAP; prompt.
##  Initially, <C>NCurses.Demo</C> sets the value of
##  <C>BrowseData.defaults.work.windowParameters</C> to the parameters that
##  describe the part of the screen above the window that shows the inputs;
##  so applications of <Ref Func="NCurses.BrowseGeneric"/> use automatically
##  the maximal part of the screen as their window.
##  It is recommended to use a screen with at least <M>80</M> columns
##  and at least <M>37</M> rows.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
NCurses.Demo:= function( arg )
    local inputs, indent, size, infosize, win, pan, oldparas, items, width,
          csize, begin, choices, leny, lenx, i, inp, j, spl, keepsel, sel, r,
          block, l, ch, continu, wback, wpan;

    if Length( arg ) = 0 then
      inputs:= NCurses.DemoDefaults;
    elif Length( arg ) = 1 and IsList( arg[1] )
         and ForAll( arg[1], x -> IsRecord( x ) and IsBound( x.title )
                                  and IsBound( x.inputblocks ) ) then
      inputs:= arg[1];
    else
      Error( "usage: NCurses.Demo( [<inputs>] )" );
    fi;

    indent:= "  ";

    # make sure that background is clean
    wback := NCurses.newwin(0,0,0,0);
    wpan := NCurses.new_panel(wback);
    size:= NCurses.getmaxyx(0);
    infosize:= [ 12, size[2] ];
    oldparas:= BrowseData.defaults.work.windowParameters;
    BrowseData.defaults.work.windowParameters:= [ size[1] - infosize[1],
                                                  size[2], 0, 0 ];

    # Prepare the choices.
    items:= List( inputs, x -> x.title );
    width:= Maximum( List( items, NCurses.WidthAttributeLine ) )
            + LogInt( Length( items ), 10 ) + 7;
    csize:= [ Minimum( Length( items ) + 3, size[1] ),
              Minimum( Maximum( width, 51 ), size[2] ) ];
    begin:= [ QuoInt( size[1] - csize[1], 2 ),
              QuoInt( size[2] - csize[2], 2 ) ];
    choices:= rec( items:= items,
                   none:= true,
                   size:= csize,
                   begin:= begin,
                   border:= true,
                 );

    # Check whether the inputs fit into the info window.
    leny:= infosize[1] - 4;
    lenx:= infosize[2] - 2 - Length( indent );
    for i in [ 1 .. Length( inputs ) ] do
      inp:= inputs[i].inputblocks;
      for j in [ 1 .. Length( inp ) ] do
        spl:= SplitString( inp[j], "", "\n" );
        if leny < Length( spl ) then
          Print( "#E  Please reduce entry ", i, ", step ", j, ", from ",
                 Length( spl ), " to ", leny, " lines.\n" );
        fi;
        if ForAny( spl, x -> lenx < Length( x ) ) then
          Print( "#E  Please reduce the lines of entry ", i, ", step ", j,
                 ", to length ", lenx, ".\n" );
        fi;
      od;
    od;

    keepsel:= false;
    sel:= 0;
    while true do
      sel:= sel + 1;
      if not keepsel then
        choices.select:= [ sel ];
        sel:= NCurses.Select( choices );
        if sel = false then
          break;
        fi;
        r:= inputs[ sel ];
      fi;

      win:= NCurses.newwin( infosize[1], infosize[2],
                            size[1] - infosize[1],
                            QuoInt( size[2] -  infosize[2] - 1, 2 ) );
      pan:= NCurses.new_panel(win);

      for block in r.inputblocks do
        keepsel:= false;
        NCurses.werase( win );
        NCurses.wborder( win, 0 );
        NCurses.PutLine( win, 1, 1, [ NCurses.attrs.BOLD, r.title ] );
        l:= List( SplitString( block, "", "\n" ),
                  a -> Concatenation( indent, a ) );
        NCurses.PutLine(win, 2, 1, l);
        if IsBound( r.footer ) and IsString( r.footer ) then
          NCurses.PutLine( win, infosize[1]-2, 1,
                           [ NCurses.attrs.BOLD, r.footer ] );
        fi;
        NCurses.update_panels();
        NCurses.doupdate();
        NCurses.ReadString( block );
        NCurses.PutLine( win, infosize[1] - 2 , 1, [ NCurses.attrs.BOLD, 
          "'q' to quit, 'b' to repeat, any other character to continue" ] );
        NCurses.top_panel(pan);
        NCurses.curs_set(0);
        NCurses.update_panels();
        NCurses.doupdate();
        ch:= NCurses.wgetch( win );
        continu:= true;
        if   ch = IntChar( 'q' ) then
          # return to the same item in the choices list
          continu:= false;
        elif ch = IntChar( 'b' ) then
          # repeat the current item
          keepsel:= true;
          continu:= false;
        fi;
        if not continu then
          sel:= sel - 1;
          if IsBound( r.cleanup ) then
            NCurses.ReadString( r.cleanup );
          fi;
          break;
        fi;
        NCurses.update_panels();
        NCurses.doupdate();
      od;

      # Clean up.
      NCurses.del_panel( pan );
      NCurses.delwin( win );
      NCurses.endwin();

    od;

    # clean background
    NCurses.del_panel( wpan );
    NCurses.delwin( wback );
    # Reset the default window parameters for `Browse'.
    BrowseData.defaults.work.windowParameters:= oldparas;
end;


#############################################################################
##
#V  NCurses.DemoDefaults
##
NCurses.DemoDefaults:= [];

Add( NCurses.DemoDefaults,
rec( title:= "Basic NCurses Functionality",
inputblocks:= [
"# set some flags for visual mode:\n\
#                no scroll, no echo, key translations ...\n\
NCurses.SetTerm();\n\
# windows are accessed by a number, main window is 0\n\
# go into visual mode:\n\
NCurses.wrefresh(0);\n\
",
"# create a new window of size the whole screen:\n\
win := NCurses.newwin(0,0,0,0);\n\
# wrap it in a panel:\n\
panel := NCurses.new_panel(win);\n\
# update buffers, refresh screen:\n\
NCurses.update_panels(); NCurses.doupdate();\n\
",
"# move cursor, top left corner is position 0, 0:\n\
NCurses.wmove(win, 1, 5);\n\
# write a string at cursor position:\n\
NCurses.waddstr(win, \"ABCDE\");\n\
",
"# print size of window:\n\
size := NCurses.getmaxyx(win);;\n\
NCurses.PutLine(win, 2, 0, [\"Size of window: \",\n\
                            String(size)]);\n\
",
"# at end of line cursor advances to next line:\n\
NCurses.wmove(win, 3, size[2]-3);;\n\
NCurses.waddstr(win, \"abcde\");;\n\
",
"# create another wrapped window:\n\
win2 := NCurses.newwin(12, size[2]-23, 1, 12);;\n\
pan2 := NCurses.new_panel(win2);;\n\
NCurses.wmove(win2, 0, 0);;\n\
str := List([33..126],CHAR_INT);; ConvertToStringRep(str);;\n\
NCurses.waddstr(win2, Concatenation(str, str, str));;\n\
# new panel is top:\n\
NCurses.update_panels(); NCurses.doupdate();\n\
",
"# make window/panel more visible with a border:\n\
# first with prescribed characters for lines and corners ...\n\
NCurses.wborder(win2, List(\"abcdefgh\", IntChar));;\n\
NCurses.update_panels(); NCurses.doupdate();\n\
",
"# now with default lines, depending on terminal capabilities:\n\
NCurses.wborder(win2, 0);;\n\
NCurses.update_panels(); NCurses.doupdate();\n\
",
"# moving the *panel*:\n\
for i in [0..2] do\n\
  NCurses.move_panel(pan2, 1, 10*i);\n\
  NCurses.update_panels(); NCurses.doupdate();\n\
  # sleep 200 ms\n\
  NCurses.napms(200);\n\
od;\n\
",
"# set attributes for next written characters:\n\
NCurses.werase(win);; NCurses.top_panel(panel);; \n\
for c in [\"STANDOUT\",\"UNDERLINE\",\"REVERSE\",\"BLINK\",\
\"DIM\",\"BOLD\"] do\n\
  NCurses.wattrset(win, NCurses.attrs.NORMAL);\n\
  NCurses.waddstr(win, Concatenation(c, \"\\t\\t\"));\n\
  NCurses.wattrset(win, NCurses.attrs.(c));\n\
  NCurses.waddstr(win, \"ABC 123\\n\");\n\
od; NCurses.update_panels();; NCurses.doupdate();;\n\
",
"# colors are accessed by 'color pairs' for fore-/background:\n\
NCurses.werase(win);; defc := NCurses.defaultColors;;\n\
NCurses.wmove(win, 0, 0);;\n\
for a in defc do for b in defc do\n\
  # NCurses.ColorAttr(a, a) give color a in default bg\n\
  NCurses.wattrset(win, NCurses.ColorAttr(a, b));\n\
  NCurses.waddstr(win, Concatenation(a,\"/\",b,\"\\t\"));\n\
od; od; NCurses.update_panels();; NCurses.doupdate();;\n\
",
"# change attribute in whole window:\n\
NCurses.wbkgd(win, NCurses.attrs.BOLD + \n\
                   NCurses.ColorAttr(\"yellow\",\"blue\"));;\n\
NCurses.wmove(win, 4, 10);; NCurses.wclrtobot(win);;\n\
NCurses.waddstr(win, \"\\n\\nThis is also used for new text!\\n\");;\n\
NCurses.update_panels();; NCurses.doupdate();;\n\
",
"# get other panel back, and show line drawing characters:\n\
NCurses.show_panel(pan2);;NCurses.werase(win2);;\n\
for c in RecFields(NCurses.lineDraw) do\n\
  NCurses.waddstr(win2, c);\n\
  NCurses.waddch(win2, '\\t');\n\
  NCurses.waddch(win2, NCurses.lineDraw.(c));\n\
  NCurses.waddch(win2, '\\t');\n\
od; NCurses.update_panels();; NCurses.doupdate();;\n\
",
"# draw some lines, NCurses.Grid takes crossings into account:\n\
NCurses.werase(win2);;\n\
NCurses.Grid(win2, 3, 20, 4, 30, [3,5,8,11,20], [4,12,13,25,30]);\n\
NCurses.update_panels();; NCurses.doupdate();;\n\
",
"# Do not forget to clean up before leaving the ncurses application.\n\
NCurses.del_panel( panel );;\n\
NCurses.delwin( win );;\n\
NCurses.del_panel( pan2 );;\n\
NCurses.delwin( win2 );;\n\
NCurses.endwin();;\n\
NCurses.update_panels();; NCurses.doupdate();;\n\
",
],
cleanup:= "NCurses.del_panel( panel );;\n\
NCurses.delwin( win );;\n\
NCurses.del_panel( pan2 );;\n\
NCurses.delwin( win2 );;\n\
NCurses.endwin();;\n\
NCurses.update_panels(); NCurses.doupdate();\n\
",
) );

Add( NCurses.DemoDefaults,
rec( title:= "NCurses Utilities",
inputblocks:= [
"# create a new window of size the whole screen:\n\
win := NCurses.newwin(0,0,0,0);\n\
# wrap it in a panel:\n\
pan := NCurses.new_panel(win);\n\
",
"# get a string interactively:\n\
userstr := NCurses.GetLineFromUser( rec(\n\
  prefix:= \" Type string and <Return>: \", begin:= [ 10, 2 ] ) );;\n\
NCurses.wmove(win, 0, 0);\n\
NCurses.waddstr(win, userstr);\n\
# go back to visual mode\n\
NCurses.update_panels();; NCurses.doupdate();;\n\
",
"# and another interactive utility:\n\
fruits := [\"apple\", \"pear\", \"banana\", \"orange\"];;\n\
r := rec(items := fruits);;\n\
res:= NCurses.Select(r);;\n\
NCurses.waddstr(win, Concatenation(\"\\nAh, you like \",\n\
                      fruits[res], \"s!\\n\"));;\n\
NCurses.update_panels();; NCurses.doupdate();;\n\
",
"# here is a simple pager utility:\n\
fname := Filename(DirectoriesPackageLibrary(\"Browse\"),\n\
                  \"../PackageInfo.g\");;\n\
sf := StringFile(fname);;\n\
NCurses.Pager(sf, true, 10, 60, 2, 3);;\n\
",
"# Do not forget to clean up before leaving the ncurses application.\n\
NCurses.del_panel( pan );;\n\
NCurses.delwin( win );;\n\
NCurses.endwin();;\n\
NCurses.update_panels();; NCurses.doupdate();;\n\
",
],
cleanup:= "NCurses.del_panel( pan );;\n\
NCurses.delwin( win );;\n\
NCurses.endwin();;\n\
NCurses.update_panels(); NCurses.doupdate();\n\
",
) );


#############################################################################
##
##  mouse.g
##
Add(NCurses.DemoDefaults, rec(
title := "Using mouse with ncurses (if terminal allows)",
inputblocks := [
"# just call the mouse demo function\n\
NCurses.MouseDemo();\n\
" 
] ));

#############################################################################
##
##  ctbldisp.g
##
Add( NCurses.DemoDefaults,
rec( title:= "Browsing in Character Tables (non-interactive)",
inputblocks:= [
"n:= [ 14, 14, 14 ];;  # ``do nothing'' input (means timeout)\n\
BrowseData.SetReplay( Concatenation(\n\
  \"DDRRUL\", n,              # scroll in the table by screens ...\n\
  \"dddddrrrrrlluu\", n, n,   # ... and by cells, ...\n\
  \"Q\" ) );                  # ... and quit\n\
Browse( CharacterTable( \"HN\" ) );\n\
",
"BrowseData.SetReplay( Concatenation(\n\
  \"se\", n,                # select an entry, ...\n\
  \"ddrruuuddlll\", n, n,   # ... move it around, ...\n\
  \"Q\" ) );                # ... and quit\n\
Browse( CharacterTable( \"HN\" ) );\n\
",
"BrowseData.SetReplay( Concatenation(\n\
  \"/135\",                   # enter the search pattern 135, ...\n\
  [ NCurses.keys.ENTER ], n,  # ... start the search, ...\n\
  \"nnnnn\", n, n,            # ... search further (five times), ...\n\
  \"Q\" ) );                  # ... and quit\n\
Browse( CharacterTable( \"HN\" ) );\n\
",
"BrowseData.SetReplay( Concatenation(\n\
  \"scsc\", n,  # sort & categorize by the first column, ...\n\
  \"sr\", n,    # ... select the first row, ...\n\
  \"dddd\", n,  # ... move down the selection, ...\n\
  \"x\", n, n,  # ... expand the selected category, ...\n\
  \"Q\" ) );    # ... and quit\n\
Browse( CharacterTable( \"HN\" ) );\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );


#############################################################################
##
##  tomdisp.g
##
Add( NCurses.DemoDefaults,
rec( title:= "Browsing in Tables of Marks (non-interactive)",
inputblocks:= [
"d:= [ NCurses.keys.DOWN ];;  r:= [ NCurses.keys.RIGHT ];;\n\
c:= [ NCurses.keys.ENTER ];;  n:= [ 14, 14, 14 ];;  # ``do nothing''\n\
BrowseData.SetReplay( Concatenation(\n\
  \"DDRRR\", n,  # scroll in the table, ...\n\
  \"?dddd\", n,  # ... ask for help, scroll in the help table, ...\n\
  \"Q\", n, n,   # ... leave the help table,\n\
  \"Q\" ) );     # ... and quit\n\
Browse( TableOfMarks( \"A10\" ) );\n\
",
"BrowseData.SetReplay( Concatenation(\n\
  \"/100\",       # enter a search pattern, ...\n\
  d, d, r, d, d, d, r,  # ... change search parameters, ...\n\
  c, \"nn\", n,   # ... search for the (exact) value 100 (three times)\n\
  c, n, n,        # (no more occurrences of 100, confirm)\n\
  \"Q\" ) );      # ... and quit\n\
Browse( TableOfMarks( \"A10\" ) );  BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );


#############################################################################
##
##  atlasbrowse.g
##
if IsPackageMarkedForLoading( "atlasrep", "" ) then
Add( NCurses.DemoDefaults,
rec( title:= "Table of Contents of AtlasRep (non-interactive)",
inputblocks:= [
"d:= [ NCurses.keys.DOWN ];;  r:= [ NCurses.keys.RIGHT ];;\n\
c:= [ NCurses.keys.ENTER ];;  n:= [ 14, 14, 14 ];;  # ``do nothing''\n\
BrowseData.SetReplay( Concatenation(\n\
  \"/A5\",     # Find the string A5\n\
  d, d, r, c, c, n,  # s. t. just the word matches, enter, click on A5,\n\
  d, c, \"Q\",  # move down, click on this row, return to the first table,\n\
  d, d, c, d, c, n, # move down twice, click on A6, click on the first row\n\
  \"Q\", \"Q\" ) );     # and quit the two nested tables\n\
",
"tworeps:= BrowseAtlasInfo();;\n\
BrowseData.SetReplay( false );\n\
if fail in tworeps then\n\
  NCurses.Alert( [ \"no access to the Web ATLAS\" ], 2000 );;\n\
else\n\
  NCurses.Alert( [ \"the representations returned belong to the groups \",\n\
     String( List( tworeps, x -> x.identifier[1] ) ) ], 2000 );;\n\
fi;\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );
fi;


#############################################################################
##
##  manual.g
##
Add( NCurses.DemoDefaults,
rec( title:= "The GAP Manuals (non-interactive)",
inputblocks:= [
"n:= [ 14, 14, 14 ];;  # ``do nothing'' input (means timeout)\n\
BrowseData.SetReplay( Concatenation(\n\
  \"x\", n,      # expand the first chapter of the Tutorial, ...\n\
  \"d\", n,      # ... move down, ...\n\
  \"x\", n,      # ... expand the first section of the Tutorial, ...\n\
  \"d\", n, n,   # ... move to the text\n\
  \"Q\" ) );     # ... and quit\n\
BrowseGapManuals( \"inline/collapsed\" );\n\
",
"BrowseData.SetReplay( Concatenation(\n\
  \"/Browse\", [ NCurses.keys.ENTER ], n,  # go to the Browse manual,\n\
  \"xd\", n,                               # to its first chapter,\n\
  \"xdd\", n,                              # to its first section,\n\
  \"xd\", n, n,                            # to its text,\n\
  \"Q\" ) );                               # and quit\n\
BrowseGapManuals( \"inline/collapsed\" );\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );


#############################################################################
##
##  gapbibl.g
##
Add( NCurses.DemoDefaults,
rec( title:= "The GAP Bibliography (non-interactive)",
inputblocks:= [
"n:= [ 14, 14, 14 ];;  # ``do nothing'' input (means timeout)\n\
BrowseData.SetReplay( Concatenation(\n\
  \"scrrsc\", n,     # sort and categorize by year,\n\
  \"seddddd\", n,    # select an entry, scroll down,\n\
  \"xddddd\", n, n,  # expand a category row, scroll down,\n\
  \"Q\" ) );         # and quit\n\
BrowseBibliography();;\n\
",
"BrowseData.SetReplay( Concatenation(\n\
  \"scsc\", n,       # sort and categorize by authors,\n\
  \"Xse\", n,        # expand all category rows, select an entry,\n\
  \"dddddd\", n, n,  # scroll down,\n\
  \"Q\" ) );         # and quit\n\
BrowseBibliography();;\n\
",
"BrowseData.SetReplay( Concatenation(\n\
   \"scrrrsc\", n,             # sort and categorize by journal,\n\
   \"/J. Algebra\",            # enter a search string,\n\
   [ NCurses.keys.ENTER ], n,  # start the search,\n\
   \"nxddd\", n, n,            # search further, expand, scroll down,\n\
   \"Q\" ) );                  # and quit\n\
BrowseBibliography();;\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );


#############################################################################
##
##  filetree.g
##
if IsPackageMarkedForLoading( "io", "" ) then
Add( NCurses.DemoDefaults,
rec( title:= "Contents of the Browse Directory (non-interactive)",
inputblocks:= [
"n:= [ 14, 14, 14 ];;  # ``do nothing'' input (means timeout)\n\
BrowseData.SetReplay( Concatenation(\n\
   \"x\", n,                     # expand the first category row,\n\
   \"ddddd\", n,                 # move the selection down,\n\
   [ NCurses.keys.ENTER ], n,  # click the entry,\n\
   \"Q\" ) );                    # and quit\n\
file:= Filename( DirectoriesPackageLibrary( \"Browse\" ), \"\" );;\n\
BrowseDirectory( file );;\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );
fi;


#############################################################################
##
##  puzzle.g
##
Add( NCurses.DemoDefaults,
rec( title:= "Loyd's Fifteen (non-interactive)",
inputblocks:= [
"BrowseData.SetReplay( BrowsePuzzleSolution.steps );\n\
BrowsePuzzle( 4, 4, BrowsePuzzleSolution.init );;\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Loyd's Fifteen (interactive)",
inputblocks:= [
"BrowsePuzzle();;\n\
" ],
footer:= "(arrow keys to move, 'Q' to quit)",
) );


#############################################################################
##
##  solitair.g
##
Add( NCurses.DemoDefaults,
rec( title:= "Peg Solitaire, 33 holes (non-interactive)",
inputblocks:= [
"BrowseData.SetReplay( PegSolitaireSolutions.33 );\n\
PegSolitaire( 33 );\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Peg Solitaire, 33 holes (interactive)",
inputblocks:= [
"PegSolitaire( 33 );\n\
" ],
footer:= "(arrow keys to move, 'j' and arrow keys to jump, 'Q' to quit)",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Peg Solitaire, 37 holes (non-interactive)",
inputblocks:= [
"BrowseData.SetReplay( PegSolitaireSolutions.37 );\n\
PegSolitaire( 37 );\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Peg Solitaire, 37 holes (interactive)",
inputblocks:= [
"PegSolitaire( 37 );\n\
" ],
footer:= "(arrow keys to move, 'j' and arrow keys to jump, 'Q' to quit)",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Peg Solitaire, 45 holes (non-interactive)",
inputblocks:= [
"BrowseData.SetReplay( PegSolitaireSolutions.45 );\n\
PegSolitaire( 45 );\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Peg Solitaire, 45 holes (interactive)",
inputblocks:= [
"PegSolitaire( 45 );\n\
" ],
footer:= "(arrow keys to move, 'j' and arrow keys to jump, 'Q' to quit)",
) );


#############################################################################
##
##  rubik.g
##
Add( NCurses.DemoDefaults,
rec( title:= "Rubik's Cube (non-interactive)",
inputblocks:= [
"cubegens := [\n\
  ( 1, 3, 8, 6)( 2, 5, 7, 4)( 9,33,25,17)(10,34,26,18)(11,35,27,19),\n\
  ( 9,11,16,14)(10,13,15,12)( 1,17,41,40)( 4,20,44,37)( 6,22,46,35),\n\
  (17,19,24,22)(18,21,23,20)( 6,25,43,16)( 7,28,42,13)( 8,30,41,11),\n\
  (25,27,32,30)(26,29,31,28)( 3,38,43,19)( 5,36,45,21)( 8,33,48,24),\n\
  (33,35,40,38)(34,37,39,36)( 3, 9,46,32)( 2,12,47,29)( 1,14,48,27),\n\
  (41,43,48,46)(42,45,47,44)(14,22,30,38)(15,23,31,39)(16,24,32,40) \
];;\n\
",
"choice:= List( [ 1 .. 30 ], i -> Random( [ 1 .. 6 ] ) );;\n\
input:= \"tlfrbd\";;  input:= input{ choice };;\n\
input:= Concatenation(\n\
  input{ [ 1 .. 20 ] }, \"s\",    # switch to number display\n\
  input{ [ 21 .. 25 ] }, \"s\",   # switch to color display\n\
  input{ [ 26 .. 30 ] } );;\n\
",
"BrowseData.SetReplay( input );\n\
BrowseRubiksCube( Product( cubegens{ choice } ) );;\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Rubik's Cube (interactive)",
inputblocks:= [
"BrowseRubiksCube();;\n\
" ],
footer:= "('tlfrbdTLFRBD' to move, 'Q' to quit)",
) );


#############################################################################
##
##  knight.g
##
Add( NCurses.DemoDefaults,
rec( title:= "Changing Sides (non-interactive)",
inputblocks:= [
"BrowseData.SetReplay( BrowseChangeSidesSolutions[1] );\n\
BrowseChangeSides();\n\
BrowseData.SetReplay( false );\n\
" ],
footer:= "(enter 'Q' for interrupting)",
cleanup:= "BrowseData.SetReplay( false );\n\
",
) );

Add( NCurses.DemoDefaults,
rec( title:= "Changing Sides (interactive)",
inputblocks:= [
"BrowseChangeSides();\n\
" ],
footer:= "(triples of arrow keys to move, 'Q' to quit)",
) );


#############################################################################
##
##  sudoku.g
##
Add( NCurses.DemoDefaults,
rec( title:= "Sudoku (interactive)",
inputblocks:= [
"# generate a random game\n\
PlaySudoku();\n"],
footer :=  "(try 'h' for a hint, 's' for the solution, '?' for more help)",
) );


#############################################################################
##
#E

