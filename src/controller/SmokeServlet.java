package controller;

import service.SensorDataService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet("/SmokeServlet")
public class SmokeServlet extends HttpServlet {
    private final SensorDataService service = new SensorDataService("t_iot_smoke");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(service.getChartData());
    }
}

