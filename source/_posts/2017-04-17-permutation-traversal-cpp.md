---
title: 遍历管理
date: 2017-04-17 00:50:21
tags:
---

# permutation_traversal.cpp

```c++
//10 - 0.2s
#include<iostream>
using namespace std;

int pt_s;

void ptdemo(unsigned int pt_bits){
  if(pt_bits == (1<<pt_s) - 1)
    return ;
  unsigned int i;
  for(i = 0; i < pt_s ; ++i){
    if( pt_bits & (1<<i) )
      continue ; 
    //cout<<i<<endl;
    int debug = i;
    ptdemo(pt_bits | (1<<i));
  }
  return ;
}
int main(){
  pt_s = 10;
  int v = 0;
  ptdemo(v);
  return 0;
}
```

# permutation_traversal.old1.cpp

```c++
//10 - 11.588 
#include<iostream>
#include<vector>
#include<stack>
using namespace std;

class Permutation_traversal{
  protected:
    vector<int>left_index; // to boost vector?
    stack<pair<vector<int>::iterator,int>>visitstack; // to boost list?
    vector<int>::iterator iter;
    Permutation_traversal(const vector<int>&li,const stack<pair<vector<int>::iterator,int>>&vs)
    :left_index(li),visitstack(vs){
      iter = left_index.begin();
    }
  public:
    Permutation_traversal(int s){
      for(int i=0;i<s;i++){
        left_index.push_back(i);
      }
      iter = left_index.begin();
    }
    
    bool const empty(){
      return left_index.empty();
    }
    void next(){
      if(iter == left_index.end())
        return ;
      ++iter;
    }

    bool const valid(){
      return iter != left_index.end();
    }

    int getnum(){
      return visitstack.size();
    }

    int const getvalue(){
      return iter != left_index.end() ? *iter : -1;
    }
    void push(){
      if(iter == left_index.end())
        return ;
      visitstack.push(make_pair(iter,*iter));
      left_index.erase(iter);
    }
    void pop(){
      if(visitstack.empty())
        return ;
      pair<vector<int>::iterator,int> p = visitstack.top();
      left_index.insert(p.first,p.second);
      visitstack.pop();
    }

    Permutation_traversal * isolate(){// careful about memory overflow
      return new Permutation_traversal(left_index,visitstack);
    }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    //for(int i=0,limiti=pt.getnum();i<limiti;i++)cout<<" ";
    //cout<<pt.getvalue()<<endl;
    int debug = pt.getvalue();
    pt.push();
    Permutation_traversal * child_pt = pt.isolate();
    ptdemo(*child_pt);
    delete child_pt;
    pt.pop();
  }
  return ;
}
int main(){
  Permutation_traversal pt(10);
  ptdemo(pt);
  return 0;
}
```

# permutation_traversal.old1.min.cpp

```c++
// ,min.cpp use less check
#include<iostream>
#include<vector>
#include<stack>
using namespace std;

class Permutation_traversal{
  protected:
    vector<int>left_index; // to boost vector?
    stack<pair<vector<int>::iterator,int>>visitstack; // to boost list?
    vector<int>::iterator iter;
    Permutation_traversal(const vector<int>&li,const stack<pair<vector<int>::iterator,int>>&vs)
    :left_index(li),visitstack(vs){
      iter = left_index.begin();
    }
  public:
    Permutation_traversal(int s){
      for(int i=0;i<s;i++){
        left_index.push_back(i);
      }
      iter = left_index.begin();
    }
    
    bool const empty(){
      return left_index.empty();
    }
    void next(){
      ++iter;
    }

    bool const valid(){
      return iter != left_index.end();
    }

    int const getvalue(){
      return *iter;
    }
    void push(){
      visitstack.push(make_pair(iter,*iter));
      left_index.erase(iter);
    }
    void pop(){
      pair<vector<int>::iterator,int> p = visitstack.top();
      left_index.insert(p.first,p.second);
      visitstack.pop();
    }

    Permutation_traversal * isolate(){// careful about memory overflow
      return new Permutation_traversal(left_index,visitstack);
    }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    cout<<pt.getvalue()<<endl;
    pt.push();
    Permutation_traversal * child_pt = pt.isolate();
    ptdemo(*child_pt);
    delete child_pt;
    pt.pop();
  }
  return ;
}
int main(){
  Permutation_traversal pt(5);
  ptdemo(pt);
  return 0;
}

```

# permutation_traversal.old2.cpp

```c++
//10 4.469s
#include<iostream>
#include<vector>
using namespace std;

class Permutation_traversal{
  protected:
    vector<int>left_index; // to boost vector?
    vector<int>::iterator iter;
    Permutation_traversal(const vector<int>&li)
    :left_index(li){
      iter = left_index.begin();
    }
  public:
    Permutation_traversal(int s){
      for(int i=0;i<s;i++){
        left_index.push_back(i);
      }
      iter = left_index.begin();
    }
    
    bool const empty(){
      return left_index.empty();
    }
    void next(){
      if(iter == left_index.end())
        return ;
      ++iter;
    }

    bool const valid(){
      return iter != left_index.end();
    }


    int const getvalue(){
      return iter != left_index.end() ? *iter : -1;
    }

    Permutation_traversal * isolate(){// careful about memory overflow
      if(iter == left_index.end())
        return NULL;
      vector<int>::iterator tmp_iter = iter;
      int tmp_val = *iter;
      left_index.erase(iter);
      Permutation_traversal * newpt = new Permutation_traversal(left_index);
      left_index.insert(tmp_iter,tmp_val);
      return newpt;
    }
    // debug [TODO]remove code below
    int getnum(){
      return 5-left_index.size();
    }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    //for(int i=0,limiti=pt.getnum();i<limiti;i++)cout<<" ";
    //cout<<pt.getvalue()<<endl;
    int debug = pt.getvalue();
    Permutation_traversal * child_pt = pt.isolate();
    ptdemo(*child_pt);
    delete child_pt;
  }
  return ;
}
int main(){
  Permutation_traversal pt(10);
  ptdemo(pt);
  return 0;
}

```

# permutation_traversal.old2.min.cpp

```c++
#include<iostream>
#include<vector>
#include<stack>
using namespace std;

class Permutation_traversal{
  protected:
    vector<int>left_index; // to boost vector?
    vector<int>::iterator iter;
    Permutation_traversal(const vector<int>&li)
    :left_index(li){
      iter = left_index.begin();
    }
  public:
    Permutation_traversal(int s){
      for(int i=0;i<s;i++){
        left_index.push_back(i);
      }
      iter = left_index.begin();
    }
    
    bool const empty(){
      return left_index.empty();
    }
    void next(){
      ++iter;
    }

    bool const valid(){
      return iter != left_index.end();
    }


    int const getvalue(){
      return *iter;
    }

    Permutation_traversal * isolate(){// careful about memory overflow
      vector<int>::iterator tmp_iter = iter;
      int tmp_val = *iter;
      left_index.erase(iter);
      Permutation_traversal * newpt = new Permutation_traversal(left_index);
      left_index.insert(tmp_iter,tmp_val);
      return newpt;
    }
    // debug [TODO]remove code below
    int getnum(){
      return 5-left_index.size();
    }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    for(int i=0,limiti=pt.getnum();i<limiti;i++)cout<<" ";
    cout<<pt.getvalue()<<endl;
    Permutation_traversal * child_pt = pt.isolate();
    ptdemo(*child_pt);
    delete child_pt;
  }
  return ;
}
int main(){
  Permutation_traversal pt(5);
  ptdemo(pt);
  return 0;
}

```

# permutation_traversal.old3.cpp

```c++
//10 - 0.927s
#include<iostream>
using namespace std;

class Permutation_traversal{
  protected:
    int * left_index; // to boost vector?
    int size;
    int iter;
    Permutation_traversal(){
    }
  public:
    Permutation_traversal(int s)
    :size(s),iter(0){
      left_index = new int[s];
      for(int i=0;i<s;i++){
        left_index[i]=i;
      }
    }
    ~Permutation_traversal(){
      delete [] left_index;
    }
    bool const empty(){
      return size == 0;
    }
    void next(){
      if(iter == size)
        return ;
      ++iter;
    }

    bool const valid(){
      return iter != size;
    }

    int const getvalue(){
      return iter != size ? left_index[iter] : -1;
    }

    Permutation_traversal * isolate(){// careful about memory overflow
      if(iter == size)
        return NULL;
      Permutation_traversal * newpt = new Permutation_traversal();
      newpt->left_index = new int[size-1];
      newpt->size = 0;
      newpt->iter = 0;
      for(int it = 0 ; it < size ; ++it){
        if(it == iter)
          continue;
        newpt->left_index[newpt->size++] = left_index[it];
      }
      return newpt;
    }
    // debug [TODO]remove code below
    int getnum(){
      return 5-size;
    }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    //for(int i=0,limiti=pt.getnum();i<limiti;i++)cout<<" ";
    //cout<<pt.getvalue()<<endl;
    int debug = pt.getvalue();
    Permutation_traversal * child_pt = pt.isolate();
    ptdemo(*child_pt);
    delete child_pt;
  }
  return ;
}
int main(){
  Permutation_traversal pt(10);
  ptdemo(pt);
  return 0;
}

```

# permutation_traversal.old3.min.cpp

```c++
#include<iostream>
#include<vector>
#include<stack>
using namespace std;

class Permutation_traversal{
  protected:
    int * left_index; // to boost vector?
    int size;
    int iter;
    Permutation_traversal(){
    }
  public:
    Permutation_traversal(int s)
    :size(s),iter(0){
      left_index = new int[s];
      for(int i=0;i<s;i++){
        left_index[i]=i;
      }
    }
    ~Permutation_traversal(){
      delete [] left_index;
    }
    bool const empty(){
      return size == 0;
    }
    void next(){
      ++iter;
    }

    bool const valid(){
      return iter != size;
    }

    int const getvalue(){
      return left_index[iter];
    }

    Permutation_traversal * isolate(){// careful about memory overflow
      Permutation_traversal * newpt = new Permutation_traversal();
      newpt->left_index = new int[size-1];
      newpt->size = 0;
      newpt->iter = 0;
      for(int it = 0 ; it < size ; ++it){
        if(it == iter)
          continue;
        newpt->left_index[newpt->size++] = left_index[it];
      }
      return newpt;
    }
    // debug [TODO]remove code below
    int getnum(){
      return 5-size;
    }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    for(int i=0,limiti=pt.getnum();i<limiti;i++)cout<<" ";
    cout<<pt.getvalue()<<endl;
    Permutation_traversal * child_pt = pt.isolate();
    ptdemo(*child_pt);
    delete child_pt;
  }
  return ;
}
int main(){
  Permutation_traversal pt(5);
  ptdemo(pt);
  return 0;
}

```
# permutation_traversal.old4.cpp

```c++
//10 - 0.581s
#include<iostream>
using namespace std;

class Permutation_traversal{
  private:
  class Child_Permutation_traversal{
    public:
      int * left_index; // to boost vector?
      int size;
      int iter;
      Child_Permutation_traversal(int s)
        :size(s),iter(0){
          left_index = new int[s];
        }
      ~Child_Permutation_traversal(){
        delete [] left_index;
      }
  };

  Child_Permutation_traversal ** cpt;
  int size;
  int depth;
  public:
  Permutation_traversal(int s)
  :size(s){
    cpt = new Child_Permutation_traversal * [s + 1];
    int i;
    for(i = 0; i <= s; i++){
      cpt[i] = new Child_Permutation_traversal(s-i);
    }
    for(i = 0; i < s; i++){
      cpt[0]->left_index[i]=i;
    }
    depth = 0;
  }
  ~Permutation_traversal(){
    for(int i=0;i<=size;i++){
      delete cpt[i];
    }
    delete [] cpt;
  }
  bool const empty(){
    return cpt[depth]->size == 0;
  }
  void next(){
    if(cpt[depth]->iter == cpt[depth]->size)
      return ;
    ++(cpt[depth]->iter);
  }
  
  bool const valid(){
    return cpt[depth]->iter != cpt[depth]->size;
  }
  
  int const getvalue(){
    return cpt[depth]->iter != cpt[depth]->size ? cpt[depth]->left_index[cpt[depth]->iter] : -1;
  }

  void select(){
    if(cpt[depth]->iter == cpt[depth]->size)
      return ;
    int newdepth = depth + 1;
    cpt[newdepth]->size = 0;
    cpt[newdepth]->iter = 0;
    for(int it = 0,itlimit=cpt[depth]->size ; it < itlimit ; ++it){
      if(it == cpt[depth]->iter)
        continue;
      cpt[newdepth]->left_index[cpt[newdepth]->size++] = cpt[depth]->left_index[it];
    }
    depth = newdepth;
  }

  void unselect(){
    if(depth > 0)
      --depth;
  }

  int getnum(){
    return 5-cpt[depth]->size;
  }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    //for(int i=0,limiti=pt.getnum();i<limiti;i++)cout<<" ";
    //cout<<pt.getvalue()<<endl;
    int debug = pt.getvalue();
    pt.select();
    ptdemo(pt);
    pt.unselect();
  }
  return ;
}
int main(){
  Permutation_traversal pt(10);
  ptdemo(pt);
  return 0;
}

```

# permutation_traversal.old4.min.cpp

```c++
//10 - 0.472s
#include<iostream>
using namespace std;

class Permutation_traversal{
  private:
  class Child_Permutation_traversal{
    public:
      int * left_index; // to boost vector?
      int size;
      int iter;
      Child_Permutation_traversal(int s)
        :size(s),iter(0){
          left_index = new int[s];
        }
      ~Child_Permutation_traversal(){
        delete [] left_index;
      }
  };

  Child_Permutation_traversal ** cpt;
  int size;
  int depth;
  public:
  Permutation_traversal(int s)
  :size(s){
    cpt = new Child_Permutation_traversal * [s + 1];
    int i;
    for(i = 0; i <= s; i++){
      cpt[i] = new Child_Permutation_traversal(s-i);
    }
    for(i = 0; i < s; i++){
      cpt[0]->left_index[i]=i;
    }
    depth = 0;
  }
  ~Permutation_traversal(){
    for(int i=0;i<=size;i++){
      delete cpt[i];
    }
    delete [] cpt;
  }
  bool const empty(){
    return cpt[depth]->size == 0;
  }
  void next(){
    ++(cpt[depth]->iter);
  }
  
  bool const valid(){
    return cpt[depth]->iter != cpt[depth]->size;
  }
  
  int const getvalue(){
    return cpt[depth]->left_index[cpt[depth]->iter];
  }

  void select(){
    int newdepth = depth + 1;
    cpt[newdepth]->size = 0;
    cpt[newdepth]->iter = 0;
    for(int it = 0,itlimit=cpt[depth]->size ; it < itlimit ; ++it){
      if(it == cpt[depth]->iter)
        continue;
      cpt[newdepth]->left_index[cpt[newdepth]->size++] = cpt[depth]->left_index[it];
    }
    depth = newdepth;
  }

  void unselect(){
      --depth;
  }

  int getnum(){
    return 5-cpt[depth]->size;
  }
};

void ptdemo(Permutation_traversal & pt){
  if(pt.empty())
    return ;
  for(;pt.valid();pt.next()){
    //for(int i=0,limiti=pt.getnum();i<limiti;i++)cout<<" ";
    //cout<<pt.getvalue()<<endl;
    int debug = pt.getvalue();
    pt.select();
    ptdemo(pt);
    pt.unselect();
  }
  return ;
}
int main(){
  Permutation_traversal pt(10);
  ptdemo(pt);
  return 0;
}

```
