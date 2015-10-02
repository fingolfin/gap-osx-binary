gap> START_TEST("HAPprime version 0.6 userguide examples");
gap> HAPprimeInfoLevel := InfoLevel(InfoHAPprime);;
gap> SetInfoLevel(InfoHAPprime, 0);;
gap> #
# from paragraph [ 2, 1, 0, 24 ][ "/home/pas/GAP/gap/pkg/HAPprime/doc/userguide/examples.xml", 128 ]

gap> G := SmallGroup(64, 134);;
gap> # First construct a FG-resolution for the group G
gap> R := ResolutionPrimePowerGroupRadical(G, 10);
Resolution of length 10 in characteristic 2 for <pc group of size 64 with
6 generators> .
No contracting homotopy available.
A partial contracting homotopy is available.

gap> # Convert this into a cochain complex (over the prime field with p=2)
gap> C := HomToIntegersModP(R, 2);
Cochain complex of length 10 in characteristic 2 .

gap> # And get the rank of the 9th cohomology group
gap> b9 := Cohomology(C, 9);
55
gap> 
gap> # Since R is a free resolution, the ranks of the cohomology groups
gap> # are the same as the module ranks in R
gap> ResolutionModuleRanks(R);
[ 3, 6, 10, 15, 21, 28, 36, 45, 55, 66 ]
gap> #
gap> SetInfoLevel(InfoHAPprime, HAPprimeInfoLevel);
gap> STOP_TEST("HAPprime/tst/userguideexamples.tst", 4550000000);
