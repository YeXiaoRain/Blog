---
title: Cartesian tree 笛卡尔树
date: 2024-12-20
tags:
  - 笛卡尔树
category:
  - algorithm
description:
---

# 笛卡尔树

二叉树 搜索树性质+ 堆性质

在范围最值查询、范围top k查询（range top k queries）等问题上有广泛应用。它具有堆的有序性，中序遍历可以输出原数列。

![](https://img2024.cnblogs.com/blog/3481216/202407/3481216-20240715114230327-1448318026.png)


上面是小根笛卡尔树

<!--more-->

## 性质

- 树上深度递增简单路径，权值不减
- 对于 $\forall u,v; u\le v;p=lca(u,v)$ ,那么以p为根的子树 恰好?能够? 覆盖$[u,v]$ 中全部位置
	- `a[p]` 是 $a[u..v]$中的最小值
## 构造

stack即可
- 维护 随着i增加，值单调下降
- 那么新增一个 v
	- 把左侧 <= v 的全pop
	- `[....u].push_back(v)`
		- v的左侧连 原来u的右侧
		- u的右侧连v


# 相关


[codeforces 2048 F](https://codeforces.com/contest/2048/problem/F)
