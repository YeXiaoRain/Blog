---
title: Möbius inversion formula
date: 2019-01-06 11:20:14
tags: [Möbius function]
category: [code]
mathjax: true
---

# Möbius function

${\displaystyle \mu (n)=\delta _{\omega (n)}^{\Omega (n)}\lambda (n)}$

where ${\displaystyle \delta }$  is the Kronecker delta, λ(n) is the Liouville function, ω(n) is the number of distinct prime divisors of n, and Ω(n) is the number of prime factors of n, counted with multiplicity.

---

μ(n) = 0 if n has a squared prime factor.

μ(n) = 1 if n is a square-free positive integer with an even number of prime factors.

μ(n) = −1 if n is a square-free positive integer with an odd number of prime factors.

上面是 Möbius function 的定义

> 它具有的性质

${\displaystyle \sum _{d\mid n}\mu (d)={\begin{cases}1&{\text{if }}n=1,\\\0&{\text{if }}n>1.\end{cases}}}$

> 性质的证明

首先 要μ(x) != 0

需要x的各个质因子次数恰好为1

假设n的所有质因子有t个,既 $n = p_1^{a_1} * p_2^{a_2}...p_t^{a_t}$

那么 所有是n的因子的x 且$\mu(x) \neq 0$ 的x,则为这t个质因子的组合

注意到 不包含平方数的 Möbius function也可以写成

$\mu(n) = (-1)^{t}$, 其中n不包含平方数,t为其质因子个数

${\displaystyle \sum _{d\mid n}\mu (d)= \sum_{k=0}^{t} {t \choose k}x^{k} = (1-1)^t = 0}$

证毕

---

wikipedia上,还有写些其它性质

例如 μ(ab) = μ(a) μ(b) ,当 a和b互质

不过和本文的关系不大,就没有 copy paste过来

# Möbius inversion formula

如果 f和g都是算数函数,且

$g(n)=\sum_{d\,\mid \,n}f(d)\quad\text{for every integer }n\ge 1$

那么有

${\displaystyle f(n)=\sum _{d\,\mid \,n}\mu (d)g\left({\frac {n}{d}}\right)\quad {\text{for every integer }}n\geq 1}$

> 证明

${\displaystyle \sum _{n\mid x}\mu (n)g\left({\frac {x}{n}}\right)}$

${\displaystyle =\sum _{n\mid x}\mu (n)\sum _{m\mid {\frac {x}{n}}}f\left(m\right)}$

${\displaystyle=\sum _{m\mid x}f\left(m\right)\sum _{n\mid \frac{x}{m}}\mu (n)}$ (n能取到所有x的因子,m也能取到,且满足n,m其中一个确定时,另一个取值使得n*m为x的因子)

${\displaystyle=f(x)}$

见上面Möbius function的性质,也就是仅在m=x时 右侧的sum 才不为0,且为1


# 实例代码


# 相关延伸


# 练习题目

[CF Hello 2019 F](https://codeforces.com/contest/1097/problem/F)

# 参考

[Möbius inversion formula](https://en.wikipedia.org/wiki/M%C3%B6bius_inversion_formula)

[Möbius function](https://en.wikipedia.org/wiki/M%C3%B6bius_function)

[OEIS A008683](https://oeis.org/A008683)

https://mathlesstraveled.com/2016/11/29/the-mobius-function-proof-part-1/

https://mathlesstraveled.com/2016/09/08/post-without-words-11/

http://2000clicks.com/MathHelp/NumberTh06MobiusFunction.aspx
