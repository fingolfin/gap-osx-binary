
KuroshAlgebraByLib := function( d, n, F )
    if n = 2 then 
        return KuroshAlgebra(d,n,F);
    elif n = 3 and d = 2 then 
        return KuroshAlgebra(d,n,F);
    elif n = 3 and d = 3 then 
        if F = Rationals then 
            return Kur_3_3_Q();
        elif F = GF(3) then 
            return Kur_3_3_3();
        elif F = GF(2) then 
            return Kur_3_3_2();
        elif F = GF(4) then 
            return Kur_3_3_4();
        fi;
    elif n = 3 and d = 4 then 
        if F = Rationals then 
            return Kur_4_3_Q();
        elif F = GF(3) then 
            return Kur_4_3_3();
        elif F = GF(2) then 
            return Kur_4_3_2();
        elif F = GF(4) then 
            return Kur_4_3_4();
        fi;
    elif n = 4 and d = 2 then 
        if F = Rationals then 
            return Kur_2_4_Q();
        elif F = GF(3) then 
            return Kur_2_4_3();
        elif F = GF(9) then 
            return Kur_2_4_9();
        elif F = GF(2) then 
            return Kur_2_4_2();
        elif F = GF(4) then 
            return Kur_2_4_4();
        fi;
    elif n = 5 and d = 2 then 
        if F = Rationals then
            return Kur_2_5_Q(); 
        elif F = GF(5) then 
            return Kur_2_5_5();
        elif F = GF(3) then 
            return Kur_2_5_3();
        elif F = GF(9) then 
            return Kur_2_5_9();
        elif F = GF(2) then 
            return Kur_2_5_2();
        elif F = GF(4) then 
            return Kur_2_5_4();
        elif F = GF(8) then 
            return Kur_2_5_8();
        fi;
    fi;
    return fail;
end;

