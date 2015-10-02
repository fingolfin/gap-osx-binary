#############################################################################
##
#A  testall.tst        IntPic package                   Manuel Delgado
##                                                    
##  (based on the cooresponding file of the 'example' package, 
##   by Alexander Konovalov) 
##
##  To create a test file, place GAP prompts, input and output exactly as
##  they must appear in the GAP session. Do not remove lines containing 
##  START_TEST and STOP_TEST statements.
##
##  The first line starts the test. START_TEST reinitializes the caches and 
##  the global random number generator, in order to be independent of the 
##  reading order of several test files. Furthermore, the assertion level 
##  is set to 2 by START_TEST and set back to the previous value in the 
##  subsequent STOP_TEST call.
##
##  The argument of STOP_TEST may be an arbitrary identifier string.
## 
gap> START_TEST("IntPic package: testall.tst");

# Note that you may use comments in the test file
# and also separate parts of the test by empty lines

# First load the package without banner (the banner must be suppressed to 
# avoid reporting discrepancies in the case when the package is already 
# loaded)
gap> LoadPackage("intpic",false);
true

# Check that the data are consistent  

#############################################################################
# Some more elaborated tests


#############################################################################
#############################################################################
# Examples from the manual
# (These examples use at least a funtion from each file)
gap> rg := [81..89];
[ 81 .. 89 ]
gap> len := 10;
10
gap> arr := [Filtered(rg,IsPrime),Filtered(rg,u->(u mod 2)=0),
>         Filtered(rg,u->(u mod 3)=0)];
[ [ 83, 89 ], [ 82, 84, 86, 88 ], [ 81, 84, 87 ] ]
gap> tkz := IP_TikzArrayOfIntegers(rg,len,rec(highlights:=arr));
"%tikz\n\\begin{tikzpicture}[every node/.style={draw,scale=1pt,\nminimum width\
=20pt,inner sep=3pt,\nline width=0pt,draw=black}]\n\\matrix[row sep=2pt,column\
 sep=2pt]\n{\\node[fill=blue]{81};&\n\\node[fill=green]{82};&\n\\node[fill=red\
]{83};&\n\\node[left color=green,right color=blue]{84};&\n\\node[]{85};&\n\\no\
de[fill=green]{86};&\n\\node[fill=blue]{87};&\n\\node[fill=green]{88};&\n\\nod\
e[fill=red]{89};\\\\\n};\n\\end{tikzpicture}\n"
gap> Print(tkz);
%tikz
\begin{tikzpicture}[every node/.style={draw,scale=1pt,
minimum width=20pt,inner sep=3pt,
line width=0pt,draw=black}]
\matrix[row sep=2pt,column sep=2pt]
{\node[fill=blue]{81};&
\node[fill=green]{82};&
\node[fill=red]{83};&
\node[left color=green,right color=blue]{84};&
\node[]{85};&
\node[fill=green]{86};&
\node[fill=blue]{87};&
\node[fill=green]{88};&
\node[fill=red]{89};\\
};
\end{tikzpicture}
#######
gap> SetOfNumericalSemigroups(rec(set:=rec(genus:=6),filter:=rec(type:= 2), order:="frobenius"));                                                 
[ <Numerical semigroup with 3 generators>, 
  <Numerical semigroup with 5 generators>, 
  <Numerical semigroup with 5 generators>, 
  <Numerical semigroup with 3 generators>, 
  <Numerical semigroup with 4 generators>, 
  <Numerical semigroup with 6 generators> ]
gap> List(last,MinimalGeneratingSystem);
[ [ 3, 10, 11 ], [ 5, 6, 7 ], [ 5, 6, 8 ], [ 3, 8, 13 ], [ 4, 7, 9 ], 
  [ 6, 7, 8, 9, 11 ] ]

gap> STOP_TEST( "testall.tst", 10000 );
## The first argument of STOP_TEST should be the name of the test file.
## The number is a proportionality factor that is used to output a 
## "GAPstone" speed ranking after the file has been completely processed.
## For the files provided with the distribution this scaling is roughly 
## equalized to yield the same numbers as produced by the test file 
## tst/combinat.tst. For package tests, you may leave it unchnaged. 

#############################################################################
##
