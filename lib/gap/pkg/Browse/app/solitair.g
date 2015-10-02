#############################################################################
##
#W  solitair.g            GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  PegSolitaire( [<format>][<nrholes>][<twoModes>] )
##
##  <#GAPDoc Label="Solitaire_section">
##  <Section Label="sec:solitaire">
##  <Heading>Peg Solitaire</Heading>
##  <Index Subkey="Peg Solitaire">game</Index>
##
##  <Index>solitaire game</Index>
##  Peg solitaire is a board game for one player.
##  The game board consists of several holes some of which contain pegs.
##  In each step of the game, one peg is moved horizontally or vertically
##  to an empty hole at distance two, by jumping over a neighboring peg
##  which is then removed from the board.
##
##  <Alt Only="LaTeX">
##  <!-- BP solitair -->
##  <![CDATA[
##  \begin{center}
##  \begin{tabular}{ccccccc}
##  \cline{3-5}
##     &   & \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c|}{$\circ$} &   &   \\
##  \cline{3-5}
##     &   & \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c|}{$\circ$} &   &   \\
##  \hline
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c|}{$\circ$} \\
##  \hline
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{ } &
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c|}{$\circ$} \\
##  \hline
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c|}{$\circ$} \\
##  \hline
##     &   & \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c|}{$\circ$} &   &   \\
##  \cline{3-5}
##     &   & \multicolumn{1}{|c}{$\circ$} & \multicolumn{1}{|c}{$\circ$} &
##  \multicolumn{1}{|c|}{$\circ$} &   &   \\
##  \cline{3-5}
##  \end{tabular}
##  \end{center}
##  ]]>
##  <!-- EP -->
##  </Alt>
##  <Alt Only="HTML">
##  <![CDATA[
##  </p><div style="text-align:center;">
##  <img src="solitair.png" alt="[solitaire image]"/>
##  </div><p>
##  ]]>
##  </Alt>
##  <Alt Only="Text">
##  <Verb>
##                ┌───┬───┬───┐
##                │ o │ o │ o │
##                ├───┼───┼───┤
##                │ o │ o │ o │
##        ┌───┬───┼───┼───┼───┼───┬───┐
##        │ o │ o │ o │ o │ o │ o │ o │
##        ├───┼───┼───┼───┼───┼───┼───┤
##        │ o │ o │ o │   │ o │ o │ o │
##        ├───┼───┼───┼───┼───┼───┼───┤
##        │ o │ o │ o │ o │ o │ o │ o │
##        └───┴───┼───┼───┼───┼───┴───┘
##                │ o │ o │ o │
##                ├───┼───┼───┤
##                │ o │ o │ o │
##                └───┴───┴───┘
##  </Verb>
##  </Alt>
##
##  We consider the game that in the beginning, exactly one hole is empty,
##  and in the end, exactly one peg is left.
##
##  <ManSection>
##  <Func Name="PegSolitaire" Arg="[format][nrholes][twoModes]"/>
##
##  <Description>
##  This function shows the game board in a window.
##  <P/>
##  If the argument <A>format</A> is one of the strings <C>"small"</C> or
##  <C>"large"</C> then small or large pegs are shown,
##  the default is <C>"small"</C>.
##  <P/>
##  Three shapes of the game board are supported,
##  with <M>33</M>, <M>37</M>, and <M>45</M> holes, respectively;
##  this number can be specified via the argument <A>nrholes</A>,
##  the default is <M>33</M>.
##  In the cases of <M>33</M> and <M>45</M> holes,
##  the position of both the initial hole and the destination of the final
##  peg is the middle cell,
##  whereas in the case of <M>37</M> holes,
##  the initial hole is in the top left position and the final peg has to be
##  placed in the bottom right position.
##  <P/>
##  If a Boolean <A>twoModes</A> is entered as an argument
##  then it determines whether a browse table with one or two modes is used;
##  the default <K>false</K> yields a browse table with only one mode.
##  <P/>
##  In any case, one cell of the board is selected, and the selection can be
##  moved to neighboring cells via the arrow keys.
##  A peg in the selected cell jumps over a neighboring peg to an adjacent
##  hole via the <C>j</C> key followed by the appropriate arrow key.
##  <P/>
##  <Example><![CDATA[
##  gap> for n in [ 33, 37, 45 ] do
##  >      BrowseData.SetReplay( Concatenation(
##  >          PegSolitaireSolutions.( String( n ) ), "Q" ) );
##  >      PegSolitaire( n );
##  >      PegSolitaire( "large", n );
##  >      PegSolitaire( n, true );
##  >      PegSolitaire( "large", n, true );
##  > od;
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  <P/>
##  For more information such as variations of the game and references,
##  see&nbsp;<Cite Key="PegSolitaireWeb"/>.
##  Also the solutions stored in the variable <C>PegSolitaireSolutions</C>
##  have been taken from this web page.
##  <P/>
##  <E>Implementation remarks</E>:
##  The game board is implemented via a browse table,
##  without row and column labels,
##  with static header, dynamic footer, and individual <C>minyx</C> function.
##  In fact, two implementations are provided.
##  The first one needs only one mode in which one cell is selected;
##  moving the selection and jumping with the peg in the selected cell
##  in one of the four directions are the supported user actions.
##  The second implementation needs two modes,
##  one for moving the selection and one for jumping.
##  <P/>
##  Some standard <Ref Func="NCurses.BrowseGeneric"/> functionality,
##  such as scrolling, selecting, and searching,
##  are not available in this application.
##  <P/>
##  The code can be found in the file <F>app/solitair.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "PegSolitaire", function( arg )
    local format, nrholes, two_modes, i, admissible, rows, emptypos, pegs,
          stone, empty, sepRow, sepCol, minyx, matrix, j, move, select_move,
          select_jump, footer, jump, modes, table;

    # Get and check the arguments.
    format:= "small";
    nrholes:= 33;
    two_modes:= false;
    for i in [ 1 .. Length( arg ) ] do
      if   IsString( arg[i] ) and arg[i] in [ "small", "large" ] then
        format:= arg[i];
      elif IsBool( arg[i] ) then
        two_modes:= ( arg[i] = true );
      elif arg[i] in [ 33, 37, 45 ] then
        nrholes:= arg[i];
      else
        Error( "usage: PegSolitaire( [<format>][<nrholes>][<twoModes>] )" );
      fi;
    od;

    # Construct the list of holes on the board.
    admissible:= [];
    if   nrholes = 33 then
      rows:= 7;
      for i in [ 1, 2, 6, 7 ] do
        Append( admissible, List( [ 3 .. 5 ], j -> 2 * [ i, j ] ) );
      od;
      for i in [ 3 .. 5 ] do
        Append( admissible, List( [ 1 .. 7 ], j -> 2 * [ i, j ] ) );
      od;
      emptypos:= 2 * [ 4, 4 ];
    elif nrholes = 37 then
      rows:= 7;
      for i in [ 1, 7 ] do
        Append( admissible, List( [ 3 .. 5 ], j -> 2 * [ i, j ] ) );
      od;
      for i in [ 2, 6 ] do
        Append( admissible, List( [ 2 .. 6 ], j -> 2 * [ i, j ] ) );
      od;
      for i in [ 3 .. 5 ] do
        Append( admissible, List( [ 1 .. 7 ], j -> 2 * [ i, j ] ) );
      od;
      emptypos:= 2 * [ 1, 3 ];
    elif nrholes = 45 then
      rows:= 9;
      for i in [ 1, 2, 3, 7, 8, 9 ] do
        Append( admissible, List( [ 4 .. 6 ], j -> 2 * [ i, j ] ) );
      od;
      for i in [ 4 .. 6 ] do
        Append( admissible, List( [ 1 .. 9 ], j -> 2 * [ i, j ] ) );
      od;
      emptypos:= 2 * [ 5, 5 ];
    fi;
    pegs:= nrholes - 1;

    # Construct the cell contents, depending on the format.
    if format = "small" then
      stone:= [ NCurses.attrs.BOLD, true, "<>" ];
      empty:= [ NCurses.attrs.NORMAL, true, "<>" ];
      sepRow:= "";
      sepCol:= "";
      minyx:= [ rows + 5, 2 * rows + 2 ];
    else
      stone:= [ [ NCurses.attrs.BOLD, true, "//\\\\" ],
                [ NCurses.attrs.BOLD, true, "\\\\//" ] ];
      empty:= [ [ NCurses.attrs.NORMAL, true, "//\\\\" ],
                [ NCurses.attrs.NORMAL, true, "\\\\//" ] ];
      sepRow:= " ";
      sepCol:= "  ";
      minyx:= [ 3 * rows + 6, 6 * rows + 2 ];
    fi;

    # Fill the matrix of formatted entries.
    matrix:= [];
    for i in [ 2, 4 .. 2*rows ] do
      matrix[i]:= [];
      for j in [ 2, 4 .. 2*rows ] do
        if [ i, j ] in admissible then
          matrix[i][j]:= stone;
        else
          matrix[i][j]:= "";
        fi;
      od;
    od;
    matrix[ emptypos[1] ][ emptypos[2] ]:= empty;

    # Supported actions are
    # - entering the help mode,
    # - moving of the selection by one cell,
    # - jumping of a selected peg over a peg to a hole,
    # - and leaving the table.

    # Check whether the desired move would lead outside the admissible area.
    move:= function( t, x, y )
      return t.dynamic.selectedEntry + [ y, x ] in admissible;
    end;

    # Differences bewteen the two implementations:
    if two_modes then
      select_move:= BrowseData.defaults.work.startSelect;
      select_jump:= NCurses.ConcatenationAttributeLines( [ select_move,
                        [ NCurses.ColorAttr( "red", -1 ) ] ] );
      footer:= rec(
        move:= function( t )
          if pegs = 1 then
            return [ "", "move mode",
              [ "1 peg left ", NCurses.ColorAttr( "red", -1 ), "(done)" ] ];
          else
            return [ "", "move mode",
              Concatenation( String( pegs ), " pegs left" ) ];
          fi;
          end,
        jump:= function( t )
          if pegs = 1 then
            return [ "", [ NCurses.ColorAttr( "red", -1 ), "jump mode" ],
              [ "1 peg left", NCurses.ColorAttr( "red", -1 ), "(done)" ] ];
          else
            return [ "", [ NCurses.ColorAttr( "red", -1 ), "jump mode" ],
              Concatenation( String( pegs ), " pegs left" ) ];
          fi;
          end,
        );
    else
      footer:= function( t )
        if pegs = 1 then
          return [ "", [ "1 peg left ", NCurses.ColorAttr( "red", -1 ),
                         "(done)" ] ];
        else
          return [ "", Concatenation( String( pegs ), " pegs left" ) ];
        fi;
      end;
    fi;

    # One can jump if the next cell contains a peg and the next but one not.
    jump:= function( t, x, y )
      local old, new, new2;

      old:= t.dynamic.selectedEntry;
      new:= old + [ y, x ];
      new2:= new + [ y, x ];
      if new2 in admissible and
         matrix[ old[1] ][ old[2] ] = stone and
         matrix[ new[1] ][ new[2] ] = stone and
         matrix[ new2[1] ][ new2[2] ] = empty then
        matrix[ old[1] ][ old[2] ]:= empty;
        matrix[ new[1] ][ new[2] ]:= empty;
        matrix[ new2[1] ][ new2[2] ]:= stone;
        pegs:= pegs - 1;
        t.dynamic.selectedEntry:= new2;
      fi;
      if two_modes then
        # Switch back to the move mode.
        t.work.startSelect:= select_move;
        BrowseData.actions.QuitMode.action( t );
      fi;
      # Force redraw also if the jump is not possible.
      t.dynamic.changed:= true;

      return true;
    end;

    # Construct the mode(s).
    modes:= [ BrowseData.CreateMode( "move", "select_entry", [
      # standard actions
      [ [ "E" ], BrowseData.actions.Error ],
      [ [ "q", [ [ 27 ], "<Esc>" ] ], BrowseData.actions.QuitMode ],
      [ [ "Q" ], BrowseData.actions.QuitTable ],
      [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
        BrowseData.actions.ShowHelp ],
      [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
      # move via arrow keys
      [ [ [ [ NCurses.keys.RIGHT ], "arrow right" ] ], rec(
        helplines:= [ "move the selection one cell to the right" ],
        action:= t -> move( t, 2, 0 )
            and BrowseData.actions.ScrollSelectedCellRight.action( t ) ) ],
      [ [ [ [ NCurses.keys.LEFT ], "arrow left" ] ], rec(
        helplines:= [ "move the selection one cell to the left" ],
        action:= t -> move( t, -2, 0 )
            and BrowseData.actions.ScrollSelectedCellLeft.action( t ) ) ],
      [ [ [ [ NCurses.keys.DOWN ], "arrow down" ] ], rec(
        helplines:= [ "move the selection one cell down" ],
        action:= t -> move( t, 0, 2 )
            and BrowseData.actions.ScrollSelectedCellDown.action( t ) ) ],
      [ [ [ [ NCurses.keys.UP ], "arrow up" ] ], rec(
        helplines:= [ "move the selection one cell up" ],
        action:= t -> move( t, 0, -2 )
            and BrowseData.actions.ScrollSelectedCellUp.action( t ) ) ],
    ] ) ];

    if two_modes then
      BrowseData.SetActions( modes[1], [
        # switch to jump mode
        [ [ "j" ], rec(
          helplines:= [ "switch to jump mode" ],
          action:= function( t )
                     t.work.startSelect:= select_jump;
                     t.dynamic.changed:= true;
                     return BrowseData.PushMode( t, "jump" );
                     return true;
                   end ) ],
        ] );
      modes[2]:= BrowseData.CreateMode( "jump", "select_entry", [
        # standard actions
        [ [ "E" ], BrowseData.actions.Error ],
        [ [ "q", [ [ 27 ], "<Esc>" ] ], rec(
          helplines:= [ "return to move mode" ],
          action:= function( t )
                     t.work.startSelect:= select_move;
                     return BrowseData.actions.QuitMode.action( t );
                   end ) ],
        [ [ "Q" ], BrowseData.actions.QuitTable ],
        [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
          BrowseData.actions.ShowHelp ],
        [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ],
          BrowseData.actions.SaveWindow ],
        # jumps via arrow keys
        [ [ [ [ NCurses.keys.RIGHT ], "arrow right" ] ], rec(
          helplines:= [ "jump to the right" ],
          action:= t -> jump( t, 2, 0 ) ) ],
        [ [ [ [ NCurses.keys.LEFT ], "arrow left" ] ], rec(
          helplines:= [ "jump to the left" ],
          action:= t -> jump( t, -2, 0 ) ) ],
        [ [ [ [ NCurses.keys.DOWN ], "arrow down" ] ], rec(
          helplines:= [ "jump down" ],
          action:= t -> jump( t, 0, 2 ) ) ],
        [ [ [ [ NCurses.keys.UP ], "arrow up" ] ], rec(
          helplines:= [ "jump up" ],
          action:= t -> jump( t, 0, -2 ) ) ],
        ] );
    else
      BrowseData.SetActions( modes[1], [
        # jump via `j' plus arrow keys
        [ [ [ [ IntChar( 'j' ), NCurses.keys.RIGHT ], "j + arrow right" ] ],
          rec(
          helplines:= [ "jump over a peg to a hole two cells to the right" ],
          action:= t -> jump( t, 2, 0 ) ) ],
        [ [ [ [ IntChar( 'j' ), NCurses.keys.LEFT ], "j + arrow left" ] ],
          rec(
          helplines:= [ "jump over a peg to a hole two cells to the left" ],
          action:= t -> jump( t, -2, 0 ) ) ],
        [ [ [ [ IntChar( 'j' ), NCurses.keys.DOWN ], "j + arrow down" ] ],
          rec(
          helplines:= [ "jump over a peg to a hole two cells down" ],
          action:= t -> jump( t, 0, 2 ) ) ],
        [ [ [ [ IntChar( 'j' ), NCurses.keys.UP ], "j + arrow up" ] ], rec(
          helplines:= [ "jump over a peg to a hole two cells up" ],
          action:= t -> jump( t, 0, -2 ) ) ],
        ] );
    fi;

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "ct",
        minyx:= minyx,
        header:= [ "", [ NCurses.attrs.UNDERLINE, true, "Solitaire" ], "" ],
        main:= [],
        mainFormatted:= matrix,
        m:= rows,
        n:= rows,
        sepRow:= sepRow,
        sepCol:= sepCol,
        footer:= footer,
        availableModes:= modes,
      ),
      dynamic:= rec(
        activeModes:= [ modes[1] ],
        selectedEntry:= emptypos,
      ),
    );

    # Show the browse table.
    NCurses.BrowseGeneric( table );
end );


#############################################################################
##
#V  PegSolitaireSolutions
##
##  This is a record with the components `33', `37', and `45',
##  which describe solutions of the `PegSolitaire' game with the respective
##  number of holes.
##
BindGlobal( "PegSolitaireSolutions", rec(
  33:=  # solution by E. Bergholt
   [260,260,106,261,258,258,260,106,259,258,260,260,106,261,261,106,260,261,
    261,261,261,106,260,258,258,261,106,259,259,106,258,258,260,260,106,261,
    106,259,260,260,259,259,106,258,259,259,259,259,106,258,261,261,259,106,
    258,106,258,106,260,106,259,106,259,258,260,260,106,258,106,261,106,261,
    259,259,261,261,106,260,260,106,261,258,258,261,106,259,106,260,259,259,
    106,260,106,258,260,106,261,106,261,106,258,106,260,106,259,259,106,258],
  37:=
   [114,261,261,106,260,258,258,261,106,259,258,261,261,106,260,259,106,258,
    258,106,259,258,258,258,258,106,259,258,258,260,260,106,261,258,106,259,
    259,259,259,260,106,261,258,258,260,260,106,259,258,258,261,261,106,260,
    258,258,261,261,106,259,259,259,259,260,260,106,258,258,106,259,260,106,
    261,261,106,260,258,258,261,261,106,259,258,260,260,260,260,106,261,258,
    260,260,106,261,259,261,261,261,261,106,260,258,261,261,106,260,258,261,
    261,106,260,259,260,260,106,258,259,259,259,259,106,258,258,258,258,106,
    259,259,106,258,261,261,259,259,106,258,259,259,259,259,106,258,258,258,
    258,106,259,259,106,258,261,106,260,259,260,260,260,106,261,106,258,259,
    259,261,106,258,260,106,261],
  45:=  # solution by George Bell
   [261,261,106,260,259,259,261,106,258,259,261,261,106,260,258,258,261,261,
    106,259,261,106,260,258,258,261,261,106,259,260,260,260,106,261,261,106,
    260,258,260,260,106,261,258,260,106,261,259,259,260,106,258,261,106,260,
    259,259,260,260,106,261,259,259,260,260,106,258,259,261,259,261,106,260,
    259,106,258,259,261,259,261,106,260,258,258,258,106,259,259,106,258,106,
    261,106,258,260,260,260,260,259,106,261,260,258,260,258,106,259,260,106,
    261,258,260,258,260,106,259,261,261,261,106,260,260,106,261,258,261,258,
    106,260,261,261,258,258,106,259,258,258,261,261,106,260,258,106,259,258,
    261,258,261,106,260,259,259,259,106,258,258,106,259,259,260,259,259,106,
    258,260,106,261,258,261,106,259,106,260,261,258,258,106,259,260,106,261,
    106,261,260,258,258,106,259,261,106,260],
  ) );


#############################################################################
##
#E

