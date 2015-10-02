#############################################################################
##
#W  init.g          GAP 4 package `Browse'        Thomas Breuer, Frank Lübeck
##
#Y  Copyright (C) 2006-2007, Lehrstuhl D für Mathematik, RWTH Aachen, Germany
##

# make sure that TERM is set in environment, if not we set it to "dumb"
# (here only in GAP's info about the environment setting, but in kernel
# code we also change the actual environment)
if not IsBound(GAPInfo.SystemEnvironment.TERM) then
  GAPInfo.SystemEnvironment.TERM := "dumb";
fi;

# load kernel module
if (not IsBound(NCurses)) and 
   ("ncurses" in SHOW_STAT()) then
  # try static module
  LoadStaticModule("ncurses");
fi;
if (not IsBound(NCurses)) and 
   (Filename(DirectoriesPackagePrograms("Browse"), "ncurses.so") <> fail) then
  LoadDynamicModule(Filename(DirectoriesPackagePrograms("Browse"), 
    "ncurses.so"));
fi;

# check if the kernel module was loaded and has correct version
if not IsBound(NCurses) then
  if UserPreference("browse", "loadwithoutncurses") <> true then
    Unbind(GAPInfo.PackagesLoaded.browse);
    Error("Browse: Something went wrong with loading the kernel module.\n");
  else
    # read a fake NCurses record and reset user preferences
    LogPackageLoadingMessage( PACKAGE_WARNING,
        [ "Loaded fake NCurses record because ('loadwithoutncurses' set)" ] );
    ReadPackage("Browse", "lib/fakeNCurses.g");
    NCurses.KernelModuleVersion := GAPInfo.PackagesLoaded.browse[2];
    Append(GAPInfo.PackagesLoaded.browse[3], 
           " Without NCurses PLEASE COMPILE!!!");
    SetUserPreference( "browse", "SelectHelpMatches", false );
    SetUserPreference( "browse", "SelectPackageName", false );
    SetUserPreference( "browse", "EnableMouseEvents", false );
  fi;
fi;
if GAPInfo.PackagesLoaded.browse[2] <> NCurses.KernelModuleVersion then
  GAPInfo.browseerror := Concatenation("Browse: Kernel module has version ", 
      NCurses.KernelModuleVersion, " but version ", 
      GAPInfo.PackagesLoaded.browse[2], " is to be loaded.\n");
  Unbind(GAPInfo.PackagesLoaded.browse);
  Error(GAPInfo.browseerror);
fi;

ReadPackage("Browse", "lib/ncurses.gd");
ReadPackage("Browse", "lib/browse.gd");

# support for database attributes
ReadPackage( "Browse", "lib/brdbattr.gd" );

# utilities for Browse applications (must be read before `read.g')
ReadPackage( "Browse", "lib/brutils.g" );

Browse_svnRevision := "536";
