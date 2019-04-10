---
title: project euler 100 Arranged probability
date: 2020-06-23 10:37:14
tags: [pe,project euler,math,pell eq]
category: [project euler]
mathjax: true
---

# 题目

https://projecteuler.net/problem=100

# 大意

$\frac{x(x-1)}{y(y-1)} = \frac{1}{2}$,x,y均为正整数，求首个满足表达式且$x>10^{12}$的x的值

# 读懂本文你可能需要的前置知识

[pell方程和连分数 project euler 66](/Blog/2020-05-29-project-euler066/)

# 解

显然 通过等式变换的基本操作 有

$(2y-1)^2-2(2x-1)^2 = -1$

这不就是 project euler的66题很像的pell 方程吗！

一点比较好的是$10^{12}$,其实可以双指针暴搜,O(x)时间复杂度，O(1)空间暴力算几个小时算出来,但当然如果是暴力也就不会写这篇文章了

稍加搜索也能搜到这个 `https://www.alpertron.com.ar/QUAD.HTM` 也就是说$ax^2+bxy+cy^2+dx+ey+f=0$的等式 都能解，

当然直接用网页也不需要这篇文章了，本文还是以证明为核心

## 简化

考虑 $ax^2+bxy+cy^2+dx+ey+f=0$ 二元二次方程(以下过程中所有字母均为整数)

因为对称性，我们只考虑$a \neq 0$，否则交换x和y。

不然就是形如$axy+bx+cy+d=0$的方程了，而这类方程总能化为$(ax+b)(cy+d) = e$的形式，变为拆分e的。众所周知比较容易，本文就不涉及细节了。

$4a(ax^2+bxy+cy^2+dx+ey+f)=0$

$4a^2x^2+4abxy+4acy^2+4adx+4aey+4af=0$

$(2ax+by+d)^2 +(4ac-b^2)y^2+(4ae-2bd)y+(4af-d^2)= 0$

这形如

$x^2+ay^2+by+c=0$, 如果这里$y^2$的系数$a=0$,那么也是$x^2+ay+b=0$的简单情况，讨论$x \in [0,a)$，这里不细聊了,以下只考虑$a\neq 0$

$4a^2(x^2+ay^2+by+c) = 0$

$(2ax)^2+4a^3y^2+4a^2by+4a^2c = 0$

$(2ax)^2+a(2ay+b)^2+(4a^2c-ab^2) = 0$

这形如

$x^2+ay^2+c=0$

最终又回到了 这个式子，如果这里的a是正数，显然是一个椭圆方程，有限范围内的一些尝试,不是本次讨论的，暂时不展开了

那么最终回到了

$x^2-dy^2 = k$,其中$d > 0,k \neq 0$, $d$为非平方数,否则是平方数间隔问题

## 温故知新

看看之前project euler 66 的证明过程

1. pell方程基础解
2. pell方程解存在性
3. 连分数分子分母递推式
4. 连分数，分子分母相关性质(分子分母互质性,原无理数与渐进数差值表达式，差值绝对值单调递减性，连分数是最给定分母以及更小分母中最接近原无理数，任何满足“某不等式”的数字是渐进数（这个不等式是pell方程 的必要条件）)
5. Lagrange’s Theorem 二次无理数与有循环节的连分数
6. Galois’ Theorem 纯循环连分数与reduced二次有理数
7. 根号n的连分数性质（精确的$\frac{P_n+\sqrt{d}}{Q_n}$表示 和 形如pell方程 与$Q_n$的等式）
8. 分类讨论$Q_n$与n的取值最后的结论

对比有

1&2不再是一定存在的，我们会讨论如果存在，那么具有性质和基础解

3只涉及连分数的性质，之前证明可复用

4同样只涉及连分数和不等式，最终结论任何最简分数$\frac{h}{k}$如果满足 $|\sqrt{d} - \frac{h}{k}| < \frac{1}{2k^2}$ 那么它是个渐进分数,同样复用

5,6都是连分数循环性质，reduced性质和二次无理数的关系，可复用

7是根号n的连分数表示性质，和$h_{n-1}^2-dk_{n-1}^2=(-1)^nQ_n$的证明，可复用

8再回到$x^2-dy^2=k$

## 如果存在

若存在$(x_0,y_0),x_0 > 0,y_0 > 0$使得 $x_0^2-dy_0^2 = k$, 因为有最小的$(x_1,y_1)$满足$x_1^2-dy_1^2=1$ (证明见pe 66的证明)

那么通过$(x_0+y_0\sqrt{d})(x_1+y_1\sqrt{d})$能得到新的解

$(x_0^2-dy_0^2)(x_1^2-dy_1^2) = (x_0x_1+dy_0y_1)^2 - d(x_0y_1+x_1y_0)^2 = k$，所以如果有解那么有无限组解

设$(x_i,y_i)$是满足$x^2-dy^2 = k$的最小解,$(x_j,y_j)$是另一个满足方程的解,有$x_i<x_j,y_i<y_j$

若$(x_j,y_j)$不是由最小的$(x_i,y_i)$和$(x_1,y_1)$生成的,则

$(x_i+y_i\sqrt{d})(x_1+y_1\sqrt{d})^n < (x_j+y_j\sqrt{d}) < (x_i+y_i\sqrt{d})(x_1+y_1\sqrt{d})^{n+1}$

同时乘$(x_1-y_1\sqrt{d})^n$

$x_i+y_i\sqrt{d} < (x_j+y_j\sqrt{d})(x_1-y_1\sqrt{d})^n < (x_i+y_i\sqrt{d})(x_1+y_1\sqrt{d})$

因为中间的也满足 $x+y\sqrt{d}$的形式

若$(x_j+y_j\sqrt{d})(x_1-y_1\sqrt{d})^n$ 也是一组生成的解

令$(x_j+y_j\sqrt{d})(x_1-y_1\sqrt{d})^n = x_p+y_p\sqrt{d}$

有$(x_j-y_j\sqrt{d})(x_1+y_1\sqrt{d})^n = x_p-y_p\sqrt{d}$

有$(x_j-y_j\sqrt{d})(x_1+y_1\sqrt{d})^n = x_p-y_p\sqrt{d}$

** TODO 不会证明了 失败 **

### 证明

$1=\frac{x_0^2-dy_0^2}{x_1^2-dy_1^2} $

$= \frac{x_0+y_0\sqrt{d}}{x_1+y_1\sqrt{d}} \cdot \frac{x_0-y_0\sqrt{d}}{x_1-y_1\sqrt{d}}$

$= \frac{(x_0+y_0\sqrt{d})(x_1-y_1\sqrt{d})}{-1} \cdot \frac{(x_0-y_0\sqrt{d})(x_1+y_1\sqrt{d})}{-1}$

$= ((x_0x_1-y_0y_1d)+(x_1y_0-x_0y_1)\sqrt{d})((x_0x_1-y_0y_1d)-(x_1y_0-x_0y_1)\sqrt{d})$

$= (x_0x_1-y_0y_1d)^2-(x_1y_0-x_0y_1)^2 d $

说明两个不同的`-1`的解 一定是通过乘一个`=1`的解得到的

说明存在一个`=-1`的基础解，其它解是靠基础解乘上(`=1`的基础解的幂次)得到的

## 主要关心 = -1


同时我们在66证明过 $h_{n-1}^2-dk_{n-1}^2 = (-1)^nQ_n$

**注记：最开始66那一版本,的渐进分数的部分直接使用的是pell方程中$\sqrt{d}$,其中d是非平方正整数，但下面的部分证明和证明实际上只需要保证 其中部分的参数只要是无理数即可。所以进行了修改 **

若$x^2-\alpha^2 y^2 = \beta$, 且存在解，若$|\beta| < \alpha $,则$\frac{x}{y}$ 一定是 $\alpha$的渐近分数。

证明

若$\beta > 0$,有 $x^2-\alpha^2y^2 > 0 $即$x>y\alpha$

有$|\frac{x}{y} - \alpha| = \frac{\beta}{y(x+y\alpha)} < \frac{\beta}{2y^2\alpha} < \frac{1}{2y^2}$

前面证明过(66的6.2.3.8)满足这个表达式 的 对应的最简分数$\frac{x}{y}$ 一定是渐近连分数

若$\beta < 0$ 

$y^2 - \frac{1}{\alpha^2}x^2 = \frac{-\beta}{\alpha^2}$,注意到$|\frac{-\beta}{\alpha^2}| < \frac{1}{ \alpha } $ 也就回到上面的情况

综上，证毕。

以上的证明说明了 如果$x^2-dy^2=-1$如果有解,那么 一定是一个最简分数

同样根据66的过程 我们 连分类讨论的内容都能复用

$h_{n-1}^2-dk_{n-1}^2=(-1)^nQ_n = (-1)^n, n = kl $,l为$\sqrt{d}$的 最小周期长度,

也就是再看个奇偶，最后得到了pell方程和连分数比较紧密的结论

$l$长度为偶数无解

$l$长度为奇数, $(x,y) = {h_{(2m+1)l-1},k_{(2m+1)l-1}}$,m为非负整数 

## 回到题目

$x^2-2y^2 = -1$

关于$\sqrt{2}$的连分数展开众所周知了也(66连分数开篇就是)

从前面得到的结论看 也可以通过$(x_0+\sqrt{d}y_0)(x_1+\sqrt{d}y_1)^n$来生成

$(1+\sqrt{2})(3+2\sqrt{2})^n$

$(x+y\sqrt{2})(3+2\sqrt{2})^n$

$(x_n,y_n) = (3x_{n-1}+4y_{n-1},2x_{n-1}+3y_{n-1})$

# 代码

嗯 高亮有点问题 整除识别成注释了

```python
x = 1
y = 1

while True:
    x,y = 3*x+4*y,2*x+3*y;
    print(x,y);
    if (x+1)//2 > 1000000000000:
        print((y+1)//2)
        break
```

# 参考

https://oeis.org/A031396

https://en.wikipedia.org/wiki/Pell%27s_equation#The_negative_Pell_equation

https://mathworld.wolfram.com/PellEquation.html

# 总结&感受

有搜到有人通过枚举前面的小解，发现了增长比例有趋近于定值的趋势。哎 我连找规律也不会了吗

没聊到其它非1和非-1时的情况

似乎$x^2-34y^2=-1$不存在解,所以可能无法证明它一定有解，但是如果有解，上面证明了一定是通过连分数的渐进分数找到的,也可以通过基础解生成
