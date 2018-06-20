#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from classsample.employee import Employee

# 定义函数
def printme( str ):
   "打印任何传入的字符串"
   print(str);
   return;
 
# 调用函数
printme("我要调用用户自定义函数!");
printme("再次调用同一函数");
printme("Done");
print("Total Employee %d" % Employee.empCount)

class JustCounter:
    __secretCount = 0  # 私有变量
    publicCount = 0    # 公开变量
    def count(self):
        self.__secretCount += 1
        self.publicCount += 1
        print(self.__secretCount)
    def count2(self):
        print(self)
        print(self.__class__)
        print(self.__secretCount)

counter = JustCounter()
counter.count()
# 在类的对象生成后,调用含有类私有属性的函数时就可以使用到私有属性.
counter.count()
#第二次同样可以.
print(counter.publicCount)
print(counter._JustCounter__secretCount ) # 不改写报错，实例不能访问私有变量
try:
    counter.count2()
except IOError:
    print("不能调用非公有属性!")
else:
    print("ok!") #现在呢!证明是滴!