---
title: 某人的python作业
date: 2017-03-27 20:49:14
tags:
category: [code]
---

```python
# 字符串 在内存里的保存形式 英文数字等会按照ASCII码保存 (中文是utf-8或其它)
# 如果 字符串变量名为 s ，s="hello"，那么s[0] 即是取它的第一个字符'h',s[1]是取它第二个字符'e',以此类推 
#
# ASCII 码表在这里: http://baike.baidu.com/link?url=vIX_ks54v50vnb-tKKAFKfQXc6Mqu1uzbfvBJQwuLadPL0GXSVLo1WlZTBSRtARNcyLFe8Pl0IqKHdJNAE9aZciRoFMDqOR2UrOXqPvAYrxc16528vFTTUS1CXXM1IDbyqMXPkhJGfwyqbA_e781Dq
# 看表中的 "十进制列" 和 "解释列" 即可
# 可以看到 
#    数字0~9 对应的ASCII是 48~57
#    英文 A~Z 对应的ASCII 65~90
#    a~z 对应的是97~122
#
# 所以我们判断字符串的第一个字符s[0] 是否是数字的话，可以用 下面三种方式 任意一种，第三种比较简洁
#     ord(s[0]) >= 48 and ord(s[0]) <= 57
#     ord(s[0]) >= ord('0') and ord(s[0]) <= ord('9')
#     s[0] >= '0' and s[0] <= '9'
#
# 下面示例判断 输入的字符串的 第一个字符是 数字 还是 字母 还是 其它

inputstring = input("输入的字符串:")

if (inputstring[0] >= 'A' and inputstring[0] <= 'Z') or (inputstring[0] >= 'a' and inputstring[0] <= 'z') :
    print("输入的 第一个字符 为英文")
elif inputstring[0] >= '0' and inputstring[0] <= '9':
    print("输入的 第一个字符 为数字")
else :
    print("输入的 第一个字符 为其它")
```
