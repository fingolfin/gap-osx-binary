#############################################################################
##
#W  methods.g             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseGapMethods( [<operations>] )
##
##  Categorize by operations and number of arguments with input 'scrscscsc'.
##  Categorize by filenames with input 'scrrrrrrsc'.
##  (Reset the table with input '!'.)
##
BindGlobal( "BrowseGapMethods", function( arg )
    local opnamewidth, argumentswidth,
          commentwidth, filenamewidth, operations, pkgnames, pkgpaths,
          matrix, methodlist, cats, operation, opname, i, methods, j,
          argnames, comment, func, filename, pkg, path, len, sel_action, t;

    opnamewidth:= 20;
    argumentswidth:= 25;
    commentwidth:= 30;
    filenamewidth:= 30;

    # Get the list of operations, sorted alphabetically.
    if Length( arg ) = 0 then
      operations:= OPERATIONS{ [ 1, 3 .. Length( OPERATIONS ) - 1 ] };;
    elif Length( arg ) = 1 and IsList( arg[1] ) then
      operations:= Filtered( arg[1],
         op -> IsFunction( op ) and ForAny( OPERATIONS,
                                      opr -> IsIdenticalObj( op, opr ) ) );
    else
      Error( "usage: BrowseGapMethods( [<operations>] )" );
    fi;
    SortParallel( List( operations, NameFunction ), operations );

    # (Similar code is in `app/profile.g'.)
    pkgnames:= ShallowCopy( RecNames( GAPInfo.PackagesLoaded ) );
    pkgpaths:= List( pkgnames, nam -> GAPInfo.PackagesLoaded.( nam )[1] );
    pkgnames:= List( pkgnames, nam -> GAPInfo.PackagesLoaded.( nam )[3] );
    Append( pkgnames, List( GAPInfo.RootPaths, x -> "GAP" ) );
    Append( pkgpaths, GAPInfo.RootPaths );
    Add( pkgnames, "GAP" );
    Add( pkgpaths, "GAPROOT/" ); # used for compiled functions in lib

    # Fill the matrix with the information about the methods,
    # ordered by their rank.
    # (Omit default methods for setter and getter operations.)
    matrix:= [];
    methodlist:= [];
    cats:= [];
    for operation in operations do
      opname:= NameFunction( operation );
      for i in [ 0 .. GAPInfo.MaxNrArgsMethod ] do
        methods:= METHODS_OPERATION( operation, i );
        for j in [ 1, 5+i .. Length( methods ) - 3-i ] do
          argnames:= NamesLocalVariablesFunction( methods[ j + i + 1 ] );
          if argnames = fail then
            argnames:= [ "..." ];
          elif i <= Length( argnames ) then
            argnames:= argnames{ [ 1 .. i ] };
          fi;
          comment:= methods[ j + i + 3 ];
          if not ':' in comment then
            comment:= "";
          else
            comment:= comment{ [ Position( comment, ':' ) + 2
                                 .. Length( comment ) ] };
          fi;
          if    Length( opname ) < 7
             or i <> 2
             or not opname{ [ 1 .. 7 ] } in [ "Getter(", "Setter(" ]
             or not comment in [ "system setter",
                                 "default method, does nothing" ] then
            func:= methods[ j + i + 1 ];
            Add( methodlist, func );

            # Compute package (if applicable) and filename.
            filename:= FilenameFunc( func );
            if filename = fail then
              filename:= "(no filename stored)";
              if IsOperation( func ) then
                pkg:= "(oprt.)";
              else
                pkg:= "";
              fi;
            else
              pkg:= PositionProperty( pkgpaths,
                        path -> Length( path ) < Length( filename )
                        and filename{ [ 1 .. Length( path ) ] } = path );
              if pkg <> fail then
                pkg:= pkgnames[ pkg ];
              else
                pkg:= "";
              fi;
              for path in GAPInfo.RootPaths do
                len:= Length( path );
                if len < Length( filename )
                   and filename{ [ 1 .. len ] } = path then
                  filename:= filename{ [ len + 1 .. Length( filename ) ] };
                  break;
                fi;
              od;
            fi;

            Add( matrix, [
              # operation name
              rec( align:= "tl", rows:= SplitString(
                BrowseData.ReallyFormatParagraph( opname, opnamewidth,
                                                  "left" ), "\n" ) ),
              # number of arguments
              rec( align:= "tr", rows:= [ String( i ) ] ),
              # arguments
              rec( align:= "tl", rows:= SplitString(
                BrowseData.ReallyFormatParagraph( Concatenation( "( ",
                  JoinStringsWithSeparator( argnames, ", " ),
                  " )" ), argumentswidth, "left" ), "\n" ) ),
              # comment
              rec( align:= "tl", rows:= SplitString(
                BrowseData.ReallyFormatParagraph( comment, commentwidth,
                  "left" ), "\n" ) ),
              # rank
              rec( align:= "t", rows:= [ String( methods[ j + i + 2 ] ) ] ),
              # source package (if applicable)
              rec( align:= "tl", rows:= [ pkg ] ),
              # source file (if applicable)
              rec( align:= "tl", rows:= SplitString(
                BrowseData.ReallyFormatParagraph( filename, filenamewidth,
                                                  "left" ), "\n" ) ),
              ] );
          fi;
        od;
      od;
    od;

    # Implement the ``click'' action.
    # (Essentially the same function is contained in `app/profile.g'
    # and `app/pkgvar.g'.)
    sel_action:= rec(
      helplines:= [ "show the chosen method in a pager" ],
      action:= function( t )
        local pos, func, file, lines, stream;

        if t.dynamic.selectedEntry <> [ 0, 0 ] then
          pos:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
          func:= methodlist[ pos ];
          file:= FilenameFunc( func );
          if file = fail or file = "*stdin*"
                         or not IsReadableFile( file ) then
            # Show the code in a pager.
            lines:= "";
            stream:= OutputTextString( lines, true );
            PrintTo( stream, func );
            CloseStream( stream );
          else
            # Show the file in a pager.
            lines:= rec( lines:= StringFile( file ),
                         start:= StartlineFunc( func ) );
          fi;
          if BrowseData.IsDoneReplay( t.dynamic.replay ) then
            NCurses.Pager( lines );
            NCurses.update_panels();
            NCurses.doupdate();
            NCurses.curs_set( 0 );
          fi;
        fi;
        return t.dynamic.changed;
      end );

    # Construct the browse table.
    t:= rec(
      work:= rec(
        align:= "tl",
        header:= t -> BrowseData.HeaderWithRowCounter( t, "GAP Methods",
                          Length( matrix ) ),
        main:= matrix,
        labelsCol:= [ [ rec( rows:= [ "Operation" ], align:= "l" ),
                        rec( rows:= [ "#" ], align:= "r" ),
                        rec( rows:= [ "Arguments" ], align:= "l" ),
                        rec( rows:= [ "Comment" ], align:= "l" ),
                        rec( rows:= [ "Rank" ], align:= "r" ),
                        rec( rows:= [ "Package" ], align:= "l" ),
                        rec( rows:= [ "Filename" ], align:= "l" ),
        ] ],
        sepLabelsCol:= "=",
        sepRow:= "-",
        sepCol:= [ "| ", " | ", " | ", " | ", " | ", " | ", " |" ],
        widthCol:= [ , opnamewidth,,,, argumentswidth,, commentwidth,,,,,,
                     filenamewidth ],
        SpecialGrid:= BrowseData.SpecialGridLineDraw,

        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
        ),

        startCollapsedCategory:= [ [ NCurses.attrs.BOLD, true, "> " ],
                                   [ NCurses.attrs.BOLD, true, "  > " ],
                                 ],
        startExpandedCategory:= [ [ NCurses.attrs.BOLD, true, "* " ],
                                  [ NCurses.attrs.BOLD, true, "  * " ],
                                 ],
      ),
      dynamic:= rec(
        sortFunctionsForColumns:= [ ,, BrowseData.CompareLenLex ],
      ),
    );

    # Customize the sort parameters.
    BrowseData.SetSortParameters( t, "column", 1,
        [ "add counter on categorizing", "yes" ] );
    BrowseData.SetSortParameters( t, "column", 2,
        [ "add counter on categorizing", "yes" ] );

    # Show the browse table.
    NCurses.BrowseGeneric( t );
end );


#############################################################################
##
##  Add the Browse application to the list shown by `BrowseGapData'.
##
BrowseGapDataAdd( "GAP Operations and Methods", BrowseGapMethods, false, "\
the operations available in the current GAP session, \
together with their methods, shown in a browse table; \
the columns of the table contain the operation names, \
the number and the names of the arguments, the comments, the ranks, \
the package names, and the filenames (if applicable) of the methods; \
``click'' shows the code of the method; \
one can categorize the table by operations and argument number \
by entering scrscscsc \
" );


#############################################################################
##
#E

