package example.rocksdb.javarocksdb;

import java.util.Map;

import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.common.serialization.Serializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FstSerializer<T> implements Serializer<T>  {
    private static final Logger logger = LoggerFactory.getLogger(FstSerializer.class);

    private Class<T> tClass;
    
    @Override
    public void configure(Map<String, ?> configs, boolean isKey) {
        tClass = (Class<T>) configs.get(FstCodec.FST_CODEC_NAME);
    }

    @Override
    public byte[] serialize(String topic, T object) {
        if (object == null){
            logger.debug("Input Object is null, skip the serialize operation");
            return null;
        }

        try {
            return FstCodec.encode(object);
        } catch (Exception e) {
            throw new SerializationException("Error serializing Fst message", e);
        }
    }

    @Override
    public void close() {
        // TODO Auto-generated method stub
        
    }

}
