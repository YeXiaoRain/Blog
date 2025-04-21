---
title: min-max容斥
date: 2025-03-28
tags: [min_max,容斥原理]
category: [algorithm]
mathjax: true
---

## 基础

- 前置内容
  - 容斥原理
  - 全序

定理: 对于满足 全序 关系并且其中元素满足可加减性的序列 $\lbrace x_i \rbrace$，设其长度为 n，并设$S=\lbrace 1,2,3,\cdots,n \rbrace$，则有：
- $\max_{i\in S}{x_i}=\sum_{T\subseteq S}{(-1)^{|T|-1}\min_{j\in T}{x_j}}$
- $\min_{i\in S}{x_i}=\sum_{T\subseteq S}{(-1)^{|T|-1}\max_{j\in T}{x_j}}$

## 证明

- 我们需要集合满足
  - 全序: 任意两个基础元素可比较大小
  - 需要零元素
  - 然后每个元素有逆元，这里(-1)乘法表示取逆元
  - 不需要可加，这里的加号只是把不同的连在一起
- 例子 {🍟,🍔,🌭}
  - 全序 🍟 < 🍔 < 🌭
  - 零元 0+(🍟)=🍟
  - 逆元 (🍟)+(-🍟)=0

$🌭 =\max (\lbrace🍟,🍔,🌭 \rbrace)$

$= \sum_{T\subset S} (-1)^{|T|-1} \min(T)$

$= (-1)^{1-1}\min(\lbrace🍟 \rbrace)+(-1)^{1-1}\min(\lbrace 🍔 \rbrace)+(-1)^{1-1}\min(\lbrace 🌭 \rbrace)  + (-1)^{2-1}\min(\lbrace 🍟,🍔  \rbrace)+(-1)^{2-1}\min(\lbrace 🍔, 🌭 \rbrace)+(-1)^{2-1}\min(\lbrace 🌭,🍟 \rbrace)+(-1)^{3-1}\min(\lbrace 🍟,🍔,🌭 \rbrace)$

$=🍟+🍔+🌭+(-🍟)+(-🍔)+(-🍟)+🍟$

$=🌭$

--- 

简单的逻辑证明，含有最大元和未含有最小元的产生1-1 对应的关系，其中(空集)和(只含有最大元)的1-1对应
- 那么 这个1-1对应导致了一个他们的min相同，而(-1)幂次一个奇一个偶，所以都抵消了
- 所以只剩下 只含有最大元的



## 用例

首先这个玩意很直接，几乎不会直接使用

然而 在概率论中计算期望会用到，

$E(\max_{i\in S}x_i)=\sum_{T\subset S}(-1)^{|T|-1} E(\min_{j\in T} x_j)$ 

$E(\min_{i\in S}x_i)=\sum_{T\subset S}(-1)^{|T|-1} E(\max_{j\in T} x_j)$ 

不同的是，这里$x_i$更多是其中一个自由变量，有时写作$X_i$
- 证明: 其实一句话，E是 线性函数

## 进一步的 k-th min/max

$\text{k-th} \max_{i\in S} x_i =\sum_{T\subset S,|T|\ge k} (-1)^{|T|-k} \binom{|T|-1}{k-1}\min_{j\in T} x_j$
- 证明: 其实类似的, 记结果为😺, 我们固定$\min$ 来看抵消
  - $\min =$😺 时，那么只能选最大k个, 那么就是$(-1)^{k-k}\binom{k-1}{k-1} 😺=😺$
  - $\min < 😺$ 时 希望证明 $\sum_{t=k}^{n+1} \binom{n}{t-1} (-1)^{t-k}\binom{t-1}{k-1} =0, n \ge t-1 \ge k-1 \ge 0$
    - n表示 比😺 大的个数
    - 在其中选了t-1个（加上😺就是t个） 
    - 这种情况下的贡献 就是后一半
    - 为了简洁，用$t_{new}=t-1,k_{new}=k-1$替换
    - 希望证明 $\sum_{t=k}^n \binom{n}{t} (-1)^{t-k}\binom{t}{k} =0,n \ge t \ge k \ge 0, n > k$
    - $=\sum_t (-1)^{t-k}\frac{n!}{(t)!(n-t)!}\frac{(t)!}{(k)!(t-k)!}$
    - $=\sum_t (-1)^{t-k}\frac{n!}{(k)!(n-k)!}\frac{(n-k)!}{(n-t)!(t-k)!}$
    - $=\sum_t (-1)^{t-k} \binom{n}{k} \binom{n-k}{t-k}$
    - $=\binom{n}{k} \sum_t (-1)^{t-k}  \binom{n-k}{t-k}$
    - $=\binom{n}{k} \sum_{s=t-k=0}^{n-k} (-1)^{s}  \binom{n-k}{s}$
    - $=\binom{n}{k} (1-1)^{n-k}$
    - $=0$


类似的，根据E的线性的性质，有期望的形式

## 例题

[2022-03 2835分 abc242H](https://atcoder.jp/contests/abc242/tasks/abc242_h)
- 区间$[1,n]$,$n\le 400$
- m个子区间$[l_i,r_i]$,$m \le 400$
- 每次 1/m 概率选择一个区间 涂黑
- 问全部区间都涂黑的 期望时间
- $t_i=$第i个首次被涂黑的时间
- $E(\min T)=$ 集合T中,任何一个首次被涂黑的时间
- $E(\max T)=$ 集合T中,全部被涂黑的期望时间
- 配合$dp[i][j]=$前i个,第i个被选中,j个覆盖了已选集合的 加权和 可做

[2022-06 3500分 cf(1687/R796)E](https://codeforces.com/contest/1687/problem/E)

[2023-12 2668分 abc331G](https://atcoder.jp/contests/abc331/tasks/abc331_g)
- 盒子里有 写着i的卡片有$C_i$张, $1\le i \le n \le 2e5$
- 每次 抽出一张 记录数字, 放回盒子
- 问 期望次数 1~n全至少出现一次
- $t_i=$数字i首次抽到的时间
- $E(\min T)=$ 集合T中,任何一个首次抽到
- $E(\max T)=$ 集合T中,全部被抽过一次的期望时间
- $\displaystyle \mathrm{ans}=\sum_{T\subset S} (-1)^{|T|+1} \frac{N}{\sum_{i\in T}C_i}$
  - 同样 分类讨论$\min$也就是右侧，然后去想办法算左侧-1幂次的加权和
  - 而左侧 把T展开，就是 生成函数系数
  - $\displaystyle -(1-x^{sz_1})(1-x^{sz_2})\cdots(1-x^{sz_m})$的系数，就是要求的内容, 一点poly技巧即可

## ref 

[oiwiki 容斥原理 min_max](https://oi-wiki.org/math/combinatorics/inclusion-exclusion-principle/#min-max-%E5%AE%B9%E6%96%A5)

algo/反演 里面有提到 min_max 容斥