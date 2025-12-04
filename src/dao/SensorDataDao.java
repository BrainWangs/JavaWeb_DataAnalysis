package dao;

import vo.SensorData;
import java.sql.*;
import java.util.*;

/**
 * 通用 DAO，用于查询任意传感器表（温度、湿度、烟雾）
 * 通过构造器或方法参数动态指定表名
 */
public class SensorDataDao {

    private final String tableName;

    public SensorDataDao(String tableName) {
        this.tableName = tableName;
    }

    /**
     * 获取指定表指定设备中全部传感器数据
     */
    public List<SensorData> getAllData(String deviceName) {
        List<SensorData> list = new ArrayList<>();
        String sql = "SELECT id, record_time, device_name, value_text FROM " + tableName +
                " WHERE device_name = ?" ;//+ " LIMIT 20000";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, deviceName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SensorData data = new SensorData();
                data.setId(rs.getLong("id"));
                data.setRecordTime(rs.getString("record_time"));
                data.setDeviceName(rs.getString("device_name"));
                data.setValueText(Double.parseDouble(rs.getString("value_text")));
                list.add(data);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
