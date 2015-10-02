# GAP Implementation
# This file was generated from 
# $Id: functors.gd,v 1.7 2012/08/01 16:01:10 sunnyquiver Exp $
DeclareAttribute( "DualOfModule", IsPathAlgebraMatModule );
DeclareAttribute( "TransposeOfModule", IsPathAlgebraMatModule );
DeclareAttribute( "DTr", IsPathAlgebraMatModule );
DeclareAttribute( "TrD", IsPathAlgebraMatModule );
DeclareSynonym("DualOfTranspose", DTr);
DeclareSynonym("TransposeOfDual", TrD);
DeclareAttribute( "StarOfModule", IsPathAlgebraMatModule );
DeclareAttribute( "StarOfModuleHomomorphism", IsPathAlgebraMatModuleHomomorphism );
DeclareAttribute( "NakayamaFunctorOfModule", IsPathAlgebraMatModule );
DeclareAttribute( "NakayamaFunctorOfModuleHomomorphism", IsPathAlgebraMatModuleHomomorphism );