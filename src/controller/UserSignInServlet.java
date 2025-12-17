package controller;

import service.SignInService;
import vo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UserSignInServlet")
public class UserSignInServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 获取表单提交的用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 验证输入
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("msg", "用户名和密码不能为空");
            request.getRequestDispatcher("/view/UserSignIn.jsp").forward(request, response);
            return;
        }

        // 调用服务层处理注册逻辑
        SignInService signInService = new SignInService();
        String result = signInService.register(new User(0, username, password));

        // 根据结果跳转
        if ("success".equals(result)) {
            // 注册成功，跳转到登录页
            request.setAttribute("msg", "注册成功，请登录");
            request.getRequestDispatcher("/view/Login.jsp").forward(request, response);
        } else {
            // 注册失败，返回注册页并显示错误信息
            request.setAttribute("msg", result);
            request.getRequestDispatcher("/view/UserSignIn.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 转发到注册页面
        request.getRequestDispatcher("/view/UserSignIn.jsp").forward(request, response);
    }
}