# Groovy

## 基础

Groovy注释标记和Java一样，支持//或者//

Groovy语句可以不用分号结尾。Groovy为了尽量减少代码的输入，确实煞费苦心

Groovy中支持动态类型，即定义变量的时候可以不指定其类型。Groovy中，变量定义可以使用关键字def。注意，虽然def不是必须的，但是为了代码清晰，建议还是使用def关键字

```
def var =1 
def str= "i am a person"
def int x = 1//也可以指定类型

函数定义时，参数的类型也可以不指定。比如

```
String function(arg1,args2){//无需指定参数类型
}
```

除了变量定义可以不指定类型外，Groovy中函数的返回值也可以是无类型的。比如：

```
//无类型的函数定义，必须使用def关键字
def  nonReturnTypeFunc(){
     last_line   //最后一行代码的执行结果就是本函数的返回值
}
//如果指定了函数返回类型，则可不必加def关键字来定义函数
String  getString(){
   return "I am a string"
}
```

其实，所谓的无返回类型的函数，我估计内部都是按返回Object类型来处理的。毕竟，Groovy是基于Java的，而且最终会转成Java Code运行在JVM上

函数返回值：Groovy的函数里，可以不使用return xxx来设置xxx为函数返回值。如果不使用return语句的话，则函数里最后一句代码的执行结果被设置成返回值。比如
//下面这个函数的返回值是字符串"getSomething return value"
def getSomething(){
   "getSomething return value" //如果这是最后一行代码，则返回类型为String
    1000 //如果这是最后一行代码，则返回类型为Integer
}
注意，如果函数定义时候指明了返回值类型的话，函数中则必须返回正确的数据类型，否则运行时报错。如果使用了动态类型的话，你就可以返回任何类型了。

Groovy对字符串支持相当强大，充分吸收了一些脚本语言的优点：
1 单引号''中的内容严格对应Java中的String，不对$符号进行转义
 def singleQuote='I am $ dolloar'  //输出就是I am $ dolloar
2 双引号""的内容则和脚本语言的处理有点像，如果字符中有$号的话，则它会$表达式先求值。

def doubleQuoteWithoutDollar = "I am one dollar" //输出 I am one dollar
def x = 1
def doubleQuoteWithDollar = "I am $x dolloar" //输出I am 1 dolloar
3 三个引号'''xxx'''中的字符串支持随意换行 比如

 def multieLines = ''' begin
     line  1 
     line  2
     end '''
最后，除了每行代码不用加分号外，Groovy中函数调用的时候还可以不加括号。比如：
println("test") ---> println "test"
注意，虽然写代码的时候，对于函数调用可以不带括号，但是Groovy经常把属性和函数调用混淆。比如

def getSomething(){
   "hello"
}
getSomething() //如果不加括号的话，Groovy会误认为getSomething是一个变量。
所以，调用函数要不要带括号，我个人意见是如果这个函数是Groovy API或者Gradle API中比较常用的，比如println，就可以不带括号。否则还是带括号。Groovy自己也没有太好的办法解决这个问题，只能兵来将挡水来土掩了。

## 数据类型

Groovy中的数据类型我们就介绍两种和Java不太一样的：

一个是Java中的基本数据类型。
另外一个是Groovy中的容器类。
最后一个非常重要的是闭包。
基本数据类型
作为动态语言，Groovy世界中的所有事物都是对象。所以，int，boolean这些Java中的基本数据类型，在Groovy代码中其实对应的是它们的包装数据类型。比如int对应为Integer，boolean对应为Boolean。比如下图中的代码执行结果：

image005.png
容器类
List类

变量定义：List变量由[]定义，比如

def aList = [5,'string',true] //List由[]定义，其元素可以是任何对象

变量存取：可以直接通过索引存取，而且不用担心索引越界。如果索引超过当前链表长度，List会自动
往该索引添加元素

assert aList[1] == 'string'
assert aList[5] == null //第6个元素为空
aList[100] = 100  //设置第101个元素的值为10
assert aList[100] == 100

那么，aList到现在为止有多少个元素呢？

println aList.size  ===>结果是101
Map类

容器变量定义

变量定义：Map变量由[:]定义，比如

def aMap = ['key1':'value1','key2':true] 

Map由[:]定义，注意其中的冒号。冒号左边是key，右边是Value。key必须是字符串，value可以是任何对象。另外，key可以用''或""包起来，也可以不用引号包起来。比如

def aNewMap = [key1:"value",key2:true] //其中的key1和key2默认被
处理成字符串"key1"和"key2"

不过Key要是不使用引号包起来的话，也会带来一定混淆，比如

def key1="wowo"
def aConfusedMap=[key1:"who am i?"]

aConfuseMap中的key1到底是"key1"还是变量key1的值“wowo”？显然，答案是字符串"key1"。如果要是"wowo"的话，则aConfusedMap的定义必须设置成：

def aConfusedMap=[(key1):"who am i?"]

Map中元素的存取更加方便，它支持多种方法：

println aMap.keyName    <==这种表达方法好像key就是aMap的一个成员变量一样
println aMap['keyName'] <==这种表达方法更传统一点
aMap.anotherkey = "i am map"  <==为map添加新元素
Range类
Range是Groovy对List的一种拓展，变量定义和大体的使用方法如下：

def aRange = 1..5  <==Range类型的变量 由begin值+两个点+end值表示
                      左边这个aRange包含1,2,3,4,5这5个值

如果不想包含最后一个元素，则

def aRangeWithoutEnd = 1..<5  <==包含1,2,3,4这4个元素
println aRange.from
println aRange.to
API
Groovy的API文档位于 http://www.groovy-lang.org/api.html

闭包
闭包，英文叫Closure，是Groovy中非常重要的一个数据类型或者说一种概念了。闭包的历史来源，种种好处我就不说了。我们直接看怎么使用它！

闭包，是一种数据类型，它代表了一段可执行的代码。其外形如下：

def aClosure = {//闭包是一段代码，所以需要用花括号括起来..  
    String param1, int param2 ->  //这个箭头很关键。箭头前面是参数定义，箭头后面是代码  
    println"this is code" //这是代码，最后一句是返回值，  
   //也可以使用return，和Groovy中普通函数一样  
}  
简而言之，Closure的定义格式是：

def xxx = {paramters -> code}  //或者  
def xxx = {无参数，纯code}  这种case不需要->符号
说实话，从C/C++语言的角度看，闭包和函数指针很像。闭包定义好后，要调用它的方法就是：
闭包对象.call(参数) 或者更像函数指针调用的方法：
闭包对象(参数)
比如

aClosure.call("this is string",100)  或者  
aClosure("this is string", 100)  
上面就是一个闭包的定义和使用。在闭包中，还需要注意一点：
如果闭包没定义参数的话，则隐含有一个参数，这个参数名字叫it，和this的作用类似。it代表闭包的参数。
比如：

def greeting = { "Hello, $it!" }
assert greeting('Patrick') == 'Hello, Patrick!'
等同于

def greeting = { it -> "Hello, $it!" }
assert greeting('Patrick') == 'Hello, Patrick!'
但是，如果在闭包定义时，采用下面这种写法，则表示闭包没有参数！

def noParamClosure = { -> true }
这个时候，我们就不能给noParamClosure传参数了！

noParamClosure ("test")  <==报错喔！
Closure使用中的注意点

省略圆括号
闭包在Groovy中大量使用，比如很多类都定义了一些函数，这些函数最后一个参数都是一个闭包。比如：

public static <T> List<T> each(List<T> self, Closure closure)
上面这个函数表示针对List的每一个元素都会调用closure做一些处理。这里的closure，就有点回调函数的感觉。但是，在使用这个each函数的时候，我们传递一个怎样的Closure进去呢？比如：

def iamList = [1,2,3,4,5]  //定义一个List
iamList.each{  //调用它的each，这段代码的格式看不懂了吧？each是个函数，圆括号去哪了？
      println it
}
上面代码有两个知识点：
each函数调用的圆括号不见了！原来，Groovy中，当函数的最后一个参数是闭包的话，可以省略圆括号。比如

def  testClosure(int a1,String b1, Closure closure){
      //do something
      closure() //调用闭包
}
那么调用的时候，就可以免括号！
testClosure (4, "test", {
   println "i am in closure"
} )  //红色的括号可以不写..
注意，这个特点非常关键，因为以后在Gradle中经常会出现图7这样的代码：

image008.png
经常碰见图7这样的没有圆括号的代码。省略圆括号虽然使得代码简洁，看起来更像脚本语言，但是它这经常会让我confuse（不知道其他人是否有同感），以doLast为例，完整的代码应该按下面这种写法：

 doLast({
   println 'Hello world!'
})
有了圆括号，你会知道 doLast只是把一个Closure对象传了进去。很明显，它不代表这段脚本解析到doLast的时候就会调用println 'Hello world!' 。

但是把圆括号去掉后，就感觉好像println 'Hello world!'立即就会被调用一样！

如何确定Closure的参数
另外一个比较让人头疼的地方是，Closure的参数该怎么搞？还是刚才的each函数：

public static <T> List<T> each(List<T> self, Closure closure)
如何使用它呢？比如：

def iamList = [1,2,3,4,5]  //定义一个List变量
iamList.each{  //调用它的each函数，只要传入一个Closure就可以了。
  println it
}
看起来很轻松，其实：
对于each所需要的Closure，它的参数是什么？有多少个参数？返回值是什么？

我们能写成下面这样吗？

iamList.each{String name,int x ->
  return x
}  //运行的时候肯定报错！
所以，Closure虽然很方便，但是它一定会和使用它的上下文有极强的关联。要不，作为类似回调这样的东西，我如何知道调用者传递什么参数给Closure呢？

此问题如何破解？只能通过查询API文档才能了解上下文语义。比如下图8：


image009.png

image010.png
图8中：
each函数说明中，将给指定的closure传递Set中的每一个item。所以，closure的参数只有一个。
findAll中，绝对抓瞎了。一个是没说明往Closure里传什么。另外没说明Closure的返回值是什么.....。

对Map的findAll而言，Closure可以有两个参数。findAll会将Key和Value分别传进去。并且，Closure返回true，表示该元素是自己想要的。返回false表示该元素不是自己要找的。示意代码所示：

def result = aMap.findAll {
    key, value ->
        println "key=$key,value=$value"
        if (key == "k1")
            return true
        return false
}
Closure的使用有点坑，很大程度上依赖于你对API的熟悉程度，所以最初阶段，SDK查询是少不了的。

## 脚本类

import
groovy也可以像java那样写package，然后写类

package bean
class Person {
    String name
    String gender
    Person(name, gender) {
        this.name = name
        this.gender = gender
    }
    def print() {
        println name + " " + gender
    }
}
import bean.Person
def name = 'EvilsoulM'
def person=new Person(name,"male");
person.print()
groovy和Java类很相似。当然，如果不声明public/private等访问权限的话，Groovy中类及其变量默认都是public的。

脚本到底是什么
Java中，我们最熟悉的是类。但是我们在Java的一个源码文件中，不能不写class（interface或者其他....），而Groovy可以像写脚本一样，把要做的事情都写在xxx.groovy中，而且可以通过groovy xxx.groovy直接执行这个脚本。这到底是怎么搞的？

Groovy把它转换成这样的Java类：
执行** groovyc** -d classes test.groovy
groovyc是groovy
的编译命令，-d classes用于将编译得到的class文件拷贝到classes文件夹下
图13是test.groovy脚本转换得到的java class。用jd-gui反编译它的代码：
image015.png
test.groovy被转换成了一个test类，它从script派生。
每一个脚本都会生成一个static main函数。这样，当我们groovy test.groovy的时候，其实就是用java去执行这个main函数
脚本中的所有代码都会放到run函数中。比如，println 'Groovy world'，这句代码实际上是包含在run函数里的。
如果脚本中定义了函数，则函数会被定义在test类中。
groovyc是一个比较好的命令，读者要掌握它的用法。然后利用jd-gui来查看对应class的Java源码。

3.脚本中的变量和作用域
前面说了，xxx.groovy只要不是和Java那样的class，那么它就是一个脚本。而且脚本的代码其实都会被放到run函数中去执行。那么，在Groovy的脚本中，很重要的一点就是脚本中定义的变量和它的作用域。举例：

def x = 1 <==注意，这个x有def（或者指明类型，比如 int x = 1）  
def printx(){  
   println x  
}  
printx() <==报错，说x找不到

为什么？继续来看反编译后的class文件。

image016.png

图中，x也没有被定义成test的成员函数，而是在run的执行过程中，将x作为一个属性添加到test实例对象中了。然后在printx中，先获取这个属性。

注意，Groovy的文档说 x = 1这种定义将使得x变成test的成员变量，但从反编译情况看，这是不对的.....(这是infoQ文章中说的，但是测试来说这句话是对的，应该是文章作者没有定义成class)

虽然printx可以访问x变量了，但是假如有其他脚本却无法访问x变量。因为它不是test的成员变量。

比如，我在测试目录下创建一个新的名为test1.groovy。这个test1将访问test.groovy中定义的printx函数：

def atest=new test()
atest.printx()
这种方法使得我们可以将代码分成模块来编写，比如将公共的功能放到test.groovy中，然后使用公共功能的代码放到test1.groovy中。
执行groovy test1.groovy，报错。说x找不到。这是因为x是在test的run函数动态加进去的。怎么办？

import groovy.transform.Field;   //必须要先import
@Field x = 1  <==在x前面加上@Field标注，这样，x就彻彻底底是test的成员变量了。
查看编译后的test.class文件，得到：

image019.png

这个时候，test.groovy中的x就成了test类的成员函数了。如此，我们可以在script中定义那些需要输出给外部脚本或类使用的变量了！

eg:
ScriptBase.groovy类 (用了filed 就相当这就是一个class 就不用再自己定义class了)

import groovy.transform.Field;
@Field author = 'EvilsouM'
@Field gender = 'male'
@Field age = 25
//必须要先import
def printInfo() {
    println "name->$author  gender->$gender age->$age"
}
或者自己定义class

class ScriptBase {
    def author = 'EvilsouM'
    def gender = 'male'
    def age = 25//必须要先import
    def printInfo() {
        println "name->$author  gender->$gender age->$age"
    }
}
scripttest.groovy类

def Closure printAuthorInfo = {
            String name, String gender, int age ->
                println "name->$name  gender->$gender age->$age"
}
def ScriptBase base = new ScriptBase()
base.printInfo()
printAuthorInfo.call(base.author, base.gender, base.age) 上面两种方式都能拿到成员变量
文件I/O操作
本节介绍下Groovy的文件I/O操作。直接来看例子吧，虽然比Java看起来简单，但要理解起来其实比较难。尤其是当你要自己查SDK并编写代码的时候。

整体说来，Groovy的I/O操作是在原有Java I/O操作上进行了更为简单方便的封装，并且使用Closure来简化代码编写。主要封装了如下一些了类：

image020.png
读文件
Groovy中，文件读操作简单到令人发指：
def targetFile = new File(文件名) <==File对象还是要创建的。
然后打开http://docs.groovy-lang.org/latest/html/groovy-jdk/java/io/File.html
看看Groovy定义的API：
1 读该文件中的每一行：eachLine的唯一参数是一个Closure。Closure的参数是文件每一行的内容
其内部实现肯定是Groovy打开这个文件，然后读取文件的一行，然后调用Closure...

def File targetFile = new File("build.gradle")
targetFile.eachLine {
    String line ->
        println line
}
2 直接得到文件内容

targetFile.getBytes()  <==文件内容一次性读出，返回类型为byte[]  
3 使用InputStream.InputStream的SDK在 http://docs.groovy-lang.org/latest/html/groovy-jdk/java/io/InputStream.html

def ism =  targetFile.newInputStream()  
//操作ism，最后记得关掉  
ism.close  
4 使用闭包操作inputStream，以后在Gradle里会常看到这种搞法

 targetFile.withInputStream{
 ism -> 操作ism. 不用close。Groovy会自动替你close
}
写文件
和读文件差不多。不再啰嗦。这里给个例子，告诉大家如何copy文件。
def srcFile = new File(源文件名)
def targetFile = new File(目标文件名)
 targetFile.withOutputStream{
 os-> srcFile.withInputStream {
 ins->
       os << ins //利用OutputStream的<<操作符重载，完成从inputstream到OutputStream  //的输出
      }
 }

作者：EvilsoulM
链接：https://www.jianshu.com/p/94aabdfcdfc5
來源：简书

## Groovy常用语法总结

1.List，和Map的初始化
这个用的最多了，原来java的时候，非要新建一个List或者Map，然后把element一个一个加进去，特繁琐。用Groovy在语法上简洁了很多。

定义一个List： 

[java] view plain copy
List intList = [1,3,5,7,9]  
List stringList = ['a', 'b','']  

定义一个Map：
[java] view plain copy
Map map = [a:4,b:'d']  
定义Map的时候，对于key，如果像上面的例子一样，没有特别指示，那所有key都是String类型的，key值就是‘a’,'b'，上面的例子等价于

[java] view plain copy
Map map = ['a':4,'b':'d']  

某些时候，map的key可能是存在的一个变量，那这个时候，就要用括号把key抱起来，比如
[java] view plain copy
String a = 'I am Key'  
Map map = [(a):'I am Value']  

也可以定义空的List或者Map
[java] view plain copy
List empty = []  
Map empty = [:]  
需要知道的是，这种方式新建的List实例是ArrayList，Map实例是LinkedHashMap

2.二元运算符 ?:
java继承了C语言的问号表达式，二元运算符就是更加精简的问号表达式。形式：

[java] view plain copy
def result = a ?: b  

意为，如果条件为真，即a为true或者a有值，则result为a，否则result为b

3.安全占位符
这个很有用，可以避免很多NullPointerException，但是也不能滥用了

[java] view plain copy
def result = obj?.property  

代码里，obj是个对象，property是对象的一个熟悉，这行代码的意思，如果obj不为null，则会返回property属性的值，如果obj为null，这会直接返回null。语句可以一直串下去
[java] view plain copy
def result = a?.b?.c?.d...  


4.字段操作
按照Groovy Bean的标准，默认的时候类里面的所有字段，Groovy都会帮忙生成一个get方法。在类的外部，即便你直接用了属性名而不用get方法去取值，拿到的也是通过get方法拿到的值。如果想直接拿属性值怎么办呢？ 通过字段运算符：

[java] view plain copy
class A {  
   String b  
}  
  
A a = new A()  
a.b //通过get方法拿值  
a.getB() //通过get方法拿值  
a.@b //直接拿值  

5.GString
Java里有String，Groovy里新加了GString。Groovy的语法是，如果用单引号括起来的就是String，如果是双引号括起来的就是GString。所以Groovy不能直接定义原来Java里的char了。

String

[java] view plain copy
String s = 'This is a String'  

GString
[java] view plain copy
GString s = "This is a GString"  

两种方式定义出来的实例类型是不一样的。当然GString不是这么简单的，GString的强大之处在于它可以作为模板使用
[java] view plain copy
String name = 'count'  
int value1 = 23  
int value2 = 22  
GString s = "The value of $name is ${value1+value2}"   
println s  

最终的输出是： The value of count is 55

倒数第二行，里面有关键字符 $, $即代表去引用上下文中的变量值，而${}中间不仅可以引用变量值，还可以加上一些运算，作为一个表达式

最后一行这是把GString转换成String，再输出。

String是常量，但是GString是变量，准确的说，在GString中的$仅仅是作为一个模板的占位符存在，GString会保存对那个对象的引用，如果引用的对象值发生改变，GString的值也就跟着改变。

需要注意的是，Map里面String和GString就算最终生成的String值一样，但是还是当作两个key存在的。很容易理解，但是很容易犯的错误，比如手误把单引号写成了双引号等等都会引起这个错误。

6.构造函数
[java] view plain copy
class ClassA {  
    String s1  
    int i1  
    ClassB cb  
}  
class ClassB {  
    String s2  
}  
new ClassA(s1:'pro in A', i1:5, cb:[s2:'pro in B'])  

以上代码是可以工作的，Groovy会创建一个ClassA的实例，并把‘pro in A’ 和 5 分别设到属性s1和i1里。即便有一个复杂类型的熟悉cb，也能正常工作，ClassB的对象会被创建出来，并设到属性cb上。ClassB里的s2熟悉当然就是'pro in B'了。
可以看到构造函数里的参数很像Map的定义，确实，其实传入Map也是可以的

[java] view plain copy
new ClassA([s1:'pro in A', i1:5, cb:[s2:'pro in B']])  

这个功能，在一些数据模型转换的时候，比较方便。打个比方，前台来的JSON数据，直接全转成Map，再用构造函数new一下，就全部出来了。注意的是，如果Map存在某个类里没有的属性值，会出错误的。
7.asType
用Groovy的是，可能经常看到这样的代码

[java] view plain copy
String a = '78'  
int b = a as int  
print b  

第二行，有个关键字as，可以看出来作用就是把String类型的a转成int类型的b。它是怎么工作的呢，很简单，就是把这个操作代理给了String的asType方法，比如String有如下的方法（仅仅是例子，代码中不是这样）
[java] view plain copy
class String {  
    Object asType(Class clz) {  
         if(clz == Integer) {  
                return Integer.parseInt(this)  
         } else if(clz == GString) {  
                 return "$this"  
         } else {  
                 return super.asType(clz)  
         }  
    }  
}  

那么，String就可以用as运算符转换成int或者GString类型
[java] view plain copy
String a = '45'  
int b = a as int  
GString c = a as GString  

上面的 clz == GString 是合法的，在Groovy里等价于 clz == GString.class
8. inspect和eval
eval就和javascript里的eval一样，就是直接执行一段Groovy脚本，可以用Eval.me(...script here...)直接调用。

inspect就是eval的反相操作了，就是把一个对象转成一个合法的可执行的脚本（我的理解，没仔细看过文档）。没试过其他对象，但是像Map，List之类的都可以转出来。这就够了，Map，List转出来的数据之于Groovy就相当于JSON之于JavaScript。在系统内部的时候就可以直接当作数据传输，虽然大家都不推荐这么用，但是我还是坚持，如果数据只包含Map，List，Number，String等简单类型，为什么不用呢？（如果Number里值是NaN或者Infinite的时候有问题，但是很容易解决，看Eval类里的其他两个方法就知道了）。呵呵，我也就这么用着，直到发现了一个Bug（http://stackoverflow.com/questions/7410252/groovy-inspect-handle-dollar-sign）,没法解决，我才换掉了实现。

但是我对这个东西还是有很大期待，如果都是内部集成，不存在安全问题，且没有很好JSON支持的时候，这种方式还是很好的方式。




9.is方法
按照Groovy的定义，== 操作等于调用equals方法。这样，我们就失去了直接判断两个对象是不是同一对象的运算符。要判断是不是同一个对象，要调用is方法，比如thisObject.is(anotherObject)。这点非常重要，特别是在overwrite对象的equals方法的时候，eclipse自动生成的代码里面有些地方不能直接用==了，而要用is方法。