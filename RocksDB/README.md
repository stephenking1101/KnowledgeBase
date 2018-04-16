# RockDB 简单介绍

## rocksDB 是一个可嵌入的，持久性的 key-value存储。

以下介绍来自rocksDB 中文官网 

https://rocksdb.org.cn/

它有以下四个特点

1 高性能：RocksDB使用一套日志结构的数据库引擎，为了更好的性能，这套引擎是用C++编写的。 Key和value是任意大小的字节流。

2 为快速存储而优化：RocksDB为快速而又低延迟的存储设备（例如闪存或者高速硬盘）而特殊优化处理。 RocksDB将最大限度的发挥闪存和RAM的高度率读写性能。

3 可适配性 ：RocksDB适合于多种不同工作量类型。 从像MyRocks这样的数据存储引擎， 到应用数据缓存, 甚至是一些嵌入式工作量，RocksDB都可以从容面对这些不同的数据工作量需求。

4 基础和高级的数据库操作  RocksDB提供了一些基础的操作，例如打开和关闭数据库。 对于合并和压缩过滤等高级操作，也提供了读写支持。

​​​​​​## RockDB 安装与使用

rocksDB 安装有多种方式。由于官方没有提供对应平台的二进制库，所以需要自己编译使用。

rocksDB 的安装很简单，但是需要转变一下对于rocksDB 的看法。它不是一个重量级别的数据库，是一个嵌入式的key-value 存储。这意味着你只要在你的Maven项目中添加 rocksDB的依赖，就可以在开发环境中自我尝试了。如果你没有理解这点，你就可能会走入下面这两种不推荐的安装方式。

* 方式 1   去查看rocksDB 的官网 发现要写 一个C++ 程序（不推荐）

#include <assert>
#include "rocksdb/db.h"

rocksdb::DB* db;
rocksdb::Options options;
options.create_if_missing = true;
rocksdb::Status status =
  rocksdb::DB::Open(options, "/tmp/testdb", &db);
assert(status.ok());
创建一个数据库？？？？ 怎么和之前用的mysql 或者mongo 不一样，为啥没有一个start.sh 或者start.bat 之类的脚本。难道要我写。写完了编译发现还不知道怎么和rocksDB 库进行关联，怎么办，我C++都忘完了。

* 方式二  使用pyrocksDB （不推荐）

http://pyrocksdb.readthedocs.io/en/latest/installation.html

详细的安装文档见pyrocksDB 的官网安装文档。

以上两种方式对于熟悉C++ 或者python 的开发者来说都比较友好，但对于java 开发者来说不是太友好。

接下来就介绍第三种方式。

* 方式三 使用maven （推荐）

新建maven 项目，修改pom.xml 依赖里面添加

<dependency>
    <groupId>org.rocksdb</groupId>
    <artifactId>rocksdbjni</artifactId>
    <version>5.8.6</version>
</dependency>
可以选择你喜欢的版本。

然后更高maven 的语言级别，我这里全局设置为了1.8

<profiles>
    <profile>
        <id>jdk18</id>
        <activation>
            <activeByDefault>true</activeByDefault>
            <jdk>1.8</jdk>
        </activation>
        <properties>
            <maven.compiler.source>1.8</maven.compiler.source>
            <maven.compiler.target>1.8</maven.compiler.target>
            <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
        </properties>
    </profile>
</profiles>
到这里，环境就装好了，是不是又回到了熟悉的java 世界。

## rocksdb的文件类型
主要有以下几种类型sst文件，CURRENT文件，manifest文件，log文件，LOG文件和LOCK文件

sst文件存储的是落地的数据

* MANIFEST/CURRENT 文件

MANIFEST 记录着 RocksDB 一些状态变化的信息，用来在重启的时候能让 RocksDB 还原到最近的一致状态上面去。 MANIFEST 包括一系列的 manifest 文件，以及标识最后最新的一个 manifest 文件的 CURRENT 文件。 Manifest 文件名的格式类似 MANIFEST-<seq no>，sequence number 会一直递增，最新的 manifest 文件一定有最大的 sequence number。

我们可以认为 MANIFEST 是一个 transaction log，只要 RocksDB 的状态变化，就会记录一下。当一个 manifest 文件超过了配置的最大值的时候，一个包含当前 RocksDB 状态信息的新的 manifest 文件就会创建，CURRENT 文件会记录最新的 manifest 文件信息。当所有的更改都 sync 到文件系统之后，之前老的 manifest 文件就会被清除。

* log 文件

RocksDB采用的write ahead log(WAL)方式来写日志，即预写日志，每次要对数据操作之前，先写日志保存起来，然后在进行相应操作。这样当发生某些意外而导致还未写到磁盘中的数据丢失时，我们可以采用log文件来进行恢复。通过读取磁盘中的内容和已知的WAL日志，就可以恢复到最新的状态。而memtable和未写入磁盘的immemtable则从log文件中读出来，重做memtable和immemtable到sstable中即可。

* LOG文件是一些日志信息,是供调试用的

* LOCK是打开db锁，只允许同时有一个进程打开db

http://blog.csdn.net/flyqwang/article/details/50096377

http://blog.csdn.net/zdy0_2004/article/details/64905515