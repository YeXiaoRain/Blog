---
title: maspy 生成方程与问题解决
date: 2022-08-12 22:24:00
tags: [生成方程]
category: [algorithm]
mathjax: true
---

# 生成方程

感谢google翻译和maspy大佬的几篇博客, 见下方链接


用很多例子来实例如何使用 多项式乘积

状態ごとに何らかの値が計算されているときに、その計算結果を多項式の形で持ちます。この際、 「多項式の次数」が「考えている状態」、「係数」が状態ごとの「計算した値」（多くの場合、数え上げ）を表すように多項式を持つのが原則です。

括号内是或关系, 括号间幂次是加和关系,系数是代价倍数一般是1

翻译了一下, 统一了一下格式,增加了一些步骤

以下未强调的都是非负整数

注意的是有不少都可以写成无限次方的上限,因为超过n不会影响n,看具体情况哪个更好用用哪个

## maspy 1 如何把问题转化

> 问题1, $A=\\{2,3\\},B=\\{2,4\\},C=\\{3,5,7\\} , a+b+c=n$ 有多少种方法可以

$\lbrack x^n \rbrack (x^2+x^3)(x^2+x^4)(x^3+x^5+x^7)$, 就是乘开后$n$次项的系数

> 问题2. $a \le 2,b\le 3,c\le 4, a+b+c = n$ 有多少种

$\lbrack x^n \rbrack (1+x+x^2)(1+x+x^2+x^3)(1+x+x^2+x^3+x^4)$

> 问题3. 无限制的$a,b,c \ge 0, a+b+c=n$ 有多少种

$\lbrack x^n \rbrack (1+x+x^2+\cdots)^3$

$\lbrack x^n \rbrack (1+x+x^2+\cdots+x^n)^3$, (因为高次不影响n

> 问题4(ABC149E), $A=\\{a_1,a_2,\cdots,a_k\\}, n = a_i + a_j$ 有多少种

$\lbrack x^n \rbrack (x^{a_1}+x^{a_2}+\cdots+x^{a_k})^2$

> 问题5, 从1开始,每次+2或+3, 恰好n次移动到N的方案数

$\lbrack x^{N-1} \rbrack (x^2+x^3)^n$, 从增量的角度

$\lbrack x^{N} \rbrack x(x^2+x^3)^n$, 从状态的角度

> 问题6, 从1开始,每次+2或+3, 移动到N的方案数

$\lbrack x^{N-1} \rbrack \sum_{n=0}^{\infty}(x^2+x^3)^n$

$\lbrack x^{N-1} \rbrack \sum_{n=0}^{\frac{N}{2}}(x^2+x^3)^n$

> 问题7, 1元,5元,10元有无限多, 组合成n元方案数

$\lbrack x^{n} \rbrack (1+x^1+x^2+x^3+\cdots)(1+x^5+x^{10}+x^{15}+\cdots)(1+x^{10}+x^{20}+x^{30}+\cdots)$

> 问题8, 重量分别$w_i$, 总重量不超过$W$ 有多少方案

$\sum_{n=0}^W \lbrack x^n \rbrack (1+x^{w_1})(1+x^{w_2})\cdots (1+x^{w_k})$

$\sum_{n=0}^{W}[x^n]\prod_{i=1}^k$

> 问题9, $0\le a_i \le N$, $a_1+\cdots+a_8=6N$ $a_i$的方案数

$\lbrack x^{6N} \rbrack (1+x^1+x^2+\cdots+x^N)^8$

> 问题10, $0\le a,b,c \le N$且为素数,$a+b+c$ 也是素数方案数

$\sum_{p=2}^{3N} \lbrack x^{p} \rbrack (x^2+x^3+x^5+x^7+\cdots+x^{prime,\le N})^3$, 且$p$为素数

> 问题11, $N$ 拆成正整数求和表达式(关心顺序)

$\sum_{n=1}^{\infty} \lbrack x^{N} \rbrack (x^1+x^2+x^3+\cdots+x^N)^n$

$\sum_{n=1}^{N} \lbrack x^{N} \rbrack (x^1+x^2+x^3+\cdots+x^N)^n$

$\lbrack x^{N} \rbrack \sum_{n=1}^{N} (x^1+x^2+x^3+\cdots+x^N)^n$

> 问题12, $N$ 拆成正整数求和表达式, 但是数字从小到大(不关心顺序)

$\lbrack x^{N} \rbrack \prod_{k=1}^{\infty} (\sum_{i=0}^{\infty} x^{ki})$, 相当于数字相同的视作一致,只有每个的数字的个数

$\lbrack x^{N} \rbrack \prod_{k=1}^{n} (\sum_{i=0}^{n} x^{ki})$

> 问题13, $N$ 拆成多个不同整数的和, 但是数字从小到大(不关心顺序)

$\lbrack x^{N} \rbrack \prod_{k=1}^{\infty} (1+x^k)$, 选或不选

$\lbrack x^{N} \rbrack \prod_{k=1}^{N} (1+x^k)$

> 问题14, $N,M > 0, 0 < A_1 \le A_2 \le \cdots \le A_N = M$, 相邻$A_i$的差在$[3,5]$, 求方案数

$\lbrack x^M \rbrack (x^1+x^2+\cdots+x^M)(x^3+x^4+x^5)^{N-1}$, 相当于一个是$A_1$ 的选择,后面是增加到$A_N$的选择

> 问题15, $N,M > 0, 0 < A_1 \le A_2 \le \cdots \le A_N < M$, 相邻$A_i$的差在$[3,5]$, 求方案数, 和上面不同的是最后

$\sum_{m=0}^{M-1} \lbrack x^m \rbrack (x^1+x^2+\cdots+x^m)(x^3+x^4+x^5)^{N-1}$, 相当于枚举$A_N$的值

$\lbrack x^M \rbrack (x^1+x^2+\cdots+x^M)(x^3+x^4+x^5)^{N-1}(x^1+x^2+\cdots+x^M)$, 相当于想象多一个$A_{N+1} = M$

> 问题16, $[1,6]$的骰子,扔100次, 总和为$n$的概率

$\lbrack x^{n} \rbrack (\frac{x^1+x^2+x^3+x^4+x^5+x^6}{6})^{100}$ 这里系数终于不是1了,而是概率倍数的贡献

> 问题17, $p+q = 1,p,q\ge 0$是 实数概率, $p$概率$+1$,$q$概率$-1$, 总和$=100$的概率

$\lbrack x^{n} \rbrack (px+qx^{-1})^{100}$ , 这里一个是再次展示了系数,一个是出现了负数幂次, 称作 Laurent polynomial, 几乎没有区别 

$\lbrack x^{n+100} \rbrack x^{100}(px+qx^{-1})^{100}$

$\lbrack x^{n+100} \rbrack (px^2+q)^{100}$

> 问题18(AGC013E), 对N划分成有序的正整数的和, 划分后 获得价值 = 所有正整数的平方的乘积, 求所有方案的 价值和

$\lbrack x^N \rbrack \sum_{n=0}^{N} (x+4x^2+9x^3+16x^4+\cdots+N^2x^N)^n$, 代价拆散到每个选择上

### 高维

> 问题19, A:3元,4克; B:5元,6克, 每个最多选2个, 构成n元,m克的方案数

$\lbrack x^ny^m \rbrack (1+x^3y^4+x^6y^8)(1+x^5y^6+x^{10}y^{12})$

> 问题20, 1元,5元,10元,无限个, 用n个,组成m元方案数

$\lbrack x^my^n \rbrack (1+x^1y^1+x^2y^2+x^3y^3+\cdots)(1+x^5y^1+x^{10}y^2+x^{15}y^3+\cdots)(1+x^{10}y^1+x^{20}y^2+x^{30}y^3+\cdots)$

> 问题21(ARC012D), 每次随机$x\pm 1$或$y\pm 1$, 问$(0,0)$在恰好$T$次走到$(a,b)$的概率

$\lbrack x^ay^b \rbrack (\frac{x+x^{-1}+y+y^{-1}}{4})^T$

> 问题22, $x,y,z$ 每次随机一个$\pm 1$或 全部一起$\pm 1$, 问$(0,0,0)$在恰好$T$次走到$(a,b,c)$的方案数

$\lbrack x^ay^bz^c \rbrack (x+x^{-1}+y+y^{-1}+z+z^{-1}+xyz+(xyz)^{-1})^T$, 很能表达或关系

[21,22, maspy 具体计算方案](https://maspypy.com/atcoder-k-one-or-all%ef%bc%88kupc-2019%ef%bc%89)

> 问题23, $(x,y,z)$ 每次任意非0正增量,任意维度变化$\ge 0$, 至少一个维度变化$ > 0$, 求原点到$(a,b,c)$的方案数

$\lbrack x^ay^bz^c \rbrack \sum_{n=0}^{\infty} ((1+x+x^2+x^3+\cdots)(1+y+y^2+y^3+\cdots)(1+z+z^2+z^3+\cdots) - 1)^n$

> 问题24, $(x,y,z)$ 每次随机一个方向随机$\pm 1$, T次,$3a+4b+5c=n$的概率

$\sum_{3a+4b+5c=n} \lbrack x^ay^bz^c \rbrack (\frac{x+x^{-1}+y+y^{-1}+z+z^{-1}}{6})^T$

$\lbrack t^n \rbrack (\frac{t^3+t^{-3}+t^4+t^{-4}+t^5+t^{-5}}{6})^T$, 其实对各个坐标没限制 只对总和限制,$3,4,5$看成贡献倍数

## maspy 2 如何计算

### 二项式定理

$(x+y)^n = \sum_{i=0}^{n} \binom{n}{i} x^iy^{n-i}$

其中$\binom{n}{i} = \frac{n!}{i!(n-i)!}$是排列数, 为了方便当$ i < 0 $或$ i > n$ 时令它为$0$

$(x+y)^n = \sum_{i=0}^{\infty} \binom{n}{i} x^iy^{n-i}$

### 等比数列求和

$r\neq 1$时

$\sum_{i=0}^{n} r^i = \frac{1-r^{n+1}}{1-r}$

### 形式幂级数 运算法则

形式幂级数 $F = \sum_{n=0}^{\infty} f_nx^n$

若$G = \sum_{n=0}^{\infty} g_nx^n$

加减: $\lbrack x^n \rbrack (F\pm G) = f_n \pm g_n$

乘法: $\lbrack x^n \rbrack (FG) =  \sum_{i+j=n}f_ig_j.$

在运算中可以 只考虑 小于等于 $x^n$的部分

满足,交换律,结合律,分配律, 被称作 环

### 形式的べき級数環の位相

形式的べき級数$F$は、最低次の項が高いほど、 $0$に近いと考えて扱います。このことを利用して、形式的べき級数の列の極限を定義することができます：

【定義】

形式的べき級数列$F1,F2,F3\cdots F$ に収束するとは、任意の$k$ に対してある$N$が存在して、$n\ge N$ ならば $F_n$ と $F$ の $k$ 次未満部分が一致することを指す。

我没看懂翻译以后的XD

### 形式幂级数的倒数

$FG = 1$, 则$F = \frac{1}{G}$

也可以和正常分数类似的计算规则$\frac{F_1}{G_1}\pm\frac{F_2}{G_2}=\frac{F_1G_2\pm F_2G_1}{G_1G_2}$

最常用的一个

$\frac{1}{1-x} = 1 + x + x^2 + x^3 + x^4 + \cdots = \sum_{n=0}^{\infty}x^n$

因为$(1-x)(1+x+x^2+x^3+\cdots) $, 而对于一个具体$x^n$ 前面乘了以后会变成$1-x^{\infty}$, 又高于$x^n$不会对$x^n$的系数有影响, 所以即使 从级数收敛角度看起来 $x \ge 1$ 时它不收敛, 但从求系数意义上它是合理 

对于**没有常数项的**多项式 $F$, 也有, 原理也是相同的, 也需要注意没有常数项

$\frac{1}{1-F} = 1 + F + F^2 + F^3 + F^4 + \cdots  = \sum_{n=0}^{\infty}F^n.$

### 幂级数 示例

> 问题 N拆成正整数和的表达式

前面已经有转换了

$\lbrack x^N \rbrack \sum_{n=0}^{\infty} (x+x^2+x^3+\cdots)^n$

然后利用这里幂级数

$ = \lbrack x^N \rbrack \sum_{n=0}^{\infty} (\frac{x}{1-x})^n$

$ = \lbrack x^N \rbrack \frac{1}{1- \frac{x}{1-x}}$

$ = \lbrack x^N \rbrack \frac{1-x}{1-2x}$

$ = \lbrack x^N \rbrack (1-x)(1+2x+4x^2+8x^3+\cdots)$

$ = 2^N - 2^{N-1}$

$ = 2^{N-1} $

同样在分数过程也可以简化掉 分子

$ = \lbrack x^N \rbrack \frac{1-x}{1-2x}$

$ = \lbrack x^N \rbrack \frac{1}{2} + \frac{1}{2} \cdot \frac{1}{1-2x}$

$ = \lbrack x^N \rbrack \frac{1}{2} + \frac{1}{2}(1+2x+4x^2+8x^3+\cdots)$

### 因式分解 示例

> 问题 $\lbrack x^ay^b\rbrack(x+x^{-1}+y+y^{-1})^T$

$ = \lbrack x^ay^b \rbrack ((xy)^{-1}(xy+1)(x+y))^T$

$ = \lbrack x^ay^b \rbrack \sum_{i,j} \binom {T}{i}\binom{T}{j}x^{i+j-T}y^{i-j}.$

只会有唯一的$(i,j)$

### 积累和 推到 dp转换

> 问题 $xi \in [0,a_i]$, 选择$x_1+\cdots+x_N = M$, 找出方案数, $a_i \le M \le 10^5, N \le 100$

$\lbrack x^M \rbrack \prod_{i=1}^N (\sum_{j=0}^{a_i} x^j)$

$\lbrack x^M \rbrack \prod_{i=1}^N \frac{1-x^{a_i+1}}{1-x}$

---

分解成一个稀疏多项式(项少,就可以DP)的方法, $(1-x)Q = P$, 那么$p_n = q_n-q_{n-1}$, 有可以$q_n = q_{n-1}+p_n$递推

$1-x^{a_i+1}$ 也是类似, 相当于$dp[j] = dp[j] - dp[j-(a_i+1)]$

这样是$O(NM)$, 这里$NM \le 10^7$ 可做

据说$N = 1e5$ 也有方法可搞?

### DP的推导返回

> 问题 $xi \in [0,a_i]$, 选择$x_1+\cdots+x_N = M$, 找出方案数
> 但是Q个独立询问, 让$x_{p_j} = c_j$
> $a_i \le M \le 2000, N \le 2000, Q \le 500000$

对i以外的前后缀来计算 $\prod$, 再用FFT 可以得到

另一个思路是,能否接受除法

先算出所有的$\prod$ 再除以被更改部分的

### 交换律 和 迭代平方法

没看懂翻译

----

鸽

### 负二项式定理

$(1-rx)^{-d} = \sum_{n=0}^{\infty}\binom{n+d-1}{d-1}(rx)^n$

证明:

归纳+导数, 可证 `-d`成立,那么`-d-1`也成立

这个在百度百科上也有

$(1+x)^{-d} = \sum_{n=0}^{\infty} (-1)^n \binom{d+n-1}{n}x^n$


## Ref

[maspy](https://maspypy.com/category/%e5%bd%a2%e5%bc%8f%e7%9a%84%e3%81%b9%e3%81%8d%e7%b4%9a%e6%95%b0%e8%a7%a3%e8%aa%ac)

[百度百科 二项式定理推广](https://baike.baidu.com/item/%E4%BA%8C%E9%A1%B9%E5%BC%8F%E5%AE%9A%E7%90%86)
