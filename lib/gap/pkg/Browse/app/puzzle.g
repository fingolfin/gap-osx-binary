#############################################################################
##
#W  puzzle.g              GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowsePuzzle( [<m>, <n>[, <pi>]] )
##
##  <#GAPDoc Label="Puzzle_section">
##  <Section Label="sec:mnpuzzle">
##  <Heading>A Puzzle</Heading>
##  <Index Subkey="A Puzzle">game</Index>
##
##  We consider an <M>m</M> by <M>n</M> rectangle of squares numbered from
##  <M>1</M> to <M>m n - 1</M>, the bottom right square is left empty.
##  The numbered squares are permuted
##  by successively exchanging the empty square and a neighboring square
##  such that in the end, the empty cell is again in the bottom right corner.
##
##  <Table Align="|c|c|c|c|">
##  <HorLine/>
##  <Row>
##    <Item><M> 7</M></Item>
##    <Item><M>13</M></Item>
##    <Item><M>14</M></Item>
##    <Item><M> 2</M></Item>
##  </Row>
##  <HorLine/>
##  <Row>
##    <Item><M> 1</M></Item>
##    <Item><M> 4</M></Item>
##    <Item><M>15</M></Item>
##    <Item><M>11</M></Item>
##  </Row>
##  <HorLine/>
##  <Row>
##    <Item><M> 6</M></Item>
##    <Item><M> 8</M></Item>
##    <Item><M> 3</M></Item>
##    <Item><M> 9</M></Item>
##  </Row>
##  <HorLine/>
##  <Row>
##    <Item><M>10</M></Item>
##    <Item><M> 5</M></Item>
##    <Item><M>12</M></Item>
##    <Item><M>  </M></Item>
##  </Row>
##  <HorLine/>
##  </Table>
##
##  The aim of the game is to order the numbered squares via these moves.
##  <P/>
##  For the case <M>m = n = 4</M>, the puzzle is (erroneously?) known under
##  the name <Q>Sam Loyd's Fifteen</Q>, see&nbsp;<Cite Key="LoydFifteenWeb"/>
##  and&nbsp;<Cite Key="HistGames"/> for more information and references.
##
##  <ManSection>
##  <Func Name="BrowsePuzzle" Arg="[m, n[, pi]]"/>
##
##  <Returns>
##  a record describing the initial and final status of the puzzle.
##  </Returns>
##
##  <Description>
##  This function shows the rectangle in a window.
##  <P/>
##  The arguments <A>m</A> and <A>n</A> are the dimensions of the rectangle,
##  the default for both values is <M>4</M>.
##  The initial distribution of the numbers in the squares can be prescribed
##  via a permutation <A>pi</A>, the default is a random element in the
##  alternating group on the points <M>1, 2, \ldots, <A>m</A> <A>n</A> - 1</M>.
##  (Note that the game has not always a solution.)
##  <P/>
##  In any case, the empty cell is selected, and the selection can be
##  moved to neighboring cells via the arrow keys,
##  or to any place in the same row or column via a mouse click.
##  <P/>
##  The return value is a record with the components
##  <C>dim</C> (the pair <C>[ m, n ]</C>),
##  <C>init</C> (the initial permutation),
##  <C>final</C> (the final permutation), and
##  <C>steps</C> (the number of transpositions that were needed).
##
##  <Example><![CDATA[
##  gap> BrowseData.SetReplay( Concatenation(
##  >        BrowsePuzzleSolution.steps, "Q" ) );
##  gap> BrowsePuzzle( 4, 4, BrowsePuzzleSolution.init );;
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##
##  An implementation using only mouse clicks but no key strokes
##  is available in the &GAP; package <Package>XGAP</Package>
##  (see&nbsp;<Cite Key="XGAP"/>).
##  <P/>
##  <E>Implementation remarks</E>:
##  The game board is implemented via a browse table,
##  without row and column labels,
##  with static header, dynamic footer, and individual <C>minyx</C> function.
##  Only one mode is needed in which one cell is selected,
##  and besides the standard actions for quitting the table, asking for help,
##  and saving the current window contents,
##  only the four moves via the arrow keys and mouse clicks are admissible.
##  <Index>mouse events</Index>
##  <P/>
##  Some standard <Ref Func="NCurses.BrowseGeneric"/> functionality,
##  such as scrolling, selecting, and searching,
##  are not available in this application.
##  <P/>
##  The code can be found in the file <F>app/puzzle.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowsePuzzle", function( arg )
    local m, n, pi, numbers, matrix, box, move, mode, max, empty, fmatrix,
          i, j, table;

    # Get and check the arguments.
    if   Length( arg ) = 0 then
      m:= 4;
      n:= 4;
      pi:= Random( AlternatingGroup( 15 ) );
    elif Length( arg ) = 2 and IsPosInt( arg[1] ) and IsPosInt( arg[2] ) then
      m:= arg[1];
      n:= arg[2];
      pi:= Random( AlternatingGroup( m*n-1 ) );
    elif Length( arg ) = 3 and IsPosInt( arg[1] ) and IsPosInt( arg[2] ) then
      m:= arg[1];
      n:= arg[2];
      pi:= arg[3];
    else
      Error( "usage: BrowsePuzzle( [<m>, <n>[, <pi>]] )" );
    fi;
    if not IsPerm( pi ) or m*n-1 < LargestMovedPointPerm( pi ) then
      Error( "<pi> must be a permutation on 1 .. ", m*n-1 );
    fi;

    numbers:= ListPerm( pi );
    Append( numbers, [ Length( numbers )+1 .. m*n ] );
    matrix:= List( [ 1 .. m ], i -> numbers{ [ n*(i-1)+1 .. n*i ] } );
    box:= [ m, n ];

    # Supported actions are
    # - moving the free position,
    # - entering the help mode,
    # - and leaving the table

    move:= function( t, y, x )
      local new, help1, help2;

      new:= box + [ y, x ];
      if 0 < new[1] and 0 < new[2] and new[1] <= m and new[2] <=n then
        help1:= t.work.mainFormatted[ 2 * box[1] ][ 2 * box[2] ];
        help2:= t.work.mainFormatted[ 2 * new[1] ][ 2 * new[2] ];
        t.work.mainFormatted[ 2 * box[1] ][ 2 * box[2] ]:= help2;
        t.work.mainFormatted[ 2 * new[1] ][ 2 * new[2] ]:= help1;

        help1:= matrix[ box[1] ][ box[2] ];
        help2:= matrix[ new[1] ][ new[2] ];
        matrix[ box[1] ][ box[2] ]:= help2;
        matrix[ new[1] ][ new[2] ]:= help1;

        t.dynamic.Return.steps:= t.dynamic.Return.steps + 1;
        t.dynamic.Return.final:= t.dynamic.Return.final * ( help1, help2 );

        box:= new;
        t.dynamic.selectedEntry:= t.dynamic.selectedEntry + 2 * [ y, x ];
        t.dynamic.changed:= true;
      fi;
      return t.dynamic.changed;
    end;

    # Construct the mode.
    mode:= BrowseData.CreateMode( "puzzle", "select_entry", [
      # standard actions
      [ [ "E" ], BrowseData.actions.Error ],
      [ [ "q", [ [ 27 ], "<Esc>" ] ], BrowseData.actions.QuitMode ],
      [ [ "Q" ], BrowseData.actions.QuitTable ],
      [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
        BrowseData.actions.ShowHelp ],
      [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
      # moves via arrow keys
      [ [ [ [ NCurses.keys.RIGHT ], "arrow right" ] ], rec(
        helplines:= [ "move the free position one cell to the right" ],
        action:= t -> move( t, 0, 1 ) ) ],
      [ [ [ [ NCurses.keys.LEFT ], "arrow left" ] ], rec(
        helplines:= [ "move the free position one cell to the left" ],
        action:= t -> move( t, 0, -1 ) ) ],
      [ [ [ [ NCurses.keys.DOWN ], "arrow down" ] ], rec(
        helplines:= [ "move the free position one cell down" ],
        action:= t -> move( t, 1, 0 ) ) ],
      [ [ [ [ NCurses.keys.UP ], "arrow up" ] ], rec(
        helplines:= [ "move the free position one cell up" ],
        action:= t -> move( t, -1, 0 ) ) ],
      # moves via mouse actions
      [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
      [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
            "<Mouse1Down>" ],
          [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
            "<Mouse1Click>" ] ], rec(
        helplines:= [ "move the free position to the clicked cell" ],
        action:= function( t, data )
          local pos, diff, i;

          pos:= BrowseData.PositionInBrowseTable( t, data );
          if pos[1] = "main" and IsEvenInt( pos[2][1] )
                             and IsEvenInt( pos[2][2] ) then
            if   pos[2][1] = t.dynamic.selectedEntry[1] then
              diff:= pos[2][2] - t.dynamic.selectedEntry[2];
              for i in [ 1 .. AbsInt( diff / 2 ) ] do
                t.dynamic.changed:= move( t, 0, SignInt( diff ) );
              od;
            elif pos[2][2] = t.dynamic.selectedEntry[2] then
              diff:= pos[2][1] - t.dynamic.selectedEntry[1];
              for i in [ 1 .. AbsInt( diff / 2 ) ] do
                t.dynamic.changed:= move( t, SignInt( diff ), 0 );
              od;
            fi;
          fi;

          return t.dynamic.changed;
        end ) ],
    ] );

    # Construct the browse table.
    max:= Length( String( m * n - 1 ) );
    empty:= RepeatedString( " ", max + 2 );
    fmatrix:= [];
    for i in [ 1 .. m ] do
      fmatrix[ 2*i ]:= [];
      for j in [ 1 .. n ] do
        fmatrix[ 2*i ][ 2*j ]:= [ empty,
                                    [ NCurses.attrs.BOLD, true,
                                      Concatenation( " ",
                                          String( matrix[i][j], max ), " " ) ],
                                    empty ];
      od;
    od;

    table:= rec(
      work:= rec(
        align:= "ct",
        minyx:= [ 4 * m + 6, n * ( 3 + max ) + 1 ],
        header:= [ "",
                   [ NCurses.attrs.UNDERLINE, true, Concatenation(
                     String(m), " by ", String(n), " puzzle" ) ],
                   "" ],
        main:= [],
        m:= m,
        n:= n,
        mainFormatted:= fmatrix,
        sepRow:= "-",
        sepCol:= "|",
        footer:= function( t )
            if IsOne( t.dynamic.Return.final ) then
              return [ "", [ Concatenation( String( t.dynamic.Return.steps ),
                                            " steps " ),
                             NCurses.ColorAttr( "red", -1 ),
                             "(done)" ] ];
            else
              return [ "", Concatenation( String( t.dynamic.Return.steps ),
                                          " steps" ) ];
            fi;
          end,
        availableModes:= [ mode ],
        cacheEntries:= true,
        SpecialGrid:= BrowseData.SpecialGridLineDraw,
      ),
      dynamic:= rec(
        activeModes:= [ mode ],
        selectedEntry:= [ 2*m, 2*n ],
        Return:= rec( dim:= [ m, n ],
                      init:= pi,
                      final:= pi,
                      steps:= 0,
        ),
      ),
    );

    # Leave the marked cell empty.
    table.work.mainFormatted[ 2*m ][ 2*n ][2]:= empty;

    # Show the browse table, and return its return value.
    return NCurses.BrowseGeneric( table );
end );


#############################################################################
##
#V  BrowsePuzzleSolution
##
BindGlobal( "BrowsePuzzleSolution", rec(
  dim := [ 4, 4 ],
  init := ( 1, 7,15,12, 9, 6, 4, 2,13,10, 8,11, 3,14, 5),
  steps :=
    [259,259,259,260,260,260,258,261,261,261,259,260,258,260,259,261,258,258,
     261,259,259,260,258,260,260,259,261,261,258,260,258,261,261,259,259,260,
     258,261,259,260,260,260,258,258,258,261,259,260,258,261,259,259,260,258,
     258,261,261,259,259,261,258,260,260,260,259,261,261,258,261,259,260,260,
     260,258,258,261,261,261,259,260,260,260,258,261,261,261,259,260,260,258,
     260,259,261,261,261,258,260,260,260,259,261,261,258,260,260,259,261,261,
     258,261,259,260,260,260,258,261,261,259,260,260,258,261,261,261],
  ) );


#############################################################################
##
#E

