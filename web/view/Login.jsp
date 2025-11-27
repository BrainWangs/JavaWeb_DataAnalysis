<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="Header.jsp" %>

<div style="width: 400px; margin: 80px auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">

    <h2 style="text-align:center;">用户登录</h2>

    <form action="LoginServlet" method="post" style="margin-top: 20px;">
        <label>用户名：</label><br>
        <input type="text" name="username" required style="width:100%; padding:8px; margin-bottom:15px;">

        <label>密码：</label><br>
        <input type="password" name="password" required style="width:100%; padding:8px; margin-bottom:15px;">

        <button type="submit" style="width:100%; padding:10px; background:#3498db; color:#fff; border:none; border-radius:5px;">
            登录
        </button>

        <% if(request.getAttribute("msg") != null) { %>
        <p style="color:red; margin-top:10px; text-align:center;">
            <%= request.getAttribute("msg") %>
        </p>
        <% } %>
    </form>
</div>

<%@ include file="Footer.jsp" %>
