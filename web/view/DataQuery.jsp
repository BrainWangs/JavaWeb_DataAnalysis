<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>设备数据查询与分析</title>
    <!-- 引入Bootstrap 5 CSS (虽然TabBar引入了，但为了编辑器预览或独立性保留引用) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入 Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-color: #4361ee;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
            --light-bg: #f8f9fa;
            --sidebar-width: 240px;
            --topbar-height: 60px;
            --card-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        }

        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        /* 主内容区域 - 适配 TabBar */
        .main-content {
            margin-top: var(--topbar-height);
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: calc(100vh - var(--topbar-height));
            transition: all 0.3s ease;
        }

        /* 响应式适配：当屏幕小于992px时（对应TabBar的响应式断点） */
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }

        /* 卡片通用样式 */
        .custom-card {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            background-color: #fff;
            margin-bottom: 25px;
            transition: transform 0.2s ease;
        }

        .custom-card:hover {
            transform: translateY(-2px);
        }

        .card-header-custom {
            background-color: transparent;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 20px 25px;
        }

        .card-title {
            color: #333;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* 表单控件优化 */
        .form-label {
            font-weight: 500;
            color: #555;
            font-size: 0.9rem;
            margin-bottom: 0.4rem;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            padding: 0.6rem 1rem;
            font-size: 0.95rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
        }

        .btn-search {
            background: linear-gradient(to right, #4361ee, #3a0ca3);
            border: none;
            color: white;
            padding: 0.6rem 2rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-search:hover {
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
            transform: translateY(-1px);
        }

        /* 表格样式 */
        .table-custom {
            margin-bottom: 0;
        }

        .table-custom thead th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #eee;
            color: #444;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            padding: 15px;
        }

        .table-custom tbody td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f0f0f0;
            color: #555;
        }

        .table-custom tbody tr:hover {
            background-color: #f8f9ff;
        }

        /* 分页样式 */
        .pagination-container {
            padding: 20px 25px;
            border-top: 1px solid #f0f0f0;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
        }

        .jump-input {
            width: 60px;
            text-align: center;
            display: inline-block;
            margin: 0 5px;
        }
    </style>
</head>
<body>

<%@ include file="TabBar.jsp" %>

<main class="main-content">

    <!-- 页面标题 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">数据查询</h4>
            <p class="text-muted small mb-0">查询历史监测数据与详细记录</p>
        </div>
    </div>

    <!-- 查询面板 -->
    <div class="card custom-card">
        <div class="card-header-custom">
            <h5 class="card-title">
                <i class="fas fa-filter text-primary"></i> 筛选条件
            </h5>
        </div>
        <div class="card-body p-4">
            <form method="get" action="${pageContext.request.contextPath}/DataQueryServlet">
                <div class="row g-3">
                    <!-- 1. 参数类型 -->
                    <div class="col-md-6 col-lg-2">
                        <label class="form-label">参数类型</label>
                        <select name="paramType" class="form-select">
                            <option value="temperature" ${paramType == 'temperature' ? 'selected' : ''}>温度</option>
                            <option value="humidity" ${paramType == 'humidity' ? 'selected' : ''}>湿度</option>
                            <option value="smoke" ${paramType == 'smoke' ? 'selected' : ''}>烟感指数</option>
                        </select>
                    </div>

                    <!-- 2. 设备名 -->
                    <div class="col-md-6 col-lg-2">
                        <label class="form-label">设备名</label>
                        <select name="deviceName" class="form-select">
                            <option value="L101" ${deviceName == 'L101' ? 'selected' : ''}>L101</option>
                            <option value="L102" ${deviceName == 'L102' ? 'selected' : ''}>L102</option>
                            <option value="L201" ${deviceName == 'L201' ? 'selected' : ''}>L201</option>
                            <option value="L202" ${deviceName == 'L202' ? 'selected' : ''}>L202</option>
                            <option value="L203" ${deviceName == 'L203' ? 'selected' : ''}>L203</option>
                        </select>
                    </div>

                    <!-- 3. 起始日期 -->
                    <div class="col-md-6 col-lg-2">
                        <label class="form-label">起始日期</label>
                        <input type="date" name="startDate" class="form-control" value="${startDate}">
                    </div>

                    <!-- 4. 结束日期 -->
                    <div class="col-md-6 col-lg-2">
                        <label class="form-label">结束日期</label>
                        <input type="date" name="endDate" class="form-control" value="${endDate}">
                    </div>

                    <!-- 5. 阈值 -->
                    <div class="col-md-6 col-lg-2">
                        <label class="form-label">数值筛选</label>
                        <input type="text" name="threshold" class="form-control ${not empty errorMessage ? 'is-invalid' : ''}"
                               placeholder="例如 >25" value="${threshold}">
                        <c:if test="${not empty errorMessage}">
                            <div class="invalid-feedback">${errorMessage}</div>
                        </c:if>
                    </div>

                    <!-- 6. 查询按钮 -->
                    <div class="col-md-6 col-lg-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-search w-100">
                            <i class="fas fa-search me-2"></i>查询
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- 数据表格 -->
    <div class="card custom-card">
        <div class="card-header-custom d-flex justify-content-between align-items-center">
            <h5 class="card-title">
                <i class="fas fa-table text-primary"></i> 查询结果
            </h5>
            <c:if test="${not empty records}">
                <span class="badge bg-light text-dark border">共找到 ${records.size()} 条 (当前页)</span>
            </c:if>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-custom table-hover">
                    <thead>
                    <tr>
                        <th scope="col" style="width: 30%">记录时间</th>
                        <th scope="col" style="width: 30%">设备名</th>
                        <th scope="col" style="width: 40%">数值</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty records}">
                            <c:forEach var="r" items="${records}">
                                <tr>
                                    <td>
                                        <i class="far fa-clock text-muted me-2"></i>${r.time}
                                    </td>
                                    <td>
                                            <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3">
                                                    ${r.deviceName}
                                            </span>
                                    </td>
                                    <td class="fw-bold">${r.value}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="3" class="text-center py-5 text-muted">
                                    <div class="my-3">
                                        <i class="fas fa-inbox fa-3x mb-3 text-secondary opacity-25"></i>
                                        <p>暂无数据，请尝试调整查询条件</p>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 分页控制 -->
        <c:if test="${not empty records || (empty records && not empty paramType)}">
            <div class="pagination-container">
                <div class="text-muted small">
                    第 <strong>${page}</strong> 页 / 共 <strong>${totalPages}</strong> 页
                </div>

                <form method="get" action="${pageContext.request.contextPath}/DataQueryServlet" class="d-flex align-items-center m-0">
                    <input type="hidden" name="paramType" value="${paramType}">
                    <input type="hidden" name="deviceName" value="${deviceName}">
                    <input type="hidden" name="startDate" value="${startDate}">
                    <input type="hidden" name="endDate" value="${endDate}">
                    <input type="hidden" name="threshold" value="${threshold}">

                    <span class="text-muted small me-2">跳转至</span>
                    <input type="number" name="page" min="1" max="${totalPages}" value="${page}" class="form-control form-control-sm jump-input">
                    <span class="text-muted small ms-2 me-3">页</span>

                    <button type="submit" class="btn btn-outline-primary btn-sm">GO</button>
                </form>
            </div>
        </c:if>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>