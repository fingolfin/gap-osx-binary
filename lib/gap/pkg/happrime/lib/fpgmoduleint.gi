#############################################################################
##
##  HAPPRIME - fpgmoduleint.gi
##  Various internal Functions, Operations and Methods
##  Paul Smith
##
##  Copyright (C)  2007-2008
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
##  $Id: fpgmoduleint.gi 345 2008-11-21 12:56:17Z pas $
##
#############################################################################

#####################################################################
##  <#GAPDoc Label="HAPPRIME_GActMatrixColumns_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_GActMatrixColumns" Arg="g, Vt, GA"/>
##  <Oper Name="HAPPRIME_GActMatrixColumnsOnRight" Arg="g, Vt, GA"/>
##
##  <Returns>
##    Matrix
##  </Returns>
##
##  <Description>
##  Returns the matrix that results from the applying the group action 
##  <M>u=gv</M> (or <M>u=vg</M> in the case of the <C>OnRight</C> version of
##  this function) to each <E>column</E> vector in the matrix <A>Vt</A>. By 
##  acting on <E>columns</E> of a matrix (i.e. the transpose of the normal &GAP; 
##  representation), the group action is just a permutation of the rows of the 
##  matrix, which is a fast operation. The group and action are passed in
##  <A>GA</A> using the <Ref Func="ModuleGroupAndAction"/> record.
##  <P/>
##  If the input matrix <A>Vt</A> is in a compressed matrix representation, then
##  the returned matrix will also be in compressed matrix representation.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_GActMatrixColumns,
  [IsObject, IsMatrix, IsRecord],
  function(g, Vt, GA)
    local newRowNumbers, gVt, nblocks, i, newi, blockstart, j;

    # Create list stating to which new row each old row in a block
    # maps to. We can do this by seeing which row rows come _from_ when
    # mapped under the inverse
    newRowNumbers := GA.action(Inverse(g), [1..GA.actionBlockSize]);

    gVt := [];

    nblocks := Length(Vt) / GA.actionBlockSize;
    if not IsInt(nblocks) then
      Error("<v> must be an integer multiple of the order of the group in length");
    fi;

    for i in [1..GA.actionBlockSize] do
      newi := newRowNumbers[i];
      blockstart := 0;
      for j in [1..nblocks] do
        gVt[newi + blockstart] := Vt[i + blockstart];
        blockstart := blockstart + GA.actionBlockSize;
      od;
    od;

    if IsGF2MatrixRep(Vt) or Is8BitMatrixRep(Vt) then
      ConvertToMatrixRepNC(gVt, Field(Vt[1][1]));
    fi;
  
    return gVt;
  end);
#####################################################################
InstallMethod(HAPPRIME_GActMatrixColumnsOnRight,
  [IsObject, IsMatrix, IsRecord],
  function(g, Vt, GA)
    local newRowNumbers, gVt, nblocks, i, newi, blockstart, j;

    # Create list stating to which new row each old row in a block
    # maps to. We can do this by seeing which row rows come _from_ when
    # mapped under the inverse
    newRowNumbers := GA.actionOnRight(Inverse(g), [1..GA.actionBlockSize]);

    gVt := [];

    nblocks := Length(Vt) / GA.actionBlockSize;
    if not IsInt(nblocks) then
      Error("<v> must be an integer multiple of the order of the group in length");
    fi;

    for i in [1..GA.actionBlockSize] do
      newi := newRowNumbers[i];
      blockstart := 0;
      for j in [1..nblocks] do
        gVt[newi + blockstart] := Vt[i + blockstart];
        blockstart := blockstart + GA.actionBlockSize;
      od;
    od;

    if IsGF2MatrixRep(Vt) or Is8BitMatrixRep(Vt) then
      ConvertToMatrixRepNC(gVt, Field(Vt[1][1]));
    fi;
  
    return gVt;
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_ExpandGeneratingRows_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_ExpandGeneratingRow" Arg="gen, GA"/>
##  <Oper Name="HAPPRIME_ExpandGeneratingRows" Arg="gens, GA"/>
##  <Oper Name="HAPPRIME_ExpandGeneratingRowOnRight" Arg="gen, GA"/>
##  <Oper Name="HAPPRIME_ExpandGeneratingRowsOnRight" Arg="gens, GA"/>
##
##  <Returns>
##    List
##  </Returns>
##
##  <Description>
##  Returns a list of &G;-generators for the vector space that corresponds 
##  to the of &G;-generator <A>gen</A> (or generators <A>gens</A>). This space 
##  is formed by multiplying each generator by each element of <A>G</A> in 
##  turn, using the group and action specified in <A>GA</A> (see
##  <Ref Func="ModuleGroupAndAction"/>). The returned list is thus <M>|G|</M>
##  times larger than the input. 
##  <P/>
##  For a list of generators <A>gens</A> <M>[v_1, v_2, \ldots, v_n]</M>,
##  <Ref Func="HAPPRIME_ExpandGeneratingRows"/> returns the list 
##  <M>[g_1v_1, g_2v_1, \ldots, g_1v_2, g_2v_2, \ldots, g_{|G|}v_n]</M>
##  In other words, the form of the returned matrix is block-wise, with the 
##  expansions of each row given in turn. This function is more efficient 
##  than repeated use of
##  <Ref Func="HAPPRIME_ExpandGeneratingRow"/> since it uses the efficient
##  <Ref Func="HAPPRIME_GActMatrixColumns"/> to perform the group action on the
##  whole set of generating rows at a time.
##  <P/>
##  The function <Ref Func="HAPPRIME_ExpandGeneratingRowsOnRight"/> is the 
##  same as above, but the group action operates on the right instead.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_ExpandGeneratingRow,
  [IsVector, IsRecord],
  function(gen, GA)
    local Fbasis, g;

    Fbasis := [];
    for g in Elements(GA.group) do
      Add(Fbasis, GA.action(g, gen));
    od;

  return Fbasis;
end);
#####################################################################
InstallMethod(HAPPRIME_ExpandGeneratingRowOnRight,
  [IsVector, IsRecord],
  function(gen, GA)
    local Fbasis, g;

    Fbasis := [];
    for g in Elements(GA.group) do
      Add(Fbasis, GA.actionOnRight(g, gen));
    od;

  return Fbasis;
end);
#####################################################################
InstallMethod(HAPPRIME_ExpandGeneratingRows,
  "usual method",
  [IsMatrix, IsRecord],
  function(gens, GA)
    local gensT, nrows, Fbasis, eltsG, orderG, i, ggens, r;

    # Each column of the matrix Be corresponds to a different group
    # element e.g. [a b c d | a b c d | a b c d].
    # Transpose this matrix so that the group elements go across rows instead
    ConvertToMatrixRepNC(gens, Field(gens[1][1]));
    gensT := TransposedMatMutable(gens);
    nrows := Length(gens);

    # We want to multiply each row of gens (now each column) by each group
    # element in turn. It is more efficient to apply the action to the
    # whole matrix and then put the rows in the correct places
    Fbasis := [];
    eltsG := Elements(GA.group);
    orderG := Order(GA.group);
    for i in [1..Length(eltsG)] do
      ggens := TransposedMatMutable(
        HAPPRIME_GActMatrixColumns(eltsG[i], gensT, GA));
      for r in [1..nrows] do
        Fbasis[i + (r-1)*orderG] := ggens[r];
      od;
    od;

    return Fbasis;
  end);
#####################################################################
InstallOtherMethod(HAPPRIME_ExpandGeneratingRows,
  "method for empty matrices",
  [IsEmpty, IsRecord],
  function(gens, ga)
    return [];
end);
#####################################################################
InstallMethod(HAPPRIME_ExpandGeneratingRowsOnRight,
  "usual method",
  [IsMatrix, IsRecord],
  function(gens, GA)
    local gensT, nrows, Fbasis, eltsG, orderG, i, ggens, r;

    # Each column of the matrix Be corresponds to a different group
    # element e.g. [a b c d | a b c d | a b c d].
    # Transpose this matrix so that the group elements go across rows instead
    ConvertToMatrixRepNC(gens, Field(gens[1][1]));
    gensT := TransposedMatMutable(gens);
    nrows := Length(gens);

    # We want to multiply each row of gens (now each column) by each group
    # element in turn. It is more efficient to apply the action to the
    # whole matrix and then put the rows in the correct places
    Fbasis := [];
    eltsG := Elements(GA.group);
    orderG := Order(GA.group);
    for i in [1..Length(eltsG)] do
      ggens := TransposedMatMutable(
        HAPPRIME_GActMatrixColumnsOnRight(eltsG[i], gensT, GA));
      for r in [1..nrows] do
        Fbasis[i + (r-1)*orderG] := ggens[r];
      od;
    od;

    return Fbasis;
  end);
#####################################################################
InstallOtherMethod(HAPPRIME_ExpandGeneratingRowsOnRight,
  "method for empty matrices",
  [IsEmpty, IsRecord],
  function(gens, ga)
    return [];
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive" Arg="basis, gen, GA"/>
## 
##  <Returns>
##    Record with elements <C>vectors</C> and <C>basis</C>
##  </Returns>
##  <Description>
##  This function augments a vector space basis with another generator. It 
##  returns a record consisting of two elements: <C>vectors</C>, a set of 
##  semi-echelon basis vectors for the vector space spanned by the sum of the 
##  input <A>basis</A> and all &G;-multiples of the generating vector 
##  <A>gen</A>; and <C>heads</C>, a list of the head elements, in the same
##  format as returned by <Ref Func="SemiEchelonMat" BookName="ref"/>. The 
##  generator <A>gen</A> is expanded according to the group and action specified 
##  in the <A>GA</A> record (see <Ref Func="ModuleGroupAndAction"/>).
##  <P/>
##  If the input <A>basis</A> is not zero, it is also modified by this function, 
##  to be the new basis (i.e. the same as the <C>vectors</C> element of the 
##  returned record).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive,
  [IsMatrix, IsVector, IsRecord],
  function(basis, gen, GA)

  local Fgens, semiechelon;

  # Expand out this generator and add it to my basis
  Fgens := HAPPRIME_ExpandGeneratingRow(gen, GA);
  Append(basis, Fgens);

  # Now do semiechelon on it to reduce it and find the heads
  semiechelon := SemiEchelonMatDestructive(basis);
  basis := semiechelon.vectors;

  return rec(vectors := basis, heads := semiechelon.heads);
end);
#####################################################################
InstallOtherMethod(HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive,
  [IsEmpty, IsVector, IsRecord],
  function(basis, gen, GA)

  local semiechelon;

  # The input basis is empty, so just expand out this generator 
  basis := HAPPRIME_ExpandGeneratingRow(gen, GA);
  # Now do semiechelon on it to reduce it and find the heads
  semiechelon := SemiEchelonMatDestructive(basis);
  basis := semiechelon.vectors;

  return rec(vectors := basis, heads := semiechelon.heads);
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_ReduceVectorDestructive_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_ReduceVectorDestructive" Arg="v, basis, heads"/>
## 
##  <Returns>
##     Boolean
##  </Returns>
##  <Description>
##  Reduces the vector <A>v</A> (in-place) using the semi-echelon set of vectors 
##  <A>basis</A> with heads <A>heads</A> (as returned by 
##  <Ref Func="SemiEchelonMat" BookName="ref"/>).
##  Returns <K>true</K> if the vector is completely reduced to zero, or
##  <K>false</K> otherwise.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_ReduceVectorDestructive,
  [IsVector and IsMutable, IsMatrix, IsVector],
  function(v, basis, heads)
    local c, p, r, allreduced;

    allreduced := true;
    if IsZero(heads) then 
      return IsZero(v);
    fi;

    for c in [1..Length(v)] do
      if not IsZero(v[c]) then
        p := heads[c];
        if p <> 0 then
          AddRowVector(v, basis[p], v[c]);
        else
          allreduced := false;
        fi;
      fi;
    od;
    return allreduced;
end);
#####################################################################
InstallOtherMethod(HAPPRIME_ReduceVectorDestructive,
  [IsVector, IsEmpty, IsVector],
  function(v, basis, heads)
    # Nothing to reduce with, so leave v as it is, and return false
    return false;
end);
#####################################################################




#####################################################################
##  <#GAPDoc Label="HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelonDestructive_manGenMatInt">
##  <ManSection>
##  <Heading>HAPPRIME_ReduceGeneratorsOfModuleByXX</Heading>
##  <Oper Name="HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelon" Arg="gens, GA"/>
##  <Oper Name="HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelonDestructive" Arg="gens, GA"/>
##  <Oper Name="HAPPRIME_ReduceGeneratorsOfModuleByLeavingOneOut" Arg="gens, GA"/>
##  <Oper Name="HAPPRIME_ReduceGeneratorsOnRightByLeavingOneOut" Arg="gens, GA"/>
## 
##  <Returns>
##    List of vectors
##  </Returns>
##
##  <Description>
##  Returns a subset of the module generators <A>gens</A> over the group with 
##  action specified in the <A>GA</A> record (see 
##  <Ref Func="ModuleGroupAndAction"/>) that will still generate the module.
##  <P/>
##  The <C>BySemiEchelon</C> functions gradually expand out the module generators 
##  into an &FF;-basis, using that &FF;-basis to reduce the other generators, 
##  until the full vector space of the module is spanned. The generators needed 
##  to span the space are returned, and should be a small set, although not 
##  minimal. The <C>Destructive</C> version of this function will modify the 
##  input <A>gens</A> parameter. The non-destructive version makes a copy first, so
##  leaves the input arguments unchanged, at the expense of more memory.
##  <P/>
##  The <C>ByLeavingOneOut</C> function is tries repeatedly leaving out 
##  generators from the list <A>gens</A> to find a small subset that still 
##  generates the module. If the generators are from the field GF(2), this is 
##  guaranteed to be a minimal set of generators. The <C>OnRight</C> version
##  computes a minimal subset which generates the module under group 
##  multiplication on the right.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelonDestructive,
  "generic method",
  [IsMatrix and IsMutable, IsRecord],
  function(gens, GA)
  
  local reducedgens, sebasis, g, r;
  
  # Add the first row to the basis
  reducedgens := [gens[1]];
  sebasis := 
    HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive([], gens[1], GA);

  # Now reduce and add in the other ones until we have enough
  for g in [2..Length(gens)] do
    # Reduce the next row, but first remember it
    r := ShallowCopy(gens[g]);
    if not HAPPRIME_ReduceVectorDestructive(
      gens[g], sebasis.vectors, sebasis.heads) then
        # This one is needed, so add it to the basis and to my list of generators
        sebasis := HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive(
          sebasis.vectors, gens[g], GA);
        Add(reducedgens, r);
        # If we now have a full rank of rows, we don't need to go any further
        if Length(sebasis.vectors) = Length(gens[1]) then
          break;
        fi;
    fi;
  od;
  return reducedgens;
end);
#####################################################################
InstallOtherMethod(HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelonDestructive,
  "method for empty generators",
  [IsEmpty, IsRecord],
  function(gens, GA)
    return [];
end);
#####################################################################
InstallMethod(HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelon,
  "generic method",
  [IsMatrix, IsRecord],
  function(gens, GA)
  
  local gens_copy;
  
  gens_copy := MutableCopyMat(gens);
  return HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelonDestructive(
    gens_copy, GA);
end);
#####################################################################
InstallOtherMethod(HAPPRIME_ReduceGeneratorsOfModuleBySemiEchelon,
  "method for empty generators",
  [IsEmpty, IsRecord],
  function(gens, GA)
    return [];
end);
#####################################################################
InstallMethod(HAPPRIME_ReduceGeneratorsOfModuleByLeavingOneOut,
  "generic method",
  [IsMatrix and IsMutable, IsRecord],
  function(gens, GA)

  local dim, rowsneeded, r, previousrowsneeded, 
    VectorSpaceDimensionOfGeneratingRows;

  # If there is only one generator, then this is the minimal set
  if Length(gens) = 1 then
    return gens;
  fi;
  
  ###############################
  VectorSpaceDimensionOfGeneratingRows := function(gens)
    if IsEmpty(gens) then return 0; else
      return RankMatDestructive(HAPPRIME_ExpandGeneratingRows(gens, GA));
    fi;
  end;
  ###############################

  dim := VectorSpaceDimensionOfGeneratingRows(gens);
  # Start by assuming that all the rows are needed
  rowsneeded := [1..Length(gens)];

  r := 1; # The row to try leaving out
  while r <= Length(rowsneeded) do
    # Remember our current list of rows
    previousrowsneeded := ShallowCopy(rowsneeded);
    # now remove one
    Remove(rowsneeded, r);
    if VectorSpaceDimensionOfGeneratingRows(gens{rowsneeded}) = dim then
      # This row is not needed. We next try the one that is now in position r
    else
      # This row is needed. Go back to where we were and move on to the next
      rowsneeded := ShallowCopy(previousrowsneeded);
      r := r + 1;
    fi;
  od;
  return gens{rowsneeded};
end);
#####################################################################
InstallOtherMethod(HAPPRIME_ReduceGeneratorsOfModuleByLeavingOneOut,
  "for empty generators",
  [IsEmpty, IsRecord],
  function(gens, GA)
    return [];
end);
#####################################################################
InstallMethod(HAPPRIME_ReduceGeneratorsOnRightByLeavingOneOut,
  [IsMatrix and IsMutable, IsRecord],
  function(gens, GA)

  local dim, rowsneeded, r, previousrowsneeded, 
    VectorSpaceDimensionOfGeneratingRows;

  # If there is only one generator, then this is the minimal set
  if Length(gens) = 1 then
    return gens;
  fi;
  
  ###############################
  VectorSpaceDimensionOfGeneratingRows := function(gens)
    if IsEmpty(gens) then return 0; else
      return RankMatDestructive(HAPPRIME_ExpandGeneratingRowsOnRight(gens, GA));
    fi;
  end;
  ###############################

  dim := VectorSpaceDimensionOfGeneratingRows(gens);
  # Start by assuming that all the rows are needed
  rowsneeded := [1..Length(gens)];

  r := 1; # The row to try leaving out
  while r <= Length(rowsneeded) do
    # Remember our current list of rows
    previousrowsneeded := ShallowCopy(rowsneeded);
    # now remove one
    Remove(rowsneeded, r);
    if VectorSpaceDimensionOfGeneratingRows(gens{rowsneeded}) = dim then
      # This row is not needed. We next try the one that is now in position r
    else
      # This row is needed. Go back to where we were and move on to the next
      rowsneeded := ShallowCopy(previousrowsneeded);
      r := r + 1;
    fi;
  od;
  return gens{rowsneeded};
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_DisplayGeneratingRows_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_DisplayGeneratingRows" Arg="gens, GA"/>
##
##  <Returns>
##    nothing
##  </Returns>
##  <Description>
##  Displays a set of &G;-generating rows a human-readable form. 
##  The elements of each generating vector are displayed,
##  with each block marked by a separator (since the 
##  group action on a module vector will only permute elements within a block).
##  <P/>
##  This function is used by <K>Display</K> for both
##  <K>FpGModuleGF</K> and <K>FpGModuleHomomorphismGF</K>.
##  <P/>
##  NOTE: This is currently only implemented for GF(2)
##  </Description>
##  </ManSection>
##  <Log><![CDATA[
##  gap> HAPPRIME_DisplayGeneratingRows(
##  >  ModuleGenerators(M), HAPPRIME_ModuleGroupAndAction(M));
##  [...1..11|........|.......1|........|........]
##  [........|........|........|.1....11|........]
##  [........|........|........|........|..1.1.1.]
##  [........|.1.1..1.|........|........|........]
##  [........|........|......11|........|........]
##  [........|........|1......1|........|........]
##  ]]></Log>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_DisplayGeneratingRows,
  "for characteristic 2",
  [IsMatrix, IsRecord],
  function(gens, GA)
    local row, orderG, i;

    if not IsInt(Length(gens[1]) / GA.actionBlockSize) then
      Error("The length of vectors in <gens> is not an integer multiple of <actionBlockSize>");
    fi;
    if Field(gens[1][1]) <> GaloisField(2) then
      TryNextMethod();
    fi;

    for row in gens do
      Print("[");
      for i in [1..Length(row)] do
        if IsOne(row[i]) then
          Print("1");
        else
          Print(".");
        fi;

        if IsInt(i / GA.actionBlockSize) and i <> Length(row) then
          Print("|");
        fi;
      od;
      Print("]\n");

    od;
end);
#####################################################################
InstallOtherMethod(HAPPRIME_DisplayGeneratingRows,
  "generic method for empty generators",
  [IsEmpty, IsRecord],
  function(gens, GA)
    Print("[ ]\n");
end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="HAPPRIME_GeneratingRowsBlockStructure_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_GeneratingRowsBlockStructure" Arg="gens, GA"/>
##
##  <Returns>
##    Matrix
##  </Returns>
##  <Description>
##  Returns a matrix detailing the block structure of a set of module 
##  generating rows. The group action on a generator permutes the vector in 
##  blocks of length <C>GA.actionBlockSize</C>: any block that contains 
##  non-zero elements will still contain non-zero elements after the group 
##  action; any block that is all zero will remain all zero. This operation 
##  returns a matrix giving this block structure: it has a one where the block
##  is non-zero and zero where the block is all zero.
##  </Description>
##  </ManSection>
##  <Log><![CDATA[
##  gap> b := HAPPRIME_GeneratingRowsBlockStructure(
##  >  ModuleGenerators(M), ModuleActionBlockSize(M));
##  [ [ 1, 0, 1, 1, 1 ], [ 1, 0, 1, 1, 1 ], [ 0, 1, 1, 1, 1 ], [ 0, 0, 1, 1, 1 ] ]
##  ]]></Log>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_GeneratingRowsBlockStructure,
  "generic method",
  [IsMatrix, IsRecord],
  function(gens, GA)
 
  local nrows, nblocks, r, i, blockstart, block, M, row;;

  nrows := Length(gens);
  nblocks := Length(gens[1]) / GA.actionBlockSize;
  if not IsInt(nblocks) then
    Error("The length of vectors in <gens> is not an integer multiple of <actionBlockSize>");
  fi;

  M := [];
  for r in gens do
    row := [];
    blockstart := 1;
    for i in [1..nblocks] do
      block := r{[blockstart..(blockstart+GA.actionBlockSize-1)]};
      blockstart := blockstart + GA.actionBlockSize;
      if IsZero(block) then
        Add(row, 0);
      else
        Add(row, 1);
      fi;
    od;
    Add(M, row);
  od;

  return M;

end);
#####################################################################
InstallOtherMethod(HAPPRIME_GeneratingRowsBlockStructure,
  "method for empty matrices",
  [IsEmpty, IsRecord],
  function(rows, GA)
    return [];
end);
#####################################################################
  


#####################################################################
##  <#GAPDoc Label="HAPPRIME_DisplayGeneratingRowsBlocks_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_DisplayGeneratingRowsBlocks" Arg="gens, actionBlockSize"/>
##
##  <Returns>
##    nothing
##  </Returns>
##  <Description>
##  Displays a set of &G;-generating rows a compact human-readable form. 
##  Each generating rows can be divided into blocks of length 
##  <A>actionBlockSize</A>.
##  The generating rows are displayed in a per-block form: a <K>*</K> where the
##  block is non-zero and <K>.</K> where the block is all zero.
##  <P/>
##  This function is used by <Ref Func="DisplayBlocks" Label="for FpGModuleGF"/> 
##  (for <K>FpGModuleGF</K>) and 
##  <Ref Func="DisplayBlocks" Label="for FpGModuleHomomorphismGF"/> (for 
##  <K>FpGModuleHomomorphismGF</K>).
##  </Description>
##  </ManSection>
##  <Log><![CDATA[
##  gap> HAPPRIME_DisplayGeneratingRowsBlocks(
##  >  ModuleGenerators(M), HAPPRIME_ModuleGroupAndAction(M));
##  [*.*..]
##  [...*.]
##  [....*]
##  [.*...]
##  [..*..]
##  [..*..] ]]></Log>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_DisplayGeneratingRowsBlocks,
  "generic method",
  [IsMatrix, IsRecord],
  function(gens, GA)

    local blocks, r, c;

    blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);

    for r in blocks do
      Print("[");
      for c in r do
        if IsZero(c) then
          Print(".");
        else
          Print("*");
        fi;
      od;
      Print("]\n");
    od;

end);
#####################################################################
InstallOtherMethod(HAPPRIME_DisplayGeneratingRowsBlocks,
  "for empty matrices",
  [IsEmpty, IsRecord],
  function(rows, GA)
    Print("[  ]\n");
end);
#####################################################################
  

#####################################################################
##  <#GAPDoc Label="HAPPRIME_IndependentGeneratingRows_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_IndependentGeneratingRows" Arg="blocks"/>
##
##  <Returns>
##    List of lists
##  </Returns>
##  <Description>
##  Given a block structure as returned by 
## <Ref Func="HAPPRIME_GeneratingRowsBlockStructure"/>, this decomposes a set
## of generating rows into sets of independent rows. These are returned as 
## a list of row indices, where each set of rows share no blocks with any other
## set.
##  </Description>
##  </ManSection>
##  <Log><![CDATA[
##  gap> DisplayBlocks(M);
##  Module over the group ring of Group( [ f1, f2, f3 ] )
##   in characteristic 2 with 6 generators in FG^5.
##  [**...]
##  [.*...]
##  [.**..]
##  [.**..]
##  [...*.]
##  [....*]
##  Generators are in minimal echelon form.
##  gap> gens := ModuleGenerators(M);;
##  gap> G := ModuleGroup(M);;
##  gap> blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, G);
##  [ [ 1, 1, 0, 0, 0 ], [ 0, 1, 0, 0, 0 ], [ 0, 1, 1, 0, 0 ], [ 0, 1, 1, 0, 0 ],
##    [ 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 1 ] ]
##  gap> HAPPRIME_IndependentGeneratingRows(blocks);
##  [ [ 1, 2, 3, 4 ], [ 5 ], [ 6 ] ]
##  ]]></Log>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_IndependentGeneratingRows, 
  "method for a block structure matrix",
  [IsMatrix],
  function(blocks)

    local length, generatorgroups, columngroup, merge, i, r, row, rowcolumns,
      groups, c, group, g;
  
    # One-pass algorithm akin to image connected-component labelling
    # First make a list of which generators are in which block columns,
    # and another list of which columns are shared by generators
    length := Length(blocks[1]);

    generatorgroups := [];
    columngroup := [];
    merge := [];
    for i in [1..length] do
      columngroup[i] := 0;
    od;

    for r in [1..Length(blocks)] do
      row := blocks[r];
      # We'll just skip empty rows  
      if IsZero(row) then 
        continue;
      fi;
      rowcolumns := [];
      groups := [];
      for c in [1..length] do
        if row[c] <> 0 then
          # Also find a list of existing group numbers to go with this row
          if columngroup[c] <> 0 then
            AddSet(groups, columngroup[c]);
          else;
            # Make a list of which columns are non-zero in this row and
            # don't have a group
            Add(rowcolumns, c);
          fi;
        fi;
      od;

      if IsEmpty(groups) then
        # If we've not found a group for this row then (at least at the
        # moment) it's a new group. 
        Add(generatorgroups, [r]);
        group := Length(generatorgroups);
      elif Length(groups) = 1 then
        # If we only have one group that this could belong to, then we assign
        # the row to that group
        Add(generatorgroups[group], r);
        group := groups[1];
      else
        # It could belong to several groups, which means that those groups
        # need to be merged. We'll do that merge, keeping only the smallest
        # group number (the other groups will be set to empty)
        group := groups[1];
        Add(generatorgroups[group], r);

        # Merge the groups
        for i in [2..Length(groups)] do
          g := groups[i];
          UniteSet(generatorgroups[group], generatorgroups[g]);
          generatorgroups[g] := [];
          # Now merge the numbers
          for c in [1..length] do
            if columngroup[c] = g then
              columngroup[c] := group;
            fi;
          od;
        od;
      fi;

      # Now mark each column in columngroup with this group number
      for c in rowcolumns do
        columngroup[c] := group;
      od;
    od;

    # We need to filter out any empty (i.e. merged) groups
    return Filtered(generatorgroups, i->not IsEmpty(i));
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_GactFGvector_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_GactFGvector" Arg="g, v, MT"/>
##
##  <Returns>
##    Vector
##  </Returns>
##
##  <Description>
##  Returns the vector that is the result of the action <M>u=gv</M> of the 
##  group element <A>g</A> on a module vector <A>v</A> (according to 
##  the group multiplication table <A>MT</A>.
##  This operation is the quickest current method for a single vector. 
##  To perform the same action on a set of vectors, it is faster write the
##  vectors as columns of a matrix and use
##  <Ref Func="HAPPRIME_GActMatrixColumns"/> instead.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_GactFGvector,
  [IsPosInt, IsVector, IsMatrix],
  function(g, v, MT)
  local 
    orderG,     # The order of the group
    u,          # The output vector
    nblocks,
    blockstart, # The element at the start of the current block in the vector
    i,          # Loop through the blocks
    elt,        # The current element from the vector
    t,          # The location that that element goes to under the group action
    field,      # The field of the vector
    zero,       # the zero of the field
    e;          # An element from the vector

#  field := Field(v[1]);
  orderG := Length(MT);
#  zero := Zero(field);
#  u := ListWithIdenticalEntries(Length(v), zero);
  u := ShallowCopy(v);
  nblocks := Length(v)/orderG;
  
  if not IsInt(nblocks) then
    Error("<v> must be an integer multiple of the order of the group in length");
  fi;

  blockstart := 0;
  for i in [0..(nblocks - 1)] do
    if not IsZero(v{[blockstart+1..blockstart+orderG]}) then
      for elt in [1..orderG] do
        t := blockstart + MT[g][elt];
        u[t] := v[blockstart + elt];
      od;
    fi;
    blockstart := blockstart + orderG;
  od;

#  ConvertToVectorRepNC(u, field);
  return u;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_CoefficientsOfGeneratingRowsDestructive_manGenMatInt">
##  <ManSection>
##  <Heading>HAPPRIME_CoefficientsOfGeneratingRowsXX</Heading>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRows" Arg="gens, GA, v" Label="for vector"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRows" Arg="gens, GA, coll" Label="for collection of vectors"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsDestructive" Arg="gens, GA, v" Label="for vector"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsDestructive" Arg="gens, GA, coll" Label="for collection of vectors"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsGF" Arg="gens, GA, v" Label="for vector"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsGF" Arg="gens, GA, coll" Label="for collection of vectors"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive" Arg="gens, GA, v" Label="for vector"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive" Arg="gens, GA, coll" Label="for collection of vectors"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2" Arg="gens, GA, v" Label="for vector"/>
##  <Oper Name="HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2" Arg="gens, GA, coll" Label="for collection of vectors"/>
##
##  <Returns>
##   Vector, or list of vectors
##  </Returns>
##  <Description>
##  For a single vector <A>v</A>, this function returns a vector <M>x</M> giving 
##  the &G;-coefficients from <A>gens</A> needed to generate <A>v</A>, i.e.
##  the solution to the equation <M>x*A=v</M>, where <M>A</M> is the expansion 
##  of <A>gens</A>. If there is no solution, <K>fail</K> is returned. If a list 
##  of vectors, <A>coll</A>, then a vector is returned that lists the solution 
##  for each vector (any of which may be <K>fail</K>).
##  The standard forms of this function use standard linear algebra to solve
##  for the coefficients. The <C>Destructive</C> version will corrupt both
##  <A>gens</A> and <A>v</A>. The <C>GF</C> versions use the block structure of 
##  the generating rows to expand only the blocks that are needed to find the 
##  solution before using linear algebra. If the generators are in echelon form, 
##  this can save memory, but is slower.
##  <P/>
##  The <C>GFDestructive2</C> functions also assume an echelon form for the
##  generators, but use back-substitution to find a set of coefficients.
##  This can save a lot of memory but is again slower.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRowsDestructive, 
  [IsMatrix and IsMutable, IsRecord, IsVector and IsMutable],
  function(gens, GA, v)

    local Fbasis;

    if Length(v) <> Length(gens[1]) then
      Error("rows of <gens> must be the same length as <v>");
    fi;

    Fbasis := HAPPRIME_ExpandGeneratingRows(gens, GA);
    return SolutionMatDestructive(Fbasis, v);
end);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRows, 
  "generic method",
  [IsMatrix, IsRecord, IsVector],
  function(gens, GA, v)
    local genscopy, vcopy;
    genscopy := MutableCopyMat(gens);
    vcopy := ShallowCopy(v);
    return HAPPRIME_CoefficientsOfGeneratingRowsDestructive(
      genscopy, GA, vcopy);
end);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRowsDestructive, 
  "generic method",
  [IsMatrix and IsMutable, IsRecord, IsMatrix and IsMutable],
  function(gens, GA, coll)

    local Fbasis;
  
    if Length(coll[1]) <> Length(gens[1]) then
      Error("rows of <gens> must be the same length as vectors in <coll>");
    fi;

    Fbasis := HAPPRIME_ExpandGeneratingRows(gens, GA);
    return SolutionMatDestructive(Fbasis, coll);
end);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRows, 
  "generic method",
  [IsMatrix, IsRecord, IsMatrix],
  function(gens, GA, coll)
    local genscopy, collcopy;
    genscopy := MutableCopyMat(gens);
    collcopy := MutableCopyMat(coll);
    return HAPPRIME_CoefficientsOfGeneratingRowsDestructive(
      genscopy, GA, collcopy);
end);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive, 
  "generic method",
  [IsMatrix and IsMutable, IsRecord, IsVector and IsMutable],
  function(gens, GA, v)
  
    local blocks, decomp, d, rowblocks, rowstoexpand, padzeros, i, 
      Fbasis, w, result, elms, orderG;
  
    if Length(v) <> Length(gens[1]) then
      Error("rows of <gens> must be the same length as <v>");
    fi;
  
    blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);
    # How do the blocks decompose?
    decomp := HAPPRIME_IndependentGeneratingRows(blocks);

    if Length(decomp) = 1 then
      rowstoexpand := [1..Length(gens)];
      padzeros := false;
    else
      # What is the block structure of v?
      rowblocks := HAPPRIME_GeneratingRowsBlockStructure([v], GA)[1];
      # Which rows do I need to expand?
      rowstoexpand := [];
      padzeros := false;
      for d in decomp do
        if Sum(blocks{d}) * rowblocks <> 0 then
          UniteSet(rowstoexpand, d);
        else
          padzeros := true;
        fi;
      od;

      if IsEmpty(rowstoexpand) then
        return fail;
      fi;
    fi;

    Fbasis := HAPPRIME_ExpandGeneratingRows(gens{rowstoexpand}, GA);
    w := SolutionMatDestructive(Fbasis, v);

    if w = fail then
      return fail;
    fi;

    if padzeros then
      orderG := Order(GA.group);
      # Now put zeros back in
      result := ListWithIdenticalEntries(
        Length(gens)*orderG, Zero(gens[1][1]));
      ConvertToVectorRepNC(result, Field(gens[1][1]));
      elms := [1..orderG];
      for i in [1..Length(rowstoexpand)] do
        result{elms + (rowstoexpand[i] - 1)*orderG} := w{elms + (i-1)*orderG};
      od;
      return result;
    else
      return w;
    fi;
end);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRowsGF, 
  [IsMatrix, IsRecord, IsVector],
  function(gens, GA, v)
    local genscopy, vcopy;
    genscopy := MutableCopyMat(gens);
    vcopy := ShallowCopy(v);
    return HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive(
      genscopy, GA, vcopy);
end);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive, 
  [IsMatrix and IsMutable, IsRecord, IsMatrix and IsMutable],
  function(gens, GA, coll)

    local blocks, decomp, d, rowblocks, rowstoexpand, i, padzeros,
      Fbasis, W, j, result, elms, orderG;
  
    if Length(coll[1]) <> Length(gens[1]) then
      Error("rows of <gens> must be the same length as rows in <coll>");
    fi;
  
    blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);
    # How do the blocks decompose?
    decomp := HAPPRIME_IndependentGeneratingRows(blocks);

    if Length(decomp) = 1 then
      rowstoexpand := [1..Length(gens)];
      padzeros := false;
    else
      # What is the block structure of coll?
      rowblocks := Sum(
        HAPPRIME_GeneratingRowsBlockStructure(coll, GA));
      # Which rows do I need to expand?
      rowstoexpand := [];
      padzeros := false;
      for d in decomp do
        if Sum(blocks{d}) * rowblocks <> 0 then
          UniteSet(rowstoexpand, d);
        else
          padzeros := true;
        fi;
      od;

      if IsEmpty(rowstoexpand) then
        return ListWithIdenticalEntries(Length(coll), fail);
      fi;
    fi;

    Fbasis := HAPPRIME_ExpandGeneratingRows(gens{rowstoexpand}, GA);;
    W := SolutionMatDestructive(Fbasis, coll);

    if padzeros then
      orderG := Order(GA.group);
      # Now put zeros back in
      result := NullMat(Length(W), Length(gens)*orderG, Field(gens[1][1]));
      for j in [1..Length(W)] do
        if W[j] = fail then
          result[j] := fail;
        else
          elms := [1..orderG];
          for i in [1..Length(rowstoexpand)] do
            result[j]{elms + (rowstoexpand[i] - 1)*orderG} := 
              W[j]{elms + (i-1)*orderG};
          od;
        fi;
      od;
      return result;
    else
      return W;
    fi;
end);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRowsGF, 
  "generic method",
  [IsMatrix, IsRecord, IsMatrix],
  function(gens, GA, coll)
    local genscopy, collcopy;
    genscopy := MutableCopyMat(gens);
    collcopy := MutableCopyMat(coll);
    return HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive(
      genscopy, GA, collcopy);
end);
#####################################################################
InstallOtherMethod(HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2, 
  [IsMatrix and IsMutable, IsRecord, IsVector and IsMutable, IsList and IsMutable],
  function(gens, GA, elm, prevK)
    return HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2(
      gens, GA, [elm], prevK)[1];
  end
);
#####################################################################
InstallMethod(HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2, 
  [IsMatrix and IsMutable, IsRecord, IsMatrix and IsMutable, IsList and IsMutable],
  function(gens, GA, coll, prevK)

    local blocks, n, firstblock, otherblock, SplitMatrixDestructive, temp,
    a, b, Bexpanded, Cexpanded, D, kerB, pos, field, zeros, i, v, xbar, bprime, 
    kerBC, yprime, preimages, goodxbars,
    tempD, tempbprime, tempkerBC;
   
    # we divide the matrix into blocks to solve [x y] [ B C ] = [a b]
    #                                                 [ 0 D ]
    #
    # We will solve the expansion
    #        xB = a
    #   xC + yD = b
    # where a particular solution is
    #   x = preim(a) + k*ker(B)
    # where preim(a) is any preimage representative and k*ker(B) is some
    # vector from the kernel of B selected by a list of coefficients k.
    # substituting, we get
    #   preim(a)*C + k*ker(B)*C + yD = b
    # and gathering the knowns and unknowns
    #   [k y] [ker(B)*C] = b - preim(A)*C
    #         [   D    ]
    # which we can solve recursively by writing it as 
    #         y'D' = b'
    # and solving for y', which gives both y and k to put into the solution
    #   [x y] = [preim(a) + k*ker(B) | y]
        
    if Length(coll[1]) <> Length(gens[1]) then
      Error("rows of <gens> must be the same length as rows in <coll>");
    fi;
    if not IsEmpty(prevK) and Length(prevK[1]) <> Length(gens[1]) then
      Error("rows of <gens> must be the same length as rows in <prevK>");
    fi;

    # Prepare the answers with everything failing
    preimages := List([1..Length(coll)], i->fail);

    # divide the generators into blocks [B C]
    #                                   [0 D]
    blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);
    # Find the number of bottom rows starting with zero
    n := Length(blocks);
    while n > 0 and blocks[n][1] = 0 do
      n := n - 1;
    od;
    # Are there no zeros at the bottom?
    if n = Length(blocks) or Length(gens) = 1 then
      # All we can do is expand all of gens, append them to prevK and find a 
      # solution
      temp := HAPPRIME_ExpandGeneratingRows(gens, GA);
      if not IsEmpty(prevK) then
        temp := Concatenation(prevK, temp);
        # And wipe prevK to save memory
        for i in [1..Length(prevK)] do
          prevK[i] := [];
        od;
      fi;
      return SolutionMatDestructive(temp, coll);
    elif n = 0 then 
      # else is the whole column zero?
      # if so, B may still be non-zero since we append prevK.
      # if we have prevK then leave n as zero, otherwise set it to one
      # so that at least we have something
      if IsEmpty(prevK) then
        n := 1;
      fi;
    fi;

    firstblock := [1..(GA.actionBlockSize)];
    otherblock := [(GA.actionBlockSize)+1..Length(gens[1])];
    ################################
    ## Split a matrix into the first n columns and the rest
    SplitMatrixDestructive := function(A, n)
      local i, v, B, C;
      
      if n = 0 then
        return [[], A];
      elif n = Length(A[1]) then 
        return [A, []];
      fi;
      
      B := [];
      C := [];
      for i in [1..Length(A)] do
        v := Remove(A, 1);
        Add(B, v{[1..n]});
        Add(C, v{[n+1..Length(v)]});
      od;
      return [B, C];
    end;
    ################################

    # Split coll into [a b] sections
    temp := SplitMatrixDestructive(coll, GA.actionBlockSize);
    a := temp[1];
    b := temp[2];

    # Remove the top rows from gens
    temp := [];
    for i in [1..n] do
      Add(temp, Remove(gens, 1));
    od;
    # Chop up the rest of gens now to make D
    for i in [1..Length(gens)] do
      gens[i] := gens[i]{otherblock};
    od;
    D := gens;
    # expand the rows we have taken off and add them to (a copy of)
    # prevK. Since there are only a few generators in the top rows, this
    # should all be manageable
    temp := HAPPRIME_ExpandGeneratingRows(temp, GA);
    if not IsEmpty(prevK) then
      temp := Concatenation(prevK, temp);
      # And wipe prevK to save memory
      for i in [1..Length(prevK)] do
        prevK[i] := [];
      od;
    fi;
    Info(InfoHAPprime, 2, "Preimage of module homomorphism: expanded matrix is ", 
      PrintDimensionsMat(temp), " = ", Product(DimensionsMat(temp)));
    # now split into B and C
    temp := SplitMatrixDestructive(temp, GA.actionBlockSize);
    Bexpanded := temp[1];
    Cexpanded := temp[2];
    Unbind(temp);

    # Find the kernel of B
    # This is an F-basis
    if IsZero(Bexpanded) then
      # With zero generators, the whole source module is the kernel  
      # We want a set of coefficients that span the entire source module
      field := Field(gens[1][1]);
      kerB := DiagonalMat(ListWithIdenticalEntries(
        Length(Bexpanded), One(field)));
      ConvertToMatrixRepNC(kerB, field);
    else
      kerB := NullspaceMat(Bexpanded);;
    fi;

    # Find x' where x' is a possible solution to x'*B = a 
    xbar := SolutionMatDestructive(Bexpanded, a);
    # now we don't need B any more
    Unbind(Bexpanded);

    # some of these may have failed. Remove these, and remember where the
    # good ones are. Do this backwards so that remove works nicely
    goodxbars := [];
    for i in [Length(xbar), Length(xbar)-1..1] do
      if xbar[i] = fail then
        Remove(xbar, i);
        Remove(b, i);
      else
        Add(goodxbars, i);
      fi;
    od;
    goodxbars := Reversed(goodxbars);


    # if there are no possible xbars then we can't have any solutions
    # return our initial list of fails
    if IsEmpty(xbar) then
      return preimages;
    fi;

    # now compute b - x'*C
    bprime := b - xbar*Cexpanded;
    # and kerB*C
    if not IsEmpty(kerB) and not IsZero(kerB) then
      kerBC := kerB * Cexpanded;
    else
      kerBC := [];
    fi;
    # Now get rid of C
    Unbind(Cexpanded);
    
    # and call ourselves to find the a preimage of
    # [k y]D' = b'
    tempD := MutableCopyMat(D);
    tempbprime := MutableCopyMat(bprime);
    tempkerBC := MutableCopyMat(kerBC);
    yprime := HAPPRIME_CoefficientsOfGeneratingRowsGFDestructive2(
      tempD, GA, tempbprime, tempkerBC);
    # See if any have failed
    for i in [Length(yprime), Length(yprime)-1..1] do  
      if yprime[i] = fail then
        Remove(yprime, i);
        Remove(xbar, i);  
        Remove(goodxbars, i);  
      fi;
    od;      
    
    # If we have no yprimes left, then we have no solutions. Return the 
    # preimages that we earlier set to all fail.
    if IsEmpty(yprime) then
      return preimages;
    fi;
    
    
    yprime := SplitMatrixDestructive(yprime, Length(kerB));
    # The first |kerB| elements in y are the coefficients of kerB, so 
    # multiply by those. 
    # Create the return list 
    if not IsEmpty(kerB) and not IsZero(kerB) then
      for i in [1..Length(xbar)] do
        preimages[goodxbars[i]] :=
          Concatenation(xbar[i] + yprime[1][i]*kerB, yprime[2][i]);
      od;
    else
      for i in [1..Length(xbar)] do
        preimages[goodxbars[i]] := Concatenation(xbar[i], yprime[2][i]);
      od;
    fi;
    return preimages;
  end
);
#####################################################################



#####################################################################
##  <#GAPDoc Label="HAPPRIME_GenerateFromGeneratingRowsCoefficients_manGenMatInt">
##  <ManSection>
##  <Heading>HAPPRIME_GenerateFromGeneratingRowsCoefficientsXX</Heading>
##  <Oper Name="HAPPRIME_GenerateFromGeneratingRowsCoefficients" Arg="gens, GA, c" Label="for vector"/>
##  <Oper Name="HAPPRIME_GenerateFromGeneratingRowsCoefficients" Arg="gens, GA, coll" Label="for collection of vectors"/>
##  <Oper Name="HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF" Arg="gens, GA, c" Label="for vector"/>
##  <Oper Name="HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF" Arg="gens, GA, coll" Label="for collection of vectors"/>
##
##  <Returns>
##    Vector, or list of vectors
##  </Returns>
##  <Description>
##  For a vector <A>c</A>, returns (as a vector), the module element generated
##  by multiplying <A>c</A> by the expansion of the generators <A>gens</A>. For
##  a list of coefficient vectors <A>coll</A>, this returns a list of generating
##  vectors.
##  <P/>
##  The standard versions of this function use standard linear algebra. The
##  <C>GF</C> versions only performs the expansion of necessary generating rows,
##  and only expands by one group element at a time, so will only need at most
##  twice the amount of memory as that to store <A>gens</A>, which is a large
##  saving over expanding the generators by every group element at the same 
##  time, as in a naive implementation. It may also be faster.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_GenerateFromGeneratingRowsCoefficients, 
  "for vector",
  [IsMatrix, IsRecord, IsVector],
  function(gens, GA, v)
    
    local Fbasis;
    if Length(v) <> Length(gens) * Order(GA.group) then
      Error("the length of <v> must be the same as the number rows of <gens> times the order of the group");
    fi;
    Fbasis := HAPPRIME_ExpandGeneratingRows(gens, GA);
    return v * Fbasis;
end);
#####################################################################
InstallMethod(HAPPRIME_GenerateFromGeneratingRowsCoefficients, 
  "for list of vectors",
  [IsMatrix, IsRecord, IsMatrix],
  function(gens, GA, coll)
    
    local Fbasis;
    if Length(coll[1]) <> Length(gens) * Order(GA.group) then
      Error("the length of vectors in <coll> must be the same as the number rows of <gens> times the order of the group");
    fi;
    Fbasis := HAPPRIME_ExpandGeneratingRows(gens, GA);
    return coll * Fbasis;
end);
#####################################################################
InstallMethod(HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF, 
  "for vector",
  [IsMatrix, IsRecord, IsVector],
  function(gens, GA, v)
  
    local orderG, nblocks, field, MT, answer, elms, g, v_set, gens_set, i, eltsG;
  
    orderG := Order(GA.group);
    nblocks := Length(v) / GA.actionBlockSize;
    field := Field(gens[1][1]);

    if Length(v) <> Length(gens) * orderG then
      Error("the length of <v> must be the same as the number rows of <gens> times the order of the group");
    fi;

    answer := ListWithIdenticalEntries(Length(gens[1]), Zero(field));
    # We shall work a group element at a time. Which elements from v 
    # correspond to the first group element?
    elms := [];
    g := 1;
    for i in [1..nblocks] do
      Add(elms, g);
      g := g + orderG;
    od;

    for g in Elements(GA.group) do
      # Now see which elements of v{elms} are non-zero
      v_set := [];
      gens_set := [];
      for i in [1..nblocks] do
        if not IsZero(v[elms[i]]) then
          Add(v_set, v[elms[i]]);
          Add(gens_set, gens[i]);
        fi;
      od;

      if Length(gens_set) > 1 then
        # Now multiply all the rows in gens_set by g
        ConvertToMatrixRepNC(gens_set, field);
        gens_set := TransposedMatMutable(gens_set);
        gens_set := HAPPRIME_GActMatrixColumns(g, gens_set, GA);
        gens_set := TransposedMatMutable(gens_set);
        # Do the matrix multiplication
        answer := answer + v_set * gens_set;
      elif Length(v_set) = 1 then
        answer := answer + v_set[1] * GA.action(g, gens_set[1]);
      fi;
      elms := elms + 1;
    od;
    return answer;  
end);
#####################################################################
InstallMethod(HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF, 
  "for list of vectors",
  [IsMatrix, IsRecord, IsMatrix],
  function(gens, GA, coll)
  
    local orderG, nblocks, field, MT, collsum, answer, elms, g, coll_vset, 
      gens_set, i, coll_set;
  
    orderG := Order(GA.group);
    nblocks := Length(coll[1]) / GA.actionBlockSize;
    field := Field(gens[1][1]);

    if Length(coll[1]) <> Length(gens) * orderG then
      Error("the length of vectors in <coll> must be the same as the number rows of <gens> times the order of <G>");
    fi;
  
    # Add up the rows of coll (over the integers) to find out which
    # columns have some entries in
    collsum := ListWithIdenticalEntries(Length(coll[1]), 0);
    for i in coll do
      collsum := collsum + IntVecFFE(i);
    od;

    answer := NullMat(Length(coll), Length(gens[1]), field);
    # Gens tells me where the identity of the input vector maps to.
    # The identity in each block is the first element. Make a vector of those
    elms := [];
    g := 1;
    for i in [1..nblocks] do
      Add(elms, g);
      g := g + orderG;
    od;

    for g in Elements(GA.group) do
      # Now see which elements of collsum{elms} are non-zero
      coll_vset := [];
      gens_set := [];
      for i in [1..nblocks] do
        if not IsZero(collsum[elms[i]]) then
          Add(coll_vset, elms[i]);
          Add(gens_set, gens[i]);
        fi;
      od;
      coll_set := MutableCopyMat(coll);
      for i in [1..Length(coll)] do
        coll_set[i] := coll_set[i]{coll_vset};
      od;

      if Length(gens_set) > 1 then
        # Now multiply all the rows in gens_set by g
        ConvertToMatrixRepNC(gens_set, field);
        gens_set := TransposedMatMutable(gens_set);
        gens_set := HAPPRIME_GActMatrixColumns(g, gens_set, GA);
        gens_set := TransposedMatMutable(gens_set);
        # And add them up
        answer := answer + coll_set * gens_set;
      elif Length(gens_set) = 1 then
        answer := answer + coll_set * [GA.action(g, gens_set[1])];
      fi;
      elms := elms + 1;
    od;
    return answer;  
end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="HAPPRIME_RemoveZeroBlocks_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_RemoveZeroBlocks" Arg="gens, GA"/>
##
##  <Returns>
##    Vector
##  </Returns>
##  <Description>
##  Removes from a set of generating vectors <A>gens</A> (with 
##  <Ref Func="ModuleGroupAndAction"/> <A>GA</A>) any blocks that are zero in 
##  every generating vector. Removal is done in-place, i.e. the input argument
##  <A>gens</A> will be modified to remove the zero blocks.
##  Zero blocks are unaffected by any row or expansion operation, and can be
##  removed to save time or memory in those operations. The function returns
##  the original block structure as a vector, and this can be used in the 
##  function <Ref Oper="HAPPRIME_AddZeroBlocks"/> to reinstate the zero blocks 
##  later, if required. See the documentation for that function for more detail 
##  of the block structure vector.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_RemoveZeroBlocks, 
  [IsMatrix, IsRecord],
  function(gens, GA)

    local blocks, blockStart, blockSize, blockEndOffset, keep, b, i;
  
    blocks := Sum(HAPPRIME_GeneratingRowsBlockStructure(gens, GA));
    
    # Check there aren't no zeros
    if Position(blocks, 0) = fail then
      return blocks;
    fi;

    # OK - there are some zeros, so let's remove them
    blockStart := 1;
    blockSize := GA.actionBlockSize;
    blockEndOffset := blockSize - 1;
    keep := [];
    for b in blocks do
      if not IsZero(b) then
        Append(keep, [blockStart..blockStart+blockEndOffset]);
      fi;
      blockStart := blockStart + blockSize;
    od;
    for i in [1..Length(gens)] do
      gens[i] := gens[i]{keep};
    od;
    return blocks;  
end);
#####################################################################

#####################################################################
##  <#GAPDoc Label="HAPPRIME_AddZeroBlocks_manGenMatInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_AddZeroBlocks" Arg="gens, blockStructure, GA"/>
##
##  <Returns>
##    List of vectors
##  </Returns>
##  <Description>
##  Adds zero blocks to a set of generating vectors <A>gens</A> to make it 
##  have the block structure given in <A>blockStructure</A> (for a given
##  <Ref Func="ModuleGroupAndAction"/> <A>GA</A>). The generators <A>gens</A> 
##  are modified in place, and also returned. 
##  <P/>
##  The <A>blockStructure</A> parameter is a vector of which is the length 
##  of the required output vector and has zeros where zero blocks should be,
##  and is non-zero elsewhere. Typically, an earlier call to 
##  <Ref Func="HAPPRIME_RemoveZeroBlocks"/> will have been used to remove the 
##  zero blocks, and this function and such a <A>blockStructure</A> vector is
##  returned by this function. <Ref Func="HAPPRIME_AddZeroBlocks"/> can be
##  used to reinstate these zero blocks.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_AddZeroBlocks, 
  [IsMatrix, IsVector, IsRecord],
  function(gens, blocks, GA)

    local blockSize, blockStart, blockEndOffset, zeroblock, blockStore, last,
      currentblock, b, bi, gi, gen;
  
    # Check there aren't no zeros
    if Position(blocks, 0) = fail then
      return gens;
    fi;

    # OK, we need to add some zeros
    blockSize := GA.actionBlockSize;
    blockStart := 1;
    blockEndOffset := blockSize - 1;

    zeroblock := ListWithIdenticalEntries(blockSize, Zero(gens[1][1]));
    ConvertToVectorRepNC(zeroblock, Field(gens[1][1]));

    blockStore := []; # Stores the breakdown of what to do with the blocks
    last := ""; # What was the last block?
    # currentblock accumulates the current meta-block. This is either a
    # vector of zeros (crossing one or more blocks), or a list of indices
    # into gens to copy out.
    for b in blocks do
      if not IsZero(b) then  # nonzero - copy some of gens
        if last = "zeros" then
          Add(blockStore, currentblock);
        fi;
        if last <> "gens" then
          currentblock := [];
        fi;
        Append(currentblock, [blockStart..blockStart+blockEndOffset]);
        blockStart := blockStart + blockSize;
        last := "gens";
      else # zero - add some zeros
        if last = "gens" then
          Add(blockStore, currentblock);
        fi;
        if last <> "zeros" then
          currentblock := ShallowCopy(zeroblock);
          last := "zeros";
        else
          Append(currentblock, zeroblock);
        fi;
      fi;
    od;
    Add(blockStore, currentblock);
    Unbind(currentblock);

    # Now construct the extended generators by looking at blockStore
    for gi in [1..Length(gens)] do
      if IsZero(blockStore[1]) then
        gen := ShallowCopy(blockStore[1]);
      else
        gen := gens[gi]{blockStore[1]};
      fi;
      for bi in [2..Length(blockStore)] do
        if IsZero(blockStore[bi]) then
          Append(gen, blockStore[bi]);
        else
          Append(gen, gens[gi]{blockStore[bi]});
        fi;
      od;
      gens[gi] := gen;
    od;
    return gens;  
end);
#####################################################################





testSolutionMultiply := function()

local gens, G, XX, V, i, v, X2, x, Vfast, vfast, X2fast, V2fast, xfast, V2,
 action, groupAndAction;

  gens := RandomMat(4, 256, GF(2));
  G := SmallGroup(64, 25);
  
  XX := RandomMat(4, 256, GF(2));
  
  action := CanonicalAction(G);
  groupAndAction := rec(group := G, action := action, actionBlockSize := Order(G));
    
  Vfast := HAPPRIME_GenerateFromGeneratingRowsCoefficients(gens, groupAndAction, XX);
  V := HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF(gens, groupAndAction, XX);
  
  Assert(0, V = Vfast);

  for i in [1..Length(XX)] do
    v := HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF(gens, groupAndAction, XX[i]);
    vfast := HAPPRIME_GenerateFromGeneratingRowsCoefficients(gens, groupAndAction, XX[i]);
    Assert(0, v = V[i]);
    Assert(0, vfast = V[i]);
  od;
    
  X2 := HAPPRIME_CoefficientsOfGeneratingRowsGF(gens, groupAndAction, V);
  X2fast := HAPPRIME_CoefficientsOfGeneratingRows(gens, groupAndAction, V);
    
  V2 := HAPPRIME_GenerateFromGeneratingRowsCoefficientsGF(gens, groupAndAction, X2);
  Assert(0, V2 = V);
  V2fast := HAPPRIME_GenerateFromGeneratingRowsCoefficients(gens, groupAndAction, X2fast);
  Assert(0, V2fast = Vfast);
  
  for i in [1..Length(V)] do
    x := HAPPRIME_CoefficientsOfGeneratingRowsGF(gens, groupAndAction, V[i]);
    Assert(0, x = X2[i]);
    xfast := HAPPRIME_CoefficientsOfGeneratingRows(gens, groupAndAction, V[i]);
    Assert(0, xfast = X2fast[i]);
  od;

end;
  
  
testRowBlocks := function()
  local gens, G, M,  MM, N;

  G := SmallGroup(8, 5);
  gens := RandomMat(6, 40, GF(2));;
  M := FpGModuleGF(gens, G);
  DirectDecompositionOfModule(M);
end;
  

testKernel := function()

  local G, S, T, im, phi, kernel1, kernel2, kernel3;

  G := SmallGroup(8, 5);
  S := FpGModuleGF(G, 5);  
  T := FpGModuleGF(G, 5);  
  
  im := FpGModuleGF(RandomElement(T, 5), G);
  EchelonModuleGeneratorsDestructive(im);
  ReverseEchelonModuleGeneratorsDestructive(im);
  DisplayBlocks(im);
      
  if Length(ModuleGenerators(im)) = 5 then
  
    phi := FpGModuleHomomorphismGF(S, T, ModuleGenerators(im));
    
    kernel1 := KernelOfModuleHomomorphism(phi);
    kernel2 := KernelOfModuleHomomorphismSplit(phi);
    kernel3 := KernelOfModuleHomomorphismIndependentSplit(phi);
    
    Assert(0, kernel1 = kernel2);
    Assert(0, kernel1 = kernel3);
  else
    Print("try again\n");  
  fi;
      
end;
  
  