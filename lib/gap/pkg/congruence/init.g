#############################################################################
##
#W init.g                  The Congruence package                   Ann Dooms
#W                                                               Eric Jespers
#W                                                        Alexander Konovalov
#W                                                             Helena Verrill
##
##
#############################################################################

# read Congruence declarations
ReadPackage( "congruence/lib/cong.gd" );
ReadPackage( "congruence/lib/farey.gd" );

# read the other part of code
ReadPackage( "congruence/lib/cong.g" );
ReadPackage( "congruence/lib/buildman.g" );
ReadPackage( "congruence/lib/factor.g" );

# set the default InfoLevel
SetInfoLevel( InfoCongruence, 1 );