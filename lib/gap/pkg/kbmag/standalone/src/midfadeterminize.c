/* midfadeterminize.c 4/8/95.
 * 6/8/98 large scale reorganisation to omit globals, etc.
 * determinizes a multiple statrt-state dfa.
 *
 * SYNOPSIS:  midfadeterminize [-ip d/s[dr]] [-op d/s] [-silent] [-v] [-l/-h]
 *		[filename]
 * Input is from filename (or stdin if not specified),
 * which should contain a fsa.
 * Output is to stdout or to filename.midfadeterminize
 *
 * OPTIONS:
 * -ip d/s[dr]  input in dense or sparse format - dense is default
 * -op d/s      output in dense or sparse format - default is as in current
 *               value of table->printing_format, in the fsa.
 * -v           verbose
 * -silent      no diagnostics
 * -l/-h        large/huge hash-tables (for big examples)
 */

#include <stdio.h>
#include "defs.h"
#include "fsa.h"
#include "definitions.h"

static FILE *rfile, *wfile;

void  badusage_midfadeterminize();

/* Functions defined in other files used in this file */
void  fsa_read();
fsa   *midfa_determinize();
void  fsa_print();
void  fsa_clear();
int   fsa_minimize();
int   stringlen();

main(argc, argv)
        int             argc;
        char           *argv[];
{ int arg;
  fsa fsain, *midfadeterminize;
  char inf[100], outf[100], fsaname[100], tempfilename[100];
  storage_type ip_store = DENSE;
  int dr = 0;
  storage_type op_store = DENSE;


  setbuf(stdout,(char*)0);
  setbuf(stderr,(char*)0);

  inf[0] = '\0';
  outf[0] = '\0';
  arg = 1;
  while (argc > arg) {
    if (strcmp(argv[arg],"-ip")==0) {
      arg++;
      if (arg >= argc)
        badusage_midfadeterminize();
      if (strcmp(argv[arg],"d")==0)
        ip_store = DENSE;
      else if (argv[arg][0] == 's') {
        ip_store = SPARSE;
        if (stringlen(argv[arg]) > 1)
          dr = atoi(argv[arg]+1);
      }
      else
        badusage_midfadeterminize();
    }
    else if (strcmp(argv[arg],"-op")==0) {
      arg++;
      if (arg >= argc)
        badusage_midfadeterminize();
      if (strcmp(argv[arg],"d")==0)
        op_store = DENSE;
      else if (strcmp(argv[arg],"s")==0)
        op_store = SPARSE;
      else
        badusage_midfadeterminize();
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
    else {
       if (argv[arg][0] == '-')
         badusage_midfadeterminize();
       if (strcmp(inf,""))
         badusage_midfadeterminize();
       strcpy(inf,argv[arg]);
    }
    arg++;
  }
  if (stringlen(inf)!=0) {
    strcpy(outf,inf);
    strcat(outf,".midfadeterminize");

    if ((rfile = fopen(inf,"r")) == 0) {
      fprintf(stderr,"Cannot open file %s.\n",inf);
      exit(1);
    }
  }
  else
    rfile = stdin;
  fsa_read(rfile,&fsain,ip_store,dr,0,TRUE,fsaname);
  if (stringlen(inf)!=0)
    fclose(rfile);

  strcpy(tempfilename,inf);
  strcat(tempfilename,"temp_mid_XXX");
  midfadeterminize = midfa_determinize(&fsain,op_store,TRUE,tempfilename);
  if (midfadeterminize==0) exit(1);

  fsa_clear(&fsain);

  if (kbm_print_level>1)
   printf("  #Number of states of midfadeterminize before minimisation = %d.\n",
        midfadeterminize->states->size);
  if (fsa_minimize(midfadeterminize)== -1) exit(1);
  if (kbm_print_level>1)
    printf("  #Number of states of midfadeterminize after minimisation = %d.\n",
        midfadeterminize->states->size);

  strcat(fsaname,"_midfadeterminize");

  if (stringlen(inf)!=0)
    wfile = fopen(outf,"w");
  else
    wfile=stdout;
  fsa_print(wfile,midfadeterminize,fsaname);
  if (stringlen(inf)!=0)
    fclose(wfile);
  if (kbm_print_level>0)
    printf("#\"Determinized\" fsa with %d states computed.\n",
	midfadeterminize->states->size);

  fsa_clear(midfadeterminize);
  tfree(midfadeterminize);
  exit(0);
}
 
void
badusage_midfadeterminize()
{
    fprintf(stderr,
    "Usage: midfadeterminize [-ip d/s[dr]] [-op d/s] [-silent] [-v] [-l/-h]\n\
	    [filename]\n");
    exit(1);
}
