---
title: Pollard-Rho 质数拆分,分解
date: 2022-06-03 10:37:14
tags: [数学,质数]
category: [algorithm]
mathjax: true
---

# 前情提要

在之前做Project Euler 216 的时候

学了一下 如何利用别人的答案,在log n时间内判断n是否是一个 64位以内的质数的 Miller-Rabin 判别法

但如果这个数不是质数, 如何能拆解还没有解决

# 方法

## 方法1

回到最初的起点, for一遍 那也是$\sqrt(n)$

而众所周知, $\sqrt {2^{64}} = 2^{32} = $ 4.2e9

单独算一次的时间复杂度都接受不了

## 方法2

相信随机的力量, 先特判是否质数

在不停的随一个判断是否`gcd != 1` 来找因数

---

问题是, 生日悖论(一个房间里有23个人，则他们中有两人生日相同的概率超过一半)

换句话说, 反复生成随机数,有很高几率生成了不少一样的

## Pollard 的伪随机数

问题变成 我们希望它概率上看起来随机,值上有不重复得不那么随机

$x_{n+1} = f(x_n) = (x_n^2 + c) mod N$

但也不一定如期望, 例如 x = 0, c= 24,N = 9400, 很有规律, 因为这个递推式说白了就是下一项由上一项决定,肯定有循环,只是循环的早晚

低空间,低时间判断环? 那不是经典面试题双指针吗?(floyd判环算法)

初始$x_1 = y_1$

$x_{n+1} = f(x_n)$

$y_{n+1} = f(f(y_n))$

每次判断$gcd(|x_n - y_n|,N) > 1$, 和是否到达环, 成环则换一个c来跑

---

性质 |i-j| 是p的倍数,则 |f(i)-f(j)| 也是p的倍数

如果看作环上指针, 也就意味这两个指针距离相等时,其它距离和这个距离相等的两个指针之差,都是p的倍数,

而快慢指针每次会让距离+1, 而对于环上的视角, 其实追上慢指针相当于逐渐减少

## 实现和细节

据说$O(n^{\frac{1}{4}}\log n)$

$N = 4,N = 1$ 需要特判

素数平方提前判断

让x=0

```cpp
#include <bits/stdc++.h>
#include <atcoder/modint>
using mint = atcoder::modint998244353;
using namespace std;

typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<(ll)n;i++)
#define pb push_back

ll read(){ll r;scanf("%lld",&r);return r;} // read

typedef __int128_t lll;
ll quick_p(lll b, ll p,ll mod){
  lll r = 1;
  while(p){
    if(p%2)(r*=b)%=mod;
    (b*=b)%=mod;
    p/=2;
  }
  return r % mod;
}

bool miller_robin(ll v, ll base, ll startpwr){
  lll r = quick_p(base,startpwr,v);
  for(ll p = startpwr; p < v-1; p *=2){
    if(r == v-1) return true; // -1 开始的序列
    if(r == 1) return p == startpwr; // 全1序列
    (r*=r)%=v;
  }
  return false;
}

bool is_prime_64(ll v){
  if(v == 2)return true;
  if(v < 2 || v % 2 == 0)return false;
  ll p = v-1;
  while(p % 2 == 0) p /= 2;
  for(auto base:{2, 325, 9375, 28178, 450775, 9780504, 1795265022}){
    if(base % v == 0) continue; // don't break may cause 4033 bug
    // 需要所有都能找到-1开始, 或奇数次开始 全1
    if(!miller_robin(v,base,p)) return false;
  }
  return true;
}

ll my_sqrt(ll v){
  if(v <= 1) return v;
  ll l = 1; // 左ok
  ll r = v; // 右not ok
  while(r - l > 1){
    ll m = (l+r)/2;
    (v/m < m ? r : l) = m; // 防止 overflow
  }
  return l;
}
unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
mt19937 rand_num(seed);

ll randll(ll low,ll hi){
  return low + (rand_num() % static_cast<ll>(hi - low + 1));
}

ll Pollard_Rho(ll N) { // 返回一个> 1的因数
  assert(N > 1);
  if (N == 4) return 2;
  lll ret = my_sqrt(N); // 质数平方 效率低 提前判断
  if(ret * ret == N) return ret;
  while(true) {
    ll c = randll(1, N - 1); // 生成随机的c
    auto f = [=](lll x) { return ((lll)x * x + c) % N; }; // ll 表示__int128，防溢出
    ll t = 0, r = 0; // 初始两个相同
    do{
      t = f(t); // 1倍速度
      r = f(f(r)); // 2倍速度
      ll d = gcd(abs(t - r), N);
      if (d > 1 && d < N) return d;
    }while (t != r);
  }
}

// 分解x为质因数, sorted
vector<ll> fenjie(ll x) {
  vector<ll> res = {};
  deque <ll> arr = {x};
  while(arr.size()){
    ll v = arr.front();
    arr.pop_front();
    if(v == 1) continue;
    if(is_prime_64(v)) {
      res.pb(v);
      continue;
    }
    ll divisor = Pollard_Rho(v);
    arr.push_back(divisor);
    arr.push_back(v/divisor);
  }
  sort(res.begin(),res.end());
  return res;
}
```

## 固定128距离

减少求gcd的次数, 128次 或者 即将乘起来是N的倍数

大概是$O(n^{\frac{1}{4}})$

```cpp
ll Pollard_Rho(ll N) {
  assert(N!=1);
  if (N == 4) return 2;
  if (is_prime(N)) return N;
  if (is_prime_square(N)) return prime_square(N);
  while(true){
    ll c = randint(1, N - 1);
    auto f = [=](ll x) { return ((lll)x * x + c) % N; };
    ll t = 0, r = 0, p = 1, q;
    do {
      for (int i = 0; i < 128; ++i) { // 令固定距离C=128
        t = f(t), r = f(f(r));
        if (t == r || (q = (lll)p * abs(t - r) % N) == 0) break; // 如果发现环，或者积即将为0，退出
        p = q;
      }
      ll d = gcd(p, N);
      if (d > 1) return d;
    } while (t != r);
  }
}
```
