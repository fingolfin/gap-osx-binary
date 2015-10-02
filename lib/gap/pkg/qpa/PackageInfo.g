SetPackageInfo( rec(
PackageName := "QPA",
Subtitle := "Quivers and Path Algebras",
Version := "1.21",
Date := "03/06/2015",

ArchiveURL := Concatenation( "http://www.math.ntnu.no/~oyvinso/QPA/qpa-version-","1.21"),

ArchiveFormats := ".tar.gz",

Persons := [
  rec( 
    LastName      := "Green",
    FirstNames    := "Edward",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "green@math.vt.edu",
    WWWHome       := "http://www.math.vt.edu/people/green",
    PostalAddress := Concatenation( [
		       "Department of Mathematics\n",
		       "Virginia Polytechnic Institute and State  University\n",
		       "Blacksburg, Virginia\n",
                       "U.S.A." ] ),
    Place         := "Blacksburg",
    Institution   := "Virginia Polytechnic Institute and State  University"
           ),
  rec( 
    LastName      := "Solberg",
    FirstNames    := "Oeyvind",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "oyvind.solberg@math.ntnu.no",
    WWWHome       := "http://www.math.ntnu.no/~oyvinso/",
    PostalAddress := Concatenation( [
		       "Department of Mathematical Sciences\n",
		       "NTNU\n",
		       "N-7491 Trondheim\n",
                       "Norway" ] ),
    Place         := "Trondheim",
    Institution   := "Norwegian University of Science and Technology"
  )              
],

Status := "deposited",

##  You must provide the next two entries if and only if the status is 
##  "accepted" because is was successfully refereed:
# format: 'name (place)'
# CommunicatedBy := "Mike Atkinson (St. Andrews)",
#CommunicatedBy := "",
# format: mm/yyyy
# AcceptDate := "08/1999",
#AcceptDate := "",

README_URL := "http://www.math.ntnu.no/~oyvinso/QPA/README",
PackageInfoURL := "http://www.math.ntnu.no/~oyvinso/QPA/PackageInfo.g",

AbstractHTML := "The <span class=\"pkgname\">QPA</span> package provides data structures \
                   and algorithms for doing computations with finite dimensional quotients \
                   of path algebras, and finitely generated modules over such algebras. The \
                   current version of the QPA package has data structures for quivers, \
                   quotients of path algebras, and modules, homomorphisms and complexes of \
                   modules over quotients of path algebras.",
                   
PackageWWWHome := "http://www.math.ntnu.no/~oyvinso/QPA/",
               
PackageDoc := rec(
  BookName  := "QPA",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Quivers and Path Algebras",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.5",
  NeededOtherPackages := [["GBNP", ">=0.9.5"]],
  SuggestedOtherPackages := [],
  ExternalConditions := []
                      
),

AvailabilityTest := ReturnTrue,
                   
Autoload := false,

TestFile := "tst/testall.tst",

Keywords := ["quiver","path algebra"]
));
