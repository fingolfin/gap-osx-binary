# This module is part of a GAP package MAPCLASS. 
# It contains functions maintaining a hash table 
# containing a braid orbit.
#
# A. James,  K. Magaard, S. Shpectorov 2011


# Function initializing tables 

#
# InitializeTable
# Takes hashlength, numberofgenerators and number of points acted on
# Returns a record with three places, (table, hash, primecode)
#
InstallGlobalFunction(InitializeTable,function(HashLength,NumberOfGenerators,OurN)
  local table,hash,primecode;

  table:=[];
  hash:=List([1..HashLength],x->0);
  primecode:=List([1..NumberOfGenerators*OurN],x->RandomList(Primes));

  return rec(table:=table, hash:=hash, primecode:= primecode);
end);

#
# HashKey
# Function computing the hash key of a tuple
#
InstallGlobalFunction(HashKey,function(T,PrimeCode,HashLength,OurN)
  local t;
  t:=Concatenation(List(T,x->OnTuples([1..OurN],x)));
  return 1+(Sum(List([1..Length(t)],x->t[x]*PrimeCode[x])) mod HashLength);
end);

#
# LookUpTuple
# Function looking up a tuple returns index if found else returns fail
#
InstallGlobalFunction(LookUpTuple,function(T, PrimeCode, HashLength, TupleTable,
  Hash, OurN)
  local h,a;
  h:=HashKey(T,PrimeCode,HashLength, OurN);
  a:=Hash[h];
  while a<>0 do
    if TupleTable[a].tuple=T then
      return a;
    else
      a:=TupleTable[a].next;
    fi;
  od;
  return fail;
end);

#
# AddTuple
# Adds a tuple to the end of a tuple table adjusts the HashKey and returns a
# the length of the last element of the tuple and the adjusted Hashkey
#
InstallGlobalFunction(AddTuple,function(T,PrimeCode, HashLength, TupleTable, Hash, OurN)
  local i,j,k,h;
  h:=HashKey(T,PrimeCode,HashLength,OurN);
  Append(TupleTable,[rec(tuple:=T,next:=Hash[h])]);
  Hash[h]:=Length(TupleTable);
  return(Length(TupleTable));
 end);
# End
