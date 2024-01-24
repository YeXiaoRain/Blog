---
title: Hall theorem
date: 2024-01-24
tags:
  - halls_theorem
  - 二分图
category:
  - algorithm
mathjax: true
---

# Hall's theorem, 霍尔定理

二分图 左侧$n$点,右侧$m$点, $n\le m$

二分图的最大匹配个数$=n$ 的充要条件, 左侧点$n$的任意大小$(=k)$的子集 连到右图的点的个数都满足$\ge k$

<!--more-->

必要性:

因为最大匹配$=n$,所以存在一个方案, 任意左侧子集$(=k)$的方案对应右侧的点都是$k$, 所以连接的一定 $\ge k$

充分性:

归纳法

显然$n = 1$时成立, 证明 $n成立 \to n+1成立$

若存在$k(\le n)$个左侧点对应可达右侧恰好是k个

那么存在一组k个到k个的匹配

注意到左侧$n+1$对应 右侧$\ge n+1$, 那么从左右分别去掉上面完成匹配的$k$个

那么左侧剩下$n+1-k$个点, 这些点连到右侧的点 $\ge n+1-k$, 这种情况是有方案有方案


如果上述不存在

则所有$k(<=n)$个左侧点,对应的是$\ge k+1$个右侧点

那么 任意取一个`1-1`的匹配, 那么剩下的$n$个左点对应的右点$\ge  k$个

所以归纳成立

## 相关

[wikipedia](https://zh.wikipedia.org/wiki/%E9%9C%8D%E7%88%BE%E5%A9%9A%E9%85%8D%E5%AE%9A%E7%90%86)

atcoder abc215H

atcoder abc317G

codeforces edu134 F