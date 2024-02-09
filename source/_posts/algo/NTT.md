---
title: 从FFT 到 NTT(快速数论变换)
date: 2022-07-24 22:24:00
tags:
  - FFT
  - NTT
  - 原根
category:
  - algorithm
mathjax: true
---

# NTT

竟然Div2能出现NTT 虽然是在最后一题, 还是得学一学

## 解决什么问题

是多项式乘法带模数的情况计算卷积

并且没有fft中会涉及到double,

NTT 也就是关于任意 环(数学术语) 上的离散傅立叶变化(DFT), 有限域的情况下,通常成为数论变换

## 离散傅立叶变换

回顾离散傅立叶变换, 就是

原函数(原向量) $\to$ DFT(离散傅立叶) $\to$ 点乘 $\to$ IDFT(逆傅立叶) $\to$ 结果函数(结果向量)

DFT:

$\hat{x}[k]=\sum_{n=0}^{N-1} e^{-i\frac{2\pi}{N}nk}x[n] \qquad k = 0,1,\ldots,N-1.$

IDFT:

$x\left[n\right]={1 \over N}\sum_{k=0}^{N-1} e^{ i\frac{2\pi}{N}nk}\hat{x}[k] \qquad n = 0,1,\ldots,N-1.$

有时系数可以是两个$\frac{1}{\sqrt{N}}$

矩阵表示的DFT, 是一个线性算子

${\displaystyle {\begin{bmatrix}f_{0}\\\\f_{1}\\\\\vdots \\\\f_{n-1}\end{bmatrix}}={\begin{bmatrix}1&1&1&\cdots &1\\\\1&\alpha &\alpha ^{2}&\cdots &\alpha ^{n-1}\\\\1&\alpha ^{2}&\alpha ^{4}&\cdots &\alpha ^{2(n-1)}\\\\\vdots &\vdots &\vdots &&\vdots \\\\1&\alpha ^{n-1}&\alpha ^{2(n-1)}&\cdots &\alpha ^{(n-1)(n-1)}\\\\\end{bmatrix}}{\begin{bmatrix}v_{0}\\\\v_{1}\\\\\vdots \\\\v_{n-1}\end{bmatrix}}.}$

<!--more-->

## 阶

若 $gcd(a,p) = 1, p > 1$

最小的$n > 0$ 使得 $a^n \equiv 1 \pmod{p}$, 则$\delta_p(a) = n$ 称作$a$模$p$的阶

显然, 对于$i\in [0,\delta_p(a))$, $a^i \pmod p$ 两两不同

## 原根

$\varphi(n)$ 为欧拉函数, 表示$1$到$n$中与$n$互质的数的个数

$p > 0, a$ 是整数, $\delta_p(a) = \varphi(a), gcd(p,a) = 1$, 则称$a$为$p$的一个原根

---

若$gcd(a,p) = 1, p > 0$ 则$a$为$p$的一个原根的充要条件 $\{a^1,a^2,a^3,\cdots,a^{\varphi(p)}\}$ 是p的简化剩余系

必要: $a$是$p$的原根, 根据阶中结论, 模$p$两两不同

充分: 因为是简化剩余系, 所以两两不同, 所以说明 $< \varphi(p)$ 的都不为1, 也说明$\delta_p(a) = \varphi(a)$

完全剩余系: n的完全剩余系, 在模n的剩余类中各取一个元素，则这n个数就构成了模n的一个完全剩余系。例如$\lbrace 0,1,2,3,...,n-1\rbrace$ 是n的一个完全剩余系

简化剩余系: 完全剩余系中 与n互质 构成的

### $\gcd(a,m)=1$ 则$\delta_m(a^k)=\dfrac{\delta_m(a)}{\gcd\left(\delta_m(a),k\right)}$

$a^{k\delta_m(a^k)}=(a^{k})^{\delta_m(a^k)}\equiv 1\pmod{m}$

所以$\delta_m(a) | k\delta_m(a^k)$

所以$\frac{\delta_m(a)}{\gcd(\delta_m(a),k)} | \delta_m(a^k)$

---

另一方面

$\displaystyle (a^k)^{\frac{\delta_m(a)}{\gcd(\delta_m(a),k)}}=(a^{\delta_m(a)})^{\frac{k}{\gcd(\delta_m(a),k)}}\equiv 1\pmod{p}$

所以 $\delta_m(k)| \frac{\delta_m(a)}{\gcd(\delta_m(a),k)}$

---

综上 两个 互为倍数，所以相等

### $\gcd(a,m)=\gcd(b,m)=1$ 则$\delta_m(ab)=\delta_m(a)\delta_m(b)\leftrightarrow \gcd(\delta_m(a),\delta_m(a))=1$


$(ab)^{\mathrm{lcm}(\delta_m(a),\delta_m(b))}=((a)^{\delta_m(a)})^{\frac{\delta_m(b)}{\gcd(\delta_m(a),\delta_m(b))}}((b)^{\delta_m(b)})^{\frac{\delta_m(a)}{\gcd(\delta_m(a),\delta_m(b))}}\equiv 1\pmod{p}$

所以 $\delta_m(ab) | \mathrm{lcm}(\delta_m(a),\delta_m(b))$

也有 $\delta_m(ab) | \delta_m(a)\delta_m(b)$


必要性:

由于$\delta_m(ab)=\delta_m(a)\delta_m(b)$ 所以$\delta_m(a)\delta_m(b) | \mathrm{lcm}(\delta_m(a),\delta_m(b))$

即$\gcd(\delta_m(a),\delta_m(b))=1$

充分性:

$\displaystyle 1\equiv ((ab)^{\delta_m(ab)})^{\delta_m(b)}=((a)^{\delta_m(ab)})^{\delta_m(b)}((b)^{\delta_m(b)})^{\delta_m(ab)} \equiv (a)^{\delta_m(ab)\delta_m(b)}\pmod p$

因此$\delta_m(a)|\delta_m(ab)\delta_m(b)$

因为$\gcd(\delta_m(a),\delta_m(b))=1$, 即$\delta_m(a) | \delta_m(ab)$

对称可得$\delta_m(b)|\delta_m(ab)$

再次因为$\gcd(\delta_m(a),\delta_m(b))=1$,所以$\delta_m(a)\delta_m(a) | \delta_m(ab)$

因为$\delta_m(ab) | \delta_m(a)\delta_m(b)$

所以$\delta_m(ab) = \delta_m(a)\delta_m(b)$

充要性得证

### 原根存在性定理

$n$ 存在原根 当且仅当$n\in\lbrace 2,4,p^\alpha,2p^\alpha\rbrace$,其中$p$为就奇素数

$n=2,4$ 显然存在

$n=p^\alpha$

... TODO

#### 引理: 素数$p$一定有原根


对于满足$\gcd(a,p) = 1$和$\gcd(b,p)=1$ 的$a,b$

存在$c$使得$\delta_p(c)=\mathrm{lcm}(\delta_p(a),\delta_p(b))$

首先表示$\left(\delta_m(a)=\prod_{i=1}^k{p_i^{\alpha_i}},\delta_m(b)=\prod_{i=1}^k{p_i^{\beta_i}} \right)$

然后表示成$\delta_m(a)=XY,\delta_m(b)=ZW$

其中

- $Y=\prod_{i=1}^k{p_i^{[\alpha_i>\beta_i]\alpha_i}}$, 也就是 质因数中，在$\delta_p(a)$中幂次更大的
- $X=\dfrac {\delta_m(a)}Y$ 剩余部分
- $W=\prod_{i=1}^k{p_i^{[\alpha_i\le\beta_i]\beta_i}}$, 也就是 质因数中，在$\delta_p(b)$中幂次更大或等于的
- $Z=\dfrac {\delta_m(b)}W$ 剩余部分

有$\delta_m(a^X)=\frac{\delta_m(a)}{\gcd(\delta_m(a),X)}=\frac{XY}{\gcd(XY,X)}=Y$

同理$\delta_m(b^Z)=\frac{\delta_m(b)}{\gcd(\delta_m(b),Z)}=\frac{ZW}{\gcd(ZW,Z)}=W$

因为$\gcd(Y,W)=1$,

$\delta_m(a^Xb^Z)=\delta_m(a^X)\delta_m(b^Z) =YW=\mathrm{lcm}(\delta_p(a),\delta_p(b))$

所以存在$c=a^Xb^Z$使得

---

存在$\delta_p(g)=\mathrm{lcm}(\delta_p(1),\delta_p(2),\cdots,\delta_p(p-1))$

所以对于$\forall j=1,2,\cdots,p-1, \delta_p(j)|\delta_p(g)$

所以$\displaystyle (j^{\delta_p(j)})^{\frac{\delta_p(g)}{\delta_p(j)}}\equiv 1\pmod{p}$

即都是$x^{\delta_p(g)}\equiv 1\pmod p$的根

$\delta_p(g)\le p-1$

$x^{\delta_p(g)}-1 \equiv k\prod_{j=1}^{p-1} (x-j) \pmod{p}$,$k$为与x无关的常数, 证明: 注意到 $x^{\delta_p(g)}-1\equiv 0\pmod{p}$,对左侧做 多项式带余数除法 除以$(x-j)$, 显然 对于其它$j$来说$x-j \not \equiv 0\pmod{p}$

所以$\delta_p(g)\ge p-1$

所以$\delta_p(g) = p-1$

得证
## 回到NTT

$p$为素数,$a$为$p$的一个原根, 有$\varphi(p) = p-1$

$n = 2^k, n | (p-1), k > 0$

令 $g_n = a^{\frac{p-1}{n}}$

$g_n^n = (a^{\frac{p-1}{n}})^n = a^{p-1} = 1 \pmod p$

$g_n^{\frac{n}{2}} = a^{\frac{p-1}{2}} = -1 \pmod p$

$g_{tn}^{tk} = a^{\frac{tk(p-1)}{tn}}=a^{\frac{k(p-1)}{n}}=g_n^k$

这里想用 $g_n^k$ 来替代$w_n^k$ 

(然后就直接可以替换了??? 不严格的语言证明是, 可以看成w为未知数, 那么$a \* b = c$ 不过是变成了c = IFFT(FFT(a) FFT(b)) = a * b

也就是 最终的只和$w$的$n$和$\frac{n}{2}$有关,否则 会有复平面的偏移

所以$w_n^k = e^{- i \frac{2 \pi}{N} nk}$ 也好

所以$w_n^k = g_n^k \pmod p$ 也好, 只要满足了$n$和$\frac{n}{2}$次方的性质即可

---

注意的是 $g_n^k \neq 1 \pmod p , k < \varphi_p(g)$

例如

$p=998244353=7 \times 17 \times 2^{23}+1$

有$g_{2^{23}} = 3^{\frac{p-1}{2^{23}}}$

---

据说$g$都挺小, 可以枚举$g$

---

然后INTT, 和IFFT对应, IFFT 相当于乘上了$e^{i \frac{2 \pi}{N} nk} = \frac{1}{w_n^k}$

所以这里就是$g$的逆元,

## 代码, 模板

https://github.com/CroMarmot/OICode/blob/master/functions/ntt998244353.cpp

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
#define rep(i,a,n) for (int i=a;i<n;i++)

const int MOD = 998244353; // 7*17*2^23 + 1
const int MAXPWR = 22; // 随着MOD改变, 2的幂次, 对应复平面单位向量的N = 2 && MAXPWR;
const int g = 3;// 原根 随着MOD改变
const int invg = 332748118;// 原根模逆元 随着MOD 和 g 改变

// bit 翻转
int rev(int x, int len) {
  int ans = 0;
  while(len -- ){
    ans <<= 1;
    ans |= x & 1;
    x >>= 1;
  }
  return ans;
}

inline int getlog2(int n){ return 31 - __builtin_clz(n);}

ll mypow(ll a, ll k) { //快速幂，a**k
  ll res = 1;
  while (k) {
    if (k & 1) (res *= a) %= MOD;
    (a *= a) %= MOD;
    k >>= 1;
  }
  return res;
}

void NTT(vector<ll> &A, int flag = 1 /* 1: NTT, -1: INTT*/ ) {
  int n = A.size();
  if(n == 1) return ;
  // assert((n & (n-1)) == 0); // 2 的幂次
  int lgn = getlog2(n);
  // assert(lgn <= MAXPWR);
  rep(i, 0, n) { // 同FFT
    int j = rev(i, lgn);
    if (j > i) swap(A[i], A[j]);
  }
  rep(pwr,0,lgn){
    int m = 1 << pwr;
    // assert((MOD - 1) % (m<<1) == 0);
    ll gn = mypow(flag == 1 ? g : invg, (MOD - 1) / (m << 1)); // 单位原根g_n
    for (int k = 0; k < n; k += (m<<1)) {
      ll gi = 1;
      rep(j,0,m) {
        auto U = A[k + j];
        auto T = gi * A[k + j + m] % MOD;
        A[k + j] = (U + T) % MOD;
        A[k + j + m] = (U - T + MOD) % MOD;
        (gi *= gn) %= MOD;
      }
    }
  }
  if(flag == -1){ // 内置 / N
    const ll INVSIZE = mypow(n, MOD-2);
    rep(i,0,n) (A[i] *= INVSIZE) %= MOD;
  }
}

void INTT(vector<ll> &A){ NTT(A,-1);}

int main(){
  // 123*456 = 56088
  const int SIZE = 8; // 一定要是2的幂次
  auto a = vector<ll>{3,2,1,0,0,0,0,0};
  auto b = vector<ll>{6,5,4,0,0,0,0,0};
  // 计算
  NTT(a);
  NTT(b);
  auto c = vector<ll>(SIZE,0);
  rep(i,0,SIZE) c[i] = a[i] * b[i];
  INTT(c);
  // 输出
  rep(i,0,SIZE) printf("(%lld)", c[i]);
  printf("\n");
  rep(i,0,SIZE-1) {// 进位
    c[i+1] += c[i] / 10;
    c[i] -= (c[i] / 10) * 10;
  }
  rep(i,0,SIZE) printf("(%lld)", c[i]);
  printf("\n");
  return 0;
}
```

## Ref

[我的FFT笔记](http://yexiaorain.github.io/Blog/2019-01-02-fftmul/)

https://oi-wiki.org/math/number-theory/primitive-root/