## From: 	Alban Quadrat <alban.quadrat@inria.fr>
## Subject: 	MaCaulay's example
## Date: 	18. November 2010 18:26:06 MEZ
## To: 	Mohamed Barakat <mohamed.barakat@rwth-aachen.de>
## 
## Dear Mohamed,
## 
## Find attached an interesting example due to Macaulay paragraph 42, p. 44.
## 
## [Macaulay's book: The algebraic theory of modular systems, p.44]

LoadPackage( "RingsForHomalg" );

R := HomalgFieldOfRationalsInDefaultCAS( ) * "x1,x2,x3,x4";

mat := HomalgMatrix( "[ \
x1^3, \
x2^3, \
x1^2*x4+x2^2*x4+x1*x2*x3 \
]", 3, 1, R);

LoadPackage( "Modules" );

M := LeftPresentation( mat );

filt := PurityFiltration( M );

m := IsomorphismOfFiltration( filt );

Display( StringTime( homalgTime( R ) ) );
