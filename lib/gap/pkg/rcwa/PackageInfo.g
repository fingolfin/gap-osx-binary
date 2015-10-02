####################################################################################################
##
##  PackageInfo.g                         GAP4 Package `RCWA'                            Stefan Kohl
##
####################################################################################################

SetPackageInfo( rec(

PackageName      := "RCWA",
Subtitle         := "Residue-Class-Wise Affine Groups",
Version          := "3.7.0",
Date             := "21/07/2014",
ArchiveURL       := "http://www.gap-system.org/DevelopersPages/StefanKohl/rcwa/rcwa-3.7.0",
ArchiveFormats   := ".tar.gz", # "-win.zip" when providing text files with Windows line breaks
Persons          := [
                      rec( LastName      := "Kohl",
                           FirstNames    := "Stefan",
                           IsAuthor      := true,
                           IsMaintainer  := true,
                           Email         := "stefan@mcs.st-and.ac.uk",
                           WWWHome       := "http://www.gap-system.org/DevelopersPages/StefanKohl/"
                         )
                    ],
Status           := "accepted",
CommunicatedBy   := "Bettina Eick (Braunschweig)",
AcceptDate       := "04/2005",
PackageWWWHome   := "http://www.gap-system.org/DevelopersPages/StefanKohl/rcwa.html",
README_URL       := "http://www.gap-system.org/DevelopersPages/StefanKohl/rcwa/README.rcwa",
PackageInfoURL   := "http://www.gap-system.org/DevelopersPages/StefanKohl/rcwa/PackageInfo.g",
AbstractHTML     := Concatenation("This package provides implementations of algorithms and ",
                                  "methods for computation in certain infinite permutation groups.",
                                  " For an abstract, see ",
                                  "<a href = \"",~.PackageWWWHome,"\">here</a>."),
PackageDoc       := rec(
                         BookName         := "RCWA",
                         ArchiveURLSubset := ["doc"],
                         HTMLStart        := "doc/chap0.html",
                         PDFFile          := "doc/manual.pdf",
                         SixFile          := "doc/manual.six",
                         LongTitle        := "[R]esidue-[C]lass-[W]ise [A]ffine groups",
                         Autoload         := true
                       ),
Dependencies     := rec(
                         GAP                    := ">=4.7.0",
                         NeededOtherPackages    := [ ["ResClasses",">=3.4.0"], ["GRAPE",">=4.3"],
                                                     ["Polycyclic",">=2.6"], ["GAPDoc",">=1.4"] ],
                         SuggestedOtherPackages := [ ["FR",">=1.1.3"] ],
                         ExternalConditions     := [ ]
                       ),
AvailabilityTest := ReturnTrue,
BannerString     := Concatenation( "\nLoading RCWA ", ~.Version,
                                   " ([R]esidue-[C]lass-[W]ise [A]ffine groups)",
                                   "\n  by Stefan Kohl, stefan@mcs.st-and.ac.uk.",
                                   "\nSee ?RCWA:About for information about the package.\n\n" ),
TestFile         := "tst/testinstall.tst",
Keywords         := [ "infinite permutation groups", "permutation groups over rings",
                      "combinatorial group theory", "residue-class-wise affine groups",
                      "residue-class-wise affine mappings",
                      "Collatz conjecture", "3n+1 conjecture" ]

) );

####################################################################################################
##
#E  PackageInfo.g  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here