import re
import pandas as pd
import numpy as np
from sqlalchemy import create_engine
job_data=[]
#索引规则
find_job_list=re.compile('<script type="text/javascript">(.*?)</script>',re.S)
find_job_clear_list=re.compile('\[\{(?:.|\s)*?\}\]')

#逐文件夹读取数据并提取-----------------------------------------------------------------------------------------------------
def get_job_data():
    job_name_list=[ '人工智能','机器学习', '数据分析', '数据挖掘', '算法工程师','python','语音识别','图像处理','律师','销售']
    for o in job_name_list:
        for j in range(1,11):
            with open("data\{name}{page}".format(page=j,name=o),'r',encoding='utf-8') as file:
                html=file.read()
                job_list=re.findall(find_job_list,html)[0]                       #找到粗糙的job_list序列
                job_clear_list=re.findall(find_job_clear_list,job_list)          #找到更加精确的job_list序列
                job_clear_list=eval(job_clear_list[0])                           #将字符串的形式的列表转为列表

            #逐条提取数据
            for i in range(len(job_clear_list)):
                single_job_data = []
                job_name=job_clear_list[i].get("job_name")                       #职位名称
                single_job_data.append(job_name)
                company_name=job_clear_list[i].get("company_name")               #公司
                single_job_data.append(company_name)
                providesalary_text=job_clear_list[i].get("providesalary_text")   #薪水
                single_job_data.append(providesalary_text)
                workarea_text=job_clear_list[i].get("workarea_text")             #地点
                single_job_data.append(workarea_text)
                jobwelf=job_clear_list[i].get("companytype_text")                #公式类型
                single_job_data.append(jobwelf)
                jobwelf=job_clear_list[i].get("companysize_text")                #公司规模
                single_job_data.append(jobwelf)
                jobwelf=job_clear_list[i].get("companyind_text")                 #行业分析
                single_job_data.append(jobwelf)
                jobwelf=job_clear_list[i].get("jobwelf")                         #待遇
                single_job_data.append(jobwelf)
                jobwelf=job_clear_list[i].get("updatedate")                      #发布时间
                single_job_data.append(jobwelf)
                job_request=job_clear_list[i].get("attribute_text")              #学历经验
                try:
                    single_job_data.append(job_request[2])
                except:
                    single_job_data.append(None)

                #将单条数据添加入总数据列表中
                job_data.append(single_job_data)
    return job_data

#将所有数据存入mysql和csv中-------------------------------------------------------------------------------------------------
def store_data(job_data):
    pd_job_data=pd.DataFrame(job_data,columns=["job_name","company_name","providesalary_text","workarea_text","companytype_text","companysize_text","companyind_text","jobwelf","updatedate",'job_request'])
    pd_job_data.to_csv("data/job_data.csv", encoding='utf-8')
    engine=create_engine("mysql+mysqlconnector://root:root1234@localhost:3306/job_data?charset=utf8")
    connect=engine.connect()
    pd_job_data.to_sql(name="job_data",con=connect)
    connect.close()

def store_data_cleared(job_data):
    job_data = pd.read_csv("./data/job_data_cleared.csv", encoding="utf-8")
    pd_job_data = pd.DataFrame(job_data, columns=["job_name", "company_name", "providesalary_text", "workarea_text",
                                                  "companytype_text", "companysize_text", "companyind_text", "jobwelf",
                                                  "updatedate", 'job_request'])
    engine = create_engine("mysql+mysqlconnector://root:root1234@localhost:3306/job_data?charset=utf8")
    connect = engine.connect()
    pd_job_data.to_sql(name="job_data_cleared", con=connect)
    connect.close()

#通过csv来处理数据---------------------------------------------------------------------------------------------------------

#清洗城市地区-------------------------------------------------------------------------------------------------------------

def get_city(x):
    try:
        x=x.split('-')[0]
    except:
        pass
    return x

#处理工资----------------------------------------------------------------------------------------------------------------

def get_max_min_salary(end,mul,x,mouth=12):
    global min_1
    global max_1
    if x=='100万以上\/年':
        min_1, max_1 = None, None
        return min_1, max_1
    if end=='\/年':
        x = x.replace(end, '')
        try:
            x=x.replace('万','')
            temp = x.split('-')
            min_1, max_1 = float(temp[0]) * mul, float(temp[1]) * mul
        except:
            min_1 = max_1 = float(x) * mul
    elif end=='万' or end=='千':
        x = x.replace(end,'')
        try:
            temp= x.split('-')
            if temp[0].endswith('千'):
                temp[0]=temp[0].replace('千','')
                min_1,max_1 = float(temp[0])*1000*mouth,float(temp[1])*mul*mouth
            else:
                min_1,max_1 = float(temp[0])*mul*mouth,float(temp[1])*mul*mouth
        except:
            min_1=max_1=float(temp[0])*mul*mouth

    return min_1,max_1

def get_salary(x):
    global min_
    global max_
    if str(x).endswith('万'):
        min_,max_ = get_max_min_salary('万',10000,x)
    elif str(x).endswith('\/年'):
        min_,max_ = get_max_min_salary('\/年',10000,x)
    elif str(x).endswith('千'):
        min_,max_ = get_max_min_salary('千',1000,x)
    elif str(x).endswith('薪'):
        mouth=int(x[-3:-1])
        temp=x.split('·')
        x=str(temp[0])
        end=x[-1]
        if end=='千':
            mul=1000
            min_, max_ = get_max_min_salary(end, mul, x, mouth)
        elif end=='万':
            mul=10000
            min_, max_ = get_max_min_salary(end, mul, x, mouth)
    else:
        min_,max_ = None,None
    return min_,max_
#处理职位名称-------------------------------------------------------------------------------------------------------------

def get_job_name(x):
    if ("AI" in x) or ("人工智能" in x):
        x="人工智能"
    elif '算法工程师' in x:
        x='算法工程师'
    elif '数据分析' in x:
        x='数据分析师'
    elif '数据挖掘' in x:
        x='数据挖掘工程师'
    elif 'python' in x:
        x='python'
    elif '语音识别' in x:
        x='语音识别'
    elif '图像处理' in x:
        x='图像处理'
    elif '机器学习' in x:
        x='机器学习'
    elif '律师' in x:
        x = '律师'
    elif '销售' in x:
        x = '销售'
    else:
        x=None
    return x
#处理职位名称-------------------------------------------------------------------------------------------------------------

def get_job_degree(x):
    if x=='中技\/中专':
        x='中专'
    return x

#数据处理汇总-------------------------------------------------------------------------------------------------------------

def data_processing():
    cleared_job_data=pd.DataFrame(columns=["job_name","company_name","providesalary_text","workarea_text","companytype_text","companysize_text","companyind_text","jobwelf","updatedate",'job_request'])
    job_data = pd.read_csv("./data/job_data.csv", encoding="utf-8")
    # print(job_data.loc[4000])

    job_data['workarea_text'] = job_data['workarea_text'].apply(get_city)                     #工作地点清理
    salary= job_data['providesalary_text'].apply(get_salary)                                  #薪资处理
    job_data['min_salary'], job_data['max_salary'] = salary.str[0],salary.str[1]              #最小薪资
    job_data['salary_mean'] = (job_data['min_salary'] + job_data['max_salary']) / 2.0         #平均薪资
    job_data['job_name']=job_data['job_name'].apply(get_job_name)                             #岗位名称
    job_data['job_request']=job_data['job_request'].apply(get_job_degree)                     #学历要求
    job_data=job_data.dropna(how='all')
    job_data=job_data.replace(to_replace='None', value=np.nan).dropna()
    return job_data


if __name__ == '__main__':
        job_data=get_job_data()                                          #获取数据
        store_data(job_data)                                             #存储第一次粗糙数据
        job_data=data_processing()                                       #数据清洗
        job_data.to_csv("data/job_data_cleared.csv", encoding='utf-8')   #将清洗好的数据存入csv
        store_data_cleared(job_data)                                     #将清洗好的数据存入MySQL