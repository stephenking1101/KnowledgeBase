#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from classsample.employee import Employee
from classsample import cli_util

import sys
print(sys.argv)

# 定义函数
def printme(str="test"):
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
    publicCount = 0  # 公开变量

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
# 第二次同样可以.
print("conuter.publicCount: " + str(counter.publicCount))
print(counter._JustCounter__secretCount)  # 写成counter.__secretCount会报错，因为实例不能访问私有变量
try:
    counter.count2()
except IOError:
    print("不能调用非公有属性!")
else:
    print("ok!")  # 现在呢!证明是滴!

# 也可写作status, output
(status, output) = cli_util.run_cmd("echo test > test.log")
print(output)
# cli_util.run_cmd("ping -t 127.0.0.1", 2)
#################################### 获取键盘输入 ################################################
# age = input("Please intput your age:")
# print(age)

#################################### 读取properties文件 ################################################
from classsample.properties_util import Properties
dictProperties=Properties("filename.properties").getProperties()
print(dictProperties)
print(dictProperties['name'])
print(dictProperties.keys())
print(dictProperties.get("a.b.c.id"))

#################################### 获取本机所有IP地址 ################################################
import socket

# 查看当前主机名
print('当前主机名称为 : ' + socket.gethostname())

# 根据主机名称获取当前IP
print('当前主机的IP为: ' + socket.gethostbyname(socket.gethostname()))


# 下方代码为获取当前主机IPV4 和IPV6的所有IP地址(所有系统均通用)
# getaddrinfo()函数，该函数用法为getaddrinfo(host, port, family=0, type=0, proto=0,
# flags=0)，返回值是一个五元组的列表，该五元组形式为(family, type, proto, canonname, sockaddr)，其中最后一个元素sockaddr对于IPV4协议是(IP address,
# port)形式的元组，而对于IPV6协议是(address, port, flow info, scope id)形式的元组，也就是说，不管是IPV4还是IPV6，上面的函数都可以正确地获取IP地址。
addrs = socket.getaddrinfo(socket.gethostname(), None)

for item in addrs:
    print(item)

# 仅获取当前IPV4地址
print('for循环获取首个当前主机IPV4地址为:' + [item[4][0] for item in addrs if ':' not in item[4][0]][0])  # 由for 循环获取循环变量的列表
print('for循环获取所有当前主机IPV4地址为:' + ','.join([item[4][0] for item in addrs if ':' not in item[4][0]]))
# 同上仅获取当前IPV4地址
for item in addrs:
    if ':' not in item[4][0]:
        print('当前主机IPV4地址为:' + item[4][0])


def main():
    pass
