##  <#GAPDoc Label="Schenck-3.2">
##  <Subsection Label="Schenck-3.2">
##  <Heading>Schenck-3.2</Heading>
##  This is an example from Section 3.2 in <Cite Key="Sch"/>.
##  <Example><![CDATA[
##  gap> Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";;
##  gap> mmat := HomalgMatrix( "[ x, x^3 + y^3 + z^3 ]", 1, 2, Qxyz );
##  <A 1 x 2 matrix over an external ring>
##  gap> S := GradedRing( Qxyz );;
##  gap> M := RightPresentationWithDegrees( mmat, S );
##  <A graded cyclic right module on a cyclic generator satisfying 2 relations>
##  gap> Mr := Resolution( M );
##  <A right acyclic complex containing
##  2 morphisms of graded right modules at degrees [ 0 .. 2 ]>
##  gap> bettiM := BettiTable( Mr );
##  <A Betti diagram of <A right acyclic complex containing
##  2 morphisms of graded right modules at degrees [ 0 .. 2 ]>>
##  gap> Display( bettiM );
##   total:  1 2 1
##  --------------
##       0:  1 1 .
##       1:  . . .
##       2:  . 1 1
##  --------------
##  degree:  0 1 2
##  gap> R := GradedRing( CoefficientsRing( S ) * "x,y,z,w" );;
##  gap> nmat := HomalgMatrix( "[ z^2 - y*w, y*z - x*w, y^2 - x*z ]", 1, 3, R );
##  <A 1 x 3 matrix over a graded ring>
##  gap> N := RightPresentationWithDegrees( nmat );
##  <A graded cyclic right module on a cyclic generator satisfying 3 relations>
##  gap> Nr := Resolution( N );
##  <A right acyclic complex containing
##  2 morphisms of graded right modules at degrees [ 0 .. 2 ]>
##  gap> bettiN := BettiTable( Nr );
##  <A Betti diagram of <A right acyclic complex containing
##  2 morphisms of graded right modules at degrees [ 0 .. 2 ]>>
##  gap> Display( bettiN );
##   total:  1 3 2
##  --------------
##       0:  1 . .
##       1:  . 3 2
##  --------------
##  degree:  0 1 2
##  ]]></Example>
##  </Subsection>
##  <#/GAPDoc>

LoadPackage( "RingsForHomalg" );

Qxyz := HomalgFieldOfRationalsInDefaultCAS( ) * "x,y,z";

mmat := HomalgMatrix( "[ x, x^3 + y^3 + z^3 ]", 1, 2, Qxyz );

LoadPackage( "GradedRingForHomalg" );

S := GradedRing( Qxyz );;

LoadPackage( "GradedModules" );

M := RightPresentationWithDegrees( mmat, S );

Mr := Resolution( M );

bettiM := BettiTable( Mr );

Display( bettiM );

Assert( 0,
        MatrixOfDiagram( bettiM ) =
        [ [ 1, 1, 0 ],
          [ 0, 0, 0 ],
          [ 0, 1, 1 ] ] );

Print( "\n" );

R := GradedRing( CoefficientsRing( S ) * "x,y,z,w" );;

nmat := HomalgMatrix( "[ z^2 - y*w, y*z - x*w, y^2 - x*z ]", 1, 3, R );

N := RightPresentationWithDegrees( nmat, R );

Nr := Resolution( N );

bettiN := BettiTable( Nr );

Display( bettiN );

Assert( 0,
        MatrixOfDiagram( bettiN ) =
        [ [ 1, 0, 0 ],
          [ 0, 3, 2 ] ] );
