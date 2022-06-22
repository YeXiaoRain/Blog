---
title: 反演
date: 2022-11-28
tags: [反演,二项式反演,stirling反演,子集反演,莫比乌斯反演]
category: [algorithm]
description: 反演
---

# 反演

已知$f$ 使得 $\displaystyle a_n = \sum_{i=0}^{\infty} f_{n,i} \cdot b_i$

求$g$ 满足 $\displaystyle b_n = \sum_{i=0}^{\infty} g_{n,i} \cdot a_i$

有不少的 $f_{n,> n} = 0$ 所以$\infty$ 对应的替换成$n$也是同样道理

> 有不少文章从意义角度, 或者直接给表达式,让你验证正确性来写的, 而我没有智力, 总觉得很怪和难以理解, 这篇主要通过EGF和假设没有预知能力来写

## 基本理论

对于一个明确反演, $f$实际是给定的常数序列, 看成**矩阵乘法**有(其中$a,b$ 为列向量)

$a = M_f\cdot b$

则$b = M_f^{-1}\cdot a = M_g \cdot a$

即$M_f \cdot M_g = I$ (单位矩阵)

即$\displaystyle \sum_{k=0}^{\infty} M_{f,i,k} M_{g,k,j} = \lbrack i=j \rbrack $ 是充要条件

一般题目中 知道$a$与$f$, 需要求$b$时使用

下面一般步骤首先建立分别的EGF, 然后通过正向得到两个EGF的等价关系, 最后转换等价关系推得逆向的递推式

egf(指数形 生成 函数), 构建EGF:

$\displaystyle F(x) = \sum_{i=0}^{\infty} a_{i} \frac{x^i}{i!}$

$\displaystyle G(x) = \sum_{i=0}^{\infty} b_{i} \frac{x^i}{i!}$

<!--more-->

## 常见反演

### 前缀和反演(差分)

从前缀和与差分开始 $\displaystyle a_n = \sum_{i=0}^n 1\cdot b_i \Longleftrightarrow b_n = a_n - a_{n-1}$

前缀和差分 本身不需要用到反演知识, 但从性质上也属于一种反演, 作为对比和样例很好说明问题

前缀和 $\displaystyle a_n = \sum_{i=0}^n 1\cdot b_i$

差分 $\displaystyle b_n = a_n - a_{n-1}$

以大小为$4$为例 [wolframalpha](https://www.wolframalpha.com/input?key=&i=%7B%7B1%2C0%2C0%2C0%7D%2C%7B1%2C1%2C0%2C0%7D%2C%7B1%2C1%2C1%2C0%7D%2C%7B1%2C1%2C1%2C1%7D%7D%5E-1)

$M_f = \displaystyle \begin{pmatrix} 1&0&0&0 \\\\ 1&1&0&0 \\\\ 1&1&1&0 \\\\ 1&1&1&1 \end{pmatrix}, M_g = \begin{pmatrix} 1&0&0&0 \\\\ -1&1&0&0 \\\\ 0&-1&1&0 \\\\ 0&0&-1&1 \end{pmatrix}, M_f\cdot M_g = \begin{pmatrix} 1&0&0&0 \\\\ 0&1&0&0 \\\\ 0&0&1&0 \\\\ 0&0&0&1 \end{pmatrix}$

---

$\displaystyle F(x) = \sum_{i=0}^{\infty} (\sum_{j=0}^i 1\cdot b_j) \frac{x^i}{i!}$

$\displaystyle = \sum_{j=0}^{\infty} b_j \sum_{i=j}^{\infty} \frac{x^i}{i!}$

有$\displaystyle \int F(x) dx = \sum_{j=0}^{\infty} b_j \sum_{i=j}^{\infty} \frac{x^{i+1}}{(i+1)!} = \sum_{j=0}^{\infty} b_j \sum_{i=j+1}^{\infty} \frac{x^{i}}{i!}$

即 $F(x) - (\int F(x) dx) = \sum_{j=0}^{\infty} b_j (\sum_{i=j}^{\infty} \frac{x^{i}}{i!} -\sum_{i=j+1}^{\infty} \frac{x^{i}}{i!}) = \sum_{j=0}^{\infty} b_j \frac{x^j}{j!} = G(x)$

即$\displaystyle \sum_{i=0}^{\infty} b_i \frac{x^i}{i!} = G(x) = F(x) - (\int F(x) dx) = \sum_{i=0}^{\infty} (a_i - a_{i-1}) \frac{x^i}{i!}$

同样得到了$b_i = a_i-a_{i-1}$

---

二维前缀和

两个维度在运算上其实互不影响, 所以两个维度的逆运算也是互不影响

### 二项式反演

#### $a_n = \sum_{i=0}^n \binom{n}{i} (-1)^i b_i \Leftrightarrow b_n = \sum_{i=0}^n \binom{n}{i} (-1)^i a_i$

正向

$\displaystyle F(x) = \sum_{i=0}^{\infty} (\sum_{j=0}^i \binom{i}{j} (-1)^j b_j) \frac{x^i}{i!}$

$\displaystyle = \sum_{j=0}^{\infty}(-1)^j b_j \sum_{i=j}^{\infty} \binom{i}{j} \frac{x^i}{i!}$

$\displaystyle = \sum_{j=0}^{\infty} (-1)^j \frac{b_j}{j!} x^j \sum_{i=j}^{\infty} \frac{1}{(i-j)!} x^{i-j}$

$\displaystyle = \sum_{j=0}^{\infty} (-1)^j \frac{b_j}{j!} x^j \sum_{i=0}^{\infty} \frac{1}{i!} x^i$

$\displaystyle = \sum_{j=0}^{\infty} \frac{b_j}{j!} (-x)^j \sum_{i=0}^{\infty} \frac{1}{i!} x^i$

$\displaystyle = \sum_{j=0}^{\infty} \frac{b_j}{j!} (-x)^j e^{x}$

$\displaystyle = G(-x) e^x$

反过来

$\displaystyle \sum_{i=0}^{\infty} b_i \frac{x^i}{i!} = G(x) = F(-x) e^{-(-x)} = F(-x) e^{x}$

这里依然可以像上面展开, 但是实际上发现 $G$和$F$之间是相同的转化关系 所以对称直接就有了, 不需要再推一次

#### 另一个形式 $a_n=\sum \limits_{i=n}^{\infty} {i\choose n} b_i \Leftrightarrow b_n = \sum\limits_{i=n}^{\infty}(-1)^{i-n}{i\choose n} a_i$

$\displaystyle F(x) = \sum_{i=0}^{\infty} (\sum_{j=i}^{\infty} \binom{j}{i} b_j) \frac{x^i}{i!}$

$\displaystyle = \sum_{j=0}^{\infty} j! b_j \sum_{i=0}^j \frac{x^i}{i!(j-i)!i!}$

并不能搞, 那就先变形一下$a'_ n = n! a_n,b'_ n = n! b_n$

即要证 $a'_ n=\sum\limits_{i=n}^{\infty} \frac{b'_ i}{(i-n)!} \Leftrightarrow b'_ i = \sum\limits_{i=n}^{\infty}(-1)^{i-n} \frac{a'_ i}{(i-n)!}$

$\displaystyle F(x) = \sum\limits_{i=0}^{\infty} (\sum_{j=i}^{\infty} \frac{b'_ j}{(j-i)!}) \frac{x^i}{i!}$

$\displaystyle = \sum\limits_{j=0}^{\infty} b'_ j \sum_{i=0}^{j} \frac{x^i}{(j-i)!i!}$

$\displaystyle = \sum\limits_{j=0}^{\infty} \frac{b'_ j}{j!} \sum_{i=0}^{j} \binom{j}{i} x^i$

$\displaystyle = \sum\limits_{j=0}^{\infty} \frac{b'_ j}{j!} (1+x)^j$

$=G(1+x)$

反过来

$\displaystyle \sum_{i=0}^{\infty} b'_ i \frac{x^i}{i!} =G(x)=F(x-1)=\sum_{i=0}^{\infty} a'_ i \frac{(x-1)^i}{i!}$

$\displaystyle =\sum_{i=0}^{\infty} a'_ i \frac{\sum_{j=0}^i \binom{i}{j} x^j (-1)^{i-j}}{i!}$

$\displaystyle =\sum_{i=0}^{\infty} a'_ i \sum_{j=0}^i \frac{x^j (-1)^{i-j}}{(i-j)!j!}$

$\displaystyle =\sum_{j=0}^{\infty} \frac{x^j}{j!}\sum_{i=j}^{\infty} a'_ i\frac{(-1)^{i-j}}{(i-j)!}$ 得证

注意到 $e^{-x} = \sum \frac{(-x)^{i}}{i!}$, 有些时候$a,b$在下标大于某个值$m$时都是$0$, 所以可以翻转$a_{i} = a_{m-i}$

相当于$a,b$生成函数之间有 $a(x)=y(x)e^{-x}$, 这里还可以快速对序列 $a$ 和 $b$进行转换

### Stirling反演

$\displaystyle a_{n}=\sum_{k=0}^{n} {\begin{Bmatrix}n\\\\ k\end{Bmatrix}} b_{k} \Leftrightarrow b_{n}=\sum_{k=0}^{n}{\begin{bmatrix}n\\\\ k\end{bmatrix}} a_{k}$

> 注: 这里的 第一类stirling数是带符号的, 如果要写成不带符号的则是$\lbrack \begin{matrix}n\\\\ k\end{matrix} \rbrack (-1)^{n-k}$

同样的原理 ${\displaystyle {\widehat {F}}(z)={\widehat {G}}\left(e^{z}-1\right)}$

---

$\displaystyle F(x) = \sum_{i=0}^{\infty} (\sum_{j=0}^i \lbrace \begin{matrix} i \\\\ j \end{matrix} \rbrace b_j)\frac{x^i}{i!}$

$\displaystyle = \sum_{j=0}^{\infty} b_j \sum_{i=j}^{\infty} \lbrace \begin{matrix} i \\\\ j \end{matrix} \rbrace \frac{x^i}{i!}$

$\displaystyle = \sum_{j=0}^{\infty} b_j \frac{(e^x-1)^j}{j!}$

$= G(e^x-1)$

反过来

$\displaystyle \sum_{i=0}^{\infty} b_i \frac{x^i}{i!} = G(x) = F(\ln(x+1)) = \sum_{i=0}^{\infty} a_i \frac{(\ln(x+1))^i}{i!}$

$\displaystyle = \sum_{i=0}^{\infty} a_i (\sum_{j=i}^{\infty} \lbrack \begin{matrix} j \\\\ i \end{matrix}\rbrack \frac{x^j}{j!})$

$\displaystyle = \sum_{j=0}^{\infty} \frac{x^j}{j!} \sum_{i=0}^{j} a_i \lbrack \begin{matrix} j \\\\ i \end{matrix}\rbrack$

### 莫比乌斯反演

$\displaystyle a_n=\sum_{i\mid n} b_i \Leftrightarrow b_n=\sum_{i\mid n}\mu(\frac{n}{i}) a_i$

$\displaystyle b_n = \sum_{i\mid n} b_i \cdot [i=n]$

$\displaystyle = \sum_{i\mid n} b_{\frac{n}{i}} \cdot [i=1]$

$\displaystyle = \sum_{i\mid n} b_{\frac{n}{i}} \sum_{d\mid i} \mu(d)$

$\displaystyle = \sum_{d\mid n} \mu(d) \sum_{d\mid i,i\mid n} b_{\frac{n}{i}}$

$\displaystyle = \sum_{d\mid n} \mu(d) \sum_{d\mid \frac{n}{k},k\mid n} b_k $

$\displaystyle = \sum_{j\mid n} \mu(\frac{n}{j})\sum_{\frac{n}{j} \mid \frac{n}{k},k\mid n} b_k$

$\displaystyle = \sum_{j\mid n} \mu(\frac{n}{j}) \sum_{k \mid j} b_k$

$\displaystyle = \sum_{j\mid n} \mu(\frac{n}{j}) a_j $


---

莫反一般配合$\lbrack n = 1 \rbrack$使用,

因为$\displaystyle \sum_{d\mid n}\mu (d)={\begin{cases}1&{\text{if }}n=1,\\\\ 0&{\text{if }}n>1.\end{cases}}$

这个根据wikipedia 似乎也可以 生成函数搞, 但实际操作起来还是 直接推导简单

### 子集反演

$\displaystyle g(S) = \sum_{T \subseteq S} f(T) \Leftrightarrow f(S) = \sum_{T\subseteq S} (-1)^{|S-T|} g(T)$

核心原理就是奇偶正负抵消

类似 莫比乌斯的$\lbrack n=1\rbrack$ , 这里需要的工具是$\displaystyle \lbrack S = \varnothing \rbrack$

$h(S) = \sum_{T\subseteq S} (-1)^{|S-T|}$

$=\sum_{i=0}^{|S|} \binom{|S|}{i} (-1)^{|S|-i}$

$=(1-1)^{|S|}$

$\displaystyle =\lbrack S = \varnothing \rbrack$

---

因此

$\displaystyle f(S) = \sum_{Q\subseteq S} f(Q) \lbrack S-Q = \varnothing \rbrack$

$\displaystyle = \sum_{Q\subseteq S} f(Q) h(S-Q)$

$\displaystyle = \sum_{Q\subseteq S} f(Q) \sum_{T\subseteq S-Q} (-1)^{|S-Q-T|}$

$\displaystyle = \sum_{Q\subseteq S} f(Q) \sum_{T+Q\subseteq S} (-1)^{|S-(T+Q)|}$

$\displaystyle = \sum_{Q\subseteq S} f(Q) \sum_{Q\subseteq R \subseteq S} (-1)^{|S-R|}$

$\displaystyle = \sum_{R\subseteq S} (-1)^{|S-R|} \sum_{Q\subseteq R} f(Q) $

$\displaystyle = \sum_{R\subseteq S} (-1)^{|S-R|} g(R)$

### Min-Max容斥

$\displaystyle \max(S) = \sum_{T\subseteq S} (-1)^{|T|-1} \min(T)$, 核心原理就是奇偶正负抵消

对称 $\displaystyle \min(S) = \sum_{T\subseteq S} (-1)^{|T|-1} \max(T)$, 相当于所有元素乘上$-1$

在期望中使用

$\displaystyle E(\max(S)) = E(\sum_{T\subseteq S} (-1)^{|T|-1} \min(T)) = \sum_{T\subseteq S} (-1)^{|T|-1} E(\min(T))$

---

设集合内元素从小到大 排序了

$\displaystyle \sum_{T\subseteq S} (-1)^{|T|-1} \min(T)$

$\displaystyle = \sum_{T\subseteq S,a_i = min(T) } (-1)^{|T|-1} a_i$, 直接指定$T$

$\displaystyle = \sum_{i=1}^{n} a_i \sum_{T\subseteq S,a_i = min(T) } (-1)^{|T|-1}$, 先指定$a_i$ 再指定$T$

$\displaystyle = \sum_{i=1}^{n} a_i \sum_{j=1}^{n-i+1} \sum_{T\subseteq S,a_i = min(T),|T|=j } (-1)^{j-1}$, 先指定$a_i$, 再指定$T$的大小

$\displaystyle = \sum_{i=1}^{n} a_i \sum_{j=1}^{n-i+1} (-1)^{j-1} \sum_{T\subseteq S,a_i = min(T),|T|=j }$

$\displaystyle = \sum_{i=1}^{n} a_i \sum_{j=1}^{n-i+1} (-1)^{j-1} \binom{n-i}{j-1}$

$\displaystyle = \sum_{i=1}^{n} a_i \sum_{j=0}^{n-i} (-1)^{j} \binom{n-i}{j}$

$\displaystyle = \sum_{i=1}^{n} a_i (1-1)^{n-i}$

$\displaystyle = a_n$

$\displaystyle = \max(S_n)$


### 单位根反演

#### FFT

#### NTT

#### FWT

## 示例代码

### 二项式反演

### Stirling反演

### 莫比乌斯反演

### 子集反演

### Min-Max容斥

### 单位根反演

#### FFT

#### NTT

#### FWT

## 相关文章

[wikipedia 生成函数反演](https://en.wikipedia.org/wiki/Generating_function_transformation)

https://vfleaking.blog.uoj.ac/slide/87

[洛谷 炫酷反演魔术](https://www.luogu.com.cn/blog/command-block/xuan-ku-fan-yan-mo-shu)

---

[abc 272 中使用二项式反演](../../atcoder/abc/272)

[abc 278 stirling反演](../../atcoder/abc/278)

[abc 242 min-max容斥](../../atcoder/abc/242)

[abc 215 子集反演](../../atcoder/abc/215)

[莫比乌斯反演](../MobiusInversionFormula)
