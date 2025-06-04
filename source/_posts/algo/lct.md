---
title: lct link-cut-tree 动态树 实链剖分
date: 2025-06-04
tags: [lct]
category: [algorithm]
---

# LCT

前置知识: 树链剖分（轻重儿子，轻重链，批量维护）, Splay tree(伸展树, 二叉搜索，简单调整，势能评价)

Link/Cut Tree 是一种数据结构，我们用它来解决 动态树问题

维护一棵树，支持如下操作：

- 修改两点间路径权值。
- 查询两点间路径权值和。
- 修改某点子树权值。
- 查询某点子树权值和。

这是一道树剖模版题。

但是再加一个操作：

- 断开并连接一些边，保证仍是一棵树。

要求在线求出上面的答案。

这就成了动态树问题，可以使用 LCT 求解。

https://github.com/PotatoHashing/kactl/blob/LCT/content/graph/LCT.h

<!--more-->

## 实现

维护一个 森林，支持删除某条边，加入某条边，并保证加边，删边之后仍是森林。我们要维护这个森林的一些信息。

一般的操作有两点连通性，两点路径权值和，连接两点和切断某条边、修改信息等。

回顾树链剖分:
- 对整棵树按子树大小进行剖分，并重新标号。
- 我们发现重新标号之后，在树上形成了一些以链为单位的连续区间，并且可以用线段树进行区间操作。
- 适合树的形状是静态的

实链剖分(上面是选择重，而断开合并操作以后 重是不稳定的)
- 对于一个点连向它所有儿子的边，我们自己选择一条边进行剖分，我们称被选择的边为`实边`，其他边则为`虚边`。对于实边，我们称它所连接的儿子为实儿子。对于一条由实边组成的链，我们同样称之为实链。请记住我们选择实链剖分的最重要的原因：它是我们选择的，灵活且可变。正是它的这种灵活可变性，我们采用 Splay Tree 来维护这些实链。

我们可以简单的把 LCT 理解成用一些 Splay 来维护动态的树链剖分，以期实现动态树上的区间操作。对于每条实链，我们建一个 Splay 来维护整个链区间的信息。

### 辅助树 AuxTree

我们先来看一看辅助树的一些性质，再通过一张图实际了解一下辅助树的具体结构。

在本文里，你可以认为一些 Splay 构成了一个辅助树，每棵辅助树维护的是一棵树，一些辅助树构成了 LCT，其维护的是整个森林。

辅助树由多棵 Splay 组成，每棵 Splay 维护原树中的一条路径，且中序遍历这棵 Splay 得到的点序列，从前到后对应原树「从上到下」的一条路径。

原树每个节点与辅助树的 Splay 节点一一对应。

辅助树的各棵 Splay 之间并不是独立的。每棵 Splay 的根节点的父亲节点本应是空，但在 LCT 中每棵 Splay 的根节点的父亲节点指向原树中 这条链 的父亲节点（即链最顶端的点的父亲节点）。这类父亲链接与通常 Splay 的父亲链接区别在于儿子认父亲，而父亲不认儿子，对应原树的一条 虚边。因此，每个连通块恰好有一个点的父亲节点为空。

由于辅助树的以上性质，我们维护任何操作都不需要维护原树，辅助树可以在任何情况下拿出一个唯一的原树，我们只需要维护辅助树即可。

现在我们有一棵原树，如图所示。（加粗边是实边，虚线边是虚边。）

![](https://oi-wiki.org/ds/images/lct-atree-1.svg)

由刚刚的定义，辅助树的结构如图所示。

![](https://oi-wiki.org/ds/images/lct-atree-2.svg)


考虑原树和辅助树的结构关系
- 原树中的实链 : 在辅助树中节点都在一棵 Splay 中。
- 原树中的虚链 : 在辅助树中，子节点所在 Splay 的 Father 指向父节点，但是父节点的两个儿子都不指向子节点。
- 注意：
  - 原树的根不等于辅助树的根。
  - 原树的 Father 指向不等于辅助树的 Father 指向。
- 辅助树是可以在满足辅助树、Splay 的性质下任意换根的。
- 虚实链变换可以轻松在辅助树上完成，这也就是实现了动态维护树链剖分。

例如上面的原树C指向A，而辅助树种 C,E在一个splay中，是这个splay的根E 指向了节点A

接下来要用到的变量声明,都是辅助树上splay的
- ch[N][2] 左右儿子
- f[N] 父亲指向（这个在一个splay中是splay中的父节点，而跨过splay是原树中的父节点指向，但是源不一定是原树中的子节点, f[splay的根(原树子节点)] = 原树父节点）, 另一方面 因为辅助树的每个splay对应原树从上到下的链，所以源节点是splay中最小的值
- siz[N] 辅助树上子树大小
- tag[N] 翻转标记, 是辅助splay MakeRoot翻转的lazy tag, tag遵循: 本地已经完成(左右儿子已经完成, 直接可以读数据, 没有向下pushDown)
- laz[N] 权值标记
- sum[N] 路径权值和
- val[N] 点权
- Other_Vars

函数声明

一般数据结构函数，这个就是线段树各种树中常见的
- PushUp(x), 父节点收集子节点信息 的计算和操作
- PushDown(x)，父节点把lazy部分向子节点分发的操作

Splay 树的函数, 下面是 Splay 树中用到的函数，具体可以查阅 Splay 树。

- Get(x) 获取 x 是父亲的哪个儿子。
- Splay(x) 通过和 Rotate 操作联动实现把 x 旋转到 当前 Splay 的根。
- Rotate(x) 将 x 向上旋转一层的操作。

新操作
- Access(x) 把从x到根的所有点放在一条实链里，使根到 x 成为一条实路径，并且在同一棵 Splay 里。只有此操作是必须实现的，其他操作视题目而实现。
- IsRoot(x) 判断 x 是否是所在树的根。
- Update(x) 在 Access 操作之后，递归地从上到下 PushDown 更新信息。
- MakeRoot(x) 使 x点成为其所在原树的根。
- Link(x, y) 在 x, y 两点间连一条边。
- Cut(x, y) 把 x, y 两点间边删掉。
- Find(x) 找到 x 所在树的根节点编号。
- Fix(x, v) 修改 x 的点权为 v。
- Split(x, y) 提取出 x, y 间的路径，方便做区间操作。

宏定义

```c++
#define ls ch[p][0]
#define rs ch[p][1]
```


```cpp
void PushUp(int p) {
  // maintain other variables
  siz[p] = siz[ch[p][0]] + siz[ch[p][1]] + 1;
}

void PushDown(int p) {
  if (tag[p] != std_tag) {
    // pushdown the tag
    tag[p] = std_tag;
  }
}
```

`Splay && Rotate`

```cpp
#define Get(x) (ch[f[x]][1] == x)

void Rotate(int x) {
  int y = f[x];
  int z = f[y];
  int k = Get(x);
  if (!isRoot(y)) ch[z][Get(y)] = x;
  // 上面这句一定要写在前面，普通的 Splay 是不用的，因为 isRoot  (后面会讲)
  int &xc = ch[x][!k]; // x child
  ch[y][k] = xc;
  f[xc] = y;
  xc = y;
  f[y] = x;
  f[x] = z;
  PushUp(y);
  PushUp(x);
}

void Splay(int x) {
  Update(x); // 马上就能看到啦。在 Splay 之前要把旋转会经过的路径上的点都 PushDown
  for (int fa; fa = f[x], !isRoot(x); Rotate(x)) {
    if (!isRoot(fa)) Rotate(Get(fa) == Get(x) ? fa : x);
  }
}
```

`isRoot`

```cpp
// 在前面我们已经说过，LCT 具有 如果一个儿子不是实儿子，他的父亲找不到它的性质
// 所以当一个点既不是它父亲的左儿子，又不是它父亲的右儿子，它就是当前 Splay 的根
#define isRoot(x) (ch[f[x]][0] != x && ch[f[x]][1] != x)
```

`Access(u)`

```cpp
// Access(x) 把从根到 x 的所有点放在一条实链里，使根到 x 成为一条实路径，并且在同一棵 Splay 里。只有此操作是必须实现的，其他操作视题目而实现。
// Access 是 LCT 的核心操作，试想我们想求解一条路径，而这条路径恰好就是我们当前的一棵 Splay，
// 直接调用其信息即可。先来看一下代码，再结合图来看看过程
// ?这里有一点疑问的是，首个x向下的保持原来的可以吗? 也就是初始化 p = ch[x][1]; 因为后面MakeRoot依赖了这一点，需要恰好x到根是实链，所以这里p还是初始化空节点
int Access(int x) {
  int p;
  for (p = 0; x; p = x, x = f[x]) {// p = 0 表示空节点
    Splay(x);
    ch[x][1] = p; // 注意到splay对应原树的一个从上到下的实链，这里的操作就是，只要x以及以上的作为实链，x往下是 上一轮的实链的结果（上一轮的splay的根）
    PushUp(x);
  }
  return p;
}
```

原树:

![](https://oi-wiki.org/ds/images/lct-access-1.svg)

辅助树:

![](https://oi-wiki.org/ds/images/lct-access-2.svg)

oi wiki上有逐步更详细的例子的步骤解释


这里提供的 Access 还有一个返回值。这个返回值相当于最后一次虚实链变换时虚边父亲节点的编号。该值有两个含义：

连续两次 Access 操作时，第二次 Access 操作的返回值等于这两个节点的 LCA.
表示 x 到根的链所在的 Splay 树的根。这个节点一定已经被旋转到了根节点，且父亲一定为空。

```cpp
// 从上到下一层一层 pushDown 即可
void Update(int p) {
  if (!isRoot(p)) Update(f[p]); // 只在splay内，递归是为了从上到下的pushDown
  pushDown(p);
}
```

`MakeRoot(u)`

MakeRoot() 的重要性丝毫不亚于 Access()。我们在需要维护路径信息的时候，一定会出现路径深度无法严格递增的情况，根据 AuxTree 的性质，这种路径是不能出现在一棵 Splay 中的。

这时候我们需要用到 MakeRoot()。

MakeRoot() 的作用是使指定的点成为原树的根，考虑如何实现这种操作。

设 Access(x) 的返回值为 y，则此时 x 到当前根的路径恰好构成一个 Splay，且该 Splay 的根为 y.

考虑将树用有向图表示出来，给每条边定一个方向，表示从儿子到父亲的方向。容易发现换根相当于将 x 到根的路径的所有边反向（请仔细思考）。

因此将 x 到当前根的路径翻转即可。

由于 y 是 x 到当前根的路径所代表的 Splay 的根，因此将以 y 为根的 Splay 树进行区间翻转即可。

```cpp
void MakeRoot(int u) {// u变为u所在原树的根
  v = Access(u);
  swap(ch[v][0], ch[v][1]);
  tag[v] ^= 1; // 用lazy
}
```

`Link(u,v)`

Link 两个点其实很简单，先 MakeRoot(u)，然后把 u 的父亲指向 v 即可。显然，这个操作肯定不能发生在同一棵树内，所以记得先判一下。

```cpp
void Link(int u, int v) { // 原树中u,v相连
  // 确保在原树中，u,v是不同树
  MakeRoot(u);
  Splay(u);
  f[u] = p;
}
```

`Find(u)`

- Find() 查找的是 u 所在的 原树 的根，请不要把原树根和辅助树根弄混。在 Access(u) 后，再 Splay(u)。这样根就是树里深度最小的那个，一直往左儿子走，沿途 PushDown 即可。
- 一直走到没有 左儿子，非常简单。
- 注意，每次查询之后需要把查询到的答案对应的结点 Splay 上去以保证复杂度。

```cpp
int Find(int u) {
  Access(u);
  Splay(u);
  pushDown(u);
  while (ch[u][0]) pushDown(u = ch[u][0]);
  Splay(u);
  return u;
}
```

`Split(x,y)` 让原树上x到y的路径恰好成为一条实链。
- Split 操作意义很简单，就是拿出一棵 Splay，维护的是 x 到 y 的路径。
- 先 MakeRoot(x)，然后 Access(y)。如果要 y 做根，再 Splay(y)。
- 另外 Split 这三个操作可以直接把需要的路径拿出到 y 的子树上，可以进行其他操作。

```cpp
void Split(int u, int v) { // u,v在同一个原树
  MakeRoot(u);
  Access(v);
  // splay(v); // 如果需要v做根
}
```

`Cut(x,y)`
- x,y 相邻
- Cut 有两种情况，保证合法和不一定保证合法。
- 如果保证合法，直接 Split(x, y)，这时候 y 是根，x 一定是它的儿子，双向断开即可。就像这样：

```cpp
void Cut(int x, int y) {
  MakeRoot(x);
  Access(y);
  Splay(y);
  ch[y][0] = f[x] = 0;
}
```

- 如果不确定是否x,y相邻(有直接边)

```cpp
bool Cut(int x, int y) { // 这样吗?
	rx = Access(x);
	ry = Access(y);
	if (ch[rx][0] != ry || ch[ry][1]) return false;
  ch[rx][0]=fa[ry]=fa[fa[ry]]=0;
  pushUp(rx);
  return true;
}
```


## 相关资料

https://oi-wiki.org/ds/lct/

类似？ abc351 的 static top tree 也是建立了一个辅助树来管理形态树上dp（核心是对dp拆解成多个步骤可以和分块有关，从而把树的“合并”动作与dp计算对应）


luogu 3690 动态树LCT https://www.luogu.com.cn/problem/P3690

```cpp
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<(ll)n;i++)
ll read() { ll r;scanf("%lld", &r);return r; }
template <typename T, typename S> class LCT {
  struct node { // 这里用0 表示空节点，所有存在的节点以1-index
    int pa; // 父节点(splay 内是splay内关系, 跨splay 是源点所在splay 指向 原树父节点)
    int ch[2]; // splay 的子节点
    bool flip; // lazy 子树翻转标记, 主要用在 makeRoot
    T v; // 节点单点值
    T prod;  // l.prod  * v * r.prod , 自定义 乘号运算, 计算的是限制在splay中的
    T rprod; // r.rprod * v * r.rprod, 翻转的 为了flip准备的，有些运算的 乘法不满足交换律，有些满足(那么和prod值相同)
    S sv; // 当前节点值
    S vir; // 在原树中此点的虚儿子的sub之和(原树有边,但splay中跨越splay)
    S sub; // vir + l.sub + r.sub + sv, 也就是当前u所在splay的 最左节点v（原树中的某个v）,v以及v子树的所有sv之和
    node() : pa{ 0 }, ch{ 0, 0 }, flip{ false }, v{},
      prod{}, rprod{}, sv{}, sub{}, vir{} {}
  };
#define cur o[u]
#define lc cur.ch[0]
#define rc cur.ch[1]
  vector<node> o;
  bool isRoot(int u) const { return o[cur.pa].ch[0] != u && o[cur.pa].ch[1] != u; } // 认父不认子
  bool direction(int u) const { return o[cur.pa].ch[1] == u && !isRoot(u); } // 是splay中父亲的哪个儿子
  void down(int u) {
    if (!cur.flip) return;
    for (int c : {lc, rc}) setFlip(c);
    cur.flip = false;
  }
  void up(int u) {
    cur.prod = o[lc].prod * cur.v * o[rc].prod;
    cur.rprod = o[rc].rprod * cur.v * o[lc].rprod;
    cur.sub = cur.vir + o[lc].sub + o[rc].sub + cur.sv;
  }
  void setFlip(int u) {
    if (!u) return;
    swap(lc, rc);
    swap(cur.prod, cur.rprod);
    cur.flip ^= 1;
  }
  void cp(int c, int p, int d) { // child parent
    if (c) o[c].pa = p;
    if (p) o[p].ch[d] = c;
  }
  /* SPLIT_HASH_HERE */
  void rotate(int u) {
    int f = cur.pa; // fa
    assert(f); // u not root
    int g = o[f].pa; // grandfa
    int l = direction(u);
    int c = cur.ch[l ^ 1]; // child
    // 需要注意的是 这里和splay中的区别, 这里的pa 当f是root时，依然会指向所在splay树中的最左的点的在原树的父节点, 所以这里不能用 cp(u, g, isRoot(f) ? -1 : direction(f));
    if (!isRoot(f)) o[g].ch[direction(f)] = u;
    cur.pa = g;
    cp(f, u, l ^ 1);
    cp(c, f, l);
    up(f);
  }
  void update(int u) { // 从上到下down 所以递归
    if (!isRoot(u)) update(cur.pa);
    down(u);
  };
  void splay(int u) {
    update(u);
    while (!isRoot(u)) {
      int f = cur.pa;
      if (!isRoot(f)) rotate(direction(u) == direction(f) ? f : u);
      rotate(u);
    }
    up(u);
  }
  void access(int x) { // x到当前原树的根的所有点，恰好放入一个splay中(实链中), 并且把x置为实链splay的根
    for (int u = x, last = 0; u; u = cur.pa) {
      splay(u);
      cur.vir = cur.vir + o[rc].sub - o[last].sub;
      rc = last;
      up(last = u);
    }
    splay(x);
  }
  int findRoot(int u) { // 原树的根
    int la = 0;
    for (access(u); u; u = lc) down(la = u);
    return la;
  }
  void split(int x, int y) { makeRoot(x); access(y); } // x到的路径y是恰好单独一个splay树, y为splay的根
  void makeRoot(int u) { access(u); setFlip(u); } // 修改根, 当前到原树的根的路径（大小关系翻转）
  /* SPLIT_HASH_HERE */
public:
  LCT(int n = 0) : o(n + 1) {}
  void setVal(int u, const T& v) { splay(++u); cur.v = v; up(u); }
  void setSval(int u, const S& v) { access(++u); cur.sv = v; up(u); }
  T query(int x, int y) { // 输入是0-index, 对于原树上x到y的链进行查询
    split(++x, ++y);
    return o[y].prod; // 内部是1-index
  }
  S subtree(int p, int u) { // 输入是0-index
    makeRoot(++p); // 在原树中p为根
    access(++u); // u...p是同splay
    return cur.vir + cur.sv;
  }
  bool connected(int u, int v) { return findRoot(++u) == findRoot(++v); }
  void link(int x, int y) { // 原来分离的原树通过x,y连接, x连到y, 但是lct中是没有连接的, 这个操作y父,x子，但是它们之间不是实边
    makeRoot(++x);
    access(++y);
    o[y].vir = o[y].vir + o[x].sub;
    up(o[x].pa = y); // 之间不是实边，所以只用更新y,不用更新y的祖先
  }
  void cut(int x, int y) { // 对原树切割, x-y如果不相邻则 无事发生
    split(++x, ++y);
    if (o[y].ch[0] == x) { // 如果相邻则满足
      o[y].ch[0] = o[x].pa = 0;
      up(y);
    }
  }
#undef cur
#undef lc
#undef rc
};

struct nodev {
  long long value;
  nodev(long long v = 0) : value(v) {}
};

nodev operator*(const nodev& v0, const nodev& v1) {
  return nodev(v0.value ^ v1.value);  // 用异或作为示例
}

void luogu3690() {
  int n = read();
  int m = read();

  auto lct = LCT<nodev, int>(n);
  rep(i, 0, n) {
    int v = read();
    lct.setVal(i, nodev(v));
  }
  while (m-- > 0) {
    int op = read();
    int x = read();
    int y = read();
    if (op == 0) {
      printf("%lld\n", lct.query(--x, --y).value);
    } else if (op == 1) {
      if (!lct.connected(--x, --y)) lct.link(x, y);
    } else if (op == 2) {
      lct.cut(--x, --y);
    } else if (op == 3) {
      lct.setVal(--x, y);
    }
  }
}

int main() {
  luogu3690();
  return 0;
}
```

https://codeforces.com/contest/2097/problem/E

```cpp
void cf2097e() {
  // https://codeforces.com/contest/2097/problem/E
  struct nodev {
    ll value;
    nodev(ll v = 0) : value(v) {}
    nodev operator*(const nodev& v0) { return nodev(value + v0.value); };
  };
  int t = read();
  while (t-- > 0) {
    int n = read();
    int d = read();
    vector<pair<ll, int>> avi(n + 1); // 放置 {0,0} 最前面简化if逻辑
    rep(i, 1, n + 1) avi[i] = { read(),i - 1 };
    sort(begin(avi), end(avi));
    auto lct = LCT<nodev, int>(n + 1);
    rep(i, 0, n) lct.link(i, i + 1); // 未选中的 i -> i+1, 已经选中的i -> min(i+d,n);
    ll ans = 0;
    per(j, 1, n + 1) {
      auto [v, i] = avi[j];
      lct.setVal(i, nodev(1));
      lct.cut(i, i + 1);
      lct.link(i, min(i + d, n));
      ans += (avi[j].first - avi[j - 1].first) * lct.query(0, n).value;
    }
    printf("%lld\n", ans);
  }
}
```