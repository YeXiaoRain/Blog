---
title: 模逆元/乘法逆元(CF 入门算法)
date: 2018-12-30 01:37:14
tags: [exgcd,gcd]
category: [algorithm]
mathjax: true
---

# 模逆元/乘法逆元

众所周知,如同线段树/FFT一样,乘法逆元是CF的入门必会算法,然而我只能凭空写线段树

每次遇到需要用乘法逆元,我都是快速搜一个函数代码,复制进来用

之前也反复学懂了三四遍,始终没记住(毕竟用的频率不算高)

以下大自整理总结一下

# 什么是乘法逆元

已知a和p求b, 其中`gcd(a,p)=1`

$a^{ -1 } \equiv b{\pmod {n}}$

# 求法

# 费马小定理

当p是质数时

$a^{p-2} \mod p $

# 扩展欧几里得

既解$\gcd=1$的扩展欧几里得方程, 已知$(a,p)$求一个$(b,k)$

$a\cdot b+p\cdot k = 1$, 其中$k$为某未知整数

把正常计算$\gcd$的过程的细节 写出来`int gcd(int a,int b){return b==0?a:gcd(b,a%b);}`

$a \cdot b+p\cdot k = 1$,

初始为$(a,p)$

把$(d_i,d_{i+1})$ 变为 $(d_{i+1},d_{i+2})$

$d_1 = a + p\cdot c_1$ 分解 式子1 ($c_1 = - a / p, d_1 = a \mod p$)

$d_2 = p + d_1\cdot c_2$ 分解 式子2($c_2 = - p / d_1, d_2 = p \mod d_1$)

$d_3 = d_1 + d_2\cdot c_3$ 分解 式子3

直到$d_i == 0$, 也就是$d_{i+1} = d_{i-1} + d_2 \cdot c_{i+1}$

$gcd(a,p) = gcd(a,p) \cdot 1 + 0 cdot 0$

在算法实现上也就是再分解, 然后反过来把`式子i`带入`式子i+1`

$d_n = d_{n-2} + d_{n-1} \cdot c_n$

$d_n = d_{n-2} + (d_{n-3}+d_{n-2} \cdot c_{n-1}) \cdot c_n$

然后我们只需要记录的是 $d_{n-2}, d_{n-1}$的系数 $gcd(a,p) = d_{n-2} \cdot k_0 + d_{n-1} \cdot k_1$ 

$gcd(a,p) = d_{n-2} \cdot k_0 + (d_{n-3} \cdot 1 + d_{n-2} \cdot c_{n-1}) \cdot k_1$ , 这个 $c_i = - a_i/b_i$ 在回溯过程中 可以得到

$gcd(a,p) = d_{n-3} \cdot k_1 + d_{n-2} \cdot (k_0 - k_1 \cdot a_i / b_i )$

如此展开到最初的a和p即可

```c++
// 返回的 [x,y,z] 满足 a*x+b*y=z
tuple<int,int,int> exgcd(int a,int b){
  if(b==0)
    return {1,0,a};
  auto [x,y,z] = exgcd(b,a%b);
  return  {y,x-(a/b)*y,z};
}
```

**以上代码需要C++17**

要注意的是如果 原来的数据有负数,零,需要在外部处理

# 扩展欧几里得 的矩阵理解

${\begin{pmatrix} a & p \\\\ 1 & 0 \\\\ 0 & 1 \end{pmatrix} } {\begin{pmatrix}x \\\\ y\end{pmatrix}} \Rightarrow {\begin{pmatrix}{a \cdot x + b \cdot y = gcd(x,y) } \\\\ x \\\\ y \end{pmatrix}}$

所以可以建立 `2*3`矩阵,然后对它做列变换,直到 得到`gcd(a,p)`, 这时的 列向量上的 第二第三个值就是`(x,y)`

# 批量求 $< p $ 的 模逆元

## 方法1

妇孺皆知,质数的欧拉筛法,又 模逆元 有 可乘性,

所以 如果 `a=p1*p2`,那么 a的模逆元 = `p1的模逆元*p2的模逆元` mod p

只需要 `O(p+ exgcd平均时间 * ~n/ln n )`

## 方法2

线性递推

$x = p/a$ (整除)

$y = p \mod a < a$

有 $a \cdot x + y = p$

所以 $y = - a \cdot x (\bmod p)$

两边同时乘 逆元 $inv_a \cdot inv_y$

$inv_a \cdot inv_y \cdot y = - a \cdot inv_a \cdot inv_y \cdot x (\bmod p)$

即 $inv_a = - x \cdot inv_y = - (p/a) \cdot inv_{p \bmod a} (\bmod p)$

注意到$ y = p \bmod a < a$,所以 在计算$inv_a$时,$inv_y$ 已经计算好了

又注意处理负号,在mod p的意义下

$- (p/a) \cdot inv_{p \bmod a} = (p - (p/a)) \cdot inv_{p \bmod a} (\bmod p)$

综上

```c++
inv[1] = 1;
rep(i,2,p)
  inv[i] = ((p-p/i)*inv[p%i])%p;
```

# 例题

[CF EDU57 F](https://codeforces.com/contest/1096/problem/F)

# 参考

[wikipedia](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse)

[baidu百科](https://baike.baidu.com/item/%E4%B9%98%E6%B3%95%E9%80%86%E5%85%83/5831857?fr=aladdin)

