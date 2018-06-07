package example.rocksdb.javarocksdb;

import java.util.Map;

import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.common.serialization.Deserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FstDeserializer<T> implements Deserializer<T>  {
    private static final Logger logger = LoggerFactory.getLogger(FstDeserializer.class);

    private Class<T> tClass;
    
    @Override
    public void configure(Map<String, ?> configs, boolean isKey) {
        tClass = (Class<T>) configs.get(FstCodec.FST_CODEC_NAME);
    }

    @Override
    public T deserialize(String topic, byte[] data) {
        if (data == null) {
            logger.debug("Input byte array is null, skip the deserialize operation");
            return null;
        }
        
        T object;
        try {
            object = (T)FstCodec.decode(data);
        } catch (Exception e) {
            throw new SerializationException("Error deserializing Fst message", e);
        }
        return object;
    }

    @Override
    public void close() {
        // TODO Auto-generated method stub
        
    }

}
