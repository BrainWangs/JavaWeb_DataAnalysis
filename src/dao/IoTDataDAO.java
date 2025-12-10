package dao;

import vo.IoTData;
import java.sql.*;
import java.util.List;

public class IoTDataDAO {

    public void createTablesIfNotExists() throws Exception {
        String template =
                "CREATE TABLE IF NOT EXISTS %s (" +
                        "id BIGINT PRIMARY KEY AUTO_INCREMENT," +
                        "record_time VARCHAR(50)," +
                        "device_name VARCHAR(100)," +
                        "value_text VARCHAR(50)" +
                        ")";
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate(String.format(template, "t_iot_temperature"));
            st.executeUpdate(String.format(template, "t_iot_humidity"));
            st.executeUpdate(String.format(template, "t_iot_smoke"));
        }
    }

    public void batchInsert(String tableName, List<IoTData> list) throws Exception {
        if (list.isEmpty()) return;

        String sql = "INSERT INTO " + tableName +
                " (record_time, device_name, value_text) VALUES (?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (IoTData d : list) {
                ps.setString(1, d.getTime());
                ps.setString(2, d.getDeviceName());
                ps.setString(3, d.getValue());
                ps.addBatch();
            }

            ps.executeBatch();
        }
    }
}
