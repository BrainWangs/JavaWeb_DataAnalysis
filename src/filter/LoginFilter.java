package filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        // 检查是否为JSP页面请求
        boolean isJspRequest = uri.endsWith(".jsp");

        // 检查是否为登录相关请求
        boolean isLoginRequest = uri.endsWith("Login.jsp") ||
                               uri.endsWith("LoginServlet") ||
                               uri.contains("/LoginServlet");

        // 检查是否为注册相关请求
        boolean isRegisterRequest = uri.endsWith("UserSignIn.jsp");

        HttpSession session = req.getSession(false);
        // 通过判断session中是否有用户信息来判断用户是否已登录
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        // 决策功能
        if (isLoggedIn) {
            // 用户已登录
            if (isLoginRequest && uri.endsWith("Login.jsp")) {
                // 已登录用户访问登录页，重定向到主页面
                resp.sendRedirect(contextPath + "/view/ImportData.jsp");
                return;
            }
            // 放行其他请求
            chain.doFilter(request, response);
        } else if (isLoginRequest || isRegisterRequest || !isJspRequest) {
            // 未登录但访问的是登录相关资源或非JSP资源，放行
            chain.doFilter(request, response);
        } else {
            // 未登录且访问受保护的JSP页面 -> 重定向到登录页
            resp.sendRedirect(contextPath + "/view/Login.jsp");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {}
    @Override
    public void destroy() {}
}