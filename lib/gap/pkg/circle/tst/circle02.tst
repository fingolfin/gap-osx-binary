# Circle, chapter 2

# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 18, 29 ]

gap> CircleMultiplication := function(a,b)
>      return a+b+a*b;
>    end;
function( a, b ) ... end
gap> CircleMultiplication(2,3); 
11
gap> CircleMultiplication( ZmodnZObj(2,8), ZmodnZObj(5,8) );      
ZmodnZObj( 1, 8 )


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 35, 42 ]

gap> CircleMultiplication( 3, ZmodnZObj(3,8) );
ZmodnZObj( 7, 8 )
gap> CircleMultiplication( [1], [2,3] );
[ 5, 5 ]


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 50, 63 ]

gap> DeclareOperation( "BetterCircleMultiplication",                             
>      [IsRingElement,IsRingElement] );
gap> InstallMethod( BetterCircleMultiplication,
>      IsIdenticalObj,
>      [IsRingElement,IsRingElement],  
>      CircleMultiplication );
gap> BetterCircleMultiplication(2,3);
11
gap> BetterCircleMultiplication( ZmodnZObj(2,8), ZmodnZObj(5,8) );
ZmodnZObj( 1, 8 )


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 85, 90 ]

gap> CircleObject( 2 ) * CircleObject( 3 );                       
CircleObject( 11 )


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 105, 109 ]

gap> DeclareCategory( "IsMyCircleObject", IsMultiplicativeElementWithInverse );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 117, 121 ]

gap> DeclareCategoryCollections( "IsMyCircleObject" );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 132, 139 ]

gap> DeclareRepresentation( "IsMyPositionalObjectOneSlotRep",
>     IsPositionalObjectRep, [ 1 ] );
gap> DeclareSynonym( "IsMyDefaultCircleObject",
>     IsMyCircleObject and IsMyPositionalObjectOneSlotRep );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 151, 155 ]

gap> DeclareAttribute( "MyCircleFamily", IsFamily );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 160, 178 ]

gap> InstallMethod( MyCircleFamily,
>     "for a family",
>     [ IsFamily ],
>     function( Fam )
>     local F;
>   # create the family of circle elements
>   F:= NewFamily( "MyCircleFamily(...)", IsMyCircleObject );
>   if HasCharacteristic( Fam ) then
>     SetCharacteristic( F, Characteristic( Fam ) );
>   fi;
>   # store the type of objects in the output
>   F!.MyCircleType:= NewType( F, IsMyDefaultCircleObject );
>   # Return the circle family
>   return F;
> end );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 189, 198 ]

gap> DeclareAttribute( "MyCircleObject", IsRingElement );
gap> InstallMethod( MyCircleObject,
>     "for a ring element",
>     [ IsRingElement ],
>     obj -> Objectify( MyCircleFamily( FamilyObj( obj ) )!.MyCircleType,
>                       [ Immutable( obj ) ] ) );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 204, 211 ]

gap> a:=MyCircleObject(2);
<object>
gap> a![1];
2


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 216, 221 ]

gap> FamilyObj( MyCircleObject ( 2 ) ) = MyCircleFamily( FamilyObj( 2 ) );
true


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 226, 235 ]

gap> InstallMethod( PrintObj,
>     "for object in `IsMyCircleObject'",
>     [ IsMyDefaultCircleObject ],
>     function( obj )
>     Print( "MyCircleObject( ", obj![1], " )" );
>     end );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 242, 247 ]

gap> a;
MyCircleObject( 2 )


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 257, 267 ]

gap> DeclareAttribute("UnderlyingRingElement", IsMyCircleObject );
gap> InstallMethod( UnderlyingRingElement,
>     "for a circle object", 
>     [ IsMyCircleObject],
>     obj -> obj![1] );
gap> UnderlyingRingElement(a);
2


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 278, 290 ]

gap> InstallMethod( \*,
>     "for two objects in `IsMyCircleObject'",
>     IsIdenticalObj,
>     [ IsMyDefaultCircleObject, IsMyDefaultCircleObject ],
>     function( a, b )
>     return MyCircleObject( a![1] + b![1] + a![1]*b![1] );
>     end );
gap> MyCircleObject(2)*MyCircleObject(3);
MyCircleObject( 11 )


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 299, 316 ]

gap> InstallMethod( \=,
>     "for two objects in `IsMyCircleObject'",
>     IsIdenticalObj,
>     [ IsMyDefaultCircleObject, IsMyDefaultCircleObject ],
>     function( a, b )
>     return a![1] = b![1];
>     end );
gap> InstallMethod( \<,
>     "for two objects in `IsMyCircleObject'",
>     IsIdenticalObj,
>     [ IsMyDefaultCircleObject, IsMyDefaultCircleObject ],
>     function( a, b )
>     return a![1] < b![1];
>     end );


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 323, 332 ]

gap> InstallMethod( OneOp,
>     "for an object in `IsMyCircleObject'",
>     [ IsMyDefaultCircleObject ],
>     a -> MyCircleObject( Zero( a![1] ) ) );
gap> One(a);
MyCircleObject( 0 )


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 336, 349 ]

gap> S:=Monoid(a);
<monoid with 1 generator>
gap> One(S);
MyCircleObject( 0 )
gap> S:=Monoid( MyCircleObject( ZmodnZObj( 2,8) ) );
<monoid with 1 generator>
gap> Size(S);
2
gap> AsList(S);
[ MyCircleObject( ZmodnZObj( 0, 8 ) ), MyCircleObject( ZmodnZObj( 2, 8 ) ) ]


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 357, 376 ]

gap> InstallMethod( InverseOp,
>     "for an object in `IsMyCircleObject'",
>     [ IsMyDefaultCircleObject ],
>     function( a )
>     local x;
>     x := Inverse( One( a![1] ) + a![1] );
>     if x = fail then
>       return fail;
>     else
>       return MyCircleObject( -a![1] * x );
>     fi;
>     end );
gap> MyCircleObject(-2)^-1;                
MyCircleObject( -2 )
gap> MyCircleObject(2)^-1; 
MyCircleObject( -2/3 )


# [ "/Users/alexk/gap4r6p1/pkg/circle/doc/objects.xml", 381, 396 ]

gap> Group( MyCircleObject(2) );  
#I  default `IsGeneratorsOfMagmaWithInverses' method returns `true' for
[ MyCircleObject( 2 ) ]
<group with 1 generators>
gap> G:=Group( [MyCircleObject( ZmodnZObj( 2,8 ) )  ]);
#I  default `IsGeneratorsOfMagmaWithInverses' method returns `true' for
[ MyCircleObject( ZmodnZObj( 2, 8 ) ) ]
<group with 1 generators>
gap> Size(G);
2
gap> AsList(G);
[ MyCircleObject( ZmodnZObj( 0, 8 ) ), MyCircleObject( ZmodnZObj( 2, 8 ) ) ]

