---
title: 数论杂项
date: 2024-02-12
tags:
  - 数论
  - 二次互反律
  - 二次剩余
  - 勒让德符号
category:
  - algorithm
description: 数论杂项（二次剩余，二次互反律，勒让德符号）
---

## 二次剩余

### 定义

$x^2\equiv a\pmod{p}$

若有解$a$为二次剩余，否则为二次非剩余

### 性质

二次剩余 乘 二次剩余 = 二次剩余， 显然

二次剩余 乘 二次非剩余 = 二次非剩余， 显然

二次非剩余 乘 二次非剩余 = 二次剩余, 暂时无法证明，后续证明

---

$1\cdots p-1$中有$\frac{p-1}{2}$个二次剩余 和 $\frac{p-1}{2}$个二次非剩余

二次剩余 $1^2,2^2,\cdots,(\frac{p-1}{2})^2$， 显然包含所有，且都是二次剩余，且两两不等

### 延伸

#### 勒让德符号(legendre symbol)

$xy\equiv a\pmod p$

显然 对于 给定x,只有唯一$y\equiv ax^{-1}\pmod{p}$

---

如果a二次非剩余，所以每个x配对的都不是x自己，所以是p-1个有序的不等的配对$(i,ai^{-1})$,

而 每个(x,y)对应也有一个(y,x), 所以是$\frac{p-1}{2}$对 前后可以颠倒的

把所有(x<y)的xy全部乘起来 $(p-1)!\equiv a^{\frac{p-1}{2}}\pmod{p}$

---

a是二次剩余, x是解,p-x也是解，显然只有这两个是解

所以$\frac{p-1}{2}-1$对 前后不等可交换的，和$(x,x),(p-x,p-x)$

同样 成对的只选(x<y)的全部乘起来，$(p-1)!\equiv a^{\frac{p-1}{2}-1}x(p-x)\equiv -a^{\frac{p-1}{2}-1}x^2\equiv-a^{\frac{p-1}{2}}\pmod{p}$

---

由上面的性质 引入 勒让德符号(legendre symbol): $\left(\frac{a}{p}\right)$

$=1$则$a$是$\pmod{p}$二次剩余

$=-1$则$a$是$\pmod{p}$二次非剩余

---

所以$(p-1)!\equiv -\left(\frac{a}{p}\right)a^{\frac{p-1}{2}}\pmod{p}$，即

##### 推论

威尔逊定理$(p-1)!\equiv -1\pmod{p}$

$\left(\frac{a}{p}\right)\equiv a^{\frac{p-1}{2}}\pmod{p}$, 因此可以快速知道一个数是否是$\pmod{p}$的二次剩余，本章节核心

由此 我们知道

$\left(\frac{a}{p}\right)\left(\frac{b}{p}\right)\equiv a^{\frac{p-1}{2}}b^{\frac{p-1}{2}} \equiv (ab)^{\frac{p-1}{2}}\equiv \left(\frac{ab}{p}\right) \pmod{p}$, 也就是勒让德符号的乘法分配率，也证明了上面的 两个二次非剩余的乘积是二次剩余


$\left(\frac{-1}{p}\right)\equiv (-1)^{\frac{p-1}{2}}\pmod{p} = (-1)^{\frac{p-1}{2}}$

所以$p=4n+3$则$-1$不是二次剩余,如果$p=4n+1$则$-1$是二次剩余

---

$\gcd(a,b)=1$则$a^2+b^2$的素因子都是$4n+1$型

反证: $p=4n+3,p|a^2+b^2$,

$a^2\not\equiv 0\pmod{p}$

$b^2\not\equiv 0\pmod{p}$

$a^2+b^2\equiv 0\pmod{p}$

$-a^2\equiv b^2 \pmod{p}$

$-1 \equiv b^2(a^{-1})^2 \pmod{p}$

$-1 \equiv (ba^{-1})^2 \pmod{p}$, 这说明 -1是二次剩余

$\left(\frac{-1}{p}\right) = (-1)^{\frac{p-1}{2}} = (-1)^{2n+1} = -1$， 这说明-1是二次非剩余，矛盾

### 高斯引理

例子: $\left(\frac{2}{p}\right)=2^{\frac{p-1}{2}}\mod p$

$a=1,2,\cdots,\frac{p-1}{2}$

$b=2a=2,4,\cdots,p-1$

$2^{\frac{p-1}{2}}(\frac{p-1}{2})!=\prod b=(\frac{p-1}{2})!(-1)^{\mathrm{count}(\mathrm{even} > \frac{p-1}{2})}$, 对于 $> \frac{p-1}{2}$的用$p-(p-v)$替换

$2^{\frac{p-1}{2}}=(-1)^{\mathrm{count}(\mathrm{even} > \frac{p-1}{2})}$

$p=4n+3$是$\left(\frac{2}{p}\right)=(-1)^{n+1}$

$p=4n+1$是$\left(\frac{2}{p}\right)=(-1)^n$

再细分

$p=8n+1,\left(\frac{2}{p}\right)=1$

$p=8n+3,\left(\frac{2}{p}\right)=-1$

$p=8n+5,\left(\frac{2}{p}\right)=-1$

$p=8n+7,\left(\frac{2}{p}\right)=1$

所以$\left(\frac{2}{p}\right)=(-1)^{\frac{p^2-1}{8}}$

---

一般化:

$\left(\frac{m}{p}\right)$

$a=1,2,\cdots,\frac{p-1}{2}$

$b=ma=1m,2m,\cdots,\frac{p-1}{2}m$, 两两不同余

$\mu_{m,p}=$ 数列$b$中$\mod p$后$> \frac{p-1}{2}$的个数

$\left(\frac{m}{p}\right)=(-1)^{\mu_{m,p}}$

### 二次互反律

二次也就是上面二次剩余的二次，也就是legendre符号要判定的内容

$p,q$是两个不同奇素数则$\displaystyle \left(\frac{p}{q}\right)\left(\frac{q}{p}\right)=(-1)^{\frac{p-1}{2}\frac{q-1}{2}}$

好处，计算时,可以辗转 反复颠倒 从而快速算出p,q都很大时的 结果

---

埃森斯坦的证明法

$\displaystyle \frac{p^2-1}{8}q = \sum_{i=1}^{\frac{p-1}{2}} iq$

$\displaystyle =\sum_{i=1}^{\frac{p-1}{2}}([\frac{iq}{p}]p+r_i)$, 写成余数和商

$\displaystyle =\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]p+\sum_{i=1,r_i\le \frac{p-1}{2}}^{\frac{p-1}{2}} r_i+\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} r_i$, 根据$r_i$大小拆分

$\displaystyle =\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]p+\sum_{i=1,r_i\le \frac{p-1}{2}}^{\frac{p-1}{2}} r_i+\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} (p-(p-r_i))$, 把$r_i$转化成为$[1,\frac{p-1}{2}]$

$\displaystyle =\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]p+\sum_{i=1,r_i\le \frac{p-1}{2}}^{\frac{p-1}{2}} r_i+\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} p-\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} (p-r_i)$, 把$r_i$转化成为$[1,\frac{p-1}{2}]$

$\displaystyle =\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]p+\sum_{i=1,r_i\le \frac{p-1}{2}}^{\frac{p-1}{2}} r_i+\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} (p-r_i)+\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} p-2\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} (p-r_i)$, 拆出2倍


$\displaystyle =\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]p+\sum_{i=1}^{\frac{p-1}{2}} i+p\mu_{q,p}-2\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} (p-r_i)$, 处理(2+3),4项



$\displaystyle =\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]p+\frac{p^2-1}{8}+p\mu_{q,p}-2\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} (p-r_i)$, 处理第2项


$\displaystyle \sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]p+p\mu_{q,p}\equiv \frac{p^2-1}{8}(q-1) +2\sum_{i=1,r_i > \frac{p-1}{2}}^{\frac{p-1}{2}} (p-r_i) \equiv 0\pmod{2}$, 奇偶性

$\displaystyle \sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]+\mu_{q,p}\equiv 0\pmod{2}$, 奇偶性


$\displaystyle \left(\frac{q}{p}\right)=(-1)^{\mu_{q,p}}=(-1)^{\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]}$ 利用高斯引理


$\displaystyle \left(\frac{q}{p}\right)\left(\frac{p}{q}\right)=(-1)^{\sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]+\sum_{i=1}^{\frac{q-1}{2}} [\frac{ip}{q}]}$ 对称带入


$\displaystyle \sum_{i=1}^{\frac{p-1}{2}} [\frac{iq}{p}]+\sum_{i=1}^{\frac{q-1}{2}} [\frac{ip}{q}]$ 在二维平面中表示的是 $y=\frac{q}{p}x$ 这条线下方和上方，与$x=1,y=1,x=\frac{p-1}{2},y=\frac{q-1}{2}$ 围成三角形边界和内部的格点之和 =$\frac{p-1}{2}\frac{q-1}{2}$

这里 发现中间用到了奇偶性，毕竟是(-1)的次方，所以会有一点不那么精确得到的感觉

#### 展望

三次互反律，四次互反律，eisenstein互反律,Artin互反律，Langlands纲领

https://zhuanlan.zhihu.com/p/601704520

https://zhuanlan.zhihu.com/p/646169244

### lemma 2

n非零整数, p奇素数,$p\not{|}n$,$(x,y)=1$

$p|x^2+ny^2 \leftrightarrow \left(\frac{-n}{p}\right)=1$

证明:

必要性: 这个形式的质因子 满足 -n是p的二次剩余

$x^2+ny^2\equiv 0\pmod{p}$

$p\not{|}y$

$(xy^{-1})^2+n\equiv 0\pmod{p}$

$(xy^{-1})^2\equiv -n\pmod{p}$

充分性: -n是p的二次剩余的p可以表示成$x^2+ny^2$从而多个素因子相乘依然是$x^2+ny^2$

$x^2\equiv -n\pmod{p}$

取$x=x,y=1$即可

#### 延伸 $(x,y)=1,x^2+ny^2$的质因数

$p | x^2+y^2, (x,y)=1 \leftrightarrow \left(\frac{-1}{p}\right)=1 \leftrightarrow p\equiv 1\pmod{4}$

$p | x^2+2y^2, (x,y)=1 \leftrightarrow \left(\frac{-2}{p}\right)=1 \leftrightarrow p\equiv 1\pmod{4}$

$p | x^2+3y^2, (x,y)=1 \leftrightarrow \left(\frac{-3}{p}\right)=1 \leftrightarrow p\equiv 1\pmod{3}$，

$p | x^2+7y^2, (x,y)=1 \leftrightarrow \left(\frac{-7}{p}\right)=1 \leftrightarrow p\equiv 1,2,4\pmod{7}$，

注: 这里上面p可以直接是$n$,因为x取n的倍数，而y不是时，$(x,y)=1$,


# Refs

[What's the "best" proof of quadratic reciprocity?](https://mathoverflow.net/questions/1420/whats-the-best-proof-of-quadratic-reciprocity)
