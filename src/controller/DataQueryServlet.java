package controller;

import service.DataQueryService;
import vo.IoTData;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/DataQueryServlet")
public class DataQueryServlet extends HttpServlet {
    private DataQueryService service = new DataQueryService();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String paramType = getOrDefault(request.getParameter("paramType"), "temperature");
        String deviceName = getOrDefault(request.getParameter("deviceName"), "L101");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String threshold = request.getParameter("threshold");
        
        // 添加threshold验证逻辑
        if (threshold != null && !threshold.isEmpty()) {
            if (!isValidThreshold(threshold)) {
                // 保存错误信息和用户输入的参数到request中
                request.setAttribute("errorMessage", "非法的阈值格式: " + threshold + "。请使用如 '>25' 或 '<30' 的格式。");
                request.setAttribute("paramType", paramType);
                request.setAttribute("deviceName", deviceName);
                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("threshold", threshold);

                // 重定向回原页面
                request.getRequestDispatcher("/view/DataQuery.jsp").forward(request, response);
                return;
            }
        }
        
        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}

        List<IoTData> records = service.queryData(paramType, deviceName, startDate, endDate, threshold, page);
        int totalPages = service.getTotalPages(paramType, deviceName, startDate, endDate, threshold);

        request.setAttribute("records", records);
        request.setAttribute("paramType", paramType);
        request.setAttribute("deviceName", deviceName);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("threshold", threshold);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/view/DataQuery.jsp").forward(request, response);
    }

    private String getOrDefault(String val, String def) {
        return (val == null || val.isEmpty()) ? def : val;
    }
    
    // 验证threshold格式是否合法
    private boolean isValidThreshold(String threshold) {
        // 支持的操作符
        String[] operators = {">=", "<=", ">", "<", "=", "!="};
        
        for (String op : operators) {
            if (threshold.startsWith(op)) {
                // 提取操作符后面的部分并尝试转换为数字
                String valuePart = threshold.substring(op.length()).trim();
                try {
                    Double.parseDouble(valuePart);
                    return true;
                } catch (NumberFormatException e) {
                    return false;
                }
            }
        }
        return false;
    }
}