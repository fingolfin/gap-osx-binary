Read( "SmallMainExample2.g" );

filt := PurityFiltration( W );

II_E := SpectralSequence( filt );

Display( II_E );

m := IsomorphismOfFiltration( filt );

Display( Source( m ) );

Display( TimeToString( homalgTime( Qxyz ) ) );
