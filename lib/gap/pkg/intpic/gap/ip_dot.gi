## not optimized nor mantained... for the moment we concentrate our efforts in the corresponding functions that make use of tikz
#################
## This function aims to produce dot code for displaying arrays of integers.
##
## Input: the arguments (at most 4) are: 
#a range or a table of integers,
#an integer (indicating the length of the floors; it is only needed when a range is given as first argument.
#an array of integers (all the elements of each of the lists in the array is highlighted with a different color; in cases of elements that appear in more than one list are highlighted the background an the number -- the colors corresponding to the first two appearences are used) 
#a record of options. For details on these see the default options...
InstallGlobalFunction(IP_DotArrayOfIntegers,
function(arg)
  local  opt, i, array, rg, cat, flen, aux, el, node, h, utable, 
         k, table, dotstring, floor, nd;
  
  opt := First(arg, a -> IsRecord(a));
  if opt = fail then
    opt := DotIP_DefaultOptionsForArraysOfIntegers;
  else
    for i in RecNames( DotIP_DefaultOptionsForArraysOfIntegers ) do
      if not IsBound(opt.(i)) then
         opt.(i) := DotIP_DefaultOptionsForArraysOfIntegers.(i);
      fi;
    od;
  fi;
  array := opt.highlight;
  
  # the integers are put in an ordered list. The length of each floor is saved.
  rg := First(arg, a -> not(IsRecord(a) or IsInt(a)));
  if rg = fail then
    cat := Concatenation(array);
    rg := [Minimum(cat)..Maximum(cat)];
  fi;
  if IsRange(rg) then
    flen := First(arg, a -> IsInt(a));
    if flen = fail then
      flen := Length(rg);
    fi;
  else
    flen := Length(rg[1]);
    rg := Concatenation(rg);
  fi;
  if opt.allow_adjust_cell_width <> "false" then
    aux := Int(opt.allow_adjust_cell_width)*(LogInt(Maximum(rg),10)+1);
    opt.cell_width := String(aux);
    
  fi;
  
    
  
  # process...
  for i in [1..Length(rg)] do
    el := rg[i];
    node := [el];
    for h in [1..Length(array)] do
      if el in array[h] then
        Add(node,h);
      fi;
    od;
    rg[i] := node;
  od;
  utable := [];
  for k in [1..Int(Length(rg)/flen)] do
    Add(utable,rg{[(k-1)*flen+1..k*flen]});
  od;
  if not IsInt(Length(rg)/flen) then
    Add(utable,rg{[Int(Length(rg)/flen)*flen+1..Length(rg)]});
  fi;
  
  table := Reversed(utable);
    
  ##################
  dotstring := "/*dot*/ \n graph IntegersArray {\n ";
  Append(dotstring,Concatenation("label=<<TABLE  border=\"",opt.border,"\""));
  Append(dotstring,Concatenation(" cellborder=\"",opt.cellborder,"\""));
  Append(dotstring,Concatenation(" cellspacing=\"",opt.cellspacing,"\""));
  Append(dotstring,Concatenation(" bgcolor=\"",opt.bgcolor,"\">\n "));
#  Error("..");
  
  for floor in table do
    Append(dotstring,"<TR>\n");
    for nd in floor do
      if Length(nd) = 1 then
        Append(dotstring,Concatenation("<TD width = \"",opt.cell_width,"\">"));
      elif Length(nd) >= 2 then
        Append(dotstring,Concatenation("<TD width = \"",opt.cell_width,"\""));
        Append(dotstring,Concatenation(" bgcolor=\"",opt.colors[nd[2]],"\">"));
      fi;
      if Length(nd) > 2 then
        Append(dotstring,Concatenation("<FONT POINT-SIZE = \"",opt.point_size,"\""));
        Append(dotstring,Concatenation(" color=\"",opt.colors[nd[3]],"\""));
        Append(dotstring,Concatenation(">",String(nd[1]),"</FONT></TD>\n"));
      else
        Append(dotstring,Concatenation("<FONT POINT-SIZE = \"",opt.point_size,"\""));
        Append(dotstring,Concatenation(">",String(nd[1]),"</FONT></TD>\n"));
      fi;
    od; 
    Append(dotstring,"</TR>\n");
  od;
  Append(dotstring,"</TABLE>>\n }");
  return dotstring;
  
end);
