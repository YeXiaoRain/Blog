---
title: 一个积分
date: 2020-08-29 01:28:19
tags: [\integral]
category: [math]
mathjax: true
---

# 题目 & 解答

$ \int_0^1 (x-x^2)^n dx$ (换元$t=x-\frac{1}{2}$

$= \int_{-\frac{1}{2}}^{\frac{1}{2}} (\frac{1}{4} - x^2)^n dx$ (偶函数

$= 2 \int_{0}^{\frac{1}{2}} (\frac{1}{4} - x^2)^n dx $(换元$t=2x$

$= \frac{1}{4^n}\int_0^1 (1 - x^2)^n dx$(换元$t=sin(x)$

$= \frac{1}{4^n} \int_0^{\frac{\pi}{2}} (1 - sin(x)^2)^n d(sin(x))$

$= \frac{1}{4^n} \int_0^{\frac{\pi}{2}} cos(x)^{2n+1} d x$ (`Wallis'_integrals`

$= \frac{1}{4^n} \cdot \frac{2n(2n-2)\cdots 2}{(2n+1)(2n-1)3}$
