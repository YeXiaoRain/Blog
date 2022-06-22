---
title: Stirling 斯特林数
date: 2023-01-06
tags: [stirling,stirling反演]
category: [algorithm]
description: 第一类第二类stirling数
---

# 第一类stirling数

$s(n,k) = \begin{bmatrix} n \\\\ m \\\\ \end{bmatrix}$ 表示n个不同元素, 划分成m个非空段(每个非空段 满足循环平移等价) 的方案数

(n个两两不同元素,划分为k个互不区分的非空**轮换**的方案数, 也就是 如果划分出 [1,2,3] 那么 和[2,3,1]等价和[3,1,2]等价, 但是和[3,2,1]等价


$\begin{bmatrix}n\\\\ k\end{bmatrix}=\begin{bmatrix}n-1\\\\ k-1\end{bmatrix}+(n-1)\begin{bmatrix}n-1\\\\ k\end{bmatrix}$ 一样的也是考虑 最后一个单独放还是插入到前面某个序列里

边界$\begin{bmatrix}n\\\\ 0\end{bmatrix}=[n=0]$

## 生成函数

构造生成函数 $F_n(x)=\sum\limits_{i=0}^n\begin{bmatrix}n\\\\ i\end{bmatrix}x^i$

根据递推公式$F_n(x)=(n-1)F_{n-1}(x)+xF_{n-1}(x)$

有 $F_n(x)=\prod\limits_{i=0}^{n-1}(x+i)=\dfrac{(x+n-1)!}{(x-1)!}$

<!--more-->

# 第二类stirling数

比第一类用得多

$\begin{Bmatrix} n \\\\ m \\\\ \end{Bmatrix}$表示n个不同元素放入m个无差别盒子且每个盒子非空的方案数

$n^k = \sum_{i=0}^k \begin{Bmatrix} k \\\\ i \end{Bmatrix} i! \binom{n}{i}$

k个球 放任意n个盒子 = binom(n,i) 选i个盒子会放球, S(k,i) = k个求拆成i个非空集合, i! 盒子不同,

$n^m=\sum_{k=0}^m \begin{Bmatrix} m \\\\ k \end{Bmatrix} n^{\underline k}$

k个球 放任意n个盒子 = k个求拆成i个非空集合, 盒子不同 第一个集合有n种盒子选法,第二个n-1种...,

---

$\begin{Bmatrix} n \\\\ m \\\\ \end{Bmatrix}=\begin{Bmatrix} n-1 \\\\ m-1 \\\\ \end{Bmatrix}+m\begin{Bmatrix} n-1 \\\\ m \ \end{Bmatrix}$ ,相当于考虑第n个数, 是单独一个,还是和前面某组合并

$\begin{Bmatrix} 0 \\\\ 0 \\\\ \end{Bmatrix}=1$

$\begin{Bmatrix} > 0 \\\\ 0 \\\\ \end{Bmatrix}=0$

通项 $s(n,k) = \sum_{i=0}^k \frac{(-1)^{k-i}i^n}{i!(k-i)!}$, 归纳可证


$\begin{Bmatrix} n \\\\ m \\\\ \end{Bmatrix}=\frac{1}{m !} \sum_{i=0}^{m}(-1)^{i} \left( \begin{array}{c}{m} \\\\ {i}\end{array}\right)(m-i)^{n} = \sum_{i=0}^{n}\frac{(-1)^i(n-i)^n}{i!(m-i)!}$ 可以卷积算

构造生成函数 $G_n(x)=\sum\limits_{i=0}^n\begin{Bmatrix}n\\\\ i\end{Bmatrix}x^i$

# 相关

[ABC 247Ex](../../atcoder/abc/247)

[ABC 278Ex](../../atcoder/abc/278)

[CF EDU 133F(1716F)](../../cf/edu/133-1716)

[反演](../Generating_function_transformation)

[百度百科 斯特林数](https://baike.baidu.com/item/%E6%96%AF%E7%89%B9%E6%9E%97%E6%95%B0/4938529)

[oi wiki 斯特林数](https://oi-wiki.org/math/combinatorics/stirling/)
