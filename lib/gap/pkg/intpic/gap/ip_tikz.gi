#################
## This function aims to produce tikz code for displaying arrays of integers.
##
## Input: the arguments (at most 3) are: 
#    * a table of integers, or
#    * a range of integers to be disposed in a table whose width is an integer also given as argument (Note that when a range is given it is mandatory to give an integer for the length of each row in the table to be constructed from the range.)
#    and... (although not mandatory)
#    * a record of options. For details on these see the manual
#
#when no range or table is given, the minimum range containing all the elements to be highlighted is taken.
##

  
InstallGlobalFunction(IP_TikzArrayOfIntegers,
function(arg)
  local  opt, rg, tb, flen, i, array, aux, 
         lens, l, r, cat, el, node, h, utable, k, table, 
         tikzstring, floor, nd, string;
  
  opt := StructuralCopy(First(arg, a -> IsRecord(a)));
  rg := StructuralCopy(First(arg, a -> IsHomogeneousList(a) and not IsList(a[1])));
  tb := StructuralCopy(First(arg, a -> IsTable(a)));
  flen := StructuralCopy(First(arg, a -> IsInt(a)));
  
  ## the options ##
  if opt = fail then
    opt := IP_TikzDefaultOptionsForArraysOfIntegers;
  else
    if IsBound(opt.cell_width) then
      opt.allow_adjust_cell_width := "false";
    fi;
    for i in RecNames( IP_TikzDefaultOptionsForArraysOfIntegers ) do
      if not IsBound(opt.(i)) then
        opt.(i) := IP_TikzDefaultOptionsForArraysOfIntegers.(i);
      fi;
    od;
  fi;
  array := opt.highlights;
 
  if rg <> fail then
    if flen = fail then
      #     flen := Length(rg);
      # a compromise to not get too large or too high images
      flen := Minimum(30,Int(40/(LogInt(Maximum(rg),10)+1)));       
    fi;
    #  elif tb <> fail then #201407
    if tb <> fail then
      lens := List(tb,Length); #the lengths of the lists
      if flen = fail then
        flen := Maximum(lens);
      else
        flen := Maximum(Maximum(lens),flen); # 
      fi;
      if flen = Minimum(lens) then #all the lists have the same length, which 
        # coincides with the length given as argument  
        rg := Concatenation(tb);
      else # otherwise, dots (".") are used at the end of the lists in order 
        #to produce a table where all lists have the same length
        aux := [];
        for l in tb do
          Append(aux,l);
          if Length(l) < flen then
            r := flen - Length(l);
            for i in [1..r] do
              Add(aux,".");
            od;
          fi;
        od;
        rg := aux;
      fi;
    fi; #201407

  else #when no list or table is given, the minimum range containing all the elements 
    #to be highlighted is taken.
    cat := Concatenation(array);
    rg := [Minimum(cat)..Maximum(cat)];
    if flen = fail then
      flen := Length(rg);
    fi;
  fi;  
  
  if opt.allow_adjust_cell_width <> "false" then
    aux := Int(opt.allow_adjust_cell_width)*(LogInt(Maximum(Flat(rg)),10)+1);
    opt.cell_width := String(aux);
    # this concrete adjustment of the cell width is a result of various 
    # experiments done
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
    if opt.shape_only <> "false" then
      node[1] := opt.shape_only;
    fi;
    
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
  tikzstring := "%tikz\n\\begin{tikzpicture}[";
  Append(tikzstring,"every node/.style={draw,");
  if opt.scale <> 1 then
    Append(tikzstring,Concatenation("scale=",opt.scale,"pt,\n"));
  fi;
  Append(tikzstring,Concatenation("minimum width=",opt.cell_width,"pt,"));  
  Append(tikzstring,Concatenation("inner sep=",opt.inner_sep,"pt,\n"));
  Append(tikzstring,Concatenation("line width=",opt.line_width,"pt,"));
  Append(tikzstring,Concatenation("draw=",opt.line_color));
  Append(tikzstring,"}]\n");
    
  Append(tikzstring,Concatenation("\\matrix[row sep=",opt.rowsep,"pt,"));
  Append(tikzstring,Concatenation("column sep=",opt.colsep,"pt]\n{"));

  for floor in table do
    for nd in floor do
      Append(tikzstring,"\\node[");
      
      if Length(nd) = 1 then
        Append(tikzstring,"]");
      fi;
      if Length(nd) = 2 then
        Append(tikzstring,"fill=");
        Append(tikzstring,opt.colors[nd[2]]);
        Append(tikzstring,"]");
      fi;
      if Length(nd) = 3 then
        Append(tikzstring,"left color=");
        Append(tikzstring,opt.colors[nd[2]]);
        Append(tikzstring,",right color=");
        Append(tikzstring,opt.colors[nd[3]]);
        Append(tikzstring,"]");
      fi;
      if Length(nd) = 4 then
        Append(tikzstring,"left color=");
        Append(tikzstring,opt.colors[nd[2]]);
        Append(tikzstring,",right color=");
        Append(tikzstring,opt.colors[nd[3]]);
        Append(tikzstring,",middle color=");
        Append(tikzstring,opt.colors[nd[4]]);
        Append(tikzstring,"]");
      fi;
      if Length(nd) = 5 then
        Append(tikzstring,",upper left=");
        Append(tikzstring,opt.colors[nd[2]]);
        Append(tikzstring,",upper right=");
        Append(tikzstring,opt.colors[nd[3]]);
        Append(tikzstring,",lower left=");
        Append(tikzstring,opt.colors[nd[4]]);
        Append(tikzstring,",lower right=");
        Append(tikzstring,opt.colors[nd[5]]);
        Append(tikzstring,"]");
      fi;
      if Length(nd) = 6 then
        Append(tikzstring,",upper left=");
        Append(tikzstring,opt.colors[nd[2]]);
        Append(tikzstring,",upper right=");
        Append(tikzstring,opt.colors[nd[3]]);
        Append(tikzstring,",lower left=");
        Append(tikzstring,opt.colors[nd[4]]);
        Append(tikzstring,",lower right=");
        Append(tikzstring,opt.colors[nd[5]]);
        Append(tikzstring,",text=");
        Append(tikzstring,opt.colors[nd[6]]);
        Append(tikzstring,"]");
      fi;
      if Length(nd) = 7 then
        Append(tikzstring,"upper left=");
        Append(tikzstring,opt.colors[nd[2]]);
        Append(tikzstring,",upper right=");
        Append(tikzstring,opt.colors[nd[3]]);
        Append(tikzstring,",lower left=");
        Append(tikzstring,opt.colors[nd[4]]);
        Append(tikzstring,",lower right=");
        Append(tikzstring,opt.colors[nd[5]]);
        Append(tikzstring,",text=");
        Append(tikzstring,opt.colors[nd[6]]);
        Append(tikzstring,",thick,draw=");
        Append(tikzstring,opt.colors[nd[7]]);
       Append(tikzstring,"]");
      fi;
      if Length(nd) > 7 then
        Append(tikzstring,"upper left=");
        Append(tikzstring,opt.colors[nd[2]]);
        Append(tikzstring,",upper right=");
        Append(tikzstring,opt.colors[nd[3]]);
        Append(tikzstring,",lower left=");
        Append(tikzstring,opt.colors[nd[4]]);
        Append(tikzstring,",lower right=");
        Append(tikzstring,opt.colors[nd[5]]);
        Append(tikzstring,",text=");
        Append(tikzstring,opt.colors[nd[6]]);
        Append(tikzstring,",ultra thick,draw=");
        Append(tikzstring,opt.colors[nd[7]]);
       Append(tikzstring,"]");
      fi;

      Append(tikzstring,Concatenation("{",String(nd[1]),"};&\n"));
    od;
    #remove "&\n"
     Unbind(tikzstring[Length(tikzstring)]);
    Unbind(tikzstring[Length(tikzstring)]);
    Append(tikzstring,"\\\\\n");
  od;
  Append(tikzstring,"};\n");
  
  if IsBound(opt.other) then
    for string in opt.other do
      Append(tikzstring,string);
      Append(tikzstring,"\n");
    od;
  fi;
  
  Append(tikzstring,"\\end{tikzpicture}\n");
  return tikzstring;

end);

#################
# a simplified version for the case a list of integers or a matrix of
# integers is given 
# The length of each level is Maximum(32,Int(Length(rg)/50))
InstallGlobalFunction(IP_SimpleTizkArrayOfIntegers,
function(mat)
  local  rg, len, cat;
  
  if IsTable(mat) then
    cat := Concatenation(mat);
    rg := [Minimum(cat)..Maximum(cat)];
    len := Minimum(30,Int(40/(LogInt(Maximum(rg),10)+1)));
    return IP_TikzArrayOfIntegers(rg,len,rec(highlights:=mat));
   else
    rg := [Minimum(mat)..Maximum(mat)];
    len := Minimum(30,Int(40/(LogInt(Maximum(rg),10)+1)));
    return IP_TikzArrayOfIntegers(rg,len,rec(highlights:=[mat]));
 fi;
end);

