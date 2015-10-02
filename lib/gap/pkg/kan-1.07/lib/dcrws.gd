##############################################################################
##
#W  dcrws.gd                     Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 0.99, 06/06/2011
##
#Y  Copyright (C) 1996-2011, Chris Wensley and Anne Heyworth 
##
##  This file contains generic methods for double coset rewriting systems
##

#############################################################################
##
#V  InfoKan
##
DeclareInfoClass( "InfoKan" );

############################################################################# 
## 
#A  ConstructedFromFpGroup
## 
DeclareAttribute( "ConstructedFromFpGroup", IsFpMonoid );

#############################################################################
## 
#P  IsDoubleCosetRewritingSystem( <rws> )
#P  IsWordAcceptorOfDoubleCosetRws( <aut> ) 
## 
DeclareProperty( "IsDoubleCosetRewritingSystem", IsRewritingSystem );
DeclareProperty( "IsWordAcceptorOfDoubleCosetRws", IsAutomatonObj ); 

############################################################################# 
## 
#O  WordToString( <word>, <alph> )
#O  DisplayAsString( <word>, <alph> )
#O  DisplayRwsRules( <rws> )
## 
DeclareOperation( "WordToString", [ IsWord, IsString ] );
DeclareOperation( "DisplayAsString", [ IsWord, IsString ] ); 
DeclareOperation( "DisplayRwsRules", [ IsRewritingSystem ] );    

############################################################################# 
## 
#A  WordAcceptorOfReducedRws
## 
DeclareAttribute( "InitialRewritingSystem", IsFpGroup );
DeclareAttribute( "CompleteRewritingSystem", IsFpGroup );
DeclareAttribute( "WordAcceptorOfReducedRws", IsRewritingSystem );

############################################################################# 
## 
#O  PartialDoubleCosetRewritingSystem
#O  DCrules
#A  Hrules
#A  Krules
#A  HKrules
#O  DoubleCosetRewritingSystem
#O  NextWord
#O  IdentityDoubleCoset
## 
DeclareOperation( "PartialDoubleCosetRewritingSystem", 
 [ IsGroup, IsHomogeneousList, IsHomogeneousList, IsRewritingSystem, IsInt ] );
DeclareOperation( "DCrules", [ IsDoubleCosetRewritingSystem ] );
DeclareAttribute( "Hrules", IsDoubleCosetRewritingSystem );
DeclareAttribute( "Krules", IsDoubleCosetRewritingSystem );
DeclareAttribute( "HKrules", IsDoubleCosetRewritingSystem );
DeclareOperation( "DoubleCosetRewritingSystem", [ IsGroup, IsHomogeneousList, 
    IsHomogeneousList, IsRewritingSystem ] );    
DeclareOperation( "NextWord", [ IsRewritingSystem, IsWord ] );
DeclareOperation( "IdentityDoubleCoset", [ IsDoubleCosetRewritingSystem ] );

############################################################################# 
## 
#A  WordAcceptorOfDoubleCosetRws( <dcrws> )                           
#O  WordAcceptorOfPartialDoubleCosetRws( <grp>, <prws> )
#O  WordAcceptorByKBMagOfDoubleCosetRws( <grp>, <pdcrws> )
#A  RewritingSystemOfWordAcceptor( <aut> )
## 
DeclareAttribute( "WordAcceptorOfDoubleCosetRws", 
    IsDoubleCosetRewritingSystem );
DeclareOperation( "WordAcceptorOfPartialDoubleCosetRws", 
    [ IsGroup, IsDoubleCosetRewritingSystem ] );
DeclareOperation( "WordAcceptorByKBMagOfDoubleCosetRws", 
    [ IsFpGroup, IsDoubleCosetRewritingSystem ] );
DeclareAttribute( "RewritingSystemOfWordAcceptor", IsAutomatonObj );

############################################################################# 
## 
#O  KBMagFSAtoAutomataDFA
#O  WordAcceptorByKBMag
#A  KBMagRewritingSystem
#A  KBMagWordAcceptor
## 
DeclareOperation( "KBMagFSAtoAutomataDFA", [ IsInternalRep, IsString ] );
DeclareOperation( "WordAcceptorByKBMag", [ IsFpGroup, IsString ] );
DeclareAttribute( "KBMagRewritingSystem", IsFpGroup );
DeclareAttribute( "KBMagWordAcceptor", IsFpGroup );

############################################################################# 
## 
#O  DoubleCosetsAutomaton
#O  RightCosetsAutomaton
## 
DeclareOperation( "DoubleCosetsAutomaton", [ IsFpGroup, IsGroup, IsGroup ] );
DeclareOperation( "RightCosetsAutomaton", [ IsFpGroup, IsGroup ] );

##############################################################################
## 
#E  dcrws.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
## 
