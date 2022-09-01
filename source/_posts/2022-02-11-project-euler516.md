---
title: project euler 516 (5-smooth,二分,前缀和,prime)
date: 2022-02-11 10:37:14
tags: [数学]
category: [Project Euler]
mathjax: true
---

# 题目

https://projecteuler.net/problem=516

## 题意

求` n < 10^12`, `phi(n)`的值仅包含质因数2,3,5的所有`n`的和，mod`2^32`

# 题解

## 欧拉函数

$\phi(n) = n(1-\frac{1}{p_0})(1-\frac{1}{p_1})(1-\frac{1}{p_2})\cdots$

其中$p_i$均为$n$的质数因数

性质:

$\phi(x)\phi(y)=\phi(xy), gcd(x,y)==1$

$\phi(prime)\phi(x)=(prime-1)\phi(x), gcd(x,prime)==1$

## 题目转换

$n = 2^{q_0}3^{q_1}5^{q_2} p_0p_1p_2\cdots$

其中$p_i + 1$ 是只包含$2,3,5$ 质因子的数

## 广搜2,3,5

$x => 2x,3x,5x$

广搜小于$10^{12}$的所有只包含质因数$2,3,5$的数

## 质数判别

小于$2^{64}$里的质因数可以 Miller-Robin算法 常数级别 判别

## 二分

$n = 2^{q_0}3^{q_1}5^{q_2} p_0p_1p_2\cdots$

后面又可以拆分成$2^{q_0}3^{q_1}5^{q_2}$ 和 $p_0p_1p_2\cdots$

右边每个质数最多一次方，直接生成所有的积，左边还是上面求的

要两部分数组内容乘积小于n, 可以左侧枚举二分右侧，右侧枚举二分左侧都一样的, 通过前缀和辅助得到和

# Ref

[Euler's totient function](https://en.wikipedia.org/wiki/Euler%27s_totient_function)
