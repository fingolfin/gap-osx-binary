#############################################################################
##
##  MAGMA_PIR.gi              RingsForHomalg package         Mohamed Barakat
##
##  Copyright 2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations for commutative principal ideal rings in MAGMA.
##
#############################################################################

####################################
#
# constructor functions and methods:
#
####################################

InstallMethod( CreateHomalgTable,
        "for the ring of integers in MAGMA",
        [ IsHomalgExternalRingObjectInMAGMARep
          and IsPrincipalIdealRing ],
        
  function( ext_ring_obj )
    local RP, RP_General, RP_BestBasis, RP_specific, component;
    
    RP := ShallowCopy( CommonHomalgTableForMAGMATools );
    
    RP_General := ShallowCopy( CommonHomalgTableForRings );
    
    RP_BestBasis := ShallowCopy( CommonHomalgTableForMAGMABestBasis );
    
    RP_specific :=
          rec(
               ## Can optionally be provided by the RingPackage
               ## (homalg functions check if these functions are defined or not)
               ## (homalgTable gives no default value)
               
               ElementaryDivisors :=
                 function( M )
                   
                   return homalgSendBlocking( [ "ElementaryDivisors(", M, ")" ], "need_output", HOMALG_IO.Pictograms.ElementaryDivisors );
                   
                 end,
               
               RowRankOfMatrixOverDomain :=
                 function( M )
                     
                     return Int( homalgSendBlocking( [ "Rank(", M, ")" ], "need_output" ) );
                     
                 end,
               
               ## Must be defined if other functions are not defined
               
               RowReducedEchelonForm :=
                 function( arg )
                   local M, R, nargs, N, U;
                   
                   M := arg[1];
                   
                   R := HomalgRing( M );
                   
                   nargs := Length( arg );
                   
                   N := HomalgVoidMatrix( NrRows( M ), NrColumns( M ), R );
                   
                   if nargs > 1 and IsHomalgMatrix( arg[2] ) then ## not RowReducedEchelonForm( M, "" )
                       # assign U:
                       U := arg[2];
                       SetNrRows( U, NrRows( M ) );
                       SetNrColumns( U, NrRows( M ) );
                       SetIsInvertibleMatrix( U, true );
                       
                       ## compute N and U:
                       homalgSendBlocking( [ N, U, " := EchelonForm(", M, ")" ], "need_command", HOMALG_IO.Pictograms.ReducedEchelonFormC );
                   else
                       ## compute N only:
                       homalgSendBlocking( [ N, " := EchelonForm(", M, ")" ], "need_command", HOMALG_IO.Pictograms.ReducedEchelonForm );
                   fi;
                   
                   SetIsUpperStairCaseMatrix( N, true );
                   
                   return N;
                   
                 end
               
          );
    
    for component in NamesOfComponents( RP_General ) do
        RP.(component) := RP_General.(component);
    od;
    
    for component in NamesOfComponents( RP_BestBasis ) do
        RP.(component) := RP_BestBasis.(component);
    od;
    
    for component in NamesOfComponents( RP_specific ) do
        RP.(component) := RP_specific.(component);
    od;
    
    Objectify( TheTypeHomalgTable, RP );
    
    return RP;
    
end );
