package example.rocksdb.javarocksdb.entity;

import java.io.Serializable;
import java.util.*;

public class HelloWorld implements Serializable {
    private static final long serialVersionUID = 7273496753350952316L;

    private long latestActiveTime;

    private String deviceName;

    private String deviceType;

    private Map<String, Long> amrCounterMap;

    private Set<String> fingerPrintList;

    private String recentSessionId;

    public String getRecentSessionId() {
        return recentSessionId;
    }

    public void setRecentSessionId(String recentSessionId) {
        this.recentSessionId = recentSessionId;
    }

    public long getLatestActiveTime() {
        return latestActiveTime;
    }

    public void setLatestActiveTime(long latestActiveTime) {
        this.latestActiveTime = latestActiveTime;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public Map<String, Long> getAmrCounterMap() {
        return amrCounterMap;
    }

    public void setAmrCounterMap(Map<String, Long> amrCounterMap) {
        this.amrCounterMap = amrCounterMap;
    }

    public Set<String> getFingerPrintList() {
        return fingerPrintList;
    }

    public void setFingerPrintList(Set<String> fingerPrintList) {
        this.fingerPrintList = fingerPrintList;
    }

    public int sizeOfAmr() {
        if (amrCounterMap != null)
            return amrCounterMap.size();
        return 0;
    }

    public void addAmrCount(String key) {
        this.addAmrCount(key, 1);
    }

    public void addAmrCount(HelloWorld o) {
        Map<String, Long> amrCountMap = o.getAmrCounterMap();
        if (amrCountMap != null) {
            amrCountMap.forEach(this::addAmrCount);
        }
    }

    private void addAmrCount(String key, long updateCount) {
        if (amrCounterMap == null)
            amrCounterMap = new HashMap<>();
        amrCounterMap.merge(key, updateCount, (oldValue, newValue) -> oldValue + newValue);
    }

    public void addFingerPrints(HelloWorld o) {
        Collection<String> fingerPrints = o.getFingerPrintList();
        if (fingerPrints != null) {
            fingerPrints.forEach(this::addFingerPrint);
        }
    }

    @Override
    public String toString() {
        return "DeviceInfo{" +
                "latestActiveTime=" + latestActiveTime +
                ", deviceName='" + deviceName + '\'' +
                ", deviceType='" + deviceType + '\'' +
                ", amrCounterMap=" + amrCounterMap +
                ", fingerPrintList=" + fingerPrintList +
                '}';
    }

    public void addFingerPrint(String fingerPrint) {
        if (this.fingerPrintList == null)
            fingerPrintList = new HashSet<>();
        fingerPrintList.add(fingerPrint);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        HelloWorld that = (HelloWorld) o;

        if (latestActiveTime != that.latestActiveTime) return false;
        if (deviceName != null ? !deviceName.equals(that.deviceName) : that.deviceName != null) return false;
        if (deviceType != null ? !deviceType.equals(that.deviceType) : that.deviceType != null) return false;
        if (amrCounterMap != null ? !amrCounterMap.equals(that.amrCounterMap) : that.amrCounterMap != null)
            return false;
        if (fingerPrintList != null ? !fingerPrintList.equals(that.fingerPrintList) : that.fingerPrintList != null)
            return false;
        return recentSessionId != null ? recentSessionId.equals(that.recentSessionId) : that.recentSessionId == null;
    }

    @Override
    public int hashCode() {
        int result = (int) (latestActiveTime ^ (latestActiveTime >>> 32));
        result = 31 * result + (deviceName != null ? deviceName.hashCode() : 0);
        result = 31 * result + (deviceType != null ? deviceType.hashCode() : 0);
        result = 31 * result + (amrCounterMap != null ? amrCounterMap.hashCode() : 0);
        result = 31 * result + (fingerPrintList != null ? fingerPrintList.hashCode() : 0);
        result = 31 * result + (recentSessionId != null ? recentSessionId.hashCode() : 0);
        return result;
    }
}
