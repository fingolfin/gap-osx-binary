#############################################################################
##
#W  profile.g             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2010,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseProfile( [<functions>][,][<mincount>, <mintime>] )
##
##  <#GAPDoc Label="BrowseProfile_section">
##  <Section Label="sec:profiledisp">
##  <Heading>Profiling &GAP; functions&ndash;a Variant</Heading>
##
##  A &Browse; adapted way to evaluate profiling results is
##  to show the overview that is printed by the &GAP; function
##  <Ref Func="DisplayProfile" BookName="ref"/> in a &Browse; table,
##  which allows one to sort the profiled functions according to
##  the numbers of calls, the time spent, etc.,
##  and to search for certain functions one is interested in.
##
##  <ManSection>
##  <Func Name="BrowseProfile" Arg="[functions][,][mincount, mintime]"/>
##
##  <Description>
##  The arguments and their meaning are the same as for the function
##  <Ref Func="DisplayProfile" BookName="ref"/>,
##  in the sense that the lines printed by that function correspond to the
##  rows of the list that is shown by <Ref Func="BrowseProfile"/>.
##  Initially, the table is sorted in the same way as the list shown by
##  <Ref Func="BrowseProfile"/>; sorting the table by any of the first five
##  columns will yield a non-increasing order of the rows.
##  <P/>
##  The threshold values <A>mincount</A> and <A>mintime</A> can be changed
##  in visual mode via the user input <B>e</B>.
##  If mouse events are enabled (see <Ref Func="NCurses.UseMouse"/>) then
##  one can also use a mouse click on the current parameter value shown
##  in the table header
##  in order to enter the mode for changing the parameters.
##  <P/>
##  When a row or an entry in a row is selected,
##  <Q>click</Q> shows the code of the corresponding function in a pager
##  (see <Ref Func="NCurses.Pager"/>) whenever this is possible, as follows.
##  If the function was read from a file then this file is opened,
##  if the function was entered interactively then the code of the function
##  is shown in the format produced by <Ref Func="Print" BookName="ref"/>;
##  other functions (for example &GAP; kernel functions) cannot be shown,
##  one gets an alert message (see <Ref Func="NCurses.Alert"/>) in such a
##  case.
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  <Example><![CDATA[
##  gap> n:= [ 14, 14, 14, 14, 14 ];;  # ``do nothing''
##  gap> ProfileOperationsAndMethods( true );    # collect some data
##  gap> ConjugacyClasses( PrimitiveGroup( 24, 1 ) );;
##  gap> ProfileOperationsAndMethods( false );
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "scso",                                 # sort by column 1,
##  >        n,
##  >        "rso",                                  # sort by column 2,
##  >        n,
##  >        "rso",                                  # sort by column 3,
##  >        n,
##  >        "q",                                    # deselect the column,
##  >        "/Centralizer", [ NCurses.keys.ENTER ], # search for a function,
##  >        n, "Q" ) );                             # and quit
##  gap> BrowseProfile();
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  <P/>
##  <E>Implementation remarks</E>:
##  The browse table has a dynamic header,
##  which shows the current values of <A>mincount</A> and <A>mintime</A>,
##  and a dynamic footer, which shows the sums of counts and timings for the
##  rows in the table (label <C>TOTAL</C>) and if applicable the sums for the
##  profiled functions not shown in the table (label <C>OTHER</C>).
##  There are no row labels, and the obvious column labels.
##  There is no return value.
##  <P/>
##  The standard modes in <Ref Var="BrowseData"/> (except the <C>help</C>
##  mode) have been modified
##  by adding a new action for changing the threshold parameters
##  <A>mincount</A> and <A>mintime</A> (user input <B>e</B>).
##  The way how this in implemented made it necessary to change the standard
##  <Q>reset</Q> action (user input <B>!</B>) of the table;
##  note that resetting (a sorting or filtering of) the table must not
##  make those rows visible that shall be hidden because of the
##  threshold parameters.
##  <P/>
##  The code can be found in the file <F>app/profile.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseProfile", function( arg )
    local i, funcs, mincount, mintime, info, reject, table, denom, widths,
          otim, osto, entry, rej, row, collabels, packagetotals, sel_action,
          recompute_hide_conditions, modes, editfields, myDealWithMouseClick,
          replactions, newactions, mode;

    # Stop profiling, in order to keep the computations in this function
    # away from the profiling data.
    for i in PROFILED_FUNCTIONS do
      UNPROFILE_FUNC( i );
    od;

    # Get the arguments.
    funcs:= "all";
    mincount:= GAPInfo.ProfileThreshold[1];
    mintime:= GAPInfo.ProfileThreshold[2];
    if   Length( arg ) = 0 then
      # Keep these defaults.
    elif Length( arg ) = 1 and IsList( arg[1] ) then
      funcs:= arg[1];
    elif Length( arg ) = 2 and IsInt( arg[1] ) and IsInt( arg[2] ) then
      mincount:= arg[1];
      mintime:= arg[2];
    elif Length( arg ) = 3 and IsList( arg[1] ) and IsInt( arg[2] )
                           and IsInt( arg[3] ) then
      funcs:= arg[1];
      mincount:= arg[2];
      mintime:= arg[3];
    elif ForAll( arg, IsFunction ) then
      funcs:= arg;
    else
      # Start profiling again.
      for i in PROFILED_FUNCTIONS do
        PROFILE_FUNC( i );
      od;
      Error( "usage: BrowseProfile( ",
             "[<functions>][,][<mincount>, <mintime>] )" );
    fi;

    # Compute the table contents.
    # We create a row for each profiled function, and hide those rows that
    # shall not be shown because of the threshold parameters.
    # Note that the parameters can be changed interactively,
    # and we want to keep the same table.
    # For efficiency reasons, functions with zero count and zero time
    # are omitted except if `mincount' or `mintime' are zero,
    # and we forbid setting the parameters to zero if a nonzero parameter
    # was given as an argument.
    if mincount < 0 then
      mincount:= 0;
    fi;
    if mintime < 0 then
      mintime:= 0;
    fi;
    if mincount = 0 or mintime = 0 then
      info:= ProfileInfo( funcs, 0, 0 );
    else
      info:= ProfileInfo( funcs, 1, 1 );
    fi;
    reject:= [ false ];
    table:= [];
    denom:= info.denom;
    widths:= info.widths;
    otim:= 0;
    osto:= 0;
    for entry in info.prof do
      rej:= entry[1] < mincount and entry[2] + entry[3] < mintime;
      row:= [];
      for i in [ 1 .. Length( denom ) ] do
        if denom[i] = 1 then
          row[i]:= String( entry[i] );
        else
          row[i]:= String( QuoInt( entry[i], denom[i] ) );
        fi;
        if widths[i] < 0 then
          row[i]:= rec( rows:= [ row[i] ], align:= "l" );
        fi;
      od;
      Add( table, row );
      Append( reject, [ rej, rej ] );
      if rej then
        otim:= otim + entry[2];
        osto:= osto + entry[4];
      fi;
    od;
    if ForAll( [ 2 .. Length( reject ) ], i -> reject[i] ) then
      NCurses.Alert( [ "There are currently no functions",
                       "to be profiled" ], 2000 );
      return;
    fi;

    # Get the column labels.
    # We use the widths only for the alignment information.
    collabels:= [];
    for i in [ 1 .. Length( info.labelsCol) ] do
      if info.widths[i] < 0 then
        Add( collabels, rec( rows:= [ info.labelsCol[i] ], align:= "l" ) );
      else
        Add( collabels, rec( rows:= [ info.labelsCol[i] ], align:= "r" ) );
      fi;
    od;

    # Collect the total time and storage for each package involved.
    # (This information is used when the table is categorized by packages.)
    packagetotals:= function( t, prof )
      local mincount, mintime, n, pkgpos, cntpos, timepos, chldpos, storpos,
            pkgnames, sumtime, sumstor, i, pkg, pos;

      if not IsBound( t.dynamic.packagetotals ) then
        mincount:= t.dynamic.mincount;
        mintime:= t.dynamic.mintime;
        n:= prof.labelsCol;
        pkgpos:= Position( n, "package" );
        cntpos:= Position( n, "  count" );
        timepos:= Position( n, "self/ms" );
        chldpos:= Position( n, "chld/ms" );
        storpos:= Position( n, "stor/kb" );
        pkgnames:= [ "GAP" ];
        sumtime:= [ 0 ];
        sumstor:= [ 0 ];
        for i in prof.prof do
          if mincount <= i[ cntpos ]
             or mintime <= i[ timepos ] + i[ chldpos ] then
            pkg:= i[ pkgpos ];
            pos:= Position( pkgnames, pkg );
            if pos = fail then
              Add( pkgnames, pkg );
              pos:= Length( pkgnames );
              sumtime[ pos ]:= 0;
              sumstor[ pos ]:= 0;
            fi;
            sumtime[ pos ]:= sumtime[ pos ] + i[ timepos ];
            sumstor[ pos ]:= sumstor[ pos ] + i[ storpos ];
          fi;
        od;
        pos:= Length( t.work.startCollapsedCategory[1][3] );
        t.dynamic.packagetotals:= [ pkgnames,
            List( sumtime, x -> QuoInt( x, prof.denom[ timepos ] ) ),
            List( sumstor, x -> QuoInt( x, prof.denom[ storpos ] ) ),
            Sum( t.work.widthCol{ [ 1 .. 2 * timepos ] } ) - pos,
            Sum( t.work.widthCol{ [ 1 .. 2 * storpos ] } ) - pos ];
      fi;

      return t.dynamic.packagetotals;
    end;

    # Implement the ``click'' action.
    # (Essentially the same function is contained in `app/methods.g'
    # and `app/pkgvar.g'.)
    sel_action:= rec(
      helplines:= [ "show the code of the chosen function" ],
      action:= function( t )
        local pos, func, file, lines, stream;

        if t.dynamic.selectedEntry <> [ 0, 0 ] then
          pos:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
          func:= info.funs[ pos ];
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

    # Construct the extended modes if necessary.
    if not IsBound( BrowseData.defaults.work.customizedModes.profile ) then
      # Create a shallow copy of each default mode for `Browse',
      # and adjust the actions.
      modes:= List( BrowseData.defaults.work.availableModes,
                    BrowseData.ShallowCopyMode );

      # If the threshold is changed interactively, we have to adjust the table.
      recompute_hide_conditions:= function( t )
        local reject, i, entry, rej, changed;

        reject:= [ false ];
        otim:= 0;
        osto:= 0;
        for i in [ 2, 4 .. Length( t.dynamic.indexRow ) - 1 ] do
          entry:= t.work.prof[ t.dynamic.indexRow[i] / 2 ];
          rej:= entry[1] < t.dynamic.mincount and
                entry[2] + entry[3] < t.dynamic.mintime;
          Append( reject, [ rej, rej ] );
          if rej then
            otim:= otim + entry[2];
            osto:= osto + entry[4];
          fi;
        od;
        changed:= reject <> t.dynamic.isRejectedRow or
                  t.dynamic.topleft <> [ 1, 1, 1, 1 ];
        if changed then
          t.dynamic.isRejectedRow:= reject;
          t.dynamic.topleft:= [ 1, 1, 1, 1 ];
          t.dynamic.otim:= otim;
          t.dynamic.osto:= osto;
        fi;

        return changed;
      end;

      editfields:= function( t, focus )
        local val, arecs, pos;

        val:= String( t.dynamic.mincount, 0 );
        arecs:= [ rec( prefix:= "count >= ",
                       default:= val,
                       suffix:= "",
                       ncols:= "fit",
                       begin:= [ 1, 20 ] ),
                  rec( prefix:= "self + chld >= ",
                       default:= String( t.dynamic.mintime, 0 ),
                       suffix:= " ms",
                       ncols:= "fit",
                       begin:= [ 1, 33 + Length( val ) ] ) ];
        if focus = "mincount" then
          arecs[1].focus:= true;
        else
          arecs[2].focus:= true;
        fi;
        NCurses.hide_panel( t.dynamic.statuspanel );
        val:= NCurses.EditFields( t.dynamic.window, arecs );
        NCurses.show_panel( t.dynamic.statuspanel );
        if val = fail then
          return t.dynamic.changed;
        fi;
        Perform( val, NormalizeWhitespace );
        val:= List( val, Int );
        # Do not set negative values, and forbid zero except if
        # zero had been entered as an argument.
        if val[1] <> fail and t.dynamic.mincount <> val[1]
           and ( 0 < val[1] or
                 ( 0 = val[1] and t.dynamic.mincount_orig = 0 ) ) then
          t.dynamic.changed:= true;
          t.dynamic.mincount:= val[1];
        fi;
        if val[2] <> fail and t.dynamic.mintime <> val[2]
           and ( 0 <= val[2] or
                 ( 0 = val[2] and t.dynamic.mintime_orig = 0 ) ) then
          t.dynamic.changed:= true;
          t.dynamic.mintime:= val[2];
        fi;
        if t.dynamic.changed = true then
          recompute_hide_conditions( t );
          Unbind( t.dynamic.packagetotals );
        fi;
        return t.dynamic.changed;
      end;

      myDealWithMouseClick:= function( t, data, flag )
        local pos, len;

        # If a parameter in the header is seleced then change it.
        pos:= BrowseData.PositionInBrowseTable( t, data );
        if pos[1] = "header" and pos[2][1] = 3 then
          len:= Length( String( t.dynamic.mincount ) );
          if pos[2][2] >= 22 and pos[2][2] < 31 + len then
            # focus on the first parameter
            return editfields( t, "mincount" );
          elif pos[2][2] >= 35 + len
               and pos[2][2] < 50 + len
                     + Length( String( t.dynamic.mintime ) ) then
            # focus on the second parameter
            return editfields( t, "mintime" );
          fi;
        fi;

        # Otherwise do the same as the standard action.
        return BrowseData.DealWithMouseClick( t, data, flag );
      end;

      # changed actions in any mode except help mode:
      # - reset the table
      # - mouse click on a parameter in the header
      replactions:= [
        [ [ "!" ], rec(
          helplines := [ "unsort the table, recompute hide conditions",
                         "according to the current thresholds,",
                         "if necessary scroll up to the first row" ],
          action := function( t )
            local changed;
            t.dynamic.changed:= BrowseData.actions.ResetTable.action( t );
            changed:= recompute_hide_conditions( t );
            t.dynamic.changed:= t.dynamic.changed or changed;
            return t.dynamic.changed;
            end ) ],
        [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
              "<Mouse1Down>" ],
            [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
              "<Mouse1Click>" ] ], rec(
          helplines:= Concatenation(
            [ "change the threshold parameter in the table header, or" ],
            BrowseData.actions.DealWithSingleMouseClick.helplines ),
          action := function( t, data )
            return myDealWithMouseClick( t, data, false );
          end ) ],
        [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_DOUBLE_CLICKED" ],
              "<Mouse1DoubleClick>" ] ], rec(
          helplines:= Concatenation(
            [ "change the threshold parameter in the table header, or" ],
            BrowseData.actions.DealWithDoubleMouseClick.helplines ),
          action := function( t, data )
            return myDealWithMouseClick( t, data, true );
          end ) ],
      ];

      # new actions in any mode except help mode:
      # - e: Change the value of the threshold parameters
      newactions:= [
        [ [ "e" ], rec(
          helplines:= [ "change the threshold parameters" ],
          action:= t -> editfields( t, "mincount" ) ) ],
      ];

      for mode in modes do
        if mode.name <> "help" then
          BrowseData.SetActions( mode, replactions, "replace" );
          BrowseData.SetActions( mode, newactions );
        fi;
      od;
      BrowseData.defaults.work.customizedModes.profile:= modes;
    fi;
    modes:= BrowseData.defaults.work.customizedModes.profile;

    # Construct and show the browse table.
    NCurses.BrowseGeneric( rec(
      work:= rec(
        align:= "tl",
        minyx:= [ 10, 1 ],
        availableModes:= modes,
        prof:= info.prof,

        # The header is dynamic because `mincount' and `mintime' can vary.
        header:= function( t )
          return [ "",
                   [ NCurses.attrs.UNDERLINE, true, "GAP Profiling",
                     NCurses.attrs.NORMAL ],
                   Concatenation(
                     "(show functions with count >= ",
                     String( t.dynamic.mincount ),
                     " or self + chld >= ",
                     String( t.dynamic.mintime ), " ms)" ),
                   "" ];
        end,

        # The footer is dynamic because we have to emulate scrolling
        # horizontally, and because the `OTHER' values can vary.
        footer:= function( t )
          local start, w, lines, qotim, qosto, line;

          start:= Sum( List( [ 1 .. t.dynamic.topleft[2] - 1 ],
                             j -> BrowseData.WidthCol( t, j ) ),
                       t.dynamic.topleft[4] );
          w:= List( [ [ 1 .. 4 ], [ 5 .. 8 ],
                      [ 9 .. Length( collabels ) - 1 ] ],
                    l -> Sum( List( l, j -> BrowseData.WidthCol( t, j ) ) ) );
          lines:= [];
          qotim:= QuoInt( t.dynamic.otim, denom[2] );
          qosto:= QuoInt( t.dynamic.osto, denom[4] );
          if 0 < qotim or 0 < qosto then
            line:= Concatenation( String( qotim, w[1] ),
                                  String( qosto, w[2] ),
                                  String( " ", w[3] ), "OTHER" );
            lines[1]:= line{ [ start .. Length( line ) ] };
          else
            lines[1]:= "";
          fi;
          line:= Concatenation( String( QuoInt( info.ttim, denom[2] ), w[1] ),
                                String( QuoInt( info.tsto, denom[4] ), w[2] ),
                                String( " ", w[3] ), "TOTAL" );
          lines[2]:= line{ [ start .. Length( line ) ] };

          return lines;
        end,
        main:= table,
        labelsCol:= [ collabels ],
        sepLabelsCol:= "=",
        sepCol:= Concatenation( [ "" ],
                   ListWithIdenticalEntries( Length( collabels ) - 1,
                                             info.sepCol ),
                   [ "" ] ),
        SpecialGrid:= BrowseData.SpecialGridLineDraw,

        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
        ),

        # If the column shows the package assignment then show the
        # total time and storage used by this package in the category row.
        CategoryValues:= function( t, i, j )
          local cats, totals, k, cat, pos, len;

          cats:= BrowseData.defaults.work.CategoryValues( t, i, j );
          if info.labelsCol[ j/2 ] = "package" then
            totals:= packagetotals( t, info );
            for k in [ 1 .. Length( cats ) ] do
              cat:= cats[k];
              if cat = "(empty category)" then
                cat:= "(none)";
                pos:= Position( totals[1], "" );
              else
                pos:= Position( totals[1], cat );
              fi;
              len:= totals[4] - Length( cat ) - 1;
              cat:= Concatenation( cat, " ",
                        String( totals[2][ pos ], len ) );
              Append( cat, " " );
              len:= totals[5] - Length( cat );
              Append( cat, String( totals[3][ pos ], len ) );
              cats[k]:= cat;
            od;
          fi;

          return cats;
        end,

      ),
      dynamic:= rec(
        activeModes:= [ First( modes, x -> x.name = "browse" ) ],
        isRejectedRow:= reject,
        sortFunctionsForColumns:= ListWithIdenticalEntries( 5,
                                      BrowseData.CompareLenLexRev ),
        mincount:= mincount,
        mintime:= mintime,
        mincount_orig:= mincount,
        mintime_orig:= mintime,
        otim:= otim,
        osto:= osto,
      ),
    ) );

    # Start profiling again.
    for i in PROFILED_FUNCTIONS do
      PROFILE_FUNC( i );
    od;
end );


#############################################################################
##
##  Add the Browse application to the list shown by `BrowseGapData'.
##
BrowseGapDataAdd( "DisplayProfile as a Browse application", BrowseProfile,
  false, "\
the profiled operations, methods, and global functions, \
shown in a browse table; \
the columns of the table contain \
the names of the functions, the number of calls, \
and the time needed; \
``click'' shows the code of the function if possible" );


#############################################################################
##
#E

