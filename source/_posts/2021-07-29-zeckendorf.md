---
title: Zeckendorf's theorem
date: 2021-07-29 10:37:14
tags: [algorithm]
category: [algorithm]
mathjax: true
---

# 定理

任何正整数都可以唯一表示成不连续的Fibonacci数列和

# 相关

Finonacci数列, 以1，2开始, 每一项=前两项之和

# proof

## 可表示性

对于任意自然数n

有唯一i使得 $fib(i) <= n < fib(i+1)$

说明 $fib(i) > n/2 $ 否则 $fib(i+1) = fib(i)+fib(i-1) < fib(i)+fib(i) = 2fib(i) <= n$ 矛盾

$n-fib(i) < n/2$

$n-fib(i) < fib(i-1)$, 否则 $n >= fib(i)+fib(i-1) = fib(i+1)$，保证了非连续

说明$f(n)$ 的表示通过拆除fib(i)方案数与 $f(n-fib(i))$ 一致，

所有都是唯一可递归下降，f(0) 唯一表示为空

所以所有都可以表示

## 下面证明唯一表示

上面我们每次取得都是不大于n的最大的fib(i), 这种情况下非连续且可表示

下面证明如果不这样操作，则不可表示，就能证明其唯一性

$fib(i) <= n < fib(i+1)$

证明$fib(i-1)+fib(i-3)+fib(i-5)+... < fib(i) < n$


$1 + fib(i-1)+fib(i-3)+fib(i-5)+... = fib(i) $

$fib(i-1)+fib(i-3)+fib(i-5)+... = fib(i) - 1 < fib(i) = n$

得到 如果不取$fib(i)$,那么最大的非连续和无法构成n，则唯一性得证

