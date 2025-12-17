package service;

import dao.IoTDataDAO;
import vo.IoTData;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class CSVImportProcessor {

    private IoTDataDAO dao = new IoTDataDAO();
    private static final int BATCH_SIZE = 2000;

    public void processCSV(InputStream in) throws Exception {

        dao.createTablesIfNotExists();
        dao.getConnection().setAutoCommit(false);

        List<IoTData> batch = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new InputStreamReader(in, StandardCharsets.UTF_8))) {

            String header = br.readLine();
            if (header == null) return;

            String[] cols = header.split(",", -1);
            // 添加输出cols数组元素的代码
            for (int i = 0; i < cols.length; i++) {
                System.out.println("cols[" + i + "] = " + cols[i]);
            }
            // 消除cols数组中每个元素首尾的引号
            for (int i = 0; i < cols.length; i++) {
                if (cols[i].startsWith("\"") && cols[i].endsWith("\"") && cols[i].length() >= 2) {
                    cols[i] = cols[i].substring(1, cols[i].length() - 1);
                }
            }
            for (int i = 0; i < cols.length; i++) {
                System.out.println("cols[" + i + "] = " + cols[i]);
            }

            // 需要的字段
            int indexTime = findIndex(cols, "date_time");
            int indexDeviceName = findIndex(cols, "device_name");

            if (indexTime == -1 || indexDeviceName == -1)
                throw new IllegalArgumentException("CSV 缺少 date_time 或 device_name 字段。");

            // 正数第6列为value
            int indexValue = 5;
            String valueColName = cols[indexValue].trim().toLowerCase();

            // 确定表名
            String targetTable = "t_iot_" + valueColName;

            String line;
            while ((line = br.readLine()) != null) {

                if (line.trim().isEmpty()) continue;

                String[] fields = line.split(",", -1);

                if (fields.length <= indexValue) continue;

                IoTData d = new IoTData(
                        fields[indexTime].trim(),
                        fields[indexDeviceName].trim(),
                        fields[indexValue].trim()
                );
                batch.add(d);

                if (batch.size() >= BATCH_SIZE) {
                    dao.batchInsert(targetTable, batch);
                    batch.clear();
                }
            }

            if (!batch.isEmpty()) {
                dao.batchInsert(targetTable, batch);
            }

        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * 在字符串数组cols中查找指定key的索引位置
     * */
    private int findIndex(String[] cols, String key) {
        key = key.toLowerCase();
        for (int i = 0; i < cols.length; i++) {
            if (cols[i].trim().toLowerCase().equals(key))
                return i;
        }
        return -1;
    }
}