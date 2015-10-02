##############################################################################
##
#W  dcrws.gi                     Kan Package                     Chris Wensley
#W                                                             & Anne Heyworth
##  version 1.11, 10/11/2014
##
#Y  Copyright (C) 1996-2014, Chris Wensley and Anne Heyworth 
##
##  This file contains generic methods for double coset rewriting systems
##

##  Convention:  order is a string, "shortlex" or "wreath",
##                 ord is an ordering,
##             gensord is a numerical list of generators, e.g. [2,1,4,3]

KAN_double_coset_group_alphabet := 
    ["A","a","B","b","C","c","D","d","E","e","F","f","G","g"];
KAN_double_coset_coset_alphabet := 
    ["T","t"];

############################################################################
##
#M  \*                                                  methods for strings
#M  \^                                                   (rather a fudge)
##
InstallOtherMethod( \*, "for strings", true, 
    [ IS_STRING_REP, IS_STRING_REP ], 0, 
function( s1, s2 ) 
  return Concatenation( s1, s2 );
end );

InstallOtherMethod( \^, "for strings", true, [ IS_STRING_REP, IsPosInt ], 0, 
function( s, p ) 
    local  i, w;
    w := s;
    for i in [2..p] do
        w := Concatenation( w, s );
    od;
    return w;
end );

#############################################################################
##
#M  WordToString
#M  DisplayAsString
#M  DisplayRwsRules 
##
InstallMethod( WordToString, "generic method for a dcrws", true, 
    [ IsWord, IsString ], 0, 
function( r, alph )

    local  alph0, w, lenw, i, j, k, c, s;
    alph0 := List( [1..Length(alph)], i -> WordAlp( alph, i ) );
    w := ExtRepOfObj( r );  
    lenw := QuoInt( Length(w), 2 );
    s := "";
    for i in [1..lenw] do
        j := i+i;
        c := alph0[w[j-1]];
        for k in [1..w[j]] do
            s := Concatenation( s, c );
        od;
    od;
    return s;
end );

InstallMethod( DisplayAsString, "generic method for a dcrws", true, 
    [ IsWord, IsString ], 0, 
function( r, alph )

    local  alph0, w, lenw, i, j, k, c, s;
    alph0 := List( [1..Length(alph)], i -> WordAlp( alph, i ) );
    w := ExtRepOfObj( r );  
    lenw := QuoInt( Length(w), 2 );
    s := "";
    for i in [1..lenw] do
        j := i+i;
        c := alph0[w[j-1]];
        for k in [1..w[j]] do
            s := Concatenation( s, c );
        od;
    od;
    Print( s );
end );

InstallOtherMethod( DisplayAsString, "generic method for a list of words", 
    true, [ IsHomogeneousList, IsString, IsBool ], 0, 
function( L, alph, b )

    local  alph0, w, lenw, i, j, k, c, q, r, s, len, M;

    alph0 := List( [1..Length(alph)], i -> WordAlp( alph, i ) );
    if ( L = [ ] ) then
        Print( L );
        if ( b = true ) then
            Print( "\n" );
        fi;
    elif IsList( L[1] ) then
        for M in L do
            DisplayAsString( M, alph, b );
        od;
    elif not IsWord( L[1] ) then
        Error( "not a list of words" );
    else
        len := Length( L );
        Print( "[ " );
        for q in [1..len] do
            r := L[q];
            w := ExtRepOfObj( r ); 
            lenw := QuoInt( Length(w), 2 );
            if ( lenw = 0 ) then
                Print( "id" );
            else
                s := "";
                for i in [1..lenw] do
                    j := i+i;
                    c := alph0[w[j-1]];
                    for k in [1..w[j]] do
                        s := Concatenation( s, c );
                    od;
                od;
                Print( s );
            fi;
            if ( q < len ) then
               Print( ", " );
            else
                Print( " ]" );
                if ( b = true ) then
                    Print( "\n" );
                fi;
            fi;
        od;
    fi;
end );

InstallMethod( DisplayRwsRules,
    "generic method for a double coset rewriting system", true, 
    [ IsRewritingSystem ], 0,
function( rws )

    local  numr, t, type, w, k, ok, c, cG, cH, cK, cHK,
           rules, M, num, extended, alph;

    rules := Rules( rws );
    extended := ( HasIsDoubleCosetRewritingSystem( rws ) and
                     IsDoubleCosetRewritingSystem( rws ) );
    M := MonoidOfRewritingSystem( rws );
    num := Length( GeneratorsOfMonoid( M ) );
    if IsBound( rws!.alphabet ) then
        alph := rws!.alphabet;
    else
        alph := KAN_double_coset_group_alphabet{[1..num]};
        if extended then
            alph := Concatenation( "HK", alph );
        fi;
    fi;
    cG:=0;  cH:=0;  cK:=0;  cHK:=0;
    numr := Length( rules );
    type := ListWithIdenticalEntries( numr, 0 ); 
    if extended then
        for k in [1..numr] do
            t := 0;
            w := ExtRepOfObj( rules[k][1] );
            if ( w[1]=1 ) then t:=1; fi;
            if ( w[Length(w)-1]=2 ) then t:=t+2; fi;
            type[k] := t;
            if (t=0) then cG:=cG+1;
            elif (t=1) then cH:=cH+1;
            elif (t=2) then cK:=cK+1;
            else cHK:=cHK+1;
            fi;
        od;
    else
        cG := numr;
    fi;
    c := 0;
    if extended then  Print( "G-rules:\n" );  fi;
    for k in [1..numr] do
        if ( type[k] = 0 ) then
            if (c=0) then Print("[ "); fi;
            c := c+1;
            DisplayAsString( rules[k], alph, false );
            if (c=cG) then Print(" ]\n"); else Print(", "); fi;
        fi;
    od;
    if extended then
        if ( cH > 0 ) then
            c := 0;
            Print( "H-rules:\n" );
            for k in [1..numr] do
                if ( type[k] = 1 ) then
                    if (c=0) then Print("[ "); else Print("  "); fi;
                    c := c+1;
                    DisplayAsString( rules[k], alph, false );        
                if (c=cH) then Print(" ]\n"); else Print(",\n"); fi;
                fi;
            od;
        fi;
        if ( cK > 0 ) then
            c := 0;
            Print( "K-rules:\n" );
            for k in [1..numr] do
                if ( type[k] = 2 ) then
                    if (c=0) then Print("[ "); else Print("  "); fi;
                    c := c+1;
                    DisplayAsString( rules[k], alph, false );   
                if (c=cK) then Print(" ]\n"); else Print(",\n"); fi;
                fi;
            od;
        fi;
        if (cHK > 0 ) then
            c := 0;
            Print( "H-K-rules:\n" );
            for k in [1..numr] do
                if ( type[k] = 3 ) then
                    if (c=0) then Print("[ "); else Print("  "); fi;
                    c := c+1;
                    DisplayAsString( rules[k], alph, false );  
                if (c=cHK) then Print(" ]\n"); else Print(",\n"); fi;
                fi;
            od;
        fi;
    fi;
    return true;
end );

#############################################################################
##
#M  WordAcceptorOfReducedRws
##
InstallMethod( WordAcceptorOfReducedRws, 
    "generic method for an rws", true, [ IsRewritingSystem ], 0,
function( rws )

    local  rules, numr, order, fam, ogens, id, numgens, pf, numpf, 
           i, j, k, l, p, u, v, w, pos, pos2, numstates, sh, row, transmx, 
           rhs, ugens, len, sink, accept, init, alph, alpht, nfa, mfa, 
           ok, ls, lu, perm, IsSuffix;

    IsSuffix := function( u, s )
        ls := Length( s );  lu := Length( u );
        return ( (lu >= ls) and (Subword(u,lu-ls+1,lu) = s) );
    end;

    rules := Rules( rws );
    numr := Length( rules );
    order := OrderingOfRewritingSystem( rws );
    fam := FamilyForRewritingSystem( rws );
    ogens := OrderingOnGenerators( order );
    ugens := List( ogens, g -> true );
    id := One( ogens[1] );
    numgens := Length( ogens );
    if IsBound( rws!.alphabet ) then
        alph := rws!.alphabet;
        alpht := ShallowCopy( alph );
        perm := rws!.gensperm;
        for i in [1..Length(alph)] do
            alpht[i] := alph[i^perm];
        od;
        Info( InfoKan, 2, "alphabet= ", alph, ", twisted alphabet= ", alpht );
    else
        alph := numgens;
    fi;
    pf := [ id ];
    rhs := [ ];
    for k in [1..numr] do
        w := rules[k][2];
        if not ( w = id ) then
            pos := Position( rhs, w );
            if ( pos = fail ) then
                Add( rhs, w );
            fi;
        fi;
        w := rules[k][1];
        len := Length( w );
        if ( len = 1 ) then
            pos := Position( ogens, Subword( w, 1, 1 ) );
            ugens[pos] := false;
        else
            for i in [1..len-1] do
                p := Subword( w, 1, i );
                pos := Position( pf, p );
                if ( pos = fail ) then
                    Add( pf, p );
                fi;
            od;
        fi;
    od;
    numpf := Length( pf );
    Info( InfoKan, 2, "prefixes = ", pf );
    sink := 1;  sh := 1;
    numstates := numpf + sh;
    row := ListWithIdenticalEntries( numstates, 0 );
    transmx := List( [1..numgens], i -> ShallowCopy( row ) );
    for i in [1..numgens] do
        transmx[i][sink] := [ sink ];
        for j in [sh+1..numstates] do 
            if ( ugens[i] = false ) then
                transmx[i][j] := [ sink ];
            else
                transmx[i][j] := [ ];
            fi;
        od;
    od;
    Info( InfoKan, 2, "ogens, ugens and rhs:" );
    Info( InfoKan, 2, ogens );
    Info( InfoKan, 2, ugens );
    Info( InfoKan, 2, rhs );
    ## transitions ##
    for k in [1..numpf] do
        j := k + sh;
        u := pf[k];
        len := Length(u) + 1;
        for i in [1..numgens] do
            v := u * ogens[i];
            ok := true;
            l := 1;
            while ( ok and ( l <= numr ) ) do
                if IsSuffix( v, rules[l][1] ) then
                    transmx[i][j] := [ sink ];
                    ok := false;
                fi;
                l := l+1;
            od;
            if ok then
                for l in [1..len] do
                    p := Subword( v, l, len );
                    pos := Position( pf, p );
                    if not ( pos = fail ) then
                        pos2 := Position( transmx[i][j], pos );
                        if ( pos2 = fail ) then 
                            Add( transmx[i][j], pos+sh );
                        fi;
                    fi;
                od;
            fi;
            if ( transmx[i][j] = [ ] ) then
                Error( "transmx[i][j] = fail" );
            fi;
        od;
    od;
    Info( InfoKan, 2, "transition matrix of acceptor:" );
    Info( InfoKan, 2, transmx );
    accept := [sink];
    init := [ sh+1 ];
    nfa := Automaton( "nondet", numstates, alpht, transmx, init, accept );
    Info( InfoKan, 2, "initial NFA: ", nfa ); 
    Info( InfoKan, 2, "initial NFA has alphabet ", 
                      AlphabetOfAutomatonAsList( nfa ) ); 
    mfa := MinimalAutomaton( ComplementDA( NFAtoDFA( nfa ) ) );
    SetWordAcceptorOfReducedRws( rws, mfa );
    return nfa;
end );

#############################################################################
##
#M  PartialDoubleCosetRewritingSystem
#M  DCrules
#M  DoubleCosetRewritingSystem
##
InstallMethod( DoubleCosetRewritingSystem,
    "generic method for a group, two subgroups, an rws, and a limit",  true, 
    [ IsGroup, IsHomogeneousList,  IsHomogeneousList, IsRewritingSystem ], 0,
function( G, genH, genK, rwsG )
    local dcrws;
    dcrws := PartialDoubleCosetRewritingSystem( G, genH, genK, rwsG, 0 );
    return dcrws;
end );

InstallMethod( DCrules, "generic method for a double coset rws", true, 
    [ IsDoubleCosetRewritingSystem ], 0,
function( dcrws )

    local  order, ogens, rules, hrules, krules, hkrules, m1, m2;

    order := OrderingOfRewritingSystem( dcrws );
    ogens := OrderingOnGenerators( order );
    m1 := ogens[1];
    m2 := ogens[2];
    rules := Rules( dcrws );
    hrules := Filtered( rules, r -> Subword(r[1],1,1) = m1 );
    krules := Filtered( rules, 
        r -> Subword(r[1],Length(r[1]),Length(r[1])) = m2 );
    hkrules := Filtered( krules, r -> Subword(r[1],1,1) = m1 );
    hrules := Difference( hrules, hkrules );
    krules := Difference( krules, hkrules );
    SetHrules( dcrws, hrules );
    SetKrules( dcrws, krules );
    SetHKrules( dcrws, hkrules );
    return true;
end );

InstallMethod( PartialDoubleCosetRewritingSystem,
    "generic method for a group, two subgroups, etc.",  true, 
    [ IsGroup, IsHomogeneousList, IsHomogeneousList,  IsRewritingSystem,
      IsInt ], 0,
function( G, genH, genK, rwsG, limit )

    local  gensord, order, fG, rels, genG, genfG, numgenG, numgenfG, 
           genfM, genfH, genfK, alph, alpht, alph2, mhom, M, genM, 
           numgenM, range, fM, ord, perm, rules, numrules, numgensF2, 
           F2, genF2, numH, numK, extrules, printmax, i, j, l, el, r, 
           er, lene, n, e, h, h1, k, k1, fam2, M2, genM2, numgenM2, 
           range2, ord2, rws2, fM2, genfM2, L2, perm2, plus;

    printmax := 40;
    ord := OrderingOfRewritingSystem( rwsG );
    if ( HasIsShortLexOrdering( ord ) and IsShortLexOrdering( ord ) ) then
        order := "shortlex";
    elif ( HasIsBasicWreathProductOrdering( ord ) and
           IsBasicWreathProductOrdering( ord ) ) then
        order := "wreath";
    fi;
    alph := rwsG!.alphabet;
    gensord := OrderingOnGenerators( ord );
    alpht := ShallowCopy( alph );
    if ( HasReducedConfluentRewritingSystem( G ) 
         or HasInitialRewritingSystem( G ) ) then
        perm := rwsG!.gensperm;
    elif HasKBMagWordAcceptor( G ) then
        perm := KBMagWordAcceptor( G )!.gensperm;
    else
        Error( "no gensperm with which to permute the alphabet" );
    fi;
    for i in [1..Length(alph)] do
        alpht[i] := alph[i^perm];
    od;
    fG := FreeGroupOfFpGroup( G );
    rels := RelatorsOfFpGroup( G );
    genG := GeneratorsOfGroup( G );
    genfG := GeneratorsOfGroup( fG );
    numgenG := Length( genG );
    numgenfG := Length( genfG );
    if ( numgenG <> numgenfG ) then
        Error( "unequal numbers of generators" );
    fi;
    genfH := List( genH, h -> MappedWord( h, genG, genfG ) );
    genfK := List( genK, k -> MappedWord( k, genG, genfG ) );
    mhom := IsomorphismFpMonoid( G );
    M := Image( mhom );
    genM := GeneratorsOfMonoid( M );
    fM := FreeMonoidOfFpMonoid( M );
    genfM := GeneratorsOfMonoid( fM );
    numgenM := Length( genM );
    if ( numgenM = Length( gensord ) ) then
        range := List( gensord, x -> Position( genfM, x ) );
    else
        range := 0 * [1..numgenM];
        for i in [1..numgenG] do
            range[i] := 2*i;
            range[i+numgenG] := 2*i-1;
        od;
    fi;
    Info( InfoKan, 2, "using range = ", range );
    if ( order = "shortlex" ) then
        ord := ShortLexOrdering( fM, range );
    elif ( order = "wreath" ) then
        ord := BasicWreathProductOrdering( fM, range );
    else
        Error( "the given order should be \"shortlex\" or \"wreath\"" );
    fi;
    rules := Rules( rwsG );
    numrules := Length( rules );
    Info( InfoKan, 2, "Rules of ", order, " rewriting system:" );
    if ( InfoLevel( InfoKan ) >= 2 ) then
        if ( numrules <= printmax )  then
            DisplayRwsRules( rwsG );
        else
            Print( "number of rules = ", numrules, "\n" );
        fi;
    fi;
    alph2 := Concatenation( "HK", alph );
    Info( InfoKan, 2, "setting alphabet alph2 = ", alph2 );
    numgensF2 := numgenM + 2;
    F2 := FreeMonoid( numgensF2 );
    genF2 := GeneratorsOfMonoid( F2 );
    numH := Length( genH );
    numK := Length( genK );
    plus := 2*(numH + numK);
    extrules := 0 * [1..(plus+numrules)];
    fam2 := FamilyObj( One( F2 ) );
    for i in [1..numrules] do
        el := ShallowCopy( ExtRepOfObj( rules[i][1] ) );
        lene := QuoInt( Length( el ), 2 );
        for j in [1..lene] do
             el[j+j-1] := el[j+j-1] + 2;
        od;
        l := ObjByExtRep( fam2, el );
        er := ShallowCopy( ExtRepOfObj( rules[i][2] ) );
        lene := QuoInt( Length( er ), 2 );
        for j in [1..lene] do
             er[j+j-1] := er[j+j-1] + 2;
        od; 
        r := ObjByExtRep( fam2, er );
        extrules[plus + i] := [ l, r ];
    od;
    n := 0;
    for h in genH do
        n := n+1;
        e := ShallowCopy( ExtRepOfObj( h ) );
        for i in [1..QuoInt( Length(e), 2 ) ] do
            j := i+i;
            e[j-1] := 2*e[j-1] + 2;
            if ( e[j] < 0 ) then
                e[j] := - e[j];
                e[j-1] := e[j-1] - 1;
            fi;
        od;
        e := Concatenation( [ 1, 1 ], e );
        extrules[n] := [ ObjByExtRep( fam2, e ), genF2[1] ];
        h1 := h^-1;
        n := n+1;
        e := ShallowCopy( ExtRepOfObj( h1 ) );
        for i in [1..QuoInt( Length(e), 2 ) ] do
            j := i+i;
            e[j-1] := 2*e[j-1] + 2;
            if ( e[j] < 0 ) then
                e[j] := - e[j];
                e[j-1] := e[j-1] - 1;
            fi;
        od;
        e := Concatenation( [ 1, 1 ], e );
        extrules[n] := [ ObjByExtRep( fam2, e ), genF2[1] ];
    od;    
    for k in genK do
        n := n+1;
        e := ShallowCopy( ExtRepOfObj( k ) );
        for i in [1..QuoInt( Length(e), 2 ) ] do
            j := i+i;
            e[j-1] := 2*e[j-1] + 2;
            if ( e[j] < 0 ) then
                e[j] := - e[j];
                e[j-1] := e[j-1] - 1;
            fi;
        od;
        e := Concatenation( e, [ 2, 1 ] );
        extrules[n] := [ ObjByExtRep( fam2, e ), genF2[2] ];
        k1 := k^-1;
        n := n+1;
        e := ShallowCopy( ExtRepOfObj( k1 ) );
        for i in [1..QuoInt( Length(e), 2 ) ] do
            j := i+i;
            e[j-1] := 2*e[j-1] + 2;
            if ( e[j] < 0 ) then
                e[j] := - e[j];
                e[j-1] := e[j-1] - 1;
            fi;
        od;
        e := Concatenation( e, [ 2, 1 ] );
        extrules[n] := [ ObjByExtRep( fam2, e ), genF2[2] ];
        k1 := k^-1;
    od;
    if not ( n = plus ) then
        Error( "expecting plus = n" );
    fi; 
    numrules := Length( rules );
    Info( InfoKan, 2, "Rules of ", order, " extended rewriting system:" );
    if ( InfoLevel( InfoKan ) >= 2 ) then
        if ( Length(extrules) <= printmax )  then
            DisplayAsString( extrules, alph2, true );
        else
            Print( "number of rules = ", Length(extrules), "\n" );
        fi;
    fi;

    M2 := F2/extrules;
    genM2 := GeneratorsOfMonoid( M2 );
    numgenM2 := Length( genM2 );
    range2 := Concatenation( [1,2], List( range, j -> j+2 ) );
    if ( order = "shortlex" ) then
        ord2 := ShortLexOrdering( F2, range2 );
    elif ( order = "wreath" ) then
        Info( InfoKan, 2, "using wreath product ordering" );
        ord2 := BasicWreathProductOrdering( F2, range2 );
    else
        Error( "expecting order to be \"shortlex\" or \"wreath\"" );
    fi;
    L2 := Concatenation( [1,2], List( ListPerm(perm), i -> i+2 ) );
    perm2 := PermList( L2 );
    rws2 := ReducedConfluentRewritingSystem( M2, ord2, limit );
    rws2!.alphabet := alph2;
    rws2!.gensperm := perm2;
    if ( InfoLevel( InfoKan ) > 3 ) then   
        DisplayRwsRules( rws2 );
    fi;
    fM2 := FreeMonoidOfFpMonoid( M2 );
    genfM2 := GeneratorsOfMonoid( fM2 );
    SetIsDoubleCosetRewritingSystem( rws2, true );
    return rws2;
end );

#############################################################################
##          need to define  One  for DCRws  as  HK  or  Tt                 ##
#############################################################################

#############################################################################
##
#M  IdentityDoubleCoset
#M  NextWord
##
InstallMethod( IdentityDoubleCoset, "generic method for a double coset rws",
    true, [ IsDoubleCosetRewritingSystem ], 0, 
function( dcrws )

    local  ord, gens, w;
    ord := OrderingOfRewritingSystem( dcrws );
    gens := ShallowCopy( OrderingOnGenerators( ord ) );
    w := gens[1]*gens[2];
    return w;
end );

InstallMethod( NextWord, "generic method for a rws and a group", 
    true, [ IsRewritingSystem, IsWord ], 0,
function( rws, w )

    local  ord, fam, famw, gens, ogens, num, id, v, lenv, eu, j, 
           lastg, lastp, u, rfu, ok;

    ord := OrderingOfRewritingSystem( rws );
    gens := OrderingOnGenerators( ord );
    ogens := List( gens, g -> ExtRepOfObj( g )[1] );
    SortParallel( ogens, gens );
    num := Length( gens );
    fam := FamilyObj( gens[1] );
    if not ( fam = FamilyObj( w ) ) then
        Error( "word not in correct family" );
    fi;
    id := One( gens[1] );
    ok := false;
    u := w;
    while not ok do
        ok := true;
        v := u;
        lenv := Length(v);
        if ( lenv = 0 ) then 
             u := gens[1]; 
        else
            eu := ShallowCopy( ExtRepOfObj( v ) );
            j := Length( eu );
            lastg := eu[j-1];
            lastp := eu[j];
            if (lastg < num ) then
                if ( lastp = 1 ) then
                    eu[j-1] := lastg + 1;
                else
                    eu[j] := lastp - 1;
                    eu := Concatenation( eu, [ lastg+1, 1 ] );
                fi;
            else  ## lastg = num ##
                if ( j = 2 ) then
                    eu := [ 1, lastp+1 ];
                else
                    j := j-2;
                    if ( eu[j] = 1 ) then
                        eu[j-1] := eu[j-1] + 1;
                        eu[j+1] := 1;
                    else
                        eu[j] := eu[j] - 1;
                        eu[j+1] := eu[j-1] + 1;
                        eu[j+2] := 1;
                        eu := Concatenation( eu, [ 1, lastp ] );
                    fi;
                fi;
            fi;
            u := ObjByExtRep( fam, eu );
        fi;
        rfu :=  ReducedForm( rws, u );
        ok := ( u = rfu );
    od;
    return u;
end );

InstallMethod( NextWord, "generic method for a double coset rws and a group", 
    true, [ IsDoubleCosetRewritingSystem, IsWord ], 0,
function( rws, w )

    local  ord, fam, famw, gens, ogens, num, id, v, lenv, eu, j, 
           lastg, lastp, u, rfu, ok, max_number_of_attempts, count;

    max_number_of_attempts := 10000;
    ord := OrderingOfRewritingSystem( rws );
    gens := ShallowCopy( OrderingOnGenerators( ord ) );
    ogens := List( gens, g -> ExtRepOfObj( g )[1] );
    SortParallel( ogens, gens );
    num := Length( gens );
    fam := FamilyObj( gens[1] );
    if not ( fam = FamilyObj( w ) ) then
        Error( "word not in correct family" );
    fi;
    id := One( gens[1] );
    ok := false;
    u := w;
    count := 0;
    while not ok do
        ok := true;
        v := u;
        lenv := Length(v);
        if ( lenv = 2 ) then
            u := gens[1] * gens[3] * gens[2];
        else
            eu := ShallowCopy( ExtRepOfObj( v ) );
            j := Length( eu ) - 2;
            lastg := eu[j-1];
            lastp := eu[j];
            if ( lastg < num ) then
                if ( lastp = 1 ) then
                    eu[j-1] := lastg + 1;
                else
                    eu[j] := lastp - 1;
                    eu[j+1] := lastg + 1;
                    eu := Concatenation( eu, [ 2, 1 ] );
                fi;
            else  ## lastg = num ##
                if ( j = 4 ) then
                    eu := [ 1, 1, 3, lastp+1, 2, 1 ];
                else
                    j := j-2;
                    if ( eu[j] = 1 ) then
                        eu[j-1] := eu[j-1] + 1;
                        eu[j+1] := 3;
                    else
                        eu[j] := eu[j] - 1;
                        eu[j+1] := eu[j-1] + 1;
                        eu[j+2] := 1;
                        eu[j+3] := 3;
                        eu[j+4] := lastp;
                        eu := Concatenation( eu, [ 2, 1 ] );
                    fi;
                fi;
            fi;
            u := ObjByExtRep( fam, eu );
        fi;
        rfu :=  ReducedForm( rws, u );
        count := count + 1;
        ##  ok := ( ( u = rfu ) or ( count > max_number_of_attempts ) );
        ok := ( u = rfu );
    od;
    ##  if ( count > max_number_of_attempts ) then return fail;
    ##                                        else return u; fi;
    return u;
end );

#############################################################################
##
#M  WordAcceptorOfDoubleCosetRws
##
InstallMethod( WordAcceptorOfDoubleCosetRws,
    "generic method for a double coset rewriting system",
    true, [ IsDoubleCosetRewritingSystem ], 0,
function( rws )

    local  rules, numr, order, fam, ogens, ugens, numgens, range, type, 
           a, c, g, i, j, k, l, m, n, p, q, s, t, u, v, w, lq, ls, lu, lw, 
           cG, cH, cK, cHK, posG, posH, posK, posHK, id, alph, alpht, perm, 
           ok, pfG, pfH, sfK, pfHK, npfG, npfH, nsfK, npfHK, printmax,
           wG, wH, wK, wHK, numstates, lr, len, sublr, pos, pos2, 
           row, transmx, shG, shH, shK, shHK, accept, nfa, dfa, cdfa, mdfa,
           init, sink, done, stateG, stateH, stateK, stateHK, 
           IsSuffix;

    IsSuffix := function( u, s )
        ls := Length( s );  lu := Length( u );
        return ( (lu >= ls) and (Subword(u,lu-ls+1,lu) = s) );
    end;

    printmax := 30;
    rules := Rules( rws );
    if ( ( InfoLevel(InfoKan) > 1 ) and ( Length(rules) < 51 ) )then
        Print( "rules of double coset rewriting system:\n" );
        DisplayRwsRules( rws );
    else
        Info( InfoKan, 2, "there are ", Length( rules ), " rules" );
    fi;
    numr := Length( rules );
    type := ListWithIdenticalEntries( numr, 0 );;
    order := OrderingOfRewritingSystem( rws );
    fam := FamilyForRewritingSystem( rws );
    ogens := OrderingOnGenerators( order );
    ugens := List( ogens, g -> true );
    id := One( ogens[1] );
    numgens := Length( ogens );
    alph := rws!.alphabet;
    alpht := ShallowCopy( alph );
    perm := rws!.gensperm;
    for i in [3..Length(alph)] do
        alpht[i] := alph[i^perm];
    od;
    Info( InfoKan, 2, "alphabet = ", alph, ", twisted alphabet = ", alpht );
    cG:=0;  cH:=0;  cK:=0;  cHK:=0;
    posG := [ ];  posH := [ ];  posK := [ ];  posHK := [ ];
    for k in [1..numr] do
        t := 0;
        w := ExtRepOfObj( rules[k][1] );
        Info( InfoKan, 3, "w = ", w );
        if ( w[1]=1 ) then t:=1; fi;
        if ( w[Length(w)-1]=2 ) then t:=t+2; fi;
        type[k] := t;
        if (t=0) then cG:=cG+1; Add(posG,k);
        elif (t=1) then cH:=cH+1; Add(posH,k);
        elif (t=2) then cK:=cK+1; Add(posK,k);
        else cHK:=cHK+1; Add(posHK,k);
        fi;
    od;
    Info( InfoKan, 2, "[cG,cH,cK,cHK] = ", [cG,cH,cK,cHK] );
    Info( InfoKan, 2, " posG = ", posG );
    Info( InfoKan, 2, " posH = ", posH );
    Info( InfoKan, 2, " posK = ", posK );
    Info( InfoKan, 2, "posHK = ", posHK );
    if ( numr <= printmax ) then
        Info( InfoKan, 2, "type = ", type );
    fi;
    pfG:=[ id ];  pfH:=[ id ];  sfK:=[ id ];  pfHK:=[ id ];
    wG:=0*[1..cG];  wH:=0*[1..cH];  wK:=0*[1..cK];  wHK:=0*[1..cHK];
    cG:=0;  cH:=0;  cK:=0;  cHK:=0;
    for k in [1..numr] do
        lr := rules[k][1];
        len := Length( lr );
        if ( type[k] = 0 ) then  ## G rule ##
            if ( len = 1 ) then
                pos := Position( ogens, Subword( lr, 1, 1 ) );
                ugens[pos] := false;
            else
                for i in [1..len-1] do
                    sublr := Subword( lr, 1, i );
                    pos := Position( pfG, sublr );
                    if ( pos = fail ) then Add( pfG, sublr); fi;
                od;
            fi;
            cG := cG+1;
            wG[cG] := lr;
        elif ( type[k] = 1 ) then  ## H rule ##
            for i in [2..len-1] do
                sublr := Subword( lr, 2, i );
                pos := Position( pfH, sublr );
                if ( pos = fail ) then Add( pfH, sublr); fi;
            od;
            cH := cH+1;
            wH[cH] := lr;
        elif ( type[k] = 2 ) then  ## K rule ##
            for i in [2..len-1] do
                sublr := Subword( lr, i, len-1 );
                pos := Position( sfK, sublr );
                if ( pos = fail ) then Add( sfK, sublr); fi;
            od;
            cK := cK+1;
            wK[cK] := lr;
        else  ## HK rule ##
            for i in [2..Length(lr)-1] do
                sublr := Subword( lr, 2, i );
                pos := Position( pfHK, sublr );
                if ( pos = fail ) then Add( pfHK, sublr); fi;
            od;
            cHK := cHK+1;
            wHK[cHK] := lr; 
        fi;
    od;
    if ( numr <= printmax ) then
        Info( InfoKan, 2, "[wG, wH, wK, wHK] =" );
        Info( InfoKan, 2, wG );
        Info( InfoKan, 2, wH );
        Info( InfoKan, 2, wK );
        Info( InfoKan, 2, wHK );
        Info( InfoKan, 2, "[pfG, pfH, sfK, pfHK] =" );
        Info( InfoKan, 2, pfG );
        Info( InfoKan, 2, pfH );
        Info( InfoKan, 2, sfK );
        Info( InfoKan, 2, pfHK );
    fi;
    Info( InfoKan, 2, "ogens = ", ogens );
    npfG := Length( pfG );
    npfH := Length( pfH );
    nsfK := Length( sfK );
    npfHK := Length( pfHK );
    init := 1;  done := 2;  sink := 3;  shG := 3;
    stateG := shG+1;  shH := shG+npfG; 
    stateH := shH+1;  shK := shH+npfH;
    stateK := shK+1;  shHK := shK+nsfK;  
    stateHK := shHK+1;
    numstates := shG + npfG + npfH + nsfK + npfHK;
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
    ## G transitions ##
    for j in [shG+1..shH] do
        transmx[2][j] := [done];
    od;
    for k in [1..npfG] do
        j := k + shG;
        u := pfG[k];
        len := Length(u) + 1;
        for i in [3..numgens] do
            v := u * ogens[i];
            ok := true;
            l := 1;
            while ( ok and ( l <= cG ) ) do
                if IsSuffix( v, rules[posG[l]][1] ) then
                    transmx[i][j] := [sink];
                    ok := false;
                fi;
                l := l+1;
            od;
            if ok then
                for l in [1..len] do
                    p := Subword( v, l, len );
                    pos := Position( pfG, p );
                    if not ( pos = fail ) then
                        pos2 := Position( transmx[i][j], pos );
                        if ( pos2 = fail ) then
                            Add( transmx[i][j], pos+shG );
                        fi;
                    fi;
                od;
            fi;
            if ( transmx[i][j] = [ ] ) then
                Error( "transmx[i][j] = fail" );
            fi;
        od;
    od;
    ## H transitions ##
    for k in [2..npfH] do
        q := pfH[k];  lq := Length(q);
        a := Subword( q, lq, lq );
        i := Position( ogens, a );
        p := Subword( q, 1, lq-1 );
        pos := Position( pfH, p );
        Add( transmx[i][pos+shH], k+shH );
    od;
    for w in wH do
        lw := Length(w);
        a := Subword( w, lw, lw );
        i := Position( ogens, a );
        p := Subword( w, 2, lw-1 );
        pos := Position( pfH, p );
        transmx[i][pos+shH] := [sink];
    od;
    ## K transitions ##
    for k in [2..nsfK] do
        q := sfK[k];  lq := Length(q);
        a := Subword( q, 1, 1 );
        i := Position( ogens, a );
        p := Subword( q, 2, lq );
        pos := Position( sfK, p );
        Add( transmx[i][k+shK], pos+shK );
    od;
    ##  for i in [1..numgens] do transmx[i][shK+1] := [sink]; od;
    transmx[2][stateK] := [sink];
    ## transitions to K-leaves ##
    for w in wK do
        a := Subword( w, 1, 1 );
        p := Subword( w, 2, Length(w)-1 );
        pos := Position( sfK, p );
        i := Position( ogens, a );
        for k in [1..npfG] do
            j := k + shG;
            if ( transmx[i][j] <> [sink] ) then
                Add( transmx[i][j], pos+shK );
            fi;
        od;
    od;
    ## HK transitions ##
    for k in [2..npfHK] do
        q := pfHK[k];  lq := Length(q);
        a := Subword( q, lq, lq );
        i := Position( ogens, a );
        p := Subword( q, 1, lq-1 );
        pos := Position( pfHK, p );
        Add( transmx[i][pos+shHK], k+shHK );
    od;
    for w in wHK do
        p := Subword( w, 2, Length(w)-1 );
        pos := Position( pfHK, p );
        transmx[2][pos+shHK] := [sink];
    od;
    accept := Difference( [1..numstates], [done] );
    nfa := Automaton( "nondet", numstates, alpht, transmx, [init], accept );
    if ( nfa!.states < 51 ) then 
        Info( InfoKan, 2, "initial NFA: ", nfa );
    else
        Info( InfoKan, 2, "initial NFA has ", nfa!.states, " states" );
    fi;
    #?  (12/11/08)  added fixes while awaiting automata.1.12
    Info( InfoKan, 2, "initial NFA has alphabet ", 
                      AlphabetOfAutomatonAsList( nfa ) ); 
    dfa := NFAtoDFA( nfa );
    Info( InfoKan, 2, "DFA of NFA has alphabet ", 
                      AlphabetOfAutomatonAsList( dfa ) ); 
    if ( dfa!.states < 51 ) then 
        Info( InfoKan, 2, "DFA from NFA:", dfa );
    else
        Info( InfoKan, 2, "DFA from NFA has ", dfa!.states, " states" );
    fi;
    cdfa := ComplementDA( dfa );
    Info( InfoKan, 2, "complement of DFA has alphabet ", 
                      AlphabetOfAutomatonAsList( cdfa ) ); 
    if ( cdfa!.states < 51 ) then 
        Info( InfoKan, 2, "complement of DFA:", cdfa );
    else
        Info( InfoKan, 2, "complement of DFA has ", cdfa!.states, " states" );
    fi;
    mdfa := MinimalAutomaton( cdfa ); 
    Info( InfoKan, 2, "minimalized cdfa has alphabet ", 
                      AlphabetOfAutomatonAsList( mdfa ) ); 
    if ( mdfa!.states < 51 ) then 
        Info( InfoKan, 2, "minimal automaton of complement of DFA", mdfa );
    else
        Info( InfoKan, 2, "minimal automaton of complement of DFA has ", 
            mdfa!.states, " states" );
    fi;
    SetIsWordAcceptorOfDoubleCosetRws( rws, true );
    SetRewritingSystemOfWordAcceptor( mdfa, rws );
    SetWordAcceptorOfDoubleCosetRws( rws, mdfa );
    return mdfa;
end );

###########################################################################
##
#M  WordAcceptorOfPartialDoubleCosetRws
##
##  this method requires G to already have a complete rewrite system,
##  generators for H and K should be supplied, plus a limit on #rules
##
InstallMethod( WordAcceptorOfPartialDoubleCosetRws,
    "generic method for a double coset rewriting system", true, 
    [ IsGroup, IsDoubleCosetRewritingSystem ], 0,
function( G, dcrws )

    local  rwsG, gensord, ord, alph, alpht, alph2, perm, perm2, alpht2, 
           rules, numr, fam, order, ogens, ugens, numgens, range, type, 
           a, c, g, i, j, k, l, m, n, p, q, r, s, t, u, v, w, 
           lq, ls, lu, lw, M, genM, numgenM, fM, genfM, m1, m2, oldinit, 
           accG, transG, numstG, numH, numK, numHK, hrules, krules, hkrules,
           id, ok, printmax, fhrules, fkrules, fhkrules,
           numstates, lr, len, sublr, pos, pos2, shG, shH, shK, shHK, 
           pfH, sfK, pfHK, npfH, nsfK, npfHK, 
           row, transmx, accept, nfa, dfa, cdfa, mdfa, 
           init, nonacc, oldsink, sink, done, 
           stateG, stateH, stateK, stateHK;

    if not HasReducedConfluentRewritingSystem( G ) then
        Error( "make a ReducedConfluentRewritingSystem( G ) first" );
    fi;
    rwsG := ReducedConfluentRewritingSystem( G );
    alph := rwsG!.alphabet;
    alpht := ShallowCopy( alph );
    perm := rwsG!.gensperm;
    for i in [1..Length(alph)] do
        alpht[i] := alph[i^perm];
    od;
    Info( InfoKan, 2, "alphabet = ", alph, ", twisted alphabet = ", alpht );
    gensord := OrderingOfRewritingSystem( rwsG );
    ord := OrderingOnGenerators( gensord );
    accG := WordAcceptorOfReducedRws( rwsG );
    Info( InfoKan, 3, "WordAcceptor of group:", accG );
    ##  dcrws := PartialDoubleCosetRewritingSystem
    ##               ( G, genH, genK, gensord, ord, limit );
    rules := Rules( dcrws );
    numr := Length( rules );
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
    hrules := Filtered( rules, r -> Subword(r[1],1,1) = m1 );
    krules := Filtered( rules, 
        r -> Subword(r[1],Length(r[1]),Length(r[1])) = m2 );
    hkrules := Filtered( krules, r -> Subword(r[1],1,1) = m1 );
    hrules := Difference( hrules, hkrules );
    krules := Difference( krules, hkrules );
    Info( InfoKan, 2, "H-rules, K-rules, HK-rules =" );
    Info( InfoKan, 2, hrules );
    Info( InfoKan, 2, krules );
    Info( InfoKan, 2, hkrules );

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
    Info( InfoKan, 2, "initial transmx", transmx );
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
    #?  (12/11/08)  added fixes while awaiting automata.1.12
    dfa := NFAtoDFA( nfa );
    Info( InfoKan, 2, "DFA from NFA:" );
    Info( InfoKan, 2, dfa );
    cdfa := ComplementDA( dfa );
    mdfa := MinimalAutomaton( cdfa );
    return mdfa;
end );

#############################################################################
##
#M  DoubleCosetsAutomaton
#M  RightCosetsAutomaton 
##
##  should use these to make DoubleCosetsNC and RightCosetsNC: these were 
##  the original names, but changed 04/04/06 to fix a conflict with Gpd
##
InstallMethod( DoubleCosetsAutomaton, "for an fp-group with rewriting system", 
    true, 
    [ IsFpGroup and HasReducedConfluentRewritingSystem, IsGroup, IsGroup ], 0,
function( G, U, V )
    local genU, genV, rws, dcrws, dcwa;
    Info( InfoKan, 2, "in first Kan version of DoubleCosetsAutomaton" );
    genU := GeneratorsOfGroup( U );
    genV := GeneratorsOfGroup( V );
    rws := ReducedConfluentRewritingSystem( G );
    dcrws := DoubleCosetRewritingSystem( G, genU, genV, rws );
    dcwa := WordAcceptorOfDoubleCosetRws( dcrws );
    return dcwa;
end );

InstallMethod( DoubleCosetsAutomaton, "for an infinite fp-group", true, 
    [ IsFpGroup, IsGroup, IsGroup ], 0,
function( G, U, V )
    local genG, len, i, L, Aa, alph, genU, genV, rws, dcrws, dcwa;
    if IsFinite( G ) then
        TryNextMethod();
    fi;
    Info( InfoKan, 2, "in second Kan version of DoubleCosetsAutomaton" );
    genG := GeneratorsOfGroup( G );
    len := Length( genG );
    L := [1..2*len];
    for i in [1..len] do
        L[2*i] := 2*i-1;
        L[2*i-1] := 2*i;
    od;
    rws := ReducedConfluentRewritingSystem( G, L, "shortlex", 0 );
    if ( rws = fail ) then
        TryNextMethod();
    fi;
    Aa := "Aa";
    alph := "Aa";
    for i in [2..len] do
        alph := Concatenation( alph, Aa );
    od;
    for i in [3..2*len] do
        alph[i] := CHAR_INT( INT_CHAR(alph[i])+1 );
    od;
    rws := ReducedConfluentRewritingSystem( G );
    rws!.alphabet := alph; 
    genU := GeneratorsOfGroup( U );
    genV := GeneratorsOfGroup( V );
    dcrws := DoubleCosetRewritingSystem( G, genU, genV, rws );
    dcwa := WordAcceptorOfDoubleCosetRws( dcrws );
    return dcwa;
end );

InstallMethod( RightCosetsAutomaton, "for an fp-group with rewriting system", 
    true, [ IsFpGroup and HasReducedConfluentRewritingSystem, IsGroup ], 0,
function( G, V )
    local one, genV, rws, dcrws, dcwa;
    Info( InfoKan, 2, "in first Kan version of RightCosetsAutomaton" );
    one := One( G );
    genV := GeneratorsOfGroup( V );
    rws := ReducedConfluentRewritingSystem( G );
    dcrws := DoubleCosetRewritingSystem( G, [one], genV, rws );
    dcwa := WordAcceptorOfDoubleCosetRws( dcrws );
    return dcwa;
end );

InstallMethod( RightCosetsAutomaton, "for an infinite fp-group", true, 
    [ IsFpGroup, IsGroup ], 0,
function( G, V )
    local  one;
    if IsFinite( G ) then
        TryNextMethod();
    fi;
    Info( InfoKan, 2, "in second Kan version of RightCosetsAutomaton" );
    one := One( G );
    return DoubleCosetsAutomaton( G, Subgroup(G,[one]), V );
end );

#############################################################################
## 
#E  dcrws.gi . . . .  . . . . . . . . . . . . . . . . . . . . . . . ends here 
## 
