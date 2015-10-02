/*  This file was created by Configure. Any change made to it will be lost
 *  next time Configure is run. */
#ifndef __CONFIG_H__
#define __CONFIG_H__
#define UNIX
#define SHELL_Q '\''

#define PARIVERSION "GP/PARI CALCULATOR Version 2.7.2 (released)"
#define PARIINFO "i386 running darwin (x86-64/GMP-6.0.0 kernel) 64-bit version"
#define PARI_VERSION_CODE 132866
#define PARI_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
#define PARI_VERSION_SHIFT 8
#define PARI_VCSVERSION ""
#define PARI_MT_ENGINE "single"

#define PARI_DOUBLE_FORMAT -
#define GCC_VERSION "Apple LLVM version 5.1 (clang-503.0.40) (based on LLVM 3.4svn)"
#define ASMINLINE

/*  Location of GNU gzip program (enables reading of .Z and .gz files). */
#define GNUZCAT
#define ZCAT "/usr/bin/gzip -dc"

#define READLINE "6.3"
#define LONG_IS_64BIT
#define HAS_EXP2
#define HAS_LOG2
#define HAS_ISATTY
#define HAS_ALARM
#define USE_GETRUSAGE 1
#define HAS_SIGACTION
#define HAS_WAITPID
#define HAS_GETENV
#define HAS_SETSID
#define HAS_DLOPEN
#define STACK_CHECK
#define HAS_VSNPRINTF
#define HAS_TIOCGWINSZ
#define HAS_STRFTIME
#define HAS_STAT
#endif
