---
title: tarjan 强连通分量 缩点
date: 2018-06-24 03:45:30
tags: [强联通分量]
category: [algorithm]
---

> 关于 强连通分量 缩点 tarjan是什么 自行搜索，这里只是封了一个板子

[Codeforces Round #490 (Div. 3) E题](http://codeforces.com/contest/999/problem/E)

题目一眼可得tarjan 也不是一次两次了 封了板子，最开始还想做个模板类，但仔细一想，时间复杂度导致点个数不会超int，所以如果点序号大于int先离散化再做

[E题 AC CODE](http://codeforces.com/contest/999/submission/39589245)

板子如下

```c++
/* construct: vertexsize
 *    auto tarjan = new Tarjan(vertex_size)
 *
 * addpath // 1<=from_vertex,to_vertex<= vertex_size
 *    tarjan.addpath(from_vertex,to_vertex)
 *
 * prepare an result array,and work
 *    int res[vertex_size+1];
 *    tarjan.work(res);
 *
 * return:
 *    res[vertex_id]  ===== after_tarjan_vertex_group_id
 */
class Tarjan{
  int *low;// lowest node
  int *dfn;// deep first node
  int *stk;// stack
  bool *instk;
  bool *visited;

  vector<int> * p; // one-way road
  int stki;
  int id;
  int n;
  // strongly connected components强联通分量
  void scc(int v) {
    low[v] = dfn[v] = ++id;
    stk[stki++] = v;
    instk[v] = true;
    visited[v] = true;
    for(auto w:p[v]){
      if(!visited[w]){
        scc(w);
        low[v] = min(low[v],low[w]);  //v或v的子树能够追溯到的最早的栈中节点的次序编号
      } else if(instk[w]){ //v->w后向边
        low[v] = min(low[v],dfn[w]);
      }
    }
    int u;
    if(low[v] == dfn[v])  {
      do{
        u = stk[--stki];
        dfn[u] = v;  //缩点
        instk[u] = false;    //出栈解除标记
      }while(u != v);
    }
  }
public:
  Tarjan(int SZ){
    n = SZ;
    low =  new int[n+1];
    stk =  new int[n+1];
    dfn =  new int[n+1];
    instk = new bool[n+1];
    visited = new bool[n+1];
    p = new vector<int>[n+1];
    rep(i,0,n+1){
        visited[i] = false;
    }
    id = 0;
    stki = 0;
  }
  ~Tarjan(){
    delete [] low;
    delete [] stk;
    delete [] dfn;
    delete [] instk;
    delete [] visited;
    delete [] p;
  }
  void work(int *ret){
    rep(i,1,n+1){
      if(!visited[i]){
        scc(i);
      }
    }
    rep(i,1,n+1)
      ret[i]=dfn[i];
  }
  void addpath(int i,int j){
    p[i].pb(j);
  }
};
```

基本上 使用分3个步骤就好

1. 根据size初始化
2. 给它加单向边`.addpath(from,to)`
3. 准备一个结果数组a，调用`.work(a)`
4. 得到的结果数组`a[原来的点序号]=缩点后的点序号`

5. emmm 需要加两个宏使用 `#define rep(i,a,n) for (int i=a;i<n;i++)` 和 `#define pb push_back`

## 增强复用+简化

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<n;i++)
#define pb push_back

class Tarjan{
  vector<int> low;
  vector<int> dfn;
  stack<int> stk;
  vector<int> res;
  vector<vector<int> > p;
  int n;
  void scc(int v) {
    static int id = 0;
    low[v] = dfn[v] = ++id;
    stk.push(v);
    for(auto w:p[v]){
      if(!dfn[w]){ // 未访问过
        scc(w);
        low[v] = min(low[v],low[w]);
      } else if(!res[w]){ // 访问过但没有结果(在栈中)
        low[v] = min(low[v],dfn[w]);
      }
    }
    int u;
    if(low[v] == dfn[v])  {
      do{
        res[u = stk.top()] = v;
        stk.pop();
      }while(u != v);
    }
  }
public:
  Tarjan(int SZ):n(SZ){
    low = vector<int>(n+1);
    stk = {};
    vector<int>(n+1);
    dfn = vector<int>(n+1);
    res = vector<int> (n+1);
    p = vector<vector<int> >(n+1);
  }
  vector<int> calc(){
    rep(i,1,n+1){
      if(!res[i]){
        scc(i);
      }
    }
    return res;
  }
  void p2(int i,int j){
    p[i].pb(j);
  }
};

int main(){
  int n,m;
  // 点,有向边,
  cin>>n>>m;
  Tarjan tarjan(n);
  rep(i,0,m){
    int u,v;
    scanf("%d %d",&u,&v);
    tarjan.p2(u,v);
  }
  vector<int> num = tarjan.calc(); // scc 联通分量 标识
  rep(i,1,n+1){
    printf("%lld: %d\n",i,num[i]);
  }
  return 0;
}

/**
1->2->3->1
3->4->5

5 5
1 2
2 3
3 1
3 4
4 5
 */
```


### 简述操作

tarjan(u)

0. 深搜: 标记序号, 到达最小, u进栈
1. 子点v未访问(dfn[v] == 0), 递归tarjan(v), low[u] = min(low[u],low[v])
2. 子点v在栈中(result[v] == 0), low[u] = min(low[u],深搜序号[v])
3. 当low[u] == dfn[u]时, 逐个出栈直到遇到u, 这些出栈的都是属于u这个联通分量 result[i] = u



