#############################################################################
##
#W  conwaypols.g          GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseConwayPolynomials()
##
BindGlobal( "BrowseConwayPolynomials", function()
    local stringpol, d, len, maxd, mat, p, pstr, dwidth, winwidth, polwidth,
          source, footerlength, name, sel_action, table, result;

    stringpol:= function( coeffs )
      local str, i;

      str:= "";
      for i in Reversed( [ 2 .. Length( coeffs ) ] ) do
        if coeffs[i] = 1 then
          Append( str, "X^" );
          Append( str, String( i-1 ) );
          Append( str, " + " );
        elif coeffs[i] <> 0 then
          Append( str, String( coeffs[i] ) );
          Append( str, " X^" );
          Append( str, String( i ) );
          Append( str, " + " );
        fi;
      od;
      Append( str, String( coeffs[1] ) );
      return str;
    end;

    for d in [ "1", "2", "3" ] do
      if CONWAYPOLYNOMIALSINFO.( Concatenation( "conwdat", d ) ) = false then
        ReadLib( Concatenation( "conwdat", d, ".g" ) );
      fi;
    od;

    len:= LogInt( Length( CONWAYPOLDATA ), 10 ) + 1;
    maxd:= 1;
    mat:= [];
    for p in [ 1 .. Length( CONWAYPOLDATA ) ] do
      pstr:= String( p );
      if IsBound( CONWAYPOLDATA[p] ) then
        for d in [ 1 .. Length( CONWAYPOLDATA[p] ) ] do
          if IsBound( CONWAYPOLDATA[p][d] ) then
            # Store only the first two columns now,
            # compute the polynomials on demand.
            Add( mat, [ pstr, String( d ) ] );
          fi;
        od;
        maxd:= Maximum( maxd, d );
      fi;
    od;
    dwidth:= LogInt( maxd, 10 ) + 1;
    winwidth:= NCurses.getmaxyx( 0 )[2];
    polwidth:= winwidth - len - dwidth - 19;

    # Formatted source info.
    source:= rec();
    footerlength:= 0;
    for name in RecNames( CONWAYPOLYNOMIALSINFO ) do
      if IsString( CONWAYPOLYNOMIALSINFO.( name ) ) then
        source.( name ):= SplitString( FormatParagraph(
            NormalizedWhitespace( CONWAYPOLYNOMIALSINFO.( name ) ),
            winwidth, "left" ), "\n" );
        footerlength:= Maximum( footerlength, Length( source.( name ) ) );
      fi;
    od;
    source.( "nothing" ):= "";

    sel_action:= rec(
      helplines:= [ "add the Conway polynomial to the result list" ],
      action:= function( t )
        local i;

        if t.dynamic.selectedEntry <> [ 0, 0 ] then
          i:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
          Add( t.dynamic.Return,
               List( t.work.main[i]{ [ 1, 2 ] }, EvalString ) );
        fi;
      end );

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "ct",
        header:= t -> BrowseData.HeaderWithRowCounter( t,
                        "Conway Polynomials in GAP",
                        Length( mat ) ),
        footer:= rec(
          # Show the long form of the source.
          select_entry:= function( t )
            local entry;

            entry:= "nothing";
            if   t.dynamic.selectedEntry = [ 0, 0 ] then
              entry:= First( t.dynamic.categories[2],
                x -> [ x.pos, x.level ] = t.dynamic.selectedCategory ).value;
            elif t.dynamic.indexCol[ t.dynamic.selectedEntry[2] ] = 8 then
              entry:= t.work.Main( t,
                  t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2,
                  t.dynamic.indexCol[ t.dynamic.selectedEntry[2] ] / 2
                  ).rows[1];
            fi;
            if not IsBound( source.( entry ) ) then
              entry:= "nothing";
            fi;
            return source.( entry );
          end ),
        footerLength:= rec(
          select_entry:= footerlength,
          ),
        CategoryValues:= function( t, i, j )
          if   j = 2 then
            return [ Concatenation( "p = ", t.work.main[ i/2 ][1] ) ];
          elif j = 4 then
            return [ Concatenation( "d = ", t.work.main[ i/2 ][2] ) ];
          elif j = 6 then
            return t.work.Main( t, i/2, j/2 );
          elif j = 8 then
            return t.work.Main( t, i/2, j/2 ).rows;
          else
            Error( "this should not happen" );
          fi;
        end,

        # Avoid computing strings for all entries in advance.
        main:= mat,
        n:= 4,
        Main:= function( t, i, j )
          local p, d;

          p:= EvalString( t.work.main[i][1] );
          d:= EvalString( t.work.main[i][2] );
          if j = 3 then
            # Avoid creating the finite field and the polynomial itself,
            # just evaluate the stored data.
            return SplitString( FormatParagraph(
              stringpol( ConwayPol( p, d ) ), polwidth, "left" ), "\n" );
          elif j = 4 then
            return rec( rows:= [ CONWAYPOLDATA[p][d][2] ], align:= "l" );
          else
            Error( "this should not happen" );
          fi;
        end,

        labelsRow:= [],
        labelsCol:= [ [ rec( rows:= [ "p" ], align:= "r" ),
                        rec( rows:= [ "d" ], align:= "r" ),
                        rec( rows:= [ "polynomial" ], align:= "r" ),
                        rec( rows:= [ "source" ], align:= "l" ),
                      ] ],
        sepLabelsCol:= "=",
        sepRow:= "-",
        sepCol:= [ "| ", " | ", " | ", " | ", " |" ],

        widthCol:= [ , len,, dwidth,, polwidth ],
        SpecialGrid:= BrowseData.SpecialGridLineDraw,
        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
        ),
      ),
      dynamic:= rec(
        sortFunctionsForColumns:= ListWithIdenticalEntries( 2,
            BrowseData.CompareLenLex ),
        Return:= [],
      ),
    );

    # Show the browse table.
    result:= DuplicateFreeList( NCurses.BrowseGeneric( table ) );

    # Construct the return value.
    return List( result, pair -> ConwayPolynomial( pair[1], pair[2] ) );
    end );


#############################################################################
##
##  Add the Browse application to the list shown by `BrowseGapData'.
##
BrowseGapDataAdd( "Conway Polynomials", BrowseConwayPolynomials, true, "\
the list of precomputed Conway polynomials, \
shown in a browse table whose columns contain the characteristic, \
the degree, the polynomial itself, \
and a short form of the source of the data \
(a long form is shown when the cell with the short form is selected)" );


#############################################################################
##
#E

