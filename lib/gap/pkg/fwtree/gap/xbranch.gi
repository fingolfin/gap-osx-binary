VDEBUG := false;
W := 24; 
H := 32;
W0 := 800;
H0 := 512;
X0 := 3 * W; 
Y0 := 2 * H;

Coord := function(i, j)
    return [4 + X0 + W*j, 4 + Y0 + H * i];
end;

DrawVertex := function(sheet, i, j, parent, terminal, info)
    local p, q;
    p := Coord(i, j);
    if parent <> false then
        q := Coord(parent[1],parent[2]);
        Line(sheet, p[1], p[2], q[1] - p[1], q[2] - p[2]);
    fi;
    
    if terminal <> false then
        Box(sheet, p[1] - 3, p[2] - 3, 6, 6);
#        Text(sheet, FONTS.tiny, p[1] + 6, p[2], String(terminal));
    else
        Disc(sheet, p[1], p[2], 3);
    fi;
    
    if VDEBUG and (info <> false) then
        Text(sheet, FONTS.tiny,p[1] + 3, p[2] + 15 ,
             Concatenation("(", String(info), ")"));
    fi;
end;

DrawText := function(sheet, i, j, t)
    local p;
    p := Coord(i, j);
    Text(sheet, FONTS.tiny, p[1], p[2], String(t));
end;

HeightBranch := function( branch )
    local t, i, max;
    max := 0;
    i := 0;
    for t in branch do
        if t = LEFT then
            i := i + 1;
            max := Maximum( max, i );
        elif t = RIGHT then
            i := i - 1;
        fi;
    od;
    return max - 1;
end;

BreadthBranch := function( branch )
    local b, x, i;
    b := List( [ 1 .. Length( branch ) ], x -> 0 );
    i := 0;
    for x in branch do
        if x = LEFT then
            i := i + 1;
        elif x = RIGHT then
            i := i - 1;
        elif not IsRecord( x ) then
            b[i] := b[i] + 1;
        fi;
    od;
    return Maximum( b );
end;

#  par : coord. of the parent
#    i : new row
# branch : the branch
#    k : index in the twig
# 
DrawBranch := function( branch )
    local sheet, b, RecDraw, k, stack, i, x, step, foo;
    sheet := GraphicSheet( "", W * (6 + BreadthBranch( branch ) ),
                     H * ( HeightBranch( branch ) + 4 )  );
    
    b := List( [ 1 .. HeightBranch( branch ) + 1 ], x -> 2);
    
    stack := [ [0,0] ];
    
    for i in [ 0 .. HeightBranch( branch )  ] do
        DrawText( sheet, i, -1, i + branch[1].class );
    od;
    i := 0;
    DrawVertex( sheet, 0, 0, false, false, false );
    
    for x in branch{[2..Length(branch)]} do
        if IsRecord( x ) then
            DrawVertex( sheet, i, b[i+1], stack[Length(stack)], step, false );
            Append( stack, [ [i, b[i+1]] ]);
            b[i+1] := b[i+1] + 1;
        elif x = LEFT then
            i := i + 1;
        elif x = RIGHT then
            i := i - 1; #steps[ Length(steps) ];
            stack := stack{ [ 1 .. Length( stack )-1 ] };
        else
            if x = 1 then
                step := false;
            else
                step := true;
            fi;
        fi;
    od;
end;
