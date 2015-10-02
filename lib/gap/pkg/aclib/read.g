#############################################################################
##
#W    read.g                    share package                   Karel Dekimpe
#W                                                               Bettina Eick
##

# In GAP 4.4, the function IsPackageMarkedForLoading is not available.
if not IsBound( IsPackageMarkedForLoading ) then
  IsPackageMarkedForLoading:= function( arg )
    return CallFuncList( LoadPackage, arg ) = true;
  end;
fi;

# read matrix groups 
ReadPackage( "aclib", "gap/matgrp3.gi" );
ReadPackage( "aclib", "gap/matgrp4.gi" );
ReadPackage( "aclib", "gap/matgrp.gi" );

# read corresponding pcp groups - only if polycyclic is installed
if IsPackageMarkedForLoading( "polycyclic", "1.0" ) then 
    ReadPackage( "aclib", "gap/pcpgrp3.gi" );
    ReadPackage( "aclib", "gap/pcpgrp4.gi" );
    ReadPackage( "aclib", "gap/pcpgrp.gi" );

    ReadPackage( "aclib", "gap/betti.gi" );
    ReadPackage( "aclib", "gap/union.gi" );
    ReadPackage( "aclib", "gap/extend.gi" );
else
    Print("#I The polycyclic package is not installed \n");
    Print("#I Cannot load pc group functionality \n");
fi;

# read some help functions to work with crystallographic groups
if IsPackageMarkedForLoading( "crystcat", "1.1" ) then
    ReadPackage( "aclib", "gap/crystgrp.gi" );
else
    Print("#I The crystcat package is not installed \n");
    Print("#I Cannot load crystallographic groups functionality \n");
fi;

