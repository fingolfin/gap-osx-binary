#############################################################################
##
#W    read.g                 The SglPPow package              
##

#############################################################################
##
#R  Read the install files.
##

# needed global var's
SMALL_GROUP_LIB_P7 := [];
SMALL_GROUP_NUM_P7 := [];
layer_3hoch8 := false;
layer_phoch7 := false;
pos_3hoch8 := false;
pos_phoch7 := false;

ReadPackage( "sglppow", "lib/3hoch8/sgl-6561.g" ); 

#LPR := RequirePackage("liepring");
#LR := RequirePackage("liering");
#if LPR=true and LR=true then 
#    ReadPackage( "sglppow", "lib/phoch7/sgl-p7.g" ); 
#fi;

if IsPackageMarkedForLoading( "LieRing", "2.2" ) and
   IsPackageMarkedForLoading( "LiePRing", "1.8" ) then
  ReadPackage( "sglppow", "lib/phoch7/sgl-p7.g" ); 
fi;


#E  read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here

