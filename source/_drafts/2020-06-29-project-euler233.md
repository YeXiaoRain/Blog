---
title: project euler 233 Lattice points on a circle
date: 2020-06-29 10:37:14
tags: [pe,project euler,math]
category: [project euler]
mathjax: true
---

# 题目

https://projecteuler.net/problem=233

f(N) = 在(过(0,0),(N,0),(0,N)的圆)上的整点个数

求 sum{f(i=1->10^11) == 420}

# 解

显然 暴力不可取:-)


也就是 $(x-\frac{N}{2})^2+(y-\frac{N}{2})^2 = 2(\frac{N}{2})^2$，其中如果N是基数两侧同时乘以4

整体还是 x^2+y^2=2z^2 的形式

回想75的 勾股数的证明步骤

拆分基本满足表达式和通过倍数生成的。下面只考虑基本的满足表达式的

`gcd(x,y)=gcd(y,z)=gcd(x,z) = 1` 两两互质

因为$x,y$是奇数所以是$4k+1$ 或$4k+3$ 平方后为$4m+1$,和为$ 4n+2 = 2(2n+1)$

$(x,y,z) = 奇,奇,奇$ ,注意到表达式的几何意义完全对称，因此只考虑 (x>0,y>0,z>0),因为轴上一定无整点，所以整点个数，为4倍考虑的区域

$(x-z)(x+z)=(z-y)(z+y)$

然后注意到|x|=|y|=z在上面不会被 m,n表示，因为实际表示分母为零，而实际上在几何上就是 题目描述的$(0,0),(0,N),(N,0),(N,N)$

令最简分数 $\frac{m}{n} = \frac{x-z}{z-y} = \frac{z+y}{z+x}$,即$gcd(m,n) = 1$,且$m>0,n>0$

$\frac{m}{n} + 1 = \frac{x-y}{z-y}$

$\frac{n}{m} - 1 = \frac{x-y}{z+y}$

$\frac{n}{m+n} + \frac{m}{n-m} = \frac{n^2+m^2}{n^2-m^2} = \frac{2z}{x-y}$

$\frac{m}{n-m} - \frac{n}{m+n} = \frac{m^2+2mn-n^2}{n^2-m^2} = \frac{2y}{x-y}$

$x-y = n^2-m^2$

$2y = m^2 - n^2 + 2mn$

$2z = n^2 + m^2$

$y = \frac{m^2 - n^2 + 2mn}{2}$

$x = \frac{n^2 - m^2 + 2mn}{2}$

$z = \frac{m^2 + n^2}{2}$

若 $m,n$全奇数，上述$x,y,z$ 根据mod4,显然也全为奇数

若 $m,n$一奇一偶，上述$x,y,z$表达式同时乘2,显然也全为奇数

因为$gcd(m,n) = 1$，根据gcd运算法则也可得到$x,y,z$两两互质

综上每个$x^2+y^2=2z^2$可以根据$m,n$表述成上述式子,每组$gcd(m,n) = 1$也可以生成$x^2+y^2=2z^2$

# 回到题目

看$z$的表达式 说明$m,n < \sqrt{2 * 10^{11} } = 447213.5954....$

再来对称性 只考虑 m > n

$f(p)$表示 直接达成p的方案数

易知 $f(偶数) = 0$, $f(1) = 4$,$n > (\sqrt{2}-1)m$ 

$ans(k) = sum(f(p)), k%p = 0$

平方和 + 因子计算, 就要$O(\sqrt{N}^3 = N^\frac{3}{2})$,

很明显 时间复杂度降低了, 但是依然是无法暴力出来的

因为上面的式子，会想到莫比乌斯反演，但暂时没想到更深的。


# 参考


发现了个这个 https://www.hackerrank.com/contests/projecteuler/challenges
