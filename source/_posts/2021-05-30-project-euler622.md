---
title: project euler 622 (函数周期)
date: 2021-05-30 10:37:14
tags: [数学]
category: [Project Euler]
mathjax: true
---

# 完美洗牌

AAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBB

变为

ABABABABABABABABABABABABABABABABAB

# 次数

52张需要8次变回原型

需要8次的方案的张数和为412

问

需要60次的方案的张数和是多少

# 解

首先 估计已经到2的60次方左右的搜索范围,暴力不可取

递推

`f(i,n) = (i%n)*2+int(i>=n)`


然后我们分开写

`f(i,n) = 2i` (i < n)

`f(i,n) = 2(i-n)+1` (i >= n)

变形

`f(i,n) = 2i - (2n-1)` (i >= n)

合并

`f(i,n) = (2i)%(2n-1)` 这里就很神奇了

相当于每个值的变化都是在乘2,又膜运算有合并性, 所以任何值a的k次后的值为 `(a * 2^k) % (2n-1)`

所以要所有都会到原位其实就是 任意 a, `a = (a * 2^k) % (2n-1)`

a取1,也是最大循环节

题目变成 $(2^60-1)%(2n-1) = 0$ 且 $(2^(<60)-1)%(2n-1) != 0$

质因数分解一下就好

# 总结

关键在 int(i>=n)的那个表达式转换成纯的模运算表达式,后面都好做了

