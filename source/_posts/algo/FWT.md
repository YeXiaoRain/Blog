---
title: 从FFT 到 FWHT 快速沃尔什-阿达玛转换(Walsh Hadamard transform)
date: 2022-07-26 22:24:00
tags: [FFT,FWT]
category: [algorithm]
mathjax: true
---

# FWHT

快速沃尔什-阿达玛转换(Fast Walsh-Hadamard transform), 一种广义傅立叶变换(FWHT)

## 解决什么问题

FWHT 是用于解决对下标进行位运算卷积问题的方法

$c_{i} = \sum_{i=j \bigoplus k}a_{j} b_{k}$

并且没有fft中会涉及到double

---

前置知识 FFT(DFT)

DFT:

${\displaystyle {\begin{bmatrix}f_{0}\\\\f_{1}\\\\\vdots \\\\f_{n-1}\end{bmatrix}}={\begin{bmatrix}1&1&1&\cdots &1\\\\1&\alpha &\alpha ^{2}&\cdots &\alpha ^{n-1}\\\\1&\alpha ^{2}&\alpha ^{4}&\cdots &\alpha ^{2(n-1)}\\\\\vdots &\vdots &\vdots &&\vdots \\\\1&\alpha ^{n-1}&\alpha ^{2(n-1)}&\cdots &\alpha ^{(n-1)(n-1)}\\\\\end{bmatrix}}{\begin{bmatrix}v_{0}\\\\v_{1}\\\\\vdots \\\\v_{n-1}\end{bmatrix}}.}$

<!--more-->

## 回顾离散傅立叶与卷积

核心等式

$\operatorname{FFT}(a * b) = \operatorname{FFT}(a) \cdot \operatorname{FFT}(b)$

快速变换, $x$原向量,$N$大小, $idx$ 下标

$idx \le \frac{N}{2}$

$f(x,N,idx) = f(even(x),\frac{N}{2},idx) + w^k \cdot f(odd(x),\frac{N}{2},idx)$

$f(x,N,idx+\frac{N}{2}) = f(even(x),\frac{N}{2},idx) - w^k \cdot f(odd(x),\frac{N}{2},idx)$

## Or 版本 FORT(Fast or transform)

### Or卷积 与 ForT

$c_{i} = \sum_{i = j | k}a_{j} b_{k}$, 这里$|$ 是按位或不是整除

令$fort[C]_ i = \sum_{i = j|i} A_j$

$\begin{aligned}
fort[a]_ i \cdot fort[b]_ i &= (\sum_{j|i=i} a_j) \cdot (\sum_{k|i=i} b_k) \\\\
&= \sum_{j|i=i} \sum_{k|i=i} a_jb_k \\\\
&= \sum_{(j|k)|i = i} a_jb_k \\\\
&= fort[c]_ i
\end{aligned}$

这证明了 $\operatorname{ForT}(\left(\sum_{i=j | k}a_{j} b_{k}\right)) = \operatorname{ForT}(a) \cdot \operatorname{ForT}(b)$

### 快速变换

下面问题就是如何fast, 如何让快速计算fort和它的逆变换ifort

快速变换, $x$原向量,$N$大小, $idx$ 下标

$idx < \frac{N}{2}$

$f(x,N,idx) = f(x, \frac{N}{2},idx)$

$f(x,N,idx+\frac{N}{2}) = f(x[0\cdots \frac{N}{2}-1]),\frac{N}{2},idx) + f(x[\frac{N}{2}\cdots N-1],\frac{N}{2},idx)$

因为本身$fort$的第$i$位就是所有$i$的二进制子集位置的和

那么对于$idx$ 它的子集一定也是在前半数组中

那么对于$idx + \frac{N}{2}$ 它的 其实就是最高位多了一个bit, 除了这个bit, 剩余部分和$idx$一样, 所以前半后半都按照$idx$来计算求和即可

至此完成fast

```cpp
void ForT(modint *f) {
  for (int k = 1; k < n; k *=2){
    for (int i = 0; i < n; i += 2*k){
      for (int j = 0; j < k; j++){
        // f[i+j] = f[i+j];
        f[i+j+k] += f[i+j];
      }
    }
  }
}
```

### 逆变换

可以直接参考fast的过程, 每个位置表示它所有bit子集的和, 那么按照反过来, 可以先减去未包含最低的其它子集和bit的值,未包含了低2位bit的其她子集和,...

显然对于的向量的$v$首个值有 $fort(v)_ 0 = v_0$

所以 $a_0 = fort(a)_ 0$

因为 $fort(a)_ 1 = fort(a_0) + fort(a_1)$

所以 $a_1 = fort(a_1) = fort(a)_ 1 - fort(a_0)$

同理$idx < \frac{N}{2}$

$f(x,N,idx) = f(x, \frac{N}{2},idx)$

$f(x,N,idx+\frac{N}{2}) = f(x[0\cdots \frac{N}{2}-1]),\frac{N}{2},idx) - f(x[\frac{N}{2}\cdots N-1],\frac{N}{2},idx)$


```cpp
void IForT(modint *f) {
  for (int k = 1; k < n; k *=2){
    for (int i = 0; i < n; i += 2*k){
      for (int j = 0; j < k; j++){
        f[i+j+k] -= f[i+j];
      }
    }
  }
}
```

---

合并

```cpp
// Or卷积
void ForT(vector<modint> &f,int flag = 1/* 1:正变换,-1:逆变换 */) {
  int n = f.size();
  for (int k = 1; k < n; k *=2){
    for (int i = 0; i < n; i += 2*k){
      for (int j = 0; j < k; j++){
        f[i+j+k] += flag * f[i+j];
      }
    }
  }
}
```

## And 卷积(Fast and transform)

$c_{i} = \sum_{i = j \& k}a_{j} b_{k}$

和Or的部分同理

1. 定义变换$fandt(a)_ i = \sum_{i|j = j} a_j$
2. 证明 $fandt(a) \odot fandt(b) = fandt(\left(\sum_{i = j \& k}a_{j} b_{k}\right))$
3. 利用分块关系,实现fast

最终代码

```cpp
void FandT(vector<modint> &f, int flag = 1/* 1:正变换,-1:逆变换 */) {
  int n = f.size();
  for (int k = 1; k < n; k *=2){
    for (int i = 0; i < n; i += 2*k){
      for (int j = 0; j < k; j++){
        f[i+j] += f[i+j+k] * flag;
      }
    }
  }
}
```

## Xor卷积 与 FWHT(Fast Walsh-Hadamard transform)

$\operatorname{FWHT}(\left(\sum_{i=j \bigoplus k}a_{j} b_{k}\right)) = \operatorname{FWHT}(a) \cdot \operatorname{FWHT}(b)$

### 定义FWHT

其实和上面一样,依然是三步,定义转换,证明等式,实现fast

定义符号 $x\otimes y=\text{popcount}(x \& y) \bmod 2$, 即 $x$位与$y$后的二进制表示的$1$的个数再$\bmod 2$

有性质$(i \otimes j) \oplus (i \otimes k) = i \otimes (j \oplus k)$

证明: 对于给定的一位, 如果i中0, 则都贡献0, 如果i中是1, $j,k$对应的是1 则贡献是0 则不贡献, 得证

定义: $fwht[a]_ i = \sum_{i\otimes j = 0}a_j - \sum_{i\otimes j = 1}a_j$

那么有:

$fwht[a]_ i \cdot fwht[b]_ i$

$\begin{aligned}
&= (\sum_{i\otimes j = 0} a_j - \sum_{i\otimes j = 1} a_j)\cdot (\sum_{i\otimes k = 0} b_k - \sum_{i\otimes k = 1} b_k) \\\\
&=\left((\sum_{i\otimes j=0}a_j)(\sum_{i\otimes k=0}b_k)+(\sum_{i\otimes j=1}a_j)(\sum_{i\otimes k=1}b_k) \right)-\left((\sum_{i\otimes j=0}a_j)(\sum_{i\otimes k=1}b_k)-(\sum_{i\otimes j=1}a_j)(\sum_{i\otimes kj=0}b_k)\right)\\\\
&=\sum_{i\otimes(j \oplus k)=0}a_jb_k-\sum_{i\otimes(j\oplus k)=1}a_jb_k \\\\
&=\sum_{i\otimes l = 0}\sum_{l = j \oplus k}a_jb_k-\sum_{i\otimes l = 1}\sum_{l = j\oplus k}a_jb_k \\\\
&= fwht[\left(\sum_{i=j \bigoplus k}a_{j} b_{k}\right)]_ i
\end{aligned}$

### Walsh matrix and Hadamard transform

可以看看Walsh矩阵的样子

${\displaystyle H_{m}={\frac {1}{\sqrt {2}}}{\begin{pmatrix}H_{m-1}&H_{m-1}\\\\H_{m-1}&-H_{m-1}\end{pmatrix}}}$

${\begin{aligned}H_{0}&=+{\begin{pmatrix}1\end{pmatrix}}\\\\H_{1}&={\frac {1}{\sqrt {2}}}\left({\begin{array}{rr}1&1\\\\1&-1\end{array}}\right)\\\\H_{2}&={\frac {1}{2}}\left({\begin{array}{rrrr}1&1&1&1\\\\1&-1&1&-1\\\\1&1&-1&-1\\\\1&-1&-1&1\end{array}}\right)\\\\H_{3}&={\frac {1}{2^{3/2}}}\left({\begin{array}{rrrrrrrr}1&1&1&1&1&1&1&1\\\\1&-1&1&-1&1&-1&1&-1\\\\1&1&-1&-1&1&1&-1&-1\\\\1&-1&-1&1&1&-1&-1&1\\\\1&1&1&1&-1&-1&-1&-1\\\\1&-1&1&-1&-1&1&-1&1\\\\1&1&-1&-1&-1&-1&1&1\\\\1&-1&-1&1&-1&1&1&-1\end{array}}\right)\\\\(H_{n})_{i,j}&={\frac {1}{2^{n/2}}}(-1)^{i\cdot j}\end{aligned}}$

对于 $(1,0,1,0,0,1,1,0)$

![The product of a Boolean function and a Walsh matrix](https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/1010_0110_Walsh_spectrum_%28single_row%29.svg/300px-1010_0110_Walsh_spectrum_%28single_row%29.svg.png)

![Fast Walsh–Hadamard transform, a faster way to calculate the Walsh spectrum](https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/1010_0110_Walsh_spectrum_%28fast_WHT%29.svg/300px-1010_0110_Walsh_spectrum_%28fast_WHT%29.svg.png)

### 快速变换

其实看到了矩阵之间的递推关系 这个表达式就很显然了

$idx < \frac{N}{2}$

$f(x,N,idx) = f(x[0,\frac{N}{2}), \frac{N}{2},idx) + f(x[\frac{N}{2},N), \frac{N}{2}, idx)$

$f(x,N,idx+\frac{N}{2}) = f(x[0,\frac{N}{2}), \frac{N}{2},idx) - f(x[\frac{N}{2},N), \frac{N}{2}, idx)$



```cpp
void FWHT(vector<modint> &f, int flag = 1 /* 1: 正变换, 1/2: 逆变换*/) {
  int n = f.size();
  for (int k = 1; k < n; k *=2){
    for (int i = 0; i < n; i += 2*k){
      for (int j = 0; j < k; j++){
        auto U = f[i+j];
        auto T = f[i+j+k];
        f[i+j]   = U + T;
        f[i+j+k] = U - T;
        f[i+j] *= flag;
        f[i+j+k] *= flag;
      }
    }
  }
}
```

## 模板

```cpp
#include <bits/stdc++.h>
#include "./modint.cpp"
using namespace std;

typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<n;i++)
#define per(i,a,n) for (ll i=n;i-->(ll)a;)
#define pb push_back

using MODINT::modint;

namespace FWT{
  void ForT(vector<modint> &f,int flag = 1/* 1:正变换,-1:逆变换 */) {
    int n = f.size();
    for (int k = 1; k < n; k *=2){
      for (int i = 0; i < n; i += 2*k){
        for (int j = 0; j < k; j++){
          f[i+j+k] += f[i+j] * flag;
        }
      }
    }
  }

  void IForT(vector<modint> &f) {ForT(f, -1);}

  vector<modint> or_convolution(vector<modint> &v0, vector<modint> &v1){
    const int sz = v0.size();
    ForT(v0);
    ForT(v1);
    vector<modint> v2(sz,0);
    rep(i,0,sz) v2[i] = v0[i] * v1[i];
    IForT(v2);
    return v2;
  }

  void FandT(vector<modint> &f, int flag = 1/* 1:正变换,-1:逆变换 */) {
    int n = f.size();
    for (int k = 1; k < n; k *=2){
      for (int i = 0; i < n; i += 2*k){
        for (int j = 0; j < k; j++){
          f[i+j] += f[i+j+k] * flag;
        }
      }
    }
  }
  void IFandT(vector<modint> &f) {FandT(f, -1);}

  vector<modint> and_convolution(vector<modint> &v0, vector<modint> &v1){
    const int sz = v0.size();
    FandT(v0);
    FandT(v1);
    vector<modint> v2(sz,0);
    rep(i,0,sz) v2[i] = v0[i] * v1[i];
    IFandT(v2);
    return v2;
  }

  modint inv2 = modint(2).inv();
  void FWHT(vector<modint> &f, modint flag = 1 /* 1: 正变换, 1/2: 逆变换*/) {
    int n = f.size();
    for (int k = 1; k < n; k *=2){
      for (int i = 0; i < n; i += 2*k){
        for (int j = 0; j < k; j++){
          auto U = f[i+j];
          auto T = f[i+j+k];
          f[i+j]   = U + T;
          f[i+j+k] = U - T;
          f[i+j] *= flag;
          f[i+j+k] *= flag;
        }
      }
    }
  }
  void IFWHT(vector<modint> &f) {FWHT(f, inv2);}
  void FxorT(vector<modint> &f,int flag = 1) {FWHT(f, flag);}
  void IFxorT(vector<modint> &f) {IFWHT(f);}

  vector<modint> xor_convolution(vector<modint> &v0, vector<modint> &v1){
    const int sz = v0.size();
    FxorT(v0);
    FxorT(v1);
    vector<modint> v2(sz,0);
    rep(i,0,sz) v2[i] = v0[i] * v1[i];
    IFxorT(v2);
    return v2;
  }
};

void print(vector<modint> &arr){
  for(auto &v:arr) printf("%d ", v.val());
  printf("\n");
}

int main(){
  // 长度2的幂次
  const vector<modint> A0 = {1,2,3,0};
  const vector<modint> B0 = {4,5,6,0};

  // --- or ---
  {
    auto A = A0;
    auto B = B0;
    auto C = FWT::or_convolution(A,B);
    print(C);
  }
  // --- and ---
  {
    auto A = A0;
    auto B = B0;
    auto C = FWT::and_convolution(A,B);
    print(C);
  }
  // --- xor ---
  {
    auto A = A0;
    auto B = B0;
    auto C = FWT::xor_convolution(A,B);
    print(C);
  }
  return 0;
}
```

## 洛谷P4717

https://www.luogu.com.cn/record/81332363

```cpp
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<n;i++)

ll read(){ll r;scanf("%lld",&r);return r;} // read

// ----------- modint -----------
namespace MODINT{
  const int _mod = 998244353;
  class modint{
    private:
      ll _v;
    public:
      modint() :_v(0) {  }
      modint(ll _a) {
        _v = (_a < 0)? _mod - ((-_a) % _mod) : (_a % _mod);
      }

      int val()const { return _v; }
      modint operator+()const { return *this; }
      modint operator-()const { return { _mod - _v }; }
      modint operator+(const modint& rhs) const { return modint(*this) += rhs; }
      modint operator-(const modint& rhs) const { return modint(*this) -= rhs; }
      modint operator*(const modint& rhs) const { return modint(*this) *= rhs; }
      modint operator/(const modint& rhs) const { return modint(*this) /= rhs; }

      bool operator==(const modint& rhs)const { return _v == rhs._v; }
      bool operator!=(const modint& rhs)const { return _v != rhs._v; }
      bool operator> (const modint& rhs)const { return _v >  rhs._v; }
      bool operator>=(const modint& rhs)const { return _v >= rhs._v; }
      bool operator<=(const modint& rhs)const { return _v <= rhs._v; }
      bool operator< (const modint& rhs)const { return _v <  rhs._v; }

      modint& operator+=(const modint& rhs) {
        (_v += rhs._v) %= _mod;
        return *this;
      }
      modint& operator-=(const modint& rhs) {
        (_v += _mod - rhs._v) %= _mod;
        return *this;
      }
      modint& operator*=(const modint& rhs) {
        _v = _v * rhs.val() % _mod;
        return *this;
      }
      modint& operator/=(const modint& rhs) { // 费马小定理
        _v = _v * rhs.inv().val() % _mod ;
        return *this;
      }
      modint pow(ll pwr) const {
        ll res(1);
        ll _b(_v);
        while (pwr) {
          if (pwr & 1) (res *= _b) %= _mod;
          (_b *= _b) %= _mod;
          pwr /= 2;
        }
        return res;
      }
      modint inv() const {
        assert(_v != 0);
        return pow(_mod - 2);
      }
  };
};
// ----------- modint -----------


// ----------- fwt -----------
using MODINT::modint;

namespace FWT{
  void ForT(vector<modint> &f,int flag = 1/* 1:正变换,-1:逆变换 */) {
    int n = f.size();
    for (int k = 1; k < n; k *=2){
      for (int i = 0; i < n; i += 2*k){
        for (int j = 0; j < k; j++){
          f[i+j+k] += f[i+j] * flag;
        }
      }
    }
  }

  void IForT(vector<modint> &f) {ForT(f, -1);}

  vector<modint> or_convolution(vector<modint> &v0, vector<modint> &v1){
    const int sz = v0.size();
    ForT(v0);
    ForT(v1);
    vector<modint> v2(sz,0);
    rep(i,0,sz) v2[i] = v0[i] * v1[i];
    IForT(v2);
    return v2;
  }

  void FandT(vector<modint> &f, int flag = 1/* 1:正变换,-1:逆变换 */) {
    int n = f.size();
    for (int k = 1; k < n; k *=2){
      for (int i = 0; i < n; i += 2*k){
        for (int j = 0; j < k; j++){
          f[i+j] += f[i+j+k] * flag;
        }
      }
    }
  }
  void IFandT(vector<modint> &f) {FandT(f, -1);}

  vector<modint> and_convolution(vector<modint> &v0, vector<modint> &v1){
    const int sz = v0.size();
    FandT(v0);
    FandT(v1);
    vector<modint> v2(sz,0);
    rep(i,0,sz) v2[i] = v0[i] * v1[i];
    IFandT(v2);
    return v2;
  }

  modint inv2 = modint(2).inv();
  void FWHT(vector<modint> &f, modint flag = 1 /* 1: 正变换, 1/2: 逆变换*/) {
    int n = f.size();
    for (int k = 1; k < n; k *=2){
      for (int i = 0; i < n; i += 2*k){
        for (int j = 0; j < k; j++){
          auto U = f[i+j];
          auto T = f[i+j+k];
          f[i+j]   = U + T;
          f[i+j+k] = U - T;
          f[i+j] *= flag;
          f[i+j+k] *= flag;
        }
      }
    }
  }
  void IFWHT(vector<modint> &f) {FWHT(f, inv2);}
  void FxorT(vector<modint> &f,int flag = 1) {FWHT(f, flag);}
  void IFxorT(vector<modint> &f) {IFWHT(f);}

  vector<modint> xor_convolution(vector<modint> &v0, vector<modint> &v1){
    const int sz = v0.size();
    FxorT(v0);
    FxorT(v1);
    vector<modint> v2(sz,0);
    rep(i,0,sz) v2[i] = v0[i] * v1[i];
    IFxorT(v2);
    return v2;
  }
};
// ----------- fwt -----------

void print(vector<modint> &arr){
  for(auto &v:arr) printf("%d ", v.val());
  printf("\n");
}

int main(){
  const int n = read();
  const int SIZE = 1<<n;
  // 长度2的幂次
  auto A0 = vector<modint>(SIZE,0);
  auto B0 = vector<modint>(SIZE,0);
  rep(i,0,SIZE) A0[i] = read();
  rep(i,0,SIZE) B0[i] = read();

  // --- or ---
  {
    auto A = A0;
    auto B = B0;
    auto C = FWT::or_convolution(A,B);
    print(C);
  }
  // --- and ---
  {
    auto A = A0;
    auto B = B0;
    auto C = FWT::and_convolution(A,B);
    print(C);
  }
  // --- xor ---
  {
    auto A = A0;
    auto B = B0;
    auto C = FWT::xor_convolution(A,B);
    print(C);
  }
  return 0;
}

```

## Ref

[我的FFT笔记](http://yexiaorain.github.io/Blog/2019-01-02-fftmul/)

[wikipedia Fast Walsh-Hadamard transform](https://en.wikipedia.org/wiki/Fast_Walsh%E2%80%93Hadamard_transform)

[Hadamard transform](https://en.wikipedia.org/wiki/Hadamard_transform)

[Walsh matrix](https://en.wikipedia.org/wiki/Walsh_matrix)

[Codeforces FWHT inner working](https://codeforces.com/blog/entry/71899)

[CSDN 快速沃尔什变换（FWT）详详详解](https://blog.csdn.net/a_forever_dream/article/details/105110089)

[luogu 模板练习](https://www.luogu.com.cn/problem/solution/P4717)
