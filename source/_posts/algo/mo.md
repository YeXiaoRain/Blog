---
title: 莫队
date: 2020-08-28
tags: [莫队]
category: [algorithm]
mathjax: true
---

# 题目

啊 被牛客题目描述坑了，把关键信息藏在数据范围里，不过顺便学了一下莫队。

牛客题目https://ac.nowcoder.com/acm/contest/7079/A ， 知道真实题意以后是个水题

# 大意

指莫队要解决的问题不是牛客的题。

给长n的数组，没有改动，q次询问区间的不同值的个数

q和n都1e5

# 解法

我看到mex都很慌，这玩意虽然看上去是个质朴的东西，但涉及到的都不太好搞

上面 直接暴力，就 O(q n)。

莫队实际上就是 优雅的分块，然后再暴力。

1. 离线请求。
2. 根据请求的`[左端点/sqrt(n), 右端点]`排序
3. 暴力求解

意味着，每次对于 `左端点/sqrt(n)`相同的时候， 时间复杂度= `sqrt(n)*询问个数 + n`

总时间复杂度 `sqrt(n)*q + n*sqrt(n)`

一些优化，通过奇偶 来决定右端点是 正序还是逆序列。

# 代码

```c++
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
#define ten5 100000+10
#define rep(i,a,n) for (int i=a;i<n;i++)
#define iif(c,t,f) ((c)?(t):(f))
#define per(i,a,n) for (int i=n-1;i>=a;i--)


const int MAXN = 30005; // 数组大小
const int MAXQ = 200005; // 询问次数
const int MAXM = 1000005; // 值记录

int sq; // sqrt(n);
struct query{ // 把询问以结构体方式保存
  int l, r, id;
  // 不是按照 l 第一序列，r第二序
  // 而是 l/sq 第一序，r第二序列，对于相同的l/sq 其中根据l/sq的奇偶性来决定r是正向序还是逆向序
  bool operator<(const query &o) const { // 重载<运算符，奇偶化排序
    // 这里只需要知道每个元素归属哪个块，而块的大小都是sqrt(n)，所以可以直接用l/sq
    if (l / sq != o.l / sq)
      return l < o.l;
    if (l / sq & 1)
      return r < o.r;
    return r > o.r;
  }
} Q[MAXQ];
int A[MAXN];// 原始数组
int ans[MAXQ]; // 离线结果
int Cnt[MAXM];
int cur;// 总计
int l = 1, r = 0; // 左右游标

void add(int p) {
  if (Cnt[A[p]] == 0)
    cur++;
  Cnt[A[p]]++;
}
void del(int p) {
  Cnt[A[p]]--;
  if (Cnt[A[p]] == 0)
    cur--;
}
ll read(){
  ll r;
  scanf("%lld",&r);
  return r;
}
int main() {
  int n = read();
  sq = sqrt(n);
  rep(i,1,n+1){
    A[i] = read();
  }
  int q = read();
  rep(i,0,q){
    Q[i].l = read();
    Q[i].r = read();
    Q[i].id = i; // 把询问离线下来
  }
  sort(Q, Q + q); // 排序
  // 每个 按 l/sq的区块分的区间内，r的总变化最多n, l的变化 = sqrt(n) * 个数
  // 总代价 = sum 所有区块的代价 = 区块数 * r的每个区块变化 + sqrt(n) * 总个数 = n^(3/2) + q * n^(1/2);
  rep(i,0,q){
    while (l < Q[i].l)
      del(l++);
    while (l > Q[i].l)
      add(--l);
    while (r < Q[i].r)
      add(++r);
    while (r > Q[i].r)
      del(r--);
    ans[Q[i].id] = cur; // 储存答案
  }
  rep(i,0,q){
    printf("%d\n", ans[i]); // 按编号顺序输出
  }
  return 0;
}
```

# 参考

各种莫队博文

