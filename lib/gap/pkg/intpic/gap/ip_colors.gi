#############################################################################
##
#F PickElementsFromList
##
#input: source is a list; n is the number of elements to be picked
#the distance between the elements picked is aproximately the number of
#remaining elements by the number of deserts.
#the first element is always picked.
#############################################################################
InstallGlobalFunction(PickElementsFromList,
function(source,n)
  local  s, list, gaplen, idx, i;
  
  s := Length(source);
  
  if n >= s then
    list := Concatenation(source,source);
    while Length(list)<n do
      list := Concatenation(list,source);
    od;
    return list{[1..n]};
  fi;
  
  gaplen := Int((s-n)/(n-1)); #the distance from an index to the following one used
  
  idx := 1;
  list := [source[idx]];
  
  for i in [1..n-1] do
    idx := idx+1+gaplen;
    Add(list,source[idx]);
  od;
  return list;
end);
########
#############################################################################
##
#F PickSublistsFromListOfLists
#############################################################################
InstallGlobalFunction(PickSublistsFromListOfLists,
        function(mat,list)
  
  return List([1..Length(mat)], ll -> PickElementsFromList(mat[ll],list[ll]));
end);

#########
#############################################################################
##
#F IP_ColorsByTones
## the input is either a list of tones or are tones
#############################################################################
# InstallGlobalFunction(IP_ColorsByTones,
#         function(arg)
#   local  tons, admissible, diff, tones, colors, tone;
#   if IsString(arg[1]) then
#     tons := Filtered(arg, t->IsString(t));
#   elif IsString(arg[1][1]) then
#     tons := arg[1];
#   fi;
  
#   admissible := RecNames(RecordOfColorsForIP_);
# #  admissible := ["Reds","rEDS","Greens","gREENS","Blues","bLUES","DGrays","LGrays"];
#   diff := Difference(tons,admissible);
#   if diff <> [] then
#     Print(" the strings ", diff, " does not correspond to lists of colors \n");
#     Print("and will be ignored.\n");
#   fi;
#   if tons = [] then
#     tones := admissible;
#   else
#     tones := tons;
#   fi;
#   colors := [];
  
#   for tone in tones do
#     if tone = "Reds" then 
#       Add(colors,RecordOfColorsForIP_.Reds);
#     fi;
#     if tone = "rEDS" then 
#       Add(colors,RecordOfColorsForIP_.rEDS);
#     fi;
#     if tone = "Greens" then 
#       Add(colors,RecordOfColorsForIP_.Greens);
#     fi;
#     if tone = "gREENS" then 
#       Add(colors,RecordOfColorsForIP_.gREENS);
#     fi;
#     if tone = "Blues" then 
#       Add(colors,RecordOfColorsForIP_.Blues);
#     fi;
#     if tone = "bLUES" then 
#       Add(colors,RecordOfColorsForIP_.bLUES);
#     fi;
#     if tone = "DGrays" then 
#       Add(colors,RecordOfColorsForIP_.DGrays);
#     fi;
#     if tone = "LGrays" then
#        Add(colors,RecordOfColorsForIP_.LGrays);
#     fi;
#   od;
#   return colors;
  
# end);


########
#############################################################################
##
#F IP_ColorsForOneImage
# this function has as input a list of tones (from the list
# RecNames(RecordOfColorsForIP_);
# ["Reds","rEDS","Greens","gREENS","Blues","bLUES","DGrays","LGrays"]) 
# and a number (which is the number of colors to be used) 
# -- the tones list is optional: if it is not
# present, all colors are used. 
# -- the number is optional too: when not present,
# the colors used are all the colors of the selected tones.
# For each tone there is a list of *5* colors
#
#############################################################################

# InstallGlobalFunction(IP_ColorsForOneImage,
#         function(arg)
#   local  tones, admissible, diff, num_tones, mat, n, num_available_colors, 
#          num_per_tone;

#   tones := Filtered(arg, t->IsString(t));
#   admissible := RecNames(RecordOfColorsForIP_);
#    if tones = fail then
#     tones := admissible;
#   else
#     diff := Difference(tones,admissible);
#     if diff <> [] then
#       Print(" the strings ", diff, " does not correspond to lists of colors \n");
#       Print("and will be ignored.\n");
#       tones := Difference(tones,diff);
#     fi;
#   fi;
#   num_tones := Length(tones);
#   mat := IP_ColorsByTones(tones);
#   n := First(arg, t->IsInt(t));
#   if n = fail then
#     n := num_tones*IP_TonesLength;
#   fi;
#   num_available_colors := num_tones*IP_TonesLength;
#   if num_available_colors > n then
#     if IsInt(n/num_tones) then
#       num_per_tone := List([1..num_tones],i->n/num_tones);
#     else
#       num_per_tone := List([1..num_tones],i->Int(n/num_tones)+1);
#     fi;
#   fi;

#   return PickSublistsFromListOfLists(mat,num_per_tone);
# end);

#
#############################################################################
##
#F ShuffleIP_Colors
#############################################################################
InstallGlobalFunction(ShuffleIP_Colors,
        function(mat)
  return Concatenation(TransposedMat(mat));
end);


