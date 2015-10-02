#############################################################################
##
#W init.g                                                   Laurent Bartholdi
##
#H   @(#)$Id$
##
#Y Copyright (C) 2006, Laurent Bartholdi
##
#############################################################################
##
##  This file reads the declarations of the packages' new objects
##
#############################################################################

POSTHOOK@fr := []; # to be processed at the end

BindGlobal("@", rec()); # a record to store locals in the package

#############################################################################
##
#I Create info class to be able to debug loading
##
InfoFR := NewInfoClass("InfoFR");
SetInfoLevel(InfoFR, 1);
#############################################################################

#############################################################################
##
#R Read the declaration files.
##
ReadPackage("fr", "gap/helpers.gd");
ReadPackage("fr", "gap/perlist.gd");
ReadPackage("fr", "gap/frmachine.gd");
ReadPackage("fr", "gap/frelement.gd");
ReadPackage("fr", "gap/mealy.gd");
ReadPackage("fr", "gap/group.gd");
ReadPackage("fr", "gap/vector.gd");
ReadPackage("fr", "gap/algebra.gd");
ReadPackage("fr", "gap/bisets.gd");
ReadPackage("fr", "gap/examples.gd");

if not IsBound(IsLpGroup) then # shut up warnings in case LpGroups is not present
    ForAll(["IsLpGroup","IsElementOfLpGroup","LPresentedGroup",
            "ElementOfLpGroup","SetEmbeddingOfAscendingSubgroup"], function(w)
        BIND_GLOBAL(w, fail);
        Add(POSTHOOK@fr,function() MAKE_READ_WRITE_GLOBAL(w); UNBIND_GLOBAL(w); end);
        return true;
    end);
fi;

#############################################################################

#E init.g . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
