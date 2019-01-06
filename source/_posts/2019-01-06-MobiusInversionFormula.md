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

wikipedia上,还有些性质

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

${\displaystyle=\sum _{m\mid x}f\left({\frac {x}{m}}\right)\sum _{n|m}\mu (n)}$

${\displaystyle=f(x)$

见上面Möbius function的性质


# 实例代码


# 相关延伸


# 练习题目

[CF Hello 2019 F](https://codeforces.com/contest/1097/problem/F)

# 参考

[Möbius inversion formula](https://en.wikipedia.org/wiki/M%C3%B6bius_inversion_formula)

[Möbius function](https://en.wikipedia.org/wiki/M%C3%B6bius_function)

[OEIS A008683](https://oeis.org/A008683)
