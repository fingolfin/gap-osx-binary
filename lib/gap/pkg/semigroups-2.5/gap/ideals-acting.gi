#############################################################################
##
#W  ideals-acting.gi
#Y  Copyright (C) 2013-15                                 James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

#

InstallMethod(SemigroupData, "for a regular acting semigroup ideal",
[IsActingSemigroup and IsRegularSemigroup and IsSemigroupIdeal],
SemigroupIdealData);

# JDM this method should become obsolete in time...
# <I> is not known to be regular if this function is invoked...

InstallMethod(SemigroupData, "for an acting semigroup ideal",
[IsActingSemigroup and IsSemigroupIdeal],
function(I)
  local data, pos, partial, classes, D, U, inj, i, j, C;

  # the maximal D-classes of the supersemigroup of <I> contained in <I>
  data := SemigroupIdealData(I);
  pos := [1 .. data!.genspos - 1];
  # the D-classes of the generators in positions
  # [1..n-1] in data!.dorbit
  partial := data!.poset;
  classes := data!.dorbit;
  D := [];
  for i in pos do
    if not ForAny([1 .. Length(partial)], j -> j <> i and i in partial[j]) then
      Add(D, classes[i]);
    fi;
  od;

  # find generators for I...
  U := Semigroup(GeneratorsOfSemigroupIdeal(I));

  for i in [1 .. Length(D)] do
    if IsRegularDClass(D[i]) then
      inj := InverseGeneralMapping(InjectionPrincipalFactor(D[i]));
      U := ClosureSemigroup(U, OnTuples(GeneratorsOfSemigroup(Source(inj)),
                                        inj));
    else
      U := ClosureSemigroup(U, D[i]);
    fi;
  od;

  i := 0;
  partial := data!.poset;
  D := data!.dorbit;

  while Size(U) <> Size(I) do
    i := i + 1;
    j := 0;
    while Size(U) <> Size(I) and j < Length(partial[i]) do
      j := j + 1;
      if Length(partial[i]) = 1 or partial[i][j] <> i then
        C := D[partial[i][j]];
        if IsRegularDClass(C) then
          inj := InverseGeneralMapping(InjectionPrincipalFactor(C));
          U := ClosureSemigroup(U, OnTuples(GeneratorsOfSemigroup(Source(inj)),
                                            inj));
        else
          U := ClosureSemigroup(U, AsList(C));
        fi;
      fi;
    od;
  od;

  SetGeneratorsOfSemigroup(I, GeneratorsOfSemigroup(U));
  SetLambdaOrb(I, LambdaOrb(U));
  SetRhoOrb(I, RhoOrb(U));
  # JDM: maybe more is required here to remove U from the semigroup data, like
  # replacing U with I in the first position of every entry of the data, and in
  # the different internal components of the data.
  return SemigroupData(U);
end);

#

InstallMethod(GeneratorsOfSemigroup, "for an acting semigroup ideal",
[IsActingSemigroup and IsSemigroupIdeal],
function(I)
  local data, pos, partial, classes, D, U, inj, i, j, C;

  if not IsRegularSemigroup(I) then
    return SemigroupData(I)!.gens;
  fi;

  Info(InfoWarning, 2, "finding a generating set of a semigroup ideal!");
  data := SemigroupIdealData(I);
  Enumerate(data, infinity, ReturnFalse);
  pos := [1 .. data!.genspos - 1];
  # the D-classes of the generators in positions
  # [1..n-1] in data!.dorbit
  partial := data!.poset;
  classes := data!.dorbit;
  D := [];
  for i in pos do
    Add(D, classes[i]);
  od;

  # find generators for I...
  U := Semigroup(GeneratorsOfSemigroupIdeal(I));

  for i in [1 .. Length(D)] do
    if IsRegularDClass(D[i]) then
      inj := InverseGeneralMapping(InjectionPrincipalFactor(D[i]));
      U := ClosureSemigroup(U, OnTuples(GeneratorsOfSemigroup(Source(inj)),
                                        inj));
    else
      U := ClosureSemigroup(U, D[i]);
    fi;
  od;

  i := 0;
  partial := data!.poset;
  D := data!.dorbit;

  while Size(U) <> Size(I) do
    i := i + 1;
    j := 0;
    while Size(U) <> Size(I) and j < Length(partial[i]) do
      j := j + 1;
      if Length(partial[i]) = 1 or partial[i][j] <> i then
        C := D[partial[i][j]];
        if IsRegularDClass(C) then
          inj := InverseGeneralMapping(InjectionPrincipalFactor(C));
          U := ClosureSemigroup(U, OnTuples(GeneratorsOfSemigroup(Source(inj)),
                                            inj));
        else
          U := ClosureSemigroup(U, AsList(C));
        fi;
      fi;
    od;
  od;

  return GeneratorsOfSemigroup(U);
end);

#

InstallMethod(GeneratorsOfSemigroup,
"for an inverse op acting semigroup ideal",
[IsActingSemigroupWithInverseOp and IsSemigroupIdeal],
function(I)
  local out, U, partial, D, pos, inj, i, j, C, gens;

  if HasGeneratorsOfInverseSemigroup(I) then
    # TODO could remove repeats and only add necessary inverses...
    out := ShallowCopy(GeneratorsOfInverseSemigroup(I));
    Append(out, List(out, x -> x ^ -1));
    return out;
  fi;

  Info(InfoWarning, 2, "finding a generating set of a semigroup ideal!");

  # find generators for I...
  U := InverseSemigroup(GeneratorsOfSemigroupIdeal(I));
  partial := PartialOrderOfDClasses(I);
  D := GreensDClasses(I);

  # positions of the D-classes containing generators of the ideal...
  pos := Set(GeneratorsOfSemigroupIdeal(I),
             x -> OrbSCCLookup(LambdaOrb(I))[Position(LambdaOrb(I),
                                                      LambdaFunc(I)(x))] - 1);

  for i in pos do
    inj := InverseGeneralMapping(InjectionPrincipalFactor(D[i]));
    U := ClosureInverseSemigroup(U,
                                 OnTuples(GeneratorsOfSemigroup(Source(inj)),
                                          inj));
  od;

  i := 0;
  while Size(U) <> Size(I) do
    i := i + 1;
    j := 0;
    while Size(U) <> Size(I) and j < Length(partial[i]) do
      j := j + 1;
      if Length(partial[i]) = 1 or partial[i][j] <> i then
        C := D[partial[i][j]];
        inj := InverseGeneralMapping(InjectionPrincipalFactor(C));
        gens := GeneratorsOfSemigroup(Source(inj));
        U := ClosureInverseSemigroup(U, OnTuples(gens, inj));
      fi;
    od;
  od;

  return GeneratorsOfSemigroup(U);
end);

#

InstallMethod(GeneratorsOfInverseSemigroup,
"for an inverse op acting semigroup ideal",
[IsActingSemigroupWithInverseOp and IsSemigroupIdeal],
function(I)
  local U, i, partial, D, pos, inj, gens, j, C;

  if HasGeneratorsOfSemigroup(I) then
    # JDM: could remove inverses...
    return GeneratorsOfSemigroup(I);
  fi;

  Info(InfoWarning, 2, "finding a generating set of a semigroup ideal!");

  # find generators for I...
  U := InverseSemigroup(GeneratorsOfSemigroupIdeal(I));
  i := 0;
  partial := PartialOrderOfDClasses(I);
  D := GreensDClasses(I);

  # positions of the D-classes containing generators of the ideal...
  pos := Set(GeneratorsOfSemigroupIdeal(I),
             x -> OrbSCCLookup(LambdaOrb(I))[Position(LambdaOrb(I),
                                                      LambdaFunc(I)(x))] - 1);

  for i in pos do
    inj := InverseGeneralMapping(InjectionPrincipalFactor(D[i]));
    gens := GeneratorsOfSemigroup(Source(inj));
    U := ClosureInverseSemigroup(U, OnTuples(gens, inj));
  od;

  while Size(U) <> Size(I) do
    i := i + 1;
    j := 0;
    while Size(U) <> Size(I) and j < Length(partial[i]) do
      j := j + 1;
      if Length(partial[i]) = 1 or partial[i][j] <> i then
        C := D[partial[i][j]];
        inj := InverseGeneralMapping(InjectionPrincipalFactor(C));
        gens := GeneratorsOfSemigroup(Source(inj));
        U := ClosureInverseSemigroup(U, OnTuples(gens, inj));
      fi;
    od;
  od;

  return GeneratorsOfInverseSemigroup(U);
end);

# this could be simplier for ideals which know they are regular a priori.

InstallMethod(SemigroupIdealData, "for an acting semigroup ideal",
[IsActingSemigroup and IsSemigroupIdeal],
function(I)
  local gens, data, filt;

  gens := GeneratorsOfSemigroup(SupersemigroupOfIdeal(I));

  data := rec(gens := gens,
              parent := I,
              log := [1],
              genspos := 0,
              ht := HTCreate(gens[1], rec(treehashsize :=
                                          SEMIGROUPS_OptionsRec(I).hashlen.L)),
              pos := 0,
              init := false,
              reps := [],
              repslookup := [],
              orblookup1 := [],
              orblookup2 := [],
              rholookup := [fail],
              lenreps := [0],
              orbit := [fail],
              dorbit := [],
              repslens := [],
              lambdarhoht := [],
              regular := [],
              genstoapply := [1 .. Length(gens)],
              stopper := false,
              poset := [],
              scc_lookup := []);

  if HasIsRegularSemigroup(I) and IsRegularSemigroup(I) then
    filt := IsRegularIdealData;
  else
    filt := IsSemigroupIdealData;
  fi;
  Objectify(NewType(FamilyObj(I), filt), data);

  return data;
end);

#

InstallMethod(SemigroupIdealData, "for an inverse op acting semigroup ideal",
[IsActingSemigroupWithInverseOp and IsSemigroupIdeal], ReturnFail);

#

InstallMethod(ViewObj, [IsSemigroupIdealData],
function(data)
  Print("<");
  if IsClosedData(data) then
    Print("closed ");
  else
    Print("open ");
  fi;
  Print("semigroup ideal ");

  Print("data with ", Length(data!.orbit) - 1, " reps, ",
        Length(LambdaOrb(data!.parent)) - 1, " lambda-values, ",
        Length(RhoOrb(data!.parent)) - 1, " rho-values>");
  return;
end);

#

InstallMethod(Enumerate, "for semigroup ideal data, limit, looking function",
[IsSemigroupIdealData, IsCyclotomic, IsFunction],
function(data, limit, lookfunc)
  return Enumerate(data, limit, rec(lookfunc := lookfunc));
end);

# We concentrate on the case when nothing is known about the parent of the
# ideal.

# we make the R-class centered data structure as in SemigroupIdealData but at
# the same time have an additional "orbit" consisting of D-class reps.

InstallMethod(Enumerate,
"for semigroup ideal data, limit, and record",
[IsSemigroupIdealData, IsCyclotomic, IsRecord],
function(data, limit, record)
  local lookfunc, looking, lambdalookfunc, lambdalooking, rholookfunc,
  rholooking, ht, orb, nr_r, d, nr_d, reps, repslens, lenreps, lambdarhoht,
  repslookup, orblookup1, orblookup2, rholookup, stopper, gens, nrgens,
  genstoapply, I, lambda, lambdao, lambdaoht, lambdalookup, lambdascc, lenscc,
  lambdaact, lambdaperm, rho, rhoo, rhooht, rhoolookup, rhoscc, act, htadd,
  htvalue, drel, dtype, poset, datalookup, log, tester, regular,
  UpdateSemigroupIdealData, idealgens, i, x, rreps, scc, pos, j, k, z;

  if IsBound(record.lookfunc) then
    lookfunc := record.lookfunc;
    looking := true;
    data!.found := false;
  else
    looking := false;
  fi;

  if IsBound(record.lambdalookfunc) then
    lambdalookfunc := record.lambdalookfunc;
    lambdalooking := true;
  else
    lambdalookfunc := ReturnFalse;
    lambdalooking := false;
  fi;

  if IsBound(record.rholookfunc) then
    rholookfunc := record.rholookfunc;
    rholooking := true;
  else
    rholookfunc := ReturnFalse;
    rholooking := false;
  fi;

  if IsClosedData(data) then
    if looking then
      data!.found := false;
    fi;
    return data;
  fi;

  data!.looking := looking;

  ht   := data!.ht;     # so far found R-reps
  orb  := data!.orbit;  # the so far found R-reps data
  nr_r := Length(orb);
  d    := data!.dorbit; # the so far found D-classes
  nr_d := Length(d);
  reps := data!.reps;   # reps grouped by equal lambda-scc-index and
                        # rho-value-index

  repslens := data!.repslens;       # Length(reps[m][i])=repslens[m][i]
  lenreps := data!.lenreps;         # lenreps[m]=Length(reps[m])

  lambdarhoht := data!.lambdarhoht;
  # HTValue(lambdarhoht, [m,l])=position in reps[m]
  # of R-reps with lambda-scc-index=m and
  # rho-value-index=l

  repslookup := data!.repslookup; # Position(orb, reps[m][i][j])
                                  # = repslookup[m][i][j]
                                  # = HTValue(ht, reps[m][i][j])

  orblookup1 := data!.orblookup1; # orblookup1[i] position in reps[m]
                                  # containing orb[i][4] (the R-rep)

  orblookup2 := data!.orblookup2; # orblookup2[i] position in
                                  # reps[m][orblookup1[i]]
                                  # containing orb[i][4] (the R-rep)

  rholookup := data!.rholookup;   #rholookup[i]=rho-value-index of orb[i][4]

  stopper := data!.stopper;       # stop at this place in the orbit

  # generators
  gens := data!.gens; # generators of the parent semigroup
  nrgens := Length(gens);
  genstoapply := data!.genstoapply;

  I := data!.parent;

  # lambda
  lambda := LambdaFunc(I);
  lambdao := LambdaOrb(I);
  lambdaoht := lambdao!.ht;
  lambdalookup := lambdao!.scc_lookup;
  lambdascc := OrbSCC(lambdao);
  lenscc := Length(lambdascc);

  lambdaact := LambdaAct(I);
  lambdaperm := LambdaPerm(I);

  # rho
  rho := RhoFunc(I);
  rhoo := RhoOrb(I);
  rhooht := rhoo!.ht;
  rhoolookup := rhoo!.scc_lookup;
  rhoscc := OrbSCC(rhoo);

  act := StabilizerAction(I);

  if IsBoundGlobal("ORBC") then
    htadd := HTAdd_TreeHash_C;
    htvalue := HTValue_TreeHash_C;
  else
    htadd := HTAdd;
    htvalue := HTValue;
  fi;

  # new stuff
  drel := GreensDRelation(I);
  dtype := DClassType(I);

  poset := data!.poset;  # the D-class poset
  datalookup := data!.scc_lookup;

  log := data!.log;
  # log[i+1] is the last position in orb=data!.orbit where the R-class reps
  # of d[i] appear...

  tester := IdempotentTester(I);
  regular := data!.regular;

  #############################################################################

  # the function which checks if x is already R/D-related to something in the
  # data and if not adds it in the appropriate place

  UpdateSemigroupIdealData := function(x, pos, gen, idealpos)
    local new, xx, l, m, mm, schutz, mults, cosets, y, n, z, ind, val;
    new := false;

    # check, update, rectify the lambda value
    xx := lambda(x);
    l := htvalue(lambdaoht, xx);
    if l = fail then
      l := UpdateIdealLambdaOrb(lambdao, xx, x, pos, gen, idealpos,
                                lambdalookfunc);

      # update the lists of reps
      for n in [lenscc + 1 .. lenscc + Length(lambdascc)] do
        reps[n] := [];
        repslookup[n] := [];
        repslens[n] := [];
        lenreps[n] := 0;
        lenscc := Length(lambdascc);
      od;
      new := true; # x is a new R-rep
    fi;
    m := lambdalookup[l];
    if l <> lambdascc[m][1] then
      x := x * LambdaOrbMult(lambdao, m, l)[2];
    fi;

    # check if x is identical to one of the known R-reps
    if not new then
      val := htvalue(ht, x);
      if val <> fail then
        if pos <> fail then # we are multiplying the <i>th D-rep by a generator
          AddSet(poset[i], datalookup[val]);
        fi;
        return; #x is one of the old R-reps
      fi;
    fi;

    # check, update, rectify the rho value
    xx := rho(x);
    l := htvalue(rhooht, xx);
    if l = fail then
      l := UpdateIdealRhoOrb(rhoo, xx, x, pos, gen, idealpos, rholookfunc);
      new := true; # x is a new R-rep
    fi;
    schutz := LambdaOrbStabChain(lambdao, m);

    # check if x is R-related to one of the known R-reps
    if not new and schutz <> false and IsBound(lambdarhoht[l])
        and IsBound(lambdarhoht[l][m]) then
       # if schutz=false or these are not bound, then x is a new R-rep

      ind := lambdarhoht[l][m];
      if schutz = true then
        if pos <> fail then
          AddSet(poset[i], datalookup[repslookup[m][ind][1]]);
        fi;
        return;
      fi;

      for n in [1 .. repslens[m][ind]] do
        if SiftedPermutation(schutz, lambdaperm(reps[m][ind][n], x)) = () then
          if pos <> fail then
            AddSet(poset[i], datalookup[repslookup[m][ind][n]]);
          fi;
          return; # x is on of the old R-reps
        fi;
      od;
    fi;

    # if we reach here, then x is a new R-rep, and hence a new D-rep
    mm := rhoolookup[l];
    if l <> rhoscc[mm][1] then
      x := RhoOrbMult(rhoo, mm, l)[2] * x;
    fi;

    nr_d := nr_d + 1;
    d[nr_d] := rec();
    # FIXME: use SEMIGROUPS_CreateDClass here!
    ObjectifyWithAttributes(d[nr_d], dtype, ParentAttr, I,
                            EquivalenceClassRelation, drel, IsGreensClassNC,
                            false, Representative, x, LambdaOrb, lambdao,
                            LambdaOrbSCCIndex, m, RhoOrb, rhoo, RhoOrbSCCIndex,
                            mm, RhoOrbSCC, rhoscc[mm]);
    regular[nr_d] := false;

    # install the point in the poset

    if pos <> fail  then
      AddSet(poset[i], nr_d);
    fi;

    # install the R-class reps of the new D-rep
    mults := RhoOrbMults(rhoo, mm);
    cosets := RhoCosets(d[nr_d]);

    for l in rhoscc[mm] do #install the R-class reps
      if not IsBound(lambdarhoht[l]) then
        lambdarhoht[l] := [];
      fi;
      if not IsBound(lambdarhoht[l][m]) then
        lenreps[m] := lenreps[m] + 1;
        ind := lenreps[m];
        lambdarhoht[l][m] := ind;
        repslens[m][ind] := 0;
        reps[m][ind] := [];
        repslookup[m][ind] := [];
      else
        ind := lambdarhoht[l][m];
        if not HasIsRegularSemigroup(I) then
          SetIsRegularSemigroup(I, false);
        fi;
      fi;
      if not HasIsRegularSemigroup(I) and not regular[nr_d] then
        regular[nr_d] := tester(lambdao[lambdascc[m][1]], rhoo[l]);
      fi;
      y := mults[l][1] * x;

      for z in cosets do
        nr_r := nr_r + 1;

        repslens[m][ind] := repslens[m][ind] + 1;
        reps[m][ind][repslens[m][ind]] := act(y, z ^ -1);
        repslookup[m][ind][repslens[m][ind]] := nr_r;
        orblookup1[nr_r] := ind;
        orblookup2[nr_r] := repslens[m][ind];
        rholookup[nr_r] := l;
        datalookup[nr_r] := nr_d;

        orb[nr_r] := [I, m, lambdao, reps[m][ind][repslens[m][ind]],
                      false, nr_r];
        htadd(ht, reps[m][ind][repslens[m][ind]], nr_r);

        if looking then
          # did we find it?
          if lookfunc(data, orb[nr_r]) then
            data!.found := nr_r;
          fi;
        fi;

      od;
    od;
    log[nr_d + 1] := nr_r;
  end;
  #############################################################################

  # initialise the data if necessary
  if data!.init = false then
    # add the generators of the ideal...
    idealgens := GeneratorsOfSemigroupIdeal(I);
    for i in [1 .. Length(idealgens)] do
      UpdateSemigroupIdealData(idealgens[i], fail, fail, i);
    od;

    data!.init := true;
    data!.genspos := nr_d + 1;
  fi;

  i := data!.pos;  # points in orb in position at most i have descendants

  while nr_d <= limit and i < nr_d and i <> stopper do
    i := i + 1; # advance in the dorb
    poset[i] := [];
    x := Representative(d[i]);

    # left multiply the R-class reps by the generators of the semigroup
    rreps := [];
    scc := RhoOrbSCC(d[i]);
    pos := Position(lambdao, lambda(x));
    for j in [log[i] + 1 .. log[i + 1]] do  # the R-class reps of d[i]
      rreps[j - log[i]] := orb[j][4];
      for k in genstoapply do
        UpdateSemigroupIdealData(gens[k] * orb[j][4], pos, k, fail);
        if (looking and data!.found <> false)
            or (lambdalooking and lambdao!.found <> false)
            or (rholooking and rhoo!.found <> false) then
          data!.pos := i - 1;
          return data;
        fi;
      od;
    od;
    SetRClassReps(d[i], rreps);

    # right multiply the L-class reps by the generators of the semigroup
    pos := Position(rhoo, rho(x));
    for z in LClassReps(d[i]) do
      for k in genstoapply do
        UpdateSemigroupIdealData(z * gens[k], pos, k, fail);
        if (looking and data!.found <> false)
            or (lambdalooking and lambdao!.found <> false)
            or (rholooking and rhoo!.found <> false) then
          data!.pos := i - 1;
          return data;
        fi;
      od;
    od;
  od;

  # for the data-orbit
  data!.pos := i;

  if nr_d = i then
    SetFilterObj(lambdao, IsClosed);
    SetFilterObj(rhoo, IsClosed);
    SetFilterObj(data, IsClosedData);
    if not HasIsRegularSemigroup(I) then
      SetIsRegularSemigroup(I, ForAll(regular, x -> x = true));
    fi;
    if IsRegularSemigroup(I) then
      SetGreensDClasses(I, d);
    fi;
  fi;
  return data;
end);

#

InstallMethod(\in,
"for an associative element and regular acting semigroup ideal",
[IsAssociativeElement,
 IsActingSemigroup and IsSemigroupIdeal and IsRegularSemigroup],
function(x, I)
  local data, ht, xx, o, scc, scclookup, l, lookfunc, new, m, xxx, lambdarhoht,
  schutz, ind, reps, repslens, max, lambdaperm, oldrepslens, found, n, i;

  if ElementsFamily(FamilyObj(I)) <> FamilyObj(x)
      or (IsActingSemigroupWithFixedDegreeMultiplication(I)
          and ActionDegree(x) <> ActionDegree(I))
      or (ActionDegree(x) > ActionDegree(I)) then
    return false;
  fi;

  if ActionRank(I)(x) >
      MaximumList(List(Generators(I), f -> ActionRank(I)(x))) then
    Info(InfoSemigroups, 2, "element has larger rank than any element of ",
         "semigroup.");
    return false;
  fi;

  if HasMinimalIdeal(I) then
    if ActionRank(I)(x) < ActionRank(I)(Representative(MinimalIdeal(I))) then
      Info(InfoSemigroups, 2, "element has smaller rank than any element of ",
           "semigroup.");
      return false;
    fi;
  fi;

  data := SemigroupIdealData(I);
  ht := data!.ht;

  # look for lambda!
  xx := LambdaFunc(I)(x);
  o := LambdaOrb(I);
  scc := OrbSCC(o);
  scclookup := OrbSCCLookup(o);

  l := Position(o, xx);

  if l = fail then
    if IsClosed(o) then
      return fail;
    fi;

    # this function checks if <pt> has the same lambda-value as x
    lookfunc := function(lambdao, pt)
      return pt = xx;
    end;
    Enumerate(data, infinity, rec(lambdalookfunc := lookfunc));
    l := PositionOfFound(o);

    # rho is not found, so f not in s
    if l = false then
      return false;
    fi;
    l := Position(o, xx);
    new := true;
  fi;

  # strongly connected component of lambda orb
  m := OrbSCCLookup(o)[l];

  # make sure lambda of f is in the first place of its scc
  if l <> OrbSCC(o)[m][1] then
    x := x * LambdaOrbMult(o, m, l)[2];
  fi;

  # check if f is an existing R-rep
  if HTValue(ht, x) <> fail then
    return true;
  fi;

  # look for rho!
  xxx := RhoFunc(I)(x);
  o := RhoOrb(I);
  scc := OrbSCC(o);
  scclookup := OrbSCCLookup(o);

  l := Position(o, xxx);

  if l = fail then
    if IsClosed(o) then
      return fail;
    fi;

    # this function checks if <pt> has the same lambda-value as x
    lookfunc := function(o, pt)
      return pt = xxx;
    end;
    Enumerate(data, infinity, rec(rholookfunc := lookfunc));
    l := PositionOfFound(o);

    # rho is not found, so f not in s
    if l = false then
      return false;
    fi;
    l := Position(o, xxx);
    new := true;
  fi;

  lambdarhoht := data!.lambdarhoht;

  # look for the R-class rep
  if not IsBound(lambdarhoht[l]) or not IsBound(lambdarhoht[l][m]) then
    # lambda-rho-combination not yet seen
    if IsClosedData(data) then
      return false;
    fi;

    lookfunc := function(data, x)
      return IsBound(lambdarhoht[l]) and IsBound(lambdarhoht[l][m]);
    end;
    data := Enumerate(data, infinity, lookfunc);
    if not IsBound(lambdarhoht[l]) or not IsBound(lambdarhoht[l][m]) then
      return false;
    fi;
    new := true;
  fi;

  o := LambdaOrb(I);
  schutz := LambdaOrbStabChain(o, m);
  ind := lambdarhoht[l][m];
  # the index of the list of reps with same lambda-rho value as f.

  # if the Schutzenberger group is the symmetric group, then f in s!
  if schutz = true then
    return true;
  fi;

  reps := data!.reps;
  repslens := data!.repslens;
  max := Factorial(LambdaRank(I)(xx)) / Size(LambdaOrbSchutzGp(o, m));

  if repslens[m][ind] = max then
    return true;
  fi;

  # if schutz is false, then f has to be an R-rep which it is not...
  if schutz <> false then

    # check if f already corresponds to an element of reps[m][ind]
    lambdaperm := LambdaPerm(I);
    for n in [1 .. repslens[m][ind]] do
      if SiftedPermutation(schutz, lambdaperm(reps[m][ind][n], x)) = () then
        return true;
      fi;
    od;
  elif new and HTValue(ht, x) <> fail then
    return true;
  fi;

  if IsClosedData(data) then
    return false;
  fi;

  # enumerate until we find x or finish
  if repslens[m][ind] < max then
    oldrepslens := repslens[m][ind];
    lookfunc := function(data, x)
      return repslens[m][ind] > oldrepslens;
    end;
    if schutz = false then
      repeat
        # look for more R-reps with same lambda-rho value
        data := Enumerate(data, infinity, lookfunc);
        oldrepslens := repslens[m][ind];
        found := data!.found;
        if found <> false then
          if oldrepslens = max or x = data[found][4] then
            return true;
          fi;
        fi;
      until found = false;
    else
      repeat
        # look for more R-reps with same lambda-rho value
        data := Enumerate(data, infinity, lookfunc);
        oldrepslens := repslens[m][ind];
        found := data!.found;
        if found <> false then
          if oldrepslens = max then
            return true;
          fi;
          for i in [n + 1 .. repslens[m][ind]] do
            if SiftedPermutation(schutz, lambdaperm(reps[m][ind][i], x))
                = () then
              return true;
            fi;
          od;
          n := repslens[m][ind];
        fi;
      until found = false;
    fi;
  fi;
  return false;
end);

# JDM; this method could be removed later...

InstallMethod(Size, "for an acting semigroup ideal",
[IsActingSemigroup and IsSemigroupIdeal],
function(s)
  local data, lenreps, repslens, o, scc, size, n, m, i;

  data := Enumerate(SemigroupIdealData(s), infinity, ReturnFalse);
  lenreps := data!.lenreps;
  repslens := data!.repslens;
  o := LambdaOrb(s);
  scc := OrbSCC(o);

  size := 0;

  for m in [2 .. Length(scc)] do
    n := Size(LambdaOrbSchutzGp(o, m)) * Length(scc[m]);
    for i in [1 .. lenreps[m]] do
      size := size + n * repslens[m][i];
    od;
  od;

  return size;
end);

#

InstallMethod(Enumerate,
"for regular ideal data, limit, and func",
[IsRegularIdealData, IsCyclotomic, IsRecord],
function(data, limit, record)
  local lookfunc, looking, lambdalookfunc, lambdalooking, rholookfunc,
  rholooking, ht, orb, nr_r, d, nr_d, reps, repslens, lenreps, lambdarhoht,
  repslookup, orblookup1, orblookup2, rholookup, stopper, gens, nrgens,
  genstoapply, I, lambda, lambdao, lambdaoht, lambdalookup, lambdascc, lenscc,
  lambdaact, lambdaperm, rho, rhoo, rhooht, rhoolookup, rhoscc, rholen, act,
  htadd, htvalue, drel, dtype, poset, datalookup, log,
  UpdateSemigroupIdealData, idealgens, i, x, rreps, scc, pos, j, k, z;

  if IsBound(record.lookfunc) and record.lookfunc <> ReturnFalse then
    lookfunc := record.lookfunc;
    looking := true;
    data!.found := false;
  else
    looking := false;
  fi;

  if IsBound(record.lambdalookfunc) then
    lambdalookfunc := record.lambdalookfunc;
    lambdalooking := true;
  else
    lambdalookfunc := ReturnFalse;
    lambdalooking := false;
  fi;

  if IsBound(record.rholookfunc) then
    rholookfunc := record.rholookfunc;
    rholooking := true;
  else
    rholookfunc := ReturnFalse;
    rholooking := false;
  fi;

  if IsClosedData(data) then
    if looking then
      data!.found := false;
    fi;
    return data;
  fi;

  data!.looking := looking;

  ht := data!.ht;       # so far found R-reps
  orb := data!.orbit;   # the so far found R-reps data
  nr_r := Length(orb);
  d := data!.dorbit;    # the so far found D-classes
  nr_d := Length(d);
  reps := data!.reps;
  # reps grouped by equal lambda-scc-index and rho-value-index

  repslens := data!.repslens;       # Length(reps[m][i])=repslens[m][i]
  lenreps := data!.lenreps;         # lenreps[m]=Length(reps[m])

  lambdarhoht := data!.lambdarhoht;
                                  # HTValue(lambdarhoht, [m,l])=position in
                                  # reps[m] of R-reps with lambda-scc-index=m
                                  # and rho-value-index=l

  repslookup := data!.repslookup; # Position(orb, reps[m][i][j])
                                  # = repslookup[m][i][j]
                                  # = HTValue(ht, reps[m][i][j])

  orblookup1 := data!.orblookup1; # orblookup1[i] position in reps[m]
                                  # containing orb[i][4] (the R-rep)

  orblookup2 := data!.orblookup2; # orblookup2[i] position in
                                  # reps[m][orblookup1[i]]
                                  # containing orb[i][4] (the R-rep)

  rholookup := data!.rholookup;   #rholookup[i]=rho-value-index of orb[i][4]

  stopper := data!.stopper;       # stop at this place in the orbit

  # generators
  gens := data!.gens; # generators of the parent semigroup
  nrgens := Length(gens);
  genstoapply := data!.genstoapply;

  I := data!.parent;

  # lambda
  lambda := LambdaFunc(I);
  lambdao := LambdaOrb(I);
  lambdaoht := lambdao!.ht;
  lambdalookup := lambdao!.scc_lookup;
  lambdascc := OrbSCC(lambdao);
  lenscc := Length(lambdascc);

  lambdaact := LambdaAct(I);
  lambdaperm := LambdaPerm(I);

  # rho
  rho := RhoFunc(I);
  rhoo := RhoOrb(I);
  rhooht := rhoo!.ht;
  rhoolookup := rhoo!.scc_lookup;
  rhoscc := OrbSCC(rhoo);
  rholen := Length(rhoo);

  act := StabilizerAction(I);

  if IsBoundGlobal("ORBC") then
    htadd := HTAdd_TreeHash_C;
    htvalue := HTValue_TreeHash_C;
  else
    htadd := HTAdd;
    htvalue := HTValue;
  fi;

  # new stuff
  drel := GreensDRelation(I);
  dtype := DClassType(I);

  poset := data!.poset;  # the D-class poset
  datalookup := data!.scc_lookup;

  log := data!.log;
  # log[i+1] is the last position in orb=data!.orbit where the
  # R-class reps of d[i] appear...

  #############################################################################

  # the function which checks if x is already R/D-related to something in the
  # data and if not adds it in the appropriate place

  UpdateSemigroupIdealData := function(x, pos, gen, idealpos)
    local new, xx, l, m, mm, schutz, mults, y, n, ind, val;
    new := false;

    # check, update, rectify the lambda value
    xx := lambda(x);
    l := htvalue(lambdaoht, xx);
    if l = fail then
      l := UpdateIdealLambdaOrb(lambdao, xx, x, pos, gen, idealpos,
                                lambdalookfunc);

      # update the lists of reps
      for n in [lenscc + 1 .. lenscc + Length(lambdascc)] do
        reps[n] := [];
        repslookup[n] := [];
        repslens[n] := [];
        lenreps[n] := 0;
        lenscc := Length(lambdascc);
      od;
      new := true; # x is a new R-rep
    fi;
    m := lambdalookup[l];
    if l <> lambdascc[m][1] then
      x := x * LambdaOrbMult(lambdao, m, l)[2];
    fi;

    # check if x is identical to one of the known R-reps
    if not new then
      val := htvalue(ht, x);
      if val <> fail then
        if pos <> fail then # we are multiplying the <i>th D-rep by a generator
          AddSet(poset[i], datalookup[val]);
        fi;
        return; #x is one of the old R-reps
      fi;
    fi;

    # check, update, rectify the rho value
    xx := rho(x);
    l := htvalue(rhooht, xx);
    if l = fail then
      l := UpdateIdealRhoOrb(rhoo, xx, x, pos, gen, idealpos, rholookfunc);
      for n in [rholen + 1 .. rholen + Length(rhoo)] do
        lambdarhoht[n] := [];
      od;
      rholen := Length(rhoo);
      new := true; # x is a new R-rep
    fi;
    schutz := LambdaOrbStabChain(lambdao, m);

    # check if x is R-related to one of the known R-reps
    if not new and schutz <> false and IsBound(lambdarhoht[l][m]) then
      ind := lambdarhoht[l][m];
      if pos <> fail then
        AddSet(poset[i], datalookup[repslookup[m][ind][1]]);
      fi;
      return;
    fi;

    # if we reach here, then x is a new R-rep, and hence a new D-rep
    mm := rhoolookup[l];
    if l <> rhoscc[mm][1] then
      x := RhoOrbMult(rhoo, mm, l)[2] * x;
    fi;

    nr_d := nr_d + 1;
    d[nr_d] := rec();
    ObjectifyWithAttributes(d[nr_d], dtype, ParentAttr, I,
                            EquivalenceClassRelation, drel, IsGreensClassNC,
                            false, Representative, x, LambdaOrb, lambdao,
                            LambdaOrbSCCIndex, m, RhoOrb, rhoo, RhoOrbSCCIndex,
                            mm, RhoOrbSCC, rhoscc[mm]);

    # install the point in the poset
    if pos <> fail  then
      AddSet(poset[i], nr_d);
    fi;

    # install the R-class reps of the new D-rep
    mults := RhoOrbMults(rhoo, mm);

    for l in rhoscc[mm] do #install the R-class reps
      nr_r := nr_r + 1;
      y := mults[l][1] * x;
      orb[nr_r] := [I, m, lambdao, y, false, nr_r];
      htadd(ht, y, nr_r);

      lenreps[m] := lenreps[m] + 1;
      ind := lenreps[m];
      lambdarhoht[l][m] := ind; #this can't have been seen before
      reps[m][ind] := [y];
      repslookup[m][ind] := [nr_r];
      repslens[m][ind] := 1;
      orblookup1[nr_r] := ind;
      orblookup2[nr_r] := 1;
      rholookup[nr_r] := l;
      datalookup[nr_r] := nr_d;

      if looking then
        # did we find it?
        if lookfunc(data, orb[nr_r]) then
          data!.found := nr_r;
        fi;
      fi;

    od;
    log[nr_d + 1] := nr_r;
  end;
  #############################################################################

  # initialise the data if necessary
  if data!.init = false then
    # add the generators of the ideal...
    idealgens := GeneratorsOfSemigroupIdeal(I);
    for i in [1 .. Length(idealgens)] do
      UpdateSemigroupIdealData(idealgens[i], fail, fail, i);
    od;

    data!.init := true;
    data!.genspos := nr_d + 1;
  fi;

  i := data!.pos;       # points in orb in position at most i have descendants

  while nr_d <= limit and i < nr_d and i <> stopper do
    i := i + 1; # advance in the dorb
    poset[i] := [];
    x := Representative(d[i]);

    # left multiply the R-class reps by the generators of the semigroup
    rreps := [];
    scc := RhoOrbSCC(d[i]);
    pos := Position(lambdao, lambda(x));
    for j in [log[i] + 1 .. log[i + 1]] do  # the R-class reps of d[i]
      rreps[j - log[i]] := orb[j][4];
      for k in genstoapply do
        UpdateSemigroupIdealData(gens[k] * orb[j][4], pos, k, fail);
        if (looking and data!.found <> false)
            or (lambdalooking and lambdao!.found <> false)
            or (rholooking and rhoo!.found <> false) then
          data!.pos := i - 1;
          return data;
        fi;
      od;
    od;
    SetRClassReps(d[i], rreps);

    # right multiply the L-class reps by the generators of the semigroup
    pos := Position(rhoo, rho(x));
    for z in LClassReps(d[i]) do
      for k in genstoapply do
        UpdateSemigroupIdealData(z * gens[k], pos, k, fail);
        if (looking and data!.found <> false)
            or (lambdalooking and lambdao!.found <> false)
            or (rholooking and rhoo!.found <> false) then
          data!.pos := i - 1;
          return data;
        fi;
      od;
    od;
  od;

  # for the data-orbit
  data!.pos := i;

  if nr_d = i then
    SetFilterObj(lambdao, IsClosed);
    SetFilterObj(rhoo, IsClosed);
    SetFilterObj(data, IsClosedData);
  fi;

  return data;
end);
