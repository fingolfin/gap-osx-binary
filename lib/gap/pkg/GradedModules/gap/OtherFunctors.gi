#############################################################################
##
##  OtherFunctors.gi                                  Graded Modules package
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##                       Markus Lange-Hegermann, RWTH Aachen
##
##  Implementation stuff for some other graded functors.
##
#############################################################################

####################################
#
# install global functions/variables:
#
####################################

##
## DirectSum
##

InstallGlobalFunction( _Functor_DirectSum_OnGradedModules,	### defines: DirectSum
  function( M, N )
    local S, degMN, sum, iotaM, iotaN, piM, piN, natural, phi;
    
    CheckIfTheyLieInTheSameCategory( M, N );
    
    S := HomalgRing( M );
    
    degMN := Concatenation( DegreesOfGenerators( M ), DegreesOfGenerators( N ) );
    
    #degMN := List( degMN, HomalgElementToInteger  );
    
    sum := DirectSum( UnderlyingModule( M ), UnderlyingModule( N ) );
    
    # take the non-graded natural transformations
    iotaM := MonoOfLeftSummand( sum );
    iotaN:= MonoOfRightSummand( sum );
    piM := EpiOnLeftFactor( sum );
    piN := EpiOnRightFactor( sum );
    
    # create the graded sum with the help of its natural generalized embedding
    natural := NaturalGeneralizedEmbedding( sum );
    natural := GradedMap( natural, "create", degMN, S );
    
    Assert( 4, IsGeneralizedMorphism( natural ) );
    SetIsGeneralizedMorphism( natural, true );
    
    sum := Source( natural );
    sum!.NaturalGeneralizedEmbedding := natural;
    
    # grade the natural transformations
    iotaM := GradedMap( iotaM, M, sum, S );
    iotaN := GradedMap( iotaN, N, sum, S );
    piM := GradedMap( piM, sum, M, S );
    piN := GradedMap( piN, sum, N, S );
    
    Assert( 4, IsMorphism( iotaM ) );
    SetIsMorphism( iotaM, true );
    Assert( 4, IsMorphism( iotaN ) );
    SetIsMorphism( iotaN, true );
    Assert( 4, IsMorphism( piM ) );
    SetIsMorphism( piM, true );
    Assert( 4, IsMorphism( piN ) );
    SetIsMorphism( piN, true );
    
    if HasIsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) and IsInt( IsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) ) and 
       HasIsModuleOfGlobalSectionsTruncatedAtCertainDegree( N ) and IsInt( IsModuleOfGlobalSectionsTruncatedAtCertainDegree( N ) ) and
       IsModuleOfGlobalSectionsTruncatedAtCertainDegree( N ) = IsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) then
        SetIsModuleOfGlobalSectionsTruncatedAtCertainDegree( sum, IsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) );
    fi;
    
    return SetPropertiesOfDirectSum( [ M, N ], sum, iotaM, iotaN, piM, piN );
    
end );

InstallValue( Functor_DirectSum_for_graded_modules,
        CreateHomalgFunctor(
                [ "name", "DirectSum" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "DirectSumOp" ],
                [ "natural_transformation1", "EpiOnLeftFactor" ],
                [ "natural_transformation2", "EpiOnRightFactor" ],
                [ "natural_transformation3", "MonoOfLeftSummand" ],
                [ "natural_transformation4", "MonoOfRightSummand" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "2", [ [ "covariant" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_DirectSum_OnGradedModules ],
                [ "OnMorphismsHull", _Functor_DirectSum_OnMaps ]
                )
        );

Functor_DirectSum_for_graded_modules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_DirectSum_for_graded_modules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

InstallFunctor( Functor_DirectSum_for_graded_modules );

##
## LinearPart
##
## (cf. Eisenbud, Floystad, Schreyer: Sheaf Cohomology and Free Resolutions over Exterior Algebras)

InstallGlobalFunction( _Functor_LinearPart_OnGradedModules,    ### defines: LinearPart (object part)
  function( M )
    return M;
end );

##
InstallGlobalFunction( _Functor_LinearPart_OnGradedMaps, ### defines: LinearPart (morphism part)
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    local deg_s, deg_t, S, zero, mat, deg, i, j, result;
    
    if HasIsZero( phi ) and IsZero( phi ) then
        return phi;
    fi;
    
    deg_s := Set( DegreesOfGenerators( F_source ) );
    deg_t := Set( DegreesOfGenerators( F_source ) );
    if Length( deg_s ) = 1 and Length( deg_t ) = 1 and deg_s[1] = deg_t[1] - 1 then
        return phi;
    fi;
    
    S := HomalgRing( phi );
    
    zero := Zero( S );
    
    mat := ShallowCopy( MatrixOfMap( phi ) );
    
    SetIsMutableMatrix( mat, true );
    
    deg := DegreesOfEntries( mat );
    
    if not ( deg <> [] and IsHomogeneousList( deg ) and IsHomogeneousList( deg[1] ) and IsInt( deg[1][1] ) ) then
      Error( "Multigraduations are not yet supported" );
    fi;
    
    for i in [ 1 .. Length( deg ) ] do
      for j in [ 1 .. Length( deg[1] ) ] do
        if deg[i][j] <> -1 then
          SetMatElm( mat, i, j, zero );
        fi;
      od;
    od;
    
    MakeImmutable( mat );
    
    result := GradedMap( mat, F_source, F_target );
    
    if HasIsMorphism( phi ) and IsMorphism( phi ) then
        Assert( 4, IsMorphism( result ) );
        SetIsMorphism( result, true );
    fi;
    
    return result;
    
end );

InstallValue( Functor_LinearPart_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "LinearPart" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "LinearPart" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_LinearPart_OnGradedModules ],
                [ "OnMorphisms", _Functor_LinearPart_OnGradedMaps ]
                )
        );

Functor_LinearPart_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_LinearPart_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

InstallFunctor( Functor_LinearPart_ForGradedModules );

##
## ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree
##

InstallGlobalFunction( _Functor_ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree_OnGradedModules,
  function( d, M )
  local S, deg, l, mat, pi;
    
    S := HomalgRing( M );
    
    if NrRelations( M ) <> 0 then
        Error( "This functor only accepts graded free modules" );
    fi;
    
    deg := List( DegreesOfGenerators( M ), HomalgElementToInteger );
    l := Filtered( [ 1 .. Length( deg ) ], a -> deg[a] = d );
    
    if IsHomalgLeftObjectOrMorphismOfLeftObjects( M ) then
        mat := CertainRows( HomalgIdentityMatrix( NrGenerators( M ), S ), l );
    else
        mat := CertainColumns( HomalgIdentityMatrix( NrGenerators( M ), S ), l );
    fi;
    
    pi := GradedMap( mat, ListWithIdenticalEntries( Length( l ), d ), M );
    
    Assert( 4, IsMorphism( pi ) );
    SetIsMorphism( pi, true );
    
    if l = [ 1 .. Length( deg ) ] then
        Assert( 3, IsEpimorphism( pi ) );
        SetIsEpimorphism( pi, true );
    fi;
    Assert( 3, IsMonomorphism( pi ) );
    SetIsMonomorphism( pi, true );
    
    return pi;
    
end );

InstallValue( Functor_ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsInt ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree_OnGradedModules ]
                )
        );

Functor_ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;
  
InstallFunctor( Functor_ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree_ForGradedModules );

InstallMethod( ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedModule ],
               
  function( d, M )
    
    return ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree( HomalgElementToInteger( d ), M );
    
end );

## DirectSummandOfGradedFreeModuleGeneratedByACertainDegree

InstallMethod( DirectSummandOfGradedFreeModuleGeneratedByACertainDegree,
        "for linear complexes over the exterior algebra",
        [ IsInt, IsGradedModuleRep ],
  function( m, M )
    local pi, N;
    
    pi := ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree( m, M );
    
    N := Source( pi );
    
    return N;
    
end );

InstallMethod( DirectSummandOfGradedFreeModuleGeneratedByACertainDegree,
        "for linear complexes over the exterior algebra",
        [ IsInt, IsInt, IsMapOfGradedModulesRep ],
  function( m, n, phi )
    local pi1, pi2, pi2_minus_1;
    
    pi1 := ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree( m, Source( phi ) );
    pi2 := ProjectionToDirectSummandOfGradedFreeModuleGeneratedByACertainDegree( n, Range( phi ) );
    
    # PostInverse of a SubidentityMatrix is a GAP-computation
    pi2_minus_1 := PostInverse( pi2 );
    
    return PreCompose( PreCompose( pi1, phi ), pi2_minus_1 );
    
end );

InstallMethod( DirectSummandOfGradedFreeModuleGeneratedByACertainDegree,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedModule ],
               
  function( d, M )
    
    return DirectSummandOfGradedFreeModuleGeneratedByACertainDegree( HomalgElementToInteger( d ), M );
    
end );

InstallMethod( DirectSummandOfGradedFreeModuleGeneratedByACertainDegree,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgElement, IsHomalgGradedMap ],
               
  function( d1, d2, M )
    
    return DirectSummandOfGradedFreeModuleGeneratedByACertainDegree( HomalgElementToInteger( d1 ), HomalgElementToInteger( d2 ), M );
    
end );

##
## GeneralizedLinearStrand
##

InstallGlobalFunction( _Functor_GeneralizedLinearStrand_OnFreeCocomplexes,
  function( f, T )
  local i, alpha, alpha2, T2;
    
    for i in MorphismDegreesOfComplex( T ) do
        
        alpha := CertainMorphism( T, i );
        
        alpha2 := DirectSummandOfGradedFreeModuleGeneratedByACertainDegree( f( i ), f( i + 1 ), alpha );
        
        if not IsBound( T2 ) then
            T2 := HomalgCocomplex( alpha2, i );
        else
            Add( T2, alpha2 );
        fi;
        
    od;
    
    Assert( 3, IsComplex( T2 ) );
    SetIsComplex( T2, true );
    
    return T2;
    
end );

InstallGlobalFunction( _Functor_GeneralizedLinearStrand_OnCochainMaps,
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    local f, i, alpha, f_i, alpha2, psi;
    
    f := arg_before_pos[1];
    
    for i in DegreesOfChainMorphism( phi ) do
        
        alpha := CertainMorphism( phi, i );
        
        f_i := f( i );
        
        alpha2 := DirectSummandOfGradedFreeModuleGeneratedByACertainDegree( f_i, f_i, alpha );
        
        if not IsBound( psi ) then
            psi := HomalgChainMorphism( alpha2, F_source, F_target, i );
        else
            Add( psi, alpha2 );
        fi;
        
    od;
    
    return psi;
    
end );
  

InstallValue( Functor_GeneralizedLinearStrand_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "GeneralizedLinearStrand" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "GeneralizedLinearStrand" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsFunction ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], [ IsHomalgComplex, IsHomalgChainMorphism ] ] ],
                [ "OnObjects", _Functor_GeneralizedLinearStrand_OnFreeCocomplexes ],
                [ "OnMorphisms", _Functor_GeneralizedLinearStrand_OnCochainMaps ]
                )
        );

Functor_GeneralizedLinearStrand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_GeneralizedLinearStrand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

InstallFunctorOnObjects( Functor_GeneralizedLinearStrand_ForGradedModules );
InstallFunctorOnMorphisms( Functor_GeneralizedLinearStrand_ForGradedModules );

##
## LinearStrand
##

# returns the subcomplex of a free complex,
# where cohomological degree + shift = internal degree

InstallGlobalFunction( _Functor_LinearStrand_OnFreeCocomplexes,
  function( shift, T )
    
    return GeneralizedLinearStrand( function( i ) return i + shift; end, T );
    
end );

InstallGlobalFunction( _Functor_LinearStrand_OnCochainMaps,
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    
    return _Functor_GeneralizedLinearStrand_OnCochainMaps( F_source, F_target, [ function( i ) return i + arg_before_pos[1]; end ], phi, arg_behind_pos );
    
end );
  

InstallValue( Functor_LinearStrand_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "LinearStrand" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "LinearStrand" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsInt ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], [ IsHomalgComplex, IsHomalgChainMorphism ] ] ],
                [ "OnObjects", _Functor_LinearStrand_OnFreeCocomplexes ],
                [ "OnMorphisms", _Functor_LinearStrand_OnCochainMaps ]
                )
        );

Functor_LinearStrand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_LinearStrand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

# InstallFunctor( Functor_LinearStrand_ForGradedModules );
InstallFunctorOnObjects( Functor_LinearStrand_ForGradedModules );
InstallFunctorOnMorphisms( Functor_LinearStrand_ForGradedModules );

InstallMethod( LinearStrand,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgMorphism ],
               
  function( d, M )
    
    return LinearStrand( HomalgElementToInteger( d ), M );
    
end );

##
## ConstantStrand
##

InstallGlobalFunction( _Functor_ConstantStrand_OnFreeCocomplexes,
  function( d, T )
    
    return GeneralizedLinearStrand( function( i ) return d; end, T );
    
end );

InstallGlobalFunction( _Functor_ConstantStrand_OnCochainMaps,
  function( F_source, F_target, arg_before_pos, phi, arg_behind_pos )
    
    return _Functor_GeneralizedLinearStrand_OnCochainMaps( F_source, F_target, [ function( i ) return arg_before_pos[1]; end ], phi, arg_behind_pos );
    
end );
  

InstallValue( Functor_ConstantStrand_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "ConstantStrand" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "ConstantStrand" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsInt ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], [ IsHomalgComplex, IsHomalgChainMorphism ] ] ],
                [ "OnObjects", _Functor_ConstantStrand_OnFreeCocomplexes ],
                [ "OnMorphisms", _Functor_ConstantStrand_OnCochainMaps ]
                )
        );

Functor_ConstantStrand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_ConstantStrand_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

# InstallFunctor( Functor_ConstantStrand_ForGradedModules );
InstallFunctorOnObjects( Functor_ConstantStrand_ForGradedModules );
InstallFunctorOnMorphisms( Functor_ConstantStrand_ForGradedModules );

InstallMethod( ConstantStrand,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgMorphism ],
               
  function( d, M )
    
    return ConstantStrand( HomalgElementToInteger( d ), M );
    
end );

##
## LinearFreeComplexOverExteriorAlgebraToModule
##

# This functor creates a module from a linear complex over the exterior algebra
# (and a module map from a degree 0 cochain map).
# first we introduce two helper functions

##
# Takes a linear map phi over a graded ring with indeterminates x_i
# write phi = sum_i x_i*phi_i
# returns (for left objects) the matrix
# <phi_0,
#  phi_1
#
#  phi_n>
# and a map with matrix
# <x_0*I,
#  x_1*I
#
#  x_n*I>
# where I is the identity matrix of size Source( phi ), i.e. both matrices have the same number of rows
# later we will use these two maps to produce a pushout.
InstallMethod( SplitLinearMapAccordingToIndeterminates,
        "for linear complexes over the exterior algebra",
        [ IsMapOfGradedModulesRep ],
  function( phi )
      local E, n, S, K, l_var, left, map_E, map_S, t, F, var_s_morphism, k, alpha, alpha2, matrix_of_extension, c, extension_matrix,l_test;
      
      E := HomalgRing( phi );
      
      n := Length( Indeterminates( E ) );
      
      S := KoszulDualRing( E );
      
      K := CoefficientsRing( E );
      
      Assert( 5, IsIdenticalObj( K, CoefficientsRing( S ) ) );
      
      l_var := Length( Indeterminates( S ) );
      
      left := IsHomalgLeftObjectOrMorphismOfLeftObjects( phi );
      
      if left then
          map_E := MaximalIdealAsLeftMorphism( E );
          map_S := MaximalIdealAsLeftMorphism( S );
      else
          map_E := MaximalIdealAsRightMorphism( E );
          map_S := MaximalIdealAsRightMorphism( S );
      fi;
      
      t := NrGenerators( Range( phi ) );
      if left then
          if DegreesOfGenerators( Range( phi ) ) <> [ ] then
              F := FreeLeftModuleWithDegrees( NrGenerators( Source( phi ) ), S, DegreesOfGenerators( Range( phi ) )[1] - 1 - n );
          else
              F := FreeLeftModuleWithDegrees( NrGenerators( Source( phi ) ), S, 0 );
          fi;
          var_s_morphism := - TensorProduct( map_S, F );
      else
          if DegreesOfGenerators( Range( phi ) ) <> [ ] then
              F := FreeRightModuleWithDegrees( NrGenerators( Source( phi ) ), S, DegreesOfGenerators( Range( phi ) )[1] - 1 - n );
          else
              F := FreeRightModuleWithDegrees( NrGenerators( Source( phi ) ), S, 0 );
          fi;
          var_s_morphism := - TensorProduct( map_S, F );
      fi;
      
      alpha := TensorProduct( map_E, Range( phi ) );
      alpha2 := GradedMap( HomalgIdentityMatrix( NrGenerators( Range( phi ) ), HomalgRing( phi ) ), Range( alpha ), Range( phi ) );
      alpha := PreCompose( alpha, alpha2 );
      matrix_of_extension := phi / alpha;
      matrix_of_extension := K * MatrixOfMap( matrix_of_extension );
      if left then
          extension_matrix := HomalgZeroMatrix( 0, NrGenerators( Range( phi ) ), K );
          for k in [ 1 .. l_var ] do
              c := CertainColumns( matrix_of_extension, [ (k-1) * t + 1 .. k * t ] );
              extension_matrix := UnionOfRows( extension_matrix, c );
          od;
      else
          extension_matrix := HomalgZeroMatrix( NrGenerators( Range( phi ) ), 0, K );
          for k in [ 1 .. l_var ] do
              c := CertainRows( matrix_of_extension, [ (k-1) * t + 1 .. k * t ] );
              extension_matrix := UnionOfColumns( extension_matrix, c );
          od;
      fi;
      
      return [ extension_matrix, var_s_morphism ];
    
end );

##
# Takes a linear map phi over a graded ring with indeterminates x_i
# write phi = sum_i x_i*phi_i
# creates (for left objects) the maps var_s_morphism and extension_map with matrices
# <x_0*I,
#  x_1*I
#
#  x_n*I>
# and
# <phi_0,
#  phi_1
#
#  phi_n>
# where I is the identity matrix of size Source( phi ),
# i.e. both matrices have the same number of rows and (accordingly) both maps the same source.
# The target of var_s_morphism is newly created 
# and of extension_map is taken to be the source of the second argument psi.
# Then a base change is performed on source and target of extension_map, to have this
# map (with a matrix with entries over the ground field) in a simple shape for later use.
# In this process, a complement alpha of the image of extension_map is created (also for later use)
# we return [ var_s_morphism, extension_map, alpha ]
InstallMethod( ExtensionMapsFromExteriorComplex,
        "for linear complexes over the exterior algebra",
        [ IsMapOfGradedModulesRep, IsMapOfGradedModulesRep ],

  function( phi, psi )
      local N, E, S, K, extension_matrix, var_s_morphism, M, extension_map, alpha,l_test;
      
      N := Source( psi );
      
      E := HomalgRing( phi );
      
      S := KoszulDualRing( E );
      
      extension_matrix := SplitLinearMapAccordingToIndeterminates( phi );
      var_s_morphism := extension_matrix[2];
      M := Source( var_s_morphism );
      extension_matrix := extension_matrix[1];
      
      # compute over the free module instead of N, because it is faster
      extension_map := GradedMap( S * extension_matrix, M, N, S );
      
      if HasIsMorphism( phi ) and IsMorphism( phi ) then
          Assert( 4, IsMorphism( extension_map ) );
          SetIsMorphism( extension_map, true );
      fi;
      
      # This command changes the presentation of Source and Range of extension_map.
      # In particular, N is changes, which was used before
      # the change is due to the wish of a much faster ByASmallerPresentation
      NormalizeGradedMorphism( extension_map );
      
      alpha := extension_map!.complement_of_image;
      
      return [ var_s_morphism, extension_map, alpha ];
    
end );

##
# This method creates a module from a single linear map over the exterior algebra.
# The idea behind this is, that the submodule of cohomology module generated by a certain degree
# above the regularity can be constructed from this single map phi.
# Let e_i be the generators of the exterior algebra and x_i the generators of the symmetric algebra.
# Write phi=sum e_i*phi_i, then the phi_i are matrices over the ground field.
# (Left modules) Let extension_map be the map with stacked matrix
# <phi_0,
#  phi_1
#
#  phi_n>
# and var_s_morphism the map with stacked matrix
# <x_0*I,
#  x_1*I
#
#  x_n*I>
# where I is the identity matrix of size Source( phi ).
# (both maps have the same source)
# Then cokernel( kernel( extension_map ) * var_s_morphism ) the the wanted module.
InstallMethod( ModuleFromExtensionMap,
        "for linear complexes over the exterior algebra",
        [ IsMapOfGradedModulesRep ],

  function( phi )
      local  E, S, K, extension_matrix, var_s_morphism, M, ar, N, extension_map, result;
      
      E := HomalgRing( phi );
      
      S := KoszulDualRing( E );
      
      if IsZero( phi ) then
          if IsHomalgLeftObjectOrMorphismOfLeftObjects( phi ) then
              return 0*S;
          else
              return S*0;
          fi;
      fi;
      
      extension_matrix := SplitLinearMapAccordingToIndeterminates( phi );
      var_s_morphism := extension_matrix[2];
      M := Source( var_s_morphism );
      extension_matrix := extension_matrix[1];
      
      ar := [ NrGenerators( Range( phi ) ), S, DegreesOfGenerators( M )[1] ];
      if IsHomalgLeftObjectOrMorphismOfLeftObjects( M ) then
          N := CallFuncList( FreeLeftModuleWithDegrees, ar );
      else
          N := CallFuncList( FreeRightModuleWithDegrees, ar );
      fi;
      extension_map := GradedMap( S * extension_matrix, M, N, S );
      
      if HasIsMorphism( phi ) and IsMorphism( phi ) then
          Assert( 4, IsMorphism( extension_map ) );
          SetIsMorphism( extension_map, true );
      fi;
      
      result := Cokernel( PreCompose( KernelEmb( extension_map ), var_s_morphism ) );
      
      return result;
      
end );

InstallMethod( CompareArgumentsForLinearFreeComplexOverExteriorAlgebraToModuleOnObjects,
        "for argument lists of the functor LinearFreeComplexOverExteriorAlgebraToModule on objects",
        [ IsList, IsList ],

  function( l_old, l_new )
      local lower_bound1, lower_bound2;
      
      lower_bound1 := Minimum( ObjectDegreesOfComplex( l_old[2] ) );
      lower_bound2 := Minimum( ObjectDegreesOfComplex( l_new[2] ) );
      
      return lower_bound1 = lower_bound2
          and l_old[1] <= l_new[1]
          and IsIdenticalObj(
              CertainMorphism( l_old[2], lower_bound1 ),
              CertainMorphism( l_new[2], lower_bound1 )
              );
      
end );

InstallGlobalFunction( _Functor_LinearFreeComplexOverExteriorAlgebraToModule_OnGradedModules,
  function( reg_sheaf, lin_tate )
      local i, deg, A, n, S, k, result, EmbeddingsOfHigherDegrees, RecursiveEmbeddingsOfHigherDegrees, lower_bound, jj, j, tate_morphism, psi,
      extension_map, var_s_morphism, T, T2, l, T2b, V1, V2, V1_iso_V2, isos, source_emb, map, certain_deg, t1, t2, phi, chain_phi, pos, Rresult, iso;
      
      if not reg_sheaf < HomalgElementToInteger( HighestDegree( lin_tate ) ) then
          Error( "the given regularity is larger than the number of morphisms in the complex" );
      fi;
      if not IsCocomplexOfFinitelyPresentedObjectsRep( lin_tate ) then
          Error( "expected a _co_complex over the exterior algebra" );
      fi;
      for i in ObjectDegreesOfComplex( lin_tate ) do
          deg := List( DegreesOfGenerators( CertainObject( lin_tate, i ) ), HomalgElementToInteger );
          if not Length( Set( deg ) ) <= 1 then
              Error( "for every cohomological degree in the cocomplex expected the degrees of generators of the object to be equal to each other" );
          fi;
#           if not ( deg = [] or deg[1] = i ) then
#               Error( "expected the degrees of generators in the cocomplex to be equal to the cohomological degree" );
#           fi;
      od;
      
      A := HomalgRing( lin_tate );
      
      n:= Length( Indeterminates( A ) );
      
      S := KoszulDualRing( A );
      
      k := CoefficientsRing( A );
      
      result := ModuleFromExtensionMap( CertainMorphism( lin_tate, reg_sheaf ) );
      
#   each new step constructs a new StdM as pushout of 
#   extension_map*LeftPushoutMorphism  and  var_s_morphism.
#   These maps are created from a modified Tate resolution.
#
#     StdM = new (+) old                                   Range( var_s_morphism )
#             /\                                                  /\
#             |                                                   |
#             |                                                   |
#             | LeftPushoutMorphism                               | var_s_morphism
#             |                                                   |
#             |           extension_map                           |
#           new  <-------------------------------- Source( var_s_morphism ) = Source( extension_map )
      
      result := Pushout( TheZeroMorphism( Zero( result ), result ), TheZeroMorphism( Zero( result ), Zero( result ) ) );
      
      EmbeddingsOfHigherDegrees := rec( (String( reg_sheaf )) := TheIdentityMorphism( result ) );
      RecursiveEmbeddingsOfHigherDegrees := rec( );
      
      lower_bound := Minimum( ObjectDegreesOfComplex( lin_tate ) );
      
      for jj in [ lower_bound + 1 .. reg_sheaf ] do
          j := reg_sheaf + lower_bound - jj;
          
          # create the extension map from the tate-resolution
          # e.g. ( e_0, e_1, 3*e_0+2*e_1 ) leads to  /   1,   0,   3   \
          #                                          \   0,   1,   2   /
          # but the gaussian algorithm is applied to the latter matrix (both to rows an columns) for easier simplification
          tate_morphism := CertainMorphism( lin_tate, j );
          
          psi := LeftPushoutMorphism( result );
          
          extension_map := ExtensionMapsFromExteriorComplex( tate_morphism, psi );
          var_s_morphism := extension_map[1];
          T := extension_map[3];
          extension_map := extension_map[2];
          
          # this line computes the global sections module
          result := Pushout( var_s_morphism, PreCompose( extension_map, psi ) );
          
          # This direct sum will be used in different contextes of the summands.
          # We need to ensure that we speak about the same object in each of these cases.
          # Thus, we force homalg to return this object regardless of the context of the summands.
          Range( NaturalGeneralizedEmbedding( result ) )!.IgnoreContextOfArgumentsOfFunctor := true;
          UnderlyingModule( Range( NaturalGeneralizedEmbedding( result ) ) )!.IgnoreContextOfArgumentsOfFunctor := true;
          
          # the "old" ModuleOfGlobalSections (the one generated in larger degree) embeds into the new one
          Assert( 3, IsMonomorphism( RightPushoutMorphism( result ) ) );
          SetIsMonomorphism( RightPushoutMorphism( result ), true );
          
          # the following block simplifies the ModuleOfGlobalSections much faster than ByASmallerPresentation could.
          # We know in advance, which generators we need to generate result. These are 
          # 1) the new generators, i.e. Image( var_s_morphism ),
          # 2) a basis of Cokernel( extension_map ) (which is free), i.e. Image( T ),
          # 3) and the older generators, which have not been made superfluous, i.e. CertainGenerators( result, k ).
          # We build the CoproductMorphism T2 of these three morphisms and its image is a smaller presentation of result
          T := PreCompose( PreCompose( T, psi ), RightPushoutMorphism( result ) );
          T2 := CoproductMorphism( LeftPushoutMorphism( result ), T );
          l := PositionProperty( DegreesOfGenerators( result ), function( a ) return a > j+1; end );
          if l <> fail then
              l := [ l .. NrGenerators( result ) ];
              T2b := GradedMap( CertainGenerators( result, l ), "free", result );
              Assert( 4, IsMorphism( T2b ) );
              SetIsMorphism( T2b, true );
              T2 := CoproductMorphism( T2, T2b );
          fi;
          Assert( 3, IsEpimorphism( T2 ) );
          SetIsEpimorphism( T2, true );
          PushPresentationByIsomorphism( NaturalGeneralizedEmbedding( ImageObject( T2 ) ) );
          
          # try to keep the information about higher modules
          EmbeddingsOfHigherDegrees!.(String(j)) := TheIdentityMorphism( result );
          for l in [ j + 1 .. reg_sheaf ] do
              EmbeddingsOfHigherDegrees!.(String(l)) := PreCompose( EmbeddingsOfHigherDegrees!.(String(l)), RightPushoutMorphism( result ) );
          od;
          RecursiveEmbeddingsOfHigherDegrees!.(String(j+1)) := RightPushoutMorphism( result );
          
      od;
      
      # end core procedure
      
      # Now set some properties of the module collected during the computation.
      # Most of these are needed in the morphism part of this functor.
      
      for l in [ lower_bound .. reg_sheaf ] do
          if fail = GetFunctorObjCachedValue( Functor_TruncatedSubmodule_ForGradedModules, [ l, result ] ) then
              SetFunctorObjCachedValue( Functor_TruncatedSubmodule_ForGradedModules, [ l, result ], FullSubobject( Source( EmbeddingsOfHigherDegrees!.(String(l)) ) ) );
              SetNaturalTransformation( Functor_TruncatedSubmodule_ForGradedModules, [ l, result ], "TruncatedSubmoduleEmbed", EmbeddingsOfHigherDegrees!.(String(l)) );
          fi;
      od;
      for l in [ lower_bound .. reg_sheaf - 1 ] do
          if fail = GetFunctorObjCachedValue( Functor_TruncatedSubmoduleRecursiveEmbed_ForGradedModules, [ l, result ] ) then
              SetFunctorObjCachedValue( Functor_TruncatedSubmoduleRecursiveEmbed_ForGradedModules, [ l, result ], RecursiveEmbeddingsOfHigherDegrees!.(String(l+1)) );
          fi;
      od;
      
      isos := rec( );
      
      for l in [ lower_bound .. reg_sheaf ] do
          
          V1 := HomogeneousPartOverCoefficientsRing( l, CertainObject( lin_tate, l ) );
          
          # modules of global sections truncated at different degrees do not share their V2 on purpose.
          V1_iso_V2 := GradedMap( HomalgIdentityMatrix( NrGenerators( V1 ), k ), "free", V1 );
          Assert( 4, IsMorphism( V1_iso_V2 ) );
          SetIsMorphism( V1_iso_V2, true );
          Assert( 4, IsIsomorphism( V1_iso_V2 ) );
          SetIsIsomorphism( V1_iso_V2, true );
          UpdateObjectsByMorphism( V1_iso_V2 );
          
          isos.(l) := V1_iso_V2;
          
          V2 := Source( V1_iso_V2 );
          
          SetMapFromHomogenousPartOverSymmetricAlgebraToHomogeneousPartOverExteriorAlgebra( V2, V1_iso_V2 );
          SetMapFromHomogenousPartOverExteriorAlgebraToHomogeneousPartOverSymmetricAlgebra( V1, V1_iso_V2 );
          
          source_emb := Source( EmbeddingsOfHigherDegrees!.(String(l)) );
          
          deg := List( DegreesOfGenerators( source_emb ), HomalgElementToInteger );
          certain_deg := Filtered( [ 1 .. Length( deg ) ], a -> deg[a] = l );
          if IsHomalgLeftObjectOrMorphismOfLeftObjects( result ) then
              map := GradedMap( CertainRows( HomalgIdentityMatrix( NrGenerators( source_emb ), S ), certain_deg ), S * V2, source_emb );
          else
              map := GradedMap( CertainColumns( HomalgIdentityMatrix( NrGenerators( source_emb ), S ), certain_deg ), S * V2, source_emb );
          fi;
          Assert( 4, IsMorphism( map ) );
          SetIsMorphism( map, true );
          
          map := PreCompose( map, EmbeddingsOfHigherDegrees!.(String(l)) );
          
          if fail = GetFunctorObjCachedValue( Functor_HomogeneousPartOverCoefficientsRing_ForGradedModules, [ l, result ] ) then
              SetFunctorObjCachedValue( Functor_HomogeneousPartOverCoefficientsRing_ForGradedModules, [ l, result ], V2 );
          fi;
          
          SetNaturalTransformation(
              Functor_HomogeneousPartOverCoefficientsRing_ForGradedModules,
              [ l, result ],
              "EmbeddingOfSubmoduleGeneratedByHomogeneousPart",
              map
          );
          
          if l = lower_bound then
              SetEmbeddingOfSubmoduleGeneratedByHomogeneousPart( V2, map );
          fi;
          
      od;
      
      # set the koszul-right-adjoint matrices!
      pos := PositionOfTheDefaultPresentation( result );
      if not IsBound( result!.RepresentationMatricesOfKoszulId ) then
          result!.RepresentationMatricesOfKoszulId := rec( );
      fi;
      if not IsBound( result!.RepresentationMatricesOfKoszulId!.(pos) ) then
          result!.RepresentationMatricesOfKoszulId!.(pos) := rec( );
      fi; 
      for l in MorphismDegreesOfComplex( lin_tate ) do
          result!.RepresentationMatricesOfKoszulId!.(pos)!.(l) := MatrixOfMap( CertainMorphism( lin_tate, l ) );
      od;
      
      # this is now rather cheap, mostly the objects have to be created
      Rresult := KoszulRightAdjoint( result, lower_bound, reg_sheaf );
      
      for l in [ lower_bound .. reg_sheaf ] do
          
          t1 := CertainObject( lin_tate, l );
          t2 := CertainObject( Rresult, l ); # = omega_A * V2;
          
          V1_iso_V2 := isos.(l);
          V1 := Source( V1_iso_V2 );
          
          iso := A^(-n) * ( A * V1_iso_V2^(-1) );
          
          phi := GradedMap( HomalgIdentityMatrix( NrGenerators( t1 ), A ), t1, Source( iso ) );
          Assert( 4, IsMorphism( phi ) );
          SetIsMorphism( phi, true );
          Assert( 4, IsIsomorphism( phi ) );
          SetIsIsomorphism( phi, true );
          UpdateObjectsByMorphism( phi );
          phi := PreCompose( phi, iso );
          phi := (-1)^l * phi;
          
          if not IsBound( chain_phi ) then
              chain_phi := HomalgChainMorphism( phi, lin_tate, Rresult, l );
          else
              Add( chain_phi, phi );
          fi;
          
      od;
      
      SetNaturalMapFromExteriorComplexToRightAdjoint( lin_tate, chain_phi );
      
      return result;
      
end );

InstallMethod( ConstructMorphismFromLayers,
        "for argument lists of the functor LinearFreeComplexOverExteriorAlgebraToModule on objects",
        [ IsGradedModuleRep, IsGradedModuleRep, IsHomalgChainMorphism ],

  function( F_source, F_target, psi )
    local reg, phi, lower_bound, jj, j, emb_new_source, emb_new_target, emb_old_source, emb_old_target, epi_source, epi_target, phi_new;
    
    reg := HomalgElementToInteger( HighestDegree( psi ) );
    
    phi := HighestDegreeMorphism( psi );
      
    lower_bound := HomalgElementToInteger( LowestDegree( psi ) );
    
    if reg = lower_bound then
        
        phi := CompleteKernelSquare(
            SubmoduleGeneratedByHomogeneousPart( lower_bound, F_source )!.map_having_subobject_as_its_image,
            phi,
            SubmoduleGeneratedByHomogeneousPart( lower_bound, F_target )!.map_having_subobject_as_its_image );
        
    fi;
    
    for jj in [ lower_bound + 1 .. reg ] do
        j := reg + lower_bound - jj;
        
        if j = reg - 1 then
            emb_old_source := SubmoduleGeneratedByHomogeneousPartEmbed( j + 1, F_source ) / TruncatedSubmoduleEmbed( j, F_source );
            emb_old_target := SubmoduleGeneratedByHomogeneousPartEmbed( j + 1, F_target ) / TruncatedSubmoduleEmbed( j, F_target );
        else
            emb_old_source := TruncatedSubmoduleRecursiveEmbed( j, F_source );
            emb_old_target := TruncatedSubmoduleRecursiveEmbed( j, F_target );
        fi;
        
        emb_new_source := SubmoduleGeneratedByHomogeneousPartEmbed( j, F_source ) / TruncatedSubmoduleEmbed( j, F_source );
        emb_new_target := SubmoduleGeneratedByHomogeneousPartEmbed( j, F_target ) / TruncatedSubmoduleEmbed( j, F_target );
        
        epi_source := CoproductMorphism( emb_new_source, -emb_old_source );
        epi_target := CoproductMorphism( emb_new_target, -emb_old_target );
        
        Assert( 3, IsEpimorphism( epi_source ) );
        SetIsEpimorphism( epi_source, true );
        Assert( 3, IsEpimorphism( epi_target ) );
        SetIsEpimorphism( epi_target, true );
        
        phi_new := CertainMorphism( psi, j );
        
        # We should have
        # IsZero( PreCompose( PreCompose( KernelEmb( emb_new_source ), phi_new ), emb_new_target ) )
        # to call CompleteKernelSquare. But since emb_new_source maps from a free module and not from
        # SubmoduleGeneratedByHomogeneousPart( j, F_source ) the kernel is too big.
        # We could compute the relations in Source( emb_new_source ). This would imply a costly syzygy
        # computation, which i would like to circumwent. So CompleteKernelSquare does not yield a
        # well defined result, but the final result is well defined
        Assert( 5, IsZero( PreCompose( PreCompose( KernelEmb( emb_new_source ), phi_new ), emb_new_target ) ) );
        phi := DiagonalMorphism( phi_new, phi );
        Assert( 5, IsZero( PreCompose( PreCompose( KernelEmb( epi_source ), phi), epi_target ) ) );
        phi := CompleteKernelSquare( epi_source, phi, epi_target );
        
    od;
    
    return phi;

end );

InstallMethod( HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing,
        "for homalg cocomplexes over graded rings",
        [ IsHomalgComplex, IsInt, IsInt ],

  function( C, min, max )
    local HC, j;
    
    HC := HomalgCocomplex( HomogeneousPartOverCoefficientsRing( min, CertainObject( C, min ) ), min );
    for j in [ min + 1 .. max ] do
        Add( HC, HomogeneousPartOverCoefficientsRing( j, CertainObject( C, j ) ) );
    od;
    
    return HC;
    
end );

InstallMethod( HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing,
        "for homalg cocomplexes over graded rings",
        [ IsHomalgChainMorphism, IsInt, IsInt ],

  function( C, min, max )
    local HC, j, A, B;
      
      A := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( Source( C ), min, max );
      B := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( Range( C ), min, max );
      
      HC := HomalgChainMorphism( HomogeneousPartOverCoefficientsRing( min, CertainMorphism( C, min ) ), A, B, min );
      for j in [ min + 1 .. max ] do
          Add( HC, HomogeneousPartOverCoefficientsRing( j, CertainMorphism( C, j ) ) );
      od;
      
      return HC;
      
end );

InstallMethod( CompleteKernelSquareByDualization,
        "for homalg cocomplexes over graded rings",
        [ IsMapOfGradedModulesRep, IsMapOfGradedModulesRep, IsMapOfGradedModulesRep ],

  function( alpha2, phi, beta2 )
    local A, alpha, id1, id2;
      
      A := HomalgRing( phi );
      
      if not ( HasIsFree( UnderlyingModule( Range( alpha2 ) ) ) and IsFree( UnderlyingModule( Range( alpha2 ) ) ) ) or
         not ( HasIsFree( UnderlyingModule( Range( beta2 ) ) ) and IsFree( UnderlyingModule( Range( beta2 ) ) ) ) or
         not ( HasIsFree( UnderlyingModule( Source( phi ) ) ) and IsFree( UnderlyingModule( Range( phi ) ) ) ) or
         not ( HasIsFree( UnderlyingModule( Range( phi ) ) ) and IsFree( UnderlyingModule( Range( phi ) ) ) ) then
          Error( "expect all graded modules to be graded free" );
      fi;
      
      alpha := CompleteImageSquare(
          GradedHom( beta2, A ),
          GradedHom( phi, A ),
          GradedHom( alpha2, A )
          );
      alpha := GradedHom( alpha, A );
      Assert( 3, IsMorphism( alpha ) );
      SetIsMorphism( alpha, true );
      id1 := NatTrIdToHomHom_R( Range( alpha2 ) );
      Assert( 3, IsIsomorphism( id1 ) );
      SetIsIsomorphism( id1, true );
      UpdateObjectsByMorphism( id1 );
      id2 := NatTrIdToHomHom_R( Range( beta2 ) );
      Assert( 3, IsIsomorphism( id2 ) );
      SetIsIsomorphism( id2, true );
      UpdateObjectsByMorphism( id2 );
      
      return PreCompose( PreCompose( id1, alpha ), id2^(-1) );
      
end );

InstallMethod( SetNaturalMapFromExteriorComplexToRightAdjointForModulesOfGlobalSections,
        "for homalg cocomplexes over graded rings",
        [ IsHomalgComplex, IsGradedModuleRep ],

  function( lin_tate, M )
    local truncation_bound, reg, RM, object, alpha, beta, jj, j;
    
    truncation_bound := LowestDegree( lin_tate );
    
    reg := Maximum( HighestDegree( lin_tate ), CastelnuovoMumfordRegularity( M ) );
    
    RM := KoszulRightAdjoint( M, truncation_bound, reg );
    
    object := CertainObject( lin_tate, reg );
    
    alpha := TheIdentityMorphism( object );
    
    beta := HomalgChainMorphism( alpha, lin_tate, RM, reg );
    
    for jj in [ truncation_bound + 1 .. reg ] do
        j := reg + truncation_bound - jj;
        
        alpha := CompleteImageSquare( CertainMorphism( lin_tate, j ), alpha, CertainMorphism( RM, j ) );
        
        Add( alpha, beta );
        
    od;
    
    SetNaturalMapFromExteriorComplexToRightAdjoint( lin_tate, beta );
    
end );

# Constructs a morphism between two modules F_source and F_target from the cochain map lin_tate
# We begin by constructing the map from F_source_{>=reg}=SubmoduleGeneratedByHomogeneousPart(reg,F_source)
# to F_target_{>=reg}=SubmoduleGeneratedByHomogeneousPart(reg,F_target).
# This map can be directly read of from the morphism in lin_tate at degree reg.
# Now we inductively construct maps from the submodules generated by a certain degree of F_source and F_target.
# Since F_{>=j} = F_{>=j+1} \oplus <F_j> we have the map starting from the direct sum and finally
# also from the factor of this direct sum.
InstallGlobalFunction( _Functor_LinearFreeComplexOverExteriorAlgebraToModule_OnGradedMaps,
  function( F_source, F_target, arg_before_pos, lin_tate, arg_behind_pos )
    local reg_sheaf, lower_bound, A, S, j, object, jj, RF_source, RF_target,
          lin_tate_source, lin_tate_target, nat_source, nat_target, alpha,
          id1, id2, Hnat_source, Hnat_target, phi, H_source, H_target, phi_source, phi_target, psi;
      
      reg_sheaf := arg_before_pos[1];
      
      lower_bound := LowestDegree( lin_tate );
      
      A := HomalgRing( lin_tate );
      S := HomalgRing( F_source );
      
      RF_source := KoszulRightAdjoint( F_source, lower_bound, reg_sheaf );
      RF_target := KoszulRightAdjoint( F_target, lower_bound, reg_sheaf );
      
      lin_tate_source := Source( lin_tate );
      lin_tate_target := Range( lin_tate );
      
      if not HasNaturalMapFromExteriorComplexToRightAdjoint( lin_tate_source ) then
          SetNaturalMapFromExteriorComplexToRightAdjointForModulesOfGlobalSections( lin_tate_source, F_source );
      fi;
      if not HasNaturalMapFromExteriorComplexToRightAdjoint( lin_tate_target ) then
          SetNaturalMapFromExteriorComplexToRightAdjointForModulesOfGlobalSections( lin_tate_target, F_target );
      fi;

      nat_source := NaturalMapFromExteriorComplexToRightAdjoint( lin_tate_source );
      nat_target := NaturalMapFromExteriorComplexToRightAdjoint( lin_tate_target );
      
      Hnat_source := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( nat_source, lower_bound, reg_sheaf );
      Hnat_target := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( nat_target, lower_bound, reg_sheaf );
      
      for jj in [ lower_bound .. reg_sheaf ] do
          j := reg_sheaf + lower_bound - jj;
          
          phi := CertainMorphism( lin_tate, j );
          
          phi_source := MapFromHomogeneousPartofModuleToHomogeneousPartOfKoszulRightAdjoint( j, F_source );
          phi_source := PreCompose( phi_source, CertainMorphism( Hnat_source, j )^(-1) );
          
          phi_target := MapFromHomogeneousPartofModuleToHomogeneousPartOfKoszulRightAdjoint( j, F_target );
          phi_target := PreCompose( phi_target, CertainMorphism( Hnat_target, j )^(-1) );
          
          phi := HomogeneousPartOverCoefficientsRing( j, phi );
          
          H_source := HomogeneousPartOverCoefficientsRing( j, F_source );
          H_target := HomogeneousPartOverCoefficientsRing( j, F_target );
          
          phi := CompleteImageSquare( phi_source, phi, phi_target );
          
          phi := S * phi;
          
          if j = reg_sheaf then
          
              psi := HomalgChainMorphism( phi, HomalgCocomplex( Source( phi ), reg_sheaf ), HomalgCocomplex( Range( phi ), reg_sheaf ), reg_sheaf );
          
          else
          
              Add( Source( phi ), Source( psi ) );
              Add( Range( phi ), Range( psi ) );
              Add( phi, psi );
          
          fi;
          
      od;
      
      return ConstructMorphismFromLayers( F_source, F_target, psi );
      
end );

InstallValue( Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "LinearFreeComplexOverExteriorAlgebraToModule" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "LinearFreeComplexOverExteriorAlgebraToModule" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsInt ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], [ IsHomalgComplex, IsHomalgChainMorphism ] ] ],
                [ "OnObjects", _Functor_LinearFreeComplexOverExteriorAlgebraToModule_OnGradedModules ],
                [ "OnMorphisms", _Functor_LinearFreeComplexOverExteriorAlgebraToModule_OnGradedMaps ],
                [ "CompareArgumentsForFunctorObj", CompareArgumentsForLinearFreeComplexOverExteriorAlgebraToModuleOnObjects ],
                [ "MorphismConstructor", HOMALG_GRADED_MODULES.category.MorphismConstructor ]
                )
        );

Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

InstallFunctor( Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules );

##
## ModuleOfGlobalSectionsTruncatedAtCertainDegree
##
## (cf. Eisenbud, Floystad, Schreyer: Sheaf Cohomology and Free Resolutions over Exterior Algebras)

InstallGlobalFunction( _Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_OnGradedModules,
  function( truncation_bound, M )
    local V2, map, UM, SOUM, C, reg, tate, B, reg_sheaf, t1, t2, psi, RM, id_old, phi, lin_tate, fit, HM, ii, i, hom_part;
      
      if HasIsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) and HomalgElementToInteger( IsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) ) = truncation_bound then
          HM := M;
          if truncation_bound = 0 then
              V2 := HomogeneousPartOverCoefficientsRing( 0, HM );
              map := EmbeddingOfSubmoduleGeneratedByHomogeneousPart( 0, HM );
              SetEmbeddingOfSubmoduleGeneratedByHomogeneousPart( V2, map );
          fi;
          return HM;
      fi;

      if not IsBound( M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree ) then
          M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree := rec( );
      elif IsBound( M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) ) then
          HM := Range( M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) );
          return HM;
      fi;
      
      # 0 -> M -> SOUM -> C -> 0
      # SOUM is module of global sections
      # C does not have a non-trivial artinian submodule
      # then M is already a module of global sections
      # proof:
      #   0 -> M ----> SOUM --> C -> 0
      #        |         |      |
      #   iota |      Id |      | phi
      #       \/        \/     \/
      #   0-> HM ----> SOUM -> HC
      # Show, that iota is an isomorphism.
      # C does not have a non-trivial artinian submodule, so phi is mono.
      # The claim follows from the five-lemma.
      if HasUnderlyingSubobject( M ) then
          UM := UnderlyingSubobject( M );
          SOUM := SuperObject( UM );
          if IsBound( UM!.map_having_subobject_as_its_image ) and HasIsModuleOfGlobalSectionsTruncatedAtCertainDegree( SOUM ) and 
             IsInt( HomalgElementToInteger( IsModuleOfGlobalSectionsTruncatedAtCertainDegree( SOUM ) ) ) and HomalgElementToInteger( IsModuleOfGlobalSectionsTruncatedAtCertainDegree( SOUM ) ) = truncation_bound then
              C := Cokernel( UM!.map_having_subobject_as_its_image );
              if HasIsTorsionFree( C ) and IsTorsionFree( C ) or TrivialArtinianSubmodule( C ) then
                  SetIsModuleOfGlobalSectionsTruncatedAtCertainDegree( M, HomalgElementToInteger( IsModuleOfGlobalSectionsTruncatedAtCertainDegree( SOUM ) ) );
                  HM := M;
                  if truncation_bound = 0 then
                      V2 := HomogeneousPartOverCoefficientsRing( 0, HM );
                      map := EmbeddingOfSubmoduleGeneratedByHomogeneousPart( 0, HM );
                      SetEmbeddingOfSubmoduleGeneratedByHomogeneousPart( V2, map );
                  fi;
                  M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) := TheIdentityMorphism( M );
                  return HM;
              fi;
          fi;
      fi;
      
      # For free modules or modules with a regularity low enough we get the result
      # by just truncating the module
      if HasIsFree( UnderlyingModule( M ) ) and IsFree( UnderlyingModule( M ) ) or
         HomalgElementToInteger( CastelnuovoMumfordRegularity( M ) ) <= truncation_bound then
          
          psi := TruncatedSubmoduleEmbed( truncation_bound, M );
          
          HM := Source( psi );
          
          if truncation_bound = 0 then
              V2 := HomogeneousPartOverCoefficientsRing( 0, HM );
              map := EmbeddingOfSubmoduleGeneratedByHomogeneousPart( 0, HM );
              SetEmbeddingOfSubmoduleGeneratedByHomogeneousPart( V2, map );
          fi;
          
          M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) := TheIdentityMorphism( HM );
          
      else
          
          reg := Maximum( truncation_bound, HomalgElementToInteger( CastelnuovoMumfordRegularity( M ) ) );
          
          # in certain cases, when we know that the map to the
          # truncated module of global sections is injective,
          # we can check by looking at dimensions, whether it is surjective.
          # Then, we are done.
          if HasIsTorsionFree( M ) and IsTorsionFree( M ) or TrivialArtinianSubmodule( M ) then
              lin_tate := LinearStrandOfTateResolution( M, truncation_bound, reg+1 );
              fit := true;
              for i in [ truncation_bound .. reg+1 ] do
                  if not NrGenerators( CertainObject( lin_tate, i ) ) = NrGenerators( HomogeneousPartOverCoefficientsRing( i, M ) ) then
                    fit := false;
                    break;
                  fi;
              od;
          fi;
          
          if IsBound( fit ) and fit then
              
              psi := TruncatedSubmoduleEmbed( truncation_bound, M );
              
              HM := Source( psi );
              
              if truncation_bound = 0 then
                  V2 := HomogeneousPartOverCoefficientsRing( 0, HM );
                  map := EmbeddingOfSubmoduleGeneratedByHomogeneousPart( 0, HM );
                  SetEmbeddingOfSubmoduleGeneratedByHomogeneousPart( V2, map );
              fi;
              
              M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) := TheIdentityMorphism( HM );
              
          # the generic (expensive!) case.
          else
              
              lin_tate := LinearStrandOfTateResolution( M, truncation_bound, reg+1 );
              reg_sheaf := HomalgElementToInteger( lin_tate!.regularity );
              
              HM := LinearFreeComplexOverExteriorAlgebraToModule( reg_sheaf, lin_tate );
              
              Assert( 5, HomalgElementToInteger( CastelnuovoMumfordRegularity( HM ) ) = reg_sheaf );
              SetCastelnuovoMumfordRegularity( HM, reg_sheaf );
              
          fi;
          
      fi;
      
      SetIsModuleOfGlobalSectionsTruncatedAtCertainDegree( HM, truncation_bound );
      
      SetTrivialArtinianSubmodule( HM, true );
      
      if HasIsZero( HM ) then
          SetIsArtinian( M, IsZero( HM ) );
      fi;
      
      if truncation_bound = 0 then
          Assert( 0, HasEmbeddingOfSubmoduleGeneratedByHomogeneousPart( HomogeneousPartOverCoefficientsRing( 0, HM ) ) );
      fi;
      
      return HM;
      
end );

##
InstallGlobalFunction( _Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_OnGradedMaps,
  function( F_source, F_target, arg_before_pos, mor, arg_behind_pos )
      local truncation_bound, source, target, nat_source, nat_target, reg, lin_tate, reg_sheaf, H_mor;
      
      if IsIdenticalObj( Source( mor ), F_source ) and IsIdenticalObj( Range( mor ), F_target ) then
          return mor;
      fi;
      
      if not Length( arg_before_pos ) = 1 and IsInt( HomalgElementToInteger( arg_before_pos[1] ) ) then
          Error( "expected a bound for the truncation" );
      else
          truncation_bound := HomalgElementToInteger( arg_before_pos[1] );
      fi;
      
      source := Source( mor );
      target := Range( mor );
      
      if IsBound( source!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree )
         and IsBound( source!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) ) then
          nat_source := source!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound);
      else
          nat_source := fail;
      fi;
      if IsBound( target!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree )
         and IsBound( target!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) ) then
          nat_target := target!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound);
      else
          nat_target := fail;
      fi;
      if IsIdenticalObj( source, F_source ) and 
         nat_target <> fail then
          return PreCompose(
              mor / TruncatedSubmoduleEmbed( truncation_bound, target ),
              nat_target );
      fi;
      
      if nat_source <> fail and
         HasIsEpimorphism( nat_source ) and
         IsEpimorphism( nat_source ) and
         IsIdenticalObj( target, F_target ) then
          H_mor := PreDivide(
             nat_source,
             PreCompose( TruncatedSubmoduleEmbed( truncation_bound, source ), mor ) );
          return H_mor;
      fi;
      
      if nat_source <> fail and
         HasIsEpimorphism( nat_source ) and
         IsEpimorphism( nat_source ) and
         nat_target <> fail then
          H_mor := CompleteKernelSquare(
              nat_source,
              TruncatedSubmodule( truncation_bound, mor ),
              nat_target );
          return H_mor;
      fi;
      
      reg := Maximum( truncation_bound, HomalgElementToInteger( CastelnuovoMumfordRegularity( mor ) ) );

      lin_tate := LinearStrandOfTateResolution( mor, truncation_bound, reg+1 );
      
      reg_sheaf := Maximum( truncation_bound, HomalgElementToInteger( CastelnuovoMumfordRegularity( F_source ) ), HomalgElementToInteger( CastelnuovoMumfordRegularity( F_target ) ) );
      
      # setting these functors is vital, since ModuleOfGlobalSections on object does not compute with
      # LinearFreeComplexOverExteriorAlgebraToModule in every case, but we want to have identical objects
      if fail = GetFunctorObjCachedValue( Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules, [ reg_sheaf, Source( lin_tate ) ] ) then
          SetFunctorObjCachedValue( Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules, [ reg_sheaf, Source( lin_tate ) ], ModuleOfGlobalSectionsTruncatedAtCertainDegree( truncation_bound, Source( mor ) ) );
      fi;
      if fail = GetFunctorObjCachedValue( Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules, [ reg_sheaf, Range( lin_tate ) ] ) then
          SetFunctorObjCachedValue( Functor_LinearFreeComplexOverExteriorAlgebraToModule_ForGradedModules, [ reg_sheaf, Range( lin_tate ) ], ModuleOfGlobalSectionsTruncatedAtCertainDegree( truncation_bound, Range( mor ) ) );
      fi;
      
      H_mor := LinearFreeComplexOverExteriorAlgebraToModule( reg_sheaf, lin_tate );
      
      if HasIsMorphism( mor ) and IsMorphism( mor ) then
          SetIsMorphism( H_mor, true );
      fi;
      if HasIsMonomorphism( mor ) and IsMonomorphism( mor ) then
          SetIsMonomorphism( H_mor, true );
      fi;      
      
      return H_mor;
    
end );

##
## We create a map by following the layers from 
## T1) the homogeneous layers of M to
## T2) the homogenous parts of coefficients rings in R(M) to
## T3) the linear strand of the Tate resolution of M (we possibly need to do CompleteImageSquare here to get down from the regularity of the module to the regularity of the sheaf) to
## T4) the homogenous parts of coefficients rings in R(Gamma(M)) (we possibly need to do CompleteKernelSquare here to get back up from the regularity of the sheaf to the regularity of the module) to
## T5) the homogeneous layers of Gamma(M)
##
InstallMethod( NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree,
        "for integers and homalg graded modules",
        [ IsInt, IsGradedModuleRep ],

  function( truncation_bound, M )
    local S, A, regM, HM, regHM, T1, i, RM, T2, t1, linTM, T3, tau2, ii, t2, RHM, T4, T5, tau3, alpha, id1, id2, t3, t4, phi;
    
    if not IsBound( M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree ) then
        M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree := rec( );
    elif IsBound( M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) ) then
        return M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound);
    fi;
    
    if HasIsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) and IsInt( IsModuleOfGlobalSectionsTruncatedAtCertainDegree( M ) ) then
        return TheIdentityMorphism( M );
    fi;
    
    S := HomalgRing( M );
    
    A := KoszulDualRing( S );
    
    regM := Maximum( truncation_bound, CastelnuovoMumfordRegularity( M ) );
    
    HM := ModuleOfGlobalSectionsTruncatedAtCertainDegree( truncation_bound, M ); #This might set NaturalMapToModuleOfGlobalSections as a side effect
    
    # generating the module might generate the map naturally.
    if IsBound( M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) ) then
        return M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound);
    fi;
    
    regHM := CastelnuovoMumfordRegularity( HM );
    
    T1 := HomalgCocomplex( HomogeneousPartOverCoefficientsRing( truncation_bound, M ), truncation_bound );
    for i in [ truncation_bound + 1 .. regM +1 ] do
        Add( T1, HomogeneousPartOverCoefficientsRing( i, M ) );
    od;
    
    RM := KoszulRightAdjoint( M, truncation_bound, regM + 1 );
    T2 := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( RM, truncation_bound, regM + 1 );
    
    t1 := HomalgChainMorphism( MapFromHomogeneousPartofModuleToHomogeneousPartOfKoszulRightAdjoint( truncation_bound, M ), T1, T2, truncation_bound );
    for i in [ truncation_bound + 1 .. regM +1 ] do
        Add( t1, MapFromHomogeneousPartofModuleToHomogeneousPartOfKoszulRightAdjoint( i, M ) );
    od;
    Assert( 3, IsMorphism( t1 ) );
    SetIsMorphism( t1, true );
    
    linTM := LinearStrandOfTateResolution( M, truncation_bound, regM + 1 );
    T3 := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( linTM, truncation_bound, regM + 1 );
    
    tau2 := HomalgChainMorphism( TheIdentityMorphism( CertainObject( RM, regM + 1 ) ), RM, linTM, regM + 1 );
    for ii in [ truncation_bound .. regM ] do
        i := regM + truncation_bound - ii;
        Add( CompleteImageSquare( CertainMorphism( RM, i ), LowestDegreeMorphism( tau2 ), CertainMorphism( linTM, i ) ), tau2 );
    od;
    
    t2 := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( tau2, truncation_bound, regM + 1 );
    Assert( 3, IsMorphism( t2 ) );
    SetIsMorphism( t2, true );
    
    RHM := KoszulRightAdjoint( HM, truncation_bound, regM + 1 );
    T4 := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( RHM, truncation_bound, regM + 1 );
    
    
    if not HasNaturalMapFromExteriorComplexToRightAdjoint( linTM ) then
        SetNaturalMapFromExteriorComplexToRightAdjointForModulesOfGlobalSections( linTM, M );
    fi;
    tau3 := NaturalMapFromExteriorComplexToRightAdjoint( linTM );
    for i in [ Maximum( DegreesOfChainMorphism( tau3 ) ) + 1 .. regM + 1 ] do
        alpha := CompleteKernelSquareByDualization( CertainMorphism( linTM, i - 1 ), HighestDegreeMorphism( tau3 ), CertainMorphism( RHM, i - 1 ) );
        Assert( 3, IsIsomorphism( alpha ) );
        SetIsIsomorphism( alpha, true );
        UpdateObjectsByMorphism( alpha );
        if not i in ObjectDegreesOfComplex( Range( tau3 ) ) then
            Add( Range( tau3 ), CertainMorphism( RHM, i - 1 ) );
        fi;
        Add( tau3, alpha );
    od;
    
    t3 := HomogeneousPartOfCohomologicalDegreeOverCoefficientsRing( tau3, truncation_bound, regM + 1 );
    Assert( 3, IsMorphism( t3 ) );
    SetIsMorphism( t3, true );
    
    T5 := HomalgCocomplex( HomogeneousPartOverCoefficientsRing( truncation_bound, HM ), truncation_bound );
    for i in [ truncation_bound + 1 .. regM +1 ] do
        Add( T5, HomogeneousPartOverCoefficientsRing( i, HM ) );
    od;
    
    t4 := HomalgChainMorphism( MapFromHomogeneousPartofModuleToHomogeneousPartOfKoszulRightAdjoint( truncation_bound, HM )^(-1), T4, T5, truncation_bound );
    for i in [ truncation_bound + 1 .. regM +1 ] do
        Add( t4, MapFromHomogeneousPartofModuleToHomogeneousPartOfKoszulRightAdjoint( i, HM )^(-1) );
    od;
    Assert( 3, IsMorphism( t4 ) );
    SetIsMorphism( t4, true );
    
    phi := PreCompose( PreCompose( t1, t2 ), PreCompose( t3, t4 ) );
    
    phi := ConstructMorphismFromLayers( TruncatedModule( truncation_bound, M ), HM, S * phi );
    
    M!.NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree!.(truncation_bound) := phi;
    
    return phi;
    
end );

InstallValue( Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "ModuleOfGlobalSectionsTruncatedAtCertainDegree" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "ModuleOfGlobalSectionsTruncatedAtCertainDegree" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsInt ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_OnGradedModules ],
                [ "OnMorphisms", _Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_GRADED_MODULES.category.MorphismConstructor ]
                )
        );

Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

InstallFunctor( Functor_ModuleOfGlobalSectionsTruncatedAtCertainDegree_ForGradedModules );

##
InstallMethod( ModuleOfGlobalSectionsTruncatedAtCertainDegree,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedMap ],
               
  function( d, M )
    
    return ModuleOfGlobalSectionsTruncatedAtCertainDegree( HomalgElementToInteger( d ), M );
    
end );

##
InstallMethod( ModuleOfGlobalSectionsTruncatedAtCertainDegree,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedModule ],
               
  function( d, M )
    
    return ModuleOfGlobalSectionsTruncatedAtCertainDegree( HomalgElementToInteger( d ), M );
    
end );

##
InstallMethod( NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedModule ],
               
  function( d, M )
    
    return NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree( HomalgElementToInteger( d ), M );
    
end );

##
## ModuleOfGlobalSections
##

InstallGlobalFunction( _Functor_ModuleOfGlobalSections_OnGradedModules,
  function( M )
      return ModuleOfGlobalSectionsTruncatedAtCertainDegree( HOMALG_GRADED_MODULES!.LowerTruncationBound, M );
end );

InstallGlobalFunction( _Functor_ModuleOfGlobalSections_OnGradedMaps,
  function( F_source, F_target, arg_before_pos, mor, arg_behind_pos )
      return ModuleOfGlobalSectionsTruncatedAtCertainDegree( HOMALG_GRADED_MODULES!.LowerTruncationBound, mor );
end );

InstallValue( Functor_ModuleOfGlobalSections_ForGradedModules,
        CreateHomalgFunctor(
                [ "name", "ModuleOfGlobalSections" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "ModuleOfGlobalSections" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], HOMALG_GRADED_MODULES.FunctorOn ] ],
                [ "OnObjects", _Functor_ModuleOfGlobalSections_OnGradedModules ],
                [ "OnMorphisms", _Functor_ModuleOfGlobalSections_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_GRADED_MODULES.category.MorphismConstructor ]
                )
        );

Functor_ModuleOfGlobalSections_ForGradedModules!.ContainerForWeakPointersOnComputedBasicObjects := true;

Functor_ModuleOfGlobalSections_ForGradedModules!.ContainerForWeakPointersOnComputedBasicMorphisms := true;

InstallFunctor( Functor_ModuleOfGlobalSections_ForGradedModules );

##
InstallMethod( NaturalMapToModuleOfGlobalSections,
        "for homalg graded modules",
        [ IsGradedModuleRep ],

  function( M )
    
    return NaturalMapToModuleOfGlobalSectionsTruncatedAtCertainDegree( HOMALG_GRADED_MODULES!.LowerTruncationBound, M );
    
end );

##
InstallMethod( ModuleOfGlobalSections,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedMap ],
               
  function( d, M )
    
    return ModuleOfGlobalSections( HomalgElementToInteger( d ), M );
    
end );

##
InstallMethod( ModuleOfGlobalSectionsTruncatedAtCertainDegree,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedModule ],
               
  function( d, M )
    
    return ModuleOfGlobalSections( HomalgElementToInteger( d ), M );
    
end );

##
## GuessModuleOfGlobalSectionsFromATateMap
##

##
InstallMethod( GuessModuleOfGlobalSectionsFromATateMap,
        "for homalg modules",
        [ IsMapOfGradedModulesRep ],
        
  function( phi )
    
    return GuessModuleOfGlobalSectionsFromATateMap( 1, phi );
    
end );

InstallGlobalFunction( _Functor_GuessModuleOfGlobalSectionsFromATateMap_OnGradedMaps, ### defines: GuessModuleOfGlobalSectionsFromATateMap (object part)
        [ IsInt, IsMapOfGradedModulesRep ],
        
  function( steps, phi )
    local A, n, psi, deg, lin_tate, alpha, j, K, tate, i, tate2;
    
    Info( InfoWarning, 1, "GuessModuleOfGlobalSectionsFromATateMap uses a heuristic for efficiency;\nplease check the correctness of the following result\n" );
    
    A := HomalgRing( phi );
    
    n := Length( Indeterminates( A ) );
    
    # go up to the regularity
    
    psi := GradedHom( phi, A );
    
    deg := Minimum( List( DegreesOfGenerators( Source( psi ) ), HomalgElementToInteger ) );
    
    lin_tate := HomalgCocomplex( psi, deg );
    
    alpha := LowestDegreeMorphism( lin_tate );
    
    for j in [ 1 .. Maximum( 1, steps ) ] do
    
        repeat
                
            K := Kernel( alpha );
            ByASmallerPresentation( K );
            Add( PreCompose( CoveringEpi( K ), KernelEmb( alpha ) ), lin_tate );
        
            alpha := LowestDegreeMorphism( lin_tate );
            
            deg := Minimum( List( DegreesOfGenerators( Source( alpha ) ), HomalgElementToInteger ) );
            if deg <> Minimum( ObjectDegreesOfComplex( lin_tate ) ) then
                lin_tate := HomalgCocomplex( alpha, deg );
            fi;
            
        until Minimum( List( DegreesOfGenerators( Source( alpha ) ), HomalgElementToInteger ) ) = Maximum( List( DegreesOfGenerators( Source( alpha ) ), HomalgElementToInteger ) )
          and Minimum( List( DegreesOfGenerators( Range( alpha ) ), HomalgElementToInteger ) ) = Maximum( List( DegreesOfGenerators( Range( alpha ) ), HomalgElementToInteger ) )
          and HomalgElementToInteger( DegreesOfGenerators( Range( alpha ) )[1] ) = HomalgElementToInteger( DegreesOfGenerators( Source( alpha ) )[1] ) + 1;
          
    od;
      
    lin_tate := LinearStrand( 0, lin_tate );
    
    tate := GradedHom( lin_tate, A );
    tate := A^(-n) * tate;
    
    for i in MorphismDegreesOfComplex( tate ) do
        if not IsBound( tate2 ) then
            tate2 := HomalgCocomplex( CertainMorphism( tate, i ), -i );
        else
            Add( CertainMorphism( tate, i ), tate2 );
        fi;
    od;
    
    # go down to HOMALG_GRADED_MODULES!.LowerTruncationBound
    
    ResolveLinearly( Minimum( List( ObjectDegreesOfComplex( tate2 ), HomalgElementToInteger ) ) - HomalgElementToInteger( HOMALG_GRADED_MODULES!.LowerTruncationBound ), tate2 );
    
    # reconstruct the module
    
    return LinearFreeComplexOverExteriorAlgebraToModule( Maximum( List( ObjectDegreesOfComplex( tate2 ), HomalgElementToInteger ) ) - 1, tate2 );
    
end );

InstallValue( Functor_GuessModuleOfGlobalSectionsFromATateMap_ForGradedMaps,
        CreateHomalgFunctor(
                [ "name", "GuessModuleOfGlobalSectionsFromATateMap" ],
                [ "category", HOMALG_GRADED_MODULES.category ],
                [ "operation", "GuessModuleOfGlobalSectionsFromATateMap" ],
                [ "number_of_arguments", 1 ],
                [ "0", [ IsInt ] ],
                [ "1", [ [ "covariant", "left adjoint", "distinguished" ], [ IsMapOfGradedModulesRep ] ] ],
                [ "OnObjects", _Functor_GuessModuleOfGlobalSectionsFromATateMap_OnGradedMaps ],
                [ "MorphismConstructor", HOMALG_MODULES.category.MorphismConstructor ]
                )
        );

Functor_GuessModuleOfGlobalSectionsFromATateMap_ForGradedMaps!.ContainerForWeakPointersOnComputedBasicObjects := true;

InstallFunctor( Functor_GuessModuleOfGlobalSectionsFromATateMap_ForGradedMaps );

##
InstallMethod( GuessModuleOfGlobalSectionsFromATateMap,
               "for homalg elements",
               [ IsHomalgElement, IsHomalgGradedMap ],
               
  function( d, M )
    
    return GuessModuleOfGlobalSectionsFromATateMap( HomalgElementToInteger( d ), M );
    
end );
