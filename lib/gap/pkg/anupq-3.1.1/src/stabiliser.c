/****************************************************************************
**
*A  stabiliser.c                ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"
#include "pga_vars.h"
#include "pq_functions.h"
#include "constants.h"

/*static int ***setup_identity_auts (int nmr_of_generators, int ***auts, struct pga_vars *pga);*/
static void evaluate_generators (int pointer, int nmr_of_generators, int ***stabiliser, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);


/* find the stabiliser of the representative, rep; 
   all of the permutations are stored in perms;
   nmr_of_generators is the number of pcp generators in the descendant */

int*** stabiliser_of_rep (int **perms, int rep, int orbit_length,
                          int *a, int *b, char *c, char *d, int ***auts,
                          struct pga_vars *pga, struct pcp_vars *pcp)
{
   register int *y = y_address;

   int*** stabiliser;
   int pointer = pcp->lused + 1;
   Logical soluble_group = (pga->soluble || pga->Degree == 1 || 
			    pga->nmr_of_perms == 0);
   int nmr_of_generators;
   int restriction;
   int j;
   int *relative;

   nmr_of_generators = pga->final_stage ? y[pcp->clend + pcp->cc - 1] + pga->s :
      pcp->lastg + pga->s - pga->q;
                              
   pga->nmr_stabilisers = 0;

   /* if necessary, compute the stabiliser of the representative 
      in the insoluble portion using a system call to GAP -- 
      this is done before setting up the remainder of the automorphisms 
      to minimise the size of the workspace created by the system call */

   if (!soluble_group) { 

#if defined (GAP_LINK) || defined (GAP_LINK_VIA_FILE)
      insoluble_stab_gens (rep, orbit_length, pga, pcp);
#else
      printf ("To compute stabilisers in insoluble automorphism groups, ");
      printf ("you must compile pq\nwith the compiler flag GAP_LINK set\n"); 
      exit (FAILURE);
#endif
   }

   /* determine the generators for the stabiliser if soluble */
   if (soluble_group) { 
      stabiliser_generators (perms, rep, a, b, c, d, auts, pga, pcp);

      /* allocate space for stabiliser */
      stabiliser = allocate_array (pga->nmr_stabilisers, pga->ndgen,
				nmr_of_generators, TRUE);
                                 
      /* construct the generators of the stabiliser in the soluble group 
         as automorphisms */

      if (pga->nmr_stabilisers != 0 && soluble_group) {
         restriction = pga->final_stage ? 
           y[pcp->clend + pcp->cc - 1] + pga->s : y[pcp->clend + pcp->cc - 1];
           evaluate_generators (pointer, restriction, stabiliser, auts, pga, pcp);
      }
   }
   else {
      /* read in the generators of the stabiliser in the insoluble case -- 
          these were computed using GAP */

#if defined (GAP_LINK) || defined (GAP_LINK_VIA_FILE)
      stabiliser = read_stabiliser_gens (nmr_of_generators, stabiliser, pga, pcp);
#endif
   }
 
   pcp->lastg = nmr_of_generators;

   if (pga->final_stage) {
      /* include relative orders for central generators */
      relative = allocate_vector (pga->nmr_soluble + pga->nmr_centrals, 1, 0);
      for (j = pga->nmr_soluble; j >= 1; --j) 
         relative[pga->nmr_centrals + j] = pga->relative[j]; 
      for (j = 1; j <= pga->nmr_centrals; ++j) 
         relative[j] = pga->p;         

      /* free_vector (pga->relative, 1); */
      pga->relative = relative;
      pga->nmr_soluble += pga->nmr_centrals;
   }

   if (pga->print_automorphisms && pga->final_stage) { 
/* 
	if (pga->print_automorphisms) { 
*/
      printf ("Number of stabiliser generators is %d\n", pga->nmr_stabilisers);
      print_auts (pga->nmr_stabilisers, pga->ndgen, stabiliser, pcp);
   }

   pga->m = pga->nmr_centrals + pga->nmr_stabilisers;

   return stabiliser;
}

/* find generators for the stabiliser for orbit representative, rep;
   store each word in y, preceded by its length */

void stabiliser_generators (int **perms, int rep, int *a, int *b, char *c, char *d,
                            int ***auts, struct pga_vars *pga, struct pcp_vars *pcp)
{
   register int *y = y_address;

   register int alpha, k, next;
   register int word_length;
   register int pointer = pcp->lused + 1;
   int index;
   int perm_number;

   /* let k run over the elements of orbit with representative rep; 
      if c[k] >= 2, then some permutation did not extend the orbit of k; 
      hence, there is some product of subsequent permutations which 
      stabilises the representative a[k] */

   k = rep;
   while (k != 0) {
      if (c[k] >= 2) {
	 for (alpha = d[k] + 1; alpha <= d[k] + c[k] - 1; ++alpha) {
	    ++pga->nmr_stabilisers;
	    word_length = 1;
	    y[pointer + word_length] = alpha;

	    /* does automorphism alpha induce a trivial permutation? */
	    if ((perm_number = pga->map[alpha]) == 0)
	       next = a[k];
	    else {
	       next = pga->space_efficient ? 
		  find_image (a[k], auts[alpha], pga, pcp) : 
		  perms[perm_number][a[k]];
	    }

	    while (next != a[k]) {
	       index = d[next];
	       ++word_length;
	       y[pointer + word_length] = index;
	       if ((perm_number = pga->map[index]) != 0) {
		  next = pga->space_efficient ? 
		     find_image (next, auts[index], pga, pcp) : 
		     perms[perm_number][next];
	       }
	    }
	    y[pointer] = word_length;
	    pointer += word_length + 1; 
	 }
      }
      k = b[k];
   }

   pcp->lused = pointer;
}

/* evaluate the action of a stabiliser of a representative on the 
   defining generators of the group; each stabiliser generator is 
   stored as a word in the automorphisms, auts, of the parent, where 
   y[pointer] = length of word defining first generator */

static void evaluate_generators (int pointer, int nmr_of_generators, int ***stabiliser, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp)
{
   register int *y = y_address;

   register int i, j;
   register int gamma;
   int cp = pcp->lused;

   for (gamma = 1; gamma <= pga->nmr_stabilisers; ++gamma) {

      for (i = 1; i <= pga->ndgen; ++i) {
	 /* compute image of defining generator i 
	    under generator gamma of stabiliser */
	 image_of_generator (i, pointer, auts, pga, pcp);

	 /* copy restriction of result into stabiliser array */
	 for (j = 1; j <= nmr_of_generators; ++j) 
	    stabiliser[gamma][i][j] = y[cp + j];
      }
      pointer += y[pointer] + 1; 
   }
}

/* compute the image of group generator under a stabiliser generator,
   whose definition as a word in the automorphisms, auts, of the parent
   is stored at y[pointer + 1], .., y[pointer + y[pointer]] */ 

void image_of_generator (int generator, int pointer, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp)
{
   register int *y = y_address;

   register int i, j, k, l;
   register int alpha, letter;
   register int length, exp; 
   int cp = pcp->lused;
   int ptr = cp + pcp->lastg;
   int nmr_of_letters = y[pointer];
   register int bound;

   /* alpha is the last letter in the stabiliser generator word */
   alpha = y[pointer + nmr_of_letters];

   /* set up the image of gen under the action of alpha at cp */
   for (i = 1; i <= pcp->lastg; ++i)
      y[cp + i] = auts[alpha][generator][i]; 

   /* for each remaining letter in the generator word, set up as a 
      word its action on each of the elements of the image under alpha */

   for (letter = nmr_of_letters - 1; letter >= 1; --letter) {

      alpha = y[pointer + letter];

      /* set up image under alpha */
      length = 0;
      for (i = 1; i <= pcp->lastg; ++i) {
	 if ((exp = y[cp + i]) > 0) {
	    /* set up exp copies of the image of generator i under 
	       action of automorphism alpha */
	    for (j = 1; j <= exp; ++j) {
	       for (k = 1; k <= pcp->lastg; ++k) {
		  bound = auts[alpha][i][k]; 
		  for (l = 1; l <= bound; ++l) {
		     ++length;
		     y[ptr + length] = k;
		  }
	       }
	    }
	 }
      }

      /* now zero out previous result */
      for (i = 1; i <= pcp->lastg; ++i)
	 y[cp + i] = 0;

      /* now collect the result of the composition of maps so far to cp */
      for (l = 1; l <= length; ++l)
	 collect (y[ptr + l], cp, pcp);
   }
}

/* find which automorphism, alpha, induces the permutation with index perm */

int preimage (int perm, struct pga_vars *pga)
{
   int alpha;

   for (alpha = 1; alpha <= pga->m; ++alpha)
      if (pga->map[alpha] == perm)
	 return alpha;

   printf ("*** Error in function preimage ***\n");
   exit (FAILURE);
}

/* set up those automorphisms which induced the identity on the 
   p-multiplicator as the leading elements of the stabiliser */
/*
static int ***setup_identity_auts (int nmr_of_generators, int ***auts, struct pga_vars *pga)
{
   int alpha, i = 0, j, k;
   int ***stabiliser;

   stabiliser = allocate_array (pga->nmr_stabilisers, pga->ndgen,
				nmr_of_generators, TRUE);
                                 
   for (alpha = 1; alpha <= pga->m; ++alpha) {
      if (pga->map[alpha] == 0) {
	 ++i;
	 for (j = 1; j <= pga->ndgen; ++j)
	    for (k = 1; k <= nmr_of_generators; ++k)
	       stabiliser[i][j][k] = auts[alpha][j][k];
      }
   }

   return stabiliser;
}
*/

#if defined (GAP_LINK_VIA_FILE)

/* read the insoluble stabiliser generators from LINK file;
   each list of stabilisers is preceded by a list of integers -- 
   the first indicates whether the stabiliser is soluble; 
   the second is the number of soluble generators for the stabiliser;
   for each soluble generator, its relative order is now listed;
   finally the total number of generators is listed */

int*** read_stabiliser_gens (int nmr_of_generators, int ***soluble_generators, struct pga_vars *pga, struct pcp_vars *pcp)
{
   register int ndgen = pga->ndgen;
   register int gamma, i, j;
   FILE * LINK_output;
   int ***stabiliser;
   int nmr_items;
   int temp;

   LINK_output = OpenFileInput ("LINK_output");

   nmr_items = fscanf (LINK_output, "%d", &pga->soluble);
   verify_read (nmr_items, 1);
   nmr_items = fscanf (LINK_output, "%d", &pga->nmr_soluble);
   verify_read (nmr_items, 1);



   pga->relative = allocate_vector (pga->nmr_soluble, 1, 0);
   for (j = 1; j <= pga->nmr_soluble; ++j) {
      nmr_items = fscanf (LINK_output, "%d", &temp);
      verify_read (nmr_items, 1);
      pga->relative[j] = temp;
   }

   nmr_items = fscanf (LINK_output, "%d", &pga->nmr_stabilisers);
   verify_read (nmr_items, 1);

#ifdef DEBUG1 
   printf ("Nmr of soluble gens for stabiliser is %d\n", pga->nmr_soluble);
   printf ("FROM GAP Relative orders are ");
   for (i = 1; i <= pga->nmr_soluble ; ++i)
      printf ("%d ", pga->relative[i]);
   printf ("\n");
   printf ("Total Nmr of gens for stabiliser is %d\n", pga->nmr_stabilisers);
#endif

   stabiliser = allocate_array (pga->nmr_stabilisers, ndgen, 
                                nmr_of_generators, TRUE);

   /* now read in the insoluble generators */
   for (gamma = 1; gamma <= pga->nmr_stabilisers; ++gamma)  
      for (i = 1; i <= ndgen; ++i)  
	 for (j = 1; j <= pcp->ccbeg - 1; ++j) {
	    nmr_items = fscanf (LINK_output, "%d", &stabiliser[gamma][i][j]);
	    verify_read (nmr_items, 1);
	 }

   CloseFile (LINK_output);

   return stabiliser; 
}

#endif 
