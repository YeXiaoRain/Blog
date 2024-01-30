---
title: Kirchhoff’s theorem(基尔霍夫定律)
date: 2024-01-30
tags:
  - 基尔霍夫定律
category:
  - algorithm
mathjax: true
---

# Kirchhoff’s theorem(基尔霍夫定律)

无自环，可重边无向图$G$的生成树个数 = G的Laplacian矩阵(基尔霍夫矩阵)的$n-1$阶余子式的行列式

<!--more-->

## 基本定义

对于一个无向图G,有N点,M边, 定义一个$N \times N$的Laplacian矩阵$L$

$L_{i,j} =$

- $i=j$时为点$i$的度
- 否则为点$i$到点$j$的重边数的相反数

等价于`点的度数矩阵`减去`邻接矩阵`

### 引理

#### 关联矩阵$B$

定义$B_{n\times m}$为关联矩阵, $n$为点数,$m$为边数

$B_{i,j}$ 表示 第$i$个点与第$j$条边(重边就拆成多条边)的关系

- $0$:无关系
- $1$:是第$j$条边的小点
- $-1$:是第$j$条边的大点

那么有$B$与$B^T$的乘积也是`基尔霍夫矩阵`

即$L=B\cdot B^T$

证明: 

- $L_{i,i} = \sum_{j\in[1,m]} B_{i,j}\times (B^T)_{j,i} = \sum_{j\in[1,m]} B_{i,j}\times B_{i,j}$ 每属于一条边则贡献为1,所以是度
- $L_{i,j} = \sum_{k\in[1,m]} B_{i,k}\times (B^T)_{k,j} = \sum_{j\in[1,m]} B_{i,k}\times B_{j,k}, i\neq j$ 所以边$k$连接点$i$和点$j$,贡献$-1$, 所以表示点$i,j$之间的边的相反数
####  Binet-Cauchy定理

$A_{n行\times m列},B_{m行\times n列},n\le m$, (若$n>m$显然结果为$0$)

$s$ 为从$m$中选出的$n$个数从小到大的一个排列

$\displaystyle \mathrm{det}(AB)= \begin{pmatrix} A_{n\times m} & O_{m\times m} \\\\ -I_{n\times n} & B_{m\times n} \end{pmatrix}= (-1)^{nm+m} \begin{pmatrix} A & O \\\\ I & B \end{pmatrix}=\sum_{s\in \binom{[m]}{n}} |A_{n,s}|\cdot|B_{s,n}|$

### 性质1 L每行 每列 元素和都是0

因为 邻接矩阵的每行每列元素和 都是对应行列的点的度数

### 性质2 L行列式 为0

因为有特征向量$(1,1,\cdots,1)^T$ 对应特征值$0$

### 性质3 L任何n-1阶 余子式的行列式相等

#### 3.0 任何$n-1$阶**主**余子式的行列式相等

> proof

根据Binet-Cauchy定理

基尔霍夫矩阵$L=B\cdot B^T$ 去掉$i$行$i$列的$n-1$阶主余子式$=\sum_{所有n-1列} \mathrm{det}(C)\cdot \mathrm{det}(C^T)$

其中$C=B$去掉$i$行选择$n-1$列的矩阵

---

接下来从意义上看对于每个$n-1$列选择下, $\mathrm{det}(C\cdot C^T)$是什么

在$B$中选了$n-1$列，对应的就是选了其中$n-1$条边,那么讨论这些边在原图中的形状

- 如果这$n-1$条边在图中有环

那么这个环上的边,$B$中对应的`列向量`之间做加减运算能得到全$0$列向量, 即线性相关, 而这对应$C$中同样的那些列向量中去掉第$i$个元素, 依然线性相关, 所以对`主余子式`的贡献$\mathrm{det}(C\cdot C^T)=0$

- 否则$n$点$n-1$条边无环 则只能是树

对于这个具体的树, 考虑把第$i$个看作树的根

那么任何叶子节点$u$，考虑它到根$i$的路径, 沿着路径, $C$中对应的`列向量`做列变换, 行列式等价 于 把这个叶子节点作为直接$i$的子节点的行列式 乘上$-1$的$0$次或$1$次，也就是列变换$X$,且$\mathrm{det}(X)=1$, 所以新的$C'$的$\mathrm{det}(C'\cdot C'^T)=\mathrm{det}(XCC^TX^T) = 1\cdot \mathrm{det}(CC^T)\cdot 1$

```
   u0                u0
    | j0          j0/  \j1
   u1         =>   u1  u2(leaf)
    | j1
   u2(leaf)

      j0  j1           j0  j1
u0     1   0            1   1
u1    -1   1  =>       -1   0
u2     0  -1            0  -1
                            也就是列向量j1 += (-1)^0 j0
```


因此$\mathrm{det}({C})$= 所有点都是点$i$直接子节点的行列式, (通过把所有点按照上面的方式进行直到都是根$i$的直接子节点)

那么转化后的行列式 是 每列有且只有一个1或-1, 每行有且只有一个1或-1的的行列式

所以$\mathrm{det}(C)=$ 1/-1

因此$\mathrm{det}({C})\cdot\mathrm{det}({C^T})$贡献为$1$, 也就是树的贡献恒为1

也就是 不论删去 哪个$i$行$i$列,的主余子式 = 生成树个数

#### 3.1 任意n-1阶余子式的行列式相等

例如


```matlab
A=[ 1,-1, 0, 0;
   -1, 0, 1, 1;
    0, 1,-1,-1]
B=A*A'
det(B([1,2],[1,2]))
det(B([1,3],[1,3]))
det(B([1,2],[2,3]))
```

proof

其实和 上面 n-1 主余子式是类似的, 通过Binet-Cauchy定理 和 树上意义 与 列向量关系

$L$的去掉$i$行$j$列的余子式$=\mathrm{det}((B去掉第i行) \star (B去掉第j行)^T) =\sum_{选n-1列s} \mathrm{det}(C_{i,s})\mathrm{det}(C_{j,s}^T)$

那么$n-1$列依然对应选$n-1$条边

因此当有成环时, $B$中列向量线性相关，去掉行后$C$列向量依然线性相关,L的n-1阶余子式行列式依然是$0$

那么对于不成环时, 依然是$C$行列式为$1$或$-1$

那么只要证明了 若 其中一组n-1条边 (移除i对应行列式 与 移除j对应的行列式) 符号相同 则 任意n-1条边(...)符号相同

先看 因为n-1点n-1边上面已经证明了行列式非0, 所以列向量线性无关

因此对应的n点n-1边的列向量也线性无关

两个树 对应的n点(行)n-1边(列)的矩阵T0,T1, 的列向量都是线性无关,

且树之间可以转化, 也就是存在可逆矩阵M(行列式非0) 使得 T0 * M = T1, 那么有

(T0去掉行i) * M = (T1去掉行i)

(T0去掉行j) * M = (T1去掉行j)

即行列式有

|T0去掉行i| * |M| = |T1去掉行i|

|T0去掉行j| * |M| = |T1去掉行j|

注意到 M 是与 i和j 无关的 只与 T0,T1的选取有关, 而且, |M| = 1/-1

因此 |T0去掉行i| * |T0去掉行j| * |M|^2 = |T1去掉行i| * |T1去掉行j|

得到了对于给定的i和j, 每个图中的树 在 Binet-Cauchy 中 贡献的绝对值为1, 且符号一致

综上

任意n-1阶子矩阵的行列式 都是生成树的个数 * (-1)的某个次方

TODO, 证明代数余子式 相等(即消掉-1)

#### 3.2 显然 根据 Binet-Cauchy 也能得到它显然是半正定矩阵

因为 |(x'B)(x'B)^T| >= 0

因此它的特征值 全非负

### 性质4 n-1余子式的行列式 = 剩余非0特征值的乘积 除以n

proof TODO, 似乎是线性代数的知识


# 相关

[atcoder abc253 Ex 官方题解](https://atcoder.jp/contests/abc253/editorial/4034)

[abc 213 g](https://yexiaorain.github.io/Blog/atcoder/abc/213/?highlight=213#G-Connectivity-2)

https://en.wikipedia.org/wiki/Kirchhoff%27s_theorem

调和矩阵Laplacian matrix: https://en.wikipedia.org/wiki/Laplacian_matrix

[wikipedia Cauchy–Binet_formula](https://en.wikipedia.org/wiki/Cauchy%E2%80%93Binet_formula)

周冬: 生成树的计数及其应用(ppt+doc 两个版本)

## 习题

atcoder:

- [jsc2021 g](https://atcoder.jp/contests/jsc2021/tasks/jsc2021_g)
- [abc253 h](https://atcoder.jp/contests/abc253/tasks/abc253_h)
- [abc323 g](https://atcoder.jp/contests/abc323/tasks/abc323_g)
