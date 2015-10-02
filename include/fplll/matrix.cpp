/* Copyright (C) 2005-2008 Damien Stehle.
   Copyright (C) 2007 David Cade.
   Copyright (C) 2011 Xavier Pujol.

   This file is part of fplll. fplll is free software: you
   can redistribute it and/or modify it under the terms of the GNU Lesser
   General Public License as published by the Free Software Foundation,
   either version 2.1 of the License, or (at your option) any later version.

   fplll is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with fplll. If not, see <http://www.gnu.org/licenses/>. */

#ifndef FPLLL_MATRIX_CPP
#define FPLLL_MATRIX_CPP

FPLLL_BEGIN_NAMESPACE

template<class T>
void Matrix<T>::resize(int rows, int cols) {
  int oldSize = matrix.size();
  if (oldSize < rows) {
    vector<NumVect<T> > m2(max(oldSize * 2, rows));
    for (int i = 0; i < oldSize; i++) {
      matrix[i].swap(m2[i]);
    }
    matrix.swap(m2);
  }
  for (int i = r; i < rows; i++) {
    matrix[i].resize(cols);
  }
  if (cols != c) {
    for (int i = min(r, rows) - 1; i >= 0; i--) {
      matrix[i].resize(cols);
    }
  }
  r = rows;
  c = cols;
  cols = c;
}

template<class T>
template<class U>
void Matrix<T>::fill(U value) {
  for (int i = 0; i < r; i++) {
    for (int j = 0; j < c; j++) {
      matrix[i][j] = value;
    }
  }
}

template<class T>
void Matrix<T>::rotateGramLeft(int first, int last, int nValidRows) {
  FPLLL_DEBUG_CHECK(0 <= first && first <= last && last < nValidRows &&
          nValidRows <= r);
  matrix[first][first].swap(matrix[first][last]);
  for (int i = first; i < last; i++) {
    matrix[i + 1][first].swap(matrix[first][i]);
  }
  for (int i = first; i < nValidRows; i++) {
    matrix[i].rotateLeft(first, min(last, i)); // most expensive step
  }
  rotateLeft(first, last);
}

template<class T>
void Matrix<T>::rotateGramRight(int first, int last, int nValidRows) {
  FPLLL_DEBUG_CHECK(0 <= first && first <= last && last < nValidRows &&
          nValidRows <= r);
  rotateRight(first, last);
  for (int i = first; i < nValidRows; i++) {
    matrix[i].rotateRight(first, min(last, i)); // most expensive step
  }
  for (int i = first; i < last; i++) {
    matrix[i + 1][first].swap(matrix[first][i]);
  }
  matrix[first][first].swap(matrix[first][last]);
}

template<class T>
void Matrix<T>::transpose() {
  extendVect(matrix, c);
  for (int i = 0; i < c; i++) {
    matrix[i].extend(r);
  }
  for (int i = 0; i < min(r, c); i++) {
    for (int j = i + 1; j < max(r, c); j++) {
      matrix[i][j].swap(matrix[j][i]);
    }
    if (c > r)
      matrix[i].resize(r);
  }
  std::swap(r, c);
}

template<class T>
long Matrix<T>::getMaxExp() {
  long maxExp = 0;
  for (int i = 0; i < r; i++)
    for (int j = 0; j < c; j++)
      maxExp = max(maxExp, matrix[i][j].exponent());
  return maxExp;
}

template<class T>
void Matrix<T>::print(ostream& os, int nRows, int nCols) const {
  if (nRows < 0 || nRows > r) nRows = r;
  if (nCols < 0 || nCols > c) nCols = c;
  os << '[';
  for (int i = 0; i < nRows; i++) {
    if (i > 0) os << '\n';
    os << '[';
    for (int j = 0; j < nCols; j++) {
      if (j > 0) os << ' ';
      os << matrix[i][j];
    }
    if (printMode == MAT_PRINT_REGULAR && nCols > 0) os << ' ';
    os << ']';
  }
  if (printMode == MAT_PRINT_REGULAR && nRows > 0) os << '\n';
  os << ']';
}

template<class T>
void Matrix<T>::read(istream& is) {
  char ch;
  matrix.clear();
  if (!(is >> ch)) return;
  if (ch != '[') {
    is.setstate(ios::failbit);
    return;
  }
  while (is >> ch && ch != ']') {
    is.putback(ch);
    matrix.resize(matrix.size() + 1);
    if (!(is >> matrix.back())) {
      matrix.pop_back();
      break;
    }
  }

  r = matrix.size();
  c = 0;
  for (int i = 0; i < r; i++) {
    c = max(c, matrix[i].size());
  }
  for (int i = 0; i < r; i++) {
    int oldC = matrix[i].size();
    if (oldC < c) {
      matrix[i].resize(c);
      for (int j = oldC; j < c; j++) {
        matrix[i][j] = 0;
      }
    }
  }
}

#ifdef FPLLL_V3_COMPAT

template<class T>
void Matrix<T>::print(int d, int n) {
  cout << "[";
  for (int i=0;i<d;i++) {
    cout << "[";
    for (int j=0;j<n;j++) {
      matrix[i][j].print();
      cout << " ";
    }
    cout << "]\n";
  }
  cout << "]" << endl;
}

inline char nextNonBlankChar(char& ch)
{
  
  ch=getchar();
  while (ch==' '||ch=='\t'||ch=='\r'||ch=='\n')
    ch=getchar();
  return ch;
}

template<class T>
int Matrix<T>::read()
{
  char ch;
  
  nextNonBlankChar(ch);

  if (ch!='[')
    {
      FPLLL_INFO("[ expected instead of "<<ch);
      return 1;
    }
  for (int i=0; i<r; i++)
    {
      nextNonBlankChar(ch);
      if (ch != '[')
        {
          FPLLL_INFO("error at row "<<i<< " '[' expected instead of "<<ch);
          return 1;
        }
      for (int j=0; j<c; j++)
        {
          matrix[i][j].read();
        }
      
      nextNonBlankChar(ch);
      if (ch != ']')
        {
          FPLLL_INFO("error: ']' expected at line "<<i);
          return 1;
        }
    }

  nextNonBlankChar(ch);
  if (ch != ']')
    {
      FPLLL_INFO("error: ']' expected");
      return 1;
    }

  return 0;
}

#endif // #ifdef FPLLL_V3_COMPAT


/* ZZ_mat */

template<class ZT> inline void ZZ_mat<ZT>::gen_intrel(int bits)
{
  if (c!=r+1)
    {
      FPLLL_ABORT("gen_intrel called on an ill-formed matrix");
      return;
    }
  int i,j;
  for (i=0;i<r;i++)
    {
      matrix[i][0].randb(bits);
      for (j=1; j<=i; j++)
        matrix[i][j] = 0;
      matrix[i][i + 1] = 1;
      for (j=i+2; j<c; j++)
        matrix[i][j] = 0;
    }
}


template<class ZT> inline void ZZ_mat<ZT>::gen_simdioph(int bits,int bits2)
{
  if (c!=r)
    {
      FPLLL_ABORT("gen_simdioph called on an ill-formed matrix");
      return;
    }
  int i, j;

  matrix[0][0] = 1;
  matrix[0][0].mul_2si(matrix[0][0], bits2);
  for (i=1; i<r; i++)
    matrix[0][i].randb(bits);
  for (i=1; i<r; i++)
    {
      for (j=1; j<i; j++)
        matrix[j][i] = 0;
      matrix[i][i] = 1;
      matrix[i][i].mul_2si(matrix[i][i], bits);
      for (j=i+1; j<c; j++)
        matrix[j][i] = 0;
    }
}

template<class ZT> inline void ZZ_mat<ZT>::gen_uniform(int bits)
{
  for (int i=0;i<r;i++)for(int j=0;j<c;j++)matrix[i][j].randb(bits);
}

template<class ZT> inline void ZZ_mat<ZT>::gen_ntrulike(int bits,int q)
{
  int i, j, k;
  int d=r/2;
  if (c!=r || c!=2*d) 
    {
      FPLLL_ABORT("gen_ntrulike called on an ill-formed matrix");
      return;
    }
  Z_NR<ZT> * h=new Z_NR<ZT>[d];

  for (i=0; i<d; i++)
    h[i].randb(bits);
  
  for (i=0; i<d; i++)
    {
      for (j=0; j<i; j++)
        matrix[i][j] = 0;
      matrix[i][i] = 1;
      for (j=i+1; j<d; j++)
        matrix[i][j] = 0;
    }

  for (i=d; i<r; i++)
    for (j=0; j<d; j++)
      matrix[i][j] = 0;

  for (i=d; i<r; i++)
    {
      for (j=d; j<i; j++)
        matrix[i][j] = 0;
      matrix[i][i] = q;
      for (j=i+1; j<c; j++)
        matrix[i][j] = 0;
    }

  for (i=0; i<d; i++)
    for (j=d; j<c; j++)
      { 
        k = j+i;
        while (k>=d)k-=d;
        matrix[i][j] = h[k];
      }

  delete[] h;
}

template<class ZT> inline void ZZ_mat<ZT>::gen_ntrulike2(int bits,int q)
{

  int i, j, k;
  
  int d=r/2;
  if (c!=r || c!=2*d) 
    {
      FPLLL_ABORT("gen_ntrulike2 called on an ill-formed matrix");
      return;
    }
  Z_NR<ZT> * h=new Z_NR<ZT>[d];
   
  for (i=0; i<d; i++)
    h[i].randb(bits);
  
  for (i=0; i<d; i++)
    for (j=0; j<c; j++)
      matrix[i][j] = 0;

  for (i=0; i<d; i++)
    matrix[i][i] = q;


  for (i=d; i<r; i++)
    for (j=d; j<c; j++)
      matrix[i][j] = 0;
      
  for (i=d; i<c; i++)
    matrix[i][i] = 1;

  for (i=d; i<r; i++)
    for (j=0; j<d; j++)
      { 
        k = i+j;
        while (k>=d)k-=d;
        matrix[i][j] = h[k];
      }

  delete[] h;
}

template<class ZT> inline void ZZ_mat<ZT>::gen_ajtai(double alpha)
{
  int i, j, bits;
  Z_NR<ZT> ztmp, ztmp2, zone, sign;
  
  ztmp2 = 0;
  zone = 1;

  int d=r;
  if (c!=r) 
    {
      FPLLL_ABORT("gen_ajtai called on an ill-formed matrix");
      return;
    }

  for (i=0; i<d; i++)
    {
      bits = (int) pow((double) (2*d-i), alpha);
      ztmp = 1;
      ztmp.mul_2si(ztmp, bits);          
      ztmp.sub(ztmp,zone); 
      matrix[i][i].randm(ztmp);
      matrix[i][i].add_ui(matrix[i][i], 2);
      ztmp.div_2si(matrix[i][i], 1);
      for (j=i+1; j<d; j++)
        {
          matrix[j][i].randm(ztmp);
          sign.randb(1);
          if (sign == 1)
            matrix[j][i].sub(ztmp2, matrix[j][i]);
          matrix[i][j] = 0;
        }
    }
}


template<class ZT> inline void ZZ_mat<ZT>::gen_ajtai2(FP_NR<mpfr_t> *w)
{
  int i, j;
  Z_NR<ZT> ztmp, ztmp2;
  
  int d=r;
  if (c!=r) 
    {
      FPLLL_ABORT("gen_ajtai2 called on an ill-formed matrix");
      return;
    }

  for (i=0; i<d; i++)
    {
      matrix[i][i].set_f(w[i]);
      ztmp.div_2si(matrix[i][i], 1);
      ztmp2 = 1;
      ztmp.add(ztmp, ztmp2);
      for (j=i+1; j<d; j++)
        { 
          ztmp2 = 0;
          matrix[j][i].randm(ztmp);
          if (rand()%2==1)
            matrix[j][i].sub(ztmp2, matrix[j][i]);
          matrix[i][j] = 0;
        }
    }

}

#ifdef FPLLL_V3_COMPAT

template<class ZT> int ZZ_mat<ZT>::getShift()
{
  int n = getCols();
  int shift=0;
  for (int i = 0; i < getRows(); i++) {
    int j;
    for (j = n - 1; j >= 0 && matrix[i][j].sgn() == 0; j--) {}
    if (shift < j - i) shift = j - i;
  }

#ifdef DEBUG
  cerr << "Shift  =  " << shift <<", ";
#endif
  return shift;
}

#endif // #ifdef FPLLL_V3_COMPAT

FPLLL_END_NAMESPACE

#endif
