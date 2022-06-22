---
title: Pollard-Rho 质数拆分
date: 2022-06-03 10:37:14
tags: [math,prime]
category: [Math]
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
ll Pollard_Rho(ll N) {
  assert(N!=1);
  if (N == 4) return 2;
  if (is_prime(N)) return N;
  if (is_prime_square(N)) return prime_square(N);
  while(true) {
    ll c = randint(1, N - 1); // 生成随机的c
    auto f = [=](ll x) { return ((lll)x * x + c) % N; }; // lll表示__int128，防溢出
    ll t = 0, r = 0;
    do{
      t = f(t);
      r = f(f(r));
      ll d = gcd(abs(t - r), N);
      if (d > 1) return d;
    }while (t != r)
  }
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
