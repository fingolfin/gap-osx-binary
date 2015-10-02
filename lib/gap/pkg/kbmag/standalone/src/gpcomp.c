/* gpcomp.c 25/11/94.
 * 8/10/98 large-scale re-organisation.
 * Calculates a composite multiplier automaton of a short-lex automatic group,
 * This program assumes that kbprog with -wd option, gpwa, gpgenmult, gpmult,
 * and preferably gpcheckmult  have already been run of G.
 *
 * SYNOPSIS:
 * gpcomp [-ip d/s[dr]] [-op d/s] [-silent] [-v] [-l] [-f] inf1 inf2 outf
 *
 * Input and output files are specified on command-line.
 *
 * OPTIONS:
 * -ip d/s[dr]	input in dense or sparse format - dense is default
 * -op d/s	output in dense or sparse format - sparse is default
 * -v		verbose
 * -silent	no diagnostics
 * -l/-h	large/huge hash-tables (for big examples)
 * -f           read back the transition table repeatedly while mimimizing.
 *              this avoids storing the large table, but is a little slower.
 */

#include <stdio.h>
#include "defs.h"
#include "fsa.h"
#include "definitions.h"

static FILE *rfile, *wfile;

void  badusage_gpcomp();

/* Functions defined in other files used in this file */
void  fsa_read();
fsa  *fsa_composite();
int   fsa_minimize();
int   fsa_ip_minimize();
void  fsa_print();
void  fsa_clear();
int   stringlen();

main(argc, argv)
        int             argc;
        char           *argv[];
{ int arg, i, g1, g2;
  fsa mult1, mult2, *compmult;
  char inf1[100], inf2[100], outf[100], fsaname[100],
       tempfilename[100], *inf2ptr;
  storage_type ip_store = DENSE;
  int dr = 0;
  storage_type op_store = SPARSE;
  boolean readback = TRUE;

  setbuf(stdout,(char*)0);
  setbuf(stderr,(char*)0);

  inf1[0] = '\0';
  inf2[0] = '\0';
  outf[0] = '\0';
  arg = 1;
  while (argc > arg) {
    if (strcmp(argv[arg],"-ip")==0) {
      arg++;
      if (arg >= argc)
        badusage_gpcomp();
      if (strcmp(argv[arg],"d")==0)
        ip_store = DENSE;
      else if (argv[arg][0] == 's') {
        ip_store = SPARSE;
        if (stringlen(argv[arg]) > 1)
          dr = atoi(argv[arg]+1);
      }
      else
        badusage_gpcomp();
    }
    else if (strcmp(argv[arg],"-op")==0) {
      arg++;
      if (arg >= argc)
        badusage_gpcomp();
      if (strcmp(argv[arg],"d")==0)
        op_store = DENSE;
      else if (strcmp(argv[arg],"s")==0)
        op_store = SPARSE;
      else
        badusage_gpcomp();
    }
    else if (strcmp(argv[arg],"-silent")==0)
      kbm_print_level = 0;
    else if (strcmp(argv[arg],"-v")==0)
      kbm_print_level = 2;
    else if (strcmp(argv[arg],"-vv")==0)
      kbm_print_level = 3;
    else if (strcmp(argv[arg],"-l")==0)
      kbm_large = TRUE;
    else if (strcmp(argv[arg],"-h")==0)
      kbm_huge = TRUE;
    else if (strcmp(argv[arg],"-f")==0)
      readback = FALSE;
    else {
       if (argv[arg][0] == '-')
         badusage_gpcomp();
       if (strcmp(outf,"")!=0)
         badusage_gpcomp();
       else if (strcmp(inf1,"")==0)
         strcpy(inf1,argv[arg]);
       else if (strcmp(inf2,"")==0)
         strcpy(inf2,argv[arg]);
       else
         strcpy(outf,argv[arg]);
    }
    arg++;
  }
  if (stringlen(inf1)==0 || stringlen(inf2)==0 || stringlen(outf)==0)
    badusage_gpcomp();
  
  strcpy(tempfilename,inf1);
  /* The next lines avoid a potential problem when "inf2" contains a '/' */
  inf2ptr=inf2+strlen(inf2);
  while (--inf2ptr>=inf2) if (*inf2ptr=='/')
    break;
  inf2ptr++;
  strcat(tempfilename,inf2ptr);
  strcat(tempfilename,"_tempXXX");

  if ((rfile = fopen(inf1,"r")) == 0) {
    fprintf(stderr,"Cannot open file %s.\n",inf1);
      exit(1);
  }
  fsa_read(rfile,&mult1,ip_store,dr,0,TRUE,fsaname);

  if ((rfile = fopen(inf2,"r")) == 0) {
    fprintf(stderr,"Cannot open file %s.\n",inf2);
      exit(1);
  }
  fsa_read(rfile,&mult2,ip_store,dr,0,TRUE,fsaname);
  fclose(rfile);

  compmult = fsa_composite(&mult1,&mult2,op_store,TRUE,tempfilename,readback);
  if (compmult==0) exit(1);

  if (kbm_print_level>1)
    printf("  #Number of states of composite before minimization = %d.\n",
       compmult->states->size);

  if (readback) {
    if (fsa_minimize(compmult)== -1) exit(1);
  } 
  else {
    if (fsa_ip_minimize(compmult)== -1) exit(1);
  }

  if (kbm_print_level>1)
    printf("  #Number of states of composite after minimization = %d.\n",
       compmult->states->size);

  base_prefix(fsaname);
  strcat(fsaname,".comp");
  wfile = fopen(outf,"w");
  fsa_print(wfile,compmult,fsaname);
  fclose(wfile);

  if (kbm_print_level>0)
    printf("#Composite multiplier with %d states computed.\n",
            compmult->states->size);

  fsa_clear(compmult);
  tfree(compmult);
  exit(0);
}
 
void
badusage_gpcomp()
{
    fprintf(stderr,
"Usage: \n");
    fprintf(stderr,
"gpcomp [-ip d/s[dr]] [-op d/s] [-silent] [-v] [-l/-h] [-f] inf1 inf2 outf.\n");
    exit(1);
}
