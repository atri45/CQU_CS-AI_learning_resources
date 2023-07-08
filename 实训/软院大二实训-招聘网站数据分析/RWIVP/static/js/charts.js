function convertData(data, geoCoordMap) {
    var res = [];
    for (var i = 0; i < data.length; i++) {
        var geoCoord = geoCoordMap[data[i].name];
        if (geoCoord) {
            res.push({
                name: data[i].name,
                value: geoCoord.concat(data[i].value)
            });
        }
    }
    return res;
}
$(document).ready(function () {
    // 使用 Ajax 从服务器获取数据
    $.getJSON(window.location.href, function (data) {
            // 获取 canvas 元素并设置其尺寸
        let expCanvas = document.getElementById('Experience-average_salary_chart');
        expCanvas.style.width = '100%';
        expCanvas.style.height = '60vh';  // 设定一个高度为视口高度60%
        expCanvas.width = expCanvas.offsetWidth;
        expCanvas.height = expCanvas.offsetHeight;
        // 在 canvas 尺寸设置完毕后，初始化图表
        expChart = echarts.init(expCanvas, null, {devicePixelRatio: window.devicePixelRatio});
            // 设置图表的配置项和数据
        var expOption = {
            title: {
                text: '经验-平均工资分布图',
                left: 'center',
                textStyle: {
                    color: '#333',
                    fontSize: 30
                }
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'shadow'
                }
            },
            grid: {
                top: '10%',
                left: '2%',
                right: '2%',
                bottom: '1%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                data: data.experience.map(function (item) { return item.experience; }),
                axisLabel: {
                    interval: 0,
                    rotate: 45
                },
                axisTick: {
                    alignWithLabel: true
                }
            },
            yAxis: {
                type: 'value'
            },
            dataZoom: [
                {
                    type: 'inside'
                },
                {
                    type: 'slider',

                }
            ],
      toolbox: {
        feature: {
          saveAsImage: {},
          magicType: {type: ['line', 'bar']},
          restore: {},
        }
      },
            series: [{
                name: '平均工资',
                type: 'bar',
                data: data.experience.map(function (item) { return item.avg_salary; }),
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                        offset: 0, color: '#83bff6'
                    }, {
                        offset: 0.5, color: '#188df0'
                    }, {
                        offset: 1, color: '#188df0'
                    }])
                }
            }]
        };
        expChart.setOption(expOption);
    });

    window.addEventListener('resize', function () {
            expChart.resize();
            eduChart.resize();
            natureChart.resize();
            industryChart.resize();
            salChart.resize();
            geoChart.resize()
            wordCloudChart.resize();
});
});
$(document).ready(function () {
    $.getJSON(window.location.href, function (data) {
            // 获取 canvas 元素并设置其尺寸
        let eduCanvas = document.getElementById('education-average_salary_chart');
        eduCanvas.style.width = '100%';
        eduCanvas.style.height = '60vh';  // 设定一个高度为视口高度60%
        eduCanvas.width = eduCanvas.offsetWidth;
        eduCanvas.height = eduCanvas.offsetHeight;

        eduChart = echarts.init(eduCanvas, null, {devicePixelRatio: window.devicePixelRatio});

        var eduOption = {
        title: {
                text: '教育-平均工资分布图',
                left: 'center',
                textStyle: {
                    color: '#333',
                    fontSize: 30
                }
                },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
            grid: {
                top: '10%',
                left: '2%',
                right: '2%',
                bottom: '1%',
                containLabel: true
            },
        xAxis: {
            type: 'category',
            data: data.education.map(function (item) { return item.education; }),
            axisLabel: {
                interval: 0,
                rotate: 45
            },
            axisTick: {
                alignWithLabel: true
            }
        },
        yAxis: {
            type: 'value'
        },
        dataZoom: [
            {
                type: 'inside'
            },
            {
                type: 'slider',

            }
        ],
      toolbox: {
        feature: {
          saveAsImage: {},
          magicType: {type: ['line', 'bar']},
          restore: {},
        }
      },
        series: [{
            name: '平均工资',
            type: 'bar',
            data: data.education.map(function (item) { return item.avg_salary; }),
            itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                    offset: 0, color: '#1cbb9b'
                }, {
                    offset: 0.5, color: '#2ca02c'
                }, {
                    offset: 1, color: '#2ca02c'
                }])
            }
        }]
    };
        eduChart.setOption(eduOption);
    });
});
$(document).ready(function () {
    $.getJSON(window.location.href, function (data) {
            // 获取 canvas 元素并设置其尺寸
        let natureCanvas = document.getElementById('company_nature_chart');
        natureCanvas.style.width = '100%';
        natureCanvas.style.height = '60vh';  // 设定一个高度为视口高度60%
        natureCanvas.width = natureCanvas.offsetWidth;
        natureCanvas.height = natureCanvas.offsetHeight;
        natureChart = echarts.init(natureCanvas, null, {devicePixelRatio: window.devicePixelRatio});
        var natureOption = {

            title: {
                text: '公司性质占比图',
                left: 'center',
              textStyle: {
                fontSize: 30 // 设置字体大小为18
              },
              padding: [20, 0, 0, 0] // 设置上方间距为10
            },
            tooltip: {
                trigger: 'item'
            },
            legend: {
                orient: 'horizontal',
                top: 'bottom',
            },
      toolbox: {
        feature: {
          saveAsImage: {},
          restore: {},
        }
      },

            series: [{
                type: 'pie',
                radius: '50%',    // 设置为环形图
                center: ['50%', '45%'],
                data: data.company_nature,
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },
                label: {
                    show: true,
                    formatter: '{b} : {c} ({d}%)'  // b, c, d分别表示数据名，数据值和百分比
                }
            }]
        };
        natureChart.setOption(natureOption);
    });
});
$(document).ready(function () {
    $.getJSON(window.location.href, function (data) {
            // 获取 canvas 元素并设置其尺寸
        let sizeCanvas = document.getElementById('company_size_chart');
        sizeCanvas.style.width = '100%';
        sizeCanvas.style.height = '60vh';  // 设定一个高度为视口高度60%
        sizeCanvas.width = sizeCanvas.offsetWidth;
        sizeCanvas.height = sizeCanvas.offsetHeight;
        sizeChart = echarts.init(sizeCanvas, null, {devicePixelRatio: window.devicePixelRatio});
        var sizeOption = {
        title: {
            text: '公司规模占比图',
            left: 'center',
          textStyle: {
            fontSize: 30 // 设置字体大小为18
          },
          padding: [20, 0, 0, 0] // 设置上方间距为10
        },
        tooltip: {
            trigger: 'item'
        },
        legend: {
            orient: 'horizontal',
            top: 'bottom',
        },
      toolbox: {
        feature: {
          saveAsImage: {},
          restore: {},
        }
      },
        series: [{
            type: 'pie',
            radius: '50%',    // 设置为环形图
            center: ['50%', '45%'],
            data: data.company_size,
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            },
            label: {
                show: true,
                formatter: '{b} : {c} ({d}%)'  // b, c, d分别表示数据名，数据值和百分比
            }
        }]
    };
        sizeChart.setOption(sizeOption);
    });
});
$(document).ready(function () {
    $.getJSON(window.location.href, function (data) {
                // 获取 canvas 元素并设置其尺寸
        let industryCanvas = document.getElementById('Industry_category_chart');
        industryCanvas.style.width = '100%';
        industryCanvas.style.height = '60vh';  // 设定一个高度为视口高度60%
        industryCanvas.width = industryCanvas.offsetWidth;
        industryCanvas.height = industryCanvas.offsetHeight;
        industryChart = echarts.init(industryCanvas, null, {devicePixelRatio: window.devicePixelRatio});
        var inDustryOption = {
        title: {
          text: '产业类别占比图',
          left: 'center',
          textStyle: {
            fontSize: 30 // 设置字体大小为18
          },
          padding: [20, 0, 0, 0] // 设置上方间距为10
        },
        tooltip: {
            trigger: 'item'
        },
        legend: {
            orient: 'horizontal',
            top: 'bottom',
        },
      toolbox: {
        feature: {
          saveAsImage: {},
          restore: {},
        }
      },
        series: [{
            type: 'pie',
            radius: '50%',    // 设置为环形图
            center: ['50%', '45%'],
            data: data.industry,
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            },
            label: {
                show: true,
                formatter: '{b} : {c} ({d}%)'  // b, c, d分别表示数据名，数据值和百分比
            }
        }]
    };
        industryChart.setOption(inDustryOption);
    });
});
$(document).ready(function () {
    $.getJSON(window.location.href, function (data) {
            // 获取 canvas 元素并设置其尺寸
        let salCanvas = document.getElementById('salary_distribution_chart');
        salCanvas.style.width = '100%';
        salCanvas.style.height = '60vh';
        salCanvas.width = salCanvas.offsetWidth;
        salCanvas.height = salCanvas.offsetHeight;
        salChart = echarts.init(salCanvas, null, {devicePixelRatio: window.devicePixelRatio});
        var salOption = {
    title: {
          text: '平均工资分布直方图',
          left: 'center',
          textStyle: {
            fontSize: 30 // 设置字体大小为18
          },
          padding: [20, 0, 0, 0] // 设置上方间距为10
    },
      tooltip: {
        trigger: 'item',
      },
      toolbox: {
        feature: {
          saveAsImage: {},
          magicType: {type: ['line', 'bar']},
          restore: {},
        }
      },
      xAxis: {
        type: 'category',
        data: data.bins.slice(0, -1).map(bin => bin + '-' + (bin + 5) + '万'),
        axisLabel: {
          interval: 0,
          rotate: 45
        },
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: data.counts,
        type: 'bar'
      }],
      dataZoom: [{
        type: 'inside'
      }, {
        type: 'slider'
      }]
    };
        salChart.setOption(salOption);
    });
});
$(document).ready(function () {
    $.getJSON(window.location.href, function (data) {
            // 获取 canvas 元素并设置其尺寸

        let geoCanvas = document.getElementById('geographic_distribution_chart');
        geoCanvas.style.width = '100%';
        geoCanvas.style.height = '60vh';
        geoCanvas.width = geoCanvas.offsetWidth;
        geoCanvas.height = geoCanvas.offsetHeight;
        geoChart = echarts.init(geoCanvas, null, {devicePixelRatio: window.devicePixelRatio});

        city_geo_js=data.city_geo;
        convertedData={};
        geoCoordMap = {};

        let minValue = Math.min.apply(Math, city_geo_js.map(function(o) { return o.value; }));
        let maxValue = Math.max.apply(Math, city_geo_js.map(function(o) { return o.value; }));

        console.log(minValue);
        console.log(minValue);
    fetch(citiesPath)
      .then(response => response.json())
      .then(data => {

        data.features.forEach(feature => {
          var name = feature.properties.name;
          var coordinates = feature.properties.cp;
          geoCoordMap[name] = coordinates;
        });

        var convertedData = convertData(city_geo_js, geoCoordMap);
        var geoOption = {
        title: {
            text: '地理位置分布图',
            left: 'center',
            textStyle: {
                fontSize: 30 // 设置字体大小为18
            },
            padding: [20, 0, 0, 0] // 设置上方间距为10
        },
        toolbox: {
        feature: {
          saveAsImage: {},
          restore: {},
        }
      },
        tooltip: {  // 添加提示框组件
            show: true,
            // showContent: true,
            trigger: 'item',  // 触发类型
            formatter: function (params) {  // 提示框显示内容
                return params.data.name +  ":"  + params.data.value[2];
            },
            textStyle: {  // 设置提示框文字样式
            color: '#b31616',  // 文字颜色
            fontSize: 14  // 文字大小
        },
        backgroundColor: '#cb2f2f',  // 提示框背景色
        borderColor: '#bf0f0f',  // 提示框边框色
        borderWidth: 1,  // 提示框边框宽度
        zIndex: 10000 // 设置堆叠顺序，数值越大，元素越在上层
        },
        geo: {
            map: 'china',
            roam: true,  // 允许缩放和拖动
            label: {
                emphasis: {
                    show: true
                }
            },
        },
        visualMap: {
            min: minValue,  // 数据的最小值
            max: maxValue,  // 数据的最大值
            calculable: true,  // 是否可拖动选择
            inRange: {
                color: ['#e7b179', '#ac0d0d']  // 定义颜色范围
            },
            textStyle: {
                color: '#000000'  // 图例文字颜色
            }
        },
        series: [
            {
                name: '工作数量',
                type: 'scatter',
                coordinateSystem: 'geo',
                data: convertedData,
                itemStyle: {
                    emphasis: {  // 高亮的样式
                        borderColor: '#f1d9d9',
                        borderWidth: 1
                    }
                },
            }
        ]
    };

        geoChart.setOption(geoOption);


  });
    });
});
$(document).ready(function () {
    $.getJSON(window.location.href, function (data) {
            // 获取 canvas 元素并设置其尺寸
        let wordCloudCanvas = document.getElementById('word_cloud_chart');
        wordCloudCanvas.style.width = '100%';
        wordCloudCanvas.style.height = '60vh';
        wordCloudCanvas.width = wordCloudCanvas.offsetWidth;
        wordCloudCanvas.height = wordCloudCanvas.offsetHeight;
        wordCloudChart = echarts.init(wordCloudCanvas,'2d', { willReadFrequently: true });
        image= "data:image/png;base64,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"
        var maskResource = new Image()
        maskResource.src=image;
        var wordCloudOption = {
            title: {
                text: '词云分布图',
                left: 'center',
              textStyle: {
                fontSize: 30 // 设置字体大小为18
              },
              padding: [20, 0, 0, 0] // 设置上方间距为10
            },
            grid: {
                top: '10%',
                left: '2%',
                right: '2%',
                bottom: 0,
                containLabel: true
            },
            tooltip:{

                },
          toolbox: {
        feature: {
          saveAsImage: {},
          restore: {},
        }
      },
          series: [{

            maskImage:maskResource,
            type: 'wordCloud',

            textStyle: {
                normal:{
                    //生成随机的字体颜色

                }

            },
              data: data.word_cloud_data,  // 从服务器获取过滤后的数据
          }]
        };
        maskResource.onload = function(){
        wordCloudChart.setOption(wordCloudOption);
        };
    });
});
