---
title: Lagrange inversion theorem
date: 2021-10-09
tags:
  - NTT
  - 拉格朗日反演
category:
  - algorithm
description: 拉格朗日反演
---

# Lagrange inversion theorem 拉格朗日反演

## 解决的问题

给定F(x), 找G(x) 使得 G(F(x)) = x, 也就是找反函数

**这里有一点要用到,但是没有证明的是 $G(F(x)) = x$ 则 $F(G(x)) = x$**, 只能说在$F(x)$的值域内$F(G(F(x)) = F(x)$即$F(G(x)) = x$可以证明, 但在值域外不知道如何证明...

## 结论

如果$F,G$满足

- 0次项系数均为0: $[x^0]F(x)=[x^0]G(x)=0$
- 1次项系数均非0: $[x^1]F(x) \neq 0,[x^1]G(x) \neq 0$

那么 $\lbrack x^n \rbrack G(x)^k = \frac{k}{n} \lbrack x^{n-k} \rbrack \left(\frac{x}{F(x)}\right)^n.$

$\lbrack x^n \rbrack G(x) = \frac{1}{n} \lbrack x^{n-1} \rbrack \left(\frac{x}{F(x)}\right)^n.$

## 证明

辅助lemma: 任何 $F(0)=0$(0次系数为0), $F'(0)\neq 0$ (?存在非0次的非0系数?????), 有对于$\forall k \in \mathbb{Z}$

$\lbrack x^{-1} \rbrack F'(x) F(x)^k = \lbrack k = -1\rbrack$

即$k=-1$时$-1$次系数为$1$,否则$-1$次系数为$0$

证明lemma:

对于$k\neq -1$, 显然求导法则$\displaystyle F'(x) F(x)^k = \frac{\left ( F(x)^{k+1} \right)'}{k+1}$, 所以$\le 0$的x的幂次的系数都是0

对于$k = -1$, $F(x) = \sum_{i>0} a_i x^i$

$\displaystyle \frac{F'(x)}{F(x)} = \frac{a_1+2a_2x+3a_3x^2+\cdots}{x(a_1+a_2x+a_3 x^2+\cdots}= x^{-1} \frac{1 + 2\frac{a_2}{a_1}x + \cdots}{1 + \frac{a_2}{a_1}x + \cdots}$

也就是右侧这个分式除完以后是$1+k_1x+k_2x^2+\cdots$的样子, 因此 -1 次方的系数是 1, lemma 证毕.

这里 注意到 像$\frac{1}{1-x}$这种 对应的 $x^{-1}$的系数是0,因为它虽然写在分母上，但实际是泰勒展开到正，而$\frac{1}{x}$ 是不能在0点泰勒展开成正的?而去查 1/x的泰勒展开，都是在点1的展开

---

因此$G(F(x))^k = x^k,k\ge 1,k\in \mathbb{Z}$, 的$G$ 满足条件

$(\sum_{i} ([x^i]G^k(x))F(x)^i)'\cdot F'(x) = kx^{k-1}$ (  同时对$x$求导, 以及按位展开式 $G^k(x)=\sum_{i}([x^i]G^k(x))x^i$

展开$\sum_i i(\lbrack x^i\rbrack G^k(x) ) F(x)^{i-1} F'(x) = kx^{k-1}$, (基本的求导法则 $(ax^i)' = iax^{i-1}$, 注意到前两项都是常系数 而非生成函数

$\sum_{i} i (\lbrack x^i \rbrack G^k(x)) F^{i-1-n}(x) F'(x) = kx^{k-1}F^{-n}(x).$ ( 同乘上$F^{-n}$, 这里想用lemma, 也就是$[x^{-1}]F^?(x)F'(x)$, 同时最终目标是$[x^?]G(x)$

$\lbrack x^{-1}\rbrack \left(\sum_{i} i (\lbrack x^i \rbrack G^k(x)) F^{i-1-n}(x) F'(x)\right) = \lbrack x^{-1}\rbrack \left(kx^{k-1}F^{-n}(x)\right).$ (提取$-1$次项目的系数

因为左侧$i (\lbrack x^i \rbrack G (x))$ 整个都是系数, 以及上面的lemma, 左侧只有$i-1-n=-1$即$i=n$时, $[x^{-1}]F^{i-1-n}(x)F'(x)$生成系数的内容才为$1$,其它则是$0$,

$n[x^n]G^k(x) = [x^{-1}]kx^{k-1}F^{-n}(x)$

变形一下,就有了最初要证明的$\displaystyle \lbrack x^n \rbrack G(x) = \frac{k}{n} \lbrack x^{n-k} \rbrack \left(\frac{x}{F(x)}\right)^n.$

---

这玩意 百科上说建立了函数方程和幂级数之间的联系 !!??

## 使用示例: 卡特兰数Catalan number

$c_0 = 1$

$c_{n+1} = \sum_{i=0}^n c_{i} \cdot c_{n-i}$

令$C$为以卡特兰数 1,1,2,5,14为系数的生成方程

令$F(x) = C(x) - 1$, 保证0次项系数为0, 1次系数非0

那么$F(x) = x(F(x)+1)^2$ , 根据卡特兰数本身推导的定义的到的

令$G(x) = \frac{x}{(x+1)^2}$

那么有$G(F(x)) = \frac{F(x)}{(F(x)+1)^2} = x$

那么$c_n$ 就有了

因此

$\begin{aligned} [x^n]F(x) &= \frac{1}{n} \lbrack x^{n-1} \rbrack \left(\frac{x}{G(x)}\right)^n \\\\ &= \frac{1}{n} \lbrack x^{n-1} \rbrack (x + 1)^{2n} \\\\ &= \frac{1}{n} \binom{2n}{n-1} = \frac{1}{n+1} \binom{2n}{n}, \end{aligned}$


## 相关

https://atcoder.jp/contests/abc222/editorial/2765

abc222ex

[拉格朗日反演](https://baike.baidu.com/item/%E6%8B%89%E6%A0%BC%E6%9C%97%E6%97%A5%E5%8F%8D%E6%BC%94/20844121)

[超理论坛 拉格朗日反演](https://chaoli.club/index.php/6072)

[洛谷 拉格朗日反演](https://www.luogu.com.cn/blog/tiw-air-oao/post-ke-pu-xiang-la-ge-lang-ri-fan-yan-di-ji-zhong-xing-shi)

