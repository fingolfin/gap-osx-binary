#############################################################################
##
#W  ncurses.gi            GAP 4 package `Browse'                 Frank Lübeck
##
#Y  Copyright (C) 2006-2007, Lehrstuhl D für Mathematik, RWTH Aachen, Germany
##
##  This file implements some lower/middle level functionality of the package:
##  GAP level additions to the record NCurses, utilities for attribute lines
##  and basic applications NCurses.{Pager,Select,Alert}.
##  

##  General utilities using the kernel interface to the ncurses library.

BindGlobal("SplitWithEscapeSequences", function(str)
  local res, i, l, esc, j;
  res := [];
  i := 1;
  l := Length(str);
  esc := CHAR_INT(27);
  while i <= l do
    j := i;
    while j <= l and str[j] <> esc do
      j := j + 1;
    od;
    if j > i then
      Add(res, str{[i..j-1]});
      i := j;
    else
      # escape
      while j <= l and not str[j] in LETTERS do
        j := j + 1;
      od;
      Add(res, str{[i..j]});
      i := j+1;
    fi;
  od;
  return res;
end);


# need all of this only if kernel module was loaded 
if IsBound(NCurses) then


#############################################################################
##
#F  NCurses.IsAttributeLine( <obj> )
##
##  <#GAPDoc Label="IsAttributeLine_man">
##  <ManSection>
##  <Func Name="NCurses.IsAttributeLine" Arg="obj"/>
##
##  <Returns>
##  <K>true</K> if the argument describes a string with attributes.
##  </Returns>
##
##  <Description>
##  An <E>attribute line</E> describes a string with attributes.
##  It is represented by either a string or a dense list of strings,
##  integers, and Booleans immediately following integers,
##  where at least one list entry must <E>not</E> be a string.
##  (The reason is that we want to be able to distinguish between
##  an attribute line and a list of such lines,
##  and that the case of plain strings is perhaps the most usual one,
##  so we do not want to force wrapping each string in a list.)
##  The integers denote attribute values such as color or font information,
##  the Booleans denote that the attribute given by the preceding integer
##  is set or reset.
##  <P/>
##  If an integer is not followed by a Boolean then it is used as the attribute
##  for the following characters, that is it overwrites all previously set
##  attributes. Note that in some applications the variant with explicit 
##  Boolean values is preferable, because such a line can nicely be highlighted
##  just by prepending a <C>NCurses.attrs.STANDOUT</C> attribute.
##  <P/>
##  For an overview of attributes,
##  see&nbsp;<Ref Subsect="ssec:ncursesAttrs"/>.
##  <P/>
##  <Example><![CDATA[
##  gap> NCurses.IsAttributeLine( "abc" );
##  true
##  gap> NCurses.IsAttributeLine( [ "abc", "def" ] );
##  false
##  gap> NCurses.IsAttributeLine( [ NCurses.attrs.UNDERLINE, true, "abc" ] );
##  true
##  gap> NCurses.IsAttributeLine( "" );  NCurses.IsAttributeLine( [] );
##  true
##  false
##  ]]></Example>
##  <P/>
##  The <E>empty string</E> is an attribute line whereas the
##  <E>empty list</E>
##  (which is not in <Ref Func="IsStringRep" BookName="ref"/>)
##  is <E>not</E> an attribute line.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
NCurses.IsAttributeLine :=
     obj -> IsStringRep( obj ) or
            ( IsDenseList( obj ) and
              ForAll( obj, x -> IsStringRep( x ) or IsInt( x )
                                                 or IsBool( x ) ) and
              ForAny( obj, x -> not IsStringRep( x ) ) );


#############################################################################
##
#F  NCurses.SimpleString( <line> )
##
##  For an attribute line <A>line</A>, <C>NCurses.SimpleString</C> returns
##  the string that is obtained by removing the attributes information from
##  <A>line</A>.
##
##  (Should this be documented?)
##
NCurses.SimpleString := function( line )
    if not IsString( line ) then
      line:= Concatenation( Filtered( line, IsString ) );
      if IsEmpty( line ) then
        line:= "";
      fi;
    fi;
    return line;
end;


#############################################################################
##
#F  NCurses.ConcatenationAttributeLines( <lines>[, <keep>] )
##
##  <#GAPDoc Label="ConcatenationAttributeLines_man">
##  <ManSection>
##  <Func Name="NCurses.ConcatenationAttributeLines" Arg="lines[, keep]"/>
##
##  <Returns>
##  an attribute line.
##  </Returns>
##
##  <Description>
##  For a list <A>lines</A> of attribute lines
##  (see <Ref Func="NCurses.IsAttributeLine"/>),
##  <C>NCurses.ConcatenationAttributeLines</C> returns the attribute line
##  obtained by concatenating the attribute lines in <A>lines</A>.
##  <P/>
##  If the optional argument <A>keep</A> is <K>true</K> then attributes set
##  in an entry of <A>lines</A> are valid also for the following entries
##  of <A>lines</A>.
##  Otherwise (in particular if there is no second argument) the attributes
##  are reset to <C>NCurses.attrs.NORMAL</C> between the entries of
##  <A>lines</A>.
##  <Example><![CDATA[
##  gap> plain_str:= "hello";;
##  gap> with_attr:= [ NCurses.attrs.BOLD, "bold" ];;
##  gap> NCurses.ConcatenationAttributeLines( [ plain_str, plain_str ] );
##  "hellohello"
##  gap> NCurses.ConcatenationAttributeLines( [ plain_str, with_attr ] );
##  [ "hello", 2097152, "bold" ]
##  gap> NCurses.ConcatenationAttributeLines( [ with_attr, plain_str ] );
##  [ 2097152, "bold", 0, "hello" ]
##  gap> NCurses.ConcatenationAttributeLines( [ with_attr, with_attr ] );
##  [ 2097152, "bold", 0, 2097152, "bold" ]
##  gap> NCurses.ConcatenationAttributeLines( [ with_attr, with_attr ], true );
##  [ 2097152, "bold", 2097152, "bold" ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
NCurses.ConcatenationAttributeLines := function( arg )
    local lines, keep, result, line, len;

    lines:= arg[1];
    keep:= Length( arg ) = 2 and arg[2] = true;
    result:= "";
    for line in lines do
      if IsString( result ) then
        if IsString( line ) then
          Append( result, line );
        elif result = "" then
          result:= ShallowCopy( line );
        else
          result:= Concatenation( [ result ], line );
        fi;
      elif IsString( line ) then
        if keep then
          len:= Length( result );
          if IsString( result[ len ] ) then
            result[ len ]:= Concatenation( result[ len ], line );
          else
            Add( result, line );
          fi;
        else
          Append( result, [ NCurses.attrs.NORMAL, line ] );
        fi;
      else
        if not keep then
          Add( result, NCurses.attrs.NORMAL );
        fi;
        Append( result, line );
      fi;
    od;

    return result;
end;


#############################################################################
##
#F  NCurses.SublineAttributeLine( <line>, <from>, <len> )
##  
##  For an attribute line <A>line</A> and two positive integers <A>from</A>
##  and <A>len</A>,
##  <C>NCurses.SublineAttributeLine</C> returns the attribute line
##  that starts at the <A>from</A>-th displayed character of <A>line</A>
##  and is <A>len</A> displayed characters long.
##
##  (Should this be documented?)
##
NCurses.SublineAttributeLine:= function( line, from, len )
    local result, entry, elen;
    
    if IsString( line ) then
      result:= line{ [ from .. from + len - 1 ] };
    else
      result:= [];
      for entry in line do
        if IsString( entry ) then
          elen:= Length( entry );
          if elen < from then 
            from:= from - elen;
          else
            if from > 1 then
              entry:= entry{ [ from .. elen ] };
              elen:= elen - from + 1;
              from:= 1;
            fi;
            if elen <= len then
              Add( result, entry );
              len:= len - elen;
            else
              Add( result, entry{ [ 1 .. len ] } );
              len:= 0;
            fi;
          fi;
        else 
          Add( result, entry );
        fi;
      od;
    fi;
    return result;
end;


#############################################################################
##
#F  NCurses.RepeatedAttributeLine( <line>, <width> )
##
##  <#GAPDoc Label="RepeatedAttributeLine_man">
##  <ManSection>
##  <Func Name="NCurses.RepeatedAttributeLine" Arg="line, width"/>
##
##  <Returns>
##  an attribute line.
##  </Returns>
##
##  <Description>
##  For an attribute line <A>line</A>
##  (see <Ref Func="NCurses.IsAttributeLine"/>)
##  and a positive integer <A>width</A>,
##  <C>NCurses.RepeatedAttributeLine</C> returns an attribute line with
##  <A>width</A> displayed characters
##  (see&nbsp;<Ref Func="NCurses.WidthAttributeLine"/>)
##  that is obtained by concatenating sufficiently many copies of <A>line</A>
##  and cutting off a tail if applicable.
##  <P/>
##  <Example><![CDATA[
##  gap> NCurses.RepeatedAttributeLine( "12345", 23 );
##  "12345123451234512345123"
##  gap> NCurses.RepeatedAttributeLine( [ NCurses.attrs.BOLD, "12345" ], 13 );
##  [ 2097152, "12345", 0, 2097152, "12345", 0, 2097152, "123" ]
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
NCurses.RepeatedAttributeLine:= function( line, width )
    local result, len, i;

    if width = 0 then
      return "";
    fi;
    len:= NCurses.WidthAttributeLine( line );
    if len = 0 then
      Error( "cannot get length <width> from empty line" );
    fi;

    if IsString( line ) then
      result:= RepeatedString( line, width );
    else
      result:= [];
      for i in [ 1 .. Int( width / len ) ] do
        Append( result, line );
        Add( result, NCurses.attrs.NORMAL );
      od;
      width:= width mod len;
      if width <> 0 then
        Append( result, NCurses.SublineAttributeLine( line, 1, width ) );
      fi;
    fi;
    return result;
end;


#############################################################################
##

##  For back translation of some Esc sequences to ncurses attributes.
NCurses.AttrEscSeq := 
rec( ("[0m") := NCurses.attrs.NORMAL, 
     ("[22m") := NCurses.attrs.NORMAL, 
     ("[1m") := NCurses.attrs.BOLD, 
     ("[4m") := NCurses.attrs.UNDERLINE, 
     ("[5m") := NCurses.attrs.BLINK, 
     ("[7m") := NCurses.attrs.REVERSE 
);
if NCurses.attrs.has_colors then
  # assume white background, only handle foreground colors
  NCurses.AttrEscSeq.("[30m") := NCurses.attrs.ColorPairs[56+0];
  NCurses.AttrEscSeq.("[31m") := NCurses.attrs.ColorPairs[56+1]; 
  NCurses.AttrEscSeq.("[32m") := NCurses.attrs.ColorPairs[56+2]; 
  NCurses.AttrEscSeq.("[33m") := NCurses.attrs.ColorPairs[56+3]; 
  NCurses.AttrEscSeq.("[34m") := NCurses.attrs.ColorPairs[56+4]; 
  NCurses.AttrEscSeq.("[35m") := NCurses.attrs.ColorPairs[56+5]; 
  NCurses.AttrEscSeq.("[36m") := NCurses.attrs.ColorPairs[56+6]; 
  NCurses.AttrEscSeq.("[37m") := NCurses.attrs.ColorPairs[56+7]; 
else
  # if no colors available then ignore
  NCurses.AttrEscSeq.("[30m") := NCurses.attrs.NORMAL;
  NCurses.AttrEscSeq.("[31m") := NCurses.attrs.NORMAL;
  NCurses.AttrEscSeq.("[32m") := NCurses.attrs.NORMAL;
  NCurses.AttrEscSeq.("[33m") := NCurses.attrs.NORMAL;
  NCurses.AttrEscSeq.("[34m") := NCurses.attrs.NORMAL;
  NCurses.AttrEscSeq.("[35m") := NCurses.attrs.NORMAL;
  NCurses.AttrEscSeq.("[36m") := NCurses.attrs.NORMAL;
  NCurses.AttrEscSeq.("[37m") := NCurses.attrs.NORMAL;
fi;

NCurses.AttributeLineFromEscape := function(str)
  local l, res, a, aa;
  l := SplitWithEscapeSequences(str);
  res := [];
  for a in l do
    if a[1] = '\033' then
      aa := a{[2..Length(a)]};
      if IsBound(NCurses.AttrEscSeq.(aa)) then
        Add(res, NCurses.AttrEscSeq.(aa));
        if NCurses.AttrEscSeq.(aa) <> NCurses.attrs.NORMAL then
          Add(res, true);
        fi;
      else
        Add(res, NCurses.attrs.NORMAL);
      fi;
    else
      Add(res, a);
    fi;
  od;
  return res;
end;

# args: line[, attr]   # default attr is NCurses.attrs.STANDOUT
# puts attr at beginning and after a 0 entry without following boolean
NCurses.StandOutAttributeLine := function(arg)
  local line, attr, res, len, i;
  line := arg[1];
  if Length(arg) > 1 then
    attr := arg[2];
  else
    attr := NCurses.attrs.STANDOUT;
  fi;
  if IsString(line) then
    return [attr, line];
  fi;
  res := [attr];
  len := Length(line);
  for i in [1..len] do
    if line[i] = 0 and i < len and not IsBool(line[i+1]) then
      Append(res, [0, attr]);
    else
      Add(res, line[i]);
    fi;
  od;
  return res;
end;
  
# we change OnBreak to first leave visual mode
OnBreakSavedByBrowse := OnBreak;
OnBreak := function()
# if NCurses.IsStdoutATty() then
  if not NCurses.isendwin() then
    NCurses.endwin();
  fi;
# fi;
  OnBreakSavedByBrowse();
end;
 

##  <#GAPDoc Label="NCurses.SetTerm">
##  <ManSection>
##  <Func Name="NCurses.SetTerm" Arg="[record]"/>
##  
##  <Description>
##  This function provides a unified interface to the various terminal
##  setting  functions of <C>ncurses</C> listed in 
##  <Ref Subsect="ssec:ncursesTermset" />. 
##  The optional argument is a record with components which are assigned to
##  <K>true</K> or <K>false</K>. Recognised components are:
##  <C>cbreak</C>, <C>echo</C>, <C>nl</C>, <C>intrflush</C>, <C>leaveok</C>,
##  <C>scrollok</C>, <C>keypad</C>, <C>raw</C> (with the obvious meaning if
##  set to <K>true</K> or <K>false</K>, respectively).
##  <P/>
##  The default, if no argument is given,  is <C>rec(cbreak := true,
##               echo := false,
##               nl := false,
##               intrflush := false,
##               leaveok := true,
##               scrollok := false,
##               keypad := true)</C>.
##  (This is a useful setting for many applications.) If there is an 
##  argument <Arg>record</Arg>, then the given components overwrite the 
##  corresponding defaults.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  
##  Without argument this sets the terminal to
##  cbreak, noecho, nonl, intrflash to FALSE, leaveok to TRUE, 
##  scrollok to FALSE, keypad to TRUE 
##  Overwrite components with rec(cbreak := true/false, intrflush :=
##  true/false, ...) record as argument.  
NCurses.SetTerm := function(arg)
  local r, c;
  r := rec(cbreak := true,
             echo := false,
             nl := false,
             intrflush := false,
             leaveok := true,
             scrollok := false,
             keypad := true);
  if Length(arg) > 0 then
    for c in NamesOfComponents(arg[1]) do
      r.(c) := arg[1].(c);
    od;
  fi;
  for c in ["cbreak", "echo", "nl"] do
    if IsBound(r.(c)) then
      if r.(c) = true then
        NCurses.(c)();
      else
        NCurses.(Concatenation("no", c))();
      fi;
    fi;
  od;
  for c in ["intrflush", "scrollok", "leaveok", "keypad", "raw"] do
    if IsBound(r.(c)) then
      NCurses.(c)(0, r.(c));
    fi;
  od;
end;

##  args:  handler, data[, setterm]        
##  here 'setterm' is arg for SetTerm, empty rec() by default
NCurses.Loop := function(arg)
  local keybind, data, setterm, fin, c, a, i;
  keybind := List(arg[1], ShallowCopy);
  # normalize keys to lists of integers
  for a in keybind do
    if not IsList(a[1]) then
      a[1] := [a[1]];
    fi;
    for i in [1..Length(a[1])] do
      if IsChar(a[1][i]) then
        a[1][i] := IntChar(a[1][i]);
      fi;
    od;
  od;
  data := arg[2];
  if Length(arg) > 2 then
    setterm := arg[3];
  else
    setterm := rec();
  fi;
  NCurses.werase(0);
  NCurses.savetty();
  NCurses.SetTerm(setterm);
  NCurses.wrefresh(0);
  fin := false;
  while not fin do
    c := NCurses.wgetch(0);
    for a in keybind do
      if c in a[1] then
        fin := a[2](data, c);
      fi;
    od;
    NCurses.wrefresh(0);
  od;
  NCurses.ResetCursor();
  NCurses.resetty();
  NCurses.endwin();
end;

##  A few more utilities:

# call waddnstr with string length as n
NCurses.waddstr := function(win, str)
  return NCurses.waddnstr(win, str, Length(str));
end;

######################################
# Using the mouse:

# names of mouse events in same order as in kernel (but recall that
# positions in kernel are counted from 0)
NCurses.mouseEvents := [ "BUTTON1_PRESSED", "BUTTON1_RELEASED",
"BUTTON1_CLICKED", "BUTTON1_DOUBLE_CLICKED", "BUTTON1_TRIPLE_CLICKED",
"BUTTON2_PRESSED", "BUTTON2_RELEASED", "BUTTON2_CLICKED",
"BUTTON2_DOUBLE_CLICKED", "BUTTON2_TRIPLE_CLICKED", "BUTTON3_PRESSED",
"BUTTON3_RELEASED", "BUTTON3_CLICKED", "BUTTON3_DOUBLE_CLICKED",
"BUTTON3_TRIPLE_CLICKED", "BUTTON4_PRESSED", "BUTTON4_RELEASED",
"BUTTON4_CLICKED", "BUTTON4_DOUBLE_CLICKED", "BUTTON4_TRIPLE_CLICKED",
"BUTTON_SHIFT", "BUTTON_CTRL", "BUTTON_ALT", "REPORT_MOUSE_POSITION",
"BUTTON5_PRESSED", "BUTTON5_RELEASED", "BUTTON5_CLICKED",
"BUTTON5_DOUBLE_CLICKED", "BUTTON5_TRIPLE_CLICKED" ];

##  <#GAPDoc Label="NCurses.Mouse">
##  <ManSection>
##  <Heading>Mouse support in <C>ncurses</C> applications</Heading>
##  <Func Name="NCurses.UseMouse" Arg="on"/>
##  <Returns>a record</Returns>
##  <Func Name="NCurses.GetMouseEvent" Arg=""/>
##  <Returns>a list of records</Returns>
##  <Description>
##  <C>ncurses</C> allows  on some  terminals (<C>xterm</C> and  related) to
##  catch mouse events. In principle a subset of events  can be catched, see
##  <C>mousemask</C>  in <Ref  Subsect="ssec:ncursesMouse"/>. But  this does
##  not seem to  work well with proper subsets of  possible events (probably
##  due to  intermediate processes X, window  manager, terminal application,
##  ...). Therefore  we suggest to  catch either all  or no mouse  events in
##  applications. <P/>
##  
##  This  can  be done  with  <Ref  Func="NCurses.UseMouse"/> with  argument
##  <K>true</K>  to   switch  on  the   recognition  of  mouse   events  and
##  <K>false</K>  to switch  it  off.  The function  returns  a record  with
##  components  <C>.new</C>  and  <C>.old</C>  which are  both  set  to  the
##  status  <K>true</K> or  <K>false</K>  from after  and  before the  call,
##  respectively.  (There does  not  seem to  be a  possibility  to get  the
##  current  status  without  calling  <Ref  Func="NCurses.UseMouse"/>.)  If
##  you  call the  function with  argument <K>true</K>  and the  <C>.new</C>
##  component  of the  result is  <K>false</K>, then  the terminal  does not
##  support mouse events.<P/>
##  
##  When the  recognition of mouse events  is switched on and  a mouse event
##  occurs  then the  key <C>NCurses.keys.MOUSE</C>  is found  in the  input
##  queue, see <C>wgetch</C> in  <Ref Subsect="ssec:ncursesInput"/>. If this
##  key  is read  the  low level  function  <C>NCurses.getmouse</C> must  be
##  called to  fetch further details about  the event from the  input queue,
##  see <Ref Subsect="ssec:ncursesMouse"/>.  In many cases this  can be done
##  by calling  the function <Ref Func="NCurses.GetMouseEvent"/>  which also
##  generates  additional  information.  The  return  value  is  a  list  of
##  records,  one  for  each  panel  over which  the  event  occured,  these
##  panels  sorted from  top to  bottom (so,  often you  will just  need the
##  first  entry if  there is  any). Each  of these  records has  components
##  <C>.win</C>,  the  corresponding  window  of the  panel,  <C>.y</C>  and
##  <C>.x</C>,  the relative  coordinates  in window  <C>.win</C> where  the
##  event occured, and  <C>.event</C>, which is bound to one  of the strings
##  in <C>NCurses.mouseEvents</C> which describes the event. <P/>
##  
##  <Emph>Suggestion:</Emph> Always  make the use  of the mouse  optional in
##  your application. Allow the user to  switch mouse usage on and off while
##  your  application is  running. Some  users may  not like  to give  mouse
##  control  to your  application, for  example the  standard cut  and paste
##  functionality cannot be used while mouse events are catched.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  
NCurses.UseMouse := function(on)
  local res, a;
  if on = true then
    res := NCurses.mousemask([0..29]+0);
  else
    res := NCurses.mousemask([]);
  fi;
  for a in ["new", "old"] do
    if Length(res.(a)) > 0 then
      res.(a) := true;
    else
      res.(a) := false;
    fi;
  od;
  return res;
end;

# Add triples [win, yrel, xrel] to result of NCurses.getmouse for each
# window win below the position [y, x], the windows in top panels coming
# first; yrel, xrel are the coordinates of y, x relative to window win.
NCurses.AddMouseWins := function(mev)
  local res, p, beg;
  res := [];
  p := NCurses.panel_below(0);
  while p <> false do
    if NCurses.wenclose(p, mev[1], mev[2]) then
      beg := NCurses.getbegyx(p);
      Add(res, [p, mev[1] - beg[1], mev[2] - beg[2]]);
    fi;
    p := NCurses.panel_below(p);
  od;
  mev[4] := res;
  return mev;
end;

NCurses.GetMouseEvent := function()
  local raw, res, a;
  # get y,x,eventlist wrt. screen
  raw := NCurses.getmouse();
  # compute the  panel windows under y, x and relative positions
  NCurses.AddMouseWins(raw);
  # make list of records with .win, .y, .x (relative to .win), .event (as name)
  # (in most applications only  the first for the top panel under the 
  # event is needed)
  res := [];
  for a in raw[4] do
    Add(res, rec(win := a[1], y := a[2], x := a[3], 
                 event := NCurses.mouseEvents[raw[3][1]+1]));
  od;
  return res;
end;

##  <#GAPDoc Label="NCurses.SaveRestoreWin">
##  <ManSection>
##  <Func Name="NCurses.SaveWin" Arg="win"/>
##  <Func Name="NCurses.StringsSaveWin" Arg="cont"/>
##  <Func Name="NCurses.RestoreWin" Arg="win, cont"/>
##  <Func Name="NCurses.ShowSaveWin" Arg="cont"/>
##  
##  <Returns>
##  a &GAP; object describing the contents of a window.
##  </Returns>
##
##  <Description>
##  These functions can be used to save and restore the contents of
##  <C>ncurses</C> windows. <Ref Func="NCurses.SaveWin"/> returns a list
##  <C>[nrows, ncols, chars]</C> giving the number of rows, number of
##  columns, and a list of integers describing the content of window 
##  <Arg>win</Arg>. The integers in the latter contain the displayed
##  characters plus  the attributes for the display.
##  <P/>
##  The function <Ref Func="NCurses.StringsSaveWin"/> translates data
##  <Arg>cont</Arg> in  form of the
##  output of <Ref Func="NCurses.SaveWin"/> to a list of <C>nrows</C>
##  strings giving the text of the rows of the saved window, and ignoring 
##  the attributes. You can view the result with <Ref
##  Func="NCurses.Pager"/>.
##  <P/>
##  The argument <Arg>cont</Arg> for <Ref Func="NCurses.RestoreWin"/>
##  must be of the same format as the output of
##  <Ref Func="NCurses.SaveWin"/>.
##  The content of the saved window is copied to the window <Arg>win</Arg>,
##  starting from the top-left corner as much as it fits. 
##  <P/>
##  The utility <Ref Func="NCurses.ShowSaveWin"/> can be used to display the
##  output of <Ref Func="NCurses.SaveWin"/> (as much of the top-left corner as
##  fits on the screen).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
##  NCurses.SaveWin saves the current content of a window. The return value
##  can be used with NCurses.RestoreWin to write the saved content in
##  a window (starting from top-left corner, as much as fits).
NCurses.SaveWin := function(win)
  local res, max, i, j;
  res := [];
  max := NCurses.getmaxyx(win);
  for i in [0..max[1]-1] do
    for j in [0..max[2]-1] do
      NCurses.wmove(win,i,j);
      Add(res, NCurses.winch(win));
    od;
  od;
  Add(max, res);
  return max;
end;
NCurses.StringsSaveWin := function(save)
  return List([1..save[1]], i-> String(List(save[3]{[1..save[2]]+(i-1)*save[2]},
                x-> CHAR_INT(x mod 256))));
end;
NCurses.RestoreWin := function(win, save)
  local max, i, j;
  max := NCurses.getmaxyx(win);
  if max[1] > save[1] then
    max[1] := save[1];
  fi;
  if max[2] > save[2] then
    max[2] := save[2];
  fi;
  for i in [0..max[1]-1] do
    for j in [0..max[2]-1] do
      NCurses.wmove(win,i,j);
      NCurses.waddch(win, save[3][i*save[2]+j+1]);
    od;
  od;
end;
NCurses.ShowSaveWin := function(save)
  local w, p, m;
  w := NCurses.newwin(save[1],save[2],0,0);
  if w = false then
    w := NCurses.newwin(0,0,0,0);
  fi;
  p := NCurses.new_panel(w);
  NCurses.RestoreWin(w, save);
  m := NCurses.curs_set(0);
  NCurses.update_panels();
  NCurses.doupdate();
  NCurses.wgetch(w);
  NCurses.curs_set(m);
  NCurses.endwin();
  NCurses.del_panel(p);
  NCurses.delwin(w);
end;


##  <#GAPDoc Label="NCurses.WBorder">
##  <ManSection >
##  <Func Arg="win[, chars]" Name="NCurses.WBorder" />
##  <Description>
##  This is a convenient interface to the <C>ncurses</C> function 
##  <C>wborder</C>. It draws a border around the window <Arg>win</Arg>. If 
##  no second argument is given the default line drawing characters are 
##  used, see <Ref Subsect="ssec:ncursesLines" />. 
##  Otherwise, <Arg>chars</Arg> must be a list of  &GAP; characters
##  or integers specifying characters, possibly with attributes.
##  If <Arg>chars</Arg> has length 8 the characters are used for the
##  left/right/top/bottom sides and
##  top-left/top-right/bottom-left/bottom-right corners. If <Arg>chars</Arg>
##  contains 2 characters the first is used for the sides and the second for
##  all corners. If <Arg>chars</Arg> contains just one character it is used
##  for all sides including the corners.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  
##  NCurses.wborder needs plain list of characters or integers, we support 
##  a wrapper. Also we allow to give 1 or 2 characters for the lines/corners
##  and expand them to the needed 8 characters.
NCurses.WBorder := function(arg)
  local win, chars;
  win := arg[1];
  if Length(arg) > 1 then
    chars := arg[2];
  else
    chars := true;
  fi;
  # useful for configurable applications
  if chars = false then 
    return true;
  fi;
  if IsStringRep(chars) then
    chars := List(chars, IntChar);
  fi;
  if IsInt(chars) then
    chars := [chars];
  fi;
  if IsList(chars) then
    if Length(chars) = 1 then
      chars := List([1..8], i-> chars[1]);
    elif Length(chars) < 8 then
      chars := Concatenation(List([1..4], i-> chars[1]),
                             List([1..4], i-> chars[2]));
    fi;
  fi;
  return NCurses.wborder(win, chars);
end;


##  <#GAPDoc Label="NCurses.ColorAttr">
##  <ManSection>
##  <Func Name="NCurses.ColorAttr" Arg="fgcolor, bgcolor"/>
##  <Returns>an attribute for setting the foreground and background color 
##  to be used on a terminal window (it is a &GAP; integer).</Returns>
##  <Var Name="NCurses.attrs.has_colors" />
##  <Description>
##  The return value can be used like any other attribute as described in 
##  <Ref Subsect="ssec:ncursesAttrs" />. The arguments <Arg>fgcolor</Arg>
##  and <Arg>bgcolor</Arg> can be given as strings, allowed are those in
##  <C>[ "black", "red", "green", "yellow", "blue", "magenta", 
##  "cyan", "white" ]</C>. These are the default foreground colors 0 to 7 
##  on ANSI terminals. Alternatively, the numbers 0 to 7 can  be used
##  directly as arguments. 
##  <P/>
##  Note that terminals can be configured in a way
##  such that these named colors are not the colors which are actually 
##  displayed.  
##  <P/>
##  The variable <Ref Var="NCurses.attrs.has_colors"/>
##  <Index>colors, availability</Index> is set to <K>true</K> 
##  or <K>false</K> if the terminal supports colors or not, respectively.
##  If a terminal does not support colors then <Ref Func="NCurses.ColorAttr"
##    /> always returns <C>NCurses.attrs.NORMAL</C>.
##  <P/>
##  For an attribute setting the foreground color with the default 
##  background color of the terminal use <C>-1</C> as <Arg>bgcolor</Arg> or
##  the same as <Arg>fgcolor</Arg>.
##  
##  <Example><![CDATA[
##  gap> win := NCurses.newwin(0,0,0,0);; pan := NCurses.new_panel(win);;
##  gap> defc := NCurses.defaultColors;;
##  gap> NCurses.wmove(win, 0, 0);;
##  gap> for a in defc do for b in defc do
##  >      NCurses.wattrset(win, NCurses.ColorAttr(a, b));
##  >      NCurses.waddstr(win, Concatenation(a,"/",b,"\t"));
##  >    od; od;
##  gap> if NCurses.IsStdoutATty() then
##  >      NCurses.update_panels();; NCurses.doupdate();;
##  >      NCurses.napms(5000);;     # show for 5 seconds
##  >      NCurses.endwin();; NCurses.del_panel(pan);; NCurses.delwin(win);;
##  >    fi;
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  get attribute for fg/bg color pair
NCurses.defaultColors := ["black", "red", "green", "yellow",
                          "blue", "magenta", "cyan", "white"];
NCurses.ColorAttr := function(fg, bg)
  local CP;
  if not NCurses.attrs.has_colors then
    return NCurses.attrs.NORMAL;
  else
    CP := NCurses.attrs.ColorPairs;
  fi;
  if IsString(fg) then 
    fg := Position(NCurses.defaultColors, fg);
    if fg=fail then
      fg := 0;
    else
      fg := fg-1;
    fi;
  fi;
  if IsString(bg) then 
    bg := Position(NCurses.defaultColors, bg);
    if bg=fail then
      bg := 7;
    else
      bg := bg-1;
    fi;
  fi;
  if bg = -1 then
    bg := fg;
  fi;
  if bg = 0 and fg = 0 then
    return 0;
  fi;
  if IsBound(CP) and IsBound(CP[bg*8+fg]) then
    return CP[bg*8+fg];
  fi;
  return NCurses.attrs.NORMAL;
end;

# lines with T-ends
NCurses.whlineUTL := function(win, n, type)
  local pos, R, l, r;
  R := NCurses.lineDraw;
  l := rec(U := R.ULCORNER, T := R.LTEE, L := R.LLCORNER);
  r := rec(U := R.URCORNER, T := R.RTEE, L := R.LRCORNER);
  pos := NCurses.getyx(win);
  if pos[2]+n > NCurses.getmaxyx(win)[2] then
    return false;
  fi;
  NCurses.waddch(win, l.(type));
  NCurses.whline(win, 0, n-2);
  NCurses.wmove(win, pos[1], pos[2]+n-1);
  NCurses.waddch(win, r.(type));
  return true;
end;

NCurses.whlineX := function(win, n)
  local pos, max, ch, i;
  pos := NCurses.getyx(win);
  max := NCurses.getmaxyx(win);
  for i in [1..Minimum(n, max[2]-pos[2])] do
    ch := NCurses.winch(win);
    if ch = NCurses.lineDraw.VLINE then
      NCurses.waddch(win, NCurses.lineDraw.PLUS);
    else
      NCurses.waddch(win, NCurses.lineDraw.HLINE);
    fi;
  od;
  NCurses.wmove(win, pos[1], pos[2]);
  return true;
end;

NCurses.wvlineLTR := function(win, n, type)
  local R, pos, u, l;
  R := NCurses.lineDraw;
  u := rec(L := R.ULCORNER, T := R.TTEE, R := R.URCORNER);
  l := rec(L := R.LLCORNER, T := R.BTEE, R := R.LRCORNER);
  pos := NCurses.getyx(win);
  if pos[1]+n > NCurses.getmaxyx(win)[1] then
    return false;
  fi;
  NCurses.waddch(win, u.(type));
  NCurses.wmove(win, pos[1]+1, pos[2]);
  NCurses.wvline(win, 0, n-2);
  NCurses.wmove(win, pos[1]+n-1, pos[2]);
  NCurses.waddch(win, l.(type));
  return true;
end;

NCurses.wvlineX := function(win, n)
  local pos, max, ch, i;
  pos := NCurses.getyx(win);
  max := NCurses.getmaxyx(win);
  for i in [1..Minimum(n, max[1]-pos[1])] do
    ch := NCurses.winch(win);
    if ch = NCurses.lineDraw.HLINE then
      NCurses.waddch(win, NCurses.lineDraw.PLUS);
    else
      NCurses.waddch(win, NCurses.lineDraw.VLINE);
    fi;
    NCurses.wmove(win, pos[1]+i, pos[2]);
  od;
  NCurses.wmove(win, pos[1], pos[2]);
  return true;
end;

##  <#GAPDoc Label="NCurses.Grid">
##  <ManSection >
##  <Func Arg="win, trow, brow, lcol, rcol, rowinds, colinds" 
##  Name="NCurses.Grid" />
##  <Description>
##  This function draws a grid of horizontal and vertical lines on the
##  window <Arg>win</Arg>, using the line drawing characters explained 
##  in <Ref Subsect="ssec:ncursesLines" />. The given arguments specify
##  the top and bottom row of the grid, its left and right column, and 
##  lists of row and column numbers where lines should be drawn. 
##  <Log><![CDATA[
##  gap> fun := function() local win, pan;
##  >      win := NCurses.newwin(0,0,0,0);
##  >      pan := NCurses.new_panel(win);
##  >      NCurses.Grid(win, 2, 11, 5, 22, [5, 6], [13, 14]);
##  >      NCurses.PutLine(win, 12, 0, "Press <Enter> to quit");
##  >      NCurses.update_panels(); NCurses.doupdate();
##  >      NCurses.wgetch(win);
##  >      NCurses.endwin();
##  >      NCurses.del_panel(pan); NCurses.delwin(win);
##  > end;;
##  gap> fun();
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
NCurses.Grid := function(win, trow, brow, lcol, rcol, rowinds, colinds)
  local size, tvis, bvis, ht, lvis, rvis, wdth, ld, lmr, i, j;
  size := NCurses.getmaxyx(win);
  if size = false then return false; fi;
  if not ForAll([trow, brow, lcol, rcol], IsInt) then return false; fi;
  if not ForAll(rowinds, IsInt) then return false; fi;
  if not ForAll(colinds, IsInt) then return false; fi;
  # find viewable rows and cols
  rowinds := Filtered(rowinds, i-> i >= 0 and i >= trow and 
                                   i <= size[1]-1 and i <= brow);
  colinds := Filtered(colinds, i-> i >= 0 and i >= lcol and 
                                   i <= size[2]-1 and i <= rcol);
  tvis := Maximum(trow, 0);
  bvis := Minimum(brow, size[1]);
  ht := bvis - tvis + 1;
  lvis := Maximum(lcol, 0);
  rvis := Minimum(rcol, size[2]);
  wdth := rvis - lvis + 1;
  ld := NCurses.lineDraw;
  # draw vlines
  for i in colinds do
    NCurses.wmove(win, tvis, i);
    NCurses.wvline(win, ld.VLINE, ht);
  od;
  # draw hlines and handle crossings
  for i in rowinds do
    NCurses.wmove(win, i, lvis);
    NCurses.whline(win, ld.HLINE, wdth);
    if i = trow then
      lmr := [ld.ULCORNER, ld.TTEE, ld.URCORNER];
    elif i = brow then
      lmr := [ld.LLCORNER, ld.BTEE, ld.LRCORNER];
    else
      lmr := [ld.LTEE, ld.PLUS, ld.RTEE];
    fi;
    for j in colinds do
      NCurses.wmove(win, i, j);
      if j = lcol then
        NCurses.waddch(win, lmr[1]);
      elif j = rcol then
        NCurses.waddch(win, lmr[3]);
      else
        NCurses.waddch(win, lmr[2]);
      fi;
    od;
  od;
  return true;
end;


##  
##  Here, an 'attribute line' has the following format: it is a list  of GAP
##  integers, Booleans and strings.
##  
##  An integer describes an attribute  for the following terminal characters
##  (e.g., numbers or sums of numbers from NCurses.attrs).
##  
##  If an integer is followed by 'true', this attribute is switched 'on', in
##  addition to the attributes already set.
##  
##  If an integer is followed by  'false', this attribute is switched 'off',
##  the remaining attributes are left as before.
##  
##  Otherwise, the integer   is used as a whole set  of attributes which are
##  'set'.
#T  TB: ``i.e., the current attributes are cleaned and replaced by
#T      the new attribute set'' ?
##  
##  A string is  written to the terminal  as long as it fits  on the current
##  line.
##  
##  As  first  and last  step  the  current  attributes  are always  set  to
##  NCurses.attrs.NORMAL.
##  

##  <#GAPDoc Label="NCurses.WidthAttributeLine">
##  <ManSection>
##  <Func Name="NCurses.WidthAttributeLine" Arg="line"/>
##  <Returns>number of displayed characters in an attribute line.</Returns>
##  <Description>
##  For an attribute line <A>line</A>
##  (see <Ref Func="NCurses.IsAttributeLine"/>),
##  the function returns the number of displayed characters of <A>line</A>.
##  <Index>displayed characters</Index>
##  <P/>
##  <Example><![CDATA[
##  gap> NCurses.WidthAttributeLine( "abcde" );
##  5
##  gap> NCurses.WidthAttributeLine( [ NCurses.attrs.BOLD, "abc",
##  >        NCurses.attrs.NORMAL, "de" ] );
##  5
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
NCurses.WidthAttributeLine := function(lstr)
  local res, a;
  if IsString(lstr) then
    return Length(lstr);
  fi;
  res := 0;
  for a in lstr do
    if IsString(a) then
      res := res + Length(a);
    fi;
  od;
  return res;
end;


##  <#GAPDoc Label="NCurses.PutLine">
##  <ManSection>
##  <Func Name="NCurses.PutLine" Arg="win, y, x, lines[, skip]"/>
##
##  <Returns>
##  <K>true</K> if <A>lines</A> were written, otherwise <K>false</K>.
##  </Returns>
##
##  <Description>
##  The argument <Arg>lines</Arg> can be a list of attribute lines (see 
##  <Ref Func="NCurses.IsAttributeLine" />) or a single attribute line.
##  This function  writes the attribute lines to window 
##  <Arg>win</Arg> at and below of position <Arg>y</Arg>, <Arg>x</Arg>.
##  <P/>
##  If the argument <Arg>skip</Arg> is given, it must be a nonnegative
##  integer. In that
##  case the first <Arg>skip</Arg> characters of each given line are not
##  written to the window (but the attributes are). 
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  
# args:   win, y, x, lstr[, skip]          
NCurses.PutLine := function(arg)
  local win, y, x, lstr, skip, n, max, norm, i, s;
  win := arg[1]; y := arg[2]; x := arg[3]; lstr := arg[4];
  if Length(arg) > 4 then
    skip := arg[5];
  else
    skip := 0;
  fi;
  # handle lstr as string and list of attribute lines
  if IsString(lstr) then
    lstr := [lstr];
  elif IsList(lstr) and ForAll(lstr, NCurses.IsAttributeLine) then
    s := true;
    max := NCurses.getmaxyx(win);
    for i in [1..Length(lstr)] do
      if y+i-1 < max[1] then
        s := s and NCurses.PutLine(win, y+i-1, x, lstr[i], skip);
      fi;
    od;
    return s;
  elif not NCurses.IsAttributeLine(lstr) then
    return false;
  fi;
  # now the work begins
  n := Length(lstr);
  max := NCurses.getmaxyx(win);
  norm := NCurses.attrs.NORMAL;
  # we first reset all attributes
  NCurses.wattrset(win, norm);
  if max = false then return false; fi;
  if not NCurses.wmove(win, y, x) then return false; fi;
  # now we know maximal number of chars to be written
  max := max[2]-x;
  i := 1;
  while i <= n do
    if max <= 0 then break; fi;
    if IsInt(lstr[i]) then
      if i < n and lstr[i+1] = true then
        if not NCurses.wattron(win, lstr[i]) then
          NCurses.wattrset(win, norm);
          return false;
        else
          i := i+2;
        fi;
      elif i < n and lstr[i+1] = false then
        if not NCurses.wattroff(win, lstr[i]) then
          NCurses.wattrset(win, norm);
          return false;
        else
          i := i+2;
        fi;
      else
        if not NCurses.wattrset(win, lstr[i]) then
          NCurses.wattrset(win, norm);
          return false;
        else
          i := i+1;
        fi;
      fi;
    elif IsString(lstr[i]) then
      if not IsStringRep(lstr[i]) then
        # we need a C-string on kernel level
        s := ShallowCopy(lstr[i]);
        ConvertToStringRep(s);
      else
        s := lstr[i];
      fi;
      if skip > 0 then
        if skip > Length(s) then
          skip := skip - Length(s);
          s := "";
        else
          s := s{[skip+1..Length(s)]};
          skip := 0;
        fi;
      fi;
      if Length(s) > max then
        s := s{[1..max]};
      fi;
      if not NCurses.waddstr(win, s) then
        NCurses.wattrset(win, norm);
        return false;
      else
        max := max - Length(s);
        i := i+1;
      fi;
    else
      Error("Non-valid entry in attribute line: ", lstr[i], 
            ", 'return' to ignore.");
      i := i+1;
    fi;
  od;
  NCurses.wattrset(win, norm);
  return true;
end;


##  <#GAPDoc Label="NCurses.GetLineFromUser">
##  <ManSection>
##  <Func Name="NCurses.GetLineFromUser" Arg="pre"/>
##  <Returns>User input as string.</Returns>
##  <Description>
##  This function can be used to get an input string from the user. It opens a
##  one line window and writes the given string <Arg>pre</Arg> into it. Then it
##  waits for user input. After hitting the <B>Return</B> key the typed line is
##  returned as a string to &GAP;.
##  If the user exits via hitting the <B>Esc</B> key instead of hitting
##  the <B>Return</B> key,
##  the function returns <K>false</K>.
##  (The <B>Esc</B> key may be recognized as input only after a delay of about
##  a second.)
##  <P/>
##  Some simple editing is possible during user input: The <B>Left</B>,
##  <B>Right</B>, <B>Home</B> and <B>End</B> keys,
##  the <B>Insert</B>/<B>Replace</B> keys,
##  and the <B>Backspace</B>/<B>Delete</B> keys are supported.
##  <P/>
##  Instead of a string, <A>pre</A> can also be a record with the component
##  <C>prefix</C>, whose value is the string described above.
##  The following optional components of this record are supported.
##  <P/>
##  <List>
##  <Mark><C>window</C></Mark>
##  <Item>
##    The window with the input field is created relative to this window,
##    the default is <M>0</M>.
##  </Item>
##  <Mark><C>begin</C></Mark>
##  <Item>
##    This is a list with the coordinates of the upper left corner of the
##    window with the input field, relative to the window described by the
##    <C>window</C> component; the default is <C>[ y-4, 2 ]</C>,
##    where <C>y</C> is the height of this window.
##  </Item>
##  <Mark><C>default</C></Mark>
##  <Item>
##    This string appears as result when the window is opened,
##    the default is an empty string.
##  </Item>
##  </List>
##  <P/>
##  <Log><![CDATA[
##  gap> str := NCurses.GetLineFromUser("Your Name: ");;
##  gap> Print("Hello ", str, "!\n");
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
# the curses wgetnstr seems strange with respect to left arrow/delete/
# backspace, so we write our own function
NCurses.GetLineFromUser := function( arec )
  local win, res, yx, begin, pan, off, max, pos, ins, c, curs;

  if not IsRecord( arec ) then
    arec:= rec( prefix:= arec );
  fi;
  win:= 0;
  if IsBound( arec.window ) then
    win:= arec.window;
  fi;
  res := "";
  if IsBound( arec.default ) then
    res:= arec.default;
  fi;
  yx := NCurses.getmaxyx( win );
  begin:= [ yx[1]-4, 2 ];
  if IsBound( arec.begin ) then
    begin:= arec.begin;
  fi;
  win := NCurses.newwin( 3, yx[2]-4, begin[1], begin[2] );
  pan := NCurses.new_panel(win);
  off := Length( arec.prefix );
  max := yx[2] - 6 - off;
  pos := 1;
  ins := true;
  NCurses.savetty();
  NCurses.SetTerm();
  # make sure cursor is visible
  curs := NCurses.curs_set(1);
  repeat
    # draw
    NCurses.werase(win);
    NCurses.PutLine(win, 1, 1, [NCurses.attrs.BOLD, arec.prefix,
                    NCurses.attrs.NORMAL, res]);
    NCurses.wborder(win, 0);
    NCurses.wmove(win, 1, off + pos);
    NCurses.update_panels();
    NCurses.doupdate();
    # get character and adjust
    c := NCurses.wgetch(win);
    if c = NCurses.keys.RIGHT then
      if pos <= Length(res) and pos < max then
        pos := pos + 1;
      fi;
    elif c = NCurses.keys.LEFT then
      if pos > 1 then
        pos := pos - 1;
      fi;
    elif c = NCurses.keys.IC then
      ins := not ins;
    elif c = NCurses.keys.REPLACE then
      ins := not ins;
    elif c in [NCurses.keys.HOME, IntChar('')] then
      pos := 1;
    elif c in [NCurses.keys.END, IntChar('')] then
      pos := Length(res) + 1;
      if pos > max then
        pos := pos - 1;
      fi;
    elif c in [NCurses.keys.BACKSPACE, IntChar('')] then
      if pos > 1 then
        pos := pos - 1;
        RemoveElmList(res, pos);
      fi;
    elif c in [NCurses.keys.DC, IntChar('')] then
      if pos <= Length(res) then
        RemoveElmList(res, pos);
      fi;
    elif not c in [ NCurses.keys.ENTER, IntChar(NCurses.CTRL('M')), 27 ] then
      if ins and Length(res) < max then
        InsertElmList(res, pos, CHAR_INT(c mod 256));
        pos := pos + 1;
      elif not ins and pos <= max then
        res[pos] := CHAR_INT(c mod 256);
        pos := pos + 1;
      fi;
    fi;
  until c in [ NCurses.keys.ENTER, IntChar(NCurses.CTRL('M')), 27 ];
  NCurses.del_panel(pan);
  NCurses.delwin(win);
  NCurses.curs_set(curs);
  NCurses.resetty();
  NCurses.endwin();

  if c = 27 then
    res:= false;
  fi;
## If this was called from visual mode, one should now say:  
##    NCurses.update_panels();
##    NCurses.doupdate();
  return res;
end;


#############################################################################
##
#F  NCurses.EditFields( <win>, <arecs> )
##
##  For a list <arecs> of records, allows the user to edit some fields
##  in the window <win>.
##  <TAB> sets the focus to the next field,
##  <RETURN> stops the cycle and transfers the changed values,
##  <ESC> stops the cycle without transfering the changed values.
##
NCurses.EditFields := function( win, arecs )
    local results, i, yx, curs, field, createfield, fillfield, b, helppage,
          arec, res, max, pos, firstvisible, ins, c;

    # Initializations.
    results:= List( arecs, x -> "" );
    for i in [ 1 .. Length( arecs ) ] do
      if not IsRecord( arecs[i] ) then
        arecs[i]:= rec( prefix:= arecs[i], suffix:= "" );
      fi;
      if IsBound( arecs[i].default ) then
        results[i]:= arecs[i].default;
      fi;
    od;
    yx:= NCurses.getmaxyx( win );

    NCurses.savetty();
    NCurses.SetTerm();

    curs:= NCurses.curs_set( 1 );  # make sure cursor is visible

    # Determine the focus.
    field:= PositionProperty( arecs,
                r -> IsBound( r.focus ) and r.focus = true );
    if field = fail then
      field:= 1;
      arecs[1].focus:= true;
    fi;

    # Make all editable fields visible.
    createfield:= function( arec )
      if not IsBound( arec.begin ) then
        arec.begin:= [ yx[1]-4, 2 ];
      fi;
      if not IsBound( arec.nrows ) then
        arec.nrows:= 1;
      fi;
      if not IsBound( arec.ncols ) then
        arec.ncols:= yx[2]-6;
      elif arec.ncols = "fit" then
        arec.ncols:= Length( arec.prefix ) + Length( arec.default )
                                           + Length( arec.suffix );
      fi;

      # Delete the window if it exists already, and create it anew.
      # (Without this, setting the cursor does not work correctly.)
      if IsBound( arec.win ) then
        NCurses.del_panel( arec.pan );
        NCurses.delwin( arec.win );
      fi;
      arec.win:= NCurses.newwin( arec.nrows + 2, arec.ncols + 2,
                                 arec.begin[1], arec.begin[2] );
      arec.pan:= NCurses.new_panel( arec.win );
    end;

    fillfield:= function( arec, res, pos, firstvisible, max, hasfocus )
      local line, showres;

      NCurses.werase( arec.win );

      # Highlight the border of the field if it has the focus.
      if hasfocus then
        NCurses.wattrset( arec.win, NCurses.attrs.BOLD );
        NCurses.wborder( arec.win, 0 );
        NCurses.wattrset( arec.win, NCurses.attrs.NORMAL );
      else
        NCurses.wborder( arec.win, 0 );
      fi;

      # Cut out invisible parts of the string,
      # and enter the current contents.
      showres:= res;
      line:= [ NCurses.attrs.BOLD, arec.prefix, NCurses.attrs.NORMAL ];
      if 1 < firstvisible then
        showres:= res{ [ firstvisible .. Length( res ) ] };
      fi;
      if Length( showres ) <= max then
        Append( line, [ showres, NCurses.attrs.BOLD, arec.suffix ] );
      else
        Append( line, [ showres{ [ 1 .. max ] },
                        NCurses.attrs.BOLD, arec.suffix ] );
      fi;
      NCurses.PutLine( arec.win, 1, 1, line );

      # Show the continuation symbols if applicable.
      if 1 < firstvisible then
        NCurses.wmove( arec.win, 1, Length( arec.prefix ) + 1 );
        NCurses.waddch( arec.win, NCurses.lineDraw.CKBOARD );
      fi;
      if max < Length( showres ) then
        NCurses.wmove( arec.win, 1, arec.ncols );
        NCurses.waddch( arec.win, NCurses.lineDraw.CKBOARD );
      fi;
      NCurses.wmove( arec.win, 1,
                     Length( arec.prefix ) + pos - firstvisible + 1 );
    end;

    for i in [ 1 .. Length( arecs ) ] do
      if i <> field then
        arec:= arecs[i];
        createfield( arec );
        max:= arec.ncols - Length( arec.prefix ) - Length( arec.suffix );
        fillfield( arec, results[i], 1, 1, max, false );
      fi;
    od;
    NCurses.curs_set( 1 );
    arec:= arecs[ field ];
    createfield( arec );
    max:= arec.ncols - Length( arec.prefix ) - Length( arec.suffix );
    fillfield( arec, results[ field ], 1, 1, max, true );

    # Prepare a help menu.
    b:= NCurses.attrs.BOLD;
    helppage:= [
      [b, "<Esc>:"],
      "      quit without submitting values",
      [b, "<Return>:"],
      "      submit the current values",
    ];
    if 1 < Length( arecs ) then
      Append(helppage, [
        [b, "<Tab>:"],
        "      move focus to the next field",
        ] );
    fi;
    Append(helppage, [
      [b, "<Left>:"],
      "      move cursor left",
      [b, "<Right>:"],
      "      move cursor right",
      [b, "<Home>:"],
      "      move cursor to the beginning",
      [b, "<End>:"],
      "      move cursor to the end",
      [b, "<Del>:"],
      "      delete character under cursor",
      [b, "<Backspace>:"],
      "      delete character left from cursor",
      [b, "<Insert>:"],
      "      toggle insertion/overwrite mode",
      [b, "<F1>:"],
      "      show this help",
      ] );

    # Start the loop over the fields.
    while true do

      # Edit this field.
      arec:= arecs[ field ];
      res:= results[ field ];
      max:= arec.ncols - Length( arec.prefix ) - Length( arec.suffix );
      pos:= 1;
      firstvisible:= 1;
      ins:= true;
      createfield( arec );

      while true do
        fillfield( arec, res, pos, firstvisible, max, true );
        NCurses.update_panels();
        NCurses.doupdate();

        # Get a character and adjust the data.
        c:= NCurses.wgetch( arec.win );
        if c = NCurses.keys.RIGHT then
          if pos <= Length( res ) then
            pos:= pos + 1;
            if max < pos - firstvisible + 1 or
               ( max = pos - firstvisible + 1 and pos < Length( res ) ) then
              firstvisible:= firstvisible + 1;
            fi;
          fi;
        elif c = NCurses.keys.LEFT then
          if 1 < pos then
            pos:= pos - 1;
            if pos = firstvisible and 1 < firstvisible then
              firstvisible:= firstvisible - 1;
            fi;
          fi;
        elif c = NCurses.keys.IC then
          ins:= not ins;
        elif c = NCurses.keys.REPLACE then
          ins:= not ins;
        elif c in [ NCurses.keys.HOME, IntChar('') ] then
          pos:= 1;
          firstvisible:= 1;
        elif c in [ NCurses.keys.END, IntChar('') ] then
          pos:= Length( res ) + 1;
          firstvisible:= pos - max + 1;
          if firstvisible < 1 then
            firstvisible:= 1;
          fi;
        elif c in [ NCurses.keys.BACKSPACE, IntChar('') ] then
          if pos > 1 then
            pos:= pos - 1;
            RemoveElmList( res, pos );
            if pos = firstvisible and 1 < firstvisible then
              firstvisible:= firstvisible - 1;
            fi;
          fi;
        elif c in [ NCurses.keys.DC, IntChar('') ] then
          if pos <= Length( res ) then
            RemoveElmList( res, pos );
          fi;
        elif c in [ NCurses.keys.ENTER, IntChar(NCurses.CTRL('M')), 27, 9 ] then
          break;
        elif c in [ NCurses.keys.F1 ] then
          NCurses.Pager(rec( lines := helppage,
              size := [Minimum(NCurses.getmaxyx(0)[1]-2, Length(helppage)+2),
                      Maximum(List(helppage, Length)) + 2],
              begin := [1, 2],
              border := true,
              hint := " [ q to leave help ] ",
              thisishelp := true ));
        else
          if ins then
            InsertElmList( res, pos, CHAR_INT( c mod 256 ) );
            pos:= pos + 1;
            if max < pos - firstvisible + 1 or
               ( max = pos - firstvisible + 1 and pos < Length( res ) ) then
              firstvisible:= firstvisible + 1;
            fi;
          else
            res[pos]:= CHAR_INT( c mod 256 );
            pos:= pos + 1;
            if max < pos - firstvisible + 1 or
               ( max = pos - firstvisible + 1 and pos < Length( res ) ) then
              firstvisible:= firstvisible + 1;
            fi;
          fi;
        fi;
      od;

      results[ field ]:= res;
      if c = 9 then
        # TAB was entered; the focus leaves this window,
        # the window border is no longer highlighted.
        NCurses.wattrset( arec.win, NCurses.attrs.NORMAL );
        NCurses.wborder( arec.win, 0 );

        field:= field + 1;
        if field > Length( arecs ) then
          field:= 1;
        fi;
      else
        break;
      fi;
    od;

    # Clean up.
    for arec in arecs do
      if IsBound( arec.win ) then
        NCurses.del_panel( arec.pan);
        NCurses.delwin( arec.win);
      fi;
    od;
    NCurses.curs_set( curs );
    NCurses.resetty();
    NCurses.endwin();

    # <ESC> was pressed.
    if c = 27 then
      results:= fail;
    fi;

## If this was called from visual mode, one should now say:  
##    NCurses.update_panels();
##    NCurses.doupdate();

    return results;
end;


##  <#GAPDoc Label="NCurses.Pager">
##  <ManSection>
##  <Func Name="NCurses.Pager" Arg="lines[,border[,ly, lx, y, x]]"/>
##  <Description>
##  This is a simple pager utility for displaying and scrolling text.
##  The argument <Arg>lines</Arg> can be a list of attribute lines (see
##  <Ref Func="NCurses.IsAttributeLine"/>) or a string (the lines are
##  separated by newline characters) or a record. In case of a record the 
##  following components are recognized:
##  <P/>
##  <List >
##  <Mark><C>lines</C></Mark>
##  <Item>The list of attribute lines or a string as described above.</Item>
##  <Mark><C>start</C></Mark>
##  <Item>Line number to start the display.</Item>
##  <Mark><C>size</C></Mark>
##  <Item>The size <C>[ly, lx]</C> of the window like the first two arguments
##  of <C>NCurses.newwin</C> (default is <C>[0, 0]</C>, as big as possible).
##  </Item>
##  <Mark><C>begin</C></Mark>
##  <Item>Top-left corner <C>[y, x]</C> of the window like the last two
##  arguments of <C>NCurses.newwin</C>
##  (default is <C>[0, 0]</C>, top-left of the screen).
##  </Item>
##  <Mark><C>attribute</C></Mark>
##  <Item>An attribute used for the display of the window (default is
##  <C>NCurses.attrs.NORMAL</C>).</Item>
##  <Mark><C>border</C></Mark>
##  <Item>Either one of <K>true</K>/<K>false</K> to show the pager window 
##  with or without a standard border. Or it can be string with eight, two 
##  or one characters, giving characters to be used for a border, see
##  <Ref Func="NCurses.WBorder"/>.</Item>
##  <Mark><C>hint</C></Mark>
##  <Item> A text for usage info in the last line of the window.</Item>
##  </List>
##  <P/>
##  As an abbreviation the information from <C>border</C>, <C>size</C> and
##  <C>begin</C> can also be specified in optional arguments.
##  
##  <Log><![CDATA[
##  gap> lines := List([1..100],i-> ["line ",NCurses.attrs.BOLD,String(i)]);;
##  gap> NCurses.Pager(lines);
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  Here 'lines' can be
##        - a list of attribute lines or strings
##        - a single string - it is then split into lines
##        - a record r with component .lines as above
##             r can have more optional components:
##                .start    line number to start display
##                .hint     for usage info in last line of window, default is
##                          "  [q quit, arrows to scroll, h help] "
##                .attribute    a global attribute for the pager window,
##                              default is none
##                .border       true/false for standard borders or not,
##                              or 8 characters for l,r,t,b,tl,tr,bl, br
##                              or 2 characters x,y as shortcut x,x,x,x,y,y,y,y
##                              or 1 character z as shortcut for z, z,
##                              default is false
##                .size         [ly, lx], default 0, 0 (whole screen)
##                .begin        [y, x] top left corner, default [0, 0]
##  
# args:  lines[, border, [ly, lx, y, x] ]
NCurses.Pager := function(arg)
  local r, sout, win, size, pan, off, pos, len, width, skip, nk, 
        ic, max, c, i, helppage, b;
  
  # If we know that there will be no chance to show anything
  # in visual mode then print a warning and give up.
  if GAPInfo.SystemEnvironment.TERM = "dumb" then
    Info( InfoWarning, 1,
    "NCurses.Pager: cannot switch to visual mode because of TERM = \"dumb\"" );
    return fail;
  fi;

  r := arg[1];
  if not IsRecord(r) then
    r := rec( lines := r );
  fi;
  if IsString(r.lines) then
    r.lines := SplitString(r.lines, "\n", "");
  fi;
  if Length(arg) > 1 then
    r.border := arg[2];
  fi;
  if not IsBound(r.border) then
    r.border := false;
  fi;
  if Length(arg) > 5 then
    r.size := [arg[3], arg[4]];
    r.begin := [arg[5], arg[6]];
  fi;
  if not IsBound(r.size) then
    r.size := [0, 0];
  fi;
  if not IsBound(r.begin) then
    r.begin := [0, 0];
  fi;
  sout := NCurses.attrs.STANDOUT;
  if not IsBound(r.hint) then
    r.hint := [sout, " [q quit, arrows to scroll, h help] "];
  fi;
  win := NCurses.newwin(r.size[1], r.size[2], r.begin[1], r.begin[2]);
  if win = false then
    win := NCurses.newwin(r.size[1], r.size[2], 0, 0);
  fi;
  if win = false then
    win := NCurses.newwin(0, 0, 0, 0);
  fi;
  if win = false then
    return false;
  fi;
  if IsBound(r.attribute) then
    NCurses.wbkgdset(win, r.attribute);
  fi;
  size := NCurses.getmaxyx(win);
  pan := NCurses.new_panel(win);
  if r.border <> false then
    off := 1;
  else
    off := 0;
  fi;
  len := Length(r.lines);
  if IsBound(r.start) and r.start <= len then
    pos := r.start;
  else
    pos := 1;
  fi;
  if len = 0 then
    width := 0;
  else
    width := Maximum(List(r.lines, NCurses.WidthAttributeLine));
  fi;
  # skip is the offset for each line it we need to scroll to the right
  skip := 0;
  NCurses.savetty();
  NCurses.SetTerm();
  nk := NCurses.keys;
  ic := IntChar;
  b := NCurses.attrs.BOLD;
  helppage := [
    [b, "'q', <Esc>:"],
    "      quit this pager",
    [b, "<Down>, ' ', 'n', 'd':"],
    "      scroll down one line",
    [b, "<PageDown>, 'N', 'D':"],
    "      scroll down half a page",
    [b, "<Up>, 'p', 'u':"],
    "      scroll up one line",
    [b, "<PageUp>, 'P', 'U':"],
    "      scroll up half a page",
    [b, "<Home>, 'T':"],
    "      goto first (top) line",
    [b, "<End>, 'B', 'G':"],
    "      goto last (bottom) line",
    [b, "<Right>, 'r':"],
    "      scroll right one column",
    [b, "<Left>, 'l':"],
    "      scroll left one column",
    [b, "'0':"],
    "      scroll left to first column",
    [b, "'$':"],
    "      scroll to right most column",
    [b, "'?', <F1>, 'h':"],
    "      show this help"
    ];
  while true do
    # we show lines pos..max
    if len - pos + 1 + off + 1 <= size[1] then
      max := len;
    else
      # reserve one line for " . . ." 
      max := pos + size[1] - off - 3;
    fi;
    NCurses.werase(win);
    for i in [pos..max] do
      if pos > 1 and i = pos then
        NCurses.PutLine(win, off, off, ["   ", sout, "< < <"]);
      else
        NCurses.PutLine(win, off + i - pos, off, r.lines[i], skip);
      fi;
    od;
    if max < len then
      NCurses.PutLine(win, size[1] - 2, off, ["   ", sout, "> > >"]);
    fi;
    NCurses.WBorder(win, r.border);
    NCurses.PutLine(win, size[1] - 1, Maximum(0, QuoInt( size[2] - 
                         NCurses.WidthAttributeLine(r.hint), 2 )), r.hint);
    NCurses.update_panels();
    NCurses.curs_set(0);
    NCurses.doupdate();
    # navigation
    c := NCurses.wgetch(win);
    if c in [ic('q'), 27] then
      break;
    elif c in [nk.UP, ic('u'), ic('p')] then
      if pos > 1 then
        pos := pos - 1;
      fi;
    elif c in [nk.DOWN, ic('d'), ic('n'), ic(' ')] then
      if max < len then
        pos := pos + 1;
      fi;
    elif c in [nk.PPAGE, ic('U'), ic('P')] then
      if pos > 1 then
        pos := pos - QuoInt( size[1]-2, 2 );
        if pos < 1 then
          pos := 1;
        fi;
      fi;
    elif c in [nk.NPAGE, ic('D'), ic('N')] then
      if max < len then
        pos := pos + QuoInt( size[1]-2, 2 );
        if len - pos + 1 + off + 1 <= size[1] then
          pos := len - size[1] + off + 2;
        fi;
      fi;
    elif c in [nk.LEFT, ic('l')] then
      if skip > 0 then
        skip := skip - 1;
      fi;
    elif c in [nk.RIGHT, ic('r')] then
      if skip + size[2] - 2 * off < width then
        skip := skip + 1;
      fi;
    elif c in [ic('0')] then
      skip := 0;
    elif c in [ic('$')] then
      if width > size[2] - 2 * off then
        skip := width + 2 * off - size[2];
      fi;
    elif c in [nk.HOME, ic('T')] then
      pos := 1;
    elif c in [nk.END, ic('B'), ic('G')] then
      pos := len - size[1] + off + 2;
    elif c in [ic('h'), ic('?'), nk.F1] and not IsBound(r.thisishelp) then 
      NCurses.Pager(rec( lines := helppage,
          size := [Minimum(NCurses.getmaxyx(0)[1]-2, Length(helppage)+2),
                  Maximum(List(helppage, Length)) + 2],
          begin := [1, 2],
          border := true,
          hint := " [ q to leave help ] ",
          thisishelp := true ));
    fi;
  od;
  NCurses.ResetCursor();
  NCurses.del_panel(pan);
  NCurses.delwin(win);
  NCurses.resetty();
  NCurses.endwin();
end;

                 
##  <#GAPDoc Label="NCurses.Select">
##  <ManSection>
##  <Func Name="NCurses.Select" Arg="poss[, single[, none]]"/>
##  <Returns>Position or list of positions, or <K>false</K>.</Returns>
##  <Description>
##  <Index Subkey="see NCurses.Select">checkbox</Index>
##  <Index Subkey="see NCurses.Select">radio button</Index>
##  This function allows the user to select one or several items from a
##  given list. In the simplest case <Arg>poss</Arg> is a list of attribute 
##  lines (see <Ref Func="NCurses.IsAttributeLine"/>),
##  each of which should fit on one line. Then <Ref Func="NCurses.Select" /> 
##  displays these lines and lets the user browse through them. After pressing
##  the <B>Return</B> key the index of the highlighted item is returned. 
##  Note that attributes in your lines should be switched on and off separately
##  by <K>true</K>/<K>false</K> entries such that the lines can be nicely
##  highlighted.
##  <P/>
##  The optional argument <Arg>single</Arg> must be <K>true</K> (default)
##  or <K>false</K>. In the second case, an arbitrary number of items can be
##  marked and the function returns the list of their indices.
##  <P/>
##  If <Arg>single</Arg> is <K>true</K> a third argument <Arg>none</Arg> can
##  be given. If it is <K>true</K> then it is possible to leave the selection
##  without choosing an item, in this case <K>false</K> is returned.
##  <P/>
##  More details can be given to the function by giving a record as argument
##  <Arg>poss</Arg>. It can have the following components:
##  <List >
##  <Mark><C>items</C></Mark>
##  <Item>The list of attribute lines as described above.</Item>
##  <Mark><C>single</C></Mark>
##  <Item>Boolean with the same meaning as the optional argument 
##  <Arg>single</Arg>.</Item>
##  <Mark><C>none</C></Mark>
##  <Item>Boolean with the same meaning as the optional argument 
##  <Arg>none</Arg>.</Item>
##  <Mark><C>size</C></Mark>
##  <Item>The size of the window like the first two arguments of 
##  <C>NCurses.newwin</C> (default is <C>[0, 0]</C>, as big as possible),
##  or the string <C>"fit"</C> which means the smallest possible window.
##  </Item>
##  <Mark><C>align</C></Mark>
##  <Item>
##    A substring of <C>"bclt"</C>, which describes the alignment of the
##    window in the terminal.
##    The meaning and the default are the same as for
##    <Ref Func="BrowseData.IsBrowseTableCellData"/>.
##  </Item>
##  <Mark><C>begin</C></Mark>
##  <Item>Top-left corner of the window like the last two arguments of
##  <C>NCurses.newwin</C> (default is <C>[0, 0]</C>, top-left of the screen).
##    This value has priority over the <C>align</C> component.
##  </Item>
##  <Mark><C>attribute</C></Mark>
##  <Item>An attribute used for the display of the window (default is
##  <C>NCurses.attrs.NORMAL</C>).</Item>
##  <Mark><C>border</C></Mark>
##  <Item>
##    If the window should be displayed with a border then set to
##    <K>true</K> (default is <K>false</K>) or to an integer
##    representing attributes such as the components of <C>NCurses.attrs</C>
##    (see Section&nbsp;<Ref Subsect="ssec:ncursesAttrs"/>)
##    or the return value of <Ref Func="NCurses.ColorAttr"/>;
##    these attributes are used for the border of the box.
##    The default is <C>NCurses.attrs.NORMAL</C>.
##  </Item>
##  <Mark><C>header</C></Mark>
##  <Item>An attribute line used as header line (the default depends on 
##  the settings of <C>single</C> and <C>none</C>).</Item>
##  <Mark><C>hint</C></Mark>
##  <Item>An attribute line used as hint in the last line of the window (the 
##  default depends on the settings of <C>single</C> and <C>none</C>).</Item>
##  <Mark><C>onSubmitFunction</C></Mark>
##  <Item>
##    A function that is called when the user submits the selection;
##    the argument for this call is the current value of the record
##    <A>poss</A>.
##    If the function returns <K>true</K> then the selected entries are
##    returned as usual,
##    otherwise the selection window is kept open, waiting for new inputs;
##    if the function returns a nonempty list of attribute lines then
##    these messages are shown using <Ref Func="NCurses.Alert"/>.
##  </Item>
##  </List>
##  <P/>
##  If mouse events are enabled
##  (see <Ref Func="NCurses.UseMouse"/>)<Index>mouse events</Index>
##  then the window can be moved on the screen via mouse events,
##  the focus can be moved to an entry,
##  and (if <C>single</C> is <K>false</K>) the selection of an entry can be
##  toggled.
##  <P/>
##  <Log><![CDATA[
##  gap> index := NCurses.Select(["Apples", "Pears", "Oranges"]);
##  gap> index := NCurses.Select(rec(
##  >                     items := ["Apples", "Pears", "Oranges"],
##  >                     single := false,
##  >                     border := true,
##  >                     begin := [5, 5],
##  >                     size := [8, 60],
##  >                     header := "Choose at least two fruits",
##  >                     attribute := NCurses.ColorAttr("yellow","red"),
##  >                     onSubmitFunction:= function( r )
##  >                       if Length( r.RESULT ) < 2 then
##  >                         return [ "Choose at least two fruits" ];
##  >                       else
##  >                         return true;
##  >                       fi;
##  >                     end ) );
##  ]]></Log>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  
##  r: record with entries
##       .items          list of single line strings to choose from
##       .single         if 'true' (default) one (or none) item is to 
##                       be selected
##       .none           if 'true' a 'q' is allowed to quit without selection
##       .size           window size or "fit"
##       .align          a substring of "bclt"
##       .begin
##       .attribute
##       .border         'false' (default) or 'true' or an integer denoting
##                       attributes of the border
##       .header
##       .hint
##       .onSubmitFunction
##
NCurses.Select_Match:= function( entry, searchstr, case_sensitive, mode,
                                 type, negate )
    local pos, len, pos2;

    # Remove markup if necessary.
    entry:= NCurses.SimpleString( entry );
    if not case_sensitive then
      entry:= LowercaseString( entry );
      searchstr:= LowercaseString( searchstr );
    fi;

    if mode = "substring" then
      pos:= PositionSublist( entry, searchstr );
      if pos <> fail and type = "any substring" then
        return not negate;
      fi;
      len:= Length( entry );
      while pos <> fail do
        if type = "word" then
          pos2:= pos + Length( searchstr ) - 1;
          if ( pos = 1 or entry[ pos-1 ] = ' ' ) and
             ( pos2 = len or
               ( pos2 < len and entry[ pos2+1 ] = ' ' ) ) then
            return not negate;
          fi;
        elif type = "prefix" then
          if pos = 1 or ( pos < len and entry[ pos-1 ] = ' ' ) then
            return not negate;
          fi;
        elif type = "suffix" then
          pos2:= pos + Length( searchstr ) - 1;
          if pos2 = len or
             ( pos2 < len and entry[ pos2 + 1 ] = ' ' ) then
            return not negate;
          fi;
        else
          Error( "not supported as <type>: ", type );
        fi;
        pos:= PositionSublist( entry, searchstr, pos );
      od;
      return negate;
    else
      if   type = "\"=\"" then
        return ( entry = searchstr ) <> negate;
      elif type = "\"<>\"" then
        return ( entry = searchstr ) = negate;
      else
        if   type = "\"<\"" then
          return ( entry < searchstr ) <> negate;
        elif type = "\"<=\"" then
          return ( entry <= searchstr ) <> negate;
        elif type = "\">=\"" then
          return ( entry >= searchstr ) <> negate;
        else # type = "\">\""
          return ( entry > searchstr ) <> negate;
        fi;
      fi;
    fi;
end;

NCurses.Select_SearchPattern:= function( items, string, currpos, incl,
                                         parameters, isvisible )
    local direction, entry, wrap, case, mode, type, negate, n, range2,
          range1, i;

    # Evaluate the search parameters:
    # - forwards (default) or backwards?
    # - wrap around (default) or not?
    # - case sensitive (default) or not?
    # - search for (1) any substring or (2) for whole entries?
    #   - in case (1), search for substring, word, prefix, suffix?
    #   - in case (2), compare via <, <=, =, >=, >, <>?
    # - negated search or not (default)?
    direction:= "forwards";
    for entry in parameters do
      if entry[1] = "search" and entry[2][1] = "forwards" then
        direction:= entry[2][ entry[3] ];
      elif entry[1] = "wrap around" then
        wrap:= ( entry[2][ entry[3] ] = "yes" );
      elif entry[1] = "case sensitive" then
        case:= ( entry[2][ entry[3] ] = "yes" );
      elif entry[1] = "mode" then
        mode:= entry[2][ entry[3] ];
      elif entry[1] = "search for" and mode = "substring" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "compare with" and mode = "whole entry" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "negate" then
        negate:= ( entry[2][ entry[3] ] = "yes" );
      fi;
    od;

    n:= Length( items );
    range2:= [];
    if direction = "forwards" then
      if not incl then
        currpos:= currpos + 1;
        if currpos = n + 1 then
          if wrap then
            currpos:= 1;
          else
            return fail;
          fi;
        fi;
      fi;
      range1:= [ currpos .. n ];
      if wrap then
        range2:= [ 1 .. currpos - 1 ];
      fi;
    else
      if not incl then
        currpos:= currpos - 1;
        if currpos = 0 then
          if wrap then
            currpos:= n;
          else
            return fail;
          fi;
        fi;
      fi;
      range1:= [ currpos, currpos - 1 .. 1 ];
      if wrap then
        range2:= [ n, n - 1 .. currpos + 1 ];
      fi;
    fi;

    for i in range1 do
      if isvisible[i] and
         NCurses.Select_Match( items[i], string, case, mode, type, negate )
        then
        return i;
      fi;
    od;
    for i in range2 do
      if isvisible[i] and
         NCurses.Select_Match( items[i], string, case, mode, type, negate )
        then
        return i;
      fi;
    od;

    return fail;
end;

NCurses.Select_FilterList:= function( items, string, parameters, isvisible )
    local entry, case, mode, type, negate, nrvisible, newisvisible, i;

    # Evaluate the filtering parameters:
    # - case sensitive (default) or not?
    # - search for (1) any substring or (2) for whole entries?
    #   - in case (1), search for substring, word, prefix, suffix?
    #   - in case (2), compare via <, <=, =, >=, >, <>?
    # - negated search or not (default)?
    for entry in parameters do
      if   entry[1] = "case sensitive" then
        case:= ( entry[2][ entry[3] ] = "yes" );
      elif entry[1] = "mode" then
        mode:= entry[2][ entry[3] ];
      elif entry[1] = "search for" and mode = "substring" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "compare with" and mode = "whole entry" then
        type:= entry[2][ entry[3] ];
      elif entry[1] = "negate" then
        negate:= ( entry[2][ entry[3] ] = "yes" );
      fi;
    od;

    nrvisible:= 0;
    newisvisible:= ShallowCopy( isvisible );
    for i in [ 1 .. Length( items ) ] do
      if isvisible[i] then
        if NCurses.Select_Match( items[i], string, case, mode, type, negate )
          then
          nrvisible:= nrvisible + 1;
        else
          newisvisible[i]:= false;
        fi;
      fi;
    od;

    return [ newisvisible, nrvisible ];
end;

#args: r[, single[, none]]
NCurses.Select := function(arg)
  local r, t, labels, len, mwin, winparas, mpan, size, offitems, offitemsv,
        start, b, max, ind, sel, pos, draw, c, a, helppage,
        searchString, searchParameters, filterParameters, isvisible,
        nrvisible, jumpto, digits, buttondown, resetjump, str, pos2, move,
        onsubmit, cand, candlen, i,
        data, event, pressdata, diff, newpos;

  # If we know that there will be no chance to show anything
  # in visual mode then print a warning and give up.
  if GAPInfo.SystemEnvironment.TERM = "dumb" then
    Info( InfoWarning, 1,
    "NCurses.Select: cannot switch to visual mode because of TERM = \"dumb\"" );
    return fail;
  fi;

  r := arg[1];
  if IsList(r) then
    r := rec(items := r);
  else
    r:= ShallowCopy( r );
  fi;
  if Length(arg) > 1 then
    r.single := arg[2];
  fi;
  if not IsBound(r.single) then
    r.single := true;
  fi;
  if Length(arg) > 2 then
    r.none := arg[3];
  fi;
  if not IsBound(r.none) then
    r.none := false;
  fi;
  if not IsBound(r.border) then
    r.border := false;
  fi;
  if IsBound( r.select ) then
    r.select:= Intersection( r.select, [ 1 .. Length( r.items ) ] );
    if r.single then
      if r.select = [] then
        r.select:= [ 1 ];
      else
        r.select:= [ r.select[1] ];
      fi;
    fi;
  elif r.single then
    r.select:= [ 1 ];
  else
    r.select:= [];
  fi;

  # default header and hint
  if not IsBound(r.header) then
    if r.single and r.none then
      t := "Choose one or none item:";
    elif r.single then
      t := "Choose one of these items:";
    else
      t := "Select a subset of these items:";
    fi;
    r.header := [NCurses.attrs.BOLD, t];
  fi;
  if not IsBound(r.hint) then
    if r.single and r.none then
      t := " [ <Up>/<Down> select, <Return> done, q none ] ";
    elif r.single then
      t := " [ <Up>/<Down> select, <Return> done ] ";
    else
      t := " [ <Up>/<Down> move, <Space> (un)select, <Return> done ] ";
    fi;
    r.hint := [NCurses.attrs.BOLD, t];
  fi;
  
  # precompute labels
  if r.single then
    labels := List([1..Length(r.items)], i-> Concatenation("[",
                    String(i), "]"));
    len := Length(labels[Length(labels)]) + 2;
    for a in labels do
      while Length(a) < len do
        Add(a, ' ');
      od;
    od;
  else
    len:= 5;
  fi;

  # window size and alignment
  size:= NCurses.getmaxyx(0);
  if not IsBound(r.size) then
    # maximal possible window size, alignment questions do not arise
    r.size := size;
    if not IsBound(r.begin) then
      r.begin := [0, 0];
    fi;
  else
    if r.size = "fit" then
      r.size:= [ Length( r.items ) + 3,
                 Maximum( NCurses.WidthAttributeLine( r.header ) + 4,
                          NCurses.WidthAttributeLine( r.hint ) + 6,
                          Maximum( List( r.items, Length ) ) + len + 4 ) ];
    fi;

    # The window size cannot be larger than the terminal size.
    # (Scrolling would not work if 'r.size' is too large.)
    if size[1] < r.size[1] then
      r.size:= [ size[1], r.size[2] ];
    fi;
    if size[2] < r.size[2] then
      r.size:= [ r.size[1], size[2] ];
    fi;

    # alignment of the window in the terminal
    if not IsBound(r.begin) then
      r.begin := [0, 0];
      if IsBound( r.align ) then
        if 'c' in r.align then
          # horizontally centered
          r.begin[2]:= QuoInt( size[2] - r.size[2] + 1, 2 );
        elif not 'l' in r.align then
          # default: right aligned
          r.begin[2]:= size[2] - r.size[2];
        fi;
        if 'b' in r.align then
          # bottom aligned
          r.begin[1]:= size[1] - r.size[1];
        elif not 't' in r.align then
          # default: vertically centered
          r.begin[1]:= QuoInt( size[1] - r.size[1] + 1, 2 );
        fi;
      fi;
    fi;

  fi;

  # set standard terminal flags and create window and panel
  NCurses.savetty();
  NCurses.SetTerm();
  mwin := NCurses.newwin(r.size[1], r.size[2], r.begin[1], r.begin[2]);
  winparas:= [ r.size[1], r.size[2], r.begin[1], r.begin[2] ];
  if mwin = false then
    mwin := NCurses.newwin(r.size[1], r.size[2], 0, 0);
    winparas:= [ r.size[1], r.size[2], 0, 0 ];
  fi;
  if mwin = false then
    mwin := NCurses.newwin(0, 0, 0, 0);
    winparas:= [ 0, 0, 0, 0 ];
  fi;
  if mwin = false then
    return fail;
  fi;
  mpan := NCurses.new_panel(mwin);
  if IsBound(r.attribute) then
    NCurses.wbkgdset(mwin, r.attribute);
  fi;
  # offset for viewable items
  offitems := 0;
  offitemsv:= 0;
  # line of first displayed item
  start := 0;
  # number of items that can be displayed
  max:= r.size[1];
  if Length(r.header) > 0 then
    max := max - 1;
    start := start + 1;
  fi;
  if Length(r.hint) > 0 then
    max := max - 1;
  fi;
  if r.border <> false then
    if Length(r.hint) > 0 then
      max := max - 1;
    else
      max := max - 2;
    fi;
    start := start + 1;
  fi;
  # indent of text
  if r.border <> false then
    ind := 1;
  else
    ind := 0;
  fi;
  if not r.single then
    sel := BlistList([1..Length(r.items)], r.select );
  fi;
  # currently active row
  if IsEmpty( r.select ) then
    pos := 1;
  else
    pos:= r.select[1];
  fi;
  # help texts
  b := NCurses.attrs.BOLD;
  if r.single and r.none then
    helppage := [
        [b, "'q', 'Q', <Esc>:"],
        "      quit without selecting an item" ];
  else
    helppage := [];
  fi;
  if r.single then
    Append(helppage, [
    [b, "<Return>:"],
    "      choose focussed item",
    ] );
  else
    Append(helppage, [
    [b, "<Return>:"],
    "      finish selection",
    [b, "<Space>, 'x':"],
    "      (un)select focussed item",
    ] );
  fi;
  Append(helppage, [
    [b, "<Down>, 'd':"],
    "      focus next item",
    [b, "<PageDown>, 'N', 'D':"],
    "      move focus down half a page",
    [b, "<Up>, 'p', 'u':"],
    "      focus previous item",
    [b, "<PageUp>, 'P', 'U':"],
    "      move focus up half a page",
    [b, "<Home>, 'T':"],
    "      goto first item",
    [b, "<End>, 'B', 'G':"],
    "      goto last item",
    [b, "<nr>:"],
    "      goto the item with label <nr>",
    [b, "'/':"],
    "      ask for a search string, and search",
    [b, "'n':"],
    "      search further with the same search string",
    [b, "'f':"],
    "      ask for a filtering string, and filter",
    [b, "'!':"],
    "      reset the filtering",
    [b, "'M':"],
    "      toggle enabling/disabling mouse events",
    [b, "<Mouse1Down>:"],
    "      starting point for moving the window",
    [b, "<Mouse1Up>:"],
    "      end point for moving the window",
    [b, "<Mouse1Click>:"],
    "      move the focus or toggle the selection",
    [b, "<Mouse1DoubleClick>:"],
    "      move the focus and toggle the selection",
    [b, "<F1>, 'h':"],
    "      show this help",
    ] );

  searchString:= "";
  searchParameters:= StructuralCopy( Filtered(
                         BrowseData.defaults.dynamic.searchParameters,
                         l -> not ( "row by row" in l[2] ) ) );
  filterParameters:= StructuralCopy(
                         BrowseData.defaults.dynamic.filterParameters );
  isvisible:= BlistList( [ 1 .. Length( r.items ) ],
                         [ 1 .. Length( r.items ) ] );
  nrvisible:= Length( r.items );
  jumpto:= "[";
  digits:= List( "0123456789", IntChar );

  # the loop to (re)draw the window
  draw := function()
    local ipos, ii, l, i;
    NCurses.werase(mwin);
    if Length(r.header) > 0 then
      NCurses.PutLine(mwin, start-1, ind, r.header);
    fi;
    ipos:= 0;
    for ii in [ offitems + 1 .. Length( r.items ) ] do
      if isvisible[ ii ] then
        ipos:= ipos + 1;
        if max < ipos then
          break;
        fi;
        l := [];
        if ii = pos then
          Add(l, NCurses.attrs.STANDOUT);
        else
          Add(l, NCurses.attrs.NORMAL);
        fi;
        if not r.single then
          if sel[ii] then
            Add(l, "[X]  ");
          else
            Add(l, "[ ]  ");
          fi;
        else
          Add(l, labels[ii]);
        fi;
        if IsString(r.items[ii]) then
          Add(l, r.items[ii]);
        else
          if ii = pos then
            Append(l, NCurses.StandOutAttributeLine(r.items[ii]));
          else
            Append(l, r.items[ii]);
          fi;
        fi;
        NCurses.PutLine(mwin, start + ipos - 1, ind, l);
      fi;
    od;
    if offitemsv > 0 then
      NCurses.wmove(mwin, start, 0);
      NCurses.wclrtoeol(mwin);
      NCurses.PutLine(mwin, start, ind, " < < <");
    fi;
    if offitemsv + max < nrvisible then
      NCurses.wmove(mwin, start + max - 1, 0);
      NCurses.wclrtoeol(mwin);
      NCurses.PutLine(mwin, start + max - 1, ind, " > > >");
    fi;
    if r.border = true then
      NCurses.wborder( mwin, 0 );
    elif IsInt( r.border ) then
      NCurses.wattrset( mwin, r.border );
      NCurses.wborder( mwin, 0 );
      NCurses.wattrset( mwin, NCurses.attrs.NORMAL );
    elif r.border <> false then
      NCurses.WBorder(mwin, r.border);
    fi;
    if Length(r.hint) > 0 then
      NCurses.PutLine(mwin, winparas[1] - 1, Maximum(ind + 1,
                      QuoInt(winparas[2] - 
                      NCurses.WidthAttributeLine(r.hint), 2)), r.hint);
    fi;
  end;

  # move the window via mouse actions
  buttondown:= false;

  while true do
    draw();
    NCurses.curs_set(0);
    NCurses.update_panels();
    NCurses.doupdate();
    resetjump:= true;
    c := NCurses.wgetch(mwin);
    if c in [ IntChar( 'q' ), IntChar( 'Q' ), 27 ]
       and r.single and r.none then
      r.RESULT := false;
      break;
    elif c in [NCurses.keys.DOWN, IntChar('d')] then
      # Move to next visible entry if there is one.
      pos2:= pos + 1;
      while pos2 <= Length( r.items ) and not isvisible[ pos2 ] do
        pos2:= pos2 + 1;
      od;
      if pos2 <= Length( r.items ) then
        pos:= pos2;
      fi;
    elif c in [NCurses.keys.UP, IntChar('p'), IntChar('u')]  then
      # Move to the previous visible entry if there is one.
      pos2:= pos - 1;
      while 0 < pos2 and not isvisible[ pos2 ] do
        pos2:= pos2 - 1;
      od;
      if 0 < pos2 then
        pos:= pos2;
      fi;
    elif c in [NCurses.keys.NPAGE, IntChar('N'), IntChar('D')] then
      # Move half a screen down if possible.
      move:= QuoInt( max+1, 2 );
      pos2:= pos + 1;
      while 0 < move and pos2 <= Length( r.items ) do
        if isvisible[ pos2 ] then
          pos:= pos2;
          move:= move - 1;
        fi;
        pos2:= pos2 + 1;
      od;
      if pos > Length(r.items) then
        pos := Length(r.items);
      fi;
    elif c in [NCurses.keys.PPAGE, IntChar('P'), IntChar('U')] then
      # Move half a screen up if possible.
      move:= QuoInt( max+1, 2 );
      pos2:= pos - 1;
      while 0 < move and 0 < pos2 do
        if isvisible[ pos2 ] then
          pos:= pos2;
          move:= move - 1;
        fi;
        pos2:= pos2 - 1;
      od;
      if  pos < 1 then
        pos := 1;
      fi;
    elif c in [IntChar(' '), IntChar('x')] and not r.single then
      # Toggle the selection at `pos'.
      sel[pos] := not sel[pos];
    elif c in [NCurses.keys.HOME, IntChar('T')] then
      # Move to the first visible entry.
      pos2:= 1;
      while pos2 < pos and not isvisible[ pos2 ] do
        pos2:= pos2 + 1;
      od;
      pos:= pos2;
    elif c in [NCurses.keys.END, IntChar('B'), IntChar('G')] then
      # Move to the last visible entry.
      pos2:= Length( r.items );
      while pos < pos2 and not isvisible[ pos2 ] do
        pos2:= pos2 + 1;
      od;
      pos:= pos2;
    elif c in [NCurses.keys.ENTER, 13] then
      # Submit.
      if r.single then 
        r.RESULT := pos;
      else
        r.RESULT := Filtered([1..Length(sel)], i-> sel[i]);
      fi;
      if IsBound( r.onSubmitFunction ) then
        # Leave the visual mode.
        NCurses.endwin();

        # Call the function.
        onsubmit:= r.onSubmitFunction( r );

        if onsubmit = true then
          # Exit the loop.
          break;
        fi;

        # Re-enter the visual mode.
        NCurses.update_panels();
        NCurses.doupdate();
        NCurses.curs_set( 0 );

        # If the return value is a nonempty string then show it.
        if IsList( onsubmit ) and not IsEmpty( onsubmit )
           and ForAll( onsubmit, NCurses.IsAttributeLine ) then
          NCurses.Alert( onsubmit, 0 );
        fi;
      else
        break;
      fi;
    elif c in [ IntChar( '/' ) ] then 
      str:= BrowseData.GetPatternEditParameters(
                [ NCurses.attrs.BOLD, "enter a search string: " ],
                searchString,
                searchParameters );
      if str <> fail and str <> "" then
        searchString:= str;
        pos2:= NCurses.Select_SearchPattern( r.items, searchString, pos,
                   true, searchParameters, isvisible );
        if pos2 = fail then
          NCurses.Alert( [ "not found:", searchString ], 0,
                         NCurses.attrs.BOLD );
        else
          pos:= pos2;
        fi;
      fi;
    elif c in [ IntChar( 'n' ) ] then 
      if searchString <> "" then
        pos2:= NCurses.Select_SearchPattern( r.items, searchString, pos,
                   false, searchParameters, isvisible );
        if pos2 = fail then
          NCurses.Alert( [ "not found:", searchString ], 0,
                         NCurses.attrs.BOLD );
        else
          pos:= pos2;
        fi;
      fi;
    elif c in [ IntChar( 'f' ) ] then
      str:= BrowseData.GetPatternEditParameters(
                [ NCurses.attrs.BOLD, "enter a search string: " ],
                searchString,
                filterParameters );
      if str <> fail and str <> "" then
        searchString:= str;
        str:= NCurses.Select_FilterList( r.items, searchString,
                                         searchParameters, isvisible );
        if str[2] = 0 then
          NCurses.Alert( [ "not found:", searchString ], 0,
                         NCurses.attrs.BOLD );
        else
          isvisible:= str[1];
          nrvisible:= str[2];
          if not isvisible[ pos ] then
            for pos2 in [ pos + 1 .. Length( r.items ) ] do
              if isvisible[ pos2 ] then
                pos:= pos2;
                break;
              fi;
            od;
          fi;
          if not isvisible[ pos ] then
            for pos2 in [ 1 .. pos ] do
              if isvisible[ pos2 ] then
                pos:= pos2;
                break;
              fi;
            od;
          fi;
        fi;
      fi;
    elif c in [ IntChar( '!' ) ] then
      isvisible:= BlistList( [ 1 .. Length( r.items ) ],
                             [ 1 .. Length( r.items ) ] );
    elif c in digits or c in [NCurses.keys.BACKSPACE, IntChar('')] then
      if c in digits then
        # If the input corresponds to a label in the list
        # then extend the prefix and jump to the first matching line.
        cand:= Concatenation( jumpto, String( Position( digits, c ) - 1 ) );
        candlen:= Length( cand );
      else
        # If the user had entered as least one digit then delete the last digit
        # from the buffer, and jump to the first matching line.
        candlen:= Length( jumpto );
        if 1 < candlen then
          Unbind( jumpto[ candlen ] );
          candlen:= candlen - 1;
        fi;
      fi;
      for i in [ 1 .. Length( r.items ) ] do
        if isvisible[i]
           and candlen <= Length( labels[i] )
           and labels[i]{ [ 1 .. candlen ] } = cand then
          jumpto:= cand;
          pos:= i;
          break;
        fi;
      od;
      resetjump:= false;
    elif c in [ NCurses.keys.F1, IntChar('h') ]
         and not IsBound(r.thisishelp) then 
      NCurses.Pager(rec( lines := helppage,
          size := [Minimum(NCurses.getmaxyx(0)[1]-2, Length(helppage)+2),
                  Maximum(List(helppage, Length)) + 2],
          begin := [1, 2],
          border := true,
          hint := " [ q to leave help ] ",
          thisishelp := true ));
    elif c in [ IntChar( 'M' ) ] then
      # Toggle mouse events.
      data:= NCurses.UseMouse( true );
      if data.old = true or data.new = false then
        data:= NCurses.UseMouse( false );
        NCurses.Alert( [ "mouse events disabled" ], 0, NCurses.attrs.BOLD );
      else
        NCurses.Alert( [ "mouse events enabled" ], 0, NCurses.attrs.BOLD );
      fi;
    elif c = NCurses.keys.MOUSE then
      data:= NCurses.GetMouseEvent();
      if 0 < Length( data ) then
        # There is a indow below the position where the mouse was released.
        # (If not then we cannot move the window.)
        event:= data[1].event;
        if   event = "BUTTON1_PRESSED" and data[1].win = mwin then
          # Store the info where the button was pressed.
          pressdata:= data[ Length( data ) ];
          buttondown:= true;
        elif event = "BUTTON1_RELEASED" and buttondown then
          # Move the window by the difference.
          data:= data[ Length( data ) ];
          winparas[3]:= Maximum( 0, winparas[3] + data.y - pressdata.y );
          winparas[4]:= Maximum( 0, winparas[4] + data.x - pressdata.x );
          NCurses.del_panel( mpan );
          NCurses.delwin( mwin );
          mwin:= CallFuncList( NCurses.newwin, winparas );
          mpan:= NCurses.new_panel( mwin );
          if IsBound( r.attribute ) then
            NCurses.wbkgdset( mwin, r.attribute );
          fi;
          NCurses.update_panels();
          NCurses.doupdate();
          buttondown:= false;
        elif event = "BUTTON1_CLICKED" and data[1].win = mwin then
          # If the button was clicked on an entry then move the focus there.
          # If the focus was already there and if multiple entries can be
          # selected then toggle the selection.
          diff:= data[1].y - start;
          newpos:= diff + offitems + 1;
          if newpos = pos then
            if not r.single then
              # Toggle the selection at `pos'.
              sel[ pos ]:= not sel[ pos ];
            fi;
          elif ( 0 < diff or ( offitemsv = 0 and 0 <= diff ) ) and
               ( diff < max - 1 or ( offitemsv + max >= nrvisible and
                                     diff <= max - 1 ) ) then
            pos:= newpos;
          fi;
        elif event = "BUTTON1_DOUBLE_CLICKED" and data[1].win = mwin then
          # If the button was clicked on an entry then move the focus there,
          # and toggle the selection if multiple entries can be selected.
          diff:= data[1].y - start;
          newpos:= diff + offitems + 1;
          if ( 0 < diff or ( offitemsv = 0 and 0 <= diff ) ) and
             ( diff < max - 1 or ( offitemsv + max >= nrvisible and
                                   diff <= max - 1 ) ) then
            pos:= newpos;
            if not r.single then
              sel[ pos ]:= not sel[ pos ];
            fi;
          fi;
        fi;
      fi;
    fi;
    if resetjump then
      # We have read a non-digit, reset the buffer.
      jumpto:= "[";
    fi;
    # correct offitems, offitemsv if pos not in visible part
    pos2:= Number( [ 1 .. pos ], i -> isvisible[i] );
    if pos2 = 1 then
      offitemsv:= 0;
    elif pos2 <= offitemsv + 1 then
      offitemsv:= pos2 - 2;
    elif pos2 = nrvisible then
      offitemsv:= Maximum(0, nrvisible - max);
    elif pos2 > offitemsv + max - 1 then
      offitemsv:= pos2 - max + 1;
    fi;
    offitems:= PositionNthTrueBlist( isvisible, offitemsv + 1 ) - 1;
  od;
  NCurses.del_panel(mpan);
  NCurses.delwin(mwin);
  NCurses.resetty();
  NCurses.endwin();
  return r.RESULT;
end;

#T NCurses.Select( rec( items:= [ "1", "2", "3" ], size:= [ 4, 70 ] ) );
#T does not work correctly: one cannot see the entry "2"


#############################################################################
##
#F  NCurses.Alert( <messages>, <timeout>[, <attrs>] )
##
##  <#GAPDoc Label="Alert_man">
##  <ManSection>
##  <Func Name="NCurses.Alert" Arg="messages, timeout[, attrs]"/>
##
##  <Returns>
##  the integer corresponding to the character entered, or <K>fail</K>.
##  </Returns>
##
##  <Description>
##  In visual mode, <Ref Func="Print" BookName="ref"/> cannot be used for
##  messages.
##  An alternative is given by <Ref Func="NCurses.Alert"/>.
##  <P/>
##  Let <A>messages</A> be either an attribute line or a nonempty list of
##  attribute lines,
##  and <A>timeout</A> be a nonnegative integer.
##  <Ref Func="NCurses.Alert"/> shows <A>messages</A> in a bordered box
##  in the middle of the screen.
##  <P/>
##  If <A>timeout</A> is zero then the box is closed after any user input,
##  and the integer corresponding to the entered key is returned.
##  If <A>timeout</A> is a positive number <M>n</M>, say,
##  then the box is closed after <M>n</M> milliseconds,
##  and <K>fail</K> is returned.
##  <P/>
##  If <C>timeout</C> is zero and mouse events are enabled 
##  (see <Ref Func="NCurses.UseMouse"/>)<Index>mouse events</Index>
##  then the box can be moved inside the window via mouse events.
##  <P/>
##  If the optional argument <A>attrs</A> is given, it must be an integer
##  representing attributes such as the components of <C>NCurses.attrs</C>
##  (see Section&nbsp;<Ref Subsect="ssec:ncursesAttrs"/>)
##  or the return value of <Ref Func="NCurses.ColorAttr"/>;
##  these attributes are used for the border of the box.
##  The default is <C>NCurses.attrs.NORMAL</C>.
##  <P/>
##  <Example><![CDATA[
##  gap> NCurses.Alert( "Hello world!", 1000 );
##  fail
##  gap> NCurses.Alert( [ "Hello world!",
##  >      [ "Hello ", NCurses.attrs.BOLD, "bold!" ] ], 1500,
##  >      NCurses.ColorAttr( "red", -1 ) + NCurses.attrs.BOLD );
##  fail
##  ]]></Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
NCurses.Alert := function( arg )
    local usage, messages, timeout, attrs, yx, height, width, winposy,
          winposx, buttondown, win, pan, i, result, data, event, pressdata;

    # Get and check the arguments.
    usage:= "usage: NCurses.Alert( <messages>, <timeout>[, <attrs>] )";
    if Length( arg ) < 2 or 3 < Length( arg ) then
      Error( usage );
    fi;
    messages:= arg[1];
    if NCurses.IsAttributeLine( messages ) then
      messages:= [ messages ];
    elif not ( IsList( messages ) and ForAll( messages,
                                              NCurses.IsAttributeLine )
                                  and not IsEmpty( messages ) ) then
      Error( usage );
    fi;

    if GAPInfo.SystemEnvironment.TERM = "dumb" then
      Info( InfoWarning, 1,
      "NCurses.Alert: cannot switch to visual mode because of TERM = \"dumb\"" );
      return fail;
    fi;



    timeout:= arg[2];
    if not ( IsInt( timeout ) and 0 <= timeout ) then
      Error( usage );
    fi;
    attrs:= NCurses.attrs.NORMAL;
    if Length( arg ) = 3 then
      attrs:= arg[3];
      if not IsInt( attrs ) then
        Error( usage );
      fi;
    fi;

    # If output is redirected to a file then exit.
    if not NCurses.IsStdoutATty() then
      return fail;
    fi;

    # Create a window of the right size in the middle of the screen,
    # and fill it with `messages'.
    yx:= NCurses.getmaxyx( 0 );
    height:= Length( messages ) + 2;
    if yx[1] < height then
      height:= yx[1];
    fi;
    width:= Maximum( List( messages, NCurses.WidthAttributeLine ) ) + 2;
    if yx[2] < width then
      width:= yx[2];
    fi;
    winposy:= QuoInt( yx[1] - height, 2 );
    winposx:= QuoInt( yx[2] - width, 2 );
    buttondown:= false;

    repeat
      win:= NCurses.newwin( height, width, winposy, winposx );
      pan:= NCurses.new_panel( win );
      NCurses.savetty();
      NCurses.SetTerm();
      NCurses.curs_set( 0 );
      NCurses.werase( win );
      for i in [ 1 .. Length( messages ) ] do
        NCurses.PutLine( win, i, 1, messages[i] );
      od;
      NCurses.wattrset( win, attrs );
      NCurses.wborder( win, 0 );
      NCurses.wattrset( win, NCurses.attrs.NORMAL );

      # Show the window.
      NCurses.update_panels();
      NCurses.doupdate();

      # Evaluate the criterion for closing the box.
      if timeout = 0 then
        result:= NCurses.wgetch( win );
        if result = NCurses.keys.MOUSE then
          # If the first button is pressed on this window
          # then we expect that the alert box shall be moved.
          # If the first button is released somewhere
          # then we move the alert box by the difference.
          data:= NCurses.GetMouseEvent();
          if 0 < Length( data ) then
            event:= data[1].event;
            if   event = "BUTTON1_PRESSED" and data[1].win = win then
              pressdata:= data[ Length( data ) ];
              buttondown:= true;
            elif event = "BUTTON1_RELEASED" and buttondown then
              data:= data[ Length( data ) ];
              winposy:= Minimum( Maximum( 0, winposy + data.y - pressdata.y ),
                                 yx[1] - height );
              winposx:= Minimum( Maximum( 0, winposx + data.x - pressdata.x ),
                                 yx[2] - width );
              buttondown:= false;
            fi;
          fi;
        fi;
      else
        NCurses.napms( timeout );
        result:= fail;
      fi;

      # Close the box.
      NCurses.del_panel( pan );
      NCurses.delwin( win );
    until result <> NCurses.keys.MOUSE or
          not event in [ "BUTTON1_PRESSED", "BUTTON1_RELEASED" ];
    NCurses.resetty();
    NCurses.endwin();

    # Return the result.
    return result;
end;


#############################################################################
##
#F  NCurses.NumberOfKey()
##
NCurses.NumberOfKey := function()
    return NCurses.Alert( "Please hit a key", 0 );
end;

## useful for small tests, shows win 0 for 2 seconds and then erases everything
NCurses.SC0 := function()
  NCurses.wrefresh(0);
  Sleep(2);
  NCurses.werase(0);
  NCurses.wrefresh(0);
  Sleep(1);
  NCurses.endwin();
end;


fi;

