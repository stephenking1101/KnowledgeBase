---
title:  "Java Interview Q&A"
date:   2017-06-01 09:00:00 +0800
author: Stephen
categories: [interview]
---

# Java Interview Q&A

## abstract class和interface有什么区别

1. 相同点
   1. 两者都是抽象类，都不能实例化。
   2. interface实现类及abstrct class的子类都必须要实现已经声明的抽象方法。

2. 不同点
   1. interface需要实现，要用implements，而abstract class需要继承，要用extends。
   2. 一个类可以实现多个interface，但一个类只能继承一个abstract class。
   3. interface强调特定功能的实现，而abstract class强调所属关系。 
   4. 尽管interface实现类及abstrct class的子类都必须要实现相应的抽象方法，但实现的形式不同。interface中的每一个方法都是抽象方法，都只是声明的 (declaration, 没有方法体)，实现类必须要实现。而abstract class的子类可以有选择地实现。
  这个选择有两点含义：
    一是abastract class中并非所有的方法都是抽象的，只有那些冠有abstract的方法才是抽象的，子类必须实现。那些没有abstract的方法，在abstrct class中必须定义方法体。
    二是abstract class的子类在继承它时，对非抽象方法既可以直接继承，也可以覆盖；而对抽象方法，可以选择实现，也可以通过再次声明其方法为抽象的方式，无需实现，留给其子类来实现，但此类必须也声明为抽象类。既是抽象类，当然也不能实例化。
   5. abstract class是interface与Class的中介。
  interface是完全抽象的，只能声明方法，而且只能声明pulic的方法，不能声明private及protected的方法，不能定义方法体，也 不能声明实例变量。然而，interface却可以声明常量变量，并且在JDK中不难找出这种例子。但将常量变量放在interface中违背了其作为接 口的作用而存在的宗旨，也混淆了interface与类的不同价值。如果的确需要，可以将其放在相应的abstract class或Class中。
  abstract class在interface及Class中起到了承上启下的作用。一方面，abstract class是抽象的，可以声明抽象方法，以规范子类必须实现的功能；另一方面，它又可以定义缺省的方法体，供子类直接使用或覆盖。另外，它还可以定义自己 的实例变量，以供子类通过继承来使用。

3. interface的应用场合
   1. 类与类之前需要特定的接口进行协调，而不在乎其如何实现。
   2. 作为能够实现特定功能的标识存在，也可以是什么接口方法都没有的纯粹标识。
   3. 需要将一组类视为单一的类，而调用者只通过接口来与这组类发生联系。
   4. 需要实现特定的多项功能，而这些功能之间可能完全没有任何联系。

4. abstract class的应用场合
  
   一句话，在既需要统一的接口，又需要实例变量或缺省的方法的情况下，就可以使用它。最常见的有：
   1. 定义了一组接口，但又不想强迫每个实现类都必须实现所有的接口。可以用abstract class定义一组方法体，甚至可以是空方法体，然后由子类选择自己所感兴趣的方法来覆盖。
   2. 某些场合下，只靠纯粹的接口不能满足类与类之间的协调，还必需类中表示状态的变量来区别不同的关系。abstract的中介作用可以很好地满足这一点。
   3. 规范了一组相互协调的方法，其中一些方法是共同的，与状态无关的，可以共享的，无需子类分别实现；而另一些方法却需要各个子类根据自己特定的状态来实现特定的功能。
  
## 有状态、无状态(Stateful and Stateless)

### 基本概念： 

有状态就是有数据存储功能。有状态对象(Stateful Bean)，就是有实例变量的对象，可以保存数据，是非线程安全的。在不同方法调用间不保留任何状态。 

无状态就是一次操作，不能保存数据。无状态对象(Stateless Bean)，就是没有实例变量的对象.不能保存数据，是不变类，是线程安全的。 

### EJB中的有状态与无状态： 

1. Stateful session bean的每个用户都有自己的一个实例，所以两者对stateful session bean的操作不会影响对方。另外注意：如果后面需要操作某个用户的实例，你必须在客户端缓存Bean的Stub对象（JSP通常的做法是用Session缓存），这样在后面每次调用中，容器才知道要提供相同的bean实例。 

2. Stateless Session Bean不负责记录使用者状态，Stateless Session Bean一旦实例化就被加进会话池中，各个用户都可以共用。如果它有自己的属性（变量），那么这些变量就会受到所有调用它的用户的影响。 

3. 从内存方面来看，Stateful Session Bean与Stateless Session Bean比较，Stateful Session Bean会消耗J2EE Server 较多的内存，然而Stateful Session Bean的优势却在于他可以维持使用者的状态。 

### Spring中的有状态(Stateful)和无状态(Stateless) 

1. 通过上面的分析，相信大家已经对有状态和无状态有了一定的理解。无状态的Bean适合用不变模式，技术就是单例模式，这样可以共享实例，提高性能。有状态的Bean，多线程环境下不安全，那么适合用Prototype原型模式。Prototype: 每次对bean的请求都会创建一个新的bean实例。 

2. 默认情况下，从Spring bean工厂所取得的实例为singleton（scope属性为singleton）,容器只存在一个共享的bean实例。 

3. 理解了两者的关系，那么scope选择的原则就很容易了：有状态的bean都使用prototype作用域，而对无状态的bean则应该使用singleton作用域。 

4. 如Service层、Dao层用默认singleton就行，虽然Service类也有dao这样的属性，但dao这些类都是没有状态信息的，也就是相当于不变(immutable)类，所以不影响。Struts2中的Action因为会有User、BizEntity这样的实例对象，是有状态信息的，在多线程环境下是不安全的，所以Struts2默认的实现是Prototype模式。在Spring中，Struts2的Action中，scope要配成prototype作用域。 

### Servlet、Struts中的有状态和无状态: 

1. Servlet体系结构是建立在Java多线程机制之上的，它的生命周期是由Web 容器负责的。一个Servlet类在Application中只有一个实例存在，也就是有多个线程在使用这个实例。这是单例模式的应用。无状态的单例是线程安全的，但我们如果在Servlet里用了实例变量，那么就变成有状态了，是非线程安全的。如下面的用法就是不安全的,因为user,out都是有状态信息的。
Out,Request,Response,Session,Config,Page,PageContext是线程安全的,Application在整个系统内被使用,所以不是线程安全的.

2. Struts1也是基于单例模式实现，也就是只有一个Action实例供多线程使用。默认的模式是前台页面数据通过actionForm传入，在action中的excute方法接收，这样action是无状态的，所以一般情况下Strunts1是线程安全的。如果Action中用了实例变量，那么就变成有状态了，同样是非线程安全的。像下面这样就是线程不安全的。 

3. Struts2默认的实现是Prototype模式。也就是每个请求都新生成一个Action实例，所以不存在线程安全问题。需要注意的是，如果由Spring管理action的生命周期， scope要配成prototype作用域。 

4. 如何解决Servlet和Struts1的线程安全问题，当我们能比较好的理解有状态和无状态的原理，自然很容易得出结论：不要使用有状态的bean,也就是不要用实例变量。如果用，就要用prototype模式。Struts1 user guide里有： Only Use Local Variables - The most important principle that aids in thread-safe coding is to use only local variables, not instance variables , in your Action class. 

### 总结： 
Stateless无状态用单例Singleton模式，Stateful有状态就用原型Prototype模式。 
Stateful 有状态是多线程编码的天敌，所以在开发中尽量用Stateless无状态，无状态是不变(immutable)模式的应用，有很多优点：不用管线程和同步的问题，如果值是不可变的，程序不用担心多个线程改变共享状态，所以可以避免线程竞争的bugs. 因为没有竞争，就不用用locks等机制，所以无状态的不变机制，也可以避免产生死锁现象。 
