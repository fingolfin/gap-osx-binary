#############################################################################
##  
##  PackageInfo.g for the package `Forms'                 
##                                                              John Bamberg
##                                                              Jan De Beule
##
##  (created from Frank Luebeck's PackageInfo.g template file)
##  

SetPackageInfo( rec( 
  PackageName := "Forms", 
  Subtitle := "Sesquilinear and Quadratic",
  Version := "1.2.2",
  Date := "29/08/2011",

##  URL of the archive(s) of the current package release, but *without*
##  the format extension(s), like '.zoo', which are given next.
##  The archive file name *must be changed* with each version of the archive
##  (and probably somehow contain the package name and version).
##  The paths of the files in the archive must begin with the name of the
##  directory containing the package (in our "example" probably:
##  example/init.g, ...    or  example-1.3/init.g, ...  )
# 
ArchiveURL := "http://cage.ugent.be/geometry/software/forms/forms-1.2.2",
ArchiveFormats := ".tar.gz -win.zip .tar.bz2",
Persons := [
  rec( 
    LastName      := "Bamberg",
    FirstNames    := "John",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "bamberg@maths.uwa.edu.au",
    WWWHome       := "http://school.maths.uwa.edu.au/~bamberg/",
    PostalAddress := Concatenation( [
                       "John Bamberg\n",
                       "School of Mathematics and Statistics\n",
                       "The University of Western Australia\n",
                       "35 Stirling Highway\n",
                       "CrawleyY WA 6009, Perth\n",
                       "Australia" ] ),
    Place         := "Perth",
    Institution   := "The University of Western Australia",
  ),
  rec( 
    LastName      := "De Beule",
    FirstNames    := "Jan",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "jdebeule@cage.ugent.be",
    WWWHome       := "http://cage.ugent.be/~jdebeule",
    PostalAddress := Concatenation( [
                       "Jan De Beule\n",
                       "Department of Mathematics\n",
                       "Ghent University\n",
                       "Krijgslaan 281, S22\n",
                       "B-9000 Ghent\n",
                       "Belgium" ] ),
    Place         := "Ghent",
    Institution   := "Ghent University",
  ),
],

Status := "accepted",
README_URL := "http://cage.ugent.be/geometry/software/forms/README",
PackageInfoURL := "http://cage.ugent.be/geometry/software/forms/PackageInfo.g",
AbstractHTML := "This package can be used for work with sesquilinear and quadratic forms on finite vector spaces; objects that are used to describe polar spaces and classical groups.",

PackageWWWHome := "http://cage.ugent.be/geometry/forms.php",
            
PackageDoc := rec(
  # use same as in GAP            
  BookName  := "Forms",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Forms - Sesquilinear and Quadratic",
  Autoload  := true),

Dependencies := rec(
  GAP := ">=4.4",
  NeededOtherPackages := [["GAPDoc", ">= 0.99"]],
  SuggestedOtherPackages := [],
  ExternalConditions := []),

AvailabilityTest := function()
    return true;
  end,

BannerString := Concatenation( 
  "---------------------------------------------------------------------\n",
  "Loading 'Forms' ", ~.Version," (", ~.Date,")", "\n",
  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,
        " (", ~.Persons[1].WWWHome, ")\n",
  "   ", ~.Persons[2].FirstNames, " ", ~.Persons[2].LastName,
        " (", ~.Persons[2].WWWHome, ")\n",
   "For help, type: ?Forms \n",
  "---------------------------------------------------------------------\n" ),

Autoload := false,
Keywords := ["Forms", "Sesquilinear", "Quadratic"],

CommunicatedBy := "Leonard Soicher (London)",
AcceptDate := "03/2009"

));


