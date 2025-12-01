package vo;

public class IoTData {

    private String time;        // date_time
    private String deviceName;  // device_name
    private String value;       // temperature/humidity/smoke

    public IoTData(String time, String deviceName, String value) {
        this.time = time;
        this.deviceName = deviceName;
        this.value = value;
    }

    public String getTime() {
        return time;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public String getValue() {
        return value;
    }
}
