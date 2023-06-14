import pyecharts.charts as chart
import pyecharts.options as opt
import pandas as pd
import numpy as np

#按职位地点可视化
def area_map(job_data):
    city_data = []
    count = job_data['workarea_text'].value_counts()
    for index in count.index:
        ind = index.replace('省','')
        if chart.Geo().get_coordinate(ind):
            city_data.append([ind,int(count[index])])
    map_ = (
        chart.Geo(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add_schema(maptype='china')
        .add('城市',city_data)
        .set_series_opts(label_opts=opt.LabelOpts(is_show=False))
        .set_global_opts(title_opts=opt.TitleOpts(title='城市岗位数量分布地图'),
                        visualmap_opts=opt.VisualMapOpts(min_=0,max_=30))
    )
    map_.render('flaskProject/templates/job51_map.html')

#按公司性质可视化
def company_type_picture(job_data):
    company_type_data = []
    count = job_data['companytype_text'].value_counts()
    for index in count.index:
        company_type_data.append((index,int(count[index])))

    pie = (
        chart.Pie(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add('',company_type_data,radius=["10%","40%"],rosetype='area')
        .set_global_opts(title_opts=opt.TitleOpts(title='公司性质分布图'),
                        legend_opts=opt.LegendOpts(pos_left="80%", orient="vertical"))
        .set_series_opts(label_opts=opt.LabelOpts(formatter='{b}: {c}({d}%)'))
    )
    pie.render('flaskProject/templates/job51_company_type_picture.html')

#按公司规模可视化
def company_size_picture(job_data):
    company_scale_data = []
    count = job_data['companysize_text'].value_counts()
    for index in count.index:
        company_scale_data.append((index,int(count[index])))

    pie2 = (
        chart.Pie(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add('',company_scale_data,radius=["10%","40%"])
        .set_global_opts(title_opts=opt.TitleOpts(title='公司规模分布图'),
                         legend_opts=opt.LegendOpts(pos_left="85%", orient="vertical"))
        .set_series_opts(label_opts=opt.LabelOpts(formatter='{b}: {d}%'))
    )
    pie2.render('flaskProject/templates/job51_company_size_picture.html')

#按公司行业可视化
def company_industry_picture(job_data):
    company_industry_data = []
    count = job_data['companyind_text'].value_counts()
    for index in count.index:
        company_industry_data.append((index,int(count[index])))

    pie3 = (
        chart.Pie(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add('',company_industry_data,radius=["10%","40%"],rosetype='area')
        .set_global_opts(title_opts=opt.TitleOpts(title='公司类别分布图'),
                        legend_opts=opt.LegendOpts(type_='scroll',pos_left="5%",pos_bottom='5%',orient="horizontal"))
        .set_series_opts(label_opts=opt.LabelOpts(formatter='{b}: {c}({d}%)'))
    )
    pie3.render('flaskProject/templates/job51_company_industry_picture.html')

#学历薪资关系
def salary_and_education_picture(job_data):
    dt_education = job_data[['salary_mean','job_request']].groupby('job_request').mean()

    x_data_e = dt_education.index.tolist()
    y_data_e = np.around(dt_education.values,2).tolist()
    line_ed=(
        chart.Line(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add_xaxis(xaxis_data=x_data_e)
        .add_yaxis('最高学历平均薪资',y_data_e,linestyle_opts=opt.LineStyleOpts(width=2))
        .set_global_opts(title_opts=opt.TitleOpts(title='最高学历平均薪资水平'),
                         xaxis_opts=opt.AxisOpts(name='最高学历'),
                        yaxis_opts=opt.AxisOpts(name='薪资（元/月）'))
    )
    line_ed.render('flaskProject/templates/job51_salary_and_education_picture.html')

#薪资与公司规模分析
def salary_and_company_size_picture(job_data):
    dt_scale = job_data[['salary_mean','companysize_text']].groupby('companysize_text').mean()
    x_data_e = dt_scale.index.tolist()
    y_data_e = np.around(dt_scale.values,2).tolist()
    line_ed=(
        chart.Line(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add_xaxis(xaxis_data=x_data_e)
        .add_yaxis('最高学历平均薪资',y_data_e,linestyle_opts=opt.LineStyleOpts(width=2))
        .set_global_opts(title_opts=opt.TitleOpts(title='公司规模与平均薪资水平'),
                         xaxis_opts=opt.AxisOpts(name='最高学历'),
                        yaxis_opts=opt.AxisOpts(name='薪资（元/月）'))
    )
    line_ed.render('flaskProject/templates/job51_salary_and_company_size_picture.html')

#处理数据方便做岗位日发布量和薪资关系
def data_processing(job_data):

    x_date = job_data['updatedate'].sort_values().unique().tolist()
    salary_mean = job_data[['updatedate','salary_mean','job_name']].groupby(['updatedate','job_name']).mean()['salary_mean']
    job_num = job_data[['updatedate','salary_mean','job_name']].groupby(['updatedate','job_name']).count()['salary_mean']
    date_job_salary ={'job_num':[],'salary_mean':[]}
    for date in x_date:
        for job in set(job_data['job_name'].values):
            index = (date,job)
            try:
                salary = salary_mean[index]
                number = job_num[index]
                date_job_salary['job_num'].append((date,job,int(number)))
                date_job_salary['salary_mean'].append((date,job,float(salary)))
            except:
                date_job_salary['job_num'].append((date,job,None))
                date_job_salary['salary_mean'].append((date,job,None))
    d1 = pd.DataFrame(date_job_salary['job_num'],columns=['date','job','number'])
    d2 = pd.DataFrame(date_job_salary['salary_mean'],columns=['date','job','salary_mean'])
    d3 = pd.merge(d1,d2)

#各岗位日发布数量
    dt_job = {}
    dt_salary = {}
    for job in set(job_data['job_name'].values):
        dt_job[job] = d3[d3['job']==job][['date','number']].dropna(axis=0)
        dt_salary[job] = d3[d3['job']==job][['date','salary_mean']].dropna(axis=0)

    def ceil_(x):
        return round(x, 2)

    bar1 = (
    chart.Bar(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add_xaxis(xaxis_data=x_date)
        .add_yaxis('图像处理',dt_job['图像处理']['number'].tolist())
        .add_yaxis('语音识别',dt_job['语音识别']['number'].tolist())
        .add_yaxis('机器学习',dt_job['机器学习']['number'].tolist())
        .add_yaxis('数据挖掘工程师',dt_job['数据挖掘工程师']['number'].tolist())
        .add_yaxis('算法工程师',dt_job['算法工程师']['number'].tolist())
        .add_yaxis('数据分析师',dt_job['数据分析师']['number'].tolist())
        .add_yaxis('人工智能',dt_job['人工智能']['number'].tolist())
        .add_yaxis('python',dt_job['python']['number'].apply(ceil_).tolist())
        .add_yaxis('销售',dt_job['销售']['number'].tolist())
        .add_yaxis('律师',dt_job['律师']['number'].tolist())
        .set_global_opts(title_opts=opt.TitleOpts(title='各岗位日发布量')
                         ,xaxis_opts=opt.AxisOpts(name='日期'),
                        yaxis_opts=opt.AxisOpts(name='岗位数量'),
                        datazoom_opts=[opt.DataZoomOpts(),opt.DataZoomOpts(type_='inside')])
    )
    bar1.render('flaskProject/templates/job51_date_job_num_picture.html')

#岗位日发布平均薪资

    line = (
    chart.Line(init_opts=opt.InitOpts(width='1400px',height='700px'))
        .add_xaxis(xaxis_data=x_date)
        .add_yaxis('图像处理',y_axis=dt_salary['图像处理']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('语音识别',y_axis=dt_salary['语音识别']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('数据挖掘工程师',y_axis=dt_salary['数据挖掘工程师']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('算法工程师',y_axis=dt_salary['算法工程师']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('数据分析师',y_axis=dt_salary['数据分析师']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('人工智能',y_axis=dt_salary['人工智能']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('python',y_axis=dt_salary['python']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('销售',y_axis=dt_salary['销售']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .add_yaxis('律师',y_axis=dt_salary['律师']['salary_mean'].apply(ceil_).tolist(),
                  linestyle_opts=opt.LineStyleOpts(width=2))
        .set_global_opts(title_opts=opt.TitleOpts(title='各岗位日发布平均薪资')
                         ,xaxis_opts=opt.AxisOpts(name='日期'),
                        yaxis_opts=opt.AxisOpts(name='薪资（元/月）'),
                        datazoom_opts=[opt.DataZoomOpts(),opt.DataZoomOpts(type_='inside')])
    )
    line.render('flaskProject/templates/job51_date_salary_mean_picture.html')



if __name__ == '__main__':
    job_data = pd.read_csv("./data/job_data_cleared.csv", encoding="utf-8")    #数据读取
    area_map(job_data)                                                         #按职位地点可视化
    company_type_picture(job_data)                                             #按公司性质可视化
    company_size_picture(job_data)                                             #按公司规模可视化
    company_industry_picture(job_data)                                         #按公司行业可视化
    salary_and_education_picture(job_data)                                     #学历薪资关系
    salary_and_company_size_picture(job_data)                                  #各岗位日发布数量
    data_processing(job_data)                                                  #岗位日发布平均薪资
