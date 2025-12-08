<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>设备数据查询与分析</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.min.css">
    <style>
        main.container { max-width: 1100px; margin: 40px auto; }
        table { width: 100%; margin-top: 1rem; }
        th, td { text-align: center; }
        .pagination { margin-top: 1rem; text-align: center; }
    </style>
</head>
<body>

<%@ include file="Header.jsp" %>

<main class="container">
    <h2>设备数据查询与分析</h2>

    <form method="get" action="${pageContext.request.contextPath}/DataQueryServlet" class="grid">
        <label>
            参数类型：
            <select name="paramType">
                <option value="temperature" ${paramType == 'temperature' ? 'selected' : ''}>温度</option>
                <option value="humidity" ${paramType == 'humidity' ? 'selected' : ''}>湿度</option>
                <option value="smoke" ${paramType == 'smoke' ? 'selected' : ''}>烟感指数</option>
            </select>
        </label>

        <label>
            设备名：
            <select name="deviceName">
                <option value="L101" ${deviceName == 'L101' ? 'selected' : ''}>L101</option>
                <option value="L102" ${deviceName == 'L102' ? 'selected' : ''}>L102</option>
                <option value="L103" ${deviceName == 'L103' ? 'selected' : ''}>L103</option>
                <option value="L104" ${deviceName == 'L104' ? 'selected' : ''}>L104</option>
                <option value="L105" ${deviceName == 'L105' ? 'selected' : ''}>L105</option>
            </select>
        </label>

        <label>
            起始日期：
            <input type="date" name="startDate" value="${startDate}">
        </label>

        <label>
            结束日期：
            <input type="date" name="endDate" value="${endDate}">
        </label>

        <label>
            阈值：
            <input type="text" name="threshold" placeholder=">25" value="${threshold}">
            <span style="color: red;">${errorMessage}</span>
        </label>

        <button type="submit">查询</button>
    </form>

    <h3>查询结果</h3>
    <table>
        <thead>
        <tr>
            <th>记录时间</th>
            <th>设备名</th>
            <th>数值</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="r" items="${records}">
            <tr>
                <td>${r.time}</td>
                <td>${r.deviceName}</td>
                <td>${r.value}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div class="pagination">
        <form method="get" action="${pageContext.request.contextPath}/DataQueryServlet">
            <input type="hidden" name="paramType" value="${paramType}">
            <input type="hidden" name="deviceName" value="${deviceName}">
            <input type="hidden" name="startDate" value="${startDate}">
            <input type="hidden" name="endDate" value="${endDate}">
            <input type="hidden" name="threshold" value="${threshold}">
            <label>页码：
                <input type="number" name="page" min="1" value="${page}" style="width: 60px;">
            </label>
            <button type="submit">跳转</button>
        </form>
        <p>共 ${totalPages} 页，当前第 ${page} 页</p>
    </div>
</main>

<%@ include file="Footer.jsp" %>
</body>
</html>
