<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>IoT 数据可视化系统</title>
    <!-- 引入Bootstrap 5 CSS -->
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
            /*font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;*/
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        /* 主内容区域布局 */
        .main-content {
            margin-top: var(--topbar-height);
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: calc(100vh - var(--topbar-height));
            transition: all 0.3s ease;
        }

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }

        /* 标题区域 */
        .page-header {
            margin-bottom: 30px;
        }

        /* 卡片样式 */
        .chart-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            border: none;
            margin-bottom: 25px;
            transition: transform 0.2s ease;
            height: 35%;
        }

        .chart-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }

        .chart-header {
            padding: 20px 25px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .chart-title {
            margin: 0;
            font-size: 1.1rem;
            font-weight: 600;
        }

        .chart-body {
            padding: 20px;
        }

        /* 设备控制面板 */
        .device-control-card {
            background: white;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            border: none;
            position: sticky;
            top: 80px; /* 当向下滚动时，固定在顶部 */
        }

        .device-btn {
            text-align: left;
            padding: 15px 20px;
            border: 1px solid #eee;
            margin-bottom: 10px;
            border-radius: 8px;
            transition: all 0.2s ease;
            background-color: #fff;
            color: #555;
            position: relative;
            overflow: hidden;
        }

        .device-btn:hover {
            background-color: #f8f9fa;
            border-color: var(--primary-color);
            transform: translateX(5px);
        }

        .device-btn.active {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            color: white;
            border: none;
            box-shadow: 0 4px 10px rgba(67, 97, 238, 0.3);
        }

        .device-status {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #ddd;
            display: inline-block;
            margin-right: 10px;
        }

        .device-btn.active .device-status {
            background-color: #00ff88;
            box-shadow: 0 0 5px #00ff88;
        }

        /* 移动端优化 */
        @media (max-width: 991px) {
            .device-control-card {
                position: static; /* 移动端取消吸顶 */
                margin-bottom: 30px;
            }

            /* 横向排列设备按钮 */
            .device-list-container {
                display: flex;
                overflow-x: auto;
                gap: 10px;
                padding-bottom: 5px;
            }

            .device-btn {
                margin-bottom: 0;
                min-width: 140px;
                white-space: nowrap;
            }

            .device-btn:hover {
                transform: translateY(-2px);
            }
        }
    </style>
</head>
<body>

<%@ include file="TabBar.jsp" %>

<main class="main-content">

    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold text-dark mb-1">环境监测仪表板</h2>
            <p class="text-muted mb-0">实时监控各设备运行状态与环境数据</p>
        </div>
    </div>

    <div class="row">

        <!-- 左侧：图表区域 (在大屏占9份宽度) -->
        <div class="col-lg-9 order-2 order-lg-1">

            <!-- 温度趋势 -->
            <div class="chart-card">
                <div class="chart-header">
                    <h3 class="chart-title text-primary">
                        <i class="fas fa-temperature-high me-2"></i>温度趋势图
                    </h3>
                </div>
                <div class="chart-body">
                    <div id="tempChart" style="width:100%;height:350px;"></div>
                </div>
            </div>

            <!-- 温湿度对比 -->
            <div class="chart-card">
                <div class="chart-header">
                    <h3 class="chart-title text-success">
                        <i class="fas fa-tint me-2"></i>温湿度关联分析
                    </h3>
                </div>
                <div class="chart-body">
                    <div id="humChart" style="width:100%;height:350px;"></div>
                </div>
            </div>

            <!-- 烟雾报警 -->
            <div class="chart-card">
                <div class="chart-header">
                    <h3 class="chart-title text-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>烟雾报警监控
                    </h3>
                </div>
                <div class="chart-body">
                    <div id="smokeChart" style="width:100%;height:350px;"></div>
                </div>
            </div>

        </div>

        <!-- 右侧：设备控制 (在大屏占3份宽度) -->
        <div class="col-lg-3 order-1 order-lg-2 mb-4">
            <div class="device-control-card">
                <div class="p-3 border-bottom bg-light rounded-top">
                    <h5 class="mb-0 fw-bold">设备列表</h5>
                    <small class="text-muted">点击切换监控视图</small>
                </div>

                <div class="p-3 device-list-container">
                    <button class="device-btn w-100 active" data-device="L101">
                        <div class="d-flex align-items-center">
                            <span class="device-status"></span>
                            <div>
                                <div class="fw-bold">设备 L101</div>
                                <small class="opacity-75" style="font-size: 0.75rem;">在线</small>
                            </div>
                        </div>
                    </button>

                    <button class="device-btn w-100" data-device="L102">
                        <div class="d-flex align-items-center">
                            <span class="device-status"></span>
                            <div>
                                <div class="fw-bold">设备 L102</div>
                                <small class="text-muted" style="font-size: 0.75rem;">在线</small>
                            </div>
                        </div>
                    </button>

                    <button class="device-btn w-100" data-device="L201">
                        <div class="d-flex align-items-center">
                            <span class="device-status"></span>
                            <div>
                                <div class="fw-bold">设备 L201</div>
                                <small class="text-muted" style="font-size: 0.75rem;">在线</small>
                            </div>
                        </div>
                    </button>

                    <button class="device-btn w-100" data-device="L202">
                        <div class="d-flex align-items-center">
                            <span class="device-status"></span>
                            <div>
                                <div class="fw-bold">设备 L202</div>
                                <small class="text-muted" style="font-size: 0.75rem;">在线</small>
                            </div>
                        </div>
                    </button>

                    <button class="device-btn w-100" data-device="L203">
                        <div class="d-flex align-items-center">
                            <span class="device-status"></span>
                            <div>
                                <div class="fw-bold">设备 L203</div>
                                <small class="text-muted" style="font-size: 0.75rem;">在线</small>
                            </div>
                        </div>
                    </button>
                </div>
            </div>

        </div>

    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/echarts@6.0.0/dist/echarts.min.js"></script>
<script>
    // 从 JSP 注入上下文路径
    const contextPath = '${pageContext.request.contextPath}';
    let currentDevice = 'L101';

    // 通用图表配置，保持风格统一
    const chartCommonOption = {
        grid: { left: '3%', right: '4%', bottom: 60, containLabel: true },
        animationDuration: 1000
    };

    // ======== 温度图 ========
    const tempChart = echarts.init(document.getElementById('tempChart'));
    function loadTemperature(device) {
        tempChart.showLoading();
        fetch(contextPath + '/TemperatureServlet?deviceName=' + device)
            .then(r => r.json())
            .then(data => {
                tempChart.hideLoading();
                tempChart.setOption({
                    ...chartCommonOption,
                    tooltip: { trigger: 'axis', backgroundColor: 'rgba(255,255,255,0.9)', borderColor: '#eee' },
                    xAxis: { type: 'category', data: data.time, boundaryGap: false },
                    yAxis: { type: 'value', name: '温度(°C)' , min: 20, max: 25, splitNumber: 5},
                    dataZoom: [
                        {
                            type: 'slider',
                            start: 0,
                            end: 2
                        }],
                    series: [{
                        type: 'line',
                        name: '温度',
                        data: data.value,
                        smooth: true,
                        itemStyle: { color: '#4361ee' },
                        areaStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: 'rgba(67, 97, 238, 0.5)' },
                                { offset: 1, color: 'rgba(67, 97, 238, 0.01)' }
                            ])
                        }
                    }]
                });
            })
            .catch(() => tempChart.hideLoading());
    }

    // ======== 温湿度双Y轴 ========
    const humChart = echarts.init(document.getElementById('humChart'));
    function loadTempHumidity(device) {
        humChart.showLoading();
        Promise.all([
            fetch(contextPath + '/TemperatureServlet?deviceName=' + device).then(r => r.json()),
            fetch(contextPath + '/HumidityServlet?deviceName=' + device).then(r => r.json())
        ]).then(([temp, hum]) => {
            humChart.hideLoading();
            humChart.setOption({
                ...chartCommonOption,
                tooltip: { trigger: 'axis' },
                legend: { data: ['温度', '湿度'], bottom: '0%' },
                xAxis: { type: 'category', data: temp.time },
                yAxis: [
                    { type: 'value', name: '温度(°C)', position: 'left',min: 20, max: 25, splitNumber: 5, axisLine: {show: true, lineStyle: {color: '#4361ee'}} },
                    { type: 'value', name: '湿度(%)', position: 'right', min: 45, max: 55, splitNumber: 5, axisLine: {show: true, lineStyle: {color: '#4cc9f0'}} }
                ],
                series: [
                    { name: '温度', type: 'line', yAxisIndex: 0, data: temp.value, smooth: true, itemStyle: { color: '#4361ee' } },
                    { name: '湿度', type: 'line', yAxisIndex: 1, data: hum.value, smooth: true, itemStyle: { color: '#4cc9f0' } }
                ],
                dataZoom: [{ type: 'slider', start: 0, end: 2 }]
            });
        });
    }

    // ======== 烟雾散点报警 ========
    const smokeChart = echarts.init(document.getElementById('smokeChart'));
    function loadSmoke(device) {
        smokeChart.showLoading();
        fetch(contextPath + '/SmokeServlet?deviceName=' + device)
            .then(r => r.json())
            .then(data => {
                smokeChart.hideLoading();
                const threshold = 50;
                smokeChart.setOption({
                    ...chartCommonOption,
                    tooltip: {
                        trigger: 'item',
                        formatter: function (params) {
                            return params.seriesName + '<br/>' + params.value[0] + ' : ' + params.value[1];
                        }
                    },
                    xAxis: { type: 'category', data: data.time },
                    yAxis: { type: 'value', name: '烟雾值' },
                    visualMap: {
                        show: false,
                        dimension: 1,
                        pieces: [{ gt: 0, lte: threshold, color: '#4cc9f0' }, { gt: threshold, color: '#f72585' }]
                    },
                    series: [{
                        name: '烟雾浓度',
                        type: 'scatter',
                        data: data.time.map((t, i) => [t, data.value[i]]),
                        symbolSize: val => val[1] > threshold ? 15 : 8,
                    }],
                    dataZoom: [{ type: 'slider', start: 0, end: 2}]
                });
            });
    }

    // ======== 按钮事件 ========
    document.querySelectorAll('.device-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.device-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            // 更新当前设备状态文本（模拟）
            document.querySelectorAll('.device-btn small').forEach(s => s.className = 'text-muted');
            const smallText = btn.querySelector('small');
            if(smallText) smallText.className = 'text-white opacity-75';

            currentDevice = btn.dataset.device;
            loadTemperature(currentDevice);
            loadTempHumidity(currentDevice);
            loadSmoke(currentDevice);

            // 移动端：点击后自动滚动到图表区域
            if(window.innerWidth < 992) {
                document.querySelector('.col-lg-9').scrollIntoView({behavior: 'smooth'});
            }
        });
    });

    // 窗口大小改变时重绘图表
    window.addEventListener('resize', function() {
        tempChart.resize();
        humChart.resize();
        smokeChart.resize();
    });

    // 默认加载
    loadTemperature(currentDevice);
    loadTempHumidity(currentDevice);
    loadSmoke(currentDevice);
</script>

</body>
</html>