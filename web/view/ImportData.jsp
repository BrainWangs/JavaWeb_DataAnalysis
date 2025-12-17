<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CSV 导入 - IoT 数据</title>
    <style>
        :root {
            --primary-color: #4361ee;
            --success-color: #4cc9f0;
            --danger-color: #f72585;
            --light-bg: #f8f9fa;
            --sidebar-width: 240px;
            --topbar-height: 60px;
        }

        * {
            box-sizing: border-box;
        }

        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        /* 主容器 - 响应式布局 */
        .main-container {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* 主要内容区域 */
        .main-content {
            flex: 1;
            margin-top: var(--topbar-height);
            margin-left: var(--sidebar-width);
            padding: 30px;
            width: calc(100% - var(--sidebar-width));
            transition: all 0.3s ease;
        }

        /* 响应式调整 */
        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 20px;
            }

            .row {
                margin-left: -10px;
                margin-right: -10px;
            }

            .col-lg-8, .col-lg-4 {
                padding-left: 10px;
                padding-right: 10px;
            }

            .upload-card, .example-card {
                border-radius: 8px;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 15px;
            }

            .upload-area {
                padding: 2rem 1rem;
            }

            .step-indicator {
                flex-direction: column;
                align-items: center;
            }

            .step:not(:last-child):after {
                display: none;
            }
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 10px;
            }

            .upload-area {
                padding: 2rem 1rem;
            }

            .step-indicator {
                flex-direction: column;
                align-items: center;
            }

            .step:not(:last-child):after {
                display: none;
            }
        }

        /* 卡片样式 */
        .upload-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            background-color: #fff;
        }

        .upload-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        .upload-area {
            border: 2px dashed #d0d7de;
            border-radius: 10px;
            padding: 3rem 2rem;
            text-align: center;
            background-color: #fafbfc;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .upload-area:hover, .upload-area.dragover {
            border-color: var(--primary-color);
            background-color: rgba(67, 97, 238, 0.05);
        }

        .upload-icon {
            font-size: 3.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .file-info {
            background-color: var(--light-bg);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .example-card {
            background-color: #f0f8ff;
            border-left: 4px solid var(--primary-color);
            border-radius: 10px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.05);
        }

        .code-sample {
            background-color: #2d3748;
            color: #e2e8f0;
            border-radius: 6px;
            padding: 1rem;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            overflow-x: auto;
        }

        .custom-alert {
            border: none;
            border-radius: 10px;
            padding: 1.25rem 1.5rem;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
        }

        .requirements-list {
            list-style-type: none;
            padding-left: 0;
        }

        .requirements-list li {
            padding: 0.5rem 0;
            padding-left: 2rem;
            position: relative;
        }

        .requirements-list li:before {
            content: "✓";
            color: #10b981;
            font-weight: bold;
            position: absolute;
            left: 0;
        }

        .requirements-list li.warning:before {
            content: "!";
            color: #f59e0b;
        }

        .btn-upload {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            border: none;
            padding: 0.75rem 2rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            color: white;
        }

        .btn-upload:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(67, 97, 238, 0.3);
        }

        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            counter-reset: step;
        }

        .step {
            text-align: center;
            flex: 1;
            position: relative;
        }

        .step:before {
            counter-increment: step;
            content: counter(step);
            width: 40px;
            height: 40px;
            line-height: 40px;
            background-color: #e9ecef;
            color: #6c757d;
            border-radius: 50%;
            display: block;
            margin: 0 auto 10px;
            font-weight: bold;
        }

        .step.active:before {
            background-color: var(--primary-color);
            color: white;
        }

        .step.completed:before {
            background-color: var(--success-color);
            color: white;
        }

        .step:not(:last-child):after {
            content: '';
            position: absolute;
            width: 100%;
            height: 3px;
            background-color: #e9ecef;
            top: 20px;
            left: 50%;
            z-index: -1;
        }

        .step.completed:not(:last-child):after {
            background-color: var(--success-color);
        }

        /* 确保Bootstrap网格在响应式布局中正常工作 */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin-left: -15px;
            margin-right: -15px;
        }

        .col-lg-8, .col-lg-4 {
            position: relative;
            width: 100%;
            padding-left: 15px;
            padding-right: 15px;
        }

        @media (min-width: 992px) {
            .col-lg-8 {
                flex: 0 0 66.666667%;
                max-width: 66.666667%;
            }
            .col-lg-4 {
                flex: 0 0 33.333333%;
                max-width: 33.333333%;
            }
        }
    </style>
    <!-- 引入Font Awesome图标 -->
    <!-- 引入Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="main-container">
<%@ include file="TabBar.jsp" %>

    <!-- 主要内容区域 -->
    <div class="main-content">
        <h1>上传 CSV 导入 IoT 数据</h1>

    <!-- 消息提示区域 -->
    <%
        String msg = (String) request.getAttribute("msg");
        String msgType = (String) request.getAttribute("msgType");

        if (msg != null && !msg.trim().isEmpty()) {
            if (msgType == null) {
                msgType = "";
            }
            String alertClass = "alert-info";
            String icon = "info-circle";

            if ("success".equals(msgType)) {
                alertClass = "alert-success";
                icon = "check-circle";
            } else if ("error".equals(msgType)) {
                alertClass = "alert-danger";
                icon = "exclamation-circle";
            }
    %>
    <div class="alert <%= alertClass %> custom-alert d-flex align-items-center" role="alert">
        <i class="fas fa-<%= icon %> fa-lg me-3"></i>
        <div><%= msg %></div>
    </div>
    <%
        }
    %>

    <div class="row">
        <!-- 上传表单区域 -->
        <div class="col-lg-8 mb-4">
            <div class="card upload-card">
                <div class="card-body p-4">
                    <h4 class="card-title mb-4">
                        <i class="fas fa-cloud-upload-alt me-2 text-primary"></i>选择 CSV 文件
                    </h4>
                    <%--重要,使用el表达式动态获取上下文路径,否则会出现找不到页面的错误--%>
                    <form action="${pageContext.request.contextPath}/CSVImportServlet" method="post" enctype="multipart/form-data" id="uploadForm">
                        <!-- 文件拖放区域 -->
                        <div class="upload-area" id="dropArea">
                            <div class="upload-icon">
                                <i class="fas fa-file-upload"></i>
                            </div>
                            <h5>拖放文件到此处或点击选择</h5>

                            <!-- 文件选择按钮 -->
                            <div class="d-grid gap-2 d-md-block">
                                <button type="button" class="btn btn-outline-primary btn-lg" id="browseBtn">
                                    <i class="fas fa-folder-open me-2"></i>浏览文件
                                </button>
                            </div>

                            <!-- 隐藏的文件输入 -->
                            <input type="file" name="csvFile" id="csvFile" accept=".csv" class="d-none" required />

                            <!-- 文件信息展示 -->
                            <div class="file-info d-none" id="fileInfo">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <i class="fas fa-file-csv text-primary me-2"></i>
                                        <span id="fileName" class="fw-bold">未选择文件</span>
                                        <span id="fileSize" class="text-muted ms-2"></span>
                                    </div>
                                    <button type="button" class="btn-close" id="removeFile" aria-label="Remove"></button>
                                </div>
                            </div>
                        </div>

                        <!-- 上传按钮 -->
                        <div class="mt-4 text-end">
                            <button type="submit" class="btn btn-upload btn-lg text-white">
                                <i class="fas fa-upload me-2"></i>上传并导入数据
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- 说明区域 -->
        <div class="col-lg-4">
            <div class="card example-card">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="fas fa-info-circle me-2 text-primary"></i>文件要求
                    </h5>
                    <ul class="requirements-list">
                        <li>必须包含 <code>date_time</code> 字段</li>
                        <li>必须包含 <code>device_name</code> 字段</li>
                        <li>包含以下字段之一
                            <ul class="mt-1">
                                <li><code>Temperature</code></li>
                                <li><code>Humidity</code></li>
                                <li><code>Smoke</code></li>
                            </ul>
                        </li>
                    </ul>

                    <hr class="my-3">

                    <h6 class="fw-bold mb-3">示例 CSV 格式：</h6>
                    <div class="code-sample">
                        "id","_time","date_time","device_id","device_name","temperature","status"
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 文件上传相关交互
    document.addEventListener('DOMContentLoaded', function() {
        const dropArea = document.getElementById('dropArea');
        const csvFile = document.getElementById('csvFile');
        const browseBtn = document.getElementById('browseBtn');
        const fileInfo = document.getElementById('fileInfo');
        const fileName = document.getElementById('fileName');
        const fileSize = document.getElementById('fileSize');
        const removeFile = document.getElementById('removeFile');
        const uploadForm = document.getElementById('uploadForm');

        // 点击浏览按钮触发文件选择
        browseBtn.addEventListener('click', () => {
            csvFile.click();
        });

        // 文件选择变化事件
        csvFile.addEventListener('change', function(e) {
            if (this.files.length > 0) {
                const file = this.files[0];
                updateFileInfo(file);
            }
        });

        // 拖放事件处理
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, highlight, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, unhighlight, false);
        });

        function highlight() {
            dropArea.classList.add('dragover');
        }

        function unhighlight() {
            dropArea.classList.remove('dragover');
        }

        // 处理文件放置
        dropArea.addEventListener('drop', function(e) {
            const dt = e.dataTransfer;
            const files = dt.files;

            if (files.length > 0) {
                csvFile.files = files;
                updateFileInfo(files[0]);
            }
        }, false);

        // 移除文件
        removeFile.addEventListener('click', function() {
            csvFile.value = '';
            fileInfo.classList.add('d-none');
            fileName.textContent = '未选择文件';
            fileSize.textContent = '';
        });

        // 更新文件信息显示
        function updateFileInfo(file) {
            fileName.textContent = file.name;

            // 格式化文件大小
            const fileSizeInBytes = file.size;
            let sizeText = '';
            if (fileSizeInBytes < 1024) {
                sizeText = fileSizeInBytes + ' B';
            } else if (fileSizeInBytes < 1024 * 1024) {
                sizeText = (fileSizeInBytes / 1024).toFixed(2) + ' KB';
            } else {
                sizeText = (fileSizeInBytes / (1024 * 1024)).toFixed(2) + ' MB';
            }
            fileSize.textContent = '(' + sizeText + ')';

            fileInfo.classList.remove('d-none');
        }

        // 表单提交验证
        uploadForm.addEventListener('submit', function(e) {
            if (!csvFile.files || csvFile.files.length === 0) {
                e.preventDefault();
                alert('请先选择CSV文件');
                return false;
            }

            const file = csvFile.files[0];

            // 验证文件类型
            const fileName = file.name.toLowerCase();
            if (!fileName.endsWith('.csv')) {
                e.preventDefault();
                alert('请选择CSV格式的文件');
                return false;
            }
        });
    });
</script>
</body>
</html>