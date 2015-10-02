#############################################################################
##
##  HAPPRIME - happrime.tst
##  Test the package with some examples
##  Paul Smith
##
##  Copyright (C)  2008-2009
##  National University of Ireland Galway
##  Copyright (C)  2011
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

gap> START_TEST("HAPprime version 0.6 general tests");
gap> 
gap> LoadPackage("HAP");;
gap> LoadPackage("HAPPrime");;
gap> ##
gap> # Check the PackageInfo.g for this package
gap> ValidatePackageInfo( Filename( DirectoriesPackageLibrary( "HAPprime", "" ), "PackageInfo.g" ) );
true
gap> # Set the info level to zero to suppress some of the output
gap> infolevel := InfoLevel(InfoHAPprime);;
gap> SetInfoLevel(InfoHAPprime, 0);
gap> ##
gap> ## Test ResolutionPrimePowerGroupGF by calculating the module ranks
gap> ## in a minimal resolution
gap> R := ResolutionPrimePowerGroupGF( SmallGroup(32, 8), 5 );;
gap> Print(ResolutionModuleRanks(R), "\n"); 
[ 2, 3, 4, 4, 5 ]
gap> ##
gap> ## Test ResolutionPrimePowerGroupRadical by seeing that it gives the 
gap> ## correct PoincareSeriesAutoMem
gap> R := ResolutionPrimePowerGroupRadical( SmallGroup(128, 154), 8 );;
gap> Print(PoincareSeries(R, 8), "\n");
(1)/(x_1^4-2*x_1^3+2*x_1^2-2*x_1+1)
gap> ##
gap> ## Test ResolutionPrimePowerGroupAutoMem by seeing comparing the torsion
gap> ## coefficients of the homology
gap> ## Note that this is unlikely to switch to the GF version, but
gap> ## it at least checks that the function exists
gap> R := ResolutionPrimePowerGroupAutoMem( SmallGroup(64, 36), 15 );;
gap> Print(List([1..14], i->Homology(TensorWithIntegersModP(R, 2), i)), "\n");
[ 2, 3, 5, 6, 7, 9, 11, 14, 17, 20, 24, 27, 30, 34 ]
gap> ##
gap> # Reset the info level
gap> SetInfoLevel(InfoHAPprime, infolevel);;
gap> 
gap> ## Tweak this number until this gives the same GAP4stones as
gap> ## ReadTest("/usr/local/lib/gap4r4/tst/combinat.tst");
gap> STOP_TEST("HAPprime/tst/happrime.tst", 2000000000);
