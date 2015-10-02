#############################################################################
##
#W  gp3objmap.g              XMOD example files                 Chris Wensley
##
##  version 2.31, 08/11/2014 
##
#Y  Copyright (C) 2001-2014, Murat Alp and Chris Wensley, 
#Y  School of Computer Science, Bangor University, U.K. 
##
#############################################################################

Print("\nXMod example file gp3objmap.g (version 08/11/14) :-");
Print("\ntesting functions for crossed squares\n\n");

## SetInfoLevel( InfoXMod, 2 );

c := (11,12,13,14,15,16);
d := (12,16)(13,15);
cd := (11,16)(12,15)(13,14);
d12 := Group( [c,d] );
SetName( d12, "d12");
s3a := Subgroup( d12, [ c^2, d ] );
SetName( s3a, "s3a" );
s3b := Subgroup( d12, [ c^2, cd ] );
SetName( s3b, "s3b" );
c3 := Subgroup( d12, [ c^2 ] );
SetName( c3, "c3" );

XSconj := XSqByNormalSubgroups( d12, s3b, s3a, c3 );
Print( "Crossed square XSconj for normal subgroups of d12:\n" );
Print( XSconj, "\n" );
nconj := Name( XSconj );
Print( "XSconj has transpose XStrans:\n" );
XStrans := Transpose3dGroup( XSconj );
Print( XStrans, "\n" );

X12 := XModByNormalSubgroup( d12, s3a );
WP12 := WhiteheadPermGroup( X12 );
reg12 := RegularDerivations( X12 );
AP12 := AutomorphismPermGroup( X12 );
A12 := ActorXMod( X12 );
Display( A12 );

XSact := ActorXSq( X12 );
Print( "\nCrossed square XSact for the actor of [s3a -> d12]:\n" );
Print( XSact, "\n" );

xp12 := XPair( XSact );
Print( "WP12 has elements:\n", Elements(WP12), "\n" ); 
Print( "d12 has elements:\n", Elements(d12), "\n" ); 
Print( "and images table:\n", ImagesTable(RegularDerivations(X12)), "\n" );
strong := StrongGeneratorsStabChain( StabChain( d12 ) );
Print( "\nStrongGeneratorsStabChain: ", strong, "\n\n" );
Print( "the crossed pairing images are:\n" );
for p in WP12 do 
    genM := GeneratorsOfGroup( Range( X12 ) );
    imxp := List( genM, m -> ImageElmXPair( xp12, [m,p] ) );
    Print( p, " -> ", imxp, "\n" );
od;
Print( "\nRepeat this calculation on the transposed crossed square:\n" );
XTact := Transpose3dGroup( XSact );
xt12 := XPair( XTact );
for p in WP12 do 
    genM := GeneratorsOfGroup( Range( X12 ) );
    imxt := List( genM, m -> ImageElmXPair( xt12, [p,m] ) );
    Print( p, " -> ", imxt, "\n" );
od;


c6 := Subgroup( d12, [ c ] );
SetName( c6, "c6" );

XSub := XSqByNormalSubgroups( c6, c3, c3, c3 );
Print( "\n\nCrossed square XSub for normal subgroups of c6:\n" );
Print( XSub, "\n" );
nsub := Name( XSub );
id := IdentityMapping( XSconj );
Print( "IdentityMapping on XSconj:\n" );
Display( id );
inc := InclusionMorphism3dDomains( XSconj, XSub );
Print( "Inclusion of XSub in XSconj:\n" );
Display( inc );
Print("\n");

ad12 := GroupHomomorphismByImages( d12, d12, [c,d], [c,d^c] );
as3a := GroupHomomorphismByImages( s3a, s3a, [c^2,d], [c^2,d^c] );
as3b := GroupHomomorphismByImages( s3b, s3b, [c^2,cd], [c^2,cd^c] );
idc3 := IdentityMapping( c3 );
upconj := Up2dGroup( XSconj ); 
leftconj := Left2dGroup( XSconj ); 
downconj := Down2dGroup( XSconj ); 
rightconj := Right2dGroup( XSconj ); 
up := XModMorphismByHoms( upconj, upconj, idc3, as3b );
left := XModMorphismByHoms( leftconj, leftconj, idc3, as3a );
down := XModMorphismByHoms( downconj, downconj, as3a, ad12 );
right := XModMorphismByHoms( rightconj, rightconj, as3b, ad12 );

autoconj := XSqMorphism( XSconj, XSconj, up, left, right, down );
ord := Order( autoconj );
Print( "Automorphism of XSconj :-\n" );
Display( autoconj );
Print("\n");

##############################################################################
##
#E  gp3objmap.g  . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
