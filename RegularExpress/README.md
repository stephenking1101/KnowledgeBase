# 正则表达式

## ., [ ], ^, $

四个字符是所有语言都支持的正则表达式，所以这四个是基础的正则表达式。正则难理解因为里面有一个等价的概念，这个概念大大增加了理解难度，让很多初学者看起来会懵，如果把等价都恢复成原始写法，自己书写正则就超级简单了，就像说话一样去写你的正则了：

##　等价：
等价是等同于的意思，表示同样的功能，用不同符号来书写。

* ?,*,+,\d,\w 都是等价字符  
　　?等价于匹配长度{0,1}
　　*等价于匹配长度{0,} 
　　+等价于匹配长度{1,}
　　\d等价于[0-9]
  \D等价于[^0-9]
　　\w等价于[A-Za-z_0-9]
  \W等价于[^A-Za-z_0-9]。

* 常用运算符与表达式：
　　^ 开始
　　（） 域段
　　[] 包含,默认是一个字符长度
　　[^] 不包含,默认是一个字符长度
　　{n,m} 匹配长度 
　　. 任何单个字符(\. 字符点)
　　| 或
　　\ 转义
　　$ 结尾
　　[A-Z] 26个大写字母
　　[a-z] 26个小写字母
　　[0-9] 0至9数字
  [A-Za-z0-9] 26个大写字母、26个小写字母和0至9数字
　　， 分割
　　.
　　
　　分割语法：
　　[A,H,T,W] 包含A或H或T或W字母
　　[a,h,t,w] 包含a或h或t或w字母
　　[0,3,6,8] 包含0或3或6或8数字

　　语法与释义：
　　基础语法 "^([]{})([]{})([]{})$"
　　正则字符串 = "开始（[包含内容]{长度}）（[包含内容]{长度}）（[包含内容]{长度}）结束" 
　　
　　?,*,+,\d,\w 这些都是简写的,完全可以用[]和{}代替，在(?:)(?=)(?!)(?<=)(?<!)(?i)(*?)(+?)这种特殊组合情况下除外。
　　初学者可以忽略?,*,+,\d,\w一些简写标示符，学会了基础使用再按表自己去等价替换

　　
　　实例：
　　字符串；tel:086-0666-88810009999
　　原始正则："^tel:[0-9]{1,3}-[0][0-9]{2,3}-[0-9]{8,11}$" 
　　速记理解：开始 "tel:普通文本"[0-9数字]{1至3位}"-普通文本"[0数字][0-9数字]{2至3位}"-普通文本"[0-9数字]{8至11位} 结束"
　　等价简写后正则写法："^tel:\d{1,3}-[0]\d{2,3}-\d{8,11}$" ，简写语法不是所有语言都支持

  /g意思就是：global可选标志，带这个标志表示替换将针对行中每个匹配的串进行，否则则只替换行中第一个匹配串。如：we.fdffddfwe.加上/g后，则2个we都会出来；
  /i意思就是 case insensitive,区分大小写小字。如：sw与sW不管；

** 正则表达式应用——实例应用

1.验证用户名和密码：（"^[a-zA-Z]\w{5,15}$"）正确格式："[A-Z][a-z]_[0-9]"组成,并且第一个字必须为字母6~16位；
2.验证电话号码：（"^(\d{3,4}-)\d{7,8}$"）正确格式：xxx/xxxx-xxxxxxx/xxxxxxxx；
3.验证手机号码："^1[3|4|5|7|8][0-9]{9}$"；
4.验证身份证号（15位）："\d{14}[[0-9],0-9xX]"，（18位）："\d{17}[[0-9],0-9xX]"；
5.验证Email地址：("^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")；
6.只能输入由数字和26个英文字母组成的字符串：("^[A-Za-z0-9]+$")；
7.整数或者小数：^[0-9]+([.][0-9]+){0,1}$
8.只能输入数字："^[0-9]*$"。
9.只能输入n位的数字："^\d{n}$"。
10.只能输入至少n位的数字："^\d{n,}$"。
11.只能输入m~n位的数字："^\d{m,n}$"。
12.只能输入零和非零开头的数字："^(0|[1-9][0-9]*)$"。
13.只能输入有两位小数的正实数："^[0-9]+(\.[0-9]{2})?$"。
14.只能输入有1~3位小数的正实数："^[0-9]+(\.[0-9]{1,3})?$"。
15.只能输入非零的正整数："^\+?[1-9][0-9]*$"。
16.只能输入非零的负整数："^\-[1-9][0-9]*$"。
17.只能输入长度为3的字符："^.{3}$"。
18.只能输入由26个英文字母组成的字符串："^[A-Za-z]+$"。
19.只能输入由26个大写英文字母组成的字符串："^[A-Z]+$"。
20.只能输入由26个小写英文字母组成的字符串："^[a-z]+$"。
21.验证是否含有^%&',;=?$\"等字符："[%&',;=?$\\^]+"。
22.只能输入汉字："^[\u4e00-\u9fa5]{0,}$"。
23.验证URL："^http://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$"。
24.验证一年的12个月："^(0?[1-9]|1[0-2])$"正确格式为："01"～"09"和"10"～"12"。
25.验证一个月的31天："^((0?[1-9])|((1|2)[0-9])|30|31)$"正确格式为；"01"～"09"、"10"～"29"和“30”~“31”。
26.获取日期正则表达式：\\d{4}[年|\-|\.]\d{\1-\12}[月|\-|\.]\d{\1-\31}日?
评注：可用来匹配大多数年月日信息。
27.匹配双字节字符(包括汉字在内)：[^\x00-\xff]
评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）
28.匹配空白行的正则表达式：\n\s*\r
评注：可以用来删除空白行
29.匹配HTML标记的正则表达式：<(\S*?)[^>]*>.*?</>|<.*? />
评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力
30.匹配首尾空白字符的正则表达式：^\s*|\s*$
评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
31.匹配网址URL的正则表达式：[a-zA-z]+://[^\s]*
评注：网上流传的版本功能很有限，上面这个基本可以满足需求
32.匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
评注：表单验证时很实用
33.匹配腾讯QQ号：[1-9][0-9]{4,}
评注：腾讯QQ号从10 000 开始
34.匹配中国邮政编码：[1-9]\\d{5}(?!\d)
评注：中国邮政编码为6位数字
35.匹配ip地址：([1-9]{1,3}\.){3}[1-9]。
评注：提取ip地址时有用
36.匹配MAC地址：([A-Fa-f0-9]{2}\:){5}[A-Fa-f0-9]

## 应用场景
将所有方法foo(a,b,c)的实例改为foo(b,a,c)。这里a、b和c可以是任何提供给方法foo()的参数。也就是说我们要实现这样的转换：

之前 之后
foo(10,7,2) foo(7,10,2)
foo(x+13,y-2,10) foo(y-2,x+13,10)
foo( bar(8), x+y+z, 5) foo( x+y+z, bar(8), 5)

下面这条替换命令能够实现这一方法：

:%s/foo(\([^,]*\),\([^,]*\),\([^,)]*\))/foo(\2,\1,\3)/g
让我们把它打散来加以分析。写出这个表达式的基本思路是找出foo()和它的括号中的三个参数的位置。第一个参数是用这个表达式来识别的：：\([^,]*\)，我们可以从里向外来分析它：
[^,] 除了逗号之外的任何字符
[^,]* 0或者多个非逗号字符
\([^,]*\) 将这些非逗号字符标记为\1，这样可以在之后的替换模式表达式中引用它
\([^,]*\), 我们必须找到0或者多个非逗号字符后面跟着一个逗号，并且非逗号字符那部分要标记出来以备后用。
正是指出一个使用正则表达式常见错误的最佳时机。为什么我们要使用[^,]*这样的一个表达式，而不是更加简单直接的写法，例如：.*，来匹配第一个参数呢？设想我们使用模式.*来匹配字符串"10,7,2"，它应该匹配"10,"还是"10,7,"？为了解决这个两义性（ambiguity），正则表达式规定一律按照最长的串来，在上面的例子中就是"10,7,"，显然这样就找出了两个参数而不是我们期望的一个。所以，我们要使用[^,]*来强制取出第一个逗号之前的部分。
这个表达式我们已经分析到了：foo(\([^,]*\)，这一段可以简单的翻译为“当你找到foo(就把其后直到第一个逗号之前的部分标记为\1”。然后我们使用同样的办法标记第二个参数为\2。对第三个参数的标记方法也是一样，只是我们要搜索所有的字符直到右括号。我们并没有必要去搜索第三个参数，因为我们不需要调整它的位置，但是这样的模式能够保证我们只去替换那些有三个参数的foo()方法调用，在foo()是一个重载（overloading）方法时这种明确的模式往往是比较保险的。然后，在替换部分，我们找到foo()的对应实例，然后利用标记好的部分进行替换，是把第一和第二个参数交换位置。