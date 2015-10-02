###############
# given integers a and b and another one, which stays for the origin,
# computes a table with b columns (or b+1 when rep is "true"), a row whose
# first element is the origin, depth rows below the origin and height rows
# above.  
# The row containing the origin is 
#origin + [0..b-1]*a;
#or, when rep is "true", 
###origin-a + [0..b]*a;
#origin + [0..b]*a;
# The remaining rows are obtained by adding b (the upper ones) or subtracting b
# (the others)
##
# Note: when a<b are coprime, this construction provides a representation of the
# integers as an array. 
# The first five arguments arguments "origin, a, b,depth and height" have the above meanings. 
# when the sixth argument, rep, is "true", there is some repetition: the last column is equal to the first, but pushed up a rows
# When the seventh is "true", no rows below 0 are considered, (contradicting "depth, if needed)
InstallGlobalFunction(IP_TableWithModularOrder,
        function(origin,a,b,depth,height,rep,pos)
  local  row, i, table, b_row, u_row;


  if rep then #"repeats" the first and last column
    row := origin + [0..b]*a;
  else
    row := origin + [0..b-1]*a;
  fi;
  table := [row];
  for i in [1 .. depth] do
    b_row := table[1] - b;
    table := Concatenation([b_row],table);
    if pos and (0 in b_row) then
      break;
    fi;
  od;
  ##  Unbind(table[1][1]);

  for i in [1..height] do
    u_row := table[Length(table)] +b;
    Append(table,[u_row]);
  od;
  return table;
end);
