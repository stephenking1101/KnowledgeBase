package example.rocksdb.javarocksdb;

import org.apache.kafka.common.serialization.StringDeserializer;
import org.rocksdb.Options;
import org.rocksdb.RocksDB;
import org.rocksdb.RocksDBException;
import org.rocksdb.RocksIterator;

import example.rocksdb.javarocksdb.entity.HelloWorld;

public class App {
	public static void main(final String[] args) {
		// a static method that loads the RocksDB C++ library.
		RocksDB.loadLibrary();

		// the Options class contains a set of configurable DB options
		// that determines the behaviour of the database.
		try (final Options options = new Options().setCreateIfMissing(false)) {
		    
		    // a factory method that returns a RocksDB instance
			//A rocksdb database has a name which corresponds to a file system directory. All of the contents of database are stored in this directory. 
		    try (final RocksDB db = RocksDB.open(options, "C:\\Temp\\stream-data\\consumer\\0_1\\ktable-example-store\\ktable-example-store.1517369220000")) {
		    	try (final RocksIterator iterator = db.newIterator()) {
		    		for (iterator.seekToFirst(); iterator.isValid(); iterator.next()) {
		                iterator.status();
		                System.out.println("Key: " + new StringDeserializer().deserialize("", iterator.key()));
		                System.out.println("Value: " + new FstDeserializer<HelloWorld>().deserialize("", iterator.value()));
		            }
		    	}
		    }
		    
		    
		    try (final RocksDB db = RocksDB.open(options, "C:\\Temp\\example")) {	
		    	db.put("hello".getBytes(), "world".getBytes());

		        final byte[] value = db.get("hello".getBytes());
		        assert ("world".equals(new String(value)));
		        System.out.println(new String(value));

		        db.put("hello".getBytes(), "hello".getBytes());

		        assert ("hello".equals(new String(db.get("hello".getBytes()))));
		        System.out.println(new String(db.get("hello".getBytes())));
		        
		        db.delete("hello".getBytes());
		        assert(db.get("hello".getBytes()) == null);
		        System.out.println(db.get("hello".getBytes()));
		        
		    }
		} catch (RocksDBException e) {
		    e.printStackTrace();
		}
	}
	  
	
}
