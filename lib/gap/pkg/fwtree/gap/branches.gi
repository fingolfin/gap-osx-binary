LEFT := "("; RIGHT := ")";

ConstructBranch := function( G, branch, exclude, rwo )
    local desc, p, s, d, exclude_p_classes, foo, bar, c, x, pos, obltest;
    
    p := PrimePGroup( G );
    c := PClassPGroup( G );
    
    List( exclude, PrimePGroup );
    exclude_p_classes := List( exclude, PClassPGroup );
    
    Append( branch, [ rec(
            group := G, 
            class := NilpotencyClassOfGroup( G ),
            size := Size( G ),
            gamma := LCSFactorTypes( G ) ) ]);
    Append( branch, [ LEFT ] );
    
    if rwo[3] = 0 then
        obltest := HasObliquityZero;
    else
        obltest := x -> Obliquity(x) = rwo[3];
    fi;
    
    Print( "ConstructBranch: root-p-class: ", c, "\n" );
    
    for s in [ 1 .. rwo[2] ] do
        desc := PqDescendants( G : Prime := p, StepSize := s );
        foo := Length( desc );
        Print( "Constructed ", foo, " ", s, "-step descendants.\n" );
        
        Exec( "killall pq 2>/dev/null" );
        if CHECK_OBLIQUITY then
            desc := Filtered( desc, obltest );
            #if foo - Length( desc ) > 0 then
            #    Error( "Removed ", foo - Length( desc ), 
            #           " with obliquity > 0.\n" );
            #fi;
        fi;
        
        if CHECK_RANK then
#           foo := Length( desc );
            desc := Filtered( desc, x -> SubgroupRank(x) = rwo[1] );
            #if foo - Length( desc ) > 0 then
            #    Error( "Additionally, removed ", foo - Length ( desc ), 
            #           " with rank > 3.\n" );
            #fi;
        fi;
        
        foo := Length( desc );
        for x in exclude do
            pos := PositionProperty( desc, k -> IsIsomorphicPGroup( x, k ) );
            if pos <> fail then
                Remove( desc, pos );
            fi;
        od;

        for d in desc do
            Append( branch, [ s ] );
            ConstructBranch( d, branch, exclude, rwo );
        od;
    od;

    Append( branch, [ RIGHT ] );
end;

ConstructBoundedDescendants := function( g, branch, classbound, rwo)
    local desc, p, s, d, foo, bar, c, x, obltest;
    
    p := PrimePGroup( g );
    c := PClassPGroup( g );
    
    Append( branch, [ rec(
            group := g, class := NilpotencyClassOfGroup( g ),
                        size := Size( g ),
                        gamma := LCSFactorTypes( g ) 
                        ) ]
                     );
    
    if c >= classbound then
        Append( branch, [ LEFT, RIGHT ] );
        return;
    fi;

    if rwo[3] = 0 then
        obltest := HasObliquityZero;
    else
        obltest := x -> Obliquity(x) = rwo[3];
    fi;

    Append( branch, [ LEFT ] );
    Print( "ConstructBoundedDescendants: root-p-class: ", c, "\n" );
    
    for s in [ 1 .. rwo[2] ] do
        desc := PqDescendants( g #Image( IsomorphismPcGroup( g ) )
                        : Prime := p, StepSize := s );
        
        foo := Length( desc );
        Print( "Constructed ", foo, " ", s, "-step descendants.\n" );
        
        Exec( "killall pq 2>/dev/null" );
        if CHECK_OBLIQUITY then
            desc := Filtered( desc, obltest );
            # if foo - Length( desc ) > 0 then
            #   Error( "Removed ", foo - Length( desc ), 
            #           " with obliquity > 0.\n" );
            # fi;
        fi;
        
        if CHECK_RANK then
            # foo := Length( desc );
            desc := Filtered( desc, x -> SubgroupRank(x) = rwo[1] );
            # if foo - Length( desc ) > 0 then
            #    Error( "Additionally, removed ", foo - Length ( desc ), 
            #           " with rank > 3.\n" );
            # fi;
        fi;
        
        for d in desc do
            Append( branch, [ s ] );
            ConstructBoundedDescendants( d, branch, classbound, rwo );
        od;
    od;

    Append( branch, [ RIGHT ] );
end;

BranchRWO := function( g, i, rwo )
    local l, this, next, branch, time;
    
    time := Runtime();
    g := Image( IsomorphismPcGroup( g ) );
    this := Pq( g : Prime := PrimePGroup( g ), ClassBound := i - 1 );
    next := Pq( g : Prime := PrimePGroup( g ), ClassBound := i );
    
    branch := [];
    ConstructBranch( this, branch, [ next ], rwo );
    Print( "time: ", StringTime(Runtime() - time), "\n" );
    return branch;
end;

BoundedDescendantsRWO := function( g, i, classbound, rwo )
    local l, this, next, branch;
    g := Image( IsomorphismPcGroup( g ) );
    this := Pq( g : Prime := PrimePGroup( g ), ClassBound := i - 1 );
    
    branch := [];
    ConstructBoundedDescendants( this, branch, classbound, rwo );
    return branch;
end;

AsciiBranchTo := function( file, branch )
    local l, x, indent, i;
    
    l := Filtered( branch, x -> not IsRecord( x ) );
    AppendTo( file, "*\n" );
    indent := 0;
    for x in l do
        if x = LEFT then
            for i in [ 1 .. indent ] do
                AppendTo( file, "\t" );
            od;
            AppendTo( file, "(\n" );
            indent := indent + 1;
        elif x = RIGHT then
            indent := indent - 1;
        for i in [ 1 .. indent ] do
            AppendTo( file, "\t" );
        od;
            AppendTo( file, ")\n\n" );
        else 
            for i in [ 1 .. indent ] do
                AppendTo( file, "\t" );
            od;
            AppendTo( file, x, "\n" );
        fi;
    od;
    AppendTo( file, "\n" );
end;

SaveBranch := function( file, branch )
    local f;
    f := function( x )
        local c;
        if IsRecord( x ) then
            c := ShallowCopy( x );
            Unbind( c.group );
            return c;
        else
            return x;
        fi;            
    end;
    PrintTo( file, List( branch, f ) );
end;

LoadBranch := function( file )
    local branch;
    PrintTo("/tmp/rwo", "return\n");
    Exec("cat ", file, ">>/tmp/rwo");
    AppendTo("/tmp/rwo",";\n");
    branch := ReadAsFunction("/tmp/rwo")();
    return branch;
end;

AsciiBranch := function( branch )
    AsciiBranchTo( "/dev/stdout", branch );
end;
