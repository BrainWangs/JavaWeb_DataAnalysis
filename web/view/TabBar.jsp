<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bootstrap 侧边栏与导航栏</title>
    <!-- 引入Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入Bootstrap 图标库 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-width: 240px;
            --sidebar-collapsed-width: 60px;
            --navbar-height: 60px;
        }

        body {
            /* 防止侧边栏动画导致水平滚动条 */
            overflow-x: hidden;
        }

        /* 顶部导航栏样式 */
        .navbar-custom {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            height: var(--navbar-height);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            color: white;
            font-weight: 600;
            font-size: 1.5rem;
        }

        .navbar-nav .nav-link {
            color: rgba(255, 255, 255, 0.9);
            padding: 0.5rem 1rem;
            transition: color 0.2s;
        }

        .navbar-nav .nav-link:hover {
            color: white;
        }

        .navbar-toggler {
            border-color: rgba(255, 255, 255, 0.5);
            z-index: 1040; /* 确保按钮在展开的菜单之上，防止点击失效 */
        }

        .navbar-toggler-icon {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.9%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
        }

        /* 侧边栏样式 */
        .sidebar {
            position: fixed;
            top: var(--navbar-height);
            left: 0;
            height: calc(100vh - var(--navbar-height));
            width: var(--sidebar-width);
            background-color: #f8f9fa;
            transition: all 0.3s ease;
            padding: 20px 0;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            z-index: 1020;
            overflow-y: auto;
        }

        .sidebar.toggled {
            width: var(--sidebar-collapsed-width);
        }

        /* 侧边栏切换按钮样式 - 集成在侧边栏右上角 */
        .sidebar-toggle-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 30px;
            height: 30px;
            background-color: #0d6efd;
            color: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1030;
            transition: all 0.3s ease;
        }

        .sidebar-toggle-btn:hover {
            background-color: #0b5ed7;
        }

        /* 侧边栏导航项样式 */
        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 20px;
            text-align: center;
        }

        .sidebar-header h5 {
            font-weight: 600;
            color: #343a40;
            margin: 0;
            white-space: nowrap;
            overflow: hidden;
        }

        .sidebar.toggled .sidebar-header h5 {
            opacity: 0;
            width: 0;
        }

        .sidebar-nav {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-nav .nav-item {
            position: relative;
        }

        .sidebar-nav .nav-link {
            color: #495057;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: all 0.2s;
            text-decoration: none;
            border-left: 3px solid transparent;
        }

        .sidebar-nav .nav-link:hover {
            background-color: #e9ecef;
            color: #0d6efd;
        }

        /* 激活状态样式 */
        .sidebar-nav .nav-link.active {
            background-color: #e3f2fd;
            color: #0d6efd;
            border-left: 3px solid #0d6efd;
            font-weight: 500;
        }

        .sidebar-nav .nav-icon {
            font-size: 1.2rem;
            min-width: 40px;
        }

        .sidebar-nav .nav-text {
            white-space: nowrap;
            transition: opacity 0.3s;
        }

        .sidebar.toggled .sidebar-nav .nav-text {
            opacity: 0;
            width: 0;
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                width: 280px;
            }

            .sidebar.mobile-open {
                transform: translateX(0);
            }

            .sidebar-toggle-btn {
                display: none;
            }

            /* 移动端导航栏折叠菜单样式 */
            .navbar-collapse {
                background-color: rgba(13, 110, 253, 0.98); /* 不透明度提高 */
                padding: 15px;
                border-radius: 0 0 8px 8px;
                position: absolute;
                top: var(--navbar-height);
                left: 0;
                right: 0;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .navbar-nav .dropdown-menu {
                background-color: rgba(255, 255, 255, 0.1);
                border: none;
            }

            .navbar-nav .dropdown-item {
                color: rgba(255, 255, 255, 0.9);
            }
        }

        @media (min-width: 769px) {
            /* 桌面端隐藏移动端侧边栏切换按钮 */
            #mobileSidebarToggle {
                display: none;
            }
        }
    </style>
</head>
<body>

<!-- 顶部导航栏 -->
<nav class="navbar navbar-custom navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <i class="bi bi-layout-sidebar-inset"></i> 数据可视化系统
        </a>

        <!-- 移动端汉堡菜单按钮 - 优化了点击事件处理 -->
        <button class="navbar-toggler" type="button" id="mainNavbarToggler" aria-label="切换导航菜单">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <i class="bi bi-bell"></i> 通知
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <i class="bi bi-gear"></i> 设置
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                       aria-expanded="false">
                        <i class="bi bi-person-circle"></i> 用户
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#">个人资料</a></li>
                        <li><a class="dropdown-item" href="#">账户设置</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#">退出登录</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- 侧边栏 -->
<div class="sidebar" id="sidebar">
    <!-- 桌面端侧边栏收缩按钮 -->
    <div class="sidebar-toggle-btn" id="sidebarToggleBtn">
        <i class="bi bi-chevron-left"></i>
    </div>

    <!-- 侧边栏内容 -->
    <div class="sidebar-header">
        <h5>导航菜单</h5>
    </div>

    <ul class="sidebar-nav">
        <!-- 注意：移除了 active 类，由 JS 动态添加 -->
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/view/DataQuery.jsp">
                <i class="bi bi-search nav-icon"></i>
                <span class="nav-text">数据查询</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/view/DataVisualize.jsp">
                <i class="bi bi-bar-chart nav-icon"></i>
                <span class="nav-text">数据视图</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/view/ImportData.jsp">
                <i class="bi bi-box-arrow-in-down nav-icon"></i>
                <span class="nav-text">数据导入</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="bi bi-file-earmark-text nav-icon"></i>
                <span class="nav-text">用户管理</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="bi bi-gear nav-icon"></i>
                <span class="nav-text">系统设置</span>
            </a>
        </li>
    </ul>
</div>

<!-- 移动端侧边栏浮动开关 -->
<button class="btn btn-primary d-lg-none" id="mobileSidebarToggle" style="position: fixed; bottom: 20px; right: 20px; z-index: 1040; width: 50px; height: 50px; border-radius: 25px; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
    <i class="bi bi-list"></i>
</button>

<!-- 引入Bootstrap JS (确保在页面底部) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {

        // ==========================================
        // 1. 自动高亮当前页面的侧边栏链接
        // ==========================================
        function highlightActiveLink() {
            const currentPath = window.location.pathname;
            // 获取所有侧边栏链接
            const navLinks = document.querySelectorAll('.sidebar-nav .nav-link');

            navLinks.forEach(link => {
                // 移除所有 active 类
                link.classList.remove('active');

                const href = link.getAttribute('href');
                if (href && href !== '#' && currentPath.includes(href)) {
                    link.classList.add('active');
                }
            });
        }
        highlightActiveLink();

        // ==========================================
        // 2. 修复右上角菜单 (Navbar Toggler) 无法关闭的问题
        // ==========================================
        const navbarToggler = document.getElementById('mainNavbarToggler');
        const navbarCollapse = document.getElementById('navbarNav');

        if (navbarToggler && navbarCollapse) {
            // 使用 Bootstrap 5 的 Collapse API 手动控制
            // 避免 data-bs-toggle 某些情况下的冲突
            const bsCollapse = new bootstrap.Collapse(navbarCollapse, {
                toggle: false // 初始化时不切换
            });

            navbarToggler.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                if (navbarCollapse.classList.contains('show')) {
                    bsCollapse.hide();
                } else {
                    bsCollapse.show();
                }
            });

            // 点击页面其他地方自动关闭顶部菜单
            document.addEventListener('click', function(e) {
                if (navbarCollapse.classList.contains('show') &&
                    !navbarCollapse.contains(e.target) &&
                    !navbarToggler.contains(e.target)) {
                    bsCollapse.hide();
                }
            });
        }

        // ==========================================
        // 3. 侧边栏 (Sidebar) 逻辑
        // ==========================================

        // 桌面端折叠/展开
        const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
        if (sidebarToggleBtn) {
            sidebarToggleBtn.addEventListener('click', function() {
                const sidebar = document.getElementById('sidebar');
                const mainContent = document.querySelector('.main-content'); // 兼容新旧ID
                const toggleIcon = document.querySelector('#sidebarToggleBtn i');

                sidebar.classList.toggle('toggled');

                // 如果存在 mainContent，同步调整 margin
                if (mainContent) {
                    // 检查当前是否在桌面模式
                    if (window.innerWidth > 768) {
                        if (sidebar.classList.contains('toggled')) {
                            mainContent.style.marginLeft = 'var(--sidebar-collapsed-width)';
                        } else {
                            mainContent.style.marginLeft = 'var(--sidebar-width)';
                        }
                    }
                }

                // 切换图标方向
                if (sidebar.classList.contains('toggled')) {
                    toggleIcon.classList.remove('bi-chevron-left');
                    toggleIcon.classList.add('bi-chevron-right');
                } else {
                    toggleIcon.classList.remove('bi-chevron-right');
                    toggleIcon.classList.add('bi-chevron-left');
                }
            });
        }

        // 移动端侧边栏呼出
        const mobileSidebarToggle = document.getElementById('mobileSidebarToggle');
        if (mobileSidebarToggle) {
            mobileSidebarToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                const sidebar = document.getElementById('sidebar');
                sidebar.classList.toggle('mobile-open');
            });
        }

        // 移动端：点击主区域关闭侧边栏
        document.addEventListener('click', function(e) {
            if (window.innerWidth <= 768) {
                const sidebar = document.getElementById('sidebar');
                const mobileBtn = document.getElementById('mobileSidebarToggle');

                // 如果侧边栏打开，且点击的不是侧边栏本身，也不是打开按钮
                if (sidebar.classList.contains('mobile-open') &&
                    !sidebar.contains(e.target) &&
                    (!mobileBtn || !mobileBtn.contains(e.target))) {
                    sidebar.classList.remove('mobile-open');
                }
            }
        });
    });
</script>
</body>
</html>