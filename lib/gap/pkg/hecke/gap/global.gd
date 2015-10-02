#######################################################################
##  Hecke - global.gd : some usefull global functions                ##
##                                                                   ##
##     A GAP package for calculating the decomposition numbers of    ##
##     Hecke algebras of type A (over fields of characteristic       ##
##     zero). The functions provided are primarily combinatorial in  ##
##     nature. Many of the combinatorial tools from the (modular)    ##
##     representation theory of the symmetric groups appear in the   ##
##     package.                                                      ##
##                                                                   ##
##     These programs, and the enclosed libraries, are distributed   ##
##     under the usual licensing agreements and conditions of GAP.   ##
##                                                                   ##
##     Dmitriy Traytel                                               ##
##     (heavily using the GAP3-package SPECHT 2.4 by Andrew Mathas)  ##
##                                                                   ##
#######################################################################

## Hecke 1.0: September 2010:
##   - initial

DeclareOperation("\*",[IsFunction,IsFunction]);
DeclareOperation("FoldLeft",[IsFunction,IsObject,IsList]);
DeclareOperation("FoldAfterMapLeft",[IsFunction,IsFunction,IsObject,IsList]);
DeclareOperation("StringFold",[IsString,IsList]);
DeclareOperation("Zip",[IsList,IsList]);

