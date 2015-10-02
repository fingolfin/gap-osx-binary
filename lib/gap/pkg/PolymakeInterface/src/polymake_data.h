#ifndef POLYMAKEDATA
#define POLYMAKEDATA 1

#include "loadgap.h"

#include <polymake/Main.h>
#include <polymake/Matrix.h>
#include <polymake/IncidenceMatrix.h>
#include <polymake/Rational.h>
#include <polymake/common/lattice_tools.h>

#include <iostream>
#include <map>
#include <utility>

using std::cerr;
using std::endl;
using std::string;
using std::map;
using std::pair;

extern Obj TheTypeExternalPolymakeCone;
extern Obj TheTypeExternalPolymakeFan;
extern Obj TheTypeExternalPolymakePolytope;
extern Obj TheTypeExternalPolymakeTropicalHypersurface;
extern Obj TheTypeExternalPolymakeTropicalPolytope;

typedef pair<int, pm::perl::Object*> object_pair;
typedef pm::perl::Object perlobj;
typedef map<int, pm::perl::Object*>::iterator iterator;

struct Polymake_Data {
   bool initialized;
   polymake::Main *main_polymake_session;
   polymake::perl::Scope *main_polymake_scope;
   map<int, pm::perl::Object*> *polymake_objects;
   int new_polymake_object_number;
};

#define POLYMAKEOBJ_SET_PERLOBJ(o, p) (ADDR_OBJ(o)[1] = reinterpret_cast<Obj>(p))
#define PERLOBJ_POLYMAKEOBJ(o) (reinterpret_cast<perlobj*>(ADDR_OBJ(o)[1]))

#define IS_POLYMAKE_CONE(o) ((UInt)(ADDR_OBJ(o)[0])==(UInt)TheTypeExternalPolymakeCone)
#define IS_POLYMAKE_POLYTOPE(o) ((UInt)(ADDR_OBJ(o)[0])==(UInt)TheTypeExternalPolymakePolytope)
#define IS_POLYMAKE_FAN(o) ((UInt)(ADDR_OBJ(o)[0])==(UInt)TheTypeExternalPolymakeFan)
#define IS_POLYMAKE_TROPICAL_HYPERSURFACE(o) ((UInt)(ADDR_OBJ(o)[0])==(UInt)TheTypeExternalPolymakeTropicalHypersurface)
#define IS_POLYMAKE_TROPICAL_POLYTOPE(o) ((UInt)(ADDR_OBJ(o)[0])==(UInt)TheTypeExternalPolymakeTropicalPolytope)
#define IS_POLYMAKE_OBJECT(o) ((IS_POLYMAKE_CONE(o))||(IS_POLYMAKE_POLYTOPE(o))||(IS_POLYMAKE_FAN(o))||(IS_POLYMAKE_TROPICAL_HYPERSURFACE(o))||(IS_POLYMAKE_TROPICAL_POLYTOPE(o)))

enum polymake_object_type {
  T_POLYMAKE_EXTERNAL_CONE,
  T_POLYMAKE_EXTERNAL_FAN,
  T_POLYMAKE_EXTERNAL_POLYTOPE,
  T_POLYMAKE_EXTERNAL_TROPICAL_HYPERSURFACE,
  T_POLYMAKE_EXTERNAL_TROPICAL_POLYTOPE
};
Obj NewPolymakeExternalObject(enum polymake_object_type t);
void ExternalPolymakeObjectFreeFunc(Obj o);
Obj ExternalPolymakeObjectTypeFunc(Obj o);

void polymake_start( Polymake_Data* );


// Obj x = NewPolymakeExternalObject(T_POLYMAKE_EXTERNAL_CONE);
// POLYMAKEOBJ_SET_PERLOBJ(x, p);

#define POLYMAKE_GAP_CATCH \
    catch( std::exception& err ){ \
    cerr << "Polymake error: " << endl << err.what( ) << endl; \
    ErrorMayQuit("during polymake computation.",0,0); \
  }

#endif
