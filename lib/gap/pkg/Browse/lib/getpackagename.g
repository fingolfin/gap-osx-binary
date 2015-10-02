#############################################################################
##
#W  getpackagename.g      GAP 4 package `Browse'                Thomas Breuer
##
#Y  Copyright (C) 2012,   Lehrstuhl D für Mathematik,  RWTH Aachen,   Germany
##
##  This file contains a utility for `LoadPackage' in case several package
##  names match the first argument.
##  The library function just replaces an exact match and otherwise prints an
##  info message about all matches.
##  We overwrite this function by the opportunity to choose one match.
##

DeclareUserPreference( rec(
    name:= "SelectPackageName",
    description:= [
"In the case that 'LoadPackage' is called with a prefix of some \
package names, 'true' means that the user can choose one matching entry, \
and 'false' means that the matches are just printed" ],
    default:= true,
    values:= [ true, false ],
    multi:= false,
    ) );

## reset to false for 'dumb' terminals
if GAPInfo.SystemEnvironment.TERM = "dumb" then
  SetUserPreference("browse", "SelectPackageName", false);
fi;

#############################################################################
##
#F  GetPackageNameForPrefix( <prefix> ) . . . . . . . .  show list of matches
#F                                                   or single match directly
##

BindGlobal( "GetPackageNameForPrefix_LIB", GetPackageNameForPrefix );
MakeReadWriteGlobal( "GetPackageNameForPrefix" );
UnbindGlobal( "GetPackageNameForPrefix" );

DeclareGlobalFunction( "GetPackageNameForPrefix" );
InstallGlobalFunction( GetPackageNameForPrefix, function( prefix )
    local len, lowernames, name, allnames, c;

    if UserPreference( "browse", "SelectPackageName" ) = false then
      return GetPackageNameForPrefix_LIB( prefix );
    fi;

    len:= Length( prefix );
    lowernames:= [];
    for name in Set( RecNames( GAPInfo.PackagesInfo ) ) do
      if Length( prefix ) <= Length( name ) and
         name{ [ 1 .. len ] } = prefix then
        Add( lowernames, name );
      fi;
    od;
    if IsEmpty( lowernames ) then
      # No package name matches.
      return prefix;
    fi;
    allnames:= List( lowernames,
                     nam -> GAPInfo.PackagesInfo.( nam )[1].PackageName );
    if Length( allnames ) = 1 then
      # There is one exact match.
      LogPackageLoadingMessage( PACKAGE_DEBUG, Concatenation(
          [ "replace prefix '", prefix, "' by the unique completion '",
            allnames[1], "'" ] ), allnames[1] );
      return lowernames[1];
    fi;

    # Several package names match.
    c:= NCurses.Select( rec(
            items  := allnames,
            none   := true,
            border := true,
            header := [ NCurses.attrs.BOLD,
          "   Choose an entry, 'q' for none:" ] ) );
    if c = false then
      # The user did not choose an entry.
      return prefix;
    fi;

    LogPackageLoadingMessage( PACKAGE_DEBUG, Concatenation(
        [ "replace prefix '", prefix, "' by the user choice '",
          allnames[c], "'" ] ), allnames[c] );
    return lowernames[c];
    end );


#############################################################################
##
#E

