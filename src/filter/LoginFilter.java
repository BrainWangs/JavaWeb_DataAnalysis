//package filter;
//
//import javax.servlet.*;
//import javax.servlet.http.*;
//import java.io.IOException;
//
//public class LoginFilter implements Filter {
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse resp = (HttpServletResponse) response;
//
//        String uri = req.getRequestURI();
//        HttpSession session = req.getSession(false);
//        // 通过判断session中是否有用户信息来判断用户是否已登录
//        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
//
//        boolean isLoginRequest = uri.endsWith("Login.jsp") || uri.endsWith("LoginServlet");
//
//        // 决策功能
//        if (isLoggedIn || isLoginRequest) {
//            // 用户已登录或正在访问登录页面，放行
//            chain.doFilter(request, response);
//        } else {
//            // 未登录且访问受限资源 -> 重定向到登录页
//            resp.sendRedirect("Login.jsp");
//        }
//    }
//
//    @Override
//    public void init(FilterConfig filterConfig) {}
//    @Override
//    public void destroy() {}
//}
