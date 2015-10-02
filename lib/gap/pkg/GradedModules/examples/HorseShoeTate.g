Read( "MiniExample.g" );
C:=CokernelSequence(PresentationMorphism(W));
#TC:=HorseShoeTateResolution( [ KoszulDualRing( S ), 0, 4 ], C );
TTC:=TateTriangle([KoszulDualRing(S),0,4],C);
