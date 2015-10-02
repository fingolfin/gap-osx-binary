# This file was created automatically, do not edit!
#############################################################################
##
#W  test.tst                GAP 4 package Browse                Thomas Breuer
#W                                                              Frank Lübeck
##
#Y  Copyright (C)  2013,   Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains the GAP code of the examples in the package
##  documentation files.
##  
##  In order to run the tests, one starts GAP from the `tst' subdirectory
##  of the `pkg/Browse' directory, and calls `Test( "test.tst" );'.
##  

gap> LoadPackage( "Browse", false );
true
gap> save:= SizeScreen();;
gap> SizeScreen( [ 72 ] );;
gap> START_TEST( "Input file: test.tst" );

##
gap> oldinterval:= BrowseData.defaults.dynamic.replayDefaults.replayInterval;;
gap> BrowseData.defaults.dynamic.replayDefaults.replayInterval:= 1;;

##  doc/../lib/ncurses.gi (815-828)
gap> win := NCurses.newwin(0,0,0,0);; pan := NCurses.new_panel(win);;
gap> defc := NCurses.defaultColors;;
gap> NCurses.wmove(win, 0, 0);;
gap> for a in defc do for b in defc do
>      NCurses.wattrset(win, NCurses.ColorAttr(a, b));
>      NCurses.waddstr(win, Concatenation(a,"/",b,"\t"));
>    od; od;
gap> if NCurses.IsStdoutATty() then
>      NCurses.update_panels();; NCurses.doupdate();;
>      NCurses.napms(5000);;     # show for 5 seconds
>      NCurses.endwin();; NCurses.del_panel(pan);; NCurses.delwin(win);;
>    fi;

##  doc/../lib/ncurses.gi (79-89)
gap> NCurses.IsAttributeLine( "abc" );
true
gap> NCurses.IsAttributeLine( [ "abc", "def" ] );
false
gap> NCurses.IsAttributeLine( [ NCurses.attrs.UNDERLINE, true, "abc" ] );
true
gap> NCurses.IsAttributeLine( "" );  NCurses.IsAttributeLine( [] );
true
false

##  doc/../lib/ncurses.gi (152-165)
gap> plain_str:= "hello";;
gap> with_attr:= [ NCurses.attrs.BOLD, "bold" ];;
gap> NCurses.ConcatenationAttributeLines( [ plain_str, plain_str ] );
"hellohello"
gap> NCurses.ConcatenationAttributeLines( [ plain_str, with_attr ] );
[ "hello", 2097152, "bold" ]
gap> NCurses.ConcatenationAttributeLines( [ with_attr, plain_str ] );
[ 2097152, "bold", 0, "hello" ]
gap> NCurses.ConcatenationAttributeLines( [ with_attr, with_attr ] );
[ 2097152, "bold", 0, 2097152, "bold" ]
gap> NCurses.ConcatenationAttributeLines( [ with_attr, with_attr ], true );
[ 2097152, "bold", 2097152, "bold" ]

##  doc/../lib/ncurses.gi (277-282)
gap> NCurses.RepeatedAttributeLine( "12345", 23 );
"12345123451234512345123"
gap> NCurses.RepeatedAttributeLine( [ NCurses.attrs.BOLD, "12345" ], 13 );
[ 2097152, "12345", 0, 2097152, "12345", 0, 2097152, "123" ]

##  doc/../lib/ncurses.gi (1048-1054)
gap> NCurses.WidthAttributeLine( "abcde" );
5
gap> NCurses.WidthAttributeLine( [ NCurses.attrs.BOLD, "abc",
>        NCurses.attrs.NORMAL, "de" ] );
5

##  doc/../lib/ncurses.gi (2827-2834)
gap> NCurses.Alert( "Hello world!", 1000 );
fail
gap> NCurses.Alert( [ "Hello world!",
>      [ "Hello ", NCurses.attrs.BOLD, "bold!" ] ], 1500,
>      NCurses.ColorAttr( "red", -1 ) + NCurses.attrs.BOLD );
fail

##  doc/../lib/browse.gi (246-258)
gap> BrowseData.IsBrowseTableCellData( "abc" );
true
gap> BrowseData.IsBrowseTableCellData( [ "abc", "def" ] );
true
gap> BrowseData.IsBrowseTableCellData( rec( rows:= [ "ab", "cd" ],
>                                           align:= "tl" ) );
true
gap> BrowseData.IsBrowseTableCellData( "" );
true
gap> BrowseData.IsBrowseTableCellData( [] );
true

##  doc/../lib/browse.gi (1997-2003)
gap> BrowseData.BlockEntry( "abc", 3, 5 );
[ "     ", "  abc", "     " ]
gap> BrowseData.BlockEntry( rec( rows:= [ "ab", "cd" ],
>                                align:= "tl" ), 3, 5 );
[ "ab   ", "cd   ", "     " ]

##  doc/../lib/browse.gi (440-447)
gap> m:= 10;;  n:= 5;;
gap> xpl1:= rec( work:= rec(
>      main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
>        j -> String( [ i, j ] ) ) ) ) );;
gap> BrowseData.IsBrowseTable( xpl1 );
true

##  doc/../lib/browse.gi (454-467)
gap> m:= 6;;  n:= 5;;
gap> xpl2:= rec( work:= rec(
>      main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
>        j -> rec( rows:= List( [ -i*j, i*j*1000+j, i-j ], String ),
>                  align:= "c" ) ) ),
>      labelsRow:= List( [ 1 .. m ], i -> [ String( i ) ] ),
>      labelsCol:= [ List( [ 1 .. n ], String ) ],
>      sepRow:= "-",
>      sepCol:= "|",
>  ) );;
gap> BrowseData.IsBrowseTable( xpl2 );
true

##  doc/../lib/browse.gi (476-516)
gap> m:= 30;;  n:= 25;;
gap> xpl3:= rec( work:= rec(
>      header:= [ "                    Example 3" ],
>      labelsRow:= List( [ 1 .. 30 ], i -> [ String( i ) ] ),
>      sepLabelsRow:= " % ",
>      sepLabelsCol:= "=",
>      sepRow:= "*",
>      sepCol:= " |",
>      footer:= t -> [ Concatenation( "top-left entry is: ",
>                          String( t.dynamic.topleft{ [ 1, 2] } ) ) ],
>  ) );;
gap> if NCurses.attrs.has_colors then
>   xpl3.work.main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
>     j -> rec( rows:= [ String( -i*j ),
>                        [ NCurses.attrs.BOLD, true,
>                          NCurses.attrs.ColorPairs[56+1], true,
>                          String( i*j*1000+j ),
>                          NCurses.attrs.NORMAL, true ],
>                          String( i-j ) ],
>               align:= "c" ) ) );
>   xpl3.work.labelsCol:= [ List( [ 1 .. 30 ], i -> [
>     NCurses.attrs.ColorPairs[ 56+4 ], true,
>     String( i ),
>     NCurses.attrs.NORMAL, true ] ) ];
> else
>   xpl3.work.main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
>     j -> rec( rows:= [ String( -i*j ),
>                        [ NCurses.attrs.BOLD, true,
>                          String( i*j*1000+j ),
>                          NCurses.attrs.NORMAL, true ],
>                          String( i-j ) ],
>               align:= "c" ) ) );
>   xpl3.work.labelsCol:= [ List( [ 1 .. 30 ], i -> [
>     NCurses.attrs.BOLD, true,
>     String( i ),
>     NCurses.attrs.NORMAL, true ] ) ];
> fi;
gap> BrowseData.IsBrowseTable( xpl3 );
true

##  doc/../lib/browse.gi (527-545)
gap> xpl4:= rec(
>     defc:= NCurses.defaultColors,
>     wd:= Maximum( List( ~.defc, Length ) ),
>     ca:= NCurses.ColorAttr,
>     work:= rec(
>       header:= [ "Examples of NCurses.ColorAttr" ],
>       main:= List( ~.defc, i -> List( ~.defc,
>         j -> [ [ ~.ca( i, j ), String( i, ~.wd ) ],        # no true!
>                [ ~.ca( i, j ), true, String( "on", ~.wd ) ],
>                [ ~.ca( i, j ), String( j, ~.wd ) ] ] ) ),  # no true!
>       labelsRow:= List( ~.defc, i -> [ String( i ) ] ),
>       labelsCol:= [ List( ~.defc, String ) ],
>       sepRow:= "-",
>       sepCol:= [ " |", "|" ],
>  ) );;
gap> BrowseData.IsBrowseTable( xpl4 );
true

##  doc/../lib/browse.gi (5418-5429)
gap> xpl1.work.ShowHelp:= BrowseData.ShowHelpPager;;
gap> BrowseData.SetReplay( "?Q" );
gap> Unbind( xpl1.dynamic );
gap> NCurses.BrowseGeneric( xpl1 );
gap> xpl1.work.ShowHelp:= BrowseData.ShowHelpTable;;
gap> BrowseData.SetReplay( "?dQQ" );
gap> Unbind( xpl1.dynamic );
gap> NCurses.BrowseGeneric( xpl1 );
gap> BrowseData.SetReplay( false );
gap> Unbind( xpl1.dynamic );

##  doc/../app/matdisp.g (108-124)
gap> n:= [ 14, 14, 14, 14 ];;
gap> input:= Concatenation( n, n, n, "Q" );;  # ``do nothing and quit''
gap> BrowseData.SetReplay( input );
gap> Browse( RandomMat( 10, 10, Integers ) );
gap> BrowseData.SetReplay( input );
gap> Browse( RandomMat( 10, 10, GF(3) ) );
gap> BrowseData.SetReplay( input );
gap> Browse( RandomMat( 10, 10, GF(4) ) );
gap> BrowseData.SetReplay( input );
gap> Browse( RandomMat( 10, 10, Integers mod 6 ) );
gap> BrowseData.SetReplay( input );
gap> Browse( RandomMat( 10, 10, GF( NextPrimeInt( 2^16 ) ) ) );
gap> BrowseData.SetReplay( input );
gap> Browse( RandomMat( 10, 10, GF( 2^20 ) ) );
gap> BrowseData.SetReplay( false );

##  doc/../app/ctbldisp.g (60-82)
gap> if TestPackageAvailability( "CTblLib" ) = true then
>      BrowseData.SetReplay( Concatenation(
>         # scroll in the table
>         "DRULdddddrrrrrlluu",
>         # select an entry and move it around
>         "seddrruuuddlll",
>         # search for the pattern 135 (six times)
>         "/135", [ NCurses.keys.ENTER ], "nnnnn",
>         # deselect the entry, select the first column
>         "qLsc",
>         # sort and categorize by this column
>         "sc",
>         # select the first row, move down the selection
>         "srdddd",
>         # expand the selected category, scroll the selection down
>         "xd",
>         # and quit the application
>         "Q" ) );
>      Browse( CharacterTable( "HN" ) );
>      BrowseData.SetReplay( false );
> fi;

##  doc/../app/ctbldisp.g (678-690)
gap> BrowseData.SetReplay( Concatenation(
>         # select the first entry
>         "se",
>         # scroll in the table
>         "drrrr",
>         # keep the table open for a while
>         [ 14, 14, 14, 14, 14 ],
>         # and quit the application
>         "Q" ) );
gap> BrowseDecompositionMatrix( CharacterTable( "J1" ) mod 2 );
gap> BrowseData.SetReplay( false );

##  doc/../app/tomdisp.g (41-58)
gap> if TestPackageAvailability( "TomLib" ) = true then
>      BrowseData.SetReplay( Concatenation(
>         # scroll in the table
>         "DDRRR",
>         # search for the (exact) value 100 (three times)
>         "/100",
>         [ NCurses.keys.DOWN, NCurses.keys.DOWN, NCurses.keys.RIGHT ],
>         [ NCurses.keys.DOWN, NCurses.keys.DOWN, NCurses.keys.DOWN ],
>         [ NCurses.keys.RIGHT, NCurses.keys.ENTER ], "nn",
>         # no more occurrences of 100, confirm
>         [ NCurses.keys.ENTER ],
>         # and quit the application
>         "Q" ) );
>      Browse( TableOfMarks( "A10" ) );
>      BrowseData.SetReplay( false );
>    fi;

##  doc/../app/atlasbrowse.g (497-526)
gap> d:= [ NCurses.keys.DOWN ];;  r:= [ NCurses.keys.RIGHT ];;
gap> c:= [ NCurses.keys.ENTER ];;
gap> BrowseData.SetReplay( Concatenation(
>        "/A5",         # Find the string A5 ...
>        d, d, r,       # ... such that just the word matches,
>        c,             # start the search,
>        c,             # click the table entry A5,
>        d, d,          # move down two rows,
>        c,             # click the row for this representation,
>        "Q",           # quit the second level table,
>        d, d,          # move down two rows,
>        c,             # click the table entry A6,
>        d,             # move down one row,
>        c,             # click the first row,
>        "Q",           # quit the second level table,
>        "Q" ) );       # and quit the application.
gap> if IsBound( BrowseAtlasInfo ) and IsBound( AtlasProgramInfo ) then
>      tworeps:= BrowseAtlasInfo();
>    else
>      tworeps:= [ fail ];
>    fi;
gap> BrowseData.SetReplay( false );
gap> if fail in tworeps then
>      Print( "no access to the Web ATLAS\n" );
>    else
>      Print( List( tworeps, x -> x.identifier[1] ), "\n" );
[ "A5", "A6" ]
>    fi;

##  doc/../app/manual.g (69-81)
gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
gap> BrowseData.SetReplay( Concatenation(
>        "xdxd",                             # expand a Tutorial section
>        n, "Q" ) );                         # and quit
gap> BrowseGapManuals( "inline/collapsed" );
gap> BrowseData.SetReplay( Concatenation(
>        "/Browse", [ NCurses.keys.ENTER ],  # search for "Browse"
>        "xdxddxd",                          # expand a section
>        n, "Q" ) );                         # and quit
gap> BrowseGapManuals( "inline/collapsed" );
gap> BrowseData.SetReplay( false );

##  doc/../app/gapbibl.g (356-358)
gap> file:= Filename( DirectoriesLibrary( "doc" ), "manualbib.xml" );;

##  doc/../app/gapbibl.g (396-408)
gap> # sort and categorize by year, scroll down, expand a category row
gap> BrowseData.SetReplay( "scrrscsedddddxdddddQ" );
gap> BrowseBibliography();;
gap> # sort & categorize by authors, expand all category rows, scroll down
gap> BrowseData.SetReplay( "scscXseddddddQ" );
gap> BrowseBibliography();;
gap> # sort and categorize by journal, search for a journal name, expand
gap> BrowseData.SetReplay( Concatenation( "scrrrsc/J. Algebra",
>        [ NCurses.keys.ENTER ], "nxdddQ" ) );
gap> BrowseBibliography();;
gap> BrowseData.SetReplay( false );

##  doc/../app/profile.g (56-73)
gap> n:= [ 14, 14, 14, 14, 14 ];;  # ``do nothing''
gap> ProfileOperationsAndMethods( true );    # collect some data
gap> ConjugacyClasses( PrimitiveGroup( 24, 1 ) );;
gap> ProfileOperationsAndMethods( false );
gap> BrowseData.SetReplay( Concatenation(
>        "scso",                                 # sort by column 1,
>        n,
>        "rso",                                  # sort by column 2,
>        n,
>        "rso",                                  # sort by column 3,
>        n,
>        "q",                                    # deselect the column,
>        "/Centralizer", [ NCurses.keys.ENTER ], # search for a function,
>        n, "Q" ) );                             # and quit
gap> BrowseProfile();
gap> BrowseData.SetReplay( false );

##  doc/../app/gapdata.g (139-151)
gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
gap> # open the overview of Conway polynomials
gap> BrowseData.SetReplay( Concatenation( "/Conway Polynomials",
>      [ NCurses.keys.ENTER, NCurses.keys.ENTER ], "srdddd", n, "Q" ) );
gap> BrowseGapData();;
gap> # open the overview of GAP packages
gap> BrowseData.SetReplay( Concatenation( "/GAP Packages",
>      [ NCurses.keys.ENTER, NCurses.keys.ENTER ], "/Browse",
>      [ NCurses.keys.ENTER ], "n", n, "Q" ) );
gap> BrowseGapData();;
gap> BrowseData.SetReplay( false );

##  doc/../app/filetree.g (124-136)
gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
gap> BrowseData.SetReplay( Concatenation(
>        "q",                                  # leave the selection
>        "X",                                  # expand all categories
>        "/filetree", [ NCurses.keys.ENTER ],  # search for "filetree"
>        n, "Q" ) );                           # and quit
gap> dir:= Filename( DirectoriesPackageLibrary( "Browse", "" ), "" );;
gap> if IsBound( BrowseDirectory ) then
>      BrowseDirectory( dir );
>    fi;
gap> BrowseData.SetReplay( false );

##  doc/../app/puzzle.g (89-94)
gap> BrowseData.SetReplay( Concatenation(
>        BrowsePuzzleSolution.steps, "Q" ) );
gap> BrowsePuzzle( 4, 4, BrowsePuzzleSolution.init );;
gap> BrowseData.SetReplay( false );

##  doc/../app/solitair.g (123-133)
gap> for n in [ 33, 37, 45 ] do
>      BrowseData.SetReplay( Concatenation(
>          PegSolitaireSolutions.( String( n ) ), "Q" ) );
>      PegSolitaire( n );
>      PegSolitaire( "large", n );
>      PegSolitaire( n, true );
>      PegSolitaire( "large", n, true );
> od;
gap> BrowseData.SetReplay( false );

##  doc/../app/rubik.g (94-103)
gap> cubegens := [
>   ( 1, 3, 8, 6)( 2, 5, 7, 4)( 9,33,25,17)(10,34,26,18)(11,35,27,19),
>   ( 9,11,16,14)(10,13,15,12)( 1,17,41,40)( 4,20,44,37)( 6,22,46,35),
>   (17,19,24,22)(18,21,23,20)( 6,25,43,16)( 7,28,42,13)( 8,30,41,11),
>   (25,27,32,30)(26,29,31,28)( 3,38,43,19)( 5,36,45,21)( 8,33,48,24),
>   (33,35,40,38)(34,37,39,36)( 3, 9,46,32)( 2,12,47,29)( 1,14,48,27),
>   (41,43,48,46)(42,45,47,44)(14,22,30,38)(15,23,31,39)(16,24,32,40)
> ];;

##  doc/../app/rubik.g (145-158)
gap> choice:= List( [ 1 .. 30 ], i -> Random( [ 1 .. 6 ] ) );;
gap> input:= List( "tlfrbd", IntChar ){ choice };;
gap> BrowseData.SetReplay( Concatenation(
>        input{ [ 1 .. 20 ] },
>        "s",                    # switch to number display
>        input{ [ 21 .. 25 ] },
>        "s",                    # switch to color display
>        input{ [ 26 .. 30 ] },
>        "Q" ) );;               # quit the browse table
gap> BrowseRubiksCube( Product( cubegens{ choice } ) );;
gap> BrowseRubiksCube( "large", Product( cubegens{ choice } ) );;
gap> BrowseData.SetReplay( false );

##  doc/../app/knight.g (79-85)
gap> for entry in BrowseChangeSidesSolutions do
>      BrowseData.SetReplay( Concatenation( entry, "Q" ) );
>      BrowseChangeSides();
> od;
gap> BrowseData.SetReplay( false );

##  doc/../app/sudoku.g (238-241)
gap> game := Sudoku.Init(" 3   68  | 85  1 69|  97   53|      79 |\
>  6  47   |45  2    |89   2 1 | 4   8 7 | ");;

##  doc/../app/sudoku.g (269-278)
gap> game := Sudoku.Init(" 3   68  | 85  1 69|  97   53|      79 |\
>  6  47   |45  2    |89   2 1 | 4   8 7 | ");;
gap> Sudoku.Place(game, 1, 3);; # 3 is already in first row
gap> IsBound(game.impossible);
true
gap> Sudoku.Place(game, 1, 2);; # 2 is not in row, col or subsquare
gap> IsBound(game.impossible);
false

##  doc/../app/sudoku.g (297-303)
gap> Sudoku.RandomGame(5833750);
[ " 1         2     43  2   68   72    8     6 2   1 9 8  8 3   9     \
47 3   7  18  ", 5833750 ]
gap> last = Sudoku.RandomGame(last[2]);
true

##  doc/../app/sudoku.g (313-328)
gap> game := Sudoku.Init(" 3   68  | 85  1 69|  97   53|      79 |\
>  6  47   |45  2    |89   2 1 | 4   8 7 | ");;
gap> Sudoku.SimpleDisplay(game);
 3 |  6|8  
 85|  1| 69
  9|7  | 53
-----------
   |   |79 
 6 | 47|   
45 | 2 |   
-----------
89 |  2| 1 
 4 |  8| 7 
   |   |   

##  doc/../app/sudoku.g (409-425)
gap> s := "      5  | 154 6 2 |9   5 3  |6 4      |   8     |8  9   53\
> |     5   | 4   7  2|  91  8  ";;
gap> sol := Sudoku.UniqueSolution(Sudoku.Init(s));;
gap> Sudoku.SimpleDisplay(sol);
438|219|576
715|436|928
962|758|314
-----------
694|573|281
153|862|749
827|941|653
-----------
281|695|437
546|387|192
379|124|865

##  doc/brdbattr.xml (89-95)
gap> n:= 100;;
gap> smallintenum1:= DatabaseIdEnumerator( rec(
>      identifiers:= [ 1 .. n ],
>      entry:= function( dbidenum, id ) return id; end,
>    ) );;

##  doc/brdbattr.xml (107-118)
gap> DatabaseAttributeAdd( smallintenum1, rec(
>      identifier:= "primes",
>      type:= "values",
>      name:= "IsPrimeInt",
>    ) );
gap> DatabaseAttributeAdd( smallintenum1, rec(
>      identifier:= "prime powers",
>      type:= "values",
>      name:= "IsPrimePowerInt",
>    ) );

##  doc/brdbattr.xml (122-128)
gap> DatabaseAttributeAdd( smallintenum1, rec(
>      identifier:= "factors",
>      type:= "values",
>      name:= "Factors",
>    ) );

##  doc/brdbattr.xml (136-142)
gap> DatabaseAttributeAdd( smallintenum1, rec(
>      identifier:= "residue mod 11",
>      type:= "values",
>      create:= function( attr, id ) return id mod 11; end,
>    ) );

##  doc/brdbattr.xml (152-167)
gap> factorialdata:= function( n )
>      local result, i, f;
>      result:= [];  i:= 1;  f:= 1;;
>      while f <= n do
>        Add( result, [ f, i ] );  i:= i + 1;  f:= f * i;
>      od;
>      return result;
>    end;;
gap> DatabaseAttributeAdd( smallintenum1, rec(
>      identifier:= "inverse factorial",
>      type:= "pairs",
>      data:= rec( automatic:= factorialdata( n ), nonautomatic:= [] ),
>      isSorted:= true,
>    ) );

##  doc/brdbattr.xml (179-184)
gap> t1:= BrowseTableFromDatabaseIdEnumerator( smallintenum1,
>           [ "self" ],
>           [ "primes", "prime powers", "factors", "residue mod 11",
>             "inverse factorial" ] );;

##  doc/brdbattr.xml (188-203)
gap> nop:= [ 14, 14, 14, 14, 14, 14 ];;  # ``do nothing''
gap> sample_session:= Concatenation(
>         # categorize by the first column, expand categories, wait, reset
>         nop, "scsc", nop, "X", nop, "!",
>         # sort the residue column, wait, reset
>         "scrrrso", nop, "!",
>         # categorize by the inverse factorial column
>         "rscsrdx", nop, "!",
>         # and quit the application
>         "qQ" );;
gap> BrowseData.SetReplay( sample_session );
gap> NCurses.BrowseGeneric( t1 );
gap> BrowseData.SetReplay( false );
gap> Unbind( t1.dynamic.replay );

##  doc/brdbattr.xml (252-316)
gap> smallintenum2:= DatabaseIdEnumerator( rec(
>      identifiers:= [ 1 .. n ],
>      entry:= function( dbidenum, id ) return id; end,
>      viewLabel:= "",
>    ) );;
gap> DatabaseAttributeAdd( smallintenum2, rec(
>      identifier:= "primes",
>      type:= "values",
>      name:= "IsPrimeInt",
>      viewLabel:= "prime?",
>      viewValue:= value -> BrowseData.ReplacedEntry( value,
>          [ true, false ], [ "+", "-" ] ),
>      sortParameters:= [ "add counter on categorizing", "yes" ],
>      align:= "c",
>      categoryValue:= value -> BrowseData.ReplacedEntry( value,
>          [ true, false ], [ "prime", "nonprime" ] ),
>    ) );
gap> DatabaseAttributeAdd( smallintenum2, rec(
>      identifier:= "prime powers",
>      type:= "values",
>      name:= "IsPrimePowerInt",
>      viewLabel:= "prime power?",
>      viewValue:= value -> BrowseData.ReplacedEntry( value,
>          [ true, false ], [ "+", "-" ] ),
>      sortParameters:= [ "add counter on categorizing", "yes" ],
>      align:= "c",
>      categoryValue:= value -> BrowseData.ReplacedEntry( value,
>          [ true, false ], [ "prime power", "not prime power" ] ),
>    ) );
gap> DatabaseAttributeAdd( smallintenum2, rec(
>      identifier:= "factors",
>      type:= "values",
>      name:= "Factors",
>      viewLabel:= "factors",
>      viewValue:= value -> JoinStringsWithSeparator( List( value, String ),
>                                                     " * "),
>      widthCol:= 10,
>    ) );
gap> DatabaseAttributeAdd( smallintenum2, rec(
>      identifier:= "residue mod 11",
>      type:= "values",
>      create:= function( attr, id ) return id mod 11; end,
>      viewSort:= BrowseData.SortAsIntegers,
>      categoryValue:= res -> Concatenation( String( res ), " mod 11" ),
>    ) );
gap> DatabaseAttributeAdd( smallintenum2, rec(
>      identifier:= "inverse factorial",
>      type:= "pairs",
>      data:= rec( automatic:= factorialdata( n ), nonautomatic:= [] ),
>      isSorted:= true,
>      categoryValue:= function( k )
>        if k = "" then
>          return "(no factorial)";
>        else
>          return Concatenation( String( k ), "!" );
>        fi;
>      end,
>    ) );
gap> t2:= BrowseTableFromDatabaseIdEnumerator( smallintenum2,
>           [ "self" ],
>           [ "primes", "prime powers", "factors", "residue mod 11",
>             "inverse factorial" ],
>           t -> BrowseData.HeaderWithRowCounter( t, "Small integers", n ) );;

##  doc/brdbattr.xml (320-325)
gap> BrowseData.SetReplay( sample_session );
gap> NCurses.BrowseGeneric( t2 );
gap> BrowseData.SetReplay( false );
gap> Unbind( t2.dynamic.replay );

##  doc/brdbattr.xml (348-386)
gap> DatabaseAttributeAdd( smallintenum2, rec(
>      identifier:= "primes & prime powers",
>      type:= "values",
>      create:= function( attr, id )
>        if   IsPrimeInt( id ) then
>          return 2;
>        elif IsPrimePowerInt( id ) then
>          return 1;
>        else
>          return 0;
>        fi;
>      end,
>      viewLabel:= [ NCurses.attrs.BOLD + NCurses.ColorAttr( "red", -1 ),
>                    "prime", NCurses.attrs.NORMAL, " power?" ],
>      viewValue:= value -> BrowseData.ReplacedEntry( value,
>          [ 0, 1, 2 ], [ "-", "+",
>                         [ NCurses.attrs.BOLD + NCurses.ColorAttr( "red", -1 ),
>                           true, "+",
>                           NCurses.ColorAttr( "red", -1 ), false ] ] ),
>      sortParameters:= [ "add counter on categorizing", "yes" ],
>      align:= "c",
>      categoryValue:= value -> BrowseData.ReplacedEntry( value,
>          [ 0, 1, 2 ],
>          [ "not prime power", "prime power, not prime", "prime" ] ),
>    ) );
gap> t3:= BrowseTableFromDatabaseIdEnumerator( smallintenum2,
>           [ "self" ],
>           [ "primes & prime powers", "residue mod 11",
>             "inverse factorial" ],
>           t -> BrowseData.HeaderWithRowCounter( t, "Small integers", n ) );;
gap> sample_session2:= Concatenation(
>         # categorize by the first column, expand categories, wait, reset
>         nop, "scsc", nop, "X", nop, "!", "Q" );;
gap> BrowseData.SetReplay( sample_session2 );
gap> NCurses.BrowseGeneric( t3 );
gap> BrowseData.SetReplay( false );
gap> Unbind( t3.dynamic.replay );

##  doc/brdbattr.xml (400-482)
gap> smallintenum3:= DatabaseIdEnumerator( rec(
>     identifiers:= [ 1 .. n ],
>     entry:= function( dbidenum, id ) return id; end,
>     viewLabel:= "",
>     version:= n,
>     update:= function( dbidenum )
>         dbidenum.identifiers:= [ 1 .. n ];
>         dbidenum.version:= n;
>         return true;
>       end,
>     ) );;
gap> updateByUnbindData:= function( attr )
>      Unbind( attr.data );
>      return true;
>    end;;
gap> DatabaseAttributeAdd( smallintenum3, rec(
>     identifier:= "primes",
>     type:= "values",
>     name:= "IsPrimeInt",
>     viewLabel:= "prime?",
>     viewValue:= value -> BrowseData.ReplacedEntry( value,
>         [ true, false ], [ "+", "-" ] ),
>     sortParameters:= [ "add counter on categorizing", "yes" ],
>     align:= "c",
>     categoryValue:= value -> BrowseData.ReplacedEntry( value,
>         [ true, false ], [ "prime", "nonprime" ] ),
>     version:= n,
>     update:= updateByUnbindData,
>     ) );
gap> DatabaseAttributeAdd( smallintenum3, rec(
>     identifier:= "prime powers",
>     type:= "values",
>     name:= "IsPrimePowerInt",
>     viewLabel:= "prime power?",
>     viewValue:= value -> BrowseData.ReplacedEntry( value,
>         [ true, false ], [ "+", "-" ] ),
>     sortParameters:= [ "add counter on categorizing", "yes" ],
>     align:= "c",
>     categoryValue:= value -> BrowseData.ReplacedEntry( value,
>         [ true, false ], [ "prime power", "not prime power" ] ),
>     version:= n,
>     update:= updateByUnbindData,
>     ) );
gap> DatabaseAttributeAdd( smallintenum3, rec(
>     identifier:= "factors",
>     type:= "values",
>     name:= "Factors",
>     viewLabel:= "factors",
>     viewValue:= value -> JoinStringsWithSeparator( List( value, String ),
>                                                    " * "),
>     widthCol:= 10,
>     version:= n,
>     update:= updateByUnbindData,
>     ) );
gap> DatabaseAttributeAdd( smallintenum3, rec(
>     identifier:= "residue mod 11",
>     type:= "values",
>     create:= function( attr, id ) return id mod 11; end,
>     viewSort:= BrowseData.SortAsIntegers,
>     categoryValue:= res -> Concatenation( String( res ), " mod 11" ),
>     version:= n,
>     update:= updateByUnbindData,
>     ) );
gap> DatabaseAttributeAdd( smallintenum3, rec(
>     identifier:= "inverse factorial",
>     type:= "pairs",
>     data:= rec( automatic:= factorialdata( n ), nonautomatic:= [] ),
>     isSorted:= true,
>     categoryValue:= function( k )
>       if k = "" then
>         return "(no factorial)";
>       else
>         return Concatenation( String( k ), "!" );
>       fi;
>     end,
>     version:= n,
>     update:= function( attr )
>         attr.data.automatic:= factorialdata( n );
>         return true;
>       end,
>     ) );

##  doc/brdbattr.xml (488-500)
gap> n:= 200;;
gap> DatabaseIdEnumeratorUpdate( smallintenum3 );
true
gap> t4:= BrowseTableFromDatabaseIdEnumerator( smallintenum3,
>   [ "self" ], [ "primes", "prime powers", "factors", "residue mod 11",
>     "inverse factorial" ],
>   t -> BrowseData.HeaderWithRowCounter( t, "Small integers", n ) );;
gap> BrowseData.SetReplay( sample_session );
gap> NCurses.BrowseGeneric( t4 );
gap> BrowseData.SetReplay( false );
gap> Unbind( t4.dynamic.replay );

##  doc/../app/transbrowse.g (446-455)
gap> c:= [ NCurses.keys.ENTER ];;
gap> BrowseData.SetReplay( Concatenation(
>        "scrrrr/5", c,     # search for transitivity 5,
>        "nn", c,           # go to the third occurrence, click on it,
>        "Q" ) );;          # and quit the browse table
gap> BrowseTransitiveGroupsInfo();
[ M(12) ]
gap> BrowseData.SetReplay( false );

##  doc/../app/transbrowse.g (563-568)
gap> TransitiveGroupsData.AllTransitiveGroups(
>      NrMovedPoints, [ 5 .. 28 ],
>      IsSimpleGroup, true, IsAbelian, true );
[ C(5) = 5, C(7) = 7, C(11)=11, C(13)=13, C(17)=17, C(19)=19, C(23) ]

##  doc/../app/transdbattr.g (36-47)
gap> n:= [ 14, 14, 14 ];;  # ``do nothing'' input (means timeout)
gap> BrowseData.SetReplay( Concatenation(
>        "scrrrsc", n, n,        # categorize by solvability info
>        "!", n,                 # reset
>        "scrrrrsc", n, n,       # categorize by abelianity info
>        "Q" ) );;               # quit the browse table
gap> BrowseTransitiveGroupsInfo( rec( choice:= [ "degree", "size",
>      "names", "IsSolvableGroup", "IsAbelian", "IsPerfectGroup",
>      "IsSimpleGroup" ] ) );;
gap> BrowseData.SetReplay( false );

##  doc/../app/transdbattr.g (57-67)
gap> TransitiveGroupsData.MinimalDegree;
2
gap> attrs:= TransitiveGroupsData.IdEnumerator.attributes;;
gap> oldlen:= SizeScreen();;  SizeScreen( [ 60 ] );;
gap> HexStringBlistEncode( attrs.IsAbelian.data );
"D88400040Es0503s0480s040406s252010s0720s0C3EsF30803s7A040\
5s8B20s1302s0740E0sFFsFFsFFsFFsFFsFFsFFsFFsFFsFFsFFsFFs40C\
0s1910s0B1AsFFs2B18sE74040sFFsFF"
gap> SizeScreen( oldlen );;

##  doc/../app/tmdbattr.g (51-76)
gap> c:= [ NCurses.keys.ENTER ];;
gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
gap> BrowseData.SetReplay( Concatenation(
>        "scrrsc",   # categorize the list by source tables of fusions,
>        "srdd",     # choose a source table,
>        "x",        # expand the list of targets of fusions
>        n,
>        "!",        # revert the categorization
>        "q",        # leave the mode in which a row is selected
>        "scrrrrsc", # categorize the list by filenames
>        "X",        # expand all categories
>        n,
>        "!",        # revert the categorization
>        "scso",     # sort the list by group order
>        n,
>        "!q",       # revert the sorting and selection
>        "?",        # open the help window
>        n,
>        "Q",        # close the help window
>        "/A5", c,   # search for the first occurrence of "A5"
>        n,
>        "Q" ) );;   # and quit the browse table
gap> BrowseTomLibInfo();
gap> BrowseData.SetReplay( false );

##
gap> BrowseData.defaults.dynamic.replayDefaults.replayInterval:= oldinterval;;

##
gap> STOP_TEST( "test.tst", 10000000 );
gap> SizeScreen( save );;

#############################################################################
##
#E
