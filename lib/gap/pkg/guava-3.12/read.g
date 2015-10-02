#############################################################################
##
#A  read.g                  GUAVA library                       Reinald Baart
#A                                                         Jasper Cramwinckel
#A                                                            Erik Roijackers
#A                                                                Eric Minkes
#A                                                                 Lea Ruscio
#A                                                               David Joyner
##
##  This file is read by GAP upon startup. It installs all functions of
##  the GUAVA library 
##
#H  @(#)$Id: read.g,v 1.5 2003/02/27 22:45:16 gap Exp $
##
## added read curves.gi 5-2005
## Changed "ReadPkg" to "ReadPackage" as the former is now deprecated 
##   (GAP 4.5.3)  --JEF 21/5/2012
##

#############################################################################
##
#F  Read calls to load all files.  
##
ReadPackage("guava", "lib/util2.gi"); 
ReadPackage("guava", "lib/setup.g");
ReadPackage("guava", "lib/codeword.gi");    
ReadPackage("guava", "lib/codegen.gi");
ReadPackage("guava", "lib/matrices.gi");
ReadPackage("guava", "lib/nordrob.gi");
ReadPackage("guava", "lib/util.gi"); 
ReadPackage("guava", "lib/curves.gi"); 
ReadPackage("guava", "lib/codeops.gi"); 
ReadPackage("guava", "lib/bounds.gi"); 
ReadPackage("guava", "lib/codefun.gi"); 
ReadPackage("guava", "lib/codeman.gi"); 
ReadPackage("guava", "lib/codecr.gi");
ReadPackage("guava", "lib/codecstr.gi");
ReadPackage("guava", "lib/codemisc.gi");
ReadPackage("guava", "lib/codenorm.gi");
ReadPackage("guava", "lib/decoders.gi"); 
ReadPackage("guava", "lib/tblgener.gi"); 
ReadPackage("guava", "lib/toric.gi"); 

