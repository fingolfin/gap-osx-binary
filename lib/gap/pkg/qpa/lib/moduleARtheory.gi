#######################################################################
##
#O  AlmostSplitSequence(<M>,<N>)
##
##  This function finds the almost split sequence ending in the module
##  <M>, if the module is indecomposable and not projective. It returns 
##  fail if the module is projective. The almost split sequence is 
##  returned as a pair of maps, the monomorphism and the epimorphism. 
##  The function assumes that the module  <M>  is indecomposable, and 
##  the range of the epimorphism is a module that is isomorphic to the 
##  input, not necessarily identical. 
##
InstallMethod( AlmostSplitSequence, 
    "for a PathAlgebraMatModule",
    true, 
    [ IsPathAlgebraMatModule ], 0,
    function( M )

    local K, DTrM, f, g, PM, syzygy, G, H, Img1, zero, 
          genssyzygyDTrM, VsyzygyDTrM, Img, gensImg, VImg, 
          stop, test, ext, preimages, homvecs, dimsyz, dimDTrM, 
          EndDTrM, radEndDTrM, nonzeroext, temp, L, pos, i;
#
# ToDo: Add test of input with respect to being indecomposable.
#
    K := LeftActingDomain(M);
    if IsProjectiveModule(M) then 
        return fail;
    else 
        DTrM := DTr(M);
#
# creating a short exact sequence 0 -> Syz(M) -> P(M) -> M -> 0
# f: P(M) -> M, g: Syz(M) -> P(M)  
#
        f := ProjectiveCover(M);
        g := KernelInclusion(f);
        PM := Source(f);
        syzygy := Source(g);
#
# using Hom(-,DTrM) on the s.e.s. above
#
        G := HomOverAlgebra(PM,DTrM);
        H := HomOverAlgebra(syzygy,DTrM);
#
# Making a vector space of Hom(Syz(M),DTrM)
# by first rewriting the maps as vectors
#
        genssyzygyDTrM := List(H, x -> Flat(x!.maps));
        VsyzygyDTrM := VectorSpace(K, genssyzygyDTrM);
#
# finding a basis for im(g*)
# first, find a generating set of im(g*)
# 
        Img1 := g*G;
#
# removing 0 maps by comparing to zero = Zeromap(syzygy,DTrM)
#
        zero := ZeroMapping(syzygy,DTrM);
        Img  := Filtered(Img1, x -> x <> zero);
#
# Rewriting the maps as vectors
#
        gensImg := List(Img, x -> Flat(x!.maps));
#
# Making a vector space of <Im g*>
        VImg := Subspace(VsyzygyDTrM, gensImg);  
#
# Finding a non-zero element in Ext1(M,DTrM)
#
        i := 1;
        stop := false;
        repeat 
            test := Flat(H[i]!.maps) in VImg;
            if test then 
                i := i + 1;
            else 
                stop := true;
            fi;
        until stop;
        nonzeroext := H[i];
#
# Finding the radical of End(DTrM)
#
        EndDTrM := EndOverAlgebra(DTrM);
        radEndDTrM := RadicalOfAlgebra(EndDTrM);
        radEndDTrM := List(BasisVectors(Basis(radEndDTrM)), x -> FromEndMToHomMM(DTrM,x));
#
# Finding an element in the socle of Ext^1(M,DTrM)
#
        temp := nonzeroext;

        L := List(temp*radEndDTrM, x -> Flat(x!.maps) in VImg);
        while not ForAll(L, x -> x = true) do
            pos := Position(L,false);
            temp := temp*radEndDTrM[pos];
            L := List(temp*radEndDTrM, x -> Flat(x!.maps) in VImg);
        od;
#
# Constructing the almost split sequence in Ext^1(M,DTrM)
#
        ext := PushOut(g,temp);

        return [ext[1],CoKernelProjection(ext[1])];
    fi;
end
);

#######################################################################
##
#O  PredecessorsOfModule( <M>, <n> )
##
##  Given an indecomposable non-projective PathAlgebraMatModule  M  
##  this function finds the predecessors of the module  M  in the 
##  AR-quiver of the algebra  M  is given over of distance less or 
##  equal to  n. It returns two lists, the first is the indecomposable
##  modules in the different layers and the second is the valuations
##  for the arrows in the AR-quiver. The function assumes that the 
##  entered module  M  is indecomposable.
##
InstallMethod ( PredecessorsOfModule, 
    "for a IsPathAlgebraMatModule and a positive integer",
    true,
    [ IsPathAlgebraMatModule, IS_INT ], 
    0,
    function( M, n )

    local layers, valuation, L, middleterm, i, N, j, m, 
          tempval, s, inlayer_i_plus_1;
#
# ToDo: Add test of input with respect to being indecomposable.
#
    if IsProjectiveModule(M) then
        Error("entered module is projective,");
    fi;
    if n = 1 then 
        return M;
    fi;
    #
    # Initializing the data structures.
    #
    layers := List([1..n + 1], x -> []);
    valuation := List([1..n], x -> []);
    #
    # Layer number 1 is the entered module.
    #
    Add(layers[1],M);
    #
    # Layer number 2 is the indecomposable modules in the 
    # middel term of the almost split sequence ending in  M.
    #
    L := AlmostSplitSequence(M);
    middleterm := DecomposeModuleWithMultiplicities(Range(L[1]));
    Append(layers[2],middleterm[1]);
    #
    # First entry in the third layer is  DTr(M).
    #
    Add(layers[3],Source(L[1]));
    #
    # Adding the valuation of the irreducible maps from layer
    # 2 to layer 1 and from the one module  DTr(M)  in layer 3 
    # to layer 2. 
    #
    for i in [1..Length(middleterm[2])] do
        Add(valuation[1],[i,1,[middleterm[2][i],false]]);
        Add(valuation[2],[1,i,[false,middleterm[2][i]]]);
    od;
    #
    # The next layers ......
    #
    i := 2;
    while ( i in [2..n-1] ) and ( Length(layers) >= i ) do 
        for N in layers[i] do
            if not IsPathAlgebraMatModule(N) then 
                Error("not PathAlgebraMatModule.");
            fi;
            if not IsProjectiveModule(N) then 
    #
    # Computing the almost split sequence ending in  N.
    # 
                L := AlmostSplitSequence(N);
    #
    # Decomposing the middel term with multiplicities
    #
                middleterm := DecomposeModuleWithMultiplicities(Range(L[1]));
    #
    # Adding  DTr(N)  to the  (i + 2)-th layer.
    #
                Add(layers[i+2],Source(L[1]));
    #
    # Adding the middel term to the  (i + 1)-th layer.
    #
                for j in [1..Length(middleterm[1])] do
                    inlayer_i_plus_1 := false;
                    for m in [1..Length(layers[i + 1])] do 
                        if CommonDirectSummand(middleterm[1][j],layers[i + 1][m]) <> false then
                            tempval := valuation[i]{[1..Length(valuation[i])]}{[1..2]};
                            s := Position(tempval,[m,Position(layers[i],N)]);
                            valuation[i][s][3][1] := middleterm[2][j];
                            Add(valuation[i + 1],[Length(layers[i + 2]),m,[false,middleterm[2][j]]]);
                            inlayer_i_plus_1 := true;
                        fi;
                    od;
                    if not inlayer_i_plus_1 then
                        Add(layers[i+1],middleterm[1][j]);
                        Add(valuation[i],[Length(layers[i + 1]),Position(layers[i],N),[middleterm[2][j],false]]);
                        Add(valuation[i + 1],[Length(layers[i + 2]),Length(layers[i + 1]),[false,middleterm[2][j]]]);
                    fi;               
                od;
            else
                # 
                #  if  N  is projective ....
                #
                if Dimension(RadicalOfModule(N)) <> 0 then 
                    middleterm := DecomposeModuleWithMultiplicities(RadicalOfModule(N));
                    for j in [1..Length(middleterm[1])] do
                        inlayer_i_plus_1 := false;
                        for m in [1..Length(layers[i + 1])] do 
                            if CommonDirectSummand(middleterm[1][j],layers[i + 1][m]) <> false then
                                tempval := valuation[i]{[1..Length(valuation[i])]}{[1..2]};
                                s := Position(tempval,[m,Position(layers[i],N)]);
                                valuation[i][s][3][1] := middleterm[2][j];
                                inlayer_i_plus_1 := true;  
                            fi;
                        od;
                        if not inlayer_i_plus_1 then 
                            Add(layers[i+1],middleterm[1][j]);
                            Add(valuation[i],[Length(layers[i + 1]),Position(layers[i],N),middleterm[2][j]]);
                        fi;
                    od;
                fi;
            fi;
        od;
        i := i + 1;
    od;

    return [layers,valuation];
end
);
