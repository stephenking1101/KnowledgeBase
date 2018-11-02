#!/usr/bin/python
# -*- coding: UTF-8 -*-


# 单下划线、双下划线、头尾双下划线说明：
# __foo__: 定义的是特殊方法，一般是系统定义名字 ，类似 __init__() 之类的。
# 
# _foo: 以单下划线开头的表示的是 protected 类型的变量，即保护类型只能允许其本身与子类进行访问，不能用于 from module import *
# 
# __foo: 双下划线的表示的是私有类型(private)的变量, 只能是允许这个类本身进行访问了。 

class Employee:
    '所有员工的基类'
    empCount = 0  # empCount 变量是一个类变量，它的值将在这个类的所有实例之间共享。你可以在内部类或外部类使用 Employee.empCount 访问。

    def __init__(self, name, salary):  # __init__()方法是一种特殊的方法，被称为类的构造函数或初始化方法，当创建了这个类的实例时就会调用该方法
        self.name = name  # 实例变量：定义在方法中的变量，只作用于当前实例的类。
        self.salary = salary
        Employee.empCount += 1

    def displayCount(self):  # self 代表类的实例，self 在定义类的方法时是必须有的，虽然在调用时不必传入相应的参数。
        print("Total Employee %d" % Employee.empCount)

    def displayEmployee(self):
        self.abc = "abc";
        print("Name : ", self.name, ", Salary: ", self.salary)

    def __del__(self):  # __del__在对象销毁的时候被调用
        class_name = self.__class__.__name__
        print(self.abc)
        print(class_name, "销毁")


"创建 Employee 类的第一个对象"
emp1 = Employee("Zara", 2000)
"创建 Employee 类的第二个对象"
emp2 = Employee("Manni", 5000)
emp1.displayEmployee()
emp2.displayEmployee()
print("Total Employee %d" % Employee.empCount)

print("Employee.__doc__:", Employee.__doc__)
print("Employee.__name__:", Employee.__name__)
print("Employee.__module__:", Employee.__module__)
print("Employee.__bases__:", Employee.__bases__)
print("Employee.__dict__:", Employee.__dict__)

print(id(emp1))  # 打印对象的id
del (emp1)


class Parent:  # 定义父类
    parentAttr = 100

    def __init__(self):
        print("调用父类构造函数")

    def parentMethod(self):
        print('调用父类方法')

    def setAttr(self, attr):
        Parent.parentAttr = attr

    def getAttr(self):
        print("父类属性 :", Parent.parentAttr)


class Child(Parent):  # 定义子类
    def __init__(self):  # 如果重写了__init__ 时，要继承父类的构造方法，可以使用 super 关键字：
        print("调用子类构造方法")
        super(Child, self).__init__()
        Parent.__init__(self)  # 还有一种经典写法：父类名称.__init__(self,参数1，参数2，...)

    def childMethod(self):
        print('调用子类方法')


def main():
    c = Child()  # 实例化子类
    c.childMethod()  # 调用子类的方法
    c.parentMethod()  # 调用父类方法
    c.setAttr(200)  # 再次调用父类的方法 - 设置属性值
    c.getAttr()  # 再次调用父类的方法 - 获取属性值


if __name__ == '__main__':
    main()
