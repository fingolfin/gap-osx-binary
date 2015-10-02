############################################################################
####
##
#W  read.g                  ParGAP Package                    Gene Cooperman
##
#H  @(#)$Id$
##
#Y  Copyright (C) 1999-2001  Gene Cooperman
#Y    See included file, COPYING, for conditions for copying
##

#if not IsBound( MasterSlave ) then
  ReadPkg("pargap","lib/slavelist.g");
  ReadPkg("pargap","lib/masslave.g");
#fi;

# PAR_GAP_SLAVE_START is invoked at end of GAP's lib/init.g
if MPI_Comm_rank() <> 0 then
  PAR_GAP_SLAVE_START := function()
    BreakOnError := false;
    # Call SlaveListener(), and repeat if we catch SIGINT (if we return fail)
    while fail = UNIX_Catch( SlaveListener, [] ) do
    od;
  end;
fi;

#E read.g . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
