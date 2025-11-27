package controller;

import service.UserLogin;
import vo.User;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 调用service层,用于处理登录请求,登录逻辑在service层
 */
public class LoginServlet extends javax.servlet.http.HttpServlet {
    private UserLogin userLogin;
    @Override
    public void init() throws ServletException {
        super.init();
        this.userLogin = new UserLogin();
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userLogin.login(username, password);

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