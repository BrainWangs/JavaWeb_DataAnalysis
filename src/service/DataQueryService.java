package service;

import dao.DataQueryDAO;
import vo.IoTData;

import java.util.List;

public class DataQueryService {
    private DataQueryDAO dao = new DataQueryDAO();

    public List<IoTData> queryData(String type, String device, String start, String end, String threshold, int page) {
        return dao.query(type, device, start, end, threshold, page, 100);
    }

    public int getTotalPages(String type, String device, String start, String end, String threshold) {
        int total = dao.count(type, device, start, end, threshold);
        return (int) Math.ceil(total / 100.0);
    }
}
