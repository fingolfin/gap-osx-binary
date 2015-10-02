#############################################################################
##
##  HAPPRIME - groups.gi
##  General Functions, Operations and Methods for groups
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
##  $Id: groups.gi 318 2008-09-15 11:42:28Z pas $
##
#############################################################################


#####################################################################
##  <#GAPDoc Label="HallSeniorNumber_manGroups">
##  <ManSection>
##  <Heading>HallSeniorNumber</Heading>
##  <Attr Name="HallSeniorNumber" Arg="order, i" Label="for SmallGroup library ref"/>
##  <Attr Name="HallSeniorNumber" Arg="G" Label="for group"/>
##
##  <Returns>
##    Integer
##  </Returns>
##  <Description>
##  Returns the Hall-Senior number for a small group (of order 8, 16, 32 or 64).
##  The group can be specified an <A>order</A>, <A>i</A> pair from the 
##  &GAP; <Ref Sect="Small groups" BookName="ref"/> library, or as a group
##  <A>G</A>, in which case <Ref Func="IdSmallGroup" BookName="ref"/> is
##  used to identify the group.
##  </Description>
##  </ManSection>
##  <Example><![CDATA[
##  gap> HallSeniorNumber(32, 5);
##  20
##  gap> HallSeniorNumber(SmallGroup(64, 1));
##  11
##  ]]></Example>
##  <#/GAPDoc>
#####################################################################
InstallOtherMethod(HallSeniorNumber,
  "for group",
  [IsGroup],
  function(G)
    return HallSeniorNumber(IdSmallGroup(G)[1], IdSmallGroup(G)[2]);
  end
);
#####################################################################
InstallMethod(HallSeniorNumber,
  "for small group library ref",
  [IsPosInt, IsPosInt],
  function(order, i)
    local SmallGroupToHallSenior;    

    if order = 8 then 
      SmallGroupToHallSenior := 
      [ 3, 2, 4, 5, 1 ];
      if i > 5 then 
        Error("there are only 5 groups of order 8");
      fi;
      return SmallGroupToHallSenior[i];
    elif order = 16 then 
      SmallGroupToHallSenior := 
      [ 5, 3, 9, 10, 4, 11, 12, 13, 14, 2, 6, 7, 8, 1 ];
      if i > 14 then 
        Error("there are only 14 groups of order 16");
      fi;
      return SmallGroupToHallSenior[i];
    elif order = 32 then 
      SmallGroupToHallSenior := 
      [ 7, 18, 5, 19, 20, 46, 47, 48, 27, 28, 31, 21, 30, 29, 32, 6, 22, 49, 
        50, 51, 3, 11, 12, 16, 14, 15, 33, 36, 37, 38, 39, 40, 41, 34, 35, 4, 
        13, 17, 23, 24, 25, 26, 44, 45, 2, 8, 9, 10, 42, 43, 1 ];
      if i > 51 then 
        Error("there are only 51 groups of order 32");
      fi;
      return SmallGroupToHallSenior[i];
    elif order = 64 then 
      SmallGroupToHallSenior := 
      [ 11, 8, 38, 131, 132, 62, 63, 237, 238, 239, 240, 234, 235, 236, 65, 64, 37,
      180, 181, 60, 59, 61, 128, 129, 130, 9, 39, 182, 40, 133, 66, 250, 251,
      252, 253, 254, 255, 138, 139, 142, 248, 247, 249, 41, 67, 246, 140, 141,
      143, 10, 42, 265, 266, 267, 5, 22, 30, 28, 29, 81, 83, 89, 90, 93, 82, 86,
      84, 92, 91, 88, 85, 87, 144, 147, 146, 145, 150, 151, 149, 148, 152, 153,
      6, 23, 31, 32, 24, 94, 96, 123, 126, 124, 125, 127, 47, 48, 53, 114, 113,
      115, 51, 120, 25, 95, 97, 50, 49, 54, 116, 52, 121, 33, 98, 102, 34, 99,
      100, 55, 56, 57, 118, 119, 117, 58, 122, 35, 101, 201, 203, 217, 202, 204,
      218, 261, 263, 262, 264, 259, 260, 205, 206, 208, 211, 219, 220, 196, 195,
      197, 229, 228, 230, 257, 256, 258, 207, 210, 209, 212, 221, 222, 213, 214,
      223, 215, 216, 224, 193, 194, 200, 232, 231, 233, 189, 188, 192, 198, 225,
      226, 191, 199, 190, 227, 7, 26, 36, 134, 135, 136, 137, 244, 245, 3, 15,
      16, 20, 18, 19, 27, 106, 108, 107, 68, 71, 72, 73, 77, 74, 75, 76, 80, 69,
      70, 78, 79, 169, 170, 172, 171, 175, 177, 176, 179, 178, 173, 174, 154,
      157, 160, 159, 155, 158, 163, 167, 164, 161, 166, 168, 162, 156, 165, 184,
      183, 185, 186, 187, 4, 17, 21, 109, 43, 44, 45, 46, 110, 111, 112, 241,
      242, 243, 2, 12, 13, 14, 103, 104, 105, 1 ];
      if i > 267 then 
        Error("there are only 267 groups of order 64");
      fi;
      return SmallGroupToHallSenior[i];
    else
      Error("the database only contains Hall-Senior numbers for groups of order 8, 16, 32 and 64");
    fi;
  end
);
#####################################################################
