#############################################################################
##
#W  rubik.g               GAP 4 package `browse'                Thomas Breuer
##
#Y  Copyright (C)  2006,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##


#############################################################################
##
#F  BrowseRubiksCube( [<format>][<pi>] )
#F  BrowseRubiksCube( <output> )
##
##  <#GAPDoc Label="Rubik_section">
##  <Section Label="sec:rubikscube">
##  <Heading>Rubik's Cube</Heading>
##  <Index Subkey="Rubik's Cube">game</Index>
##
##  We visualize the transformations of Rubik's magic cube in a model that is
##  given by <Q>unfolding</Q> the faces and numbering them as follows.
##
##  <Alt Only="LaTeX">
##  <!-- BP rubik -->
##  <![CDATA[
##  \begin{center}
##  \begin{tabular}{cccccccccccc}
##  \cline{4-6}
##   & & & \multicolumn{1}{|c}{1} & \multicolumn{1}{c}{2} &
##  \multicolumn{1}{c|}{3} & & & & & & \\
##   & & & \multicolumn{1}{|c}{4} & \multicolumn{1}{c}{top} &
##  \multicolumn{1}{c|}{5} & & & & & & \\
##   & & & \multicolumn{1}{|c}{6} & \multicolumn{1}{c}{7} &
##  \multicolumn{1}{c|}{8} & & & & & & \\
##  \hline
##  \multicolumn{1}{|c}{9} & \multicolumn{1}{c}{10} &
##  \multicolumn{1}{c}{11} & \multicolumn{1}{|c}{17} &
##  \multicolumn{1}{c}{18} & \multicolumn{1}{c}{19} &
##  \multicolumn{1}{|c}{25} & \multicolumn{1}{c}{26} &
##  \multicolumn{1}{c}{27} & \multicolumn{1}{|c}{33} &
##  \multicolumn{1}{c}{34} & \multicolumn{1}{c|}{35} \\
##  \multicolumn{1}{|c}{12} & \multicolumn{1}{c}{left} &
##  \multicolumn{1}{c}{13} & \multicolumn{1}{|c}{20} &
##  \multicolumn{1}{c}{front} & \multicolumn{1}{c}{21} &
##  \multicolumn{1}{|c}{28} & \multicolumn{1}{c}{right} &
##  \multicolumn{1}{c}{29} & \multicolumn{1}{|c}{36} &
##  \multicolumn{1}{c}{back} & \multicolumn{1}{c|}{37} \\
##  \multicolumn{1}{|c}{14} & \multicolumn{1}{c}{15} &
##  \multicolumn{1}{c}{16} & \multicolumn{1}{|c}{22} &
##  \multicolumn{1}{c}{23} & \multicolumn{1}{c}{24} &
##  \multicolumn{1}{|c}{30} & \multicolumn{1}{c}{31} &
##  \multicolumn{1}{c}{32} & \multicolumn{1}{|c}{38} &
##  \multicolumn{1}{c}{39} & \multicolumn{1}{c|}{40} \\
##  \hline
##   & & & \multicolumn{1}{|c}{41} & \multicolumn{1}{c}{42} &
##  \multicolumn{1}{c|}{43} & & & & & & \\
##   & & & \multicolumn{1}{|c}{44} & \multicolumn{1}{c}{down} &
##  \multicolumn{1}{c|}{45} & & & & & & \\
##   & & & \multicolumn{1}{|c}{46} & \multicolumn{1}{c}{47} &
##  \multicolumn{1}{c|}{48} & & & & & & \\
##  \cline{4-6}
##  \end{tabular}
##  \end{center}
##  ]]>
##  <!-- EP -->
##  </Alt>
##  <Alt Only="HTML">
##  <![CDATA[
##  </p><div style="text-align:center;">
##  <img src="rubik.png" alt="[unfolded Rubik's cube image]"/>
##  </div><p>
##  ]]>
##  </Alt>
##  <Alt Only="Text">
##  <Verb>
##                     ┌──────────────┐
##                     │  1    2    3 │
##                     │  4   top   5 │
##                     │  6    7    8 │
##      ┌──────────────┼──────────────┼──────────────┬──────────────┐
##      │  9   10   11 │ 17   18   19 │ 25   26   27 │ 33   34   35 │
##      │ 12  left  13 │ 20 front  21 │ 28 right  29 │ 36  back  37 │
##      │ 14   15   16 │ 22   23   24 │ 30   31   32 │ 38   39   40 │
##      └──────────────┼──────────────┼──────────────┴──────────────┘
##                     │ 41   42   43 │
##                     │ 44  down  45 │
##                     │ 46   47   48 │
##                     └──────────────┘
##  </Verb>
##  </Alt>
##
##  Clockwise turns of the six layers (top, left, front, right, back, and
##  down) are represented by the following permutations.
##  <P/>
##  <Example><![CDATA[
##  gap> cubegens := [
##  >   ( 1, 3, 8, 6)( 2, 5, 7, 4)( 9,33,25,17)(10,34,26,18)(11,35,27,19),
##  >   ( 9,11,16,14)(10,13,15,12)( 1,17,41,40)( 4,20,44,37)( 6,22,46,35),
##  >   (17,19,24,22)(18,21,23,20)( 6,25,43,16)( 7,28,42,13)( 8,30,41,11),
##  >   (25,27,32,30)(26,29,31,28)( 3,38,43,19)( 5,36,45,21)( 8,33,48,24),
##  >   (33,35,40,38)(34,37,39,36)( 3, 9,46,32)( 2,12,47,29)( 1,14,48,27),
##  >   (41,43,48,46)(42,45,47,44)(14,22,30,38)(15,23,31,39)(16,24,32,40)
##  > ];;
##  ]]></Example>
##
##  &GAP; computations analyzing this permutation group have been part of
##  the announcements of &GAP;&nbsp;3 releases.
##  For a &GAP;&nbsp;4 equivalent, see&nbsp;<Cite Key="RubiksCubeGAPWeb"/>.
##  For more information and references (not &GAP; related)
##  about Rubik's cube, see&nbsp;<Cite Key="RubiksCubeWeb"/>.
##
##  <ManSection>
##  <Func Name="BrowseRubiksCube" Arg="[format][pi]"/>
##
##  <Description>
##  This function shows the model of the cube in a window.
##  <P/>
##  If the argument <A>format</A> is one of the strings <C>"small"</C> or
##  <C>"large"</C> then small or large cells are shown,
##  the default is <C>"small"</C>.
##  <P/>
##  The argument <A>pi</A> is the initial permutation of the faces,
##  the default is a random permutation in the cube group,
##  see&nbsp;<Ref Sect="Random" BookName="ref"/>.
##  <P/>
##  Supported user inputs are the keys <B>t</B>, <B>l</B>, <B>f</B>,
##  <B>r</B>, <B>b</B>, and <B>d</B> for clockwise turns of the six layers,
##  and the corresponding capital letters for counter-clockwise turns.
##  If the terminal supports colors, according to the global variable
##  <Ref Var="NCurses.attrs.has_colors"/>, the input <B>s</B> switches
##  between a screen that shows only the colors of the faces and a screen
##  that shows the numbers; the color screen is the default.
##  <P/>
##  The return value is a record with the components
##  <C>inputs</C> (a string describing the user inputs),
##  <C>init</C>, and <C>final</C> (the initial and final permutation of the
##  faces, respectively).
##  (The <C>inputs</C> component can be used for the replay feature,
##  see the example below.)
##  <P/>
##  In the following example, a word in terms of the generators is used to
##  initialize the browse table, and then the letters in this word are used
##  as a series of input steps, except that in between, the display is
##  switched once from colors to numbers and back.
##  <P/>
##  <Example><![CDATA[
##  gap> choice:= List( [ 1 .. 30 ], i -> Random( [ 1 .. 6 ] ) );;
##  gap> input:= List( "tlfrbd", IntChar ){ choice };;
##  gap> BrowseData.SetReplay( Concatenation(
##  >        input{ [ 1 .. 20 ] },
##  >        "s",                    # switch to number display
##  >        input{ [ 21 .. 25 ] },
##  >        "s",                    # switch to color display
##  >        input{ [ 26 .. 30 ] },
##  >        "Q" ) );;               # quit the browse table
##  gap> BrowseRubiksCube( Product( cubegens{ choice } ) );;
##  gap> BrowseRubiksCube( "large", Product( cubegens{ choice } ) );;
##  gap> BrowseData.SetReplay( false );
##  ]]></Example>
##
##  <E>Implementation remarks</E>:
##  The cube is implemented via a browse table,
##  without row and column labels,
##  with static header, dynamic footer, and individual <C>minyx</C> function.
##  Only one mode is needed,
##  and besides the standard actions for quitting the table, asking for help,
##  and saving the current window contents,
##  only the twelve moves and the switch between color and number
##  display are admissible.
##  <P/>
##  Switching between the two display formats is implemented via a function
##  <C>work.Main</C>,
##  so this relies on <E>not</E> caching the formatted cells in
##  <C>work.main</C>.
##  <P/>
##  Row and column separators of the browse table are whitespace of height
##  and width one.
##  The separating lines are drawn using an individual <C>SpecialGrid</C>
##  function in the browse table.
##  Note that the relevant cells do not form a rectangular array.
##  <P/>
##  Some standard <Ref Func="NCurses.BrowseGeneric"/> functionality,
##  such as scrolling, selecting, and searching,
##  are not available in this application.
##  <P/>
##  The code can be found in the file <F>app/rubik.g</F> of the package.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>
##
BindGlobal( "BrowseRubiksCube", function( arg )
    local gens, cube, format, i, pi, showcolors, coord, minyx, numbers,
          col, colors, grid, turn, mode, table;

    # Write down the permutations and the group.
    gens:= [
      ( 1, 3, 8, 6)( 2, 5, 7, 4)( 9,33,25,17)(10,34,26,18)(11,35,27,19), # t
      ( 9,11,16,14)(10,13,15,12)( 1,17,41,40)( 4,20,44,37)( 6,22,46,35), # l
      (17,19,24,22)(18,21,23,20)( 6,25,43,16)( 7,28,42,13)( 8,30,41,11), # f
      (25,27,32,30)(26,29,31,28)( 3,38,43,19)( 5,36,45,21)( 8,33,48,24), # r
      (33,35,40,38)(34,37,39,36)( 3, 9,46,32)( 2,12,47,29)( 1,14,48,27), # b
      (41,43,48,46)(42,45,47,44)(14,22,30,38)(15,23,31,39)(16,24,32,40), # d
     ];
    cube:= GroupWithGenerators( gens );

    # Get and check the arguments.
    format:= "small";
    for i in [ 1 .. Length( arg ) ] do
      if   IsPerm( arg[i] ) then
        pi:= arg[i];
      elif IsString( arg[i] ) and arg[i] in [ "small", "large" ] then
        format:= arg[i];
      else
        Error( "usage: BrowseRubiksCube( [<format>][<pi>] )" );
      fi;
    od;
    if   not IsBound( pi ) then
      pi:= Random( cube );
    elif not IsPerm( pi ) or not pi in cube then
      Error( "<pi> must be a permutation in <cube>" );
    fi;

    showcolors:= NCurses.attrs.has_colors;

    coord:= [ [1, 4],[1, 5],[1, 6],[2, 4],[2, 6],[3, 4],[3, 5],[3, 6],  # t
              [4, 1],[4, 2],[4, 3],[5, 1],[5, 3],[6, 1],[6, 2],[6, 3],  # l
              [4, 4],[4, 5],[4, 6],[5, 4],[5, 6],[6, 4],[6, 5],[6, 6],  # f
              [4, 7],[4, 8],[4, 9],[5, 7],[5, 9],[6, 7],[6, 8],[6, 9],  # r
              [4,10],[4,11],[4,12],[5,10],[5,12],[6,10],[6,11],[6,12],  # b
              [7, 4],[7, 5],[7, 6],[8, 4],[8, 6],[9, 4],[9, 5],[9, 6],  # d
              [2, 5],[5, 2],[5, 5],[5, 8],[5,11],[8, 5],  # layer centers
            ];

    if format = "small" then
      minyx:= [ 25, 37 ];
      numbers:= List( [ 1 .. 48 ], i -> [ String( i, 2 ) ] );
      Append( numbers, List( [ " t", " l", " f", " r", " b", " d" ],
                         c -> [ NCurses.attrs.BOLD, true, c ] ) );
      col:= List( [ "red", "green", "yellow", "blue", "cyan", "white" ],
                  color -> [ NCurses.ColorAttr( "white", color ), true,
                             "  " ] );
    else
      minyx:= [ 43, 61 ];
      numbers:= List( [ 1 .. 48 ], i -> [ "    ",
                           Concatenation( String( i, 3 ), " " ),
                           "    " ] );
      Append( numbers,
              List( [ "  t ", "  l ", "  f ", "  r ", "  b ", "  d " ],
                    c -> [ "    ", [ NCurses.attrs.BOLD, true, c ],
                           "    " ] ) );
      col:= List( [ "red", "green", "yellow", "blue", "cyan", "white" ],
                  color -> ListWithIdenticalEntries( 3,
                   [ NCurses.ColorAttr( "white", color ), true, "    " ] ) );
    fi;
    colors:= Concatenation( List( col,
                                  c -> ListWithIdenticalEntries( 8, c ) ) );
    Append( colors, col );

    grid:= function( t, data )
      local ht, wt, win, tp, lt, i, j;

      ht:= Length( numbers[1] ) + 1;
      wt:= Length( numbers[1][1] ) + 1;
      win:= t.dynamic.window;
      tp:= data.topmargin + 3;
      lt:= data.leftmargin;
      NCurses.Grid( win, tp, tp + 3 * ht, lt + 3 * wt, lt + 6 * wt,
                         tp + [ 0 .. 3 ] * ht, lt + [ 3 .. 6 ] * wt );
      NCurses.Grid( win, tp + 3 * ht, tp + 6 * ht, lt, lt + 12 * wt,
                         tp + [ 3 .. 6 ] * ht, lt + [ 0 .. 12 ] * wt );
      NCurses.Grid( win, tp + 6 * ht, tp + 9 * ht, lt + 3 * wt, lt + 6 * wt,
                         tp + [ 6 .. 9 ] * ht, lt + [ 3 .. 6 ] * wt );
      for i in [ 3, 6 ] do
        for j in [ 3 .. 6 ] do
          NCurses.wmove( win, tp + i * ht, lt + j * wt );
          NCurses.waddch( win, NCurses.lineDraw.PLUS );
        od;
      od;
    end;

    # Supported actions are
    # - quarter turns via the six generators and their inverses
    # - switching between color and number display
    # - entering the help mode,
    # - and leaving the table

    turn:= function( t, gen, input, exp )
      pi:= gens[ gen ]^exp * pi;
      t.dynamic.Return.final:= pi;
      Add( t.dynamic.Return.input, input );
      t.dynamic.changed:= true;
      return t.dynamic.changed;
    end;

    # Construct the mode.
    mode:= BrowseData.CreateMode( "rubik", "", [
      # standard actions
      [ [ "E" ], BrowseData.actions.Error ],
      [ [ "q", [ [ 27 ], "<Esc>" ] ], BrowseData.actions.QuitMode ],
      [ [ "Q" ], BrowseData.actions.QuitTable ],
      [ [ "?", [ [ NCurses.keys.F1 ], "<F1>" ] ],
        BrowseData.actions.ShowHelp ],
      [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
      # moves via the keys tlfrbd and TLFRBD
      [ [ "t" ], rec( helplines:= [ "turn the top layer clockwise" ],
                  action:= t -> turn( t, 1, 't', -1 ) ) ],
      [ [ "l" ], rec( helplines:= [ "turn the left layer clockwise" ],
                  action:= t -> turn( t, 2, 'l', -1 ) ) ],
      [ [ "f" ], rec( helplines:= [ "turn the front layer clockwise" ],
                  action:= t -> turn( t, 3, 'f', -1 ) ) ],
      [ [ "r" ], rec( helplines:= [ "turn the right layer clockwise" ],
                  action:= t -> turn( t, 4, 'r', -1 ) ) ],
      [ [ "b" ], rec( helplines:= [ "turn the back layer clockwise" ],
                  action:= t -> turn( t, 5, 'b', -1 ) ) ],
      [ [ "d" ], rec( helplines:= [ "turn the down layer clockwise" ],
                  action:= t -> turn( t, 6, 'd', -1 ) ) ],
      [ [ "T" ], rec( helplines:= [ "turn the top layer counter-clockwise" ],
                  action:= t -> turn( t, 1, 'T', 1 ) ) ],
      [ [ "L" ], rec( helplines:= [ "turn the left layer counter-clockwise" ],
                  action:= t -> turn( t, 2, 'L', 1 ) ) ],
      [ [ "F" ], rec( helplines:= [ "turn the front layer counter-clockwise" ],
                  action:= t -> turn( t, 3, 'F', 1 ) ) ],
      [ [ "R" ], rec( helplines:= [ "turn the right layer counter-clockwise" ],
                  action:= t -> turn( t, 4, 'R', 1 ) ) ],
      [ [ "B" ], rec( helplines:= [ "turn the back layer counter-clockwise" ],
                  action:= t -> turn( t, 5, 'B', 1 ) ) ],
      [ [ "D" ], rec( helplines:= [ "turn the down layer counter-clockwise" ],
                  action:= t -> turn( t, 6, 'D', 1 ) ) ],
      # switch between color and number display
      [ [ "s" ], rec( helplines:= [ "switch between color and number display" ],
                  action:= function( t )
                    if NCurses.attrs.has_colors then
                      showcolors:= not showcolors;
                      t.dynamic.changed:= true;
                    else
                      BrowseData.AlertWithReplay( t,
                        "Your terminal does not support colors.",
                        NCurses.attrs.BOLD );
                    fi;
                  end ) ],
    ] );

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "ct",
        minyx:= minyx,
        header:= [ "", [ NCurses.attrs.UNDERLINE, true, "Rubik's cube" ],
                   "" ],
        main:= [],
        Main:= function( t, i, j )
          i:= Position( coord, [ i, j ] );
          if i = fail then
            return "";
          fi;
          i:= i ^ pi;
          if showcolors then
            return colors[i];
          else
            return numbers[i];
          fi;
        end,
        m:= 9,
        n:= 12,
        sepRow:= " ",
        sepCol:= " ",
        footer:= function( t )
            local stepsline, scr, inputline;

            if IsOne( t.dynamic.Return.final ) then
              stepsline:= [ Concatenation(
                  String( Length( t.dynamic.Return.input ) ), " steps " ),
                            NCurses.ColorAttr( "red", -1 ), "(done)" ];
            else
              stepsline:= Concatenation(
                  String( Length( t.dynamic.Return.input ) ), " steps" );
            fi;
            scr:= Sum( t.work.widthCol, 0 );
            if   Length( t.dynamic.Return.input ) = 0 then
              inputline:= "input: ";
            elif Length( t.dynamic.Return.input ) + 7 < scr then
              inputline:= Concatenation( "input: ", t.dynamic.Return.input );
            else
              inputline:= t.dynamic.Return.input;
              inputline:= inputline{ [ Length( inputline ) - scr + 10
                                       .. Length( inputline ) ] };
              inputline:= Concatenation( "input: ...", inputline );
            fi;
            return [ "", stepsline, inputline ];
          end,
        availableModes:= [ mode ],
        cacheEntries:= false,
        SpecialGrid:= grid,
      ),
      dynamic:= rec(
        activeModes:= [ mode ],
        Return:= rec( input:= "",
                      init:= pi,
                      final:= pi,
        ),
      ),
    );

    # Show the browse table, and return its return value.
    return NCurses.BrowseGeneric( table );
end );


#############################################################################
##
#E

