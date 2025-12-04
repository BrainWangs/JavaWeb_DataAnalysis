<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CSV 导入 - IoT 数据</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 700px; margin: auto; }
        .msg { padding: 12px; margin-bottom: 16px; border-radius: 4px; }
        .msg.success { background: #e6ffed; border: 1px solid #b7f0c7; }
        .msg.error { background: #ffecec; border: 1px solid #f1a7a7; }
        .hint { font-size: 0.9em; color: #666; margin-top: 8px; }
    </style>
</head>
<body>
<%@ include file="Header.jsp" %>

<div class="container">
    <h1>上传 CSV 导入 IoT 数据</h1>

    <%-- 替代 JSTL 的逻辑部分 --%>
    <%
        // 从 request 域中获取 msg 和 msgType
        String msg = (String) request.getAttribute("msg");
        String msgType = (String) request.getAttribute("msgType");

        // 相当于 <c:when test="${not empty msg}">
        if (msg != null && !msg.trim().isEmpty()) {
            // 防止 msgType 为 null 导致输出 "null" 字符串
            if (msgType == null) {
                msgType = "";
            }
    %>
    <div class="msg <%= msgType %>">
        <%= msg %>
    </div>
    <%
        }
    %>

    <%-- 替代 action="${pageContext.request.contextPath}/..." --%>
    <form action = "CSVImportServlet" method="post" enctype="multipart/form-data">
        <label>选择 CSV 文件:
            <input type="file" name="csvFile" accept=".csv" required />
        </label>
        <div style="margin-top: 12px;">
            <button type="submit">上传导入</button>
        </div>
    </form>

    <div class="hint">
        <p><strong>示例CSV表头</strong>（第一行）：<br />
            Time, Device, Temperature<br />
            或：Time, Device, Humidity<br />
            或：Time, Device, Smoke
        </p>
        <p>注意：CSV 文件应为 UTF-8 编码，且表头必须包含 <code>Time</code> 与 <code>Device</code> 字段，第三列需包含 <code>temperature</code> / <code>humidity</code> / <code>smoke</code> 中的一个关键字以映射到目标表。</p>
    </div>
</div>

</body>
</html>