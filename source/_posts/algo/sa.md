---
title: 后缀数组 SA
date: 2022-07-27 10:37:14
tags: [SA,SAM]
category: [algorithm]
mathjax: true
---

# 相关内容

后缀自动机

# 最终产物

一个数组sa 记录下标, 按照后缀字典序排序

以及需要的话一个记录rank的数组(和sa相反)

![后缀数组](https://oi-wiki.org/string/images/sa1.png)

h[i] 表示排名为i的和排名为i-1的最长公共前缀长度

<!--more-->

# SA

就是字符串所有后缀, 按照字典序排序

就是先按照每个位置开始长度为1排序, 变成数值顺序

再按照长度2的前缀顺序排, 但是此时 不需要原字符串,而直接用算出的数值顺序拼接

再按照长度4的前缀顺序排, 同上 相当于两个 长度2 的拼接

```
for step => 2 * step:
  rank = sort(pair< rank[i],rank[i+step] >)
```

## 例如代码

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
#define MOD 1000000007
#define rep(i,a,n) for (ll i=a;i<n;i++)
#define per(i,a,n) for (ll i=n;i-->(ll)a;)
#define pb push_back

const int N = 1000000;

bool eq(vector<int>& rk, int x,int y,int w){
  return rk[x] == rk[y] && rk[x+w] == rk[y+w];
}

// 0-index + 基数排序
void calcsa(char *s,int n, vector<int> &sa,vector<int> &rk){
  const int SIZE = max(512, n+1); // 字符集大小
  vector<int>cnt(SIZE, 0); // char 2 count
  rk.resize(2*n); // rank: 相等的前缀rank相等, 结束符rank = 0, 所以rank从1开始
  sa.resize(n); // 后缀 index
  rep(i,0,n) ++cnt[rk[i] = s[i]]; // 计数统计
  rep(i,1,SIZE) cnt[i] += cnt[i - 1]; // 计数统计前缀
  per(i,0,n) sa[--cnt[rk[i]]] = i; // 当前排序
  { // n == 1
    auto oldrk = rk;
    int p = 0;
    rep(i,0,n) {
      if (i == 0 || oldrk[sa[i]] != oldrk[sa[i-1]]) p++;
      rk[sa[i]] = p;
    }
  }
  // rk = sort({rk[i],rk[i+w]}
  for(int w = 1; w < n; w *= 2) {
    // 从低位到高位排序, 先排低位 rank[i+w], 再排 rank[i+0]
    for(auto d:{w, 0}){
      cnt = vector(SIZE,0);
      rep(i,0,n) ++cnt[rk[i + d]]; // 所有 i+d 开始的计数统计
      rep(i,1,SIZE) cnt[i] += cnt[i - 1];// 前缀和(基数排序
      auto idx = sa;
      per(i,0,n) sa[--cnt[rk[idx[i] + d]]] = idx[i]; // 保序
    }
    auto oldrk = rk;
    int p = 0;
    rep(i,0,n) {
      if (i == 0 || oldrk[sa[i]] != oldrk[sa[i-1]] || oldrk[sa[i]+w] != oldrk[sa[i - 1] + w]) p++;
      rk[sa[i]] = p;
    }
  }
  rk.resize(n+1);
}

int main() {
  char s[N+10] = "aabaaaab";
  int n = strlen(s) ;
  printf("%d\n",n);
  printf("%s\n",s);
  vector<int> sa;
  vector<int> rank;
  calcsa(s, n, sa, rank);
  rep(i,0,n) printf("%d ", sa[i]);
  return 0;
}
```

## height 数组

而h数组, 首次相等的则 = 1

h[i] = lcp(sa[i],sa[i-1])

性质

h[rk[i]] >= h[rk[i-1]] - 1

设后缀i-1 = "aAB", a字符,A是h[i-1]对应字符串剩余部分,B是后缀的剩余部分

那么后缀i = "AB"

因为后缀i-1 = "aAB" 其实存在 "aAC", "C < B", 且"C,B"公共前缀为空字符串

那么也就说明"AC"也存在

"AC", "AB" 之间 如果还有其他的字符串,只能是"AD"形式 "C < D < B", 那么长度至少为"|A|", 得证

所以 可以按照i的顺序暴力算

```cpp
int k = 0;
rep(i,0,n) {
  if (rk[i] == 0) continue;
  if (k) --k;
  while (s[i + k] == s[sa[rk[i] - 1] + k]) ++k;
  h[rk[i]] = k;
}
```


## vector + sort + pair版本

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
#define MOD 1000000007
#define rep(i,a,n) for (ll i=a;i<n;i++)
#define per(i,a,n) for (ll i=n;i-->(ll)a;)
#define pb push_back

// 0-index + vector + sort
// sa 下标按照顺序排列
// rank 下标对应顺序index
// h sa 中相邻后缀 最长公共前缀 h[0] = 0;
template<class T>
void calc_sa_rank(vector<T>& arr, vector<int> &sa,vector<int> &rank, vector<int>&h){
  int n = arr.size();
  rank = vector<int>(n,0);
  sa = vector<int>(n,0);
  iota(sa.begin(),sa.end(), 0);
  sort(sa.begin(),sa.end(), [&](int i,int j){return arr[i] < arr[j];}); // 注意[&] 不要[=] 会有复杂度问题
  rep(i,1,n) rank[sa[i]] = rank[sa[i-1]] + !(arr[sa[i]] == arr[sa[i-1]]);
  for(int w = 1; w < n; w *= 2) {
    auto rank0 = rank;
    auto rk = [&](int i){return i < n ? rank0[i] : -1;};
    sort(sa.begin(),sa.end(), [&](int i,int j){
        return rk(i) != rk(j) ? rk(i) < rk(j) : rk(i+w) < rk(j+w);
    });
    rank[sa[0]] = 0;
    rep(i,1,n) rank[sa[i]] = rank[sa[i-1]] + !(rk(sa[i]) == rk(sa[i-1]) && rk(sa[i]+w) == rk(sa[i-1]+w));
  }
  // height
  h = vector<int>(n,0);
  int k = 0;
  rep(i,0,n) {
    if (rank[i] == 0) continue;
    if (k) --k;
    while (arr[i + k] == arr[sa[rank[i] - 1] + k]) ++k;
    h[rank[i]] = k;
  }
}


int main() {
  char s[100] = "aabaaaab";
  int n = strlen(s) ;
  printf("s:%s\n",s);
  vector<char> arr ;
  rep(i,0,n) arr.pb(s[i]);
  vector<int> sa;
  vector<int> rank;
  vector<int> h;
  calc_sa_rank(arr, sa, rank, h);
  printf("sa:\n");
  rep(i,0,n) printf("%d %s\n", sa[i], s + sa[i]);
  printf("\nrk:\n");
  rep(i,0,n) printf("%d %s\n", rank[i], s + i);
  printf("\nhei:");
  rep(i,0,n) printf("%d ", h[i]);
  printf("\n");
  return 0;
}
```
