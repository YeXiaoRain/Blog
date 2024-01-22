---
title: floor sum
date: 2024-01-21
tags:
  - floor_sum
category:
  - algorithm
mathjax: true
---


$f(a,b,c,n) = \sum_{x=0}^n \lfloor \frac{ax+b}{c} \rfloor$

## 代码

```cpp
// \sum_{x=0}^n \lfloor \frac{ax+b}{c} \rfloor
ll floor_sum(ll a,ll b,ll c,ll n){
  if(a==0) return (b/c)*(n+1);
  if(a >= c or b >= c) return n*(n+1)/2*(a/c) + (n+1)*(b/c) + floor_sum(a%c,b%c,c,n);
  ll m = (a*n+b)/c;
  return m*n - floor_sum(c,c-b-1,a,m-1);
}
```


<!--more-->

## floor sum / Generalized Floor Sum of Arithmetic Progressions

那么现在问题是 求

$f(a,b,c,n) = \sum_{x=0}^n \lfloor \frac{ax+b}{c} \rfloor$

如果 $a \ge c$ 或者 $b \ge c$

$\begin{aligned}f(a, b, c, n) =&{\sum\limits_{x = 0}^{n}}  \left\lfloor{\frac{ (  \left\lfloor{\frac{a}{c}}\right\rfloor c + (a \bmod c) )x +  \left\lfloor{\frac{b}{c}}\right\rfloor c + (b \bmod c)}{c}}\right\rfloor \cr =& {\sum\limits_{x = 0}^{n}} \left( \left\lfloor{\frac{a}{c}}\right\rfloor x +  \left\lfloor{\frac{b}{c}}\right\rfloor +   \left\lfloor{\frac{ (a \bmod c)x + (b \bmod c)}{c}}\right\rfloor \right) \cr =& \frac{n(n + 1)}{2} \left\lfloor{\frac{a}{c}}\right\rfloor + (n + 1) \left\lfloor{\frac{b}{c}}\right\rfloor + f(a \bmod c, b \bmod c, c, n)\end{aligned}$

---

所以 不妨设 $a < c, b < c$

$\begin{aligned}f(a, b, c, n) =& {\sum\limits_{x = 0}^{n} \sum\limits_{y = 0}^{  \left\lfloor{\frac{ax + b}{c}}\right\rfloor - 1}} 1 \cr =&{\sum\limits_{y = 0}^{  \left\lfloor{\frac{an + b}{c}}\right\rfloor - 1} \sum\limits_{x = 0}^{n}}\left[y <  \left\lfloor{\frac{ax + b}{c}}\right\rfloor \right]\end{aligned}$

~~amazing, 又看到一种(反演?)办法~~

对右边进行变形

$\begin{aligned}& y <  \left\lfloor{\dfrac{ax + b}{c}}\right\rfloor  \cr \implies & y + 1 \leq \dfrac{ax + b}{c} \cr \implies &cy + c - b \leq ax \cr \implies & cy + c - b - 1 < ax \cr \implies &  \left\lfloor{\dfrac{cy + c -b - 1}{a}}\right\rfloor < x \end{aligned}$

令$m= \lfloor \frac{an+b}{c} \rfloor$

$\begin{aligned} f(a, b, c, n) =& {\sum\limits_{y = 0}^{m - 1} \sum\limits_{x = 0}^{n}}\left[x >  \left\lfloor{\dfrac{cy + c -b - 1}{a}}\right\rfloor\right] \cr =& {\sum\limits_{y = 0}^{m - 1}} n -  \left\lfloor{\dfrac{cy + c -b - 1}{a}}\right\rfloor \cr =& mn - {\sum\limits_{y = 0}^{m - 1}} \left\lfloor{\dfrac{cy + c -b - 1}{a}}\right\rfloor \cr =& mn - f(c, c - b - 1, a, m - 1)\end{aligned}$

注意到

$(a,b,c) \to (c\mod a,(c-b-1)\mod a,a)$ 中$a,c$的变换,是辗转相除的复杂度, 所以log级别

## 参考

https://codeforces.com/blog/entry/97562

http://poj.org/problem?id=3495

https://atcoder.github.io/ac-library/master/document_en/math.html

相关

- [abc 283 Ex](https://atcoder.jp/contests/abc283/tasks/abc283_h)
- [abc 313 G](https://atcoder.jp/contests/abc313/tasks/abc313_g)