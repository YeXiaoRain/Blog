---
title: project euler 216 (质数判别)
date: 2021-06-12 10:37:14
tags: [数学,质数]
category: [Project Euler]
mathjax: true
---


# 题目

1<= n <=50'000'000

求让 $2n^2-1$ 为质数的有多少

# 尝试

## 裸暴力

显然我们枚举n,然后每个计算到 $\sqrt{n}$, 时间复杂度$O(n^{1.5})$

在n取这么大,要大概一个小时, 显然不满足pe的期望1min

## 优化1

显然如果 $ 2n^2-1 = 0 (\bmod b)$

那么有 $ 2(b+n)^2-1 = 0 (\bmod b)$, 且这是充要的

这有两个好的性质,并不要求$2n^2-1$是质数或者合数

对于给定b总能找到一个小于b的n

---

看上去很美好,而实际操作上,也能降低一定的复杂度,不过这个方法空间要求很大,而上面的暴力是O(1)空间

其2每次进行筛的时候也不算快,也有不少重复筛的

## 优化2

我们存不下$2n^2-1$的质数,但是可以预运算$\sqrt{2n^2-1}$的质数 进行一定的提速

# 如何判断质数

## Level 1

裸暴力,从2到开根

## Level 2

众所周知 费马小定理$a^{p-1} = 1 (\bmod p), gcd(a,p) = 1$

当然这个表达式 p是质数一定成立,但是成立并不一定是质数

## Level 3

尝试多个a的费马小定理,

依然是"概率"运气的判断,

依然可能表达式成立,但p不是质数

## Level 4 Miller-Rabin

把费马小定理的$p-1$拆解成$p-1 = 2^k (2m+1), m\ge 0$

也就是 2幂次和奇数的乘积

如果p是质数,我们有 $2^{2^k(2m+1)} = 1 (\bmod p)$

也就是 $2^{2^{k-1}(2m+1)} = \pm 1 (\bmod p)$

如果 $2^{2^{k-1}(2m+1)} = 1 (\bmod p)$

那么 $2^{2^{k-2}(2m+1)} = \pm 1 (\bmod p)$

同样,我们可以尝试多个a

这样的话"运气"能好很多,本身还是概率的做法

## Level 5

http://miller-rabin.appspot.com/

我们用别人的答案!

Jim Sinclair证明了如果a的取值把下面都测试一遍,那么在 $p<2^{64}$时,都是能判断质数的!

2, 325, 9375, 28178, 450775, 9780504, 1795265022

还是Miller-Rabin,不过我们使用了已有成果,(好奇是证明,还是暴力枚举,毕竟是2011-04-20的事情了

## Level 6 AKS

上面要么慢,要么基于概率(或有限范围的历史答案)

$(x-a)^n = x^n-a (\bmod n), gcd(\forall a,n) = 1$,

n是质数时,根据2项式定理显然,

如果n 合数, $(X-a)^n - X^n-a $ 看成 $X$为变量, 其余部分为系数

那么 $X^i$的系数为$C(n,i) a^{n-i}$

把合数表示成其构成的质数相乘$n = p_1^m \cdots$, 那么2项式中$C(n,p_1) \neq 0 (\bmod p_1^m )$,因为$C(n,p_1) = \frac{n!}{p!(n-p)!}= \frac{(n-p+1)...(n)}{1...p}$ 分子只有n是p的倍数,分母只有p是n的倍数

所以$C(n,p_1)a^{n-p_1} \neq 0 (\bmod p_1^m)$ (因为a和n互质,不会包含因子$p_1$) 也说明 $C(n,p_1)a^{n-p_1} \neq 0 (\bmod n)$

注意我们$(X-a)^n - X^n-a $ 看成 $X$为变量, 其余部分为系数,后就是一个 f(X)的表达式, 有系数非零

例如 n = 4

$(x+a)^4 = x^4+C(4,1)ax^3+C(4,2)a^2x^2+C(4,3)a^3x+a^4 = x^4 + C(4,2)a^2x^2+a^4 (\bmod 4)$

$(x+a)^4 -(x^4+a) = 6a^2x^2+a^4-a (\bmod 4)$

想存在$x,gcd(a,4) = 1$,使得 $6a^2x^2+a^4-a \neq (\bmod 4)$, 我们的确能找到 a=1,x=1,有些地方说,

既然是关于x有系数的表达式,或者项数差异,说明它在模意义下非恒为零??? 这是模运算的什么定理吗

> 小证? 写成 系数乘上 x的从1取到n的范得Vandermonde 矩阵, 系数和结果都对n取mod,所以只能全是零才有解? 甚至如果希望陪结果,可以反向推?**脑补证明的感觉可能有误**. 比如如果要按mod算的话,那vandermonde矩阵的n列就全是0和部分 位置XD

但是要中间的系数全是n的倍数上面已经证明

有的地方说主要是等式而不是值?

TODO

## 其它

$(n-1)! = -1 (\bmod p)$ 当且仅当 p为质数,陶哲轩的书上也有这个

效率更差, 在一些特定场景有用

# Code

```cplusplus
#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
typedef uint64_t ull;
#define rep(i,a,n) for (ll i=a;i<n;i++)

// overflow
ll quick_p(__int128_t b, ll p,const ll mod){
  __int128_t r = 1;
  while(p){
    if(p%2)(r*=b)%=mod;
    (b*=b)%=mod;
    p/=2;
  }
  return r%mod;
}

ll mr(ll base,ll v){
  if(base > v)return true;
  ll startp = v-1;
  while(startp%2 == 0)startp>>=1;
  ll p = startp;
  __int128_t r = quick_p(base,p,v);
  while(p != v-1){
    if(r == v-1)return true;
    if(r == 1)return p == startp;
    p*=2;
    // overflow
    (r*=r)%=v;
  }
  return false;
}

bool is_prime_64(ll v){
  if(v < 2)return false;
  if(v < 4)return true;
  // %6 = 1 or 5
  if((v % 6) % 4 != 1)return false;
  ll test_g[] = {2, 325, 9375, 28178, 450775, 9780504, 1795265022};
  rep(i,0,7){
    if(!(mr(test_g[i],v)))return false;
  }
  return true;
}

bool isp(ll v){
  rep(i,2,v){
    if(i*i>v)return true;
    if(v%i == 0)return false;
  }
  return true;
}

int main(){
  ll ans = 0;
  rep(i,2,50'000'000+1){
    if(i % 500'000 == 0){
      printf("i:%lld\n",i);
    }
    ans += is_prime_64(2*i*i-1);
  }
  printf("ans:%lld\n",ans);
  return 0;
}

```


# Ref

https://brilliant.org/wiki/prime-testing/

https://primes.utm.edu/prove/prove2_3.html

[2002 primes is P](http://www.cse.iitk.ac.in/users/manindra/algebra/primality_v6.pdf)

http://www.cs.tau.ac.il/~amnon/Classes/2019-Derandomization/Lectures/Lecture7-AKS-All.pdf

https://en.wikipedia.org/wiki/AKS_primality_test

[系数与完整表达式的疑问也有人问过](https://math.stackexchange.com/questions/2155958/lemma-2-1-of-aks-algorithm)

http://blog.sciencenet.cn/blog-3224443-1115018.html
