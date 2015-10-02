#############################################################################
##
##  init.g                homalg package
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Reading the declaration part of the homalg package.
##
#############################################################################

## init
ReadPackage( "homalg", "gap/homalg.gd" );

## categories
ReadPackage( "homalg", "gap/HomalgCategory.gd" );

## objects/subobjects
ReadPackage( "homalg", "gap/HomalgObject.gd" );
ReadPackage( "homalg", "gap/HomalgSubobject.gd" );

## morphisms
ReadPackage( "homalg", "gap/HomalgMorphism.gd" );

## elements
ReadPackage( "homalg", "gap/HomalgElement.gd" );

## filtrations
ReadPackage( "homalg", "gap/HomalgFiltration.gd" );

## complexes
ReadPackage( "homalg", "gap/HomalgComplex.gd" );

## chain maps
ReadPackage( "homalg", "gap/HomalgChainMorphism.gd" );

## bicomplexes
ReadPackage( "homalg", "gap/HomalgBicomplex.gd" );

## bigraded objects
ReadPackage( "homalg", "gap/HomalgBigradedObject.gd" );

## spectral sequences
ReadPackage( "homalg", "gap/HomalgSpectralSequence.gd" );

## functors
ReadPackage( "homalg", "gap/HomalgFunctor.gd" );

## diagrams
ReadPackage( "homalg", "gap/HomalgDiagram.gd" );

## main
ReadPackage( "homalg", "gap/StaticObjects.gd" );

ReadPackage( "homalg", "gap/Morphisms.gd" );

ReadPackage( "homalg", "gap/Complexes.gd" );

ReadPackage( "homalg", "gap/ChainMorphisms.gd" );

ReadPackage( "homalg", "gap/SpectralSequences.gd" );

ReadPackage( "homalg", "gap/Filtrations.gd" );

ReadPackage( "homalg", "gap/ToolFunctors.gd" );
ReadPackage( "homalg", "gap/BasicFunctors.gd" );
ReadPackage( "homalg", "gap/OtherFunctors.gd" );

## LogicForHomalg subpackages
ReadPackage( "homalg", "gap/LIOBJ.gd" );
ReadPackage( "homalg", "gap/LIMOR.gd" );
ReadPackage( "homalg", "gap/LICPX.gd" );
ReadPackage( "homalg", "gap/LICHM.gd" );

