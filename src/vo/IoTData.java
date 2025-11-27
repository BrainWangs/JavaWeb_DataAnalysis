package vo;

public class IoTData {
    private String time;       // 时间戳
    private String deviceName; // 设备名称
    private String value;      // 数值 (可能是温度、湿度或烟雾浓度)

    public IoTData(String time, String deviceName, String value) {
        this.time = time;
        this.deviceName = deviceName;
        this.value = value;
    }

    public String getTime() { return time; }
    public String getDeviceName() { return deviceName; }
    public String getValue() { return value; }
}