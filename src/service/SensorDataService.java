package service;

import dao.SensorDataDao;
import vo.SensorData;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import java.util.List;

/**
 * 通用 Service，用于封装业务逻辑。
 * 构造时指定表名。
 */
public class SensorDataService {

    private final SensorDataDao dao;

    public SensorDataService(String tableName) {
        this.dao = new SensorDataDao(tableName);
        System.out.println("SensorDataService: " + tableName);
    }

    public String getChartData() {
        System.out.println("SensorDataService.getChartData");
        List<SensorData> list = dao.getAllData();
        JsonArray time = new JsonArray();
        JsonArray value = new JsonArray();

        for (SensorData d : list) {
            time.add(d.getRecordTime());
            value.add(d.getValueText());
        }

        JsonObject result = new JsonObject();
        result.add("time", time);
        result.add("value", value);
        return result.toString();
    }
}
