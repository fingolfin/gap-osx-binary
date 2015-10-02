#############################################################################
##
#W  atlasbrowse_old.g     GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,   RWTH Aachen,  Germany
##
##  This file is read if version 1.5 of AtlasRep is still used.
##  For any later version of AtlasRep, the file atlasbrowse.g is used.
##


#############################################################################
##
#V  BrowseData.AtlasInfoActionShowOverview
##
##  is used in the tables constructed by `BrowseData.AtlasInfoGroupTable' and
##  `BrowseData.AtlasInfoOverview'.
##
BrowseData.AtlasInfoActionShowOverview:= [
    [ [ "Y" ], rec( helplines := [
         "show an overview of selected entries" ],
      action := function( t )
        local str, grps, grp, line;

        str:= "";
        grps:= Set( List( t.dynamic.viewReturn, x -> x[1] ) );
        for grp in grps do
          Append( str, "G = " );
          Append( str, grp );
          Append( str, ":\n" );
          for line in Filtered( t.dynamic.viewReturn,
                                x -> x[1] = grp ) do
            Append( str, "  " );
            Append( str, line[2] );
            Append( str, "\n" );
          od;
          Append( str, "\n" );
        od;
        if IsEmpty( str ) then
          str:= "(nothing was chosen yet)";
        fi;

        if BrowseData.IsDoneReplay( t.dynamic.replay ) then
          NCurses.Pager( str );
          NCurses.update_panels();
          NCurses.doupdate();
          NCurses.curs_set( 0 );
        fi;
        return t.dynamic.changed;
      end ) ],
  ];


#############################################################################
##
#F  BrowseData.AtlasInfoGroupTable( <conditions>, <log>, <replay>, <t> )
##
##  This function is called by `BrowseData.AtlasInfoOverview' when a row in
##  the overview table is clicked.
##  It returns a browse table with the details for the chosen group,
##  which is shown via a second level `Browse' call.
##
BrowseData.AtlasInfoGroupTable:= function( conditions, log, replay, t )
    local gapname, cats, labelsRow, info, inforeps, name, infoprgs, entry,
          sel_action, header, footer, showTables, modes, mode, table;

    gapname:= AGR.GAPName( conditions[1] );
    cats:= [];
    labelsRow:= [];
    info:= [];

    # Construct the information about representations for `gapname'.
    inforeps:= AGR.InfoReps( conditions );
    if 0 < Length( inforeps.list ) then
      Add( cats, rec( pos:= 2,
                      level:= 1,
                      value:= Concatenation( inforeps.header ),
                      separator:= "",
                      isUnderCollapsedCategory:= false,
                      isRejectedCategory:= false ) );
      Append( labelsRow,
              List( inforeps.list, x -> [ Concatenation( x[1] ) ] ) );
      Append( info,
              List( inforeps.list,
                    x -> [ rec( rows:= [ BrowseData.SimplifiedString(
                                             Concatenation( x[2] ) ) ],
                                align:= "l" ),
                           rec( rows:= [ BrowseData.SimplifiedString(
                                             Concatenation( x[3] ) ) ],
                                align:= "l" ) ] ) );
    fi;

    # Construct the information about scripts for `gapname'.
    infoprgs:= AGR.InfoPrgs( conditions );
    if ForAny( infoprgs.list, x -> not IsEmpty( x ) ) then
      Add( cats, rec( pos:= 2 * Length( info ) + 2,
                      level:= 1,
                      value:= Concatenation( infoprgs.header ),
                      separator:= "",
                      isUnderCollapsedCategory:= false,
                      isRejectedCategory:= false ) );

      for entry in infoprgs.list do
        if   Length( entry ) = 1 then
          Add( info, [ rec( rows:= entry, align:= "l" ) ] );
          Add( labelsRow, [ "" ] );
        elif 1 < Length( entry ) then
          Add( cats, rec( pos:= 2 * Length( info ) + 2,
                          level:= 2,
                          value:= entry[1],
                          separator:= "",
                          isUnderCollapsedCategory:= false,
                          isRejectedCategory:= false ) );
          Append( info,
              List( entry{ [ 2 .. Length( entry ) ] },
                    x -> [ rec( rows:= [ x ], align:= "l" ) ] ) );
          Append( labelsRow,
              List( [ 2 .. Length( entry ) ], x -> [ "" ] ) );
        fi;
      od;
    fi;

    # Provide functionality for the `Click' function, the header, the footer,
    # and a modified `showTables' function.
    sel_action:= rec(
      helplines:= [ "add the selected entry to the result" ],
      action:= function( t )
        local info, pos, line, choice, i;

        if t.dynamic.selectedEntry <> [ 0, 0 ] then
          # Set the return value and close the window.
          pos:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
          if pos <= Length( inforeps.list ) then
            info:= inforeps.list[ pos ];
            pos:= t.work.labelsRow[ pos ][1];
            pos:= pos{ [ 1 .. Length( pos ) - 1 ] };
            line:= Concatenation( info[2] );
            if not IsEmpty( info[3] ) then
              Append( line, " (" );
              Append( line, Concatenation( info[3] ) );
              Append( line, ")" );
            fi;
            choice:= [ gapname, Int( pos ) ];
          else
            pos:= pos - Length( inforeps.list );
            for i in [ 1 .. Length( infoprgs.list ) ] do
              if Length( infoprgs.list[i] ) = 1 then
                if pos = 1 then
                  line:= infoprgs.list[i][1];
                  choice:= [ gapname, infoprgs.nams[i] ];
                  break;
                fi;
                pos:= pos - 1;
              elif 1 < Length( infoprgs.list[i] ) then
                if pos < Length( infoprgs.list[i] ) then
                  if infoprgs.nams[i] = "maxes" then
                    line:= Concatenation( "max. no. ",
                               infoprgs.list[i][ pos+1 ] );
                  else
                    line:= infoprgs.list[i][ pos+1 ];
                  fi;
                  choice:= [ gapname, infoprgs.nams[i],
                             infoprgs.list[i][ pos+1 ] ];
                  break;
                fi;
                pos:= pos - Length( infoprgs.list[i] ) + 1;
              fi;
            od;
          fi;
          if choice in t.dynamic.Return then
            t.dynamic.currentFooterRow:= Concatenation( line,
                " was already chosen" );
          else
            Add( t.dynamic.Return, choice );
            Add( t.dynamic.viewReturn, [ gapname, line ] );
            t.dynamic.currentFooterRow:= Concatenation( line,
                " added to the result" );
          fi;
        fi;
      end );

    header:= Concatenation( "AtlasRep info for ", gapname );
    if 1 < Length( conditions ) then
      Append( header, " (selected entries)" );
    fi;

    footer:= t -> [ [ NCurses.attrs.UNDERLINE, true,
                      RepeatedString( " ",
                          BrowseData.HeightWidthWindow( t )[2] ) ],
                    t.dynamic.currentFooterRow ];

    showTables:= function( t )
      BrowseData.ShowTables( t );
      t.dynamic.currentFooterRow:= "";
      end;

    # Construct the modified modes if necessary.
    if not IsBound( BrowseData.defaults.work.customizedModes.atlasbrowse2 )
       then
      # Create a shallow copy of each default mode for `Browse',
      # modify the `showTables' function,
      # and add a new action to all available modes (except the help mode):
      # - Y: Show a pager with the entries that have been selected.
      modes:= List( BrowseData.defaults.work.availableModes,
                    BrowseData.ShallowCopyMode );
      for mode in modes do
        if mode.name in [ "select_entry", "select_row",
             "select_row_and_entry", "select_column_and_entry" ] then
          mode.ShowTables:= showTables;
        fi;
        if mode.name <> "help" then
          BrowseData.SetActions( mode,
              BrowseData.AtlasInfoActionShowOverview );
        fi;
      od;
      BrowseData.defaults.work.customizedModes.atlasbrowse2:= modes;
    else
      modes:= BrowseData.defaults.work.customizedModes.atlasbrowse2;
    fi;

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "tl",
        header:= [ "", [ NCurses.attrs.UNDERLINE, true, header ], "" ],
        footer:= rec(
          select_entry:= footer,
          select_row:= footer,
          select_row_and_entry:= footer,
          select_column_and_entry:= footer,
        ),
        availableModes:= modes,
        main:= info,
        labelsRow:= labelsRow,
        sepLabelsRow:= [ " ", "" ],
        sepCol:= [ " ", " ", "" ],
        Click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
          select_row_and_entry:= sel_action,
          select_column_and_entry:= sel_action,
        ),
      ),
      dynamic:= rec(
        categories:= [ List( cats, x -> x.pos ), cats, [ 1 ] ],
        initialSteps:= [ 115, 114 ],
        Return:= [],
        currentFooterRow:= "",
        viewReturn:= [],
      ),
    );
    if log <> fail then
      table.dynamic.log:= log;
      table.dynamic.replay:= replay;
    fi;
    if t <> fail then
      table.dynamic.Return:= t.dynamic.Return;
      table.dynamic.viewReturn:= t.dynamic.viewReturn;
    fi;

    return table;
    end;


#############################################################################
##
#F  BrowseData.AtlasInfoOverview( <gapnames>, <conditions>, <log>, <replay> )
##
##  Part of the code is analogous to `AGR.DisplayAtlasInfoOverview'.
##
BrowseData.AtlasInfoOverview:= function( gapnames, conditions, log, replay )
    local tocs, columns, type, i, sel_action, header, modes, mode, table;

    tocs:= AGR.TablesOfContents( conditions );

    # Consider only those names for which actually information is available.
    # (The ordering shall be the same as in the input.)
    if gapnames = "all" then
      gapnames:= AtlasOfGroupRepresentationsInfo.GAPnamesSortDisp;
    else
      gapnames:= Filtered( List( gapnames, AGR.InfoForName ),
                           x -> x <> fail );
    fi;
    gapnames:= Filtered( gapnames,
                   x -> ForAny( tocs, toc -> IsBound( toc.( x[2] ) ) ) );
    if IsEmpty( gapnames ) then
      return;
    fi;

    # Compute the data of the columns.
    columns:= [ [ "G", "l", List( gapnames, x -> [ x[1], false ] ) ] ];
    for type in AGR.DataTypes( "rep", "prg" ) do
      if type[2].DisplayOverviewInfo <> fail then
        Add( columns, [
             type[2].DisplayOverviewInfo[1],
             type[2].DisplayOverviewInfo[2],
             List( gapnames,
                   n -> type[2].DisplayOverviewInfo[3](
                            Concatenation( [ n ], conditions ) ) ) ] );
      fi;
    od;

    # Evaluate the privacy flag.
    for i in [ 1 .. Length( gapnames ) ] do
      if ForAny( columns, x -> x[3][i][2] ) then
        columns[1][3][i][1]:= Concatenation( columns[1][3][i][1],
            AtlasOfGroupRepresentationsInfo.markprivate );
      fi;
    od;

    sel_action:= function( t )
      local name, tt;

      if t.dynamic.selectedEntry <> [ 0, 0 ] then
        name:= gapnames[ t.dynamic.indexRow[
                             t.dynamic.selectedEntry[1] ] / 2 ][1];
        tt:= BrowseData.AtlasInfoGroupTable(
               Concatenation( [ name ], conditions ),
               t.dynamic.log, t.dynamic.replay, t );
        if IsEmpty( tt.work.main ) then
          BrowseData.AlertWithReplay( t,
            Concatenation( "There are no data for the group", name, "." ),
            NCurses.attrs.BOLD );
        else
          NCurses.BrowseGeneric( tt );
          if tt.dynamic.interrupt then
            BrowseData.actions.QuitTable.action( t );
          else
            t.dynamic.Return:= tt.dynamic.Return;
            t.dynamic.viewReturn:= tt.dynamic.viewReturn;
          fi;
        fi;
      fi;
    end;

    header:= "Atlas Of Group Representations: Overview";
    if gapnames <> "all" or not IsEmpty( conditions ) then
      Append( header, " (selected entries)" );
    fi;

    # Construct the modified modes if necessary.
    if not IsBound( BrowseData.defaults.work.customizedModes.atlasbrowse1 )
       then
      # Create a shallow copy of each default mode for `Browse'
      # and add a new action to all available modes (except the help mode):
      # - Y: Show a pager with the entries that have been selected.
      modes:= List( BrowseData.defaults.work.availableModes,
                    BrowseData.ShallowCopyMode );
      for mode in modes do
        if mode.name <> "help" then
          BrowseData.SetActions( mode,
              BrowseData.AtlasInfoActionShowOverview );
        fi;
      od;
      BrowseData.defaults.work.customizedModes.atlasbrowse1:= modes;
    else
      modes:= BrowseData.defaults.work.customizedModes.atlasbrowse1;
    fi;

    # Construct and show the browse table.
    table:= rec(
      work:= rec(
        align:= "tl",
        header:= t -> BrowseData.HeaderWithRowCounter( t, header,
                          Length( gapnames ) ),
        availableModes:= modes,
        main:= List( [ 1 .. Length( gapnames ) ], i ->  List( columns,
                    col -> rec( rows:= [ col[3][i][1] ], align:= col[2] ) ) ),
        labelsCol:= [ List( columns,
                        col -> rec( rows:= [ col[1] ], align:= col[2] ) ) ],
        sepLabelsCol:= [ "-" ],
        sepCol:= Concatenation( [ "| " ],
                     List( [ 1 .. Length( columns ) - 1 ], i -> " | " ),
                     [ " |" ] ),
        SpecialGrid:= BrowseData.SpecialGridLineDraw,
        Click:= rec(
          select_entry:= rec(
            helplines:= [ "open an overview for the selected entry" ],
            action:= sel_action ),
          select_row:= rec(
            helplines:= [ "open an overview for the selected row" ],
            action:= sel_action ),
          select_row_and_entry:= rec(
            helplines:= [ "open an overview for the selected entry" ],
            action:= sel_action ),
          select_column_and_entry:= rec(
            helplines:= [ "open an overview for the selected entry" ],
            action:= sel_action ),
        ),
      ),
      dynamic:= rec(
        Return:= [],
        viewReturn:= [],
      ),
    );

    if log <> fail then
      table.dynamic.log:= log;
      table.dynamic.replay:= replay;
    fi;

    return NCurses.BrowseGeneric( table );
    end;


#############################################################################
##
#F  BrowseData.AtlasInfoGroup( <conditions>, <log>, <replay>, <t> )
##
BrowseData.AtlasInfoGroup:= function( conditions, log, replay, t )
    local table;

    table:= BrowseData.AtlasInfoGroupTable( conditions, log, replay, t );
    if IsEmpty( table.work.main ) then
      BrowseData.AlertWithReplay( table,
          Concatenation( "There are no data for the group ", conditions[1],
                         "." ),
          NCurses.attrs.BOLD );
      return [];
    fi;
    return NCurses.BrowseGeneric( table );
    end;


#############################################################################
##
#F  BrowseAtlasInfo( [...] )
##
##  <#GAPDoc Label="AtlasRep_section">
##  <Section Label="sec:atlasdisp">
##  <Heading>Table of Contents of <Package>AtlasRep</Package></Heading>
##
##  The &GAP; package <Package>AtlasRep</Package>
##  (see&nbsp;<Cite Key="AtlasRep"/>) is an interface to a database
##  of representations and related data.
##  The table of contents of this database can be displayed via the function
##  <Ref Func="DisplayAtlasInfo" BookName="atlasrep"/> of this package.
##  The &Browse; package provides an alternative based on the function
##  <Ref Func="NCurses.BrowseGeneric"/>;
##  one can scroll, search, and fetch data for later use.
##
##  <ManSection>
##  <Heading>BrowseAtlasInfo</Heading>
##  <Func Name="BrowseAtlasInfo"
##   Arg='[listofnames, ]["contents", sources][, ...]'
##   Label="overview of groups"/>
##  <Func Name="BrowseAtlasInfo" Arg="gapname[, std][, ...]"
##   Label="overview for one group"/>
##
##  <Returns>
##  the list of <Q>clicked</Q> info records.
##  </Returns>
##
##  <Description>
##  This function shows the information available via the &GAP; package
##  <Package>AtlasRep</Package> in a browse table,
##  cf. Section&nbsp;<Ref Sect="Accessing Data of the AtlasRep Package"
##  BookName="atlasrep"/> in the <Package>AtlasRep</Package> manual.
##  <P/>
##  The optional arguments can be used to restrict the table to public or
##  private data, or to show an overview for one particular group.
##  The arguments are the same as for
##  <Ref Func="DisplayAtlasInfo" BookName="AtlasRep"/>,
##  see the documentation of this function for details.
##  (Note that additional conditions such as
##  <Ref Func="IsPermGroup" BookName="ref"/> can be entered also in the case
##  that no <A>gapname</A> is given.
##  In this situation, the additional conditions are evaluated for the
##  <Q>second level tables</Q> that are opened by <Q>clicking</Q> on a
##  table row or entry.)
##  <P/>
##  When one <Q>clicks</Q> on one of the table rows or entries then a
##  browse table with an overview of the information available for this
##  group is shown, and <Q>clicking</Q> on one of the rows in these tables
##  adds the corresponding info record
##  (see <Ref Func="OneAtlasGeneratingSetInfo" BookName="AtlasRep"/>)
##  to the list of return values of
##  <Ref Func="BrowseAtlasInfo" Label="overview of groups"/>.
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  The following example shows how
##  <Ref Func="BrowseAtlasInfo" Label="overview of groups"/> can be
##  used to fetch info records about permutation representations of the
##  alternating groups <M>A_5</M> and <M>A_6</M>:
##  We search for the group name <C>"A5"</C> in the overview table, and the
##  first cell in the table row for <M>A_5</M> becomes selected;
##  hitting the <B>Enter</B> key causes a new window to be opened, with an
##  overview of the data available for <M>A_5</M>;
##  moving down two rows and hitting the <B>Enter</B> key again causes the
##  second representation to be added to the result list;
##  hitting <B>Q</B> closes the second window, and we are back in the
##  overview table;
##  we move the selection down twice (to the row for the group <M>A_6</M>),
##  and choose the first representation for this group;
##  finally we leave the table, and the return value is the list with the
##  data for the two representations.
##  <P/>
##  <Example><![CDATA[
##  gap> d:= [ NCurses.keys.DOWN ];;  r:= [ NCurses.keys.RIGHT ];;
##  gap> c:= [ NCurses.keys.ENTER ];;
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "/A5",         # Find the string A5 ...
##  >        d, d, r,       # ... such that just the word matches,
##  >        c,             # start the search,
##  >        c,             # click the table entry A5,
##  >        d, d,          # move down two rows,
##  >        c,             # click the row for this representation,
##  >        "Q",           # quit the second level table,
##  >        d, d,          # move down two rows,
##  >        c,             # click the table entry A6,
##  >        d,             # move down one row,
##  >        c,             # click the first row,
##  >        "Q",           # quit the second level table,
##  >        "Q" ) );       # and quit the application.
##  gap> if IsBound( BrowseAtlasInfo ) and IsBound( AtlasProgramInfo ) then
##  >      tworeps:= BrowseAtlasInfo();
##  >    else
##  >      tworeps:= [ fail ];
##  >    fi;
##  gap> BrowseData.SetReplay( false );
##  gap> if fail in tworeps then
##  >      Print( "no access to the Web ATLAS\n" );
##  >    else
##  >      Print( List( tworeps, x -> x.identifier[1] ), "\n" );
##  [ "A5", "A6" ]
##  >    fi;
##  ]]></Example>
##  <P/>
##  <E>Implementation remarks</E>:
##  The first browse table shown has a static header,
##  no footer and row labels,
##  one row of column labels describing the type of data summarized in the
##  columns.
##  <P/>
##  Row and column separators are drawn as grids
##  (cf.&nbsp;<Ref Func="NCurses.Grid"/>) composed from the special characters
##  described in Section&nbsp;<Ref Subsect="ssec:ncursesLines"/>,
##  using the component <C>work.SpecialGrid</C> of the browse table,
##  see <Ref Var="BrowseData"/>.
##  <P/>
##  When a row is selected, the <Q>click</Q> functionality opens a new window
##  (via a second level call to <Ref Func="NCurses.BrowseGeneric"/>),
##  in which a browse table with the list of available data for
##  the given group is shown;
##  in this table, <Q>click</Q> results in adding the info for the selected
##  row to the result list, and a message about this addition is shown in the
##  footer row.
##  One can choose further data, return to the first browse table,
##  and perhaps iterate the process for other groups.
##  When the first level table is left, the list of info records for the
##  chosen data is returned.
##  <P/>
##  For the two kinds of browse tables,
##  the standard modes in <Ref Var="BrowseData"/> (except the <C>help</C>
##  mode) have been extended by a new action that opens a pager giving an
##  overview of all data that have been chosen in the current call.
##  The corresponding user input is the <B>Y</B> key.
##  <P/>
##  This function is available only if the &GAP; package
##  <Package>AtlasRep</Package> is available.
##  <P/>
##  The code can be found in the file <F>app/atlasbrowse.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseAtlasInfo", function( arg )
    local log, replay, result, i, pos, pos2;

    # A record at the first position may prescribe the replay with history.
    log:= fail;
    replay:= fail;
    if Length( arg ) <> 0 and IsRecord( arg[1] )
                          and IsBound( arg[1].log )
                          and IsBound( arg[1].replay ) then
      log:= arg[1].log;
      replay:= arg[1].replay;
      arg:= arg{ [ 2 .. Length( arg ) ] };
    fi;

    # Distinguish the summary overview for at least one group
    # from the detailed overview for exactly one group.
    if   Length( arg ) = 0 then
      result:= BrowseData.AtlasInfoOverview( "all", arg, log, replay );
    elif IsList( arg[1] ) and ForAll( arg[1], IsString ) then
      result:= BrowseData.AtlasInfoOverview( arg[1],
                   arg{ [ 2 .. Length( arg ) ] }, log, replay );
    elif not IsString( arg[1] ) or arg[1] = "contents" then
      result:= BrowseData.AtlasInfoOverview( "all", arg, log, replay );
    else
      result:= BrowseData.AtlasInfoGroup( arg, log, replay, fail );
    fi;

    # Evaluate the return value.
    for i in [ 1 .. Length( result ) ] do
      if IsInt( result[i][2] ) then
        # a representation
        result[i]:= OneAtlasGeneratingSetInfo( result[i][1], Position,
                        result[i][2] );
      else
        # a program; turn the display values into inputs.
        if   result[i][2] = "maxes" then
          # perhaps standard generators of the subgroup
          pos:= PositionSublist( result[i][3], "(std. " );
          if pos <> fail then
            pos2:= Position( result[i][3], ')', pos );
            result[i][4]:= Int( result[i][3]{ [ pos+6 .. pos2-1 ] } );
          fi;
          pos:= Position( result[i][3], ':' );
          if pos <> fail then
            result[i][3]:= result[i][3]{ [ 1 .. pos-1 ] };
          fi;
          result[i][3]:= Int( NormalizedWhitespace( result[i][3] ) );
        elif result[i][2] = "out" then
          result[i][2]:= "automorphism";
        elif result[i][2] = "pres" then
          result[i][2]:= "presentation";
        elif result[i][2] = "kernel" then
          pos:= PositionSublist( result[i][3], " -> " );
          result[i][3]:= result[i][3]{ [ pos+4 .. Length( result[i][3] ) ] };
        fi;
        result[i]:= CallFuncList( AtlasProgramInfo, result[i] );
      fi;
    od;

    return result;
    end );


#############################################################################
##
##  Add the Browse application to the list shown by `BrowseGapData'.
##
BrowseGapDataAdd( "AtlasRep Overview", BrowseAtlasInfo, true, "\
an overview of the information provided by the \
Atlas of Group Representations, \
the return value is the list of records \
encoding the clicked entries" );


#############################################################################
##
#E

