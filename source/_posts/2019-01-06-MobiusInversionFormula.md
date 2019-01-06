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

μ(n) = 1 if n is a square-free positive integer with an even number of prime factors.

μ(n) = −1 if n is a square-free positive integer with an odd number of prime factors.

μ(n) = 0 if n has a squared prime factor.

上面是 Möbius function 的定义

> 它具有的性质

μ(ab) = μ(a) μ(b) ,当 a和b互质

${\displaystyle \sum _{d\mid n}\mu (d)={\begin{cases}1&{\text{if }}n=1,\\\0&{\text{if }}n>1.\end{cases}}}$

wikipedia上,还有些性质,不过和本文的关系不大,就没有 copy paste过来

# Möbius inversion formula

如果 f和g都是算数函数,且

$g(n)=\sum_{d\,\mid \,n}f(d)\quad\text{for every integer }n\ge 1$



# 实例代码

[CF R488 Div1 E ACCEPTED](https://codeforces.com/contest/993/submission/47860243)

# 相关延伸


# 练习题目

[CF Hello 2019 F](https://codeforces.com/contest/1097/problem/F)

# 参考

[Möbius inversion formula](https://en.wikipedia.org/wiki/M%C3%B6bius_inversion_formula)

[Möbius function](https://en.wikipedia.org/wiki/M%C3%B6bius_function)

[OEIS A008683](https://oeis.org/A008683)
