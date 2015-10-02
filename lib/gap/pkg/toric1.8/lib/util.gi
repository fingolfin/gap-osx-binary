#############################################################################
##
#A  util.gi                 toric library          David Joyner
##
##
##  This file contains miscellaneous functions
##
#H  @(#)$Id: util.gi,v 1.0 2004/08/16 03:49:21 gap Exp $
##
Revision.("toric/lib/util_gi") :=
    "@(#)$Id: util.gi,v 1.0 2004/08/16 03:49:21 gap Exp $";

TORIC:=rec();

##
##  returns 1 if i=j, 0 otherwise
##
TORIC.krondecker_delta:=function(i, j) 
if i = j then return 1; fi; 
return 0; 
end;

##
##  takes a lists of lists and returns the elements
##
TORIC.flatten:=function(L) 
local L0,L1,i;
 L0:=ShallowCopy(L[1]);     
 if Size(L) = 1 then return L0; fi;  
 for i in [2..Size(L)] do
   Append(L0, L[i]);
 od;
 return Set(L0);
end;

##
##  the ``inner product'' v1^t*A*v2
##
TORIC.inner_product:=function(v1,v2,A) return v1*A*v2; end;

##
##  returns a list of dim-vectors of length dim
##
TORIC.make_basis:=function(dim)
local e,i,j;
 e:=[]; 
 for i in [1..dim] do 
  e[i]:=List(TORIC.kronecker_delta(i,j), j in [1..dim]); 
 od;  
end;
 
##
##  Input: L is a list of vectors L:=[v1,...,vn] 
##  Output: max abs value of all coords of all vecs vi
##
TORIC.max_vectors:=function(L) 
 local n,max0,min0,i,max;
  n:=Size(L); 
  max:=0; 
  for i in [1..n] do 
   max0:=Maximum(L[i]); 
   min0:=Minimum(L[i]); 
   max:=Maximum([max,AbsoluteValue(max0),AbsoluteValue(min0)]); 
  od; 
 return max; 
end; 


##
##  for lists L1, L2, returns Boolean Is L1 subset L2?
##
TORIC.is_sublist:=function(L1, L2)
 local i,j,ans,x,y;
  x:=Set(L1);
  y:=Set(L2);
  if IsSubset(y,x) then return true; fi;
 return false;
end; 


##
##      Input: L is a list of n-1 vectors in Q^n
##      Output: a vector v s.t. <v,h>=0, for all h in span(L)
##
TORIC.normal_to_hyperplane:=function(L) 
 local normal;
  normal:=NullspaceMat(TransposedMat(L));
 return normal[1];
end;

##
##      Input: L is a list of r vectors
##      Output: true if all vectors have same length
##              false otherwise
##
TORIC.consistent_vectors:=function(L) 
 local a,b,i,n;
 n:=Length(L);
 b:=Maximum(List([1..n],i->Length(L[i])));
 a:=Minimum(List([1..n],i->Length(L[i])));
 if a<>b then 
  Error("\n The vectors must all have the same length.\n");
 fi;
end;

