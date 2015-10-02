##########################################################################
##########################################################################
##
# The aim of this function is to "splash" an image directly from the tikz code.
# To this effect, it adds a preamble and makes a call to the Viz Splash function.
# To avoid forcing the user to install the Viz package (under development), a copy of the Viz Splash function is included in the file "splash_from_viz.g" of this package
## example
#IP_Splash(TikzCodeForNumericalSemigroup(NumericalSemigroup(7,13,19,23),[[3,4],"pseudo_frobenius","small_elements","special_gaps","fundamental_gaps"],20),rec(viewer := "evince"));

InstallGlobalFunction(IP_Splash,
        function(arg)
  local  opt, tk, ltx;
  
  opt := First(arg, IsRecord);
  tk := First(arg, IsString);
  
  ltx := Concatenation("%tikz\n",IP_Preamble,tk,IP_Closing);
  if opt = fail then
    Splash(ltx);
  else
    Splash(ltx,opt);
  fi;  
end);

