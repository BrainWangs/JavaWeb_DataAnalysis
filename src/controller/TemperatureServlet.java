package controller;

import service.SensorDataService;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/TemperatureServlet")
public class TemperatureServlet extends HttpServlet {
    private final SensorDataService service = new SensorDataService("t_iot_temperature");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        System.out.println("TemperatureServlet.doGet");

        String deviceName = req.getParameter("deviceName");

        resp.setContentType("application/json;charset=UTF-8");
        String jsonData = service.getChartData(deviceName);
        resp.getWriter().write(jsonData);
    }
}
