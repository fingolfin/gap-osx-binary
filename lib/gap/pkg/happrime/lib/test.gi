#############################################################################
##
##  HAPPRIME - test.gi
##  Various test operations
##  Paul Smith
##
##  Copyright (C) 2007-2008
##  National University of Ireland Galway
##  Copyright (C) 2007-2011
##  University of St Andrews
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
#############################################################################

if not IsBound(sing_exec) then
  sing_exec := "Singular";
fi;

#####################################################################
##  <#GAPDoc Label="HAPPRIME_SingularIsAvailable_manTestInt">
##  <ManSection>
##  <Func Name="HAPPRIME_SingularIsAvailable" Arg=""/>
##
##  <Returns>
##    Boolean
##  </Returns>
##  <Description>
##  The <Package>Singular</Package> package can be succesfully loaded whether
##  the <F>singular</F> executable is present or not, so this function
##  attempts to check for the presence of this executable by searching on the 
##  system path and checking for global variables set by the 
##  <Package>Singular</Package>. 
##  <P/>
##  Whether this function returns <Keyword>true</Keyword> or <Keyword>false</Keyword>
##  will not affect the rest of this package: it only affects which tests are run 
##  by the <F>happrime.txt</F> and <F>testall.g</F> test routines.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallGlobalFunction(HAPPRIME_SingularIsAvailable,
  function()
  local IsExec;

  if not LoadPackage("Singular") = true then 
    return false;
  fi;

  ##
  # The following is based on the code in pkg/singular/gap/singular.g
  ## 

  IsExec := path -> IsString(path) and IsDirectoryPath(path) <> true 
    and IsExecutableFile(path) = true;

  # try to correct the string in case that only the directory or the
  # filename was supplied
  if IsBound(sing_exec) and IsString(sing_exec) then
    if IsDirectoryPath(sing_exec) = true then
      sing_exec := Filename(Directory(sing_exec), "Singular");
    elif not IsExecutableFile(sing_exec) = true and not "/" in sing_exec then
      sing_exec := Filename(DirectoriesSystemPrograms(), sing_exec);
    fi;
  fi;

  # try to detect the executable file
  if not IsBound(sing_exec) or not IsExec(sing_exec) then
    sing_exec := Filename(DirectoriesSystemPrograms(), "Singular");
  fi;

  return IsBound(sing_exec) and IsExec(sing_exec);
end);
#####################################################################

#####################################################################
##  <#GAPDoc Label="HAPPRIME_Random2Group_manTestInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_Random2Group" Arg="[orderG]"/>
##  <Oper Name="HAPPRIME_Random2GroupAndAction" Arg="[orderG]"/>
##
##  <Returns>
##    Group or <C>groupAndAction</C> record
##  </Returns>
##  <Description>
##  Returns a random 2-group, or a <C>groupAndAction</C> record 
##  (see <Ref Oper="ModuleGroupAndAction"/>) with the canonical action. 
##  The order may be specified as an 
##  argument, or if not then a group is chosen randomly (from a uniform 
##  distribution) over all of the possible groups with order from 2 to 128.
##  </Description>
##  </ManSection>
##  <Log><![CDATA[
##  gap> HAPPRIME_Random2Group();
##  <pc group of size 8 with 3 generators>
##  gap> HAPPRIME_Random2Group();
##  <pc group of size 32 with 5 generators>
##  ]]></Log>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_Random2GroupAndAction,
  [IsPosInt],
  function(n)
    return CanonicalGroupAndAction(HAPPRIME_Random2Group(n));
end);
#####################################################################
InstallOtherMethod(HAPPRIME_Random2GroupAndAction,
  [],
  function()
    return CanonicalGroupAndAction(HAPPRIME_Random2Group());
end);
#####################################################################
InstallMethod(HAPPRIME_Random2Group,
  [IsPosInt],
  function(n)
    local logorder, order;
  
    logorder := LogInt(n, 2);
    if n < 2 or 2^logorder <> n then
      Error("the order of the group must be a positive power of two\n");
    fi;
  
    order := 2^logorder;
  
    return SmallGroup(order, Random([1..NumberSmallGroups(order)]));
end);  
#####################################################################
InstallOtherMethod(HAPPRIME_Random2Group,
  [],
  function()
    local maxgroup, numgroups, logorder, g, totalgroups, i;

    maxgroup := 7; # 128

    # Count up how many groups there are in total
    totalgroups := 0;
    for i in [1..maxgroup] do
      totalgroups := totalgroups + NumberSmallGroups(2^i);
    od;
    g := Random([1..totalgroups]);
    totalgroups := 0;
    for i in [1..maxgroup] do
      totalgroups := totalgroups + NumberSmallGroups(2^i);
      if g <= totalgroups then
        logorder := i;
        break;
      fi;
    od;

    return HAPPRIME_Random2Group(2^logorder);
end);
#####################################################################



#####################################################################
##  <#GAPDoc Label="HAPPRIME_TestResolutionPrimePowerGroup_manTestInt">
##  <ManSection>
##  <Oper Name="HAPPRIME_TestResolutionPrimePowerGroup" Arg="[ntests]"/>
##
##  <Returns>
##    Boolean
##  </Returns>
##  <Description>
##  Returns <K>true</K> if <Ref Oper="ResolutionPrimePowerGroupGF" Label="for group" BookName="HAPprime"/> and
##  <Ref Oper="ResolutionPrimePowerGroupRadical" Label="for group" BookName="HAPprime"/> appear 
##  to be working correctly, or <K>false</K> otherwise.
##  This repeatedly creates resolutions of length 6 for random 2-groups (up to order
##  128) using both of the &HAPprime; resolution algorithms, 
##  and compares them both with the original &HAP;
##  <Ref Func="ResolutionPrimePowerGroup" BookName="HAP"/> and checks that they
##  are equal. The optional argument <A>ntests</A> specifies how many
##  resolutions to try: the default is 25.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
#####################################################################
InstallMethod(HAPPRIME_TestResolutionPrimePowerGroup,
  [IsPosInt],
  function(n)

  local i, G, R, R2, S, ok, ok2;

  for i in [1..n] do
    G := HAPPRIME_Random2Group();
    Print("******* Testing Group ", IdGroup(G)[2], " of order ", 
      IdGroup(G)[1], "\n");

    R := ResolutionPrimePowerGroupGF(G, 6);
    R2 := ResolutionPrimePowerGroupRadical(G, 6);
    S := ResolutionPrimePowerGroup(G, 6);

    ok := ResolutionsAreEqual(R, S);
    ok2 := ResolutionsAreEqual(R2, S);
    if ok = false or ok2 = false then
      Print("Failed\n");
      return false;
    fi;
  od;

  return true;
end);
#####################################################################
InstallOtherMethod(HAPPRIME_TestResolutionPrimePowerGroup,
  [],
  function()

  return HAPPRIME_TestResolutionPrimePowerGroup(25);
end);
#####################################################################


