---
title: project euler 709 (OEIS A000111)
date: 2021-05-31 10:37:14
tags: [数学]
category: [Project Euler]
mathjax: true
---


# 题目

每次新增一个塑料袋

可以把偶数个之前的塑料袋放入这个新增的塑料袋

求n次后 的状态数

f(4)=5

f(8)=1385

求`f(24680)%1020202009`

# 打表

显然 OEIS A000111

# DP(n^3)


`dp[i][j] = ` 第i步,剩余j个袋子

`dp[i][j] = dp[i-1][j-1+d] * c(j-1+d,d), d = 0..i-j, step = 2,(i-j)%2=0`

试图优化,内部运算也没有摆脱`O(n^3)`, n在2w 搞不了

# DP(n^2)

`f(n+1) = `

0个放袋子n+1里`c(n,0) * f(0) * f(n)`

2个放袋子n+1里`c(n,2) * f(2) * f(n-2)` ,我们 不关心 这2个 和 这n-2个 内部的关系,而只关心谁在n+1袋子里,谁在袋子外,有了`c(n,2)`, 于是 这2个和n-2互不干扰,各自的结构只与其内部相关,所以方案数也就是f(2)和f(n-2)


2k个放袋子n+1里`c(n,2k) * f(2k) * f(n-2k)` ,我们 不关心 这2k个 和 这n-2k个 内部的关系,而只关心谁在n+1袋子里,谁在袋子外,有了`c(n,2k)`, 于是 这2k个和n-2k互不干扰,各自的结构只与其内部相关,所以方案数也就是f(2k)和f(n-2k)

`f(n+1) = sum( c(n,2k) * f(2k) * f(n-2k) ), k = 0..floor(n/2)`

令`g(n) = f(n)/(n!)`, 其实上面dp我也用了这个技巧,但是还是有剩余的阶乘,无法简化到递推

`g(n+1) * (n+1) = sum( g(2k) * g(n-2k)), k = 0..floor(n/2)`


# Ref

https://hiragn.hatenablog.com/entry/2020/12/01/031135

https://gist.github.com/hrgnz/10c4c3afb5a332c8ad3428327e6459c0#file-pe709a-nb

