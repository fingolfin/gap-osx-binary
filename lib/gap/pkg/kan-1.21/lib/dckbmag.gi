##############################################################################
##
#W  dckbmag.gi                   Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.11, 10/11/2014
##
#Y  Copyright (C) 1996-2014, Chris Wensley and Anne Heyworth 
##
##  This file contains generic methods for double coset rewriting systems
##

###########################################################################
##
#M  WordAcceptorByKBMagOfDoubleCosetRws
##
##  this method requires KBMAG to produce a finite automaton for the group

InstallMethod( WordAcceptorByKBMagOfDoubleCosetRws,
    "generic method for a partial double coset rewriting system", true, 
    [ IsFpGroup, IsDoubleCosetRewritingSystem ], 0,
function( grp, dcrws )

    local  rules, numr, fam, order, ogens, ugens, numgens, range, type, 
           a, c, g, i, j, k, l, m, n, p, q, r, s, t, u, v, w, 
           lq, ls, lu, lw, M, genM, numgenM, fM, genfM, m1, m2, oldinit, 
           waG, accG, transG, numstG, numH, numK, numHK, 
           hrules, krules, hkrules, alph, alph2, alpht, alpht2, perm2, 
           id, ok, printmax, fhrules, fkrules, fhkrules,
           numstates, lr, len, sublr, pos, pos2, shG, shH, shK, shHK, 
           pfH, sfK, pfHK, npfH, nsfK, npfHK, 
           row, transmx, accept, nfa, mdfa, 
           init, nonacc, oldsink, sink, done, 
           stateG, stateH, stateK, stateHK;

    rules := Rules( dcrws );
    numr := Length( rules );
    ok := DCrules( dcrws );
    hkrules := HKrules( dcrws );
    hrules := Hrules( dcrws );
    krules := Krules( dcrws );
    Info( InfoKan, 2, "H-rules, K-rules, HK-rules =" );
    Info( InfoKan, 2, hrules );
    Info( InfoKan, 2, krules );
    Info( InfoKan, 2, hkrules );
    fam := FamilyForRewritingSystem( dcrws );
    order := OrderingOfRewritingSystem( dcrws );
    ogens := OrderingOnGenerators( order );
    Info( InfoKan, 2, "ogens = ", ogens );
    ugens := List( ogens, g -> true );
    id := One( ogens[1] );
    numgens := Length( ogens );
    alph2 := dcrws!.alphabet;
    alpht2 := ShallowCopy( alph2 );
    perm2 := dcrws!.gensperm;
    for i in [3..Length(alph2)] do
        alpht2[i] := alph2[i^perm2];
    od;
    Info( InfoKan, 2, "alphabet = ", alph2, ", twisted alphabet = ", alpht2 );
    M := MonoidOfRewritingSystem( dcrws );
    genM := GeneratorsOfMonoid( M );
    numgenM := Length( genM );
    id := One( genM[1] );
    fM := FreeMonoidOfFpMonoid( M );
    genfM := GeneratorsOfMonoid( fM );
    m1 := genfM[1];  m2 := genfM[2];
    ## process the DFA from KBMag ##
    alph := alph2{[3..Length(alph2)]};
    alpht := alpht2{[3..Length(alpht2)]};
    waG := WordAcceptorByKBMag( grp, alph );
    accG := KBMagWordAcceptor( grp );
    transG := accG!.transitions;
    numstG := accG!.states;
    oldinit := accG!.initial[1];
    numH := Length( hrules );
    numK := Length( krules );
    numHK := Length( hkrules );
    pfH:=[ m1 ];  sfK:=[ m2 ];  pfHK:=[ m1 ];
    for k in [1..numH] do
        lr := hrules[k][1];
        len := Length( lr );
        for i in [1..len-1] do
            sublr := Subword( lr, 1, i );
            pos := Position( pfH, sublr );
            if ( pos = fail ) then Add( pfH, sublr); fi;
        od;
    od;
    for k in [1..numK] do
        lr := krules[k][1];
        len := Length( lr );
        for i in [1..len-1] do
            sublr := Subword( lr, len-i+1, len );
            pos := Position( sfK, sublr );
            if ( pos = fail ) then Add( sfK, sublr); fi;
        od;
    od;
    for k in [1..numHK] do
        lr := hkrules[k][1];
        len := Length( lr );
        for i in [1..len-1] do
            sublr := Subword( lr, 1, i );
            pos := Position( pfHK, sublr );
            if ( pos = fail ) then Add( pfHK, sublr); fi;
        od;
    od;
    pfH := List( pfH, w -> Subword( w, 2, Length(w) ) );
    sfK := List( sfK, w -> Subword( w, 1, Length(w)-1 ) );
    pfHK := List( pfHK, w -> Subword( w, 2, Length(w) ) );
    npfH := Length( pfH );
    nsfK := Length( sfK );
    npfHK := Length( pfHK );
    Info( InfoKan, 2, "[npfH,nsfK,npfHK] = ", [npfH,nsfK,npfHK] );
    Info( InfoKan, 2, pfH );
    Info( InfoKan, 2, sfK );
    Info( InfoKan, 2, pfHK );
    nonacc := Difference( [1..numstG], accG!.accepting );
    if not ( Length( nonacc ) = 1 ) then
        Error( "more than one non-accepting state" );
    fi;
    oldsink := nonacc[1];
    init := 1;  done := 2;  shG := 2;  sink := shG+oldsink;
    stateG := shG+accG!.initial[1];  shH := shG+numstG; 
    stateH := shH+1;  shK := shH+npfH;
    stateK := shK+1;  shHK := shK+nsfK;  
    stateHK := shHK+1;
    numstates := shG + numstG + npfH + nsfK + npfHK;
    row := ListWithIdenticalEntries( numstates, 0 );
    transmx := List( [1..numgens], i -> ShallowCopy( row ) );
    for j in [1..shH] do  transmx[1][j] := [sink];  od;
    for j in [shH+1..numstates] do  transmx[1][j] := [ ];  od;
    for j in [1..numstates] do  transmx[2][j] := [ ];  od;
    transmx[2][init] := [sink];  
    transmx[2][done] := [sink];
    transmx[2][sink] := [sink];
    ## identify the identity word states ##
    transmx[1][init] := [ stateG, stateH, stateHK ];  
    for i in [3..numgens] do
        ##  if ( transG[i-2][oldinit] = oldsink ) then
        ##      Info( InfoKan, 2, "found dud generator", i );
        ##      ugens[i] := false;
        ##  fi;
        for j in [1..shG] do
            transmx[i][j] := [sink];
        od;
        for j in [shG+1..numstates] do
            if ( ugens[i] = false ) then
                transmx[i][j] := [sink];
            else
                transmx[i][j] := [ ];
            fi;
        od;
        transmx[i][init] := [sink];
        transmx[i][sink] := [sink];
    od;
    Info( InfoKan, 2, "ugens = ", ugens );
    Info( InfoKan, 3, "initial transmx", transmx );
    ## G transitions ##
    for i in [1..numgens-2] do
        for j in [1..numstG] do
            transmx[i+2][j+shG] := [ transG[i][j]+shG ];
        od;
    od;
    for j in [1..numstG] do
        transmx[2][j+shG] := [done];
    od;
    transmx[2][oldsink+shG] := [sink];
    Info( InfoKan, 3, "*** H-transitions:" );
    ## H transitions ##
    for k in [2..npfH] do
        q := pfH[k];  lq := Length(q);
        a := Subword( q, lq, lq );
        i := Position( ogens, a );
        if ( lq = 1 ) then
            pos := 1;
        else
            p := Subword( q, 1, lq-1 );
            pos := Position( pfH, p );
        fi;
        Info( InfoKan, 3, "[q,a,pos,i,pos+shH,k+shH] = ",
            [q,a,pos,i,pos+shH,k+shH] );
        Add( transmx[i][pos+shH], k+shH );
    od;
    Info( InfoKan, 3, "*** H-rules:" );
    for r in hrules do
        w := Subword( r[1], 2, Length(r[1]) );
        lw := Length(w);
        a := Subword( w, lw, lw );
        i := Position( ogens, a );
        if ( lw = 1 ) then
            pos := 1;
        else
            p := Subword( w, 1, lw-1 );
            pos := Position( pfH, p );
        fi;
        transmx[i][pos+shH] := [sink];
    od;
    ## K transitions ##
    Info( InfoKan, 3, "*** K-transitions:" );
    for k in [2..nsfK] do
        q := sfK[k];  lq := Length(q);
        a := Subword( q, 1, 1 );
        i := Position( ogens, a );
        if ( lq = 1 ) then
            pos := 1;
        else
            p := Subword( q, 2, lq );
            pos := Position( sfK, p );
        fi;
        Info( InfoKan, 3, "[q,a,pos,i,k+shK,pos+shK] = ",
            [q,a,pos,i,k+shK,pos+shK] );
        Add( transmx[i][k+shK], pos+shK );
    od;
    ##  for i in [1..numgens] do transmx[i][shK+1] := [sink]; od;
    transmx[2][stateK] := [sink];
    ## transitions to K-leaves ##
    Info( InfoKan, 3, "*** K-rules:" );
    for r in krules do
        w := Subword( r[1], 1, Length(r[1])-1 );
        lw := Length( w );
        a := Subword( w, 1, 1 );
        i := Position( ogens, a );
        if ( lw = 1 ) then
            pos := 1;
        else
            p := Subword( w, 2, lw );
            pos := Position( sfK, p );
        fi;
        for k in [1..numstG] do
            j := k + shG;
            if ( transmx[i][j] <> [sink] ) then
                Info( InfoKan, 3, "adding [i,j,pos+shK] = ", [i,j,pos+shK] );
                Add( transmx[i][j], pos+shK );
            fi;
        od;
    od;
    ## HK transitions ##
    Info( InfoKan, 3, "*** HK-transitions:" );
    for k in [2..npfHK] do
        q := pfHK[k];  lq := Length(q);
        a := Subword( q, lq, lq );
        i := Position( ogens, a );
        if ( lq = 1 ) then
            pos := 1;
        else
            p := Subword( q, 1, lq-1 );
            pos := Position( pfHK, p );
        fi;
        Info( InfoKan, 3, "[q,a,pos,i,pos+shHK,k+shHK] = ",
            [q,a,pos,i,pos+shHK,k+shHK] );
        Add( transmx[i][pos+shHK], k+shHK );
    od;
    Info( InfoKan, 3, "*** HK-rules:" );
    for r in hkrules do
        pos := Position( pfHK, Subword( r[1], 2, Length(r[1])-1 ) );
        transmx[2][pos+shHK] := [sink];
    od;
    accept := Difference( [1..numstates], [done] );
    nfa := Automaton( "nondet", numstates, alpht2, transmx, [init], accept );
    Info( InfoKan, 2, "initial NFA:" );
    Info( InfoKan, 2, nfa ); 
    mdfa := MinimalAutomaton( ComplementDA( NFAtoDFA( nfa ) ) );
    return mdfa;
end );

#############################################################################
##
#M  KBMagFSAtoAutomataDFA
##
InstallMethod( KBMagFSAtoAutomataDFA, "generic method for an fsa", true, 
    [ IsInternalRep, IsString ], 0,
function( fsa, alph )

    local  numst, numa, init, accept, table, ftrans, atrans, 
           flags, format, i, j, k, sink, dfa, alpht, perm, L;

    if not IsFSA( fsa ) then
        Error( "fsa is not a KBMAG FSA" );
    fi;
    table := fsa!.table;
    format := table!.format;
    if not ( format = "dense deterministic" ) then
        Print( "*** only dense deterministic fsa treated at present\n" );
        return fail;
    fi;
    numa := fsa!.alphabet!.size;
    if not ( numa = Length( alph ) ) then
        Print( "** length of string alph not equal to size of alphabet **\n" );
        Print( "** probably one of the generators has order 2          **\n" );
        Print( "** this case is not treated at present                 **\n" );
        return fail;
    fi; 
    L := [1..numa];
    i := 1;
    while ( i < numa ) do
        j := L[i];
        L[i] := L[i+1];
        L[i+1] := j;
        i := i+2;
    od;
    perm := PermList( L );
    alpht := ShallowCopy( alph );
    for i in [1..numa] do
        alpht[i] := alph[i^perm];
    od;
    numst := fsa!.states!.size + 1;
    sink := numst;
    init := fsa!.initial;
    accept := fsa!.accepting;
    ftrans := table!.transitions;
    atrans := [ ];
    ##  change zero entries to sink state
    for i in [ numa, numa-1 .. 1 ] do
        atrans[i]:= [ ];
        atrans[i][sink] := sink;
        for j in [ numst-1, numst-2 .. 1 ] do
            k := ftrans[j][i];
            if ( k > 0 ) then
                atrans[i][j] := k;
            else
                atrans[i][j] := sink;
            fi;
        od;
    od;
    dfa := Automaton( "det", numst, alpht, atrans, init, accept );
    return dfa;
end );

#############################################################################
##
#M  WordAcceptorByKBMag
#M  KBMagRewritingSystem
#M  KBMagWordAcceptor
##
InstallMethod( WordAcceptorByKBMag, "generic method for fp group and string", 
    true, [ IsFpGroup, IsString ], 0,
function( grp, alph )

    local  rws, ok, wa, dfa, alpht, L;

    if HasKBMagWordAcceptor( grp ) then
        return KBMagWordAcceptor( grp );
    fi;
    rws := KBMAGRewritingSystem( grp );
    ok := AutomaticStructure( rws );
    wa := WordAcceptor( rws );
    dfa := KBMagFSAtoAutomataDFA( wa, alph );
    alpht := AlphabetOfAutomatonAsList( dfa );
    L := List( [1..Length(alph)], i-> Position( alph, alpht[i] ) );
    dfa!.gensperm := PermList( L );
    SetKBMagRewritingSystem( grp, rws );
    SetKBMagWordAcceptor( grp, dfa );
    return dfa;
end );

#############################################################################
## 
#E  dckbmag.gi . . .  . . . . . . . . . . . . . . . . . . . . . . . ends here 
## 
