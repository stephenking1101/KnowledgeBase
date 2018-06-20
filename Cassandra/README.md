
## Cassandra之存储结构

Cassandra的WHERE查询有很多限制，可以查看这篇https://www.datastax.com/dev/blog/a-deep-look-to-the-cql-where-clause了解WHERE的限制有哪些。但是如果你明白了Cassandra内部是如何存储一个表，你就明白哪些字段可以’WHERE’，哪些不可以，而不需要死记硬背，而且对设计data model时候有很大的帮助。

下面针对各种拥有不同形式primary key的table向大家介绍Cassandra内部的存储结构：

* Table without clustering column

CREATE TABLE demo1 {
  id text,
  field1 text,
  field2 text,
  PRIMARY KEY(id);

}

Cassandra 是key-value数据库，每一行记录，key为partition key, value也是一个map，而内层的map就是它的其他的字段组成。
例如，demo1的主键只有id组成， 那么id的值则为每一行记录的key，其它字段的字段名作为内层Map的Key,并且内层map的顺序以key的大小排序，它们的value作为对应的value。
假设demo1有下面两行记录：
| id | field1 | field2 |
|----|--------|--------|
| 01 | abc    | cde    |
| 02 | efg    | efg    |
那么在cassandra内部将会这样存储：
|    | field1 | field2 |
| 01 |--------|--------|
|    | abc    | cde    |

|    | field1 | field2 |
| 02 |--------|--------|
|    | efg    | efg    |

* Table with clustering column

CREATE TABLE demo2 {
  id text,
  cluster1 text,
  cluster2 text,
  field1 text,
  PRIMARY KEY(id，cluster1, cluster2);

}

demo2有两个clustering column, cassandra将会以它们的value作为内层Map的key，并且以这个key排序。例如demo2有3行记录:

| id | cluster1 | cluster2 | field1 |
|----|----------|----------|--------|
| 01 | a        | b        | test1  |
| 01 | a        | c        | test2  |
| 01 | b        | a        | test3  |
那么cassandra的存储结构将会是这样：
|    | a:b:field1 | a:c:field1 | b:a:field1 |
| 01 |------------|------------|------------|
|    | test1      | test2      | test3      |

* Table with composite partition key

CREATE TABLE demo3 {
  id text,
  bucket text,
  field1 text,
  PRIMARY KEY((id,bucket));

}

demo3中，id和bucket作为composite的partition key，假设有两行记录：

| id | bucket | field1 |
|----|--------|--------|
| 01 | 01     | test1  |
| 01 | 02     | test2  |

那么cassandra的存储表现为：

|       | field1 |
| 01:01 |--------|
|       | test1  |

|       | field1 |
| 01:02 |--------|
|       | test2  |

结论

Partition Key作为决定记录存放到哪个节点的值，因此CQL的WHERE条件里，必须先给出partition key的所有字段的完整的值，即‘=’条件，才能让cassandra找到那条记录。例如在demo3中，’SELECT *　FROM demo3 where id=’01’ and bucket =’02’’ 包含id和bucket的值的查询才合法，缺一不可。

Clustering column 由于是以它的值作为key排序的，因此可以做equal 和range查询。然而，从demo2看到，这个key是先以cluster1的值开头，因此，WHERE条件里，你可以只限定cluster1的值（等值查询，范围查询都可以）。若想根据cluster2查询，那么必须先给出cluster1的确定值（等值查询）。 例如， ‘SELECT * FROM demo2 WHERE id=’01’ AND cluster1=’a’ AND cluster2=’b’’ ，这样的查询合法；‘SELECT * FROM demo2 WHERE id=’01’ AND cluster2=’b’’ 这样的查询不合法。