#############################################################################
##  
#W  testlib.g              The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#############################################################################

#############################################################################
##
##  UNITLIBTestLibrary()
##
##  This is a function to check the completeness of the library
##  (requires a UNIX environment)
##
UNITLIBTestLibrary := function()
local datapath, testresult, size, missing, n, libfile, s;

  datapath := Concatenation(
                GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath, 
	        "/data/" );
  testresult := true;		

  for size in Filtered( [ 2 .. 243 ], IsPrimePowerInt) do

    missing := [];
    
    # Print( NrSmallGroups(size), " group(s) of order ", size, "\n" );

    for n in [ 1 .. NrSmallGroups( size ) ] do

      # Print( n, "\r");
      
      if IsPrimeInt( size ) then
        libfile := Concatenation( datapath, "primeord", 
		   "/u", String(size), "_", String(n) );
      else      
        libfile := Concatenation( datapath, String(size), 
		   "/u", String(size), "_", String(n) );
      fi;

      if size=128 then
        libfile := Concatenation( libfile, ".g.gz" );
      elif size=243 then
        libfile := Concatenation( libfile, ".gg" );
      else
        libfile := Concatenation( libfile, ".g" );
      fi;      

      if not IsExistingFile(libfile) then
        Add( missing, n );
	testresult := false;
      fi;
      
      if size=243 then
        s:= SingleHTTPRequest( "www.cs.st-andrews.ac.uk", 80, "GET", 
              Concatenation( "/~alexk/unitlib/data/243/u243_",  String(n), ".txt"), 
              rec( ), false, false ).body;
       
	# if we are not online, we will get the wrong string
	if s <> "" then		
	  # if the file is missing on the server, 
	  # we can not perform the next command 
          s:=IntHexString(s);
	fi;
      fi;

    od;

    if Length(missing) > 0 then
      Print( Length(missing), " missing groups for order ", size, " : ", missing, "\n");
    fi;
  od;
  if testresult then
    Print("UnitLib library is complete - no missing files!!!\n");
    return true;
  else
    Print("UnitLib library is incomplete - some files are not available!!!\n");
    return false;
  fi;
end;


#############################################################################
##
#E
##