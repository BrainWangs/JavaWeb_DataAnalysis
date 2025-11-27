package controller;

import service.CSVImportProcessor;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

public class CSVImportServlet extends HttpServlet {

    // 【优化点】将连接信息提取为常量
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/sql_demo?useSSL=false";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "123456";

    private Connection getDBConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try (Connection conn = getDBConnection()) {
            Part filePart = request.getPart("csvFile");

            if (filePart == null || filePart.getSize() == 0) {
                // 如果文件为空，直接抛出，让 catch 块处理
                throw new IllegalArgumentException("错误：请选择要上传的 CSV 文件。");
            }

            CSVImportProcessor processor = new CSVImportProcessor(conn);
            processor.processCSV(filePart.getInputStream());

            // 成功时设置属性
            request.setAttribute("msg", "文件导入成功！");
            request.setAttribute("msgType", "success");

        } catch (Exception e) {
            e.printStackTrace();

            String userMessage;
            if (e instanceof IllegalArgumentException) {
                // 如果是格式错误或文件选择错误，显示具体信息
                userMessage = e.getMessage();
            } else {
                // 【优化点】隐藏底层数据库错误，只提示用户联系管理员
                userMessage = "导入过程中发生系统错误，请检查文件格式或联系管理员。";
            }

            request.setAttribute("msg", userMessage);
            request.setAttribute("msgType", "error");

        } finally {
            // 【关键点】转发回 JSP，确保地址栏不变
            request.getRequestDispatcher("/ImportData.jsp").forward(request, response);
        }
    }
}