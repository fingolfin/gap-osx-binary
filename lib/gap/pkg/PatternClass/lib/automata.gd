#############################################################################
##
##
#W  automata.gd						Ruth Hoffmann
##
##
#Y  Copyright (C) 2004-2015 School of Computer Science, 
#Y                          University of St. Andrews, North Haugh,
#Y                          St. Andrews, Fife KY16 9SS, Scotland
##

################################################################################
##
#F NDIntersectionAutomaton(aut1,aut2)
##
## A faster automata intersection algorithm, which does not turn the automata 
## deterministic.
##
DeclareGlobalFunction( "NDIntersectionAutomaton" );

################################################################################
##
#F NDUnionAutomata(aut1,aut2)
##
## A faster automata union algorithm, which does not turn the automata 
## deterministic.
##
DeclareGlobalFunction( "NDUnionAutomata" );

################################################################################
##
#F NDProductOfLanguages(aut1,aut2)
##
## A faster automata concatenation algorithm, which does not turn the automata 
## deterministic.
##
DeclareGlobalFunction( "NDProductOfLanguages" );

#############################################################################
##
#F  PCMinimalizedAut(A)
##
## Minimalisation algorithm, with no assertions.
##
##
DeclareGlobalFunction( "PCMinimalizedAut" );

DeclareAttribute("PCMinimalAutomaton", IsAutomatonObj);

#############################################################################
##
#F  PCReducedNFA(aut)
##
## Again we got rid of the Assertion
##
DeclareGlobalFunction( "PCReducedNFA" );