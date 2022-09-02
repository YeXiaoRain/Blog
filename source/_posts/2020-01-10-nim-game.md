---
title: NIM's GAME
date: 2020-01-10 10:37:14
tags: [nim的游戏,博弈论,SG函数]
category: [algorithm]
mathjax: true
---

# 入门题目(Bash Game)

有一堆物品，两人轮流取,每次只能$[1,a]$个，最后取空的赢/输，求对策

假设你的对手取$x$个，有$1\le x \le a$,也就有$1 \le a+1-x \le a$,保证不论对手怎么取$x$，只要你取对应的$a+1-x$个就能保证剩余的个数 对$a+1$ 取模不变

控制到了不变量(对$a+1$取模不变)也就找到了解题的关键

# NIM(Nim Game)

## NIM 1

现在是两堆石头（可能相同个数，可能不同），每轮任选一堆，从该堆取任意正数个，最后取空的人赢/输

如果两堆相等，则对方任意取多少，你取相同的，总能维持一个不变`两堆的差值为0`

## NIM 2

变为n堆石头（每堆数量独立），取法和上题一致，最后取空的人赢/输

假设有偶数堆，且成对的相等，那么用上题的结论，然而，这里我们发现，上题无论初始状态如何，我们都能通过0步或者1步达到我们的平衡的状态/不变的状态，而这里如果假设是偶数堆和成对的相等，这样的状态并不是任意可达的。

对于数据小，又想不到“数学”方法去找平衡态，可以用递归搜索去做，不过不是本文要讲的内容。

然后是枚举，发现并不是只有上面的状态是必胜/必败

例如有石堆$1 2 3$，也是能做到最后取空的控制，说明 偶数堆且成对相等 和 必胜必败没 不全等只有被包含关系。

先直接上结论

所有石头堆的异或值为$0$，显然如果当前为$0$,那么任意操作会使异或值变成非0

假设异或值为$k \neq 0$，从数量为$a$的堆中取走，最后剩下$b$个，

那么取走的个数为$a-b \ge 0$,$k \oplus a \oplus b = 0$(原来的异或 去掉a 新增b)

所以$b = a \oplus k$也就是要证明存在a使得$a \ge a \oplus k$

$k$是所有数量的异或结果，所以$k$的最高位$1$一定存在于某个$v[i]$中

$v[i]$ 和 $v[i]\oplus k$在高于$k$的最高位的位,值是相等的，在$k$的最高位$v[i]$为1,而$v[i]\oplus k$为$0$，所以存在$a = v[i]$使得$a \ge a \oplus k$,所以任意异或非$0$的$k$可以一步操作转化为$0$。

综上任意状态，能够通过0步或者1步转化为异或和为0。并且异或和为0是一个可以交替进行并被控制的平衡态。

至于为什么是想到异或和，我说不出，这个结论我也是从其它地方拿来，只会证明。

反过来再看NIM 1,会发现，虽然说是控制值相等，同时也就是控制异或和相等。

# SG 函数

有向无环图上

$ \operatorname{mex}(S)=\min(\\\{x\\\}) \quad (x \notin S, x \in N) $

$\operatorname{mex}(S) = $集合$S$中不包含的最小非负整数

$ \operatorname{SG}(x)=\operatorname{mex}( \\\{ \operatorname{SG}(y) \| y是x的后继 \\\} ) $

边界也就是没有出度的点，$\operatorname{SG}(\emptyset)=0$

显然如果$SG(x) = 0$，那么它的所有后继$\ne 0$,如果$SG(x) \ne 0$, 那么一定存在一个后继$SG(y) = 0$

换句话说$SG(x) = 0$的任意操作走向一个$SG(y) \ne 0$ , 而$SG(x) \ne 0$ 你总可以找到一个操作$SG(y) = 0$

所以一定能控制$SG(x) = 0$ 的平衡态，也一定能通过0步，或1步达到这个平衡态。

所以如果我们用$SG(失败状态) = 0$, 然后状态之间加上有向边, 那么以此计算$SG$ 就可以知道每个状态是成功还是失败了

## 应用在NIM 2中

考虑单个石堆游戏

有 $SG(个数) = 个数$

于是$SG(state(c_1,c_2,c_3,\cdots)) = c_1 \oplus c_2 \oplus c_3 \oplus \cdots= SG(c_1) \oplus SG(c_2) \oplus SG(c_3) \oplus \cdots$

## 对于多个游戏的组合(n个有向图)

结论, 一个游戏的$SG$函数值等于各个游戏的$SG$函数值的$Nim$ 和(异或和)

$\operatorname{SG}(s_1) \oplus \operatorname{SG}(s_2) \oplus \ldots \oplus \operatorname{SG}(s_n)$

同上面证明NIM 2的过程，假设所有异或和为$k$ (总状态)，我们能得到

存在至少一个$i$满足$SG(s_i) > SG(s_i)\oplus k$,对于第$i$个游戏，$SG(s_i)\oplus k$是$SG(s_i)$ 的后继状态

因为注意到$SG$ 是通过$\operatorname{mex}$定义的意味着, 如果$SG(x) = w$, 那么 它一步是可以走到$0..w-1$的任意$SG$状态的, 这就是NIM二中的一堆里面任意取个数的意义一样

所以 $SG(state(s_1,s_2,s_3, \cdots)) = SG(s_1)\oplus SG(s_2)\oplus SG(s_3)\oplus \cdots $

# 参考

[game theory](https://oi-wiki.org/math/game-theory/)

[Sprague–Grundy_theorem](https://en.wikipedia.org/wiki/Sprague%E2%80%93Grundy_theorem)

