---
title: project euler 218 (别写代码用数学)
date: 2021-07-20 10:37:14
tags: [pe,project euler,math]
category: [Project Euler]
mathjax: true
---

# 题目

[原题链接](http://projecteuler.net/index.php?section=problems&id=218)

直角三角形$(a,b,c)$,其中$c$为斜边

perfect定义

1. 边互质$gcd(a,b) = 1$
2. 斜边是平方数$c = x^2$

super-perfect

1. perfect
2. 直角三角形面积是6和28的倍数

求

$c \le 10^{16}$ 内,有多少perfect的不是super-perfect

# 题解

前面的PE我们学习到，$gcd(a,b)=1$ 的直角三角形可以唯一表示成

$(a,b,c) = (m^2-n^2,2mn,m^2+n^2)$

其中两个直角边可以对换

其中 $gcd(m,n) = 1, (m+n) = 1 (\bmod 2)$

$lcm(6,28) = 84$

---

简化成

$m^2+n^2 = c = x^2 \le 10^{16} $

求 $mn(m^2-n^2) != 0 (\bmod 84)$ 的个数

---

注意到 这里又是一个直角三角形公式

$ordered(m,n,x) = ordered(2uv,u^2-v^2,u^2+v^2)$

---

即

$u > v, gcd(u,v) = 1, u+v = 1 (\bmod 2)$

$u^2+v^2 \le 10^{8}$

$ordered(m,n) = ordered(2uv,u^2-v^2) $

求 $mn(m^2-n^2) != 0 (\bmod 84)$ 的个数

# 代码

直接翻译很好写了

```python
perfect_but_not_super_perfect = 0

def gcd(a,b):
    if b == 0:
        return a
    return gcd(b,a%b)


for v in range(1,10**4):
    if v % 100 == 0:
        print("b:", v)
    for u in range(v+1,10**4,2):
        if gcd(u,v) != 1:
            continue

        if u**2+v**2 > 10**8:
            break;

        m,n = u**2-v**2,2*u*v

        if n > m:
            m,n=n,m

        if (m*n*(m**2-n**2)) % 84 != 0:
            perfect_but_not_super_perfect += 1


print("ans",perfect_but_not_super_perfect )
```

时间

```
real    0m30.195s
user    0m30.195s
sys     0m0.000s
```

# 不要到此为止 上数学

就完了吗

它要是个长长的数字可能也没这篇文章了，因为PE的 one-minute rule 已经满足了

但是它的答案是0那就激起了推导的兴趣

## 命题

$u > v, gcd(u,v) = 1, u+v = 1 (\bmod 2)$

$(m,n) = (2uv,u^2-v^2) $

则 $mn(m^2-n^2) = 0 (\bmod 84)$

这里我们没有范围限制，考虑模运算的性质，没有了大小顺序正负

### 代入

$2uv(u^2-v^2)(6u^2v^2-u^4-v^4) = 0 (\bmod 84)$

$uv(u^2-v^2)(6u^2v^2-u^4-v^4) = 0 (\bmod 42)$

$42 = 2 \cdot 3 \cdot 7$

### 讨论

2 显然，因为$u+v=1(\bmod 2)$ , u 和 v一奇一偶

3 如果u和v其中有3的倍数，那么是3的倍数，如果均不是3的倍数,因为 $1^2=2^2=1 (\bmod 3)$ , 所以 $u^2-v^2 = 0 (\bmod 3)$

7 如果u和v其中有7的倍数，那么是7的倍数，否则都不是7的倍数，还是写一点代码

```python
for u in range(1,7):
    for v in range(1,7):
        print(u,v,((u**2-v**2)*(6*u*u*v*v-u**4-v**4))%7)
```

输出都是0 得证


