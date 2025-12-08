package dao;

import vo.IoTData;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DataQueryDAO {

    // 根据参数类型确定表名
    private String getTable(String type) {
        switch (type) {
            case "humidity": return "t_iot_humidity";
            case "smoke": return "t_iot_smoke";
            default: return "t_iot_temperature";
        }
    }

    /***
     * 查询分页数据
     * @param type 参数类型
     *
     */
    public List<IoTData> query(String type, String device, String start, String end, String threshold, int page, int pageSize) {
        List<IoTData> list = new ArrayList<>();
        String table = getTable(type);
        StringBuilder sql = new StringBuilder("SELECT record_time, device_name, value_text FROM " + table + " WHERE device_name=? ");

        if (start != null && !start.isEmpty())
            sql.append("AND record_time >= ? ");
        if (end != null && !end.isEmpty())
            sql.append("AND record_time <= ? ");
        if (threshold != null && !threshold.isEmpty())
            sql.append("AND value_text " + threshold + " ");

        sql.append("ORDER BY record_time DESC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            ps.setString(i++, device);
            if (start != null && !start.isEmpty())
                ps.setString(i++, start);
            if (end != null && !end.isEmpty())
                ps.setString(i++, end);
            ps.setInt(i++, pageSize);
            ps.setInt(i, (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                IoTData data = new IoTData(
                        rs.getString("record_time"),
                        rs.getString("device_name"),
                        rs.getString("value_text")
                );
                list.add(data);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /***
     * 统计记录总数
     */
    public int count(String type, String device, String start, String end, String threshold) {
        int total = 0;
        String table = getTable(type);
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM " + table + " WHERE device_name=? ");
        if (start != null && !start.isEmpty())
            sql.append("AND record_time >= ? ");
        if (end != null && !end.isEmpty())
            sql.append("AND record_time <= ? ");
        if (threshold != null && !threshold.isEmpty())
            sql.append("AND value_text " + threshold + " ");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setString(i++, device);
            if (start != null && !start.isEmpty())
                ps.setString(i++, start);
            if (end != null && !end.isEmpty())
                ps.setString(i++, end);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                total = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
}
