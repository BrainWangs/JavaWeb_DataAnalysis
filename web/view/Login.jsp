<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录系统</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            --primary-gradient-hover: linear-gradient(135deg, #0a58ca 0%, #084298 100%);
        }

        .navbar-custom {
            background: var(--primary-gradient) !important;
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.2);
        }

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

        .login-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .login-card:hover {
            transform: translateY(-5px);
        }

        .card-header-custom {
            background: var(--primary-gradient);
            color: white;
            padding: 1.5rem;
            border-bottom: none;
        }

        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .login-container {
            min-height: calc(100vh - 76px);
            display: flex;
            align-items: center;
            padding: 2rem 0;
        }

        .login-logo {
            width: 50px;
            height: 50px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #0d6efd;
            margin-right: 10px;
        }

        .footer {
            background: #f8f9fa;
            padding: 1rem 0;
            margin-top: auto;
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .error-message {
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<!-- 顶栏导航 -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="#">
            <div class="login-logo">SYS</div>
            <span class="fw-bold">用户登录系统</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="#">登录</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">注册</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">帮助</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- 主要内容区域 -->
<div class="login-container">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card login-card">
                    <div class="card-header card-header-custom text-center">
                        <h3 class="mb-0"><i class="bi bi-person-circle me-2"></i>用户登录</h3>
                        <p class="mb-0 opacity-75">请使用您的账户登录系统</p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <form action="LoginServlet" method="post">
                            <div class="mb-4">
                                <label for="username" class="form-label fw-semibold">用户名</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-person"></i>
                                        </span>
                                    <input type="text"
                                           class="form-control"
                                           id="username"
                                           name="username"
                                           placeholder="请输入用户名"
                                           required>
                                </div>
                                <div class="form-text">请输入注册时使用的用户名</div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold">密码</label>
                                <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="bi bi-lock"></i>
                                        </span>
                                    <input type="password"
                                           class="form-control"
                                           id="password"
                                           name="password"
                                           placeholder="请输入密码"
                                           required>
                                </div>
                                <div class="form-text">密码区分大小写，请谨慎输入</div>
                            </div>

                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="rememberMe">
                                <label class="form-check-label" for="rememberMe">记住登录状态</label>
                            </div>

                            <button type="submit" class="btn btn-primary-custom btn-lg w-100 py-3 fw-semibold">
                                <i class="bi bi-box-arrow-in-right me-2"></i>登录系统
                            </button>

                            <!-- 错误消息显示 -->
                            <% if(request.getAttribute("msg") != null) { %>
                            <div class="alert alert-danger mt-4 error-message" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("msg") %>
                            </div>
                            <% } %>
                        </form>

                        <div class="text-center mt-4 pt-3 border-top">
                            <p class="mb-2">没有账户？ <a href="#" class="text-decoration-none fw-semibold">立即注册</a></p>
                            <p class="mb-0"><a href="#" class="text-decoration-none">忘记密码？</a></p>
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

<!-- Bootstrap 5 JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

<script>
    // 表单验证增强
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('form');
        const usernameInput = document.getElementById('username');
        const passwordInput = document.getElementById('password');

        form.addEventListener('submit', function(event) {
            let isValid = true;

            // 清除之前的验证样式
            usernameInput.classList.remove('is-invalid');
            passwordInput.classList.remove('is-invalid');

            // 用户名验证
            if (!usernameInput.value.trim()) {
                usernameInput.classList.add('is-invalid');
                isValid = false;
            }

            // 密码验证
            if (!passwordInput.value.trim()) {
                passwordInput.classList.add('is-invalid');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();

                // 显示错误提示
                if (!usernameInput.value.trim()) {
                    showError(usernameInput, '请输入用户名');
                }
                if (!passwordInput.value.trim()) {
                    showError(passwordInput, '请输入密码');
                }
            }
        });

        function showError(input, message) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'invalid-feedback d-block';
            errorDiv.textContent = message;

            const parent = input.parentElement;
            if (!parent.querySelector('.invalid-feedback')) {
                parent.appendChild(errorDiv);
            }
        }

        // 实时验证
        usernameInput.addEventListener('input', function() {
            this.classList.remove('is-invalid');
        });

        passwordInput.addEventListener('input', function() {
            this.classList.remove('is-invalid');
        });
    });
</script>
</body>
</html>
