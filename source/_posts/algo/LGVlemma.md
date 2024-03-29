---
title: LGV 引理
date: 2022-07-22 22:24:00
tags: [LGV引理]
category: [algorithm]
mathjax: true
---

Lindström–Gessel–Viennot lemma

https://oi-wiki.org/graph/lgv/

前置知识, 图论基础,矩阵,行列式,高斯消元

适用于DAG上(有向无环图)

## 定义

$P$ 路径

$\omega(P) = $ 路径$P$上边权之积

点$u,v$

$e(u,v) = \sum_{P:u\to v} \omega(P)$每一条 $u$到 $v$ 的路径$S$,的$\omega(P)$之和

大小为n的 起点集合A,终点集合B, (点集内也可能有边, 满足DAG, 以及还有一些不是起点也不是终点的其它中间的点

$S$ 一组不相交的路径组(路径集合,包含所有起点终点): 任意两个路径$S_i,S_j$没有公共顶点

$\sigma(S)$ 表示一个具体的路径集合$S$中,$A$按照顺序($S_i$的起点是$A_i$)时, $B$的下标序列

$N(\sigma) = \sigma$的逆序对个数

系数矩阵

$M = \begin{bmatrix}e(A_1,B_1)&e(A_1,B_2)&\cdots&e(A_1,B_n) \\\\
e(A_2,B_1)&e(A_2,B_2)&\cdots&e(A_2,B_n) \\\\
\vdots&\vdots&\ddots&\vdots \\\\
e(A_n,B_1)&e(A_n,B_2)&\cdots&e(A_n,B_n)\end{bmatrix}$

<!--more-->

## 引理

其中$S$是不相交路径组

$\det(M)=\sum\limits_{S:A\rightarrow B}(-1)^{N(\sigma(S))}\prod\limits_{i=1}^n \omega(S_i)$


M的行列式的值是所有不相交路径的边权乘积的带符号数量和

---

证明:

由行列式定义

$\begin{aligned}
\det(M)&=\sum_{\sigma}(-1)^{N(\sigma)}\prod_{i=1}^ne(A_i,B_{\sigma_i})\\\\
&=\sum_{\sigma}(-1)^{N(\sigma)}\prod_{i=1}^n\left(\sum_{P:A_i\rightarrow B_{\sigma_i}}\omega(P)\right)\\\\
&=\sum_\sigma(-1)^{N(\sigma)}\sum_{\sigma=\sigma(S)}\prod_{i=1}^n \omega(S_i)\\\\
&=\sum_{S:A\rightarrow B} (-1)^{N(\sigma(S))} \prod_{i=1}^n \omega(S_i)
\end{aligned}$

第一步是行列式展开

第二步是,e等价替换

第三步是,神奇的分配率, $(\omega(A_1\to B_{\sigma_1}方案0) + \omega(A_1\to B_{\sigma_1}方案1) + \cdots) \cdot (\omega(A_2\to B_{\sigma_2}方案0) + \omega(A_2\to B_{\sigma_2}方案1) + \cdots) \cdot (\cdots)$

这个使用分配率乘开了就是 方案之间的$\omega$之乘积, 再求和

再换句话说,原来内部的求和的是针对指定的起始点$A_i$结束点$B_{\sigma_i}$, 而拆开以后,把一个路径组看作单位,对路径组中第$i$条路径($A_i$)开头的进行统计

第四步就是, 把上面按照一个行列式的$\sigma$作为贡献的单位来计算,变成一个具体的$S$来计算,也是求和分配

---

注意到上面仅证明了行列式能转换, 也保证了路径之间起点和终点互异, 但是**没有证明是不相交路径**

但注意到对于所有(起点终点两两不同)的路径组,这个表达式也成立

对路径集合划分,$U$为不相交路径组,$V$为相交路径组

$\begin{aligned}
&\sum_{S:A\rightarrow B} (-1)^{N(\sigma(S))} \prod_{i=1}^n \omega(S_i)\\\\
=&\sum_{U:A\rightarrow B} (-1)^{N(\sigma(U))} \prod_{i=1}^n \omega(U_i)+\sum_{V:A\rightarrow B} (-1)^{N(\sigma(V))} \prod_{i=1}^n \omega(V_i)
\end{aligned}$

要证明右侧$\sum_{V:A\rightarrow B} (-1)^{N(\sigma(V))} \prod_{i=1}^n \omega(V_i) = 0$ 即可

对于$V$中一个具体的路径组$S$,取最小的相交路径的二元组$(i,j)$

有路径$S_i: A_i \to u \to B_{\sigma(S)_ i}$, $S_j: A_j \to u \to B_{\sigma(S)_ j}$, 其中$u$是路径上首次相交的点(注意到是DAG,所以两条路径中都是首次

修改得到路径$S_i: A_i \to u \to B_{\sigma(S)_ j}$, $S_j: A_j \to u \to B_{\sigma(S)_ i}$

这样得到$S'$

首先乘积的部分一致$\prod_{i=1}^n \omega(S_i) = \prod_{i=1}^n \omega(S'_ i)$, 而逆序对变化为$1 = |N(\sigma(S)) - N(\sigma(S'))|$, 所以 $S$与$S'$的贡献互为相反数, 总贡献和为$0$

并且根据这个交换产生规则,$S$唯一映射到$S'$,$S'$也唯一映射到$S$, 且$S \neq S'$ ??????? ( 感觉有点没对, 这样构造并不能保证交换后 最小二元组还是$(i,j)$, 因为被交换的路径和$i$ 有交,变成$(i,k)$

但是整体思路还是可以用的, 就是找标识去构建对称,总贡献为0.

这里需要改变的是, 把S中所有相交路径的交点中取编号最小的u, 在u处相交的取最小的二元组$(i,j)$ 并交换u以后的部分, 这样 交换以后能保证, 所有交点不变, 所以u依然最小,而在u处相交的也不变,依然是$(i,j)$, 这才有一一对应的关系

综上, 所有V中的两两成对,贡献和为$0$, 因此$V$的总贡献为$0$

证毕

## 总结

这又是行列式知识, 每个乘积的正负号 = (-1)的逆序对次方 乘对应位置的积
