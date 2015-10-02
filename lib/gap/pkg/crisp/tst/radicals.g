############################################################################
##
##  radicals.g                      CRISP                 Burkhard H\"ofling
##
##  Copyright (C) 2000 by Burkhard H\"ofling, Mathematisches Institut,
##  Friedrich Schiller-Universit\"at Jena, Germany
##
LoadPackage ("crisp");
ReadPackage ("crisp", "tst/samples.g");

if PRINT_METHODS then
   TraceMethods (RadicalOp);
fi;

for G in groups do
   Info (InfoTest, 1, G());
   old := fail;
   cl := classes(); 
   for C in cl do
      SetIsFittingClass (C, true);
   od;
   for i in [1..Length (cl)] do
      if InfoLevel (InfoTest) >= 2 then
         View (cl[i]);
         Print ("\n");
      fi;
      new := Size (Radical (G(), cl[i]));
      if old = fail then
         old := new;
      elif old <> new then
         Error ("different results");
      fi;
      for j in [i..Length (cl)] do
         I := Intersection (cl[i], cl[j]);
         if InfoLevel (InfoTest) >= 3 then
            View (I);
            Print ("\n");
         fi;
         new := Size (Radical (G(), I));
         if old <> new then
            Error ("different results");
         fi;
      od;
   od;
   for C in cl do
      for D in cl do
         P := FittingProduct (C, D);
         if InfoLevel (InfoTest) >= 3 then
            View (C, "by", D);
            Print ("\n");
         fi;
         new := Size (Radical (G(), P));
         if old <> new then
            Error ("different results");
         fi;
      od;
   od;
od;

if PRINT_METHODS then
   UntraceMethods (RadicalOp);
fi;


############################################################################
##
#E
##
