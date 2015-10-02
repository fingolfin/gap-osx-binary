############################################################################
##
#W  moufang_modifications.gd  Moufang modifications [loops]
##  
#H  @(#)$Id: moufang_modifications.gd, v 2.0.0 2008/01/21 gap Exp $
##  
#Y  Copyright (C)  2004,  G. P. Nagy (University of Szeged, Hungary),  
#Y                        P. Vojtechovsky (University of Denver, USA)
##

#############################################################################
##  LOOPS M(G,2)
##  -------------------------------------------------------------------------
DeclareGlobalFunction( "LoopMG2", IsGroup );

#############################################################################
##  CYCLIC MODIFICATION
##  -------------------------------------------------------------------------
DeclareGlobalFunction( "LoopByCyclicModification" );

#############################################################################
##  DIHEDRAL MODIFICATION
##  -------------------------------------------------------------------------
DeclareGlobalFunction( "LoopByDihedralModification" );
