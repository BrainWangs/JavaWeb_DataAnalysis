<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>IoT数据导入</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        .container { max-width: 500px; margin: 0 auto; border: 1px solid #ddd; padding: 20px; border-radius: 5px; }
        button { margin-top: 10px; padding: 8px 16px; cursor: pointer; }

        /* 消息样式 */
        .msg { margin-top: 15px; padding: 10px; border-radius: 4px; text-align: center; }
        .msg.success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .msg.error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
<div class="container">
    <h2>IoT 设备数据上传</h2>

    <form action="CSVImportServlet" method="post" enctype="multipart/form-data">
        <input type="file" id="csvFile" name="csvFile" accept=".csv" required>
        <br>
        <button type="submit" id="btnSubmit">上传并导入</button>
    </form>

    <%
        String msg = (String) request.getAttribute("msg");
        String msgType = (String) request.getAttribute("msgType");

        if (msg != null && !msg.isEmpty()) {
    %>
    <div class="msg <%= (msgType != null ? msgType : "error") %>">
        <%= msg %>
    </div>
    <% } %>

</div>
</body>
</html>