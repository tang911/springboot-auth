<!--
	此示例下载自 https://echarts.apache.org/examples/zh/editor.html?c=bar-race-country
-->
<!DOCTYPE html>
<html lang="en" style="height: 100%">
<head>
    <meta charset="utf-8">
    <link href="https://cdn.staticfile.net/bootstrap/5.2.0/css/bootstrap.min.css" rel="stylesheet" />

</head>
<body style="height: 100%; margin: 0">

<button id="start_btn" type="button" class="btn btn-sm btn-info">开始</button>

<div id="container" style="height: 100%"></div>

<script type="text/javascript" src="https://echarts.apache.org/zh/js/vendors/jquery@3.7.1/dist/jquery.min.js"></script>
<script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@5/dist/echarts.min.js"></script>

<!-- Uncomment this line if you want to dataTool extension
<script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@5/dist/extension/dataTool.min.js"></script>
-->
<!-- Uncomment this line if you want to use gl extension
<script type="text/javascript" src="https://echarts.apache.org/zh/js/vendors/echarts-gl/dist/echarts-gl.min.js"></script>
-->
<!-- Uncomment this line if you want to echarts-stat extension
<script type="text/javascript" src="https://echarts.apache.org/zh/js/vendors/echarts-stat/dist/ecStat.min.js"></script>
-->
<!-- Uncomment this line if you want to echarts-graph-modularity extension
<script type="text/javascript" src="https://echarts.apache.org/zh/js/vendors/echarts-graph-modularity/dist/echarts-graph-modularity.min.js"></script>
-->
<!-- Uncomment this line if you want to use map
<script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@4.9.0/map/js/world.js"></script>
-->
<!-- Uncomment these two lines if you want to use bmap extension
<script type="text/javascript" src="https://api.map.baidu.com/api?v=3.0&ak=YOUR_API_KEY"></script>
<script type="text/javascript" src="https://fastly.jsdelivr.net/npm/echarts@5/dist/extension/bmap.min.js"></script>
-->

<script type="text/javascript">
    var dom = document.getElementById('container');
    var myChart = echarts.init(dom, null, {
        renderer: 'canvas',
        useDirtyRect: false
    });
    var app = {};
    var ROOT_PATH = 'https://echarts.apache.org/examples';
    var option;

    const updateFrequency = 2000;
    const dimension = 0;
    const countryColors = {
        Australia: '#00008b',
        Canada: '#f00',
        China: '#ffde00',
        Cuba: '#002a8f',
        Finland: '#003580',
        France: '#ed2939',
        Germany: '#000',
        Iceland: '#003897',
        India: '#f93',
        Japan: '#bc002d',
        'North Korea': '#024fa2',
        'South Korea': '#000',
        'New Zealand': '#00247d',
        Norway: '#ef2b2d',
        Poland: '#dc143c',
        Russia: '#d52b1e',
        Turkey: '#e30a17',
        'United Kingdom': '#00247d',
        'United States': '#b22234'
    };
    $.when(
        $.getJSON(CDN_PATH + 'emoji-flags@1.3.0/data.json'),
        $.getJSON(ROOT_PATH + '/data/asset/data/life-expectancy-table.json')
    ).done(function (res0, res1) {
        const flags = res0[0];
        const data = res1[0];
        const years = [];
        for (let i = 0; i < data.length; ++i) {
            if (years.length === 0 || years[years.length - 1] !== data[i][4]) {
                years.push(data[i][4]);
            }
        }
        function getFlag(countryName) {
            if (!countryName) {
                return '';
            }
            return (
                flags.find(function (item) {
                    return item.name === countryName;
                }) || {}
            ).emoji;
        }
        let startIndex = 10;
        let startYear = years[startIndex];
        option = {
            grid: {
                top: 10,
                bottom: 30,
                left: 150,
                right: 80
            },
            xAxis: {
                max: 'dataMax',
                axisLabel: {
                    formatter: function (n) {
                        return Math.round(n) + '';
                    }
                }
            },
            dataset: {
                source: data.slice(1).filter(function (d) {
                    return d[4] === startYear;
                })
            },
            yAxis: {
                type: 'category',
                inverse: true,
                max: 10,
                axisLabel: {
                    show: true,
                    fontSize: 14,
                    formatter: function (value) {
                        return value + '{flag|' + getFlag(value) + '}';
                    },
                    rich: {
                        flag: {
                            fontSize: 25,
                            padding: 5
                        }
                    }
                },
                animationDuration: 300,
                animationDurationUpdate: 300
            },
            series: [
                {
                    realtimeSort: true,
                    seriesLayoutBy: 'column',
                    type: 'bar',
                    itemStyle: {
                        color: function (param) {
                            return countryColors[param.value[3]] || '#5470c6';
                        }
                    },
                    encode: {
                        x: dimension,
                        y: 3
                    },
                    label: {
                        show: true,
                        precision: 1,
                        position: 'right',
                        valueAnimation: true,
                        fontFamily: 'monospace'
                    }
                }
            ],
            // Disable init animation.
            animationDuration: 0,
            animationDurationUpdate: updateFrequency,
            animationEasing: 'linear',
            animationEasingUpdate: 'linear',
            graphic: {
                elements: [
                    {
                        type: 'text',
                        right: 160,
                        bottom: 60,
                        style: {
                            text: startYear,
                            font: 'bolder 80px monospace',
                            fill: 'rgba(100, 100, 100, 0.25)'
                        },
                        z: 100
                    }
                ]
            }
        };
        // console.log(option);
        myChart.setOption(option);
        for (let i = startIndex; i < years.length - 1; ++i) {
            (function (i) {
                setTimeout(function () {
                    updateYear(years[i + 1]);
                }, (i - startIndex) * updateFrequency);
            })(i);
        }
        function updateYear(year) {
            let source = data.slice(1).filter(function (d) {
                return d[4] === year;
            });
            option.series[0].data = source;
            option.graphic.elements[0].style.text = year;
            myChart.setOption(option);
        }
    });

    if (option && typeof option === 'object') {
        myChart.setOption(option);
    }

    window.addEventListener('resize', myChart.resize);
</script>
</body>
</html>
