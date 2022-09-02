---
title: project euler 075 Singular integer right triangles
date: 2020-06-08 10:37:14
tags: [数学]
category: [Project Euler]
mathjax: true
---

# 题目

https://projecteuler.net/problem=75

$12=3+4+5,3^2+4^2=5^2;$

有些整数 有唯一拆分，可以拆分成直角三角形的三条边

# rust

看上去 枚举中间长度，二分最短长度，估算一下 `(n*n/4 log n)`，


```rust
use std::thread;
use std::sync::mpsc;

const N:usize = 1_500_000;


fn f(s:usize) -> usize{
    let mut cnt = 0;
    let mstart = if s/4 > 1 {s/4}else{1};
    for m in mstart..s/2+1 {
    // for m in 1..s+1 {
        let mut l = 1;
        let mut r = m+1;
        while l+1 < r {
            let mid = (l+r)/2;
            let o = s-m-mid;
            if o < m  || mid*mid + m*m > o*o {
                r = mid;
            }else if mid*mid + m*m <= o*o {
                l = mid;
            }
        }
        let o = s-m-l;
        if l*l+m*m == o*o {
            cnt+=1;
            if cnt > 1{
                return 0;
            }
        }
    }
    return if cnt == 1 {1}else {0};
}


fn main() {
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || {
        for i in 1..N+1{
            let tx_clone = mpsc::Sender::clone(&tx) ; 
            thread::spawn(move || {
                tx_clone.send( (i,f(i)) ).unwrap();
            });
        }
    });
    let mut ans = 0;
    for _i in 1..N+1 {
        let rxr = rx.recv().unwrap();
        if rxr.1 == 1 {
            ans += 1;
            if ans % 1000 == 0 {
                println!("sum: {}", rxr.0);
            }
        }
    }
    println!("ans:{}",ans);
}
```

答案每新增1000 输出一次当前i，但运行了3min+ (x8核) 我把它掐了,准备学一学 如何数学角度优化

```
time ./p075 
sum: 8890
sum: 18078
sum: 27312
sum: 36472
sum: 45568
sum: 54426
sum: 63444
sum: 72672
sum: 81828
sum: 90648
sum: 99898
sum: 109240
sum: 118476
sum: 127950
sum: 137208
sum: 146294
sum: 155246
sum: 164206
sum: 173180
sum: 182322
sum: 191448
sum: 200406
sum: 209448
sum: 218514
sum: 227412
sum: 236474
sum: 245712
sum: 254716
sum: 263728
sum: 272950
sum: 282184
sum: 291248
sum: 300514
sum: 309800
sum: 319228
sum: 328368
sum: 337978
sum: 347204
sum: 356892
sum: 366226
sum: 375914
^C

real	3m33.095s
user	24m40.718s
sys	0m22.575s
```

# 解法

如果有正整数对$(a,b,c)$满足$a^2+b^2=c^2$那么 这是一组勾股数

我们可以有$(ka,kb,kc)$也是勾股数，对于$gcd(a,b,c) = 1$的情况 称作素勾股数字

若$m>n$且$gcd(m,n)=1$ , m,n一个奇一个偶。

则令 $a=m^2-n^2$,$b=2mn$,$c=m^2+n^2$ ，则$(a,b,c)$是 素勾股数 

充分性显然，上述表达满足勾股定理,且根据gcd运算规则是素勾股数

下面再证明必要，也就是所有素勾股数都能拆解成上面的`m`和`n`,

因为$gcd(a,b,c) = 1$ 说明两两$gcd = 1$(否则如果两个gcd不为1,运算过程 会导致另一个变量也是这个gcd的倍数 )

因此 必定`a,b`一个奇一个偶

根据轮换性质，不妨设 a奇 b偶 c奇

有$(c-a)(c+a)=b^2$

令  $\frac{m}{n} = \frac{c+a}{b} = \frac{b}{c-a}$

下面解 方程组$\frac{c}{b} + \frac{a}{b} = \frac{m}{n}, \frac{c}{b}-\frac{a}{b}=\frac{n}{m}$

得到$\frac{c}{b}=\frac{m^2+n^2}{2mn},\frac{a}{b}=\frac{m^2-n^2}{2mn}$

所以 素勾股数字总能写成上述m,n的形式

以上证明了 素勾股数 和 m,n 形式的充要关系

---

注意到 $c=m^2+n^2$

所以 最大的只用枚举到 $\sqrt{\frac{l}{2}}$

# code 

```rust
use std::thread;
use std::sync::mpsc;
use std::collections::HashMap;

const N:usize = 1_500_000;

fn gcd(v1:usize,v2:usize) -> usize{
    return if v2 == 0 {v1} else{gcd(v2,v1%v2)}
}

fn f(n:usize) -> HashMap<usize,usize>{
    let mut m = n+1;
    let mut ret = HashMap::new();
    while 2*m*(m+n) <= N{
        if gcd(m*m-n*n,2*m*n) == 1 {
            println!("{},{},{} => {}",m*m-n*n,2*m*n,m*m+n*n,2*m*(m+n));
            let l = 2*m*(m+n);
            let mut kl = l;
            while kl <= N{
                ret.insert(kl, match ret.get(&kl) {
                    Some(oldcnt) => oldcnt+1,
                    None => 1
                });
                kl+=l;
            }
        }
        m+=1;
    }
    return ret;
}


fn main() {
    let (tx, rx) = mpsc::channel();
    let maxn = 1000; // N+1
    thread::spawn(move || {
        for i in 1..maxn{
            let tx_clone = mpsc::Sender::clone(&tx) ; 
            thread::spawn(move || {
                tx_clone.send( f(i) ).unwrap();
            });
        }
    });
    let mut hash_res = HashMap::new();
    for _i in 1..maxn {
        let rxr = rx.recv().unwrap();
        for (k,v) in rxr{
            hash_res.insert(k,match hash_res.get(&k){
                Some(oldv) => oldv+v,
                None => v
            });
        }
    }
    let mut ans = 0;
    for (_k,v) in hash_res{
        if v == 1{
            ans += 1;
        }
    }
    println!("ans:{}",ans);
}
```

# 参考

https://en.wikipedia.org/wiki/Pythagorean_triple

https://en.wikipedia.org/wiki/Formulas_for_generating_Pythagorean_triples
