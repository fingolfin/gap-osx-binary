#############################################################################
##  
##  PackageInfo.g for the package "SymbCompCC"       Dörte Feichtenschlager
##  

SetPackageInfo( rec(
PackageName := "SymbCompCC",
Subtitle := "Computing with parametrised presentations for p-groups of fixed coclass",
Version := "1.2",
Date := "19/11/2011",

ArchiveURL := Concatenation( [
          "http://www.icm.tu-bs.de/ag_algebra/software/feichten/SymbCompCC/SymbCompCC-", ~.Version] ),

##  All provided formats as list of file extensions, separated by white
##  space or commas.
ArchiveFormats := ".tar.bz2, .tar.gz",

Persons := [
  rec( 
    LastName      := "Feichtenschlager",
    FirstNames    := "Dörte",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "d.feichtenschlager@tu-braunschweig.de",
    #WWWHome       := "",
    PostalAddress := Concatenation([
                     "Institut Computational Mathematics\n",
                     "TU Braunschweig\n",
                     "Pockelsstr. 14 \n D-38106 Braunschweig \n Germany"] ),
    Place         := "Braunschweig",
    Institution   := "TU Braunschweig"
  )
],

Status := "accepted",
CommunicatedBy := "Mike Newman (Canberra, Australia)",
AcceptDate := "11/2011",

README_URL := 
  "http://www.icm.tu-bs.de/ag_algebra/software/feichten/SymbCompCC/README",
PackageInfoURL := 
  "http://www.icm.tu-bs.de/ag_algebra/software/feichten/SymbCompCC/PackageInfo.g",

AbstractHTML := 
  "The <span class=\"pkgname\">SymbCompCC</span> package computes with parametrised presentations for finite p-groups of fixed coclass.",

PackageWWWHome := "http://www.icm.tu-bs.de/ag_algebra/software/SymbCompCC",
               
PackageDoc := rec(
BookName  := "SymbCompCC",
ArchiveURLSubset := ["doc", "htm"],
HTMLStart := "htm/chapters.htm",
PDFFile   := "doc/manual.pdf",
SixFile   := "doc/manual.six",
LongTitle := "SymbCompCC/Symbolic computation with p-groups of fixed coclass",
Autoload  := false
),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [["polycyclic", ">= 2.2"]],
  ExternalConditions := []
),

AvailabilityTest := ReturnTrue,
BannerString := Concatenation( "Loading SymbCompCC ",
                               String( ~.Version ), " ...\n" ),
Autoload := false,

Keywords := ["parametrised presentations for p-groups of fixed coclass and calculations with these"]

));

