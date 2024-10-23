---
title: 欧拉回路
date: 2024-08-12
tags:
  - 欧拉回路
category:
  - algorithm
mathjax: true
---

TL;DR;

```cpp
vector<int> euler_circuit(vector<vector<pair<int, int>>> G, int n/*点*/, int m/*边*/) { // 欧拉回路
    vector<int> path;
    vector<bool> used(m, false); // 边是否被使用
    function<void(int)> dfs=[&](int u) {
        for(auto [v,e]: G[u]) { // (点, 边)
            if(!used[e]) {
                used[e] = true;
                dfs(v);
            }
        }
        path.push_back(u);
    };
    dfs(0);
    reverse(path.begin(), path.end());
    return path;
}
```

## 直觉的数学证明

1. 所有点都是偶度

当我们对所有边至多访问一次进行dfs

那么对于非起始点u，dfs(u) 什么时候返回

```
dfs(u):
	for 未访问过的边edgeid，v : g[u]:
		dfs(v) <----- ?什么时候返回
```

直觉告诉我们，

1. 如果绕到了u的父节点来源 且无法dfs更深时会返回
2. 如果只是绕回了u,而u还有边是不会因此导致返回的

所以只有两种情况

1. 第一次返回 是 绕到更深无法继续，第二次是 绕回u且没有多的边
2. 只有一次 绕到更深无法继续

而发现 只要把顺序反过来就好了

## 相关

abc227H

https://codeforces.com/contest/1994/problem/F