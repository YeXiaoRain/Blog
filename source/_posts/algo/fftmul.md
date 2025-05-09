---
title: FFT大数乘法(DFT,IDFT)
date: 2019-01-02 01:37:14
tags: [FFT]
category: [algorithm]
mathjax: true
---
to
FFT,IFT,DFT,IDFT

# FFT 大数乘法

不论FFT还是FFT大数乘法,网上都有"大量"的资料

但很多都看得云里雾里,不太能真正的理解

有几篇快要讲清了,但实际靠的 举例 来描述其可行性,

本篇希望从个人理解以及偏数学的角度来解释

# FFT 大数乘法要解决的问题

小学生都知道,乘法就是列竖式,然后进行一个数字一个数字的乘法再相加

那么对于一个`长度a`和`长度b`的两个数字相乘,进行了$O(ab)$次的运算,为了描述简便,假设 两个数字的长度都为$n=max(a,b)$,不足的补零,也就是$O(n^2)$的时间复杂度

那么如果题目是 长$50000$乘长$50000$的运算,那么用原始的乘法是无法在1s内解出的,

FFT可以做到$O(n \cdot log(n))$时间复杂度

# 计算逻辑总览

要计算 $a \cdot b$

且存在 函数$f:x \to X$,能使

1. $f:x \to X$ 的时间复杂度 $\le O(n \cdot log (n))$
2. $f^{-1}:X \to x$ 的时间复杂度 $\le O(n \cdot log (n))$, 注:是逆运算不是$-1$次方
3. $f^{-1}(g(f(a),f(b))) = a\cdot b$, 其中$g$的时间复杂度 $\le O (n \cdot log(n))$

用文字描述,大自为

> 如果$a,b$可以通过$f$函数变为$A,B$
> 且$A,B$通过$g$的运算变为$C$
> $C$再通过$f$的逆函数变为$c$
> 且$c == a \cdot b$的
> 那么原本$O(n^2)$的乘法,就可以用这样的方法替代,变为$O(n \cdot log(n))$

观察上面的式子,可以发现,如果有以下两个映射也可以实现

1. $f:x \to X$ 的时间复杂度 $\le O(n \cdot log (n))$
2. $g(f(a),f(b)) = a\cdot b$, 其中$g$的时间复杂度 $\le O(n \cdot log (n))$

之所以写成3条是因为我们具体用得方法, 和3条对应

所以简单的理解,为如果把$a,b$进行`低时间复杂度`的变形,再进行某种`低时间复杂度`的运算能变为$a\cdot b$,那么即可在`低时间复杂度`内算出$a\cdot b$

# 先抛开时间复杂度谈方法

$ f \* g= \mathcal{F}^{-1} \\\{ \mathcal{F} \\\{ f \\\} \cdot \mathcal{F} \\\{ g \\\} \\\}$

以上就是整个FFT大数乘法的所有数学公式,实际问题是离散傅立叶变换

分别解释符号

1. $\*$ 卷积 不是乘号
2. $\mathcal{F}$傅里叶变换
3. $\cdot$ 乘
4. $f,g$ 这里看作$n$元向量

## 卷积(连续的)

定义

${\displaystyle (f \* g)(t){\stackrel {\mathrm {def} }{=}}\ \int_{-\infty }^{\infty }f(\tau )g(t-\tau )\,d\tau }$

简单讲,卷积的结果$(f \* g)(t)$ 等于 $f(r)\cdot g(t-r)$的积分

这里就和乘法$a \cdot b = c$ 对应上了,在乘法过程中,不考虑进位, 每一位的取值都是所有整数

结果的第$t$位的原始值 = 所有$a$的$i$位 乘上 $b$的$t-i$位的和

$c_t = \sum_{i=0}^t a_i\cdot b_{t-i}$

## 傅里叶变换(连续的)

也就是上面的$\mathcal{F}$

${\displaystyle {\hat {f}}(\xi )=\int_{-\infty }^{\infty }f(x)\ e^{-2\pi ix\xi }\,dx,}$ (定义)

逆变换

${\displaystyle f(x)=\int_{-\infty }^{\infty }{\hat {f}}(\xi )\ e^{2\pi ix\xi }\,d\xi ,}$ (由正向定义推导)

## 证明 卷积的等式

要证明 $f * g= \mathcal{F}^{-1} \\\{ \mathcal{F} \\\{ f \\\} \cdot \mathcal{F} \\\{ g \\\} \\\}$

抄写自wiki

$\mathcal{F}\\\{f * g\\\}(\nu ) $

$= \int_{\mathbb{R}^n} \\\{f * g\\\} (z) \, e^{-2 \pi i z\cdot \nu}\, dz$ (傅立叶定义)

$= \int_{\mathbb{R}^n} \int_{\mathbb{R}^n} f(x) g(z-x)\, dx\, e^{-2 \pi i z\cdot \nu}\, dz.$ (卷积定义)

$= \int_{\mathbb{R}^n} f(x)\left(\int_{\mathbb{R}^n} g(z-x)e^{-2 \pi i z\cdot \nu}\,dz\right)\,dx.$(积分顺序)

$= \int_{\mathbb{R}^n} f(x) \left( \int_{\mathbb{R}^n} g(y) e^{-2 \pi i (y+x)\cdot\nu}\,dy \right) \,dx$,(换元$z=x+y$)

$= \int_{\mathbb{R}^n} f(x)e^{-2\pi i x\cdot \nu} \left( \int_{\mathbb{R}^n} g(y) e^{-2 \pi i y\cdot\nu}\,dy \right) \,dx$ (提取与$y$无关乘法因式)

$= \int_{\mathbb{R}^n} f(x)e^{-2\pi i x\cdot \nu}\,dx \int_{\mathbb{R}^n} g(y) e^{-2 \pi i y\cdot\nu}\,dy.$

$= {\mathcal {F}}\\\{f\\\}(\nu ) \cdot {\mathcal {F}}\\\{f\\\}(\nu)$

得证

## 小总结

至此,我们有了

1. 乘法 中按位 表示 和卷积对应
2. 上面要找的f,和傅里叶变换对应,$f^{-1}$和傅里叶逆变换对应
3. 有 $ f \* g $ 等式

所以

乘法按位表示 $\to$ 卷积 $\to$ ((函数的傅里叶变换)的 积)的傅里叶逆变换

当然这里证明的是连续的傅立叶和卷积,而我们下面用的是离散傅立叶(讲道理还是要单独证明的,这里并没有证明

# 接下来谈一谈,如何实现,并且能在时间复杂度内


先处理傅里叶变换的部分,首先离散傅里叶变换DFT的定义为 $x \to X$

$X_{k}=\sum _ {n=0}^{N-1}x _ {n}e^{-\frac{2 \pi i}{N}kn}\qquad k=0,\dots ,N-1.$

IDFT

$X_{k}=\frac{1}{N} \sum _ {n=0}^{N-1}x _ {n}e^{\frac{2 \pi i}{N}kn}\qquad k=0,\dots ,N-1.$

**注: 有的地方系数不是$1$和$\frac{1}{N}$,是两个 $\frac{1}{\sqrt{N}}$**, 本质上没有区别,也不影响后面的推导的核心内容

> 其中$i,\pi,e$为意义,单位虚数,元周率,自然对数, 这里主要是复平面的单位向量的知识点

> $N$取$2^{\lceil log_2n \rceil}$ 也就是长度取到2的幂次, 不足的补零

把这个式子用矩阵表示$X = Wx$,发现其实是一个"系数矩阵$W$"

${\displaystyle W=\left(\omega^{jk}\right)_ {j,k=0,\ldots ,N-1}}$

${\displaystyle W={\begin{bmatrix}
1&1&1&1&\cdots &1\\\\
1&\omega &\omega ^{2}&\omega ^{3}&\cdots &\omega ^{N-1}\\\\
1&\omega ^{2}&\omega ^{4}&\omega ^{6}&\cdots &\omega ^{2(N-1)}\\\\
1&\omega ^{3}&\omega ^{6}&\omega ^{9}&\cdots &\omega ^{3(N-1)}\\\\
\vdots &\vdots &\vdots &\vdots &\ddots &\vdots \\\\
1&\omega ^{N-1}&\omega ^{2(N-1)}&\omega ^{3(N-1)}&\cdots &\omega ^{(N-1)(N-1)}
\end{bmatrix}},{\displaystyle \omega =e^{-\frac{2\pi i}{N}}}}$

目标是求向量$X$,虽然求这个矩阵需要$O(n^2)$的时间,但可以不求矩阵,直接求向量$X$

希望能$O(n\cdot log(n))$求出列向量$X$

**行列按照$0$-index作为下标**, 那么有

 - 矩阵的 $上一列_ i \cdot \omega^i = 下一列_ i$

 - 在偶数列向量中,列上$i$和$i+\frac{n}{2}$互为相反数, 因为$\omega^{\frac{N}{2}} = -1$ (或见[youtube](https://www.youtube.com/watch?v=EsJGuI7e_ZQ&t=330s)

因此有递推式

$f(x,N,idx)$ = 初始向量为$x$, 大小为$N$(即要乘上$N$阶矩阵), 结果的第`idx` 个的值

对于 $idx < \frac{N}{2}$

$odd(x)$  表示 $x$的奇数位置上的值构成的长度$\frac{N}{2}$的向量

$even(x)$ 表示 $x$的偶数位置上的值构成的长度$\frac{N}{2}$的向量

$f(x,N,idx) = f(even(x),\frac{N}{2},idx) + w^k \cdot f(odd(x),\frac{N}{2},idx)$

$f(x,N,idx+\frac{N}{2}) = f(even(x),\frac{N}{2},idx) - w^k \cdot f(odd(x),\frac{N}{2},idx)$

函数是折半的,复杂度显然

至此傅里叶变换可以在$O(n\cdot log(n))$时间复杂度内实现

---

为了帮助理解上面这个递归式, 这里举个例子, 比如$N=8, idx = 2$ 求$f(x,8,2)$

$X_2 = 1\cdot x_0 + w^2\cdot x_1 + w^4 \cdot x_2 + w^6 \cdot x_3 + w^8 \cdot x_4 + w^{10}\cdot x_5 + w^{12} \cdot x_6 + w^{14} \cdot x_7 $

$X_{2+\frac{8}{2}} = X_{6} = 1\cdot x_0 + w^6\cdot x_1 + w^{12} \cdot x_2 + w^{18} \cdot x_3 + w^{24} \cdot x_4 + w^{30}\cdot x_5 + w^{36} \cdot x_6 + w^{42} \cdot x_7 $

注意到在$N=8$时,$w^4 = -1$, 所以

$X_{2+4} = 1\cdot x_0 - w^2\cdot x_1 + w^4 \cdot x_2 - w^6 \cdot x_3 + w^8 \cdot x_4 - w^{10}\cdot x_5 + w^{12} \cdot x_6 - w^{14} \cdot x_7 $

这不就是

$X_2 = (w^0 \cdot x_0 + w^4 \cdot x_2 + w^8 \cdot x_4 + w^{12} \cdot x_6) + w^2 (w^0 \cdot x_1 + w^4 \cdot x_3 + w^8\cdot x_5 + w^{12} \cdot x_7 ) $

$X_{2+4} = (w^0 \cdot x_0 + w^4 \cdot x_2 + w^8 \cdot x_4 + w^{12} \cdot x_6) - w^2 (w^0 \cdot x_1 + w^4 \cdot x_3 + w^8\cdot x_5 + w^{12} \cdot x_7 ) $

注意到$w_{2N}^{2k} = w_{N}^k$

而其中的 $w^0 \cdot x_0 + w^4 \cdot x_2 + w^8 \cdot x_4 + w^{12} \cdot x_6$ 正是$x$的偶数项 在 $N=4$ 时的$X_2$, 即$f(even(x), 4, 2)$

$w^0 \cdot x_1 + w^4 \cdot x_3 + w^8\cdot x_5 + w^{12} \cdot x_7 $ 正是$x$的奇数项 在 $N=4$ 时的$X_2$,即$f(odd(x), 4, 2)$

---

那么$g$也就是其中的 按位乘 也就是简单的$O(n)$

最后 傅里叶逆变换, 可以注意到上面的公式只在 系数上多了一个负号,所以同理可以在$O(n \cdot log (n))$时间复杂度内实现

## 递归+原地

```cpp
#include <bits/stdc++.h>
using namespace std;

const double pi = acos(-1.0);

void FFT(complex<double> * A, int n /* size */, int flag /* 1:FFT,-1:IFFT*/) {
    if (n == 1) return;
    // assert((n & (n-1)) == 0); 一定要是2的幂次
    // e^(i*x) = cos(x)+i*sin(x)
    complex<double> Wm(cos(2 * pi / n), -sin(2 * pi / n) * flag);
    vector<complex<double> > tmp(n);
    int u = 0;
    for (int k = 1; k < n; k += 2, u++) tmp[u] = A[k]; // 奇数列
    for (int k = 0; k < n; k += 2) A[k / 2] = A[k]; // 偶数列
    for (int k = u, i = 0; k < n && i < u; k++, i++) A[k] = tmp[i];
    FFT(A        , n / 2, flag);
    FFT(A + n / 2, n / 2, flag);
    complex<double> W(1, 0); // 运算中是 Wm 的i 次方
    for (int i = 0; i < n / 2 ; i++){
        int j = n / 2 + i;
        auto U = A[i];
        auto T = W * A[j];
        A[i] = U + T;
        A[j] = U - T;
        W *= Wm;
    }
}

int main(){
  // 123*456 = 56088
  const int SIZE = 8; // 一定要是2的幂次
  complex<double> * a = new complex<double>[SIZE]{3,2,1,0,0,0,0,0};
  complex<double> * b = new complex<double>[SIZE]{6,5,4,0,0,0,0,0};
  FFT(a, SIZE, 1);
  FFT(b, SIZE, 1);
  complex<double> * c = new complex<double>[SIZE]{0,0,0,0,0,0,0,0};
  for(int i = 0;i < SIZE;i++) c[i] = a[i] * b[i];
  FFT(c, SIZE, -1);
  for(int i = 0;i < SIZE;i++) c[i] /= SIZE;
  // print
  for(int i = 0;i < SIZE;i++) printf("(%.3lf,%.3lf)", c[i].real(), c[i].imag());
  printf("\n");
  for(int i = 0;i < SIZE-1;i++) { // 进位
    c[i+1] += int(c[i].real() / 10);
    c[i] -= int(c[i].real() / 10) * 10;
  }
  for(int i = 0;i < SIZE;i++) printf("(%d)", int(c[i].real()));
  printf("\n");
  return 0;
}
```

## 递推+原地

注意,以下代码其中 for m 的部分应该是从2 开始直到n,仅仅是看上去简便,这里处理的时候 把所有对应位置都乘上了2,所以对应cos,sin等等与m相关的都变了

```cpp
#include <bits/stdc++.h>
using namespace std;

#define rep(i,a,n) for (int i=a;i < n;i++)
const double pi = acos(-1.0);

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

int getlog2(int n){
  return 31 - __builtin_clz(n);
}

void FFT(vector<complex<double> > &A, int flag /* 1:FFT,-1:IFFT */) {
  int n = A.size();
  if(n == 1) return ;
  assert((n & (n-1)) == 0); // 2 的幂次
  int lgn = getlog2(n);
  // 相当于 上面 多次递归每个位置放到的最终位置, 直接计算位置, 而神奇的是刚好 位置 = 原位置的按照长度lgn的bit翻转
  rep(i, 0, n) {
    int j = rev(i, lgn);
    if (j > i) swap(A[i], A[j]);
  }
  // 逻辑和递归里一样了, 区别是 这里不像递归里下标连续, 需要计算下标, 好在还是顺序的
  rep(pwr, 0, lgn){
    int m = 1 << pwr;
    complex<double> Wm(cos(pi / m), -sin(pi / m) * flag);
    for (int k = 0; k < n; k += (m<<1)) {
      complex<double> W(1, 0);
      rep(j, 0, m) {
        auto U = A[k + j];
        auto T = W * A[k + j + m];
        A[k + j] = U + T;
        A[k + j + m] = U - T;
        W *= Wm;
      }
    }
  }
}

int main(){
  // 123*456 = 56088
  const int SIZE = 8; // 一定要是2的幂次
  auto a = vector<complex<double> >{3,2,1,0,0,0,0,0};
  auto b = vector<complex<double> >{6,5,4,0,0,0,0,0};
  FFT(a, 1);
  FFT(b, 1);
  auto c = vector<complex<double> >(8,0);
  for(int i = 0;i < SIZE;i++) c[i] = a[i] * b[i];
  FFT(c,-1);
  for(int i = 0;i < SIZE;i++) c[i] /= SIZE;
  // print
  for(int i = 0;i < SIZE;i++) printf("(%.3lf,%.3lf)", c[i].real(), c[i].imag());
  printf("\n");
  for(int i = 0;i < SIZE-1;i++) { // 进位
    c[i+1] += int(c[i].real() / 10);
    c[i] -= int(c[i].real() / 10) * 10;
  }
  for(int i = 0;i < SIZE;i++) printf("(%d)", int(c[i].real()));
  printf("\n");
  return 0;
}
```

# 实例代码

[CF R488 Div1 E ACCEPTED](https://codeforces.com/contest/993/submission/47860243)

# 相关延伸

有没有觉得double这种东西用起来就感觉很危险,那么也的确有叫做NTT `https://en.wikipedia.org/wiki/Discrete_Fourier_transform_(general)#Number-theoretic_transform`的方法来 实现大数乘法,但没有精度的问题需要担心.

另外建议 PI取 `const double pi = acos(-1.0);` 而不要手动输入

比如下面的R488 的第43个点 就因为我前面采用手动输入一直过不了

# 练习题目

[CF EDU57 G](https://codeforces.com/contest/1096/problem/G)

[CF R488 Div1 E](https://codeforces.com/problemset/problem/993/E)

# 参考

[Convolution](https://en.wikipedia.org/wiki/Convolution)

[Convolution theorem](https://en.wikipedia.org/wiki/Convolution_theorem)

[Multiplication](https://en.wikipedia.org/wiki/Multiplication_algorithm)

[Fourier transform](https://en.wikipedia.org/wiki/Fourier_transform)

[DFT](https://en.wikipedia.org/wiki/Discrete_Fourier_transform)

[FFT](https://en.wikipedia.org/wiki/Fast_Fourier_transform)

[DFT matrix](https://en.wikipedia.org/wiki/DFT_matrix)

[YouTube - The Fast Fourier Transform Algorithm](https://www.youtube.com/watch?v=EsJGuI7e_ZQ)

