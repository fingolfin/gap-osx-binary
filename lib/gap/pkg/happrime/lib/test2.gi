#############################################################################
##
##  HAPPRIME - test2.gi
##  Various (temporary, undocumented) test operations
##  Paul Smith
##
##  Copyright (C) 2007-2008
##  Paul Smith
##  National University of Ireland Galway
##
##  This file is part of HAPprime. 
## 
##  HAPprime is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
## 
##  HAPprime is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
## 
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
## 
##  $Id: test2.gi 251 2008-03-21 12:29:31Z pas $
##
#############################################################################


#####################################################################
# TEST2
# Temporary debugging test functions


# See how much memory MinimalGeneratorsOfGModuleDestructive takes
#####################################################################
MemoryTest := function(size)
  local Agens, A, G, NS;

  SetGasmanMessageStatus("full");
  Agens:=RandomMat(size, size*64, GF(2));
  ConvertToMatrixRepNC(Agens, GF(2));
  G:=HAPPRIME_Random2Group(64);
  GASMAN("collect");
  Print("Initialised, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");
  
  NS := GensNullspaceGModuleSplit(rec(gens:=Agens, group:= G));
  GASMAN("collect");
  Print("Done GensNullspace, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");

  return NS;
end;
  

# Try IntersectionMat2 with a random group to see how longit takes
# and if it gives the right answer
#####################################################################
TestIntersectionMat2 := function()
      
  local G, m, n, Mgens, Ugens, Vgens, U, V, t1, t2, int, intcomp;

  G := HAPPRIME_Random2Group(16);
  
#  m := Random([1..5]);
  n := Random([2..100]);

  m := n;
  
  Mgens := RandomMat(m, n*Order(G), GF(2));
  Mgens := EchelonModuleGeneratorsMinMemDestructive(Mgens, G).generators;
  #V := HAPPRIME_ExpandGeneratingRows(Vgens, G);
  
  #Vgens := MinimalGeneratorsOfGModuleDestructive(V, G);
  m := Int(Length(Mgens) / 2);

  Ugens := Mgens{[1..m]};
  Vgens := Mgens{[m+1..Length(Mgens)]};

  Print("Two G-modules in FG^", n,
    " with ", Length(Ugens), " generators and ",
    Length(Vgens), " generators and a group of order ", Order(G), 
    "\n");

  U := HAPPRIME_ExpandGeneratingRows(Ugens, G);
  V := HAPPRIME_ExpandGeneratingRows(Vgens, G);
  
  t2 := Runtime();
  intcomp := IntersectionMat2(Ugens, Vgens, G);
  t2 := Runtime() - t2;
  TriangulizeMat(intcomp);
  
  t1 := Runtime();
  int := SumIntersectionMat(U, V)[2];
  t1 := Runtime() - t1;
  Print("  SumIntersectionMat took ", t1, "\n");
  TriangulizeMat(int);
  
  if t1 <> 0 then
    Print("  Compressed version took ", t2, " (", Int(t2/t1)+1, "x slower)\n");
  else
    Print("  Compressed version took ", t2, " (lots slower)\n");
  fi;
    
  Assert(0, int = intcomp);
end;



# Try IntersectionMat and then the nullspace of U and V to see how 
# much memory they take
#####################################################################
SplitMemoryTest := function(size)
  local Agens, G, half, otherhalf, Ugens, Vgens, U, V, NS, I;

  SetGasmanMessageStatus("full");
  Agens:=RandomMat(size, size*64, GF(2));
  ConvertToMatrixRepNC(Agens, GF(2));
  half := Int(Length(Agens) / 2);
  otherhalf := Length(Agens) - half;
  Ugens := Agens{[1..half]};
  Vgens := Agens{[(half+1)..Length(Agens)]};
  G:=HAPPRIME_Random2Group(64);
  NS := [];
  GASMAN("collect");
  Print("Initialised, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");
  
#  U := HAPPRIME_ExpandGeneratingRows(Ugens, G);
#  I := SumIntersectionMat(U, V)[2];
  I := IntersectionMat(Ugens, Vgens, G);
  GASMAN("collect");
  Print("Done SumIntersectionMatV, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");
    
  U := HAPPRIME_ExpandGeneratingRows(Ugens, G);
  Append(NS, NullspaceMatDestructive(U));
  GASMAN("collect");
  Print("Done U nullspace, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");
  Unbind(U);

  V := HAPPRIME_ExpandGeneratingRows(Vgens, G);
  Append(NS, NullspaceMatDestructive(V));
  GASMAN("collect");
  Print("Done V nullspace, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");
  Unbind(V);

  return NS;
end;
  

# Try IntersectionModulesDestructive and compare with SumIntersectionMat
# to see if it is correct and how long it takes
#####################################################################
TestIntersectionModules := function(n, orderG)
      
  local G, m, Mgens, Ugens, Vgens, U, V, t1, t2, int, intcomp,
    Ugens_copy, Vgens_copy;

  G := HAPPRIME_Random2Group(orderG);
  
#  m := Random([1..5]);
#  n := Random([2..100]);

  m := n;
  
  Mgens := RandomMat(m, n*Order(G), GF(2));
  #Mgens := EchelonModuleGeneratorsMinMemDestructive(Mgens, G).generators;
  #V := HAPPRIME_ExpandGeneratingRows(Vgens, G);
  
  #Vgens := MinimalGeneratorsOfGModuleDestructive(V, G);
  m := Int(Length(Mgens) / 2);

  Ugens := Mgens{[1..m]};
  Vgens := Mgens{[m+1..Length(Mgens)]};

  Print("Two G-modules in FG^", n,
    " with ", Length(Ugens), " generators and ",
    Length(Vgens), " generators and a group of order ", Order(G), 
    "\n");

  U := HAPPRIME_ExpandGeneratingRows(Ugens, G);
  V := HAPPRIME_ExpandGeneratingRows(Vgens, G);
  
  Vgens_copy := MutableCopyMat(Vgens);
  Ugens_copy := MutableCopyMat(Ugens);
  t2 := Runtime();
  intcomp := IntersectionModulesDestructive(Ugens_copy, Vgens_copy, G);
  t2 := Runtime() - t2;
  
  t1 := Runtime();
  int := SumIntersectionMat(U, V)[2];
  t1 := Runtime() - t1;
  Print("  SumIntersectionMat took ", t1, "\n");
  
  if t1 <> 0 then
    Print("  Compressed version took ", t2, " (", Int(t2/t1)+1, "x slower)\n");
  else
    Print("  Compressed version took ", t2, " (lots slower)\n");
  fi;
    
  Assert(0, AreModulesEqual(int, intcomp, G));
end;
  



# See how much memory MinimalGeneratorsOfGModuleDestructive takes
#####################################################################
MemoryMinimalTest := function(size)
  local Agens, A, G, gens;

  SetGasmanMessageStatus("full");
  Agens:=RandomMat(size, size*64, GF(2));
  ConvertToMatrixRepNC(Agens, GF(2));
  G:=HAPPRIME_Random2Group(64);
  A := HAPPRIME_ExpandGeneratingRows(Agens, G);
  GASMAN("collect");
  Print("Initialised, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");
      
  gens := MinimalGeneratorsOfGModuleDestructive(A, G);
  GASMAN("collect");
  Print("Done minimal generators, memory used ", 
    GasmanStatistics().full.livekb, "kb\n");
end;
#####################################################################



# Try GenNullspaceGModuleNew to see how long it takes and whether
# it is correct
#####################################################################
TestSemiEchelonNullspace := function(size, orderG)
  
  local G, Agens, gens, F, FF, t, s, worst, 
  headblocks, fullheadgenerators, nsGAP, ns2;

  SetGasmanMessageStatus("full");
  G := HAPPRIME_Random2Group(orderG);
  Agens := RandomMat(size, (size-1)*orderG, GF(2));
  gens := MutableCopyMat(Agens);
  
  t := Runtime();
  s := SemiEchelonModuleGeneratorsMinMemDestructive(gens, G);
  s := EchelonModuleGeneratorsMinMemDestructive(s.generators, G);
#  HAPPRIME_DisplayGeneratingRowsBlocks(s.generators, G);
#  Display(s.headblocks);
#  Display(s.fullheadgenerators);
  gens := s.generators;
  headblocks := s.headblocks;
  fullheadgenerators := s.fullheadgenerators;
  Print("Semiechlon Generators x2 ", StringTime(Runtime() - t), "\n");
    
  t := Runtime();
  ns2 := GensNullspaceGModuleNew(rec(gens:=gens, group:=G));
  Print("GeneratorsNullspaceTriangulizedModule ", 
    StringTime(Runtime() - t), "\n");
  t := Runtime();
  nsGAP := MinimalGeneratorsOfGModuleDestructive(
    NullspaceMatDestructive(HAPPRIME_ExpandGeneratingRows(
      gens, G)), G);
  Print("NullspaceMatDestructive ", StringTime(Runtime() - t), "\n");

  Assert(0, AreModulesEqual(nsGAP, ns2, G));
end;



# Try EchelonModuleGeneratorsMinMemDestructive to see how long it takes and whether
# it is correct
#####################################################################
TestSemiEchelonModuleGeneratorsMinMem := function(size, orderG)
  
  local G, Agens, gens, F, FF, t, s, worst;

  G := HAPPRIME_Random2Group(orderG);
  Agens := RandomMat(size, size*orderG, GF(2));
  gens := MutableCopyMat(Agens);
  
  t := Runtime();
  s := EchelonModuleGeneratorsMinMemDestructive(gens, G);
  worst := Maximum(Set(Collected(s.headblocks), i->i[2]));
  Print("Most heads = ", worst, "\n");
  HAPPRIME_DisplayGeneratingRowsBlocks(s.generators, G);
  Display(s.headblocks);
  Display(s.fullheadgenerators);
  Print("SemiEchelonModuleGeneratorsMinMemDestructive took ", 
    StringTime(Runtime() - t), "\n");
      
  Assert(0, AreModulesEqual(gens, Agens, G));
  
  return worst;
end;

# Try ReverseEchelonModuleGeneratorsDestructive to see how long it takes and whether
# it is correct
#####################################################################
TestReverseEchelonModuleGenerators := function(size, orderG)
  
  local G, Agens, gens, F, FF, t, s, worst;

  G := HAPPRIME_Random2Group(orderG);
  Agens := RandomMat(size, size*orderG, GF(2));
  gens := MutableCopyMat(Agens);
  
  t := Runtime();
  s := ReverseEchelonModuleGeneratorsDestructive(gens, G);
  HAPPRIME_DisplayGeneratingRowsBlocks(s, G);
  Print("ReverseEchelonModuleGeneratorsDestructive took ", 
    StringTime(Runtime() - t), "\n");

  Assert(0, AreModulesEqual(s, Agens, G));
  return rec(generators := Agens, group := G);  
end;

# Try ReverseEchelonModuleGeneratorsDestructive to see how long it takes and whether
# it is correct
#####################################################################
TestIntersectionNew := function()

  local G, R, gens, ngens, half, Ugens, Vgens, Vgens2, int, U, V, int2, i, o, g;

  #for o in [4..6] do
  o := 6;
    Print("************** Order ", 2^o, " **************\n");
    for g in [2..NumberSmallGroups(2^o)] do
      Print("********** Group ", 2^o, ", ", g, " **********\n");
      G := SmallGroup(2^o, g);
      R := ResolutionPrimePowerGroup2(G, 10);

      for i in [1..10] do
        Print("****** ", 2^o, ", ", g,", ", i, " ******\n");
        gens := HAPPRIME_BoundaryMapMatrix(R, i);
        HAPPRIME_DisplayGeneratingRowsBlocks(gens, G);
        ngens := Length(gens);

        half := QuoInt(Length(gens), 2);
        Ugens := gens{[1..half]};
        Vgens := gens{[half+1..ngens]};
        U := HAPPRIME_ExpandGeneratingRows(Ugens, G);;
        V := HAPPRIME_ExpandGeneratingRows(Vgens, G);;

        Vgens2 := MutableCopyMat(Vgens);
        int := IntersectionTriangulizedGeneratorModulesDestructive(Ugens, Vgens2, G);

        int2 := SumIntersectionMat(U, V)[2];

        Assert(0, IsSameSubspace(int, int2));
      od;
    od;
#  od;
end;

# Try ReverseEchelonModuleGeneratorsDestructive to see how long it takes and whether
# it is correct
#####################################################################
TestIntersectionMatDestructionSE := function()

  local G, size, U, V, U2, V2, seU2, seV2, seU, seV, 
    Ubasis, Uheads, Vbasis, Vheads, si, si2, t1, t2;

    
  SetGasmanMessageStatus("full");
  size := 100;
  while true do
    Print("-----------------------\n");
#    G := HAPPRIME_Random2Group(128);
#    U := RandomMat(Random([QuoInt(size, 256)..QuoInt(size, 128)]), size, GF(2));
#    U := HAPPRIME_ExpandGeneratingRows(U, G);;
#    V := RandomMat(Random([QuoInt(size, 256)..QuoInt(size, 128)]), size, GF(2));
#    V := HAPPRIME_ExpandGeneratingRows(V, G);;
    U := RandomMat(QuoInt(size*3, 4), size);;
    V := RandomMat(QuoInt(size*3, 4), size);;
  
    U2 := MutableCopyMat(U);;
    V2 := MutableCopyMat(V);;

    Print("U is ", Length(U), "x", Length(U[1]),
      "; V is ", Length(V), "x", Length(V[1]), "\n");
    t1 := Runtime();
    si2 := SumIntersectionMatDestructive(U2, V2);
    t1 := t1 - Runtime();
    if not IsEmpty(si2[2]) then 
      Print("Sum is ", Length(si2[1]), "x", Length(si2[1][1]),
        "; Intersection is ", Length(si2[2]), "x", Length(si2[2][1]), "\n");
    else
      Print("Sum is ", Length(si2[1]), "x", Length(si2[1][1]),
        "; Intersection is empty\n");
    fi;
    Print("New took ", StringTime(t1), "\n");

    t2 := Runtime();
    si := SumIntersectionMat(U, V);
    t2 := t2 - Runtime();
    Print("Old took ", StringTime(t2), "\n");
    
    Assert(0, IsSameSubspace(si[2], si2[2]));
    Assert(0, IsSameSubspace(si[1], si2[1]));
    
    size := size * 2;
  od;
    
end;

# Try SumIntersectionMatDestructive to see how much memory it uses
#####################################################################
MemoryTestSumIntersectionMatDestructive := function(size)

  local G, orderG, Ugens, U, Vgens, V, si;

  SetGasmanMessageStatus("full");
  G := SmallGroup(64, 135);
  orderG := 64;
    
  Print("Memory at start\n");
  GASMAN("collect");
  Ugens := RandomMat(size / 2, size*orderG, GF(2));;
  GASMAN("collect");
  U := HAPPRIME_ExpandGeneratingRows(Ugens, G);;
  GASMAN("collect");

  Vgens := RandomMat(size / 2, size*orderG, GF(2));;
  GASMAN("collect");
  V := HAPPRIME_ExpandGeneratingRows(Vgens, G);;
  GASMAN("collect");

  Print("Now doing SumIntersectionMat\n");
  si := SumIntersectionMatDestructive(U, V);;
  Print("Done  - cleaning up\n");
  Unbind(U);
  Unbind(Ugens);
  Unbind(V);
  Unbind(Vgens);
  Unbind(si);
  GASMAN("collect");

end;
# Try SumIntersectionMatDestructive to see how much memory it uses
#####################################################################
MemoryTestSumIntersectionMat := function(size)

  local G, orderG, Ugens, U, Vgens, V, si;

  SetGasmanMessageStatus("full");
  G := SmallGroup(64, 135);
  orderG := 64;
    
  Print("Memory at start\n");
  GASMAN("collect");
  Ugens := RandomMat(size / 2, size*orderG, GF(2));;
  GASMAN("collect");
  U := HAPPRIME_ExpandGeneratingRows(Ugens, G);;
  GASMAN("collect");

  Vgens := RandomMat(size / 2, size*orderG, GF(2));;
  GASMAN("collect");
  V := HAPPRIME_ExpandGeneratingRows(Vgens, G);;
  GASMAN("collect");

  Print("Now doing SumIntersectionMat\n");
  si := SumIntersectionMat(U, V);;
  Print("Done  - cleaning up\n");
  Unbind(U);
  Unbind(Ugens);
  Unbind(V);
  Unbind(Vgens);
  Unbind(si);
  GASMAN("collect");

end;
# Try NullspaceMatDestructive to see how much memory it uses
#####################################################################
MemoryTestNullspaceMat:= function(size)

  local G, orderG, Mgens, M, ns;

  SetGasmanMessageStatus("full");
  G := SmallGroup(64, 135);
  orderG := 64;
    
  Print("Memory at start\n");
  GASMAN("collect");
  Mgens := RandomMat(size, size*orderG, GF(2));;
  GASMAN("collect");
  M := HAPPRIME_ExpandGeneratingRows(Mgens, G);;
  GASMAN("collect");


  Print("Now doing NullspaceMat\n");
  ns := NullspaceMatDestructive(M);;
  Print("Done  - cleaning up\n");
  Unbind(M);
  Unbind(Mgens);
  Unbind(ns);
  GASMAN("collect");

end;
# Try SolutionsMatDestructive to see how much memory it uses
#####################################################################
MemoryTestSolutionsMatDestructive:= function(size)

  local G, orderG, Mgens, M, u, v, u2;

  SetGasmanMessageStatus("full");
  G := SmallGroup(64, 135);
  orderG := 64;

  Print("Memory at start\n");
  GASMAN("collect");
  Mgens := RandomMat(size/2, size*orderG, GF(2));;
  GASMAN("collect");
  M := HAPPRIME_ExpandGeneratingRows(Mgens, G);;
  Unbind(Mgens);
  GASMAN("collect");
  u := RandomMat(1, size/2*orderG, GF(2))[1];
  v := u*M;
  GASMAN("collect");

  Print("Now doing SolutionsMat\n");
  u2 := SolutionMatDestructive(M, v);;
  Print("Done  - cleaning up\n");
  Unbind(M);
  Unbind(u);
  Unbind(v);
  Unbind(u2);
  GASMAN("collect");

end;
 # Try SolutionsMatDestructive to see how much memory it uses
#####################################################################
TestSolutionTriangulizedModuleMat:= function(size)

  local G, R, Mgens, ngens, half, Ugens, Vgens, I, Icopy, Igens, v;

  G := SmallGroup(64, 135);
  R := ResolutionPrimePowerGroup2(G, 2);
  
  Mgens := HAPPRIME_BoundaryMapMatrix(R, 2);
  HAPPRIME_DisplayGeneratingRowsBlocks(Mgens, G);
  ngens := Length(Mgens);

  half := QuoInt(Length(Mgens), 2);
  Ugens := Mgens{[1..half]};
  Vgens := Mgens{[half+1..ngens]};

  I := IntersectionTriangulizedGeneratorModules(Ugens, Vgens, G);;
  Icopy := MutableCopyMat(I);

  Igens := MinimalGeneratorsOfGModuleDestructive(Icopy, G);

  v := Igens[5];
  
end;

# Try MinimalGeneratorsOfGModuleDestructive2
#####################################################################
TestMinimalGeneratorsOfModuleDestructive2 := function()

  local G, gens, Fbasis, gens2;

  G := HAPPRIME_Random2Group(64);

  gens := RandomMat(50, 50*Order(G), GF(2));

  HAPPRIME_DisplayGeneratingRowsBlocks(gens, G);
  
  Fbasis := HAPPRIME_ExpandGeneratingRows(gens, G);
    
  gens2 := MinimalGeneratorsOfModuleDestructive2(Fbasis, G);
  HAPPRIME_DisplayGeneratingRowsBlocks(gens2, G);
  
  Assert(0, AreModulesEqual(gens, gens2, G));
  
end;

# Try MinGensKernelModuleHomomorphismMatDestructive
#####################################################################
TestMinGensKernelModuleHomomorphismMatDestructive := function(o)

  local g, G, R, gens, Mgens, kgens, kgens2, i;

  o := 4;
  Print("************** Order ", 2^o, " **************\n");
  for g in [2..NumberSmallGroups(2^o)] do
    Print("********** Group ", 2^o, ", ", g, " **********\n");
    G := SmallGroup(2^o, g);
    R := ResolutionPrimePowerGroup(G, 10);
    for i in [1..10] do
      Print("****** ", 2^o, ", ", g,", ", i, " ******\n");
      gens := HAPPRIME_BoundaryMapMatrix(R, i);

      gens := EchelonModuleGeneratorsDestructive(gens, G).generators;
      gens := ReverseEchelonModuleGeneratorsDestructive(gens, G);
      Mgens := MutableCopyMat(gens);

      kgens := MinGensKernelModuleHomomorphismMatDestructive(gens, G);

      kgens2 := HAPPRIME_ExpandGeneratingRows(Mgens, G);
      kgens2 := NullspaceMatDestructive(kgens2);
      kgens2 := MinimalGeneratorsOfGModuleDestructive(kgens2, G);

      Assert(0, Length(kgens2) = Length(kgens));
      Assert(0, AreModulesEqual(kgens, kgens2, G));
    od;
  od;
end;
 
# Try SemiEchelonModuleGeneratorsDestructive to see how long it takes and whether
# it is correct
#####################################################################
TestSemiEchelonModuleGeneratorsDestructive := function(size, orderG)
  
  local G, Agens, gens, F, FF, t, s, worst;

  G := HAPPRIME_Random2Group(orderG);
  Agens := RandomMat(size * 2, size*orderG, GF(2));
#  Agens := HAPPRIME_ExpandGeneratingRows(Agens, G);
  gens := MutableCopyMat(Agens);
  Print("Module with group order ", orderG, 
    " with ", Length(Agens), " generators\n");
#  HAPPRIME_DisplayGeneratingRowsBlocks(gens, G);
  
  t := Runtime();
  s := EchelonModuleGeneratorsMinMemDestructive(gens, G);
  Print("EchelonModuleGeneratorsMinMemDestructive took ", 
    StringTime(Runtime() - t), "\n");
  Print("  and reduced to  ", Length(s.generators), " generators\n");
# HAPPRIME_DisplayGeneratingRowsBlocks(s.generators, G);
  
  gens := MutableCopyMat(Agens);
  t := Runtime();
  s := EchelonModuleGeneratorsDestructive(gens, G);
  Print("EchelonModuleGeneratorsDestructive took ", 
    StringTime(Runtime() - t), "\n");
  Print("  and reduced to  ", Length(s.generators), " generators\n");
# HAPPRIME_DisplayGeneratingRowsBlocks(s.generators, G);

  Assert(0, AreModulesEqual(s.generators, Agens, G));
  
#  t := Runtime();
#  gens := ReverseEchelonModuleGeneratorsDestructive(s.generators, G);
#  Print("ReverseEchelonModuleGeneratorsDestructive took ", 
#    StringTime(Runtime() - t), "\n");
#  HAPPRIME_DisplayGeneratingRowsBlocks(gens, G);

  return rec(generators := Agens, group := G);
end;

# Try HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelonDestructive to see 
# whether it is correct
#####################################################################
TestReduceGeneratorsOfModuleBySemiEchelonDestructive := function()

  local G, gens, small_gens; 

   G := HAPPRIME_Random2Group();
   gens := RandomMat(2*Order(G), Order(G), GF(2));
   small_gens := HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelon(gens, G);
   
#   DisplayModule(gens, G);
   Print("Reduced ", Length(gens), " generators to ", Length(small_gens), "\n");
#   DisplayModule(small_gens, G);
   
   
   
   Assert(0, AreModulesEqual(gens, small_gens, G));
end;

# Try ReduceGeneratorsOfModuleByLeavingOneOut to see 
# whether it is correct
#####################################################################
TestReduceGeneratorsOfModuleByLeavingOneOut := function(orderG)

  local G, gens, small_gens, smaller_gens,
    gen_pos, found, g, i; 

   G := HAPPRIME_Random2Group(orderG);
   gens := RandomMat(2*Order(G), Order(G), GF(2));
   small_gens := HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelon(gens, G);
   
#   DisplayModule(gens, G);
   Print("Reduced ", Length(gens), " generators to ", Length(small_gens), "\n");
#   DisplayModule(small_gens, G);
   smaller_gens := HAPPRIME_ReduceGeneratorsOfModuleByLeavingOneOut(small_gens, G);
   Print("Then reduced ", Length(small_gens), " generators to ",
    Length(smaller_gens), "\n");
#   DisplayModule(smaller_gens, G);
   
   Assert(0, AreModulesEqual(gens, small_gens, G));
   Assert(0, AreModulesEqual(gens, smaller_gens, G));
   # Now find the generator(s)
   gen_pos := [];
   for g in smaller_gens do
    found := false;
    for i in [1..Length(gens)] do
      if g = gens[i] then
        Add(gen_pos, i);
        found := true;
        break;
      fi;
    od;
    if not found then
      Add(gen_pos(fail));
    fi;
   od;
   Print("Generator positions: ", gen_pos, "\n");
end;

# Try ResolutionPrimePowerGroup to see how much memory it uses
# and how far I can go
#####################################################################
TestResolutionPrimePowerGroupMemory := function()

  local G, R, length, i;

  SetGasmanMessageStatus("full");
  G := SmallGroup(64, 135);

  Print("Memory at start\n");
  GASMAN("collect");

  R := StartResolutionPrimePowerGroup(G);
  for i in [1..30] do
    R := ExtendResolutionPrimePowerGroupGeneral(
      R, FindMinimalKernelGeneratorsOriginal);
  od;

  Print("After StartResolutionPrimePowerGroup\n");
  GASMAN("collect");
  
  # Now build the resolution
  length := 31;
  while true do
    R := ExtendResolutionPrimePowerGroupGeneral(
      R, FindMinimalKernelGeneratorsNew2);
    length := length + 1;
    Print("***********After resolution of length ", length, "\n");
    GASMAN("collect");
  od;
  
end;

# Try ResolutionPrimePowerGroup to see how much time it takes
# and how far I can go
#####################################################################
TestResolutionPrimePowerGroupTime := function()

  local G, R, length, i;

  G := SmallGroup(64, 135);

  R := StartResolutionPrimePowerGroup(G);

  # Now build the resolution
  Print("***********Start ", Runtime(), "\n");
  while true do
    R := ExtendResolutionPrimePowerGroupGeneral(
      R, FindMinimalKernelGeneratorsNew2);
    length := ResolutionLength(R);
    Print("***********After resolution of length ", length, ": ", Runtime(), "\n");
  od;
  
end;
