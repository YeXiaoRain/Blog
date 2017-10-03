---
title: 最小值管理
date: 2017-04-17 23:31:33
description: C++手工优化
tags:
category: [code]
---

# Minimum_maintenance.cpp

```c++

//template
#include<iostream>
#include<cstdlib>
#include<assert.h>
using namespace std;
struct max_select{
  int p;
  int d;
  double v;
  bool operator > (const max_select & other) const {
    return v > other.v;
  }
  bool operator < (const max_select & other) const {
    return v < other.v;
  }
  bool operator == (const max_select & other) const {
    return v == other.v;
  }
};

template <class T>
class Minimum_maintenance {
  private:
    T * _stack[2]; // 0 store Descending sequence, 1 store other's
    int _iter[2];    // store iter
    int * _order;    // for push and pop
    int * _fakedeepcopy ;
  public:
    Minimum_maintenance(){
      cout<<"NOT SUPPORT"<<endl;
      assert(0);
    }
    Minimum_maintenance(int s){
      if(s < 1)//protect
        s = 1;
      _iter[0] = 0;
      _iter[1] = 0;
      _stack[0] = new T[s];
      _stack[1] = new T[s];
      _order = new int[s];
      _fakedeepcopy = new int [1] ;
      printf("new (%08x)\n",this);
      printf("    _stack[0] = (%08x)\n",_stack[0]);
      printf("    _stack[1] = (%08x)\n",_stack[1]);
      printf("    _order    = (%08x)\n",_order);
      _fakedeepcopy[0] = 0;
    }
    Minimum_maintenance(const Minimum_maintenance& copy){
      _stack[0]   = copy._stack[0];
      _stack[1]   = copy._stack[1];
      _iter [0]   = copy._iter [0];
      _iter [1]   = copy._iter [1];
      _order      = copy._order;
      _fakedeepcopy = copy._fakedeepcopy;
      _fakedeepcopy[0]++;
      printf("Fake deepcopy %08x => %08x\n",&copy,this);
    }
    ~Minimum_maintenance(){
      printf("free(%08x)\n",this);
      printf("    _fakedeepcopy = %d\n",_fakedeepcopy[0]);
      printf("    _stack[0]   = (%08x)\n",_stack[0]);
      printf("    _stack[1]   = (%08x)\n",_stack[1]);
      printf("    _order      = (%08x)\n",_order);
      if(!_fakedeepcopy[0]){
        delete [] _stack[0];
        delete [] _stack[1];
        delete [] _order;
      }else{
        _fakedeepcopy[0]--;
      }
      cout<<"free() finished"<<endl;
    }
    void push(const T & ms){
      int i;
      if(_iter[0] == 0 || _stack[0][_iter[0] - 1] > ms){
        i = 0;
      }else{
        i = 1;
      }
      _stack[i][_iter[i]] = ms;

      _order[_iter[0]+_iter[1]] = i;
      _iter[i] ++ ;
    }
    void pop(){
      if(_iter[0]+_iter[1]){
        _iter[_order[ _iter[0] + _iter[1] - 1 ]]--;
      }
    }
    bool top(T & ms){
      if(!(_iter[0]+_iter[1]))
        return false;
      int o = _order[ _iter[0] + _iter[1] - 1];
      ms = _stack[0][ _iter[0] - 1];
      return true;
    }
    bool const empty(){
      return _iter[0] == 0;
    }
};

int main(){
  int i;
  Minimum_maintenance<max_select> mm(20);
  for( i = 0; i < 20 ; i ++){
    double in = rand()*1.0;
    cout<<in<<endl<<"\t";
    max_select inms = {1,1,in};
    mm.push(inms);
    while(rand()%2){
      cout<< " POP ";
      mm.pop();
    }
    max_select ms;
    if(mm.top(ms))//mm.empty()
      cout<<ms.v<<endl;
    else
      cout<<"EMPTY()"<<endl;
  }
  return 0;
}
```

# Minimum_maintenance.old1.cpp

```c++
// just run
#include<iostream>
#include<cstdlib>
using namespace std;
class MinimumMaintenance {
  private:
    int * _stack[2]; // 0 store Descending sequence, 1 store other's
    int _iter[2];    // store iter
    int * _order;    // for push and pop
  public:
    MinimumMaintenance(int s){
      _iter[0] = 0;
      _iter[1] = 0;
      _stack[0] = new int[3*s];
      _stack[1] = new int[3*s];
      _order = new int[s];
    }
    ~MinimumMaintenance(){
      delete [] _stack[0];
      delete [] _stack[1];
      delete [] _order;
    }
    void push(int p,int d,int v){
      int i;
      if(_iter[0] == 0 || _stack[0][3*(_iter[0] - 1)+2] > v){
        i = 0;
      }else{
        i = 1;
      }
      _stack[i][3*_iter[i]    ] = p;
      _stack[i][3*_iter[i] + 1] = d;
      _stack[i][3*_iter[i] + 2] = v;

      _order[_iter[0]+_iter[1]] = i;
      _iter[i] ++ ;
    }
    void pop(){
      if(_iter[0]+_iter[1]){
        _iter[_order[ _iter[0] + _iter[1] - 1 ]]--;
      }
    }
    bool top(int & p,int & d,int &v){
      if(!(_iter[0]+_iter[1]))
        return false;
      int o = _order[ _iter[0] + _iter[1] - 1];
      p = _stack[0][ 3 * _iter[0] - 3];
      d = _stack[0][ 3 * _iter[0] - 2];
      v = _stack[0][ 3 * _iter[0] - 1];
      return true;
    }
};
int main(){
  int i;
  MinimumMaintenance mm(20);
  for( i = 0; i < 20 ; i ++){
    int in = rand();
    cout<<in<<endl<<"\t";
    mm.push(1,1,in);
    while(rand()%2){
      cout<< " POP ";
      mm.pop();
    }
    int a,b,c;
    if(mm.top(a,b,c))
      cout<<c<<endl;
    else
      cout<<"EMPTY()"<<endl;
  }
  return 0;
}

```

# Minimum_maintenance.old2.cpp

```c++
//struct
#include<iostream>
#include<cstdlib>
using namespace std;
struct max_select{
  int p;
  int d;
  double v;
};
class Minimum_maintenance {
  private:
    max_select * _stack[2]; // 0 store Descending sequence, 1 store other's
    int _iter[2];    // store iter
    int * _order;    // for push and pop
  public:
    Minimum_maintenance(int s){
      _iter[0] = 0;
      _iter[1] = 0;
      _stack[0] = new max_select[s];
      _stack[1] = new max_select[s];
      _order = new int[s];
    }
    ~Minimum_maintenance(){
      delete [] _stack[0];
      delete [] _stack[1];
      delete [] _order;
    }
    void push(const max_select & ms){
      int i;
      if(_iter[0] == 0 || _stack[0][_iter[0] - 1].v > ms.v){
        i = 0;
      }else{
        i = 1;
      }
      _stack[i][_iter[i]] = ms;

      _order[_iter[0]+_iter[1]] = i;
      _iter[i] ++ ;
    }
    void pop(){
      if(_iter[0]+_iter[1]){
        _iter[_order[ _iter[0] + _iter[1] - 1 ]]--;
      }
    }
    bool top(max_select & ms){
      if(!(_iter[0]+_iter[1]))
        return false;
      int o = _order[ _iter[0] + _iter[1] - 1];
      ms = _stack[0][ _iter[0] - 1];
      return true;
    }
};
int main(){
  int i;
  Minimum_maintenance mm(20);
  for( i = 0; i < 20 ; i ++){
    double in = rand()*1.0;
    cout<<in<<endl<<"\t";
    max_select inms = {1,1,in};
    mm.push(inms);
    while(rand()%2){
      cout<< " POP ";
      mm.pop();
    }
    max_select ms;
    if(mm.top(ms))
      cout<<ms.v<<endl;
    else
      cout<<"EMPTY()"<<endl;
  }
  return 0;
}
```

# Minimum_maintenance.old3.cpp

```c++
//operator
#include<iostream>
#include<cstdlib>
using namespace std;
struct max_select{
  int p;
  int d;
  double v;
  bool operator > (const max_select & other) const {
    return v > other.v;
  }
  bool operator < (const max_select & other) const {
    return v < other.v;
  }
  bool operator == (const max_select & other) const {
    return v == other.v;
  }
};
class Minimum_maintenance {
  private:
    max_select * _stack[2]; // 0 store Descending sequence, 1 store other's
    int _iter[2];    // store iter
    int * _order;    // for push and pop
  public:
    Minimum_maintenance(int s){
      _iter[0] = 0;
      _iter[1] = 0;
      _stack[0] = new max_select[s];
      _stack[1] = new max_select[s];
      _order = new int[s];
    }
    ~Minimum_maintenance(){
      delete [] _stack[0];
      delete [] _stack[1];
      delete [] _order;
    }
    void push(const max_select & ms){
      int i;
      if(_iter[0] == 0 || _stack[0][_iter[0] - 1] > ms){
        i = 0;
      }else{
        i = 1;
      }
      _stack[i][_iter[i]] = ms;

      _order[_iter[0]+_iter[1]] = i;
      _iter[i] ++ ;
    }
    void pop(){
      if(_iter[0]+_iter[1]){
        _iter[_order[ _iter[0] + _iter[1] - 1 ]]--;
      }
    }
    bool top(max_select & ms){
      if(!(_iter[0]+_iter[1]))
        return false;
      int o = _order[ _iter[0] + _iter[1] - 1];
      ms = _stack[0][ _iter[0] - 1];
      return true;
    }
};
int main(){
  int i;
  Minimum_maintenance mm(20);
  for( i = 0; i < 20 ; i ++){
    double in = rand()*1.0;
    cout<<in<<endl<<"\t";
    max_select inms = {1,1,in};
    mm.push(inms);
    while(rand()%2){
      cout<< " POP ";
      mm.pop();
    }
    max_select ms;
    if(mm.top(ms))
      cout<<ms.v<<endl;
    else
      cout<<"EMPTY()"<<endl;
  } 
  return 0;
}
```

# Minimum_maintenance.old4.cpp

```c++
//template
#include<iostream>
#include<cstdlib>
using namespace std;
struct max_select{
  int p;
  int d;
  double v;
  bool operator > (const max_select & other) const {
    return v > other.v;
  }
  bool operator < (const max_select & other) const {
    return v < other.v;
  }
  bool operator == (const max_select & other) const {
    return v == other.v;
  }
};

template <class T>
class Minimum_maintenance {
  private:
    T * _stack[2]; // 0 store Descending sequence, 1 store other's
    int _iter[2];    // store iter
    int * _order;    // for push and pop
  public:
    Minimum_maintenance(){
      // CHANGE?
      _iter[0] = 0;
      _iter[1] = 0;
      _stack[0] = new T[1];
      _stack[1] = new T[1];
      _order = new int[1];
    }
    Minimum_maintenance(int s){
      _iter[0] = 0;
      _iter[1] = 0;
      _stack[0] = new T[s];
      _stack[1] = new T[s];
      _order = new int[s];
    }
    ~Minimum_maintenance(){
      delete [] _stack[0];
      delete [] _stack[1];
      delete [] _order;
    }
    void resize(int s){
      delete [] _stack[0];
      delete [] _stack[1];
      delete [] _order;
      _iter[0] = 0;
      _iter[1] = 0;
      _stack[0] = new T[s];
      _stack[1] = new T[s];
      _order = new int[s];
    }
    void push(const T & ms){
      int i;
      if(_iter[0] == 0 || _stack[0][_iter[0] - 1] > ms){
        i = 0;
      }else{
        i = 1;
      }
      _stack[i][_iter[i]] = ms;

      _order[_iter[0]+_iter[1]] = i;
      _iter[i] ++ ;
    }
    void pop(){
      if(_iter[0]+_iter[1]){
        _iter[_order[ _iter[0] + _iter[1] - 1 ]]--;
      }
    }
    bool top(T & ms){
      if(!(_iter[0]+_iter[1]))
        return false;
      int o = _order[ _iter[0] + _iter[1] - 1];
      ms = _stack[0][ _iter[0] - 1];
      return true;
    }
    bool empty(){
      return _iter[0] == 0;
    }
};
int main(){
  int i;
  Minimum_maintenance<max_select> mm;
  mm.resize(20);
  for( i = 0; i < 20 ; i ++){
    double in = rand()*1.0;
    cout<<in<<endl<<"\t";
    max_select inms = {1,1,in};
    mm.push(inms);
    while(rand()%2){
      cout<< " POP ";
      mm.pop();
    }
    max_select ms;
    if(mm.top(ms))//mm.empty()
      cout<<ms.v<<endl;
    else
      cout<<"EMPTY()"<<endl;
  } 
  return 0;
}
```

