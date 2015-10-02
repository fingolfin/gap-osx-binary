#############################################################################
##  
#W  unitlib.gi             The UnitLib package            Alexander Konovalov
#W                                                            Elena Yakimenko
##
#############################################################################


#############################################################################
#
# PcNormalizedUnitGroupSmallGroup( n, nLibNumber )
#
InstallGlobalFunction( PcNormalizedUnitGroupSmallGroup,
function( n, nLibNumber )
local G, p, K, KG, filename, libfile, gzfile, code, V, i, fam;
if not IsPrimePowerInt( n ) then
  Error( "Underlying group is not a p-group !!! \n" );
fi;
if n > 243 then
  Print( "WARNING : the library of V(KG) for groups of order ", n, 
         " is not available yet !!! \n", 
	 "You can use only groups from the unitlib/userdata directory \n",
	 "in case if you already computed their descriptions \n",
	 "(See the manual for SavePcNormalizedUnitGroup).\n" );
fi;
G := SmallGroup( n, nLibNumber );
p := PrimePGroup( G );
fam := FamilyObj( One( G ) );
K := GF( p );
KG:= GroupRing( K, G );
# Attention - file name without extension 
filename:=Concatenation( "u", String(n), "_", String(nLibNumber) );

if IsPrimeInt(n) then

  libfile := Concatenation( 
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,
               "/data/primeord/", filename, ".g" );

elif n=128 then

  if not ARCH_IS_UNIX() then
    Error("UnitLib package : the library of normalized unit groups \n", 
          "of modular group algebras of groups of order 128 is compressed\n",
  	      "with gzip. To read it under Windows you need to unpack it manually\n",
  	      "and adjust the package code to read .g file instead of .gz\n");
  fi;
  gzfile := Concatenation( 
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,
               "/data/128/", filename, ".g.gz" );
  libfile := Filename( DirectoryTemporary(), "filename");
  Exec( Concatenation( "gunzip -c ", gzfile, " > ", libfile ) );

elif n=243 then

  libfile := Concatenation(                                                         
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,                
	       "/data/243/", filename, ".gg" );

elif not n in [2..243] then

  # Probably the group was computed and saved by the user. 
  # If not, the error will occur later

  libfile := Concatenation(                                                         
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,                
	       "/userdata/", filename, ".g" );

else

  libfile := Concatenation(                                                         
               GAPInfo.PackagesInfo.("unitlib")[1].InstallationPath,                
	       "/data/", String(n), "/", filename, ".g" );

fi;


code := ReadAsFunction(libfile)();


if n=128 then

  Exec( Concatenation("rm ", libfile ) );

elif n=243 then
  
  code[1] := SingleHTTPRequest( "alexk.host.cs.st-andrews.ac.uk", 80, "GET", 
       Concatenation( "/unitlib/data/243/u243_",  String(nLibNumber), ".txt"), 
       rec( ), false, false ).body;
  if Length(code[1]) = 0 then
    Error("Can not retrieve remote data");
  fi;
  Info( LAGInfo, 1, "Data retrieved successfully, starting generation of V(KG) ..." );

elif n>243 then

  Info( LAGInfo, 1, "Description of V(KG) for G=SmallGroup(",n,",",nLibNumber,
                    ") accepted, started its generation...");

fi;


SetDimensionBasis(G, rec( dimensionBasis := List( code[2][1], 
                                              i -> ObjByExtRep( fam, i ) ), 
                          weights := code[2][2] ) );
V := PcGroupCode( IntHexString(code[1]), p^(n-1) );
SetIsGroupOfUnitsOfMagmaRing( V, false );
SetIsNormalizedUnitGroupOfGroupRing( V, true );
SetIsPGroup( V, true );
SetPcNormalizedUnitGroup( KG, V );
SetUnderlyingGroupRing( V, KG );
return V;
end );


#############################################################################
#
# SavePcNormalizedUnitGroup( G )
#
InstallGlobalFunction( SavePcNormalizedUnitGroup,
function( G )
local p, K, KG, V, codestring, libfile, output, d, x;
if not IsPGroup( G ) then
  Error( "<G> is not a p-group !!! \n" );
fi;
if Size(G) <= 243 then
  Print( "WARNING : the normalized unit group V(KG) of the modular group algebra \n",
         " of the given group <G> is already included in the library and \n", 
	 "You can access it using the function PcNormalizedUnitGroupSmallGroup.\n",
	 "The description you are going to generate will be stored in the directory \n",
	 "unitlib/userdata, but will be not used by PcNormalizedUnitGroupSmallGroup. \n" );
fi;
p := PrimePGroup( G );
K := GF( p );
KG:= GroupRing( K, G );
V := PcNormalizedUnitGroup( KG );
codestring := HexStringInt( CodePcGroup( V ) );
libfile := Concatenation( 
             GAPInfo.PackagesInfo.( "unitlib" )[1].InstallationPath,
             "/userdata/u",
             String( IdGroup( G )[1] ), "_",
             String( IdGroup( G )[2] ), ".g");
output := OutputTextFile( libfile, false );
SetPrintFormattingStatus( output, false );
PrintTo(  output, "return [ " );
AppendTo( output, "\042", codestring, "\042" );
AppendTo( output, ", ");
AppendTo( output, [ List( DimensionBasis( G ).dimensionBasis, ExtRepOfObj), 
                    DimensionBasis( G ).weights ] );
AppendTo( output, " ];" );
CloseStream( output );
return true; 
end );


#############################################################################
##
#E
##
