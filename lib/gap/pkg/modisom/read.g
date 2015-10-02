#############################################################################
##
#W    read.g                 The ModIsom package                 Bettina Eick
##

#############################################################################
##
#R  Global vars
##
SMTX.RAND_ELM_LIMIT := 5000;
MIP_GLLIMIT := infinity; 
COVER_LIMIT := 100;
POWER_LIMIT := 1000;

# some flags for the algorithm
if not IsBound(USE_PARTI) then USE_PARTI := false; fi;
if not IsBound(USE_CHARS) then USE_CHARS := false; fi;
if not IsBound(USE_MSERS) then USE_MSERS := false; fi;

# checking modes for the package
if not IsBound(CHECK_AUT) then CHECK_AUT := false; fi;
if not IsBound(CHECK_STB) then CHECK_STB := false; fi;
if not IsBound(CHECK_CNF) then CHECK_CNF := false; fi;
if not IsBound(CHECK_NQA) then CHECK_NQA := false; fi;

# store info
if not IsBound(STORE) then STORE := true; fi;
if not IsBound(COVER) then COVER := true; fi;
if not IsBound(ALLOW) then ALLOW := true; fi;

#############################################################################
##
#R  Read the install files.
##
ReadPkg("modisom", "gap/cfstab/general.gi");
ReadPkg("modisom", "gap/cfstab/pgroup.gi");
ReadPkg("modisom", "gap/cfstab/orbstab.gi");
ReadPkg("modisom", "gap/cfstab/check.gi");

ReadPkg("modisom", "gap/tables/sparse.gi");
ReadPkg("modisom", "gap/tables/linalg.gi");
ReadPkg("modisom", "gap/tables/weight.gi");
ReadPkg("modisom", "gap/tables/tables.gi");
ReadPkg("modisom", "gap/tables/genalg.gi");
ReadPkg("modisom", "gap/tables/basic.gi");
ReadPkg("modisom", "gap/tables/quots.gi");
ReadPkg("modisom", "gap/tables/cover.gi");
ReadPkg("modisom", "gap/tables/isom.gi");

ReadPkg("modisom", "gap/nilalg/basic.gi");
ReadPkg("modisom", "gap/nilalg/liecl.gi");

ReadPkg("modisom", "gap/autiso/chains.gi");
ReadPkg("modisom", "gap/autiso/fprint.gi"); 
ReadPkg("modisom", "gap/autiso/tstepc.gi"); 
ReadPkg("modisom", "gap/autiso/initial.gi");  

ReadPkg("modisom", "gap/autiso/check.gi");
ReadPkg("modisom", "gap/autiso/induc.gi");
ReadPkg("modisom", "gap/autiso/autiso.gi");

ReadPkg("modisom", "gap/grpalg/basis.gi");
ReadPkg("modisom", "gap/grpalg/tables.gi");
ReadPkg("modisom", "gap/grpalg/autiso.gi");
ReadPkg("modisom", "gap/grpalg/check.gi");
ReadPkg("modisom", "gap/grpalg/head.gi");

ReadPkg("modisom", "gap/grpalg/detbins.gi");
ReadPkg("modisom", "gap/grpalg/chkbins.gi");

ReadPkg("modisom", "gap/algnq/exam.gi");
ReadPkg("modisom", "gap/algnq/algnq.gi");

ReadPkg("modisom", "gap/rfree/kurosh.gi");
ReadPkg("modisom", "gap/rfree/polyid.gi");
ReadPkg("modisom", "gap/rfree/engel.gi");

#ReadPkg("modisom", "gap/group/group.gi");

ReadPkg("modisom", "gap/pilib/kur_3_3_Q.gi");
ReadPkg("modisom", "gap/pilib/kur_3_3_3.gi");
ReadPkg("modisom", "gap/pilib/kur_3_3_2.gi");
ReadPkg("modisom", "gap/pilib/kur_3_3_4.gi");
ReadPkg("modisom", "gap/pilib/kur_4_3_Q.gi");
ReadPkg("modisom", "gap/pilib/kur_4_3_3.gi");
ReadPkg("modisom", "gap/pilib/kur_4_3_2.gi");
ReadPkg("modisom", "gap/pilib/kur_4_3_4.gi");
ReadPkg("modisom", "gap/pilib/kur_2_4_Q.gi");
ReadPkg("modisom", "gap/pilib/kur_2_4_3.gi");
ReadPkg("modisom", "gap/pilib/kur_2_4_9.gi");
ReadPkg("modisom", "gap/pilib/kur_2_4_2.gi");
ReadPkg("modisom", "gap/pilib/kur_2_4_4.gi");
ReadPkg("modisom", "gap/pilib/kur_2_5_Q.gi");
ReadPkg("modisom", "gap/pilib/kur_2_5_5.gi");
ReadPkg("modisom", "gap/pilib/kur_2_5_3.gi");
ReadPkg("modisom", "gap/pilib/kur_2_5_9.gi");
ReadPkg("modisom", "gap/pilib/kur_2_5_2.gi");
ReadPkg("modisom", "gap/pilib/kur_2_5_4.gi");
ReadPkg("modisom", "gap/pilib/kur_2_5_8.gi");
ReadPkg("modisom", "gap/pilib/readlib.gi");

