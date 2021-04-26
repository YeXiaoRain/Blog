---
title: project euler 078 Coin partitions
date: 2020-06-10 10:37:14
tags: [pe,project euler,math]
category: [Project Euler]
mathjax: true
---

# 题目

https://projecteuler.net/problem=78

`4 = 4 = 3+1 = 2+2 = 2+1+1=1+1+1+1,p(4)=5`

`5 = 5 = 4+1 = 3+2 = 3+1+1 = 2+2+1 = 2+1+1+1 = 1+1+1+1+1,p(5)=7`

求最小的n使得 `p(n) % 1_000_000 = 0`

# rust

dp递推暴力似乎并不可解,**警告 下面的代码 只要没找到答案就会一直增加vector大小，所以建议尽早掐断，不然会吃很大内存XD,可能造成系统卡死或者假卡死**


```rust
use std::cmp;


// dp[n][x] + (n-x <= x?) + sum(dp[n-x][1 -> min(x,n-x-1)])


fn main() {
    let mut dp = Vec::new();
    let mut dpsum = Vec::new();
    dp.push(Vec::new());
    dpsum.push(Vec::new());
    let mut i = 1;
    loop{
        dp.push(Vec::new());
        dpsum.push(Vec::new());
        dp[i].push(0);
        dpsum[i].push(0);
        let mut cnt = 0;
        for j in 1..i+1 {
            dp[i].push(0);
            dpsum[i].push(0);
            if i == j {
                dp[i][j] = 1;
            }else{
                dp[i][j] = dpsum[i-j][cmp::min(j,i-j)];
            }
            cnt += dp[i][j];
            cnt %= 1_000_000;
            dpsum[i][j] = (dpsum[i][j-1]+dp[i][j]) % 1_000_000;
        }
        println!("{}=>{}",i,cnt);
        if cnt % 1_000_000 == 0 {
            println!("{}=>{}",i,cnt);
            return ;
        }
        i+=1;
    }
}
```

# 题解

## 分拆

实际上可以把n看成，拆了$a_1$个1,$a_2$个2...

所以$p(n)$可以看成 $n = 1a_1+2a_2+3a_3+...+na_n$的解 $(a_1,a_2,...,a_n)$的个数

也是 $(1+x+x^2+x^3+...)(1+x^2+x^4+x^6+...)(1+x^3+x^6+x^9+...)...$ 结果中 $x^n$的系数,因为相当于从每个括号中选取了一项 假设第i个括号选取的是$x^{ij}$ 那么对应上面 $a_i = j$，也对应到相关的解

也就是 $\sum_{n=0}^{\infty} p(n)x^n = (1+x+x^2+...)(1+x^2+x^4+...)... = \frac{1}{1-x} \frac{1}{1-x^2} ... = \prod_{n=1}^{\infty} \frac{1}{1-x^n} $ 

## 互异分拆

如果分拆结果要求 不能出现相同的数字(互异分拆 partitions into distinct parts)，则相当于上面$a_i$增加限制$a_i\in\\{0,1\\}$

也就是 $\sum_{n=0}^{\infty} q(n)x^n = (1+x)(1+x^2)... = \prod_{n=1}^{\infty} (1+x^n) $ 

$p(n) = $拆分成偶数个互异的数的方案数 + 拆分成奇数个互异的数方案数

考虑一个互异分拆$n=n_1+n_2+...+n_s$ (注意这里是$n_i$不是$a_i$,实际是$a_{n_i} = 1$的那些)

$x^{n} = x^{n_1}x^{n_2}...x^{n_s}$

$(-1)^sx^{n} = (-x^{n_1})(-x^{n_2})...(-x^{n_s})$

考虑 $\sum_{n=0}^{\infty} g(n)x^n = (1-x)(1-x^2)... = \prod_{n=1}^{\infty} (1-x^n) $ 从值的构成上 它依然表示的是互异分拆 

注意到:$a_{n_i} = 0$在乘积贡献上是1,$a_{n_i}=1$在乘积贡献上是$-1$,所以 上述 每个互异分拆 对$g(n)$的贡献 是 $(-1)^s$

也就是$g(n) = $拆分成偶数个互异的数方案数 - 拆分成奇数个互异的数方案数

## g(n)

下面我们要看看欧拉大佬的神之推导

先上 Ferrer 图

比如 $ 11 = 5+4+2$

```
xxxxx
xxxx
xx
```

只考虑互异分拆，把底部的长度记为b(上图是1),从最大递减1的长度记为s(上图是5,4 所以s=2)

如果 一个图 $s \le b$,那么可以把最下面一排移到右侧,上图变为

```
xxxxx x
xxxx x
```

注意性质

1. 移动以后，因为少了一行，分拆的奇偶性变了。

2. b至少增加1, s = 原来的b ，所以 新的图是 s>b的。


仅有一种情况是不能移动的（因为要移动的最后一行点数比移动后剩余的行数大1） 如下,注意到需要s排满和s排满，所以对于分拆的一个n，至多出现一次，学过等差数列求和的也可以看出满足这种的n的公式。

$n = \frac{s(s+(2s-1))}{2}$

```
xxxxx
xxxx
xxx
```

以上 说明除了这特殊的以外，所有$s \le b$的 都有唯一对应的 $s > b$的互异ferrer图

---

再看 $s>b$的,例如(s=3,b=2)

```
xxxxxx
xxxxx
xxx
```

我们把右侧45度的点移到下面一排，有

```
xxxxx
xxxx
xxx
xx
```

同样有性质

1. 移动以后因为多了一行，分拆的奇偶性变了
2. 新的s >=旧的s，新的b = 旧的s，所以有 新的s>=新的b

同样有特殊的$s+1=b$的排满时，不能移动（否则移动后最下两行点数相等）

```
xxxxxx
xxxxx
xxxx
```

同样学过等差数列求和的，对于一个n最多有一个，n的表达式也呼之欲出了

$n = \frac{s((s+1)+2s)}{2}$

综上 除了两种特殊的情况，其它的 都能找到一一对应的，所以偶奇相减除了特殊的外结果为0

所以就有神奇的展开

$\prod_{n=1}^{\infty}(1-x^n) = 1+\sum_{s=1}^{\infty} (-1)^s(x^{\frac{3s^2-s}{2}}+x^{\frac{3s^2+s}{2}})$

# 回到目标p(n)

$(\sum_{n=0}^{\infty} p(n)x^n)(\cdot \prod_{n=1}^{\infty} 1-x^n) = (\prod_{n=1}^{\infty} )\cdot(\frac{1}{1-x^n} \cdot \prod_{n=1}^{\infty} 1-x^n) = 1 $ (...真的能这样乘吗。。


$(\sum_{n=0}^{\infty} p(n)x^n)(1+\sum_{s=1}^{\infty} (-1)^s(x^{\frac{3s^2-s}{2}}+x^{\frac{3s^2+s}{2}})) = 1 $ 

也就意味着左边 乘以后 对于$n>0$ 乘积后的系数都是$a_n = 0$

$a_n x^n = (p(n)x^n\cdot 1 + \sum_{s=1}^{\frac{3s^2-s}{2} \le n}[ p(n-\frac{3s^2-s}{2}) x^{n-\frac{3s^2-s}{2}} (-1)^s \cdot x^{\frac{3s^2-s}{2}} ]+ \sum_{s=1}^{\frac{3s^2+s}{2} \le n}[ p(n-\frac{3s^2+s}{2}) x^{n-\frac{3s^2+s}{2}} (-1)^s \cdot x^{\frac{3s^2+s}{2}} ])$

$0=a_n = p(n) + \sum_{s=1}^{\frac{3s^2-s}{2} \le n}[ p(n-\frac{3s^2-s}{2}) (-1)^s ]+ \sum_{s=1}^{\frac{3s^2+s}{2} \le n}[ p(n-\frac{3s^2+s}{2}) (-1)^s ])$

由此 我们有了$p(n)$的递推式,时间复杂度像是$n^1.5$(因为 s与n的不等式 是s平方增长 ，空间就只需要$O(n)$

$p(n) =  \sum_{s=1}^{\frac{3s^2-s}{2} \le n}[(-1)^{s+1} p(n-\frac{3s^2-s}{2})]+ \sum_{s=1}^{\frac{3s^2+s}{2} \le n}[(-1)^{s+1} p(n-\frac{3s^2+s}{2}) ])$

只需要初始化$p(0) = 1$

**至此就已经可以编码了**

有的地方会采取 $t=-s$的带入第一个求和，把上面两个求和合并成一个,也就是 s取非零的正负整数

$p(n) = \sum_{s\neq 0,s\in Z,\frac{3s^2+s}{2}\le n} [(-1)^{s+1}p(n-\frac{3s^2+s}{2})] $

然后就是五边形数相关的东西了,在这道题看来 不是必须的

# 代码

```rust
fn main() {
    let mut ans = Vec::new();
    let modnum:i32 = 1_000_000; // 注意usize范围很小 大坑
    ans.push(1);
    let mut i = 1;
    loop{
        let mut ansi:i32 = 0;

        let mut s:i32 = 1;
        let mut sres = ( s*(3*s-1)/2 ) as usize;
        while sres <= i{
            ansi += ((s%2)*2-1) * ans[i - sres];
            ansi %= modnum;
            s+=1;
            sres = ( s*(3*s-1)/2 ) as usize;
        }

        s = 1;
        sres = (s*(3*s+1)/2) as usize;
        while sres <= i{
            ansi += ((s%2)*2-1) * ans[i - sres];
            ansi %= modnum;
            s+=1;
            sres = (s*(3*s+1)/2) as usize;
        }
        ansi+=modnum;
        ansi%=modnum;

        ans.push(ansi);
        println!("{}=>{}",i,ansi);
        if ansi == 0 {
            println!("ans :{}",i);
            return ;
        }
        i+=1;
    }
}

```

秒出

不过看结果和我第一遍卡爆内存的值一比，我想是不是多点内存也是暴力可行的XD。


# 本题没有用到的 euler's theorem

互异分拆方案数=拆分成全是奇数个的方案数 ,$(1+x+x^2+...)(1+x^3+x^6+...)(1+x^5+x^{10}+...)...$


$\prod_{n=1}^{\infty} \sum_{k=0}^{\infty} x^{k*(2n-1)}$

$= \prod_{n=1}^{\infty} \frac{1}{1-x^{2n-1}}$

$= \prod_{n=1}^{\infty} \frac{1}{1-x^{2n-1}} \frac{\prod_{n=1}^{\infty} 1-x^{2n}}{\prod_{n=1}^{\infty} 1-x^{2n}}$

$= \frac{1}{\prod_{n=1}^{\infty} 1-x^{2n-1}}\frac{\prod_{n=1}^{\infty} (1-x^n)(1+x^n)}{\prod_{n=1}^{\infty} 1-x^{2n}}$

$ = \prod_{n=1}^{\infty} (1+x^n)$ (这。。。无限项这样拆分相消科学吗

就有了wikipedia上面那个公式 $\sum _{n=0}^{\infty }q(n)x^{n}=\prod _{k=1}^{\infty }(1+x^{k})=\prod _{k=1}^{\infty }{\frac {1}{1-x^{2k-1}}}.$


# 参考

`https://en.wikipedia.org/wiki/Partition_(number_theory)`

`https://en.wikipedia.org/wiki/Pentagonal_number_theorem`
