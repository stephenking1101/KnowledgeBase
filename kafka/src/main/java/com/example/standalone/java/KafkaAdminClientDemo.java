package com.example.standalone.java;

import java.util.Properties;
import java.util.Set;
import java.util.concurrent.ExecutionException;

import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.KafkaAdminClient;
import org.apache.kafka.clients.admin.ListTopicsOptions;
import org.apache.kafka.clients.admin.ListTopicsResult;

public class KafkaAdminClientDemo {

	public static void main(String[] args){
		Properties properties = new Properties();
		properties.put("bootstrap.servers", "localhost:9092");
		properties.put("connections.max.idle.ms", 10000);
		properties.put("request.timeout.ms", 50000);
		try (AdminClient client = KafkaAdminClient.create(properties))
		{
		    ListTopicsResult topics = client.listTopics();
		    Set<String> names = topics.names().get();
		    if (names.isEmpty())
		    {
		        // case: if no topic found.
		    	System.out.print("no topic found");
		    }
		    return;
		}
		catch (InterruptedException | ExecutionException e)
		{
			System.out.print("not started");
			e.printStackTrace();
		    // Kafka is not available
		}
		
		/*try (AdminClient client = AdminClient.create(properties)) {
            client.listTopics(new ListTopicsOptions().timeoutMs(5000)).listings().get();
        } catch (ExecutionException ex) {
        	System.out.println("Kafka is not available, timed out after {} ms" + 5000);
            return;
        } catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
	}
}
