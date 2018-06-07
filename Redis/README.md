# Redis

## Redis中的master-slave&sentinel 

### redis安装

解压完成后可以看到INSTALL和README.md文件，查看以获取更多有用信息。

在README文件中可以获取到软件的安装步骤。以下安装步骤基于此。

#step1 进入文件夹，执行编译命令

```
[root@iZ2ze8nco8ibrno0cscszfZ redis-3.2.8]# make
```

#step2 为了后面开发测试的方便，把启动脚本，配置文件，日志文件统一放到redis目录下

```
[root@iZ2ze8nco8ibrno0cscszfZ redis-3.2.8]# mkdir /usr/local/redis
[root@iZ2ze8nco8ibrno0cscszfZ redis-3.2.8]# mkdir /usr/local/redis/logs
[root@iZ2ze8nco8ibrno0cscszfZ redis-3.2.8]# mkdir /usr/local/redis/bin
[root@iZ2ze8nco8ibrno0cscszfZ redis-3.2.8]# mkdir /usr/local/redis/conf
[root@iZ2ze8nco8ibrno0cscszfZ redis-3.2.8]# cp redis.conf sentinel.conf /usr/local/redis/conf/
[root@iZ2ze8nco8ibrno0cscszfZ src]# cp redis-server redis-sentinel redis-cli /usr/local/redis/bin/
```

#step3 开启Redis服务,检测其可用性

```
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-server ../conf/redis.conf 
```

可以看到日志信息

6261:M 30 Mar 09:29:20.941 * The server is now ready to accept connections on port 6379

Redis server使用默认端口6379启动成功。

#step4 修改配置文件，使其以后台服务方式运行。

```
#what?局域网内本机IP。
#why?只接受外部程序发送到IP 172.17.84.39的数据。 
#resoult:更加安全，因为只有同一局域网内的机器能够访问。当然也可以把bind注释掉，以支持包括外网在内的所有IP。
bind 172.17.84.39
#修改默认端口，避免被恶意脚本扫描。
port 9999
loglevel debug
logfile /usr/local/redis/logs/redis.log.9999
#为服务设置安全密码
requirepass redispass
#以守护进程方式运行
daemonize yes
```

#step5 重新启动redis。

```
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-cli -h 172.17.84.39 -p 9999 -a redispass shutdown
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-server ../conf/redis.conf
```

查看日志../logs/redis.log.9999

```
6290:M 30 Mar 10:25:29.050 - Accepted 172.17.84.39:44928
6290:M 30 Mar 10:25:29.050 # User requested shutdown...
6290:M 30 Mar 10:25:29.050 * Saving the final RDB snapshot before exiting.
6290:M 30 Mar 10:25:29.053 * DB saved on disk
6290:M 30 Mar 10:25:29.053 * Removing the pid file.
6290:M 30 Mar 10:25:29.053 # Redis is now ready to exit, bye bye...
6290:M 30 Mar 09:46:01.661 * The server is now ready to accept connections on port 9999
```

可以看到，服务端接收到停止服务的命令后，并没有立即停止运行，而是做了一个Saving 的操作，因此，如果采用KILL -9 pid 的方式杀死redis进程，可能导致部分数据丢失！

#step6 在redis中保存第一个值

```
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-cli -h 172.17.84.39 -p 9999 -a redispass
172.17.84.39:9999> set test success
OK
172.17.84.39:9999> get test
"success"
```

### 开启主从复制（master-slave）

主从模式的两个重要目的，提升系统可靠性和读写分离提升部分性能。

这里通过修改端口的方式，再启动端口为9997和9998的服务作为备（从）机。

备机启动需要修改配置文件部分属性（在9999配置的基础上）。

```
port 9997
logfile /usr/local/redis/logs/redis.log.9997
#指定master ip port
slaveof 172.17.84.39 9999
#认证master时需要的密码。必须和master配置的requirepass 保持一致
masterauth redispass
protected-mode no
```

从机9998配置同理

```
port 9998
logfile /usr/local/redis/logs/redis.log.9998
slaveof 172.17.84.39 9999
masterauth redispass
protected-mode no
```

开启从机服务

```
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-server ../conf/redis.conf.9997
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-server ../conf/redis.conf.9998
```

查看slave 9978日志（省略部分信息），可以看出，slave在启动时成功连接master，并接收到了104字节的同步数据。

```
6472:S 30 Mar 11:18:17.206 * Connecting to MASTER 172.17.84.39:9999
6472:S 30 Mar 11:18:17.206 * MASTER <-> SLAVE sync started
6472:S 30 Mar 11:18:17.223 * MASTER <-> SLAVE sync: receiving 104 bytes from master
6472:S 30 Mar 11:18:17.223 * MASTER <-> SLAVE sync: Finished with success
```

验证：尝试在从机中获取前面存入的key值

```
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-cli -h 172.17.84.39 -p 9997 -a redispass
172.17.84.39:9997> get test
"success"
9998
[root@iZ2ze8nco8ibrno0cscszfZ bin]# ./redis-cli -h 172.17.84.39 -p 9998 -a redispass
172.17.84.39:9998> get test
"success"
```
### sentinel模式故障自动迁移

Master-slave主从复制避免了数据丢失带来的灾难性后果。

但是单点故障仍然存在，在运行期间master宕机需要停机手动切换。

Sentinel很好的解决了这个问题，当Master-slave模式中的Master宕机后，能够自主切换，选择另一个可靠的redis-server充当master角色，使系统仍正常运行。

一般来说sentinel server需要大于等于3个。

这里通过修改端口的方式开启3个sentinel server。修改配置文件sentinel.conf部分属性

```
#服务运行端口号
port 26379
#mymaster为指定的master服务器起一个别名
#master IP和端口号
#2的含义：当开启的sentinel server认为当前master主观下线的（+sdown）数量达到2时，则sentinel server认为当前master客观下线（+odown）系统开始自动迁移。2的计算（建议）：sentinel server数量的大多数，至少为count（sentinel server）/2 向上取整。2>3/2（主观下线与客观下线？）
sentinel monitor mymaster 172.17.84.39 9999 2
#master别名和认证密码。这就提醒了用户，在master-slave系统中，各服务的认证密码应该保持一致。
sentinel auth-pass mymaster redispass
#以守护进程方式运行
daemonize yes
logfile /usr/local/redis/logs/sentinel.log.26379
protected-mode no
sentinel down-after-milliseconds mymaster 6000
sentinel failover-timeout mymaster 18000
```

（多开服务只需要在以上配置基础上修改端口号，其它保持不变 port 26378/port 26377）

开启Sentinel服务

```
./redis-sentinel ../conf/sentinel.conf.26377
./redis-sentinel ../conf/sentinel.conf.26378
./redis-sentinel ../conf/sentinel.conf.26379
```

查看日志：

```
6860:X 30 Mar 15:20:27.383 # Sentinel ID is 14a6a8d5d770c8e9d0e880a8e426454e1a652f94
6860:X 30 Mar 15:20:27.383 # +monitor master mymaster 172.17.84.39 9999 quorum 2
6860:X 30 Mar 15:20:28.776 * +sentinel sentinel b50ce4d448ad1091df76623e625dd7f90b374fd3 172.17.84.39 26379 @ mymaster 172.17.84.39 9999
6860:X 30 Mar 15:20:31.311 * +sentinel sentinel d99a3d163a4a887a240793f2fb5a66c3b14e311a 172.17.84.39 26378 @ mymaster 172.17.84.39 9999
```

此时所有服务的运行情况：

```
[root@iZ2ze8nco8ibrno0cscszfZ logs]# ps -aux|grep redis
root      6372  0.0  0.2 138964  2532 ?        Ssl  10:26   0:05 ./redis-server 172.17.84.39:9999
root      6472  0.0  0.2 136916  2420 ?        Ssl  11:18   0:04 ./redis-server 172.17.84.39:9997
root      6477  0.0  0.2 136916  2408 ?        Ssl  11:18   0:04 ./redis-server 172.17.84.39:9998
root      6725  0.0  0.2 136916  2076 ?        Ssl  14:40   0:00 ./redis-sentinel *:26379 [sentinel]
root      6737  0.0  0.2 136916  2304 ?        Ssl  14:44   0:00 ./redis-sentinel *:26378 [sentinel]
root      6760  0.0  0.2 136916  2300 ?        Ssl  14:45   0:00 ./redis-sentinel *:26377 [sentinel]
```

测试：杀死master进程，模拟master宕机

```
Kill -9 6372
```

查看sentinel日志（省略部分信息），可以知道故障迁移的大致过程：

```
+sdown master mymaster：主观认为master下线
+odown master mymaster 172.17.84.39 9999 #quorum 2/2：认为主观下线的sentinel数量达到设定的阈值2，可以开始转移了。
+new-epoch 1：新纪元（新版本？因为会产生新的master？蛤？O(∩_∩)O~）
+try-failover master mymaster 172.17.84.39 9999：开始转移

7118:X 30 Mar 15:54:43.994 # +vote-for-leader 2c536c5f9f97071cfdfffc9ad3d426dbbf505b02 1
7118:X 30 Mar 15:54:44.004 # 69485d9636fad6003cb0dbbdbaa36d59749ee40b voted for 2c536c5f9f97071cfdfffc9ad3d426dbbf505b02 1
7118:X 30 Mar 15:54:44.004 # a027e345d3c31eebe931f1d8e9616fd34d3519b5 voted for 2c536c5f9f97071cfdfffc9ad3d426dbbf505b02 1
通过投票在运行的sentinel 服务中选举一个leader，leader的作用是，向被选举的新的master输送配置信息。

7118:X 30 Mar 15:54:44.133 # +selected-slave slave 172.17.84.39:9997 172.17.84.39 9997 @ mymaster 172.17.84.39 9999 ：Sentinel 顺利找到适合进行升级的从服务器。
7118:X 30 Mar 15:54:46.129 # +failover-end master mymaster 172.17.84.39 9999
7118:X 30 Mar 15:54:46.129 # +switch-master mymaster 172.17.84.39 9999 172.17.84.39 9997 ：配置完成，主服务器变更。
```
 

## java版客户端

官方推荐的java版客户端是jedis，非常强大和稳定，支持事务、管道及有jedis自身实现。我们对redis数据的操作，都可以通过jedis来完成。

(1)普通同步方式

      这是一种最简单和最基础的调用方式，对于简单的数据存取需求，我们可以通过这种方式调用。

public void jedisNormal() {
    Jedis jedis = new Jedis("localhost");
    long start = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        String result = jedis.set("n" + i, "n" + i);
    }
    long end = System.currentTimeMillis();
    System.out.println("Simple SET: " + ((end - start) / 1000.0) + " seconds");
    jedis.disconnect();
}

//每次set之后都可以返回结果，标记是否成功。


(2)事务方式(Transactions)

      所谓事务，即一个连续操作，是否执行是一个事务，要么完成，要么失败，没有中间状态。

      而redis的事务很简单，他主要目的是保障，一个client发起的事务中的命令可以连续的执行，而中间不会插入其他client的命令，也就是事务的连贯性。

public void jedisTrans() {
    Jedis jedis = new Jedis("localhost");
    long start = System.currentTimeMillis();
    Transaction tx = jedis.multi();
    for (int i = 0; i < 100000; i++) {
        tx.set("t" + i, "t" + i);
    }
    List<Object> results = tx.exec();
    long end = System.currentTimeMillis();
    System.out.println("Transaction SET: " + ((end - start) / 1000.0) + " seconds");
    jedis.disconnect();
}

//我们调用jedis.watch(…)方法来监控key，如果调用后key值发生变化，则整个事务会执行失败。另外，事务中某个操作失败，并不会回滚其他操作。这一点需要注意。还有，我们可以使用discard()方法来取消事务。

(3)管道(Pipelining)

      管道是一种两个进程之间单向通信的机制。

      那再redis中，为何要使用管道呢？有时候，我们需要采用异步的方式，一次发送多个指令，并且，不同步等待其返回结果。这样可以取得非常好的执行效率。

public void jedisPipelined() {
    Jedis jedis = new Jedis("localhost");
    Pipeline pipeline = jedis.pipelined();
    long start = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        pipeline.set("p" + i, "p" + i);
    }
    List<Object> results = pipeline.syncAndReturnAll();
    long end = System.currentTimeMillis();
    System.out.println("Pipelined SET: " + ((end - start) / 1000.0) + " seconds");
    jedis.disconnect();
}


(4)管道中调用事务

      对于，事务以及管道，这两个概念我们都清楚了。

      在某种需求下，我们需要异步执行命令，但是，又希望多个命令是有连续的，所以，我们就采用管道加事务的调用方式。jedis是支持在管道中调用事务的。

public void jedisCombPipelineTrans() {
    jedis = new Jedis("localhost");
    long start = System.currentTimeMillis();
    Pipeline pipeline = jedis.pipelined();
    pipeline.multi();
    for (int i = 0; i < 100000; i++) {
        pipeline.set("" + i, "" + i);
    }
    pipeline.exec();
    List<Object> results = pipeline.syncAndReturnAll();
    long end = System.currentTimeMillis();
    System.out.println("Pipelined transaction: " + ((end - start) / 1000.0) + " seconds");
    jedis.disconnect();
}
//效率上可能会有所欠缺

(5)分布式直连同步调用

      这个是分布式直接连接，并且是同步调用，每步执行都返回执行结果。类似地，还有异步管道调用。

      其实就是分片。

public void jedisShardNormal() {
    List<JedisShardInfo> shards = Arrays.asList(
                                      new JedisShardInfo("localhost", 6379),
                                      new JedisShardInfo("localhost", 6380));
    ShardedJedis sharding = new ShardedJedis(shards);
    long start = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        String result = sharding.set("sn" + i, "n" + i);
    }
    long end = System.currentTimeMillis();
    System.out.println("Simple@Sharing SET: " + ((end - start) / 1000.0) + " seconds");
    sharding.disconnect();
}

(6)分布式直连异步调用

public void jedisShardpipelined() {
    List<JedisShardInfo> shards = Arrays.asList(
                                      new JedisShardInfo("localhost", 6379),
                                      new JedisShardInfo("localhost", 6380));
    ShardedJedis sharding = new ShardedJedis(shards);
    ShardedJedisPipeline pipeline = sharding.pipelined();
    long start = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        pipeline.set("sp" + i, "p" + i);
    }
    List<Object> results = pipeline.syncAndReturnAll();
    long end = System.currentTimeMillis();
    System.out.println("Pipelined@Sharing SET: " + ((end - start) / 1000.0) + " seconds");
    sharding.disconnect();
}


(7)分布式连接池同步调用

      如果，你的分布式调用代码是运行在线程中，那么上面两个直连调用方式就不合适了，因为直连方式是非线程安全的，这个时候，你就必须选择连接池调用。

      连接池的调用方式，适合大规模的redis集群，并且多客户端的操作。

public void jedisShardSimplePool() {
    List<JedisShardInfo> shards = Arrays.asList(
                                      new JedisShardInfo("localhost", 6379),
                                      new JedisShardInfo("localhost", 6380));
    ShardedJedisPool pool = new ShardedJedisPool(new JedisPoolConfig(), shards);
    ShardedJedis one = pool.getResource();
    long start = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        String result = one.set("spn" + i, "n" + i);
    }
    long end = System.currentTimeMillis();
    pool.returnResource(one);
    System.out.println("Simple@Pool SET: " + ((end - start) / 1000.0) + " seconds");
    pool.destroy();
}


(8)分布式连接池异步调用

public void jedisShardPipelinedPool() {
    List<JedisShardInfo> shards = Arrays.asList(
                                      new JedisShardInfo("localhost", 6379),
                                      new JedisShardInfo("localhost", 6380));
    ShardedJedisPool pool = new ShardedJedisPool(new JedisPoolConfig(), shards);
    ShardedJedis one = pool.getResource();
    ShardedJedisPipeline pipeline = one.pipelined();
    long start = System.currentTimeMillis();
    for (int i = 0; i < 100000; i++) {
        pipeline.set("sppn" + i, "n" + i);
    }
    List<Object> results = pipeline.syncAndReturnAll();
    long end = System.currentTimeMillis();
    pool.returnResource(one);
    System.out.println("Pipelined@Pool SET: " + ((end - start) / 1000.0) + " seconds");
    pool.destroy();
}


(9)需要注意的地方

      事务和管道都是异步模式。在事务和管道中不能同步查询结果。比如下面两个调用，都是不允许的：

Transaction tx = jedis.multi();
for (int i = 0; i < 100000; i++) {
    tx.set("t" + i, "t" + i);
}

System.out.println(tx.get("t1000").get()); //不允许
List<Object> results = tx.exec();

…

…

Pipeline pipeline = jedis.pipelined();
long start = System.currentTimeMillis();
for (int i = 0; i < 100000; i++) {
    pipeline.set("p" + i, "p" + i);
}

System.out.println(pipeline.get("p1000").get()); //不允许
List<Object> results = pipeline.syncAndReturnAll();
      事务和管道都是异步的，个人感觉，在管道中再进行事务调用，没有必要，不如直接进行事务模式。

      分布式中，连接池的性能比直连的性能略好(见后续测试部分)。

      分布式调用中不支持事务。

      因为事务是在服务器端实现，而在分布式中，每批次的调用对象都可能访问不同的机器，所以，没法进行事务。

(10)总结

      分布式中，连接池方式调用不但线程安全外，根据上面的测试数据，也可以看出连接池比直连的效率更好。

经测试分布式中用到的机器越多，调用会越慢。

(11)完整的测试代码

package com.blogchong.example.nosqlclient;
import java.util.Arrays;
import java.util.List;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisShardInfo;
import redis.clients.jedis.Pipeline;
import redis.clients.jedis.ShardedJedis;
import redis.clients.jedis.ShardedJedisPipeline;
import redis.clients.jedis.ShardedJedisPool;
import redis.clients.jedis.Transaction;
import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

/**
* @Description: jedis的8种调用方式
*/

@FixMethodOrder(MethodSorters.NAME_ASCENDING)

public class TestJedis {
    private static Jedis jedis;
    private static ShardedJedis sharding;
    private static ShardedJedisPool pool;

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        List<JedisShardInfo> shards = Arrays.asList(
               new JedisShardInfo("localhost", 6379),
               new JedisShardInfo("localhost", 6379)); //使用相同的ip:port,仅作测试
         jedis = new Jedis("localhost");
        sharding = new ShardedJedis(shards);
        pool = new ShardedJedisPool(new JedisPoolConfig(), shards);
    }

    @AfterClass
    public static void tearDownAfterClass() throws Exception {
        jedis.disconnect();
        sharding.disconnect();
        pool.destroy();
    }

    @Test
    public void jedisNormal() {
        long start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            String result = jedis.set("n" + i, "n" + i);
        }
        long end = System.currentTimeMillis();
        System.out.println("Simple SET: " + ((end - start) / 1000.0) + " seconds");
    }

    @Test
    public void jedisTrans() {
        long start = System.currentTimeMillis();
        Transaction tx = jedis.multi();
        for (int i = 0; i < 100000; i++) {
            tx.set("t" + i, "t" + i);
        }
        //System.out.println(tx.get("t1000").get());
        List<Object> results = tx.exec();
        long end = System.currentTimeMillis();
        System.out.println("Transaction SET: " + ((end - start) / 1000.0) + " seconds");
    }

    @Test
    public void jedisPipelined() {
        Pipeline pipeline = jedis.pipelined();
        long start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            pipeline.set("p" + i, "p" + i);
        }
        //System.out.println(pipeline.get("p1000").get());
        List<Object> results = pipeline.syncAndReturnAll();
        long end = System.currentTimeMillis();
        System.out.println("Pipelined SET: " + ((end - start) / 1000.0) + " seconds");
    }

    @Test
    public void jedisCombPipelineTrans() {
        long start = System.currentTimeMillis();
        Pipeline pipeline = jedis.pipelined();
        pipeline.multi();
        for (int i = 0; i < 100000; i++) {
            pipeline.set("" + i, "" + i);
        }
        pipeline.exec();
        List<Object> results = pipeline.syncAndReturnAll();
        long end = System.currentTimeMillis();
        System.out.println("Pipelined transaction: " + ((end - start) / 1000.0) + " seconds");
    }

    @Test
    public void jedisShardNormal() {
        long start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            String result = sharding.set("sn" + i, "n" + i);
        }
        long end = System.currentTimeMillis();
        System.out.println("Simple@Sharing SET: " + ((end - start) / 1000.0) + " seconds");
    }

    @Test
    public void jedisShardpipelined() {
        ShardedJedisPipeline pipeline = sharding.pipelined();
        long start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            pipeline.set("sp" + i, "p" + i);
        }
        List<Object> results = pipeline.syncAndReturnAll();
        long end = System.currentTimeMillis();
        System.out.println("Pipelined@Sharing SET: " + ((end - start) / 1000.0) + " seconds");
    }

    @Test
    public void jedisShardSimplePool() {
        ShardedJedis one = pool.getResource();
        long start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            String result = one.set("spn" + i, "n" + i);
        }
        long end = System.currentTimeMillis();
        pool.returnResource(one);
        System.out.println("Simple@Pool SET: " + ((end - start) / 1000.0) + " seconds");
    }

    @Test
    public void jedisShardPipelinedPool() {
        ShardedJedis one = pool.getResource();
        ShardedJedisPipeline pipeline = one.pipelined();
        long start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            pipeline.set("sppn" + i, "n" + i);
        }
        List<Object> results = pipeline.syncAndReturnAll();
        long end = System.currentTimeMillis();
        pool.returnResource(one);
        System.out.println("Pipelined@Pool SET: " + ((end - start) / 1000.0) + " seconds");
    }
}