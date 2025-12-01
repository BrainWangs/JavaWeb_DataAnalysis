package controller;

import dao.UserDAO;
import service.UserLogin;
import vo.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends javax.servlet.http.HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(username, password);

        if (user != null) {
            // 登录成功
            request.getSession().setAttribute("user", user);
            response.sendRedirect("LoginSuccess.jsp");
        } else {
            // 登录失败
            request.setAttribute("msg", "用户名或密码错误");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}