###############################################################################
##
#F MakeMutableCopyListPPP.gi  The SymbCompCC package    Dörte Feichtenschlager
##

###############################################################################
##
#M MakeMutableCopyListPPP( list )
##
## Input: a list
##
## Output: a mutable copy of list
##
InstallMethod( MakeMutableCopyListPPP, [IsList], 
   function( list )
      local i, new_list;

      ## initialize
      new_list := [];

      ## copy recursively
      for i in [1..Length( list )] do
         if IsList( list[i] ) then 
            new_list[i] := MakeMutableCopyListPPP( list[i] );
         else new_list[i] := list[i];
         fi;
      od;

      return new_list;
   end);

#E MakeMutableCopyListPPP.gi . . . . . . . . . . . . . . . . . . . .  ends here
