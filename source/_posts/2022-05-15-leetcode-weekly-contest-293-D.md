---
title: leetcode周赛293D (lower_bound,set, 动态开点线段树)
date: 2022-05-15 10:37:14
tags: [lower_bound,set,动态开点线段树]
category: [NowCoder]
mathjax: true
---

# set+lower_bound

http://www.cplusplus.com/reference/algorithm/lower_bound/

On non-random-access iterators, the iterator advances produce themselves an additional linear complexity in N on average.

set不支持随机访问,所以std::lower_bound 用在set上就不再是log级别了, 而是均摊n级别了,所以要用set::lower_bound而不是std::lower_bound

# 动态开点线段树

一般来说 空间够常见是开4N大小

但是如果空间很大但是点是离散的又需要在线处理(不能离线离散化)的情况

每个点记录左右节点+lazytag+没有节点要访问时,动态开点idx, 查询时对于没有开点的直接返回空,而不是开点

```cpp
int idx = 0;

// N 按照预估点数而不是 l r 的范围了
int lc[N]; // 点的左子点
int rc[N]; // 点的右子点

void update(int &o,int l,int r,...){
  if(!o) o = ++idx; // 动态开点
  if(l == r){
    // ...
    return ;
  }
  update(lc[o],l,mid,...);
  update(rc[o],mid+1,r,...);
  // ...
}

... query(int o,int l,int r,int ql,int qr){
  if(!o){ // 查询不用创建点
    //....
    return 空状态;// 
  }
  if(ql <= l && r <= qr){ // [ql.. [l..r].. qr]
    // ...
    return //;
  }
  auto resl = query(lc[o],l,mid,ql,qr);
  auto resr = query(lr[o],mid+1,r,ql,qr);
  return ...;
}



```



