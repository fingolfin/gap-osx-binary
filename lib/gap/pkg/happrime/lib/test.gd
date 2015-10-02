#############################################################################
##
##  HAPPRIME - test.gd
##  Various test operations
##  Paul Smith
##
##  Copyright (C) 2007-2008
##  National University of Ireland Galway
##  Copyright (C) 2011
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
##  $Id: test.gd 296 2008-08-21 11:52:33Z pas $
##
#############################################################################

DeclareGlobalFunction("HAPPRIME_SingularIsAvailable");

DeclareOperation("HAPPRIME_TestResolutionPrimePowerGroup", [IsPosInt]);

DeclareOperation("HAPPRIME_Random2Group", [IsPosInt]);
DeclareOperation("HAPPRIME_Random2GroupAndAction", [IsPosInt]);


