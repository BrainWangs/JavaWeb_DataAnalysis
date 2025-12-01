<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="Header.jsp" %>

<%
    vo.User user = (vo.User) session.getAttribute("user");

    // 未登录 → 自动跳回登录页面
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div style="margin: 50px auto; width: 400px; background: #fff; padding: 20px;
     border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.2);">

    <h2 style="text-align:center;">登录成功！</h2>

    <p style="text-align:center; font-size:18px;">
        欢迎你，<strong><%= user.getUsername() %></strong>
    </p>

    <!-- 按钮区域 -->
    <div style="text-align:center; margin-top:20px;">

        <!-- 首页按钮 -->
        <a href="StudentQuery.jsp"
           style="display:inline-block; padding:10px 20px; background:#3498db; color:#fff;
           text-decoration:none; border-radius:5px; margin:0 10px;">
            首页
        </a>

        <!-- 退出登录按钮 -->
        <a href="LogoutServlet"
           style="display:inline-block; padding:10px 20px; background:#e74c3c; color:#fff;
           text-decoration:none; border-radius:5px; margin:0 10px;">
            退出登录
        </a>
    </div>

</div>

<%@ include file="Footer.jsp" %>
