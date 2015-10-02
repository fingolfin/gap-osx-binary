##############################################################################
##
#W  kbrws.gi                     Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.11, 10/11/2014
##
#Y  Copyright (C) 1996-2014, Chris Wensley and Anne Heyworth 
##
##  This file contains functions taken from the library files
##  rws.gi and kbsemi.gi, and modified to allow partial rewrite systems
##

#############################################################################
####     these functions taken from rws.gi or kbsemi.gi and modified     ####
############################################################################# 

#############################################################################
##
#G  LimitedMakeKnuthBendixRewritingSystemConfluent
#M  MakeConfluent
#M  KnuthBendixRewritingSystem
#M  ReducedConfluentRewritingSystem
##
BindGlobal("LimitedMakeKnuthBendixRewritingSystemConfluent",
function( kbrws, limit )

    local   pn,lp,rl,p,i,ok;              #loop variables

    if ( limit < 0 ) then
        Error( "limit must ne non-negative" );
    fi;
    # kbrws!.reduced is true than it means that the system know it is
    # reduced. If it is false it might be reduced or not.
    if not kbrws!.reduced then
        ReduceRules(kbrws);
    fi;

    # we check all pairs of relations for overlaps. In most cases there will
    # be no overlaps. Therefore cally an inde xp in the pairs list and reduce
    # this list, only if `AddRules' gets called. This avoids creating a lot 
    # of garbage lists.
    ok := true;
    p := 1;
    rl := 50;
    pn := Length(kbrws!.pairs2check);
    lp := Length(kbrws!.pairs2check);
    while ok do
        i := kbrws!.pairs2check[p];
        ## Print(">>>>> sending ",i," to KBOverlaps\n");
        p := KBOverlaps(i[1],i[2],kbrws,p)+1;
        lp := Length(kbrws!.pairs2check);
        if ( Length(kbrws!.tzrules) > rl ) or ( AbsInt(lp-pn) > 10000 ) then
            Info( InfoKnuthBendix, 1, Length(kbrws!.tzrules),
                " rules, and ", lp, " pairs" );
            rl := Length(kbrws!.tzrules)+50;
            pn := lp;
        fi;
        ok  :=  ( ( lp >= p ) and 
                  ( ( limit = 0 ) or ( Length(kbrws!.tzrules) <= limit ) ) );
    od;
    Info( InfoKnuthBendix, 2, "Leaving LimitedKBRSC with ", 
        Length(kbrws!.tzrules), " rules, and limit = ", limit );
    if ( ( limit > 0 ) and ( Length(kbrws!.tzrules) >= limit ) 
         and ( InfoLevel( InfoKnuthBendix ) > 0 ) ) then 
        Print( "#I WARNING: reached supplied limit ", limit, 
               " on number of rules\n" );
        if ( lp < 800 ) then
            Info( InfoKan, 2, "pairs2check: ", kbrws!.pairs2check );
        else
            Info( InfoKan, 2, "pairs2check has length ", lp );
        fi;
    else
        kbrws!.pairs2check := [];
    fi;
end );

InstallOtherMethod(MakeConfluent, "for Knuth Bendix Rewriting System",
    true, [ IsKnuthBendixRewritingSystem and IsKnuthBendixRewritingSystemRep 
            and IsMutable and IsBuiltFromMonoid, IsInt ], 0,
function(kbrws,limit)
    local rws;

    LimitedMakeKnuthBendixRewritingSystemConfluent( kbrws, limit );
    # if the monoid of the kbrws does not have a ReducedConfluentRws 
    # build one from kbrws and then store it in the monoid 
    if not HasReducedConfluentRewritingSystem(
                      MonoidOfRewritingSystem(kbrws) ) then
        rws := ReducedConfluentRwsFromKbrwsNC(kbrws);
    SetReducedConfluentRewritingSystem(MonoidOfRewritingSystem(kbrws),rws);
    fi;
end );

InstallOtherMethod( KnuthBendixRewritingSystem, 
    "generic method for an fp-group", true, 
    [ IsFpGroup, IsString, IsHomogeneousList, IsString ], 0,
function( G, order, gensord, alph )

    local  fG, rels, genG, genfG, numgenG, numgenfG, i, 
           mhom, M, genM, numgenM, range, fM, ord, rws;

    if HasInitialRewritingSystem( G ) then
        return InitialRewritingSystem( G );
    fi;
    ## Print("~~~~ in KBRws with [order,gensord,alph] = ",
    ##                           [order,gensord,alph],"\n");
    fG := FreeGroupOfFpGroup( G );
    rels := RelatorsOfFpGroup( G );
    genG := GeneratorsOfGroup( G );
    genfG := GeneratorsOfGroup( fG );
    numgenG := Length( genG );
    numgenfG := Length( genfG );
    if ( numgenG <> numgenfG ) then
        Error( "unequal numbers of generators" );
    fi;
    mhom := IsomorphismFpMonoid( G );
    M := Image( mhom );
    SetConstructedFromFpGroup( M, G );
    genM := GeneratorsOfMonoid( M );
    numgenM := Length( genM );
    Info( InfoKan, 3, "using gens order = ", gensord );
    fM := FreeMonoidOfFpMonoid( M );
    if ( order = "shortlex" ) then
        ord := ShortLexOrdering( fM, gensord );
    elif ( order = "wreath" ) then
        ord := BasicWreathProductOrdering( fM, gensord );
    else
        Error( "the given order should be \"shortlex\" or \"wreath\"" );
    fi;
    ## Print("~~~~ in KBRws with M, ord = ", M, ord, IsOrdering(ord), "\n" );
    rws := KnuthBendixRewritingSystem( M, ord );
    rws!.alphabet := alph;
    rws!.gensperm := PermList( gensord );
    SetInitialRewritingSystem( G, rws );
    return rws;
end );

InstallOtherMethod(ReducedConfluentRewritingSystem,
    "for an fp monoid and an ordering and a limited number of rules", true,
    [IsFpMonoid, IsOrdering, IsInt], 0,
function(M,ordering,limit)
    local kbrws, rws;

    if HasReducedConfluentRewritingSystem(M) and
        IsIdenticalObj(ordering,
        OrderingOfRewritingSystem(ReducedConfluentRewritingSystem(M))) then
      return ReducedConfluentRewritingSystem(M);
    fi;
    # we start by building a knuth bendix rws for the monoid
    kbrws := KnuthBendixRewritingSystem(M,ordering);
    # then we make it confluent (and reduced)
    MakeConfluent( kbrws, limit );
    # we now check whether the attribute is already set
    # (for example, there is an implementation of MakeConfluent that
    # stores it immediately)
    # if the attribute is not set we set it here
    rws := ReducedConfluentRwsFromKbrwsNC(kbrws);
    if not(HasReducedConfluentRewritingSystem(M)) then
        SetReducedConfluentRewritingSystem(M, rws);
    fi;
    return rws;
end );

#############################################################################
##
#M  ReducedConfluentRewritingSystem
##
InstallOtherMethod( ReducedConfluentRewritingSystem,
    "generic method for a group and an ordering",  true, 
    [ IsGroup, IsList, IsString ], 0,
function( G, gensorder, order )
    return ReducedConfluentRewritingSystem( G, gensorder, order, 0, "" );
end );

InstallOtherMethod( ReducedConfluentRewritingSystem,
    "generic method for a group and an ordering",  true, 
    [ IsGroup, IsList, IsString, IsInt ], 0,
function( G, gensorder, order, limit )
    return ReducedConfluentRewritingSystem( G, gensorder, order, limit, "" );
end );

InstallOtherMethod( ReducedConfluentRewritingSystem,
    "generic method for a group, an ordering, a limit and an alphabet", true, 
    [ IsGroup, IsList, IsString, IsInt, IsString ], 0,
function( G, gensorder, order, limit, alph )

    local  fG, rels, genG, genfG, numgenG, numgenfG, i, 
           mhom, M, genM, numgenM, range, fM, ord, rws;

    if ( limit < 0 ) then
        Error( "limit must ne non-negative" );
    fi;
    fG := FreeGroupOfFpGroup( G );
    rels := RelatorsOfFpGroup( G );
    genG := GeneratorsOfGroup( G );
    genfG := GeneratorsOfGroup( fG );
    numgenG := Length( genG );
    numgenfG := Length( genfG );
    if ( numgenG <> numgenfG ) then
        Error( "unequal numbers of generators" );
    fi;
    mhom := IsomorphismFpMonoid( G );
    M := Image( mhom );
    SetConstructedFromFpGroup( M, G );
    genM := GeneratorsOfMonoid( M );
    numgenM := Length( genM );
    if ( numgenM = Length( gensorder ) ) then
        range := gensorder;
    else
        range := 0 * [1..numgenM];
        for i in [1..numgenG] do
            range[i] := 2*i;
            range[i+numgenG] := 2*i-1;
        od;
    fi;
    ## range := Reversed( range );
    Info( InfoKan, 3, "using range = ", range );
    fM := FreeMonoidOfFpMonoid( M );
    if ( order = "shortlex" ) then
        ord := ShortLexOrdering( fM, range );
    elif ( order = "wreath" ) then
        ord := BasicWreathProductOrdering( fM, range );
    else
        Error( "the given order should be \"shortlex\" or \"wreath\"" );
    fi;
    rws := ReducedConfluentRewritingSystem( M, ord, limit );
    rws!.gensperm := PermList( gensorder );
    if ( alph <> "" ) then
        rws!.alphabet := alph;
    fi;
    SetReducedConfluentRewritingSystem( G, rws );
    return rws;
end );

############################################################################
## 
#E  kbrws.gi  . . .  . . . . . . . . . . . . . . . . . . . . . . . ends here 
## 
