QuickRandomize := function(m)
  local f,i,j,n,posx,posy,urposx,urposy;
  f := BaseDomain(m);
  if Length(m) < 97 then
      Randomize(m);
      return;
  fi;
  n := ExtractSubMatrix(m,[1..97],[1..97]);
  Randomize(n);
  for i in [1..QuoInt(RowLength(m)+96,97)] do
      for j in [1..QuoInt(Length(m)+96,97)] do
          posx := [(i-1)*97+1..Minimum(RowLength(m),i*97)];
          posy := [(j-1)*97+1..Minimum(Length(m),j*97)];
          urposx := [1..Length(posx)];
          urposy := [1..Length(posy)];
          CopySubMatrix(Random(f)*n,m,urposy,posy,urposx,posx);
      od;
  od;
end;
  
QuickRandomMat := function(n,m,p,d)
  local cl,i,j,l,le,nrblocks,q,qadic,r,rs,tab;

  qadic := function(n,p,le) 
    local l,x; 
    l := []; 
    while le > 0 do
        x := QuotientRemainder(n,p);
        Add(l,x[2]); 
        n := x[1];
        le := le - 1;
    od; 
    return l; 
  end;

  q := p^d;
  if q > 1024 then Error("only q <= 1024 supported"); fi;

  le := LogInt(1024,q);
  tab := List([0..q^le-1],x->qadic(x,q,le));

  cl := CVecClass(p,d,m);
  l := 0*[1..n];
  nrblocks := QuoInt(m+le-1,le);
  r := ListWithIdenticalEntries(le*nrblocks,0);
  rs := RandomSource(IsMersenneTwister);
  for i in [1..n] do
      for j in [1..nrblocks] do
          r{[1+(j-1)*le..j*le]} := 
               tab[RandomIntegerMT(rs!.state,10) mod q^le + 1];
      od;
      while Length(r) > m do Unbind(r[Length(r)]); od;
      l[i] := CVec(r,cl);
  od;
  return MutableCopyMat(CMat(l,cl));
end;

MatMulSpeedTest := function(p,d,what)
  local a,b,f,i,l,m,mm,n,reps,t,ti,x;
  f := GF(p,d);
  l := [];
  Print("Randomizing 2 matrices n=",Maximum(what),"...\c");
  m := QuickRandomMat(Maximum(what),Maximum(what),p,d);
  mm := QuickRandomMat(Maximum(what),Maximum(what),p,d);
  Print("done.\n");
  for n in what do
      a := ExtractSubMatrix(m,[1..n],[1..n]);
      b := ExtractSubMatrix(mm,[1..n],[1..n]);
      GASMAN("collect");
      t := Runtime();
      x := a*b;
      Unbind(x);
      #x := MultiplyWinograd2(a,b,false,n/2);
      t := Runtime()-t;
      if t < 5000 then
          if t = 0 then 
              reps := 2000;
          else
              reps := QuoInt(5000,t);
          fi;
          t := Runtime();
          for i in [1..reps] do
              x := a*b;
              Unbind(x);
              #x := MultiplyWinograd2(a,b,false,n/2);
          od;
          t := Runtime()-t;
      else
          reps := 1;
      fi;
      ti := FLOAT_INT(t)/FLOAT_INT(reps);
      Add(l,[n,ti]);
      Print("Field: GF(",p,",",d,"), size: ",n,", time: ",
            STRING_FLOAT(ti)," [ms]\n");
  od;
  for i in [1..Length(what)] do
      Print(l[i][1]," ",l[i][2],"\n");
  od;
  return l;
end;

MatMulSpeedTest2 := function(p,d,what,m,mm)
  local a,b,f,i,l,n,reps,t,ti,x;
  f := GF(p,d);
  l := [];
  for n in what do
      a := ExtractSubMatrix(m,[1..n],[1..n]);
      b := ExtractSubMatrix(mm,[1..n],[1..n]);
      GASMAN("collect");
      t := Runtime();
      x := a*b;
      Unbind(x);
      #x := MultiplyWinograd2(a,b,false,n/2);
      t := Runtime()-t;
      if t < 5000 then
          if t = 0 then 
              reps := 2000;
          else
              reps := QuoInt(5000,t);
          fi;
          t := Runtime();
          for i in [1..reps] do
              x := a*b;
              Unbind(x);
              #x := MultiplyWinograd2(a,b,false,n/2);
          od;
          t := Runtime()-t;
      else
          reps := 1;
      fi;
      ti := FLOAT_INT(t)/FLOAT_INT(reps);
      Add(l,[n,ti]);
      Print("Field: GF(",p,",",d,"), size: ",n,", time: ",
            STRING_FLOAT(ti)," [ms]\n");
  od;
  for i in [1..Length(what)] do
      Print(l[i][1]," ",l[i][2],"\n");
  od;
  return l;
end;

MatMulSpeedTestForWinograd := function(p,d,what,m,mm,nrwino)
  local a,b,bo,count,f,i,l,n,q,reps,t,ti,x;
  f := GF(p,d);
  q := p^d;
  l := [];
  for n in what do
      a := ExtractSubMatrix(m,[1..n],[1..n]);
      b := ExtractSubMatrix(mm,[1..n],[1..n]);
      count := nrwino;
      if count = 0 then
          CVEC_WinogradBounds[q] := (n+1)^2;
      else
          bo := n;
          while count > 1 do
              count := count - 1;
              bo := QuoInt(bo+1,2);
          od;
          CVEC_WinogradBounds[q] := bo^2;
      fi;
      GASMAN("collect");
      t := Runtime();
      x := a*b;
      t := Runtime()-t;
      Unbind(x);
      if t < 1000 then
          if t = 0 then 
              reps := 2000;
          else
              reps := QuoInt(1000,t);
          fi;
      else
          reps := 1;
      fi;
      GASMAN("collect");
      t := Runtime();
      for i in [1..reps] do
          x := a*b;
          Unbind(x);
      od;
      t := Runtime()-t;
      ti := FLOAT_INT(t)/FLOAT_INT(reps);
      Add(l,[n,ti]);
      Print("Field: GF(",p,",",d,"), size: ",n,", time: ",
            STRING_FLOAT(ti)," [ms]\n");
  od;
  for i in [1..Length(what)] do
      Print(l[i][1]," ",l[i][2],"\n");
  od;
  return l;
end;


fishy := [];

FindWinogradLimit := function(p,d)
  local a,count,i,lasttime,lowlim,m,mm,mmm,n,nn,nnn,size,sizeh,t,time,time2,
        uplim;
  lasttime := infinity;
  size := 100;
  m := QuickRandomMat(size,size,p,d);
  n := QuickRandomMat(size,size,p,d);
  GASMAN("collect");
  count := 0;
  t := Runtime();
  repeat
      a := m*n;
      count := count + 1;
      time := Runtime() - t;
  until time > 30;
  Print("Using repetition count of ",count,"\n");

  GASMAN("collect");
  t := Runtime();
  for i in [1..count] do a := m*n; od;
  time := Runtime() - t;
  if time = 0 then time := 1; fi;
  Print("Size=",size," time=",time,"\n");

  # now count is the repetition

  repeat
      lasttime := time;
      size := size * 2;
      m := QuickRandomMat(size,size,p,d);
      n := QuickRandomMat(size,size,p,d);
      GASMAN("collect");
      t := Runtime();
      for i in [1..count] do a := m*n; od;
      time := Runtime() - t;
      if time = 0 then time := 1; fi;
      Print("Size=",size," time=",time," factor=",
            FLOAT_INT(time)/FLOAT_INT(lasttime),"\n");
  until 15 * lasttime < 2 * time or     # time > 7.5 * lasttime
        size = 1600;   # in case a mistake in measurement occurs

  if time/lasttime < 15/2 then   # something strange has happened:
      Print("Giving up, very strange, using limit=100000...\n\n");
      return 100000;
  fi;

  # now reduce count :
  count := Maximum(QuoInt(count,Maximum(1,QuoInt(time,2000))),1);
  Print("Changing repetition count to ",count,"\n");

  uplim := size;
  lowlim := size/2;
  while uplim-lowlim > 1 do
      size := QuoInt(uplim+lowlim,2);
      mm := ExtractSubMatrix(m,[1..size],[1..size]);
      nn := ExtractSubMatrix(n,[1..size],[1..size]);
      sizeh := QuoInt(size,2);
      mmm := ExtractSubMatrix(m,[1..sizeh],[1..sizeh]);
      nnn := ExtractSubMatrix(n,[1..sizeh],[1..sizeh]);
      GASMAN("collect");
      t := Runtime();
      for i in [1..count] do a := mm*nn; od;
      time := Runtime() - t;
      GASMAN("collect");
      t := Runtime();
      for i in [1..count] do a := mmm*nnn; od;
      time2 := Runtime() - t;
      Print("Size=",size," time=",time," time2=",time2," factor=",
            FLOAT_INT(time)/FLOAT_INT(time2),"\n");
      if time2 = 0 or time/time2 > 15/2 then
          uplim := size;
      else
          lowlim := size;
      fi;
  od;
  if time2 = 0 or time/time2 < 7 or time/time2 > 8 then
      Add(fishy,[p,d,FLOAT_INT(time)/FLOAT_INT(time2),uplim]);
  fi;
      
  Print("Result: limit=",uplim," memory for such matrices: ",
        Memory(ExtractSubMatrix(m,[1..uplim],[1..uplim])),"\n\n");
  return uplim;
end;

FindWinogradLimit2 := function(p,d)
  local a,count,i,m,merk,merk2,minuses,n,pluses,q,size,t,time,time2;
  size := 800;
  m := QuickRandomMat(size,size,p,d);
  n := QuickRandomMat(size,size,p,d);
  GASMAN("collect");
  count := 0;
  t := Runtime();
  repeat
      a := m*n;
      count := count + 1;
      time := Runtime() - t;
  until time > 500;
  
  q := p^d;
  Print(q,":\nUsing repetition count of ",count,"\n");
  if IsBound(CVEC_WinogradBounds[q]) then
      merk2 := CVEC_WinogradBounds[q];
  else
      merk2 := 10000^2;
  fi;
  CVEC_WinogradBounds[q] := 10000^2;
  pluses := 0;
  minuses := 0;
  repeat
    m := QuickRandomMat(size,size,p,d);
    n := QuickRandomMat(size,size,p,d);
    merk := CVEC_WinogradBounds[q];
    GASMAN("collect");
    t := Runtime();
    for i in [1..count] do a := m*n; od;
    time := Runtime() - t;
    CVEC_WinogradBounds[q] := size*size;
    GASMAN("collect");
    t := Runtime();
    for i in [1..count] do a := m*n; od;
    time2 := Runtime() - t;
    Print("Size: ",size," count: ",count," without: ",time," with: ",time2);
    if 20 * time2 > time * 21 or (time2 > time and pluses = 0) then   
        # not worthwhile
        CVEC_WinogradBounds[q] := merk;
        pluses := 0;
        minuses := minuses + 1;
        Print(" -\n");
    else
        if merk < CVEC_WinogradBounds[q] then
            if minuses >= 3 then
                CVEC_WinogradBounds[q] := 10000^2;
            else
                CVEC_WinogradBounds[q] := merk;
            fi;
            
        fi;
        Print(" +\n");
        pluses := pluses + 1;
        minuses := 0;
    fi;
    if time > 1000 and count > 1 then
        count := Maximum(QuoInt(count,2),1);
    fi;
    size := size + 100;
  until size >= 4000 or (size >= 2000 and q > 16) or pluses >= 20;
  merk := CVEC_WinogradBounds[q];   # the result
  CVEC_WinogradBounds[q] := merk2;
  if pluses >= 2 then
      Print("\nResult: ",Sqrt(merk),"\n");
      return Sqrt(merk);
  else
      Print("\nResult: ",10000,"\n");
      return 10000;
  fi;
end;


FindAllWinogradLimits := function()
  local d,f,facs,i,p,q;
  CVEC_WinogradBounds := [];
  fishy := [];
  q := Filtered([2..1024],IsPrimePowerInt);
  f := List(q,Factors);
  p := List(f,x->x[1]);
  d := List(f,x->Length(x));
  facs := [];
  for i in [1..Length(q)] do
      Print("Testing q=",q[i]," p=",p[i]," d=",d[i],"...\n");
      facs[q[i]] := FindWinogradLimit(p[i],d[i])^2;
  od;
  CVEC_WinogradBounds := facs;
  return facs;
end;

FindAllWinogradLimits2 := function()
  local d,f,facs,i,p,q;
  CVEC_WinogradBounds := [];
  fishy := [];
  q := Filtered([2..1024],IsPrimePowerInt);
  f := List(q,Factors);
  p := List(f,x->x[1]);
  d := List(f,x->Length(x));
  facs := [];
  for i in [1..Length(q)] do
      Print("Testing q=",q[i]," p=",p[i]," d=",d[i],"...\n");
      facs[q[i]] := FindWinogradLimit2(p[i],d[i])^2;
  od;
  CVEC_WinogradBounds := facs;
  return facs;
end;

