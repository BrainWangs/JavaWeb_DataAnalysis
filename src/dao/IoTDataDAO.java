package dao;

import vo.IoTData;
import java.sql.*;
import java.util.List;

public class IoTDataDAO {

    private static final String URL = "jdbc:mysql://localhost:3306/sql_demo?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";

    private Connection conn;

    public Connection getConnection() throws Exception {
        if (conn == null || conn.isClosed()) {
            conn = DBUtil.getConnection();
        }
        return conn;
    }

    public void closeConnection() {
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }

    public void createTablesIfNotExists() throws Exception {
        String template =
                "CREATE TABLE IF NOT EXISTS %s (" +
                        "id BIGINT PRIMARY KEY AUTO_INCREMENT," +
                        "record_time VARCHAR(50)," +
                        "device_name VARCHAR(100)," +
                        "value_text VARCHAR(50)" +
                        ")";
        Statement st = getConnection().createStatement();
        st.executeUpdate(String.format(template, "t_iot_temperature"));
        st.executeUpdate(String.format(template, "t_iot_humidity"));
        st.executeUpdate(String.format(template, "t_iot_smoke"));
    }

    public void batchInsert(String tableName, List<IoTData> list) throws Exception {
        if (list.isEmpty()) return;

        String sql = "INSERT INTO " + tableName +
                " (record_time, device_name, value_text) VALUES (?, ?, ?)";

        PreparedStatement ps = getConnection().prepareStatement(sql);

        for (IoTData d : list) {
            ps.setString(1, d.getTime());
            ps.setString(2, d.getDeviceName());
            ps.setString(3, d.getValue());
            ps.addBatch();
        }

        ps.executeBatch();
    }
}
