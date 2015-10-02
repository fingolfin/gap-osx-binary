#ifndef _SINGULAR_SINGULARCONFIG_H
#define _SINGULAR_SINGULARCONFIG_H 1
 
/* singularconfig.h. Generated automatically at end of configure. */
 
/* _config.h.  Generated from _config.h.in by configure.  */
/* _config.h.in.  Generated from configure.ac by autoheader.  */

/* integrate python */
/* #undef EMBED_PYTHON */

/* Define if GMP is version 3.xxx */
/* #undef GMP_VERSION_3 */

/* whether google perftools support is enabled */
/* #undef GOOGLE_PERFTOOLS_ENABLED */

/* whether google profiling support is enabled */
#ifndef GOOGLE_PROFILE_ENABLED
#define GOOGLE_PROFILE_ENABLED 0
#endif

/* Define to 1 if you have the <asm/sigcontext.h> header file. */
/* #undef HAVE_ASM_SIGCONTEXT_H */

/* Define to 1 if you have the <cddlib/setoper.h> header file. */
/* #undef HAVE_CDDLIB_SETOPER_H */

/* Define to 1 if you have the <cdd/setoper.h> header file. */
/* #undef HAVE_CDD_SETOPER_H */

/* Define to have dbm links */
#ifndef HAVE_DBM
#define HAVE_DBM 1
#endif

/* division using extend euclidian algorithm otherwise using tables of
   logartihms */
/* #undef HAVE_DIV_MOD */

/* enable dynamic modules */
#ifndef HAVE_DL
#define HAVE_DL 1
#endif

/* Define to 1 if you have the <dlfcn.h> header file. */
#ifndef HAVE_DLFCN_H
#define HAVE_DLFCN_H 1
#endif

/* enable dynamic modules */
#ifndef HAVE_DYNAMIC_LOADING
#define HAVE_DYNAMIC_LOADING 1
#endif

/* Use dynamic readline */
/* #undef HAVE_DYN_RL */

/* Enable factory */
#ifndef HAVE_FACTORY
#define HAVE_FACTORY 1
#endif

/* Define to 1 if you have the <fcntl.h> header file. */
#ifndef HAVE_FCNTL_H
#define HAVE_FCNTL_H 1
#endif

/* Define if FLINT is installed */
#ifndef HAVE_FLINT
#define HAVE_FLINT 1
#endif

/* use branch for addition in Z/p otherwise it uses a generic add */
/* #undef HAVE_GENERIC_ADD */

/* Define to 1 if you have the `getcwd' function. */
#ifndef HAVE_GETCWD
#define HAVE_GETCWD 1
#endif

/* Define to 1 if you have the `getwd' function. */
#ifndef HAVE_GETWD
#define HAVE_GETWD 1
#endif

/* whether gfanlib support is enabled */
#ifndef HAVE_GFANLIB
#define HAVE_GFANLIB 0
#endif

/* Define if GMP is installed */
#ifndef HAVE_GMP
#define HAVE_GMP 1
#endif

/* Define to 1 if you have the <inttypes.h> header file. */
#ifndef HAVE_INTTYPES_H
#define HAVE_INTTYPES_H 1
#endif

/* Define to 1 if you have the <iostream.h> header file. */
/* #undef HAVE_IOSTREAM_H */

/* Define to 1 if you have the `curses' library (-lcurses). */
/* #undef HAVE_LIBCURSES */

/* Define to 1 if you have the `mathic' library (-lmathic). */
/* #undef HAVE_LIBMATHIC */

/* Define to 1 if you have the `mathicgb' library (-lmathicgb). */
/* #undef HAVE_LIBMATHICGB */

/* Define to 1 if you have the `memtailor' library (-lmemtailor). */
/* #undef HAVE_LIBMEMTAILOR */

/* Define to 1 if you have the `ncurses' library (-lncurses). */
#ifndef HAVE_LIBNCURSES
#define HAVE_LIBNCURSES 1
#endif

/* Define to 1 if you have the `readline' library (-lreadline). */
#ifndef HAVE_LIBREADLINE
#define HAVE_LIBREADLINE 1
#endif

/* Define to 1 if you have the `rt' library (-lrt). */
/* #undef HAVE_LIBRT */

/* Define to 1 if you have the `termcap' library (-ltermcap). */
/* #undef HAVE_LIBTERMCAP */

/* Define to 1 if your system has a GNU libc compatible `malloc' function, and
   to 0 otherwise. */
#ifndef HAVE_MALLOC
#define HAVE_MALLOC 1
#endif

/* Define if mathicgb is to be used */
/* #undef HAVE_MATHICGB */

/* Define to 1 if you have the <memory.h> header file. */
#ifndef HAVE_MEMORY_H
#define HAVE_MEMORY_H 1
#endif

/* multiplication is fast on the cpu: a*b is with mod otherwise using tables
   of logartihms */
#ifndef HAVE_MULT_MOD
#define HAVE_MULT_MOD 1
#endif

/* Define if NTL is installed */
#ifndef HAVE_NTL
#define HAVE_NTL 1
#endif

/* Enable non-commutative subsystem */
#ifndef HAVE_PLURAL
#define HAVE_PLURAL 1
#endif

/* Define if POLYMAKE is installed */
/* #undef HAVE_POLYMAKE */

/* Define if you have POSIX threads libraries and header files. */
#ifndef HAVE_PTHREAD
#define HAVE_PTHREAD 1
#endif

/* Have PTHREAD_PRIO_INHERIT. */
#ifndef HAVE_PTHREAD_PRIO_INHERIT
#define HAVE_PTHREAD_PRIO_INHERIT 1
#endif

/* Define to 1 if you have the `putenv' function. */
#ifndef HAVE_PUTENV
#define HAVE_PUTENV 1
#endif

/* Define to 1 if you have the <pwd.h> header file. */
#ifndef HAVE_PWD_H
#define HAVE_PWD_H 1
#endif

/* compile python-related stuff */
#ifndef HAVE_PYTHON
#define HAVE_PYTHON 1
#endif

/* Define to 1 if you have the `qsort_r' function. */
#ifndef HAVE_QSORT_R
#define HAVE_QSORT_R 1
#endif

/* Enable RatGB support */
/* #undef HAVE_RATGRING */

/* Use readline */
#ifndef HAVE_READLINE
#define HAVE_READLINE 1
#endif

/* Define to 1 if you have the <readline/history.h> header file. */
#ifndef HAVE_READLINE_HISTORY_H
#define HAVE_READLINE_HISTORY_H 1
#endif

/* Define to 1 if you have the <readline/readline.h> header file. */
#ifndef HAVE_READLINE_READLINE_H
#define HAVE_READLINE_READLINE_H 1
#endif

/* Define to 1 if you have the `readlink' function. */
#ifndef HAVE_READLINK
#define HAVE_READLINK 1
#endif

/* Define to 1 if you have the `setenv' function. */
#ifndef HAVE_SETENV
#define HAVE_SETENV 1
#endif

/* Define to 1 if you have the <setoper.h> header file. */
/* #undef HAVE_SETOPER_H */

/* Enable letterplace */
#ifndef HAVE_SHIFTBBA
#define HAVE_SHIFTBBA 1
#endif

/* Define to 1 if you have the <stdint.h> header file. */
#ifndef HAVE_STDINT_H
#define HAVE_STDINT_H 1
#endif

/* Define to 1 if you have the <stdlib.h> header file. */
#ifndef HAVE_STDLIB_H
#define HAVE_STDLIB_H 1
#endif

/* Define to 1 if you have the <strings.h> header file. */
#ifndef HAVE_STRINGS_H
#define HAVE_STRINGS_H 1
#endif

/* Define to 1 if you have the <string.h> header file. */
#ifndef HAVE_STRING_H
#define HAVE_STRING_H 1
#endif

/* Define to 1 if you have the <sys/file.h> header file. */
#ifndef HAVE_SYS_FILE_H
#define HAVE_SYS_FILE_H 1
#endif

/* Define to 1 if you have the <sys/ioctl.h> header file. */
#ifndef HAVE_SYS_IOCTL_H
#define HAVE_SYS_IOCTL_H 1
#endif

/* Define to 1 if you have the <sys/param.h> header file. */
#ifndef HAVE_SYS_PARAM_H
#define HAVE_SYS_PARAM_H 1
#endif

/* Define to 1 if you have the <sys/stat.h> header file. */
#ifndef HAVE_SYS_STAT_H
#define HAVE_SYS_STAT_H 1
#endif

/* Define to 1 if you have the <sys/times.h> header file. */
#ifndef HAVE_SYS_TIMES_H
#define HAVE_SYS_TIMES_H 1
#endif

/* Define to 1 if you have the <sys/time.h> header file. */
#ifndef HAVE_SYS_TIME_H
#define HAVE_SYS_TIME_H 1
#endif

/* Define to 1 if you have the <sys/types.h> header file. */
#ifndef HAVE_SYS_TYPES_H
#define HAVE_SYS_TYPES_H 1
#endif

/* Define to 1 if you have the <termcap.h> header file. */
#ifndef HAVE_TERMCAP_H
#define HAVE_TERMCAP_H 1
#endif

/* Define to 1 if you have the <termios.h> header file. */
#ifndef HAVE_TERMIOS_H
#define HAVE_TERMIOS_H 1
#endif

/* Define to 1 if you have the <term.h> header file. */
#ifndef HAVE_TERM_H
#define HAVE_TERM_H 1
#endif

/* Define to 1 if you have the <unistd.h> header file. */
#ifndef HAVE_UNISTD_H
#define HAVE_UNISTD_H 1
#endif

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#ifndef LT_OBJDIR
#define LT_OBJDIR ".libs/"
#endif

/* Define to 1 if your C compiler doesn't accept -c and -o together. */
/* #undef NO_MINUS_C_MINUS_O */

/* "Disable OM Debug" */
#ifndef OM_NDEBUG
#define OM_NDEBUG 1
#endif

/* Name of package */
#ifndef PACKAGE
#define PACKAGE "singular"
#endif

/* Define to the address where bug reports for this package should be sent. */
#ifndef PACKAGE_BUGREPORT
#define PACKAGE_BUGREPORT "singular@mathematik.uni-kl.de"
#endif

/* Define to the full name of this package. */
#ifndef PACKAGE_NAME
#define PACKAGE_NAME "singular"
#endif

/* Define to the full name and version of this package. */
#ifndef PACKAGE_STRING
#define PACKAGE_STRING "singular 4.0.2"
#endif

/* Define to the one symbol short name of this package. */
#ifndef PACKAGE_TARNAME
#define PACKAGE_TARNAME "singular"
#endif

/* Define to the home page for this package. */
#ifndef PACKAGE_URL
#define PACKAGE_URL ""
#endif

/* Define to the version of this package. */
#ifndef PACKAGE_VERSION
#define PACKAGE_VERSION "4.0.2"
#endif

/* Define to necessary symbol if this constant uses a non-standard name on
   your system. */
/* #undef PTHREAD_CREATE_JOINABLE */

/* Use readline.h */
#ifndef READLINE_READLINE_H_OK
#define READLINE_READLINE_H_OK 1
#endif

/* SINGULAR_CFLAGS */
#ifndef SINGULAR_CFLAGS
#define SINGULAR_CFLAGS "-DSING_NDEBUG -DOM_NDEBUG"
#endif

/* "Disable Singular Debug" */
#ifndef SING_NDEBUG
#define SING_NDEBUG 1
#endif

/* The size of `long', as computed by sizeof. */
#ifndef SIZEOF_LONG
#define SIZEOF_LONG 8
#endif

/* Refined list of builtin modules */
/* #undef SI_BUILTINMODULES */

/* Add(list) for Builtin modules */
#ifndef SI_BUILTINMODULES_ADD
#define SI_BUILTINMODULES_ADD(add) 
#endif

/* Enable autoloading of reference counted types */
/* #undef SI_COUNTEDREF_AUTOLOAD */

/* "i686" */
/* #undef SI_CPU_I386 */

/* "ia64" */
/* #undef SI_CPU_IA64 */

/* "PPC" */
/* #undef SI_CPU_PPC */

/* "SPARC" */
/* #undef SI_CPU_SPARC */

/* "x86-64" */
#ifndef SI_CPU_X86_64
#define SI_CPU_X86_64 1
#endif

/* Define to 1 if you have the ANSI C header files. */
#ifndef STDC_HEADERS
#define STDC_HEADERS 1
#endif

/* Singular\'s own uname\ */
#ifndef S_UNAME
#define S_UNAME "x86_64-Darwin"
#endif

/* Enable extensions on AIX 3, Interix.  */
#ifndef _ALL_SOURCE
# define _ALL_SOURCE 1
#endif
/* Enable GNU extensions on systems that have them.  */
#ifndef _GNU_SOURCE
# define _GNU_SOURCE 1
#endif
/* Enable threading extensions on Solaris.  */
#ifndef _POSIX_PTHREAD_SEMANTICS
# define _POSIX_PTHREAD_SEMANTICS 1
#endif
/* Enable extensions on HP NonStop.  */
#ifndef _TANDEM_SOURCE
# define _TANDEM_SOURCE 1
#endif
/* Enable general extensions on Solaris.  */
#ifndef __EXTENSIONS__
# define __EXTENSIONS__ 1
#endif


/* Version number of package */
#ifndef VERSION
#define VERSION "4.0.2"
#endif

/* release date */
#ifndef VERSION_DATE
#define VERSION_DATE "Feb 2015"
#endif

/* Define to 1 if on MINIX. */
/* #undef _MINIX */

/* Define to 2 if the system does not provide POSIX.1 features except with
   this defined. */
/* #undef _POSIX_1_SOURCE */

/* Define to 1 if you need to in order for `stat' and other things to work. */
/* #undef _POSIX_SOURCE */

/* Define to rpl_malloc if the replacement function should be used. */
/* #undef malloc */
 
/* once: _SINGULAR_SINGULARCONFIG_H */
#endif
