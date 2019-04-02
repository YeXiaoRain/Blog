---
title: CF 愚人节赛题目鉴赏
date: 2019-04-01 01:37:14
tags: [AprilFool]
category: [code,codeforces]
mathjax: true
---

[题目](https://codeforces.com/contest/1145/problems)

# A Thanos Sort

没啥讲的，阅读理解，模拟实现

# B Kanban Numbers

我的解题过程：`搜索kanban->signboard->led number`,尝试和led显示相关，未果

你群群友，有暴力枚举过B题的orz

实际解法是 标题+英语, `kanban number = 'k' 'a' 'n' ban number`,也就是 英文不含字母`k` `a` `n`的

# C Mystery Circuit

量子计算相关(实际没有到量子)

有工具[Quirk](https://algassert.com/quirk)

1) 4位2进制表示
2) 前后倒序
3) 按工具上面的按钮
4) 前后倒序
5) 再转换为10进制数

`3->0011->1100->1011->1101->13`

https://en.wikipedia.org/wiki/Quantum_logic_gate

首先`十字+圆圈` 表示的是一个`非门`

然后 竖着看，黑色的点是控制点，也就是竖着一条线上黑点 传入的数据 全是1时，非门才工作

这就是工具的运作原理，因为数也只有15个，你可以枚举打表，也可以实现这个控制逻辑

# D Pigeon d'Or

我也发现是错误单词了，https://www.grammarcheck.net/editor/ 可以检查拼写错误,但是ai的范围是误导XD..我还在想 1 2 3 4 5的样例数据是怎么解释。

正确的解法是，把错的字母连接起来，变成一个句话,这句话就是一个英文描述的公式,66666

# E Fourier Doodles

这是近年的机器学习识数梗

我已经发现的有:前20张图size很大[指文件大小，不是图片尺寸]

正确解法就是 标题+压缩包，如题名 的傅里叶，把前20个图做傅里叶，然后拼出表达式，即可

请把下面程序放到和图片同目录下，然后运行(自行用pip install安装依赖包)

```python
#!/usr/bin/python2
from PIL import Image
import numpy as np
from scipy import fftpack
import matplotlib.pyplot as plt

if __name__ == '__main__':
    plt.figure(figsize=(5, 5)) # 画布大小
    for i in range(1, 21): # 20张图片
        img = Image.open(str(i) + '.png').convert('L')  # 灰度 多色应该也可以，但是还要加更多处理
        imgout = fftpack.fftshift(fftpack.fft2(img)) # 2维傅里叶
        psd2D = np.log(np.abs(imgout))  # (256,256) 取log
        plt.subplot(4, 5, i) # 把它们依次显示在画布上
        plt.axis('off')
        plt.imshow(psd2D, cmap='Greys_r')
    plt.show()
```

官方题解给的在线工具 http://www.ejectamenta.com/Imaging-Experiments/fourierimagefiltering.html

# F Neat Numbers

嗯。。我去google查了单词，但。。。。 google的翻译并不能成功的帮助我

正确解法是 标题+英文单词理解+样例，neat words要的是所有大写字母 都是`直线段`组成的 即可`AEFHIKLMNTVWXYZ`，相对来说其它字母是带有`弯`的

# G AI Takeover

TODO

# 综上

真好玩+只会签到,题目都有实际的背景，出题不是乱出....总结逐渐开花
