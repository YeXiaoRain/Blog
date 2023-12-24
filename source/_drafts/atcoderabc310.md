---
title: Atcoder abc310
date: 2023-07-15
tags: []
category: [Atcoder,ABC]
description: Ex()
---

<https://atcoder.jp/contests/abc310/tasks>

# Ex - Negative Cost

h \in [1,1e18]

p = 0

n个([1,300]) ci [-300,300],di [1,1e9]

每次可以 任选一个(可重复选), p >= ci, 然后 p -= ci, h -= di

问最少多少次 让 h <= 0

3s

1024mb

## 我的思路

先预处理数据

sort {ci,di}

对于 ci <= cj, di >= dj, 舍去 {cj,dj}

因为首先单次ci代价越小,di越多越好

---

`dp[i][t][p] = `前i个 操作t次, p的结束值 能消耗最大的h

`dp[i][t+k][p-k*ci] = max dp[i-1][t][p]`

显然空间都存不下

---

考虑预处理后的数据

排序后前部分的 `-k*ci > 0`



<!--more-->

## 题解


## 代码


# 总结

Ex

# 参考

[官方题解]( https://atcoder.jp/contests/abc310/editorial/6801)

