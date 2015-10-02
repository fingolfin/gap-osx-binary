##  <#GAPDoc Label="Schenck-8.3">
##  <Subsection Label="Schenck-8.3">
##  <Heading>Schenck-8.3</Heading>
##  This is an example from Section 8.3 in <Cite Key="Sch"/>.
##  <Example><![CDATA[
##  gap> R := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z,w";;
##  gap> S := GradedRing( R );;
##  gap> jmat := HomalgMatrix( "[ z*w, x*w, y*z, x*y, x^3*z - x*z^3 ]", 1, 5, S );
##  <A 1 x 5 matrix over a graded ring>
##  gap> J := RightPresentationWithDegrees( jmat );
##  <A graded cyclic right module on a cyclic generator satisfying 5 relations>
##  gap> Jr := Resolution( J );
##  <A right acyclic complex containing
##  3 morphisms of graded right modules at degrees [ 0 .. 3 ]>
##  gap> betti := BettiTable( Jr );
##  <A Betti diagram of <A right acyclic complex containing
##  3 morphisms of graded right modules at degrees [ 0 .. 3 ]>>
##  gap> Display( betti );
##   total:  1 5 6 2
##  ----------------
##       0:  1 . . .
##       1:  . 4 4 1
##       2:  . . . .
##       3:  . 1 2 1
##  ----------------
##  degree:  0 1 2 3
##  ]]></Example>
##  </Subsection>
##  <#/GAPDoc>

LoadPackage( "RingsForHomalg" );

R := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z,w";;

LoadPackage( "GradedRingForHomalg" );

S := GradedRing( R );;

jmat := HomalgMatrix( "[ z*w, x*w, y*z, x*y, x^3*z - x*z^3 ]", 1, 5, S );

LoadPackage( "GradedModules" );

J := RightPresentationWithDegrees( jmat );

Jr := Resolution( J );

betti := BettiTable( Jr );

Display( betti );

Assert( 0,
        MatrixOfDiagram( betti ) =
        [ [ 1, 0, 0, 0 ],
          [ 0, 4, 4, 1 ],
          [ 0, 0, 0, 0 ],
          [ 0, 1, 2, 1 ] ] );
