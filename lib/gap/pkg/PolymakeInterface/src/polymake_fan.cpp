#include "polymake_fan.h"

Obj REAL_FAN_BY_CONES_SAVE( Polymake_Data* data, Obj cones ){
  
  if( ! IS_PLIST( cones ) ){
    ErrorMayQuit( "not a plain list", 0, 0);
    return NULL;
  }
  
  int numberofcones = LEN_PLIST( cones );
  Obj akt;
  Obj elem;
  Obj numb;
  int numberofrays = 0;
  data->main_polymake_session->set_application("fan");
  
  for(int i=1;i<=numberofcones;i++){
      akt = ELM_PLIST( cones, i );
#ifdef MORE_TESTS
      if( !IS_PLIST( akt ) ){
        ErrorMayQuit( "one cone is not a plain list", 0, 0);
        return NULL;
      }
#endif
      numberofrays += LEN_PLIST( akt );
  
  }
  int dimension = LEN_PLIST( ELM_PLIST( ELM_PLIST( cones, 1 ), 1 ) );
  pm::Array< pm::Set<pm::Integer> > incMatr(numberofcones,pm::Set<pm::Integer>());
  pm::Integer ratarray[ (numberofrays+1)*dimension ];
  int raycounter = 1;
  for(int i = 0; i < dimension; i++ )
    ratarray[i] = 0;
  for(int i = 1; i <= numberofcones; i++){
        akt = ELM_PLIST( cones, i );
        for( int j = 1; j <= LEN_PLIST( akt ); j++){
            elem = ELM_PLIST( akt, j );
            for( int k = 1; k <= LEN_PLIST( elem ); k++){
                numb = ELM_PLIST( elem, k );
                
#ifdef MORE_TESTS
                if( ! IS_INTOBJ( numb ) ){
                ErrorMayQuit( "some entries are not integers", 0, 0);
                return NULL;
                }
#endif
                
                ratarray[ raycounter*dimension+(k-1) ] = INT_INTOBJ( numb );
              
            }
            (incMatr[i-1]).collect(raycounter);
            raycounter++;
        }
  }
  pm::Matrix<pm::Integer>* matr = new pm::Matrix<pm::Integer>((numberofrays+1),dimension,ratarray);
  perlobj q;
  CallPolymakeFunction("check_fan",*matr,incMatr) >> q;
  data->polymake_objects->insert( object_pair(data->new_polymake_object_number, &q ) );
  elem = INTOBJ_INT( data->new_polymake_object_number );
  data->new_polymake_object_number++;
  return elem;
}



Obj REAL_FAN_BY_CONES( Polymake_Data* data, Obj cones ){
  
  if( ! IS_PLIST( cones ) ){
    ErrorMayQuit( "not a plain list", 0, 0);
    return NULL;
  }
  
  int numberofcones = LEN_PLIST( cones );
  Obj akt;
  Obj elem;
  Obj numb;
  int numberofrays = 0;
  data->main_polymake_session->set_application("fan");
  
  for(int i=1;i<=numberofcones;i++){
      akt = ELM_PLIST( cones, i );
#ifdef MORE_TESTS
      if( !IS_PLIST( akt ) ){
        ErrorMayQuit( "one cone is not a plain list", 0, 0);
        return NULL;
      }
#endif
      numberofrays += LEN_PLIST( akt );
  
  }
  
  int dimension = LEN_PLIST( ELM_PLIST( ELM_PLIST( cones, 1 ), 1 ) );
  pm::Array< pm::Set<pm::Integer> >* incMatr;
  incMatr = new pm::Array< pm::Set<pm::Integer> >(numberofcones,pm::Set<pm::Integer>());
  pm::Integer* ratarray;
  ratarray = new pm::Integer[ (numberofrays+1)*dimension ];
  int raycounter = 1;
  for(int i = 0; i < dimension; i++ )
    ratarray[i] = 0;
  for(int i = 1; i <= numberofcones; i++){
        akt = ELM_PLIST( cones, i );
        for( int j = 1; j <= LEN_PLIST( akt ); j++){
            elem = ELM_PLIST( akt, j );
            for( int k = 1; k <= LEN_PLIST( elem ); k++){
                numb = ELM_PLIST( elem, k );
                
#ifdef MORE_TESTS
                if( ! IS_INTOBJ( numb ) ){
                  delete [] ratarray;
                  delete incMatr;
                  ErrorMayQuit( "some entries are not integers", 0, 0);
                  return NULL;
                }
#endif
                
                ratarray[ raycounter*dimension+(k-1) ] = INT_INTOBJ( numb );
              
            }
            ((*incMatr)[i-1]).collect(raycounter);
            raycounter++;
        }
  }
  pm::Matrix<pm::Integer>* matr = new pm::Matrix<pm::Integer>((numberofrays+1),dimension,ratarray);
  perlobj* q = new perlobj("PolyhedralFan<Rational>");
  q->take("INPUT_RAYS") << *matr;
  q->take("INPUT_CONES") << *incMatr;
  elem = NewPolymakeExternalObject( T_POLYMAKE_EXTERNAL_FAN );
  POLYMAKEOBJ_SET_PERLOBJ( elem, q);
  delete [] ratarray;
  delete incMatr;
  delete matr;
  return elem;
}



Obj REAL_FAN_BY_RAYS_AND_CONES( Polymake_Data* data, Obj rays, Obj cones ){
  
  if( ! IS_PLIST( cones ) || ! IS_PLIST( rays ) ){
    ErrorMayQuit( "not a plain list", 0, 0);
    return NULL;
  }
  
  int numberofrays = LEN_PLIST( rays );
  Obj akt;
  Obj elem;
  Obj numb;
  data->main_polymake_session->set_application("fan");
  int dimension = LEN_PLIST( ELM_PLIST( rays, 1 ) );
  pm::Integer* ratarray;
  ratarray = new pm::Integer[ numberofrays*dimension ];
  for(int i=0;i<numberofrays;i++){
      akt = ELM_PLIST( rays, i+1 );
#ifdef MORE_TESTS
      if( !IS_PLIST( akt ) || LEN_PLIST( akt ) != dimension ){
        delete [] ratarray;
        ErrorMayQuit( "one ray is not a plain list", 0, 0);
        return NULL;
      }
#endif
      for(int j = 0; j<dimension; j++){
        numb = ELM_PLIST( akt, j+1 );
#ifdef MORE_TESTS
        if( ! IS_INTOBJ( numb ) ){
          delete [] ratarray;
          ErrorMayQuit( "some entries are not integers", 0, 0);
          return NULL;
        }
#endif
        ratarray[(i*dimension)+j] = INT_INTOBJ( numb );
      }
  }
  int numberofcones = LEN_PLIST( cones );
  pm::Array< pm::Set<pm::Integer> >* incMatr;
  incMatr = new pm::Array< pm::Set<pm::Integer> >(numberofcones,pm::Set<pm::Integer>());
 for(int i=0;i<numberofcones;i++){
      akt = ELM_PLIST( cones, i+1 );
#ifdef MORE_TESTS
      if( !IS_PLIST( akt ) ){
        delete [] ratarray;
        delete incMatr;
        ErrorMayQuit( "one cone is not a plain list", 0, 0);
        return NULL;
      }
#endif
      for(int j = 0; j < LEN_PLIST( akt ) ; j++){
        numb = ELM_PLIST( akt, j+1 );
#ifdef MORE_TESTS
        if( ! IS_INTOBJ( numb ) ){
          delete [] ratarray;
          delete incMatr;
          ErrorMayQuit( "some entries are not integers", 0, 0);
          return NULL;
        }
#endif
        ((*incMatr)[i]).collect( INT_INTOBJ( numb ) - 1 );
      }
  }
  
  pm::Matrix<pm::Integer>* matr = new pm::Matrix<pm::Integer>(numberofrays,dimension,ratarray);
  perlobj* q = new perlobj("PolyhedralFan<Rational>");
  q->take("INPUT_RAYS") << *matr;
  q->take("INPUT_CONES") << *incMatr;
  elem = NewPolymakeExternalObject( T_POLYMAKE_EXTERNAL_FAN );
  POLYMAKEOBJ_SET_PERLOBJ( elem, q);
  delete [] ratarray;
  delete matr;
  delete incMatr;
  return elem;
}


Obj REAL_FAN_BY_RAYS_AND_CONES_UNSAVE( Polymake_Data* data, Obj rays, Obj cones ){
  
  if( ! IS_PLIST( cones ) || ! IS_PLIST( rays ) ){
    ErrorMayQuit( "not a plain list", 0, 0);
    return NULL;
  }
  
  int numberofrays = LEN_PLIST( rays );
  Obj akt;
  Obj elem;
  Obj numb;
  data->main_polymake_session->set_application("fan");
  int dimension = LEN_PLIST( ELM_PLIST( rays, 1 ) );
  pm::Integer* ratarray;
  ratarray = new pm::Integer[ numberofrays*dimension ];
  for(int i=0;i<numberofrays;i++){
      akt = ELM_PLIST( rays, i+1 );
#ifdef MORE_TESTS
      if( !IS_PLIST( akt ) || LEN_PLIST( akt ) != dimension ){
        delete [] ratarray;
        ErrorMayQuit( "one ray is not a plain list", 0, 0);
        return NULL;
      }
#endif
      for(int j = 0; j<dimension; j++){
        numb = ELM_PLIST( akt, j+1 );
#ifdef MORE_TESTS
        if( ! IS_INTOBJ( numb ) ){
          delete [] ratarray;
          ErrorMayQuit( "some entries are not integers", 0, 0);
          return NULL;
        }
#endif
        ratarray[(i*dimension)+j] = INT_INTOBJ( numb );
      }
  }
  int numberofcones = LEN_PLIST( cones );
  pm::Array< pm::Set<pm::Integer> >* incMatr;
  incMatr = new pm::Array< pm::Set<pm::Integer> >(numberofcones,pm::Set<pm::Integer>());
 for(int i=0;i<numberofcones;i++){
      akt = ELM_PLIST( cones, i+1 );
#ifdef MORE_TESTS
      if( !IS_PLIST( akt ) ){
        delete [] ratarray;
        delete incMatr;
        ErrorMayQuit( "one cone is not a plain list", 0, 0);
        return NULL;
      }
#endif
      for(int j = 0; j < LEN_PLIST( akt ) ; j++){
        numb = ELM_PLIST( akt, j+1 );
#ifdef MORE_TESTS
        if( ! IS_INTOBJ( numb ) ){
          delete [] ratarray;
          delete incMatr;
          ErrorMayQuit( "some entries are not integers", 0, 0);
          return NULL;
        }
#endif
        ((*incMatr)[i]).collect( INT_INTOBJ( numb ) - 1 );
      }
  }
  
  pm::Matrix<pm::Integer>* matr = new pm::Matrix<pm::Integer>(numberofrays,dimension,ratarray);
  perlobj* q = new perlobj("PolyhedralFan<Rational>");
  q->take("RAYS") << *matr;
  q->take("INPUT_CONES") << *incMatr;
  elem = NewPolymakeExternalObject( T_POLYMAKE_EXTERNAL_FAN );
  POLYMAKEOBJ_SET_PERLOBJ( elem, q);
  delete [] ratarray;
  delete matr;
  delete incMatr;
  return elem;
}



Obj REAL_RAYS_IN_MAXCONES_OF_FAN( Polymake_Data* data, Obj fan ){

#ifdef MORE_TESTS
  if(! IS_POLYMAKE_FAN(fan) ){
    ErrorMayQuit(" parameter is not a fan.",0,0);
    return NULL;
  }
#endif
  
  perlobj* coneobj = PERLOBJ_POLYMAKEOBJ( fan );
  data->main_polymake_session->set_application_of(*coneobj);
  pm::IncidenceMatrix<pm::NonSymmetric> matr;
  try
  {
      pm::IncidenceMatrix<pm::NonSymmetric> matr_temp = coneobj->give("MAXIMAL_CONES");
      matr = matr_temp;
  }
  catch( std::exception err ){
    ErrorMayQuit(" error during polymake computation.",0,0);
    return NULL;
  }
  Obj RETLI = NEW_PLIST( T_PLIST , matr.rows());
  UInt matr_rows = matr.rows();
  SET_LEN_PLIST( RETLI , matr_rows );
  Obj LIZeil;
  UInt matr_cols = matr.cols();
  for(int i = 0;i<matr.rows();i++){
    LIZeil = NEW_PLIST( T_PLIST, matr.cols());
    SET_LEN_PLIST( LIZeil , matr_cols );
    for(int j = 0;j<matr.cols();j++){
      SET_ELM_PLIST(LIZeil,j+1,INTOBJ_INT(matr(i,j)));
    }
    SET_ELM_PLIST(RETLI,i+1,LIZeil);
    CHANGED_BAG(RETLI);
  }
  return RETLI;
  
}



Obj REAL_NORMALFAN_OF_POLYTOPE( Polymake_Data* data, Obj polytope ){

#ifdef MORE_TESTS
  if(! IS_POLYMAKE_POLYTOPE(polytope) ){
    ErrorMayQuit(" parameter is not a polytope.",0,0);
    return NULL;
  }
#endif
  
  perlobj* coneobj = PERLOBJ_POLYMAKEOBJ( polytope );
  data->main_polymake_session->set_application("fan");
  perlobj p;
  try{
      CallPolymakeFunction("normal_fan",*coneobj) >> p;
  }
  catch( std::exception err ){
    ErrorMayQuit(" error during polymake computation.",0,0);
    return NULL;
  }
  perlobj* q = new perlobj(p);
  //data->polymake_objects->insert( object_pair(data->new_polymake_object_number, &p ) );
  Obj elem = NewPolymakeExternalObject( T_POLYMAKE_EXTERNAL_FAN );
  POLYMAKEOBJ_SET_PERLOBJ( elem, q );
  return elem;
}


Obj REAL_STELLAR_SUBDIVISION( Polymake_Data* data, Obj ray, Obj fan ){

#ifdef MORE_TESTS
  if( (! IS_POLYMAKE_CONE(ray)) || (! IS_POLYMAKE_FAN(fan)) ){
    ErrorMayQuit(" parameter is not a fan or a cone.",0,0);
    return NULL;
  }
#endif
  perlobj* rayobject = PERLOBJ_POLYMAKEOBJ( ray );
  perlobj* fanobject = PERLOBJ_POLYMAKEOBJ( fan );
  data->main_polymake_session->set_application("fan");
  perlobj p;
  try{
      CallPolymakeFunction("stellar_subdivision",*rayobject,*fanobject) >> p;
  }
  catch( std::exception err ){
    ErrorMayQuit(" error during polymake computation.",0,0);
    return NULL;
  }
  perlobj* q = new perlobj(p);
  Obj elem = NewPolymakeExternalObject( T_POLYMAKE_EXTERNAL_FAN );
  POLYMAKEOBJ_SET_PERLOBJ( elem, q );
  return elem;
}


Obj REAL_RAYS_OF_FAN( Polymake_Data* data, Obj fan){

#ifdef MORE_TESTS
  if(  ( ! IS_POLYMAKE_FAN(fan) ) ){
    ErrorMayQuit(" parameter is not a cone or fan.",0,0);
    return NULL;
  }
#endif
  
  perlobj* coneobj = PERLOBJ_POLYMAKEOBJ( fan );
  data->main_polymake_session->set_application_of(*coneobj);
  pm::Matrix<pm::Rational> matr;
  try{
      pm::Matrix<pm::Rational> matr_temp = coneobj->give("RAYS");
      matr = matr_temp;
  }
  catch( std::exception err ){
    ErrorMayQuit(" error during polymake computation.",0,0);
    return NULL;
  }
  Obj RETLI = NEW_PLIST( T_PLIST , matr.rows());
  UInt matr_rows = matr.rows();
  SET_LEN_PLIST( RETLI , matr_rows );
  Obj LIZeil;
  pm::Integer nenner;
  pm::Integer dentemp;
  UInt matr_cols = matr.cols();
  for(int i = 0;i<matr.rows();i++){
    LIZeil = NEW_PLIST( T_PLIST, matr.cols());
    SET_LEN_PLIST( LIZeil , matr_cols );
    nenner = 1;
    for(int j = 0;j<matr.cols();j++){
      CallPolymakeFunction("denominator",matr(i,j)) >> dentemp;
      CallPolymakeFunction("lcm",nenner, dentemp ) >> nenner;
    }
    for(int j = 0;j<matr.cols();j++){
      SET_ELM_PLIST(LIZeil,j+1,INTOBJ_INT( (matr(i,j)*nenner).to_int() ));
    }
    SET_ELM_PLIST(RETLI,i+1,LIZeil);
    CHANGED_BAG(RETLI);
  }
  return RETLI;
}