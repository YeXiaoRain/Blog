---
title: Möbius inversion formula
date: 2019-01-06 11:20:14
tags: [Möbius function]
category: [code]
mathjax: true
---

# Möbius function

${\displaystyle \mu (n)=\delta _{\omega (n)}^{\Omega (n)}\lambda (n)}$

${\displaystyle \delta }$  是 Kronecker delta, λ(n) 是 Liouville 函数, ω(n) 是n的不同的质因数个数，Ω(n) 是质因子个数

## 定义

μ(n) = 0 如果n的质因子有幂次大于1的

μ(n) = 1 如果n由偶数个不同质数相乘

μ(n) = −1 如果n由奇数个不同质数相乘

## 性质

${\displaystyle \sum _{d\mid n}\mu (d)={\begin{cases}1&{\text{if }}n=1,\\\0&{\text{if }}n>1.\end{cases}}}$

有的地方写作

$\mu * 1 = \epsilon$ 其中星号表示狄利克雷卷积(https://en.wikipedia.org/wiki/Dirichlet_convolution),正好对应的是 要因子

### 性质的证明

首先 要`μ(x) != 0`

需要x的各个质因子次数恰好为1

假设n的所有质因子有t个,既 $n = p_1^{a_1} * p_2^{a_2}...p_t^{a_t}$

那么 所有是n的因子的x 且$\mu(x) \neq 0$ 的x,则为这t个质因子的组合

注意到 不包含平方数的 Möbius function也可以写成

$\mu(n) = (-1)^{t}$, 其中n不包含平方数,t为其质因子个数

${\displaystyle \sum _{d\mid n}\mu (d) = \sum _ {k=0}^t {t \choose k}(-1)^{k} = (1-1)^t = 0 }$

证毕

## 积性函数

Möbius function 是 积性函数!! 根据积性函数定义 如果gcd(a,b) == 1 有 f(ab)=f(a)*f(b)

$\mu(ab) = \mu(a) \mu(b)$ ,当 a和b互质

wikipedia上,还有写些其它性质


不过和本文的关系不大,就没有 copy paste过来

# Möbius inversion formula

如果 f和g都是算数函数,且

$g(n)=\sum_{d\,\mid \,n}f(d)\quad\text{对所有整数 }n\ge 1$

g(n)表示它所有因子对应的f的和,所以一旦有题目F(x) = sum 所有f(y),y是x的因子，就可以联想到反演

那么有

${\displaystyle f(n)=\sum _{d\,\mid \,n}\mu (d)g\left({\frac {n}{d}}\right)\quad {\text{对所有整数 }}n\geq 1}$

> 证明

${\displaystyle \sum _{n\mid x}\mu (n)g\left({\frac {x}{n}}\right)}$

${\displaystyle =\sum _{n\mid x}\mu (n)\sum _{m\mid {\frac {x}{n}}}f\left(m\right)}$

${\displaystyle=\sum _{m\mid x}f\left(m\right)\sum _{n\mid \frac{x}{m}}\mu (n)}$ (n能取到所有x的因子,m也能取到,且满足n,m其中一个确定时,另一个取值使得n*m为x的因子)

${\displaystyle=f(x)}$

见上面Möbius function的性质,也就是仅在m=x时 右侧的sum 才不为0,且为1

# 实现

线性筛

```c++
const int maxn = 100000000;
int prime[maxn], tot, mu[maxn];
bool check[maxn];
void calmu(){
  mu[1] = 1;
  rep(i,2,maxn){
    if (!check[i]){
      prime[tot++] = i;
      mu[i] = -1;
    }
    rep(j,0,tot){
      if (i * prime[j] >= maxn) break;
      check[i * prime[j]] = true;
      if (i % prime[j] == 0){
        mu[i * prime[j]] = 0;
        break;
      }else
        mu[i * prime[j]] = -mu[i];
    }
  }
}
```

# 练习题目

[CF Hello 2019 F](https://codeforces.com/contest/1097/problem/F)

# 参考

[Möbius inversion formula](https://en.wikipedia.org/wiki/M%C3%B6bius_inversion_formula)

[Möbius function](https://en.wikipedia.org/wiki/M%C3%B6bius_function)

[OEIS A008683](https://oeis.org/A008683)

https://mathlesstraveled.com/2016/11/29/the-mobius-function-proof-part-1/

https://mathlesstraveled.com/2016/09/08/post-without-words-11/

http://2000clicks.com/MathHelp/NumberTh06MobiusFunction.aspx

https://www.youtube.com/watch?v=XKjQcPNWMo0

https://www.youtube.com/watch?v=-blqpqbgu0Q
