# congruence, chapter 3

# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/farey.xml", 59, 65 ]

gap> fs:=FareySymbolByData([infinity,0,1,2,infinity],[1,2,2,1]);                         
[ infinity, 0, 1, 2, infinity ]
[ 1, 2, 2, 1 ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/farey.xml", 76, 81 ]

gap> IsValidFareySymbol(fs);
true


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/farey.xml", 99, 104 ]

gap> GeneralizedFareySequence(fs);
[ infinity, 0, 1, 2, infinity ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/farey.xml", 121, 126 ]

gap> List([1..5], i -> NumeratorOfGFSElement(GeneralizedFareySequence(fs),i));
[ -1, 0, 1, 2, 1 ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/farey.xml", 142, 147 ]

gap> List([1..5], i -> DenominatorOfGFSElement(GeneralizedFareySequence(fs),i));         
[ 0, 1, 1, 1, 0 ]


# [ "/Users/alexk/gap4r7p5/pkg/congruence/doc/farey.xml", 159, 164 ]

gap> LabelsOfFareySymbol(fs);
[ 1, 2, 2, 1 ]

