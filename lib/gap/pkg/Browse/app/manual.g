#############################################################################
##
#W  manual.g              GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseGapManuals( [<start>] )
##
##  <#GAPDoc Label="GAPManual_section">
##  <Section Label="sec:manualdisp">
##  <Heading>Access to &GAP; Manuals&ndash;a Variant</Heading>
##
##  A &Browse; adapted way to access several manuals is
##  to show the hierarchy of books, chapters, sections, and subsections
##  as collapsible category rows,
##  and to regard the contents of each subsection as a data row of a matrix
##  with only one column.
##  <P/>
##  This application is mainly intended as an example with table cells that
##  exceed the screen, and as an example with several category levels.
##
##  <ManSection>
##  <Func Name="BrowseGapManuals" Arg="[start]"/>
##
##  <Description>
##  This function displays the contents of the &GAP; manuals
##  (the main &GAP; manuals as well as the loaded package manuals)
##  in a window.
##  The optional argument <A>start</A> describes the initial status,
##  admissible values are the strings
##  <C>"inline/collapsed"</C>,
##  <C>"inline/expanded"</C>,
##  <C>"pager/collapsed"</C>, and
##  <C>"pager/expanded"</C>.
##  <P/>
##  In the <C>inline</C> cases, the parts of the manuals are shown in the
##  browse table,
##  and in the <C>pager</C> case, the parts of the manuals are shown in a
##  different window when they are <Q>clicked</Q>,
##  using the user's favourite help viewer,
##  see <Ref Sect="Changing the Help Viewer" BookName="ref"/>.
##  <P/>
##  In the <C>collapsed</C> cases, all category rows are collapsed,
##  and the first row is selected;
##  typical next steps are moving down the selection and expanding single
##  category rows.
##  In the <C>expanded</C> cases, all category rows are expanded,
##  and nothing is selected;
##  a typical next step in the <C>inline/expanded</C> case is a search
##  for a string in the manuals.
##  (Note that searching in quite slow:
##  For viewing a part of a manual,
##  the file with the corresponding section is read into &GAP;,
##  the text is formatted,
##  the relevant part is cut out from the section,
##  perhaps markup is stripped off,
##  and finally the search is performed in the resulting strings.)
##  <P/>
##  If no argument is given then the user is asked for selecting an initial
##  status, using <Ref Func="NCurses.Select"/>.
##  <P/>
##  The full functionality of the function
##  <Ref Func="NCurses.BrowseGeneric"/> is available.
##  <P/>
##  <Example><![CDATA[
##  gap> n:= [ 14, 14, 14 ];;  # ``do nothing''
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "xdxd",                             # expand a Tutorial section
##  >        n, "Q" ) );                         # and quit
##  gap> BrowseGapManuals( "inline/collapsed" );
##  gap> BrowseData.SetReplay( Concatenation(
##  >        "/Browse", [ NCurses.keys.ENTER ],  # search for "Browse"
##  >        "xdxddxd",                          # expand a section
##  >        n, "Q" ) );                         # and quit
##  gap> BrowseGapManuals( "inline/collapsed" );
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  <P/>
##  <E>Implementation remarks</E>:
##  The browse table has a dynamic header showing the name of the currently
##  selected manual, no footer, no row or column labels,
##  and exactly one column of fixed width equal to the screen width.
##  The category rows are precomputed, i.&nbsp;e.,
##  they do not arise from a table column;
##  this way, the contents of each data cell can be computed on demand,
##  as soon as it is shown on the screen,
##  in particular the category hierarchy is computed without reading the
##  manuals into &GAP;.
##  Also, the data rows are not cached.
##  There is no return value.
##  The heights of many cells are bigger than the screen height,
##  so scrolling is a mixture of scrolling to the next cell and scrolling
##  inside a cell.
##  The different initial states are realized via executing different
##  initial steps before the table is shown to the user.
##  <P/>
##  For the variants that show the manuals in a pager,
##  the code temporarily replaces the <C>show</C> function
##  of the default viewer <C>"screen"</C>
##  (see <Ref Sect="Changing the Help Viewer" BookName="ref"/>)
##  by a function that uses <Ref Func="NCurses.Pager"/>.
##  Note that in the case that the manual bit in question fits into
##  one screen,
##  the default <C>show</C> function writes this text directly to the screen,
##  but this is used already by the browse table.
##  <P/>
##  The implementation should be regarded as a sketch.
##  <P/>
##  For example, the markup available in the text file format of
##  <Package>GAPDoc</Package> manuals (using <B>Esc</B> sequences)
##  is stripped off instead of being transferred to the attribute lines
##  that arise, because of the highlighting problem mentioned in
##  Section&nbsp;<Ref Subsect="NCurses.IsAttributeLine"/>.
##  <P/>
##  Some heuristics used in the code are due to deficiencies of the
##  manual formats.
##  <P/>
##  For the inline variant of the browse table,
##  the titles of chapters, sections, and subsections are <E>not</E> regarded
##  as parts of the actual text since they appear already as category rows;
##  however, the functions of the &GAP; help system deliver the text
##  <E>together with</E> these titles,
##  so these lines must be stripped off afterwards.
##  <P/>
##  The category hierarchy representing the tables of contents is created
##  from the <F>manual.six</F> files of the manuals.
##  These files do not contain enough information
##  for determining whether several functions define the same subsection,
##  in the sense that there is a common description text
##  after a series of manual lines introducing different functions.
##  In such cases, the browse table contains a category row for each of
##  these functions (with its own number),
##  but the corresponding text appears only under the <E>last</E> of these
##  category rows, the data rows for the others are empty.
##  (This problem does not occur in the <Package>GAPDoc</Package> manual
##  format because this introduces explicit subsection titles,
##  involving only the <E>first</E> of several function definitions.)
##  <P/>
##  Also, index entries and sectioning entries in <F>manual.six</F> files
##  of manuals in <Package>GAPDoc</Package> format are not explicitly
##  distinguished.
##  <P/>
##  The code can be found in the file <F>app/manual.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseGapManuals", function( arg )
    local values, start, yx, getdata, width, keys, cats, i, sep, book,
          bookinfo, longname, dirs, toadd, known, toadd2, x, j, lastindex,
          entry, index, str, sel_action, manSection, click, table;

    # Determine the initial status.
    values:= [ "inline/collapsed", "inline/expanded",
               "pager/collapsed", "pager/expanded",
               "cancel" ];
    if Length( arg ) = 1 and arg[1] in values then
      start:= arg[1];
    else
      yx:= NCurses.getmaxyx( 0 );
      start:= values[ NCurses.Select( rec(
                items:= values,
                single:= true,
                none:= false,
                size:= [ 8, 45 ],
                begin:= [ QuoInt( yx[1] - 5, 2 ),
                          QuoInt( yx[2] - 45, 2 ) ],
                border:= true,
                header:= "Please choose an initial status.",
                ) ) ];
    fi;
    if start = "cancel" then
      return;
    fi;

    # The following code is copied from `lib/helpbase.gi':
    # read the manual.six file
    # read the first non-empty line to find out the handler for the corresp.
    # manual format (no explicit format implies the "default" handler)
    getdata:= function( six )
      local stream, line, handler;

      if six = fail then
        return fail;
      fi;
      stream := InputTextFile(six);
      line := "";
      while Length(line) = 0 do
        line := ReadLine(stream);
        if line=fail then
          CloseStream(stream);
          return fail;
        fi;
        line := NormalizedWhitespace(line);
      od;
      if Length(line)>10 and line{[1..10]}="#SIXFORMAT" then
        handler := line{[12..Length(line)]};
        NormalizeWhitespace(handler);
      else
        handler := "default";
        RewindStream(stream);
      fi;
      # give up if handler functions are not (yet) loaded
      if not IsBound(HELP_BOOK_HANDLER.(handler)) then
        return fail;
      fi;

      # Compute the label lines, ignore index entries.
      return HELP_BOOK_HANDLER.( handler ).ReadSix( stream );
    end;

    width:= NCurses.getmaxyx( 0 )[2];
    keys:= [];
    cats:= [];
    i:= 1;
    sep:= "";

    for book in [ 1 .. Length( HELP_KNOWN_BOOKS[1] ) ] do

      bookinfo:= HELP_KNOWN_BOOKS[2][ book ];
      if IsDirectory( bookinfo[3] ) then
        # package manual
        longname:= Concatenation( bookinfo[1], " - ", bookinfo[2] );
        dirs:= [ bookinfo[3] ];
      else
        # one of the main manuals
        longname:= bookinfo[2];
        dirs:= DirectoriesLibrary( bookinfo[3] );
      fi;
      toadd:= getdata( Filename( dirs, "manual.six" ) );

      if toadd <> fail then

        for j in [ 1 .. Length( toadd.entries ) ] do
          toadd.entries[j][7]:= j;
        od;

        if not IsBound( toadd.handler ) then
          # Omit index entries.
          toadd:= Filtered( toadd.entries, x -> x[3] <> "I" );

          # Compute indices of function entries.
          lastindex:= [ 0, 0 ];
          for entry in toadd do
            if entry[3] = "F" then
              if lastindex = entry{ [ 4, 5 ] } then
                index:= index + 1;
              else
                index:= 1;
              fi;
              lastindex:= entry{ [ 4, 5 ] };
              entry[6]:= index;
            else
              entry[6]:= 0;
            fi;
          od;

          # We need the sorted information [ C, S, F, text, nr ].
          toadd:= List( toadd, x -> x{ [ 4, 5, 6, 1, 7 ] } );
          Sort( toadd );
        elif toadd.handler = "GapDocGAP" then
          # Omit title page, copyright, table of contents, bibliography,
          # index, and index entries.
          # We need the sorted information [ C, S, F, text, nr ].
          known:= [];
          toadd2:= [];
          for entry in toadd.entries do
            x:= entry[3];
            if x[1] <> 0 and not IsString( x[1] ) and not x in known then
              AddSet( known, Immutable( x ) );
              Add( toadd2, Concatenation( entry[3],
                [ StripEscapeSequences( entry[1] ), entry[7] ] ) );
            fi;
          od;
          toadd:= toadd2;
          Sort( toadd );
        fi;

        # Create a category row for each book, chapter, section, function;
        # they are not separated from each other and from data lines.
        Add( cats, rec( pos:= 2*i,
                        level:= 1,
                        value:= longname,
                        separator:= sep,
                        isUnderCollapsedCategory:= false,
                        isRejectedCategory:= false ) );
        for entry in toadd do
          Add( keys, [ book, entry[5], entry[3] = 0, entry[4] ] );
          str:= List( entry, String );
          str[4]:= BrowseData.SimplifiedString( str[4] );
          if entry[3] <> 0 then
            Add( cats, rec( pos:= 2*i,
                            level:= 4,
                            value:= Concatenation( str[1], ".", str[2], ".",
                                     str[3], " ", str[4] ),
                            separator:= sep,
                            isUnderCollapsedCategory:= true,
                            isRejectedCategory:= false ) );
          elif entry[2] <> 0 then
            Add( cats, rec( pos:= 2*i,
                            level:= 3,
                            value:= Concatenation( str[1], ".", str[2],
                                     " ", str[4] ),
                            separator:= sep,
                            isUnderCollapsedCategory:= true,
                            isRejectedCategory:= false ) );
          else
            Add( cats, rec( pos:= 2*i,
                            level:= 2,
                            value:= Concatenation( str[1], " ", str[4] ),
                            separator:= sep,
                            isUnderCollapsedCategory:= true,
                            isRejectedCategory:= false ) );
          fi;
          i:= i + 1;
        od;

      fi;
    od;

    if 'i' in start then
      # ``inline'':  Fetch a prescribed piece of the manual.
      manSection:= function( pos )
        local book, info1, from, info2, to, lines;

        book:= HELP_BOOK_INFO( HELP_KNOWN_BOOKS[1][ keys[ pos ][1] ] );
        info1:= HELP_BOOK_HANDLER.( book.handler ).HelpData( book,
                  keys[ pos ][2], "text" );
        from:= info1.start;
        if pos = Length( keys ) or keys[ pos+1 ][1] <> keys[ pos ][1] then
          info2:= info1;
        else
          # next piece of the manual, in the same book
          info2:= HELP_BOOK_HANDLER.( book.handler ).HelpData( book,
                    keys[ pos+1 ][2], "text" );
          if info2.lines = info1.lines then
            to:= info2.start;
          fi;
        fi;
        lines:= info1.lines;
        if IsString( lines ) then
          lines:= SplitString( lines, "\n" );
        fi;
        # Remove the chapter or section header.
        if book.handler = "GapDocGAP" then
          if keys[ pos ][3] or NormalizedWhitespace( lines[ from ] ) = "" then
            from:= from + 2;
          else
            # This happens for subsections generated with `<ManSection>'.
            from:= from + 1;
          fi;
          if not IsBound( to ) then
            to:= Length( lines ) + 1;
          fi;
          lines:= List( lines{ [ from .. to - 1 ] }, StripEscapeSequences );
          lines:= List( lines, BrowseData.SimplifiedString );
        elif keys[ pos ][3] then
          if not IsBound( to ) then
            to:= Length( lines );
          fi;
          while from <= to and lines[ from ] <> "" do
            from:= from + 1;
          od;
          lines:= lines{ [ from .. to ] };
          if from < to or lines[ Length( lines ) ] <> "" then
            Add( lines, "" );
          fi;
        fi;
        return rec( rows:= lines, align:= "l" );
      end;
      click:= rec();
    else
      # Use a pager for showing text from the manual.
      # If the user defined pager is "builtin" then we replace the pager
      # by `NCurses.Pager', otherwise we give the control to the user defined
      # pager.
      sel_action:= rec(
        helplines:= [ "open the chosen manual part in a pager" ],
        action:= function( t )
          local pos, showfun;
          if t.dynamic.selectedEntry <> [ 0, 0 ] then
            pos:= t.dynamic.indexRow[ t.dynamic.selectedEntry[1] ] / 2;
            showfun:= HELP_VIEWER_INFO.screen.show;
            if UserPreference( "Pager" ) = "builtin" then
              HELP_VIEWER_INFO.screen.show:= function( lines )
                if IsList( lines ) then
                  lines:= List( lines, StripEscapeSequences );
                elif IsString( lines.lines ) then
                  lines.lines:= StripEscapeSequences( lines.lines );
                  lines.lines:= BrowseData.SimplifiedString( lines.lines );
                else
                  lines.lines:= List( lines.lines, StripEscapeSequences );
                  lines.lines:= List( lines.lines, BrowseData.SimplifiedString );
                fi;
                NCurses.Pager( lines );
                NCurses.update_panels();
                NCurses.doupdate();
                NCurses.curs_set( 0 );
              end;
            fi;
            if BrowseData.IsDoneReplay( t.dynamic.replay ) then
              HELP_PRINT_MATCH( [ HELP_KNOWN_BOOKS[1][ keys[ pos ][1] ],
                                  keys[ pos ][2] ] );
              # Without the following `endwin' call, the pager `less'
              # does not return to the window with the browse table!
              NCurses.endwin();
              NCurses.update_panels();
              NCurses.doupdate();
              NCurses.curs_set( 0 );
            fi;
            # Reinstall the pager for "builtin".
            HELP_VIEWER_INFO.screen.show:= showfun;
          fi;
          return t.dynamic.changed;
        end );

      manSection:= function( pos )
        return rec( rows:= [ "        (hit <Enter> to show this part)" ],
                    align:= "l" );
      end;
      click:= rec(
          select_entry:= sel_action,
          select_row:= sel_action,
      );
    fi;

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "tl",
        header:= function( t )
          local pos;
          if   t.dynamic.selectedCategory <> [ 0, 0 ] then
            pos:= t.dynamic.selectedCategory[1];
          elif t.dynamic.selectedEntry <> [ 0, 0 ] then
            pos:= t.dynamic.selectedEntry[1];
          else
            pos:= t.dynamic.topleft[1] + ( t.dynamic.topleft[1] mod 2 );
          fi;
          return [ [ NCurses.attrs.UNDERLINE, true, "GAP Documentation: ",
                     HELP_KNOWN_BOOKS[2][ keys[ pos / 2 ][1] ][1] ], "" ];
        end,
        main:= [],
        Main:= function( t, i, j ) return manSection( i ); end,
        widthCol:= [ 0, width, 0 ],
        m:= Length( keys ),
        n:= 1,
        Click:= click,
        sepCategories:= sep,
        startCollapsedCategory:= [ [ NCurses.attrs.BOLD, true, "> ",
                                     NCurses.attrs.UNDERLINE, true ],
                                   [ NCurses.attrs.BOLD, true, "  > " ],
                                   [ NCurses.attrs.BOLD, true, "    > " ],
                                   ">       ",
                                 ],
        startExpandedCategory:= [ [ NCurses.attrs.BOLD, true, "* ",
                                    NCurses.attrs.UNDERLINE, true ],
                                  [ NCurses.attrs.BOLD, true, "  * " ],
                                  [ NCurses.attrs.BOLD, true, "    * " ],
                                  "*       ",
                                 ],
      ),
      dynamic:= rec(
        categories:= [ List( cats, x -> x.pos ), cats, [] ],
        isCollapsedRow:= List( [ 1 .. 2*Length( keys ) + 1 ], x -> true ),
      ),
    );
    table.dynamic.isCollapsedRow[1]:= false;

    # Set the initial steps, depending on `start'.
    if 'c' in start then
      table.dynamic.initialSteps:= "se";
    else
      table.dynamic.initialSteps:= "X";
    fi;

    # Show the table.
    NCurses.BrowseGeneric( table );
end );


#############################################################################
##
##  Add the Browse application to the list shown by `BrowseGapData'.
##
BrowseGapDataAdd( "GAP Manuals", BrowseGapManuals, false, "\
an overview of GAP documentation (main manuals and package manuals), \
in a browse table which is categorized hierarchically by book names \
and chapter, section, subsection headings; \
the actual contents is shown either inside the table or in a pager" );


#############################################################################
##
#E

