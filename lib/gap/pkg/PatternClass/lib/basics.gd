################################################################################
##
##
#W  basics.gd						Michael Albert,
#W                                  Steve Linton,
#W                                  Ruth Hoffmann
##
##
#Y  Copyright (C) 2004-2015 School of Computer Science, 
#Y                          University of St. Andrews, North Haugh,
#Y                          St. Andrews, Fife KY16 9SS, Scotland
##

################################################################################
##
#F PermComplement(perm)
##
## The complement of a permutation [p_1, p_2, ..., p_n] is the permutation 
## [n+1-p_1, n+1-p_2, ... , n+1-p_n] .
## PermComplement calculates the complement of the input permutation which
## has to be input in the non-rank-encoded form.
##
DeclareGlobalFunction( "PermComplement" );

################################################################################
##
#F ComplementAutomaton(aut)
##
## The complement automaton accepts the complement language of aut. In other 
## words it accepts all the complements of the words that are accepted by aut.
##
DeclareGlobalFunction( "ComplementAutomaton" );

################################################################################
##
#F IsRankEncoding(perm)
##
## IsRankEncoding checks whether the inputed list (perm) represents a rank 
## encoded permutation.
##
DeclareGlobalFunction( "IsRankEncoding" );

################################################################################
##
#F IsAcceptedWord(aut,perm)
##
## IsAcceptedWord checks whether the list perm is a permutation output by the 
## the automaton aut. The permutation perm has to be in rank encoding.
##
DeclareGlobalFunction( "IsAcceptedWord" );

