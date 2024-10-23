---
title: 素数计数函数
date: 2024-06-26
tags:
  - prime
  - 容斥原理
category:
  - algorithm
mathjax: true
---
# 问题$\pi (x)$

$[1,n]$ 计算之间素数的个数,其中$n$可能达到$10^{12}$

## 足够小的n(Sieve_of_Eratosthenes)

https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

也就是 每次把 $i^2,i(i+1),i(i+2),\cdots$ 设为False

```python
def primes_with_sieve(N):
    is_prime = [1 for i in range(N+1)]
    is_prime[0]=is_prime[1]=0
    for i in range(2,N+1):
        if is_prime[i]:
            for j in range(i*i,N+1,i):
                is_prime[j] = 0
    return is_prime
```

## 勒让德(Legendre's Formula)

https://mathworld.wolfram.com/LegendresFormula.html

核心想法是**容斥原理**

$\phi(x,a) =$ 在$\le x$ 中,与前$a$个质数均互质的数, $x\in \mathbb{R},a\in \mathbb{Z}$

显然$\phi(x,a) = \phi(\lfloor x\rfloor,a)$

显然$\phi(x,\ge \pi(x))=\phi(x,\pi(x))=1$

$\displaystyle \phi(x,a)=\lfloor x\rfloor-\sum \lfloor \frac{x}{p_i}\rfloor+\sum \lfloor \frac{x}{p_ip_j}\rfloor - \sum \lfloor \frac{x}{p_ip_jp_k}\rfloor+\cdots$

而类似与上面的筛数法，也就是 $\phi(x,a=\pi(\sqrt{x}))$ 留下的是$1$以及 $(\sqrt{x},x]$之间的质数的个数，所以有

$\phi(x,a=\pi(\sqrt{x})) = \pi(x)-\pi(\sqrt{x})+1$

因此$\pi(x) = \phi(x,\pi(\sqrt{x}))+\pi(\sqrt{x})-1$

---

满足递归关系 $\phi(x,a)=\phi(x,a-1)-\phi(\frac{x}{p_a},a-1)$

proof:

根据定义 $\phi(x,a)$和$\phi(x,a-1)$ 中间的差值，其实就是$[1,x]$中 质因子含有$p_a$ 且不含有$p_{<a}$ 的数

也就是$v = p_a\cdot t \le x$且$p_{<a}\not{|}t$

$t\le \frac{x}{p_a}$

也就是 $\phi(\frac{x}{p_a},a-1)$

---

令$m_k =\prod_{i=1\cdots k} p_i$ 由前$k$个质数乘起来的

$\phi(m_k,k) = \phi(m_k)$ 也就是欧拉函数(Totient Function) 表示 不大于$x$且和$x$互质的数的个数

---

如果把$x$表示成 $x=sm_k+t$, $t\in[0,m_k]$

$\phi(sm_k+t,k) = s\phi(m_k)+\phi(t,k)$

这很显然，因为和前$k$个质数互质的数 一定形成 $[0,m_k)$的周期

对于$\displaystyle t\in (\frac{m_k}{2},m_k]$

$\phi(t,k)=\phi(m_k)-\phi(m_k-t-1,k)$

这个其实就是 $[1,m_k]$ 这一段切割+翻转了一下，$[1,t],[t+1,m_k]$,后面一段可以对应$[0,m_k-(t+1)]$

```python
def primes_with_sieve(N):
    is_prime = [1 for i in range(N+1)]
    is_prime[0]=is_prime[1]=0
    for i in range(2,N+1):
        if is_prime[i]:
            for j in range(i*i,N+1,i):
                is_prime[j] = 0
    return is_prime

def primes_from_prime_bool(arr):
    primes = [0]
    for i in range(2,len(arr)):
        if arr[i]:
            primes.append(i)
    return primes

def Sieve_of_Eratosthenes(N):
    return sum(primes_with_sieve(N))

print(f"{Sieve_of_Eratosthenes(10**2)=}")
print(f"{Sieve_of_Eratosthenes(10**4)=}")
print(f"{Sieve_of_Eratosthenes(10**6)=}")


def Legendre_s_Formula(N):
    import math
    sqrt_N=math.isqrt(N)
    # sieve for sqrt_N
    pi = primes_with_sieve(sqrt_N)
    primes = primes_from_prime_bool(pi)
    for i in range(2,sqrt_N+1):
        pi[i]+=pi[i-1]
    pi_sqrt_N=pi[sqrt_N]
    m_k = [1]
    for i in range(1,len(primes)):
        m_k.append(m_k[-1]*primes[i])
        if m_k[-1] > N:
            break

    cnt = pi_sqrt_N-1 # pi(N) = pi(sqrt(N))-1 +phi(n,pi(sqrt(n)))
    task = [(1,N,pi_sqrt_N)] # coef, x, a
    def euler_phi(val,k):
        for i in range(1,k+1):
            val*=primes[i]-1
            val//=primes[i]
        return val

    itr = 0
    while itr < len(task):
        coef,x,a = task[itr]
        # task.pop(0)
        if a==1:
            cnt += coef*(x-x//2)
        elif x<=1:
            cnt += coef*x;
        elif a>=x:
            assert x<=sqrt_N
            cnt += coef*1
        elif a < len(m_k) and x > m_k[a]:
            # phi(s m_k+t,k) = s phi(m_k,k) + phi(t,k)
            cnt += coef*(x//m_k[a])*euler_phi(m_k[a],a)
            task.append((coef            ,x%m_k[a],a))
        elif a < len(m_k) and x*2 > m_k[a] and x < m_k[a]:
            cnt += coef*euler_phi(m_k[a],a)
            task.append((coef*-1,m_k[a]-x-1,a))
        else:
            task.append((coef*-1,x//primes[a],a-1))
            task.append((coef   ,x               ,a-1))
        itr+=1

    return cnt


print(f"{Legendre_s_Formula(10**2)=}")
print(f"{Legendre_s_Formula(10**4)=}")
print(f"{Legendre_s_Formula(10**6)=}")
print(f"{Legendre_s_Formula(10**8)=}")
```

## Meissel's Formula

https://mathworld.wolfram.com/MeisselsFormula.html

$\lfloor x\rfloor=1+\sum_{1\le i\le a}\lfloor\frac{x}{p_i}\rfloor-\sum_{1\le i < j\le a}\lfloor\frac{x}{p_ip_j}\rfloor+\cdots+(\pi(x)-a)+P_2(x,a)+P_3(x,a)+\cdots$
$P_i(x,a) =$ 恰有$i$个质因子的数的个数, 且范围$\le x$,质因子不属于前$a$个

前x = 1 + (前a个质数的倍数的数) + (剩余质数) + (剩余和数)

---

例如

$P_2(x,a) =\sum_{i\ge a+1}[\pi(\frac{x}{p_i})-(i-1)]$

其实就是 枚举 $i \le j$中的最小的$i$

那么值是 $p_ip_{j\ge i} \le x$

也就有了上面 $p_j \le \frac{x}{p_i}$ 且 $j\ge i$

---

$P_3(x,a)=\sum_{i\ge a+1} P_2(\frac{x}{p_i},i-1)$ 同样的 先枚举最小的,这里似乎mathworld写错了，写成a了?

$\displaystyle =\sum_{i=a+1}^c\sum_{j=i}^{\pi(\sqrt{\frac{x}{p_i}})}[\pi(\frac{x}{p_ip_j})-(j-1)]$

那么这里其实 注意到 如果再向$P_4$ 走那么 $p_i \le x^{\frac{1}{4}}$

同时注意到$p_a < p_i \le x^{\frac{1}{4}}$

所以其实通过控制$a$的大小 可以控制$P_?$的零项

例如$a=\pi(\sqrt{x})$ 那么就是上面的勒让德，因为$P_{\ge 2}=0$

而Meissel's的 表达式，就是 调整到让$P_{\ge 3}=0$

也就是$a=\pi(x^{\frac{1}{3}})$

---

回到上面 也就是

前x = 1 + (前a个质数的倍数的数) + (剩余质数) + (剩余和数仅含2个质因子的和数)
$\lfloor x\rfloor=1+\sum_{1\le i\le a}\lfloor\frac{x}{p_i}\rfloor-\sum_{1\le i < j\le a}\lfloor\frac{x}{p_ip_j}\rfloor+\cdots+(\pi(x)-a)+P_2(x,a)$
$\phi(x,a)=1+\pi(x)-a+P_2(x,a)$

$\pi(x) = \phi(x,a)-1+a-P_2(x,a)$

$\displaystyle P_2(x,a)=\sum_{i\ge a+1}^{b=\pi(x^{\frac{1}{2}})}[\pi(\frac{x}{p_i})-(i-1)]$

$\displaystyle =\sum_{i\ge a+1}^{b=\pi(x^{\frac{1}{2}})}\pi(\frac{x}{p_i})-\sum_{i\ge a+1}^{b=\pi(x^{\frac{1}{2}})}(i-1)$

$\displaystyle =\sum_{i\ge a+1}^{b=\pi(x^{\frac{1}{2}})}\pi(\frac{x}{p_i})-\frac{1}{2}(a+b-1)(b-a)$ 这里似乎mathworld也没写对?

$\displaystyle \pi(x) = \phi(x,a)-1+a -\sum_{i\ge a+1}^{b}\pi(\frac{x}{p_i})+\frac{1}{2}(a+b-1)(b-a)$,其中$a=\pi(x^{\frac{1}{3}}),b=\pi(x^{\frac{1}{2}})$

---



```python
def primes_with_sieve(N):
    is_prime = [1 for i in range(N+1)]
    is_prime[0]=is_prime[1]=0
    for i in range(2,N+1):
        if is_prime[i]:
            for j in range(i*i,N+1,i):
                is_prime[j] = 0
    return is_prime

def primes_from_prime_bool(arr):
    primes = [0]
    for i in range(2,len(arr)):
        if arr[i]:
            primes.append(i)
    return primes

def meissel(N):
    # $\pi(x) = \phi(x,a)-1+a -\sum_{i\ge a+1}^{b}\pi(\frac{x}{p_i})+\frac{1}{2}(a+b-1)(b-a)$,
    # 其中$a=\pi(x^{\frac{1}{3}}),b=\pi(x^{\frac{1}{2}})$
    import math
    sqrt_N=math.isqrt(N)
    # sieve for sqrt_N
    pi = primes_with_sieve(sqrt_N)
    primes = primes_from_prime_bool(pi) # 1-index 即是个数也是下标
    for i in range(2,sqrt_N+1):
        pi[i]+=pi[i-1]

    def meissel_recursive(x):
        # a = pi(x^1/3)
        a = 1
        for i in range(1,len(primes)):
            if primes[i]**3 > x:
                assert i > 1
                a = i-1
                break
        # assert a == pi[math.floor(x**(1/3))] 浮点数问题

        # b = pi(x^1/2)
        b = pi[math.isqrt(x)]

        # (a,b]
        cnt = a-1+(a+b-1)*(b-a)//2
        # -sum pi(x/p_i),i=a+1..b
        for p in primes[a+1:b+1]:
            if x//p < len(pi):
                cnt -= pi[x//p]
            else:
                cnt -= meissel_recursive(x//p)

        # +phi(x,a)
        task = [(1,x,a)] # coef, x, a
        def euler_phi(val,k):
            for i in range(1,k+1):
                val*=primes[i]-1
                val//=primes[i]
            return val

        itr = 0
        while itr < len(task):
            coef,x,a = task[itr]
            # task.pop(0)
            if a==1:
                cnt += coef*(x-x//2)
            elif x<=1:
                cnt += coef*x;
            elif a>=x:
                assert x<=sqrt_N
                cnt += coef*1
            else:
                task.append((coef*-1,x//primes[a],a-1))
                task.append((coef   ,x               ,a-1))
            itr+=1
        return cnt

    return meissel_recursive(N)

print(f"{meissel(10**2)=}")
print(f"{meissel(10**4)=}")
print(f"{meissel(10**6)=}")
print(f"{meissel(10**8)=}")
```

### Lehmer's Formula

https://mathworld.wolfram.com/LehmersFormula.html

目录分级，是Meissei的变化

其实就是Lehmer是控制$a$的范围让$P_{\ge 3}=0$

而这里实际就是控制$a,b$的范围，让$P_{\ge 4}=0$

$\displaystyle \pi(x) = \phi(x,a)-1+a-\sum_{a<i\le b} (\pi(\frac{x}{p_i})-(i-1))-\sum_{i=a+1}^{c}\sum_{j=i}^{\pi(\sqrt{\frac{x}{p_i}})}[\pi(\frac{x}{p_ip_j})-(j-1)]$

$a=\pi(x^{\frac{1}{4}})$

$b=\pi(x^{\frac{1}{2}})$

$c=\pi(x^{\frac{1}{3}})$

```python
import time
def primes_with_sieve(N):
    is_prime = [1 for i in range(N+1)]
    is_prime[0]=is_prime[1]=0
    for i in range(2,N+1):
        if is_prime[i]:
            for j in range(i*i,N+1,i):
                is_prime[j] = 0
    return is_prime

def primes_from_prime_bool(arr):
    primes = [0]
    for i in range(2,len(arr)):
        if arr[i]:
            primes.append(i)
    return primes

def Sieve_of_Eratosthenes(N):
    return sum(primes_with_sieve(N))

def n_1_div_pwr(n,pwr): # python3 只有isqrt没有1/3?
    # return int(n**(1/pwr)):
    l = 0
    r = n+1
    while r-l>1:
        mid = (l+r)//2
        if mid**pwr > n:
            r = mid
        else:
            l = mid
    return l


def meissel_lehmer(N):
    # $\pi(x) = \phi(x,a)-1+a
    #   - \sum_{i=[a+1,b]}(\pi(\frac{x}{p_i})-(i-1))
    #   - \sum_{i=[a+1,c]} \sum_{j=[i,\pi(\sqrt(x/p_i))(\pi(\frac{x}{p_ip_j})-(j-1))
    # 其中 $a=\pi(x^{\frac{1}{4}}),
    #       b=\pi(x^{\frac{1}{2}})$
    #       c=\pi(x^{\frac{1}{3}})$
    import math
    sqrt_N=math.isqrt(N)
    pi = primes_with_sieve(sqrt_N)
    primes = primes_from_prime_bool(pi) # 1-index 即是个数也是下标
    for i in range(2,sqrt_N+1):
        pi[i]+=pi[i-1]

    def inner_recursive(x):
        if x < len(pi):
            return pi[x]
        a = max(pi[n_1_div_pwr(x,4)],1)
        c = max(pi[n_1_div_pwr(x,3)],a)
        b = max(pi[n_1_div_pwr(x,2)],c)

        cnt = a-1
        # -sum pi(x/p_i)-(i-1),i=a+1..b
        for i in range(a+1,b+1):
            cnt -= inner_recursive(x//primes[i]) - (i-1)

        #   - \sum_{i=[a+1,c]} \sum_{j=[i,\pi(\sqrt(x/p_i))(\pi(\frac{x}{p_ip_j})-(j-1))
        for i in range(a+1,c+1):
            mxj = pi[math.isqrt(x//primes[i])]
            for j in range(i,mxj+1):
                cnt -= inner_recursive(x//primes[i]//primes[j])-(j-1)

        # +phi(x,a)
        task = [(1,x,a)] # coef, x, a
        itr = 0
        while itr < len(task):
            coef,x,a = task[itr]
            # task.pop(0)
            if a==1:
                cnt += coef*(x-x//2)
            elif x<=1:
                cnt += coef*x;
            elif a>=x:
                assert x<=sqrt_N
                cnt += coef*1
            else:
                task.append((coef*-1,x//primes[a],a-1))
                task[itr] = (coef   ,x           ,a-1)
                continue
            itr+=1
        return cnt

    return inner_recursive(N)


for i in range(1,11):
    start_time = time.time()
    print(f"meissel_lehmer\t{i=},{meissel_lehmer(10**i):15}\t{time.time()-start_time}s")
```


我尝试在这个里也加了m_k但更慢了


## Lucy_Hedgehog

Lucy的代码本身解决的是一定范围内 质数的和，和这里其实差不多，个数无非是每个权重为1

$S(x,t)$ 为$[2,v]$ 所有整数中, 通过筛法循环筛完 前$t(\ge 0)\in \mathbb{Z}$个质数 后仍然剩余的数的个数

显然,这些数要么是$\le p_t$的素数, 要么这些数的最小素因子$> p_t$

$ans=S(n,\pi(\sqrt{n}))$

---

1. $S(x,0) = \sum_{i=2}^x 1 = x-1$ 所有数字都还没被筛掉
2. $p_t^2 > x$, $S(x,t)=S(x,t-1)$
3. $p_t^2 \le x$ 这种情况相对复杂

$\displaystyle S(x,t) = S(x,t-1) - \sum_{j\in[2,x],p_t是j的最小素因子}1$, 就是考虑 多删除$p_t$的倍数会多删除什么


$\displaystyle S(x,t) = S(x,t-1) - \sum_{j\in[1,\lfloor \frac{x}{p_t}\rfloor],j的最小素因子 \ge p_t}1$ 考虑$j_{new}=j_{old}/p_t$


$\displaystyle S(x,t) = S(x,t-1) - (S(\lfloor \frac{x}{t} \rfloor,t-1) - (t-1))$ 

其实这里已经可以看出，lucy的代码数学上并不更优秀，而是lucy用了记忆化和递推 来完成了而大量的cache，因为注意到 x 的值都是x除以多个p得到的

那么其实只有 `[0...sqrt(x)][x/sqrt(x)...x/1]`, $O(\sqrt{x})$个可能的取值，于是可以优化

而实际上，当我们单点求值时 还是像 勒让德 类似的方法只是增加了$[x/sqrt(x)...x/1]$的记忆化

而 例如pe501需要 多点求值 时，其实更多的还是 只记忆化 $x^{1/2}$或者$x^{2/3},x^{3/4}$ 来完成

多点求值 会更优吗？

```cpp
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
#define rep(i,a,n) for (ll i=a;i<(ll)n;i++)
#define per(i,a,n) for (ll i=n;i-->(ll)a;)
template<class T>using minPQ=priority_queue<T,vector<T>,greater<T>>;
#define i64 long long

inline i64 v2idx(i64 v, i64 N, i64 Ndr, i64 nv) {
  return v >= Ndr ? (N/v - 1) : (nv - v);
}

i64 primesum(i64 N) {
  i64 r = (i64)sqrt(N);
  i64 Ndr = N/r;
  assert(r*r <= N and (r+1)*(r+1) > N);
  i64 nv = r + Ndr - 1;
  i64 *V = new i64[nv];
  i64 *S = new i64[nv];
  for (i64 i=0; i<r; i++) V[i] = N/(i+1); // [N/1...N/r]
  for (i64 i=r; i<nv; i++) V[i] = V[i-1] - 1; // [N/r-1...1]
  for (i64 i=0; i<nv; i++) S[i] = V[i]  - 1; // [N/1-1...N/r-1 N/r-2...0]

  for (i64 p=2; p<=r; p++) if (S[nv-p] > S[nv-p+1]) { // is prime
    i64 sp = S[nv-p+1]; // S(p,p) = pi(p)
    i64 p2 = p*p;
    for (i64 i=0; i<nv; i++) {
      if (V[i] >= p2) {
        S[i] -= (S[v2idx(V[i]/p, N, Ndr, nv)] - sp);
      } else {
        break;
      }
    }
  }

  return S[0];
}

int main() {
  i64 N = 100'0000'0000;
  printf("%lld\n", primesum(N));
  return 0;
}
```



## 完整 代码


# 练习题目

[project euler 501](https://projecteuler.net/problem=501)

[codeforces 665F](https://codeforces.com/contest/665/problem/F)

# 参考

[wikipedia prime counting function](https://en.wikipedia.org/wiki/Prime-counting_function)

[mathworld.wolfram prime counting function](https://mathworld.wolfram.com/topics/PrimeCountingFunction.html)

[求十亿内所有质数的和，怎么做最快? - 穆罕默德·李的回答 - 知乎](https://www.zhihu.com/question/29580448/answer/876479428)

[codeforces 665F tutorial](https://codeforces.com/blog/entry/44466)

[codeforces blog counting primes](https://codeforces.com/blog/entry/91632)

[oiwiki Min_25筛](https://oi-wiki.org/math/number-theory/min-25/)

[Lucy_Hedgehog's method](https://projecteuler.net/thread=10;page=5#111677)

Meisell-Lehmer's method

[Youtube- The Pattern to Prime Numbers?](https://www.youtube.com/watch?v=dktH8hJadyU)

https://codeforces.com/blog/entry/44466

https://www.cnblogs.com/LzyRapx/p/8453170.html

[github primecount](https://github.com/kimwalisch/primecount/)

[library-checker](https://judge.yosupo.jp/problem/counting_primes)