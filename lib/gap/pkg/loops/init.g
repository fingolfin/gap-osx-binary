#############################################################################
##
#A  init.g                  loops                G. P. Nagy / P. Vojtechovsky
##
#H  @(#)$Id: init.g, v 2.2.0 2012/06/28 gap Exp $
##
#Y  Copyright (C)  2004,  G. P. Nagy (University of Szeged, Hungary),  
#Y                        P. Vojtechovsky (University of Denver, USA)
##

#############################################################################
##  BANNER
##  -------------------------------------------------------------------------
ReadPackage("loops", "gap/banner.g");

#############################################################################
##  METHODS FOR ALL QUASIGROUPS AND LOOPS
##  -------------------------------------------------------------------------
ReadPackage( "loops", "gap/quasigroups.gd");    # representing, creating and displaying quasigroups
ReadPackage( "loops", "gap/elements.gd");       # elements and basic arithmetic operations
ReadPackage( "loops", "gap/core_methods.gd");   # most common structural methods
ReadPackage( "loops", "gap/classes.gd");        # testing varieties         
ReadPackage( "loops", "gap/iso.gd");            # isomorphisms and isotopisms
ReadPackage( "loops", "gap/extensions.gd");     # extensions
ReadPackage( "loops", "gap/random.gd");         # random loops
ReadPackage( "loops", "gap/mlt_search.gd");     # realizing groups as multiplication groups of loops

#############################################################################
##  METHODS FOR BOL AND MOUFANG LOOPS
##  -------------------------------------------------------------------------
ReadPackage( "loops", "gap/bol_core_methods.gd");       # most common methods for Bol loops
ReadPackage( "loops", "gap/moufang_triality.gd" );      # triality for Moufang loops
ReadPackage( "loops", "gap/moufang_modifications.gd");  # modifications of Moufang loops

#############################################################################
##  LIBRARIES
##  -------------------------------------------------------------------------
ReadPackage( "loops", "gap/examples.gd");     # libraries

#############################################################################
##  HELP
##  -------------------------------------------------------------------------
ReadPackage( "loops", "etc/HBHforLOOPS.g");   # the handler functions for GAP's help system
