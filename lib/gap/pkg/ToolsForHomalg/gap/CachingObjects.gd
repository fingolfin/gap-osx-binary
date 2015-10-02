#############################################################################
##
##                                               ToolsForHomalg package
##
##  Copyright 2013-2014, Sebastian Gutsche, TU Kaiserslautern
##                       Sebastian Posur,   RWTH Aachen
##
##
#############################################################################

DeclareCategory( "IsCachingObject",
                 IsObject );

DeclareGlobalFunction( "CATEGORIES_FOR_HOMALG_SET_ALL_CACHES_CRISP" );

DeclareGlobalFunction( "CATEGORIES_FOR_HOMALG_PREPARE_CACHING_RECORD" );

DeclareGlobalFunction( "SEARCH_WPLIST_FOR_OBJECT" );

DeclareGlobalFunction( "CACHINGOBJECT_HIT" );

DeclareGlobalFunction( "CACHINGOBJECT_MISS" );

DeclareGlobalFunction( "COMPARE_LISTS_WITH_IDENTICAL" );

DeclareGlobalFunction( "CreateWeakCachingObject" );

DeclareGlobalFunction( "CreateCrispCachingObject" );

DeclareGlobalFunction( "InstallMethodWithCache" );

DeclareGlobalFunction( "TOOLS_FOR_HOMALG_CACHE_CLEAN_UP" );

## Weak cache is std.
DeclareSynonym( "InstallMethodWithWeakCache", InstallMethodWithCache );

DeclareGlobalFunction( "InstallMethodWithCrispCache" );

DeclareGlobalFunction( "InstallMethodWithCacheFromObject" );

DeclareOperation( "CachingObject",
                  [ ] );

DeclareOperation( "CachingObject",
                  [ IsObject ] );

DeclareOperation( "CachingObject",
                  [ IsObject, IsObject ] );

DeclareOperation( "CachingObject",
                  [ IsObject, IsObject, IsInt ] );

DeclareOperation( "CachingObject",
                  [ IsObject, IsObject, IsInt, IsBool ] );

DeclareOperation( "Add",
                  [ IsCachingObject, IsInt, IsObject ] );

DeclareOperation( "GetObject",
                  [ IsCachingObject, IsInt, IsInt ] );

DeclareOperation( "CacheValue",
                  [ IsCachingObject, IsObject ] );

DeclareOperation( "SetCacheValue",
                  [ IsCachingObject, IsObject, IsObject ] );

## Installed for CachingObject, Int, String
DeclareOperation( "InstallHas",
                  [ IsObject, IsString, IsList ] );

DeclareOperation( "InstallSet",
                  [ IsObject, IsString, IsList ] );

DeclareOperation( "DeclareHasAndSet",
                  [ IsString, IsList ] );

DeclareOperation( "DeclareOperationWithCache",
                  [ IsString, IsList ] );

DeclareOperation( "IsEqualForCache",
                  [ IsObject, IsObject ] );

################################
##
## Debug functions
##
################################

DeclareGlobalVariable( "TOOLS_FOR_HOMALG_SAVED_CACHES_FROM_INSTALL_METHOD_WITH_CACHE" );

DeclareGlobalFunction( "TOOLS_FOR_HOMALG_STORE_CACHES" );
