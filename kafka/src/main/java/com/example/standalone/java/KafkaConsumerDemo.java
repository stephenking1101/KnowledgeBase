package com.example.standalone.java;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.consumer.OffsetAndMetadata;
import org.apache.kafka.common.TopicPartition;

public class KafkaConsumerDemo {

	public static void main(String[] args) {
		//Automatic Offset Committing
		/*Properties props = new Properties();
	    props.put("bootstrap.servers", "localhost:9092");
	    props.put("group.id", "test");
	    props.put("enable.auto.commit", "true");
	    props.put("auto.commit.interval.ms", "1000");
	    props.put("isolation.level", "read_committed");
	    props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
	    props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
	    KafkaConsumer<String, String> consumer = new KafkaConsumer<>(props);
	    consumer.subscribe(Arrays.asList("streams-plaintext-input", "streams-linesplit-output"));
	    while (true) {
	         ConsumerRecords<String, String> records = consumer.poll(100);
	         for (ConsumerRecord<String, String> record : records)
	             System.out.printf("offset = %d, key = %s, value = %s%n", record.offset(), record.key(), record.value());
	    }*/
	    
		KafkaConsumerDemo.consume();
	}
	
	public static void consume(){
		//Manual Offset Control
	    Properties propsManual = new Properties();
	    propsManual.put("bootstrap.servers", "localhost:9092");
	    propsManual.put("group.id", "test");
	    propsManual.put("enable.auto.commit", "false");
	    propsManual.put("isolation.level", "read_committed");
	    propsManual.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
	    propsManual.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
	    //propsManual.put("request.timeout.ms", 10001);
	    KafkaConsumer<String, String> consumerManual = new KafkaConsumer<>(propsManual);
	    consumerManual.subscribe(Arrays.asList("streams-plaintext-input", "streams-linesplit-output"));
	    try {
	         //while(true) {
	             ConsumerRecords<String, String> records = consumerManual.poll(500);
	             for (TopicPartition partition : records.partitions()) {
	                 List<ConsumerRecord<String, String>> partitionRecords = records.records(partition);
	                 for (ConsumerRecord<String, String> record : partitionRecords) {
	                     System.out.println(record.offset() + ": " + record.value());
	                 }
	                 long lastOffset = partitionRecords.get(partitionRecords.size() - 1).offset();
	                 consumerManual.commitSync(Collections.singletonMap(partition, new OffsetAndMetadata(lastOffset + 1)));
	             }
	        //}
	     } finally {
	    	 consumerManual.close();
	     }
	}
	
	public void healthcheck(){
		ExecutorService service = Executors.newSingleThreadExecutor();
        Future<Object> result = service.submit(new Callable<Object>() {
            @Override
            public Object call() throws Exception {
            	KafkaConsumerDemo.consume();
                return "OK";
            }
        });

        try {
            result.get(10, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (TimeoutException e) {
			e.printStackTrace();
			result.cancel(true);
		} finally {
        	service.shutdown();
        }
	}
}
