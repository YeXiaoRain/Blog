---
title: Newton's method
date: 2022-07-17
tags:
  - NTT
  - 牛顿法
category:
  - algorithm
description: NTT, 牛顿法求逆多项式
---

## Newton’s method on polynomials

希望找到$F(x)$,使得$A(F(x))=0$

- 已知 $F_d(x) \equiv F(x) \mod (x^d)$
- 已知 $[x^0] F(x)$, 即$F_1(x)\equiv [x^0]F(x) \pmod{x^1}$

---

$A(F(x)) = A(F(x)-F_d(x)+F_d(x))$

$= A(F_d(x)) + A'(F_d(x))(F(x)-F_d(x)) + O((F(x)-F_d(x))^2)$

相当于$F(x)$在点 $F_d(x)$展开，（总觉得有点小怪，这里相当于认为所有的都是 能表示成 幂级数（生成函数）的表达？）

那么两边同时 $\mod x^{2d}$

$A(F(x)) \equiv A(F_d(x)) + A'(F_d(x))(F(x)-F_d(x)) \pmod{x^{2d}}$

因此我们可以从 $F_d(x)$推出 $F_{2d}(x)$

$0\equiv A(F_{2d}(x)) \equiv A(F_d(x)) + A'(F_d(x))(F_{2d}(x)-F_d(x)) \pmod{x^{2d}}$

$F_{2d}(x)\equiv F_d(x) - \frac{A(F_d(x))}{A'(F_{d}(x))} \pmod{x^{2d}}$

### 用处

- The Inverse of Formal Power Series
- 计算 在 给定 $\mod x^t$ 下的 $\frac{1}{f(x)}$

那么 利用上面的

我们想求 $\frac{1}{f(x)}$

那么令 $F(x)=\frac{1}{f(x)}$

对应上面的就是 $A(F(x))=F(x)\cdot f(x)-1 = 0$

---

带入上面的结论

$F_{2d}(x)=F_d(x)-\frac{F_d(x)f(x)-1}{f(x)}$

???? 对求逆似乎没有帮助, 感觉题解这里似乎哪里不对？


---

问题在于 令$A$, 重新定义一下$A$

$A(F(x)) = \frac{1}{F(x)}-f(x)$

即 $\displaystyle F_{2d}(x) \equiv F_{d}(x) - \frac{\frac{1}{F_{d}(x)}-f(x)}{-\frac{1}{F_d(x)^2}} \pmod{x^{2d}}$

$F_{2d}(x)\equiv 2F_{d}(x) - F_d(x)^2f(x) \pmod{x^{2d}}$

## 相关

https://atcoder.jp/contests/abc260/editorial/4469

abc 260 ex

abc 345 ex