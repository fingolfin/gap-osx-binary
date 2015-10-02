#############################################################################
##
##  read.g                   The SpinSym Package                 Lukas Maas              
##
#############################################################################

## read the install files

ReadPackage( "spinsym", "gap/mtx.gi" );
ReadPackage( "spinsym", "gap/fus.gi" );
ReadPackage( "spinsym", "gap/young.gi" );

## SPINSYM_INIT() notifies the GAP Character Table Library CTblLib of
## SpinSym's ordinary and modular tables of alternating and symmetric
## groups and their double covers

BindGlobal( "SPINSYM_INIT", function()
  local dir, n, ordfile;

  dir:= Directory( Concatenation(
               PackageInfo("spinsym")[1].InstallationPath, "/symdata" ) );

  for n in [ 2 .. 19 ] do
    ordfile:= Filename( dir, Concatenation(  "ctoa", String( n ) ) );
    NotifyCharacterTable( Concatenation( "Alt(", String( n ), ")" ),
                          ordfile, [] );
    ordfile:= Filename( dir, Concatenation( "cto2a", String( n ) ) );
    NotifyCharacterTable( Concatenation( "2.Alt(", String( n ), ")" ),
                          ordfile, [] );
    ordfile:= Filename( dir, Concatenation( "ctos", String( n ) ) );
    NotifyCharacterTable( Concatenation( "Sym(", String( n ), ")" ),
                          ordfile, [] );
    ordfile:= Filename( dir, Concatenation( "cto2s", String( n ) ) );
    NotifyCharacterTable( Concatenation( "2.Sym(", String( n ), ")" ),
                          ordfile, [] );
  od;

end );

## run SPINSYM_INIT()
SPINSYM_INIT();

