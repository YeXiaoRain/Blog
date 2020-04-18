---
title: c++ template
date: 2020-04-14 10:37:14
tags: [c++,template]
category: [c++]
mathjax: true
---


# 通用函数可变参数模板

// 迷，不是有处理args的办法吗？)

```cplusplus
#include<iostream>
void showall() { return; }

template <typename R1 ,typename...  Args>
void showall(R1 var, Args...args) {
    std::cout << var << std::endl;
    showall(args...);
}

int main(int argc, char * args[]) {
    showall(1, 2, 3, 4, 5);
    showall("gxjun","dadw","dasds");
    showall(1.0,2,"3");
    return 0;
}
```

# 仿函数 

```cplusplus
#include<iostream>
#include<functional>
using namespace std;
using namespace std::placeholders;  

template <typename R1 , typename R2>
struct  Calc
{
    void add(R1 a) {
        cout << a << endl;
    };
    void add_1(R1 a, R1 b) {
        cout << a + b << endl;
    }  
};

int main(int argc, char * args[]) {

    //函数指针
    void(Calc<int, double>::*fc)(int  a) = &Calc<int, double >::add;
    // fc(25);
    //显然上面的式子比较的麻烦
    
    Calc < int, int> calc;
    auto  fun = bind(&Calc<int, int >::add, &calc, _1);
    auto  fun_2 = bind(&Calc<int, int >::add_1, &calc, _1,_2);
    fun(123);
    fun_2(12,24);
   cin.get();
 return 0;
}
```
