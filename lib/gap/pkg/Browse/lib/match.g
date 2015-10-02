
# admit wildcards for all group names in the interface functions!
# (means that each such pattern will be replaced by the list of all
# group names that match, and then `DuplicateFreeList' is called;
# problem: when alternative names are supported then do we have to replace
# them by standard names, in order to get no *group* twice?

#T case sensitive/insensitive search?
IsMatchingString:= function( string, pattern )
local one, any, clean, addany, i, s, p, pp, pp2, pos;

one:= '?';
any:= '*';

# Normalize the pattern: ** -> *, *? -> ?*
# (So a * must be followed by a proper character!)
clean:= "";
addany:= false;
i:= 1;
while i <= Length( pattern ) do
  if pattern[i] = any then
    if i < Length( pattern ) then
      if   pattern[ i+1 ] = one then
        addany:= true;
        Add( clean, one );
        i:= i+1;
      elif pattern[ i+1 ] <> any then
        Add( clean, any );
      fi;
      i:= i+1;
    else
      Add( clean, any );
      i:= i+1;
    fi;
  else
    if addany then
      addany:= false;
      Add( clean, any );
    fi;
    Add( clean, pattern[i] );
    i:= i+1;
  fi;
od;
if addany then
  Add( clean, any );
fi;
pattern:= clean;

s:= 1;
p:= 1;
while p <= Length( pattern ) do
  if pattern[p] = one then
    # Any character matches.
    if s > Length( string ) then
      return false;
    fi;
    p:= p + 1;
    s:= s + 1;
  elif pattern[p] = any then
    # An arbitrary substring matches.
    if p = Length( pattern ) then
      return true;
    fi;
    # There is at least one explicit string in the pattern.
    pp:= p+1;
    pp2:= pp+1;
    while pp2 <= Length( pattern ) and not pattern[ pp2 ] in [ one, any ] do
      pp2:= pp2+1;
    od;
    # now the segment is in pp .. pp2-1
    pos:= PositionSublist( string, pattern{ [ pp ..pp2-1 ] }, s-1 );
    while pos <> fail do
      if IsMatchingString( string{ [ pos .. Length( string ) ] },
                           pattern{ [ pp .. Length( pattern ) ] } ) then
        return true;
      fi;
      pos:= PositionSublist( string, pattern{ [ pp ..pp2-1 ] }, pos );
    od;
    return false;
  else
    # The current characters must coincide if there is a matching.
    if s > Length( string ) or string[ s ] <> pattern[ p ] then
      return false;
    fi;
    p:= p + 1;
    s:= s + 1;
  fi;
od;

return s > Length( string );
end;;


test:= function()
  return ForAll( [ "M12", "*M12", "M12*", "*M12*", "M1*2",
                   "M1?", "?12", "M?2" ],
                 pattern -> IsMatchingString( "M12", pattern ) ) and
         ForAll( [ "?M12", "M12?" ],
                 pattern -> not IsMatchingString( "M12", pattern ) );
end;;

