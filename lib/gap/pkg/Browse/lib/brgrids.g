#############################################################################
##
#W  brgrids.g             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2007,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##
##  This file contains some <C>SpecialGrid</C> functions.
##

#T TB, May 2007:
#T extended version of `NCurses.Grid',
#T supports ``indicating continuation'' and attributes for lines;
#T the optional components `tend', `bend', `lend', `rend' are `true'
#T if the shown grid is not continued at the top, bottom, left, and right,
#T respectively (this is also the default), and `false' otherwise;
#T the argument `attrs', if given, must be an integer
#T describing the attributes for the lines.

NCurses.GridExt:= function( win, args, attrs )
  local size, trow, brow, lcol, rcol, rowinds, colinds,
        tend, bend, lend, rend,
        tvis, bvis, ht, lvis, rvis, wdth, ld, lmr, i, j;

  size := NCurses.getmaxyx(win);
  if size = false then return false; fi;

  trow:= args.trow;
  brow:= args.brow;
  lcol:= args.lcol;
  rcol:= args.rcol;
  rowinds:= args.rowinds;
  colinds:= args.colinds;
  tend:= not IsBound( args.tend ) or args.tend = true;
  bend:= not IsBound( args.bend ) or args.bend = true;
  lend:= not IsBound( args.lend ) or args.lend = true;
  rend:= not IsBound( args.rend ) or args.rend = true;

  if not ForAll([trow, brow, lcol, rcol], IsInt) then return false; fi;
  if not ForAll(rowinds, IsInt) then return false; fi;
  if not ForAll(colinds, IsInt) then return false; fi;
  # find viewable rows and cols
  rowinds := Filtered(rowinds, i-> i >= 0 and i >= trow and
                                   i <= size[1]-1 and i <= brow);
  colinds := Filtered(colinds, i-> i >= 0 and i >= lcol and
                                   i <= size[2]-1 and i <= rcol);
  if IsEmpty( rowinds ) and IsEmpty( colinds ) then
    return false;
  fi;
  tvis := Maximum(trow, 0);
  bvis := Minimum(brow, size[1]);
  ht := bvis - tvis + 1;
  lvis := Maximum(lcol, 0);
  rvis := Minimum(rcol, size[2]);
  wdth := rvis - lvis + 1;
  # Set attributes for the lines.
  NCurses.wattrset( win, attrs );
  # draw vlines
  ld := NCurses.lineDraw;
  for i in colinds do
    NCurses.wmove(win, tvis, i);
    NCurses.wvline(win, ld.VLINE, ht);
  od;
  # draw hlines and handle crossings
  for i in rowinds do
    NCurses.wmove(win, i, lvis);
    NCurses.whline(win, ld.HLINE, wdth);
    if i = trow and tend then
      lmr := [ld.ULCORNER, ld.TTEE, ld.URCORNER];
    elif i = brow and bend then
      lmr := [ld.LLCORNER, ld.BTEE, ld.LRCORNER];
    else
      lmr := [ld.LTEE, ld.PLUS, ld.RTEE];
    fi;
    for j in colinds do
      NCurses.wmove(win, i, j);
      if j = lcol and lend then
        NCurses.waddch(win, lmr[1]);
      elif j = rcol and rend then
        NCurses.waddch(win, lmr[3]);
      else
        NCurses.waddch(win, lmr[2]);
      fi;
    od;
  od;
  # Reset the attributes.
  NCurses.wattrset( win, NCurses.attrs.NORMAL );
  return true;
end;


#############################################################################
##
#F  BrowseData.SpecialGridLineDraw( <t>, <data> )
##
##  When this special grid is used in a browse table,
##  nonempty row separators are overwritten with horizontal rows
##  that consist of the special character <C>NCurses.lineDraw.HLINE</C>,
##  non-blank characters in column separators are overwritten with vertical
##  rows that consist of the special character <C>NCurses.lineDraw.VLINE</C>,
##  and <Q>crossings</Q> of horizontal and vertical lines are handled as in
##  <Ref Func="NCurses.Grid"/>.
##  <P/>
##  In categorized browse tables, each set of table rows shown under
##  a category row gets a grid of its own,
##  and the separators below category rows are regarded as the top rows of
##  these grids.
##  So this special grid requires nonempty category separators if nonempty
##  row separators occur.
##  (Note that below a row separator, first the category rows and their
##  separators appear, and then the data rows and their separators.
##  If there is a nonempty row separator above the first data row
##  then it is overwritten by whitespace.)
##
BrowseData.SpecialGridLineDraw:= function( t, data )
    local win, entry, top, i;

    win:= t.dynamic.window;

    # Clear category separators, since they may exceed the last column.
    for entry in data.catSeparators do
      NCurses.wmove( win, entry[1], entry[2] );
      NCurses.waddstr( win, ListWithIdenticalEntries( entry[3], ' ' ) );
    od;

    # Replace the row and column separators in all four tables by the lines.
    for entry in data.gridsInfo do
      NCurses.GridExt( win, entry, NCurses.attrs.NORMAL );
    od;

    # Overwrite a row separator above the first data row
    # if the table has a category for the first data row.
    top:= t.dynamic.topleft[1];
    if IsOddInt( top )
       and t.dynamic.topleft[3] = 1
       and BrowseData.LengthCell( t, top, "vert" ) <> 0 then
      for i in [ top+1, top+3 .. Length( t.dynamic.indexRow ) - 1 ] do
        if BrowseData.LengthCell( t, i, "vert" ) <> 0 then
          if i in t.dynamic.categories[1] then
            NCurses.wmove( win, data.topmargin + data.headerLength
                                + BrowseData.HeightLabelsColTable( t ),
                           data.leftmargin );
            NCurses.waddstr( win, ListWithIdenticalEntries(
                NCurses.getmaxyx( win )[2] - data.leftmargin, ' ' ) );
          fi;
          break;
        fi;
      od;
    fi;

    # Print those category separators that do not overwrite grid top lines.
#T force printing of category separators involving attributes!
    for entry in data.catSeparators do
      if ForAll( data.gridsInfo, x -> entry[1] <> x.trow ) then
        NCurses.wmove( win, entry[1], entry[2] );
        NCurses.whline( win, NCurses.lineDraw.HLINE, entry[3] );
      fi;
    od;
end;


#############################################################################
##
#F  BrowseData.SpecialGridLineDrawPlus( <t>, <data> )
##
##  This function is used for example in the `Browse' method for matrices.
##
##  It draws the crossing of the two lines that separate the row and column
##  labels from the main table.
##  Note that the grids drawn by `BrowseData.SpecialGridLineDraw' belong to
##  one of the four subtables of a browse table, and it is not supported
##  that lines separate these tables.
##
BrowseData.SpecialGridLineDrawPlus:= function( t, data )
    local win;

    BrowseData.SpecialGridLineDraw( t, data );
    win:= t.dynamic.window;
    NCurses.wmove( win, data.gridsInfo[1].rowinds[1],
                        data.gridsInfo[1].colinds[1] );
    NCurses.waddch( win, NCurses.lineDraw.PLUS );
end;


#############################################################################
##
#F  BrowseData.SpecialGridTreeStyle( <t>, <data> )
##
##  *NOTE*:
##  This function does not yet support category separators
##  and cells of height larger than 1.
##  (And there is the general problem that when one expands all categories at
##  the end of the table, the programmatically hidden rows are taken into
##  account and then lead to unmotivated empty rows.)
##  (Scrolling by cells seems to be not appropriate for this application,
##  scrolling by characters would be better.)
##
BrowseData.SpecialGridTreeStyle:= function( t, data )
    local categories, catpos, win, i, fromrow, maxdepth, previousrow, scr,
          ymin, ymax, y, prevdatarow, pos, entry, level, currlevel, pos2,
          kmin, j, k, lastcategorypos, height, l;

    categories:= t.dynamic.categories;
    catpos:= categories[1];
    if IsEmpty( catpos ) or 2 < catpos[1] then
      # `BrowseData.SpecialGridTreeStyle' expects category rows,
      # starting in the first row.
      return;
    fi;
    win:= t.dynamic.window;
    i:= t.dynamic.topleft[1];
    fromrow:= t.dynamic.topleft[3];
    maxdepth:= Length( t.work.sepCol[1] );

    # The `i'-th entry in `previousrow' is the position of the previous
    # level `i' category if there is one on the screen, and zero otherwise.
    previousrow:= 0 * [ 0 .. maxdepth ];

    # Process the current line.
    scr:= BrowseData.HeightWidthWindow( t );
    ymin:= data.topmargin + BrowseData.HeightLabelsColTable( t )
                          + data.headerLength + 1;
    ymax:= scr[1] - data.bottommargin - data.footerLength;
    y:= ymin;
    prevdatarow:= fail;
    while y <= ymax+1 and IsBound( t.dynamic.indexRow[i] ) do
      # We consider row `ymax+1' but we do not print there.
      if i mod 2 = 0 then

        # Deal with categories, omitting the first `fromrow - 1' rows.
        pos:= PositionSorted( catpos, i );
#T Why is there no variant with a <from> argument?
        while pos <= Length( catpos ) and catpos[ pos ] = i do
          entry:= categories[2][ pos ];
          if entry.isUnderCollapsedCategory or entry.isRejectedCategory then
            # This category and all of higher level are hidden.
            break;
          fi;
          level:= entry.level;

          # Deal with the category line.
          if 1 < fromrow then
            # The beginning of the cell is above the screen.
            fromrow:= fromrow - 1;
          else
            # (We print no path to level 1 rows.)
            if 1 < level then
              if not IsBound( currlevel ) then
                # The current level is that of the previous category row.
                pos2:= pos;
                while 1 < pos2 and catpos[ pos2 ] = i do
                  pos2:= pos2 - 1;
                od;
                currlevel:= categories[2][ pos2 ].level;
              fi;

              # Print the grid part for this level above the current line.
              if   currlevel < level then
                # Fill the level `currlevel' column above the current line.
                if ymin < y and previousrow[ currlevel ] + 1 < y then
                  NCurses.wmove( win, y-2, 0 );
                  NCurses.waddstr( win, ListWithIdenticalEntries(
                                            2*currlevel-2, ' ' ) );
                  NCurses.wmove( win, y-2, 2*currlevel-2 );
                  NCurses.waddch( win, NCurses.lineDraw.LTEE );
                fi;
              elif currlevel = level then
                # Fill the level `currlevel' column above the current line.
                if previousrow[ currlevel ] = 0 then
                  kmin:= ymin;
                  NCurses.wmove( win, kmin-1, 0 );
                  NCurses.waddstr( win, ListWithIdenticalEntries(
                                            2*currlevel-4, ' ' ) );
                  NCurses.wmove( win, kmin - 1, 2*currlevel-4 );
                  NCurses.waddch( win, NCurses.lineDraw.VLINE );
                else
                  kmin:= previousrow[ currlevel ];
                  NCurses.wmove( win, kmin-1, 0 );
                  NCurses.waddstr( win, ListWithIdenticalEntries(
                                            2*currlevel-4, ' ' ) );
                  NCurses.wmove( win, kmin - 1, 2*currlevel-4 );
                  NCurses.waddch( win, NCurses.lineDraw.LTEE );
                fi;
                NCurses.wmove( win, kmin, 2 * ( currlevel-2 ) );
                NCurses.wvline( win, NCurses.lineDraw.VLINE, y - kmin - 1 );
              else
                # Fill the column for level `level' above the current line.
                if previousrow[ level ] = 0 then
                  kmin:= ymin;
                else
                  kmin:= previousrow[ level ];
                fi;
                NCurses.wmove( win, kmin-1, 0 );
                NCurses.waddstr( win, ListWithIdenticalEntries(
                                          2*level-4, ' ' ) );
                NCurses.wmove( win, kmin - 1, 2*level-4 );
                if previousrow[ level ] = 0 then
                  NCurses.waddch( win, NCurses.lineDraw.VLINE );
                else
                  NCurses.waddch( win, NCurses.lineDraw.LTEE );
                fi;
                NCurses.wmove( win, kmin, 2 * ( level-2 ) );
                NCurses.wvline( win, NCurses.lineDraw.VLINE, y - kmin - 1 );
              fi;
              if y <= ymax then
                NCurses.wmove( win, y-1, 0 );
                NCurses.waddstr( win, ListWithIdenticalEntries(
                                          2*level-4, ' ' ) );
                NCurses.wmove( win, y-1, 2*level-4 );
                NCurses.waddch( win, NCurses.lineDraw.LLCORNER );
              fi;
            fi;
            previousrow[ level ]:= y;
            currlevel:= level;
            lastcategorypos:= pos;

            y:= y + 1;
          fi;

          pos:= pos + 1;
        od;
      fi;

      # Deal with the data rows.
#T what about fromrow?
      height:= BrowseData.HeightRow( t, i );
      if 0 < height then
        if i mod 2 = 0 then
          if not IsBound( currlevel ) then
            # The first shown row is a data row.
            # Determine the level of the category row above the first line.
            pos:= PositionSorted( catpos, i );
            if IsBound( catpos[ pos ] ) and catpos[ pos ] = i then
              if BrowseData.HeightCategories( t, i ) < fromrow then
                # Take the last category row for `i'.
                while IsBound( catpos[ pos ] ) and catpos[ pos ] = i do
                  pos:= pos + 1;
                od;
              else
                # Take the last category row for `i' above the first line,
                # together with its category separator below.
                while IsBound( catpos[ pos ] )
                      and BrowseData.HeightCategories( t, i,
                              categories[2][ pos ].level ) < fromrow do
                  pos:= pos + 1;
                od;
              fi;
            fi;
            if 1 < pos then
              pos:= pos-1;
            fi;
            currlevel:= categories[2][ pos ].level;
            lastcategorypos:= pos;
          fi;

          # Fill the column for level `currlevel' above the current line.
          if prevdatarow = y-1 then
            NCurses.wmove( win, y-2, 0 );
            NCurses.waddstr( win, ListWithIdenticalEntries(
                                      2*currlevel-2, ' ' ) );
            NCurses.wmove( win, y-2, 2*currlevel-2 );
            NCurses.waddch( win, NCurses.lineDraw.LTEE );
          fi;
          if y <= ymax then
            NCurses.wmove( win, y-1, 0 );
            NCurses.waddstr( win, ListWithIdenticalEntries(
                                      2*currlevel-2, ' ' ) );
            NCurses.wmove( win, y-1, 2*currlevel-2 );
            NCurses.waddch( win, NCurses.lineDraw.LLCORNER );
          fi;
          prevdatarow:= y;
#T fill with LTEE only in the first line of a cell, otherwise with VLINE
          # Draw a horizontal line in row `y'.
          if y <= ymax then
            NCurses.wmove( win, y-1, 2 * currlevel - 1 );
            NCurses.whline( win, NCurses.lineDraw.HLINE,
                            2 * ( maxdepth - currlevel ) );
          fi;
        fi;
        y:= y + height - fromrow + 1;
      fi;
      i:= i + 1;
      fromrow:= 1;
    od;

    # Draw the missing vertical lines from and to outside categories:
    # If there is an unhidden category of level $k$ below and above
    # the next category of level less than $k$
    # then either replace the `LLCORNER' in column $k-1$ by an `LTEE' and
    # draw a `VLINE' below until the end of the window,
    # or in the case that there is no `LLCORNER' in column $k-1$
    # draw a `VLINE' through the whole window.
    for k in [ 2 .. Length( previousrow ) ] do
      if previousrow[k] >= previousrow[ k-1 ] then
        for pos2 in [ lastcategorypos + 1 .. Length( catpos ) ] do
          if   categories[2][ pos2 ].level = k
               and not categories[2][ pos2 ].isRejectedCategory then
            if previousrow[k] = 0 then
              NCurses.wmove( win, ymin - 1, 2 * ( k-2 ) );
              NCurses.wvline( win, NCurses.lineDraw.VLINE,
                              ymax - ymin + 1 );
            elif previousrow[k] <= ymax then
              NCurses.wmove( win, previousrow[k]-1, 2 * ( k-2 ) );
              NCurses.waddch( win, NCurses.lineDraw.LTEE );
              NCurses.wmove( win, previousrow[k], 2 * ( k-2 ) );
              NCurses.wvline( win, NCurses.lineDraw.VLINE,
                              ymax - previousrow[k] );
            fi;
            break;
          elif categories[2][ pos2 ].level < k
               and not categories[2][ pos2 ].isRejectedCategory then
            break;
          fi;
        od;
      fi;
    od;
end;


#############################################################################
##
#E

