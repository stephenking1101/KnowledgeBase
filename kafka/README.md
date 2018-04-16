# Kafka

## how-to-delete-a-topic-in-apache-kafka

Source: https://stackoverflow.com/questions/33537950/how-to-delete-a-topic-in-apache-kafka

1, make sure Kafka is configured as delete.topic.enable=true on all brokers;

# ansible -i ece_8032 all -a 'grep delete.topic /opt/kafka/config/server.properties'
node-2 | SUCCESS | rc=0 >>
delete.topic.enable=true
node-1 | SUCCESS | rc=0 >>
delete.topic.enable=true
node-3 | SUCCESS | rc=0 >>
delete.topic.enable=true

2, stop all brokers;

# ansible -i ece_8032 all -a 'systemctl stop kafka'
node-3 | SUCCESS | rc=0 >>
node-2 | SUCCESS | rc=0 >>
node-1 | SUCCESS | rc=0 >>

3, delete all files of the topic to be deleted;

# ansible -i ece_8032 all -a 'rm -rf /data/kafka/logs/service-log-*' -m shell
[WARNING]: Consider using file module with state=absent rather than running rm
node-3 | SUCCESS | rc=0 >>
node-1 | SUCCESS | rc=0 >>
node-2 | SUCCESS | rc=0 >>

4, connect zookeeper shell, and delete topic (note: this step is not from Ansible control machine, but from any zookeeper node);

# /opt/kafka/bin/zookeeper-shell.sh 192.168.100.1:2181
ls /brokers/topics
[service-name-log, service-stream-consumer-ktable-ipAddressInfo-store-changelog, service-stream-consumer-ktable-deviceInfo-store-changelog, __consumer_offsets]
rmr /brokers/topics/service-name-log
ls /brokers/topics
[service-stream-consumer-ktable-ipAddressInfo-store-changelog, service-stream-consumer-ktable-deviceInfo-store-changelog, __consumer_offsets]
quit
Quitting...

5, restart Kafka now;

# ansible -i ece_8032 all -a 'systemctl start kafka'
node-3 | SUCCESS | rc=0 >>
node-1 | SUCCESS | rc=0 >>
node-2 | SUCCESS | rc=0 >>

6, confirm that topic is indeed deleted (note: this step is not from Ansible control machine, but from any zookeeper node);

# /opt/kafka/bin/kafka-topics.sh --list --zookeeper 192.168.100.1:2181
__consumer_offsets
service-stream-consumer-ktable-deviceInfo-store-changelog
service-stream-consumer-ktable-ipAddressInfo-store-changelog

## For topics related to kafka stream 

Mandatory steps to follow:

1, reset kafka stream’s topic by application id. Note: this step is not from Ansible control machine, but from any zookeeper node.

/opt/kafka/bin/kafka-streams-application-reset.sh --application-id service-stream-consumer --bootstrap-servers 10.175.187.42:9092

2, remove rocksdb directories on each and every service nodes (confirm the directory by this CM item: iam.rba.user.activity.streams.properties -> state.dir):

rm -rf /var/lib/rba/rocksdb

3, restart each and every service:

systemctl restart service_name

## Kafka server.properties, offsets.topic.replication.factor 如果节点数 < 那个offset配置的replicator数，就会一直报错，无限错，错到永远

[2018-04-11 16:01:00,821] ERROR [KafkaApi-0] Number of alive brokers '1' does not meet the required replication factor '2' for the offsets topic (configured via 'offsets.topic.replication.factor'). This error can be ignored if the cluster is starting up and not all brokers are up yet. (kafka.server.KafkaApis) 

http://ronnieroller.com/kafka/cheat-sheet

## Consumers
Difference between old and new consumers.
The new consumer was introduced in version 0.9.0.0, the main change introduced is for previous versions consumer groups were managed by Zookeeper, but for 9+ versions they are managed by Kafka broker. If you use kafka-console-consumer.sh for example - it uses an old consumer API. But if you created a new consumer or stream using Java API it will be a new one. Knowing this defference will help you understand which command to use from examples below.

## List consumer groups

$ ./kafka-consumer-groups.sh  -zookeeper localhost:2181 -list        # Old consumers
$ ./kafka-consumer-groups.sh  -bootstrap-server localhost:9092 -list # New consumers

## List only old consumer groups

$ ./zookeeper-shell.sh localhost:2181
Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is disabled

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
ls /consumers
[console-consumer-59900, console-consumer-857]

## Describe consumer group
$ ./kafka-consumer-groups.sh -bootstrap-server localhost:9092 -describe -group my-stream-processing-application
GROUP   TOPIC    PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             OWNER
my-appl  lttng                  0                  34996877                  34996877            0                 owner
[root@lttng02 bin]# ./kafka-consumer-groups.sh -zookeeper localhost:2181 -describe -group console-consumer-59900
GROUP                          TOPIC                          PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             OWNER
console-consumer-59900         test_topic                     0          169542          199264          29722           none

## Command to get kafka broker list from zookeeper

./zookeeper-shell.sh localhost:2181 <<< "ls /brokers/ids"

$  ls /brokers/ids  # Gives the list of active brokers
$  ls /brokers/topics #Gives the list of topics
$  get /brokers/ids/0 #Gives more detailed information of the broker id '0'

## Kafka Cluster

Client与Servers之间的通讯是通过一种语言无关的TCP协议实现的，不仅包括Java，还包括很多其他语言。



## Topics and Logs

对于每一个topic，Kafka集群都为之维护了一个的partitioned log.

不同的partition可以分布在不同的server上，这样整个log就可以不受某个server容量的限制。但是一个partition是受限于它所在的server的容量的限制的。

一个partition内的消息之间是有序的，且每一条消息都被赋予了一个在该partition内唯一的id，称为 offset 。这里的一个partition也可以被称为一个commit log。

每一条消息都会被Kafka集群保留一段时间，不论这些消息是否已经被消费了。

实际上，consumer持有的唯一元数据是它在log中的位置，称之为 offset ，这个offset完全由consumer控制。正常情况下，随着consumer不断地读取消息，offset会随之向前推进，但是consumer也可以决定将offset重置为某一个，以便于重新处理消息。



## Distribution

每一个partition会在数个server上被复制（servers的数量可配置），以此实现容错性。在这几个server中，其中一个server的角色是 leader，其他servers的角色是 follower。leader负责处理该partition的全部读写请求，而followers则会复制leader。如果leader崩溃了，则某一个follower会自动地成为新的leader。

如果一个topic的副本因子为N，则最多可以容忍N-1个server宕机而保证不丢失数据。

一个server上面会有若干个partitions，该server会作为其中某些partitions的leader以及其余partitions的follower。



## Producer

Producer将消息发布到它选择的topic中去，它负责决定将哪个消息送到topic的哪个partition中。这可以以round robin方式进行，也可以以其他方式进行（例如按照消息中的key决定将该消息发送到哪一个partition）。



## Consumer

存在若干个consumer group，每个consumer都会由一个consumer group name标签。

对于某个topic而言，会有若干个consumer group订阅该topic。当一条消息被发送给该topic后，它会被推送给每个consumer groups的其中一个consumer实例。

当消费行为发生时，一个topic会限制任何一个partition只能被subscribing consumer group中的一个consumer处理，这样就能保证这个consumer是该partition的唯一消费者，也就能保证一个partition中的消息是按照原来生成的顺序被读取的。由于一般partition的数量很多，这也能保证负载被均摊到很多消费者的身上。值得注意的是，consumer group中的消费者数量不能大于该consumer group订阅的topic的partition的数量。

Kafka只保证任何一个partition内的消息是有序的，不保证topic中的消息是有序的。