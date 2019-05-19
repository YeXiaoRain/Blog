---
title: USACO 5.3 章节
date: 2019-05-18 01:37:14
tags: [Heuristic Search,IDDFS,离散化,scc,块状矩阵]
category: [USACO]
mathjax: true
---

相关讲解可在USACO上看原文，也可以搜索nocow找到翻译的！ (nocow上有些微翻译是有问题的，如果想看nocow翻译的建议也对着英文看)

以下记录以下 自己之前未掌握的一些要点,以及按自己的括号表述的形式来记录。

# USACO Section 5.3 启发式搜索

启发式搜索的主要思想是通过评价一个状态有"多好"来改进对于解的搜索.

`0<= 可行的估价函数 <= 实际代价`

1. 启发式剪枝: 若搜到最小值，已经搜索到的最优值为C，当前的代价为A(从起始状态到这里的实际代价)，启发的期望剩余代价为B（从当前点到目标的估价），如果`A+B>C`也就是期望总代价比已经搜索的还大，那么剪枝，注意到上面有提到：估价函数是小于等于实际代价，也就意味`实际代价>=A+B>C`,所以可以剪枝

2. Best-First Search最佳优先: 深搜 中，在子节点访问顺序部分做估价处理，调整搜索顺序，再结合上面的剪枝

3. `A*` 可以和第二条相对，看做广搜中加入了顺序估价。

> 关于估价函数
> 如果为0，可以看做毫无优化的默认算法。
> 如果为实际代价，那么就直接可以最快向目标前进。

# Milk Measuring - milk4

## 题意

从P个数中选 取任意个数，使得它们的整数倍数的和=Q

如P: 3,3,5,7

Q:16

`16=3*2+5*1`

目标，1选的数的个数尽量小，2在个数尽量小的时候，字典序最小

`1<=Q<=200000`

`1<=P<=100`

`1<=每个数<=10000`

输出选择的方案

## 通过不了的题解

emmmm 我为什么一看就是个sort(从大到小)+`dp[当前第几个数][和的值]= {最小选取的个数,最后选择的index,选择的个数,倒数第一次选择的index}`

空间`O(Q*P)`,时间`O(Q*P)` 能得到最小的个和方案,

dp时 优先个数(目标要求个数)，其次上一次的index(因为sort过 且目标要求字典序)，个数用来反向输出方案

```c++
#include <bits/stdc++.h>
#define rep(i,a,n) for (int i=a;i<n;i++)
#define per(i,a,n) for (int i=n-1;i>=a;i--)

using namespace std;

const string filename = "milk4";

void usefile(){
  freopen((filename+".in").c_str(),"r",stdin);
  freopen((filename+".out").c_str(),"w",stdout);
}

tuple<int,int,int,int>dp[110][20010]; // {usecnt+1,lastuseidx,lastusecnt,preidx};
int val[110];
int Q;
int P;

int main(){
  usefile();
  cin>>Q;
  cin>>P;
  rep(i,0,P){
    scanf("%d",val+i);
  }
  sort(val,val+P,greater<int>());
  rep(p,0,P){
    dp[p][0] = {1,-1,0,-1};
  }
  rep(p,0,P){
    if(p>0){
      rep(q,0,Q+1){
        dp[p][q]=dp[p-1][q];
      }
    }
    rep(q,0,Q){
      auto & item = dp[p][q];
      if(get<0>(item) > 0){
        if(q+val[p] > Q)break;
        auto & pre = dp[p][q+val[p]];
        tuple<int,int,int,int> now = {
          get<0>(item)+ (p !=get<1>(item)),
          p,
          (p!=get<1>(item))?1:get<2>(item)+1,
          (p!=get<1>(item))?get<1>(item):get<3>(item)
        };
        if(get<0>(pre) == 0 || get<0>(pre) >= get<0>(now)){
          pre = now;
        }
      }
    }
  }
  // rep(p,0,P){
  //   cout<<"P:"<<p<<endl;
  //   rep(q,0,Q+1){
  //     printf("[%d %d %d %d]",get<0>(dp[p][q]),get<1>(dp[p][q]),get<2>(dp[p][q]),get<3>(dp[p][q]));
  //   }
  //   cout<<endl;
  // }
  auto ans = dp[P-1][Q];
  printf("%d",get<0>(ans)-1);
  int qq = Q;
  while(1){
    printf(" %d",val[get<1>(ans)]);
    qq-= get<2>(ans) * val[get<1>(ans)];
    if(get<3>(ans) == -1){
      break;
    }
    ans = dp[get<3>(ans)][qq];
  }
  printf("\n");
  return 0;
}
```

然而不幸的是超空间限制了

`Execution error: Your program (`milk4') exited with signal #11 (segmentation violation [maybe caused by accessing memory out of bounds, array indexing out of bounds, using a bad pointer (failed open(), failed malloc), or going over the maximum specified memory limit]). The program ran for 0.000 CPU seconds before the signal. It used 31552 KB of memory. `

优化可以优化掉p，在实现记录的时候用指针的方式，没有尝试能不能改过

## 可通过的解

IDDFS 迭代加深搜索，使用场景，在低的层级找到解就是最优/目标解。

和广搜的区别是，广搜过程中会用内存记录，而迭代加深每次都是深搜，但是逐次增加深度。

可行性：每次加深深度，新的状态和上一层的状态是数量级差异，所以其实只和最后成功搜索到的层数的数量级相关。

综上，IDDFS有着接近广搜的性能，有着接近深搜的空间消耗。

实现pass如下

```c++
#include <bits/stdc++.h>
#define rep(i,a,n) for (int i=a;i<n;i++)
#define per(i,a,n) for (int i=n-1;i>=a;i--)

using namespace std;

const string filename = "milk4";

void usefile(){
  freopen((filename+".in").c_str(),"r",stdin);
  freopen((filename+".out").c_str(),"w",stdout);
}

int vis[20010];
int ans[110];
int val[20010];
int Q;
int P;
int dep;

bool check(){
  rep(i,1,Q+1){
    vis[i]=0;
  }
  rep(i,0,dep){
    rep(j,0,Q+1-ans[i]){
      if(vis[j]){
        vis[j+ans[i]]=true;
      }
    }
  }
  if(vis[Q]){
    return true;
  }
  return false;
}

bool dfs(int idx,int cnt){
  ans[cnt] = val[idx];
  if(cnt+1 == dep){
    return check();
  }
  rep(j,idx+1,P+2+cnt-dep){
    if(dfs(j,cnt+1)){
      return true;
    }
  }
  return false;
}

void output(){
  printf("%d",dep);
  rep(i,0,dep){
    printf(" %d",ans[i]);
  }
  printf("\n");
}

int main(){
  usefile();
  cin>>Q;
  cin>>P;
  rep(i,0,P){
    scanf("%d",val+i);
  }
  sort(val,val+P);
  vis[0]=1;
  for(dep=1;dep<=P;dep++){
    rep(i,0,P+1-dep){
      if(dfs(i,0)){
        output();
        return 0;
      }
    }
  }
  return 0;
}
```

# Window Area - window

## 题意

在电脑上窗口的操作,5种

 * 新建窗口(标识符，x1,y1,x2,y2)
 * 置顶t(标识符)
 * 置底b(标识符)
 * 删除d(标识符)
 * 输出窗体可见百分比s(I) ,询问数<=500

窗体个数上限`(2*26+10=62)`

坐标范围`[1->32767]`

## 题解

那么显然 横纵坐标只有`((2×62)^2)`个，离线+离散+没了？

```c++
#include <bits/stdc++.h>
#define rep(i,a,n) for (int i=a;i<n;i++)
#define per(i,a,n) for (int i=n-1;i>=a;i--)
typedef long long ll;

using namespace std;

const string filename = "window";

void usefile(){
  freopen((filename+".in").c_str(),"r",stdin);
  freopen((filename+".out").c_str(),"w",stdout);
}

list<int>Is[240][240]; // 大小猜的

vector<int>x;
vector<int>y;

vector<tuple<int,int> >q;

int itr = 0;
vector<tuple<int,int,int,int> >xys;

tuple<int,int,int,int> xyxy[123];

void rm(int ix,int iy,char I){
  for (list<int>::iterator it=Is[ix][iy].begin(); it!=Is[ix][iy].end(); ++it){
    if(*it == I){
      Is[ix][iy].erase(it);
      return ;
    }
  }
}

void top(int ix,int iy,char I){
  rm(ix,iy,I);
  Is[ix][iy].push_front(I);
}

void bot(int ix,int iy,char I){
  rm(ix,iy,I);
  Is[ix][iy].push_back(I);
}

int main(){
  usefile();
  char op;
  while(~scanf("%c",&op)){
    if(op!='w' && op!='t' && op!='b' && op!='d' && op!='s')continue;
    if(op == 'w'){
      char I;
      int x1,y1;
      int x2,y2;
      scanf("(%c,%d,%d,%d,%d)",&I,&x1,&y1,&x2,&y2);
      if(x1> x2){
        swap(x1,x2);
      }
      if(y1>y2){
        swap(y1,y2);
      }
      x.push_back(x1);
      x.push_back(x2);
      y.push_back(y1);
      y.push_back(y2);
      q.push_back({op,I});
      xys.push_back({x1,y1,x2,y2});
    }else{
      char I;
      scanf("(%c)",&I);
      q.push_back({op,I});
    }
  }
  sort(x.begin(),x.end());
  sort(y.begin(),y.end());
  for(auto item:q){
    int op = get<0>(item);
    int I = get<1>(item);
    if(op == 'w'){
      xyxy[I] = xys[itr++];
    }
    int x1idx=lower_bound(x.begin(),x.end(),get<0>(xyxy[I]))-x.begin();
    int y1idx=lower_bound(y.begin(),y.end(),get<1>(xyxy[I]))-y.begin();
    int x2idx=lower_bound(x.begin(),x.end(),get<2>(xyxy[I]))-x.begin();
    int y2idx=lower_bound(y.begin(),y.end(),get<3>(xyxy[I]))-y.begin();
    switch(op){
      case 'w':
        {
          rep(ix,x1idx,x2idx){
            rep(iy,y1idx,y2idx){
              Is[ix][iy].push_front(I);
            }
          }
          break;
        }
      case 't':
        {
          rep(ix,x1idx,x2idx){
            rep(iy,y1idx,y2idx){
              top(ix,iy,I);
            }
          }
          break;
        }
      case 'b':
        {
          rep(ix,x1idx,x2idx){
            rep(iy,y1idx,y2idx){
              bot(ix,iy,I);
            }
          }
          break;
        }
      case 'd':
        {
          rep(ix,x1idx,x2idx){
            rep(iy,y1idx,y2idx){
              rm(ix,iy,I);
            }
          }
          break;
        }
      case 's':
        {
          ll sshow = 0;
          rep(ix,x1idx,x2idx){
            rep(iy,y1idx,y2idx){
              sshow+= ((*Is[ix][iy].begin() == I)?(x[ix+1]-x[ix])*ll(y[iy+1]-y[iy]):0);
            }
          }
          ll scnt = (x[x2idx]-x[x1idx])*ll(y[y2idx]-y[y1idx]);
          printf("%.3lf\n",sshow*100/double(scnt));
          break;
        }
    }
  }
  return 0;
}
```

emmmmmm 在第11个点的时候 出现了唯一标识复用的情况，也就是说 先创建 再删除 再创建，所以期望的边数也就不只 `(26*2+10)*2`，我这里尝试的是开到`240*240`才能过

所以基本上是 离散化 `O(长乘宽(分化的区块个数)*62(每次操作代价)*(t+b+r操作个数)+长乘宽(分化区块个数)*1(操作代价)*(w+s操作个数))`

以上代码还可以优化的地方:

1. 通过预处理 真实值到离散值，让每个这样的计算只发生一次。

2. 再建立一个表来优化top,bot,rm到接近O1每次，额外的指针访问时间，缺点是1增加空间，2本身数据不大的情况，枚举查找的效率是不差的

然后有一些博文有 两个矩形之间处理的优化，也就是 不分成9块，而是分成最多5块，类似旋图，然后平时只记录相对的层数(z-index)，然后在查询的时候，才自值开始向上查找。

# Network of Schools - schlnet

## 题意

有向图,(N<=100)个节点

1. 求最少选取多少个点，通过这些点能够沿着有向边到达所有的点
2. 求最少加多少边，让真个图变成全连通

## 题解

emmmm一眼

1. 直接求强连通，然后缩点，然后按照出度排序，从0开始删，直到为最后只剩独立点，进行统计？
2. 把这些缩点后的 max(出度为0的点,入度为0的点)

强连通直接tarjan

```c++
#include <bits/stdc++.h>
#define rep(i,a,n) for (int i=a;i<n;i++)
#define per(i,a,n) for (int i=n-1;i>=a;i--)

using namespace std;

const string filename = "schlnet";

void usefile(){
  freopen((filename+".in").c_str(),"r",stdin);
  freopen((filename+".out").c_str(),"w",stdout);
}

int n;

vector<int>p2[110];

const int N=100;


int id = 0;
bool vis[N+10];
int low[N+10];
int dfn[N+10];
vector<int>stk;
bool instk[N+10];

int incnt[N+10];
int outcnt[N+10];

void scc(int idx){
  // cout<<"scc"<<idx<<endl;
  dfn[idx] = low[idx] = ++id;
  vis[idx] = true;
  stk.push_back(idx);
  instk[idx] = true;
  for(auto item:p2[idx]){
    if(!vis[item]){
      scc(item);
      low[idx]=min(low[idx],low[item]);
    }else if(instk[item]){
      low[idx]=min(low[idx],dfn[item]); // dfn->low
    }
  }
  if(low[idx] == dfn[idx]){
    // cout<<"zip:"<<idx<<endl;
    // for(auto item:stk){
    //   printf("\t\tstk[%d]\n",item);
    // }
    int u;
    do{
      u = *(stk.end()-1);
      // cout<<"\tu:"<<u<<endl;
      dfn[u] = idx;
      instk[u] = false;
      stk.pop_back();
    }while(u != idx);
  }
}

void tarjan(){
  rep(i,1,n+1){
    if(!vis[i]){
      scc(i);
    }
  }
  // rep(i,1,n+1){
  //   cout<<"dfn:"<<i<<" = "<<dfn[i]<<endl;
  // }
}

int main(){
  usefile();
  cin>>n;
  rep(i,1,n+1){
    while(1){
      int v;
      scanf("%d",&v);
      if(v == 0)break;
      p2[i].push_back(v);
    }
  }
  tarjan();
  rep(i,1,n+1){
    if(dfn[i]!=i){
      for(auto item:p2[i]){
        p2[dfn[i]].push_back(dfn[item]);
      }
    }else{
      for(auto &item:p2[i]){
        item = dfn[item];
      }
    }
  }
  rep(i,1,n+1){
    if(dfn[i] == i){
      sort(p2[i].begin(),p2[i].end());
      p2[i].erase(unique(p2[i].begin(),p2[i].end()),p2[i].end());
      for(auto item:p2[i]){
        if(item == i)continue;
        // printf("%d -> %d\n",i,item);
        incnt[item]++;
        outcnt[i]++;
      }
    }
  }
  int in0cnt=0,out0cnt=0;
  rep(i,1,n+1){
    if(dfn[i] == i){
      in0cnt+=incnt[i] == 0;
      out0cnt+=outcnt[i] == 0;
    }
  }
  printf("%d\n",in0cnt);
  // single check
  int pcnt = 0;
  rep(i,1,n+1){
    pcnt+=dfn[i]==i;
  }
  if(pcnt == 1){
    printf("0\n");
  }else{
    printf("%d\n",max(in0cnt,out0cnt));
  }
  return 0;
}
```

# Big Barn - bigbrn

## 题意

NxN(N<=1000)矩阵A点上值有0或1

1的个数<=10000

求最大的全0正方形(不能斜着)

输出边长即可

## 题解

这感觉二分答案？因为二分的话如果大的可行，那么小的必定可行

又必定正方形的左侧和上侧都有点（边界看做全是点）

假设存在一个最优解左侧没有相邻点，则可以向左平移直到有点，对上侧同理。

emm 这样想下去，暂时没想到一个时间复杂度内能完成的解法，再看又像是二维线段树,跟着2维线段树的思路联想到前缀和的类似的矩阵处理

假设当前测试的长度为len

那么用`B[i][j]`表示 `A[i->i+len-1][j]`为1的个数

`C[i][j]`表示`A[i->i+len-1][j->j+len-1]`为1的个数,即是`C[i][j->j+len-1]`

根据前缀和类似的算法，`A->B`可以在`O(N^2)`完成`B->C`也同理,综上`O(N^2*log(N))`

然而很不幸的是 usaco给的空间是真的有限，就算换成 new 也会在第11个点挂掉,所以bit压位,然而事后发现，可以不用存储C，直接判断C的值就好了，从空间`O(3N^2)`变为`O(2N^2)`就能过

```c++
#include <bits/stdc++.h>
#define rep(i,a,n) for (int i=a;i<n;i++)
#define per(i,a,n) for (int i=n-1;i>=a;i--)

using namespace std;

const string filename = "bigbrn";

void usefile(){
  freopen((filename+".in").c_str(),"r",stdin);
  freopen((filename+".out").c_str(),"w",stdout);
}

int n,t;

// bitset<8> A[1010][130];// [1010][1010]; // N*N
// bitset<8> B[1010][130];// [1010][1010]; // (N+1-len)*N
// //bitset<8> C[1010][130];// [1010][1010]; // (N+1-len)*(N+1-len)

// 如果注释掉下面两行用 上面bitset的A和B也能过
int A[1010][1010];
int B[1010][1010];

void setv(bitset<8> *arr,int idx,int v){
  arr[idx/8].set(idx%8,bool(v));
}

int getv(bitset<8> *arr,int idx){
  return arr[idx/8][idx%8];
}

void setv(int *arr,int idx,int v){
  arr[idx]=v;
}

int getv(int *arr,int idx){
  return arr[idx];
}

bool ok(int len){
  if(len == 0)return true;
  // A->B
  rep(j,0,n){
    int cnt = 0;
    rep(i,0,len){
      cnt+=getv(A[i],j);
    }
    setv(B[0],j,cnt);
    rep(i,1,n+1-len){
      cnt+=getv(A[i+len-1],j)-getv(A[i-1],j);
      setv(B[i],j,cnt);
    }
  }
  // B->C
  rep(i,0,n+1-len){
    int cnt= 0;
    rep(j,0,len)
      cnt+=getv(B[i],j);
    if(cnt == 0)return true;
    rep(j,1,n+1-len){
      cnt+=getv(B[i],j+len-1)-getv(B[i],j-1);
      if(cnt == 0)return true;
    }
  }
  return false;
}

bool all1(){
  rep(i,0,n){
    rep(j,0,n){
      if(A[i][j] == 0){
        return false;
      }
    }
  }
  return true;
}

int main(){
  usefile();
  cin>>n>>t;
  rep(i,0,t){
    int x,y;
    scanf("%d %d",&x,&y);
    setv(A[x-1],y-1,1);
  }

  int lenl=0,lenr=n+1;
  while(lenl+1<lenr){
    int mid=(lenl+lenr)/2;
    if(ok(mid)){
      lenl=mid;
    }else{
      lenr=mid;
    }
  }
  cout<<lenl<<endl;

  return 0;
}
```

# 总结

emmmmm所以这些题目和标题的启发式搜索的关系是?
