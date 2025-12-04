<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>IoT 数据可视化系统</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@6.0.0/dist/echarts.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.min.css">
    <style>
        body { background-color: #f9fafb; }

        .dashboard {
            display: flex;
            gap: 20px;
            position: relative;
        }

        /* ======== 修改部分：固定侧边栏 ======== */
        .sidebar {
            width: 180px;
            background: linear-gradient(135deg, #2c3e50, #3498db);
            border-radius: 8px;
            padding: 1rem;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            position: fixed;          /* 固定定位 */
            top: 250px;               /* 距离页面顶部距离，根据Header高度调整 */
            left: 50px;               /* 距离左边距离 */
            z-index: 1000;            /* 确保浮在上层 */
        }

        /* 图表区域向右留出侧边栏宽度 */
        .charts {
            flex: 1;
            margin-left: 220px;       /* 留出侧边栏宽度+间距 */
        }

        .sidebar h3 { font-size: 1.1rem; margin-bottom: 0.5rem; }

        .device-btn {
            display: block;
            width: 100%;
            margin: 0.3rem 0;
            padding: 0.4rem 0.6rem;
            border: 1px solid #ccc;
            border-radius: 4px;
            background: #f0f0f0;
            text-align: center;
            cursor: pointer;
        }

        .device-btn.active {
            background-color: #00B4F4;
            color: white;
            font-weight: bold;
        }

        .chart-box {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            padding: 1rem;
        }

        .chart-title { margin-bottom: 0.5rem; }
    </style>
</head>
<body>

<%@ include file="Header.jsp" %>

<main class="container" style="max-width: 1400px;">
    <h2>IoT 环境监测仪表板</h2>
    <div class="dashboard">
        <!-- 左侧设备切换按钮 -->
        <div class="sidebar">
            <h3>选择设备</h3>
            <button class="device-btn active" data-device="L101">L101</button>
            <button class="device-btn" data-device="L102">L102</button>
            <button class="device-btn" data-device="L201">L201</button>
            <button class="device-btn" data-device="L202">L202</button>
            <button class="device-btn" data-device="L203">L203</button>
        </div>

        <!-- 图表区域 -->
        <div class="charts">
            <div class="chart-box">
                <h3 class="chart-title">温度趋势图</h3>
                <div id="tempChart" style="width:100%;height:400px;"></div>
            </div>

            <div class="chart-box">
                <h3 class="chart-title">温湿度曲线</h3>
                <div id="humChart" style="width:100%;height:400px;"></div>
            </div>

            <div class="chart-box">
                <h3 class="chart-title">烟雾报警事件</h3>
                <div id="smokeChart" style="width:100%;height:400px;"></div>
            </div>
        </div>
    </div>
</main>

<%@ include file="Footer.jsp" %>

<script>
    // 从 JSP 注入上下文路径
    const contextPath = '${pageContext.request.contextPath}';
    let currentDevice = 'L101';

    // ======== 温度图 ========
    const tempChart = echarts.init(document.getElementById('tempChart'));
    function loadTemperature(device) {
        fetch(contextPath + '/TemperatureServlet?deviceName=' + device)
            .then(r => r.json())
            .then(data => {
                tempChart.setOption({
                    title: { text: '温度趋势图（设备 ' + device + '）' },
                    tooltip: { trigger: 'axis' },
                    xAxis: { type: 'category', data: data.time },
                    yAxis: { type: 'value', name: '温度(°C)', min: 20, max: 25, splitNumber: 5 },
                    series: [{ type: 'line', name: '温度', data: data.value, smooth: true }],
                    dataZoom: [{ type: 'slider', start: 0, end: 2 }]
                });
            });
    }

    // ======== 温湿度双Y轴 ========
    const humChart = echarts.init(document.getElementById('humChart'));
    function loadTempHumidity(device) {
        Promise.all([
            fetch(contextPath + '/TemperatureServlet?deviceName=' + device).then(r => r.json()),
            fetch(contextPath + '/HumidityServlet?deviceName=' + device).then(r => r.json())
        ]).then(([temp, hum]) => {
            humChart.setOption({
                title: { text: '温湿度曲线（设备 ' + device + '）' },
                tooltip: { trigger: 'axis' },
                legend: { data: ['温度', '湿度'] },
                xAxis: { type: 'category', data: temp.time },
                yAxis: [
                    { type: 'value', name: '温度(°C)', position: 'left', min: 20, max: 25, splitNumber: 5 },
                    { type: 'value', name: '湿度(%)', position: 'right', min: 45, max: 55, splitNumber: 5 }
                ],
                series: [
                    { name: '温度', type: 'line', yAxisIndex: 0, data: temp.value, smooth: true },
                    { name: '湿度', type: 'line', yAxisIndex: 1, data: hum.value, smooth: true }
                ],
                dataZoom: [{ type: 'slider', start: 0, end: 2 }]
            });
        });
    }

    // ======== 烟雾散点报警 ========
    const smokeChart = echarts.init(document.getElementById('smokeChart'));
    function loadSmoke(device) {
        fetch(contextPath + '/SmokeServlet?deviceName=' + device)
            .then(r => r.json())
            .then(data => {
                const threshold = 50;
                smokeChart.setOption({
                    title: { text: '烟雾报警事件（设备 ' + device + '）' },
                    tooltip: { trigger: 'item' },
                    xAxis: { type: 'category', data: data.time },
                    yAxis: { type: 'value', name: '烟雾值' },
                    series: [{
                        name: '烟雾浓度',
                        type: 'scatter',
                        data: data.time.map((t, i) => [t, data.value[i]]),
                        symbolSize: val => val[1] > threshold ? 12 : 6,
                        itemStyle: {
                            color: val => val.value[1] > threshold ? 'red' : '#007bff'
                        },
                        markLine: {
                            data: [{ yAxis: threshold, name: '报警阈值' }],
                            lineStyle: { color: 'red', type: 'dashed' }
                        }
                    }],
                    dataZoom: [{ type: 'slider', start: 0, end: 2 }]
                });
            });
    }

    // ======== 按钮事件 ========
    document.querySelectorAll('.device-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.device-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentDevice = btn.dataset.device;
            loadTemperature(currentDevice);
            loadTempHumidity(currentDevice);
            loadSmoke(currentDevice);
        });
    });

    // 默认加载
    loadTemperature(currentDevice);
    loadTempHumidity(currentDevice);
    loadSmoke(currentDevice);
</script>

</body>
</html>
