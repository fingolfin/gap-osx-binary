##############################################################################
##
#W  browse.gi             GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
DeclareUserPreference( rec(
    name:= "EnableMouseEvents",
    description:= [
"This user preference defines whether mouse events are enabled by default \
in visual mode (value 'true') or not (value 'false', this is the default).  \
During the &GAP; session, \
the value can be changed using 'NCurses.UseMouse'.  \
Inside browse applications based on 'NCurses.BrowseGeneric' \
or 'NCurses.Select', \
the value can be toggled usually by hitting the 'M' key." ],
    default:= false,
    values:= [ true, false ],
    multi:= false,
    ) );

if UserPreference( "Browse", "EnableMouseEvents" ) = true then
  NCurses.UseMouse( true );
fi;


#############################################################################
##
#V  BrowseData
##
BrowseData.actions:= rec();

BrowseData.defaults:= rec(
      work:= rec(

          # global positioning
          windowParameters:= [ 0, 0, 0, 0 ], # full window
          minyx:= [ 0, 0 ], # is replaced by functions below
          align:= "", # default: right and vertically centered

          # table data: five matrices, four separators
          # (no default for `main', the sixth matrix)
          header:= [],
          footer:= [],
          corner:= [],
          labelsCol:= [],
          labelsRow:= [],
          sepLabelsCol:= "",
          sepLabelsRow:= "",
          sepCol:= " ",
          sepRow:= "",

          cacheEntries:= false,

          cornerFormatted:= [],
          labelsColFormatted:= [],
          labelsRowFormatted:= [],
          mainFormatted:= [],

          Main:= false,

          heightRow:= [],
          widthCol:= [],
          heightLabelsCol:= [],
          widthLabelsRow:= [],

          # (at most) mode dependent lengths
          headerLength:= rec(),
          footerLength:= rec(),

          # how to fill missing entries
          emptyCell:= "",      # table cell data object

          # for categories feature
          sepCategories:= "-",
          startCollapsedCategory:= [ [ NCurses.attrs.BOLD, true, "> " ] ],
          startExpandedCategory:= [ [ NCurses.attrs.BOLD, true, "* " ] ],

          # how to mark a selected cell/row/column
          startSelect:= [ NCurses.attrs.STANDOUT, true ],

          # mode info (will be filled below)
          availableModes:= [],

          # customized modes
          customizedModes:= rec(),

          Click:= rec(),
        ),

      dynamic:= rec(

          # for the sort feature, will be filled with the table
          indexRow:= [],
          indexCol:= [],

          # topleft is [i, j, k, l]: entry[i][j] blockposition[k][l]
          topleft := [1, 1, 1, 1],
          isCollapsedCol:= [],
          isCollapsedRow:= [],
          isRejectedCol:= [],
          isRejectedRow:= [],
          isRejectedLabelsCol:= [],
          isRejectedLabelsRow:= [],

          # mode info (will be filled as soon as the `browse' mode is defined)
          activeModes:= [],

          # for selecting a cell or row or column or category
          selectedEntry:= [ 0, 0 ],
          selectedCategory:= [ 0, 0 ],

#T not used anymore, but some applications may rely on its presence
          useMouse:= false,

          # for the search feature
          searchString:= "",
          searchParameters:= [
            [ "case sensitive", [ "yes", "no" ], 2 ],
            [ "mode", [ "substring", "whole entry" ], 1 ],
            [ "search for", [ "any substring", "word", "prefix", "suffix" ],
              1, paras -> ForAny( paras, x -> x[1] = "mode" and x[3] = 1 ) ],
            [ "compare with",
              [ "\"<\"", "\"<=\"", "\"=\"", "\">=\"", "\">\"", "\"<>\"" ], 3,
              paras -> ForAny( paras, x -> x[1] = "mode" and x[3] = 2 ) ],
#T new option: "with wildcards *,?"
            [ "search", [ "forwards", "backwards" ], 1 ],
            [ "search", [ "row by row", "column by column" ], 1 ],
            [ "wrap around", [ "yes", "no" ], 1 ],
            [ "negate", [ "yes", "no" ], 2 ],
          ],

          # for the sort feature
          sortParametersForRows:= [],
          sortParametersForColumns:= [],
          sortParametersForRowsDefault:= [
            [ "direction", [ "ascending", "descending" ], 1 ],
            [ "case sensitive", [ "yes", "no" ], 1 ],
          ],
          sortParametersForColumnsDefault:= [
            [ "direction", [ "ascending", "descending" ], 1 ],
            [ "case sensitive", [ "yes", "no" ], 2 ],
            [ "hide on categorizing", [ "yes", "no" ], 1 ],
            [ "add counter on categorizing", [ "yes", "no" ], 2 ],
            [ "split rows on categorizing", [ "yes", "no" ], 2 ],
          ],
#T other parameters: as strings or numbers or via function,
#T                   secondary sort rows/columns
          sortFunctionsForRows:= [],
          sortFunctionsForColumns:= [],
          sortFunctionForTableDefault:= \<,
          sortFunctionForRowsDefault:= \<,
          sortFunctionForColumnsDefault:= \<,

          # for the categorizing feature
          categories:= [ [], [], [] ],

          # for the filtering feature
          filterParameters:= [
            [ "case sensitive", [ "yes", "no" ], 2 ],
            [ "mode", [ "substring", "whole entry" ], 1 ],
            [ "search for", [ "any substring", "word", "prefix", "suffix" ],
              1, paras -> ForAny( paras, x -> x[1] = "mode" and x[3] = 1 ) ],
            [ "compare with",
              [ "\"<\"", "\"<=\"", "\"=\"", "\">=\"", "\">\"", "\"<>\"" ], 3,
              paras -> ForAny( paras, x -> x[1] = "mode" and x[3] = 2 ) ],
#T new option: "with wildcards *,?"
            [ "negate", [ "yes", "no" ], 2 ],
          ],

          # for the replay feature
          replayDefaults:= rec(
            steps:= [],
            position:= 1,
            replayInterval:= 200,
            quiet:= false,
          ),

          # for the logging feature
          log:= [],
      ),
     );


#############################################################################
##
#F  BrowseData.MinimalWindowHeight( <t> )
#F  BrowseData.MinimalWindowWidth( <t> )
##
BrowseData.MinimalWindowHeight:= function( t )
    local height;

    height:= BrowseData.HeightLabelsColTable( t ) +
             BrowseData.HeightRow( t, 1 ) +
             BrowseData.HeightRow( t, 2 );
    if IsList( t.work.header ) then
      height:= height + Length( t.work.header );
    fi;
    if IsList( t.work.footer ) then
      height:= height + Length( t.work.footer );
    fi;

    return height;
end;

BrowseData.MinimalWindowWidth:= function( t )
    return BrowseData.WidthLabelsRowTable( t ) +
           BrowseData.WidthCol( t, 1 ) +
           BrowseData.WidthCol( t, 2 );
end;

BrowseData.defaults.work.minyx:= [ BrowseData.MinimalWindowHeight,
                                   BrowseData.MinimalWindowWidth ];


#############################################################################
##
#F  BrowseData.IsBrowseTableCellData( <obj> )
##
##  <#GAPDoc Label="IsBrowseTableCellData_man">
##  <ManSection>
##  <Func Name="BrowseData.IsBrowseTableCellData" Arg="obj"/>
##
##  <Returns>
##  <K>true</K> if the argument is a list or a record in a supported format.
##  </Returns>
##
##  <Description>
##  A <E>table cell data object</E> describes the input data for the contents
##  of a cell in a browse table.
##  It is represented by either an attribute line
##  (see&nbsp;<Ref Func="NCurses.IsAttributeLine"/>),
##  for cells of height one, or a list of attribute lines
##  or a record with the components <C>rows</C>, a list of attribute lines,
##  and optionally <C>align</C>, a substring of <C>"bclt"</C>,
##  which describes the alignment of the attribute lines in the table cell
##  -- bottom, horizontally centered, left, and top alignment;
##  the default is right and vertically centered alignment.
##  (Note that the height of a table row and the width of a table column
##  can be larger than the height and width of an individual cell.)
##  <P/>
##  <Example><![CDATA[
##  gap> BrowseData.IsBrowseTableCellData( "abc" );
##  true
##  gap> BrowseData.IsBrowseTableCellData( [ "abc", "def" ] );
##  true
##  gap> BrowseData.IsBrowseTableCellData( rec( rows:= [ "ab", "cd" ],
##  >                                           align:= "tl" ) );
##  true
##  gap> BrowseData.IsBrowseTableCellData( "" );
##  true
##  gap> BrowseData.IsBrowseTableCellData( [] );
##  true
##  ]]></Example>
##  <P/>
##  The <E>empty string</E> is a table cell data object of height one and
##  width zero whereas the <E>empty list</E>
##  (which is not in <Ref Func="IsStringRep" BookName="ref"/>)
##  is a table cell data object of height zero and width zero.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BrowseData.IsBrowseTableCellData:=
    obj -> NCurses.IsAttributeLine( obj ) or
       ( IsDenseList( obj ) and ForAll( obj, NCurses.IsAttributeLine ) ) or
       ( IsRecord( obj ) and IsBound( obj.rows ) and IsDenseList( obj.rows )
                         and ForAll( obj.rows, NCurses.IsAttributeLine ) );


#############################################################################
##
#F  BrowseData.IsModeRecord( <obj> )
##
BrowseData.IsModeRecord:=
    obj -> IsRecord( obj ) and
           IsBound( obj.name ) and IsString( obj.name ) and
           IsBound( obj.flag ) and IsString( obj.flag ) and
           IsBound( obj.ShowTables ) and IsFunction( obj.ShowTables ) and
           IsBound( obj.actions ) and IsList( obj.actions ) and
           ForAll( obj.actions,
             x -> IsList( x ) and Length( x ) = 3
                  and IsList( x[1] )
                  and ForAll( x[1], y -> IsPosInt( y )
                                         or y in NCurses.mouseEvents )
                  and IsRecord( x[2] ) and IsBound( x[2].helplines )
                  and IsList( x[2].helplines )
                  and ForAll( x[2].helplines, NCurses.IsAttributeLine )
                  and IsBound( x[2].action ) and IsFunction( x[2].action )
                  and IsString( x[3] ) and not IsEmpty( x[3] ) );


#############################################################################
##
#F  BrowseData.IsBrowseTable( <obj> )
##
##  <#GAPDoc Label="IsBrowseTable_man">
##  <ManSection>
##  <Func Name="BrowseData.IsBrowseTable" Arg="obj"/>
##
##  <Returns>
##  <K>true</K> if the argument record has the required components
##  and is consistent.
##  </Returns>
##
##  <Description>
##  A <E>browse table</E> is a &GAP; record that can be used as the first
##  argument of the function <Ref Func="NCurses.BrowseGeneric"/>.
##  <P/>
##  The supported components of a browse table are <C>work</C> and
##  <C>dynamic</C>, their values must be records:
##  The components in <C>work</C> describe that part of the data that
##  are not likely to depend on user interactions,
##  such as the table entries and their heights and widths.
##  The components in <C>dynamic</C> describe that part of the data that
##  is intended to change with user interactions,
##  such as the currently shown top-left entry of the table,
##  or the current status w.r.t. sorting.
##  For example, suppose you call <Ref Func="NCurses.BrowseGeneric"/> twice
##  with the same browse table;
##  the second call enters the table in the same status where it was left
##  <E>after</E> the first call if the component <C>dynamic</C> is kept,
##  whereas one has to reset (which usually simply means to unbind) the
##  component <C>dynamic</C> if one wants to start in the same status as
##  <E>before</E> the first call.
##  <P/>
##  The following components are the most important ones for standard browse
##  applications.
##  All these components belong to the <C>work</C> record.
##  For other supported components (of <C>work</C> as well as of
##  <C>dynamic</C>) and for the meaning of the term <Q>mode</Q>,
##  see Section&nbsp;<Ref Sect="sec:modes"/>.
##
##  <List>
##  <Mark><C>main</C></Mark>
##  <Item>
##    is the list of lists of table cell data objects that form the matrix
##    to be shown.
##    There is no default for this component.
##    (It is possible to compute the entries of the main table on demand,
##    see the description of the component <C>Main</C>
##    in Section&nbsp;<Ref Subsect="BrowseData"/>.
##    In this situation, the value of the component <C>main</C> can be an
##    empty list.)
##  </Item>
##  <Mark><C>header</C></Mark>
##  <Item>
##    describes a header that shall be shown above the column labels.
##    The value is either a list of attribute lines (<Q>static header</Q>)
##    or a function or a record whose component names are names of
##    available modes of the browse table (<Q>dynamic header</Q>).
##    In the function case, the function must take the browse table as its
##    only argument, and return a list of attribute lines.
##    In the record case, the values of the components must be such
##    functions.
##    It is assumed that the number of these lines depends at most on the
##    mode.
##    The default is an empty list, i.&nbsp;e., there is no header.
##  </Item>
##  <Mark><C>footer</C></Mark>
##  <Item>
##    describes a footer that shall be shown below the table.
##    The value is analogous to that of <C>footer</C>.
##    The default is an empty list, i.&nbsp;e., there is no footer.
##  </Item>
##  <Mark><C>labelsRow</C></Mark>
##  <Item>
##    is a list of row label rows,
##    each being a list of table cell data objects.
##    These rows are shown to the left of the main table.
##    The default is an empty list, i.&nbsp;e., there are no row labels.
##  </Item>
##  <Mark><C>labelsCol</C></Mark>
##  <Item>
##    is a list of column information rows,
##    each being a list of table cell data objects.
##    These rows are shown between the header and the main table.
##    The default is an empty list, i.&nbsp;e., there are no column labels.
##  </Item>
##  <Mark><C>corner</C></Mark>
##  <Item>
##    is a list of lists of table cell data objects that are printed
##    in the upper left corner, i.&nbsp;e.,
##    to the left of the column label rows and above the row label columns.
##    The default is an empty list.
##  </Item>
##  <Mark><C>sepRow</C></Mark>
##  <Item>
##    describes the separators above and below rows of the main table
##    and of the row labels table.
##    The value is either an attribute line or a (not necessarily dense)
##    list of attribute lines.
##    In the former case, repetitions of the attribute line are used as
##    separators below each row and above the first row of the table;
##    in the latter case, repetitions of the entry at the first position
##    (if bound) are used above the first row, and repetitions of the last
##    bound entry before the <M>(i+2)</M>-th position (if there is such an
##    entry at all) are used below the <M>i</M>-th table row.
##    The default is an empty string,
##    which means that there are no row separators.
##  </Item>
##  <Mark><C>sepCol</C></Mark>
##  <Item>
##    describes the separators in front of and behind columns of the main
##    table and of the column labels table.
##    The format of the value is analogous to that of the component
##    <C>sepRow</C>;
##    the default is the string <C>" "</C> (whitespace of width one).
##  </Item>
##  <Mark><C>sepLabelsCol</C></Mark>
##  <Item>
##    describes the separators above and below rows of the column labels
##    table and of the corner table,
##    analogously to <C>sepRow</C>.
##    The default is an empty string,
##    which means that there are no column label separators.
##  </Item>
##  <Mark><C>sepLabelsRow</C></Mark>
##  <Item>
##    describes the separators in front of and behind columns of the row
##    labels table and of the corner table,
##    analogously to <C>sepCol</C>.
##    The default is an empty string.
##  </Item>
##  </List>
##
##  We give a few examples of standard applications.
##  <P/>
##  The first example defines a small browse table by prescribing only the
##  component <C>work.main</C>,
##  so the defaults for row and column labels (no such labels),
##  and for separators are used.
##  The table cells are given by plain strings, so they have height one.
##  Usually this table will fit on the screen.
##  <P/>
##  <Example><![CDATA[
##  gap> m:= 10;;  n:= 5;;
##  gap> xpl1:= rec( work:= rec(
##  >      main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
##  >        j -> String( [ i, j ] ) ) ) ) );;
##  gap> BrowseData.IsBrowseTable( xpl1 );
##  true
##  ]]></Example>
##  <P/>
##  In the second example, also row and column labels appear,
##  and different separators are used.
##  The table cells have height three.
##  Also this table will usually fit on the screen.
##  <P/>
##  <Example><![CDATA[
##  gap> m:= 6;;  n:= 5;;
##  gap> xpl2:= rec( work:= rec(
##  >      main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
##  >        j -> rec( rows:= List( [ -i*j, i*j*1000+j, i-j ], String ),
##  >                  align:= "c" ) ) ),
##  >      labelsRow:= List( [ 1 .. m ], i -> [ String( i ) ] ),
##  >      labelsCol:= [ List( [ 1 .. n ], String ) ],
##  >      sepRow:= "-",
##  >      sepCol:= "|",
##  >  ) );;
##  gap> BrowseData.IsBrowseTable( xpl2 );
##  true
##  ]]></Example>
##  <P/>
##  The third example additionally has a static header and a dynamic footer,
##  and the table cells involve attributes.
##  This table will usually not fit on the screen.
##  Note that <C>NCurses.attrs.ColorPairs</C> is available only if the
##  terminal supports colors, which can be checked using
##  <Ref Var="NCurses.attrs.has_colors"/>.
##  <P/>
##  <Example><![CDATA[
##  gap> m:= 30;;  n:= 25;;
##  gap> xpl3:= rec( work:= rec(
##  >      header:= [ "                    Example 3" ],
##  >      labelsRow:= List( [ 1 .. 30 ], i -> [ String( i ) ] ),
##  >      sepLabelsRow:= " % ",
##  >      sepLabelsCol:= "=",
##  >      sepRow:= "*",
##  >      sepCol:= " |",
##  >      footer:= t -> [ Concatenation( "top-left entry is: ",
##  >                          String( t.dynamic.topleft{ [ 1, 2] } ) ) ],
##  >  ) );;
##  gap> if NCurses.attrs.has_colors then
##  >   xpl3.work.main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
##  >     j -> rec( rows:= [ String( -i*j ),
##  >                        [ NCurses.attrs.BOLD, true,
##  >                          NCurses.attrs.ColorPairs[56+1], true,
##  >                          String( i*j*1000+j ),
##  >                          NCurses.attrs.NORMAL, true ],
##  >                          String( i-j ) ],
##  >               align:= "c" ) ) );
##  >   xpl3.work.labelsCol:= [ List( [ 1 .. 30 ], i -> [
##  >     NCurses.attrs.ColorPairs[ 56+4 ], true,
##  >     String( i ),
##  >     NCurses.attrs.NORMAL, true ] ) ];
##  > else
##  >   xpl3.work.main:= List( [ 1 .. m ], i -> List( [ 1 .. n ],
##  >     j -> rec( rows:= [ String( -i*j ),
##  >                        [ NCurses.attrs.BOLD, true,
##  >                          String( i*j*1000+j ),
##  >                          NCurses.attrs.NORMAL, true ],
##  >                          String( i-j ) ],
##  >               align:= "c" ) ) );
##  >   xpl3.work.labelsCol:= [ List( [ 1 .. 30 ], i -> [
##  >     NCurses.attrs.BOLD, true,
##  >     String( i ),
##  >     NCurses.attrs.NORMAL, true ] ) ];
##  > fi;
##  gap> BrowseData.IsBrowseTable( xpl3 );
##  true
##  ]]></Example>
##  <P/>
##  The fourth example illustrates that highlighting may not work properly
##  for browse tables containing entries whose attributes are not set with
##  explicit Boolean values, see <Ref Func="NCurses.IsAttributeLine"/>.
##  Call <Ref Func="NCurses.BrowseGeneric"/> with the browse table
##  <C>xpl4</C>, and select an entry (or a column or a row):
##  Only the middle row of each selected cell will be highlighted,
##  because only in this row, the color attribute is switched on with an
##  explicit <K>true</K>.
##  <P/>
##  <Example><![CDATA[
##  gap> xpl4:= rec(
##  >     defc:= NCurses.defaultColors,
##  >     wd:= Maximum( List( ~.defc, Length ) ),
##  >     ca:= NCurses.ColorAttr,
##  >     work:= rec(
##  >       header:= [ "Examples of NCurses.ColorAttr" ],
##  >       main:= List( ~.defc, i -> List( ~.defc,
##  >         j -> [ [ ~.ca( i, j ), String( i, ~.wd ) ],        # no true!
##  >                [ ~.ca( i, j ), true, String( "on", ~.wd ) ],
##  >                [ ~.ca( i, j ), String( j, ~.wd ) ] ] ) ),  # no true!
##  >       labelsRow:= List( ~.defc, i -> [ String( i ) ] ),
##  >       labelsCol:= [ List( ~.defc, String ) ],
##  >       sepRow:= "-",
##  >       sepCol:= [ " |", "|" ],
##  >  ) );;
##  gap> BrowseData.IsBrowseTable( xpl4 );
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BrowseData.IsBrowseTable:= function( obj )
    local result, work, comp, complen, dynamic, l, h, log;

    if not IsRecord( obj ) then
      Print( "#E  <obj> must be a record\n" );
      return false;
    fi;

    result:= true;

    if IsBound( obj.work ) then
      work:= obj.work;
      # windowParameters
      if IsBound( work.windowParameters ) then
        if not ( IsList( work.windowParameters ) and
                 Length( work.windowParameters ) = 4 and
                 ForAll( work.windowParameters,
                         x -> IsInt( x ) and 0 <= x ) ) then
          Print( "#E  <obj>.work.windowParameters must be a list ",
                 "of four nonnegative integers.\n" );
          result:= false;
        fi;
      fi;
      # align
      if IsBound( work.align ) then
        if not ( IsString( work.align ) and
                 IsSubset( "bclrt", Set( work.align ) ) ) then
          Print( "#E  <obj>.work.align must be a subset of \"bclrt\".\n" );
          result:= false;
        fi;
      fi;
      # header and headerLength, footer and footerLength
      for comp in [ "header", "footer" ] do
        if IsBound( work.( comp ) ) and
           not ( ( IsList( work.( comp ) ) and
                   ForAll( work.( comp ), NCurses.IsAttributeLine ) ) or
                 IsFunction( work.( comp ) ) or
                 ( IsRecord( work.( comp ) ) and
                   ForAll( RecNames( work.( comp ) ),
                           n -> IsFunction( work.( comp ).( n ) ) ) ) ) then
          Print( "#E  <obj>.work.", comp,
                 " must be a list of attribute lines\n",
                 "#E  or a function or a record of functions.\n" );
          result:= false;
        fi;
        complen:= Concatenation( comp, "Length" );
        if IsBound( work.( complen ) ) and
           not ( IsRecord( work.( complen ) ) and
                 ForAll( RecNames( work.( complen ) ),
                         n -> IsInt( work.( complen ).( n ) ) ) ) then
          Print( "#E  <obj>.work.", complen, " must be a record with ",
                 "integer values.\n" );
          result:= false;
        fi;
      od;
      # labelsCol, labelsRow, corner, main
      for comp in [ "labelsCol", "labelsRow", "corner", "main" ] do
        if IsBound( work.( comp ) ) and
           not ( IsList( work.( comp ) ) and
                 ForAll( work.( comp ),
                         x -> IsList( x ) and
                              ForAll( x,
                                BrowseData.IsBrowseTableCellData ) ) ) then
          Print( "#E  <obj>.work.", comp, " must be a list of lists ",
                 "of table cell data objects.\n" );
          result:= false;
        fi;
      od;
      # sepRow, sepCol, sepLabelsCol, sepLabelsRow
      for comp in [ "sepRow", "sepCol", "sepLabelsCol", "sepLabelsRow" ] do
        if IsBound( work.( comp ) ) and
           not ( NCurses.IsAttributeLine( work.( comp ) ) or
                 ( IsList( work.( comp ) ) and
                   ForAll( work.( comp ), NCurses.IsAttributeLine ) ) ) then
          Print( "#E  <obj>.work.", comp, " must be an attribute line or ",
                 "a list of attribute lines.\n" );
          result:= false;
        fi;
      od;
      # cacheEntries
      if IsBound( work.cacheEntries ) and
         not IsBool( work.cacheEntries ) then
        Print( "#E  <obj>.work.cacheEntries must be a Boolean.\n" );
        result:= false;
      fi;
      # cornerFormatted, labelsColFormatted, labelsRowFormatted, mainFormatted
      for comp in [ "cornerFormatted", "labelsColFormatted",
                    "labelsRowFormatted", "mainFormatted" ] do
        if IsBound( work.( comp ) ) and
           not ( IsList( work.( comp ) ) and
                 ForAll( work.( comp ), IsList ) and
                 ForAll( work.( comp ),
                   x -> ForAll( x,
                          y -> NCurses.IsAttributeLine( y ) or
                               ( IsList( y ) and
                                 ForAll( y,
                                   NCurses.IsAttributeLine ) ) ) ) ) then
          Print( "#E  <obj>.work.", comp,
                 " must be a matrix of (lists of) attribute lines.\n" );
          result:= false;
        fi;
      od;
      # m0, n0, m, n
      for comp in [ "m0", "n0", "m", "n" ] do
        if IsBound( work.( comp ) ) and
           not ( IsInt( work.( comp ) ) and 0 <= work.( comp ) ) then
          Print( "#E  <obj>.work.", comp,
                 " must be a nonnegative integer.\n" );
          result:= false;
        fi;
      od;
      # heightLabelsCol, widthLabelsRow, heightRow, widthCol
      for comp in [ "heightLabelsCol", "widthLabelsRow", "heightRow",
                    "widthCol" ] do
        if IsBound( work.( comp ) ) and
           not ForAll( work.( comp ), x -> IsInt( x ) and 0 <= x ) then
          Print( "#E  <obj>.work.", comp,
                 " must be a list of nonnegative integers.\n" );
          result:= false;
        fi;
      od;
      # emptyCell
      if IsBound( work.emptyCell ) and
         not BrowseData.IsBrowseTableCellData( work.emptyCell ) then
        Print( "#E  <obj>.work.emptyCell must be a ",
               "table cell data object.\n" );
        result:= false;
      fi;
      # sepCategories, startSelect
      for comp in [ "sepCategories", "startSelect" ] do
        if IsBound( work.( comp ) ) and
           not NCurses.IsAttributeLine( work.( comp ) ) then
          Print( "#E  <obj>.work.", comp, " must be an attribute line.\n" );
          result:= false;
        fi;
      od;
      # startCollapsedCategory, startExpandedCategory
      for comp in [ "startCollapsedCategory", "startExpandedCategory" ] do
        if IsBound( work.( comp ) ) and
           not ( IsList( work.( comp ) ) and
                 ForAll( work.( comp ), NCurses.IsAttributeLine ) ) then
          Print( "#E  <obj>.work.", comp,
                 " must be a list of attribute lines.\n" );
          result:= false;
        fi;
      od;
      # availableModes
      if IsBound( work.availableModes ) and
         not ( IsList( work.availableModes ) and
               ForAll( work.availableModes, BrowseData.IsModeRecord ) ) then
        Print( "#E  <obj>.work.availableModes must be a ",
               "list of mode records.\n" );
        result:= false;
      fi;
    fi;

    if IsBound( obj.dynamic ) then
      dynamic:= obj.dynamic;
      # indexRow, indexCol
      for comp in [ "indexRow", "indexCol" ] do
        if IsBound( dynamic.( comp ) ) then
          l:= dynamic.( comp );
          if not ( IsList( l ) and ForAll( l, IsPosInt ) ) then
            Print( "#E  <obj>.dynamic.", comp,
                   " must be a list of positive integers.\n" );
            result:= false;
          fi;
          if not ForAll( [ 2, 4 .. Length( l ) - 1 ],
                         i -> IsEvenInt( l[i] ) and l[ i+1 ] = l[i] + 1 ) then
            Print( "#E  in <obj>.dynamic.", comp,
                   ", the values at even positions\n",
                   "#E  and at the subsequent odd positions must be ",
                   "consecutive.\n" );
            result:= false;
          fi;
        fi;
      od;
      # topleft
      if IsBound( dynamic.topleft ) and
         not ( IsList( dynamic.topleft ) and
               Length( dynamic.topleft ) = 4 and
               ForAll( dynamic.topleft, IsPosInt ) ) then
        Print( "#E  <obj>.dynamic.topleft must be a list ",
               "of four positive integers.\n" );
        result:= false;
      fi;
      # isCollapsedRow, isCollapsedCol, isRejectedRow, isRejectedCol,
      # isRejectedLabelsRow, isRejectedLabelsCol
      for comp in [ "isCollapsedRow", "isCollapsedCol",
                    "isRejectedRow", "isRejectedCol",
                    "isRejectedLabelsRow", "isRejectedLabelsCol" ] do
        if IsBound( dynamic.( comp ) ) then
          l:= dynamic.( comp );
          if not ( IsList( dynamic.( comp ) ) and
                   ForAll( dynamic.( comp ), IsBool ) ) then
            Print( "#E  <obj>.dynamic.", comp,
                   " must be a list of Booleans.\n" );
            result:= false;
          fi;
          if IsBound( l[1] ) and l[1] then
            Print( "#E  in <obj>.dynamic.", comp,
                   ", the first entry must be `false'\n" );
            result:= false;
          fi;
          if not ForAll( [ 2, 4 .. Length( l ) - 1 ],
                         i -> l[ i+1 ] = l[i] ) then
            Print( "#E  in <obj>.dynamic.", comp,
                   ", the values at even positions\n",
                   "#E  and at the subsequent odd positions must be ",
                   "equal.\n" );
            result:= false;
          fi;
        fi;
      od;
      # activeModes
      if IsBound( dynamic.activeModes ) and
         not ( IsList( dynamic.activeModes ) and
               ForAll( dynamic.activeModes, BrowseData.IsModeRecord ) ) then
        Print( "#E  <obj>.dynamic.activeModes must be a ",
               "list of mode records.\n" );
        result:= false;
      fi;
      # selectedEntry, selectedCategory
      for comp in [ "selectedEntry", "selectedCategory" ] do
        if IsBound( dynamic.( comp ) ) and
           not ( IsList( dynamic.( comp ) ) and
                 Length( dynamic.( comp ) ) = 2 and
                 ForAll( dynamic.( comp ),
                         x -> IsInt( x ) and 0 <= x ) ) then
          Print( "#E  <obj>.dynamic.", comp,
                 " must be a list of two nonnegative integers.\n" );
          result:= false;
        fi;
      od;
      if IsBound( dynamic.selectedEntry ) and
         IsBound( dynamic.selectedCategory ) and
         dynamic.selectedEntry <> [ 0, 0 ] and
         dynamic.selectedCategory <> [ 0, 0 ] then
        Print( "#E  not both <obj>.dynamic.selectedEntry and ",
               "<obj>.dynamic.selectedCategory can be nonzero.\n" );
      fi;
      # searchString
      if IsBound( dynamic.searchString ) and
         not IsString( dynamic.searchString ) then
        Print( "#E  <obj>.dynamic.searchString must be a string.\n" );
      fi;
      # searchParameters (check?)
      # categories
      if IsBound( dynamic.categories ) then
        l:= dynamic.categories;
        if not ( IsDenseList( l ) and Length( l ) = 3
                                  and ForAll( l, IsList )
                                  and Length( l[1] ) = Length( l[2] )
                                  and ForAll( l[3], IsPosInt ) ) then
          Print( "#E  <obj>.dynamic.categories must be a list ",
                 "of three lists, the first two of the same length.\n" );
        elif not IsSortedList( l[1] ) then
          Print( "#E  <obj>.dynamic.categories[1] must be sorted.\n" );
        elif not ForAll( [ 1 .. Length( l[1] ) ],
                         i -> IsPosInt( l[1][i] ) and
                              IsRecord( l[2][i] ) and
                              IsBound( l[2][i].pos ) and
                              l[1][i] = l[2][i].pos and
                              IsBound( l[2][i].level ) and
                              IsPosInt( l[2][i].level ) and
                              IsBound( l[2][i].value ) and
                              NCurses.IsAttributeLine( l[2][i].value ) and
                              IsBound( l[2][i].separator ) and
                              NCurses.IsAttributeLine( l[2][i].separator ) and
                              IsBound( l[2][i].isUnderCollapsedCategory ) and
                              IsBool( l[2][i].isUnderCollapsedCategory ) and
                              IsBound( l[2][i].isRejectedCategory ) and
                              IsBool( l[2][i].isRejectedCategory ) ) then
          Print( "#E  <obj>.dynamic.categories is inconsistent.\n" );
        fi;
      fi;
      # replay
      if IsBound( dynamic.replay ) then
        h:= dynamic.replay;
        if not ( IsRecord( h ) and IsBound( h.logs )
                               and IsBound( h.pointer ) ) then
          Print( "#E  <obj>.dynamic.replay must be a record\n",
                 "#E  with the components `logs' and `pointer'.\n" );
        else
          for log in h.logs do
            if IsBound( log.steps ) and
               not ( IsList( log.steps )
                     and ForAll( log.steps, IsPosInt ) ) then
              Print( "#E  <obj>.dynamic.replay.logs[...].steps must be ",
                     "a list of positive integers.\n" );
            fi;
            if IsBound( log.position ) and not IsPosInt( log.position ) then
              Print( "#E  <obj>.dynamic.replay.logs[...].position must be ",
                     "a positive integer.\n" );
            fi;
            if IsBound( log.replayInterval ) and
               not ( IsInt( log.replayInterval )
                     and 0 <= log.replayInterval ) then
              Print( "#E  <obj>.dynamic.replay.logs[...].replayInterval ",
                     "must be a nonnegative integer.\n" );
            fi;
            if IsBound( log.quiet ) and not IsBool( log.quiet ) then
              Print( "#E  <obj>.dynamic.replay.logs[...].quiet must be ",
                     "a Boolean.\n" );
            fi;
          od;
        fi;
      fi;
      if IsBound( dynamic.log ) then
        if not IsList( dynamic.log ) then
          Print( "#E  <obj>.dynamic.log must be a list.\n" );
        fi;
      fi;
    fi;

    # The object might be a valid input for `NCurses.BrowseGeneric'.
    return result;
end;


#############################################################################
##
#F  BrowseData.HeightWidthWindow( <t> )
##
##  It may happen that there is no component `<t>.dynamic.window';
##  in this case, we use `<t>.work.windowParameters'.
##
BrowseData.HeightWidthWindow:= function( t )
    if t.work.windowParameters{ [ 1, 2 ] } = [ 0, 0 ] then
      return NCurses.getmaxyx( 0 );
    else
      return t.work.windowParameters{ [ 1, 2 ] };
    fi;
end;


#############################################################################
##
#F  BrowseData.SortStableIndirection( <list1>, <list2>, <funs>, <direction> )
##
##  Let <list1> and <list2> be lists of the same length $n$, say,
##  and <funs> be a list of comparison functions (cf. "ref:Sort").
##  `BrowseData.SortStableIndirection' returns the list of length $n$
##  that contains the entries of <list2> in the order that is obtained by
##  sorting <list1> and <list2> in parallel (cf. "ref:SortParallel"),
##  where two entries of <list1> are compared w.r.t. <funcs>,
##  and additionally equal entries in <list1> are compared
##  via the corresponding entries in <list2> (w.r.t. `\<').
##
##  <direction> must be one of `"ascending"' or `"descending"',
##  the latter means that `true' and `false' for the comparison of
##  different values are interchanged.
##
BrowseData.SortStableIndirection:= function( list1, list2, funcs, direction )
    list1:= List( [ 1 .. Length( list1 ) ], i -> [ list1[i], list2[i] ] );
    Sort( list1, function( a, b )
                   local i;

                   for i in [ 1 .. Length( funcs ) ] do
                     if a[1][i] <> b[1][i] then
                       if funcs[i]( a[1][i], b[1][i] ) then
                         return direction[i] = "ascending";
                       else
                         return direction[i] <> "ascending";
                       fi;
                     fi;
                   od;
                   return a[2] < b[2];
                 end );
    return List( list1, x -> x[2] );
end;


#############################################################################
##
#F  BrowseData.IsDoneReplay( <replay> )
##
BrowseData.IsDoneReplay:= function( replay )
    while replay.pointer <= Length( replay.logs ) and
          replay.logs[ replay.pointer ].position
              > Length( replay.logs[ replay.pointer ].steps ) do
      replay.pointer:= replay.pointer + 1;
    od;
    return Length( replay.logs ) < replay.pointer;
end;


#############################################################################
##
#F  BrowseData.IsQuietSession( <replay> )
##
BrowseData.IsQuietSession:= function( replay )
    local pointer;

    if not NCurses.IsStdoutATty() then
      return true;
    fi;
    pointer:= replay.pointer;
    while pointer <= Length( replay.logs ) and
          replay.logs[ pointer ].position
              > Length( replay.logs[ pointer ].steps ) do
      pointer:= pointer + 1;
    od;
    return pointer <= Length( replay.logs ) and replay.logs[ pointer ].quiet;
end;


#############################################################################
##
#F  BrowseData.NextReplay( <replay> )
##
BrowseData.NextReplay:= function( replay )
    local currlog;

    while replay.pointer <= Length( replay.logs ) and
          replay.logs[ replay.pointer ].position
              > Length( replay.logs[ replay.pointer ].steps ) do
      replay.pointer:= replay.pointer + 1;
    od;
    currlog:= replay.logs[ replay.pointer ];
    currlog.position:= currlog.position + 1;
    return currlog.steps[ currlog.position - 1 ];
end;


#############################################################################
##
#T  BrowseData.SetReplay( <data> )
#F  BrowseData.SetReplay( false )
##
##  <#GAPDoc Label="SetReplay_man">
##  <ManSection>
##  <Func Name="BrowseData.SetReplay" Arg="data"/>
##
##  <Description>
##  This function sets and resets the value of
##  <C>BrowseData.defaults.dynamic.replay</C>.
##  <P/>
##  When <Ref Func="BrowseData.SetReplay"/> is called with a list <A>data</A>
##  as its argument then the entries are assumed to describe user inputs for
##  a browse table for which <Ref Func="NCurses.BrowseGeneric"/> will be
##  called afterwards, such that replay of the inputs runs.
##  (Valid input lists can be obtained from the component <C>dynamic.log</C>
##  of the browse table in question.)
##  <P/>
##  When <Ref Func="BrowseData.SetReplay"/> is called with the only argument
##  <K>false</K>,
##  the component is unbound (so replay is disabled, and thus calls to
##  <Ref Func="NCurses.BrowseGeneric"/> will require interactive user input).
##  <P/>
##  The replay feature should be used by initially setting the input list,
##  then running the replay (perhaps several times),
##  and finally unbinding the inputs,
##  such that subsequent uses of other browse tables do not erroneously
##  expect their input in <C>BrowseData.defaults.dynamic.replay</C>.
##  <P/>
##  Note that the value of <C>BrowseData.defaults.dynamic.replay</C> is used
##  in a call to <Ref Func="NCurses.BrowseGeneric"/> only if the browse table
##  in question does not have a component <C>dynamic.replay</C> before the
##  call.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
#T Admit more optional arguments, in order to prescribe intervals,
#T and eventually admit also records that are checked for consistency.
##
BrowseData.SetReplay:= function( arg )
    local log, data;

    if Length( arg ) = 1 and arg[1] = false then
      # Remove the stored value.
      Unbind( BrowseData.defaults.dynamic.replay );
    elif Length( arg ) = 1 and IsList( arg[1] ) then
      # Wrap the input list into a replay record.
      data:= rec( logs:= [ rec( steps:= arg[1] ) ], pointer:= 1 );
      BrowseData.defaults.dynamic.replay:= data;
#   elif Length( arg ) = 1 and IsRecord( arg[1] ) then
#     # Validate and set the record.
# Error( "not yet ..." );
    else
      Error( "BrowseData.SetReplay( <data> ) where <data> must be\n",
#            "`false' or a list of input characters/numbers or a record" );
             "`false' or a list of input characters/numbers" );
    fi;
end;


#############################################################################
##
#F  BrowseData.GetCharacter( <t> )
##
##  If <C>BrowseData.IsDoneReplay</C>
##  <Index Key="BrowseData.IsDoneReplay">
##  <C>BrowseData.IsDoneReplay</C></Index>
##  returns <K>true</K> for <A>t</A> then
##  get the next user input interactively,
##  otherwise read one character from <A>t</A><C>.dynamic.replay</C>.
##  <P/>
##  Add this character to the list <A>t</A><C>.dynamic.log</C> if the current
##  list of logs is not the first one.
##
BrowseData.GetCharacter:= function( t )
    local c, replay, currlog;

    if t = fail then
      c:= NCurses.wgetch( 0 );
      if c = NCurses.keys.MOUSE then
        c:= [ c, NCurses.GetMouseEvent() ];
      fi;
      return c;
    fi;
    replay:= t.dynamic.replay;
    if BrowseData.IsDoneReplay( replay ) then
      if not IsBound( t.dynamic.window ) then
        NCurses.SetTerm();
        NCurses.curs_set( 0 );
        t.dynamic.window:= CallFuncList( NCurses.newwin,
                                         t.work.windowParameters );
        t.dynamic.panel:= NCurses.new_panel( t.dynamic.window );
      fi;
      c:= NCurses.wgetch( t.dynamic.window );
      if c = NCurses.keys.MOUSE then
        c:= [ c, NCurses.GetMouseEvent() ];
      fi;
    else
      currlog:= replay.logs[ replay.pointer ];
      c:= currlog.steps[ currlog.position ];
      if IsChar( c ) then
        c:= IntChar( c );
      fi;
      currlog.position:= currlog.position + 1;
      if not currlog.quiet then
        NCurses.napms( currlog.replayInterval );
      fi;
    fi;
    if 1 < replay.pointer then
      Add( t.dynamic.log, c );
    fi;

    return c;
end;


#############################################################################
##
#F  BrowseData.GetPatternEditParameters( <prefix>, <default>, <paras>
#F                                       [, <t>] )
##
##  This is based on the utility <Ref Func="NCurses.GetLineFromUser"/>.
##  In addition to a string, values for given parameters can be chosen.
##  <P/>
##  <A>prefix</A> is an attribute line shown in front of the editable region,
##  <A>default</A> is the default pattern.
##  <A>paras</A> must be a list of triples
##  <C>[ para, values, default ]</C>,
##  where <C>para</C> is a string denoting a parameter,
##  <C>values</C> is the list of admissible values, and
##  <C>default</C> is the position of the default value in this list.
##  <P/>
##  The optional argument <A>t</A> must be a browse table;
##  it is used only for logging/replay.
##  </P>
##  If the user hits the <B>Esc</B> key then the dialog is cancelled,
##  <A>paras</A> is left unchanged, and <K>fail</K> is returned.
##  If the user hits the <B>Enter</B> key then <A>paras</A> is changed
##  in place and the string entered by the user is returned.
##
BrowseData.GetPatternEditParameters:= function( arg )
    local prefix, default, paras, t, localparas, index, win, yx, res, off,
          max, empty, pos, ins, small, currpara, smallheight, bigheight,
          width, winposy, winposx, loop, height, pan, ret, line, row, para,
          i, c, data, pressdata, buttondown;

    if   Length( arg ) = 3 and NCurses.IsAttributeLine( arg[1] )
                           and IsString( arg[2] ) and IsList( arg[3] ) then
      prefix:= arg[1];
      default:= arg[2];
      paras:= arg[3];
      t:= fail;
    elif Length( arg ) = 4 and NCurses.IsAttributeLine( arg[1] )
                           and IsString( arg[2] ) and IsList( arg[3] )
                           and IsRecord( arg[4] ) then
      prefix:= arg[1];
      default:= arg[2];
      paras:= arg[3];
      t:= arg[4];
    else
      Error( "usage: BrowseData.GetPatternEditParameters( <prefix>, ",
             "<default>, <paras>[, <t>] )" );
    fi;
    if t = fail or BrowseData.IsQuietSession( t.dynamic.replay ) then
      win:= 0;
    else
      win:= t.dynamic.window;
    fi;

    localparas:= List( paras, ShallowCopy );
    index:= [];
    for para in localparas do
      if Length( para ) < 4 or para[4]( localparas ) then
        Add( index, Position( localparas, para ) );
      fi;
    od;

    yx:= NCurses.getmaxyx( win );
    res:= ShallowCopy( default );
    off:= NCurses.WidthAttributeLine( prefix );
    max:= yx[2] - 6 - off;
    empty:= RepeatedString( " ", yx[2] - 6 );
    pos:= Length( res ) + 1;
    ins:= true;
    small:= true;
    currpara:= 1;
    if Length( localparas ) = 0 then
      smallheight:= 3;
      bigheight:= 3;
    else
      smallheight:= 4;
      bigheight:= 5;
    fi;
    width:= yx[2] - 4;

    winposy:= yx[1] - bigheight - Length( localparas ) - 1;
    winposx:= 2;

    loop:= function()
      # Create the window.
      height:= smallheight;
      if not small then
        height:= bigheight + Number( localparas,
                                     x -> Length( x ) < 4 or x[4]( localparas ) );
        winposy:= Minimum( winposy, yx[1] - height - 1 );
      fi;
      ret:= false;
      win:= fail;

      repeat

        if win <> fail then
          NCurses.del_panel( pan );
          NCurses.delwin( win );
        fi;
        if t <> fail and not BrowseData.IsQuietSession( t.dynamic.replay ) then
          NCurses.hide_panel( t.dynamic.statuspanel );
        fi;
        if t = fail or not BrowseData.IsQuietSession( t.dynamic.replay ) then
          win:= NCurses.newwin( height, width, winposy, winposx );
          pan:= NCurses.new_panel( win );
          NCurses.savetty();
          NCurses.SetTerm();
          NCurses.curs_set( 1 );
          NCurses.werase( win );
          if small then
            NCurses.wattrset( win, NCurses.attrs.BOLD );
            NCurses.wborder( win, 0 );
            NCurses.wattrset( win, NCurses.attrs.NORMAL );
          else
            NCurses.GridExt( win, rec(
              trow:= 0,
              brow:= height - 1,
              lcol:= 0,
              rcol:= yx[2] - 5,
              rowinds:= [ 0, 2, height - 1 ],
              colinds:= [ 0, yx[2] - 5 ] ), NCurses.attrs.BOLD );
          fi;

          # Show the dialog box.
          NCurses.PutLine( win, 1, 1, empty );
          line:= NCurses.ConcatenationAttributeLines(
                     [ prefix, [ NCurses.attrs.NORMAL, res ] ] );
          NCurses.PutLine( win, 1, 1, line );
          NCurses.wmove( win, 1, NCurses.WidthAttributeLine( line ) );
          if small then
            if 0 < Length( localparas ) then
              NCurses.PutLine( win, 2, 1, "(down to edit parameters)" );
            fi;
          else
            row:= 3;
            index:= [];
            for para in localparas do
              if Length( para ) < 4 or para[4]( localparas ) then
                Add( index, Position( localparas, para ) );
                line:= ShallowCopy( para[1] );
                for i in [ 1 .. Length( para[2] ) ] do
                  Append( line, "  [" );
                  if para[3] = i then
                    Add( line, 'X' );
                  else
                    Add( line, ' ' );
                  fi;
                  Append( line, "] " );
                  Append( line, para[2][i] );
                od;
                Append( line, RepeatedString( " ", yx[2] - 6 - Length( line ) ) );
#T admit distributing to two lines if necessary?
                if currpara + 2 = row then
                  line:= [ NCurses.attrs.STANDOUT, true, line ];
#T ... if yes then several rows may be marked here!
                fi;
                NCurses.PutLine( win, row, 1, line );
                row:= row + 1;
              fi;
            od;
            NCurses.PutLine( win, height - 2, 1,
         "(up/down to choose a parameter, left/right to change the value)" );
#T admit distributing to two lines if necessary
          fi;
          NCurses.wmove( win, 1, off + pos );
          NCurses.update_panels();
          NCurses.doupdate();
        fi;

        # Get a character and adjust the data.
        c:= BrowseData.GetCharacter( t );
        if   c = NCurses.keys.DOWN then
          if small then
            # Switch to the bigger window.
            ret:= true;
            break;
          elif currpara < Length( index ) then
            # Select the next parameter.
            currpara:= currpara + 1;
          fi;
        elif c = NCurses.keys.UP then
          if not small then
            if currpara > 1 then
              # Select the previous parameter.
              currpara:= currpara - 1;
            else
              # Switch to the small window.
              ret:= true;
              break;
            fi;
          fi;
        elif c = NCurses.keys.RIGHT then
          if small then
            if pos <= Length( res ) and pos < max then
              pos:= pos + 1;
            fi;
          else
            # Select the next value (with wrap around).
            localparas[ index[ currpara ] ][3]:= ( localparas[ index[ currpara ] ][3] mod
                Length( localparas[ index[ currpara ] ][2] ) ) + 1;
          fi;
        elif c = NCurses.keys.LEFT then
          if small then
            if pos > 1 then
              pos:= pos - 1;
            fi;
          else
            # Select the previous value (with wrap around).
            localparas[ index[ currpara ] ][3]:= ( ( localparas[ index[ currpara ] ][3] - 2 ) mod
                Length( localparas[ index[ currpara ] ][2] ) ) + 1;
          fi;
        elif c = NCurses.keys.IC then
          ins:= not ins;
        elif c = NCurses.keys.REPLACE then
          ins:= not ins;
        elif c in [ NCurses.keys.HOME, IntChar( '' ) ] then
          pos:= 1;
        elif c in [ NCurses.keys.END, IntChar( '' ) ] then
          pos:= Length( res ) + 1;
          if pos > max then
            pos:= pos - 1;
          fi;
        elif c in [ NCurses.keys.BACKSPACE, IntChar( '' ) ] then
          if pos > 1 then
            pos:= pos - 1;
            RemoveElmList( res, pos );
          fi;
        elif c in [ NCurses.keys.DC, IntChar( '' ) ] then
          if pos <= Length( res ) then
            RemoveElmList( res, pos );
          fi;
        elif IsList( c ) and c[1] = NCurses.keys.MOUSE then
          # If the first button is pressed on this window
          # then we expect that the dialog box shall be moved.
          # If the first button is released somewhere
          # then we move the alert box by the difference.
          data:= c[2];
          if 0 < Length( data ) then
            if   data[1].event = "BUTTON1_PRESSED" and data[1].win = win then
              pressdata:= data[ Length( data ) ];
              buttondown:= true;
            elif data[1].event = "BUTTON1_RELEASED" and buttondown then
              data:= data[ Length( data ) ];
              winposy:= Minimum( Maximum( 0, winposy + data.y - pressdata.y ),
                                 yx[1] - height );
              winposx:= Minimum( Maximum( 0, winposx + data.x - pressdata.x ),
                                 yx[2] - width );
              buttondown:= false;
            fi;
          fi;
        elif not c in [ NCurses.keys.ENTER, 
                        IntChar(NCurses.CTRL( 'M' )), 27 ] then
          if ins and Length( res ) < max then
            InsertElmList( res, pos, CHAR_INT( c mod 256 ) );
            pos:= pos + 1;
          elif not ins and pos <= max then
            res[ pos ]:= CHAR_INT( c mod 256 );
            pos:= pos + 1;
          fi;
        fi;
      until c in [ NCurses.keys.ENTER, IntChar(NCurses.CTRL( 'M' )), 27 ];

      if t <> fail and not BrowseData.IsQuietSession( t.dynamic.replay ) then
        NCurses.show_panel( t.dynamic.statuspanel );
      fi;

      if t = fail or not BrowseData.IsQuietSession( t.dynamic.replay ) then
        NCurses.del_panel( pan );
        NCurses.delwin( win );
        NCurses.resetty();
#       NCurses.endwin();
#T hier!
        NCurses.update_panels();
        NCurses.doupdate();
      fi;

      return ret;
    end;

    while loop() do
      if 0 < Length( localparas ) then
        small:= not small;
      fi;
    od;

    # Decide whether the user cancelled or submitted.
    if c = 27 then
      return fail;
    else
      for i in [ 1 .. Length( localparas ) ] do
        paras[i]:= localparas[i];
      od;
      return res;
    fi;
end;


#############################################################################
##
#F  BrowseData.CurrentMode( <t> )
##
BrowseData.CurrentMode:= t -> t.dynamic.activeModes[
                                  Length( t.dynamic.activeModes ) ];


#############################################################################
##
#F  BrowseData.PushMode( <t>, <modename> )
##
BrowseData.PushMode:= function( t, modename )
    local mode;

    mode:= First( t.work.availableModes, x -> x.name = modename );
    if mode <> fail then
      Add( t.dynamic.activeModes, mode );
      t.dynamic.changed:= true;
      return true;
    fi;
    return false;
end;


#############################################################################
##
#F  BrowseData.NumberFreeCharacters( <t>, <direction> )
##
##  If <direction> is `"vert"' then the return value is the number of rows in
##  the window of <t>, minus the number of rows needed for the column labels,
##  the header, and the footer;
##  otherwise the return value is the number of columns in the window of <t>,
##  minus the number of columns needed for the row labels.
##
BrowseData.NumberFreeCharacters := function( t, direction )
    local s, mode, header, footer;

    if direction = "vert" then
      s:= BrowseData.HeightWidthWindow( t )[1]
          - BrowseData.HeightLabelsColTable( t );
      mode:= BrowseData.CurrentMode( t ).name;
      header:= t.work.header;
      if   IsList( header ) then
        s:= s - Length( header );
      elif IsFunction( header ) then
        if not IsBound( t.work.headerLength.( mode ) ) then
          t.work.headerLength.( mode ):= Length( header( t ) );
        fi;
        s:= s - t.work.headerLength.( mode );
      elif IsRecord( header ) and IsBound( header.( mode ) ) then
        if not IsBound( t.work.headerLength.( mode ) ) then
          t.work.headerLength.( mode ):= Length( header.( mode )( t ) );
        fi;
        s:= s - t.work.headerLength.( mode );
      fi;
      footer:= t.work.footer;
      if   IsList( footer ) then
        s:= s - Length( footer );
      elif IsFunction( footer ) then
        if not IsBound( t.work.footerLength.( mode ) ) then
          t.work.footerLength.( mode ):= Length( footer( t ) );
        fi;
        s:= s - t.work.footerLength.( mode );
      elif IsRecord( footer ) and IsBound( footer.( mode ) ) then
        if not IsBound( t.work.footerLength.( mode ) ) then
          t.work.footerLength.( mode ):= Length( footer.( mode )( t ) );
        fi;
        s:= s - t.work.footerLength.( mode );
      fi;
    else
      s:= BrowseData.HeightWidthWindow( t )[2]
          - BrowseData.WidthLabelsRowTable( t );
    fi;
    return s;
end;


#############################################################################
##
#F  BrowseData.Separator( <sep>, <i> )
##
BrowseData.Separator:= function( sep, i )
    local result, j;

    if NCurses.IsAttributeLine( sep ) then
      result:= sep;
    else
      # a list of attribute lines
      result:= "";
      j:= i;
      while 0 < j and not IsBound( sep[j] ) do
        j:= j-1;
      od;
      if 0 < j then
        result:= sep[j];
        sep[i]:= result;
      fi;
    fi;
    return result;
end;


#############################################################################
##
#F  BrowseData.HeightCategories( <t>, <i>[, <l>] )
##
##  is the number of rows that are currently needed for the categories of
##  the <i>-th row of (the main matrix in) the browse table <t>,
##  including category separator rows.
##  If the optional argument <l> is given, only categories up to level <l>
##  are considered.
##  Note that collapsed/rejected categories do not count.
##
BrowseData.HeightCategories := function( arg )
    local t, i, l, cat, cats, k, len, entry;

    t:= arg[1];
    i:= arg[2];
    if Length( arg ) = 2 then
      l:= infinity;
    else
      l:= arg[3];
    fi;
    cat:= 0;
    cats:= t.dynamic.categories;
    k:= PositionSorted( cats[1], i );
    cats:= cats[2];
    len:= Length( cats );
    while k <= len do
      entry:= cats[k];
      if i < entry.pos
         or l < entry.level
         or entry.isUnderCollapsedCategory
         or entry.isRejectedCategory then
        break;
      else
        cat:= cat + 1;
        # If there is a category separator and the category is expanded
        # then also the separator counts.
        if NCurses.WidthAttributeLine( entry.separator ) <> 0 then
          if   k = len then
            if ForAny( [ i .. Length( t.dynamic.indexRow ) ],
                   x -> not BrowseData.IsHiddenCell( t, x, "vert" ) ) then
              cat:= cat + 1;
            fi;
          elif i < cats[ k+1 ].pos then
            if ForAny( [ i .. cats[ k+1 ].pos - 1 ],
                   x -> not BrowseData.IsHiddenCell( t, x, "vert" ) ) then
              cat:= cat + 1;
            fi;
          elif not ( cats[ k+1 ].isUnderCollapsedCategory
                     or cats[ k+1 ].isRejectedCategory ) then
            cat:= cat + 1;
          fi;
        fi;
      fi;
      k:= k + 1;
    od;

    return cat;
end;


#############################################################################
##
#F  BrowseData.HeightRow( <t>, <i> )
##
##  is the height of the <i>-th row of the `main' or `mainFormatted' matrix
##  in the browse table <t>.
##  Both row labels and entries of the main matrix are considered.
##  Hidden rows have height zero.
##
BrowseData.HeightRow := function( t, i )
    local result, k, mainfun, isfun, empty, row1, row2, j, entry, w;

    if BrowseData.IsHiddenCell( t, i, "vert" ) then
      return 0;
    fi;
    i:= t.dynamic.indexRow[i];
    if IsBound( t.work.heightRow[i] ) then
      return t.work.heightRow[i];
    fi;
    result:= 0;
    if i mod 2 = 1 then
      # This row is a separator row.
      if NCurses.WidthAttributeLine( BrowseData.Separator(
             t.work.sepRow, ( i + 1 ) / 2  ) ) <> 0 then
        result:= 1;
#T admit arbitrary heights for separators?
      fi;
    else
      k:= i/2;
      mainfun:= t.work.Main;
      isfun:= IsFunction( mainfun );
      empty:= t.work.emptyCell;
      row1:= [];
      row2:= [];
      if IsBound( t.work.mainFormatted[i] ) then
        row1:= t.work.mainFormatted[i];
      fi;
      if IsBound( t.work.main[k] ) then
        row2:= t.work.main[k];
      fi;
      for j in [ 1 .. t.work.n ] do
        if   IsBound( row1[ 2*j ] ) then
          entry:= row1[ 2*j ];
        elif IsBound( row2[j] ) then
          entry:= row2[j];
        elif isfun then
          entry:= mainfun( t, k, j );
        else
          entry:= empty;
        fi;
        w:= BrowseData.HeightEntry( entry );
        if result < w then
          result:= w;
        fi;
      od;
      if IsBound( t.work.labelsRow[k] ) then
        for entry in t.work.labelsRow[k] do
          w:= BrowseData.HeightEntry( entry );
          if result < w then
            result:= w;
          fi;
        od;
      fi;
    fi;
    t.work.heightRow[i]:= result;
    return result;
end;


#############################################################################
##
#F  BrowseData.HeightRowWithCategories( <t>, <i> )
##
BrowseData.HeightRowWithCategories := function( t, i )
    return BrowseData.HeightCategories( t, i )
           + BrowseData.HeightRow( t, i );
end;


#############################################################################
##
#F  BrowseData.HeightLabelsCol( <t>, <i> )
##
##  is the height of the <i>-th row of column labels in the browse table <t>.
##  Both corner rows and entries of the column label matrix are considered.
##  Hidden rows have height zero.
##
BrowseData.HeightLabelsCol := function( t, i )
    local result, k, entry, w;

    if   t.dynamic.isRejectedLabelsCol[i] then
      return 0;
    elif IsBound( t.work.heightLabelsCol[i] ) then
      return t.work.heightLabelsCol[i];
    fi;
    result:= 0;
    if i mod 2 = 1 then
      # This row is a separator row.
      if NCurses.WidthAttributeLine( BrowseData.Separator(
             t.work.sepLabelsCol, ( i + 1 ) / 2 ) ) <> 0 then
        result:= 1;
#T admit arbitrary heights for separators?
      fi;
    else
      k:= i/2;
      if IsBound( t.work.labelsCol[k] ) then
        for entry in t.work.labelsCol[k] do
          w:= BrowseData.HeightEntry( entry );
          if result < w then
            result:= w;
          fi;
        od;
      fi;
      if IsBound( t.work.corner[k] ) then
        for entry in t.work.corner[k] do
          w:= BrowseData.HeightEntry( entry );
          if result < w then
            result:= w;
          fi;
        od;
      fi;
    fi;
    t.work.heightLabelsCol[i]:= result;
    return result;
end;


#############################################################################
##
#F  BrowseData.WidthCol( <t>, <j> )
##
##  is the width of the <j>-th column of the `main' or `mainFormatted'
##  matrix in the browse table <t>.
##  Both column labels and entries of the main matrix are considered.
##  Hidden columns have width zero.
##
BrowseData.WidthCol := function( t, j )
    local result, k, mainfun, isfun, empty, i, row1, row2, entry, w, row;

    if BrowseData.IsHiddenCell( t, j, "horz" ) then
      return 0;
    fi;
    j:= t.dynamic.indexCol[j];
    if IsBound( t.work.widthCol[j] ) then
      return t.work.widthCol[j];
    fi;
    if j mod 2 = 1 then
      # This column is a separator column.
      result:= NCurses.WidthAttributeLine( BrowseData.Separator(
                   t.work.sepCol, ( j + 1 ) / 2 ) );
    else
      result:= 0;
      k:= j/2;
      mainfun:= t.work.Main;
      isfun:= IsFunction( mainfun );
      empty:= t.work.emptyCell;
      for i in [ 1 .. t.work.m ] do
        row1:= [];
        row2:= [];
        if IsBound( t.work.mainFormatted[ 2*i ] ) then
          row1:= t.work.mainFormatted[ 2*i ];
        fi;
        if IsBound( t.work.main[i] ) then
          row2:= t.work.main[i];
        fi;
        if   IsBound( row1[j] ) then
          entry:= row1[j];
        elif IsBound( row2[k] ) then
          entry:= row2[k];
        elif isfun then
          entry:= mainfun( t, i, k );
        else
          entry:= empty;
        fi;
        w:= BrowseData.WidthEntry( entry );
        if result < w then
          result:= w;
        fi;
      od;
      for row in t.work.labelsCol do
        if IsBound( row[k] ) then
          w:= BrowseData.WidthEntry( row[k] );
          if result < w then
            result:= w;
          fi;
        fi;
      od;
    fi;
    t.work.widthCol[j]:= result;
    return result;
end;


#############################################################################
##
#F  BrowseData.WidthLabelsRow( <t>, <j> )
##
##  is the width of the <j>-th column of row labels in the browse table <t>.
##  Both corner columns and entries of the row label matrix are considered.
##  Hidden columns have width zero.
##
BrowseData.WidthLabelsRow := function( t, j )
    local result, k, row, w;

    if   t.dynamic.isRejectedLabelsRow[j] then
      return 0;
    elif IsBound( t.work.widthLabelsRow[j] ) then
      return t.work.widthLabelsRow[j];
    fi;
    if j mod 2 = 1 then
      # This column is a separator column.
      result:= NCurses.WidthAttributeLine( BrowseData.Separator(
                   t.work.sepLabelsRow, ( j + 1 ) / 2 ) );
    else
      result:= 0;
      k:= j/2;
      for row in t.work.labelsRow do
        if IsBound( row[k] ) then
          w:= BrowseData.WidthEntry( row[k] );
          if result < w then
            result:= w;
          fi;
        fi;
      od;
      for row in t.work.corner do
        if IsBound( row[k] ) then
          w:= BrowseData.WidthEntry( row[k] );
          if result < w then
            result:= w;
          fi;
        fi;
      od;
    fi;
    t.work.widthLabelsRow[j]:= result;
    return result;
end;


#############################################################################
##
#F  BrowseData.HeightLabelsColTable( <t> )
#F  BrowseData.WidthLabelsRowTable( <t> )
##
BrowseData.HeightLabelsColTable := function( t )
    local result, i;

    result:= 0;
    for i in [ 1 .. 2 * t.work.m0 + 1 ] do
      result:= result + BrowseData.HeightLabelsCol( t, i );
    od;
    return result;
end;

BrowseData.WidthLabelsRowTable := function( t )
    local result, j;

    result:= 0;
    for j in [ 1 .. 2 * t.work.n0 + 1 ] do
      result:= result + BrowseData.WidthLabelsRow( t, j );
    od;
    return result;
end;


#############################################################################
##
#F  BrowseData.LengthCell( <t>, <i>, <direction> )
##
BrowseData.LengthCell := function( t, i, direction )
    if direction = "vert" then
      return BrowseData.HeightCategories( t, i )
             + BrowseData.HeightRow( t, i );
    else
      return BrowseData.WidthCol( t, i );
    fi;
end;


#############################################################################
##
#F  BrowseData.IsHiddenCell( <t>, <cell>, <direction> )
##
##  This is used in the search
##  but not in filtering (since this must consider also collapsed rows).
##
BrowseData.IsHiddenCell := function( t, cell, direction )
    if direction = "vert" then
      return Length( t.dynamic.isCollapsedRow ) < cell or
             t.dynamic.isCollapsedRow[ cell ] or
             t.dynamic.isRejectedRow[ cell ];
    else
      return Length( t.dynamic.isCollapsedCol ) < cell or
             t.dynamic.isCollapsedCol[ cell ] or
             t.dynamic.isRejectedCol[ cell ];
    fi;
end;


# first *unhidden* shown position!!
BrowseData.TopOrLeft := function( t, direction )
    local pos, len, curr, from;

    if direction = "vert" then
      pos:= 1;
      len:= Length( t.dynamic.indexRow );
    else
      pos:= 2;
      len:= Length( t.dynamic.indexCol );
    fi;

    curr:= t.dynamic.topleft[ pos ];
    from:= t.dynamic.topleft[ 2 + pos ];
    while curr <= len and BrowseData.LengthCell( t, curr, direction ) = 0 do
      curr:= curr + 1;
      from:= 1;
    od;
    if curr <= len then
      return [ curr, from ];
    else
      return fail;
    fi;
end;


BrowseData.SetTopOrLeft := function( t, direction, cell, from )
    local pos;

    if direction = "vert" then
      pos:= 1;
    else
      pos:= 2;
    fi;
    if t.dynamic.topleft{ [ pos, pos + 2 ] } <> [ cell, from ] then
      t.dynamic.changed:= true;
      t.dynamic.topleft{ [ pos, pos + 2 ] }:= [ cell, from ];
    fi;
end;


#############################################################################
##
#F  BrowseData.BottomOrRight( <t>, <direction> )
##
##  Let <t> be a browse table,
##  <cell> be the number of the current topmost/leftmost position on the
##  screen,
##  <from> be the topmost/leftmost visible character in this cell,
##  and <direction> be `"vert"' or `"horz"' if we are interested in vertical
##  or horizontal orientation.
##
##  If the row or column labels require (at least) the whole window width
##  or height, respectively, then `fail' is returned.
##  If the bottommost/rightmost part of the table is visible on the screen
##  then the return value is the (nonnegative) number of free characters
##  below/to the right of the table.
##  If the last row/column of the table is not visible on the screen then
##  the return value is a list $[ i, k ]$ where the last visible cell has the
##  number $i$ such that exactly $k$ characters of this cell are visible.
##  (In the case of rows, part of these $k$ can be occupied by category rows.)
##
BrowseData.BottomOrRight := function( t, direction )
    local dist, perm, pos, width, cell, from, n;

    if direction = "vert" then
      dist:= BrowseData.HeightRow;
      perm:= t.dynamic.indexRow;
      pos:= 1;
    else
      dist:= BrowseData.WidthCol;
      perm:= t.dynamic.indexCol;
      pos:= 2;
    fi;
    width:= BrowseData.NumberFreeCharacters( t, direction );
    if width <= 0 then
      return fail;
    fi;
    cell:= t.dynamic.topleft[ pos ];
    from:= t.dynamic.topleft[ 2 + pos ];
    while IsBound( perm[ cell ] ) do
      if direction = "vert" then
        n:= BrowseData.HeightCategories( t, cell );
      else
        n:= 0;
      fi;
      if not BrowseData.IsHiddenCell( t, cell, direction ) then
        n:= n + dist( t, cell ) - from + 1;
      fi;
#T here we cannot use BrowseData.LengthCell because of the summand from - 1
#T (introduce an additional argument of LengthCell ?)
      if width <= n then
        break;
      else
        width:= width - n;
      fi;
      cell:= cell + 1;
      from:= 1;
    od;

    if width = n then
      # Check whether we are at the table end.
      if ForAll( [ cell+1 .. Length( perm ) ],
                 i -> BrowseData.LengthCell( t, i, direction ) = 0 ) then
        return 0;
      fi;
    fi;

    if IsBound( perm[ cell ] ) and ( cell < Length( perm )
                                 or from - 1 + width < dist( t, cell ) ) then
      return [ cell, from - 1 + width ];
    fi;

    # number of free characters
    return width;
end;


#############################################################################
##
#F  BrowseData.BlockEntry( <tablecelldata>, <height>, <width> )
##
##  <#GAPDoc Label="BlockEntry_man">
##  <ManSection>
##  <Func Name="BrowseData.BlockEntry" Arg="tablecelldata, height, width"/>
##
##  <Returns>
##  a list of attribute lines.
##  </Returns>
##
##  <Description>
##  For a table cell data object <A>tablecelldata</A>
##  (see&nbsp;<Ref Func="BrowseData.IsBrowseTableCellData"/>)
##  and two positive integers <A>height</A> and <A>width</A>,
##  <C>BrowseData.BlockEntry</C> returns a list of <A>height</A>
##  attribute lines of displayed length <A>width</A> each
##  (see&nbsp;<Ref Func="NCurses.WidthAttributeLine"/>),
##  that represents the formatted version of <A>tablecelldata</A>.
##  <P/>
##  If the rows of <A>tablecelldata</A> have different numbers of displayed
##  characters then they are filled up to the desired numbers of rows and
##  columns, according to the alignment prescribed by <A>tablecelldata</A>;
##  the default alignment is right and vertically centered.
##  <P/>
##  <Example><![CDATA[
##  gap> BrowseData.BlockEntry( "abc", 3, 5 );
##  [ "     ", "  abc", "     " ]
##  gap> BrowseData.BlockEntry( rec( rows:= [ "ab", "cd" ],
##  >                                align:= "tl" ), 3, 5 );
##  [ "ab   ", "cd   ", "     " ]
##  ]]></Example>
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#T if the object is larger then cut it down?
##
BrowseData.BlockEntry:= function( tablecelldata, height, width )
    local result, align, tl, max, n, n1, n2, diff, i;

    align:= "r";
    if   NCurses.IsAttributeLine( tablecelldata ) then
      result:= [ tablecelldata ];
    elif IsList( tablecelldata ) then
      result:= ShallowCopy( tablecelldata );
    else
      result:= ShallowCopy( tablecelldata.rows );
      if IsBound( tablecelldata.align ) then
        align:= tablecelldata.align;
      fi;
    fi;

    # Blow up to width (according to the prescribed alignment).
    for i in [ 1 .. Length( result ) ] do
      n:= width - NCurses.WidthAttributeLine( result[i] );
      if n < 0 then
        # This can happen if some unprintable characters occur.
        # Of course something went wrong then, but here we just take care
        # that `RepeatedString' does not run into an error.
        n:= 0;
      fi;
      n:= RepeatedString( ' ', n );
#T set background color attribute?
      if 'c' in align then
        n1:= n{ [ QuoInt( Length(n), 2 ) + 1 .. Length(n) ] };
        n2:= n{ [ 1 .. QuoInt( Length(n), 2 ) ] };
      elif 'l' in align then
        n1:= "";
        n2:= n;
      else
        # default is right
        n1:= n;
        n2:= "";
      fi;
      if IsString( result[i] ) then
        result[i]:= Concatenation( n1, result[i], n2 );
      else
        result[i]:= Concatenation( [ n1 ], result[i], [ n2 ] );
      fi;
    od;

    # Blow up to height (according to the prescribed alignment).
    if Length( result ) < height then
      diff:= height - Length( result );
      n:= RepeatedString( " ", width );
#T background color attribute!
      if 't' in align then
        n2:= ListWithIdenticalEntries( diff, n );
        result:= Concatenation( result, n2 );
      elif 'b' in align then
        n1:= ListWithIdenticalEntries( diff, n );
        result:= Concatenation( n1, result );
      else
        # default is centered
        n1:= ListWithIdenticalEntries( QuoInt( diff, 2 ), n );
        n2:= ListWithIdenticalEntries( diff - QuoInt( diff, 2 ), n );
        result:= Concatenation( n1, result, n2 );
      fi;
    fi;

    return result;
end;


############################################################################
##
#F  BrowseData.StringMatch( <t>, <i>, <j>, <case_sens>, <mode>, <type>,
#F                          <negate>, <hidden> )
##
##  If <i> and <j> are even integers then `t.work.main[k][l]'
##  (the entry corresponding to row `k = t.dynamic.indexRow[<i>]'
##  and column `l = t.dynamic.indexCol[<j>]' of the main table)
##  is searched for `t.dynamic.searchString'.
##  If <i> is an attribute line (this is used for category rows)
##  then the corresponding string is searched.
##
##  <case_sens>, <type>, and <negate> are Booleans
##  denoting search parameters.
##
##  Note that the formatted strings in `mainFormatted' are searched
##  only if neither the source strings in `main' nor the function `Main' is
##  available.
##  This is because the formatted values may contain additional line breaks.
##
##  If <hidden> is `true' then also hidden cells are considered,
##  otherwise hidden cells do not match.
##  (In *search* context, hidden cells are ignored,
##  whereas in *filter* context, hidden cells count.)
##
BrowseData.StringMatch:= function( t, i, j, case_sensitive, mode, type,
                                   negate, hidden )
    local entry, searchstr, row, cleanedstr, pos, len, pos2, flag, func;

    if NCurses.IsAttributeLine( i ) then
      entry:= [ NCurses.SimpleString( i ) ];
    elif ( hidden <> true ) and
         ( BrowseData.IsHiddenCell( t, i, "vert" ) or
           BrowseData.IsHiddenCell( t, j, "horz" ) ) then
      # Hidden cells do not match.
      return false;
    else
      i:= t.dynamic.indexRow[i] / 2;
      j:= t.dynamic.indexCol[j] / 2;
      if   IsBound( t.work.main[i] ) and
           IsBound( t.work.main[i][j] ) then
        entry:= t.work.main[i][j];
      elif IsFunction( t.work.Main ) then
        entry:= t.work.Main( t, i, j );
      elif IsBound( t.work.mainFormatted[ 2*i ] ) and
           IsBound( t.work.mainFormatted[ 2*i ][ 2*j ] ) then
        entry:= t.work.mainFormatted[ 2*i ][ 2*j ];
      else
        entry:= t.work.emptyCell;
      fi;
#T support a matrix of simple strings, store them as needed!
      if   NCurses.IsAttributeLine( entry ) then
        entry:= [ NCurses.SimpleString( entry ) ];
      elif IsList( entry ) then
        entry:= List( entry, NCurses.SimpleString );
      else
        entry:= List( entry.rows, NCurses.SimpleString );
      fi;
    fi;
    searchstr:= t.dynamic.searchString;
    if not case_sensitive then
      searchstr:= LowercaseString( searchstr );
    fi;
    if mode = "substring" then
      for row in entry do
        cleanedstr:= row;
        if not case_sensitive then
          cleanedstr:= LowercaseString( cleanedstr );
        fi;
        pos:= PositionSublist( cleanedstr, searchstr );
        if pos <> fail and type = "any substring" then
          return not negate;
        fi;
        len:= Length( cleanedstr );
        while pos <> fail do
  
          if type = "word" then
            pos2:= pos + Length( searchstr ) - 1;
            if ( pos = 1 or cleanedstr[ pos-1 ] = ' ' ) and
               ( pos2 = len or
                 ( pos2 < len and cleanedstr[ pos2+1 ] = ' ' ) ) then
              return not negate;
            fi;
          elif type = "prefix" then
            if pos = 1 or ( pos < len and cleanedstr[ pos-1 ] = ' ' ) then
              return not negate;
            fi;
          elif type = "suffix" then
            pos2:= pos + Length( searchstr ) - 1;
            if pos2 = len or
               ( pos2 < len and cleanedstr[ pos2 + 1 ] = ' ' ) then
              return not negate;
            fi;
          else
            Error( "not supported as <type>: ", type );
          fi;
  
          # The condition is not satisfied, search further in the cell.
          pos:= PositionSublist( cleanedstr, searchstr, pos );
  
        od;
#T generalize:
#T support regular expressions, admit \* for * etc.
#T -> see file match.g!
      od;
      return negate;
    else
      cleanedstr:= Concatenation( entry );
      if not case_sensitive then
        cleanedstr:= LowercaseString( cleanedstr );
      fi;
      # We can directly return the comparison result:
      # value  negate  return
      #   +       -       +
      #   -       -       -
      #   +       +       -
      #   -       +       +
      if   type = "\"=\"" then
        return ( cleanedstr = searchstr ) <> negate;
      elif type = "\"<>\"" then
        return ( cleanedstr = searchstr ) = negate;
      else
        # Use the relevant comparison function.
        flag:= BrowseData.CurrentMode( t ).flag;
        if   flag in [ "browse", "select_entry" ] then
          func:= t.dynamic.sortFunctionForTableDefault;
        elif flag in [ "select_row", "select_row_and_entry" ] then
          if IsBound( t.dynamic.sortFunctionsForRows[i] ) then
            func:= t.dynamic.sortFunctionsForRows[i];
          else
            func:= t.dynamic.sortFunctionForRowsDefault;
          fi;
        elif flag in [ "select_column", "select_column_and_entry" ] then
          if IsBound( t.dynamic.sortFunctionsForColumns[j] ) then
            func:= t.dynamic.sortFunctionsForColumns[j];
          else
            func:= t.dynamic.sortFunctionForColumnsDefault;
          fi;
        else
          # We have  no idea how to compare the entries.
          return negate;
        fi;

        if   type = "\"<\"" then
          return func( cleanedstr, searchstr ) <> negate;
        elif type = "\"<=\"" then
          return ( cleanedstr = searchstr or func( cleanedstr, searchstr ) )
                 <> negate;
        elif type = "\">=\"" then
          return ( cleanedstr = searchstr or func( searchstr, cleanedstr ) )
                 <> negate;
        else
          # type = "\">\""
          return func( searchstr, cleanedstr ) <> negate;
        fi;
      fi;
    fi;
end;


#############################################################################
##
##  Debugging
##


#############################################################################
##
#F  BrowseData.actions.Error.action( <t> )
##
##  <#GAPDoc Label="Error_man">
##  <ManSection>
##  <Var Name="BrowseData.actions.Error"/>
##
##  <Description>
##  After <Ref Func="NCurses.BrowseGeneric"/> has been called,
##  interrupting by hitting the <B>Ctrl-C</B> keys is not possible.
##  It is recommended to provide the action
##  <Ref Var="BrowseData.actions.Error"/>
##  for each mode of a <Ref Func="NCurses.BrowseGeneric"/> application,
##  which enters a break loop and admits returning to the application.
##  The recommended user input for this action is the <B>E</B> key.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BrowseData.actions.Error := rec(
  helplines := [ "enter a break loop (for debugging purposes)" ],
  action := function( t )

    if NCurses.IsStdoutATty() then
      if not NCurses.isendwin() then
        NCurses.endwin();
      fi;
#T would not be needed if ErrorInner gets an appropriate handler
    fi;

    # Enter a break loop.
    Error( "user interrupt, enter a break loop in `Browse'" );

    # Clean up for returning to the browse window.
    if NCurses.IsStdoutATty() then
      NCurses.update_panels();
      NCurses.doupdate();
      NCurses.curs_set( 0 );
    fi;
  end );


#############################################################################
##
#F  BrowseData.AlertWithReplay( <t>, <messages>[, <attrs>] )
##
##  <#GAPDoc Label="AlertWithReplay_man">
##  <ManSection>
##  <Func Name="BrowseData.AlertWithReplay" Arg="t, messages[, attrs]"/>
##
##  <Returns>
##  an integer representing a (simulated) user input.
##  </Returns>
##
##  <Description>
##  The function <Ref Func="BrowseData.AlertWithReplay"/> is a variant of
##  <Ref Func="NCurses.Alert"/> that is adapted for the replay feature
##  of the browse table <A>t</A>, see Section <Ref Sect="sec:features"/>.
##  The arguments <A>messages</A> and <A>attrs</A> are the same as the
##  corresponding arguments of <Ref Func="NCurses.Alert"/>,
##  the argument <C>timeout</C> of <Ref Func="NCurses.Alert"/> is taken from
##  the browse table <A>t</A>, as follows.
##  If <C>BrowseData.IsDoneReplay</C>
##  <Index Key="BrowseData.IsDoneReplay">
##  <C>BrowseData.IsDoneReplay</C></Index>
##  returns <K>true</K> for <C>t</C> then <C>timeout</C> is zero,
##  so a user input is requested for closing the alert box;
##  otherwise the requested input character is fetched from
##  <C>t.dynamic.replay</C>.
##  <P/>
##  If <C>timeout</C> is zero and mouse events are enabled
##  (see <Ref Func="NCurses.UseMouse"/>)<Index>mouse events</Index>
##  then the box can be moved inside the window via mouse events.
##  <P/>
##  No alert box is shown if <C>BrowseData.IsQuietSession</C>
##  <Index Key="BrowseData.IsQuietSession">
##  <C>BrowseData.IsQuietSession</C></Index>
##  returns <K>true</K> when called with <A>t</A><C>.dynamic.replay</C>,
##  otherwise the alert box is closed after the time (in milliseconds) that
##  is given by the <C>replayInterval</C> value of the current entry in
##  <A>t</A><C>.dynamic.replay.logs</C>.
##  <P/>
##  The function returns either the return value of the call to
##  <Ref Func="NCurses.Alert"/> (in the interactive case) or the value
##  that was fetched from the current replay record (in the replay case).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BrowseData.AlertWithReplay := function( arg )
    local t, messages, attrs, replay, c, interval;

    t:= arg[1];
    messages:= arg[2];
    attrs:= NCurses.attrs.NORMAL;
    if Length( arg ) = 3 then
      attrs:= arg[3];
    fi;

    replay:= t.dynamic.replay;
    if BrowseData.IsDoneReplay( replay ) then
      if not BrowseData.IsQuietSession( replay ) then
        NCurses.hide_panel( t.dynamic.statuspanel );
      fi;
      c:= NCurses.Alert( messages, 0, attrs );
    else
      if not BrowseData.IsQuietSession( replay ) then
        NCurses.hide_panel( t.dynamic.statuspanel );
        interval:= replay.logs[ replay.pointer ].replayInterval;
        NCurses.Alert( messages, interval, attrs );
        NCurses.napms( interval );
      fi;
      c:= BrowseData.NextReplay( replay );
    fi;
    if 1 < replay.pointer then
      Add( t.dynamic.log, c );
    fi;

    if not BrowseData.IsQuietSession( replay ) then
      # Refresh the windows that were below the box.
      NCurses.show_panel( t.dynamic.statuspanel );
      NCurses.update_panels();
      NCurses.doupdate();
      NCurses.curs_set( 0 );
    fi;

    return c;
end;


#############################################################################
##
##  Functions for leaving the current mode or the application
##
#F  BrowseData.actions.QuitMode.action( <t> )
#F  BrowseData.actions.QuitTable.action( <t> )
##
##  <#GAPDoc Label="QuitMode_man">
##  <ManSection>
##  <Var Name="BrowseData.actions.QuitMode"/>
##  <Var Name="BrowseData.actions.QuitTable"/>
##
##  <Description>
##  The function <C>BrowseData.actions.QuitMode.action</C> unbinds
##  the current mode in the browse table that is given as its argument
##  (see Section <Ref Sect="sec:modes"/>),
##  so the browse table returns to the mode from which this mode had been
##  called.
##  If the current mode is the only one, first the user is asked for
##  confirmation whether she really wants to quit the table;
##  only if the <B>y</B> key is hit, the last mode is unbound.
##  <P/>
##  The function <C>BrowseData.actions.QuitTable.action</C> unbinds
##  all modes in the browse table that is given as its argument,
##  without asking for confirmation;
##  the effect is to exit the browse application
##  (see Section <Ref Sect="sec:applications"/>).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BrowseData.actions.QuitMode := rec(
  helplines := [ "quit the current mode of the browse table" ],
  action := function( t )
    local len, c, interval;

    len:= Length( t.dynamic.activeModes );
    if len = 1 then
      c:= BrowseData.AlertWithReplay( t, "really quit? (y/n)",
                                      NCurses.attrs.BOLD );
      if   BrowseData.IsDoneReplay( t.dynamic.replay ) then
        # Do *not* add the return value to `t.dynamic.log'.
        Unbind( t.dynamic.log[ Length( t.dynamic.log ) ] );
      fi;
      if c in List( "yY", IntChar ) then
        return BrowseData.actions.QuitTable.action( t );
      fi;
    else
      Unbind( t.dynamic.activeModes[ len ] );
      t.dynamic.changed:= true;
      if IsBound( t.dynamic.activeModes[ len - 1 ].onReturn ) then
        t.dynamic.activeModes[ len - 1 ].onReturn( t );
      fi;
    fi;
    return t.dynamic.changed;
  end );

BrowseData.actions.QuitTable := rec(
  helplines := [ "quit the browse table" ],
  action := function( t )
    t.dynamic.activeModesBeforeQuit:= t.dynamic.activeModes;
    t.dynamic.activeModes:= [];
    t.dynamic.changed:= true;
    return true;
  end );


#############################################################################
##
#F  BrowseData.actions.SaveWindow.action( <t> )
##
##  <#GAPDoc Label="SaveWindow_man">
##  <ManSection>
##  <Var Name="BrowseData.actions.SaveWindow"/>
##
##  <Description>
##  The function <C>BrowseData.actions.SaveWindow.action</C> asks the user
##  to enter the name of a global &GAP; variable,
##  using <Ref Func="NCurses.GetLineFromUser"/>.
##  If this variable name is valid and if no value is bound to this variable
##  yet then the current contents of the window of the browse table
##  that is given as the argument is saved in this variable,
##  using <Ref Func="NCurses.SaveWin"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BrowseData.actions.SaveWindow := rec(
  helplines := [ "save the contents of the window in a GAP variable" ],
  action := function( t )
    local varname;

    if BrowseData.IsDoneReplay( t.dynamic.replay )
       and not BrowseData.IsQuietSession( t.dynamic.replay ) then
      NCurses.hide_panel( t.dynamic.statuspanel );
      varname:= NCurses.GetLineFromUser( rec(
                  prefix:= "Please enter a variable name: ",
                  window:= t.dynamic.window,
                  ) );
      NCurses.show_panel( t.dynamic.statuspanel );
      NCurses.update_panels();
      NCurses.doupdate();
      NCurses.curs_set( 0 );
      if varname = false then
        return true;
      elif varname = "" then
        BrowseData.AlertWithReplay( t,
          [ "Variable names must be nonempty" ], NCurses.attrs.BOLD );
      elif ForAny( varname, l -> not l in IdentifierLetters ) then
        BrowseData.AlertWithReplay( t,
          [ "Variable names must not contain the characters",
            Filtered( varname, l -> not l in IdentifierLetters ) ],
          NCurses.attrs.BOLD );
      elif IsBoundGlobal( varname ) then
        BrowseData.AlertWithReplay( t,
          [ Concatenation( "The global variable '", varname,
                           "' is already bound" ) ], NCurses.attrs.BOLD );
      else
        BindGlobal( varname, NCurses.SaveWin( t.dynamic.window ) );
      fi;
    fi;
    return t.dynamic.changed;
  end );


#############################################################################
##
#F  BrowseData.actions.DoNothing.action( <t> )
##
BrowseData.actions.DoNothing := rec(
  helplines := [ "do nothing (useful in non-interactive demos)" ],
  action := t -> t.dynamic.changed );


#############################################################################
##
##  Functions for scrolling left, right, up, down
##  - scroll by a fixed number of characters
##  - scroll by a full table cell
##  - scroll by a full screen (minus one cell)
##  - scroll to beginning and end (vertically only)
##


#############################################################################
##
#F  BrowseData.ScrollCharactersDownOrRight( <t>, <direction>, <n> )
#F  BrowseData.ScrollCharactersUpOrLeft( <t>, <direction>, <n> )
#F  BrowseData.actions.ScrollCharacterLeft.action( <t> )
#F  BrowseData.actions.ScrollCharacterRight.action( <t> )
#F  BrowseData.actions.ScrollCharacterUp.action( <t> )
#F  BrowseData.actions.ScrollCharacterDown.action( <t> )
##
##  Scroll the main table by a fixed number <n> of characters:
##
##  If we are scrolling forwards then
##  - if the end of the table is shown or <n> is not positive
##    then we do nothing,
##  - otherwise we scroll by <n> characters, also if this means that
##    whitespace has to be shown at the end of the table.
##
##  If we are scrolling backwards then
##  - we do nothing if <n> is not positive,
##  - we scroll by the minimum of <n> and the distance between the
##    beginning of the table and the currently shown first row/column.
##
BrowseData.ScrollCharactersDownOrRight:= function( t, direction, n )
    local pos, curr, from, full, len;

    # Check whether we can move at least by one character.
    if   n = 0 or not IsList( BrowseData.BottomOrRight( t, direction ) ) then
      return t.dynamic.changed;
    elif direction = "vert" then
      len:= Length( t.dynamic.indexRow );
      pos:= 1;
    else
      len:= Length( t.dynamic.indexCol );
      pos:= 2;
    fi;

    curr:= t.dynamic.topleft[ pos ];
    from:= t.dynamic.topleft[ 2 + pos ];
    full:= BrowseData.LengthCell( t, curr, direction ) - from;
    if   n <= full then
      # Move inside the current cell.
      t.dynamic.topleft[ 2 + pos ]:= from + n;
      t.dynamic.changed:= true;
    else
      # Move to the next nonempty and unhidden cell.
      n:= n - ( full + 1 );
      curr:= curr + 1;
      from:= 1;
      while 0 < n and curr <= len do
        full:= BrowseData.LengthCell( t, curr, direction );
        if full <= n then
          n:= n - full;
          curr:= curr + 1;
        else
          from:= n + 1;
          n:= 0;
        fi;
      od;
      if curr <= len then
        BrowseData.SetTopOrLeft( t, direction, curr, from );
        t.dynamic.changed:= true;
      elif t.dynamic.topleft[ pos ] < len or
           t.dynamic.topleft[ 2 + pos ] < from then
        BrowseData.SetTopOrLeft( t, direction, len, from );
        t.dynamic.changed:= true;
      fi;
    fi;

    return t.dynamic.changed;
end;

BrowseData.ScrollCharactersUpOrLeft:= function( t, direction, n )
    local pos, from, curr, full;

    if   n = 0 or BrowseData.NumberFreeCharacters( t, direction ) <= 0 then
      return t.dynamic.changed;
    elif direction = "vert" then
      pos:= 1;
    else
      pos:= 2;
    fi;
    from:= t.dynamic.topleft[ 2 + pos ];
    if n < from then
      # Move inside the current cell.
      t.dynamic.topleft[ 2 + pos ]:= from - n;
      t.dynamic.changed:= true;
    else
      # Move to the previous nonempty and unhidden cell.
      curr:= t.dynamic.topleft[ pos ];
      n:= n - ( from - 1 );
      from:= 1;
      while 0 < n and 1 < curr do
        curr:= curr - 1;
        full:= BrowseData.LengthCell( t, curr, direction );
        if full <= n then
          n:= n - full;
        else
          from:= full - n + 1;
          n:= 0;
        fi;
      od;

      if 1 < curr then
        # `n' is zero.
        BrowseData.SetTopOrLeft( t, direction, curr, from );
        t.dynamic.changed:= true;
      elif 1 < t.dynamic.topleft[ pos ] then
        BrowseData.SetTopOrLeft( t, direction, 1, 1 );
        t.dynamic.changed:= true;
      fi;
    fi;
    return t.dynamic.changed;
end;

BrowseData.actions.ScrollCharacterLeft := rec(
  helplines := [ "scroll one character to the left" ],
  action := t -> BrowseData.ScrollCharactersUpOrLeft( t, "horz", 1 ) );

BrowseData.actions.ScrollCharacterRight := rec(
  helplines := [ "scroll one character to the right" ],
  action := t -> BrowseData.ScrollCharactersDownOrRight( t, "horz", 1 ) );

BrowseData.actions.ScrollCharacterUp := rec(
  helplines := [ "scroll one character up" ],
  action := t -> BrowseData.ScrollCharactersUpOrLeft( t, "vert", 1 ) );

BrowseData.actions.ScrollCharacterDown := rec(
  helplines := [ "scroll one character down" ],
  action := t -> BrowseData.ScrollCharactersDownOrRight( t, "vert", 1 ) );


#############################################################################
##
#F  BrowseData.ScrollCellDownOrRight( <t>, <direction> )
#F  BrowseData.ScrollCellUpOrLeft( <t>, <direction> )
#F  BrowseData.actions.ScrollCellLeft.action( <t> )
#F  BrowseData.actions.ScrollCellRight.action( <t> )
#F  BrowseData.actions.ScrollCellUp.action( <t> )
#F  BrowseData.actions.ScrollCellDown.action( <t> )
##
##  Scroll the main table by roughly one cell:
##
##  If we are scrolling forwards then
##  - if the end of the table is shown then we do nothing,
##  - otherwise we move towards the beginning of the next unhidden
##    separator, but at most by one screen,
##    with an overlap of one character (provided that the screen size is
##    larger than one).
##
##  If we are scrolling backwards then
##  - if the beginning of the first unhidden cell in the table is shown
##    then we do nothing,
##  - otherwise we move towards the beginning of the previous unhidden
##    separator, but at most by one screen,
##    with an overlap of one character (provided that the screen size is
##    larger than one).
##
BrowseData.ScrollCellDownOrRight := function( t, direction )
    local s, br, start, curr, from;

    s:= BrowseData.NumberFreeCharacters( t, direction ) - 1;
    if 0 <= s then
      br:= BrowseData.BottomOrRight( t, direction );
      if IsList( br ) then
        # The end of the table is not shown.
        start:= BrowseData.TopOrLeft( t, direction );
        if start <> fail then
          curr:= start[1];
          from:= start[2];
          if   s = 0 then
            return BrowseData.ScrollCharactersDownOrRight( t, direction, 1 );
          elif br[1] = curr then
            # The first visible cell spans more than one screen.
            BrowseData.SetTopOrLeft( t, direction, curr, s + from - 1 );
          elif ( curr mod 2 = 1 and br[1] mod 2 = 0 and
               ForAll( [ curr + 1 .. br[1] - 1 ],
                   i -> BrowseData.LengthCell( t, i, direction ) = 0 ) ) then
            # The first visible cell is a separator,
            # immediately before a data cell that fills the screen.
            BrowseData.SetTopOrLeft( t, direction, br[1],
                s - BrowseData.LengthCell( t, curr, direction ) + from - 1 );
          else
            # There are separators or categories shown below the first cell;
            # move to the beginning of the *first* such row.
            curr:=  curr + ( curr mod 2 ) + 1;
            while BrowseData.LengthCell( t, curr, direction ) = 0 do
              curr:= curr + 1;
            od;
            BrowseData.SetTopOrLeft( t, direction, curr, 1 );
          fi;
          t.dynamic.changed:= true;
        fi;
      fi;
    fi;

    return t.dynamic.changed;
end;

BrowseData.ScrollCellUpOrLeft := function( t, direction )
    local s, start, curr, from;

    s:= BrowseData.NumberFreeCharacters( t, direction );
    if 0 < s then
      start:= BrowseData.TopOrLeft( t, direction );
      if start <> fail then
        curr:= start[1];
        from:= start[2];
        if 1 < s then
          s:= s - 1;
        fi;
        if s < from then
          # The first visible cell spans more than one screen above.
          from:= from - s;
          t.dynamic.changed:= true;
        else
          # Move back to the beginning of the current cell,
          # and if it is not itself a separator then also
          # to the previous unhidden separator or category.
          if curr mod 2 = 0 then
            # Go to the separator in front of this data cell.
            s:= s - from + 1;
            curr:= curr - 1;
            from:= 1;
            # Go to the previous unhidden separator or category.
            while 0 < curr and
                  BrowseData.LengthCell( t, curr, direction ) = 0 do
              curr:= curr - 1;
            od;
            if curr = 0 then
              curr:= 1;
            else
              # Go as far as possible to the beginning.
              from:= BrowseData.LengthCell( t, curr, direction ) - s;
              if from < 1 then
                from:= 1;
              fi;
            fi;
            t.dynamic.changed:= true;
          elif 1 < from then
            # Stay on the separator but move to the beginning.
            from:= 1;
            t.dynamic.changed:= true;
          elif 1 < curr then
            # Go to the data cell (which is unhidden).
            curr:= curr - 1;
            s:= s - BrowseData.LengthCell( t, curr, direction );
            if 0 < s then
              # Go to an unhidden separator or category.
              curr:= curr - 1;
              while 0 < curr and
                    BrowseData.LengthCell( t, curr, direction ) = 0 do
                curr:= curr - 1;
              od;
              if curr = 0 then
                curr:= 1;
              else
                s:= s - BrowseData.LengthCell( t, curr, direction );
              fi;
              if 0 < s then
                from:= 1;
              else
                from:= 1 - s;
              fi;
            else
              from:= 1 - s;
            fi;
            t.dynamic.changed:= true;
          fi;
        fi;
      fi;

      BrowseData.SetTopOrLeft( t, direction, curr, from );
    fi;

    return t.dynamic.changed;
end;

BrowseData.actions.ScrollCellLeft := rec(
  helplines := [ "scroll one table cell to the left" ],
  action := t -> BrowseData.ScrollCellUpOrLeft( t, "horz" ) );

BrowseData.actions.ScrollCellRight := rec(
  helplines := [ "scroll one table cell to the right" ],
  action := t -> BrowseData.ScrollCellDownOrRight( t, "horz" ) );

BrowseData.actions.ScrollCellUp := rec(
  helplines := [ "scroll one table cell up" ],
  action := t -> BrowseData.ScrollCellUpOrLeft( t, "vert" ) );

BrowseData.actions.ScrollCellDown := rec(
  helplines := [ "scroll one table cell down" ],
  action := t -> BrowseData.ScrollCellDownOrRight( t, "vert" ) );


############################################################################
##
#F  BrowseData.ScrollScreenDownOrRight( <t>, <direction> )
#F  BrowseData.ScrollScreenUpOrLeft( <t>, <direction> )
#F  BrowseData.actions.ScrollScreenLeft.action( <t> )
#F  BrowseData.actions.ScrollScreenRight.action( <t> )
#F  BrowseData.actions.ScrollScreenUp.action( <t> )
#F  BrowseData.actions.ScrollScreenDown.action( <t> )
##
##  Scroll the main table by roughly one screen:
##
##  If we are scrolling forwards then
##  - if the end of the table is shown then we do nothing,
##  - if a separator below the first shown cell is shown then
##    we move to the beginning of the last shown unhidden separator,
##  - otherwise we move by one screen,
##    with an overlap of one character (provided that the screen size is
##    larger than one).
##
##  If we are scrolling backwards then
##  - if the beginning of the table is shown then we do nothing,
##  - otherwise we move towards the beginning of the previous unhidden
##    separator one screen before, but at most by one screen,
##    with an overlap of one character (provided that the screen size is
##    larger than one).
##
BrowseData.ScrollScreenDownOrRight := function( t, direction )
    local s, br, start, curr, from;

    s:= BrowseData.NumberFreeCharacters( t, direction ) - 1;
    if 0 <= s then
      br:= BrowseData.BottomOrRight( t, direction );
      if IsList( br ) then
        # The end of the table is not shown.
        start:= BrowseData.TopOrLeft( t, direction );
        if start <> fail then
          curr:= start[1];
          from:= start[2];
          if   s = 0 then
            return BrowseData.ScrollCharactersDownOrRight( t, direction, 1 );
          elif br[1] = curr then
            # The first visible cell spans more than one screen.
            # Move forwards inside this cell.
            BrowseData.SetTopOrLeft( t, direction, curr, s + from - 1 );
          elif curr mod 2 = 1 and br[1] mod 2 = 0
               and ForAll( [ curr + 1 .. br[1] - 1 ],
                     i -> BrowseData.LengthCell( t, i, direction ) = 0 ) then
            # The first visible cell is a separator,
            # immediately before a data cell that fills the screen.
            # Move forwards inside this data cell.
            BrowseData.SetTopOrLeft( t, direction, br[1],
                s - BrowseData.LengthCell( t, curr, direction ) + from - 1 );
          else
            # There are separators or categories shown behind the first cell.
            # Move to the beginning of the *last* such object.
            if br[1] mod 2 = 1 then
              # The last shown cell is an unhidden separator.
              BrowseData.SetTopOrLeft( t, direction, br[1], 1 );
            elif br[2] <= BrowseData.HeightCategories( t, br[1] ) then
              # The last shown row is a category, move there.
              BrowseData.SetTopOrLeft( t, direction, br[1], br[2] );
            else
              # Find the previous unhidden separator or category.
              curr:= br[1] - 1;
              while ( curr mod 2 = 0
                      and BrowseData.LengthCell( t, curr, direction ) = 0 ) or
                    ( curr mod 2 = 1
                      and BrowseData.IsHiddenCell( t, curr, direction ) ) do
                curr:= curr - 1;
              od;
              BrowseData.SetTopOrLeft( t, direction, curr, 1 );
            fi;
          fi;
          t.dynamic.changed:= true;
        fi;
      fi;
    fi;

    return t.dynamic.changed;
end;

BrowseData.ScrollScreenUpOrLeft := function( t, direction )
    local s, start, curr, from, len;

    s:= BrowseData.NumberFreeCharacters( t, direction );
    if 0 < s then

      start:= BrowseData.TopOrLeft( t, direction );
      if start = fail then
        return t.dynamic.changed;
      fi;
      curr:= start[1];
      from:= start[2];
      if 1 < s then
        s:= s - 1;
      fi;

      if s < from then
        # The first visible cell spans more than one screen above.
        BrowseData.SetTopOrLeft( t, direction, curr, from - s );
        t.dynamic.changed:= true;
      elif 1 < from then
        # Move to the start of the current row/column.
        BrowseData.SetTopOrLeft( t, direction, curr, 1 );
        t.dynamic.changed:= true;
      elif 1 < curr then
        # Compute the topleft position one screen above.
        curr:= curr - 1;
        len:= BrowseData.LengthCell( t, curr, direction );
        while 0 < curr and len <= s do
          # Move by complete rows/columns as long as possible.
          s:= s - len;
          curr:= curr - 1;
          if 0 < curr then
            len:= BrowseData.LengthCell( t, curr, direction );
          fi;
        od;
        if curr = 0 or s = 0 then
          curr:= curr + 1;
        else
          # Move into the previous data cell.
          # (We have 0 < s < len, 0 < curr.)
          from:= len - s;
        fi;

        # Save the new status values.
        BrowseData.SetTopOrLeft( t, direction, curr, from );
        t.dynamic.changed:= true;
      fi;
    fi;

    return t.dynamic.changed;
end;

BrowseData.actions.ScrollScreenLeft := rec(
  helplines := [ "scroll one screen to the left" ],
  action := t -> BrowseData.ScrollScreenUpOrLeft( t, "horz" ) );

BrowseData.actions.ScrollScreenRight := rec(
  helplines := [ "scroll one screen to the right" ],
  action := t -> BrowseData.ScrollScreenDownOrRight( t, "horz" ) );

BrowseData.actions.ScrollScreenUp := rec(
  helplines := [ "scroll one screen up" ],
  action := t -> BrowseData.ScrollScreenUpOrLeft( t, "vert" ) );

BrowseData.actions.ScrollScreenDown := rec(
  helplines := [ "scroll one screen down" ],
  action := t -> BrowseData.ScrollScreenDownOrRight( t, "vert" ) );


############################################################################
##
#F  BrowseData.actions.ScrollToFirstRow( <t> )
#F  BrowseData.actions.ScrollToLastRow( <t> )
##
##  Scroll vertically to the first or last unhidden row of the table,
##  keep the column.
##  If a row or entry is selected then move also the selection to the first
##  or last row, respectively.
##  If a category row is selected then move the selection to the first or
##  last unhidden category row, respectively.
##
BrowseData.actions.ScrollToFirstRow := rec(
  helplines := [ "scroll to the first row" ],
  action := function( t )
    local i, cat;

    # Move the topleft entry.
    if t.dynamic.topleft[1] <> 1 or t.dynamic.topleft[3] <> 1 then
      BrowseData.SetTopOrLeft( t, "vert", 1, 1 );
    fi;
    # Move the selection.
    if t.dynamic.selectedEntry[1] <> 0 then
      i:= First( [ 2, 4 .. Length( t.dynamic.indexRow ) - 1 ],
                 x -> BrowseData.LengthCell( t, x, "vert" ) <> 0 );
      t.dynamic.selectedEntry[1]:= i;
    elif t.dynamic.selectedCategory[1] <> 0 then
      cat:= First( t.dynamic.categories[2], x -> not x.isRejectedCategory );
      t.dynamic.selectedCategory:= [ cat.pos, cat.level ];
    fi;
    BrowseData.MoveFocusToSelectedCellOrCategory( t );
    t.dynamic.changed:= true;

    return t.dynamic.changed;
  end );

BrowseData.actions.ScrollToLastRow := rec(
  helplines := [ "scroll to the last row" ],
  action := function( t )
    local s, pos, i, cat;

    # Move the topleft entry.
    s:= BrowseData.NumberFreeCharacters( t, "vert" );
    if 0 < s then
      pos:= Length( t.dynamic.indexRow );
      BrowseData.SetTopOrLeft( t, "vert", pos,
                               BrowseData.LengthCell( t, pos, "vert" ) );
      BrowseData.ScrollCharactersUpOrLeft( t, "vert", s-1 );
    fi;
    # Move the selection.
    if t.dynamic.selectedEntry[1] <> 0 then
      i:= First( Reversed( [ 2, 4 .. Length( t.dynamic.indexRow ) - 1 ] ),
                 x -> BrowseData.LengthCell( t, x, "vert" ) <> 0 );
      t.dynamic.selectedEntry[1]:= i;
    elif t.dynamic.selectedCategory[1] <> 0 then
      cat:= First( Reversed( t.dynamic.categories[2] ),
                   x ->     not x.isRejectedCategory
                        and not x.isUnderCollapsedCategory );
      t.dynamic.selectedCategory:= [ cat.pos, cat.level ];
    fi;

    return t.dynamic.changed;
  end );


############################################################################
##
#F  BrowseData.SelectCategory( <t> )
#F  BrowseData.SelectRowOrColumn( <t>, <direction> )
#F  BrowseData.actions.EnterSelectRowMode.action( <t> )
#F  BrowseData.actions.EnterSelectColumnMode.action( <t> )
#F  BrowseData.actions.EnterSelectEntryMode.action( <t> )
#F  BrowseData.actions.EnterSelectRowAndEntryMode.action( <t> )
#F  BrowseData.actions.EnterSelectColumnAndEntryMode.action( <t> )
##
##  Select the top nonempty visible category or row,
##  the leftmost nonempty visible column,
##  or the topleft nonempty visible entry.
##
BrowseData.SelectCategory := function( t )
    local perm, i, cat, k, cats, len, entry;

    perm:= Length( t.dynamic.indexRow );
    i:= t.dynamic.topleft[1];
    i:= i + ( i mod 2 );
    while i <= perm and BrowseData.LengthCell( t, i, "vert" ) = 0 do
      i:= i + 2;
    od;
    # If a category of the `i'-th row is visible then select it.
    if i = t.dynamic.topleft[1] then
      # Select the first visible category if applicable.
      cat:= 0;
      k:= PositionSorted( t.dynamic.categories[1], i );
      cats:= t.dynamic.categories[2];
      len:= Length( cats );
      while k <= len do
        entry:= cats[k];
        if i < entry.pos or entry.isUnderCollapsedCategory
                         or entry.isRejectedCategory then
          break;
        fi;
        cat:= cat + 1;
        if t.dynamic.topleft[3] <= cat then
          t.dynamic.selectedEntry:= [ 0, 0 ];
          t.dynamic.selectedCategory:= [ i, entry.level ];
          return true;
        fi;
        if NCurses.WidthAttributeLine( entry.separator ) <> 0 then
          cat:= cat + 1;
        fi;
        k:= k + 1;
      od;
    elif i <= perm and 0 < BrowseData.HeightCategories( t, i ) then
      # Select the first category.
      t.dynamic.selectedEntry:= [ 0, 0 ];
      t.dynamic.selectedCategory:= [ i, 1 ];
      return true;
    fi;

    return false;
    end;

BrowseData.SelectRowOrColumn := function( t, direction )
    local perm, pos, i;

    if direction = "vert" then
      perm:= t.dynamic.indexRow;
      pos:= 1;
    else
      perm:= t.dynamic.indexCol;
      pos:= 2;
    fi;

    i:= t.dynamic.topleft[ pos ];
    i:= i + ( i mod 2 );
    while i <= Length( perm ) and
          BrowseData.LengthCell( t, i, direction ) = 0 do
      i:= i + 2;
    od;
    if i <= Length( perm ) then
      if t.dynamic.selectedEntry = [ 0, 0 ] then
        t.dynamic.selectedEntry:= t.dynamic.topleft{ [ 1, 2 ] };
      fi;
      t.dynamic.selectedEntry[ pos ]:= i;
      t.dynamic.selectedEntry[ 3-pos ]:= t.dynamic.selectedEntry[ 3-pos ]
          + ( t.dynamic.selectedEntry[ 3-pos ] mod 2 );
      t.dynamic.selectedCategory:= [ 0, 0 ];
      if i = t.dynamic.topleft[ pos ] then
        t.dynamic.topleft[ 2 + pos ]:= 1;
      fi;
      return true;
    fi;
    return false;
    end;

BrowseData.actions.EnterSelectRowMode := rec(
  helplines := [ "select a matrix row" ],
  action := function( t )
    if ForAny( t.work.availableModes, x -> x.name = "select_row" ) and
       ( BrowseData.SelectCategory( t ) or
         BrowseData.SelectRowOrColumn( t, "vert" ) ) then
      return BrowseData.PushMode( t, "select_row" );
    fi;
    return false;
  end );

BrowseData.actions.EnterSelectColumnMode := rec(
  helplines := [ "select a matrix column" ],
  action := function( t )
    if ForAny( t.work.availableModes, x -> x.name = "select_column" ) and
       BrowseData.SelectRowOrColumn( t, "horz" ) then
      return BrowseData.PushMode( t, "select_column" );
    fi;;
    return false;
  end );

BrowseData.actions.EnterSelectEntryMode := rec(
  helplines := [ "select a matrix entry" ],
  action := function( t )
    local changed;

    if ForAny( t.work.availableModes, x -> x.name = "select_entry" ) then
      if ( t.dynamic.topleft[2] <= 2 and BrowseData.SelectCategory( t ) ) then
        return BrowseData.PushMode( t, "select_entry" );
      fi;
      changed:= BrowseData.SelectRowOrColumn( t, "vert" );
      if BrowseData.SelectRowOrColumn( t, "horz" ) and changed then
        return BrowseData.PushMode( t, "select_entry" );
      fi;
    fi;
    return false;
  end );

BrowseData.actions.EnterSelectRowAndEntryMode := rec(
  helplines := [ "select a matrix row and an entry in this row" ],
  action := function( t )
    if ForAny( t.work.availableModes,
               x -> x.name = "select_row_and_entry" ) and
       BrowseData.SelectRowOrColumn( t, "vert" ) then
      return BrowseData.PushMode( t, "select_row_and_entry" );
    fi;
    return false;
  end );

BrowseData.actions.EnterSelectColumnAndEntryMode := rec(
  helplines := [ "select a matrix column and an entry in this column" ],
  action := function( t )
    if ForAny( t.work.availableModes,
               x -> x.name = "select_column_and_entry" ) and
       BrowseData.SelectRowOrColumn( t, "horz" ) then
      return BrowseData.PushMode( t, "select_column_and_entry" );
    fi;;
    return false;
  end );


#############################################################################
##
#F  BrowseData.ScrollSelectedCellLeft( <t>, <direction> )
#F  BrowseData.ScrollSelectedCellRight( <t>, <direction> )
#F  BrowseData.ScrollSelectedRowOrCellUp( <t>, <roworcell> )
#F  BrowseData.ScrollSelectedRowOrCellDown( <t>, <roworcell> )
#F  BrowseData.actions.ScrollSelectedCellLeft.action( <t> )
#F  BrowseData.actions.ScrollSelectedCellRight.action( <t> )
#F  BrowseData.actions.ScrollSelectedCellUp.action( <t> )
#F  BrowseData.actions.ScrollSelectedCellDown.action( <t> )
#F  BrowseData.ScrollSelectedRowLeft( <t> )
#F  BrowseData.ScrollSelectedRowRight( <t> )
#F  BrowseData.actions.ScrollSelectedRowLeft.action( <t> )
#F  BrowseData.actions.ScrollSelectedRowRight.action( <t> )
#F  BrowseData.actions.ScrollSelectedRowUp.action( <t> )
#F  BrowseData.actions.ScrollSelectedRowDown.action( <t> )
##
##  Move the selection by one cell:
##
##  If we are scrolling forwards (backwards) then
##  - if the end (beginning) of the table is shown and selected
##    then we do nothing,
##  - if a category is selected and we want to scroll horizontally
##    then we do nothing,
##  - if a category row is selected and we scroll vertically then we move the
##    selection to the next (previous) unhidden category row or data cell/row
##    if there is one,
##    and if this element is not on the screen then we adjust the topleft
##    corner such that the newly selected element becomes just visible,
##    so we scroll by at most one screen (minus one character),
##  - if a data cell/row is selected whose end (beginning) is not shown on
##    the screen then we move the topleft entry by the minimum of the screen
##    size (minus one character) and the distance to the end (beginning) of
##    the cell/row, in particular the selection remains in the same cell,
##  - if a data cell/row is selected whose end (beginning) is shown on
##    the screen then we move the selection to the next unhidden
##    data cell/row or category row if there is one,
##    and we move the topleft entry such that as much as possible of the
##    selected cell becomes visible on the screen, under the condition that
##    we move by at most one screen (minus one character);
##    if a data *cell* is selected then we move to a category row only if
##    the selected cell is in the first visible data column of the table
##    -- this can be interpreted in such a way that w.r.t. scrolling of a
##    selected cell, the category rows ``belong'' to the first visible
##    data column.
##
BrowseData.ScrollSelectedCellLeft := function( t )
    local s, pos, j, n, cat, cats;

    if t.dynamic.selectedEntry <> [ 0, 0 ] then
      # A data row is selected.
      s:= BrowseData.NumberFreeCharacters( t, "horz" ) - 1;
      if 0 <= s then
        j:= t.dynamic.selectedEntry[2];
        if BrowseData.LengthCell( t, j, "horz" ) <> 0 and
           ( j < t.dynamic.topleft[2] or
             ( j = t.dynamic.topleft[2] and 1 < t.dynamic.topleft[4] ) ) then
          # The selected cell is not hidden,
          # the beginning of the selected cell is not visible on the screen.
          # Keep the selection, move the topleft entry.
          BrowseData.ScrollCharactersUpOrLeft( t, "horz",
              Minimum( Maximum( 1, s ), t.dynamic.topleft[4] - 1 ) );
        else
          # The beginning is visible or the selected cell is hidden,
          # move the selection backwards.
          j:= j - 2;
          while 0 < j and BrowseData.LengthCell( t, j, "horz" ) = 0 do
            j:= j - 2;
          od;
          if 0 < j then
            t.dynamic.selectedEntry[2]:= j;
            if j <= t.dynamic.topleft[2] then
              # Make the data cell `j' and the previous separator visible.
              n:= Sum( List( [ j-1 .. t.dynamic.topleft[2] - 1 ],
                             x -> BrowseData.LengthCell( t, x, "horz" ) ),
                       t.dynamic.topleft[4] - 1 );
              BrowseData.ScrollCharactersUpOrLeft( t, "horz",
                  Minimum( Maximum( 1, s ), n ) );
            fi;
            t.dynamic.changed:= true;
          fi;
        fi;
      fi;
    fi;

    return t.dynamic.changed;
end;

BrowseData.ScrollSelectedCellRight := function( t )
    local s, len, pos, j, br, n, cat, cats;

    if t.dynamic.selectedEntry <> [ 0, 0 ] then
      # A data cell is selected.
      s:= BrowseData.NumberFreeCharacters( t, "horz" ) - 1;
      if 0 <= s then
        len:= Length( t.dynamic.indexCol );
        j:= t.dynamic.selectedEntry[2];
        br:= BrowseData.BottomOrRight( t, "horz" );
        if BrowseData.LengthCell( t, j, "horz" ) <> 0 and
           IsList( br ) and br[1] = j
             and br[2] < BrowseData.LengthCell( t, j, "horz" ) then
          # The selected cell is not hidden,
          # the end of the selected cell is not visible on the screen.
          # Keep the selection, move the topleft entry.
          return BrowseData.ScrollCharactersDownOrRight( t, "horz",
              Minimum( Maximum( 1, s ),
                       BrowseData.LengthCell( t, j, "horz" ) - br[2] ) );
        else
          # The end is visible, move the selection forwards.
          j:= j + 2;
          while j < len and BrowseData.LengthCell( t, j, "horz" ) = 0 do
            j:= j + 2;
          od;
          if j <= len then
            t.dynamic.selectedEntry[2]:= j;
            if IsList( br ) and br[1] <= j then
              # Make the data cell `j' and the next separator visible.
              n:= Sum( List( [ br[1] .. j+1 ],
                    x -> BrowseData.LengthCell( t, x, "horz" ) ), - br[2] );
              BrowseData.ScrollCharactersDownOrRight( t, "horz",
                  Minimum( Maximum( 1, s ), n ) );
            fi;
            t.dynamic.changed:= true;
          fi;
        fi;
      fi;
    fi;
    return t.dynamic.changed;
end;

BrowseData.ScrollSelectedRowOrCellUp := function( t, roworcell )
    local s, cats, selected, i, pos, n, j, entry, level, start, curr, from,
          movetocat;

    s:= BrowseData.NumberFreeCharacters( t, "vert" ) - 1;
    if 0 <= s then
      if t.dynamic.selectedEntry = [ 0, 0 ] then
        # A category of row `i' is selected;
        # select the previous unhidden category of this cell if there is one,
        # (the last screenfull of) the previous visible row,
        # in the appropriate column,
        # or the last category of the previous invisible row.
        selected:= t.dynamic.selectedCategory;
        i:= selected[1];
        pos:= PositionSorted( t.dynamic.categories[1], i );
        cats:= t.dynamic.categories[2];
        if cats[ pos ].pos = i and
           cats[ pos ].level < selected[2] and
           not cats[ pos ].isUnderCollapsedCategory and
           not cats[ pos ].isRejectedCategory then
          # There is an unhidden category of smaller level for row `i'.
          while pos <= Length( cats )
                and cats[ pos ].level < selected[2]
                and not cats[ pos ].isUnderCollapsedCategory
                and not cats[ pos ].isRejectedCategory do
            pos:=  pos + 1;
          od;
          selected[2]:= cats[ pos-1 ].level;
          n:= BrowseData.HeightCategories( t, i, selected[2] - 1 ) + 1;
          if t.dynamic.topleft[1] = selected[1]
             and n < t.dynamic.topleft[3] then
            t.dynamic.topleft[3]:= n;
          fi;
          t.dynamic.changed:= true;
        else
          # The first category of row `i' is selected,
          # or all categories for row `i' are hidden.
          i:= i - 2;
          while 0 < i and BrowseData.LengthCell( t, i, "vert" ) = 0 do
            i:= i - 2;
          od;
          if 0 < i then
            # There is a visible data row or category above.
            n:= BrowseData.HeightRow( t, i );
            if 0 < n then
              # There is a visible data row for `i'.
              # If row `i' lies above the first row of the screen
              # then scroll up such that row `i' becomes visible.
              j:= BrowseData.TopOrLeft( t, "horz" )[1];
              j:= j + ( j mod 2 );
              while BrowseData.WidthCol( t, j ) = 0 do
                j:= j + 2;
              od;
              t.dynamic.selectedEntry:= [ i, j ];
              t.dynamic.selectedCategory:= [ 0, 0 ];
              if i < t.dynamic.topleft[1] then
                n:= n + BrowseData.HeightRow( t, i+1 );
                BrowseData.ScrollCharactersUpOrLeft( t, "vert",
                    Minimum( n, Maximum( 1, s ) ) );
              fi;
            else
              # There is a visible category for `i'; select the last one.
              pos:= PositionSorted( t.dynamic.categories[1], i );
              cats:= t.dynamic.categories[2];
              while pos <= Length( cats )
                    and cats[ pos ].pos = i
                    and not cats[ pos ].isUnderCollapsedCategory
                    and not cats[ pos ].isRejectedCategory do
                entry:= cats[ pos ];
                level:= entry.level;
                pos:= pos + 1;
              od;
              t.dynamic.selectedEntry:= [ 0, 0 ];
              t.dynamic.selectedCategory:= [ i, level ];
              n:= BrowseData.HeightCategories( t, i, level );
              if i < t.dynamic.topleft[1] or
                 ( i = t.dynamic.topleft[1] and n < t.dynamic.topleft[3] ) then
                # Make the selected category just visible.
                BrowseData.ScrollCharactersUpOrLeft( t, "vert",
                    Minimum( BrowseData.HeightCategories( t, i, level ) -
                             BrowseData.HeightCategories( t, i, level - 1 ),
                      Maximum( 1, s ) ) );
              fi;
            fi;
            t.dynamic.changed:= true;
          fi;
        fi;
      else
        # A data row is selected.
        start:= BrowseData.TopOrLeft( t, "vert" );
        if start <> fail then
          curr:= start[1];
          from:= start[2];
          selected:= t.dynamic.selectedEntry;
          i:= selected[1];
          if   s = 0 and 1 < from and 0 < BrowseData.HeightRow( t, i ) then
            BrowseData.SetTopOrLeft( t, "vert", curr, from - 1 );
            t.dynamic.changed:= true;
          elif s <> 0 and i = curr and 1 < from
                      and 0 < BrowseData.HeightRow( t, i ) then
            # The beginning of the selected row is not visible on the screen.
            # Keep the selection and scroll up.
            BrowseData.SetTopOrLeft( t, "vert", curr,
                Maximum( from - s, 1 ) );
            t.dynamic.changed:= true;
          else
            # Select the last category for this row,
            # the previous unhidden row, or a cell in this row,
            # or the last unhidden category of the previous hidden row.
            # (Selecting a category is allowed only if the row is selected
            # or if the selected cell is in the first visible column.)
            level:= 0;
            movetocat:= roworcell = "row" or
               ForAll( [ t.dynamic.topleft[2]
                         + ( t.dynamic.topleft[2] mod 2 ) .. selected[2] - 1 ],
                       i -> BrowseData.WidthCol( t, i ) = 0 );
            if movetocat then
              pos:= PositionSorted( t.dynamic.categories[1], i );
              cats:= t.dynamic.categories[2];
              while pos <= Length( cats )
                    and cats[ pos ].pos = i
                    and not cats[ pos ].isUnderCollapsedCategory
                    and not cats[ pos ].isRejectedCategory do
                entry:= cats[ pos ];
                level:= entry.level;
                pos:= pos + 1;
              od;
            fi;
            if 0 < level then
              # There is an unhidden category for this row; select it.
              t.dynamic.selectedEntry:= [ 0, 0 ];
              t.dynamic.selectedCategory:= [ i, level ];
              t.dynamic.changed:= true;
              n:= BrowseData.HeightCategories( t, i, level - 1 ) + 1;
              if i < t.dynamic.topleft[1] or
                 ( i = t.dynamic.topleft[1] and n < t.dynamic.topleft[3] ) then
                # Adjust `topleft', make the selected category just visible.
                BrowseData.SetTopOrLeft( t, "vert", i, n );
              fi;
            else
              # Select the nearest data row (or category) above.
              i:= i - 2;
              if movetocat then
                while 0 < i and BrowseData.LengthCell( t, i, "vert" ) = 0 do
                  i:= i - 2;
                od;
              else
                while 0 < i and BrowseData.HeightRow( t, i ) = 0 do
                  i:= i - 2;
                od;
              fi;
              if 0 < i then
                if 0 < BrowseData.HeightRow( t, i ) then
                  # Select the data row.
                  t.dynamic.selectedEntry[1]:= i;
                  t.dynamic.selectedCategory:= [ 0, 0 ];
                  if i <= curr then
                    n:= Sum( List( [ i-1 .. curr-1 ],
                                x -> BrowseData.LengthCell( t, x, "vert" ) ),
                             from-1 );
                    BrowseData.ScrollCharactersUpOrLeft( t, "vert",
                        Minimum( n, Maximum( 1, s ) ) );
                  fi;
                else
                  # Select the last category for `i'.
                  pos:= PositionSorted( t.dynamic.categories[1], i );
                  cats:= t.dynamic.categories[2];
                  while pos <= Length( cats )
                        and cats[ pos ].pos = i
                        and not cats[ pos ].isUnderCollapsedCategory
                        and not cats[ pos ].isRejectedCategory do
                    entry:= cats[ pos ];
                    level:= entry.level;
                    pos:= pos + 1;
                  od;
                  t.dynamic.selectedEntry:= [ 0, 0 ];
                  t.dynamic.selectedCategory:= [ i, level ];
                  n:= BrowseData.HeightCategories( t, i, level - 1 );
                  if i < t.dynamic.topleft[1] or
                     ( i = t.dynamic.topleft[1] and
                       n < t.dynamic.topleft[3] ) then
                    # Make the selected category just visible.
                    BrowseData.ScrollCharactersUpOrLeft( t, "vert",
                        Minimum( BrowseData.HeightCategories( t, i, level ) -
                                 BrowseData.HeightCategories( t, i, level-1 ),
                          Maximum( 1, s ) ) );
                  fi;
                fi;
                t.dynamic.changed:= true;
              fi;
            fi;
          fi;
        fi;
      fi;
    fi;
    return t.dynamic.changed;
end;

BrowseData.ScrollSelectedRowOrCellDown := function( t, roworcell )
    local s, len, selected, i, level, pos, cats, entry, br, j, n;

    s:= BrowseData.NumberFreeCharacters( t, "vert" ) - 1;
    if 0 <= s then
      len:= Length( t.dynamic.indexRow );
      if t.dynamic.selectedCategory <> [ 0, 0 ] and
         t.dynamic.selectedEntry = [ 0, 0 ] then
        # A category is selected.
        # Select the next category of this row if there is one,
        # or the current data row (in the first unhidden column) if unhidden,
        # or the first unhidden category of the next row,
        # or the next unhidden row (in the first unhidden column).
        selected:= t.dynamic.selectedCategory;
        i:= selected[1];
        level:= selected[2];
        pos:= PositionSorted( t.dynamic.categories[1], i );
        cats:= t.dynamic.categories[2];
        while pos <= Length( cats )
              and cats[ pos ].pos = i
              and not cats[ pos ].isUnderCollapsedCategory
              and not cats[ pos ].isRejectedCategory do
          entry:= cats[ pos ];
          if level < entry.level then
            level:= entry.level;
            break;
          fi;
          pos:= pos + 1;
        od;
        if selected[2] < level then
          # There is an unhidden category for row `i' below the selected one;
          # select it.
          t.dynamic.selectedCategory:= [ i, level ];
          t.dynamic.changed:= true;
          br:= BrowseData.BottomOrRight( t, "vert" );
          if IsList( br ) and br[1] = i
                          and br[2] <= BrowseData.HeightCategories( t, i ) then
            # Make the selected category (and its separator) visible.
            BrowseData.ScrollCharactersDownOrRight( t, "vert",
                BrowseData.HeightCategories( t, i, level ) - br[2] );
          fi;
        elif 0 < BrowseData.HeightRow( t, i ) then
          # The last category of `i' is selected, and the data row is unhidden;
          # select the data row, and make at most one screen of it visible.
          j:= BrowseData.TopOrLeft( t, "horz" )[1];
          j:= j + ( j mod 2 );
          while BrowseData.WidthCol( t, j ) = 0 do
            j:= j + 2;
          od;
          t.dynamic.selectedEntry:= [ i, j ];
          t.dynamic.selectedCategory:= [ 0, 0 ];
          t.dynamic.changed:= true;
          br:= BrowseData.BottomOrRight( t, "vert" );
          if IsList( br ) and br[1] = i then
            n:= Sum( List( [ i, i+1 ],
                           x -> BrowseData.LengthCell( t, x, "vert" ) ),
                     - br[2] );
            BrowseData.ScrollCharactersDownOrRight( t, "vert",
                Minimum( n, Maximum( 1, s ) ) );
          fi;
        else
          # The last unhidden category of `i' is selected,
          # the data row is hidden; select the next visible element.
          i:= i + 2;
          while i <= len and BrowseData.LengthCell( t, i, "vert" ) = 0 do
            i:= i + 2;
          od;
          if i <= len then
            pos:= PositionSorted( t.dynamic.categories[1], i );
            cats:= t.dynamic.categories[2];
            if pos <= Length( cats )
               and cats[ pos ].pos = i
               and not cats[ pos ].isUnderCollapsedCategory
               and not cats[ pos ].isRejectedCategory then
              t.dynamic.selectedEntry:= [ 0, 0 ];
              t.dynamic.selectedCategory:= [ i, cats[ pos ].level ];
            else
              j:= BrowseData.TopOrLeft( t, "horz" )[1];
              j:= j + ( j mod 2 );
              while BrowseData.WidthCol( t, j ) = 0 do
                j:= j + 2;
              od;
              t.dynamic.selectedEntry:= [ i, j ];
              t.dynamic.selectedCategory:= [ 0, 0 ];
            fi;
            br:= BrowseData.BottomOrRight( t, "vert" );
            if IsList( br ) and br[1] <= i then
              # Make row `i' and its separator be just visible.
              n:= Sum( List( [ br[1] .. i+1 ],
                             x -> BrowseData.LengthCell( t, x, "vert" ) ),
                       - br[2] );
              BrowseData.ScrollCharactersDownOrRight( t, "vert",
                  Minimum( n, Maximum( 1, s ) ) );
            fi;
            t.dynamic.changed:= true;
          fi;
        fi;
      elif t.dynamic.selectedCategory = [ 0, 0 ] and
           t.dynamic.selectedEntry <> [ 0, 0 ] then
        # A data row is selected.
        selected:= t.dynamic.selectedEntry;
        i:= selected[1];
        br:= BrowseData.BottomOrRight( t, "vert" );
        if   IsList( br ) and i = br[1]
                          and br[2] < BrowseData.LengthCell( t, i, "vert" )
                          and 0 < BrowseData.HeightRow( t, i ) then
          # Show more of this row but scroll by at most one screen.
          n:= Sum( List( [ i, i+1 ],
                         x -> BrowseData.LengthCell( t, x, "vert" ) ),
                   - br[2] );
          BrowseData.ScrollCharactersDownOrRight( t, "vert",
              Minimum( n, Maximum( 1, s ) ) );
          t.dynamic.changed:= true;
        else
          # Scroll down to the next unhidden row,
          # and select the first element of it.
          i:= i + 2;
          if roworcell = "row" or
             ForAll( [ t.dynamic.topleft[2]
                       + ( t.dynamic.topleft[2] mod 2 ) .. selected[2] - 1 ],
                     i -> BrowseData.WidthCol( t, i ) = 0 ) then
            while i < len and BrowseData.LengthCell( t, i, "vert" ) = 0 do
              i:= i + 2;
            od;
          else
            while i < len and BrowseData.HeightRow( t, i ) = 0 do
              i:= i + 2;
            od;
          fi;
          if i < len then
            cats:= t.dynamic.categories[2];
            if roworcell = "row" or
               ForAll( [ t.dynamic.topleft[2]
                         + ( t.dynamic.topleft[2] mod 2 ) .. selected[2] - 1 ],
                       i -> BrowseData.WidthCol( t, i ) = 0 ) then
              pos:= PositionSorted( t.dynamic.categories[1], i );
            else
              pos:= Length( cats ) + 1;
            fi;
            if pos <= Length( cats )
               and cats[ pos ].pos = i
               and not cats[ pos ].isUnderCollapsedCategory
               and not cats[ pos ].isRejectedCategory then
              # Select the first category.
              t.dynamic.selectedEntry:= [ 0, 0 ];
              t.dynamic.selectedCategory:= [ i, cats[ pos ].level ];
              level:= BrowseData.HeightCategories( t, i, cats[ pos ].level );
              if IsList( br ) and ( br[1] < i or
                                    ( br[1] = i and br[2] < level ) ) then
                # Make all categories for row `i' be just visible.
                n:= Sum( List( [ br[1] .. i-1 ],
                               x -> BrowseData.LengthCell( t, x, "vert" ) ),
                         level - br[2] );
                BrowseData.ScrollCharactersDownOrRight( t, "vert",
                    Minimum( n, Maximum( 1, s ) ) );
              fi;
            else
              # There is no category for the next row,
              # select the data row/cell.
              t.dynamic.selectedEntry[1]:= i;
              t.dynamic.selectedCategory:= [ 0, 0 ];
              if IsList( br ) and br[1] <= i then
                # Make the data row `i' and the separator below be just visible.
                n:= Sum( List( [ br[1] .. i+1 ],
                        x -> BrowseData.LengthCell( t, x, "vert" ) ), - br[2] );
                BrowseData.ScrollCharactersDownOrRight( t, "vert",
                    Minimum( n, Maximum( 1, s ) ) );
              fi;
            fi;
            t.dynamic.changed:= true;
          fi;
        fi;
      fi;
    fi;
    return t.dynamic.changed;
end;

BrowseData.actions.ScrollSelectedCellLeft := rec(
  helplines := [ "scroll the selected entry one cell to the left" ],
  action := BrowseData.ScrollSelectedCellLeft );

BrowseData.actions.ScrollSelectedCellRight := rec(
  helplines := [ "scroll the selected entry one cell to the right" ],
  action := BrowseData.ScrollSelectedCellRight );

BrowseData.actions.ScrollSelectedCellUp := rec(
  helplines := [ "scroll the selected entry one cell up" ],
  action := t -> BrowseData.ScrollSelectedRowOrCellUp( t, "cell" ) );

BrowseData.actions.ScrollSelectedCellDown := rec(
  helplines := [ "scroll the selected entry one cell down" ],
  action := t -> BrowseData.ScrollSelectedRowOrCellDown( t, "cell" ) );

BrowseData.ScrollSelectedRowLeft := function( t )
    # Let `BrowseData.ScrollCellUpOrLeft' do the work.
    BrowseData.ScrollCellUpOrLeft( t, "horz" );
    if t.dynamic.selectedEntry <> [ 0, 0 ] then
      t.dynamic.selectedEntry[2]:= t.dynamic.topleft[2];
    fi;
    return t.dynamic.changed;
end;

BrowseData.ScrollSelectedRowRight := function( t )
    # Let `BrowseData.ScrollCellDownOrRight' do the work.
    BrowseData.ScrollCellDownOrRight( t, "horz" );
    if t.dynamic.selectedEntry <> [ 0, 0 ] then
      t.dynamic.selectedEntry[2]:= t.dynamic.topleft[2];
    fi;
    return t.dynamic.changed;
end;

BrowseData.actions.ScrollSelectedRowLeft := rec(
  helplines := [ "scroll the selected row one cell to the left" ],
  action := BrowseData.ScrollSelectedRowLeft );

BrowseData.actions.ScrollSelectedRowRight := rec(
  helplines := [ "scroll the selected row one cell to the right" ],
  action := BrowseData.ScrollSelectedRowRight );

BrowseData.actions.ScrollSelectedRowUp := rec(
  helplines := [ "scroll the selected row one cell up" ],
  action := t -> BrowseData.ScrollSelectedRowOrCellUp( t, "row" ) );

BrowseData.actions.ScrollSelectedRowDown := rec(
  helplines := [ "scroll the selected row one cell down" ],
  action := t -> BrowseData.ScrollSelectedRowOrCellDown( t, "row" ) );


#############################################################################
##
#F  BrowseData.actions.ScrollSelectedColumnLeft.action( <t> )
#F  BrowseData.actions.ScrollSelectedColumnRight.action( <t> )
#F  BrowseData.actions.ScrollSelectedColumnUp.action( <t> )
#F  BrowseData.actions.ScrollSelectedColumnDown.action( <t> )
##
#T document: here no problem because categories play no role!
##
BrowseData.actions.ScrollSelectedColumnLeft := rec(
  helplines := [ "scroll the selected column one cell to the left" ],
  action := BrowseData.actions.ScrollSelectedCellLeft.action );

BrowseData.actions.ScrollSelectedColumnRight := rec(
  helplines := [ "scroll the selected column one cell to the right" ],
  action := BrowseData.actions.ScrollSelectedCellRight.action );

BrowseData.actions.ScrollSelectedColumnDown := rec(
  helplines := [ "scroll the selected column one cell down" ],
  action := BrowseData.actions.ScrollCellDown.action );

BrowseData.actions.ScrollSelectedColumnUp := rec(
  helplines := [ "scroll the selected column one cell up" ],
  action := BrowseData.actions.ScrollCellUp.action );


############################################################################
##
#F  BrowseData.MoveFocusToSelectedCellOrCategory( <t> )
##
##  Change `<t>.dynamic.topleft' such that the selected cell or category
##  becomes visible.
##  This utility is called by `BrowseData.SearchStringWithStartParameters'.
##
BrowseData.MoveFocusToSelectedCellOrCategory := function( t )
    local i, j, bottom, n, right;

    if   t.dynamic.selectedEntry <> [ 0, 0 ] then
      i:= t.dynamic.selectedEntry[1];
      j:= t.dynamic.selectedEntry[2];
    elif t.dynamic.selectedCategory <> [ 0, 0 ] then
      i:= t.dynamic.selectedCategory[1];
      j:= 1;
    else
      # No entry or category is selected.
      # Move the focus to a visible cell.
      if BrowseData.LengthCell( t, t.dynamic.topleft[1], "vert" ) = 0 then
        i:= First( [ t.dynamic.topleft[1]+1 .. Length( t.dynamic.indexRow ) ],
                   x -> BrowseData.LengthCell( t, x, "vert" ) <> 0 );
        if i = fail then
          i:= First( Reversed( [ 1 .. t.dynamic.topleft[1]-1 ] ),
                     x -> BrowseData.LengthCell( t, x, "vert" ) <> 0 );
        fi;
        if i <> fail then
          BrowseData.SetTopOrLeft( t, "vert", i, 1 );
        fi;
      fi;
      if BrowseData.LengthCell( t, t.dynamic.topleft[3], "horz" ) = 0 then
        j:= First( [ t.dynamic.topleft[3]+1 .. Length( t.dynamic.indexCol ) ],
                   x -> BrowseData.LengthCell( t, x, "horz" ) <> 0 );
        if j = fail then
          j:= First( Reversed( [ 1 .. t.dynamic.topleft[3]-1 ] ),
                     x -> BrowseData.LengthCell( t, x, "horz" ) <> 0 );
        fi;
        if j <> fail then
          BrowseData.SetTopOrLeft( t, "horz", j, 1 );
        fi;
      fi;
      return;
    fi;

    bottom:= BrowseData.BottomOrRight( t, "vert" );
    if i < t.dynamic.topleft[1] or
       ( i = t.dynamic.topleft[1] and 1 < t.dynamic.topleft[3] ) then
      # Move up.
      BrowseData.SetTopOrLeft( t, "vert", i, 1 );
    elif IsList( bottom ) and ( i > bottom[1] or
         ( i = bottom[1] and
           t.dynamic.topleft[1] < i and
           t.dynamic.topleft[3]
               < BrowseData.LengthCell( t, i, "vert" ) ) ) then
      # If a category is selected then make it just visible,
      # otherwise make (the first screen of) the selected cell visible:
      # Move down by the height of the cells `bottom[1]', ..., `i-1',
      # minus the part `bottom[2]' (which is already visible),
      # plus the minimum of the height of cell `i' (up to the selected
      # category) and the screen height.
      n:= Sum( List( [ bottom[1] .. i-1 ],
                     x -> BrowseData.LengthCell( t, x, "vert" ) ),
               - bottom[2] )
          + Minimum( BrowseData.NumberFreeCharacters( t, "vert" ),
                     BrowseData.LengthCell( t, i, "vert" ) );
      BrowseData.ScrollCharactersDownOrRight( t, "vert", n );
    fi;
    right:= BrowseData.BottomOrRight( t, "horz" );
    if j < t.dynamic.topleft[2] or
       ( j = t.dynamic.topleft[2] and 1 < t.dynamic.topleft[4] ) then
      # Move left.
      BrowseData.SetTopOrLeft( t, "horz", j, 1 );
    elif IsList( right ) and ( j > right[1] or
         ( j = right[1] and
           t.dynamic.topleft[2] < j and
           t.dynamic.topleft[4] < BrowseData.WidthCol( t, j ) ) ) then
      # Move right by the width of the cells `right[1]', ..., `j-1',
      # minus the part `right[2]' (which is already visible),
      # plus the minimum of the width of cell `j' and the screen width.
      n:= Sum( List( [ right[1] .. j-1 ],
                     x -> BrowseData.WidthCol( t, x ) ), - right[2] )
          + Minimum( BrowseData.NumberFreeCharacters( t, "horz" ),
                     BrowseData.LengthCell( t, j, "horz" ) );
      BrowseData.ScrollCharactersDownOrRight( t, "horz", n );
    fi;
  end;


############################################################################
##
#F  BrowseData.SearchStringWithStartParameters( <t>, <selEntry>, <selCat> )
#F  BrowseData.actions.SearchFirst.action( <t> )
#F  BrowseData.actions.SearchFurther.action( <t> )
##
BrowseData.SearchStringWithStartParameters:= function( t, selEntry, selCat )
    local direction, entry, wrap, case, mode, type, negate, searchCategories,
          flag, searchdomain, startrow, startcol, startcat, i, j, s, bottom,
          n, right;

    # If the search string is empty then do nothing.
    if not IsBound( t.dynamic.searchString )
       or IsEmpty( t.dynamic.searchString ) then
      return;
    fi;

    # Evaluate the search parameters:
    # - forwards (default) or backwards?
    # - row by row (default) or column by column?
    # - wrap around (default) or not?
    # - case sensitive (default) or not?
    # - search for (1) any substring or (2) for whole entries?
    #   - in case (1), search for substring, word, prefix, suffix?
    #   - in case (2), compare via <, <=, =, >=, >, <>?
    # - negated search or not (default)?
    direction:= [ "forwards", "row by row" ];
    for entry in t.dynamic.searchParameters do
      if entry[1] = "search" then
        if entry[2][1] = "forwards" then
          direction[1]:= entry[2][ entry[3] ];
        else
          direction[2]:= entry[2][ entry[3] ];
        fi;
      elif entry[1] = "wrap around" then
        wrap:= ( entry[2][ entry[3] ] = "yes" );
      elif entry[1] = "case sensitive" then
        case:= ( entry[2][ entry[3] ] = "yes" );
      elif entry[1] = "mode" then
        mode:= entry[2][ entry[3] ];
      elif entry[1] = "search for" and mode = "substring" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "compare with" and mode = "whole entry" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "negate" then
        negate:= ( entry[2][ entry[3] ] = "yes" );
      fi;
    od;

    # A category for row `i' can match only if
    # all categories for strictly smaller level at row `i' are expanded.
    searchCategories:= function( i, startlevel )
#T make this a global component?
        local list, pos, cats, entry;

        # Collect the unhidden categories for row `i'.
        list:= [];
        pos:= PositionSorted( t.dynamic.categories[1], i );
        cats:= t.dynamic.categories[2];
        while pos <= Length( cats )
              and cats[ pos ].pos = i
              and not cats[ pos ].isUnderCollapsedCategory
              and not cats[ pos ].isRejectedCategory do
          entry:= cats[ pos ];
          Add( list, entry );
          pos:= pos + 1;
        od;

        # Take `startlevel' into account.
        if direction[1] = "forwards" then
          list:= Filtered( list, x -> x.level >= startlevel );
        else
          list:= Reversed( Filtered( list, x -> x.level <= startlevel ) );
        fi;
        for entry in list do
          if BrowseData.StringMatch( t, entry.value, 0, case, mode, type,
                                     negate, false )
             then
            # This category will be selected.
            t.dynamic.changed:= true;
            j:= - entry.level;
            return true;
          fi;
        od;
        return false;
    end;

    flag:= BrowseData.CurrentMode( t ).flag;
    if   flag in [ "browse", "select_entry" ] then
      # Search in the whole table (categories and entries).
      searchdomain:= "in the main table";
      if direction[1] = "forwards" then

        if direction[2] = "row by row" then

          # Search forwards, row by row.
          if selCat = [ 0, 0 ] then
            startrow:= selEntry[1];
            if startrow = 0 then
              # Consider all categories.
              startrow:= 2;
              startcol:= 2;
              startcat:= 1;
            else
              # Ignore categories.
              startcol:= selEntry[2] + 2;
              startcat:= Length( t.dynamic.categories[1] );
            fi;
          else
            # Start with the next category level.
            startrow:= selCat[1];
            startcol:= 2;
            startcat:= selCat[2] + 1;
          fi;

          for i in [ startrow, startrow + 2
                     .. Length( t.dynamic.indexRow ) - 1 ] do
            # Search in the categories of the `i'-th row.
            if startcol = 2 and searchCategories( i, startcat ) then
              break;
            fi;

            # Search in the `i'-th table row.
            for j in [ startcol, startcol + 2
                       .. Length( t.dynamic.indexCol ) - 1 ] do
              if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                         false )
              then
                t.dynamic.changed:= true;
                break;
              fi;
            od;
            if t.dynamic.changed then
              break;
            fi;

            # In the new row, start from the first column,
            # and consider all categories.
            startcol:= 2;
            startcat:= 1;

          od;

        else

          # Search forwards, column by column.
          if selCat = [ 0, 0 ] then
            startcol:= selEntry[2];
            if startcol = 0 then
              # Consider all categories.
              startcol:= 2;
              startrow:= 2;
              startcat:= 1;
            else
              # Ignore categories if `startcol > 2'.
              startrow:= selEntry[1] + 2;
              startcat:= 1;
            fi;
          else
            # Start with the next category level.
            startrow:= selCat[1];
            startcol:= 2;
            startcat:= selCat[2] + 1;
          fi;

          for j in [ startcol, startcol + 2
                     .. Length( t.dynamic.indexCol ) - 1 ] do
            for i in [ startrow, startrow + 2
                       .. Length( t.dynamic.indexRow ) - 1 ] do
              # Search in the categories of the `i'-th row.
              if j = 2 and searchCategories( i, startcat ) then
                break;
              fi;

              # Search in the table columns.
              if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                         false )
              then
                 t.dynamic.changed:= true;
                 break;
              fi;

              # In the new row, consider all categories.
              startcat:= 1;
            od;
            if t.dynamic.changed then
              break;
            fi;
            startrow:= 2;
          od;
        fi;
      else
        if direction[2] = "row by row" then
          # Search backwards, row by row.
          if selCat = [ 0, 0 ] then
            startrow:= selEntry[1];
            if startrow = 0 then
              # Consider all categories.
              startrow:= Length( t.dynamic.indexRow ) - 1;
              startcol:= Length( t.dynamic.indexCol ) - 1;
            else
              # Consider all categories.
              startcol:= selEntry[2] - 2;
            fi;
          else
            # First finish the categories in the current row.
            if searchCategories( i, selCat[2] - 1 ) then
              # Do not search further.
              startrow:= 0;
            else
              # Go to the previous row, consider all categories.
              startrow:= selCat[1] - 2;
              startcol:= 2;
            fi;
          fi;

          for i in [ startrow, startrow - 2 .. 2 ] do
            # Search in the table rows.
            for j in [ startcol, startcol - 2 .. 2 ] do
              if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                         false )
              then
                t.dynamic.changed:= true;
                break;
              fi;
            od;
            if t.dynamic.changed then
              break;
            fi;

            # Search in the categories.
            if searchCategories( i, Length( t.dynamic.categories[1] ) ) then
              break;
            fi;

            startcol:= Length( t.dynamic.indexCol ) - 1;
          od;
        else
          # Search backwards, column by column.
          if selCat = [ 0, 0 ] then
            startcol:= selEntry[2];
            if startcol = 0 then
              # Consider all categories.
              startcol:= Length( t.dynamic.indexCol ) - 1;
              startrow:= Length( t.dynamic.indexRow ) - 1;
            else
              # Consider all categories.
              startrow:= selEntry[1] - 2;
            fi;
          else
            # First finish the categories in the current row.
            if searchCategories( i, selCat[2] - 1 ) then
              # Do not search further.
              startcol:= 0;
            else
              # Go to the previous row, consider all categories.
              startrow:= selCat[1] - 2;
              startcol:= 2;
            fi;
          fi;

          for j in [ startcol, startcol - 2 .. 2 ] do
            for i in [ startrow, startrow - 2 .. 2 ] do

              # Search in the table columns.
              if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                         false )
              then
                t.dynamic.changed:= true;
                break;
              fi;

              # Search in the categories.
              if j = 2 and
                 searchCategories( i, Length( t.dynamic.categories[1] ) ) then
                break;
              fi;

            od;
            if t.dynamic.changed then
              break;
            fi;
            startrow:= Length( t.dynamic.indexRow ) - 1;
          od;
        fi;
      fi;
    elif flag in [ "select_row", "select_row_and_entry" ] then
      # Search in the selected row (ignore categories).
      searchdomain:= "in the selected row";
      if t.dynamic.selectedCategory = [ 0, 0 ] then
        i:= t.dynamic.selectedEntry[1];
        if direction[1] = "forwards" then
          for j in [ selEntry[2]+2, selEntry[2]+4
                     .. Length( t.dynamic.indexCol ) - 1 ] do
            if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                       false )
            then
              t.dynamic.changed:= true;
              break;
            fi;
          od;
        else
          for j in [ selEntry[2]-2, selEntry[2]-4 .. 2 ] do
            if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                       false )
            then
              t.dynamic.changed:= true;
              break;
            fi;
          od;
        fi;
      fi;
    elif flag in [ "select_column", "select_column_and_entry" ] then
      # Search in the selected column (ignore categories).
      searchdomain:= "in the selected column";
      if t.dynamic.selectedCategory = [ 0, 0 ] then
        j:= t.dynamic.selectedEntry[2];
        if direction[1] = "forwards" then
          for i in [ selEntry[1]+2, selEntry[1]+4
                     .. Length( t.dynamic.indexRow ) - 1 ] do
            if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                       false )
            then
              t.dynamic.changed:= true;
              break;
            fi;
          od;
        else
          for i in [ selEntry[1]-2, selEntry[1]-4 .. 2 ] do
            if BrowseData.StringMatch( t, i, j, case, mode, type, negate,
                                       false )
            then
              t.dynamic.changed:= true;
              break;
            fi;
          od;
        fi;
      fi;
    else
      return;
    fi;

    if t.dynamic.changed then
      # Select the current entry or category, ...
      if j < 0 then
        t.dynamic.selectedCategory:= [ i, -j ];
        t.dynamic.selectedEntry:= [ 0, 0 ];
        j:= 1;
      else
        t.dynamic.selectedCategory:= [ 0, 0 ];
        t.dynamic.selectedEntry:= [ i, j ];
      fi;

      # ... switch to the mode where a cell or a category is selected
      # if this mode is available, ...
      if   flag = "browse" then
        BrowseData.PushMode( t, "select_entry" );
      elif flag = "select_row" then
        BrowseData.PushMode( t, "select_row_and_entry" );
      elif flag = "select_column" then
        BrowseData.PushMode( t, "select_column_and_entry" );
      fi;

      # ... and move the window such that the selected cell or category
      # becomes visible.
      BrowseData.MoveFocusToSelectedCellOrCategory( t );

    elif wrap and ( selEntry <> [ 0, 0 ] or selCat <> [ 0, 0 ] ) then

      # Wrap around.
      BrowseData.SearchStringWithStartParameters( t, [ 0, 0 ], [ 0, 0 ] );

    else

      # Print a message that the given string was not found.
      BrowseData.AlertWithReplay( t,
          [ Concatenation( "pattern not found ", searchdomain, ":" ),
            t.dynamic.searchString ],
          NCurses.attrs.BOLD );
    fi;
end;

BrowseData.actions.SearchFirst := rec(
  helplines := [ "search for a string" ],
  action := function( t )
    local str;

    # Get the search pattern.
    str:= BrowseData.GetPatternEditParameters(
              [ NCurses.attrs.BOLD, "enter a search string: " ],
              t.dynamic.searchString,
              t.dynamic.searchParameters,
              t );
    if NCurses.IsStdoutATty() then
      NCurses.curs_set( 0 );
    fi;

    if str <> fail then
      t.dynamic.searchString:= str;

      # Find the string in the table/row/column (depending on the mode),
      # without restriction on start parameters.
      BrowseData.SearchStringWithStartParameters( t, t.dynamic.selectedEntry,
                                                t.dynamic.selectedCategory );
    fi;
  end );

BrowseData.actions.SearchFurther := rec(
  helplines := [ "search further for the last search string" ],
  action := function( t )
    # Search with the given start parameters.
    BrowseData.SearchStringWithStartParameters( t, t.dynamic.selectedEntry,
                                                t.dynamic.selectedCategory );
  end );


#############################################################################
##
#F  BrowseData.HideOrUnhideColumnsOrRows( <t>, <direction>, <selection>,
#F                                        <flag> )
#F  BrowseData.actions.HideCurrentRow.action( <t> )
#F  BrowseData.actions.HideCurrentColumn.action( <t> )
##
##  This function is intended for hiding/unhiding a set of rows or columns,
##  in the same way as `BrowseData.FilterTable' hides non-matching rows or
##  columns.
##  This affects the component `dynamic.isRejectedRow' or
##  `dynamic.isRejectedCol' of the browse table.
##
BrowseData.HideOrUnhideColumnsOrRows:= function( t, direction, selection,
                                                 flag )
    local hide, pos, i, min;

    if   IsEmpty( selection ) then
      return;
    elif direction = "row" then
      hide:= t.dynamic.isRejectedRow;
      pos:= 1;
    else
      hide:= t.dynamic.isRejectedCol;
      pos:= 2;
    fi;

    # Hide or unhide the selected rows/columns.
    for i in selection do
      hide[i]:= flag;
    od;

    if direction = "row" then
      # Restrict the categories according to the new matches.
      BrowseData.RestrictCategories( t );
    fi;

    # Make sure that the selected row/column is unhidden.
    BrowseData.MoveSelectionToUnhiddenEntryOrCategory( t, true );
    BrowseData.MoveFocusToSelectedCellOrCategory( t );

    t.dynamic.changed:= true;
  end;

BrowseData.actions.HideCurrentRow := rec(
  helplines := [ "hide the selected row" ],
  action := function( t )
    if t.dynamic.selectedEntry <> [ 0, 0 ] then
      BrowseData.HideOrUnhideColumnsOrRows( t, "row",
        [ t.dynamic.selectedEntry[1], t.dynamic.selectedEntry[1]+1 ], true );
    fi;
  end );

BrowseData.actions.HideCurrentColumn := rec(
  helplines := [ "hide the selected column" ],
  action := function( t )
    if t.dynamic.selectedEntry <> [ 0, 0 ] then
      BrowseData.HideOrUnhideColumnsOrRows( t, "column",
        [ t.dynamic.selectedEntry[2], t.dynamic.selectedEntry[2]+1 ], true );
    fi;
  end );


#############################################################################
##
#F  BrowseData.SetSortParameters( <t>, <col_or_row>, <pos>, <values> )
##
BrowseData.SetSortParameters:= function( t, col_or_row, pos, values )
    local paras, i, entry;

    if not IsBound( t.dynamic ) then
      t.dynamic:= rec();
    fi;
    if col_or_row = "row" then
      if IsBound( t.dynamic.sortParametersForRowsDefault ) then
        paras:= StructuralCopy( t.dynamic.sortParametersForRowsDefault );
      else
        paras:= StructuralCopy(
            BrowseData.defaults.dynamic.sortParametersForRowsDefault );
      fi;
      if not IsBound( t.dynamic.sortParametersForRows ) then
        t.dynamic.sortParametersForRows:= [];
      fi;
      t.dynamic.sortParametersForRows[ pos ]:= paras;
    else
      if IsBound( t.dynamic.sortParametersForColumnsDefault ) then
        paras:= StructuralCopy( t.dynamic.sortParametersForColumnsDefault );
      else
        paras:= StructuralCopy(
            BrowseData.defaults.dynamic.sortParametersForColumnsDefault );
      fi;
      if not IsBound( t.dynamic.sortParametersForColumns ) then
        t.dynamic.sortParametersForColumns:= [];
      fi;
      t.dynamic.sortParametersForColumns[ pos ]:= paras;
    fi;
    for i in [ 1, 3 .. Length( values )-1 ] do
      entry:= First( paras, x -> x[1] = values[i] );
      if entry <> fail and values[ i+1 ] in entry[2] then
        entry[3]:= Position( entry[2], values[ i+1 ] );
      fi;
    od;
end;


#############################################################################
##
#F  BrowseData.SortTableByColumnsOrRows( <t>, <positions>, <direction> )
#F  BrowseData.actions.SortTableByColumn.action( <t> )
#F  BrowseData.actions.SortTableByRow.action( <t> )
##
##  If we sort by columns and if there are categories then we first remove
##  all categories (in particular expand all rows),
##  reset all rows to not rejected, and reset the ordering of rows.
##
##  Otherwise we reset the current sorting but keep the rejected rows/columns,
##  and then sort by the rows or columns in <positions>.
##
BrowseData.SortTableByColumnsOrRows:= function( t, positions, direction )
    local paras, sortfuns, j, sortdir, case_sensitive, para, tosort, n, i,
          col, entries, entry, str, perm, extperm;

    # Evaluate the sort parameters.
    paras:= [];
    sortfuns:= [];
    if direction  = "vert" then
      for j in t.dynamic.indexCol{ positions } / 2 do
        if IsBound( t.dynamic.sortParametersForColumns[j] ) then
          Add( paras, t.dynamic.sortParametersForColumns[j] );
        else
          Add( paras, t.dynamic.sortParametersForColumnsDefault );
        fi;
        if IsBound( t.dynamic.sortFunctionsForColumns[j] ) then
          Add( sortfuns, t.dynamic.sortFunctionsForColumns[j] );
        else
          Add( sortfuns, t.dynamic.sortFunctionForColumnsDefault );
        fi;
      od;
    else
      for j in t.dynamic.indexRow{ positions } / 2 do
        if IsBound( t.dynamic.sortParametersForRows[j] ) then
          Add( paras, t.dynamic.sortParametersForRows[j] );
        else
          Add( paras, t.dynamic.sortParametersForRowsDefault );
        fi;
        if IsBound( t.dynamic.sortFunctionsForRows[j] ) then
          Add( sortfuns, t.dynamic.sortFunctionsForRows[j] );
        else
          Add( sortfuns, t.dynamic.sortFunctionForRowsDefault );
        fi;
      od;
    fi;
    sortdir:= [];
    case_sensitive:= [];
    for j in [ 1 .. Length( paras ) ] do
      para:= First( paras[j], x -> x[1] = "direction" );
      sortdir[j]:= para[2][ para[3] ];
      case_sensitive[j]:= First( paras[j],
                                 x -> x[1] = "case sensitive" )[3] = 1;
    od;

    if direction  = "vert" then
      if not IsEmpty( t.dynamic.categories[1] ) then
        # Remove category information, and reset the reject information.
        t.dynamic.categories:= [ [], [], [] ];
        t.dynamic.selectedCategory:= [ 0, 0 ];
        t.dynamic.isCollapsedRow:= ListWithIdenticalEntries(
            Length( t.dynamic.isCollapsedRow ), false );
        t.dynamic.isCollapsedCol:= ListWithIdenticalEntries(
            Length( t.dynamic.isCollapsedCol ), false );
        t.dynamic.isRejectedRow:= ListWithIdenticalEntries(
            Length( t.dynamic.isRejectedRow ), false );
      else
        # Keep the reject information, so rewrite it.
        t.dynamic.isRejectedRow{ t.dynamic.indexRow }:=
            ShallowCopy( t.dynamic.isRejectedRow );
      fi;
      # Reset the ordering by rows.
      if t.dynamic.selectedEntry <> [ 0, 0 ] then
        t.dynamic.selectedEntry[1]:= t.dynamic.indexRow[
                                         t.dynamic.selectedEntry[1] ];
      fi;
      t.dynamic.indexRow:= [ 1 .. Length( t.dynamic.indexRow ) ];
    else
      # Reset the ordering by columns, keep the reject information.
      t.dynamic.isRejectedCol{ t.dynamic.indexCol }:=
          ShallowCopy( t.dynamic.isRejectedCol );
      if t.dynamic.selectedEntry <> [ 0, 0 ] then
        t.dynamic.selectedEntry[2]:= t.dynamic.indexCol[
                                         t.dynamic.selectedEntry[2] ];
      fi;
      t.dynamic.indexCol:= [ 1 .. Length( t.dynamic.indexCol ) ];
    fi;

    # Consider the indirection of the wanted rows or columns.
    tosort:= [];
    if direction  = "vert" then
      n:= t.work.m;
      positions:= List( positions, i -> t.dynamic.indexCol[i] / 2 );
    else
      n:= t.work.n;
      positions:= List( positions, i -> t.dynamic.indexRow[i] / 2 );
    fi;

    for i in [ 1 .. n ] do
      entries:= [];
      for col in [ 1 .. Length( positions ) ] do
        j:= positions[ col ];
        entry:= "";
        if direction  = "vert" then
          if   IsBound( t.work.mainFormatted[ 2*i ] ) and
               IsBound( t.work.mainFormatted[ 2*i ][ 2*j ] ) then
            entry:= t.work.mainFormatted[ 2*i ][ 2*j ];
          elif IsBound( t.work.main[i] ) and
               IsBound( t.work.main[i][j] ) then
            entry:= t.work.main[i][j];
          elif IsFunction( t.work.Main ) then
            entry:= t.work.Main( t, i, j );
          fi;
        else
          if   IsBound( t.work.mainFormatted[ 2*j ] ) and
               IsBound( t.work.mainFormatted[ 2*j ][ 2*i ] ) then
            entry:= t.work.mainFormatted[ 2*j ][ 2*i ];
          elif IsBound( t.work.main[j] ) and
               IsBound( t.work.main[j][i] ) then
            entry:= t.work.main[j][i];
          elif IsFunction( t.work.Main ) then
            entry:= t.work.Main( t, j, i );
          fi;
        fi;
        if NCurses.IsAttributeLine( entry ) then
          entry:= [ entry ];
        elif IsRecord( entry ) then
          entry:= entry.rows;
        fi;
        str:= NormalizedWhitespace( Concatenation( List( entry,
                  NCurses.SimpleString ) ) );
#T support a matrix of simple strings, store them as needed!
#T [as for search]
        if not case_sensitive[ col ] then
          str:= LowercaseString( str );
        fi;
        Add( entries, str );
      od;
      tosort[i]:= entries;
    od;
    perm:= BrowseData.SortStableIndirection( tosort,
               [ 1 .. Length( tosort ) ], sortfuns, sortdir );
    extperm:= [ 1 ];
    for i in [ 1 .. Length( perm ) ] do
      extperm[ 2*i ]:= 2 * perm[i];
      extperm[ 2*i+1 ]:= 2 * perm[i] + 1;
    od;
    if direction  = "vert" then
      t.dynamic.indexRow:= extperm;
      t.dynamic.isRejectedRow:= t.dynamic.isRejectedRow{ extperm };
      if t.dynamic.selectedEntry[1] <> 0 then
        t.dynamic.selectedEntry[1]:= Position( extperm,
            t.dynamic.selectedEntry[1] );
      fi;
    else
      t.dynamic.indexCol:= extperm;
      t.dynamic.isRejectedCol:= t.dynamic.isRejectedCol{ extperm };
      if t.dynamic.selectedEntry[2] <> 0 then
        t.dynamic.selectedEntry[2]:= Position( extperm,
            t.dynamic.selectedEntry[2] );
      fi;
    fi;

    t.dynamic.changed:= true;
  end;

BrowseData.actions.SortTableByColumn := rec(
  helplines := [ "sort by the selected column" ],
  action := function( t )
    BrowseData.SortTableByColumnsOrRows( t, [ t.dynamic.selectedEntry[2] ],
                                         "vert" );
  end );

BrowseData.actions.SortTableByRow := rec(
  helplines := [ "sort by the selected row" ],
  action := function( t )
    BrowseData.SortTableByColumnsOrRows( t, [ t.dynamic.selectedEntry[1] ],
                                         "horz" );
  end );


#############################################################################
##
#F  BrowseData.RestrictCategories( <t> )
##
##  Hide all those categories for which all table rows are hidden.
##
BrowseData.RestrictCategories := function( t )
    local cats, i, currcat, currlevel, nextcatpos, pos;

    cats:= t.dynamic.categories[2];
    for i in [ 1 .. Length( cats ) ] do
      # Consider a category above row i1, of level l,
      # such that the next category (if there is one)
      # of level at most l is above row i2.
      # This category is not rejected only if one of the rows i1, ... i2-1
      # is not rejected.
      currcat:= cats[i];
      currlevel:= currcat.level;
      nextcatpos:= false;
      for pos in [ i+1 .. Length( cats ) ] do
        if cats[ pos ].level <= currlevel then
          nextcatpos:= cats[ pos ].pos;
          break;
        fi;
      od;
      if nextcatpos = false then
        nextcatpos:= Length( t.dynamic.isRejectedRow ) + 1;
      fi;
      currcat.isRejectedCategory:= ForAll(
          [ currcat.pos .. nextcatpos - 1 ],
          i -> t.dynamic.isRejectedRow[i] );
    od;
  end;


#############################################################################
##
#F  BrowseData.SortAndCategorizeTableByColumn( <t>, <column>, <isexpanded> )
#F  BrowseData.actions.SortAndCategorizeTable.action( <t> )
##
##  First categories are computed for the data rows in the main table,
##  w.r.t. the column position <columns>,
##  where the values in this column are transformed into level $1$ categories
##  --note that more than one category can belong to a row.
##
##  The levels of already existing categories are increased by $1$.
##  (This way one can create a category hierarchy.
##  We decided to create new categories on the outermost level because this
##  allows us to keep an existing categorization with perhaps not uniform
##  level distribution.)
##
##  The new categories get sorted,
##  the table rows are assigned to their categories,
##  and the rows and the previously existing categories are sorted inside the
##  new categories.
##
##  If <isexpanded> is `false' then all data rows and all categories at level
##  at least two become collapsed.
##  Depending on the column sort parameters of <t>,
##  the column <column> becomes collapsed or not.
##
BrowseData.SortAndCategorizeTableByColumn:= function( t, column, isexpanded )
    local j, paras, sortfun, hide, sortdir, case_sensitive, entry,
          allcategories, rowcategories, n, i, tosort, map, map2, rowsofcats,
          cat, pos, oldcats, len, indir, oldcategorypaths, currpath,
          currlevel, perm, collapsed, rejected, categories, c, occur, hlcats,
          pos2, hlcatsanddata, currcat, usedrows;

    # Evaluate the sort parameters.
    j:= t.dynamic.indexCol[ column ] / 2;
    if IsBound( t.dynamic.sortParametersForColumns[j] ) then
      paras:= t.dynamic.sortParametersForColumns[j];
    else
      paras:= t.dynamic.sortParametersForColumnsDefault;
    fi;
    if IsBound( t.dynamic.sortFunctionsForColumns[j] ) then
      sortfun:= t.dynamic.sortFunctionsForColumns[j];
    else
      sortfun:= t.dynamic.sortFunctionForColumnsDefault;
    fi;
    hide:= First( paras, x -> x[1] = "hide on categorizing" )[3] = 1;
    sortdir:= First( paras, x -> x[1] = "direction" );
    sortdir:= sortdir[2][ sortdir[3] ];
    case_sensitive:= First( paras, x -> x[1] = "case sensitive" )[3] = 1;

    # Compute new category values for all data rows
    # (also for the rejected ones).
    allcategories:= [];
    rowcategories:= [];
    n:= t.work.m;
    for i in [ 1 .. n ] do
      rowcategories[i]:= t.work.CategoryValues( t, 2*i,
                             t.dynamic.indexCol[ column ] );
    od;
    allcategories:= Set( Concatenation( rowcategories ) );

    # Sort the new categories (according to their simplifications).
    if case_sensitive then
      tosort:= List( allcategories,
                     x -> [ NCurses.SimpleString( x ) ] );
    else
      tosort:= List( allcategories,
                     x -> [ LowercaseString( NCurses.SimpleString( x ) ) ] );
    fi;
    map:= BrowseData.SortStableIndirection( tosort,
              [ 1 .. Length( tosort ) ], [ sortfun ], [ sortdir ] );
    map2:= Sortex( allcategories );

    # Assign rows to each category.
    rowsofcats:= List( allcategories, x -> [] );
    for i in [ 1 .. n ] do
      for cat in rowcategories[i] do
        pos:= PositionSorted( allcategories, cat );
        Add( rowsofcats[ pos ^ map2 ], i );
      od;
    od;

    # Compute where in the current table the rows are shown.
    oldcats:= t.dynamic.categories;
    indir:= List( [ 1 .. n ], x -> [] );
    for i in [ 1 .. n ] do
      Add( indir[ t.dynamic.indexRow[ 2*i ] / 2 ], i );
    od; 
    for i in [ 1 .. n ] do
      indir[i]:= Set( indir[i] );
    od; 

    # If there are already category rows then compute
    # the categories path for each row.
    # And increase the level of each existing category.
    oldcategorypaths:= [ [], [] ];
    if 0 < Length( oldcats[1] ) then
      currpath:= [];
      currlevel:= 0;
      pos:= 2;
      for entry in oldcats[2] do
        if entry.pos > pos then
          Add( oldcategorypaths[1], pos );
          Add( oldcategorypaths[2], ShallowCopy( currpath ) );
        fi;
        pos:= entry.pos;
        if entry.level > currlevel then
          Add( currpath, entry );
        else
          currpath[ entry.level ]:= entry;
          for i in [ entry.level + 1 .. currlevel ] do
            Unbind( currpath[i] );
          od;
        fi;
        currlevel:= entry.level;
        entry.level:= entry.level + 1;
      od;
      Add( oldcategorypaths[1], pos );
      Add( oldcategorypaths[2], ShallowCopy( currpath ) );
    fi;

    # Create the category rows, and sort the table accordingly.
    perm:= [ 1 ];
    collapsed:= [];
    rejected:= [];
    categories:= [];
    pos:= 2;
    len:= Length( oldcategorypaths[1] );
    for c in [ 1 .. Length( map ) ] do
      cat:= allcategories[ map[c] ];
      Add( categories, rec( pos:= pos,
                            level:= 1,
                            value:= cat,
                            separator:= t.work.sepCategories,
                            isUnderCollapsedCategory:= false,
                            isRejectedCategory:= false ) );

      # Compute the indirection for the rows under this category,
      # and distribute the existing categorization if applicable.
      if Length( oldcats[1] ) = 0 then
        for i in rowsofcats[ map[c] ] do
          perm[ pos ]:= 2 * i;
          perm[ pos+1 ]:= perm[ pos ] + 1;
          if ForAll( indir[i], x -> t.dynamic.isRejectedRow[ 2 * x ] ) then
            Append( rejected, [ pos, pos+1 ] );
          fi;
          if ForAll( indir[i], x -> t.dynamic.isCollapsedRow[ 2 * x ] )
             or not isexpanded then
            Append( collapsed, [ pos, pos+1 ] );
          fi;
          pos:= pos+2;
        od;
      else
        # For all occurrences of the rows in question in the table,
        # fetch the higher level categories belonging to these occurrences.
        occur:= Union( indir{ rowsofcats[ map[c] ] } );
        hlcats:= [];
        for i in 2 * occur do
          pos2:= PositionSorted( oldcategorypaths[1], i );
          if pos2 > len then
            pos2:= len;
          elif oldcategorypaths[1][ pos2 ] > i then
            if pos2 = 1 then
              # no category row
              pos2:= fail;
            else
              pos2:= pos2-1;
            fi;
          fi;
          if pos2 <> fail then
            Append( hlcats, List( oldcategorypaths[2][ pos2 ],
                                  x -> [ x.pos, x.level, x, i ] ) );
          fi;
        od;

        # Compute the succession of category rows and data rows,
        # starting from the end.
        # (Note that there may be data rows only under low level categories.)
        Sort( hlcats );
        hlcatsanddata:= [];
        currcat:= fail;
        usedrows:= [];
        for entry in Reversed( hlcats ) do
          if entry[3] <> currcat then
            if currcat = fail or entry[3].level > currcat.level then
              usedrows:= [];
            fi;
            if currcat <> fail then
              Add( hlcatsanddata, [ "cat", currcat ] );
            fi;
            currcat:= entry[3];
          fi;
          if not entry[4] in usedrows then
            Add( hlcatsanddata, [ "data", entry[4] ] );
            Add( usedrows, entry[4] );
          fi;
        od;
        Add( hlcatsanddata, [ "cat", currcat ] );

        # Keep the order of categories in the old table.
        # (But note that the rows inside these categories are sorted
        # as in the unsorted table.)
        # extend the category rows and the row distribution.
        for entry in Reversed( hlcatsanddata ) do
          if entry[1] = "cat" then
            # Add the higher level category row.
            # The collapse status is kept, except that the category row
            # is collapsed if `isexpanded' is `false'.
            cat:= ShallowCopy( entry[2] );
            cat.pos:= pos;
            cat.isUnderCollapsedCategory:=
                 cat.isUnderCollapsedCategory or not isexpanded;
            Add( categories, cat );
          else
            # Add the data row in the current position.
            # (Keep reject and collapse status.)
            perm[ pos ]:= t.dynamic.indexRow[ entry[2] ];
            perm[ pos+1 ]:= perm[ pos ] + 1;
            if t.dynamic.isRejectedRow[ entry[2] ] then
              Append( rejected, [ pos, pos+1 ] );
            fi;
            if t.dynamic.isCollapsedRow[ entry[2] ] or not isexpanded then
              Append( collapsed, [ pos, pos+1 ] );
            fi;
            pos:= pos+2;
          fi;
        od;
      fi;
    od;

    # Store the categories, adjust the counter information.
    t.dynamic.categories:= [ List( categories, x -> x.pos ), categories,
                             oldcats[3] + 1 ];
    if First( paras, x -> x[1] = "add counter on categorizing" )[3] = 1 then
      t.dynamic.categories[3]:= Concatenation( [ 1 ], oldcats[3] + 1 );
    fi;
    t.dynamic.indexRow:= perm;

    # Hide the columns if applicable.
    if hide then
      t.dynamic.isCollapsedCol[ column ]:= true;
      t.dynamic.isCollapsedCol[ column+1 ]:= true;
    fi;

    # Collapse all table rows if applicable.
    t.dynamic.isCollapsedRow:= BlistList( [ 1 .. Length( perm ) ],
                                          collapsed );
    t.dynamic.isRejectedRow:= BlistList( [ 1 .. Length( perm ) ], rejected );

    # Hide categories for which all rows are hidden.
    BrowseData.RestrictCategories( t );

    t.dynamic.changed:= true;
end;

BrowseData.actions.SortAndCategorizeTable := rec(
  helplines := [ "sort and categorize by the selected column" ],
  action := function( t )
    BrowseData.SortAndCategorizeTableByColumn( t,
                 t.dynamic.selectedEntry[2], false );
    Unbind( t.dynamic.activeModes[ Length( t.dynamic.activeModes ) ] );
    t.dynamic.selectedEntry:= [ 0, 0 ];
    t.dynamic.selectedCategory:= [ 0, 0 ];
    t.dynamic.topleft{ [ 2, 4 ] }:= [ 1, 1 ];
#T assumes that select col. mode shall be left!
  end );


#############################################################################
##
#F  BrowseData.MoveSelectionToUnhiddenEntryOrCategory( <t>, <movetocat> )
##
BrowseData.MoveSelectionToUnhiddenEntryOrCategory := function( t, movetocat )
    local sel, roworcell;

    if   t.dynamic.selectedEntry <> [ 0, 0 ] then
      sel:= ShallowCopy( t.dynamic.selectedEntry );
      if BrowseData.LengthCell( t, sel[2], "horz" ) = 0 then
        # Move horizontally to an unhidden position, first to the left, ...
        BrowseData.ScrollSelectedCellLeft( t );
        if sel = t.dynamic.selectedEntry then
          # ... then to the right.
          BrowseData.ScrollSelectedCellRight( t );
        fi;
        if sel = t.dynamic.selectedEntry then
          # There is no unhidden column, leave the selection mode.
          BrowseData.actions.QuitMode.action( t );
          t.dynamic.changed:= true;
          return;
        fi;
      fi;
      # If a row (variable `movetocat') or a hidden cell in the first
      # unhidden column is selected then we may also move to a category.
      if movetocat then
        roworcell:= "row";
      else
        roworcell:= "cell";
      fi;
      sel:= t.dynamic.selectedEntry;
      if BrowseData.HeightRow( t, sel[1] ) = 0 then
        # Move vertically to an unhidden position, first up, ...
        BrowseData.ScrollSelectedRowOrCellUp( t, roworcell );
        if sel = t.dynamic.selectedEntry then
          # ... then down.
          BrowseData.ScrollSelectedRowOrCellDown( t, roworcell );
        fi;
        if sel = t.dynamic.selectedEntry and not movetocat then
          # Perhaps there is a selected cell but all categories have been
          # collapsed; then move to an unhidden category.
          BrowseData.ScrollSelectedRowOrCellUp( t, "row" );
          if t.dynamic.selectedEntry <> [ 0, 0 ] and
             BrowseData.HeightRow( t, t.dynamic.selectedEntry[1] ) = 0 then
            BrowseData.ScrollSelectedRowOrCellDown( t, "row" );
          fi;
        fi;
        if sel = t.dynamic.selectedEntry then
          # There is no unhidden row, leave the selection mode.
          BrowseData.actions.QuitMode.action( t );
          t.dynamic.changed:= true;
          return;
        fi;
      fi;
    elif t.dynamic.selectedCategory <> [ 0, 0 ] then
      # Move vertically to an unhidden category or row,
      # first up, then down.
      sel:= ShallowCopy( t.dynamic.selectedCategory );
      if BrowseData.HeightCategories( t, sel[1], sel[2] )
         = BrowseData.HeightCategories( t, sel[1], sel[2]-1 )  then
        BrowseData.ScrollSelectedRowOrCellUp( t, "row" );
        if sel = t.dynamic.selectedCategory then
          BrowseData.ScrollSelectedRowOrCellDown( t, "row" );
        fi;
        if sel = t.dynamic.selectedCategory then
          # There is no unhidden row, leave the selection mode.
          BrowseData.actions.QuitMode.action( t );
          t.dynamic.changed:= true;
          return;
        fi;
      fi;
    fi;
end;


#############################################################################
##
#F  BrowseData.ExpandOrCollapseCategories( <t>, <expand>, <positions>, <l> )
#F  BrowseData.actions.ExpandAllCategories.action( <t> )
#F  BrowseData.actions.CollapseAllCategories.action( <t> )
#F  BrowseData.actions.ExpandCurrentCategory.action( <t> )
#F  BrowseData.actions.CollapseCurrentCategory.action( <t> )
##
##  Let <t> be a browse table, <expand> be `true' or `false',
##  <positions> be either the string `"all"' or a list of pairs $[ i, l ]$
##  describing categories in row $i$ at level $l$,
##  and <l> be a positive integer or the string `"all"'.
##
##  `BrowseData.ExpandOrCollapseCategories' expands or collapses categories
##  at the row positions in <t> given by <positions>.
##  If <expand> is `true' then the categories up to level <l> are expanded,
##  i.&nbsp;e., the category rows up to level $<l>+1$ are unhidden;
##  the data rows are expanded if there are only expanded categories above
##  them.
##  If <expand> is `false' then the categories from level <l> on are
##  collapsed; the data rows are collapsed if there is a collapsed category
##  above them.
##
BrowseData.ExpandOrCollapseCategories := function( t, expand, positions, l )
    local cats, i, hide, j, entry, pair, pos, row, expand_i, minlevel, to,
          cat, sel, tl, br, n;

    cats:= t.dynamic.categories;

    if not IsEmpty( cats[1] ) then

      if positions = "all" then
        # Ignore rows before the first category.
        i:= cats[1][1];
        hide:= not expand;
        for j in [ i .. Length( t.dynamic.isCollapsedRow ) ] do
          t.dynamic.isCollapsedRow[j]:= hide;
        od;
        for entry in cats[2] do
          entry.isUnderCollapsedCategory:= entry.level > 1 and hide;
        od;
      else
        for pair in positions do
          i:= pair[1];
          minlevel:= pair[2];
          pos:= PositionSorted( cats[1], i );
          if pos <= Length( cats[1] ) and cats[1][ pos ] = i then
            # There are categories for row `i'.
            while pos <= Length( cats[1] )
                  and cats[2][ pos ].pos = i
                  and cats[2][ pos ].level <= minlevel do
              pos:= pos + 1;
            od;
            pos:= pos - 1;
            if expand then
              # Expand the categories of the levels from the current level on.
              row:= i;
              expand_i:= true;
              minlevel:= cats[2][ pos ].level;
              while pos <= Length( cats[1] ) and
                    ( row = i or cats[2][ pos ].level > minlevel ) do
                if cats[2][ pos ].level <= l + 1 then
                  cats[2][ pos ].isUnderCollapsedCategory:= false;
                fi;
                if cats[2][ pos ].level >= l + 1 then
                  expand_i:= false;
                fi;
                pos:= pos + 1;
                if expand_i then
                  # Unhide the data rows.
                  if pos <= Length( cats[1] ) then
                    to:= cats[1][ pos ] - 1;
                  else
                    to:= Length( t.dynamic.isCollapsedRow );
                  fi;
                  for j in [ row .. to ] do
                    t.dynamic.isCollapsedRow[j]:= false;
                  od;
                fi;
                if pos <= Length( cats[1] ) then
                  row:= cats[1][ pos ];
                fi;
              od;
            else
              # Collapse the categories.
              if pos = Length( cats[1] ) then
                for j in [ i .. Length( t.dynamic.isCollapsedRow ) ] do
                  t.dynamic.isCollapsedRow[j]:= true;
                od;
              else
                for j in [ i .. cats[2][ pos + 1 ].pos - 1 ] do
                  t.dynamic.isCollapsedRow[j]:= true;
                od;
              fi;
              pos:= pos + 1;
              row:= i;
              while pos <= Length( cats[1] ) and cats[2][ pos ].level > l do
                cats[2][ pos ].isUnderCollapsedCategory:= true;
                pos:= pos + 1;
                # Hide the data rows.
                if pos <= Length( cats[1] ) then
                  to:= cats[1][ pos ] - 1;
                else
                  to:= Length( t.dynamic.isCollapsedRow );
                fi;
                for j in [ row .. to ] do
                  t.dynamic.isCollapsedRow[j]:= true;
                od;
                if pos <= Length( cats[1] ) then
                  row:= cats[1][ pos ];
                fi;
              od;
            fi;
          fi;
        od;
      fi;

      if t.dynamic.selectedEntry <> [ 0, 0 ] or
         t.dynamic.selectedCategory <> [ 0, 0 ] then
        BrowseData.MoveSelectionToUnhiddenEntryOrCategory( t, true );
        BrowseData.MoveFocusToSelectedCellOrCategory( t );
      else

        # Nothing is selected.
        i:= t.dynamic.topleft[1];
        if BrowseData.IsHiddenCell( t, i, "vert" ) then
          # A hidden data row is the current topleft entry.
          # Move the topleft entry to the next visible category above it.
          cats:= t.dynamic.categories;
#T leave this to MoveFocus?
          pos:= PositionSorted( cats[1], i );
          if   Length( cats[1] ) < pos or cats[1][ pos ] = i then
            pos:= pos - 1;
          fi;
          while 0 < pos and cats[2][ pos ].isUnderCollapsedCategory do
            pos:= pos - 1;
          od;
          if 0 < pos then
            cat:= cats[2][ pos ];
            t.dynamic.topleft{ [ 1, 3 ] }:= [ cat.pos,
                BrowseData.HeightCategories( t, cat.pos, cat.level - 1 ) + 1 ];
          fi;
        fi;

      fi;

      t.dynamic.changed:= true;
    fi;

    return t.dynamic.changed;
  end;

BrowseData.actions.ExpandAllCategories := rec(
  helplines := [ "expand all categories" ],
  action := function( t )
  BrowseData.ExpandOrCollapseCategories( t, true, "all", "all" );
  end );

BrowseData.actions.CollapseAllCategories := rec(
  helplines := [ "collapse all categories" ],
  action := function( t )
  BrowseData.ExpandOrCollapseCategories( t, false, "all", "all" );
  end );

BrowseData.actions.ExpandCurrentCategory := rec(
  helplines := [ "expand the selected category" ],
  action := function( t )
  if t.dynamic.selectedCategory <> [ 0, 0 ] then
    BrowseData.ExpandOrCollapseCategories( t, true,
        [ t.dynamic.selectedCategory ], t.dynamic.selectedCategory[2] );
    t.dynamic.changed:= true;
  fi;
  return t.dynamic.changed;
  end );

BrowseData.actions.CollapseCurrentCategory := rec(
  helplines := [ "collapse the selected category" ],
  action := function( t )
  local i, cats, pos, cat;

  if t.dynamic.selectedEntry <> [ 0, 0 ] then
    # If an entry is selected then collapse the innermost category above it.
    i:= t.dynamic.selectedEntry[1];
    pos:= PositionSorted( t.dynamic.categories[1], i );
    cats:= t.dynamic.categories[2];
    while pos <= Length( cats ) and cats[ pos ].pos = i do
      pos:= pos + 1;
    od;
    if pos > Length( cats ) then
      pos:= pos - 1;
    fi;
    while pos > 0 and cats[ pos ].pos > i do
      pos:= pos - 1;
    od;
    if pos > 0 then
      BrowseData.ExpandOrCollapseCategories( t, false,
          [ [ cats[ pos ].pos, cats[ pos ].level ] ], cats[ pos ].level );
      t.dynamic.changed:= true;
    fi;
  elif t.dynamic.selectedCategory <> [ 0, 0 ] then
    BrowseData.ExpandOrCollapseCategories( t, false,
        [ t.dynamic.selectedCategory ], t.dynamic.selectedCategory[2] );
    t.dynamic.changed:= true;
  fi;
  return t.dynamic.changed;
  end );


#############################################################################
##
#F  BrowseData.actions.ResetTable.action( <t> )
##
##  Unsort the table, delete all categories, unhide all rows and columns.
##  This means both <E>collapsed</E> and <E>rejected</E> rows and columns;
##  note that collapsed rows make no sense in an uncategorized table,
##  and it may be not possible to map rejected rows to rows in the unsorted
##  table, since a table row can occur under several categories,
##  and some of the instances can be rejected and others are not.
##
##  If a category was selected then switch to a selected entry
##  under this category.
##
BrowseData.actions.ResetTable := rec(
  helplines := [ "unsort the table, remove categories,",
                 "and make hidden rows and columns visible" ],
  action := function( t )
    if   t.dynamic.selectedEntry <> [ 0, 0 ] then
      t.dynamic.selectedEntry:= [ t.dynamic.indexRow[
                                      t.dynamic.selectedEntry[1] ],
                                  t.dynamic.indexCol[
                                      t.dynamic.selectedEntry[2] ] ];
    elif t.dynamic.selectedCategory <> [ 0, 0 ] then
      t.dynamic.selectedEntry:= [ t.dynamic.indexRow[
                                      t.dynamic.selectedCategory[1] ], 2 ];
      t.dynamic.selectedCategory:= [ 0, 0 ];
      t.dynamic.topleft{ [ 1, 2 ] }:= t.dynamic.selectedEntry;
      t.dynamic.topleft[3]:= 1;
      t.dynamic.topleft[4]:= 1;
    fi;
    BrowseData.MoveFocusToSelectedCellOrCategory( t );
    t.dynamic.categories:= [ [], [], [] ];

    t.dynamic.indexRow:= [ 1 .. 2 * t.work.m + 1 ];
    t.dynamic.indexCol:= [ 1 .. 2 * t.work.n + 1 ];

    t.dynamic.isCollapsedRow:= List( t.dynamic.indexRow, x -> false );
    t.dynamic.isCollapsedCol:= List( t.dynamic.indexCol, x -> false );
    t.dynamic.isRejectedRow:= List( t.dynamic.indexRow, x -> false );
    t.dynamic.isRejectedCol:= List( t.dynamic.indexCol, x -> false );

    t.dynamic.changed:= true;

    return t.dynamic.changed;
  end );


#############################################################################
##
#F  BrowseData.FilterTable( <t> )
##
BrowseData.FilterTable := function( t )
    local flag, parameters, str, entry, case, mode, type, rest, negate,
          changed, found, searchdomain, rejected, len, i, j;

    flag:= BrowseData.CurrentMode( t ).flag;
    if   flag in [ "browse", "select_entry" ] then
      parameters:= Concatenation(
                       [ [ "restrict", [ "rows", "columns" ], 1 ] ],
                       t.dynamic.filterParameters );
    else
      parameters:= t.dynamic.filterParameters;
    fi;

    # Get the search pattern.
    str:= BrowseData.GetPatternEditParameters(
              [ NCurses.attrs.BOLD, "enter a search string: " ],
              t.dynamic.searchString,
              parameters,
              t );
    if NCurses.IsStdoutATty() then
      NCurses.curs_set( 0 );
    fi;
    if str = fail or IsEmpty( str ) then
      return;
    fi;

    t.dynamic.searchString:= str;

    # Evaluate the filter parameters:
    # - filter rows or columns?
    # - case sensitive (default) or not?
    # - search for substring, word, prefix, suffix?
    for entry in parameters do
      if entry[1] = "case sensitive" then
        case:= ( entry[2][ entry[3] ] = "yes" );
      elif entry[1] = "mode" then
        mode:= entry[2][ entry[3] ];
      elif entry[1] = "search for" and mode = "substring" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "compare with" and mode = "whole entry" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "restrict" then
        rest:= entry[2][ entry[3] ];
      elif entry[1] = "negate" then
        negate:= ( entry[2][ entry[3] ] = "yes" );
      fi;
    od;

    changed:= false;
    found:= false;
    if   flag in [ "browse", "select_entry" ] then
      # Search in the whole table.
      searchdomain:= "in the main table";
      if rest = "rows" then
        rejected:= ShallowCopy( t.dynamic.isRejectedRow );
        len:= Length( t.dynamic.indexCol ) - 1;
        for i in [ 2, 4 .. Length( rejected ) - 1 ] do
          if not rejected[i] then
            if ForAny( [ 2, 4 .. len ],
                       j -> BrowseData.StringMatch( t, i, j, case, mode, type,
                                                    negate, true ) ) then
              found:= true;
            else
              rejected[i]:= true;
              rejected[ i+1 ]:= true;
              changed:= true;
            fi;
          fi;
        od;
      else
        rejected:= ShallowCopy( t.dynamic.isRejectedCol );
        len:= Length( t.dynamic.indexRow ) - 1;
        for j in [ 2, 4 .. Length( rejected ) - 1 ] do
          if not rejected[j] then
            if ForAny( [ 2, 4 .. len ],
                       i -> BrowseData.StringMatch( t, i, j, case, mode, type,
                                                    negate, true ) ) then
              found:= true;
            else
              rejected[j]:= true;
              rejected[ j+1 ]:= true;
              changed:= true;
            fi;
          fi;
        od;
      fi;
    elif flag in [ "select_row", "select_row_and_entry" ] then
      # Search in the selected row (ignore categories).
      searchdomain:= "in the selected row";
      if t.dynamic.selectedCategory = [ 0, 0 ] then
        rest:= "columns";
        rejected:= ShallowCopy( t.dynamic.isRejectedCol );
        len:= Length( t.dynamic.indexRow ) - 1;
        i:= t.dynamic.selectedEntry[1];
        for j in [ 2, 4 .. Length( rejected ) - 1 ] do
          if not rejected[j] then
            if BrowseData.StringMatch( t, i, j, case, mode, type, negate, true )
            then
              found:= true;
            else
              rejected[j]:= true;
              rejected[ j+1 ]:= true;
              changed:= true;
            fi;
          fi;
        od;
      fi;
    elif flag in [ "select_column", "select_column_and_entry" ] then
      # Search in the selected column (ignore categories).
      searchdomain:= "in the selected column";
      if t.dynamic.selectedCategory = [ 0, 0 ] then
        rest:= "rows";
        rejected:= ShallowCopy( t.dynamic.isRejectedRow );
        len:= Length( t.dynamic.indexCol ) - 1;
        j:= t.dynamic.selectedEntry[2];
        for i in [ 2, 4 .. Length( rejected ) - 1 ] do
          if not rejected[i] then
            if BrowseData.StringMatch( t, i, j, case, mode, type, negate, true )
            then
              found:= true;
            else
              rejected[i]:= true;
              rejected[ i+1 ]:= true;
              changed:= true;
            fi;
          fi;
        od;
      fi;
    else
      return;
    fi;

    if not found then
      # Print a message that the given string was not found.
      BrowseData.AlertWithReplay( t, [ Concatenation( "pattern not found ",
                                           searchdomain, ":" ),
                                       t.dynamic.searchString ],
                                      NCurses.attrs.BOLD );
    elif changed then
      t.dynamic.changed:= true;

      if rest = "rows" then
        t.dynamic.isRejectedRow:= rejected;
        # Restrict the categories according to the new matches.
        BrowseData.RestrictCategories( t );
      else
        t.dynamic.isRejectedCol:= rejected;
      fi;

      # Move the selection to the next unhidden entry or category,
      # and move the window such that the selected cell or category
      # becomes visible.
      BrowseData.MoveSelectionToUnhiddenEntryOrCategory( t, true );
      BrowseData.MoveFocusToSelectedCellOrCategory( t );
    fi;
  end;


#############################################################################
##
#F  BrowseData.ClearFiltering( <t> )
##
BrowseData.ClearFiltering := function( t )
    local cat;

    t.dynamic.isRejectedRow:= List( t.dynamic.indexRow, x -> false );
    t.dynamic.isRejectedCol:= List( t.dynamic.indexCol, x -> false );
    for cat in t.dynamic.categories[2] do
      cat.isRejectedCategory:= false;
    od;
    BrowseData.MoveFocusToSelectedCellOrCategory( t );
    t.dynamic.changed:= true;

    return t.dynamic.changed;
  end;


BrowseData.actions.FilterTable := rec(
  helplines := [ "filter the table" ],
  action := BrowseData.FilterTable );

BrowseData.actions.ClearFiltering := rec(
  helplines := [ "clear the filtering of the table" ],
  action := BrowseData.ClearFiltering );


#############################################################################
##
#F  BrowseData.ShowHelpTable( <t> )
#F  BrowseData.ShowHelpPager( <t> )
#F  BrowseData.actions.ShowHelp.action( <t> )
#F  BrowseData.defaults.work.ShowHelp( <t> )
##
##  <#GAPDoc Label="ShowHelp_man">
##  <ManSection>
##  <Var Name="BrowseData.actions.ShowHelp"/>
##
##  <Description>
##  There are two predefined ways for showing an overview
##  of the admissible inputs and their meaning in the current mode of a
##  browse table.
##  The function <C>BrowseData.ShowHelpTable</C>
##  <Index Key="BrowseData.ShowHelpTable">
##  <C>BrowseData.ShowHelpTable</C></Index>
##  displays this overview in a browse table (using the <C>help</C> mode),
##  and <C>BrowseData.ShowHelpPager</C>
##  <Index Key="BrowseData.ShowHelpPager">
##  <C>BrowseData.ShowHelpPager</C></Index>
##  uses <C>NCurses.Pager</C>.
##  <P/>
##  Technically, the only difference between these two functions is that
##  <C>BrowseData.ShowHelpTable</C> supports the replay feature of
##  <Ref Func="NCurses.BrowseGeneric"/>,
##  whereas <C>BrowseData.ShowHelpPager</C> simply does not call the pager in
##  replay situations.
##  <P/>
##  The action record <C>BrowseData.actions.ShowHelp</C> is associated with
##  the user inputs <B>?</B> or <B>F1</B> in standard
##  <Ref Func="NCurses.BrowseGeneric"/> applications,
##  and it is recommended to do the same in other
##  <Ref Func="NCurses.BrowseGeneric"/> applications.
##  This action calls the function stored in the component
##  <C>work.ShowHelp</C> of the browse table,
##  the default (i.&nbsp;e.,
##  the value of <C>BrowseData.defaults.work.ShowHelp</C>)
##  is <C>BrowseData.ShowHelpTable</C>.
##  <P/>
##  <Example><![CDATA[
##  gap> xpl1.work.ShowHelp:= BrowseData.ShowHelpPager;;
##  gap> BrowseData.SetReplay( "?Q" );
##  gap> Unbind( xpl1.dynamic );
##  gap> NCurses.BrowseGeneric( xpl1 );
##  gap> xpl1.work.ShowHelp:= BrowseData.ShowHelpTable;;
##  gap> BrowseData.SetReplay( "?dQQ" );
##  gap> Unbind( xpl1.dynamic );
##  gap> NCurses.BrowseGeneric( xpl1 );
##  gap> BrowseData.SetReplay( false );
##  gap> Unbind( xpl1.dynamic );
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
BrowseData.ShowHelpPager := function( t )
    local mode, actions, helplines, c, chelplines, pos, mat, i, j;

    mode:= BrowseData.CurrentMode( t );
    actions:= [];
    helplines:= [];
    for c in mode.actions do
      chelplines:= c[2].helplines;
      if c[2].helplines[1] =
           "apply a mode specific ``Click'' function to the selected entry,"
         and IsBound( t.work.Click.( mode.name ) ) then
        chelplines:= t.work.Click.( mode.name ).helplines;
      fi;
      pos:= Position( helplines, chelplines );
      if pos = fail then
        Add( actions, Concatenation( "'", c[3], "'" ) );
        Add( helplines, chelplines );
      else
        Append( actions[ pos ], Concatenation( ", '", c[3], "'" ) );
      fi;
    od;
    mat:= [ Concatenation( "supported key strokes in ", mode.name, " mode:" ),
            "" ];
    for i in [ 1 .. Length( actions ) ] do
      Add( mat, actions[i] );
      for j in helplines[i] do
        Add( mat, Concatenation( "    ", j ) );
      od;
      Add( mat, "" );
    od;
    if BrowseData.IsDoneReplay( t.dynamic.replay ) and
       NCurses.IsStdoutATty() then
      NCurses.Pager( mat );
      NCurses.update_panels();
      NCurses.doupdate();
      NCurses.curs_set( 0 );
    fi;
  end;

BrowseData.ShowHelpTable := function( t )
    local mat, cats, modes, mode, actions, helplines, c, chelplines,
          pos, i, helpt;

    # Compose the help matrix.
    mat:= [];
    cats:= [ [], [], [] ];

    modes:= [ BrowseData.CurrentMode( t ) ];
    mode:= First( t.work.availableModes, x -> x.name = "help" );
    if mode <> fail then
      Add( modes, mode );
    fi;
    for mode in modes do
      Add( cats[1], 2 * Length( mat ) + 2 );
      Add( cats[2], rec( pos:= 2 * Length( mat ) + 2,
                         level:= 1,
                         value:= Concatenation( "supported key strokes in ",
                                     mode.name, " mode:" ),
                         separator:= "-",
                         isUnderCollapsedCategory:= false,
                         isRejectedCategory:= false ) );
      actions:= [];
      helplines:= [];
      for c in mode.actions do
        chelplines:= c[2].helplines;
        if c[2].helplines = [ "apply a mode specific ``Click'' function" ]
           and IsBound( t.work.Click.( mode.name ) ) then
          chelplines:= t.work.Click.( mode.name ).helplines;
        fi;
        pos:= Position( helplines, chelplines );
        if pos = fail then
          Add( actions, [ Concatenation( "'", c[3], "'" ) ] );
          Add( helplines, chelplines );
        else
          Add( actions[ pos ], Concatenation( "'", c[3], "'" ) );
        fi;
      od;
      for i in [ 1 .. Length( actions ) ] do
        Add( mat, [ rec( rows:= actions[i], align:= "tl" ),
                    rec( rows:= helplines[i], align:= "tl" ) ] );
      od;
    od;

    # Show the help in a new window.
    helpt:= rec( work:= rec(
                   main:= mat,
                   sepLabelsRow:= "",
                   sepCol:= [ "| ", " | ", " |" ],
                   sepRow:= "-",
                   SpecialGrid:= BrowseData.SpecialGridLineDraw,
                   align:= "c",
                   availableModes:=
                     Filtered( BrowseData.defaults.work.availableModes,
                               r -> r.name = "help" ),
                 ),
               );
    helpt.dynamic:= rec(
              activeModes:= [ helpt.work.availableModes[1] ],
              categories:= cats,
              replay:= t.dynamic.replay,
              log:= t.dynamic.log,
            );
    if IsBound( t.work.windowParameters ) then
      helpt.work.windowParameters:= t.work.windowParameters;
    fi;
    NCurses.BrowseGeneric( helpt );

    if helpt.dynamic.interrupt then
      BrowseData.actions.QuitTable.action( helpt );
    fi;
    t.dynamic.changed:= true;
  end;

BrowseData.actions.ShowHelp := rec(
  helplines := [ "show a help screen" ],
  action := function( t )
    t.work.ShowHelp( t );
  end );

BrowseData.defaults.work.ShowHelp:= BrowseData.ShowHelpTable;


############################################################################
##
#F  BrowseData.actions.ClickOrToggle.action( <t> )
##
BrowseData.actions.ClickOrToggle := rec(
  helplines := [
    "apply a mode specific ``Click'' function to the selected entry,",
    "or toggle (expand/collapse) the selected category" ],
  action := function( t )
    local cats, i, level, pos, collapsed, mode;

    if   t.dynamic.selectedCategory <> [ 0, 0 ] then
      # Expand or collapse the category.
      cats:= t.dynamic.categories;
      i:= t.dynamic.selectedCategory[1];
      level:= t.dynamic.selectedCategory[2];
      pos:= PositionSorted( cats[1], i );
      if pos <= Length( cats[1] ) and cats[1][ pos ] = i then
        while pos <= Length( cats[1] )
              and cats[2][ pos ].pos = i
              and cats[2][ pos ].level <= level do
          pos:= pos + 1;
        od;
        if pos > Length( cats[1] ) or cats[2][ pos ].pos > i then
          collapsed:= t.dynamic.isCollapsedRow[i];
        else
          collapsed:= cats[2][ pos ].isUnderCollapsedCategory;
        fi;
        BrowseData.ExpandOrCollapseCategories( t, collapsed,
            [ t.dynamic.selectedCategory ], level );
        t.dynamic.changed:= true;
      fi;
    elif t.dynamic.selectedEntry <> [ 0, 0 ] then
      # Apply the `Click' function if available.
      mode:= BrowseData.CurrentMode( t ).name;
      if IsBound( t.work.Click.( mode ) ) then
        t.work.Click.( mode ).action( t );
        t.dynamic.changed:= true;
      fi;
    fi;
    return t.dynamic.changed;
  end );


#############################################################################
##
#F  BrowseData.HeightEntry( <tablecelldata> )
##
BrowseData.HeightEntry := function( tablecelldata )
  if IsRecord( tablecelldata ) then
    return Length( tablecelldata.rows );
  elif NCurses.IsAttributeLine( tablecelldata ) then
    return 1;
  else
    return Length( tablecelldata );
  fi;
end;


#############################################################################
##
#F  BrowseData.WidthEntry( <tablecelldata> )
##
BrowseData.WidthEntry := function( tablecelldata )
  if NCurses.IsAttributeLine( tablecelldata ) then
    return NCurses.WidthAttributeLine( tablecelldata );
  elif IsRecord( tablecelldata ) then
    tablecelldata:= tablecelldata.rows;
  fi;
  if Length( tablecelldata ) = 0 then
    return 0;
  else
    return Maximum( List( tablecelldata, NCurses.WidthAttributeLine ) );
  fi;
end;


#############################################################################
##
#F  BrowseData.FormattedEntry( <t>, <srctable>, <trgtable>, <fun>,
#F      <height>, <width>, <sepsrow>, <sepscol>, <i>, <j> )
##
##  <ManSection>
##  <Func Name="BrowseData.FormattedEntry"
##  Arg="t, srctable, trgtable, fun, height, width, sepsrow, sepscol, i, j"/>
##
##  <Returns>
##  an attribute line or a list of attribute lines.
##  </Returns>
##
##  <Description>
##  This function is used to compute formatted row or column separators,
##  and formatted matrix entries.
##  The arguments are a browse table <A>t</A>,
##  a matrix <A>srctable</A> of table cell data objects
##  (for example <C><A>t</A>.work.main</C>,
##  see <Ref Func="BrowseData.IsBrowseTableCellData"/>),
##  a matrix <A>trgtable</A> from which already stored values are fetched
##  and in which the result values are stored
##  if <C><A>t</A>.work.cacheEntries</C> is <K>true</K>
##  (for example <C><A>t</A>.work.mainFormatted</C>),
##  a function <A>fun</A> for computing unavailable entries of
##  <A>srctable</A> (for example <C><A>t</A>.work.Main</C>),
##  two positive integers <A>height</A> and <A>width</A> defining the height
##  and the width of the return value,
##  two lists <A>sepsrow</A> and <A>sepscol</A> of row and column separators
##  (for example <C><A>t</A>.work.sepRow</C>, <C><A>t</A>.work.sepCol</C>),
##  the row index <A>i</A>, and the column index <A>j</A>.
##  </Description>
##  </ManSection>
##
BrowseData.FormattedEntry := function( t, srctable, trgtable, fun,
                               height, width, sepsrow, sepscol, i, j )
    local k, l, srcentry, entry;

    if IsBound( trgtable[i] ) and IsBound( trgtable[i][j] ) then
      # Just fetch the value.
      return trgtable[i][j];
    fi;

    if i mod 2 = 0 then
      if j mod 2 = 0 then
        # We compute the contents of a data cell.
        k:= i/2;
        l:= j/2;
        if   IsBound( srctable[k] ) and IsBound( srctable[k][l] ) then
          srcentry:= srctable[k][l];
        elif IsFunction( fun ) then
          srcentry:= fun( t, k, l );
        else
          srcentry:= t.work.emptyCell;
        fi;

        # Compute the formatted entry.
        entry:= BrowseData.BlockEntry( srcentry, height, width );
      else
        # We compute a column separator (in a data row).
        entry:= ListWithIdenticalEntries( height,
                    BrowseData.Separator( sepscol, ( j + 1 ) / 2 ) );
      fi;
    else
      # We compute a row separator.
      entry:= NCurses.RepeatedAttributeLine(
          BrowseData.Separator( sepsrow, ( i + 1 ) / 2 ), width );
    fi;

    # Store the entry if caching is switched on for this table.
    if t.work.cacheEntries then
      if not IsBound( trgtable[i] ) then
        trgtable[i]:= [];
      fi;
      trgtable[i][j]:= entry;
    fi;

    return entry;
    end;


#############################################################################
##
#F  BrowseData.PrintCell( <t>, <srctable>, <trgtable>, <fun>,
#F                        <height>, <width>, <sepsrow>, <sepscol>, <i>, <j>,
#F                        <y>, <ymax>, <x>, <fromrow>, <fromcol>, <select> )
##
##  Let <t> be a browse table, <srctable> and <trgtable> be two corresponding
##  matrices in <t> (e.g., `main' and `mainFormatted'),
##  <fun> be the function for computing missing values in <srctable> if such
##  a function exists,
##  <height> and <width> be two *positive* integers denoting the numbers of
##  rows and columns needed for the cell that is printed,
##  <sepsrow> and <sepscol> be the lists of row and column separators for the
##  matrix (e.g., `<t>.work.sepRow' and `<t>.work.sepCol'),
##  <i> and <j> be the row and column indices in the matrix,
##  <y> and <ymax> be the first row on the screen to be used and the last row
##  on the screen,
##  <x> be the first column on the screen to be used,
##  <fromrow> and <fromcol> be the first row and column, respectively, of the
##  cell that shall be printed,
##  and <select> be a Boolean that is `true' if and only if the cell is
##  regarded as selected (using the component `<t>.work.startSelect').
##
BrowseData.PrintCell:= function( t, srctable, trgtable, fun, height, width,
    sepsrow, sepscol, i, j, y, ymax, x, fromrow, fromcol, select )
    local tablecell, row, line;

    tablecell:= BrowseData.FormattedEntry( t, srctable, trgtable, fun,
                    height, width, sepsrow, sepscol, i, j );
    if BrowseData.IsQuietSession( t.dynamic.replay ) then
      return;
    fi;
    if NCurses.IsAttributeLine( tablecell ) then
      tablecell:= [ tablecell ];
    fi;
    for row in tablecell{ [ fromrow .. Length( tablecell ) ] } do
      if select then
        line:= NCurses.ConcatenationAttributeLines(
                   [ t.work.startSelect, row ], true );
      else
        line:= row;
      fi;
      NCurses.PutLine( t.dynamic.window, y-1, x-1, line, fromcol-1 );
      y:= y + 1;
      if ymax < y then
        return;
      fi;
    od;
end;


#############################################################################
##
#F  BrowseData.PrintSubmatrix( <t>, <srctable>, <trgtable>, <fun>,
#F                             <cellheights>, <cellwidths>,
#F                             <sepsrow>, <sepscol>, <indexRow>, <indexCol>,
#F                             <categories>, <showcategories>,
#F                             <topleft>, <ymin>, <ymax>, <xmin>, <xmax>,
#F                             <select>, <tablename>, <ret> )
##
##  Let <t> be a browse table, <srctable> and <trgtable> be two corresponding
##  matrices in <t> (e.g., `main' and `mainFormatted'),
##  <cellheights> and <cellwidths> be two functions that compute the heights
##  and widths of cells in the matrix (e.g., `BrowseData.HeightRow' and
##  `BrowseData.WidthCol'),
##  <sepsrow> and <sepscol> be the lists of row and column separators for the
##  matrix (e.g., `<t>.work.sepRow' and `<t>.work.sepCol'),
##  <indexRow> and <indexCol> be the indirections from the shown rows and
##  columns to those of the matrix,
##  <categories> be the list of category rows for the matrix,
##  <showcategories> be a Boolean that is `true' is and only if the
##  categories shall be shown (i. e., if <srctable> is `<t>.work.labelsRow'),
##  <topleft> be the quadruple describing the topleft cell that is shown,
##  <ymin> and <ymax> be the first and last row of the screen that shall
##  be used,
##  <xmin> and <xmax> be the first and last column of the screen that shall
##  be used,
##  and <select> be a Boolean that is `true' if and only if
##  `<t>.dynamic.selectedEntry' and `<t>.dynamic.selectedCategory' refer to
##  the current matrix.
##
##  <tablename> is one of `"corner"', `"column labels"', `"row labels"',
##  `"main"'.
##
##  <ret> must be a record with the components `catSeparators' (a list of the
##  form `[ <row>, <col>, <len>, <what> ]') and
##  `gridsInfo' (a list of records);
##  the components are filled with information about positions and contents
##  of separator lines (which may be used by `SpecialGrid' functions).
##
BrowseData.PrintSubmatrix:= function( t, srctable, trgtable, fun,
    cellheights, cellwidths, sepsrow, sepscol, indexRow, indexCol,
    categories, showcategories, topleft, ymin, ymax, xmin, xmax, select,
    tablename, ret )
    local i, fromrow, y, x, catpos, colinds, currgridinfo, gridsinfo,
          firstrow, pos, entry, collapsed, cat, level, pos2, count, height,
          j, fromcol, width, sep, jj, rend, val;

    i:= topleft[1];
    fromrow:= topleft[3];
    y:= ymin;
    x:= xmin;
    catpos:= categories[1];
    colinds:= [];
    currgridinfo:= rec( trow:= ymin-1, brow:= ymax-1,
                        lcol:= xmin-1, rcol:= xmax-1,
                        rowinds:= [], colinds:= colinds,
                        tend:= topleft[3] = 1 and
                               ForAll( [ 1 .. topleft[1]-1 ],
                                       i -> cellheights( t, i ) = 0 ),
                        lend:= topleft[4] = 1 and
                               ForAll( [ 1 .. topleft[2]-1 ],
                                       j -> cellwidths( t, j ) = 0 ),
                      );
    gridsinfo:= [ currgridinfo ];
    firstrow:= true;
    while y <= ymax and IsBound( indexRow[i] ) do
      if i mod 2 = 0 then
        # Show the categories info, omitting the first `fromrow - 1' rows.
        pos:= PositionSorted( catpos, i );
        while pos <= Length( catpos ) and catpos[ pos ] = i do
          entry:= categories[2][ pos ];
          if entry.isUnderCollapsedCategory or entry.isRejectedCategory then
            # This category and all of higher level are hidden.
            break;
          fi;

          # Find out whether the category is collapsed or expanded.
          if   pos = Length( categories[1] ) then
            collapsed:= ForAll( [ i .. Length( t.dynamic.indexRow ) ],
                          x -> BrowseData.IsHiddenCell( t, x, "vert" ) );
          elif i < categories[2][ pos + 1 ].pos then
            collapsed:= ForAll( [ i .. categories[2][ pos + 1 ].pos - 1 ],
                            x -> BrowseData.IsHiddenCell( t, x, "vert" ) );
          else
            collapsed:= categories[2][ pos + 1 ].isUnderCollapsedCategory or
                        categories[2][ pos + 1 ].isRejectedCategory;
          fi;

          # Deal with the category row.
          if 1 < fromrow then
            # The beginning of the cell is above the screen.
            fromrow:= fromrow - 1;
          else
            # Print the category row.
            if showcategories then
              # Really print the category row.
              # (This happens for the row labels table.)
              if collapsed then
                cat:= t.work.startCollapsedCategory;
              else
                cat:= t.work.startExpandedCategory;
              fi;
              level:= entry.level;
              while not IsBound( cat[ level ] ) do
                level:= level - 1;
              od;
              cat:= NCurses.ConcatenationAttributeLines(
                        [ RepeatedString( " ", 2 * ( entry.level - level ) ),
                          cat[ level ], entry.value ], true );
              # Compute the counter if applicable.
              if entry.level in t.dynamic.categories[3] then
                pos2:= pos + 1;
                while pos2 <= Length( catpos ) do
                  if categories[2][ pos2 ].level <= entry.level then
                    break;
                  fi;
                  pos2:= pos2 + 1;
                od;
                if pos2 <= Length( catpos ) then
                  pos2:= categories[2][ pos2 ].pos - 2;
                else
                  pos2:= Length( t.dynamic.indexRow ) - 1;
                fi;
                count:= Number( [ i, i+2 .. pos2 ],
                                x -> not t.dynamic.isRejectedRow[ x ] );
                Add( cat, Concatenation( "  (", String( count ), ")" ) );
              fi;
              if t.work.IsSelectedCategory( t, i, entry.level ) then
                cat:= NCurses.ConcatenationAttributeLines(
                          [ t.work.startSelect, cat ], true );
              fi;
              NCurses.PutLine( t.dynamic.window, y-1, xmin - 1, cat );
            fi;
            # The categories are needed for the grid information
            # for the main table not the row labels table.
            if IsEmpty( currgridinfo.rowinds ) and
               IsEmpty( currgridinfo.colinds ) then
              # The current grid is empty, simply reinitialize it.
              currgridinfo.trow:= y;
              currgridinfo.rowinds:= [ y ];
              currgridinfo.tend:= true;
            else
              # Close the current grid piece, and initialize a new one.
              if   y-2 < currgridinfo.trow then
                # Reinitialize the current grid.
                currgridinfo.trow:= y;
                currgridinfo.rowinds:= [ y ];
                currgridinfo.colinds:= colinds;
                currgridinfo.tend:= true;
              elif y - 2 = currgridinfo.trow then
                # (The leading row separator of the table is nonempty.)
#T translate partial grid into empty line or HLINE or just avoid this at all?
                currgridinfo.trow:= y;
                currgridinfo.rowinds:= [ y ];
                currgridinfo.colinds:= colinds;
                currgridinfo.tend:= true;
              else
                currgridinfo.brow:= y - 2;
                currgridinfo.bend:= true;
                currgridinfo:= rec( trow:= y, brow:= ymax-1,
                                    lcol:= xmin-1, rcol:= xmax-1,
                                    rowinds:= [ y ], colinds:= colinds,
                                    tend:= true,
                                    lend:= currgridinfo.lend );
                Add( gridsinfo, currgridinfo );
              fi;
            fi;
            # Increase the counter (also if the cat. row is not printed).
            y:= y + 1;
          fi;

          # Deal with the separator line below the category row.
          if not collapsed and
             0 < NCurses.WidthAttributeLine( entry.separator ) then
            if 1 < fromrow then
              # The beginning of the cell is above the screen.
              fromrow:= fromrow - 1;
            else
              # Print the category separator.
              if showcategories then
                # Really print the category separator.
                # (This happens for the row labels table.)
                NCurses.PutLine( t.dynamic.window, y-1, xmin - 1,
                            NCurses.RepeatedAttributeLine( entry.separator,
                            xmax - xmin + 1 ) );
              elif y <= ymax then
                # The separators shall be handled together with the grid
                # information for the main table not the row labels.
                Add( ret.catSeparators,
                     [ y-1, xmin-1, xmax-xmin+1, entry.separator ] );
                AddSet( currgridinfo.rowinds, y-1 );
#T needed only if the sep. is in top pos.?
              fi;
              # Increase the counter (also if the cat. row is not printed).
              y:= y + 1;
            fi;
          fi;

          pos:= pos + 1;
        od;
      fi;

      # Show the data rows.
      height:= cellheights( t, i );
      if 0 < height then
        # If we are on a separator row then extend the grid info.
        if IsOddInt( i ) then
          # Find a non-blank entry in the separator.
          sep:= BrowseData.Separator( sepsrow, ( i + 1 ) / 2 );
          if ForAny( sep, x -> x <> ' ' ) then
            Add( currgridinfo.rowinds, y-1 );
          fi;
        fi;

        j:= topleft[2];
        fromcol:= topleft[4];
        x:= xmin;
        while x <= xmax and IsBound( indexCol[j] ) do
          width:= cellwidths( t, j );
          if 0 < width then
            # Print the cell.
            BrowseData.PrintCell( t, srctable, trgtable, fun, height, width,
                         sepsrow, sepscol, indexRow[i], indexCol[j],
                         y, ymax, x, fromrow, fromcol,
                         select and t.work.IsSelectedCell( t, i, j ) );

            # If we are on a separator cell then extend the grid info.
            if firstrow and IsOddInt( j ) then
              # Find the positions of non-blank entries in the separator.
              sep:= BrowseData.Separator( sepscol, ( j + 1 ) / 2 );
              for jj in [ 1 .. Length( sep ) ] do
                if sep[jj] <> ' ' then
                  Add( colinds, x + jj - 2 );
                fi;
              od;
            fi;

            x:= x + width - fromcol + 1;
          fi;
          j:= j + 1;
          fromcol:= 1;
        od;
        firstrow:= false;
        y:= y + height - fromrow + 1;
      fi;
      i:= i + 1;
      fromrow:= 1;
    od;

    # Return the position of the next free column in the next free line.
    if ymax < y then
      y:= ymax + 1;
    fi;
    if xmax < x then
      x:= xmax + 1;
    fi;

    # Update the grid information.
    # In particular, compute whether the grids shall be closed on the right,
    # and whether the last grid shall be closed at the bottom.
    if tablename in [ "corner", "row labels" ] then
      rend:= true;
    else
      # For column labels or main table, we have to compute rend.
      rend:= not IsList( BrowseData.BottomOrRight( t, "horz" ) );
    fi;
    if ( IsEmpty( currgridinfo.rowinds ) and IsEmpty( currgridinfo.colinds ) )
       or ( currgridinfo.brow < currgridinfo.trow ) then
      Unbind( gridsinfo[ Length( gridsinfo ) ] );
    else
      currgridinfo.brow:= y - 2;
    fi;
    if not IsEmpty( gridsinfo ) then
      for entry in gridsinfo do
        entry.rcol:= x - 2;
        entry.rend:= rend;
      od;
      if tablename in [ "corner", "column labels" ] then
        # We are showing corner or column labels table.
        gridsinfo[ Length( gridsinfo ) ].bend:= true;
      else
        val:= gridsinfo[ Length( gridsinfo ) ].rowinds;
        if IsEmpty( val ) then
          gridsinfo[ Length( gridsinfo ) ].bend:= false;
        elif val[ Length( val ) ] < ymax - 1 then
          # The last shown row separator is not in the last line: close.
          gridsinfo[ Length( gridsinfo ) ].bend:= true;
        else
          # For the last row of the screen in row labels and main table,
          # we really have to compute bend:
          # The grid is open at the bottom if the last row on the screen
          # shows the first row of an odd cell.
          val:= BrowseData.BottomOrRight( t, "vert" );
          if not ( IsList( val ) and IsOddInt( val[1] ) and val[2] = 1 ) then
            gridsinfo[ Length( gridsinfo ) ].bend:= true;
          else
            # Check whether the next visible object below
            # is a data cell or a category row.
            val:= First( [ val[1] + 1 .. Length( t.dynamic.indexRow ) ],
                         x -> BrowseData.LengthCell( t, x, "vert" ) <> 0 );
            gridsinfo[ Length( gridsinfo ) ].bend:=
                val = fail or val in t.dynamic.categories[1];
          fi;
        fi;
      fi;
      Append( ret.gridsInfo, gridsinfo );
    fi;

    return [ y, x ];
end;


#############################################################################
##
#F  BrowseData.defaults.work.CategoryValues( <t>, <i>, <col> )
##
##  <ManSection>
##  <Func Name="BrowseData.defaults.work.CategoryValues" Arg="t, i, col"/>
##
##  <Returns>
##  a list of category rows.
##  </Returns>
##
##  <Description>
##  Let <A>t</A> be a browse table,
##  <A>i</A> be a positive even integer denoting the position of a data row,
##  and <A>col</A> be an even column position.
##  <P/>
##  The <C>CategoryValues</C> function in the <C>work</C> component of
##  <A>t</A> has to return a list of category rows for the table entry in row
##  <A>i</A> and column <A>col</A>.
##  <P/>
##  The values in <C><A>t</A>.work.main</C> are preferred to form
##  the category rows; where they are not available, the return values of the
##  function <C><A>t</A>.work.Main</C> or the values in
##  <C><A>t</A>.work.mainFormatted</C> (which may contain additional line
##  breaks) are used.
##  <P/>
##  Depending on the sort parameter <C>"split rows on categorizing"</C>,
##  the default function <C>BrowseData.defaults.work.CategoryValues</C>
##  returns either the list of the given rows or the concatenation of these
##  rows.
##  </Description>
##  </ManSection>
##
BrowseData.CategoryValuesFromEntry := function( t, value, col )
    local sortparas, para, split;

    if   NCurses.IsAttributeLine( value ) then
      value:= [ NCurses.SimpleString( value ) ];
    elif IsList( value ) then
      value:= List( value, NCurses.SimpleString );
    else
      value:= List( value.rows, NCurses.SimpleString );
    fi;

    if 1 < Length( value ) then
      # Get the sort parameters.
      if   IsBound( t.dynamic.sortParametersForColumns ) and
           IsBound( t.dynamic.sortParametersForColumns[ col ] ) then
        sortparas:= t.dynamic.sortParametersForColumns[ col ];
      elif IsBound( t.dynamic.sortParametersForColumnsDefault ) then
        sortparas:= t.dynamic.sortParametersForColumnsDefault;
      else
        sortparas:=
          BrowseData.defaults.dynamic.sortParametersForColumnsDefault;
      fi;

      # Evaluate the interesting sort parameter.
      para:= First( sortparas, x -> x[1] = "split rows on categorizing" );
      split:= IsList( para ) and para[3] = Position( para[2], "yes" );
      if not split then
        # Concatenate the lines *without* whitespace,
        # since they might be the result of splitting an entry in a
        # fixed width column.
      # value:= List( value, x -> Concatenation( [ x, " " ] ) );
        value:= [ Concatenation( value ) ];
      fi;
    fi;

    # Remove whitespace.
    value:= Filtered( List( value, NormalizedWhitespace ),
                      x -> not IsEmpty( x ) );
    if not IsEmpty( value ) then
      return value;
    fi;
    return [ "(empty category)" ];
end;

BrowseData.defaults.work.CategoryValues := function( t, i, col )
    local value, sortparas, para, split;

    if   IsBound( t.work.main[ i/2 ] ) and
         IsBound( t.work.main[ i/2 ][ col/2 ] ) then
      value:= t.work.main[ i/2 ][ col/2 ];
    elif IsFunction( t.work.Main ) then
      value:= t.work.Main( t, i/2, col/2 );
    elif IsBound( t.work.mainFormatted[i] ) and
         IsBound( t.work.mainFormatted[i][ col ] ) then
      value:= t.work.mainFormatted[i][ col ];
    else
      value:= t.work.emptyCell;
    fi;

    return BrowseData.CategoryValuesFromEntry( t, value, col/2 );
end;


#############################################################################
##
#F  BrowseData.defaults.work.IsSelectedCategory( <t>, <i>, <j> )
##
##  returns `true' if the category for row <i> at level <j> of the
##  browse table <t> shall be shown as selected, and `false' otherwise.
##
BrowseData.defaults.work.IsSelectedCategory := function( t, i, j )
    return (     BrowseData.CurrentMode( t ).flag
                     in [ "select_entry", "select_row" ]
             and t.dynamic.selectedCategory[1] = i
             and t.dynamic.selectedCategory[2] = j );
end;


#############################################################################
##
#F  BrowseData.defaults.work.IsSelectedCell( <t>, <i>, <j> )
##
##  returns `true' if the cell in row <i> and column <j> of the browse table
##  <t> shall be shown as selected, and `false' otherwise.
##
BrowseData.defaults.work.IsSelectedCell := function( t, i, j )
    local flag;

    flag:= BrowseData.CurrentMode( t ).flag;

    return ( flag = "select_entry" and
             t.dynamic.selectedEntry[1] = i and
             t.dynamic.selectedEntry[2] = j )
        or ( flag = "select_row" and
             t.dynamic.selectedEntry[1] = i )
        or ( flag = "select_column" and
             t.dynamic.selectedEntry[2] = j )
        or ( flag = "select_row_and_entry" and
             t.dynamic.selectedEntry[1] = i and
             t.dynamic.selectedEntry[2] <> j )
        or ( flag = "select_column_and_entry" and
             t.dynamic.selectedEntry[1] <> i and
             t.dynamic.selectedEntry[2] = j );
end;


#############################################################################
##
#F  BrowseData.CreateMode( <name>, <flag>[, <show>][, <actions>] )
##
BrowseData.CreateMode:= function( arg )
    local result;

    if 2 <= Length( arg ) and IsString( arg[1] ) and IsString( arg[2] ) then
      result:= rec( name:= arg[1],
                    flag:= arg[2],
                    ShowTables:= BrowseData.ShowTables,
                    actions:= [] );
    else
      Error( "usage: BrowseData.CreateMode( <name>, <flag>[, <show>]",
             "[, <actions>] )" );
    fi;
    if 3 <= Length( arg ) then
      if IsFunction( arg[3] ) then
        result.ShowTables:= arg[3];
      fi;
      if IsList( arg[ Length( arg ) ] ) then
        BrowseData.SetActions( result, arg[ Length( arg ) ] );
      fi;
    fi;

    return result;
end;


#############################################################################
##
#F  BrowseData.AddMode( <name>, <flag>[, <show>][, <actions>] )
##
BrowseData.AddMode:= function( arg )
    if ForAny( BrowseData.defaults.work.availableModes,
               x -> x.name = arg[1] ) then
      Error( "there is already a mode with name `", arg[1], "'" );
    fi;
    Add( BrowseData.defaults.work.availableModes,
         CallFuncList( BrowseData.CreateMode, arg ) );
end;


#############################################################################
##
#F  BrowseData.ShallowCopyMode( <mode> )
##
BrowseData.ShallowCopyMode:= function( mode )
    mode:= ShallowCopy( mode );
    mode.actions:= ShallowCopy( mode.actions );
    return mode;
end;


#############################################################################
##
#F  BrowseData.WindowStructure( <t>[, <header>, <footer>] )
##
BrowseData.WindowStructure:= function( arg )
    local t, header, footer, mode, headerlength, headerwidth, line, len,
          footerlength, footerwidth, scr,
          topmargin, bottommargin, labelsheight, need, i, labelswidth,
          leftmargin, rightmargin;

    t:= arg[1];
    if Length( arg ) = 3 then
      header:= arg[2];
      footer:= arg[3];
    else
      # Compute header data.
      mode:= BrowseData.CurrentMode( t ).name;
      if IsList( t.work.header ) then
        header:= t.work.header;
      elif IsFunction( t.work.header ) then
        header:= t.work.header( t );
      elif IsRecord( t.work.header ) and IsBound( t.work.header.( mode ) )
           then
        header:= t.work.header.( mode )( t );
      else
        header:= [];
      fi;

      # Compute footer data.
      if IsList( t.work.footer ) then
        footer:= t.work.footer;
      elif IsFunction( t.work.footer ) then
        footer:= t.work.footer( t );
      elif IsRecord( t.work.footer ) and IsBound( t.work.footer.( mode ) )
           then
        footer:= t.work.footer.( mode )( t );
      else
        footer:= [];
      fi;
    fi;

    headerlength:= Length( header );
    headerwidth:= 0;
    for line in header do
      len:= NCurses.WidthAttributeLine( line );
      if headerwidth < len then
        headerwidth:= len;
      fi;
    od;

    footerlength:= Length( footer );
    footerwidth:= 0;
    for line in footer do
      len:= NCurses.WidthAttributeLine( line );
      if footerwidth < len then
        footerwidth:= len;
      fi;
    od;

    # Perhaps the screen size was changed.
    scr:= BrowseData.HeightWidthWindow( t );

    # Compute margins, depending on alignment.
    topmargin:= 0;
    bottommargin:= 0;
    labelsheight:= BrowseData.HeightLabelsColTable( t );
    need:= headerlength + labelsheight + footerlength;
    for i in t.dynamic.indexRow do
      if scr[1] <= need then
        break;
      fi;
      need:= need + BrowseData.LengthCell( t, i, "vert" );
    od;
    if need < scr[1] then
      if   'b' in t.work.align then
        # bottom alignment
        topmargin:= scr[1] - need;
      elif not 't' in t.work.align then
        # vertically centered alignment
        topmargin:= QuoInt( scr[1] - need, 2 );
        bottommargin:= scr[1] - need - topmargin;
      else
        # top alignment
        bottommargin:= scr[1] - need;
      fi;
    fi;
    labelswidth:= BrowseData.WidthLabelsRowTable( t );
    need:= labelswidth;
    for i in t.dynamic.indexCol do
      if need >= scr[2] then
        break;
      fi;
      need:= need + BrowseData.WidthCol( t, i );
    od;
    leftmargin:= 0;
    rightmargin:= 0;
    if need < scr[2] then
      if   'c' in t.work.align then
        # horizontally centered alignment
        leftmargin:= QuoInt( scr[2] - need, 2 );
        rightmargin:= scr[2] - need - leftmargin;
      elif not 'l' in t.work.align then
        # right alignment
        leftmargin:= scr[2] - need;
      else
        # left alignment
        rightmargin:= scr[2] - need;
      fi;
    fi;

    return rec( heightWidthWindow:= scr,
                topmargin:= topmargin,
                bottommargin:= bottommargin,
                leftmargin:= leftmargin,
                rightmargin:= rightmargin,
                headerLength:= headerlength,
                headerWidth:= headerwidth,
                footerLength:= footerlength,
                footerWidth:= footerwidth,
                labelsheight:= labelsheight,
                labelswidth:= labelswidth,
              );
    end;


#############################################################################
##
#F  BrowseData.PositionInBrowseTable( <t>, <data> )
##
##  <A>data</A> must be a record with the components <C>win</C>,
##  <C>event</C>, <C>y</C>, <C>x</C>,
##  like the second entry of the list returned by
##  <C>BrowseData.GetCharacter</C>.
##
##  The return value is a list of length one or two or three.
##  The entry ar position one is one of the strings
##  <C>"above"</C>, <C>"below"</C>, <C>"left"</C>, <C>"right"</C>,
##  <C>"header"</C>, <C>"footer"</C>,
##  <C>"corner"</C>, <C>"column labels"</C>, <C>"row labels"</C>, or
##  <C>"main"</C>.
##
##  In the last four cases, there is a second entry, a list of four integers
##  denoting the row and column number of the cell and the line and column
##  in this cell where the event occurred,
##  in the same format as in <A>t</A><C>.dynamic.topleft</C>.
##
##  In the case of "header" and "footer", the second entry is a list of
##  length two, denoting the vertical and horizontal position in the header
##  or footer, respectively.
##
##  If the event occurred in a category row then there is a third entry
##  denoting the level of this category row.
##
BrowseData.CalcCellPos:= function( t, n, cell, from, lenfun, pos, result )
    local len;

    n:= n + from - 1;
    while 0 < n do
      len:= lenfun( t, cell );
      if n <= len then
        break;
      fi;
      n:= n - len;
      cell:= cell + 1;
    od;
    result[2][ pos ]:= cell;
    result[2][ pos + 2 ]:= n;
end;

BrowseData.PositionInBrowseTable:= function( t, data )
    local wins, win, ws, scr, y, x, result, i;

    # Check whether the window of the browse table is the top one.
#T Is it currently possible to arrive here if not?
    wins:= data.win;
    win:= t.dynamic.window;
    if data.win <> t.dynamic.window then
      return fail;
    fi;

    # Find the position w.r.t. the table.
    ws:= BrowseData.WindowStructure( t );
    scr:= ws.heightWidthWindow;
    y:= data.y + 1;
    x:= data.x + 1;

    # Check whether the position is outside the table.
    if   y <= ws.topmargin then
      return [ "above" ];
    elif scr[1] - ws.bottommargin < y then
      return [ "below" ];
    fi;
    if   x <= ws.leftmargin then
      return [ "left" ];
    elif scr[2] - ws.rightmargin < x then
      if   y <= ws.topmargin + ws.headerLength
           and x <= ws.leftmargin + ws.headerWidth then
        return [ "header", [ y - ws.topmargin, x - ws.leftmargin ] ];
      elif scr[1] - ws.bottommargin - ws.footerLength < y
           and x <= ws.leftmargin + ws.footerWidth then
        return [ "footer", [ y - scr[1] + ws.bottommargin + ws.footerLength,
                             x - ws.leftmargin ] ];
      else
        return [ "right" ];
      fi;
    fi;

    # Now we know that the position is inside the table.
    if   y <= ws.topmargin + ws.headerLength then
      return [ "header", [ y - ws.topmargin, x - ws.leftmargin ] ];
    elif scr[1] - ws.bottommargin - ws.footerLength < y then
      return [ "footer", [ y - scr[1] + ws.bottommargin + ws.footerLength,
                           x - ws.leftmargin ] ];
    fi;

    # Now we know that the position is in one of the four structured tables.
    y:= y - ws.topmargin - ws.headerLength;
    x:= x - ws.leftmargin;
    if y <= ws.labelsheight then
      if x <= ws.labelswidth then
        # corner
        result:= [ "corner", [] ];
        BrowseData.CalcCellPos( t, y,
            1, 1,
            BrowseData.HeightLabelsCol, 1, result );
        BrowseData.CalcCellPos( t, x,
            1, 1,
            BrowseData.WidthLabelsRow, 2, result );
      else
        # column labels table
        x:= x - ws.labelswidth;
        result:= [ "column labels", [] ];
        BrowseData.CalcCellPos( t, y,
            1, 1,
            BrowseData.HeightLabelsCol, 1, result );
        BrowseData.CalcCellPos( t, x,
            t.dynamic.topleft[2], t.dynamic.topleft[4],
            BrowseData.WidthCol, 2, result );
      fi;
    else
      if x <= ws.labelswidth then
        # row labels table
        y:= y - ws.labelsheight;
        result:= [ "row labels", [] ];
        BrowseData.CalcCellPos( t, y,
            t.dynamic.topleft[1], t.dynamic.topleft[3],
            BrowseData.HeightRowWithCategories, 1, result );
        BrowseData.CalcCellPos( t, x,
            1, 1,
            BrowseData.WidthLabelsRow, 2, result );
      else
        # main table
        x:= x - ws.labelswidth;
        y:= y - ws.labelsheight;
        result:= [ "main", [] ];
        BrowseData.CalcCellPos( t, y,
            t.dynamic.topleft[1], t.dynamic.topleft[3],
            BrowseData.HeightRowWithCategories, 1, result );
        BrowseData.CalcCellPos( t, x,
            t.dynamic.topleft[2], t.dynamic.topleft[4],
            BrowseData.WidthCol, 2, result );
      fi;
      if result[2][3] <= BrowseData.HeightCategories( t, result[2][1] ) then
        i:= 1;
        while BrowseData.HeightCategories( t, result[2][1], i )
                < result[2][3] do
          i:= i + 1;
        od;
        result[3]:= i;
      fi;
    fi;

    return result;
end;


############################################################################
##
#F  BrowseData.actions.ToggleMouseEvents.action( <t> )
##
BrowseData.actions.ToggleMouseEvents := rec(
  helplines := [ "toggle enabling/disabling mouse events" ],
  action := function( t )
    local data;

    data:= NCurses.UseMouse( true );
    if data.old = true or data.new = false then
      data:= NCurses.UseMouse( false );
      BrowseData.AlertWithReplay( t, [ "mouse events disabled" ],
                                  NCurses.attrs.BOLD );
    else
      BrowseData.AlertWithReplay( t, [ "mouse events enabled" ],
                                  NCurses.attrs.BOLD );
    fi;
    t.dynamic.changed:= true;

    return t.dynamic.changed;
  end );


############################################################################
##
#F  BrowseData.DealWithMouseClick( <t>, <data>, <always> )
#F  BrowseData.actions.DealWithSingleMouseClick.action( <t>, <data> )
#F  BrowseData.actions.DealWithDoubleMouseClick.action( <t>, <data> )
##
##  <A>data</A> must be a record with the components <C>win</C>,
##  <C>event</C>, <C>y</C>, <C>x</C>,
##
##  The following behaviour is implemented.
##  - on single or double mouse click in the column labels table:
##    If nothing is selected then select the clicked table column
##    (clicks on separator columns are ignored).
##    If a cell or row or column is selected then move the selection
##    to the clicked column.
##  - on single or double mouse click in the row labels table
##    (but not on category rows):
##    If nothing is selected then select the clicked table row
##    (clicks on separator rows are ignored).
##    If a cell or row or column is selected then move the selection
##    to the clicked row.
##  - on single mouse click in the main table or on a category row:
##    If nothing is selected then select the clicked table cell or category
##    row (clicks on separator cells are ignored).
##    If the selected cell is single-clicked then call the ``Click'' action
##    for this cell if available.
##    If another data cell or category row than the single-clicked one
##    is selected then move the selection to the single-clicked cell or
##    category row.
##  - on double mouse click in the main table or on a category row:
##    Do the same as for single-click, but call the ``Click'' action if
##    available.
##
BrowseData.DealWithMouseClick := function( t, data, always )
    local pos;

    pos:= BrowseData.PositionInBrowseTable( t, data );
    if   pos[1] = "column labels" and IsEvenInt( pos[2][2] ) then
      if   t.dynamic.selectedEntry <> [ 0, 0 ] then
        # A cell or row or column is already selected.
        # Move the selection to this column.
        t.dynamic.selectedEntry[2]:= pos[2][2];
        t.dynamic.changed:= true;
      elif t.dynamic.selectedCategory = [ 0, 0 ] then
        # Nothing is selected yet.
        if ForAny( t.work.availableModes, x -> x.name = "select_column" ) and
           BrowseData.PushMode( t, "select_column" ) then
          # Select the column (the row position must be even).
          t.dynamic.selectedEntry:= [ t.dynamic.topleft[1]
              + ( t.dynamic.topleft[1] mod 2 ), pos[2][2] ];
          t.dynamic.changed:= true;
        fi;
      fi;
      return t.dynamic.changed;
    elif pos[1] = "row labels" and IsEvenInt( pos[2][1] )
                               and Length( pos ) = 2 then
      if   t.dynamic.selectedEntry <> [ 0, 0 ] then
        # A cell or row or column is already selected.
        # Move the selection to this row.
        t.dynamic.selectedEntry[1]:= pos[2][1];
        t.dynamic.changed:= true;
      elif t.dynamic.selectedCategory = [ 0, 0 ] then
        # Nothing is selected yet.
        if ForAny( t.work.availableModes, x -> x.name = "select_row" ) and
           BrowseData.PushMode( t, "select_row" ) then
          # Select the row (the column position must be even).
          t.dynamic.selectedEntry:= [ pos[2][1],
              t.dynamic.topleft[2] + ( t.dynamic.topleft[2] mod 2 ) ];
          t.dynamic.changed:= true;
        fi;
      fi;
      return t.dynamic.changed;
    elif pos[1] in [ "main", "row labels" ] then
      if   t.dynamic.selectedEntry <> [ 0, 0 ] then
        # A cell is already selected.
        if Length( pos ) = 3 then
          # Move the selection to a category row.
          t.dynamic.selectedEntry:= [ 0, 0 ];
          t.dynamic.selectedCategory:= [ pos[2][1], pos[3] ];
          t.dynamic.changed:= true;
        elif pos[1] = "main" then
          if pos[2]{ [ 1, 2 ] } = t.dynamic.selectedEntry then
            # Apply the ``Click'' action.
            t.dynamic.changed:= BrowseData.actions.ClickOrToggle.action( t );
            return t.dynamic.changed;
          elif ForAll( pos[2]{ [ 1, 2 ] }, IsEvenInt ) then
            # Move the selection to another data cell.
            t.dynamic.selectedEntry:= pos[2]{ [ 1, 2 ] };
            t.dynamic.changed:= true;
          fi;
        else
          return t.dynamic.changed;
        fi;
      elif t.dynamic.selectedCategory <> [ 0, 0 ] then
        # A category row is already selected.
        if Length( pos ) = 3 then
          # The click happened on a category row.
          if pos[2][1] = t.dynamic.selectedCategory[1] and
             pos[3] = t.dynamic.selectedCategory[2] then
            # Apply the ``Click'' action.
            t.dynamic.changed:= BrowseData.actions.ClickOrToggle.action( t );
            return t.dynamic.changed;
          else
            # Move the selection to another category row.
            t.dynamic.selectedCategory:= [ pos[2][1], pos[3] ];
            t.dynamic.changed:= true;
          fi;
        elif pos[1] = "main" and ForAll( pos[2]{ [ 1, 2 ] }, IsEvenInt ) then
          # Move the selection to a data cell.
          t.dynamic.selectedEntry:= pos[2]{ [ 1, 2 ] };
          t.dynamic.selectedCategory:= [ 0, 0 ];
          t.dynamic.changed:= true;
        else
          return t.dynamic.changed;
        fi;
      elif pos[1] = "main" then
        # Nothing is selected yet.
        if ForAny( t.work.availableModes, x -> x.name = "select_entry" ) then
          if Length( pos ) = 3 then
            # Select the category row.
            if BrowseData.PushMode( t, "select_entry" ) then
              t.dynamic.selectedCategory:= [ pos[2][1], pos[3] ];
              t.dynamic.changed:= true;
            else
              return t.dynamic.changed;
            fi;
          elif ForAll( pos[2]{ [ 1, 2 ] }, IsEvenInt ) then
            # Select the cell.
            if BrowseData.PushMode( t, "select_entry" ) then
              t.dynamic.selectedEntry:= pos[2]{ [ 1, 2 ] };
              t.dynamic.changed:= true;
            else
              return t.dynamic.changed;
            fi;
          fi;
        else
          return t.dynamic.changed;
        fi;
      else
        return t.dynamic.changed;
      fi;

      if always then
        BrowseData.actions.ClickOrToggle.action( t );
      fi;
    fi;

    return t.dynamic.changed;
  end;

BrowseData.actions.DealWithSingleMouseClick := rec(
  helplines := [
    "select the current category row or the current cell in the main table,",
    "or select the column of the current column label",
    "or the row of the current row label;",
    "if the current cell in the main table was already selected",
    "then ``click'' on this cell;",
    "if the current category row was already selected",
    "then collapse/expand this category row" ],
  action := function( t, data )
    return BrowseData.DealWithMouseClick( t, data, false );
  end );

BrowseData.actions.DealWithDoubleMouseClick := rec(
  helplines := [
    "select the current cell in the main table and ``click'' it,",
    "or select the current category row and expand/collapse it,",
    "or select the column of the current column label",
    "or the row of the current row label;" ],
  action := function( t, data )
    return BrowseData.DealWithMouseClick( t, data, true );
  end );


#############################################################################
##
#F  BrowseData.ShowTables( <t> )
##
BrowseData.ShowTables := function( t )
    local mode, scr, header, footer, ws, rng, brc;

    mode:= BrowseData.CurrentMode( t ).name;

    # Compute the header.
    if IsList( t.work.header ) then
      header:= t.work.header;
    elif IsFunction( t.work.header ) then
      header:= t.work.header( t );
    elif IsRecord( t.work.header ) and IsBound( t.work.header.( mode ) ) then
      header:= t.work.header.( mode )( t );
    else
      header:= [];
    fi;
    t.work.headerLength.( mode ):= Length( header );

    # Compute the footer.
    if IsList( t.work.footer ) then
      footer:= t.work.footer;
    elif IsFunction( t.work.footer ) then
      footer:= t.work.footer( t );
    elif IsRecord( t.work.footer ) and IsBound( t.work.footer.( mode ) ) then
      footer:= t.work.footer.( mode )( t );
    else
      footer:= [];
    fi;
    t.work.footerLength.( mode ):= Length( footer );

    # Compute margins, depending on alignment.
    ws:= BrowseData.WindowStructure( t, header, footer );
    scr:= ws.heightWidthWindow;

    # Compute the range of free row positions between header and footer.
    rng:= [ Length( header ) + ws.topmargin + 1, scr[1] - Length( footer ) ];

    if not BrowseData.IsQuietSession( t.dynamic.replay ) then
      # Clear the screen.
      NCurses.werase( t.dynamic.window );
      # Enter the header.
      NCurses.PutLine( t.dynamic.window, ws.topmargin, ws.leftmargin, header );
    fi;

    ws.catSeparators:= [];
    ws.gridsInfo:= [];

    # Add the corner.
    brc:= BrowseData.PrintSubmatrix( t, t.work.corner,
              t.work.cornerFormatted, false,
              BrowseData.HeightLabelsCol, BrowseData.WidthLabelsRow,
              t.work.sepLabelsCol, t.work.sepLabelsRow,
              [ 1 .. 2 * t.work.m0 + 1 ],
              [ 1 .. 2 * t.work.n0 + 1 ],
              [ [], [], [] ], false,
              [ 1, 1, 1, 1 ],
              rng[1],
              rng[2], ws.leftmargin+1, scr[2],
              false,
              "corner",
              ws );

    # Add the current column labels.
    if brc[2] <= scr[2] then
      BrowseData.PrintSubmatrix( t, t.work.labelsCol,
          t.work.labelsColFormatted, false,
          BrowseData.HeightLabelsCol, BrowseData.WidthCol,
          t.work.sepLabelsCol, t.work.sepCol,
          [ 1 .. 2 * t.work.m0 + 1 ],
          t.dynamic.indexCol,
          [ [], [], [] ], false,
          [ 1, t.dynamic.topleft[2], 1, t.dynamic.topleft[4] ],
          rng[1],
          rng[2], ws.leftmargin + 1 + ws.labelswidth, scr[2],
          false,
          "column labels",
          ws );
    fi;

    # Add the current row labels.
    if brc[1] <= scr[1] then
      BrowseData.PrintSubmatrix( t, t.work.labelsRow,
          t.work.labelsRowFormatted, false,
          BrowseData.HeightRow, BrowseData.WidthLabelsRow,
          t.work.sepRow, t.work.sepLabelsRow,
          t.dynamic.indexRow,
          [ 1 .. 2 * t.work.n0 + 1 ],
          t.dynamic.categories,
          not BrowseData.IsQuietSession( t.dynamic.replay ),
          [ t.dynamic.topleft[1], 1, t.dynamic.topleft[3], 1 ],
          rng[1] + ws.labelsheight,
          rng[2], ws.leftmargin+1, scr[2] - ws.rightmargin,
          false,
          "row labels",
          ws );
    fi;

    # Add the current entries from the main table.
    if brc[1] <= scr[1] and brc[2] <= scr[2] then
      BrowseData.PrintSubmatrix( t, t.work.main, t.work.mainFormatted,
          t.work.Main,
          BrowseData.HeightRow, BrowseData.WidthCol,
          t.work.sepRow, t.work.sepCol,
          t.dynamic.indexRow,
          t.dynamic.indexCol,
          t.dynamic.categories, false,
          t.dynamic.topleft,
          rng[1] + ws.labelsheight,
          rng[2], ws.leftmargin + 1 + ws.labelswidth, scr[2],
          true,
          "main",
          ws );
    fi;

    if not BrowseData.IsQuietSession( t.dynamic.replay ) then
      # Enter the footer.
      NCurses.PutLine( t.dynamic.window,
          scr[1] - ws.bottommargin - Length( footer ), ws.leftmargin, footer );
      # Print an individual grid if required.
      if IsBound( t.work.SpecialGrid ) then
        t.work.SpecialGrid( t, ws );
      fi;
      # Mark the table as restricted if applicable.
      if true in t.dynamic.isRejectedRow or
         true in t.dynamic.isRejectedCol or
         ForAny( t.dynamic.categories[2], c -> c.isRejectedCategory ) then
        NCurses.PutLine( t.dynamic.window, scr[1] - 1, scr[2] - 18,
            [ NCurses.attrs.BOLD, true, "(restricted table)" ] );
      fi;
    fi;
end;

#T should ShowTables *return* the record with margins etc.?


#############################################################################
##
#F  BrowseData.SetActions( <mode>, <actions>[, "replace"] )
##
##  This function installs functionality for the mode record <mode>,
##  that is, it binds actions to user inputs that shall be admissible for
##  <mode>.
##  The argument <actions> must be a dense list of pairs
##  `[ <inputs>, <action> ]', where <inputs> is a list of admissible inputs
##  for the new action, and <action> is a record with the components
##  `...' (the function that performs the action) and
##  `helplines' (a list of strings that describes the action in the standard
##  help overviews).
##  Each entry of <inputs> is either a nonempty string or a pair
##  `[ <inp>, <descr> ]',
##  where <inp> is a list of positive integers that denotes the input
##  characters, and <descr> is a string that represents this input in the
##  standard help overviews, an example of this format is
##  `[ [ 27 ], "<Esc>" ] ]' for the escape character as input.
##
##  If the optional argument "replace" is given then it is allowed to
##  replace an existing action with the same <inp> value.
##  If "replace" is not given then it is not allowed to install an actions
##  for an already admissible input.
##
BrowseData.SetActions := function( arg )
    local mode, actions, replace, pair, action, entry, new, done, i, old;

    mode:= arg[1];
    actions:= arg[2];
    replace:= 2 < Length( arg ) and arg[3] = "replace";

    if not IsBound( mode.actions ) then
      mode.actions:= [];
    fi;
    for pair in actions do
      action:= pair[2];
      for entry in pair[1] do

        # Create the triple.
        if IsString( entry ) and 0 < Length( entry ) then
          new:= [ List( entry, IntChar ), action, entry ];
        elif IsList( entry ) and
             Length( entry ) = 2 and
             IsList( entry[1] ) and
             ForAll( entry[1],
                     x -> IsInt( x ) or x in NCurses.mouseEvents ) and
             IsString( entry[2] ) and
             ForAll( entry, x -> 0 < Length( x ) ) then
          if NCurses.keys.BACKSPACE in entry[1] or
             NCurses.keys.DC in entry[1] then
            Error( "<Backspace> and <Delete> are not allowed inputs" );
          fi;
          new:= [ entry[1], action, entry[2] ];
        else
          Error( "invalid input ", pair, " for mode `", mode.name, "'" );
        fi;

        # Check that no admissible input is a prefix of an admissible input.
        done:= false;
        for i in [ 1 .. Length( mode.actions ) ] do
          old:= mode.actions[i];
          if ( Length( old[1] ) < Length( new[1] )
               and old[1] = new[1]{ [ 1 .. Length( old[1] ) ] } ) or
             ( Length( old[1] ) > Length( new[1] )
               and old[1]{ [ 1 .. Length( new[1] ) ] } = new[1] ) then
            Error( "a new input (", new[1], ") must not be a proper prefix\n",
                   "of an already admissible input (", old[1], ")" );
          elif old[1] = new[1] then
            if replace then
              mode.actions[i]:= new;
              done:= true;
            else
              Error( "a new input (", new[1], ") must not be equal to\n",
                   "an already admissible input" );
            fi;
          fi;
        od;

        # Store the triple.
        if not done then
          Add( mode.actions, new );
        fi;
      od;
    od;
end;


#############################################################################
##
##  browse mode
##
BrowseData.AddMode( "browse", "browse", [
    # standard actions
    [ [ "E" ], BrowseData.actions.Error ],
    [ [ "q", [ [ 27 ], "<Esc>" ] ],
      BrowseData.actions.QuitMode ],
    [ [ "Q" ], BrowseData.actions.QuitTable ],
    [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
      BrowseData.actions.ShowHelp ],
    [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
    [ [ [ [ 14 ], "<Ctrl-N>" ] ], BrowseData.actions.DoNothing ],
    # switch to other modes
    [ [ "se" ], BrowseData.actions.EnterSelectEntryMode ],
    [ [ "sr" ], BrowseData.actions.EnterSelectRowMode ],
    [ [ "sc" ], BrowseData.actions.EnterSelectColumnMode ],
    # search
    [ [ "/" ], BrowseData.actions.SearchFirst ],
    [ [ "n" ], BrowseData.actions.SearchFurther ],
    # scroll
    [ [ [ [ NCurses.keys.HOME ], "<Home>" ] ],
      BrowseData.actions.ScrollToFirstRow ],
    [ [ [ [ NCurses.keys.END ], "<End>" ] ],
      BrowseData.actions.ScrollToLastRow ],
    [ [ "R" ], BrowseData.actions.ScrollScreenRight ],
    [ [ "L" ], BrowseData.actions.ScrollScreenLeft ],
    [ [ "D", [ [ NCurses.keys.NPAGE ], "<PageDown>" ],
      [ [ 32 ], "<Space>" ] ],
      BrowseData.actions.ScrollScreenDown ],
    [ [ "U", [ [ NCurses.keys.PPAGE ], "<PageUp>" ] ],
      BrowseData.actions.ScrollScreenUp ],
    [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
      BrowseData.actions.ScrollCellRight ],
    [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
      BrowseData.actions.ScrollCellLeft ],
    [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
      BrowseData.actions.ScrollCellDown ],
    [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
      BrowseData.actions.ScrollCellUp ],
    # mouse events
    [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
          "<Mouse1Down>" ],
        [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
          "<Mouse1Click>" ] ],
      BrowseData.actions.DealWithSingleMouseClick ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_DOUBLE_CLICKED" ],
          "<Mouse1DoubleClick>" ] ],
      BrowseData.actions.DealWithDoubleMouseClick ],
    # expand and collapse
    [ [ "X" ], BrowseData.actions.ExpandAllCategories ],
    [ [ "C" ], BrowseData.actions.CollapseAllCategories ],
    [ [ [ [ 13 ], "<Return>" ], [ [ NCurses.keys.ENTER ], "<Enter>" ] ],
      BrowseData.actions.ClickOrToggle ],
    # filtering
    [ [ "f" ], BrowseData.actions.FilterTable ],
    [ [ "z" ], BrowseData.actions.ClearFiltering ],
    # undo sorting, categorizing, hiding
    [ [ "!" ], BrowseData.actions.ResetTable ],
  ] );

BrowseData.defaults.dynamic.activeModes[1]:=
    First( BrowseData.defaults.work.availableModes, x -> x.name = "browse" );

BrowseData.defaults.dynamic.activeModes[1].onReturn:= function( t )
    t.dynamic.selectedEntry:= [ 0, 0 ];
    t.dynamic.selectedCategory:= [ 0, 0 ];
end;


#############################################################################
##
##  help mode (used by `BrowseData.defaults.ShowHelpTable')
##
BrowseData.AddMode( "help", "help", [
    # standard actions
    [ [ "E" ], BrowseData.actions.Error ],
    [ [ "q", [ [ 27 ], "<Esc>" ] ],
      BrowseData.actions.QuitMode ],
    [ [ "Q" ], BrowseData.actions.QuitTable ],
    [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
    [ [ [ [ 14 ], "<Ctrl-N>" ] ], BrowseData.actions.DoNothing ],
    # scroll
    [ [ [ [ NCurses.keys.HOME ], "<Home>" ] ],
      BrowseData.actions.ScrollToFirstRow ],
    [ [ [ [ NCurses.keys.END ], "<End>" ] ],
      BrowseData.actions.ScrollToLastRow ],
    [ [ "R" ], BrowseData.actions.ScrollScreenRight ],
    [ [ "L" ], BrowseData.actions.ScrollScreenLeft ],
    [ [ "D", [ [ NCurses.keys.NPAGE ], "<PageDown>" ],
      [ [ 32 ], "<Space>" ] ],
      BrowseData.actions.ScrollScreenDown ],
    [ [ "U", [ [ NCurses.keys.PPAGE ], "<PageUp>" ] ],
      BrowseData.actions.ScrollScreenUp ],
    [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
      BrowseData.actions.ScrollCellRight ],
    [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
      BrowseData.actions.ScrollCellLeft ],
    [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
      BrowseData.actions.ScrollCellDown ],
    [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
      BrowseData.actions.ScrollCellUp ],
  ] );


#############################################################################
##
##  mode where one matrix entry is selected
##
BrowseData.AddMode( "select_entry", "select_entry", [
    # standard actions
    [ [ "E" ], BrowseData.actions.Error ],
    [ [ "q", [ [ 27 ], "<Esc>" ] ],
      BrowseData.actions.QuitMode ],
    [ [ "Q" ], BrowseData.actions.QuitTable ],
    [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
      BrowseData.actions.ShowHelp ],
    [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
    [ [ [ [ 14 ], "<Ctrl-N>" ] ], BrowseData.actions.DoNothing ],
    # search
    [ [ "/" ], BrowseData.actions.SearchFirst ],
    [ [ "n" ], BrowseData.actions.SearchFurther ],
    # scroll
    [ [ [ [ NCurses.keys.HOME ], "<Home>" ] ],
      BrowseData.actions.ScrollToFirstRow ],
    [ [ [ [ NCurses.keys.END ], "<End>" ] ],
      BrowseData.actions.ScrollToLastRow ],
    [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
      BrowseData.actions.ScrollSelectedCellRight ],
    [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
      BrowseData.actions.ScrollSelectedCellLeft ],
    [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
      BrowseData.actions.ScrollSelectedCellDown ],
    [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
      BrowseData.actions.ScrollSelectedCellUp ],
# RLDU: add scrolling similar to browse mode,
    [ [ [ [ 13 ], "<Return>" ], [ [ NCurses.keys.ENTER ], "<Enter>" ] ],
      BrowseData.actions.ClickOrToggle ],
    # mouse events
    [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
          "<Mouse1Down>" ],
        [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
          "<Mouse1Click>" ] ],
      BrowseData.actions.DealWithSingleMouseClick ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_DOUBLE_CLICKED" ],
          "<Mouse1DoubleClick>" ] ],
      BrowseData.actions.DealWithDoubleMouseClick ],
    # expand and collapse
    [ [ "X" ], BrowseData.actions.ExpandAllCategories ],
    [ [ "C" ], BrowseData.actions.CollapseAllCategories ],
    [ [ "x" ], BrowseData.actions.ExpandCurrentCategory ],
    [ [ "c" ], BrowseData.actions.CollapseCurrentCategory ],
    [ [ "so" ], BrowseData.actions.SortTableByRow ],
    # filtering
    [ [ "f" ], BrowseData.actions.FilterTable ],
    [ [ "z" ], BrowseData.actions.ClearFiltering ],
    # undo sorting, categorizing, hiding
    [ [ "!" ], BrowseData.actions.ResetTable ],
  ] );


#############################################################################
##
##  mode where one matrix row is selected
##
BrowseData.AddMode( "select_row", "select_row", [
    # standard actions
    [ [ "E" ], BrowseData.actions.Error ],
    [ [ "q", [ [ 27 ], "<Esc>" ] ],
      BrowseData.actions.QuitMode ],
    [ [ "Q" ], BrowseData.actions.QuitTable ],
    [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
      BrowseData.actions.ShowHelp ],
    [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
    [ [ [ [ 14 ], "<Ctrl-N>" ] ], BrowseData.actions.DoNothing ],
    # search
    [ [ "/" ], BrowseData.actions.SearchFirst ],
    [ [ "n" ], BrowseData.actions.SearchFurther ],
    # scroll
    [ [ [ [ NCurses.keys.HOME ], "<Home>" ] ],
      BrowseData.actions.ScrollToFirstRow ],
    [ [ [ [ NCurses.keys.END ], "<End>" ] ],
      BrowseData.actions.ScrollToLastRow ],
    [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
      BrowseData.actions.ScrollSelectedRowRight ],
    [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
      BrowseData.actions.ScrollSelectedRowLeft ],
    [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
      BrowseData.actions.ScrollSelectedRowDown ],
    [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
      BrowseData.actions.ScrollSelectedRowUp ],
# RLDU: add scrolling similar to browse mode,
    [ [ [ [ 13 ], "<Return>" ], [ [ NCurses.keys.ENTER ], "<Enter>" ] ],
      BrowseData.actions.ClickOrToggle ],
    # mouse events
    [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
          "<Mouse1Down>" ],
        [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
          "<Mouse1Click>" ] ],
      BrowseData.actions.DealWithSingleMouseClick ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_DOUBLE_CLICKED" ],
          "<Mouse1DoubleClick>" ] ],
      BrowseData.actions.DealWithDoubleMouseClick ],
    # expand and collapse
    [ [ "X" ], BrowseData.actions.ExpandAllCategories ],
    [ [ "C" ], BrowseData.actions.CollapseAllCategories ],
    [ [ "x" ], BrowseData.actions.ExpandCurrentCategory ],
    [ [ "c" ], BrowseData.actions.CollapseCurrentCategory ],
    [ [ "so" ], BrowseData.actions.SortTableByRow ],
    # filtering
    [ [ "f" ], BrowseData.actions.FilterTable ],
    [ [ "z" ], BrowseData.actions.ClearFiltering ],
    [ [ "h" ], BrowseData.actions.HideCurrentRow ],
    # undo sorting, categorizing, hiding
    [ [ "!" ], BrowseData.actions.ResetTable ],
  ] );


#############################################################################
##
##  mode where one matrix column is selected
##
BrowseData.AddMode( "select_column", "select_column", [
    # standard actions
    [ [ "E" ], BrowseData.actions.Error ],
    [ [ "q", [ [ 27 ], "<Esc>" ] ],
      BrowseData.actions.QuitMode ],
    [ [ "Q" ], BrowseData.actions.QuitTable ],
    [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
      BrowseData.actions.ShowHelp ],
    [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
    [ [ [ [ 14 ], "<Ctrl-N>" ] ], BrowseData.actions.DoNothing ],
    # search
    [ [ "/" ], BrowseData.actions.SearchFirst ],
    [ [ "n" ], BrowseData.actions.SearchFurther ],
    # scroll
    [ [ [ [ NCurses.keys.HOME ], "<Home>" ] ],
      BrowseData.actions.ScrollToFirstRow ],
    [ [ [ [ NCurses.keys.END ], "<End>" ] ],
      BrowseData.actions.ScrollToLastRow ],
    [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
      BrowseData.actions.ScrollSelectedColumnRight ],
    [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
      BrowseData.actions.ScrollSelectedColumnLeft ],
    [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
      BrowseData.actions.ScrollSelectedColumnDown ],
    [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
      BrowseData.actions.ScrollSelectedColumnUp ],
# RLDU: add scrolling similar to browse mode,
    [ [ [ [ 13 ], "<Return>" ], [ [ NCurses.keys.ENTER ], "<Enter>" ] ],
      BrowseData.actions.ClickOrToggle ],
    # mouse events
    [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
          "<Mouse1Down>" ],
        [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
          "<Mouse1Click>" ] ],
      BrowseData.actions.DealWithSingleMouseClick ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_DOUBLE_CLICKED" ],
          "<Mouse1DoubleClick>" ] ],
      BrowseData.actions.DealWithDoubleMouseClick ],
    # expand and collapse
    [ [ "so" ], BrowseData.actions.SortTableByColumn ],
    [ [ "sc" ], BrowseData.actions.SortAndCategorizeTable ],
    # filtering
    [ [ "f" ], BrowseData.actions.FilterTable ],
    [ [ "z" ], BrowseData.actions.ClearFiltering ],
    [ [ "h" ], BrowseData.actions.HideCurrentColumn ],
    # undo sorting, categorizing, hiding
    [ [ "!" ], BrowseData.actions.ResetTable ],
  ] );


#############################################################################
##
##  mode where one matrix row and an entry in this row are selected
##
BrowseData.AddMode( "select_row_and_entry", "select_row_and_entry", [
    # standard actions
    [ [ "E" ], BrowseData.actions.Error ],
    [ [ "q", [ [ 27 ], "<Esc>" ] ],
      BrowseData.actions.QuitMode ],
    [ [ "Q" ], BrowseData.actions.QuitTable ],
    [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
      BrowseData.actions.ShowHelp ],
    [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
    [ [ [ [ 14 ], "<Ctrl-N>" ] ], BrowseData.actions.DoNothing ],
    # search
    [ [ "/" ], BrowseData.actions.SearchFirst ],
    [ [ "n" ], BrowseData.actions.SearchFurther ],
    # scroll
    [ [ [ [ NCurses.keys.HOME ], "<Home>" ] ],
      BrowseData.actions.ScrollToFirstRow ],
    [ [ [ [ NCurses.keys.END ], "<End>" ] ],
      BrowseData.actions.ScrollToLastRow ],
    [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
      BrowseData.actions.ScrollSelectedRowRight ],
    [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
      BrowseData.actions.ScrollSelectedRowLeft ],
    [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
      BrowseData.actions.ScrollSelectedRowDown ],
    [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
      BrowseData.actions.ScrollSelectedRowUp ],
# RLDU: add scrolling similar to browse mode,
    [ [ [ [ 13 ], "<Return>" ], [ [ NCurses.keys.ENTER ], "<Enter>" ] ],
      BrowseData.actions.ClickOrToggle ],
    # mouse events
    [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
          "<Mouse1Down>" ],
        [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
          "<Mouse1Click>" ] ],
      BrowseData.actions.DealWithSingleMouseClick ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_DOUBLE_CLICKED" ],
          "<Mouse1DoubleClick>" ] ],
      BrowseData.actions.DealWithDoubleMouseClick ],
    # filtering
    [ [ "f" ], BrowseData.actions.FilterTable ],
    [ [ "z" ], BrowseData.actions.ClearFiltering ],
    # undo sorting, categorizing, hiding
    [ [ "!" ], BrowseData.actions.ResetTable ],
  ] );


#############################################################################
##
##  mode where one matrix column and an entry in this column are selected
##
BrowseData.AddMode( "select_column_and_entry", "select_column_and_entry", [
    # standard actions
    [ [ "E" ], BrowseData.actions.Error ],
    [ [ "q", [ [ 27 ], "<Esc>" ] ],
      BrowseData.actions.QuitMode ],
    [ [ "Q" ], BrowseData.actions.QuitTable ],
    [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
      BrowseData.actions.ShowHelp ],
    [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
    [ [ [ [ 14 ], "<Ctrl-N>" ] ], BrowseData.actions.DoNothing ],
    # search
    [ [ "/" ], BrowseData.actions.SearchFirst ],
    [ [ "n" ], BrowseData.actions.SearchFurther ],
    # scroll
    [ [ [ [ NCurses.keys.HOME ], "<Home>" ] ],
      BrowseData.actions.ScrollToFirstRow ],
    [ [ [ [ NCurses.keys.END ], "<End>" ] ],
      BrowseData.actions.ScrollToLastRow ],
    [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
      BrowseData.actions.ScrollSelectedColumnRight ],
    [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
      BrowseData.actions.ScrollSelectedColumnLeft ],
    [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
      BrowseData.actions.ScrollSelectedColumnDown ],
    [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
      BrowseData.actions.ScrollSelectedColumnUp ],
# RLDU: add scrolling similar to browse mode,
    [ [ [ [ 13 ], "<Return>" ], [ [ NCurses.keys.ENTER ], "<Enter>" ] ],
      BrowseData.actions.ClickOrToggle ],
    # mouse events
    [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
          "<Mouse1Down>" ],
        [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
          "<Mouse1Click>" ] ],
      BrowseData.actions.DealWithSingleMouseClick ],
    [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_DOUBLE_CLICKED" ],
          "<Mouse1DoubleClick>" ] ],
      BrowseData.actions.DealWithDoubleMouseClick ],
    # filtering
    [ [ "f" ], BrowseData.actions.FilterTable ],
    [ [ "z" ], BrowseData.actions.ClearFiltering ],
    # undo sorting, categorizing, hiding
    [ [ "!" ], BrowseData.actions.ResetTable ],
  ] );


#############################################################################
##
#F  BrowseData.SetDefaults( <t>, <arec> )
##
##  takes a record <t>, sets defaults as described by the record <arec> or
##  by the global record `BrowseData' in <t>.
##
BrowseData.SetDefaults:= function( t, arec )
    local comp, name, record, i, j, currlog;

    # Set defaults and check consistency.
    for comp in [ "work", "dynamic" ] do
      if not IsBound( t.( comp ) ) then
        t.( comp ):= rec();
      fi;
    od;
    if not IsBound( t.work.main ) then
      Error( "at least the component `<t>.work.main' must be bound" );
    fi;

    # Set default values for unbound `work' and `dynamic' components.
    for comp in [ "work", "dynamic" ] do
      for record in [ arec.( comp ), BrowseData.defaults.( comp ) ] do
        for name in RecNames( record ) do
          if not IsBound( t.( comp ).( name ) ) then
            t.( comp ).( name ):= StructuralCopy( record.( name ) );
          fi;
        od;
      od;
    od;

    # Compute the sizes of the four matrices.
    if not IsBound( t.work.m0 ) then
      t.work.m0:= Maximum( Length( t.work.corner ),
                           Length( t.work.labelsCol ) );
    fi;
    if not IsBound( t.work.m ) then
      t.work.m:= Maximum( Length( t.work.labelsRow ),
                          Length( t.work.main ) );
    fi;
    if not IsBound( t.work.n0 ) then
      t.work.n0:= 0;
      if not IsEmpty( t.work.labelsRow ) then
        t.work.n0:= Maximum( List( t.work.labelsRow, Length ) );
      fi;
      if not IsEmpty( t.work.corner ) then
        t.work.n0:= Maximum( t.work.n0,
                             Maximum( List( t.work.corner, Length ) ) );
      fi;
    fi;
    if not IsBound( t.work.n ) then
      t.work.n:= Maximum( List( t.work.main, Length ) );
      if not IsEmpty( t.work.labelsCol ) then
        t.work.n:= Maximum( t.work.n,
                            Maximum( List( t.work.labelsCol, Length ) ) );
      fi;
    fi;

    # Set defaults inside the replay record.
    if IsBound( t.dynamic.replay ) then
      for currlog in t.dynamic.replay.logs do
        for comp in RecNames( t.dynamic.replayDefaults ) do
          if not IsBound( currlog.( comp ) ) then
            currlog.( comp ):= t.dynamic.replayDefaults.( comp );
          fi;
        od;
      od;
      if not IsBound( t.dynamic.replay.pointer ) then
        t.dynamic.replay.pointer:= 1;
      fi;
      t.dynamic.replay.logs:= t.dynamic.replay.logs{
        [ t.dynamic.replay.pointer .. Length( t.dynamic.replay.logs ) ] };
      t.dynamic.replay.pointer:= 1;
    else
      t.dynamic.replay:= rec( logs:= [], pointer:= 1 );
    fi;

    # Prepend the programmatic steps.
    if not IsBound( t.dynamic.initialSteps ) then
      t.dynamic.initialSteps:= [];
    fi;
    t.dynamic.replay.logs:= Concatenation( [ rec(
          steps:= t.dynamic.initialSteps,
          quiet:= true,
          position:= 1,
          replayInterval:= 0, ) ],
        t.dynamic.replay.logs );

    # Initialize the sort components (for the main table only).
    if t.dynamic.indexRow = [] then
      t.dynamic.indexRow:= [ 1 .. 2 * t.work.m + 1 ];
    fi;
    if t.dynamic.indexCol = [] then
      t.dynamic.indexCol:= [ 1 .. 2 * t.work.n + 1 ];
    fi;

    # Initialize the hide components.
    if t.dynamic.isCollapsedRow = [] then
      t.dynamic.isCollapsedRow:=
          BlistList( [ 1 .. Length( t.dynamic.indexRow ) ], [] );
    fi;
    if t.dynamic.isRejectedRow = [] then
      t.dynamic.isRejectedRow:=
          BlistList( [ 1 .. Length( t.dynamic.indexRow ) ], [] );
    fi;
    if t.dynamic.isCollapsedCol = [] then
      t.dynamic.isCollapsedCol:=
          BlistList( [ 1 .. Length( t.dynamic.indexCol ) ], [] );
    fi;
    if t.dynamic.isRejectedCol = [] then
      t.dynamic.isRejectedCol:=
          BlistList( [ 1 .. Length( t.dynamic.indexCol ) ], [] );
    fi;
    if t.dynamic.isRejectedLabelsRow = [] then
      t.dynamic.isRejectedLabelsRow:=
          BlistList( [ 1 .. 2 * t.work.n0 + 1 ], [] );
    fi;
    if t.dynamic.isRejectedLabelsCol = [] then
      t.dynamic.isRejectedLabelsCol:=
          BlistList( [ 1 .. 2 * t.work.m0 + 1 ], [] );
    fi;
end;


#############################################################################
##
#F  NCurses.BrowseGeneric( <t>[, <arec>] )
##
##  <#GAPDoc Label="NCurses.BrowseGeneric_man">
##  <ManSection>
##  <Func Name="NCurses.BrowseGeneric" Arg="t[, arec]"/>
##
##  <Returns>
##  an application dependent value, or nothing.
##  </Returns>
##
##  <Description>
##  <Ref Func="NCurses.BrowseGeneric"/> is used to show the browse table
##  <A>t</A> (see&nbsp;<Ref Func="BrowseData.IsBrowseTable"/>) in a formatted
##  way on a text screen, and allows the user to navigate in this table.
##  <P/>
##  The optional argument <A>arec</A>, if given, must be a record
##  whose components <C>work</C> and <C>dynamic</C>, if bound,
##  are used to provide defaults for missing values in the corresponding
##  components of <A>t</A>.
##  The default for <A>arec</A> and for the components not provided in
##  <A>arec</A> is <C>BrowseData.defaults</C>,
##  see&nbsp;<Ref Var="BrowseData"/>,
##  the function <C>BrowseData.SetDefaults</C> sets these default values.
##  <P/>
##  At least the component <C>work.main</C> must be bound in <A>t</A>,
##  with value a list of list of table cell data objects,
##  see&nbsp;<Ref Func="BrowseData.IsBrowseTableCellData"/>.
##  <P/>
##  When the window or the screen is too small for the browse table,
##  according to its component <C>work.minyx</C>,
##  the table will not be shown in visual mode,
##  and <K>fail</K> is returned.
##  (This holds also if there would be no return value of the call in a large
##  enough screen.)
##  Thus one should check for <K>fail</K> results of programmatic calls of
##  <Ref Func="NCurses.BrowseGeneric"/>,
##  and one should better not admit <K>fail</K> as a regular return value.
##  <P/>
##  Most likely,
##  <Ref Func="NCurses.BrowseGeneric"/> will not be called on the command
##  line, but the browse table <A>t</A> will be composed by a suitable
##  function which then calls <Ref Func="NCurses.BrowseGeneric"/>,
##  see the examples in Chapter&nbsp;<Ref Chap="ch:appl"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
NCurses.BrowseGeneric:= function( arg )
    local t, arec, oldscr, userinput, lastinput, maxyx, winPar, minyx, i,
          timeout, c, len, mode, names, pos, scr, lastline, name;

    # If we know that there will be no chance to show anything
    # in visual mode then print a warning and give up.
    if GAPInfo.SystemEnvironment.TERM = "dumb" then
      Info( InfoWarning, 1,
            "cannot switch to visual mode because of TERM = \"dumb\"" );
      return fail;
    fi;

    # Get the arguments.
    if   Length( arg ) = 1 and IsRecord( arg[1] ) then
      t:= arg[1];
      arec:= BrowseData.defaults;
    elif Length( arg ) = 2 and IsRecord( arg[1] ) and IsRecord( arg[2] ) then
      t:= arg[1];
      arec:= arg[2];
    else
      Error( "usage: NCurses.BrowseGeneric( <t>[, <arec>] )" );
    fi;

    # Set defaults.
    BrowseData.SetDefaults( t, arec );
    t.dynamic.interrupt:= false;
    oldscr:= SizeScreen();

    # Initialize.
    t.dynamic.changed:= true;
    userinput:= [];
    lastinput:= [];

    while not IsEmpty( t.dynamic.activeModes ) do

      if not BrowseData.IsQuietSession( t.dynamic.replay ) and
         t.dynamic.changed then
        if   not IsBound( t.dynamic.window ) then

          # Check whether the screen is big enough for the table.
          maxyx:= NCurses.getmaxyx( 0 );
          winPar:= t.work.windowParameters;
          minyx:= ShallowCopy( t.work.minyx );
          for i in [ 1, 2 ] do
            if IsFunction( minyx[i] ) then
              minyx[i]:= minyx[i]( t );
            fi;
          od;
          if not BrowseData.IsDoneReplay( t.dynamic.replay ) then
            timeout:= 2000;
          else
            timeout:= 0;
          fi;
          if maxyx[1] < winPar[1] + winPar[3] or
             maxyx[2] < winPar[2] + winPar[4] then
            NCurses.Alert(
              [ Concatenation( "The screen (", String( maxyx[1] ), ",",
                    String( maxyx[2] ), ") is too small for" ),
                Concatenation( "the desired window (",
                    String( winPar[1] ), ",", String( winPar[2] ), ",",
                    String( winPar[3] ), ",", String( winPar[4] ), ")" ) ],
              timeout, NCurses.attrs.BOLD );
            return fail;
          elif maxyx[1] < minyx[1] or maxyx[2] < minyx[2] then
            NCurses.Alert(
              [ Concatenation( "The screen (", String( maxyx[1] ), ",",
                    String( maxyx[2] ), ") is smaller than" ),
                Concatenation( "the minimal window size (",
                    String( minyx[1] ), ",", String( minyx[2] ), ")" ) ],
              timeout, NCurses.attrs.BOLD );
            return fail;
          elif ( winPar[1] <> 0 and winPar[1] < minyx[1] ) or
               ( winPar[2] <> 0 and winPar[2] < minyx[2] ) then
            NCurses.Alert(
              [ Concatenation( "The desired window (", String( winPar[1] ),
                    ",", String( winPar[2] ), ") is smaller than" ),
                Concatenation( "the minimal window size (",
                    String( minyx[1] ), ",", String( minyx[2] ), ")" ) ],
              timeout, NCurses.attrs.BOLD );
            return fail;
          fi;

          NCurses.SetTerm();
          NCurses.curs_set( 0 );
          t.dynamic.window:= CallFuncList( NCurses.newwin, winPar );
          t.dynamic.panel:= NCurses.new_panel( t.dynamic.window );

          t.dynamic.statuswindow:= NCurses.newwin( 1, winPar[2],
                                                   maxyx[1]-1, 0 );
          t.dynamic.statuspanel:= NCurses.new_panel( t.dynamic.statuswindow );
          NCurses.PutLine( t.dynamic.statuswindow, 0, 0,
                           [ NCurses.attrs.BLINK, "(computing ...)" ] );
          NCurses.hide_panel( t.dynamic.statuspanel );

        elif oldscr <> SizeScreen() then
          # Trigger a refresh for `NCurses.getmaxyx'.
          NCurses.endwin();
          NCurses.doupdate();
          oldscr:= SizeScreen();
        fi;

        # Show the tables.
        BrowseData.CurrentMode( t ).ShowTables( t );
        NCurses.update_panels();
        NCurses.doupdate();
        NCurses.curs_set( 0 );
      fi;
      t.dynamic.changed:= false;

      # Read a character.
      # It is returned either as an integer
      # or in case of a mouse event as a list.
      c:= BrowseData.GetCharacter( t );

      # Deal with `fail' and backspace/delete.
      if c = NCurses.keys.BACKSPACE or c = NCurses.keys.DC then
        # Remove the backspace/delete character and the previous one.
        len:= Length( userinput );
        if 0 < len then
          Unbind( userinput[ len ] );
        fi;
        # Force redraw, because of the info in the last row.
        t.dynamic.changed:= true;
      else
        if IsList( c ) and c[1] = NCurses.keys.MOUSE then
          if 0 < Length( c[2] ) then
            Add( userinput, c[1] );
            Add( userinput, c[2][1].event );
          fi;
        else
          Add( userinput, c );
        fi;
        len:= Length( userinput );
        # The `activeModes' list may have been changed by `ShowTables'.
        mode:= BrowseData.CurrentMode( t );
        names:= List( mode.actions, x -> x[1] );
        # Check whether the current input is admissible.
        pos:= Position( names, userinput );
        if pos <> fail then
          # Unhide the status panel before the computations.
          # (Note that the quiet mode may have been left by reading the
          # current character, so the panels might not exist yet.)
          if not BrowseData.IsQuietSession( t.dynamic.replay )
             and IsBound( t.dynamic.statuspanel ) then
            NCurses.show_panel( t.dynamic.statuspanel );
            NCurses.update_panels();
            NCurses.doupdate();
            NCurses.curs_set( 0 );
          fi;
          # Perform the associated action.
          if IsList( c ) and c[1] = NCurses.keys.MOUSE then
            mode.actions[ pos ][2].action( t, c[2][1] );
          else
            mode.actions[ pos ][2].action( t );
          fi;
          # Hide the status panel again.
          if not BrowseData.IsQuietSession( t.dynamic.replay )
             and IsBound( t.dynamic.statuspanel ) then
            NCurses.hide_panel( t.dynamic.statuspanel );
            NCurses.update_panels();
            NCurses.doupdate();
            NCurses.curs_set( 0 );
          fi;
          # Reinitialize the user input buffer.
          lastinput:= userinput;
          userinput:= [];
        elif ForAny( names, x -> len < Length( x ) and
                                 x{ [ 1 .. len ] } = userinput ) then
          # The input is only partial, show it in the last window line.
          if not BrowseData.IsQuietSession( t.dynamic.replay ) then
            if oldscr <> SizeScreen() then
              # Trigger a refresh for `NCurses.getmaxyx'.
              NCurses.endwin();
              NCurses.doupdate();
              # Refresh the screen
              BrowseData.CurrentMode( t ).ShowTables( t );
              NCurses.update_panels();
              NCurses.doupdate();
              NCurses.curs_set( 0 );
              oldscr:= SizeScreen();
            fi;
            # Translate non-printable characters.
            scr:= BrowseData.HeightWidthWindow( t );
            lastline:= "partial input: ";
            for c in userinput do
              if c in [ 1 .. 255 ] then
                Add( lastline, CHAR_INT( c ) );
              elif IsList( c ) then
                Add( lastline, "<MOUSE ...>" );
              else
                for name in RecNames( NCurses.keys ) do
                  if NCurses.keys.( name ) = c then
                    Add( lastline, '<' );
                    Append( lastline, name );
                    Add( lastline, '>' );
                  fi;
                od;
              fi;
            od;
            Append( lastline, RepeatedString( " ", scr[2] - len - 15 ) );
            NCurses.PutLine( t.dynamic.window, scr[1] - 1, 0, lastline );
            NCurses.update_panels();
            NCurses.doupdate();
            NCurses.curs_set( 0 );
          fi;
        else
          # Discard the last read character(s),
          if IsList( c ) and c[1] = NCurses.keys.MOUSE then
            userinput:= userinput{ [ 1 .. len-2 ] };
          else
            userinput:= userinput{ [ 1 .. len-1 ] };
          fi;
        fi;
      fi;

      if not BrowseData.IsDoneReplay( t.dynamic.replay ) and
         NCurses.IsStdoutATty() then

        # If we are in replay mode then check whether the user interrupted.
        NCurses.savetty();
        NCurses.wtimeout( 0, 0 );
        c:= NCurses.wgetch( 0 );
        NCurses.resetty();
        NCurses.wtimeout( 0, -1 );
        if c <> false then
          t.dynamic.interrupt:= true;
          NCurses.Alert( "user interrupt, quitting", 0, NCurses.attrs.BOLD );
          BrowseData.actions.QuitTable.action( t );
        fi;

      fi;

    od;

    # Restore the active modes before the table was left.
    if IsBound( t.dynamic.activeModesBeforeQuit ) then
      t.dynamic.activeModes:= t.dynamic.activeModesBeforeQuit;
      Unbind( t.dynamic.activeModesBeforeQuit );
    fi;

    # Store the log if requested.
    if IsBound( BrowseData.logStore ) and BrowseData.logStore = true then
      BrowseData.log:= t.dynamic.log;
    fi;

    # Clean up.
    if not BrowseData.IsQuietSession( t.dynamic.replay ) then
      NCurses.del_panel( t.dynamic.panel );
      NCurses.delwin( t.dynamic.window );
      NCurses.del_panel( t.dynamic.statuspanel );
      NCurses.delwin( t.dynamic.statuswindow );
      NCurses.resetty();
      NCurses.endwin();
      Unbind( t.dynamic.window );
      Unbind( t.dynamic.panel );
      Unbind( t.dynamic.statuswindow );
      Unbind( t.dynamic.statuspanel );
    fi;

    # Return (a value).
    if IsBound( t.dynamic.Return ) then
      return t.dynamic.Return;
    else
      return;
    fi;
end;


#############################################################################
##
#E

