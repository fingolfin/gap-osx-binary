#############################################################################
##
#W  sl25.g                    XMOD example files                Chris Wensley
##
##  version 2.41, 05/06/2015 
##
#Y  Copyright (C) 2001-2015, Murat Alp and Chris Wensley, 
#Y  School of Computer Science, Bangor University, U.K. 
##
#############################################################################

Print("\nXMod test file sl25.g (version 05/06/15) :-\n\n");

sl25pc := SpecialLinearGroup(2,5); 
SetName( sl25pc, "sl25-pc" ); 
isosl := IsomorphismPermGroup( sl25pc );
sl25 := Image( isosl );
SetName( sl25, "sl25" ); 
gensl25 := GeneratorsOfGroup( sl25 ); 
Print( "sl25 has generators: ", gensl25, "\n" ); 
ccsl := ConjugacyClassesSubgroups( sl25 ); 
repssl := List( ccsl, c -> Representative(c) );  
Print( "conj. classes: ", List( repssl, r -> Size(r) ), "\n" ); 
Print( List( repssl, r -> StructureDescription(r) ), "\n" ); 

gl25pc := GeneralLinearGroup(2,5); 
SetName( gl25pc, "gl25-pc" ); 
isogl := IsomorphismPermGroup( gl25pc );
invgl := InverseGeneralMapping( isogl ); 
gl25 := Image( isogl );
SetName( gl25, "gl25" ); 
gengl25 := GeneratorsOfGroup( gl25 ); 
Print( "gl25 has generators: ", gengl25, "\n" ); 
ccgl := ConjugacyClassesSubgroups( gl25 ); 
repsgl := List( ccgl, c -> Representative(c) );  
Print( "conj. classes: ", List( repsgl, r -> Size(r) ), "\n" ); 
Print( List( repsgl, r -> StructureDescription(r) ), "\n" ); 

lengl := Length( repsgl );
sl25c2 := repsgl[lengl-1]; 
SetName( sl25c2, "sl25.c2" ); 
X25 := XModByNormalSubgroup( sl25c2, sl25 );
inc25 := InclusionMappingGroups( gl25, sl25c2 );
indX25 := InducedXMod( X25, inc25 ); 
Display( indX25 ); 
h25 := Source( indX25 ); 
Print( "h25 = ", StructureDescription( h25 ), "\n" ); 

## sl25c2pc := Image( invgl, sl25c2 ); 
## SetName( sl25c2pc, "sl25.c2-pc" ); 
## X25pc := XModByNormalSubgroup( sl25c2pc, sl25pc );
## inc25pc := InclusionMappingGroups( gl25pc, sl25c2pc );
## indX25pc := InducedXMod( X25pc, inc25pc ); 
## Display( indX25pc ); 
## h25pc := Source( indX25pc ); 
## Print( "h25pc = ", StructureDescription( h25pc ), "\n" ); 

