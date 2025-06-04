---
title: splay tree 伸展树
date: 2025-06-03
tags: [splay,伸展树]
category: [algorithm]
---

# splay

1. 性质: 二叉查找树: 左子树小于根节点，右子树大于根节点
2. 均摊O(log n)时间复杂度
3. 伸展树: 每次访问节点后，将该节点旋转到根节点位置

m次splay 大小n的代价为 (n+m) log n

<https://www.cs.usfca.edu/~galles/visualization/SplayTree.html>

<!--more-->


## 操作

rotate(x):
- x 变为自己父节点, 保持二叉搜索树性质
  - 根据x与父节点关系，有左旋和右旋, 注意到对称性，只研究一边 右旋
  - 相关： 这个和红黑/avl 里的旋转一样, 只是红黑维护颜色性质，而avl维护深度性质，
  - zig(右旋)，zag(左旋)

```
   a                                        c
  / \                                      / \
  b   c     -> rotate(c) = zag(a) ->      a   e 
      / \   <- zig(c) = rotate(a) <-     / \
    d   e                               b   d 
```

**注意下面的x,这些表示节点id不表示值**, 需要值的话 增加val[x]去记录, 因为树的形状保证了值的大小关系，所以只有插入/查找的时候需要具体的值，而旋转的时候不会改变值，只是改变树结构，所以不需要具体的val

```c++
// 注意到上面b,e其实都没有动的，只有a,c,d之间的关系以及a的父节点在动
void rotate(int x){
  // 这里需要 保证x不是根, 一个办法是根的父节点增加一个虚根，下面的代码就可以有一致性了, virtual_root
  // assert(x != root);
  // assert(x != l[virtual_root]);
  int f = fa[x];
  if(x == r[f]){ // zag 左旋
    r[f] = l[x];
    if(l[x]) fa[l[x]] = f;
    l[x] = f;
  } else { // zig 右旋
    l[f] = r[x];
    if(r[x]) fa[r[x]] = f;
    r[x] = f;
  }
  fa[x] = fa[f];
  fa[f] = x;
  ((l[fa[x]] == f)?l[fa[x]]:r[fa[x]]) = x;
}
```

splay(x,root):
- 将x旋转到root所在的位置(代替root所在位置), 其中root原来需要是x的祖先节点

- x到root距离
  - 距离=0，直接结束
  - 距离=1, rotate(x) 即可
  - 距离>=2
    - 且 x是fa[x]左儿子,fa[x]是fa[fa[x]]左儿子( 同为左儿子，或同为右儿子), 先旋转父节点，再旋转子节点: rotate(fa[x]), rotate(x)
    - 有拐点(是父的左，父是父父的右，或者是父的右，父是父父的左), 旋转x两次: rotate(x), rotate(x)

```c++
void splay(int x,int target){
  if(x==target)return;// 本身是root
  auto direction = [&](int x){ return x==l[fa[x]]; };
  int tf = fa[target];
  while(fa[x] != tf){
    if(fa[x] == target){
      rotate(x);
    }else{
      rotate(direction(x) == direction(fa[x])?rotate(fa[x]):rotate(x));
      rotate(x);
    }
  }
}
```

显然 上面操作保持了二叉的性质，但没有直接证明 log n的性质

## 查询/增加

正常的二叉树搜索，但是如果搜索到，同时splay(x,root)

```c++
int find(int v){
  int ptr = root;
  while(not_null(ptr)) { // 非null 节点 根据需要设计, 例如-1, 不要和root冲突了
    if(val[ptr] == v){
      splay(ptr,root)
      return ptr;
    }
    nextptr = (v > val[ptr])?r[ptr]:l[ptr];
    if(is_null(nextptr)){ // 没找到也要splay，否则长链反复查询这里就会炸了
      splay(ptr,root)
      return null;
    }
    ptr = nextptr
  }
  assert(false);
  return ptr;
}
```

```c++
void insert(int v) { // 也可以自定义 类型
  int ptr = root;
  while(not_null(ptr)) { // 非null 节点 根据需要设计, 例如-1, 不要和root冲突了
    if(val[ptr] == v) { // 只应该插入不存在的
      assert(false);
    }
    nextptr = (v > val[ptr])?r[ptr]:l[ptr];
    if(is_null(nextptr)){
      nextptr = ((v > val[ptr])?r[ptr]:l[ptr]) = new_node();
      fa[nextptr] = ptr;
      val[nextptr] = v;
      splay(nextptr,root);
      return ;
    }
    ptr = nextptr;
  }
  assert(false);
  return ptr;
}
```

合并 树u,树v, 其中u全部小于树v
join(u,v)
- u 最大的节点一直走右节点x
- splay(u,rootu)
- r[x] = rootv
- fa[rootv] = x

split(x) 和删除类似
- splay(x,root)
- 左右就是切割出来的

删除x
- splay(x,root)
- join(l[x],r[x])

扩展: 查询个数
- 增加size字段, 在上面旋转中维护

区间:
- 双开区间 `(i....j)`
- splay(i,root)
- splay(j,r[i])
- l[j] 就是区间

lazy tag
- 类似segment tree 表示对子树的批量操作


## 复杂度分析

势能分析法

1. 单个节点势能 = w(u) = log(size(u)), 子树大小的log
2. $\varphi(tree) = \sum w(u)$, 整个树势能 = 所有节点势能和
3. 操作代价 $c_i= t_i + \varphi_i - \varphi_{i-1}$ 单次代价 + 势能变化

性质:
1. 父节点势能更大 w(fa[u]) > w(u)
2. 根节点势能不变 w(root) = w(new root)
3. size(p)>= size(x)+size(y) 则 2w(p)-w(x)-w(y) >= log 4
   - 证明: 右侧 $= \log(\frac{size(p)^2}{(size(x)size(y))})$
   - $\ge \log(\frac{(size(x)+size(y))^2}{(size(x)size(y))})$
   - $\ge \log 4$
   - 对于log 我们取 $\log_2$, 则得到 2

分析: 操作前f是父节点,x是子节点,g是`fa[f]`
- zig 操作
  - w是操作前,w'是操作后
  - 受到影响只有x,f
  - w(f) = w'(x) 操作前f势能 = 操作后x势能
  - $w'(x) \ge w'(f)$
  - $c_i = 1 + w'(f) + w'(x) - w(f) - w(x)$, $t_i$记作1
  - $c_i = 1 + w'(f) - w(x)$
  - $\le 1 + w'(x) - w(x)$
- zig-zig
  - $c_i = 2 + \sum w' - \sum w$
  - $= 2 + w'(f) +w'(g) - w(x) - w(f)$
  - $\le (2w'(x)-w(x)-w'(g)) + w'(f) +w'(g) - w(x) - w(f)$
  - $= 2(w'(x)-w(x)) + w'(f) - w(f)$
  - $\le 3(w'(x)-w(x))$
- zig-zag
  - $c_i \le 2(w'(x)-w(x))$ 类似的
- splay
  - zig至多一次，若干次 zig-zig/zig-zag 一类的
  - 总的代价在 $3(w^{t}(x)-w(x))+1\le 3\log n + 1$

我没有懂这个势能证明 与 代价之间如何建立最终的证明的

这个能证明，在当前的势能评价体系下，每次操作的 势能评价都是log级别的，但是 没有看到 总操作代价 与 势能函数 之间建立的 数值关系？
- 搜了几篇 都是 感觉上 让结构更好势能更小了，我也有这个“感觉”，但没有什么严谨的玩意？

---

下面的题目会发现，如果用到了一些翻转, 那么这个“值”其实难以维护的，但是能维护相对关系

## 相关资料

https://oi-wiki.org/ds/splay

Tyvj1728 luogu3369, https://www.luogu.com.cn/problem/P3369

Tyvj1728 luogu6136, https://www.luogu.com.cn/problem/P6136


```cpp
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<(ll)n;i++)
ll read() { ll r;scanf("%lld", &r);return r; }
// Tyvj1728 luogu3369
template<class T>
class Splay {
public:
  struct Node {
  public:
    int fa;
    array<int, 2> ch;
    T val;
    int cnt;
    int sz;
  };
  vector<Node> t; // tree
  const int EMPTY = -1;

  int root = EMPTY;
  bool isRoot(int u) { return t[u].fa == EMPTY; };
  int direction(int u) { assert(!isRoot(u));return t[t[u].fa].ch[1] == u; }; // u is not root
  int getSize(int u) { return (u == EMPTY) ? 0 : t[u].sz; };
  void pushUp(int u) { t[u].sz = t[u].cnt + getSize(t[u].ch[0]) + getSize(t[u].ch[1]); };
  void cp(int c, int p, int d) {
    if (c != EMPTY) t[c].fa = p;
    if (p != EMPTY) t[p].ch[d] = c;
  }
  void rotate(int u) {
    if (isRoot(u)) return;
    int fu = t[u].fa;
    int ffu = t[fu].fa;
    int du = direction(u);
    int cu = t[u].ch[!du];
    cp(u, ffu, ffu == EMPTY ? -1 : direction(fu));
    cp(fu, u, !du);
    cp(cu, fu, du);
    if (t[u].fa == EMPTY) root = u;
    pushUp(fu);
    pushUp(u);
  };
  void splay(int u, int p) { // u放到原来p的位置, 保证p是u的祖先
    assert(u != EMPTY);
    assert(p != EMPTY);
    int fp = t[p].fa;
    while (t[u].fa != fp) {
      int fu = t[u].fa;
      if (fu != p) rotate(direction(u) == direction(fu) ? fu : u);
      rotate(u);
    }
  }
  // ----
  int near(T v) {
    // 注意 调用near以后至少应该调用一次splay来 维持势能平均代价
    // near有一定的不确定性
    // 如果存在v返回的一定是对应的ptr
    // 如果不存在v，那么返回的是离它最近的，可能比它大可能比它小的一个ptr, 其对应可插入位置一定是EMPTY
    int u = root;
    if (u == EMPTY) return EMPTY;
    assert(u != EMPTY);
    while (true) {
      if (t[u].val == v) return u;
      int nextu = t[u].ch[t[u].val < v];
      if (nextu == EMPTY) return u;
      u = nextu;
    }
    assert(false);
    return EMPTY;
  }
  int add(T v) {
    auto createu = [&](int f) {
      int u = t.size();
      t.push_back(Node{ f,{EMPTY,EMPTY},v,1,1 });
      return u;
      };
    if (root == EMPTY) {
      assert(t.size() == 0);
      return root = createu(EMPTY);
    }
    int nu = near(v);
    if (t[nu].val == v) {
      t[nu].cnt++;
      pushUp(nu); // sz[nu]++
      splay(nu, root);
      return nu;
    }
    int u = t[nu].ch[t[nu].val < v] = createu(nu);
    splay(u, root);
    return u;
  };

  void remove(T v) { // 保证存在
    int nu = near(v);
    assert(t[nu].val == v);
    t[nu].cnt--;
    pushUp(nu);
    splay(nu, root);
    if (t[nu].cnt == 0) { // 真实删除
      if (t[nu].ch[0] == EMPTY) { // 没有 左子树
        cp(root = t[nu].ch[1], EMPTY, -1);
      } else {
        int lu = t[nu].ch[0];
        while (t[lu].ch[1] != EMPTY) lu = t[lu].ch[1];
        splay(lu, t[nu].ch[0]); // 左子树最大值 移动到
        int ru = t[nu].ch[1];
        cp(ru, lu, 1);
        cp(lu, EMPTY, -1);
        root = lu;
        pushUp(lu);
      }
    }
    while (t.size() and t.back().cnt == 0) t.pop_back();
  };
  int lessthan(T v) {
    int nu = near(v);
    if (nu == EMPTY) return 0;
    splay(nu, root);
    return getSize(t[nu].ch[0]) + (t[nu].val < v ? t[nu].cnt : 0);
  }
  T kth(int k) { // 返回的节点的值
    int u = root;
    while (true) {
      if (k <= getSize(t[u].ch[0])) { // 左子树
        u = t[u].ch[0];
      } else if (k <= getSize(t[u].ch[0]) + t[u].cnt) {// 根
        splay(u, root);
        return t[u].val;
      } else { // 右子树
        k -= getSize(t[u].ch[0]) + t[u].cnt;
        u = t[u].ch[1];
        if (u == EMPTY) return 0;
      }
    }
    return 0;
  }
  T prev(T v) { // return 值
    int nu = near(v);
    if (nu == EMPTY) return 0;
    splay(nu, root);
    if (t[nu].val < v) return t[nu].val;
    int ptr = t[nu].ch[0];
    while (t[ptr].ch[1] != EMPTY)ptr = t[ptr].ch[1];
    splay(ptr, root);
    return t[ptr].val;
  }
  int next(T v) {
    int nu = near(v);
    if (nu == EMPTY) return 0;
    splay(nu, root);
    if (t[nu].val > v) return t[nu].val;
    int ptr = t[nu].ch[1];
    while (t[ptr].ch[0] != EMPTY) ptr = t[ptr].ch[0];
    splay(ptr, root);
    return t[ptr].val;
  }
};

void luogu3369() {
  // 插入（可重复）
  // 删除（保证存在）
  // 比x小的个数，（x不一定存在）
  // 从小到大排列, 第k大的数
  // prev 比x小的最大的
  // next 比x打的最小的
  auto splay = Splay<int>();
  int t = read();
  while (t-- > 0) {
    int op = read();
    if (op == 1) {
      splay.add(read());
    } else if (op == 2) {
      splay.remove(read());
    } else if (op == 3) {
      printf("%d\n", splay.lessthan(read()) + 1);
    } else if (op == 4) {
      printf("%d\n", splay.kth(read()));
    } else if (op == 5) {
      printf("%d\n", splay.prev(read()));
    } else if (op == 6) {
      printf("%d\n", splay.next(read()));
    }
  }
}

void luogu6136() {
  // https://www.luogu.com.cn/discuss/765099 注意 这个数据可能不满足题意，没有修改逻辑，增加了几个查询的失败返回0，然后就过了
  int n = read();
  int m = read();
  // 插入（可重复）
  // 删除（保证存在）
  // 比x小的个数，（x不一定存在）
  // 从小到大排列, 第k大的数
  // prev 比x小的最大的
  // next 比x打的最小的
  auto splay = Splay<int>();
  rep(i, 0, n) splay.add(read());
  int ans = 0;
  int last = 0;
  while (m-- > 0) {
    int op = read();
    int v = read() ^ last;
    if (op == 1) {
      splay.add(v);
    } else if (op == 2) {
      splay.remove(v);
    } else if (op == 3) {
      last = (splay.lessthan(v) + 1);
      ans ^= last;
    } else if (op == 4) {
      last = splay.kth(v);
      ans ^= last;
    } else if (op == 5) {
      last = splay.prev(v);
      ans ^= last;
    } else if (op == 6) {
      last = splay.next(v);
      ans ^= last;
    }
  }
  printf("%d\n", ans);
}


int main() {
  luogu6136();
  return 0;
}
```

luogu p3391【模板】文艺平衡树 https://www.luogu.com.cn/problem/P3391

```cpp
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<(ll)n;i++)
ll read() { ll r;scanf("%lld", &r);return r; }
// Tyvj1728 luogu3369
template<class T>
class Splay {
public:
  struct Node {
  public:
    int fa;
    array<int, 2> ch;
    T val; // 这里只有 初始参与比较，后续不参与比较, 翻转后不再按照val比较
    int sz;
    int flip = 0;
  };
  vector<Node> t; // tree
  const int EMPTY = -1;

  int root = EMPTY;
  bool isRoot(int u) { return t[u].fa == EMPTY; };
  int direction(int u) { assert(!isRoot(u));return t[t[u].fa].ch[1] == u; }; // u is not root
  void pushUp(int u) { if (u == EMPTY)return; t[u].sz = 1 + getSize(t[u].ch[0]) + getSize(t[u].ch[1]); };
  int getSize(int u) { return u == EMPTY ? 0 : t[u].sz; };
  void flip(int u) {
    if (u == EMPTY)return;
    swap(t[u].ch[0], t[u].ch[1]); // 当前层完成操作
    t[u].flip ^= 1; // 向下未传递lazy标记
  };
  void pushDown(int u) {
    if (t[u].flip) {
      t[u].flip = 0;
      flip(t[u].ch[0]);
      flip(t[u].ch[1]);
    }
  };
  void cp(int c, int p, int d) {
    if (c != EMPTY) t[c].fa = p;
    if (p != EMPTY) t[p].ch[d] = c;
  }
  void rotate(int u) {
    if (isRoot(u)) return;
    int fu = t[u].fa;
    int ffu = t[fu].fa;
    int du = direction(u);
    int cu = t[u].ch[!du];
    cp(u, ffu, ffu == EMPTY ? -1 : direction(fu));
    cp(fu, u, !du);
    cp(cu, fu, du);
    if (t[u].fa == EMPTY) root = u;
    pushUp(fu);
    pushUp(u);
  };
  void update(int u) { // 从上到下pushDown，所以递归
    if (u != root) update(t[u].fa);
    pushDown(u);
  };
  void splay(int u, int p) { // u放到原来p的位置, 保证p是u的祖先
    assert(u != EMPTY);
    assert(p != EMPTY);
    int fp = t[p].fa;
    while (t[u].fa != fp) {
      int fu = t[u].fa;
      if (fu != p) rotate(direction(u) == direction(fu) ? fu : u);
      rotate(u);
    }
  }
  // ----
  int near(T v) {
    // 注意 调用near以后至少应该调用一次splay来 维持势能平均代价
    // near有一定的不确定性
    // 如果存在v返回的一定是对应的ptr
    // 如果不存在v，那么返回的是离它最近的，可能比它大可能比它小的一个ptr, 其对应可插入位置一定是EMPTY
    int u = root;
    if (u == EMPTY) return EMPTY;
    assert(u != EMPTY);
    while (true) {
      if (t[u].val == v) return u;
      int nextu = t[u].ch[t[u].val < v];
      if (nextu == EMPTY) return u;
      u = nextu;
    }
    assert(false);
    return EMPTY;
  }
  int add(T v) { // 保证只在开始添加，没有pushDown
    auto createu = [&](int f) {
      int u = t.size();
      t.push_back(Node{ f,{EMPTY,EMPTY},v,1,0 });
      return u;
      };
    if (root == EMPTY) {
      assert(t.size() == 0);
      return root = createu(EMPTY);
    }
    int nu = near(v);
    int u = t[nu].ch[t[nu].val < v] = createu(nu);
    splay(u, root);
    return u;
  };
  T kth(int k) { // 返回的节点
    int u = root;
    while (true) {
      pushDown(u);
      if (k <= getSize(t[u].ch[0])) { // 左子树
        u = t[u].ch[0];
      } else if (k <= getSize(t[u].ch[0]) + 1) {// 根
        return u;
      } else { // 右子树
        k -= getSize(t[u].ch[0]) + 1;
        u = t[u].ch[1];
        if (u == EMPTY) {
          return 0;
          assert(false);
        }
      }
    }
    return 0;
  }

  void dump(int u, vector<int>& res) {
    if (u == EMPTY)return;
    pushDown(u);
    dump(t[u].ch[0], res);
    res.push_back(t[u].val);
    dump(t[u].ch[1], res);
  }
  vector<int> dump() {
    vector<int> ret;
    dump(root, ret);
    return ret;
  }
};

void luogu3391() {
  // https://www.luogu.com.cn/discuss/765099 注意 这个数据可能不满足题意，没有修改逻辑，增加了几个查询的失败返回0，然后就过了
  int n = read();
  int m = read();
  // 插入（可重复）
  // 删除（保证存在）
  // 比x小的个数，（x不一定存在）
  // 从小到大排列, 第k大的数
  // prev 比x小的最大的
  // next 比x打的最小的
  auto splay = Splay<int>();
  rep(i, 0, n + 2) splay.add(i); // [0...n+1], 也保证了值和node对应
  while (m-- > 0) {
    int l = read();
    int r = read();
    // 是区间不是值
    if (l > r) continue;
    // l-1 < l<=r < r+1
    // flip [l...r]
    // splay(l-1,root);// 传递的应该是node id
    // splay(r+1,t[root].ch[1]);
    // flip(t[t[root].ch[1]].ch[0]);
    int lu = splay.kth(l); // 
    splay.update(lu);
    splay.splay(lu, splay.root);
    int ru = splay.kth(r + 2); // 
    splay.update(ru);
    splay.splay(ru, splay.t[lu].ch[1]);
    splay.flip(splay.t[ru].ch[0]);
  }
  auto ret = splay.dump();
  rep(i, 1, size(ret) - 1) printf("%d ", ret[i]);
}


int main() {
  luogu3391();
  return 0;
}
```