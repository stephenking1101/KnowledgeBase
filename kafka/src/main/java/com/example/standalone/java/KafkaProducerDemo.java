package com.example.standalone.java;

import java.util.Properties;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.KafkaException;
import org.apache.kafka.common.errors.AuthorizationException;
import org.apache.kafka.common.errors.OutOfOrderSequenceException;
import org.apache.kafka.common.errors.ProducerFencedException;
import org.apache.kafka.common.serialization.StringSerializer;

public class KafkaProducerDemo {

	public static void main(String[] args) {
		/*Properties props = new Properties();
		props.put("bootstrap.servers", "localhost:9092");
		props.put("acks", "all");
		props.put("retries", 0);
		props.put("batch.size", 16384);
		props.put("linger.ms", 1);
		props.put("buffer.memory", 33554432);
		props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

		Producer<String, String> producer = new KafkaProducer<>(props);
		for (int i = 0; i < 10; i++)
		    producer.send(new ProducerRecord<String, String>("streams-plaintext-input", Integer.toString(i), Integer.toString(i)));

		producer.close();*/
		
		Properties propsTran = new Properties();
		propsTran.put("bootstrap.servers", "localhost:9092");
		propsTran.put("acks", "all");
		propsTran.put("retries", 1);
		propsTran.put("max.in.flight.requests.per.connection", 1);
		propsTran.put("batch.size", 16384);
		propsTran.put("linger.ms", 1);
		propsTran.put("buffer.memory", 33554432);
		propsTran.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		propsTran.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		propsTran.put("transactional.id", "my-transactional-id");
		Producer<String, String> producerTran = new KafkaProducer<>(propsTran, new StringSerializer(), new StringSerializer());
		
		producerTran.initTransactions();
		System.out.println("Init");
		
		try {
			 producerTran.beginTransaction();
		     for (int i = 0; i < 10; i++){
		    	 producerTran.send(new ProducerRecord<>("streams-plaintext-input", Integer.toString(i), Integer.toString(i)));
		    	 System.out.println("Sending " + i);
		     }
		    	 
		     producerTran.commitTransaction();
		} catch (ProducerFencedException | OutOfOrderSequenceException | AuthorizationException e) {
		     // We can't recover from these exceptions, so our only option is to close the producer and exit.
			 producerTran.close();
			 System.out.println("ProducerFencedException | OutOfOrderSequenceException | AuthorizationException");
		} catch (KafkaException e) {
		     // For all other exceptions, just abort the transaction and try again.
			 producerTran.abortTransaction();
			 System.out.println("KafkaException");
		}
		producerTran.close();
		System.out.println("Done");
	}

}
