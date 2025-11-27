package dao;

import vo.IoTData;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

public class IoTDataDAO {
    private Connection conn;

    public IoTDataDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * 检查并创建所需的数据库表
     * @throws SQLException SQL异常
     */
    public void createTablesIfNotExists() throws SQLException {
        String[] createTableSQLs = {
            "CREATE TABLE IF NOT EXISTS t_iot_temperature (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "record_time DATETIME NOT NULL, " +
            "device_name VARCHAR(100) NOT NULL, " +
            "value_data DECIMAL(10,2) NOT NULL)",

            "CREATE TABLE IF NOT EXISTS t_iot_humidity (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "record_time DATETIME NOT NULL, " +
            "device_name VARCHAR(100) NOT NULL, " +
            "value_data DECIMAL(10,2) NOT NULL)",

            "CREATE TABLE IF NOT EXISTS t_iot_smoke (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "record_time DATETIME NOT NULL, " +
            "device_name VARCHAR(100) NOT NULL, " +
            "value_data DECIMAL(10,2) NOT NULL)"
        };

        try (Statement stmt = conn.createStatement()) {
            for (String sql : createTableSQLs) {
                stmt.executeUpdate(sql);
            }
        }
    }

    /**
     * 批量插入数据到指定表
     * @param tableName 数据库表名 (由Service层决定)
     * @param dataList 数据列表
     */
    public void batchInsert(String tableName, List<IoTData> dataList) throws SQLException {
        // 注意：tableName不能由用户输入直接拼接，防止SQL注入。
        // 此处tableName由Service层的枚举/常量控制，是安全的。
        String sql = "INSERT INTO " + tableName + " (record_time, device_name, value_data) VALUES (?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (IoTData data : dataList) {
                pstmt.setString(1, data.getTime());
                pstmt.setString(2, data.getDeviceName());
                pstmt.setString(3, data.getValue());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }
}