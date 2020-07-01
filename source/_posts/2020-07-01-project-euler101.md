---
title: project euler 101 Optimum polynomial
date: 2020-07-01 10:37:14
tags: [pe,project euler,math,Vandermonde]
category: [project euler]
mathjax: true
---

# 题目

https://projecteuler.net/problem=101

https://projecteuler.net/problem=101

# 大意

给你一个多项式表达式

然后 只对前面几项 进行最小幂次拟合，拟合的函数第一个和原函数 不同的输出值的和

原题目很简单，11x11的Vandermonde矩阵求个逆矩阵，甚至都不用处理分数 就搞完了

# hackerrank

然后我发现了这个

https://www.hackerrank.com/contests/projecteuler/challenges/euler101/problem

直接把 矩阵拉到了 3000x3000,然后 多项式的系数是 传入的

首先Vandermonde就需要一个高效求逆的办法，最后再O(n^2)算算

# 高效求逆

为什么要, 因为 我们有了原表达式，要去做拟合 实际就是

${\begin{pmatrix}
{a_0}\\\\
{a_1}\\\\
{a_2}\\\\
{\vdots}\\\\
{a_{n-1}}\\\\
\end{pmatrix}
}^T\begin{pmatrix}
{1}&{1}&{\cdots}&{1}\\\\
{x_{0}}&{x_{1}}&{\cdots}&{x_{n-1}}\\\\
{x_{0}^2}&{x_{1}^2}&{\cdots}&{x_{n-1}^2}\\\\
{\vdots}&{\vdots}&{}&{\vdots}\\\\
{x_{0}^{n-1}}&{x_{1}^{n-1}}&{\cdots}&{x_{n-1}^{n-1}}\\\\
\end{pmatrix}={
\begin{pmatrix}
{y_0}\\\\
{y_1}\\\\
{y_2}\\\\
{\vdots}\\\\
{y_{n-1}}
\end{pmatrix}}^T$

要去计算 左侧的a,如果能快速求逆，那么有

${\begin{pmatrix}
{a_0}\\\\
{a_1}\\\\
{a_2}\\\\
{\vdots}\\\\
{a_{n-1}}\\\\
\end{pmatrix}}^T
={\begin{pmatrix}
{y_0}\\\\
{y_1}\\\\
{y_2}\\\\
{\vdots}\\\\
{y_{n-1}}
\end{pmatrix}}^T
\begin{pmatrix}
{1}&{1}&{\cdots}&{1}\\\\
{x_{0}}&{x_{1}}&{\cdots}&{x_{n-1}}\\\\
{x_{0}^2}&{x_{1}^2}&{\cdots}&{x_{n-1}^2}\\\\
{\vdots}&{\vdots}&{}&{\vdots}\\\\
{x_{0}^{n-1}}&{x_{1}^{n-1}}&{\cdots}&{x_{n-1}^{n-1}}\\\\
\end{pmatrix}^{-1}$

也就是求完逆以后，只需要O(n^2)来得到a

$V(x_0,x_1,\cdots ,x_{n-1})=\begin{bmatrix} {1}&{1}&{\cdots}&{1} \\\\
{x_{0}}&{x_{1}}&{\cdots}&{x_{n-1}}\\\\
{x_{0}^2}&{x_{1}^2}&{\cdots}&{x_{n-1}^2}\\\\
{\vdots}&{\vdots}&{}&{\vdots}\\\\
{x_{0}^{n-1}}&{x_{1}^{n-1}}&{\cdots}&{x_{n-1}^{n-1}}\\\\ \end{bmatrix}$

有 $ V(x_0,x_1,\cdots ,x_{n-1})=\prod _{n > i > j \geq 0}(x _{i}-x _{j})$

众所周知 $A^{-1} = \frac{1}{|A|} A^*$,然而 这暴力算是4次方复杂度，似乎比玩高斯消元3次方还要久

换个方法 拉格朗日插值

想法很简单 比如过点 (1,1) (4,7) (9,100)的二次函数

直接表达式$f(x) = k_1(x-4)(x-9)+k_2(x-1)(x-9) + k_3(x-1)(x-4)$

注意到x取其中一个点时，求和的表达式只有一个不为0

也很明显 $k_i = y_i\prod\limits_{j\not =i}\dfrac{x-x_j}{x_i-x_j}$

$f(x)=\sum\limits_{i=0}^ky_i\prod\limits_{j\not =i}\dfrac{x-x_j}{x_i-x_j}$, 也可以知道它的逆矩阵 就是求和每一部分 的展开式的系数，(令 $y = [0 ... 0 1 0 ... 0]$ 即可知

回到题目$x_i = i+1, y_i = \sum\limits_{p=0}^n A_p(i+1)^p$

$f(x)=\sum\limits_{i=0}^k[y_i\prod\limits_{j\not =i}\dfrac{x-j-1}{i-j}]$

注意到 我们其实只需要求 $f(k+1)$ , 计算 所有$y_i$ O(n^2), 但是右侧看似复杂的$x_i$乘积，因为这里的取值，变成了只需要做阶乘运算即可。可类似前缀和。 再配合一点乘法逆元即可

# 代码

```python
N = 0
A = []
inv = []
po = []
poinv = []
MOD = 1000000007


def u(v):
    r = 0
    vi = 1
    for i in range(0, N+1):
        r += A[i] * vi
        r %= MOD
        vi *= v
        vi %= MOD
    return r


def init():
    # init inv
    global inv
    inv = []
    inv.append(0)
    inv.append(1)
    for i in range(2, N+10):
        inv.append(((MOD - MOD // i) * inv[MOD%i]) % MOD)
    # init power
    global po
    po = []
    po.append(1)
    for i in range(1, N+10):
        po.append( (po[i-1] * i) % MOD )

    global poinv
    poinv = []
    poinv.append(1)
    for i in range(1, N+10):
        poinv.append( (poinv[i-1] * inv[i]) % MOD )


def fitn(y, n):
    r = 0
    for i in range(1, n+1):
        mul = y[i-1]
        # 分子
        mul *= po[n] * inv[n+1-i]
        # 分母乘法逆元
        mul *= poinv[i-1] * poinv[n-i]
        if (n - i) % 2 == 1:
            mul *= -1
        mul %= MOD
        r += mul
        r %= MOD
    return (r+MOD)%MOD


def work():
    init()
    ans = 0
    y = []
    for v in range(1, N+1):
        arr.append(u(v))

    for i in range(1, N+1):
        r = fitn(y, i)
        print(r, end=' ')
        ans += r
    return ans


def pe():
    global N, A
    N = 10
    A = [1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1]
    print(work())


def main():
    global N, A
    N = int(input())
    A = list(map(int, input().split()))
    work()


# pe()
main()
```

至此 我们通过了较难版本的hackerrank 上的pe101


# 参考

http://www.vesnik.math.rs/vol/mv19303.pdf

https://proofwiki.org/wiki/Inverse_of_Vandermonde_Matrix


