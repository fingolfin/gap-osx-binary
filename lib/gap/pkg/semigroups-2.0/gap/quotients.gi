InstallMethod(GeneratorsOfSemigroup, "for a quotient semigroup",
[IsQuotientSemigroup], 
function(S)
  return DuplicateFreeList(Images(QuotientSemigroupHomomorphism(S), 
   GeneratorsOfSemigroup(QuotientSemigroupPreimage(S))));
end);

InstallMethod(\*, "for associative coll coll and congruence class",
[IsAssociativeElementCollColl, IsCongruenceClass],
function(list, nonlist)
  if ForAll(list, IsCongruenceClass) then 
    return PROD_LIST_SCL_DEFAULT( list, nonlist );
  fi;
  TryNextMethod();
end);

InstallMethod(\*, "for congruence class and associative coll coll",
[IsCongruenceClass, IsAssociativeElementCollColl],
function(nonlist, list)
  if ForAll(list, IsCongruenceClass) then 
    return PROD_SCL_LIST_DEFAULT( nonlist, list );
  fi;
  TryNextMethod();
end);

