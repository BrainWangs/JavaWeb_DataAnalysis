<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>超算数据可视化系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f5f5f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .header {
            background: linear-gradient(135deg, #2c3e50, #3498db);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo h1 { font-size: 1.8rem; }
        .nav ul { list-style: none; display: flex; }
        .nav li { margin-left: 2rem; }
        .nav a {
            color: white;
            text-decoration: none;
            transition: color 0.3s;
            font-weight: 500;
        }
        .nav a:hover { color: #f39c12; }
        .main-container { flex: 1; padding: 2rem 0; }
        .page-title { text-align: center; margin-bottom: 2rem; color: #2c3e50; }
        .btn {
            background: #3498db; color: white; padding: 0.5rem 1rem;
            border: none; border-radius: 5px; cursor: pointer;
            transition: background 0.3s; font-size: 1rem;
        }
        .btn:hover { background: #2980b9; }
        @media (max-width: 768px) {
            .header .container { flex-direction: column; text-align: center; }
            .nav ul { margin-top: 1rem; justify-content: center; }
            .nav li { margin: 0 1rem; }
        }
    </style>
</head>
<body>
<header class="header">
    <div class="container">
        <div class="logo">
            <h1>📚 超算数据可视化系统</h1>
        </div>
        <nav class="nav">
            <ul>
                <li><a href="/web/view/Login.jsp">登录</a></li>
                <li><a href="/web/view/ImportData.jsp">导入数据</a></li>
                <li><a href="/web/view/DataVisualize.jsp">数据图表</a></li>
            </ul>
        </nav>
    </div>
</header>
