#The idea in what concerns the colors is the following: the reader is free to
#choose his colors (the latex xcolor package is used), but we try to make users
#life reasonably easy. He is allowed to choose tones. The default colors are not
#many, although (from our experience) sufficient for most examples. The reason
#for being few is that we do not want to get confused with the
#colors. Furthermore, when only a few of the available colors are used the
#colors choosen are quite different... 

#########
# Lists of colors (with the same tone)
#all the lists must have length 5. Otherwise, only the first 5 colors are used.
BindGlobal("IP_TonesLength",5);

## red
BindGlobal("IP_ColorsRedTones", 
  [
   "red","red!50","red!20","red!80!green!50","red!80!blue!60"
   ]); 
##  cyan (complement of red)
BindGlobal("IP_ColorsCompRedTones", 
  [
   "-red","-red!50","-red!20","-red!80!green!50","-red!80!blue!60"
   ]); 
## green 
BindGlobal("IP_ColorsGreenTones", 
  [
   "green","green!50","green!20","green!80!red!50","green!80!blue!60"
   ]); 
## magenta (complement of green)
BindGlobal("IP_ColorsCompGreenTones", 
  [
   "-green","-green!50","-green!20","-green!80!red!50","-green!80!blue!60"
   ]); 
## blue
BindGlobal("IP_ColorsBlueTones", 
  [
   "blue","blue!50","blue!20","blue!80!red!50","blue!80!green!60"
   ]); 
## yellow (complement of blue)
BindGlobal("IP_ColorsCompBlueTones", 
  [
   "-blue","-blue!50","-blue!20","-blue!80!red!50","-blue!80!green!60"
   ]); 
## dark gray
BindGlobal("IP_ColorsDGrayTones", 
  [
   "black!80","black!70","black!60","black!50","black!40"
   ]);
## light gray
BindGlobal("IP_ColorsLGrayTones", 
  [
   "black!30","black!25","black!20","black!15","black!10"
   ]);
########
# BindGlobal("RecordOfColorsForIP_", 
#   rec(Reds := IP_ColorsRedTones,
#       rEDS := IP_ColorsCompRedTones,
#       Greens := IP_ColorsGreenTones,
#       gREENS := IP_ColorsCompGreenTones,
#       Blues := IP_ColorsBlueTones,
#       bLUES := IP_ColorsCompBlueTones,
#       DGrays := IP_ColorsDGrayTones,
#       LGrays := IP_ColorsLGrayTones
#       ));
########
BindGlobal("ListsOfIP_Colors",
        [IP_ColorsRedTones,
         IP_ColorsGreenTones,
         IP_ColorsBlueTones,
         IP_ColorsCompRedTones,
         IP_ColorsCompGreenTones,
         IP_ColorsCompBlueTones,
         IP_ColorsDGrayTones,
         IP_ColorsLGrayTones
   ]);
########
BindGlobal("IP_Colors",
  Concatenation(
        [IP_ColorsRedTones,
         IP_ColorsGreenTones,
         IP_ColorsBlueTones,
         IP_ColorsCompRedTones,
         IP_ColorsCompGreenTones,
         IP_ColorsCompBlueTones,
         IP_ColorsDGrayTones,
         IP_ColorsLGrayTones
   ]));
#########
BindGlobal("ShuffledIP_colors",
        Concatenation(TransposedMat(ListsOfIP_Colors)));

#################################################
DeclareGlobalFunction("PickElementsFromList");
#################################################
DeclareGlobalFunction("PickSublistsFromListOfLists");
#################################################
#DeclareGlobalFunction("IP_ColorsByTones");
#################################################
#DeclareGlobalFunction("IP_ColorsForOneImage");
#################################################
DeclareGlobalFunction("ShuffleIP_Colors");
