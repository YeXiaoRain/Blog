---
title: 后缀自动机器 SAM
date: 2020-04-18 10:37:14
tags: [SAM]
category: [algorithm]
mathjax: true
---

# 最终产物

输入一个原始字符串，产生一个自动机，能识别一个给的新字符串是否是原始字符串的后缀。

给一个初始State，每次接受一个字符，进行状态转移到新的State或失败

每个State有标记是否为后缀

# 详细内容建议直接看oi-wiki

本文是，理清一些东西，和一些举例

对于一个给定的原始字符串，它所产生的自动机

|描述|自己设计符号|
|---|---|
|自动机的各个状态|State|
|一个字符|char|
|字符串|String|
|原始字符串的一个位置|Pos / typedef Pos int|
|自动机状态之间的转移边(接受一个字符)| next(State st,char ch) -> State|
|状态的后缀链接|link(State st) -> State|
|字符串结尾位置|endposString(String s) -> Pos数组|
|状态结尾位置|endposState(State st) -> Pos数组|
|字符串对应的状态|str2State(String s)-> State|
|状态对应的字符串数组|state2St(State st)-> String数组|

## 性质和证明思路(不是详细证明)

给定一个字符串s，endposString(s)表示这个字符串在原始字符串中出现的结尾位置的数组

定义State:

如果两个不同的字符串s1和s2,它们的 endposString输出的数组 完全相同，则它们属于同一个State,否则它们属于不同的State

因此每个字符串对应一个State,一个State对应一个数组的字符串。（也可以把State 看作一些字符串的集合）

如果不同字符串能够结尾位置相同，那么其中一个是另一个的后缀，所以一个State中的所有字符串两两成后缀关系

因此State中最短的字符串只要在原串的任意位置出现，则State最长的也出现，所以 长度介于最短和最长之间的必定出现

所以一个State包含的是 长度递增1的,相互为后缀的一系列数组

两个State之间，如果有重复的结束位置，那么对应位置各自的两个字符串 也一定是后缀关系。注意到上面结论 一个State包含的是一个递增一的连续整数区间。所以两个State之间的关系是 max(其中一个区间) < min(另一个区间)

也有了其中一个State的所有字符串是另一个区间的字符串的后缀，所以结束位置的关系一定是包含，（长的字符串出现的位置短的一定出现，长的字符串结束位置 包含于 短的)

如果两个State 的位置是包含关系，且其中一个State1最短字符串长度 + 1 = 另一个State2最长字符串长度，那么

`link(State1) = State2`, 说明State1 更短,State2更长和State1相邻

满足 link(State1)=State2 的所有state1 对应的endposState 两两交集为空，它们的并集 为 endposState(State2)

注意State会表示原始字符串子串所有能达到的状态，link以树的形式连接了所有State,从结束位置数组的角度看，每一个link分支都表示把数组拆分，数组中n个元素，所以总状态O(n)

准确点是<= 2n-1, 初始状态空字符串,包含所有n个下标, 每次拆分最多多出两个新集合, 最多n-1次拆分,所以最多1+2(n-1)=2n-1个节点

## 构建

在完全完成以前一直不会标记终止状态

每个State记录三个信息

1. 所对应的字符串最长的长度
2. 增加一个char以后转移到的目标状态
3. 后缀关系link指向的相邻状态

具体构建过程看wiki 和下面代码及注释，这里讲一点自己的理解

首先这是一个“归纳”性质的构建过程，所以其实考虑的是 “对于字符串构建好的自动机，在该字符串右侧末尾增加一个字符所带来的变动”

以 abcbc为例

![](https://oi-wiki.org/string/images/SAM/SA_suffix_links.svg)

左是next,右侧是link, 蓝色空状态, 绿色终止条件

## link 维护理解

单独看link构成的树，考虑画一个完整的每个字符串一个节点的树和link做比较，你会发现link构成的树其实是把那些没有分支的节点的部分(存在单字符没有分叉但是单独的State)路径合并成一个节点了而已

所以从这个角度，考虑一个每个字符串一个节点的link树，新增一个字符 意味着增加了一串后缀的链到原来的树上，而接到原来的树上的位置可能是叶子/根/一个已经有分叉的节点，也可能是某个节点分叉出来。（一定不会完全重合，因为一个字符串一个节点，新增的全长字符串一定不在原始的link树中。 所以上面描述的情形再考虑缩成目标的state link树。

就会和wiki中描述的操作对应了理解。1.一定会增加一个新的节点。可能找不到和-1 state连接，也可能找到已有可用的“转移”，不在操作，也可能之前会合并成一个状态的点，现在因为多了分叉需要拆成两个,同时也能理解为什么是从last开始沿着link去找是否有 char的转移

例如考虑abcb => abcbc

原来链 c-bc-abc 是一个state

现在新插入链 c-bc-cbc-bcbc-abcbc

就会变成

1. (c-bc)新拆出的state, 下面代码中qClone
2. abc(修改老的c-bc-abc得到的state), 下面代码中q变化
3. (cbc-bcbc-abcbc新增的state), 下面代码中newState

## next维护理解

next 比link复杂一些，但是实际也是可以用上面的 link树来看

先考虑未进行合并的状态的影响,其实就是对所有last后缀 增加char建立边

考虑`abcb=>abcbc`

也就是要有边

```
""->"c"
"b"->"bc"
"cb"->"cbc"
"bcb"->"bcbc"
"abcb"->"abcbc"
```

左侧出现的, 全在last的link链上

重复处理，例如"b"->"bc"其实已经有了，所以比它更短的也全有了，所以就能理解为什么wiki上的操作是last的link链上找到首个有char的边, 相当于从长到短找找最长的有的

原来link树上路径可合并的点 缩成一个state

两个有next关系的state意味着，其中一个state的所有字符串增加字符char后 的到字符串是 另一个state的子集

比如,这里之前是 state("b").next["c"] = state("bc") == state("c","bc","abc")

但是 对于我们新增的state，不会有比它长的("abc" 不期望的

但是next不像link，对结束位置并不友好，其意义是 选其中一部分下一位置是char的，在目标state中增加这些位置

但观察长度关系 也是有友好性。虽然说是集合，但是目标state中的每一个字符串 只有唯一的“上一个”字符串（也就是去掉最后一个字符的字符串），其对应的也就是唯一的state。

所以不同的相同的state中是没有重复元素的数组

next的作用就是把原来的字符串 下一个是char的部分抽出来，push到目标state的数组中

而注意到state是长度递增1的 后缀偏序数组

那么减去最后一个字符依然是长度递增1的 后缀偏序数组

state : [xxxxxxxx]c, 长度`l->r`

那么它的next来源

state : [xxxxxxxx], 长度`l-1->len1-1`,`len1->len2-1`,....,`leni->r-1`

每组就是一个state

所以如果wiki中描述的状态转移`p->q` 刚好最大长度差1,也就是 原来的划分很完美，只需要新建>=len(q)+1的

也就是说 原来的`p->q` 转移的划分是否和 期望的划分点一致。如果不一致就拆分

## 使用场景

很显然上面甚至连标记结束状态都没说，而实际上标记结束状态无非是给每个state多个字段，在完全构建以后，走一遍 link

其实这个自动机构建了以后，不只是简单的后缀判断，还能做很多字符串的事情

1. 判断是否包含子串, 从root开始沿着next指针走
2. 不同子串个数, 相当于不同路径数, dfs, 一个节点有 len(i) - len(link(i))个子串, [luogu P3804](https://www.luogu.com.cn/problem/P3804)
3. 所有不同子串总长度, 同理, 在每个节点可以得到路径个数 和 对应长度 和 子串数量
4. 字典序第k大子串, 就是字典序第k大的路径, 也可以后缀数组做
5. 某个子串出现次数

...

见 wiki

## Code

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
#define rep(i,a,n) for (int i=a;i<n;i++)

struct State {
  State * link; // 后缀父状态 指向比它短的后缀状态
  unordered_map<int, State *> next; // 状态转移, 指向string尾部增加int后得到的State
  int maxLen; // maxlen in this state
  State(int _maxLen):
    link(NULL),maxLen(_maxLen){
      next = {};
    }
};

class SAM{
  State *root , *lastState;
public:
  SAM(){
    root = lastState = new State(0);
  }
  void extend(int w){ // ???? => ????w
    State *p = lastState;
    State *newState = new State(p->maxLen + 1);
    // find first p in lastState->link->link->link...->link
    //  satisfy p->next[w] exist
    //  let q = p->next[w]
    //  找到有 w 转移的, 或者增加w转移
    for(;p && !p->next[w];p=p->link) p->next[w] = newState;
    for(;;){ // 降低层级
      if(!p){ // 全部原来都没有w转移, 也就是 [...??w] 唯一存在
        newState -> link = root;
        break;
      }
      // state p + char w -> state q
      State *q = p->next[w]; // 说明 [p w] 至少两处存在
      if(p->maxLen+1 == q->maxLen){ // 单独状态
        newState->link = q; // newState 一定比 q 长, q是比它短的最长后缀
        break;
      }
      // clone q next & link
      State * qClone = new State(p->maxLen+1); // 相当于从State q中拆出不大于p->next[w]转移的部分
      qClone->next = q->next; // copy
      qClone->link = q->link;
      // change q & newState link
      for(;p && p->next[w] == q;p=p->link) p->next[w] = qClone; // 更新所有单独
      q->link = newState->link = qClone;
      break;
    }
    lastState = newState;
  }

  bool has(string s){
    State *p = root;
    for(auto ch:s){
      if(!p->next[ch])return false;
      p = p->next[ch];
    }
    return true;
  }
};

int main(){
  auto sam = SAM();
  string s = "aabab";
  for(auto ch: s){
    sam.extend(ch);
  }
  printf("%d\n",(int)sam.has("aba"));
  return 0;
}
```

# refs

https://oi-wiki.org/string/sam/

陈立杰 的 ppt
