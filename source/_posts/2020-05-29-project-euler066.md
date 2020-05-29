---
title: project euler 066 diophantine equation
date: 2020-05-29 10:37:14
tags: [pe,project euler,math]
category: [project euler]
mathjax: true
---

# 叹气

从2020 02 09 挖的坑，中间很长一段时间鸽了，终于在05 29写完了.

# 题目

https://projecteuler.net/problem=66

# 大意

d = 1->1000，d是非平方数

每个d 求最小的正整数`x`使得$x^2-dy^2=1$，其中x,y都是整数,

最后对所有这些x求最大的x

# 读懂本文你可能需要的前置知识

抽屉原理

二元一次方程

绝对值

有理数/无理数

模运算

矩阵运算

数列/递推数列

二项式展开

反证法

归纳法

不等式(缩放，三角不等式)

共轭实数

# 自闭尝试

## 一些自己的数学推论

如果质数p是d的因子，那么$x^2 = 1 (\bmod p)$,由此$x = 1 (\bmod p)$ 或者$x=p-1(\bmod p)$

所以我们可以按d的最大质因子的倍数 加减1去搜，能快个常数倍

---

显然有$(x-1)(x+1) = dy^2$

令$d=d_1 \cdot d_2$

令$y=y_1 \cdot y_2$

根据对称性必然有 $d_1 \cdot {y_1}^2 - d_2 \cdot {y_2}^2 = (x+1) - (x-1) = 2$

一定程度上能减少搜索量，优化最多也就最大质数常数倍，也是最多100倍的优化

> 另外就是MOD 4的性质，用处不大，2倍左右常数优化

> 然后就是1-100内的尝试是d=61最大1766319049

> 如果d0能找到x0，那么d0和y0因子平方的组合最多是x0,也是优化不大

## python3写了个 按x递增搜索

```python
N = 1000
arr = set()
Q = set()

for d in range(1,N+1):
    arr.add(d)

x = 1
while len(arr) != 0:
    Q.add(x**2)
    delarr = []
    for d in arr:
        if x**2 - 1 > 0 and (x**2-1)%d == 0 and (x**2-1)//d in Q:
            print(x,"^2-",d,"*",(x**2-1)//d,"=1,leftcnt=",len(arr))
            delarr.append(d)
    for d in delarr:
        arr.remove(d)
    x+=1

"""
2 ^2- 3 * 1 =1,leftcnt= 1000
3 ^2- 2 * 4 =1,leftcnt= 999
3 ^2- 8 * 1 =1,leftcnt= 999
4 ^2- 15 * 1 =1,leftcnt= 997
5 ^2- 6 * 4 =1,leftcnt= 996
5 ^2- 24 * 1 =1,leftcnt= 996
6 ^2- 35 * 1 =1,leftcnt= 994
7 ^2- 12 * 4 =1,leftcnt= 993
7 ^2- 48 * 1 =1,leftcnt= 993
8 ^2- 7 * 9 =1,leftcnt= 991
8 ^2- 63 * 1 =1,leftcnt= 991
9 ^2- 5 * 16 =1,leftcnt= 989
9 ^2- 20 * 4 =1,leftcnt= 989
9 ^2- 80 * 1 =1,leftcnt= 989
10 ^2- 11 * 9 =1,leftcnt= 986
10 ^2- 99 * 1 =1,leftcnt= 986
11 ^2- 30 * 4 =1,leftcnt= 984
11 ^2- 120 * 1 =1,leftcnt= 984
12 ^2- 143 * 1 =1,leftcnt= 982
13 ^2- 42 * 4 =1,leftcnt= 981
.....
23915529 ^2- 365 * 1566993225616 =1,leftcnt= 291
24220799 ^2- 284 * 2065658817600 =1,leftcnt= 290
24220799 ^2- 639 * 918070585600 =1,leftcnt= 290
24248647 ^2- 172 * 3418586519364 =1,leftcnt= 288
24248647 ^2- 688 * 854646629841 =1,leftcnt= 288
27365201 ^2- 666 * 1124405744400 =1,leftcnt= 286
30580901 ^2- 550 * 1700348192676 =1,leftcnt= 285
32080051 ^2- 106 * 9708770492100 =1,leftcnt= 284
32080051 ^2- 424 * 2427192623025 =1,leftcnt= 284
32080051 ^2- 954 * 1078752276900 =1,leftcnt= 284
^CTraceback (most recent call last):
  File "./p066.py", line 13, in <module>
    if x**2 - 1 > 0 and (x**2-1)%d == 0 and (x**2-1)//d in Q:
KeyboardInterrupt
^C
real	135m43.883s
user	133m30.473s
sys	0m20.102s
"""
```

我给它掐断了,跑了两小时，虽然是单核的，但是还有284个数没算出来

## go并行 每个数各算各的 

值过大,需要big/int

写了一个可分段，可并行，可"断点"计算的

第一遍把1到1000直接跑，每次找到值都会输出剩余表

没统计计算时间，反正很久，每次运算的结果可以去替换slowv和ans

```go
package main

// x*x-d*y*y=1
// 如果d包含质因子p
// x*x mod p = 1
// 所以 x mod p = 1 or p-1
//

import (
  "fmt"
  "math/big"
  "sync"
)

type Xd struct {
  X big.Int
  d int
}

var prime [1010]bool

const offset = 0
const VCNT = 1000

var slowv = []int{};

// 判断是否平方数 返回 {开根,true}或者{0,false}
func getSqrt(x *big.Int) (*big.Int, bool) {
  xsqrt := big.NewInt(0).Sqrt(x)
  var xx big.Int
  xx.Mul(xsqrt, xsqrt)
  if xx.Cmp(x) == 0 {
    return xsqrt, true
  }
  return big.NewInt(0), false
}

// 对每个d尝试
func findx(d int, ch chan Xd) {
  if _, ok := getSqrt(big.NewInt(int64(d))); ok {
    ch <- Xd{*big.NewInt(0), d}
    return
  }
  // d的最大质因子
  maxp := 1
  for i := 2; i <= d; i++ {
    if prime[i] {
      continue
    }
    if d%i == 0 && i > maxp {
      maxp = i
    }
  }

  for i := big.NewInt(1); ; i.Add(i, big.NewInt(1)) {
    imaxp := big.NewInt(0).Mul(i, big.NewInt(int64(maxp)))
    sub1 := big.NewInt(0).Sub(imaxp, big.NewInt(1))
    add1 := big.NewInt(0).Add(imaxp, big.NewInt(1))
    for _, x := range []*big.Int{sub1, add1} {
      // x^2-1
      x2s1 := big.NewInt(0).Sub(big.NewInt(0).Mul(x, x), big.NewInt(1))
      x2s1mod := big.NewInt(0).Mod(x2s1, big.NewInt(int64(d)))
      if x2s1mod.Cmp(big.NewInt(0)) != 0 {
        continue
      }
      x2s1div := big.NewInt(0).Div(x2s1, big.NewInt(int64(d)))
      if _, ok := getSqrt(x2s1div); ok {
        ch <- Xd{*x, d}
        return
      }
    }
  }
}
// 结果处理
func waitAns(ch chan Xd, ans *Xd, wg *sync.WaitGroup) {
  s := make(map[int]int)
  for _,v := range slowv{
    s[v]=1
  }
  cnt := 0
  fmt.Println(s, *ans, len(s))

  for v := range ch {
    cnt++
    delete(s,v.d)
    fmt.Println(s, *ans, len(s))
    if v.X.Cmp(&ans.X) == 1 {
      *ans = v
      // fmt.Println("new",*ans, cnt)
    }
    wg.Done()
  }
}

func main() {
  for i := 2; i < 100; i++ {
    if prime[i] {
      continue
    }
    for j := i * i; j <= 1000; j += i {
      prime[j] = true
    }
  }
  ans := Xd{*big.NewInt(0), 1}
  // 取消下面两行注释 从计算结果继续
  // slowv = []int{739, 367, 547, 835, 457, 797, 766, 508, 931, 166, 937, 556, 989, 517, 926, 554, 834, 253, 796, 331, 976, 953, 883, 394, 977, 511, 199, 449, 661, 919, 571, 581, 814, 271, 805, 862, 277, 526, 653, 981, 664, 829, 749, 382, 956, 821, 412, 913, 596, 911, 871, 268, 941, 859, 967, 809, 214, 317, 298, 622, 974, 565, 997, 607, 649, 991, 751, 823, 358, 487, 679, 921, 501, 716, 826, 929, 853, 478, 586, 863, 309, 947, 569, 946, 778, 849, 481, 157, 553, 673, 301, 681, 244, 509, 523, 865, 754, 844, 433, 773, 634, 869, 753, 643, 669, 589, 790, 721, 614, 857, 685, 334, 521, 149, 709, 856, 694, 491, 971, 789, 549, 281, 757, 893, 907, 964, 313, 746, 454, 724, 463, 617, 109, 886, 337, 477, 489, 922, 637, 641, 877, 597, 211, 881, 409, 493, 631, 593, 599, 397, 889, 838, 610, 970, 801, 949, 628, 928, 436, 181, 719, 811, 613, 538, 604, 421, 958, 619, 972, 379, 772, 241, 769, 541, 193, 686, 601, 691, 764, 988, 652, 353, 461, 61, 787, 718,}
  // ans := Xd{*big.NewInt(3832352837), 502}

  var wg sync.WaitGroup
  ch := make(chan Xd)
  if len(slowv) == 0{
    // 第一遍的时候 lowv 为空 用这个代码
    for i := 1+offset; i <= VCNT+offset; i++ {
      slowv = append(slowv, i)
      wg.Add(1)
      go findx(i, ch)
    }
  }else{
    for _,v := range slowv{
      wg.Add(1)
      go findx(v,ch)
    }
  }

  go waitAns(ch, &ans, &wg)
  wg.Wait()
  fmt.Println(ans)
}
```

# 题解

这时就体现出当数学家可以推出结论，而计算机拥有的只是“蛮力”。

## pell方程的解

### 解的性质(基础解)

如果$x^2-d \cdot y^2=1$ 平方得 $x^4+d^2 \cdot y^4-2dx^2y^2=1$

$x^4+2dx^2y^2+d^2 \cdot y^4-d \cdot 4x^2y^2=1$

$(x^2+dy^2)^2 - d \cdot (2xy)^2=1$

即当我们有一个解时，通过平方能得到新的解

---

又$(x+\sqrt{d} \cdot y)\cdot (x-\sqrt{d} \cdot y)=1$

可得$((x+\sqrt{d} \cdot y)\cdot (x-\sqrt{d} \cdot y))^n=1$

$(x+\sqrt{d} \cdot y)^n\cdot (x-\sqrt{d} \cdot y)^n=1$

根据二项式展开有

若 $(x+\sqrt{d} \cdot y)^n = A + B\cdot{d}$

则 $(x-\sqrt{d} \cdot y)^n = A - B\cdot{d}$ 即是 $A^2-d \cdot B^2=1$

也就是它的n次方展开的系数也是一组解

> 同样,假设有两组解：(x1,y1)和(x2,y2)的，它们也可以通过上述乘积方法，合成一组新的解

**下面证明所有解都是最小解生成的**

设$(x_1,y_1)$为最小解,$(x_k,y_k)$不是由最小解上述幂次方法生成的一个解

根据y越大x越大的性质，则存在一个整数n

$(x_1+y_1 \cdot \sqrt{d})^n < (x_k+y_k \cdot \sqrt{d}) < (x_1+y_1 \cdot \sqrt{d})^{n+1} $

同时乘$(x_1-y_1 \cdot \sqrt{d})^n$有

$1 < (x_k+y_k \cdot \sqrt{d}) \cdot (x_1-y_1 \cdot \sqrt{d})^n < (x_1+y_1 \cdot \sqrt{d}) $

注意到中间的表达式 也是满足参数形式的 也是一组解

这与最小解定义冲突，所以所有解都是最小解生成的

### 解的存在性证明

存在无穷多对整数(x,y)满足 $|x-y\sqrt{d}|<\frac 1y$

取正整数$q_0 > 1$

取$t=0,1,...,q_0$ 共计$q_0+1$个

把区间$[0,1)$等分为$q_0$部分，则每部分长度为$\frac 1{q_0}$,考虑 $t \sqrt{d}$的小数部分(t为整数)，必定有两个落在同一区间 所以存在$0<=i<j<=q_0$使得 $| t_i \sqrt{d} - t_j \sqrt{d} |$ 的小数部分 $<\frac 1{q_0}$

即$|x-(t_j-t_i)\sqrt{d}| = \\{ | t_i \sqrt{d} - t_j \sqrt{d} |\\} < \frac 1{q_0} < 1 <= \frac 1{t_j-t_i}$

把$t_j-t_i$ 看作y得到一个解

取$\frac 1{q_1} < |x-(t_j-t_i)\sqrt{d}|$

可以得到新的解(因为y乘 sqrt D的小数部分不同，所以y不同)，反复如此可生成无限个解

---

对于这无限个解

0 < $\left|x^2-dy^2\right|=\left|x+y\sqrt{d}\right|\cdot\left|x-y\sqrt{d}\right|=\left|x-y\sqrt{d}+2y\sqrt{d}\right|\cdot\left|x-y\sqrt{d}\right|<=(\left|x-y\sqrt{d}\right|+\left|2y\sqrt{d}\right|)\cdot\left|x-y\sqrt{d}\right|<\left(2y\sqrt{d}+\frac{1}{y}\right)\cdot\frac{1}{y}\le 2\sqrt{d}+\frac 1{y^2}$

说明这无限个(x,y)的取值,对$|x^2-dy^2|$的计算结果是有限范围内的整数

再一次根据抽屉原理，存在正整数k,使得$|x^2-dy^2|=k$的解有无限个

考虑这些解$(x \bmod k,y \bmod k)$ , 可以的方案数$<=k^2$,也是有限的，

再根据抽屉原理，存在$(M_x,M_y)$，使得无限个i， $s.t. (x_i \bmod k, y_i \bmod k) = (M_x,M_y)$,在这无限组中取两组$(x_1,y_1),(x_2,y_2)$

令 $X=|\frac{x_1x_2-y_1y_2d}{k}|,Y=|\frac{x_2y_1-x_1y_2}{k}|$

有 $X^2-d \cdot Y^2 = \frac{(x_1^2-d \cdot y_1^2)(x_2^2-d \cdot y_2^2)}{k^2} = 1$

显然$X = \sqrt{1+dY^2}$ 不为0

因为 $(x_1x_2-y_1y_2d)\bmod k = (x_1x_1-y_1y_1d)\bmod k = k \bmod k = 0$,所以X为整数，所以X为正整数

因为 $(x_2y_1-x_1y_2)\bmod k = (x_1y_1-x_1y_1) \bmod k = 0 \bmod k = 0$,所以Y是整数$ x_1^2-d \cdot y_1^2$

注意到 $x^2-dy^2$ 的取值范围为 $\pm k$ (有限个 ，2个)，但可取的$(x,y)$有无限对，再一次抽屉原理,因此存在$(x_i,y_i)\neq(x_j,y_j)$使得 $x_i^2-dy_i^2=x_j^2-dy_j^2$ 这时 $\frac{x_i}{y_i} \neq \frac{x_j}{y_j}$ (否则代入前式子得到$x_i=x_j$), 即Y不为0,Y为正整数

综上，一定存在解

----

关于 pell方程 ，我们现在有了 一定存在解，且存在一个最小解的基础解，两个结论，下面开始看看连分数。

## 连分数

### 定义

形如

$x = a_0 + \cfrac{1}{a_1 + \cfrac{1}{a_2 + \cfrac{1}{a_3 + \cfrac{1}{\ddots\,}}}} $

例如 

$ \sqrt{2} = 1 + \frac{1}{2 + \cfrac{1}{2 + \cfrac{1}{2 + \cfrac{1}{2 + \cfrac{1}{2 + \cfrac{1}{2 + \ddots}}}}}} $

展开的剩余部分是在`[0,1)`之间

### 性质

所有无限连分数都是无理数。

证明：如果一个数是有理数，把它写成分数的形式，再按照连分数的方式展开，你会发现这过程就是辗转相除，分子分母单调递减 所以一定有限，它的逆否命题就是要证明的性质

### 渐进分数(分子，分母等性质)

渐进分数，把上述连分数部分截断得到的分数

假设h,k分别为渐进分数的分子和分母,根据简化为分数的过程

$\begin{bmatrix} h_n & k_n \end{bmatrix} = \begin{bmatrix} 1 & 0 \end{bmatrix} \cdot \begin{bmatrix} a_n & 1 \\\ 1 & 0 \end{bmatrix}  \cdot \begin{bmatrix} a_{n-1} & 1 \\\ 1 & 0 \end{bmatrix}  \cdots \begin{bmatrix} a_0 & 1 \\\ 1 & 0 \end{bmatrix} $

然而这不好建立递推关系,稍做变形

$\begin{bmatrix} h_n & k_n \\\ ? & ? \end{bmatrix} = \begin{bmatrix} 1 & 0 \\\ 0 & 1 \end{bmatrix} \cdot \begin{bmatrix} a_n & 1 \\\ 1 & 0 \end{bmatrix}  \cdot \begin{bmatrix} a_{n-1} & 1 \\\ 1 & 0 \end{bmatrix}  \cdots \begin{bmatrix} a_0 & 1 \\\ 1 & 0 \end{bmatrix} $

$\begin{bmatrix} h_n & k_n \\\ ? & ? \end{bmatrix} = \begin{bmatrix} a_n & 1 \\\ 1 & 0 \end{bmatrix}  \cdot \begin{bmatrix} a_{n-1} & 1 \\\ 1 & 0 \end{bmatrix}  \cdots \begin{bmatrix} a_0 & 1 \\\ 1 & 0 \end{bmatrix} $

$\begin{bmatrix} h_n & k_n \\\ ? & ? \end{bmatrix} = \begin{bmatrix} a_n & 1 \\\ 1 & 0 \end{bmatrix}  \cdot \begin{bmatrix} h_{n-1} & k_{n-1} \\\ ? & ? \end{bmatrix} $

显然左式的底部可以确定

$\begin{bmatrix} h_n & k_n \\\ h_{n-1} & k_{n-1} \end{bmatrix} = \begin{bmatrix} a_n & 1 \\\ 1 & 0 \end{bmatrix}  \cdot \begin{bmatrix} h_{n-1} & k_{n-1} \\\ ? & ? \end{bmatrix} $

又因为递推关系，右边式子相当于左式带入n-1

$\begin{bmatrix} h_n & k_n \\\ h_{n-1} & k_{n-1} \end{bmatrix} = \begin{bmatrix} a_n & 1 \\\ 1 & 0 \end{bmatrix}  \cdot \begin{bmatrix} h_{n-1} & k_{n-1} \\\ h_{n-2} & k_{n-2} \end{bmatrix} $

综上

$h_n = a_n \cdot h_{n-1} + h_{n-2}$
$k_n = a_n \cdot k_{n-1} + k_{n-2}$

渐进值 $\frac{h_n}{k_n} = \frac{a_n \cdot h_{n-1} + h_{n-2}}{a_n \cdot k_{n-1} + k_{n-2}}$

且根据计算过程，可知 $h_n,k_n$互质

---

由上面的递推关系再递推有

$k_nh_{n-1}-k_{n-1}h_n=-(k_{n-1}h_{n-2}-k_{n-2}h_{n-1})=(-1)^n $, 

$k_nh_{n-2}-k_{n-2}h_n=a_n(k_{n-1}h_{n-2}-k_{n-2}h_{n-1})=a_n(-1)^{n-1} $, 

设$\sqrt d$的精确表示为$[a_0,a_1,...,a_n,x_{n+1}]$,即是最后$a_{n+1}$替换为精确的非整数值$x_{n+1}$,有$1<=a_{n+1}<x_{n+1}<a_{n+1}+1,(n>=1)$


---

根据上方计算渐进值得到的公式，同理递推式有

$\sqrt d =\frac{x_{n+1}h_n+h_{n-1}}{x_{n+1}k_n+k_{n-1}}  $

$\sqrt d-\frac{h_n}{k_n} =\frac{x_{n+1}h_n+h_{n-1}}{x_{n+1}k_n+k_{n-1}} -\frac{h_n}{k_n} $

$=\frac{h_{n-1}k_{n}-h_nk_{n-1}}{k_n(x_{n+1}k_n+k_{n-1})}$

$=\frac{(-1)^n}{k_n(x_{n+1}k_n+k_{n-1})}$

$|\sqrt d-\frac{h_n}{k_n}| =\frac{1}{k_n(x_{n+1}k_n+k_{n-1})} < \frac{1}{k_n(a_{n+1}k_n+k_{n-1})} = \frac{1}{k_nk_{n+1}}$

注意到k的递推式，容易发现它是单调递增的正整数,所以渐进分数真的是趋近(n趋于无限大，渐进分数趋进原无理数)

---

$|k_n\sqrt d - h_n|$单调递减。

证明:

$|k_n\sqrt d - h_n| - |k_{n-1}\sqrt d - h_{n-1}|$

$ = |k_n(\sqrt d - \frac{h_n}{k_n})| - |k_{n-1}(\sqrt d - \frac{h_{n-1}}{k_{n-1}}|)$

$ = \frac 1{x_{n+1}k_n+k_{n-1}} - \frac 1{x_{n}k_{n-1}+k_{n-2}} $

$ = \frac {(x_{n}k_{n-1}+k_{n-2})-(x_{n+1}k_n+k_{n-1})}{(x_{n+1}k_n+k_{n-1})(x_{n}k_{n-1}+k_{n-2})}$

$ = \frac {((a_n+\frac 1{x_{n+1}})k_{n-1}+k_{n-2})-(x_{n+1}k_n+k_{n-1})}{(x_{n+1}k_n+k_{n-1})(x_{n}k_{n-1}+k_{n-2})}$

$ = \frac {(x_{n+1}(a_nk_{n-1}+k_{n-2})+k_{n-1})-x_{n+1}(x_{n+1}k_n+k_{n-1})}{x_{n+1}(x_{n+1}k_n+k_{n-1})(x_{n}k_{n-1}+k_{n-2})}$

$ = \frac {(x_{n+1}k_n+k_{n-1})-x_{n+1}(x_{n+1}k_n+k_{n-1})}{x_{n+1}(x_{n+1}k_n+k_{n-1})(x_{n}k_{n-1}+k_{n-2})}$


$ = \frac {(1-x_{n+1})(x_{n+1}k_n+k_{n-1})}{x_{n+1}(x_{n+1}k_n+k_{n-1})(x_{n}k_{n-1}+k_{n-2})} < 0$

---

由此也可知$|\sqrt d-\frac{h_n}{k_n}|$单调递减

$|\sqrt d-\frac{h_n}{k_n}|-|\sqrt d-\frac{h_{n-1}}{k_{n-1}}|$

$=\frac {|{k_n}\sqrt d-{h_n}|-\frac {k_n}{k_{n-1}}|{k_{n-1}}\sqrt d-{h_{n-1}}|}{k_n}$

$<\frac {|{k_n}\sqrt d-{h_n}|-|{k_{n-1}}\sqrt d-{h_{n-1}}|}{k_n} < 0$

// 或者因为$k_n$单调递增

---

若$(h_n,k_n)$是一个渐进分数，则对于分母$k_n$,分子取$h_n$时，整个分数最接近原无理数

取任意$h\neq h_n$,根据三角不等式

$|\sqrt d -\frac{h}{k_n}| \geq |\frac{h-h_n}{k_n}| - |\sqrt d - \frac{h_n}{k_n}|$

$>\frac 1{k_n} - \frac 1{k_nk_{n+1}} $,因为n足够大 $k_{n+1}>=3$有

$> \frac 1{k_n} - \frac 1{2k_n} $

$=\frac 1{2k_n} $

$>  \frac 1{k_nk_{n+1}} > |\sqrt d -\frac{h_n}{k_n}|$

证明了$h_n$是最接近的分子

即 $|k_n\sqrt d-h|$在 $h=h_n$时取最小值

---

下面证明在$(0<k<=k_n)$中，对于所有$(h,k)$，有$|k_n\sqrt d -  h_n|$为最小值

考虑任意$(h,k),(0<k<k_n)$，且$\frac hk$的最简分数不是渐进数，（因为已经证明了渐进数随着n增大$|k\sqrt d - h|$单调递减，且渐进数分子分母互质，所以如果最简分数是渐进数则对应渐进数的该表达式 更大，又是分子分母是渐进数的倍数，则该表达式的结果还要乘上倍数会更大）

// 同时它是最简分数，因为上表达式 带入分数和其最简分数得到的值刚好是其分子和其最简分数的分子的比值的倍数

设二元一次方程组

$h_nx+h_{n-1}y=h$

$k_nx+k_{n-1}y=k$

则有$(x,y)=(\frac {hk_{n-1}-kh_{n-1}}{h_nk_{n-1}-h_{n-1}k_n},\frac {hk_{n}-kh_{n}}{h_nk_{n-1}-h_{n-1}k_n}) = ((-1)^{n-1}(hk_{n-1}-kh_{n-1}),(-1)^{n-1}(hk_{n}-kh_{n}))$

因为$\frac hk$不是渐进分数，所以$x,y$都是非零整数，又因为$k<k_n$和$k_nx+k_{n-1}y=k$有:$x,y$异号

因为$\sqrt d - \frac {h_n}{k_n}$的分子为$(-1)^n$,分母为正数,

因此$\sqrt d - \frac {h_n}{k_n}$和$\sqrt d - \frac {h_{n-1}}{k_{n-1}}$异号

$k_n\sqrt d - {h_n}$和$k_{n-1}\sqrt d - {h_{n-1}}$异号

$x(k_n\sqrt d - {h_n})$和$y(k_{n-1}\sqrt d - {h_{n-1}})$同号

$|k\sqrt d -h| = |(k_nx+k_{n-1}y)\sqrt d - (h_nx+h_{n-1}y)|$

$= |x(k_n\sqrt d - {h_n}) + y(k_{n-1}\sqrt d - {h_{n-1}})|$,因为同号：

$= |x(k_n\sqrt d - {h_n})|+|y(k_{n-1}\sqrt d - {h_{n-1}})|$，因为$x,y$非零整数:

$|k\sqrt d -h| > |k_n\sqrt d - {h_n}|$且$|k\sqrt d -h|>|k_{n-1}\sqrt d - {h_{n-1}}|$

内容得证

---

连续的两个渐进数中至少有一个满足，$|\sqrt d - \frac hk|<\frac 1{2k^2}$

证明:

假设都不满足，有

$0 \leq |\sqrt d-\frac{h_{n+1}}{k_{n+1}}| - \frac{1}{2k_{n+1}^2} + |\sqrt d-\frac{h_{n}}{k_{n}}|-\frac{1}{2k_{n}^2}$, 因为$\sqrt d - \frac{h_{n}}{k_{n}}$正负交替,所以

$ = |\frac{h_{n+1}}{k_{n+1}}-\frac{h_{n}}{k_{n}}|-\frac 1{2k_{n+1}^2} -\frac 1{2k_{n}^2}$

$ = |\frac{h_{n+1}k_{n}-h_{n}k_{n+1}}{k_{n+1}k_{n}}|-\frac 1{2k_{n+1}^2} -\frac 1{2k_{n}^2}$

$ = \frac 1{k_nk_{n+1}} -\frac 1{2k_{n+1}^2} -\frac 1{2k_{n}^2}$

$ = \frac 1{k_nk_{n+1}} -\frac 1{2k_{n+1}^2} -\frac 1{2k_{n}^2}$

$ = \frac {-(k_n-k_{n+1})^2}{2k_{n}^2k_{n+1}^2} < 0$

矛盾

因此至少有一个大于满足 得证

___

任何最简分数如果满足$|\sqrt d - \frac hk|<\frac 1{2k^2}$，那么它是个渐进分数

证明

设$\frac hk$满足不等式$|\sqrt d - \frac hk|<\frac 1{2k^2}$，则存在n使得渐进数分母满足 $k_{n+2}>k>=k_n $且$\frac {h_n}{k_n}$满足$|\sqrt d - \frac hk|<\frac 1{2k^2}$(因为相邻渐进数必有一个满足,这里是取n和n+2之间)，根据上面的不等式 有$|k_n\sqrt d- h_n| < |k\sqrt d - h\|$，若$\frac hk \neq \frac{h_n}{k_n}$,即$k_n < k$

$0 \leq \frac{|hk_n-h_nk|-1}{kk_n}$

$= |\frac{h}{k}-\frac{h_n}{k_n}|-\frac{1}{kk_n}$,因为三角不等式，有

$\leq |\sqrt d -\frac{h}{k}|+|\sqrt d -\frac{h_n}{k_n}|-\frac{1}{kk_n}$, 因为假设满足的不等式

$< \frac 1{2k^2} + \frac 1{k_n}|k_n\sqrt d - h_n|-\frac{1}{kk_n}$,因为上面的最小接近

$< \frac 1{2k^2} + \frac 1{k_n}|k\sqrt d - h|-\frac{1}{kk_n}$

$= \frac 1{2k^2} + \frac {k}{k_n}|\sqrt d - \frac hk|-\frac{1}{kk_n}$因为假设满足的不等式

$< \frac 1{2k^2} + \frac {k}{k_n}\cdot \frac 1{2k^2}-\frac{1}{kk_n}$

$= \frac {k_n-k}{2k^2k_n} < 0$

矛盾，因此$\frac hk$和某个渐进数相等

### Lagrange’s Theorem 二次无理数与有循环节的连分数

quadratic irrational(二次无理数) : 二次整式多项式的根 $\frac{-b\pm \sqrt{b^2-4ac}}{2a}$ 或者形如$\frac{P+\sqrt{D}}{Q}$

 An irrational number is quadratic irrational if and only if its continued fraction is periodic.

> 先证明简单的一侧，循环连分数一定是二次根式的根。

按照连分数的写法，将循环节设为t

显然还原为分数,有$x=\frac{a t + b}{c t +d},t = \frac{et+f}{gt+h}$ 变换左表达式t是x的函数，带入右侧表达式得到$\frac{ix+j}{kx+l} = \frac{mx+n}{ox+p}$,其中字母$a-p$均为整数，且注意到x为无理数，所以化简后一定是二次方程

> 再证明二次根式的根一定能表达为有循环节的连分数

定义,u对于无理数x

$f(x) = x-1 (x>1)$

$f(x) = \frac{1}{\frac{1}{x}-1} , (x<1)$

对应到连分展开，即是将首个数字减少1,(x>1时就是a0减去1,x<1时就是a1减去1)

令$x1=x,x_{n+1}=f(x_n)$,可以知道 这是一个无限数列

如果x满足$ax^2+bx+c=0$,写作$x\in[a,b,c]$

那么x-1 满足$a(x-1)^2+(2a+b)(x-1)+(a+b+c) = ax^2+b+c=0$

那么$\frac{x}{1-x}$ 满足$(a+b+c)(\frac{x}{1-x})^2+(b+2c)\frac{x}{1-x}+c = 0$

所以f(x)满足 $f(x)\in [a,2a+b,a+b+c]$ 或 $f(x)\in [a+b+c,b+2c,c]$

不失一般性，写作$x_n\in[s_n,t_n,u_n]$,有 $s_n > 0$, 否则把三元组同时换号

注意到上式 $(2a+b)^2-4a(a+b+c)=b^2-4ac=(b+2c)^2-4(a+b+c)c$

说明了 $t_n^2-4s_nu_n$是和n无关的值

如果只有有限个$u<0$,那么从某一处开始，$s>0,u>0$且$t<0$(因为 x > 0)

那么意味着 $-t$ 严格单调递减并且非负，(因为 t的变化关系是 t=2s+t或者 t=t+2u),矛盾

所以有无限个$s_nu_n<0$

注意到 $t_n^2-4s_nu_n$是常数，所以 至少有一个三元组$[s_n,t_n,u_n]$ 出现了三次,一个二次方程有两个解，所以有满足的$x_n=x_m,m>n$

得证 连分数展开有循环

Theorem 1. If x is a positive quadratic irrational then its continued fraction is eventually periodic.

### Galois’ Theorem 纯循环连分数与reduced二次有理数

Definition 1.24. x 是二次无理数的根，$\overline{x}$ 是另一个根，那么如果 x > 1 且 $-1 < \overline{x} < 0$.那么称 x 为 reduced

---

Theorem 1.25. (Galois’ Theorem) 无理数a. a是纯循环连分数（从a0开始的循环节），当且仅当 x is reduced. If $x = [\overline{a_0, a_1, a_2, . . . , a_{l−1}}]$ and $\overline{x}$ 是它共轭实数, then $-\frac{1}{x} = [\overline{a_{l−1}, . . . , a_2, a_1}].$

设二次无理数$x=[a_0,a_1,...,a_n], x>1,-1<\overline{x}<0$

那么有 $x_{n+1}=\frac{1}{x_n-a_n}$ // 表示 按照展开从n处向后取值

$\overline{x_{n+1}} = \frac{1}{\overline{x_n-a_n}} = \frac{1}{\overline{x_n}-a_n}$,(因为 两个形如$A+B\sqrt{C}$的无理数相乘为有理数，说明相乘后的无理数的系数为0,所以更改其中一个无理数的系数的正负，另一个无理数系数的正负更改即可)

注意到$x_1 \ge 1$有$a_0 \ge 1$,所以 $a_n \ge 1$

下面归纳证明 $-1 < \overline{x_n} < 0 $

若 $-1 < \overline{x_n} < 0$

有 $\frac{1}{\overline{x_{n+1}}} = \overline{x_n} - a_n < -1$

即 $-1 < \overline{x_{n+1}} < 0$，得证

$-1 < \overline{x_n} = \frac{1}{\overline{x_{n+1}}}+a_n < 0$

$ 1 > -\frac{1}{\overline{x_{n+1}}}-a_n > 0$

$ a_n = [ -\frac{1}{\overline{x_{n+1}}} ] $ // 也就是$a_n$等于分式的整数部分

因为上面已经证明 如果是二次无理数，那么必定有循环节，所以存在$x_i = x_j,(i < j )$

即$\overline{x_i}=\overline{x_j}$

即$a_{i-1}=[-\frac{1}{\overline{x_i}}]=[-\frac{1}{\overline{x_j}}] = a_{j-1}$

即$x_{i-1}=a_{i-1}+\frac{1}{x_i} = a_{j-1}+\frac{1}{x_j} = x_{j-1}$, 意义就是如果两个后缀相等，那么它们各向前一个 也相等，综上逐步迭代$a_0 =a_{j-i}$ 

因此证明了 如果一个二次无理数是 reduced，那么它是个纯循环连分数

---

下面证明 纯循环连分数 是 reduced

首先有循环节的连分数一定是二次无理数（上面证过了)

因为是纯循环，所以$a_0 \ge 1$,所以$a_n \ge 1$,有$x > 1$

假设周期为n, 有 $x_n = x = [\overline{a_0,a_1,...,a_{n-1}}]$

根据上面推过的递推式 $x = \frac{x_nh_{n-1}+h_{n-2}}{x_nk_{n-1}+k_{n-2}} = \frac{xh_{n-1}+h_{n-2}}{xk_{n-1}+k_{n-2}}$

化简 $k_{n-1}x^2+(k_{n-2}-h_{n-1})x-h_{n-2}=0$

也就是证明这个方程除了x (我们已经有 $x>1$了)的另一个根$\overline{x}$满足$-1 < \overline{x} < 0$

$x = 0$时 原式子 $=-h_{n-2} < 0$

$x = 1$时 原式子 

$= k_{n-1}+(h_{n-1}-k_{n-2})-h_{n-2}$

$= (a_{n-1}k_{n-2}+k_{n-3}) + (a_{n-1}h_{n-2}+h_{n-3}) -k_{n-2}-h_{n-2}$

$= (a_{n-1}-1)(h_{n-2}+k_{n-2}) + (h_{n-3}+k_{n-3}) $

$ > 0 $

说明了另一个根$-1 < \overline{x} < 0$

至此我们证明了 reduced 和 纯循环之间的 充要

---

最后证明 If $x = [\overline{a_0, a_1, a_2, . . . , a_{l−1}}]$ and $\overline{x}$ 是它共轭实数, then $-\frac{1}{x} = [\overline{a_{l−1}, . . . , a_2, a_1,a_0}].$

Step 1

考虑有限的连分数 $x = [a_0,a_1,...,a_n], y=[a_n,a_{n-1},...,a_0] , a_i > 0$

$h_n,k_n$为x的分子分母，$h_n',k_n'$为y的分子分母

要证明 $\frac{h_n}{h_{n-1}} = \frac{h_n'}{k_n'}$ 且 $\frac{k_n}{k_{n-1}} = \frac{h_{n-1}'}{k_{n-1}'}, n \ge 1$ 且分子分母对应相等(因为是最简分数，所以只要证明了分数相等就有对应相等了)

注意到上面 $h_n = a_n \cdot h_{n-1} + h_{n-2}$,同时除以 $h_{n-1}$

$\frac{h_n}{h_{n-1}} = a_n + \frac{1}{\frac{h_{n-1}}{h_{n-2}}}$

递归展开 可以得到 $\frac{h_n}{h_{n-1}} = [a_n,a_{n-1},...,a_0]$,

注意到 $k_n = a_n \cdot k_{n-1} + k_{n-2}$,同理 $\frac{k_n}{k_{n-1}} = [a_n,a_{n-1},...,a_1] $(注意是$a_1$不是$a_0$)

根据上面的`递归展开的结论` 和 `y的分子分母定义`有

$\frac{h_{n+1}}{h_n} = [a_{n+1},a_n,...,a_0] = \frac{h_{n+1}'}{k_{n+1}'}$

$\frac{k_{n+1}}{h_n} = [a_{n+1},a_n,...,a_1] = \frac{h_{n}'}{k_{n}'}$

且分子分母对应相等

Step 2

若x 是纯循环连分数数(即reduced 二次有理数)，那么显然$-\frac{1}{\overline{x}}$也是 reduced的二次有理数，那么它也是纯循环

假设直接取 n+1 = 两个循环节长度的最小公倍数

$k_{n}x^2+(k_{n-1}-h_{n})x-h_{n-1}=0$

令

$y = [\overline{a_n,a_{n-1},...,a_0}] = [a_n,a_{n-1},...,a_0,y]$

$y = \frac{h_n'y+h_{n-1}'}{k_n'y+k_{n-1}'}$

因为Step 1 我们证明了对应相等$h_n=h_n',k_{n-1}=k_{n-1}', h_{n-1}=k_{n}',h_{n-1}'=k_n$

所以做对应替换,$y = \frac{h_ny+k_{n}}{h_{n-1}y+k_{n-1}}$

$k_{n}{(-\frac{1}{y})}^2+(k_{n-1}-h_{n})(-\frac{1}{y})-h_{n-1}=0$

$-\frac{1}{y} = \overline{x}$ 得证(y为正 所以 不可能等于x)

至此 Theorem 1.25. (Galois’ Theorem) 无理数a. a是纯循环连分数（从a0开始的循环节），当且仅当 x is reduced. If $x = [\overline{a_0, a_1, a_2, . . . , a_{l−1}}]$ and $\overline{x}$ 是它共轭实数, then $-\frac{1}{\overline{x}} = [\overline{a_{l−1}, . . . , a_2, a_1}].$ 得证

---

Theorem 1.26 d是非平方数,那么$\sqrt{d} = [\lfloor \sqrt{d} \rfloor,\overline{a_1,a_2,...,a_2,a_1,2\lfloor \sqrt{d} \rfloor}]$

也就是 是从第二位开始循环节，且循环节最后一个是它的整部的2倍，且剩余部分是回文

令$x=\lfloor \sqrt{d} \rfloor + \sqrt{d}$ 则$\overline{x} = \lfloor \sqrt{d} \rfloor - \sqrt{d}$

注意它们的取值范围发现x是reduced 二次有理数

因此 $ x = \lfloor \sqrt{d} \rfloor + \sqrt{d} = [\overline{2\lfloor \sqrt{d} \rfloor,a_1,a_2,...,a_{l-1}}]$

$ = [2\lfloor \sqrt{d} \rfloor,\overline{a_1,a_2,...,a_{l-1},2\lfloor \sqrt{d} \rfloor}]$

$ \sqrt{d}= [\lfloor \sqrt{d} \rfloor,\overline{a_1,a_2,...,a_{l-1},2\lfloor \sqrt{d} \rfloor}]$

根据Galois' Theorem我们有

$\frac{1}{\sqrt{d}-\lfloor \sqrt{d} \rfloor} = -\frac{1}{\overline{x}} = [\overline{a_{l-1},...,a_2,a_1,2\lfloor \sqrt{d} \rfloor}]$

也就是$\sqrt{d} = [\lfloor \sqrt{d} \rfloor,\frac{1}{\sqrt{d}-\lfloor \sqrt{d} \rfloor}]$

$ = [\lfloor \sqrt{d} \rfloor,\overline{a_{l-1},...,a_2,a_1,2\lfloor \sqrt{d} \rfloor}]$

因此得证 循环内容和 回文性质

## Solution to Pell’s Equation

因为平方带来的对称性，只考虑(x>0,y>0)的解

### 根号n的连分数渐进分数的性质

若d为非平方数，$x=\sqrt{d}$,

则存在n以及整数$Q_n,P_n$满足$ x_n=\frac{P_n+\sqrt{d}}{Q_n}$和$d-P_n^2 = 0 (\bmod Q_n)$

显然n=0时$(P_0,Q_0) = (0,1)$满足,然后归纳法，若 n时能满足上述两点性质，则

$x_{n+1} = \frac{1}{x_n-a_n}$

$=\frac{1}{\frac{P_n+\sqrt{d}}{Q_n}-a_n}$

$=\frac{Q_n}{P_n+\sqrt{d}-a_n{Q_n}}$ (通过分母有理化:

$=\frac{Q_n(P_n-a_nQ_n-\sqrt{d})}{(P_n-a_nQ_n)^2-d}$

现在要证明的就是 它是满足$\frac{P_{n+1}+\sqrt{d}}{Q_{n+1}}$的形式,并且满足上面的取模

也就是要证明$P_{n+1}=a_nQ_n-P_n$是整数(显然) 和 $Q_{n+1}=\frac{d-(P_n-a_nQ_n)^2}{Q_n}$是整数

$Q_{n+1} = \frac{d-P_n^2}{Q_n}+2a_nP_n-a_n^2Q_n$

因为n时有 $d-P_n^2 = 0 (\bmod Q_n)$所以 $Q_{n+1}$是整数

又因为$Q_nQ_{n+1}=d-P_{n+1}^2$ 所以  $d-P_{n+1}^2 = 0 (\bmod Q_{n+1})$ 得证

---

对于$n \ge 2$ 要证明 $h_{n-1}^2-d k_{n-1}^2=(-1)^n Q_n$

证明:

$\sqrt{d} = \frac{x_n h_{n-1}+h_{n-2}}{x_nk_{n-1}+k_{n-2}}$

把$ x_n = \frac{P_n+\sqrt{d}}{Q_n}$带入并通分化简

$(P_nk_{n-1}+Q_nk_{n-2}-h_{n-1})\sqrt{d} = P_nh_{n-1}+h_{n-2}Q_n-k_{n-1}d$

即 $P_nk_{n-1}+Q_nk_{n-2}=h_{n-1}$ 且 $P_nh_{n-1}+h_{n-2}Q_n=k_{n-1}d$

所以有 $h_{n-1}^2-dk_{n-1}^2 = h_{n-1}(P_nk_{n-1}+Q_nk_{n-2})-k_{n-1}(P_nh_{n-1}+h_{n-2}Q_n)$

$= Q_n(h_{n-1}k_{n-2}-h_{n-2}k_{n-1})$

$= (-1)^nQ_n$

### 最后一步 连分数和pell方程的关系

假设 $\sqrt{d}$的 最小周期长度为l

那么对应pell 方程的最小解

$(x,y) = {h_{l-1},k_{l-1}}$ 长度为偶数

$(x,y) = {h_{2l-1},k_{2l-1}}$ 长度为奇数

首先假设 (x,y)是 pell方程$x^2-dy^2=1$的解$(d>1,x>y>0)$，所以

$|\sqrt{d} - \frac{x}{y}| = |\frac{dy^2-x}{y^2(\sqrt{d}+\frac{x}{y})}| < \frac{1}{2y^2}$ (从一定程度上说明了 为什么前面要去证明 小于$\frac{1}{2y^2}$

根据前面推的 我们知道满足这个表达式的一定是 渐进值

(Yang.pdf那个paper下面的部分蛮多笔误的 不过能看懂证明思路)

因为我们上面有 $h_{n-1}^2-dk_{n-1}^2=(-1)^nQ_n$ 也就是如果要满足pell方程 那么$|Q_n|=1$，分类讨论$Q_n$

---

$Q_n \neq -1, n > 0$

证明

注意到上面根据$\sqrt{d}$的表达式 证明了$n>0$时，$x_n$是纯循环连分数，也就是reduced

如果$Q_n = -1$ 因为$x_n=\frac{P_n+\sqrt{d}}{Q_n}$,所以有 $x_n=-P_n-\sqrt{d} > 1$,有$-1<-P_n+\sqrt{d} < 0$ (Galois)

有 $\sqrt{d} < P_n < -\sqrt{d} - 1  => 2\sqrt{d} < -1$ 所以$Q_n \neq -1$, 对于$Q_0 = 1$也满足,得证

---

只有n为循环节长度的倍数才有$Q_n = 1$

证明

若于$n>1$若$Q_n=1$那么有$x_n=P_n+\sqrt{d}$，它的共轭 $-1 < P_n-\sqrt{d} < 0 => P_n=\lfloor \sqrt{d} \rfloor$所以 $x_n = \lfloor \sqrt{d} \rfloor + \sqrt{d}$

$ \sqrt{d} = x_0 = \lfloor \sqrt{d} \rfloor + \frac{1}{\frac{1}{\sqrt{d} - \lfloor \sqrt{d} \rfloor}} => x_1 = \frac{1}{\sqrt{d} - \lfloor \sqrt{d} \rfloor}$

$ \lfloor \sqrt{d} \rfloor +\sqrt{d} = x_n = 2\lfloor\sqrt{d}\rfloor + \frac{1}{\frac{1}{\sqrt{d} - \lfloor \sqrt{d} \rfloor}} => x_{n+1} = \frac{1}{\sqrt{d} - \lfloor \sqrt{d} \rfloor}$

说明了 它的下一个数$x_{n+1} $和$x_1$相等, 这说明如果$Q_n = 1$ 那么n是循环节长度的倍数

如果n是循环节倍数 有

$\frac{P_{kl}+\sqrt{d}}{Q_{kl}} = x_{kl} = [\overline{2\lfloor \sqrt{d} \rfloor,a_1,a_2,...,a_{l-1}}] = \sqrt{d}+\lfloor\sqrt{d}\rfloor,(k>0)$

$(P_{kl},Q_{kl}) = (\lfloor\sqrt{d}\rfloor,1)$

对于n=0也满足，充要得证

---

最后回到这里 $h_{n-1}^2-dk_{n-1}^2=(-1)^nQ_n = (-1)^n $ 也就是再看个奇偶，最后得到了pell方程和连分数比较紧密的结论

## 回顾历程

1. pell方程基础解
2. pell方程解存在性
3. 连分数分子分母递推式
4. 连分数，分子分母相关性质(分子分母互质性,原无理数与渐进数差值表达式，差值绝对值单调递减性，连分数是最给定分母以及更小分母中最接近原无理数，任何满足“某不等式”的数字是渐进数（这个不等式是pell方程 的必要条件）)
5. Lagrange’s Theorem 二次无理数与有循环节的连分数
6. Galois’ Theorem 纯循环连分数与reduced二次有理数
7. 根号n的连分数性质（精确的$\frac{P_n+\sqrt{d}}{Q_n}$表示 和 形如pell方程 与$Q_n$的等式）
8. 分类讨论$Q_n$与n的取值最后的结论

方法涉及

1. 二项式展开，不等式，唯一最小(有术语吗)，无理数，反证法
2. 反复抽屉原理，绝对值，无理数，模运算
3. 矩阵乘法，归纳法/递推关系
4. 归纳法/递推，互质，不等式放缩，三角不等式，反证法，二元一次方程组，巧妙正负值+不等式。 很多方法都是多次
5. 归纳，反证，单调+整数离散+有限，二次函数
6. 共轭实数，反向推，归纳法
7. 归纳法,上面的分子分母等式性质
8. -1的幂次,分类讨论，Lagrange,Galois

然后还有很多整数的离散性质

证明过程感受

1. 如果有证明方向，看上去还挺自然的思路
2. 正过来倒过去看，不明白为什么能想到去先找那个不等式,以及中间的X,Y和取值是怎样的思想
3. 挺自然
4. 其实这里都是 为了那个pell方程的必要条件，但是怎么想到这一条路径。另外就是这里面二元一次方程组感觉是不是和上面X,Y是同样的思路，但是我都没有理解到思想根源，怎么能在证明之前，先去做一个分式最后证明这个分式是整数。另外就是这些反复用于后面证明的一些分子分母等式性质。还有一个我不太会的就是多级放缩，到底是原作者自己多次调整最后得出的过程，还是说有什么思路能做到多次放缩来完成目标不等式证明(或反证)
5. 这里的充分和必要完全不是一个难度，这个三元组的设计还是很能简化描述, 我想的方向是去做精确表达式，再做范围，如果证到有限范围即可，总之自己没证明到
6. reduced的性质在这里我不知道怎么用，也不知道为什么要，结果是后面证明需要结论
7. 假设给我要证明的目标，这里可能如果我自己来证明会有一个基本去做的归纳目标，但是证明过程中会衍生出额外的证明目标
8. 难点在说要怎么想到去找$h_{n-1}^2-dk_{n-1}^2=(-1)^nQ_n$这个方向去证，而后面的分类讨论就比较自然

# 代码

似乎还不足以写代码，下面的问题是 如何得到根号n的连分数呢？ 手工 无理数是一个办法，有没有更好的办法呢。

但我们至少说能证明了这个结论

# 参考

[Continued fraction](https://en.wikipedia.org/wiki/Continued_fraction)

[Pell equation](https://en.wikipedia.org/wiki/Pell%27s_equation)

[Yang.pdf](https://www.math.uchicago.edu/~may/VIGRE/VIGRE2008/REUPapers/Yang.pdf)

[stanford crypto pell](https://crypto.stanford.edu/pbc/notes/contfrac/pell.html)

[millersville periodic-continued-fractions][http://sites.millersville.edu/bikenaga/number-theory/periodic-continued-fractions/periodic-continued-fractions.html]

[YouTube:Number Theory:Pell's Equation part 1](https://www.youtube.com/watch?v=E51GKQ1qorE)

[A short proof and generalization of Lagrange’s theorem on continued fractions](https://dspace.sunyconnect.suny.edu/bitstream/handle/1951/69917/fulltext.pdf?sequence=1&isAllowed=y)

[purely periodic continued fractions](http://sites.millersville.edu/bikenaga/number-theory/purely-periodic-continued-fractions/purely-periodic-continued-fractions.html)

# 总结&感受

有些结论在证明过程中其实是缩小了范围，有些结论其实放大定义域之类也是成立的，但我们在证明过程中却只使用了我们所需要的部分。这类的从定义域和对应的要证明的逻辑不是“完美对应”的，但是足够，不知道是好还是不好。

证明的结论之间引用过程，感觉画成网状或者树状关系图会更好？

看youtube了上的讲解视频，会发现有一种写代码的抽取函数感觉，和我上面完全拆开证明不一样，抽函数的感觉其实在数学里大概是叫做“令”+“引理”，感觉和完全展开比较，的确能减少很多心智负担啊！如果你也能打开youtube建议去看看

另外比如有些 强结论要用的时候，即使你证出了相对弱的结论，但没有证明出强结论，其实相当于“没有用”，比如上面 基础解，的平方，的n次方，和任意另一组解能产生新的解的证明。当然如果能证明出，那些就是过程了，但不是步骤（虽然我上面有写进文中，因为要简洁整理的话，直接强结论证明，即可其它的弱的可以直接省略

虽然视频看的时候的确感觉到老师和同学的口算不如国内，但自从自己思考过十进制的意义以后，感觉数值计算都不再重要，有的是计算机，不需要人类来算。

youtuber james cook 有证明一个 同系数二元二次方程 之间的关系，可以用它来 从 不是解的东西里生成解(感觉好像不是特别行，因为一个等式的 四个值仅仅由两个变量控制而不是3个？)！(Quadradic Forms) Q(u+v)+Q(u-v)=2(Q(u)+Q(v)),然后以此建立树，考虑其中的“正负交替路线”river

多核没智力还是搞不动数学啊,

这篇文章整理了很多篇其它资料，所以在符号使用上还不够统一，之后看有空整理一下

在我快写完这一篇文章的时候发现了 一个[超理论坛-连分数入门](https://chaoli.club/index.php/2756/0) 注册需要一点点水平XD，这篇是带着例子讲解写的！(大自看了一下 感觉很棒 推荐), 又 有些性质证明方式不止一种，例如我本篇文章所抄来的证明 二次无理数和有循环节的充要 会感觉更漂亮一些

有些paper写到后面还是很多笔误，不过看通了也是能理解具体过程

有一个想法是 哪些结论是关键或者说证明的难点，其实可以这样想，现在，把文章中一些部分换成填空，你还能不能补全整个文章，不需要完全一样，只要能证明就行。这样想的话，就会知道所谓的难点是在哪。
