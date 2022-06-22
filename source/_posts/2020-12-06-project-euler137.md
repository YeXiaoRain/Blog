---
title: project euler 137 (pell 方程右侧为-4 )
date: 2020-12-06 10:37:14
tags: [pe,project euler,math]
category: [Project Euler]
mathjax: true
---

# 题目

$A(x) = 1x + 1x^2 + 2x^3+ 3x^4+5x^5+8x^6+..$

已知$A(x)$(整数) 求问,x为有理数时$A(x)$的取值序列

$xA(x) = 1x^2 + 1x^3 + 2x^4+ 3x^5+5x^6+8x^7+..$

$(1-x)A(x) = x + 1x^3 + 1x^4 + 2x^5+ 3x^6+5x^7+8x^8+..$

$(1-x)A(x) = x + x^2A(x)$

$A(x)x^2 +(1+A(x))x - A(x) = 0$

$x = \frac{\sqrt{1+2A(x)+5A(x)^2}-1-A(x) }{2A(x)}$ (只考虑正的取值)

也就是找$1+2x+5x^2=y^2$ 的解

在pe 100 里面我们讨论过变形

$5+10+25x^2=5y^2$

$4+(1+5x)^2=5y^2$

$(1+5x)^2-5y^2=-4$

形式上是个pell方程右侧换成-4

# pell方程

在做过66和100以后，回顾看看

66是pell方程，解一定是渐进分数，且一定有解，所有解能由基础解的幂次生成

100是pell方程右侧改为-1的方程，解一定是渐进分数，但没有证明到一定有解(d=34时似乎真的没解)，通过连分数的递推寻找

这里


我们关心一下和佩尔方程的关系

在pe66，100中我们的步骤是这样的

$x^2-d y^2 = \pm 1$

$|\sqrt{d}-\frac{x}{y}| = |\frac{dy^2-x}{y^2(\sqrt{d}+\frac{x}{y})}| < \frac{1}{2y^2}$

然后满足上面不等式的一定是连分数的渐进分数

我们假设$x^2-dy^2 = c$

$\frac{x}{y} = \sqrt{d+\frac{c}{y^2}}$

上面式子的放缩部分是 $|\frac{c}{\sqrt{d}+\frac{x}{y}}| < \frac{1}{2}$

$ |\frac{4}{\sqrt{5}+\sqrt{5-\frac{4}{y^2} } }| < \frac{1}{2}$

当c比较大时 例如 $x^2-10y^2=9$ 有三组解答 $(7,2)...$, $(13,4)...$,$(57,18),...$

# 如果为正

考虑两组满足 $x^2-5y^2=-4$的值

根据pe100的结论，$(9+4\sqrt{5})^n$ 是 其佩尔方程的基础解对应的值

$1=\frac{x_0^2-dy_0^2}{x_1^2-dy_1^2} $

$= \frac{x_0+y_0\sqrt{d}}{x_1+y_1\sqrt{d}} \cdot \frac{x_0-y_0\sqrt{d}}{x_1-y_1\sqrt{d}}$

$= \frac{(x_0+y_0\sqrt{d})(x_1-y_1\sqrt{d})}{-4} \cdot \frac{(x_0-y_0\sqrt{d})(x_1+y_1\sqrt{d})}{-4}$

$= ((\frac{x_0x_1-y_0y_1d}{4})+(\frac{x_1y_0-x_0y_1}{4})\sqrt{d})((\frac{x_0x_1-y_0y_1d}{4})-(\frac{x_1y_0-x_0y_1}{4})\sqrt{d})$

$= (\frac{x_0x_1-y_0y_1d}{4})^2-(\frac{x_1y_0-x_0y_1}{4})^2 d $

说明两个不同的`-4`的解, 如果能让$x_1y_0-x_0y_1 = 0 (\pmod 4)$,那么它们之间一定是通过乘一个`=1`的解得到的,(之考虑y是因为如果y为整数且等式成立，那么x必为整数),也就是它们有同样的基础解

如果y是偶数，$y = 2k$,显然 x也是2的倍数，直接解 $(2x)^2-5(2y)^2=-4$,$x^2-5y^2=-1$ 解之即可

如果y是奇数, x也是奇数

根据mod 4进行分类

$(4k_0+1,4k_1+1) ,(4k_0+3,4k_1+3)$ 有同样的基础解(如果有解) 

$(4k_0+1,4k_1+3) ,(4k_0+3,4k_1+1)$ 有同样的基础解(如果有解)

所以最后分为3类

注意到基础解的幂次可乘性, 考虑`(x,y)`为最小全正解，$x>0,y>0$

$(x+y\sqrt{5})(9+4\sqrt{5})^{-1} = (x+y\sqrt{5})(9-4\sqrt{5})$

$ = ((9x-20y)+(9y-4x)\sqrt{5})$ , 因为是最小正解，所以再次乘积后 $9x-20y < 0$ 或 $9y-4x<0$

$ \frac{x}{y} < \frac{20}{9} 或  \frac{x}{y} > \frac{9}{4}$ 

$ \sqrt{5-\frac{4}{y^2}} < \frac{20}{9} 或  \sqrt{5-\frac{4}{y^2}} > \frac{9}{4}$ 

$\frac{2}{\sqrt{5}} \le y < \frac{18}{\sqrt{5}} 约 8.049844718999243 $

要尝试的y有限

综上原题可解

# Code 1

尝试8以内

```py
def isSquare(v):
    if v == 1:
        return True
    l = 1
    r = v
    while l+1 < r:
        m = (l+r)//2
        if m*m == v:
            return True
        if m*m > v:
            r = m
        else:
            l = m
    return False


def main():
    for i in range(1, 9):
        if isSquare(5*i*i-4):
            print(i)


main()
```

运行得到基础解

```
1 1
4 2
11 5
```

# Code2

```py

def main():
    arr = [(1,1),(4,2),(11,5)]
    cnt = 0
    while cnt < 15:
        for i in range(len(arr)):
            x,y = arr[i]
            if x > 1 and (x-1)%5==0:
                cnt+=1
                print((x-1)//5)
            arr[i] = (9*x+20*y,9*y+4*x)


main()
```







# 参考

https://math.stackexchange.com/questions/742181/find-all-integer-solutions-for-the-equation-5x2-y2-4

https://math.stackexchange.com/questions/1088277/fermats-difference-equation-pells-equation


