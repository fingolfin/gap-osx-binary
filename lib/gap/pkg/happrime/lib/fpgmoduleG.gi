#############################################################################
##
##  HAPPRIME - fpgmoduleG.gi
##  Functions, Operations and Methods to implement FG modules
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
##  $Id: fpgmoduleG.gi 354 2008-12-09 17:38:12Z pas $
##
#############################################################################


#####################################################################
##  <#GAPDoc Label="FpGModuleGFRep_DTmanFpGModuleNODOC">
##  <ManSection>
##  <Filt Name="IsFpGModuleGFRep" Arg="O" Type="Representation"/>
##  <Description>
##  Returns <K>true</K> if the object is in the internal representation used for 
##  a <K>FpGModuleGF</K>, or <K>false</K> otherwise
##  </Returns>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
DeclareRepresentation(
  "IsFpGModuleGFRep",
  IsComponentObjectRep,
  ["groupAndAction", "generators", "ambientDimension"]);
# Note this also defines the function IsFpGModuleGFRep
#####################################################################

#####################################################################
# The type for FpGModuleGFs is a FpGModuleGF in 
# FpGModuleGFRep representation, in the FpGModuleGF family
FpGModuleGFType := 
  NewType(NewFamily("FpGModuleGFFamily"), 
    IsFpGModuleGF and IsFpGModuleGFRep);
#####################################################################
  
  

#####################################################################
##  <#GAPDoc Label="FpGModuleGF_DTmanFpGModule_Con">
##  <ManSection Label="FpGModuleConstructors">
##  <Heading>FpGModuleGF construction functions</Heading>
##  <Oper Name="FpGModuleGF" Arg="gens, G [, action, actionBlockSize]" Label="construction from generators, group and action"/>
##  <Oper Name="FpGModuleGF" Arg="gens, groupAndAction" Label="construction from generators and groupAndAction"/>
##  <Oper Name="FpGModuleGF" Arg="ambientDimension, G [, action, actionBlockSize]" Label="construction of empty module from group and action"/>
##  <Oper Name="FpGModuleGF" Arg="ambientDimension, groupAndAction" Label="construction of empty module from groupAndAction"/>
##  <Oper Name="FpGModuleGF" Arg="G, n" Label="construction of full canonical module"/>
##  <Oper Name="FpGModuleGF" Arg="groupAndAction, n" Label="construction of full canonical module from groupAndAction"/>
##  <Oper Name="FpGModuleGF" Arg="HAPmod" Label="construction from FpGModule"/>
##  <Oper Name="FpGModuleGFNC" Arg="gens, G, form, action, actionBlockSize" Label="construction from generators, group and action"/>
##  <Oper Name="FpGModuleGFNC" Arg="ambientDimension, G, action, actionBlockSize" Label="construction for empty module with group and action"/>
##  <Oper Name="FpGModuleGFNC" Arg="gens, groupAndAction [, form]" Label="construction from generators and groupAndAction"/>
##
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Creates and returns a <K>FpGModuleGF</K> module object. The most commonly-used
##  constructor requires a list of generators <A>gens</A> and a group <A>G</A>.
##  The group action and block size can be specified using the <A>action</A>
##  and <A>actionBlockSize</A> parameters, or if these are omitted then the 
##  canonical action is assumed. These parameters can also be wrapped up
##  in a <C>groupAndAction</C> record (see <Ref Sect="FpGModuleGFdatatype"/>).
##  <P/>
##  An empty <K>FpGModuleGF</K> can be constructed by specifying a group and an 
##  <A>ambientDimension</A> instead of a set of generators. A module
##  spanning &FGn; with canonical generators and action
##  can be constructed by giving a group <A>G</A> and a rank <A>n</A>.
##  A <K>FpGModuleGF</K> can also be constructed from a 
##  &HAP; <K>FpGModule</K> <A>HAPmod</A>.
##  <P/> 
##  The generators in a <K>FpGModuleGF</K> do not need to be a minimal set. If 
##  you wish to create a module with minimal generators, construct the module
##  from a non-minimal set <A>gens</A> and then
##  use one of &TheMinGenFuncs;. When constructing a 
##  <K>FpGModuleGF</K> from a <K>FpGModule</K>, the &HAP;
##  function <Ref Func="GeneratorsOfFpGModule" BookName="HAP"/> is used to provide a set of 
##  generators, so in this case the generators will be minimal.
##  <P/> 
##  Most of the forms of this function perform a few (cheap) tests to make
##  sure that the arguments are self-consistent. The <C>NC</C> versions of the 
##  constructors are provided for internal use, or when you know what you are 
##  doing and wish to skip the tests.
##  See Section <Ref Subsect="FPGModuleExample0"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(FpGModuleGF,
  "from generators assuming canonical action",
  [IsMatrix, IsGroup],
  function(gens, group)
    return FpGModuleGF(gens, group, CanonicalAction(group), Order(group));
end);
#####################################################################
InstallMethod(FpGModuleGF,
  "from generators with groupAndAction",
  [IsMatrix, IsRecord],
  function(gens, groupAndAction)
    if not IsBound(groupAndAction.group) then
      Error("The <groupAndAction> record must have an component called 'group'");
    fi;
    if not IsBound(groupAndAction.action) then
      Error("The <groupAndAction> record must have an component called 'action'");
    fi;
    if not IsBound(groupAndAction.actionBlockSize) then
      Error("The <groupAndAction> record must have an component called 'actionBlockSize'");
    fi;
    return FpGModuleGF(
      gens, groupAndAction.group, groupAndAction.action, 
      groupAndAction.actionBlockSize);
end);
#####################################################################
InstallMethod(FpGModuleGF,
  "from generators with specified action",
  [IsMatrix, IsGroup, IsFunction, IsPosInt],
  function(gens, group, action, actionBlockSize)
    local nblocks, form, g, sumgens;
    # Check that the arguments are all self-consistent
    if not IsPGroup(group) then
      Error("<group> must be a p-group");
    fi;
    if actionBlockSize < Order(group) then
      Error("<actionBlockSize> has to be at least as big as the order of <group>");
    fi;
    if not IsInt(Length(gens[1]) / actionBlockSize) then
      Error("vectors in <gens> are not a multiple of <actionBlockSize> in length");
    fi;
    if Field(gens[1][1]) <> GaloisField(PrimePGroup(group)) then
      Error("the field of <gens> is not the same as the prime of the group");
    fi;
    # Check that the action appears to work as it should do
    g := Elements(group)[2]; # this is probably not the identity
    sumgens := Sum(gens); # This should probably have elements in most places
    if action(Inverse(g), action(g, sumgens)) <> sumgens then
      Error("<action> does not appear to work properly");
    fi;
    # What do we know about the echelon form?  
    if Length(gens) < 2 then  
      form := "echelon";
    else
      form := "unknown";
    fi;
    return FpGModuleGFNC(gens, group, form, action, actionBlockSize);  
  end
);
#####################################################################
InstallOtherMethod(FpGModuleGF,
  "from empty generators and group",
  [IsEmpty, IsGroup],
  function(gens, group)
    Error("<gens> is empty, so you need to provide an ambient dimension");
end);
#####################################################################
InstallOtherMethod(FpGModuleGF,
  "from empty generators and groupAndAction",
  [IsEmpty, IsRecord],
  function(gens, groupAndAction)
    Error("<gens> is empty, so you need to provide an ambient dimension");
end);
#####################################################################
InstallOtherMethod(FpGModuleGF,
  "from empty generators and specified action",
  [IsEmpty, IsGroup, IsFunction, IsPosInt],
  function(gens, group, action, actionBlockSize)
    Error("<gens> is empty, so you need to provide an ambient dimension");
  end
);
#####################################################################
InstallMethod(FpGModuleGF,
  "zero module assuming canonical action",
  [IsPosInt, IsGroup],
  function(ambientDimension, G)
    if not IsPGroup(G) then
      Error("<group> must be a p-group");
    fi;
    return FpGModuleGFNC(
      [], G, CanonicalAction(G), Order(G), ambientDimension);
  end
);
#####################################################################
InstallMethod(FpGModuleGF,
  "zero module from group, action and actionBlockSize",
  [IsPosInt, IsGroup, IsFunction, IsPosInt],
  function(ambientDimension, G, action, actionBlockSize)
    local g, sumgens;
    if not IsPGroup(G) then
      Error("<group> must be a p-group");
    fi;
    # Check that the action appears to work as it should do
    g := Elements(G)[2]; # this is probably not the identity
    sumgens := RandomMat(1, actionBlockSize, GaloisField(PrimePGroup(G)))[1];
    if action(Inverse(g), action(g, sumgens)) <> sumgens then
      Error("<action> does not appear to work properly");
    fi;
    return FpGModuleGFNC(
      [], G, action, actionBlockSize, ambientDimension);
  end
);
#####################################################################
InstallOtherMethod(FpGModuleGF,
  "zero module from groupAndAction",
  [IsPosInt, IsRecord],
  function(ambientDimension, groupAndAction)
    return FpGModuleGFNC(
      ambientDimension, groupAndAction.group,
      groupAndAction.action, groupAndAction.actionBlockSize);
  end
);
#####################################################################
InstallMethod(FpGModuleGF,
  "copy a HAP FPGModule",
  [IsHapFPGModule],
  function(M)
    local orderG, gens, G, I, eltsG, sumExpandedGens, i, j, pos, gI, action;
    # TODO This should use a member access functions to get the 
    # members from FpGModules, but they don't exist yet!
    gens := GeneratorsOfFpGModule(M);
    G := M!.group;
    orderG := Order(G);
# #     # TODO: Finish this
# #     # What is the action block size for this module's action?
# #     # Start with an identity matrix and try out some examples
# #     eltsG := ShallowCopy(Elements(G));
# #     I := IdentityMat(Length(gens[1]), Field(gens[1][1]));
# #     sumOrbit := NullMat(Length(I), Length(I));
# #     # We shall apply each group element to each row, to find the orbit of 
# #     # each row, and we'll sum all the vectors in each orbit
# #     for i in [1..orderG] do
# #       gI := M!.action(eltsG[i], I);
# #       for j in [1..Length(gI)] do
# #         sumOrbit[j] := sumOrbit[j] + IntVecFFE(gI[j]);
# #         pos := pos + orderG;
# #       od;
# #     od;
# #     # The orbits of the first block should all lie in the first block
# #     # The first Order(G) columns (and rows) must lie in the first block,
# #     # since the block size must be at least Order(G)
# #     block := Sum(sumOrbit{[1..orderG]});
# #     # Now find out where the first and last non-zero element is in this block
# #     # Then take each next row and find the first one that has a first non-zero
# #     # element past the last non-zero element in all the previous ones 
# #     # That row number should be the start of the next block. 
# #     # Now test that the block structure (HAPPRIME_GeneratingRowsBlockStructure)
# #     # with that blockSize is diagonal. If not, merge the next 'block' into the
# #     # first one and try again.
    Info(InfoWarning, 1, "Warning: Assuming that the block size is Order(G)\n");
    action := function(g, v)
      return M!.action(g, [v])[1];
    end;
    return FpGModuleGFNC(gens, G, "minimal", action, Order(G));
  end
);
#####################################################################
InstallMethod(FpGModuleGF,
  "full module with canonical generators and action",
  [IsGroup, IsPosInt],
  function(G, n)

    local field, v, FG1, pos;

    if not IsPGroup(G) then
      Error("<group> must be a p-group");
    fi;
    field := GaloisField(PrimePGroup(G));

    # Create FG^1
    pos := Position(Elements(G), Identity(G));
    v := ListWithIdenticalEntries(Order(G), Zero(field));
    ConvertToVectorRepNC(v, field);
    v[pos] := One(field);
    # If the identity is the first element (which it usually is), then
    # the format is 'full canonical', i.e. an expansion of the rows will be the
    # identity matrix.
    if pos = 1 then
      FG1 := FpGModuleGFNC(
        [v], CanonicalGroupAndAction(G), "fullcanonical");
    else
      FG1 := FpGModuleGFNC([v], CanonicalGroupAndAction(G), "echelon");
    fi;

    return DirectSumOfModules(FG1, n);
end);
#####################################################################
InstallMethod(FpGModuleGF,
  "full module with canonical generators and action",
  [IsRecord, IsPosInt],
  function(groupAndAction, n)

    local G, field, v, FG1, pos;

    G := groupAndAction.group;
    if not IsPGroup(G) then
      Error("<group> must be a p-group");
    fi;
    field := GaloisField(PrimePGroup(G));

    # Create FG^1
    pos := Position(Elements(G), Identity(G));
    v := ListWithIdenticalEntries(Order(G), Zero(field));
    ConvertToVectorRepNC(v, field);
    v[pos] := One(field);
    # We can't be sure that the module is 'full canonical'
    # TODO: We could check to see what form it really is
    FG1 := FpGModuleGFNC([v], groupAndAction, "echelon");

    return DirectSumOfModules(FG1, n);
end);
#####################################################################
InstallMethod(FpGModuleGFNC,
  "full constructor",
  [IsMatrix, IsGroup, IsString, IsFunction, IsPosInt],
  function(gens, group, form, action, actionBlockSize)
    return Objectify( 
      FpGModuleGFType, 
      rec(
        groupAndAction := rec(
          group := group, 
          action := action,
          actionBlockSize := actionBlockSize),
        generators := gens, 
        ambientDimension := Length(gens[1]),
        minimalGenerators := form));
  end
);
#####################################################################
InstallMethod(FpGModuleGFNC,
  "full constructor for empty generators",
  [IsPosInt, IsGroup, IsFunction, IsPosInt, ],
  function(ambientDimension, group, action, actionBlockSize)
    return Objectify( 
      FpGModuleGFType, 
      rec(
        groupAndAction := rec(
          group := group, 
          action := action,
          actionBlockSize := actionBlockSize),
        generators := [], 
        ambientDimension := ambientDimension,
        minimalGenerators := "echelon"));
  end
);
#####################################################################
InstallMethod(FpGModuleGFNC,
  "constructor from groupAndAction record",
  [IsMatrix, IsRecord],
  function(gens, groupAndAction)
    return Objectify( 
      FpGModuleGFType, 
      rec(
        groupAndAction := groupAndAction,
        generators := gens, 
        ambientDimension := Length(gens[1]),
        minimalGenerators := "unknown"));
  end
);
#####################################################################
InstallMethod(FpGModuleGFNC,
  "constructor from groupAndAction record and string",
  [IsMatrix, IsRecord, IsString],
  function(gens, groupAndAction, form)
    return Objectify( 
      FpGModuleGFType, 
      rec(
        groupAndAction := groupAndAction,
        generators := gens, 
        ambientDimension := Length(gens[1]),
        minimalGenerators := form));
  end
);
#####################################################################



#####################################################################
##  <#GAPDoc Label="FpGModuleFromFpGModuleGF_DTmanFpGModule_Con">
##  <ManSection>
##  <Oper Name="FpGModuleFromFpGModuleGF" Arg="M"/>
##
##  <Returns>
##  FpGModule
##  </Returns>
##  <Description>
##  Returns a &HAP; <K>FpGModule</K> that represents the same 
##  module as the <K>FpGModuleGF</K> <A>M</A>.
##  This uses <Ref Oper="ModuleVectorSpaceBasis"/> to find the vector space 
##  basis for 
##  <A>M</A> and constructs a <K>FpGModule</K> with this vector space and the 
##  same group and action as <A>M</A>
##  See Section <Ref Subsect="FPGModuleExample0"/> below for an example of usage.
##  <P/>
##  <E>TODO: This currently constructs an FpGModule object explicitly. It should 
##  use a constructor once one is provided</E>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(FpGModuleFromFpGModuleGF,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local Fbasis, actionOnMatrix, groupAndAction;
    Fbasis := ModuleVectorSpaceBasis(M);
    groupAndAction := ModuleGroupAndAction(M);
    actionOnMatrix := function (g, V)
      return TransposedMat(
        HAPPRIME_GActMatrixColumns(g, TransposedMat(V), groupAndAction));
    end;
    return Objectify(
      HapFPGModule,
      rec(
        group := ModuleGroup(M),
        matrix := Fbasis,
        dimension := Length(Fbasis),
        ambientDimension := ModuleAmbientDimension(M),
        characteristic := ModuleCharacteristic(M),
        action := actionOnMatrix));
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ModuleGroup_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleGroup" Arg="M"/>
##
##  <Returns>
##  Group
##  </Returns>
##  <Description>
##  Returns the group of the module <A>M</A>. 
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleGroup,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return M!.groupAndAction.group;
  end);
#####################################################################

  
#####################################################################
##  <#GAPDoc Label="ModuleGroupOrder_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleGroupOrder" Arg="M"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the order of the group of the module <A>M</A>.
##  This function is identical to <C>Order(ModuleGroup(M))</C>, and is 
##  provided for convenience.
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleGroupOrder,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return Order(ModuleGroup(M));
  end);
#####################################################################

#####################################################################
##  <#GAPDoc Label="ModuleAction_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleAction" Arg="M"/>
##
##  <Returns>
##  Function
##  </Returns>
##  <Description>
##  Returns the group action function of the module <A>M</A>. This is
##  a function <C>action(g, v)</C> that takes a group element <C>g</C> and
##  a vector <C>v</C> and returns a vector <C>w</C> that is the result of 
##  <M>w = gv</M>. 
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleAction,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return M!.groupAndAction.action;
  end);
#####################################################################

  
#####################################################################
##  <#GAPDoc Label="ModuleActionBlockSize_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleActionBlockSize" Arg="M"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the block size of the group action of the module <A>M</A>.
##  This is the length of vectors (or the factor of the length) upon which
##  the group action function acts.
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleActionBlockSize,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return M!.groupAndAction.actionBlockSize;
  end);
#####################################################################

  

#####################################################################
##  <#GAPDoc Label="ModuleGroupAndAction_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleGroupAndAction" Arg="M"/>
##
##  <Returns>
##  Record with elements <C>(group, action, actionOnRight, actionBlockSize)</C>
##  </Returns>
##  <Description>
##  Returns details of the module's group and action in a record with the 
##  following elements:
##  <List>
##  <Item><C>group</C> The module's group</Item>
##  <Item><C>action</C> The module's group action, as a function of the form 
##  <C>action(g, v)</C> that takes a vector <C>v</C> and returns the vector
##  <M>w = gv</M></Item>
##  <Item><C>actionOnRight</C> The module's group action when acting on the 
##    right, as a function of the form <C>action(g, v)</C> that takes a vector 
##    <C>v</C> and returns the vector <M>w = vg</M></Item>
##  <Item><C>actionBlockSize</C> The module's group action block size. This is the
##  ambient dimension of vectors in the module <M>\mathbb{F}G</M></Item>
##  </List>
##  This function is provided for convenience, and is used by a number of 
##  internal functions. The canonical groups and action can be
##  constructed using the function <Ref Func="CanonicalGroupAndAction"/>.
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleGroupAndAction,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return M!.groupAndAction;
  end);
#####################################################################

  

  
#####################################################################
##  <#GAPDoc Label="ModuleCharacteristic_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleCharacteristic" Arg="M"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the characteristic of the field &FF; of the &FG;-module <A>M</A>.
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleCharacteristic,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return PrimePGroup(ModuleGroup(M));
  end);
#####################################################################

#####################################################################
##  <#GAPDoc Label="ModuleField_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleField" Arg="M"/>
##
##  <Returns>
##  Field
##  </Returns>
##  <Description>
##  Returns the field <M>\mathbb{F}</M> of the 
##  <M>\mathbb{F}G</M>-module <A>M</A>.
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleField,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return GaloisField(PrimePGroup(ModuleGroup(M)));
  end);
#####################################################################

#####################################################################
##  <#GAPDoc Label="ModuleAmbientDimension_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="ModuleAmbientDimension" Arg="M"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the ambient dimension of the module <A>M</A>.
##  The module <A>M</A> is represented as a submodule of 
##  <M>\mathbb{F}G^n</M> using generating vectors for a vector space. 
##  This function returns the dimension of this underlying vector space.
##  This is equal to the length of each generating vector, and also 
##  <M>n\times</M><C>actionBlockSize</C>.
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleAmbientDimension,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return M!.ambientDimension;
  end);
#####################################################################

  
#####################################################################
##  <#GAPDoc Label="AmbientModuleDimension_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="AmbientModuleDimension" Arg="M"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  The module <A>M</A> is represented a submodule embedded within the 
##  free module <M>\mathbb{F}G^n</M>. This function returns <M>n</M>, the 
##  dimension of the ambient module. This is the same as the number of blocks.
##  See Section <Ref Subsect="FPGModuleExample1"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  AmbientModuleDimension,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return ModuleAmbientDimension(M) / ModuleActionBlockSize(M);
  end
);
#####################################################################

  
#####################################################################
##  <#GAPDoc Label="FpGModuleGenerators_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleGenerators" Arg="M"/>
##
##  <Returns>
##  List of vectors
##  </Returns>
##  <Description>
##  Returns, as the rows of a matrix, a list of the set of currently-stored 
##  generating vectors for the
##  vector space of the module <A>M</A>. Note that this set is not
##  necessarily minimal. The function <Ref Oper="ModuleGeneratorsAreMinimal"/>
##  will return <K>true</K> if the set is known to be minimal, and 
##  &TheMinGenFuncs; can be used to ensure a minimal set, if necessary.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleGenerators,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return M!.generators;
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="FpGModuleGeneratorsAreMinimal_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleGeneratorsAreMinimal" Arg="M"/>
##
##  <Returns>
##  Boolean
##  </Returns>
##  <Description>
##  Returns <C>true</C> if the module generators are known to be minimal, or 
##  <C>false</C> otherwise. Generators are known to be minimal if the 
##  one of &TheMinGenFuncs; have been previously 
##  used on this module, or if the module was created from a 
##  &HAP; <K>FpGModule</K>.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleGeneratorsAreMinimal,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return ModuleGeneratorsForm(M) <> "unknown" or 
      Length(ModuleGenerators(M)) < 2;
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="FpGModuleGeneratorsAreEchelonForm_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleGeneratorsAreEchelonForm" Arg="M"/>
##
##  <Returns>
##  Boolean
##  </Returns>
##  <Description>
##  Return <K>true</K> if the module generators are known to be in echelon form, 
##  or (i.e. <Ref Oper="EchelonModuleGenerators"/> has been called for this 
##  module), or <K>false</K> otherwise.
##  Some algorithms work more efficiently if (or require that) the 
##  generators of the module are in block-echelon form, i.e. each
##  generator in the module's list of generators has its first non-zero
##  block in the same location or later than the generator before it in the 
##  list.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleGeneratorsAreEchelonForm,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return ModuleGeneratorsForm(M) = "echelon" or 
      ModuleGeneratorsForm(M) = "fullcanonical" or 
      Length(ModuleGenerators(M)) < 2;
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ModuleIsFullCanonical_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleIsFullCanonical" Arg="M"/>
##
##  <Returns>
##  Boolean
##  </Returns>
##  <Description>
##  Returns <K>true</K> if the module is known to represent the full module 
##  <M>\mathbb{F}G^n</M>, with canonical generators and group action, or
##  <K>false</K> otherwise. A module is only known to be canonical if it was
##  constructed using the canonical module <K>FpGModuleGF</K> constructor
##  (<Ref Oper="FpGModuleGF" Label="construction of full canonical module"/>). 
##  If this is true, the module is displayed
##  in a concise form, and some functions have a trivial implementation.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleIsFullCanonical,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return ModuleGeneratorsForm(M) = "fullcanonical";
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="FpGModuleGeneratorsForm_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleGeneratorsForm" Arg="M"/>
##
##  <Returns>
##  String
##  </Returns>
##  <Description>
##  Returns a string giving the form of the module generators. This may be one 
##  of the following: 
##  <List>
##  <Item><C>"unknown"</C> The form is not known
##  </Item>
##  <Item><C>"minimal"</C> The generators are known to be minimal, but not in 
##  any particular form 
##  </Item>
##  <Item><C>"fullcanonical"</C> The generators are the canonical (and minimal)
##  generators for <M>\mathbb{F}G^n</M>
##  </Item>
##  <Item><C>"semiechelon"</C> The generators are minimal and in semi-echelon
##  form.
##  </Item>
##  <Item><C>"echelon"</C> The generators are minimal and in echelon form
##  </Item>
##  </List>
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleGeneratorsForm,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return M!.minimalGenerators;
  end);
#####################################################################

#####################################################################
##  <#GAPDoc Label="ModuleRank_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleRank" Arg="M"/>
##  <Oper Name="ModuleRankDestructive" Arg="M"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the rank of the module <A>M</A>, i.e. the number of minimal 
##  generators. If the module is already in minimal form (according to
##  <Ref Oper="ModuleGeneratorsAreMinimal" Style="text"/>) then 
##  the number of generators is returned with no calculation. Otherwise,
##  <Ref Oper="MinimalGeneratorsModuleGF"/> or 
##  <Ref Oper="MinimalGeneratorsModuleGFDestructive"/> respectively 
##  are used to find a set of minimal generators.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleRankDestructive,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    if ModuleGeneratorsAreMinimal(M) then
      return Length(ModuleGenerators(M));
    else
      return Length(ModuleGenerators(MinimalGeneratorsModuleGFDestructive(M)));
    fi;
end);
#####################################################################
InstallMethod(
  ModuleRank,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return ModuleRankDestructive(MutableCopyModule(M));
end);
#####################################################################




#####################################################################
##  <#GAPDoc Label="ModuleVectorSpaceBasis_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleVectorSpaceBasis" Arg="M"/>
##
##  <Returns>
##  List of vectors
##  </Returns>
##  <Description>
##  Returns a matrix whose rows are a basis for the
##  vector space of the <K>FpGModuleGF</K> module <A>M</A>.
##  Since <K>FpGModuleGF</K> stores modules as a minimal <M>G</M>-generating 
##  set, this function has to calculate all <M>G</M>-multiples of this generating
##  set and row-reduce this to find a basis. 
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  <P/>
##  <E>TODO: A GF version of this one </E>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleVectorSpaceBasis,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    local Fbasis;
    if ModuleIsFullCanonical(M) then
      return IdentityMat(
        ModuleAmbientDimension(M), 
        ModuleField(M));
    else
      Fbasis := HAPPRIME_ExpandGeneratingRows(
        ModuleGenerators(M), ModuleGroupAndAction(M));
      return BaseMatDestructive(Fbasis);
    fi;
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ModuleVectorSpaceDimension_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="ModuleVectorSpaceDimension" Arg="M"/>
##
##  <Returns>
##  Integer
##  </Returns>
##  <Description>
##  Returns the dimension of the vector space of the module <A>M</A>.
##  Since <K>FpGModuleGF</K> stores modules as a minimal <M>G</M>-generating 
##  set, this function has to calculate all <M>G</M>-multiples of this generating
##  set and row-reduce this to find the size of the basis.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  <P/>
##  <E>TODO: A GF version of this function </E>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ModuleVectorSpaceDimension,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    local Fbasis;
    if ModuleIsFullCanonical(M) then
      return ModuleAmbientDimension(M);
    elif IsEmpty(ModuleGenerators(M)) then
      return 0;
    else
      Fbasis := HAPPRIME_ExpandGeneratingRows(
        ModuleGenerators(M), ModuleGroupAndAction(M));
      return RankMatDestructive(Fbasis);
    fi;
  end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="MutableCopyModule_DTmanFpGModule_Con">
##  <ManSection>
##  <Oper Name="MutableCopyModule" Arg="M"/>
##
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns a copy of the module <A>M</A> where the generating vectors are
##  fully mutable. 
##  The group and action in the new module is
##  identical to that in <A>M</A> - only the list of generators is copied
##  and made mutable. (The assumption is that this function used in situations
##  where you just want a new generating set.)  
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  MutableCopyModule,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(M)
    return Objectify( 
      FpGModuleGFType, 
      rec(
        groupAndAction := ModuleGroupAndAction(M), 
        generators := MutableCopyMat(ModuleGenerators(M)), 
        ambientDimension := ModuleAmbientDimension(M),
        minimalGenerators := ModuleGeneratorsForm(M)));
  end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="ViewObj_DTmanFpGModuleNODOC">
##  <ManSection>
##  <Meth Name="ViewObj" Arg="M" Label="for FpGModuleGF"/>
##
##  <Returns>
##  nothing
##  </Returns>
##  <Description>
##  Prints a short description of the module. This is the usual 
##  description printed by &GAP;.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  ViewObj,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(obj)
    HAPPRIME_PrintModuleDescription(obj, "view");
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="PrintObj_DTmanFpGModuleNODOC">
##  <ManSection>
##  <Meth Name="PrintObj" Arg="M" Label="for FpGModuleGF"/>
##
##  <Returns>
##  nothing
##  </Returns>
##  <Description>
##  Prints a detailed description of the module.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  PrintObj,
  "for FpGModuleGF object",
  [IsFpGModuleGF],
  function(obj)
    HAPPRIME_PrintModuleDescription(obj, "print");
  end);
#####################################################################

#####################################################################
##  <#GAPDoc Label="Display_DTmanFpGModuleNODOC">
##  <ManSection>
##  <Meth Name="Display" Arg="M" Label="for FpGModuleGF"/>
##
##  <Returns>
##  nothing
##  </Returns>
##  <Description>
##  Displays a module in a human-readable form. 
##  The elements of the generating vectors are displayed,
##  with each <C>actionBlockSize</C> block marked by a separator.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(
  Display,
  "for FpGModuleGF",
  [IsFpGModuleGF],
  function(obj)
    HAPPRIME_PrintModuleDescription(obj, "display");
end);
#####################################################################
  

#####################################################################
##  <#GAPDoc Label="DisplayBlocks_DTmanFpGModule_Dat">
##  <ManSection>
##  <Oper Name="DisplayBlocks" Arg="M" Label="for FpGModuleGF"/>
##
##  <Returns>
##  nothing
##  </Returns>
##  <Description>
##  Displays the structure of the module generators <A>gens</A> in a 
##  compact human-readable form. 
##  Since the group action permutes generating vectors in blocks of 
##  length <C>actionBlockSize</C>, any block that contains non-zero elements 
##  will still contain non-zero elements after the group action, but a block
##  that is all zero will remain all zero. This operation displays
##  the module generators in a per-block form, with  a <C>*</C> where the block
##  is non-zero and <C>.</C> where the block is all zero.
##  <P/>
##  The standard &GAP; methods <Ref Oper="View" BookName="ref"/>, 
##  <Ref Oper="Print" BookName="ref"/> and <Ref Oper="Display" BookName="ref"/>
##  are also available.)
##  See Section <Ref Subsect="FPGModuleExample3"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(DisplayBlocks,
  "generic method",
  [IsFpGModuleGF],
  function(obj)
    HAPPRIME_PrintModuleDescription(obj, "displayblocks");
end);
#####################################################################
  

#####################################################################
##  <#GAPDoc Label="Equals_DTmanFpGModule_Misc">
##  <ManSection>
##  <Oper Name="&#x003D;" Arg="M, N" Label="for FpGModuleGF"/>
##
##  <Returns>
##  Boolean
##  </Returns>
##  <Description>
##  Returns <K>true</K> if the modules are equal, <K>false</K> otherwise.
##  This checks that the groups and actions in each module are equal 
##  (i.e. identical), and that the vector space spanned by the two modules are 
##  the same. (All vector spaces in <K>FpGModuleGF</K>s of the same ambient 
##  dimension are assumed to be embedded in the same canonical basis.)
##  See Section <Ref Subsect="FPGModuleExample2"/> above for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(\=,
        "generic method",
        IsIdenticalObj,
        [IsFpGModuleGF, IsFpGModuleGF],
        function(M, N)

  local FM, FN;

  if ModuleGroup(M) <> ModuleGroup(N) then
    return false;
  fi;
  if ModuleAmbientDimension(M) <> ModuleAmbientDimension(N) then
    return false;
  fi;
  if ModuleActionBlockSize(M) <> ModuleActionBlockSize(N) then
    return false;
  fi;
  if ModuleAction(M) <> ModuleAction(N) then
    return false;
  fi;

  # Good - now check the vector space
  # Don't need the reduced vector space - a generating set will do
  # and is quicker, unless it is canonical, in which case I can 
  # use the vector space since it's easy to get
  if ModuleIsFullCanonical(M) then
    FM := ModuleVectorSpaceBasis(FM);
  else
    FM := HAPPRIME_ExpandGeneratingRows(
      ModuleGenerators(M), ModuleGroupAndAction(M));
  fi;
  if ModuleIsFullCanonical(N) then
    FN  := ModuleVectorSpaceBasis(N);
  else
    FN := HAPPRIME_ExpandGeneratingRows(
      ModuleGenerators(N), ModuleGroupAndAction(N));
  fi;
  
  return IsSameSubspace(FM, FN);

end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="IsModuleElement_DTmanFpGModule_Misc">
##  <ManSection>
##  <Heading>IsModuleElement</Heading>
##  <Oper Name="IsModuleElement" Arg="M, elm" Label="for element"/>
##  <Oper Name="IsModuleElement" Arg="M, coll" Label="for collection of elements"/>
##
##  <Returns>
##  Boolean
##  </Returns>
##  <Description>
##  Returns <K>true</K> if the vector <A>elm</A> can be interpreted as an 
##  element of the module <A>M</A>, or <K>false</K> otherwise.
##  If a collection of elements is given as the second argument then a list
##  of responses is returned, one for each element in the collection.
##  See Section <Ref Subsect="FPGModuleExample0"/> above for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(IsModuleElement,
  "generic method",
  [IsFpGModuleGF, IsVector],
  function(M, elm)

    return HAPPRIME_ModuleGeneratorCoefficients(M, elm) <> fail;
end);
#####################################################################
InstallMethod(IsModuleElement,
  "generic method",
  [IsFpGModuleGF, IsMatrix],
  function(M, coll)

    local i;

    return List(HAPPRIME_ModuleGeneratorCoefficients(M, coll), i->i <> fail);
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="IsSubModule_DTmanFpGModule_Misc">
##  <ManSection>
##  <Oper Name="IsSubModule" Arg="M, N"/>
##
##  <Returns>
##  Boolean
##  </Returns>
##  <Description>
##  Returns <K>true</K> if the module <A>N</A> is a submodule of <A>M</A>.
##  This checks that the modules have the same group and action, and that the 
##  generators for module <A>N</A> are elements of the module <A>M</A>. (All 
##  vector spaces in <K>FpGModuleGF</K>s of the same ambient dimension
##  are assumed to be embedded in the same canonical basis.)
##  See Section <Ref Subsect="FPGModuleExample0"/> above for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(IsSubModule,
  "generic method",
  IsIdenticalObj,
  [IsFpGModuleGF, IsFpGModuleGF],
  function(M, N)

  if ModuleGroup(M) <> ModuleGroup(N) then
    return false;
  fi;
  if ModuleCharacteristic(M) <> ModuleCharacteristic(N) then
    return false;
  fi;
  if ModuleAmbientDimension(M) <> ModuleAmbientDimension(N) then
    return false;
  fi;
  if ModuleActionBlockSize(M) <> ModuleActionBlockSize(N) then
    return false;
  fi;
  if ModuleAction(M) <> ModuleAction(N) then
    return false;
  fi;
  return IsMatrix(HAPPRIME_ModuleGeneratorCoefficients(M, ModuleGenerators(N)));
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="RandomElement_DTmanFpGModule_Misc">
##  <ManSection>
##  <Oper Name="RandomElement" Arg="M [, n]"/>
##
##  <Returns>
##  Vector
##  </Returns>
##  <Description>
##  Returns a vector which is a random element from the module <A>M</A>.
##  If a second argument, <A>n</A> is give, then a list of <A>n</A> 
##  random elements is returned.
##  See Section <Ref Subsect="FPGModuleExample0"/> above for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(RandomElement,
  "generic method",
  [IsFpGModuleGF],
  function(M)

  return HAPPRIME_ModuleElementFromGeneratorCoefficients(
    M, RandomMat(
      1, Length(ModuleGenerators(M))*ModuleGroupOrder(M), 
      ModuleField(M))[1]);
end);
#####################################################################
InstallMethod(RandomElement,
  "generic method",
  [IsFpGModuleGF, IsPosInt],
  function(M, n)

  return HAPPRIME_ModuleElementFromGeneratorCoefficients(
    M, RandomMat(
      n, Length(ModuleGenerators(M))*ModuleGroupOrder(M), 
      ModuleField(M)));
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="RandomSubmodule_DTmanFpGModule_Misc">
##  <ManSection>
##  <Heading>Random Submodule</Heading>
##  <Oper Name="RandomSubmodule" Arg="M, ngens"/>
##
##  <Returns>
##    <K>FpGModuleGF</K>
##  </Returns>
##  <Description>
##  Returns a <K>FpGModuleGF</K> module that is a submodule of <A>M</A>,
##  with <A>ngens</A> generators selected at random from elements of <A>M</A>.
##  These generators are not guaranteed to be minimal, so the rank of the 
##  submodule will not necessarily be equal to <A>ngens</A>. If a module
##  with minimal generators is required, &TheMinGenFuncs; can be used to
##  convert the module to a minimal form 
##  See Section <Ref Subsect="FPGModuleExample0"/> above for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(RandomSubmodule,
  [IsFpGModuleGF, IsPosInt],
  function(M, ngens)

    return FpGModuleGFNC(
        RandomElement(M, ngens), ModuleGroupAndAction(M));
end);
#####################################################################




#####################################################################
##  <#GAPDoc Label="MinimalGeneratorsModule_DTmanFpGModule_Gen">
##  <ManSection Label="MinimalGeneratorsModule">
##  <Heading>MinimalGeneratorsModule</Heading>
##
##  <Oper Name="MinimalGeneratorsModuleGF" Arg="M"/>
##  <Oper Name="MinimalGeneratorsModuleGFDestructive" Arg="M"/>
##  <Oper Name="MinimalGeneratorsModuleRadical" Arg="M"/>
##
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns a module equal to the <K>FpGModuleGF</K> <A>M</A>, but which has a 
##  minimal set of generators. Two algorithms are provided:
##  <List>
##  <Item>The two <C>GF</C> versions use 
##  <Ref Oper="EchelonModuleGenerators"/> and 
##  <Ref Oper="EchelonModuleGeneratorsDestructive"/>
##  respectively. In characteristic two, these return a set of minimal 
##  generators, and use less memory than the <C>Radical</C> version, but 
##  take longer. If the characteristic is not two, these functions revert to
##  <Ref Oper="MinimalGeneratorsModuleRadical"/>.
##  </Item>
##  <Item>The <C>Radical</C> version uses the radical of the module in a manner 
##  similar to the function <Ref Label="GeneratorsOfFpGModule" BookName="HAP"/>.
##  This is much faster, but requires a considerable 
##  amount of temporary storage space.
##  </Item>
##  </List>
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(MinimalGeneratorsModuleGFDestructive,
  "generic method",
  [IsFpGModuleGF],
  function(M)

  local HAPM;

  # Nothing to do if already minimal
  if ModuleGeneratorsAreMinimal(M) then
      return M;
  fi;

  if ModuleCharacteristic(M) = 2 then
    return EchelonModuleGeneratorsDestructive(M).module;
  else
    return MinimalGeneratorsModuleRadical(M);
  fi;
end);
#####################################################################
InstallMethod(MinimalGeneratorsModuleGF,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local modcopy;
    modcopy := MutableCopyModule(M);
    return MinimalGeneratorsModuleGFDestructive(modcopy);
end);
#####################################################################
InstallMethod(MinimalGeneratorsModuleRadical,
  "generic method",
  [IsFpGModuleGF],
  function(M)

  local GA;

  if ModuleGeneratorsAreMinimal(M) then
      return M;
  fi;

  GA := ModuleGroupAndAction(M);
  return HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive(
    HAPPRIME_ExpandGeneratingRows(ModuleGenerators(M), GA), GA);
end);
#####################################################################
  



#####################################################################
##  <#GAPDoc Label="RadicalOfModule_DTmanFpGModule_Gen">
##  <ManSection>
##  <Oper Name="RadicalOfModule" Arg="M"/>
##
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns radical of the <K>FpGModuleGF</K> module <A>M</A> as another
##  <K>FpGModuleGF</K>.
##  The radical is the module generated by the vectors <M>v-gv</M> for all 
##  <M>v</M> in the set of generating vectors for <A>M</A> and all <M>g</M>
##  in a set of generators for the module's group.
##  <P/>
##  The generators for the returned module will not be in minimal form:
##  &TheMinGenFuncs; can be used to
##  convert the module to a minimal form if necessary.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(RadicalOfModule,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local gens, GA, radical, gensT, g;

    gens := ModuleGenerators(M);
    GA := ModuleGroupAndAction(M);

    ConvertToMatrixRepNC(gens, ModuleField(M));

    radical := [];
    gensT := TransposedMatMutable(gens);
    for g in Elements(GA.group) do
      Append(radical, TransposedMatMutable(
        gensT - HAPPRIME_GActMatrixColumns(g, gensT, GA)));
    od;

    return FpGModuleGFNC(radical, GA, "unknown");
end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="DirectSumOfModules_DTmanFpGModule_Sum">
##  <ManSection>
##  <Heading>DirectSumOfModules</Heading>
##  <Oper Name="DirectSumOfModules" Arg="M, N" Label="for two modules"/>
##  <Oper Name="DirectSumOfModules" Arg="coll" Label="for collection of modules"/>
##  <Oper Name="DirectSumOfModules" Arg="M, n" Label="for n copies of the same module"/>
## 
##  <Returns>
##  FpGModule
##  </Returns>
##  <Description>
##  Returns the <K>FpGModuleGF</K> module that is the direct sum of the 
##  specified modules (which must have
##  a common group and action). The input can be either two modules <A>M</A> and 
##  <A>N</A>, a list of modules <A>coll</A>, or one module <A>M</A> and an 
##  exponent <A>n</A> specifying the number of copies of <A>M</A> to sum.
##  See Section <Ref Subsect="FPGModuleExample4"/> below for an example of usage.
##  <P/>
##  If the input modules all have minimal generators and/or echelon form,
##  the construction of the direct sum guarantees that the output module will 
##  share the same form.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(DirectSumOfModules,
  "method for two modules",
  IsIdenticalObj,
  [IsFpGModuleGF, IsFpGModuleGF],
  function(M, N)

    return DirectSumOfModules([M,N]);
  end
);
#####################################################################
InstallMethod(DirectSumOfModules,
  "method for list of modules",
  [IsList],
  function(coll)

    local GA, after, before, field, zero, m, gens, gen, afterzeros, beforezeros, 
    form, g;

    if IsEmpty(coll) then
      Error("the collection <coll> is empty");
    fi;

    if not IsFpGModuleGF(coll[1]) then
      Error("<coll> does not contain of FpGModuleGFs");
    fi;
    GA := ModuleGroupAndAction(coll[1]);
    after := ModuleAmbientDimension(coll[1]);
    field := ModuleField(coll[1]);
    zero := Zero(field);
    form := ModuleGeneratorsForm(coll[1]);

    # Check the modules all have the same group and work out what the 
    # total length is going to be
    for m in [2..Length(coll)] do
      if not IsFpGModuleGF(coll[m]) then
        Error(" <coll> does not contain of FpGModuleGFs");
      fi;
      if GA <> ModuleGroupAndAction(coll[m]) then  
        Error("the modules in the <coll> do not all have the same group and action");
      fi;
      if field <> ModuleField(coll[m]) then  
        Error("the modules in the <coll> do not all have generators in the same field");
      fi;
      after := after + ModuleAmbientDimension(coll[m]);
      form := HAPPRIME_DirectSumForm(form, ModuleGeneratorsForm(coll[m]));
    od;

    gens := [];
    before := 0;
    for m in coll do
      after := after - ModuleAmbientDimension(m);
      afterzeros := ListWithIdenticalEntries(after, zero);
      beforezeros := ListWithIdenticalEntries(before, zero);
      for g in ModuleGenerators(m) do
        gen := Concatenation(beforezeros, g, afterzeros);
        ConvertToVectorRepNC(gen, field);
        Add(gens, gen);
      od;
      before := before + ModuleAmbientDimension(m);
    od;
    return FpGModuleGFNC(gens, GA, form);
  end
);
#####################################################################
InstallMethod(DirectSumOfModules,
  "method for a sum of n modules",
  [IsFpGModuleGF, IsPosInt],
  function(M, n)

    local GA, dim, field, zero, form, gens, gen, after, before, i, 
    afterzeros, beforezeros, g;

    GA := ModuleGroupAndAction(M);
    dim := ModuleAmbientDimension(M);
    field := ModuleField(M);
    zero := Zero(field);
    form := HAPPRIME_DirectSumForm(
      ModuleGeneratorsForm(M), ModuleGeneratorsForm(M));

    gens := [];
    before := 0;
    after := (n - 1) * dim;
    for i in [1..n] do
      # Make the vectors of zeros to add before and after the generators
      afterzeros := ListWithIdenticalEntries(after, zero);
      beforezeros := ListWithIdenticalEntries(before, zero);
      for g in ModuleGenerators(M) do
        gen := Concatenation(beforezeros, g, afterzeros);
        ConvertToVectorRepNC(gen, field);
        Add(gens, gen);
      od;
      before := before + dim;
      after := after - dim;
    od;
    return FpGModuleGFNC(gens, GA, form);
  end
);
#####################################################################


            
#####################################################################
##  <#GAPDoc Label="DirectDecompositionOfModule_DTmanFpGModule_Sum">
##  <ManSection>
##  <Oper Name="DirectDecompositionOfModule" Arg="M"/>
##  <Oper Name="DirectDecompositionOfModuleDestructive" Arg="M"/>
## 
##  <Returns>
##  List of FpGModuleGFs
##  </Returns>
##  <Description>
##  Returns a list of <K>FpGModuleGF</K>s whose direct sum is equal to the input 
##  <K>FpGModuleGF</K> module <A>M</A>.
##  The list may consist of one element: the original module.
##  <P/>
##  This function relies on the block structure of a set of generators that 
##  have been converted to both echelon and reverse-echelon form (see
##  <Ref Oper="EchelonModuleGenerators"/> and 
##  <Ref Oper="ReverseEchelonModuleGenerators"/>), and calls these functions
##  if the module is not already in echelon form. In this form, it can be 
##  possible to trivially identify direct summands. There is no guarantee either 
##  that this function will return a decomposition if one is available, or that 
##  the modules returned in a decomposition are themselves indecomposable.
##  See Section <Ref Subsect="FPGModuleExample4"/> below for an example of usage.
##  <P/>
##  The <C>Destructive</C> version of this function uses the <C>Destructive</C>
##  versions of the echelon functions, and so modifies the input module and 
##  returns modules who share generating rows with the modified <A>M</A>. The 
##  non-<C>Destructive</C> version operates on a copy of <A>M</A>, and returns
##  modules with unique rows. 
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(DirectDecompositionOfModuleDestructive,
  "generic method",
  [IsFpGModuleGF],
  function(M)

    local blocks, decomposedrows, gens, GA, 
      firstnonzeroblock, decomposedmodules, i, j, shortermodulegens, modulegens,
      BlockStart;

    if not ModuleGeneratorsAreEchelonForm(M) then
      EchelonModuleGeneratorsDestructive(M);
      ReverseEchelonModuleGeneratorsDestructive(M);
    fi;

    gens := ModuleGenerators(M);
    GA := ModuleGroupAndAction(M);
    blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);
    decomposedrows := HAPPRIME_IndependentGeneratingRows(blocks);

    if Length(decomposedrows) = 1 then
      return [M];
    fi;

    ###################################################
    # Which element does block number b start at?
    BlockStart := function(b)
      return (b - 1) * GA.actionBlockSize + 1;
    end;
    ###################################################

    # Work out what the new module ambient dimensions are going to be
    firstnonzeroblock := List(decomposedrows, i->PositionNonZero(blocks[i[1]]));
    Add(firstnonzeroblock, Length(blocks[1])+1);

    decomposedmodules := [];
    for i in [1..Length(decomposedrows)] do
      modulegens := gens{decomposedrows[i]};
      shortermodulegens := [];
      for j in modulegens do
        Add(shortermodulegens, 
          j{[BlockStart(firstnonzeroblock[i])..BlockStart(firstnonzeroblock[i+1])-1]});
      od;
      Add(decomposedmodules, FpGModuleGFNC(shortermodulegens, GA, "echelon"));
    od;
    return decomposedmodules;
end);
#####################################################################
InstallMethod(DirectDecompositionOfModule,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    return DirectDecompositionOfModuleDestructive(
      MutableCopyModule(M));
end);
#####################################################################




#####################################################################
##  <#GAPDoc Label="EchelonFpGModuleGeneratorsDestructive_DTmanFpGModule_Blo">
##  <ManSection>
##  <Oper Name="EchelonModuleGenerators" Arg="M"/>
##  <Oper Name="EchelonModuleGeneratorsDestructive" Arg="M"/>
##  <Oper Name="SemiEchelonModuleGenerators" Arg="M"/>
##  <Oper Name="SemiEchelonModuleGeneratorsDestructive" Arg="M"/>
##  <Oper Name="EchelonModuleGeneratorsMinMem" Arg="M"/>
##  <Oper Name="EchelonModuleGeneratorsMinMemDestructive" Arg="M"/>
##  <Oper Name="SemiEchelonModuleGeneratorsMinMem" Arg="M"/>
##  <Oper Name="SemiEchelonModuleGeneratorsMinMemDestructive" Arg="M"/>
## 
##  <Returns>
##  Record <C>(module, headblocks)</C>
##  </Returns>
##  <Description>
##  Returns a record with two components:
##  <List>
##  <Item><K>module</K> A module whose generators span the same vector space as 
##  that of the input module <A>M</A>, but whose generators are in a block 
##  echelon (or semi-echelon) form</Item>
##  <Item><K>headblocks</K> A list giving, for each generating vector in 
##  <A>M</A>, the block in which the head for that generating row lies</Item>
##  </List>
##  In block-echelon form. each generator is row-reduced using <M>G</M>g-multiples of
##  the other other generators to produce a new, equivalent generating set
##  where the first non-zero block in each generator is as far to the right as
##  possible. The resulting form, with many zero blocks, can allow more 
##  memory-efficient operations on the module. See Section <Ref Sect="FpGModuleGFalgo"/> 
##  for details. In addition, the standard
##  (non-<C>MinMem</C>) form guarantees that the set of generators are minimal
##  in the sense that no generator can be removed from the set while leaving the 
##  spanned vector space the same. In the GF(2) case, this is the global 
##  minimum.
##  <P/>
##  Several versions of this algorithm are provided. The <C>SemiEchelon</C> 
##  versions of these functions do not guarantee
##  a particular generator ordering, while the <C>Echelon</C> versions sort the
##  generators into order of increasing initial zero blocks. The 
##  non-<C>Destructive</C> versions of this function return a new module and
##  do not modify the input module; the <C>Destructive</C> versions change
##  the generators of the input module in-place, and return
##  this module. All versions are memory-efficient, and do not need a full
##  vector-space basis. The <C>MinMem</C> versions are guaranteed to expand at 
##  most two generators at any one time, while the standard version may, in the
##  (unlikely) worst-case, need to expand half of the generating set. As a 
##  result of this difference in the algorithm, the <C>MinMem</C> version is 
##  likely to return a greater number of generators (which will not be minimal),
##  but those generators typically have a greater number of zero blocks after
##  the first non-zero block in the generator. The <C>MinMem</C> operations
##  are currently only implemented for GF(2) modules.
##  See Section <Ref Subsect="FPGModuleExample3"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(SemiEchelonModuleGeneratorsDestructive,
  [IsFpGModuleGF],
  function(M)

  local 
    gens, 
    GA,
    blockSize,
    ngens,      # The number of generators for this module (the number of rows)
    genlength,  # The length of a generator (the number of columns)
    nblocks,    # The number of 
    field,      # The field of the generators
    one,        # the one of the field
    zero,       # The zero of the field
    blocks,
    blockstart, 
    blockend,
    b,
    rowstoreduce,
    currentrow,
    reducingrows,
    heads,
    r,
    rowused,
    generatingrows,
    row,
    headblocks,
    starttime, 
    timesofar,
    genchunk,
    ResizeReducingRows,
    FindMinimalBlockGeneratingRows;

  # Extract out information from the module
  gens := ModuleGenerators(M);
  
  if not IsMutable(gens) then
    Error("the generators of <M> must be mutable");
  fi;
  
  # Are there no generators? If so, do nothing
  if IsEmpty(gens) then
    return rec(module := M, headblocks := []);
  fi;
  
  
  # Now other information
  GA := ModuleGroupAndAction(M);
  blockSize := GA.actionBlockSize;
  ngens := Length(gens);
  genlength := Length(gens[1]);
  field := Field(gens[1][1]);
  zero := Zero(field);
  one := One(field);

  # Find the current block structure
  blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);
  nblocks := Length(blocks[1]);

  # Nothing to do if already echelon
  if ModuleGeneratorsForm(M) = "echelon" or 
    ModuleGeneratorsForm(M) = "semiechelon" or
    ModuleIsFullCanonical(M) then
      return rec(
        module := M, headblocks := List(blocks, i->PositionNonZero(i)));
  fi;  

  # if there is only one generator, we can't do anything
  if ngens <= 1 then
    return rec(module := M, headblocks := [PositionNonZero(blocks[1])]);
  fi;

  # What is the scope of this current block?
  blockend := blockSize;
  blockstart := 1;

  rowused := ListWithIdenticalEntries(ngens, false);
  reducingrows := [];
  heads := ListWithIdenticalEntries(genlength, 0);

  
    
  #################################################
  # Remove the elements from the front of reducingrows
  # that we don't need any more
  ResizeReducingRows := function()

    local oldlength, newlength, ntoremove, rowheads, i, rowstoremove;
  
    oldlength := Length(heads);
    newlength := genlength - blockstart + 1;
    ntoremove := oldlength - newlength;
    if ntoremove = 0 then
      return;
    fi;

    # Convert 'heads' into a list by row, i.e. for each row, which column
    # is the head in?
    rowheads := [];
    for i in [1..Length(heads)] do
      if heads[i] <> 0 then
        rowheads[heads[i]] := i;
      fi;
    od;
    # Now remove all of the rows from reducingrows that have heads in the 
    # earlier block(s)
    rowstoremove := Filtered(heads{[1..ntoremove]}, n->not IsZero(n));
    Sort(rowstoremove, function(a,b) return a > b; end);
    for i in rowstoremove do
      Remove(reducingrows, i);
      Remove(rowheads, i);
    od;
    # And shorten everything else remaining 
    for i in [1..Length(reducingrows)] do
      reducingrows[i] := reducingrows[i]{[ntoremove+1..oldlength]};
    od;
    # Now rewrite the heads vector using the information remaining in rowheads
    heads := ListWithIdenticalEntries(newlength, 0);
    for i in [1..Length(rowheads)] do
      heads[rowheads[i] - ntoremove] := i;
    od;
  end;
  #################################################

  #################################################
  # Find which minimal set of rows from gens are needed to generate all 
  # of the heads for the current block
  # Input: generatingrowsnums - a list of row indices for the rows that might
  #  generate this block (as well as anything left in reducingrows)
  FindMinimalBlockGeneratingRows := function(generatingrowsnums)

    local block, r, v, initialblockbasis, gensblocks, 
      gensrowsneeded, previousgensrowsneeded, blockspace;

    # Extract out just this block for all of rows in reducingrows (ignoring zero 
    # blocks). This will be the start of our vector space
    block := rec(
      heads := ListWithIdenticalEntries(blockSize, 0),
      vectors := []); # A basis for this block's vector space
    if not IsEmpty(reducingrows) then
      for r in reducingrows do
        v := r{[1..blockSize]};
        if not IsZero(v) then
          Add(block.vectors, v);
          block.heads[PositionNonZero(v)] := Length(block.vectors);
        fi;
      od;
    fi;
    # Remember what this is for later  
    initialblockbasis := MutableCopyMat(block.vectors);

    # Cache this block for all of the generating rows that I will be using
    gensblocks := [];
    gensrowsneeded := []; # The row numbers for blocks we need
    # Now add in as many rows from generatingrows as we need
    for r in generatingrows do
      v := gens[r]{[blockstart..blockend]};
      gensblocks[r] := ShallowCopy(v);
      if not HAPPRIME_ReduceVectorDestructive(
          v, block.vectors, block.heads) then
        block := HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive(
          block.vectors, v, GA);
        Add(gensrowsneeded, r);
      fi;
      # If we now have a full rank of rows, we don't need to go any further
      if Length(block.vectors) = blockSize then
        break;
      fi;
    od;

    # Now try leaving out vectors from generatingrowsnumsblock out to see 
    #  whether we can still span the same space
    r := 1; # The row to try leaving out
    while r <= Length(gensrowsneeded) do
      previousgensrowsneeded := ShallowCopy(gensrowsneeded);
      Remove(gensrowsneeded, r);
      blockspace := HAPPRIME_ExpandGeneratingRows(gensblocks{gensrowsneeded}, GA);
      Append(blockspace, initialblockbasis);
      if IsSameSubspace(blockspace, block.vectors) then
        # This row is not needed. We next try the one that is now in position r
      else
        # This row is needed. Replace it and move on to the next
        gensrowsneeded := ShallowCopy(previousgensrowsneeded);
        r := r + 1;
      fi;
    od;

    return gensrowsneeded;  
  end;    
  #################################################
  
  starttime := Runtime();
  for b in [1..nblocks] do

    # Which rows need reducing?
    generatingrows := [];
    for r in [1..ngens] do
      # If there is a '1' for this block and it's not already been used
      # then it can be a generator
      if not rowused[r] and blocks[r][b] = 1 then
        Add(generatingrows, r);
      fi;
    od;

    # Are there any here to do reducing?
    if Length(generatingrows) <> 0 then
      ResizeReducingRows();
  
      generatingrows := FindMinimalBlockGeneratingRows(generatingrows);

      # Use these particular rows to generate a set of heads
      for r in generatingrows do
        reducingrows := HAPPRIME_AddGeneratingRowToSemiEchelonBasisDestructive(
          reducingrows, gens[r]{[blockstart..genlength]}, GA);
        rowused[r] := true;
        heads := reducingrows.heads;
        reducingrows := reducingrows.vectors;
      od;
  
      # Now we'll reduce all the other rows 
      for r in [1..ngens] do
        if not rowused[r] then
          genchunk := gens[r]{[blockstart..genlength]};
          HAPPRIME_ReduceVectorDestructive(genchunk, reducingrows, heads);
          gens[r]{[blockstart..genlength]} := genchunk;
        fi;
      od;

      # What's the new block structure?
      blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);
    fi;
    
    # And prepare for the new loop
    blockend := blockend + blockSize;
    blockstart := blockstart + blockSize;
 
    # And display the progress message  
    # Estimate is based on the assumption that the semi-echelon
    # form will be triangular
    timesofar := Runtime() - starttime;
    if InfoLevel(InfoHAPprime) >= 3 then 
      Print("Echeloning generators: ", b, "/", nblocks);
      Print(" (", StringTime(timesofar), " of an estimated ", 
        StringTime(QuoInt(timesofar * nblocks * nblocks, b * (2 * nblocks - b))),
        ")\r");
     fi;
  od;
  if InfoLevel(InfoHAPprime) >= 3 then 
    Print("                                                                         \r"); 
  fi;
   
  # If we have any zero rows, we remove them
  for r in [Length(gens), Length(gens)-1 .. 1] do
    if IsZero(gens[r]) then
      Remove(gens, r);
      Remove(blocks, r);
    fi;
  od;
   
  # Now make the headblocks list
  headblocks := [];
  for r in blocks do
    Add(headblocks, PositionNonZero(r));
  od;
  M!.generators := gens;
  # If we are in GF(2) then these generators are now minimal, otherwise
  # we don't know what form they're in, except that if they were minimal,
  # they still are
  if ModuleCharacteristic(M) = 2 then
    M!.minimalGenerators := "semiechelon";
  elif M!.minimalGenerators <> "unknown" then
    M!.minimalGenerators := "minimal";
  fi;   
  return rec(module := M, headblocks := headblocks);
end);
#####################################################################
InstallMethod(SemiEchelonModuleGenerators,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local modcopy;
    # Empty generators is trivial
    if IsEmpty(ModuleGenerators(M)) then
      return rec(module := M, headblocks := []);
    fi;
    # For the rest, we'll copy the module and call the Destructive version
    modcopy := MutableCopyModule(M);
    return SemiEchelonModuleGeneratorsDestructive(modcopy);
end);
#####################################################################
InstallMethod(EchelonModuleGeneratorsDestructive,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local semiechelon, nblocks, nrows, i, blockrows;
    # Do Semi-echelon. This reduces it, but doesn't guarantee 
    # any particular row order
    semiechelon := SemiEchelonModuleGeneratorsDestructive(M);

    # Is it already in echelon form?
    if ModuleGeneratorsForm(semiechelon.module) = "echelon" or 
      ModuleIsFullCanonical(semiechelon.module) then
      return semiechelon;
    fi;  
    # Now sort the rows
    nblocks := ModuleAmbientDimension(M) / ModuleActionBlockSize(M);
    # If there are fewer than two rows, there's no sorting to do
    nrows := Length(semiechelon.headblocks);
    if nrows < 2 then
      return semiechelon;
    fi;

    # Make a list of which rows have heads in which blocks
    blockrows := [];
    for i in [1..nblocks] do
      blockrows[i] := [];
    od;
    for i in [1..nrows] do
      Assert(0, semiechelon.headblocks[i] <= nblocks);
      Add(blockrows[semiechelon.headblocks[i]], i);
    od;
    # Flatten the list to put them in order
    blockrows := Flat(blockrows);

    # And now use this to sort the two entries in semiechelon
    M!.generators := semiechelon.module!.generators{blockrows};
    # If we are in GF(2) then these generators are now minimal, otherwise
    # we don't know what form they're in, except that if they were minimal,
    # they still are
    if ModuleCharacteristic(M) = 2 then
      M!.minimalGenerators := "echelon";
    elif M!.minimalGenerators <> "unknown" then
      M!.minimalGenerators := "minimal";
    fi;   
    return rec(
      module := M, 
      headblocks := semiechelon.headblocks{blockrows});
  end);
#####################################################################
InstallMethod(EchelonModuleGenerators,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local modcopy;
    # Empty generators is trivial
    if IsEmpty(ModuleGenerators(M)) then
      return rec(module := M, headblocks := []);
    fi;
    # For the rest, we'll copy the module and call the Destructive version
    modcopy := MutableCopyModule(M);
    return EchelonModuleGeneratorsDestructive(modcopy);
  end);
#####################################################################
#####################################################################
InstallMethod(SemiEchelonModuleGeneratorsMinMemDestructive,
  "method for generators as compressed GF2 vectors",
  [IsFpGModuleGF],
  function(M)

  local 
    gens,
    GA,
    blockSize,
    ngens,      # The number of generators for this module (the number of rows)
    nblocks,    # The number of 
    field,      # The field of the generators
    one,        # the one of the field
    zero,       # The zero of the field
    blockstart, # The column number of the start of the current block
    blockend,   # The column number of the last element in the current block
    i,          # General counter for iterations
    b,          # The current block
    row,        # A row from the generators
    rowheads,   # list giving the minimum
    headrows,   # List of the rows with heads in the current block
    semiechelonreducers, # The result from doing semiechelon on the current expanded row
    reducers,   # The set of reduced rows to use to reduce other generators
    heads,      # The row in reducers where the head for each column can be found (if it exists)
    r,          # The current row from headrows that is being used to reduce the others
    bestnumzeros, 
    blocki, 
    numzeros, 
    bestzeroesrow, 
    c, 
    leftmosthead, 
    reducerrow,
    reducersblock, 
    genlength, 
    p, 
    fullheadgenerators, 
    t, 
    timesofar, 
    rowsdone,
    starttime, 
    Fbasis;

  # Get the generators and group
  gens := ModuleGenerators(M);

  if not IsGF2VectorRep(gens[1]) then
    TryNextMethod();
  fi;
  if not IsMutable(gens) then
    Error("M!.generators must be mutable");
  fi;
  
  if IsEmpty(gens) then
    return rec(module := M, headblocks := []);
  fi;

  GA := ModuleGroupAndAction(M);
  blockSize := GA.actionBlockSize;
  ngens := Length(gens);
  genlength := Length(gens[1]);
  nblocks := Length(gens[1]) / blockSize;
  field := Field(gens[1][1]);
  zero := Zero(field);
  one := One(field);

  blockstart := 1;

  # Remember which block the head is in for each row
  # (or our current best guess - the head is only guaranteed
  # to be no further left than this number)
  rowheads := ListWithIdenticalEntries(ngens, 1);

  # Also remember which of our blocks we could find an entire
  # set of reducers for: this ones will be in hermite form (guaranteed
  # zero blocks above and below the ones that generate the reducers:
  # i.e. the rows with block heads in those columns will be independent
  # of all the other rows)
  fullheadgenerators := ListWithIdenticalEntries(ngens, 0);
  
  starttime := Runtime();
  for b in [1..nblocks] do
    blockend := blockstart + blockSize - 1;

    reducers := [];
    # Find the rows with heads in this block
    headrows := Positions(rowheads, b);

    timesofar := Runtime() - starttime;
    rowsdone := ngens - Length(headrows);
    if InfoLevel(InfoHAPprime) >= 3 then
      Print("SemiEchelonModule: ", rowsdone, "/", ngens);
      if rowsdone <> 0 then 
        Print(" (", StringTime(timesofar), " of an estimated ", 
        StringTime(Int(timesofar * ngens / rowsdone)), ")\r");
      else
        Print("\r");
      fi;  
    fi;

    # Reduce using each row in turn (except the last one - there's
    # no point using that one)
    heads := [0];
    r := 1;
    while r <= Length(headrows) and Position(heads, 0) <> fail do
      t := Runtime();
      # We want to use the row with the most zeros in the block since
      # that will hopefully give us the best number of heads
      bestnumzeros := 0;
      bestzeroesrow := 0;
      i := r;
      while i <= Length(headrows) do
        row := gens[headrows[i]]{[blockstart..blockend]}; 
        numzeros := Length(Positions(row, zero));
        if numzeros = blockSize then
          # all zeros is bad - no good for reducing
          # Remove this from the current headrows
          rowheads[headrows[i]] := b + 1;
          Remove(headrows, i);
        else
          if numzeros > bestnumzeros then
            bestnumzeros := numzeros;
            bestzeroesrow := i;
          fi;
          if bestnumzeros = (blockSize-1) then
            # We can't do better than this, so stop here
            i := headrows + 1;
          else
            # Otherwise step onto the next row
            i := i + 1;
          fi;
        fi;
      od;

      # if I have no good rows then I can't do any reducing here at all
      if bestzeroesrow = 0 then
        break;
      fi;
      # swap the best row up to the rth in the list 
      row := headrows[r];
      headrows[r] := headrows[bestzeroesrow];
      headrows[bestzeroesrow] := row;

      t := Runtime();
      # Extract this row starting from blockstart (the rest are zeros)
      row := gens[headrows[r]]{[blockstart..genlength]};
      # Now expand out this row and add it to list of reducers
      Fbasis := HAPPRIME_ExpandGeneratingRow(row, GA);
      Append(reducers, Fbasis);

      # We want to do semiechelon on this to give a basis, but to
      # save time and space we'll just do it on this block
      reducersblock := [];
      for i in reducers do
        Add(reducersblock, i{[1..blockSize]});
      od;

      t := Runtime();
      ConvertToMatrixRepNC(reducersblock, field);
      semiechelonreducers := SemiEchelonMatTransformationDestructive(reducersblock);
      Unbind(reducersblock);
      heads := semiechelonreducers.heads;
      # Now we can apply the reduction to all of the matrix using the coeff matrix
      reducers := semiechelonreducers.coeffs * reducers;
      Unbind(semiechelonreducers);

      t := Runtime();
      # Now try and reduce ALL the other rows (not just headrows) 
      # using the rows we have in reducers
      for i in [1..Length(gens)] do
        # Except for the current or previous headrow entries
        if Position(headrows{[1..r]}, i) <> fail then
          continue;
        fi;
        row := gens[i]{[blockstart..genlength]}; 
        # if the first block of this is zero then there's no reducing to do
        if not IsZero(row{[1..blockSize]}) then
          # Otherwise we'll reduce it  
          for c in [1..blockSize] do
            if row[c] = one then
              reducerrow := heads[c];
              if reducerrow <> 0 then
                AddRowVector(row, reducers[reducerrow]);
              fi;
            fi;
          od;
          # And copy this back into gens
          gens[i]{[blockstart..genlength]} := row;
        fi;
        # if this is zero and it is in in headrows then we remove it from that
        if IsZero(row{[1..blockSize]}) then
          p := Position(headrows, i);
          if p <> fail then
            rowheads[i] := b + 1;
            Remove(headrows, p);
          fi;
        fi;
      od;

      r := r + 1;
    od;
    # If we have a complete set of heads then this column and we have only used one
    # row then we know that the first block in this row is full rank
    if Position(heads, 0) = fail and r = 2 then
      fullheadgenerators[headrows[1]] := 1;
    fi;
    blockstart := blockstart + blockSize;
  od;
  if InfoLevel(InfoHAPprime) >= 3 then
    Print("                                                                             \r");
  fi;
  
  # If any rows are now zero, we'll remove them
  # Step through backwards so that the list element numbering
  # is still valid even after an element is removed
  for i in [ngens, ngens-1 .. 1] do
    if IsZero(gens[i]) then
    Remove(gens, i);
    Remove(rowheads, i);
    fi;
  od;

#  Print("SemiEchelonModule: Total time = ", StringTime(Runtime() - starttime), "\n");

  M!.generators := gens;
  # If the generators were minimal, they still are, and they're now in 
  # semiechelon form
  if M!.minimalGenerators <> "unknown" then
    M!.minimalGenerators := "semiechelon";
  fi;
  return rec(
    module := M, 
    headblocks := rowheads);
end);
#####################################################################
InstallMethod(SemiEchelonModuleGeneratorsMinMem,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local modcopy;
    # Empty generators is trivial
    if IsEmpty(ModuleGenerators(M)) then
      return rec(module := M, headblocks := []);
    fi;
    # For the rest, we'll copy the module and call the Destructive version
    modcopy := MutableCopyModule(M);
    return SemiEchelonModuleGeneratorsMinMemDestructive(modcopy);
  end);
#####################################################################
InstallMethod(EchelonModuleGeneratorsMinMemDestructive,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local semiechelon, nblocks, nrows, i, blockrows;
    # Do Semi-echelon. This reduces it, but doesn't guarantee 
    # any particular row order
    semiechelon := SemiEchelonModuleGeneratorsMinMemDestructive(M);

    # Now sort the rows
    nblocks := ModuleAmbientDimension(M) / ModuleActionBlockSize(M);
    # If there are fewer than two rows, there's no sorting to do
    nrows := Length(semiechelon.headblocks);
    if nrows < 2 then
      return semiechelon;
    fi;

    # Make a list of which rows have heads in which blocks
    blockrows := [];
    for i in [1..nblocks] do
      blockrows[i] := [];
    od;
    for i in [1..nrows] do
      Assert(0, semiechelon.headblocks[i] <= nblocks);
      Add(blockrows[semiechelon.headblocks[i]], i);
    od;
    # Flatten the list to put them in order
    blockrows := Flat(blockrows);

    # And now use this to sort the two entries in semiechelon
    M!.generators := ModuleGenerators(semiechelon.module){blockrows};
    # If the generators were minimal, they still are, and they're now in 
    # echelon form
    if M!.minimalGenerators <> "unknown" then
      M!.minimalGenerators := "echelon";
    fi;   
    return rec(
      module := M, 
      headblocks := semiechelon.headblocks{blockrows});
end);
#####################################################################
InstallMethod(EchelonModuleGeneratorsMinMem,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local modcopy;
    # Empty generators is trivial
    if IsEmpty(ModuleGenerators(M)) then
      return rec(module := M, headblocks := []);
    fi;
    # For the rest, we'll copy the module and call the Destructive version
    modcopy := MutableCopyModule(M);
    return EchelonModuleGeneratorsMinMemDestructive(modcopy);
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="ReverseEchelonModuleGenerators_DTmanFpGModule_Blo">
##  <ManSection>
##  <Oper Name="ReverseEchelonModuleGenerators" Arg="M"/>
##  <Oper Name="ReverseEchelonModuleGeneratorsDestructive" Arg="M"/>
## 
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns an <K>FpGModuleGF</K>  module whose vector space spans the same 
##  space as the input module <A>M</A>, but whose generating vectors are modified 
##  to try to get as many zero blocks as possible at the end of each vector.
##  This function performs echelon reduction of generating rows in a manner 
##  similar to <Ref Oper="EchelonModuleGenerators"/>, but working from 
##  the bottom upwards. It is guaranteed that this function will not change the 
##  head block (the location of the first non-zero block) in each generating 
##  row, and hence if the generators are already in an upper-triangular
##  form (e.g. following a call to <Ref Oper="EchelonModuleGenerators"/>) then
##  it will not disturb that form and the resulting generators will be 
##  closer to a diagonal form.
##  <P/> 
##  The <C>Destructive</C> version of this function modifies the input module's 
##  generators in-place and then returns that module; the non-<C>Destructive</C>
##  version works on a copy of the input module and so will not modify the 
##  original module.
##  <P/>
##  This operation is currently only implemented for GF(2) modules.
##  See Section <Ref Subsect="FPGModuleExample2"/> below for an example of usage.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(ReverseEchelonModuleGeneratorsDestructive,
  "method for generators as compressed GF2 vectors",
  [IsFpGModuleGF],
  function(M)

  local 
    gens,
    G,
    GA,
    blockSize,
    ngens,      # The number of generators for this module (the number of rows)
    genlength,  # The length of a generator (the number of columns)
    nblocks,    # The number of 
    field,      # The field of the generators
    one,        # the one of the field
    zero,       # The zero of the field
    blocks,
    blockstart, 
    blockend,
    b,
    rowstoreduce,
    currentrow,
    reducingrows,
    heads,
    r,
    AddReducingRow,
    ReduceRow;

  # Get the generators and group
  gens := ModuleGenerators(M);

  # Empty generators is trivial
  if IsEmpty(gens) then
    return M;
  fi;
  if not IsMutable(gens) then
    Error("M!.generators must be mutable");
  fi;
  
  if not IsGF2VectorRep(gens[1]) then
    TryNextMethod();
  fi;

  GA := ModuleGroupAndAction(M);
  G := GA.group;
  blockSize := GA.actionBlockSize;
  ngens := Length(gens);
  genlength := Length(gens[1]);
  field := Field(gens[1][1]);
  zero := Zero(field);
  one := One(field);

  # Find the current block structure
  blocks := HAPPRIME_GeneratingRowsBlockStructure(gens, GA);
  nblocks := Length(blocks[1]);

  # Work backwards through the blocks from the end
  blockend := genlength;
  blockstart := blockend - blockSize + 1;

  reducingrows := [];
  heads := [];


  #################################################
  AddReducingRow := function(reducingrows, heads, gen)

    local Fbasis, reducersblock, i, semiechelonreducers;

    # Expand out this generator and add it to my list of reducers
    Fbasis := HAPPRIME_ExpandGeneratingRow(gen, GA);
    Append(reducingrows, Fbasis);

    # We want to do semiechelon on this to give a basis, but to
    # save time and space we'll just do it on this block
    reducersblock := [];
    for i in reducingrows do
      Add(reducersblock, i{[blockstart..blockend]});
    od;

    ConvertToMatrixRepNC(reducersblock, field);
    semiechelonreducers := SemiEchelonMatTransformationDestructive(reducersblock);
    
    # Now we can apply the reduction to all of the matrix using the coeff matrix
    # (unless it was all zeros, in which case we'll just return an empty matrix)
    if IsZero(semiechelonreducers.heads) then
      return rec(reducingrows := [], heads := semiechelonreducers.heads);
    else
      return rec(reducingrows := semiechelonreducers.coeffs * reducingrows,
        heads := semiechelonreducers.heads);
    fi;
  end;
  #################################################

  #################################################
  ReduceRow := function(row)

    local c, p, iszero;

    iszero := true;
    # First reduce this row using our current heads - this will increase the
    # chance of getting lots of heads from this one when it is expanded, or 
    # might already reduce this to zero, in which case it's no use to us
    for c in [blockstart..blockend] do
      if not IsZero(gens[row][c]) then
        p := heads[c-blockstart+1];
        if p <> 0 then
          AddRowVector(gens[row], reducingrows[p]);
        else
          iszero := false;  
        fi;
      fi;
    od;
    return iszero;
  end;
  #################################################

  for b in [nblocks, nblocks-1..1] do

    # Which rows need reducing?
    rowstoreduce := [];
    for r in [ngens, ngens-1..1] do
      # If there is a '1' for this block and row then it needs reducing
      if blocks[r][b] = 1 then
        # But only reduce it if all the blocks after this one are zero
        if b = nblocks or IsZero(blocks[r]{[(b+1)..nblocks]}) then
          Add(rowstoreduce, r);
        fi;
      fi;
    od;
  
    if Length(rowstoreduce) <= 1 then
      break;
    fi;

    reducingrows := [];
    # We first need to find enough generators to generate a full set of heads
    # Start with the first one
    reducingrows := AddReducingRow(reducingrows, heads, gens[rowstoreduce[1]]);
    heads := reducingrows.heads;
    reducingrows := reducingrows.reducingrows;

    # Now we need to make sure that we have all the heads, so add more
    # generators as required
    currentrow := 2;
    while Position(heads, 0) <> fail and currentrow <= Length(rowstoreduce) do

      # Has this been reduced to zero?
      if ReduceRow(rowstoreduce[currentrow]) then
        # Mark this as now a zero block
        # And try another one
        blocks[rowstoreduce[currentrow]][b] := 0;
      else
        # Otherwise we'll add this to our reducers
        reducingrows := 
          AddReducingRow(reducingrows, heads, gens[rowstoreduce[currentrow]]);
        heads := reducingrows.heads;
        reducingrows := reducingrows.reducingrows;
      fi;

      currentrow := currentrow + 1;  
    od;

    # Now we'll reduce all the other rows.
    # (If we don't have all the heads, we'll have considered all the rows already)
    while currentrow <= Length(rowstoreduce) do
      if ReduceRow(rowstoreduce[currentrow]) then
        # Mark this as now a zero block
        blocks[rowstoreduce[currentrow]][b] := 0;
      fi;
      currentrow := currentrow + 1;  
    od;

    blockend := blockend - blockSize;
    blockstart := blockstart - blockSize;
  od;
   
  M!.generators := gens;
  return M;  
end);
#####################################################################
InstallMethod(ReverseEchelonModuleGenerators,
  "generic method",
  [IsFpGModuleGF],
  function(M)
    local modcopy;
    # Empty generators is trivial
    if IsEmpty(ModuleGenerators(M)) then
      return M;
    fi;
    # For the rest, we'll copy the module and call the Destructive version
    modcopy := MutableCopyModule(M);
    return ReverseEchelonModuleGeneratorsDestructive(modcopy);
  end);
#####################################################################
  


#####################################################################
##  <#GAPDoc Label="IntersectionModulesDestructive_DTmanFpGModule_Sum">
##  <ManSection>
##  <Oper Name="IntersectionModules" Arg="M, N"/>
##  <Oper Name="IntersectionModulesGF" Arg="M, N"/>
##  <Oper Name="IntersectionModulesGFDestructive" Arg="M, N"/>
##  <Oper Name="IntersectionModulesGF2" Arg="M, N"/>
## 
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns the <K>FpGModuleGF</K> module that is the intersection of the modules 
##  <A>M</A> and <A>N</A>.
##  This function calculates the intersection using vector space methods 
##  (i.e. <Ref Oper="SumIntersectionMatDestructive" BookName="HAPprime Datatypes"/>). The standard version
##  works on the complete vector space bases of the input modules. The <C>GF</C> 
##  version considers the block structure of the generators of <A>M</A> and 
##  <A>N</A> and only expands the necessary rows and blocks. This can lead to a 
##  large saving and memory if <A>M</A> and <A>N</A> are in echelon form and
##  have a small intersection. See Section <Ref Subsect="FpGModuleGFalgoint"/> for details.
##  See Section <Ref Subsect="FPGModuleExample4"/> below for an example of usage.
##  The <C>GF2</C> version computes the intersection by a <M>G</M>-version of 
##  the standard vector space algorithm, using <Ref Func="EchelonModuleGenerators"/>
##  to perform echelon reduction on an augmented set of generators. This is much
##  slower than the <C>GF</C> version, but may use less memory.
##  <P/>
##  The vector spaces in <K>FpGModuleGF</K>s are assumed to all be
##  with respect to the same canonical basis, so it is assumed that modules are
##  compatible if they have the same group and the same ambient dimension.
##  <P/>
##  The <C>Destructive</C> version of the <C>GF</C> function corrupts or 
##  permutes the generating vectors of <A>M</A> and <A>N</A>, leaving it 
##  invalid; the non-destructive version operates on copies of them, leaving 
##  the original modules unmodified.
##  The generating vectors in the module returned by this function are in fact 
##  also a <E>vector space</E> basis for the module, 
##  so will not be minimal. The returned module can be converted to a set of
##  minimal generators using one of &TheMinGenFuncs;.
##  <P/>
##  This operation is currently only defined for GF(2).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(IntersectionModules,
  IsIdenticalObj,
  [IsFpGModuleGF, IsFpGModuleGF],
  function(U, V)

  local Ugens, Vgens, GA, Fbasis, USe, VSe, I;
  
  # and check they're consistent  
  Ugens := ModuleGenerators(U); 
  Vgens := ModuleGenerators(V); 
  GA := ModuleGroupAndAction(U);
  if GA <> ModuleGroupAndAction(V) then
    Error("modules <U> and <V> do not share the same group and action");
  fi;
  if ModuleAmbientDimension(U) <> ModuleAmbientDimension(V) then
    Error("modules <U> and <V> do not share the same ambient dimension");
  fi;
  if not IsMutable(Ugens) then
    Error("module <U> must have mutable generators");
  fi;
  if not IsMutable(Vgens) then
    Error("module <V> must have mutable generators");
  fi;

  # If either of the generators are empty then the intersection is empty
  if IsEmpty(Ugens) then
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi;
  if IsEmpty(Vgens) then
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi;
  
  # If either of them are the canonical module then the intersection is
  # the other module
  if ModuleIsFullCanonical(U) then
    return V;
  fi;
  if ModuleIsFullCanonical(V) then
    return U;
  fi;
    
  # Expand out U
  Fbasis := HAPPRIME_ExpandGeneratingRows(Ugens, GA);
  USe := SemiEchelonMatDestructive(Fbasis);
  Fbasis := HAPPRIME_ExpandGeneratingRows(Vgens, GA);
  VSe := SemiEchelonMatDestructive(Fbasis);
  
  I := SumIntersectionMatDestructiveSE(
    USe.vectors, USe.heads, VSe.vectors, VSe.heads)[2];
  
  if not IsEmpty(I) then
    return FpGModuleGFNC(I, GA, "unknown");
  else
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi; 
end);
#####################################################################
InstallMethod(IntersectionModulesGFDestructive,
  "for GF2 matrices",
  IsIdenticalObj,
  [IsFpGModuleGF, IsFpGModuleGF],
  function(U, V)
  
  local 
    Ugens,
    Vgens,
    GA,
    blockSize,
    ngens,      # The number of generators for this module (the number of rows)
    genlength,  # The length of a generator (the number of columns)
    nblocks,    # The number of 
    field,      # The field of the generators
    one,        # the one of the field
    zero,       # The zero of the field
    blocks,
    blockstart, 
    blockend,
    b,
    rowstoreduce,
    currentrow,
    reducingrows,
    heads,
    r,
    AddReducingRow,
    ReduceRow,
    half,
    Ublocks,
    Vblocks,
    ublockssum,
    vblockssum,
    intstartblock,
    intendblock,
    Uint,
    blockrows,
    i,
    BlockStart,
    UIntersectionBasis,
    ReverseMat,
    ReverseBlocks,
    Vint,
    v,
    int,
    frontzeros,
    backzeros,
    EcheloniseGenerators;

  # get the group and the generators
  # and check they're consistent  
  Ugens := ModuleGenerators(U); 
  Vgens := ModuleGenerators(V); 
  GA := ModuleGroupAndAction(U);
  if GA <> ModuleGroupAndAction(V) then
    Error("modules <U> and <V> do not share the same group and action");
  fi;
  if ModuleAmbientDimension(U) <> ModuleAmbientDimension(V) then
    Error("modules <U> and <V> do not share the same ambient dimension");
  fi;
  if not IsMutable(Ugens) then
    Error("module <U> must have mutable generators");
  fi;
  if not IsMutable(Vgens) then
    Error("module <V> must have mutable generators");
  fi;

  # If either of the generators are empty then the intersection is empty
  if IsEmpty(Ugens) then
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi;
  if IsEmpty(Vgens) then
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi;
  
  # If either of them are the canonical module then the intersection is
  # the other module
  if ModuleIsFullCanonical(U) then
    return V;
  fi;
  if ModuleIsFullCanonical(V) then
    return U;
  fi;
  
  # We can only cope with GF(2)
  if not IsGF2VectorRep(Ugens[1]) then
    TryNextMethod();
  fi;
  if not IsGF2VectorRep(Vgens[1]) then
    TryNextMethod();
  fi;

  # OK - we can now continue. First remember some useful information
  blockSize := GA.actionBlockSize;
  field := GF(2);
  zero := Zero(field);
  one := One(field);
  genlength := ModuleAmbientDimension(U);

  Ublocks := HAPPRIME_GeneratingRowsBlockStructure(Ugens, GA);
  Vblocks := HAPPRIME_GeneratingRowsBlockStructure(Vgens, GA);
  nblocks := Length(Ublocks[1]);

  ###################################################
  # Sorts the generators into echelon form
  EcheloniseGenerators := function(gens, blocks)
    local order, i;
  
    order := [];
    for i in [1..Length(blocks[1])] do
      Add(order, []);
    od;
    for i in [1..Length(blocks)] do
      Add(order[PositionNonZero(blocks[i])], i);
    od;
    order := Flat(order);
    gens := gens{order};  
    blocks := blocks{order};  
  end;
  ###################################################
  
  # We need to make sure that the generators are in echelon form
  EcheloniseGenerators(Ugens, Ublocks);
  EcheloniseGenerators(Vgens, Vblocks);
  
  # Find the blocks where both U and V have entries
  ublockssum := Sum(Ublocks);
  vblockssum := Sum(Vblocks);

  # Find which blocks have overlap
  # intstartblock is the first block in the intersection
  # intendblock is the last block in the intersection
  intstartblock := 1; 
  while intstartblock <= nblocks and 
      (ublockssum[intstartblock] = 0 or vblockssum[intstartblock] = 0) do
    intstartblock := intstartblock + 1;
  od;
  if intstartblock > nblocks then
    # There is no intersection
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi;
  intendblock := nblocks;
  while intendblock >= 1 and 
      (ublockssum[intendblock] = 0 or vblockssum[intendblock] = 0) do
    intendblock := intendblock - 1;
  od;
  if intendblock < 1 then
    # There is no intersection
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi;
  
  ###################################################
  # Which element does block number b start at ?
  BlockStart := function(b)
    return (b - 1) * blockSize + 1;
  end;
  ###################################################
  
  # Now expand out the F-basis for U generator-by-generator, doing semi-echelon
  # and keeping the heads that are in the intersection
  # We assume that U is in echelon form
  ###################################################
  UIntersectionBasis := function(Ugens, Ublocks, startblock, endblock)
  
    local Fbasis, heads, genlength, r, newblock, oldblock, blockend, blockstart,
      start, se, RemoveUnwantedHeadRows;
  
    Fbasis := [];
    heads := [];
    # Length of the generators up to and including endblock
    genlength := endblock*blockSize;
    
    ###########################################
    RemoveUnwantedHeadRows := function(newblock)

      local i, rowstoremove, workingblocks, nblocks;

      # newblock is the block I'm currently working on. I can tidy up
      # the rows before that block, and remove the rows that have
      # heads in earlier blocks. But I only want to remove all rows with
      # heads up to startblock
      # workinglength is the length that the new vectors are going to be
      # (plus one since the numbers are inclusive)
      workingblocks := Maximum(endblock - newblock, endblock - startblock) + 1;
      # How many blocks can I remove, then?
      nblocks := QuoInt(Length(Fbasis[1]), blockSize) - workingblocks;
      if nblocks = 0 then
        return;
      fi;
      # Remove any basis rows that have heads in the first nblocks blocks
      rowstoremove := Filtered(heads{[1..nblocks*blockSize]}, n->not IsZero(n));
      Sort(rowstoremove, function(a,b) return a > b; end);
      for i in rowstoremove do
        Remove(Fbasis, i);
      od;

      # And shorten everything else remaining (to save space)
      for i in [1..Length(Fbasis)] do
        Fbasis[i] := Fbasis[i]{[BlockStart(nblocks+1)..Length(Fbasis[i])]};
      od;
    end;    
    ###########################################

    # Set oldblock to a value that won't cause harm until it is set properly
    oldblock := genlength;
    for r in [1..Length(Ugens)] do
      # Whick block does this row's elements start in?
      newblock := Position(Ublocks[r], 1);

      # Is this a different block from last time? If so,
      # we now have all the information we will be going to
      # get about the previous blocks, and we can thus tidy up
      if newblock > oldblock and oldblock < startblock then
        RemoveUnwantedHeadRows(newblock);
      fi;

      # Expand out this block and add it to the basis
      start := Minimum(startblock, newblock);
      Append(Fbasis, HAPPRIME_ExpandGeneratingRow(
       Ugens[r]{[BlockStart(start)..genlength]}, GA));

      # And do semiechelon to reduce it as much as possible.
      ConvertToMatrixRepNC(Fbasis, field);
      se := SemiEchelonMatDestructive(Fbasis);
      Fbasis := se.vectors;
      heads := se.heads;
      Unbind(se);
      oldblock := newblock;
    od;

    # Now remove any heads that are less than startblock
    RemoveUnwantedHeadRows(endblock);

    return rec(basis := Fbasis, heads := heads);
  end;
  ###################################################
  
#  Print(" - Calculating Uint\n");
#  GASMAN("collect");
  Uint := UIntersectionBasis(Ugens, Ublocks, intstartblock, intendblock);
  
  
  ####################################################
  ReverseMat := function(mat)
  
    local r;
    for r in [1..Length(mat)] do
      mat[r] := Reversed(mat[r]);
    od;
  end;
  ####################################################
  ReverseBlocks := function(mat)
  
    local r, b, row, nblocks, blockstart, blockend;
    
    if IsEmpty(mat) then
      return [];
    fi;
  
    nblocks := QuoInt(Length(mat[1]), blockSize);
    for r in [1..Length(mat)] do
      blockend := Length(mat[1]);
      blockstart := blockend - blockSize + 1;
      row := [];
      for b in [1..nblocks] do
        Append(row, mat[r]{[blockstart..blockend]});
        blockend := blockend - blockSize;
        blockstart := blockstart - blockSize;
        ConvertToVectorRepNC(row, field);
      od;
      mat[r] := row;
    od;
    ConvertToMatrixRepNC(mat, field);  
  end;
  ####################################################

  # Reverse Vgens 
  ReverseBlocks(Vgens);
  ReverseMat(Vblocks);
  # And sort into upper-triangular form
  # Where are the headblocks?
  blockrows := [];
  for i in [1..nblocks] do
    blockrows[i] := [];
  od;
  for i in [1..Length(Vgens)] do
    Add(blockrows[PositionNonZero(Vblocks[i])], i);
  od;
  # Flatten the list to put them in order
  blockrows := Flat(blockrows);

  Vgens := Vgens{blockrows};
  Vblocks := Vblocks{blockrows};

  # Now find the Fbasis for this one
#  Print(" - Calculating Vint\n");
#  GASMAN("collect");
  Vint := UIntersectionBasis(
    Vgens, Vblocks, nblocks - intendblock + 1, nblocks - intstartblock + 1);

  # And reverse Vint
#  Print(" - Reversing blocks\n");
#  GASMAN("collect");
  ReverseBlocks(Vint.basis);

  # Now find the intersection of Uint and Vint
#  Print(" - Calculating intersection of Uint and Vint\n");
#  GASMAN("collect");
  int := SumIntersectionMatDestructive(Uint.basis, Vint.basis)[2];

  # And now pad with zeros at the beginning and end to make the vectors
  # the correct length
  frontzeros := ListWithIdenticalEntries((intstartblock - 1) * blockSize, zero);
  backzeros := ListWithIdenticalEntries((nblocks - intendblock) * blockSize, zero);
  for i in [1..Length(int)] do
    r := ShallowCopy(frontzeros);
    Append(r, int[i]);
    Append(r, backzeros);
    ConvertToVectorRepNC(r, field);
    int[i] := r;
  od;
  
#  GASMAN("collect");
#  Print(" - Done intersection\n");
  if not IsEmpty(int) then
    return FpGModuleGFNC(int, GA, "unknown");
  else  
    return FpGModuleGF(ModuleAmbientDimension(U), GA);
  fi;
end);
######################################################################
InstallMethod(IntersectionModulesGF,
  "generic method",
  IsIdenticalObj,
  [IsFpGModuleGF, IsFpGModuleGF],
  function(U, V)
    local Umodcopy, Vmodcopy;
    Umodcopy := MutableCopyModule(U); 
    Vmodcopy := MutableCopyModule(V);
    return IntersectionModulesGFDestructive(U, Vmodcopy);
  end);
######################################################################
InstallMethod(IntersectionModulesGF2,
  IsIdenticalObj,
  [IsFpGModuleGF, IsFpGModuleGF],
  function(U, V)
    local GA, A, i, gens, zeros, intersectgens, g, donecol, CarriedOverFBasis,
    col, nonzerocols, nextnonzerocols, currentgens, FBasis, Echelon;

    GA := ModuleGroupAndAction(U);
    if GA <> ModuleGroupAndAction(V) then
      Error("modules <U> and <V> do not share the same group and action");
    fi;
    if ModuleAmbientDimension(U) <> ModuleAmbientDimension(V) then
      Error("modules <U> and <V> do not share the same ambient dimension");
    fi;
    # If either of the generators are empty then the intersection is empty
    if IsEmpty(ModuleGenerators(U)) then
      return FpGModuleGF(ModuleAmbientDimension(U), GA);
    fi;
    if IsEmpty(ModuleGenerators(V)) then
      return FpGModuleGF(ModuleAmbientDimension(U), GA);
    fi;
    # If either of them are the canonical module then the intersection is
    # the other module
    if ModuleIsFullCanonical(U) then
      return V;
    fi;
    if ModuleIsFullCanonical(V) then
      return U;
    fi;
      
    # Build the matrix A = [U U]
    #                      [V 0]
    # get the minimal generators for U. if it is already minimal, 
    # this will do no work
    A := ModuleGenerators(MinimalGeneratorsModuleGF(U));
    for i in [1..Length(A)] do
      A[i] := Concatenation(A[i], A[i]);
    od;
    # Now V
    gens := ModuleGenerators(MinimalGeneratorsModuleGF(V));
    zeros := ListWithIdenticalEntries(Length(gens[1]), Zero(gens[1][1]));
    ConvertToVectorRepNC(zeros, Field(gens[1][1]));
    for i in [1..Length(gens)] do
      gens[i] := Concatenation(gens[i], zeros);
      Add(A, gens[i]);
    od;
    Unbind(zeros);
    Unbind(gens);
    
    # Now (semi)echelonise A
    A := FpGModuleGFNC(A, GA);
    A := ModuleGenerators(EchelonModuleGeneratorsDestructive(A).module);
    
    # Now gradually expand out to see what vectors I can find which are
    # zero in the first half of the row - these are in the intersection
    donecol := 0;
    CarriedOverFBasis := [];
    while donecol < ModuleAmbientDimension(U) do
      col := [donecol+1..donecol+GA.actionBlockSize];
      nonzerocols := [donecol+1..ModuleAmbientDimension(U)*2];
      nextnonzerocols := [GA.actionBlockSize+1..Length(nonzerocols)];
      # Take off the top rows of A that are non-zero in the current column
      currentgens := [];
      while not IsEmpty(A) and not IsZero(A[1]{col}) do
        g := Remove(A, 1);
        Add(currentgens, g{[donecol+1..Length(g)]});
      od;
      FBasis := Concatenation(CarriedOverFBasis, 
        HAPPRIME_ExpandGeneratingRows(currentgens, GA));
      Unbind(currentgens);
      CarriedOverFBasis := [];
      
      if not IsEmpty(FBasis) then
        Echelon := SemiEchelonMatDestructive(FBasis);
        Unbind(FBasis);
  
        # We only want to keep any rows that don't have heads in the current 
        # column
        for i in [GA.actionBlockSize+1..Length(Echelon.heads)] do
          if not IsZero(Echelon.heads[i]) then
            Add(CarriedOverFBasis, 
              Echelon.vectors[Echelon.heads[i]]{nextnonzerocols});
          fi;
        od;
        Unbind(Echelon);
      fi;
      
      donecol := donecol + GA.actionBlockSize;
    od;

    # Anything left in CarriedOverFBasis is in the intersection
    # Anything left in A is also a generator of the intersection
    intersectgens := CarriedOverFBasis;
    for i in [1..Length(A)] do
      g := Remove(A, 1);
      Add(intersectgens, 
        g{[ModuleAmbientDimension(U)+1..ModuleAmbientDimension(U)*2]});
    od;

    if not IsEmpty(intersectgens) then
      return FpGModuleGFNC(intersectgens, GA, "echelon");
    else  
      return FpGModuleGF(ModuleAmbientDimension(U), GA);
    fi;
  end);
#####################################################################

  
#####################################################################
##  <#GAPDoc Label="SumModules_DTmanFpGModule_Sum">
##  <ManSection>
##  <Oper Name="SumModules" Arg="M, N"/>
## 
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns the <K>FpGModuleGF</K> module that is the sum of the input modules 
##  <A>M</A> and <A>N</A>.
##  This function simply concatenates the generating vectors of the two modules
##  and returns the result. If a set of minimal generators are needed then
##  use one of &TheMinGenFuncs; on the result.
##  See Section <Ref Subsect="FPGModuleExample4"/> below for an example of usage.
##  <P/>
##  The vector spaces in <K>FpGModuleGF</K> are assumed to all be
##  with respect to the same canonical basis, so it is assumed that modules are
##  compatible if they have the same group and the same ambient dimension.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(SumModules,
  "generic method",
  IsIdenticalObj,
  [IsFpGModuleGF, IsFpGModuleGF],
  function(U, V)
  
  local Ugens, Vgens, GA, sumgens;

  # get the group and the generators
  # and check they're consistent  
  Ugens := ModuleGenerators(U); 
  Vgens := ModuleGenerators(V); 
  GA := ModuleGroupAndAction(U);
  if GA <> ModuleGroupAndAction(V) then
    Error("modules <U> and <V> do not share the same group and action");
  fi;
  if ModuleAmbientDimension(U) <> ModuleAmbientDimension(V) then
    Error("modules <U> and <V> do not share the same ambient dimension");
  fi;
  
  # If either U or V are canonical then the sum can be no more than that
  if ModuleIsFullCanonical(U) then
    return MutableCopyModule(U);
  fi;
  if ModuleIsFullCanonical(V) then
    return MutableCopyModule(V);
  fi;
  
  sumgens := Concatenation(Ugens, Vgens);
  return FpGModuleGFNC(sumgens, GA, "unknown");
end);
#####################################################################

  
  


#####################################################################
##  <#GAPDoc Label="CanonicalAction_DTmanFpGModule_Con">
##  <ManSection>
##  <Attr Name="CanonicalAction" Arg="G"/>
##  <Attr Name="CanonicalActionOnRight" Arg="G"/>
##  <Attr Name="CanonicalGroupAndAction" Arg="G"/>
##
##  <Returns>
##  Function <C>action(g,v)</C> or a record with elements 
##    <C>(group, action, actionOnRight, actionBlockSize)</C>
##  </Returns>
##  <Description>
##  Returns a function of the form <C>action(g,v)</C> that performs the 
##  canonical group action of an element <C>g</C> of the group <A>G</A> on a 
##  vector <C>v</C> (acting on the left by default, or on the right with the
##  <C>OnRight</C> version). The <C>GroupAndAction</C> version of this function 
##  returns the actions in a record together with the group and the action block 
##  size.
##  Under the canonical action, a free module &FG; is represented
##  as a vector of length <M>|G|</M> over the field &FF;, and
##  the action is a permutation of the vector elements.
##  <P/>
##  Note that these functions are attributes of a group, so that
##  the canonical action for a particular group object will always be
##  an identical function (which is desirable for comparing and combining
##  modules and submodules).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(CanonicalAction,
  [IsGroup and IsFinite and IsPGroup],
  function(G)
  # Is slower if put the contents of HAPPRIME_GactFGvector in here!

    local MT, eltsG;
  
    MT := MultiplicationTable(G);
    eltsG := Elements(G);

    return function(g, v)
      return HAPPRIME_GactFGvector(Position(eltsG, g), v, MT);
      end;
  end
);
#####################################################################
InstallMethod(CanonicalActionOnRight,
  [IsGroup and IsFinite and IsPGroup],
  function(G)
    local MT, eltsG;
  
    MT := TransposedMat(MultiplicationTable(G));
    eltsG := Elements(G);

    return function(g, v)
      return HAPPRIME_GactFGvector(Position(eltsG, g), v, MT);
      end;
  end
);
#####################################################################
# This rewrite is better-written and uses no external functions, but
# the action function is about 15% slower than the action function
# in the original version, so we stick with that one at the moment
# 
# InstallMethod(CanonicalAction2,
#   [IsGroup],
#   function(G)
# 
#   local orderG, phi;
#   orderG := Order(G);
#   phi := ActionHomomorphism(G, Elements(G), OnLeftInverse);
#   return 
#     function(g, v)
#       local nblocks, gv, perm, range, i;
#       nblocks := Length(v)/orderG;
#       if not IsInt(nblocks) then
#         Error("The length of <v> must be an integer multiple of the order of the group\n");
#       fi;
#       gv := ShallowCopy(v);
#       perm := Image(phi, Inverse(g));
#       range := [1..orderG];
#       for i in [1..nblocks] do
#         if not IsZero(v{range}) then
#           gv{range} := Permuted(v{range}, perm);
#         fi;
#         range := range + orderG;
#       od;
#       return gv;
#     end;
# end);
#####################################################################
InstallMethod(CanonicalGroupAndAction,
  "generic method",
  [IsGroup and IsFinite and IsPGroup],
  function(G)
    return rec(
      group := G,
      action := CanonicalAction(G),
      actionOnRight := CanonicalActionOnRight(G),
      actionBlockSize := Order(G));
end);
#####################################################################




#####################################################################
##  <#GAPDoc Label="HAPPRIME_DirectSumForm_DTmanFpGModuleInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_DirectSumForm" Arg="current, new"/>
## 
##  <Returns>
##  String
##  </Returns>
##  <Description>
##  Returns a string containing the form of the generator matrix if the direct 
##  sum is formed between a <K>FpGModuleGF</K> with the form <A>current</A> and 
##  a <K>FpGModuleGF</K> with the form <A>new</A>. 
##  The direct sum is formed by placing the two module generating matrices 
##  in diagonal form. Given the form of the two generating matrices, this allows 
##  the form of the direct sum to be stated.
##  See <Ref Oper="ModuleGeneratorsForm"/> for
##  information about form strings.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_DirectSumForm,
  [IsString, IsString],
  function(current, new)

    # Sort out the generator form for the combination
    if current <> "unknown" then
      if current = "fullcanonical" then
        if new = "unknown" then
          current := "unknown";
        elif new = "minimal" then
          current := "minimal";
        elif new = "semiechelon" then
          current := "semiechelon";
        elif new = "echelon" then
          current := "echelon";
        else
          # Do nothing if it's full canonical: it still will be
        fi; 
      elif current = "echelon" then
        if new = "unknown" then
          current := "unknown";
        elif new = "minimal" then
          current := "minimal";
        elif new = "semiechelon" then
          current := "semiechelon";
        else
          # Do nothing if it's echelon or full canonical: it will be echelon
        fi; 
      elif current = "semiechelon" then
        if new = "unknown" then
          current := "unknown";
        elif new = "minimal" then
          current := "minimal";
        else
          # If it's echelon, full canonical or semiechelon, it's now semiechelon
        fi;
      elif current = "minimal" then
        if new = "unknown" then
          current := "unknown";
        else
          current := "minimal";
        fi;
      fi;
    fi;

    return current;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_PrintModuleDescription_DTmanFpGModuleInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_PrintModuleDescription" Arg="M, func"/>
## 
##  <Returns>
##  nothing
##  </Returns>
##  <Description>
##  Used by <Ref Func="PrintObj" BookName="ref"/>, 
##  <Ref Func="ViewObj" BookName="ref"/>,
##  <Ref Func="Display" BookName="ref"/> and 
##  <Ref Func="DisplayBlocks" Label="for FpGModuleGF"/>, this 
##  helper function prints a description of the module <A>M</A>. The parameter 
##  <A>func</A> can be one of the strings <C>"print"</C>, <C>"view"</C>, 
##  <C>"display"</C> or <C>"displayblocks"</C>, corresponding to the print 
##  different functions that might be called.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_PrintModuleDescription,
  [IsFpGModuleGF, IsString],
  function(obj, func)

    local form;

    if ModuleIsFullCanonical(obj) then
      Print("Full canonical module FG^", AmbientModuleDimension(obj));
      Print(" over the group ring of ");
    else
      Print("Module over the group ring of ");
    fi;
    if func = "display" or func = "displayblocks" then
      Display(ModuleGroup(obj));
    elif func = "print" then
      Print(ModuleGroup(obj));
    else 
      View(ModuleGroup(obj));
    fi;
    Print(" in characteristic ", ModuleCharacteristic(obj), " ");
    if not ModuleIsFullCanonical(obj) then
      Print("with ", Length(ModuleGenerators(obj)), " generator");
      if Length(ModuleGenerators(obj)) = 1 then
        Print(" in");
      else
        Print("s in");
      fi;
      Print(" FG^", AmbientModuleDimension(obj), ". ");
      if func = "displayblocks" then
        Print("\n");
        HAPPRIME_DisplayGeneratingRowsBlocks(
          ModuleGenerators(obj), ModuleGroupAndAction(obj));
      elif func = "display" then
        Print("\n");
        HAPPRIME_DisplayGeneratingRows(
          ModuleGenerators(obj), ModuleGroupAndAction(obj));
      elif func = "print" then 
        Print(ModuleGenerators(obj));
      fi;
      form := ModuleGeneratorsForm(obj);
      if form = "minimal" then
        Print("Generators are minimal.");
      elif form = "echelon" then
        Print("Generators are in minimal echelon form.");
      elif form = "semiechelon" then
        Print("Generators are in minimal semi-echelon form.");
      fi;
    fi;
##    if func = "print" then 
      Print("\n");
##    fi;
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_ModuleGeneratorCoefficients_DTmanFpGModuleInt">
##  <ManSection>
##  <Heading>HAPPRIME_ModuleGeneratorCoefficients</Heading>
##  <Oper Name="HAPPRIME_ModuleGeneratorCoefficients" Arg="M, elm" Label="for element"/>
##  <Oper Name="HAPPRIME_ModuleGeneratorCoefficientsDestructive" Arg="M, elm" Label="for element"/>
##  <Oper Name="HAPPRIME_ModuleGeneratorCoefficients" Arg="M, coll" Label="for collection of elements"/>
##  <Oper Name="HAPPRIME_ModuleGeneratorCoefficientsDestructive" Arg="M, coll" Label="for collection of elements"/>
## 
##  <Returns>
##  Vector
##  </Returns>
##  <Description>
##  Returns the coefficients needed to make the module element <A>elm</A> as a 
##  linear and &G;-combination of the module generators of the <K>FpGModuleGF</K> 
##  <A>M</A>. The coefficients are returned in standard vector form, or if there is
##  no solution then <C>fail</C> is returned. If a list of elements is given,
##  then a list of coefficients (or <C>fails</C>) is returned.
##  The <C>Destructive</C> form of this function might change the elements of 
##  of <A>M</A> or <A>elm</A>. The non-<C>Destructive</C> version makes copies
##  to ensure that they are not changed.
##  <P/>
##  See also <Ref Oper="HAPPRIME_ModuleElementFromGeneratorCoefficients" Label="for element"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_ModuleGeneratorCoefficientsDestructive,
  "generic method",
  [IsFpGModuleGF, IsVector and IsMutable],
  function(M, elm)

  if ModuleIsFullCanonical(M) then
    return elm;
  fi;

  return HAPPRIME_CoefficientsOfGeneratingRows(
    ModuleGenerators(M), ModuleGroupAndAction(M), elm);
end);
#####################################################################
InstallMethod(HAPPRIME_ModuleGeneratorCoefficients,
  "generic method",
  [IsFpGModuleGF, IsVector],
  function(M, elm)

  local copyM, copyelm;
  copyM := MutableCopyModule(M);
  copyelm := ShallowCopy(elm);
  
  if ModuleIsFullCanonical(copyM) then
    return copyelm;
  fi;
     
  return HAPPRIME_CoefficientsOfGeneratingRowsDestructive(
    ModuleGenerators(copyM), ModuleGroupAndAction(copyM), copyelm);
end);
#####################################################################
InstallMethod(HAPPRIME_ModuleGeneratorCoefficientsDestructive,
  "generic method",
  [IsFpGModuleGF, IsMatrix and IsMutable],
  function(M, elm)

  if ModuleIsFullCanonical(M) then
    return elm;
  fi;
     
  return HAPPRIME_CoefficientsOfGeneratingRowsDestructive(
    ModuleGenerators(M), ModuleGroupAndAction(M), elm);
end);
#####################################################################
InstallMethod(HAPPRIME_ModuleGeneratorCoefficients,
  "generic method",
  [IsFpGModuleGF, IsMatrix],
  function(M, elm)

  local copyM, copyelm;
  copyM := MutableCopyModule(M);
  copyelm := MutableCopyMat(elm);
  
  if ModuleIsFullCanonical(copyM) then
    return copyelm;
  fi;

  return HAPPRIME_CoefficientsOfGeneratingRowsDestructive(
    ModuleGenerators(copyM), ModuleGroupAndAction(copyM), copyelm);
end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_ModuleElementFromGeneratorCoefficients_DTmanFpGModuleInt">
##  <ManSection>
##  <Heading>HAPPRIME_ModuleElementFromGeneratorCoefficients</Heading>
##  <Oper Name="HAPPRIME_ModuleElementFromGeneratorCoefficients" Arg="M, c" Label="for element"/>
##  <Oper Name="HAPPRIME_ModuleElementFromGeneratorCoefficients" Arg="M, coll" Label="for collection of elements"/>
## 
##  <Returns>
##  Vector
##  </Returns>
##  <Description>
##  Returns an element from the module <A>M</A>, constructed as a linear and 
##  &G;-sum of the module generators as specified in <A>c</A>. If a list of 
##  coefficient vectors is given, a list of corresponding module elements is
##  returned.
##  <P/>
##  See also <Ref Oper="HAPPRIME_ModuleGeneratorCoefficients" Label="for element"/>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_ModuleElementFromGeneratorCoefficients,
  "method for vector",
  [IsFpGModuleGF, IsVector],
  function(M, c)

  if ModuleIsFullCanonical(M) then
    return c;
  fi;

  return HAPPRIME_GenerateFromGeneratingRowsCoefficients(
    ModuleGenerators(M), ModuleGroupAndAction(M), c);
end);
#####################################################################
InstallMethod(HAPPRIME_ModuleElementFromGeneratorCoefficients,
  "method for matrix",
  [IsFpGModuleGF, IsMatrix],
  function(M, coll)

  if ModuleIsFullCanonical(M) then
    return coll;
  fi;

  return HAPPRIME_GenerateFromGeneratingRowsCoefficients(
    ModuleGenerators(M), ModuleGroupAndAction(M), coll);
end);
#####################################################################
InstallOtherMethod(HAPPRIME_ModuleElementFromGeneratorCoefficients,
  "method for empty vector or matrix",
  [IsFpGModuleGF, IsEmpty],
  function(M, coll)

    Error("vector or matrix is empty");
end);
#####################################################################
InstallOtherMethod(HAPPRIME_ModuleElementFromGeneratorCoefficients,
  "method for fail",
  [IsFpGModuleGF, IsBool],
  function(M, coll)
    return fail;
end);
#####################################################################
InstallOtherMethod(HAPPRIME_ModuleElementFromGeneratorCoefficients,
  "method for list with fails",
  [IsFpGModuleGF, IsList],
  function(M, coll)

    local results, mycoll, good, i, elms;

    results := List([1..Length(coll)], i->fail);
    
    mycoll := MutableCopyMat(coll);
    good := [];
    for i in [Length(mycoll), Length(mycoll)-1..1] do
      if mycoll[i] = fail then
        Remove(mycoll, i);
      else
        Add(good, i);
      fi;
    od;
    if not IsEmpty(mycoll) then
      good := Reversed(good);
      elms := HAPPRIME_GenerateFromGeneratingRowsCoefficients(
        ModuleGenerators(M), ModuleGroupAndAction(M), mycoll);
    
      for i in [1..Length(elms)] do
        results[good[i]] := elms[i];
      od;
    fi;
    return results;
  end
);
#####################################################################

  
#####################################################################
##  <#GAPDoc Label="HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive_DTmanFpGModuleInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive" Arg="vgens, GA"/>
##  <Oper Name="HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsOnRightDestructive" Arg="vgens, GA"/>
##
##  <Returns>
##  FpGModuleGF
##  </Returns>
##  <Description>
##  Returns a module with minimal generators that is equal to the 
##  <M>\mathbb{F}G</M>-module with <E>vector space</E> basis <A>vgens</A> and 
##  <Ref Func="ModuleGroupAndAction"/> as specified in <A>GA</A>. The solution 
##  is computed by the module radical method, which is fast at the expense of 
##  memory. This function will corrupt the matrix <A>gens</A>.
##  <P/>
##  This is a helper function for <Ref Oper="MinimalGeneratorsModuleRadical"/> that
##  is also used by <Ref Oper="ExtendResolutionPrimePowerGroupRadical" BookName="HAPprime"/> (which
##  knows that its module is already in vector-space form).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsOnRightDestructive,
  [IsMatrix, IsRecord],
  function(vgens, GA)
    local rightGA;
    rightGA := ShallowCopy(GA);
    rightGA.actionOnRight := GA.action;
    rightGA.action := GA.actionOnRight;
    return HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive(vgens, rightGA);
  end
);
#####################################################################
InstallMethod(HAPPRIME_MinimalGeneratorsVectorSpaceGeneratingRowsDestructive,
  [IsMatrix, IsRecord],
  function(vgens, GA)

  local B, v, Bcomp, Bfrattini, BfrattComp, B1, BasInts, G,
    orderG, eltsG, gensGpos, primeG, field, one, zero, semiechelon,
    FrattiniSubspace,
    GactZGflatlist,
    ComplementaryBasisNSDestructive,
    ComplementaryBasis2;

    #####################################################################
    # Calculate the Frattini subspace. This is the subspace spanned by the 
    # vectors that are not needed to generate the space
    FrattiniSubspace := function(B)
      local BFrattini, Bt, g, gBt, i, nvector, cnt, v, b, minGenEltsG, primeG;
  
      # B is a set of F-generators 
      # We want the FG-generators.
      # The Frattini subgroup is all of the non-generators of the FG-module
      # Generate this from v - gv for all v in B and g in the group
      BFrattini := [];
      minGenEltsG := MinimalGeneratingSet(GA.group);
      primeG := PrimePGroup(GA.group);
      ConvertToMatrixRepNC(B, primeG);
      Bt := TransposedMatMutable(B);
      # Transpose B so that I can do GActMatrixColumns  
      for g in minGenEltsG do
        # Calculate v - gv (in columns)
        gBt := Bt - HAPPRIME_GActMatrixColumns(g, Bt, GA);
        Append(BFrattini, TransposedMatMutable(gBt));
      od;
  
      # The second terms in the Frattini subgroup are v + gv + g^2v + ...
      # but are only needed if the order of the group is more than 2
      if primeG > 3 then 
        nvector := ListWithIdenticalEntries(Length(B[1]), zero);
        cnt := 1;
        for v in B do
          for g in [2..Length(eltsG)] do
            # Only need this if g^primeG = Identity, i.e. if Order(g) = primeG
            if Order(eltsG[g]) = primeG then
              b := ShallowCopy(nvector);
              for i in [1..primeG] do
                b := b + GA.action(minGenEltsG[g]^i, v);
              od;
              BFrattini[cnt] := v;
              cnt := cnt + 1;
            fi;
          od;
        od;
      fi;
  
      # There are many more rows here than we need to span the space,
      # so row-reduce this to a vector-space basis.
      #ConvertToMatrixRepNC(BFrattini, primeG);
      BFrattini := SemiEchelonMatDestructive(BFrattini).vectors;
  
      return BFrattini;
    end;
    #####################################################################
  
    #####################################################################
    ComplementaryBasis2 := function(B)

      local Bcopy, BC, heads, ln, i, v, nvector;

      Bcopy := MutableCopyMat(B);

      # How long is a row from B? This is the length of vectors in the space
      ln:=Length(Bcopy[1]);
      # Convert the basis we are given into semi-echelon form. This will tell us
      # which elements in the vector play a part in spanning the basis
      ConvertToMatrixRepNC(Bcopy, field); 
      heads := SemiEchelonMatDestructive(Bcopy).heads;
      BC:=[];

      # Just use the standard basis for the complementary basis. 
      # Anywhere where there is a missing pivot (a zero in the heads) 
      # is a free variable and thus a vector containing this will
      # be in the complement.
      nvector := ListWithIdenticalEntries(ln, Zero(field));
      ConvertToVectorRepNC(nvector, field);
      for i in [1..ln] do
        if heads[i] = 0 then
        v := ShallowCopy(nvector);
        v[i] := one;
        Append(BC, [v]);
        fi;
      od;

      ConvertToMatrixRepNC(BC, field);

      return BC;
    end;
    #####################################################################
    ComplementaryBasisNSDestructive := function(B, NS)
      local BC, heads, ln, i, v, nvector;

      # How long is a row from B? This is the length of vectors in the space
      ln:=Length(B[1]);
      # Convert the basis we are given into semi-echelon form. This will tell us
      # which elements in the vector play a part in spanning the basis
      ConvertToMatrixRepNC(B, field); 
      heads:=SemiEchelonMatDestructive(B).heads;
      BC:=[];

      nvector := ListWithIdenticalEntries(ln, Zero(field));
      ConvertToVectorRepNC(nvector, field);

      # Use the appropriate vectors from NS (i.e. the row which has 
      # its pivot in the sample pace as the missing pivot here).
      for i in [1..ln] do
        if heads[i]=0 then
          v:=NS.vectors[NS.heads[i]];
          Append(BC,[v]);
        fi;
      od;

      ConvertToMatrixRepNC(BC, field);

      return BC;
    end;
    #####################################################################

    # If M is empty then return an empty vector
    if IsEmpty(vgens) or Length(vgens) = 1 then
      return FpGModuleGFNC(vgens, GA, "minimal");
    fi;

    field := Field(vgens[1][1]);
    one := Identity(field);
    zero := 0*one;
  
    # Do SemiEchelon on the submodule so that we have a list of the 
    # heads
    semiechelon := SemiEchelonMatDestructive(vgens);
    Unbind(vgens);
    B := semiechelon.vectors;

    # The Frattini subspace of the null space is spanned by all the vectors
    # that are _not_ needed to generate it  
    Bfrattini := FrattiniSubspace(B);
    # We want the basis for the space not spanned by the null space
    Bcomp := ComplementaryBasis2(B);

    # Combine the Frattini space with the basis for vectors not in the null space
    Append(Bfrattini, Bcomp);
    Unbind(Bcomp);

    # Anything that is not in the Frattini and is not-not in the null space
    # must be in the null space. This time around, the call to ComplementaryBasis
    # will select the rows from the null space that are complementary, 
    ## i.e. still needed to span the entire space in addition to BfrattComp
    B1 := ComplementaryBasisNSDestructive(Bfrattini, semiechelon);

    return FpGModuleGFNC(B1, GA, "minimal");
  end);
#####################################################################


#####################################################################
##  <#GAPDoc Label="HAPPRIME_IsGroupAndAction_DTmanFpGModuleInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_IsGroupAndAction" Arg="obj"/>
## 
##  <Returns>
##  Boolean
##  </Returns>
##  <Description>
##  Returns <C>true</C> if <A>obj</A> appears to be a <C>groupAndAction</C> 
##  record (see <Ref Func="ModuleGroupAndAction"/>), or <C>false</C> otherwise.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_IsGroupAndAction,
  "method for vector",
  [IsRecord],
  function(GA)

  if not IsBound(GA.group) then
    return false;
  fi;
  if not IsGroup(GA.group) then  
    return false;
  fi;
  if not IsBound(GA.action) then
    return false;
  fi;
  if not IsFunction(GA.action) then  
    return false;
  fi;
  if not IsBound(GA.actionBlockSize) then
    return false;
  fi;
  if not IsPosInt(GA.actionBlockSize) then  
    return false;
  fi;
  return true;
end);
#####################################################################
    
## Then do radical and Omega and DualBasis
## Then do ResolutionModule
## Then document for graham
## Then do poincare testing
## Then do induced equivarient map


