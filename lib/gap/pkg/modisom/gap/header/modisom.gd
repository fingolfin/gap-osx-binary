
DeclareOperation( "AlgebraByTable", [IsObject] );
DeclareOperation( "TableByBasis", [IsAlgebra, IsList] );

DeclareProperty( "IsNilpotentAlgebra", IsAlgebra );

DeclareOperation( "ProductIdeal", [IsAlgebra, IsAlgebra] );
DeclareAttribute( "PowerSeries", IsAlgebra );
DeclareAttribute( "WeightedBasis", IsAlgebra );

DeclareInfoClass( "InfoModIsom" );

