from flask import Flask
from flask import render_template
from flask import request
import pymysql
app = Flask(__name__)

conn = pymysql.connect(
    host='127.0.0.1',
    user='root',
    password='1234',
    db='job_data',
    charset='utf8'
)

@app.route('/')
def index():
    return render_template("index.html")

#切换图表页面-------------------------------------------------------------------------------------------------------------
@app.route('/picture1')
def picture1():
    return render_template("job51_company_industry_picture.html")
@app.route('/picture2')
def picture2():
    return render_template("job51_company_size_picture.html")
@app.route('/picture3')
def picture3():
    return render_template("job51_company_type_picture.html")
@app.route('/picture4')
def picture4():
    return render_template("job51_date_job_num_picture.html")
@app.route('/picture5')
def picture5():
    return render_template("job51_date_salary_mean_picture.html")
@app.route('/picture6')
def picture6():
    return render_template("job51_map.html")
@app.route('/picture7')
def picture7():
    return render_template("job51_salary_and_company_size_picture.html")
@app.route('/picture8')
def picture8():
    return render_template("job51_salary_and_education_picture.html")

#连接数据库并查找到相应数据--------------------------------------------------------------------------------------------------

@app.route('/aaaa')
def aaaa():
    return render_template("aaaa.html")
@app.route('/',methods=['POST'])
def search():

    conn = pymysql.connect(user='root', host='localhost', passwd='root1234', db='job_data',cursorclass=pymysql.cursors.DictCursor)
    cur = conn.cursor()
    job_name = request.values.get('question1')
    job_area=request.values.get('question2')
    job_request_list=request.values.getlist('degree')
    print(job_name)
    print(job_area)
    print(job_request_list)
    sql = "select * from job_data_cleared where (job_name like '%{0}%') and (workarea_text like '%{1}%')  ".format(job_name,job_area)
    for i in job_request_list:
        s="and job_request='{0}'".format(i)
        sql+=s
    cur.execute(sql)
    datas = cur.fetchall()
    return render_template('aaaa1.html',items=datas)


if __name__ == '__main__':
    app.run()


#%%
