package service;

import dao.IoTDataDAO;
import vo.IoTData;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CSVImportProcessor {
    private Connection conn;
    private IoTDataDAO dataDAO;
    private static final int BATCH_SIZE = 5000;

    // 映射CSV表头关键字到数据库表名
    private static final Map<String, String> TABLE_MAPPING = new HashMap<>();
    static {
        // key: CSV表头中的特征字段, value: 数据库表名
        TABLE_MAPPING.put("temperature", "t_iot_temperature");
        TABLE_MAPPING.put("humidity",    "t_iot_humidity");
        TABLE_MAPPING.put("smoke",       "t_iot_smoke");
    }

    public CSVImportProcessor(Connection conn) {
        this.conn = conn;
        this.dataDAO = new IoTDataDAO(conn);
    }

    public void processCSV(InputStream inputStream) throws IOException, SQLException, IllegalArgumentException {
        // 首先检查并创建表
        dataDAO.createTablesIfNotExists();
        
        List<IoTData> batch = new ArrayList<>();
        conn.setAutoCommit(false); // 开启事务

        try (BufferedReader br = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
            String line = br.readLine();
            if (line == null) return;

            // 1. 解析表头以确定目标表和字段索引
            String[] headers = line.toLowerCase().split(",");
            String targetTable = null;
            int timeIndex = -1, deviceIndex = -1, valueIndex = -1;

            for (int i = 0; i < headers.length; i++) {
                String h = headers[i].trim();
                if (h.contains("time")) timeIndex = i;
                else if (h.contains("device")) deviceIndex = i;
                else if (TABLE_MAPPING.containsKey(h)) {
                    targetTable = TABLE_MAPPING.get(h);
                    valueIndex = i;
                }
            }

            // 校验是否识别成功
            if (targetTable == null || timeIndex == -1 || deviceIndex == -1) {
                throw new IllegalArgumentException("无法识别CSV文件类型或关键字段缺失 (Time/Device/Type)");
            }

            // 2. 读取数据行
            while ((line = br.readLine()) != null) {
                if (line.trim().isEmpty()) continue;

                String[] fields = line.split(","); // 简单分割，如需处理引号内逗号请保留之前的正则逻辑
                if (fields.length <= Math.max(timeIndex, Math.max(deviceIndex, valueIndex))) continue;

                IoTData data = new IoTData(
                        fields[timeIndex].trim(),
                        fields[deviceIndex].trim(),
                        fields[valueIndex].trim()
                );
                batch.add(data);

                if (batch.size() >= BATCH_SIZE) {
                    dataDAO.batchInsert(targetTable, batch);
                    conn.commit();
                    batch.clear();
                }
            }

            if (!batch.isEmpty()) {
                dataDAO.batchInsert(targetTable, batch);
                conn.commit();
            }

        } catch (Exception e) {
            conn.rollback(); // 异常回滚
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }
}