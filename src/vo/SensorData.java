package vo;

public class SensorData {
    private long id;
    private String recordTime;
    private String deviceName;
    private double valueText;

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getRecordTime() { return recordTime; }
    public void setRecordTime(String recordTime) { this.recordTime = recordTime; }

    public String getDeviceName() { return deviceName; }
    public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

    public double getValueText() { return valueText; }
    public void setValueText(double valueText) { this.valueText = valueText; }
}
