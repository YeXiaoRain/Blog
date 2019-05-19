---
title: CF Round442 Div2 E(Euler tour tree + Segment tree)
date: 2017-10-24 23:02:29
tags: [segment tree]
category: [Codeforces]
---

# Danil and a Part-time Job

# 题目大意

给一个多叉树，根节点序号为1，树上每一个点是1或者0。

操作，对 一个树的节点以及这个节点的所有子节点进行 零 一 翻转(布尔非)。

询问，求 一个树的节点以及这个节点的所有子节点的 1的个数总和

## 输入

树上的连接情况也就是边，输入每个点的初始状态

接下来是输入query，为操作或者询问

# 数据范围

树的点的个数`<=200 000`

query数量`<=200 000`

上限 2秒 256MB

# 解答思路

官方给的是`Euler-tour-tree`+`Segment tree` 具体讲解见下面的参考，很清晰了。下面的链接中介绍了三种ETT，这里用得是第二种

思路是首先对树 进行`Euler-tour-tree`展开，这样操作后上面的操作和询问 都变成了 展开后的区间操作和询问了。

这样变成区间后就可以用segment tree 来做了，加个lazytag减少点时间，目测不加lazy过不了，因为每次对整个操作区间的话，每次改动就是2n

# 代码

[C++14/390ms/40 392KB](http://codeforces.com/contest/877/submission/31694632)

用了一下`C++14`的一些语法[虽然我记不清哪些在11就已经支持了]

### 实现

也是很久没有写过线段树 更不要说lazytag，上一次写应该是四五年前。

感受0. 既可以向下面这样用线段树的节点来记录 表示的l和r。也可完全不记录，这样通过固定的函数之间递归调用，多传两个参数也可以，目前用前一种方法写下来就是有点乱的感觉，如果每次传参，脑补代码会看上去更简洁。

感受1. lazytag我最开始写的是再调用处理函数，但是最后改成了只对下一层改动，因为lazytag能有tag都是说明到这层已经是和这层的左右范围完全对应，所以向下也是完全对应，所以下层也就不会再往下传，所以直接改当前层和下一层就能把lazytag处理了。

实现0. 这里线段树我的节点上有一个switched来表示是否切换，所以如果一个节点以下的开启的个数，不是直接返回on的值，而是判断一下switched,所以我后面获取on和off见注释`fix o`下面的。。。没有具体分析这样写是把代码变复杂还是简单还是差不多。因为如果直接表示每次要直接转换，lazytag下发也要再加一些判断。`_(:з」∠)_`

感受2. 总的来说我也调了半天，代码丑陋写了136行，看rank上排在前面的大佬 90行就写完了

```c++
#include <bits/stdc++.h>

#define NUM 200000+10
#define o_l (o<<1)
#define o_r (o_l+1)

using namespace std;

struct sgtnode{
  int l,r;
  int swiced;
  int on,off;
  sgtnode(){swiced=0;on=0;off=0;}
  sgtnode(int s,int n,int f):
    swiced(s),on(n),off(f){}
};

// --- input ---
int n;
vector<int> child[NUM];
// --- Euler tour tree ---
int ettIndex2ONorOFF[2*NUM];
int ett_l[NUM]={0};
int ett_r[NUM]={0};
// --- Segment tree ---
sgtnode sgmnttr[4*2*NUM];

void lazydown(int o){
  if(sgmnttr[o].swiced == 1){
    sgmnttr[o].swiced = 0;
    swap(sgmnttr[o].on,sgmnttr[o].off);
    sgmnttr[o_l].swiced ^=1;
    sgmnttr[o_r].swiced ^=1;
  }
}
// --- Segment tree switch ---
void segswi(int o,int l,int r){
  if(sgmnttr[o].l == l and sgmnttr[o].r == r){
    sgmnttr[o].swiced ^= 1;
    return ;
  }
  lazydown(o);
  int mid=(sgmnttr[o].l+sgmnttr[o].r)/2;
  if(l <= mid)
    segswi(o_l,l,min(r,mid));
  if(r > mid)
    segswi(o_r,max(l,mid+1),r);
  // fix o
  sgmnttr[o].on =
    (sgmnttr[o_l].swiced?sgmnttr[o_l].off:sgmnttr[o_l].on)+
    (sgmnttr[o_r].swiced?sgmnttr[o_r].off:sgmnttr[o_r].on);
  sgmnttr[o].off =
    (sgmnttr[o_l].swiced?sgmnttr[o_l].on:sgmnttr[o_l].off)+
    (sgmnttr[o_r].swiced?sgmnttr[o_r].on:sgmnttr[o_r].off);
}
// --- Segment tree query ---
int segqry(int o,int l,int r){
  if(sgmnttr[o].l == l and sgmnttr[o].r == r)
    return sgmnttr[o].swiced?sgmnttr[o].off:sgmnttr[o].on;
  lazydown(o);
  int mid=(sgmnttr[o].l+sgmnttr[o].r)/2;
  int ret=0;
  if(l <= mid)
    ret += segqry(o_l,l,min(r,mid));
  if(r > mid)
    ret += segqry(o_r,max(l,mid+1),r);
  return ret;
}

void build_segtree(int o,int l,int r){
  sgmnttr[o].l = l;
  sgmnttr[o].r = r;
  if(l == r){
    sgmnttr[o].off = 1^(sgmnttr[o].on = ettIndex2ONorOFF[l]);
    return ;
  }
  int mid =(l+r)/2;
  build_segtree(o_l,l,mid);
  build_segtree(o_r,mid+1,r);
  sgmnttr[o].on  = sgmnttr[o_l].on  + sgmnttr[o_r].on;
  sgmnttr[o].off = sgmnttr[o_l].off + sgmnttr[o_r].off;
}

void qry(int index){
  printf("%d\n",segqry(1,ett_l[index],ett_r[index])/2);
}

void swi(int index){
  segswi(1,ett_l[index],ett_r[index]);
}

void build_ett(int tree_index){
  static int ett_index = 0;
  ett_l[tree_index] = ett_index++;
  for(auto each_child : child[tree_index])
    build_ett(each_child);
  ett_r[tree_index] = ett_index++;
}

int main(){
  cin>>n;
  int i;
  for(i=2;i<=n;i++){
    int tmp;
    scanf("%d",&tmp);
    child[tmp].push_back(i);
  }
  build_ett(1);
  // for(i=1;i<=n;i++)
  //   cout<<ett_l[i]<<" "<<ett_r[i]<<endl;

  for(i=1;i<=n;i++){
    int tmp;
    scanf("%d",&tmp);
    ettIndex2ONorOFF[ett_l[i]]=tmp;
    ettIndex2ONorOFF[ett_r[i]]=tmp;
  }
  build_segtree(1,0,2*n-1);
  // cout<<"index\tswiced\tl\tr\ton\toff\n";
  // for(i=1;i<4*n;i++)
  //   cout<<i<<"\t"<<sgmnttr[i].swiced<<"\t"<<sgmnttr[i].l<<"\t"<<sgmnttr[i].r<<"\t"<<sgmnttr[i].on<<"\t"<<sgmnttr[i].off<<endl;

  int q;
  cin>>q;
  while(q--){
    char s[10];
    int tmp;
    scanf("%s %d",s,&tmp);
    if(s[0]=='g'){
      qry(tmp);
    }else{
      swi(tmp);
    }
  }
  return 0;
}
```

# 参考

[Problem](http://codeforces.com/contest/877/problem/E)

[Official editorial](http://codeforces.com/blog/entry/55362)

[Euler tour tree](http://codeforces.com/blog/entry/18369)

[Segment tree](https://en.wikipedia.org/wiki/Segment_tree)
