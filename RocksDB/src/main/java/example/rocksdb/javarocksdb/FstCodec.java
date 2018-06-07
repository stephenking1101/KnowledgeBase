package example.rocksdb.javarocksdb;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.nustaq.serialization.FSTConfiguration;
import org.nustaq.serialization.FSTObjectInput;
import org.nustaq.serialization.FSTObjectOutput;


public class FstCodec {

    public final static String FST_CODEC_NAME = "FstPOJOClass";
    
    private final static FSTConfiguration config;
    
    static {
        config = FSTConfiguration.createDefaultConfiguration();
        
    }
    
    public static Object decode(byte[] bytes) throws IOException {
        try {
            ByteArrayInputStream in = new ByteArrayInputStream(bytes);
            FSTObjectInput inputStream = config.getObjectInput(in);
            return inputStream.readObject();
        } catch (IOException e) {
            throw e;
        } catch (Exception e) {
            throw new IOException(e);
        }
    }
    
    public static byte[] encode(Object in) throws IOException {
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        FSTObjectOutput oos = config.getObjectOutput(os);
        oos.writeObject(in);
        oos.flush();
        return os.toByteArray();
    }
}
