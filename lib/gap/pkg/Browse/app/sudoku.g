#############################################################################
##
#W  sudoku.g            GAP 4 package `browse'       Frank Lübeck/Thomas Breuer
##
#Y  Copyright (C) 2006-2007, Lehrstuhl D für Mathematik, RWTH Aachen, Germany
##
##  This file contains functions to generate and solve Sudoku puzzles. This
##  can be used by command line function or via a Browse table interface.
##

##  <#GAPDoc Label="Sudoku_section">
##  <Section Label="sec:sudoku">
##  <Heading>Sudoku</Heading>
##  <Index Subkey="Sudoku">game</Index>
##
##  We consider a <M>9</M> by <M>9</M> board of squares.
##  Some squares are initially filled with numbers from <M>1</M> to <M>9</M>.
##  The aim of the game is to fill the empty squares in such a way that
##  each row, each column, and each of the marked <M>3</M> by <M>3</M>
##  subsquares contains all numbers from <M>1</M> to <M>9</M>. A <E>proper
##  Sudoku game</E> is defined as one with a unique solution.
##  Here is an example.
##  <!--
##  s := "      5  | 154 6 2 |9   5 3  |6 4      |   8     |8  9   53\
##  |     5   | 4   7  2|  91  8  ";
##  -->
##  
##  
##  <Alt Only="Text">
##  <Verb>
##               ┏━━━┯━━━┯━━━┳━━━┯━━━┯━━━┳━━━┯━━━┯━━━┓
##               ┃   │   │   ┃   │   │   ┃ 5 │   │   ┃
##               ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##               ┃   │ 1 │ 5 ┃ 4 │   │ 6 ┃   │ 2 │   ┃
##               ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##               ┃ 9 │   │   ┃   │ 5 │   ┃ 3 │   │   ┃
##               ┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
##               ┃ 6 │   │ 4 ┃   │   │   ┃   │   │   ┃
##               ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##               ┃   │   │   ┃ 8 │   │   ┃   │   │   ┃
##               ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##               ┃ 8 │   │   ┃ 9 │   │   ┃   │ 5 │ 3 ┃
##               ┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
##               ┃   │   │   ┃   │   │ 5 ┃   │   │   ┃
##               ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##               ┃   │ 4 │   ┃   │   │ 7 ┃   │   │ 2 ┃
##               ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##               ┃   │   │ 9 ┃ 1 │   │   ┃ 8 │   │   ┃
##               ┗━━━┷━━━┷━━━┻━━━┷━━━┷━━━┻━━━┷━━━┷━━━┛
##  </Verb>
##  </Alt>
##  
##  <Alt Only="LaTeX">
##  <![CDATA[
##  
##  \begin{center}
##  \setlength{\unitlength}{1.8ex}
##  \begin{picture}(18,18)
##  \multiput(0,0)(2,0){10}{\line(0,1){18}}
##  \multiput(0,0)(0,2){10}{\line(1,0){18}}
##  \linethickness{0.3ex}
##  \multiput(0,0)(6,0){4}{\line(0,1){18}}
##  \multiput(0,0)(0,6){4}{\line(1,0){18}}
##  \put(13,17){\makebox(0,0){$5$}}
##  \put( 3,15){\makebox(0,0){$1$}}
##  \put( 5,15){\makebox(0,0){$5$}}
##  \put( 7,15){\makebox(0,0){$4$}}
##  \put(11,15){\makebox(0,0){$6$}}
##  \put(15,15){\makebox(0,0){$2$}}
##  \put( 1,13){\makebox(0,0){$9$}}
##  \put( 9,13){\makebox(0,0){$5$}}
##  \put(13,13){\makebox(0,0){$3$}}
##  \put( 1,11){\makebox(0,0){$6$}}
##  \put( 5,11){\makebox(0,0){$4$}}
##  \put( 7, 9){\makebox(0,0){$8$}}
##  \put( 1, 7){\makebox(0,0){$8$}}
##  \put( 7, 7){\makebox(0,0){$9$}}
##  \put(15, 7){\makebox(0,0){$5$}}
##  \put(17, 7){\makebox(0,0){$3$}}
##  \put(11, 5){\makebox(0,0){$5$}}
##  \put( 3, 3){\makebox(0,0){$4$}}
##  \put(11, 3){\makebox(0,0){$7$}}
##  \put(17, 3){\makebox(0,0){$2$}}
##  \put( 5, 1){\makebox(0,0){$9$}}
##  \put( 7, 1){\makebox(0,0){$1$}}
##  \put(13, 1){\makebox(0,0){$8$}}
##  \end{picture}
##  \end{center}
##  
##  ]]></Alt>
##  
##  <Alt Only="HTML">
##  <![CDATA[
##  </p><table class="sudokuout">
##  <tr>
##  <td><table class="sudokuin">
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td></td><td>1</td>
##  <td>5</td>
##  </tr>
##  <tr>
##  <td>9</td>
##  <td></td><td></td></tr>
##  </table></td>
##  <td><table class="sudokuin">
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td>4</td>
##  <td></td><td>6</td>
##  </tr>
##  <tr>
##  <td></td><td>5</td>
##  <td></td></tr>
##  </table></td>
##  <td><table class="sudokuin">
##  <tr>
##  <td>5</td>
##  <td></td><td></td></tr>
##  <tr>
##  <td></td><td>2</td>
##  <td></td></tr>
##  <tr>
##  <td>3</td>
##  <td></td><td></td></tr>
##  </table></td>
##  </tr>
##  <tr>
##  <td><table class="sudokuin">
##  <tr>
##  <td>6</td>
##  <td></td><td>4</td>
##  </tr>
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td>8</td>
##  <td></td><td></td></tr>
##  </table></td>
##  <td><table class="sudokuin">
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td>8</td>
##  <td></td><td></td></tr>
##  <tr>
##  <td>9</td>
##  <td></td><td></td></tr>
##  </table></td>
##  <td><table class="sudokuin">
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td></td><td>5</td>
##  <td>3</td>
##  </tr>
##  </table></td>
##  </tr>
##  <tr>
##  <td><table class="sudokuin">
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td></td><td>4</td>
##  <td></td></tr>
##  <tr>
##  <td></td><td></td><td>9</td>
##  </tr>
##  </table></td>
##  <td><table class="sudokuin">
##  <tr>
##  <td></td><td></td><td>5</td>
##  </tr>
##  <tr>
##  <td></td><td></td><td>7</td>
##  </tr>
##  <tr>
##  <td>1</td>
##  <td></td><td></td></tr>
##  </table></td>
##  <td><table class="sudokuin">
##  <tr>
##  <td></td><td></td><td></td></tr>
##  <tr>
##  <td></td><td></td><td>2</td>
##  </tr>
##  <tr>
##  <td>8</td>
##  <td></td><td></td></tr>
##  </table></td>
##  </tr>
##  </table><p>
##  ]]>
##  </Alt>
##  
##  
##  The <Package>Browse</Package> package contains functions to create, play
##  and solve these games. There are basic command line functions for this,
##  which we describe first, and there is a user interface
##  <Ref Func="PlaySudoku" /> which is implemented using the generic
##  browse functionality described in Chapter <Ref Chap="chap:browse-user" />.
##  
##  <ManSection >
##  <Func Arg="[arg]" Name="Sudoku.Init" />
##  <Returns>A record describing a Sudoku board or <K>fail</K>.</Returns>
##  <Description>
##  This function constructs a record describing a Sudoku game. This is used
##  by the other functions described below. There a several possibilities
##  for the argument <Arg>arg</Arg>.
##  <List >
##  <Mark><Arg>arg</Arg> is a string</Mark>
##  <Item>The entries of a Sudoku board are numbered row-wise from 1 to 81.
##  A board is encoded as a string as follows. If one of the numbers 1 to 9
##  is in entry <M>i</M> then the corresponding digit character is written
##  in position <M>i</M> of the string. If an entry is empty any character,
##  except <C>'1'</C> to <C>'9'</C> or <C>'|'</C> is written in position
##  <M>i</M> of the string. Trailing empty entries can be left out.
##  Afterwards <C>'|'</C>-characters can be inserted in the string (for
##  example to mark line ends). Such strings can be used for <Arg>arg</Arg>.
##  </Item>
##  <Mark><Arg>arg</Arg> is a matrix</Mark>
##  <Item>A Sudoku board can also be encoded as a 9 by 9-matrix, that is a list
##  of 9 lists of length 9, whose (i,j)-th entry is the (i,j)-th entry of
##  the board as integer if it is not empty. Empty entries of the board
##  correspond to unbound entries in the matrix.
##  </Item>
##  <Mark><Arg>arg</Arg> is a list of integers</Mark>
##  <Item>Instead of the matrix just described the argument can also be
##  given by the concatenation of the rows of the matrix (so, a list of
##  integers and holes).
##  </Item>
##  </List>
##  <P/>
##  <Example><![CDATA[
##  gap> game := Sudoku.Init(" 3   68  | 85  1 69|  97   53|      79 |\
##  >  6  47   |45  2    |89   2 1 | 4   8 7 | ");;
##  ]]></Example>
##  </Description>
##  </ManSection>
##  
##  
##  <ManSection >
##  <Func Arg="game, i, n" Name="Sudoku.Place" />
##  <Func Arg="game, i" Name="Sudoku.Remove" />
##  <Returns>The changed <Arg>game</Arg>.</Returns>
##  <Description>
##  Here <Arg>game</Arg> is a record describing a Sudoku board, as returned
##  by <Ref Func="Sudoku.Init" />.
##  The argument <Arg>i</Arg> is the number of an entry, counted row-wise
##  from 1 to 81, and <Arg>n</Arg> is an integer from 1 to 9 to be placed on
##  the board. These functions change <Arg>game</Arg>.
##  <P/>
##  <Ref Func="Sudoku.Place"/> tries to place number <Arg>n</Arg> on entry
##  <Arg>i</Arg>. It is an error if entry <Arg>i</Arg> is not empty. The
##  number is not placed if <Arg>n</Arg> is already used in the row, column or
##  subsquare of entry <Arg>i</Arg>. In this case the component
##  <C>game.impossible</C> is bound.
##  <P/>
##  <Ref Func="Sudoku.Remove"/> tries to remove the number placed on position
##  <Arg>i</Arg> of the board. It does not change the board if entry
##  <Arg>i</Arg> is empty, or if entry <Arg>i</Arg> was given when the
##  board <Arg>game</Arg> was created. In the latter case
##  <C>game.impossible</C> is bound.
##  <P/>
##  <Example><![CDATA[
##  gap> game := Sudoku.Init(" 3   68  | 85  1 69|  97   53|      79 |\
##  >  6  47   |45  2    |89   2 1 | 4   8 7 | ");;
##  gap> Sudoku.Place(game, 1, 3);; # 3 is already in first row
##  gap> IsBound(game.impossible);
##  true
##  gap> Sudoku.Place(game, 1, 2);; # 2 is not in row, col or subsquare
##  gap> IsBound(game.impossible);
##  false
##  ]]></Example>
##  </Description>
##  </ManSection>
##  
##  <ManSection >
##  <Func Arg="[seed]" Name="Sudoku.RandomGame" />
##  <Returns>A pair <C>[str, seed]</C> of string and seed.</Returns>
##  <Description>
##  The optional argument <Arg>seed</Arg>, if given, must be an integer.
##  If not given some random integer from the current &GAP; session is used.
##  This function returns a random proper Sudoku game, where the board is
##  described by a string <C>str</C>, as explained in
##  <Ref Func="Sudoku.Init"/>. With the same <Arg>seed</Arg> the same board
##  is returned.
##  <P/>
##  The games computed by this function have the property
##  that after removing any given entry the puzzle does no
##  longer have a unique solution.
##  <P/>
##  <Example><![CDATA[
##  gap> Sudoku.RandomGame(5833750);
##  [ " 1         2     43  2   68   72    8     6 2   1 9 8  8 3   9     \
##  47 3   7  18  ", 5833750 ]
##  gap> last = Sudoku.RandomGame(last[2]);
##  true
##  ]]></Example>
##  </Description>
##  </ManSection>
##  
##  <ManSection >
##  <Func Arg="game" Name="Sudoku.SimpleDisplay" />
##  <Description>
##  Displays a Sudoku board on the terminal. (But see <Ref
##  Func="PlaySudoku"/> for a fancier interface.)
##  <P/>
##  <Example><![CDATA[
##  gap> game := Sudoku.Init(" 3   68  | 85  1 69|  97   53|      79 |\
##  >  6  47   |45  2    |89   2 1 | 4   8 7 | ");;
##  gap> Sudoku.SimpleDisplay(game);
##   3 |  6|8  
##   85|  1| 69
##    9|7  | 53
##  -----------
##     |   |79 
##   6 | 47|   
##  45 | 2 |   
##  -----------
##  89 |  2| 1 
##   4 |  8| 7 
##     |   |   
##  ]]></Example>
##  </Description>
##  </ManSection>
##  
##  <ManSection >
##  <Func Name="Sudoku.DisplayString" Arg="game"/>
##  <Description>
##  The string returned by this function can be used to display
##  the Sudoku board <Arg>game</Arg> on the terminal,
##  using <Ref Func="PrintFormattedString" BookName="gapdoc"/>.
##  The result depends on the value of <C>GAPInfo.TermEncoding</C>.
##  <P/>
##  <Log><![CDATA[
##  gap> game := Sudoku.Init(" 3   68  | 85  1 69|  97   53|      79 |\
##  >  6  47   |45  2    |89   2 1 | 4   8 7 | ");;
##  gap> str:= Sudoku.DisplayString( game );;
##  gap> PrintFormattedString( str );
##                       ┏━━━┯━━━┯━━━┳━━━┯━━━┯━━━┳━━━┯━━━┯━━━┓
##                       ┃   │ 3 │   ┃   │   │ 6 ┃ 8 │   │   ┃
##                       ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##                       ┃   │ 8 │ 5 ┃   │   │ 1 ┃   │ 6 │ 9 ┃
##                       ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##                       ┃   │   │ 9 ┃ 7 │   │   ┃   │ 5 │ 3 ┃
##                       ┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
##                       ┃   │   │   ┃   │   │   ┃ 7 │ 9 │   ┃
##                       ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##                       ┃   │ 6 │   ┃   │ 4 │ 7 ┃   │   │   ┃
##                       ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##                       ┃ 4 │ 5 │   ┃   │ 2 │   ┃   │   │   ┃
##                       ┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫
##                       ┃ 8 │ 9 │   ┃   │   │ 2 ┃   │ 1 │   ┃
##                       ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##                       ┃   │ 4 │   ┃   │   │ 8 ┃   │ 7 │   ┃
##                       ┠───┼───┼───╂───┼───┼───╂───┼───┼───┨
##                       ┃   │   │   ┃   │   │   ┃   │   │   ┃
##                       ┗━━━┷━━━┷━━━┻━━━┷━━━┷━━━┻━━━┷━━━┷━━━┛
##  ]]></Log>
##  </Description>
##  </ManSection>
##  
##  <ManSection >
##  <Func Arg="game" Name="Sudoku.OneSolution" />
##  <Returns>A completed Sudoku board that solves <Arg>game</Arg>, or
##  <K>fail</K>.</Returns>
##  <Description>
##  Here <Arg>game</Arg> must be a Sudoku board as returned by <Ref
##  Func="Sudoku.Init"/>. It is not necessary that <Arg>game</Arg> describes
##  a proper Sudoku game (has a unique solution).
##  It may have several solutions, then one random
##  solution is returned. Or it may have no solution, then <K>fail</K> is
##  returned.
##  <P/>
##  <Log><![CDATA[
##  gap> Sudoku.SimpleDisplay(Sudoku.OneSolution(Sudoku.Init("  3")));
##  493|876|251
##  861|542|739
##  527|193|648
##  -----------
##  942|618|573
##  156|739|482
##  738|425|916
##  -----------
##  289|354|167
##  375|961|824
##  614|287|395
##  ]]></Log>
##  
##  </Description>
##  </ManSection>
##  
##  <ManSection >
##  <Func Arg="game" Name="Sudoku.UniqueSolution" />
##  <Returns>A completed Sudoku board that solves <Arg>game</Arg>,
##  or <K>false</K>, or <K>fail</K>.</Returns>
##  <Description>
##  Here <Arg>game</Arg> must be a Sudoku board as returned by <Ref
##  Func="Sudoku.Init"/>. It is not necessary that <Arg>game</Arg> describes
##  a proper Sudoku game. If it has several solutions, then <K>false</K>
##  is returned. If it has no solution, then <K>fail</K> is
##  returned. Otherwise a board with the unique solution is returned.
##  <P/>
##  <Example><![CDATA[
##  gap> s := "      5  | 154 6 2 |9   5 3  |6 4      |   8     |8  9   53\
##  > |     5   | 4   7  2|  91  8  ";;
##  gap> sol := Sudoku.UniqueSolution(Sudoku.Init(s));;
##  gap> Sudoku.SimpleDisplay(sol);
##  438|219|576
##  715|436|928
##  962|758|314
##  -----------
##  694|573|281
##  153|862|749
##  827|941|653
##  -----------
##  281|695|437
##  546|387|192
##  379|124|865
##  ]]></Example>
##  
##  </Description>
##  </ManSection>
##  
##  <ManSection >
##  <Func Arg="[arg]" Name="PlaySudoku" />
##  <Returns>A record describing the latest status of a Sudoku board.</Returns>
##  <Description>
##  This function allows one to solve Sudoku puzzles interactively.
##  There are several possibilities for the optional argument
##  <Arg>arg</Arg>. It can either be a string, matrix or list of holes and
##  integers as described in <Ref Func="Sudoku.Init"/>, or a board as
##  returned by <Ref Func="Sudoku.Init"/>. Furthermore <Arg>arg</Arg> can be
##  an integer or not be given, in that case <Ref Func="Sudoku.RandomGame"/>
##  is called to produce a random game.
##  <P/>
##  The usage of this function is self-explanatory, pressing the
##  <B>?</B> key displays a help screen. Here, we mention two keys with a
##  particular action: Pressing the <B>h</B> key you get a hint, either
##  an empty entry is filled or the program tells you that there is no
##  solution (so you must delete some entries and try others).
##  Pressing the <B>s</B> key the puzzle is solved by the program
##  or it tells you that there is no or no unique solution.
##  <P/>
##  
##  <E>Implementation remarks</E>:
##  The game board is implemented via a browse table,
##  without row and column labels,
##  with static header, dynamic footer, and individual <C>minyx</C> function.
##  Two modes are supported, with the standard actions for quitting the table
##  and asking for help; one cell is selected in each mode.
##  The first mode provides actions for moving the selected cell via arrow
##  keys, for changing the value in the selected cell, for getting a
##  hint or the (unique) solution.
##  (Initial entries of the matrix cannot be changed via user input.
##  They are shown in boldface.)
##  The second mode serves for error handling:
##  When the user enters an invalid number, i.&nbsp;e., a number that occurs
##  already in the current row or column or subsquare, then the application
##  switches to this mode, which causes that a message is shown in the
##  footer, and the invalid entry is shown in red and blinking;
##  similarly, error mode is entered if a hint or solution does not exist.
##  <P/>
##  The separating lines are drawn using an individual <C>SpecialGrid</C>
##  function in the browse table, since they cannot be specified within
##  the generic browse table functions.
##  <P/>
##  Some standard <Ref Func="NCurses.BrowseGeneric"/> functionality,
##  such as scrolling, selecting, and searching,
##  are not available in this application.
##  <P/>
##  The code can be found in the file <F>app/sudoku.g</F> of the package.
##  </Description>
##  </ManSection>
##  
##  <ManSection >
##  <Func Arg="game" Name="Sudoku.HTMLGame" />
##  <Func Arg="game" Name="Sudoku.LaTeXGame" />
##  <Returns>A string with HTML or &LaTeX; code, respectively.</Returns>
##  <Description>
##  The argument of these functions is a record describing a Sudoku game.
##  These functions return code for including the current status of the
##  board into a webpage  or a &LaTeX; document.
##  </Description>
##  </ManSection>
##  </Section>
##  <#/GAPDoc>


# global record to hold most data and functions of this section
BindGlobal("Sudoku",  rec(
# we count fields of board rowwise from 1..81; first collect relevant
# indices in row, column and subsquare for each entry
rows := List([0..8], c-> c*9+[1..9]),
cols := List([1..9], i-> i+[0,9..72]),
squs := List([1,4,7,28,31,34,55,58,61], i-> i-1+[1,2,3,10,11,12,19,20,21]),
rcsind := List([1..81], i-> [QuoInt(i-1,9)+1, (i-1) mod 9 + 1,
          First([1..9], j-> i in ~.squs[j])]),
inds := List(~.rcsind, ind -> Set(Concatenation(~.rows[ind[1]],
              ~.cols[ind[2]], ~.squs[ind[3]])))
              ));
#####################################################################
##  a very simple random generator
Sudoku.SimpleRandData := function(seed, bound)
  local res;
  res := rec(m := 3^18, a := 4, c := 217420199, seed := seed, bound := bound);
  res.seed := res.seed mod res.m;
  return res;
end;
Sudoku.SimpleRandNext := function(self)
  self.seed := (self.a * self.seed + self.c) mod self.m;
  return self.seed mod self.bound;
end;
# returns equally distributed numbers in [0..max-1]
Sudoku.SimpleRandNextMax := function(self, max)
  return QuoInt(Sudoku.SimpleRandNext(self) * max, self.bound);
end;
Sudoku.SimpleRandList := function(self, l)
  return l[Sudoku.SimpleRandNextMax(self, Length(l))+1];
end;
# shuffle list in place
Sudoku.SimpleRandShuffleList := function(self, l)
  local pos, t, k;
  for k in [Length(l), Length(l)-1..0] do
    pos := Sudoku.SimpleRandNextMax(self, k);
    if pos < k-1 then
      t := l[k];
      l[k] := l[pos+1];
      l[pos+1] := t;
    fi;
  od;
end;
Sudoku.rand := Sudoku.SimpleRandData(Random(1,10000000), 3^18);

# place entry in game
Sudoku.Place := function(board, i, n)
  local poss, num, ind, j;
  poss := board.poss;
  num := board.num;
  if not IsList(poss[i]) then
    Error("Entry is not free.\n");
  elif poss[i][n] = false then
    # if n is already in row, column or sub-square
    board.impossible := [i,n];
    return board;
  fi;
  # adjust the possibilities for the related entries
  ind := Sudoku.inds[i];
  for j in ind do
    if IsList(poss[j]) and poss[j][n] then
      poss[j][n] := false;
      num[j] := num[j]-1;
    fi;
  od;
  Unbind(board.impossible);
  poss[i] := n;
  num[i] := 0;
  Add(board.moves, [i, n]);
  return board;
end;
# create a game
##  Returns record with the following entries (the fields of the board are
##  numbered row-wise from 1 to 81):
##  poss        list, in position i is the entry of field i if there is one,
##              and otherwise a Boolean list of nine entries, where entry j
##              is 'true' if number j doesn't yet occur in the row, column or
##              subsquare of field i.
##  num         list, in position i is 0 if field i of board has already
##              a number and the number of true's in poss[i] otherwise.
##  moves       list that records the history of the board: entries [i,j]
##              mean that number j is set on field i, and entries -i mean
##              that field i was cleared
##  start       the number of moves setting the initial numbers
##
Sudoku.Init := function(str)
  local a, board, num, i, c;
  if IsString(str) then
    str := INTLIST_STRING(str,0)-48;
  elif IsList(str) and ForAll(Flat(str), IsInt) then
    str := Flat(str);
  else
    Error("Wrong input format, give string or list/matrix of integers.\n");
  fi;
  a := BlistList([1..9],[1..9]);
  board := rec(
    poss := List([1..81], i-> ShallowCopy(a)),
    num := 9 + 0*[1..81],
    start := 0,
    moves := []);
  i := 0;
  for c in str do
    # ignore '|'
    if c <> 76 then
      i := i+1;
      if 0 < c and c < 10 then
        a := Sudoku.Place(board, i, c);
        if IsBound(a.impossible) then
          return fail;
        fi;
        board.start := board.start+1;
      fi;
    fi;
  od;
  return board;
end;
# remove an entry
Sudoku.Remove := function(board, i)
  local new, k;
  if not (IsInt(i) and 0 < i and 81 >= i) then
    Error("Wrong position argument.\n");
  fi;
  # don't remove initial entries
  if ForAny([1..board.start], k-> board.moves[k][1] = i) then
    board.impossible := -i;
    return board;
  fi;
  # if nothing to do, do nothing
  if board.num[i] > 0 then
    Unbind(board.impossible);
    return board;
  fi;
  # otherwise recompute poss and num (by recomputing completely)
  new := Sudoku.Init("");
  for k in [1..81] do
    if k <> i and IsInt(board.poss[k]) then
      Sudoku.Place(new, k, board.poss[k]);
    fi;
  od;
  board.poss := new.poss;
  board.num := new.num;
  Add(board.moves, -i);
  Unbind(board.impossible);
  return board;
end;
# find one solution (returns fail is none exists)
Sudoku.OneSolution := function(board)
  local min, pos, new, i, poss;
  if ForAll(board.poss, IsInt) then
    return board;
  fi;
  # check for entry without any possibility
  if ForAny([1..81], i-> board.num[i] = 0 and IsList(board.poss[i])) then
    return fail;
  fi;
  # only look at positions with minimal number of possibilities next,
  # this is essential to keep the backtrack reasonably short
  min := Set(board.num);
  min := min[2];
  poss := Filtered([1..81], i-> board.num[i] = min);
  pos := Sudoku.SimpleRandList(Sudoku.rand, poss);
  for i in [1..9] do
    if board.poss[pos][i] then
      new := Sudoku.Place(StructuralCopy(board), pos, i);
      if not IsBound(new.impossible) then
        new := Sudoku.OneSolution(new);
      fi;
      if new <> fail then
        return new;
      fi;
    fi;
  od;
  return fail;
end;
# find unique solution (returns fail if none exists and false if more than
# one exists)
Sudoku.UniqueSolution := function(board)
  local min, pos, sol, new, i;
  if ForAll(board.poss, IsInt) then
    return board;
  fi;
  # check for entry without any possibility
  if ForAny([1..81], i-> board.num[i] = 0 and IsList(board.poss[i])) then
    return fail;
  fi;
  # only look at positions with minimal number of possibilities next,
  # this is essential to keep the backtrack reasonably short
  min := Set(board.num);
  min := min[2];
  pos := Position(board.num, min);
  sol := [];
  # produce 'fail' if not solvable and 'false' if several solutions
  for i in [1..9] do
    if board.poss[pos][i] then
      new := Sudoku.Place(StructuralCopy(board), pos, i);
      if not IsBound(new.impossible) then
        new := Sudoku.UniqueSolution(new);
        if new = false then
          return false;
        fi;
        if new <> fail then
          sol[i] := new;
        else
          sol[i] := fail;
        fi;
      else
        sol[i] := fail;
      fi;
    else
      sol[i] := fail;
    fi;
  od;
  sol := Filtered(sol, a-> a <> fail);
  if Length(sol) > 1 then
    return false;
  elif Length(sol) = 0 then
    return fail;
  else
    return sol[1];
  fi;
end;
# create a random game
Sudoku.RandomGame := function(arg)
  local g, str, s, poss, found, merk, i, oldrand, seed;
  if Length(arg) > 0 and IsInt(arg[1]) then
    oldrand := Sudoku.rand;
    Sudoku.rand := Sudoku.SimpleRandData(arg[1], 3^18);
  fi;
  seed := Sudoku.rand.seed;
  g := Sudoku.Init(Sudoku.SimpleRandList(Sudoku.rand,
                  ["1","2","3","4","5","6","7","8","9" ]));
  g := Sudoku.OneSolution(g);
  str := Sudoku.StringGame(g);
  RemoveCharacters(str,"|");
  # try to delete random 45 entries such that solution still unique
  while not ' ' in str do
    poss := [1..81];
    Sudoku.SimpleRandShuffleList(Sudoku.rand, poss);
    s := ShallowCopy(str);
    for i in [1..45] do
      s[poss[i]] := ' ';
    od;
    if IsRecord(Sudoku.UniqueSolution(Sudoku.Init(s))) then
      str := s;
    fi;
  od;
  # delete further entries until solution unique and deleting any further
  # entry causes non-uniqueness
  while true do
    poss := Filtered([1..81], i-> str[i] <> ' ');
    Sudoku.SimpleRandShuffleList(Sudoku.rand, poss);
    found := false;
    for i in poss do
      merk := str[i];
      str[i] := ' ';
      if IsRecord(Sudoku.UniqueSolution(Sudoku.Init(str))) then
        found := true;
        break;
      else
        str[i] := merk;
      fi;
    od;
    if found = false then
      if Length(arg) > 0 and IsInt(arg[1]) then
        Sudoku.rand := oldrand;
      fi;
      return [str, seed];
    fi;
  od;
end;
# encode game status as string
Sudoku.StringGame := function(board)
  local res, c, i;
  res := "";
  c := "123456789";
  for i in [1..81] do
    if IsInt(board.poss[i]) then
      Add(res, c[board.poss[i]]);
    else
      Add(res, ' ');
    fi;
    if i<81 and i mod 9 = 0 then
      # just for readability
      Add(res, '|');
    fi;
  od;
  return res;
end;
# simple display on screen
Sudoku.SimpleDisplay := function(board)
  local i;
  for i in [1..81] do
    if i in [28,55] then
      Print("-----------\n");
    fi;
    if board.num[i] = 0 then
      Print(board.poss[i]);
    else
      Print(" ");
    fi;
    if i mod 9 in [3,6] then
      Print("|");
    fi;
    if i mod 9 = 0 then
      Print("\n");
    fi;
  od;
end;
# nicer display for UTF-8 terminals
Sudoku.DisplayString:= function( board )
  local indent, str, first, plain, bold, last, left, right, bmid, pmid, i, j,
        pos;

  indent:= RepeatedString( " ", QuoInt( SizeScreen()[1] - 37, 2 ) );
  str:= "";

  if GAPInfo.TermEncoding = "UTF-8" then
    first:= "┏━━━┯━━━┯━━━┳━━━┯━━━┯━━━┳━━━┯━━━┯━━━┓\n";
    plain:= "┠───┼───┼───╂───┼───┼───╂───┼───┼───┨\n";
    bold:=  "┣━━━┿━━━┿━━━╋━━━┿━━━┿━━━╋━━━┿━━━┿━━━┫\n";
    last:=  "┗━━━┷━━━┷━━━┻━━━┷━━━┷━━━┻━━━┷━━━┷━━━┛\n";
    left:=  "┃ ";
    right:= " ┃\n";
    bmid:=  " ┃ ";
    pmid:=  " │ ";
  else
    first:= "#####################################\n";
    plain:= "#---+---+---#---+---+---#---+---+---#\n";
    bold:= first;
    last:= first;
    left:=  "# ";
    right:= " #\n";
    bmid:=  " # ";
    pmid:=  " | ";
  fi;

  for i in [ 1 .. 9 ] do
    Append( str, indent );
    if i = 1 then
      Append( str, first );
    elif i in [ 4, 7 ] then
      Append( str, bold );
    else
      Append( str, plain );
    fi;
    Append( str, indent );
    Append( str, left );
    for j in [ 1 .. 9 ] do
      pos:= (i-1)*9 + j;
      if board.num[ pos ] = 0 then
        Append( str, String( board.poss[ pos ] ) );
      else
        Append( str, " " );
      fi;
      if j in [ 3, 6 ] then
        Append( str, bmid );
      elif j = 9 then
        Append( str, right );
      else
        Append( str, pmid );
      fi;
    od;
  od;
  Append( str, indent );
  Append( str, last );

  return str;
end;
# format game as HTML table
Sudoku.HTMLGame := function(board)
  local str, filled, fchars, res, tl, l, i, j, ii, jj;
  str := Sudoku.StringGame(board);
  RemoveCharacters(str, "|");
  filled := [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ];
  fchars := "123456789";
  res := "<table class=\"sudokuout\">\n";
  for i in [1,28,55] do
    Append(res, "<tr>\n");
    for j in [0,3,6] do
      tl := i+j;
      Append(res, "<td><table class=\"sudokuin\">\n");
      for ii in [0,9,18] do
        l := tl+ii;
        Append(res,"<tr>\n");
        for jj in [0,1,2] do
          if str[l+jj] in fchars then
            Append(res, "<td>");
            Add(res, str[l+jj]);
            Append(res, "</td>\n");
          else
            Append(res, "<td></td>");
          fi;
        od;
        Append(res,"</tr>\n");
      od;
      Append(res, "</table></td>\n");
    od;
    Append(res, "</tr>\n");
  od;
  Append(res, "</table>\n");
  Append(res, "<!-- Put this or similar in style sheet file or element:\n\
table.sudokuin td {\n\
  padding: 0px;\n\
  width: 35px;\n\
  height: 37px;\n\
  border: 2px solid red;\n\
  text-align: center;\n\
  font-weight: bold;\n\
  font-size: 20px;\n\
  background: #DDDDDD;\n\
}\n\
-->\n");
  return res;
end;
Sudoku.LaTeXGame := function(board)
  local str, filled, fchars, res, tl, l, i, j, ii, jj;
  str := Sudoku.StringGame(board);
  RemoveCharacters(str, "|");
  filled := [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ];
  fchars := "123456789";
  res := "\\begin{tabular}{||c|c|c||c|c|c||c|c|c||}\n\\hline\\hline\n";
  for i in [1..81] do
    Add(res,str[i]);
    if i mod 9 = 0  then
      Append(res, "\\\\\n\\hline\n");
      if (i/9 mod 3) = 0 then
        Append(res, "\\hline\n");
      fi;
    else
      Add(res,'&');
    fi;
  od;
  Append(res, "\\end{tabular}\n");
  return res;
end;


BindGlobal( "PlaySudoku", function( arg )
    local  entries, input, i, j, match, enter, before_error, empty,
        matrix, initial, val, grid, enterfunction, actions, errorquit, hint,
        fillmode, errormode, errorinfo, table, found, game, p, fillmatrix,
        solve, printgame, dellast, reset;

    # Get and check the arguments.
    if Length(arg) = 0 then
      # if no arg, use a random seed
      game := Random(1, 10000000);
    else
      game := arg[1];
    fi;
    if IsInt(game) then
      game := Sudoku.RandomGame(game)[1];
    fi;
    if IsString(game) or IsList(game) then
      game := Sudoku.Init(game);
    fi;
    game.given := List(game.moves{[1..game.start]}, a-> a[1]);


    # Fill the matrix with the initial values.
    empty:= "   ";
    # strings for entries
    entries:= List( [ 1 .. 9 ], i -> Concatenation( " ", String(i), " " ) );
    matrix:= List( [ 1 .. 9 ], i -> []);
    fillmatrix := function()
      local i, j, val;
      for i in [1..9] do
        for j in [1..9] do
          p := (i-1)*9+j;
          if IsInt(game.poss[p]) then
            val := game.poss[p];
            if p in game.given then
              matrix[i][j] := [ NCurses.attrs.BOLD +
                                NCurses.ColorAttr("blue",-1), true,
                                entries[val] ];
            else
              matrix[i][j] := entries[val];
            fi;
          else
            matrix[i][j] := empty;
          fi;
        od;
      od;
    end;
    fillmatrix();

    # Supported actions are
    # - moving via arrow keys,
    # - filling the current cell with a number or with whitespace,
    # - entering the help mode,
    # - and leaving the table

    # Construct the show function and some actions for the modes.
    grid:= function( t, data )
      local win, tp, lt;

      win:= t.dynamic.window;
      tp:= data.topmargin + 3;
      lt:= data.leftmargin;
      NCurses.Grid( win, tp, tp + 18, lt, lt + 36,
                         tp + [ 0, 2 .. 18 ], lt + [ 0, 4 .. 36 ] );
      NCurses.wattrset( win, NCurses.attrs.BOLD );
      NCurses.Grid( win, tp, tp + 18, lt, lt + 36,
                         tp + [ 0, 6 .. 18 ], lt + [ 0, 12 .. 36 ] );
      NCurses.wattrset( win, NCurses.attrs.NORMAL );
    end;

    enterfunction:= function( val )
      return function( t )
        local sel, p, r;

        sel:= t.dynamic.selectedEntry / 2;
        p := (sel[1]-1)*9+sel[2];
        if not p in game.given then
          if not IsDigitChar( val[1] ) then
            Sudoku.Remove(game, p);
            matrix[ sel[1] ][ sel[2] ]:= empty;
            t.dynamic.changed:= true;
          else
            if IsInt(game.poss[p]) then
              Sudoku.Remove(game, p);
            fi;
            r := IntChar(val[1])-IntChar('0');
            Sudoku.Place(game, p, r);
            if not IsBound(game.impossible) then
              matrix[ sel[1] ][ sel[2] ]:= entries[r];
            else
              matrix[ sel[1] ][ sel[2] ]:= [NCurses.attrs.BOLD, true,
                  NCurses.ColorAttr( "red", -1 ), true,
                  entries[r]];
            fi;
            t.dynamic.changed:= true;
          fi;
          if IsBound(game.impossible) then
            before_error := empty;
            errorinfo := "Invalid entry! (<Space> to continue)";
            BrowseData.PushMode( t, "error" );
          fi;
        fi;
        return t.dynamic.changed;
      end;
    end;
    # give a hint
    hint := function(t)
      local sol, sel;
      sol := Sudoku.OneSolution(game);
      if sol = fail then
        before_error := 0;
        errorinfo := Concatenation("This board cannot be completed! ",
                     "(press <Space>)");
        BrowseData.PushMode( t, "error" );
      else
        p := Filtered([1..81], i-> not IsInt(game.poss[i]));
        if Length(p)=0 then
          return true;
        fi;
        p := Random(p);
        Sudoku.Place(game, p, sol.poss[p]);
        sel := [, (p-1) mod 9 +1];
        sel[1] := (p-sel[2])/9+1;
        t.dynamic.selectedEntry := 2*sel;
        fillmatrix();
      fi;
      t.dynamic.changed := true;
      return true;
    end;
    # solve completely, if possible
    solve := function(t)
      local sol, ps, p;
      sol := Sudoku.UniqueSolution(game);
      if sol = fail then
        before_error := 0;
        errorinfo := Concatenation("This board cannot be completed! ",
                     "(<Space>)");
        BrowseData.PushMode( t, "error" );
      elif sol = false then
        before_error := 0;
        errorinfo := Concatenation("Invalid game, no unique solution!",
                     "(<Space>)");
        BrowseData.PushMode( t, "error" );
      else
        ps := Filtered([1..81], i-> not IsInt(game.poss[i]));
        for p in ps do
          Sudoku.Place(game, p, sol.poss[p]);
        od;
        fillmatrix();
      fi;
      t.dynamic.changed := true;
      return true;
    end;
    # print game status as string
    printgame := function(t)
      local str, l;
      str := Sudoku.StringGame(game);
      l := [Concatenation("\"", str{[1..45]}, "\\"),
            Concatenation(str{[46..Length(str)]}, "\"")];
      if BrowseData.IsDoneReplay( t.dynamic.replay ) then
        NCurses.Pager(rec(lines := l));
        NCurses.update_panels();
        NCurses.doupdate();
        NCurses.curs_set( 0 );
      fi;
      return t.dynamic.changed;
    end;
    # delete last
    dellast := function(t)
      local i, p, sel;
      i := Length(game.moves);
      while i > game.start and not (IsList(game.moves[i]) and
            IsInt(game.poss[game.moves[i][1]])) do
        i := i-1;
      od;
      if i > game.start then
        Sudoku.Remove(game, game.moves[i][1]);
      fi;
      p := game.moves[i][1];
      sel := [, (p-1) mod 9 +1];
      sel[1] := (p-sel[2])/9+1;
      t.dynamic.selectedEntry := 2*sel;

      fillmatrix();
      t.dynamic.changed := true;
      return true;
    end;
    # reset: delete all except given entries
    reset := function(t)
      i := Length(game.moves);
      while i > game.start do
        if IsList(game.moves[i]) and IsInt(game.poss[game.moves[i][1]]) then
          Sudoku.Remove(game, game.moves[i][1]);
        fi;
        i := i-1;
      od;
      fillmatrix();
      t.dynamic.changed := true;
      return true;
    end;

    actions := [ [ [" "],
                    rec( helplines:= ["delete the entry"],
                         action:= enterfunction( " " ) ) ] ];
    for i in List( [ 1 .. 9 ], String ) do
      Add( actions, [ [ i ], rec( helplines:= [Concatenation( "enter ", i )],
                                  action:= enterfunction( i ) ) ] );
    od;

    errorquit:= rec( helplines:= ["remove an invalid entry"],
                     action:= function( t )
                       local sel;

                       if before_error <> 0 then
                         sel:= t.dynamic.selectedEntry / 2;
                         matrix[ sel[1] ][ sel[2] ]:= before_error;
                       fi;
                       BrowseData.actions.QuitMode.action( t );
                       end );

    # Construct the modes.
    fillmode:= BrowseData.CreateMode( "fill", "select_entry",
      Concatenation( [
      # standard actions
      [ [ "E" ], BrowseData.actions.Error ],
      [ [ "q", [ [ 27 ], "<Esc>" ] ], BrowseData.actions.QuitMode ],
      [ [ "Q" ], BrowseData.actions.QuitTable ],
      [ [ "?", [[NCurses.keys.F1], "<F1>"]], BrowseData.actions.ShowHelp ],
      [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
      # moves of the selected cell via arrow keys
      [ [ "r", [ [ NCurses.keys.RIGHT ], "<Right>" ] ],
        BrowseData.actions.ScrollSelectedCellRight ],
      [ [ "l", [ [ NCurses.keys.LEFT ], "<Left>" ] ],
        BrowseData.actions.ScrollSelectedCellLeft ],
      [ [ "d", [ [ NCurses.keys.DOWN ], "<Down>" ] ],
        BrowseData.actions.ScrollSelectedCellDown ],
      [ [ "u", [ [ NCurses.keys.UP ], "<Up>" ] ],
        BrowseData.actions.ScrollSelectedCellUp ],
      [ [ "h" ], rec(helplines := ["get a hint from computer"],
                      action := hint ) ],
      [ [ "s" ], rec(helplines := ["solve game (if possible)"],
                      action := solve ) ],
      [ [ "b" ], rec(helplines := ["go back by deleting last set entry"],
                      action := dellast ) ],
      [ [ "R" ], rec(helplines := ["reset, delete all but initial entries"],
                      action := reset ) ],
      [ [ "p" ], rec(helplines := ["print game status as string"],
                      action := printgame ) ],
      # mouse events
      [ [ "M" ], BrowseData.actions.ToggleMouseEvents ],
      [ [ [ [ NCurses.keys.MOUSE, "BUTTON1_PRESSED" ],
            "<Mouse1Down>" ],
          [ [ NCurses.keys.MOUSE, "BUTTON1_CLICKED" ],
            "<Mouse1Click>" ] ],
        BrowseData.actions.DealWithSingleMouseClick ],
      ],
      # entering digits or whitespace
      actions ) );

    errormode:= BrowseData.CreateMode( "error", "select_entry", [
      # standard actions
      [ [ "E" ], BrowseData.actions.Error ],
      [ [ "Q" ], BrowseData.actions.QuitTable ],
      [ [ "?", [[NCurses.keys.F1], "<F1>"]], BrowseData.actions.ShowHelp ],
      [ [ [ [ NCurses.keys.F2 ], "<F2>" ] ], BrowseData.actions.SaveWindow ],
      # removing the offending entry
      [ [ " ", "q", [ [ 27 ], "<Esc>" ] ], errorquit ] ]  );

    # Construct the browse table.
    table:= rec(
      work:= rec(
        align:= "ct",
        minyx:= [ 24, 37 ],
        header:= [ "",
                   [ NCurses.attrs.UNDERLINE, true, "Sudoku" ],
                   "" ],
        main:= matrix,
        sepRow:= " ",
        sepCol:= " ",
        footer:= rec(
          fill:= function( t )
            if ForAll( matrix, row -> not empty in row ) then
              return [ "", [ NCurses.ColorAttr( "red", -1 ), "Done!" ] ];
            else
              return [ "", "" ];
            fi;
          end,
          error:= function( t )
            return [ "", [ NCurses.ColorAttr( "red", -1 ),
                     errorinfo ] ];
          end ),
        availableModes:= [ fillmode, errormode ],
        SpecialGrid:= grid,
      ),
      dynamic:= rec(
        selectedEntry:= [ 2, 2 ],
        log:= [],
        activeModes:= [ fillmode ],
        Return:= game,
      )
    );

    # Select the first empty position (if there is one).
    found:= false;
    for i in [ 1 .. 9 ] do
      for j in [ 1 .. 9 ] do
        if matrix[i][j] = empty then
          table.dynamic.selectedEntry:= 2 * [ i, j ];
          found:= true;
          break;
        fi;
      od;
      if found then
        break;
      fi;
    od;

    # Show the browse table, and return its return value.
    return NCurses.BrowseGeneric( table );
end );


#############################################################################
##
#E

