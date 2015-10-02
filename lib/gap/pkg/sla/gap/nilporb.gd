DeclareCategory( "IsNilpotentOrbit", IsObject );
DeclareCategoryCollections( "IsNilpotentOrbit" );
DeclareCategoryFamily( "IsNilpotentOrbit" );

DeclareOperation( "RandomSL2Triple", [IsNilpotentOrbit] );

DeclareAttribute( "SL2Triple", IsNilpotentOrbit );

DeclareAttribute( "WeightedDynkinDiagram", IsNilpotentOrbit );

DeclareAttribute( "AmbientLieAlgebra", IsNilpotentOrbit );

DeclareAttribute( "SemiSimpleType", IsNilpotentOrbit );

DeclareAttribute( "OrbitPartition", IsNilpotentOrbit );

DeclareOperation( "NilpotentOrbit", [ IsLieAlgebra, IsList ] );

DeclareAttribute( "NilpotentOrbits", IsLieAlgebra );

DeclareOperation( "SL2Grading", [ IsLieAlgebra, IsObject ] );

DeclareOperation( "SL2Triple", [ IsLieAlgebra, IsObject ] );

DeclareAttribute( "SignatureTable", IsLieAlgebra );

DeclareProperty( "IsSLA", IsLieAlgebra );

DeclareAttribute( "SLAComponents", IsLieAlgebra );

DeclareAttribute( "RigidNilpotentOrbits", IsLieAlgebra );

DeclareAttribute( "InducedNilpotentOrbits", IsLieAlgebra );

