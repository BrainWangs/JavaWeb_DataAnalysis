<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>IoT 数据可视化系统</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@6.0.0/dist/echarts.min.js"></script>
</head>
<body>
<%@ include file="Header.jsp" %>

<main class="container" style="width: 100%; margin: 0 auto; max-width: 1200px; padding: 0 20px;">
    <h2>IoT 环境监测仪表板</h2>
    <div id="tempChart" style="width:100%;height:400px;"></div>
    <div id="humChart" style="width:100%;height:400px;margin-top:50px;"></div>
    <div id="smokeChart" style="width:100%;height:400px;margin-top:50px;"></div>
</main>

<%@ include file="Footer.jsp" %>

<script>
    // ======== 温度折线图 ========
    fetch('${pageContext.request.contextPath}/TemperatureServlet')
        .then(r => r.json())
        .then(data => {
            const chart = echarts.init(document.getElementById('tempChart'));
            const option = {
                title: { text: '温度趋势图' },
                tooltip: { trigger: 'axis' },
                xAxis: { type: 'category', data: data.time },
                yAxis: { type: 'value', name: '温度(°C)', min: 20, max: 26, splitNumber: 5 },
                series: [{ name: '温度', type: 'line', smooth: true, sampling: 'lttb', data: data.value }]
            };
            chart.setOption(option);
        });

    // ======== 温湿度双Y轴 ========
    Promise.all([
        fetch('${pageContext.request.contextPath}/TemperatureServlet').then(r => r.json()),
        fetch('${pageContext.request.contextPath}/HumidityServlet').then(r => r.json())
    ]).then(([temp, hum]) => {
        const chart = echarts.init(document.getElementById('humChart'));
        const option = {
            title: { text: '温湿度变化曲线' },
            tooltip: { trigger: 'axis' },
            legend: { data: ['温度', '湿度'] },
            xAxis: { type: 'category', data: temp.time },
            yAxis: [
                { type: 'value', name: '温度(°C)', min: 20, max: 26, splitNumber: 5, position: 'left' },
                { type: 'value', name: '湿度(%)', min: 45, max: 55, splitNumber: 5, position: 'right' }
            ],
            series: [
                { name: '温度', type: 'line', yAxisIndex: 0, data: temp.value },
                { name: '湿度', type: 'line', yAxisIndex: 1, data: hum.value }
            ]
        };
        chart.setOption(option);
    });

    // ======== 烟感报警图（散点） ========
    fetch('${pageContext.request.contextPath}/SmokeServlet')
        .then(r => r.json())
        .then(data => {
            const chart = echarts.init(document.getElementById('smokeChart'));
            const threshold = 50; // 自定义报警阈值
            const option = {
                title: { text: '烟雾报警事件' },
                tooltip: { trigger: 'item' },
                xAxis: { type: 'category', data: data.time },
                yAxis: { type: 'value', name: '烟雾值' },
                series: [{
                    name: '烟雾浓度',
                    type: 'scatter',
                    symbolSize: val => val[1] > threshold ? 12 : 6,
                    data: data.time.map((t, i) => [t, data.value[i]]),
                    itemStyle: {
                        color: val => val.value[1] > threshold ? 'red' : '#3398DB'
                    },
                    markLine: {
                        data: [{ yAxis: threshold, name: '报警阈值' }],
                        lineStyle: { color: 'red', type: 'dashed' }
                    }
                }]
            };
            chart.setOption(option);
        });
</script>
</body>
</html>
