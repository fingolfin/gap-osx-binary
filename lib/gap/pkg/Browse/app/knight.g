#############################################################################
##
#W  knight.g              GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseChangeSides()
##
##  <#GAPDoc Label="Knight_section">
##  <Section Label="sec:knight">
##  <Heading>Changing Sides</Heading>
##  <Index Subkey="Changing Sides">game</Index>
##
##  We consider a <M>5</M> by <M>5</M> board of squares filled with two
##  types of stones, as follows.  The square in the middle is left empty.
##  <P/>
##  <Alt Only="LaTeX"><![CDATA[
##  \begin{center}
##  \begin{tabular}{|c|c|c|c|c|}
##  \hline
##  \rule[-6pt]{0pt}{18pt}$\times$&$\times$&$\times$&$\times$&$\times$\\
##  \hline
##  \rule[-6pt]{0pt}{18pt}$\circ$&$\times$&$\times$&$\times$&$\times$\\
##  \hline
##  \rule[-6pt]{0pt}{18pt}$\circ$&$\circ$&&$\times$&$\times$\\
##  \hline
##  \rule[-6pt]{0pt}{18pt}$\circ$&$\circ$&$\circ$&$\circ$&$\times$\\
##  \hline
##  \rule[-6pt]{0pt}{18pt}$\circ$&$\circ$&$\circ$&$\circ$&$\circ$\\
##  \hline
##  \end{tabular}
##  \end{center}
##  ]]></Alt>
##  <Alt Only="Text"><Verb>
##             ┌───┬───┬───┬───┬───┐
##             │ x │ x │ x │ x │ x │
##             ├───┼───┼───┼───┼───┤
##             │ o │ x │ x │ x │ x │
##             ├───┼───┼───┼───┼───┤
##             │ o │ o │   │ x │ x │
##             ├───┼───┼───┼───┼───┤
##             │ o │ o │ o │ o │ x │
##             ├───┼───┼───┼───┼───┤
##             │ o │ o │ o │ o │ o │
##             └───┴───┴───┴───┴───┘
##  </Verb></Alt>
##  
##  <Alt Only="HTML"> <![CDATA[
##  </p><table class="sudokuin">
##  <tr><td>X</td><td>X</td><td>X</td><td>X</td><td>X</td></tr>
##  <tr><td>O</td><td>X</td><td>X</td><td>X</td><td>X</td></tr>
##  <tr><td>O</td><td>O</td><td></td><td>X</td><td>X</td></tr>
##  <tr><td>O</td><td>O</td><td>O</td><td>O</td><td>X</td></tr>
##  <tr><td>O</td><td>O</td><td>O</td><td>O</td><td>O</td></tr>
##  </table><p>
##  ]]></Alt>
##  <P/>
##  The aim of the game is to exchange the two types of stones via a sequence
##  of single steps that move one stone to the empty position on the board.
##  Only those moves are allowed that increase or decrease one coordinate
##  by <M>2</M> and increase or decrease the other by <M>1</M>;
##  these are the allowed moves of the knight in chess.
##  <P/>
##  This game has been part of the MacTutor system <Cite Key="MacTutor"/>.
##
##  <ManSection>
##  <Func Name="BrowseChangeSides" Arg=""/>
##
##  <Description>
##  This function shows the game board in a window.
##  <P/>
##  Each move is encoded as a sequence of three arrow keys; there are
##  <M>24</M> admissible inputs.
##  <P/>
##  <Example><![CDATA[
##  gap> for entry in BrowseChangeSidesSolutions do
##  >      BrowseData.SetReplay( Concatenation( entry, "Q" ) );
##  >      BrowseChangeSides();
##  > od;
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##  <P/>
##  <E>Implementation remarks</E>:
##  The game board is implemented via a browse table,
##  without row and column labels,
##  with static header, dynamic footer, and individual <C>minyx</C> function.
##  Only one mode is needed,
##  and besides the standard actions for quitting the table, asking for help,
##  and saving the current window contents,
##  only moves via combinations of the four arrow keys are admissible.
##  <P/>
##  The separating lines are drawn using an individual <C>SpecialGrid</C>
##  function in the browse table.
##  <P/>
##  Some standard <Ref Func="NCurses.BrowseGeneric"/> functionality,
##  such as scrolling, selecting, and searching,
##  are not available in this application.
##  <P/>
##  The code can be found in the file <F>app/knight.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseChangeSides", function()
    local black, white, empty, m, n, upperhalf, emp, matrix, i, j,
          movefunction, moves, texts, actions, help, input, grid, mode,
          steps;

    # Construct the cell contents.
    black:= [ NCurses.attrs.BOLD, true, " x " ];
    white:= [ NCurses.attrs.BOLD, true, " o " ];
    empty:= "";

    # Fill the matrix of formatted entries.
    m:= 5;
    n:= 5;
    upperhalf:= Concatenation( List( [ 1 .. 5 ], j -> 2 * [ 1, j ] ),
                               List( [ 2 .. 5 ], j -> 2 * [ 2, j ] ),
                               List( [ 4 .. 5 ], j -> 2 * [ 3, j ] ),
                               List( [ 5 .. 5 ], j -> 2 * [ 4, j ] ) );
    emp:= [ 6, 6 ];
    matrix:= [];
    for i in [ 2, 4 .. 2*m ] do
      matrix[i]:= [];
      for j in [ 2, 4 .. 2*n ] do
        if [ i, j ] in upperhalf then
          matrix[i][j]:= black;
        else
          matrix[i][j]:= white;
        fi;
      od;
    od;
    matrix[ emp[1] ][ emp[2] ]:= empty;

    # Supported actions are
    # - moving the free position by a knight move,
    # - entering the help mode,
    # - and leaving the table

    movefunction:= function( twice, once )
      return function( t )
        local new;

        # Compute the coordinate changes.
        if twice mod 2 = 0 then
          new:= emp + 2 * [ 2 * twice - 6, once - 2 ];
        else
          new:= emp + 2 * [ once - 3, 2 * twice - 4 ];
        fi;

        if 0 < new[1] and 0 < new[2] and
           new[1] <= 2 * m and new[2] <= 2 * n then
          matrix[ emp[1] ][ emp[2] ]:= matrix[ new[1] ][ new[2] ];
          matrix[ new[1] ][ new[2] ]:= empty;

          steps:= steps + 1;
          emp:= new;
          t.dynamic.changed:= true;
        fi;
        return t.dynamic.changed;
      end;
    end;

    # Construct the mode.
    moves:= [ NCurses.keys.LEFT, NCurses.keys.UP,
              NCurses.keys.RIGHT, NCurses.keys.DOWN ];
    texts:= [ "<Left>", "<Up>", "<Right>", "<Down>" ];
    actions:= [];
    for i in [ 1 .. 4 ] do
      for j in [ 1 .. 4 ] do
        if i <> j and AbsInt( i - j ) <> 2 then
          help:= Concatenation( "move twice ", texts[i],
                                " and once ", texts[j] );
          for input in [ [ i, i, j ], [ i, j, i ], [ j, i, i ] ] do
            Add( actions, [ [ [ moves{ input },
              Concatenation( texts{ input } ) ] ],
              rec( helplines:= [ help ], action:= movefunction( i, j ) ) ] );
          od;
        fi;
      od;
    od;

    grid:= function( t, data )
      local tp, lt;

      tp:= data.topmargin + 3;
      lt:= data.leftmargin;
      NCurses.Grid( t.dynamic.window, tp, tp + 10, lt, lt + 20,
                    tp + [ 0, 2 .. 10 ], lt + [ 0, 4 .. 20 ] );
    end;

    mode:= BrowseData.CreateMode( "knight", "", Concatenation( [
      # standard actions
      [ [ "E" ], BrowseData.actions.Error ],
      [ [ "q", [ [ 27 ], "<Esc>" ] ], BrowseData.actions.QuitMode ],
      [ [ "Q" ], BrowseData.actions.QuitTable ],
      [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
        BrowseData.actions.ShowHelp ],
      [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ],
        BrowseData.actions.SaveWindow ] ],
      # moves via sequences of arrow keys
      actions ) );

    # Construct and show the browse table.
    steps:= 0;
    NCurses.BrowseGeneric( rec(
      work:= rec(
        align:= "ct",
        minyx:= [ 16, 21 ],
        header:= [ "",
                   [ NCurses.attrs.UNDERLINE, true, "Changing Sides" ],
                   "" ],
        main:= [],
        m:= m,
        n:= n,
        mainFormatted:= matrix,
        sepRow:= "-",
        sepCol:= "|",
        footer:= function( t )
            if emp = [ 6, 6 ] and
               ForAll( upperhalf, p -> matrix[ p[1] ][ p[2] ] = white ) then
              return [ "", [ Concatenation( String( steps ), " steps " ),
                             NCurses.ColorAttr( "red", -1 ),
                             "(done)" ] ];
            else
              return [ "", Concatenation( String( steps ), " steps" ) ];
            fi;
          end,
        availableModes:= [ mode ],
        cacheEntries:= true,
        SpecialGrid:= grid,
      ),
      dynamic:= rec(
        activeModes:= [ mode ],
      ),
    ) );
end );


#############################################################################
##
#V  BrowseChangeSidesSolutions
##
BindGlobal( "BrowseChangeSidesSolutions", [
    [259,259,260,258,258,260,259,261,261,258,258,261,258,260,260,259,259,261,
     258,261,261,258,260,260,259,259,261,259,259,261,258,260,260,259,260,260,
     258,258,261,259,261,261,258,258,260,259,259,260,258,258,260,259,261,261,
     259,261,261,258,258,260,259,259,260,258,258,260,259,261,261,258,258,261,
     259,260,260,258,260,260,259,259,261,259,259,261,258,260,260,258,261,261,
     259,259,261,258,260,260,258,258,261,259,261,261,258,258,260,259,259,260],
    [259,259,260,258,258,260,259,261,261,258,258,261,258,260,260,259,259,261,
     258,261,261,258,260,260,259,259,261,259,259,261,258,260,260,259,260,260,
     258,258,261,259,261,261,258,258,260,259,261,261,258,258,260,259,259,260,
     259,261,261,258,258,260,259,259,260,258,258,260,259,261,261,258,258,261,
     259,260,260,258,260,260,259,259,261,259,259,261,258,260,260,258,261,261,
     259,259,261,258,258,261,258,260,260,259,259,260,258,258,260,261,261,259],
    [259,261,261,258,258,260,259,259,260,258,260,260,258,258,261,259,259,261,
     258,261,261,258,260,260,259,259,261,259,259,261,258,260,260,259,260,260,
     258,258,261,259,261,261,258,258,260,259,261,261,258,258,260,259,259,260,
     259,259,260,258,258,260,259,261,261,258,258,260,259,261,261,258,258,261,
     259,260,260,258,260,260,259,259,261,259,259,261,258,260,260,258,261,261,
     259,259,261,258,258,261,258,260,260,259,259,260,258,258,260,261,261,259],
  ] );


#############################################################################
##
#E

