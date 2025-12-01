package controller;

import service.CSVImportProcessor;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024L * 1024L * 200L, // 200MB
        maxRequestSize = 1024L * 1024L * 250L // 250MB
)
@WebServlet("/CSVImportServlet")
public class CSVImportServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            Part filePart = request.getPart("csvFile");
            if (filePart == null || filePart.getSize() == 0)
                throw new IllegalArgumentException("请上传 CSV 文件");

            try (InputStream in = filePart.getInputStream()) {
                CSVImportProcessor p = new CSVImportProcessor();
                p.processCSV(in);
            }

            request.setAttribute("msg", "文件导入成功! ");
            request.setAttribute("msgType", "success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "导入失败：" + e.getMessage());
            request.setAttribute("msgType", "error");
        }

        request.getRequestDispatcher("/view/ImportData.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/view/ImportData.jsp").forward(request, response);
    }
}
