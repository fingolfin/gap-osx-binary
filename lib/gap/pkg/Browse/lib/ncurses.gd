#############################################################################
##
#W  ncurses.gd            GAP 4 package `Browse'                 Frank Lübeck
##
#Y  Copyright (C) 2006-2007, Lehrstuhl D für Mathematik, RWTH Aachen, Germany
##
##  Note that the kernel has generated the record 'NCurses'.
##  

NCurses.CTRL := function(c) return CharInt(IntChar(c) mod 32); end;

