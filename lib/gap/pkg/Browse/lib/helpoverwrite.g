#############################################################################
##
#W  helpoverwrite.g       GAP 4 package `Browse'                 Frank Lübeck
##
#Y  Copyright (C) 2006-2007, Lehrstuhl D für Mathematik, RWTH Aachen, Germany
##
##  This file contains a utility for the help system in case several topics
##  match.

# Overwrite a lib function that shows multiple matches of help system
# in pager. We give opportunity to choose a match.


DeclareUserPreference( rec(
    name:= "SelectHelpMatches",
    description:= [
"In the case that the help system finds multiple matches, \
'true' means that the user can choose one entry from the list, \
and 'false' means that the matches are just shown in a pager" ],
    default:= true,
    values:= [ true, false ],
    multi:= false,
    ) );

## reset to false for 'dumb' terminals
if GAPInfo.SystemEnvironment.TERM = "dumb" then
  SetUserPreference("browse", "SelectHelpMatches", false);
fi;

#############################################################################
##
#F  HELP_SHOW_MATCHES( <book>, <topic>, <frombegin> )  . . .  show list of
#F  matches or single match directly
##  
IsFunction(HELP_SHOW_MATCHES);
HELP_SHOW_MATCHES_LIB := HELP_SHOW_MATCHES;
MakeReadWriteGVar("HELP_SHOW_MATCHES");
HELP_SHOW_MATCHES := function( books, topic, frombegin )
  local   exact,  match,  x,  lines,  cnt,  i,  str,  n,  line, j, c;
  
  if UserPreference( "browse", "SelectHelpMatches" ) = false then
    return HELP_SHOW_MATCHES_LIB(books, topic, frombegin);
  fi;

  # first get lists of exact and other matches
  x := HELP_GET_MATCHES( books, topic, frombegin );
  exact := x[1];
  match := x[2];
  
  # no topic found
  if 0 = Length(match) and 0 = Length(exact)  then
    Print( "Help: no matching entry found\n" );
    return false;
    
  # one exact or together one topic found
  elif 1 = Length(exact) or (0 = Length(exact) and 1 = Length(match)) then
    if Length(exact) = 0 then exact := match; fi;
    i := exact[1];
    str := Concatenation("Help: Showing `", i[1].bookname,": ", 
                                               i[1].entries[i[2]][1], "'\n");
    # to avoid line breaking when str contains escape sequences:
    n := 0;
    while n < Length(str) do
      Print(str{[n+1..Minimum(Length(str), 
                                    n + QuoInt(SizeScreen()[1] ,2))]}, "\c");
      n := n + QuoInt(SizeScreen()[1] ,2);
    od;
    HELP_PRINT_MATCH(i);
    return true;

  # more than one topic found, show overview in pager
  else
    lines := [];
##          ["Help: several entries match this topic - type ?2 to get match [2]\n"];
    HELP_LAST.TOPICS:=[];
    cnt := 0;
    # show exact matches first
    match := Concatenation(exact, match);
    for i  in match  do
      cnt := cnt+1;
      topic := Concatenation(i[1].bookname,": ",i[1].entries[i[2]][1]);
      Add(HELP_LAST.TOPICS, i);
      line:= NCurses.AttributeLineFromEscape( topic );
      for j in [ 1 .. Length( line ) ] do
        if IsString( line[j] ) then
          line[j]:= BrowseData.SimplifiedString( line[j] );
        fi;
      od;
      Add( lines, line );
    od;
    NCurses.Select(rec(items := lines, 
         none := true, 
         border := true,
         header := [NCurses.attrs.BOLD, 
           "   Choose an entry to view, 'q' for none (or use ?<nr> later):"],
         hint:= " [ <Up>/<Down> select, <Return> show, q quit ] ",
         onSubmitFunction:= function( r )
             HELP_SHOW_FROM_LAST_TOPICS( r.RESULT );
             return false;
           end,
         ) );
    return true;
  fi;
end;
MakeReadOnlyGVar("HELP_SHOW_MATCHES");
MakeReadOnlyGVar("HELP_SHOW_MATCHES_LIB");

