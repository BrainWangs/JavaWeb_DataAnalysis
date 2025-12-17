<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - ULS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            --primary-gradient-hover: linear-gradient(135deg, #0a58ca 0%, #084298 100%);
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        /* 导航栏样式 */
        .navbar-custom {
            background: var(--primary-gradient) !important;
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
        }

        .login-logo {
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #0d6efd;
            margin-right: 10px;
            font-size: 0.9rem;
        }

        /* 卡片交互样式 - 核心要求 */
        .login-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease; /* 添加平滑过渡 */
            background: white;
        }

        /* 鼠标悬停时的交互效果 */
        .login-card:hover {
            transform: translateY(-5px); /* 上浮效果 */
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15); /* 阴影加深 */
        }

        .card-header-custom {
            background: var(--primary-gradient);
            color: white;
            padding: 1.5rem;
            border-bottom: none;
        }

        /* 按钮样式 */
        .btn-primary-custom {
            background: var(--primary-gradient) !important;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            background: var(--primary-gradient-hover) !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(13, 110, 253, 0.3);
        }

        .btn-primary-custom:active {
            transform: translateY(0);
        }

        /* 输入框聚焦效果 */
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .main-container {
            flex: 1;
            display: flex;
            align-items: center;
            padding: 2rem 0;
        }

        /* 错误消息动画 */
        .alert-message {
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="#">
            <div class="login-logo">ULS</div>
            <span class="fw-bold">用户登录系统</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/view/Login.jsp">登录</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="#">注册</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">帮助</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="main-container">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card login-card">
                    <div class="card-header card-header-custom text-center">
                        <h3 class="mb-0"><i class="bi bi-person-plus-fill me-2"></i>用户注册</h3>
                    </div>

                    <div class="card-body p-4 p-md-5">

                        <% if (request.getAttribute("msg") != null) { %>
                        <div class="alert <%= "success".equals(request.getAttribute("msgType")) ? "alert-success" : "alert-danger" %> alert-dismissible fade show alert-message" role="alert">
                            <i class="bi <%= "success".equals(request.getAttribute("msgType")) ? "bi-check-circle-fill" : "bi-exclamation-triangle-fill" %> me-2"></i>
                            <%= request.getAttribute("msg") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>

                        <form action="${pageContext.request.contextPath}/UserSignInServlet" method="post" id="registerForm">

                            <div class="mb-4">
                                <label for="username" class="form-label fw-semibold">用户名</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="username" name="username"
                                           placeholder="设置您的用户名" required autofocus>
                                </div>
                                <div class="invalid-feedback" id="usernameFeedback"></div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold">密码</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="请输入6位以上密码" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label fw-semibold">确认密码</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                           placeholder="请再次输入密码" required>
                                </div>
                                <div class="invalid-feedback" id="passwordFeedback"></div>
                            </div>

                            <button type="submit" class="btn btn-primary-custom btn-lg w-100 py-3 fw-semibold mt-2">
                                <i class="bi bi-check-lg me-2"></i>立即注册
                            </button>
                        </form>

                        <div class="text-center mt-4 pt-3 border-top">
                            <p class="mb-0">已有账号？
                                <a href="${pageContext.request.contextPath}/view/Login.jsp" class="text-decoration-none fw-semibold">立即登录</a>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4 text-muted small">
                    <p>© 2023 用户管理系统. 版权所有.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registerForm');
        const passwordInput = document.getElementById('password');
        const confirmInput = document.getElementById('confirmPassword');
        const passwordFeedback = document.getElementById('passwordFeedback');

        // 表单提交验证
        form.addEventListener('submit', function(e) {
            let isValid = true;

            // 重置样式
            passwordInput.classList.remove('is-invalid');
            confirmInput.classList.remove('is-invalid');

            const password = passwordInput.value;
            const confirm = confirmInput.value;

            // 验证长度
            if (password.length < 6) {
                e.preventDefault();
                passwordInput.classList.add('is-invalid');
                showError(passwordInput, '密码长度不能少于6位'); // 也可以复用下方的showError逻辑
                isValid = false;
            }

            // 验证一致性
            if (password !== confirm) {
                e.preventDefault();
                confirmInput.classList.add('is-invalid');
                passwordFeedback.textContent = '两次输入的密码不一致';
                passwordFeedback.style.display = 'block';
                isValid = false;
            }

            if (!isValid) return false;
        });

        // 实时消除错误状态
        [passwordInput, confirmInput].forEach(input => {
            input.addEventListener('input', function() {
                this.classList.remove('is-invalid');
                if(this.id === 'confirmPassword') {
                    passwordFeedback.style.display = 'none';
                }
            });
        });

        function showError(input, msg) {
            alert(msg);
        }
    });
</script>
</body>
</html>