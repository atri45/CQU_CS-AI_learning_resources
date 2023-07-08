from selenium.webdriver.common.by import By
import re
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import random
from selenium.common.exceptions import NoSuchElementException
import time
from tqdm import tqdm
import pymysql
from .models import Job
class JobCrawler:

    def __init__(self, search_job_name):
        self.search_job_name = search_job_name
        self.db = pymysql.connect(host='localhost', user='root', password='123123', database='job_data')
        self.cursor = self.db.cursor()
        self.user_agent_list = [
                    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.66 Safari/535.11',
                    'Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.66 Safari/535.11',
                    'Mozilla/5.0 (Windows NT 6.2) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.66 Safari/535.11',
                    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.53 Safari/537.36',
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36',
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.79 Safari/537.36',
                    'Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.2 (KHTML, like Gecko) Ubuntu/11.10 Chromium/15.0.874.120 Chrome/15.0.874.120 Safari/535.2',
                    'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.872.0 Safari/535.2',
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_5_8) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.801.0 Safari/535.1',
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.794.0 Safari/535.1',
                    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.24 Safari/535.1',
        ]
        self.driver = None
        self.max_page = 0

    # 使用正则表达式判断字符串是否包含数字，如 '3-4年'
    def is_num(self,s):
        return bool(re.match(r'\d', s.strip()))

    # 定义所有可能的教育程度
    def is_education(self,s):
        educations = ['博士', '硕士', '本科', '大专', '高中', '中专', '中技', '初中及以下', '无学历要求']
        return any([edu in s for edu in educations])

    # 启动浏览器驱动
    def setup_browser(self):
        options = Options()
        options.add_argument(f'user-agent={random.choice(self.user_agent_list)}')
        self.driver = webdriver.Chrome(options=options)

    # 填入想要搜索的工作
    def search_job(self):
        self.driver.get('https://we.51job.com/pc/search')
        # 定义你的 cookies
        cookies_string = "acw_tc=ac11000116885414640118085e00e1fbe240cef38a550e6f3cd8a90dc86dc2; sajssdk_2015_cross_new_user=1; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%2218924ea06267b3-0b756e0e2fe6278-81c4729-3686400-18924ea062712b3%22%2C%22first_id%22%3A%22%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E7%9B%B4%E6%8E%A5%E6%B5%81%E9%87%8F%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC_%E7%9B%B4%E6%8E%A5%E6%89%93%E5%BC%80%22%2C%22%24latest_referrer%22%3A%22%22%7D%2C%22identities%22%3A%22eyIkaWRlbnRpdHlfY29va2llX2lkIjoiMTg5MjRlYTA2MjY3YjMtMGI3NTZlMGUyZmU2Mjc4LTgxYzQ3MjktMzY4NjQwMC0xODkyNGVhMDYyNzEyYjMifQ%3D%3D%22%2C%22history_login_id%22%3A%7B%22name%22%3A%22%22%2C%22value%22%3A%22%22%7D%2C%22%24device_id%22%3A%2218924ea06267b3-0b756e0e2fe6278-81c4729-3686400-18924ea062712b3%22%7D; guid=6458e981a572348d5b4874019f9e2516; acw_sc__v2=64a5191b5002718e2be9fbb14df13718e239f413; nsearch=jobarea%3D%26%7C%26ord_field%3D%26%7C%26recentSearch0%3D%26%7C%26recentSearch1%3D%26%7C%26recentSearch2%3D%26%7C%26recentSearch3%3D%26%7C%26recentSearch4%3D%26%7C%26collapse_expansion%3D; search=jobarea%7E%60%7C%21recentSearch0%7E%60000000%A1%FB%A1%FA000000%A1%FB%A1%FA0000%A1%FB%A1%FA00%A1%FB%A1%FA99%A1%FB%A1%FA%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA99%A1%FB%A1%FA9%A1%FB%A1%FA99%A1%FB%A1%FA%A1%FB%A1%FA0%A1%FB%A1%FA%A1%FB%A1%FA2%A1%FB%A1%FA1%7C%21; JSESSIONID=57D22202888627CA8E0F0DE1C4DAD278; ssxmod_itna=YqfxnDgD2Q0=ZDxlRAm3G=DCn5pxq7KqD7nmK4vWDBThi4iNDnD8x7YDvmf=nYrrfGEKjYi3e347YgRioHqbecvLI3Dti4GLDmKDy4EZeGGRxBYDQxAYDGDDPDoZPD1D3qDkD7EZlMBsqDEDYp/DiUUD7txdeDjjL6uQeG0DDUOS4G2bj=DYfdq6dTS4ETPWA=DjdrD/+DFoE63kZabBLubN1iFtqGySPGu0qRgReDHGuXlKePq7r3oRSe4CoePnDhb4xqqU7eqbrwKYAx3t+xeYBwd+UZxDD3jjAkeeD===; ssxmod_itna2=YqfxnDgD2Q0=ZDxlRAm3G=DCn5pxq7KqD7nmK4rD8kahDxGXKeQGa0Cj=fQ+x82DxkViiRFKGGYbqOqGeK/L2rPNVrAx2jY2DCuF6FxUGYK2HhiCORs8Uh=m6W3ciCG1PmG4Ne8AKiWYq=FrIOqxDEG=RppK2G5wymeNYIyTd1GT27GF0joxq7qa1PwIv6OPY35p9riaNEuDdt9jYoS7S=HEx4kQ5Zq6NxQLzxCGPU7iu6yNRZqUHEQUhDnuYsaG76gRtH8y4LA=aZ70wu7cITA2wI8MgFPUzED6/fD4YONRYpA4ROX1jyifRln+Xb2gRp17cT/0t3pqO7Qj+=Uemt4/bRD0anIACjAU4gTUxRl+C09X7nIAcyFnrK2HbAHIb4TT=a+QPvXQvZfY+9w73OQ0yDjyrjaUnbx9WrvuS+rYFWWO36RwH8Sd73cFg=DEFDgodP/mA73pAlcrtROKSrcD63f4bonivCq523P0YnaecRb9hb40In07RIDKq8orA5yBLe=vg8uOvuw/mkDqqIc3D077AT2=e7Wqx+KRhu=0ud4xhzWYGn=j3QDO4OtgBr3IzqY9qoeD7=DY9zY2LnicW0wYx2=FCs2XWUxeD==="

        # 将 cookies 字符串转换为字典
        cookies_dict = {cookie.split('=')[0]: cookie.split('=')[1] for cookie in cookies_string.split('; ')}

        # 将 cookies 添加到 WebDriver
        for name, value in cookies_dict.items():
            self.driver.add_cookie({
                'name': name,
                'value': value,
            })
        time.sleep(4)
        self.driver.find_element(By.ID, 'keywordInput').send_keys(self.search_job_name)
        time.sleep(4)
        self.driver.find_element(By.ID, 'search_btn').click()
        time.sleep(3)

    # 获取最大页面
    def get_max_page(self):
        for _ in range(10):
            try:
                self.max_page = int(self.driver.find_element(By.XPATH, '//ul[@class="el-pager"]/li[@class="number"][last()]').text)
                break
            except NoSuchElementException:
                time.sleep(1)
                print('获取不到页面最大页数')

    # 将数据写入数据库

    def write_to_db(self, job_data):
        job = Job(
            job_name=job_data[0] if job_data[0] else '不明',
            salary=job_data[1] if job_data[1] else '不明',
            city=job_data[2] if job_data[2] else '不明',
            experience=job_data[3] if job_data[3] else '不明',
            education=job_data[4] if job_data[4] else '不明',
            tags=job_data[5] if job_data[5] else '',
            company_name=job_data[6] if job_data[6] else '不明',
            company_nature=job_data[7] if job_data[7] else '不明',
            company_size=job_data[8] if job_data[8] else '不明',
            industry=job_data[9] if job_data[9] else '不明',
            remarks_str=job_data[10] if job_data[10] else '不明',
            job_link=job_data[11] if job_data[11] else '不明'
        )
        job.save()

    def clear_if_not_empty(self):
        if Job.objects.exists():  # 判断数据表是否为空
            Job.objects.all().delete()  # 如果不为空就把数据表数据清空

    # 爬取每一页
    def crawl_page(self):
        for page in tqdm(range(1, int((self.max_page+1)/8))):  # 从第一页到最大页/3
            time.sleep(3) # 等待页面加载

            # 只有当页面编号可以被检查间隔整除时，才检查验证拖拉框
            try:
                anti_scraping_element = self.driver.find_element(By.ID, 'WAF_NC_WRAPPER')
                if anti_scraping_element.is_displayed():  # 如果反爬验证框可见
                    print("发现反爬验证框，请稍后再试")
                    break
            except NoSuchElementException:  # 如果找不到反爬验证框
                pass  # 不做任何处理，继续抓取数据

            # 获取数据
            jobs = self.driver.find_elements(By.CSS_SELECTOR, '.j_joblist .e')
            for job in jobs:
                remarks = []  # 初始化空的备注列表
                # 获取工作名
                job_name = job.find_element(By.CSS_SELECTOR, '.jname').text
                # 获取薪水
                salary = job.find_element(By.CSS_SELECTOR, '.sal').text
                # 获取工作标签
                tags = ','.join([tag.text for tag in job.find_elements(By.CSS_SELECTOR, '.tags i') if tag.text])
                # 获取公司名称
                company_name = job.find_element(By.CSS_SELECTOR, '.cname').text
                # 获取城市、经验要求、学历要求
                info_elements = job.find_element(By.CSS_SELECTOR, '.info .d').find_elements_by_tag_name('span')
                info_text = [element.text for element in info_elements if element.text != '|']
                city = experience = education = None
                    # 对城市、经验要求、学历要求可能确实进行处理
                if len(info_text) == 3:
                    city, experience, education = info_text
                elif len(info_text) == 2:
                    # 判断两个值的种类并分配
                    for info in info_text:
                        if self.is_num(info) or info=='无需经验':
                            experience = info
                        elif self.is_education(info):
                            education = info
                        else:
                            city = info
                    remarks.append("{0}公司的{1}工作只提供了城市信息、经验要求、学历要求中的2个".format(company_name,job_name))
                elif len(info_text) == 1:
                    # 判断值的种类并分配
                    info = info_text[0]
                    if self.is_num(info):
                        experience = info
                    elif self.is_education(info):
                        education = info
                    else:
                        city = info
                    remarks.append("{0}公司的{1}工作只提供了城市信息、经验要求、学历要求中的2个".format(company_name,job_name))
                else:
                    remarks.append("{0}公司的{1}工作只提供了城市信息、经验要求、学历要求中的2个".format(company_name,job_name))

                # 获取公司性质和公司规模说明
                dc_text = job.find_element(By.CSS_SELECTOR, '.dc').text
                dc_values = dc_text.split('|')
                    # 对公司性质和公司规模可能缺失经行处理
                if len(dc_values) == 2:
                    company_nature, company_size = dc_values
                elif len(dc_values) == 1:
                    # 判断是否为数字
                    if self.is_num(dc_values[0]):
                        company_size = dc_values[0]
                        company_nature = None
                        remarks.append("{0}公司的{1}工作只提供公司规模".format(company_name, job_name))
                    else:
                        company_nature = dc_values[0]
                        company_size = None
                        remarks.append("{0}公司的{1}工作只提供公司性质".format(company_name, job_name))
                else:
                    company_nature = None
                    company_size = None
                    remarks.append("{0}公司的{1}工作既没提供公司规模也没提供公司性质".format(company_name, job_name))
                # 获取所属行业
                industry = job.find_element(By.CSS_SELECTOR, '.int').text
                remarks_str = ', '.join(remarks)
                # 获取工作链接
                job_link = job.find_element(By.CSS_SELECTOR, 'a.el').get_attribute('href')
                self.write_to_db(
                    [job_name, salary, city, experience, education, tags, company_name, company_nature, company_size,
                     industry, remarks_str,job_link])

            # 翻页报错处理
            for i in range(3):  # 循环3次
                try:
                    if(page==self.max_page):
                        next_page = self.driver.find_element(By.XPATH, f'//ul[@class="el-pager"]/li[text()="{page}"]')
                    else:
                        next_page = self.driver.find_element(By.XPATH, f'//ul[@class="el-pager"]/li[text()="{page + 1}"]')
                    self.driver.execute_script("arguments[0].click();", next_page)
                    break  # 如果成功找到并点击了元素，就跳出循环
                except NoSuchElementException:  # 如果没找到元素
                    if i <3 :  # 如果不是最后一次循环
                        time.sleep(1)  # 等待1秒

                    else:  # 如果是最后一次循环
                        print("没有找到换页元素")


    def get_max_min_salary(self,end, mul, x, mouth=12):
        global min_1
        global max_1
        if x == '100万以上/年':
            min_1, max_1 = None, None
            return min_1, max_1
        if end == '/年':
            x = x.replace(end, '')
            try:
                x = x.replace('万', '')
                temp = x.split('-')
                min_1, max_1 = float(temp[0]) * mul, float(temp[1]) * mul
            except:
                min_1 = max_1 = float(x) * mul
        elif end == '万' or end == '千':
            x = x.replace(end, '')
            try:
                temp = x.split('-')
                if temp[0].endswith('千'):
                    temp[0] = temp[0].replace('千', '')
                    min_1, max_1 = float(temp[0]) * 1000 * mouth, float(temp[1]) * mul * mouth
                else:
                    min_1, max_1 = float(temp[0]) * mul * mouth, float(temp[1]) * mul * mouth
            except:
                min_1 = max_1 = float(temp[0]) * mul * mouth
        elif end=='/天':
            x = x.replace(end, '')
            try:
                if x.endswith('千'):
                    x=x.replace('千','')
                    min_1 = max_1 = float(x) * mul*1000
                elif x.endswith('元'):
                    try:
                        x = x.replace('元', '')
                        temp = x.split('-')
                        min_1, max_1 = float(temp[0]) * mul, float(temp[1]) * mul
                    except: min_1 = max_1 = float(x) * mul
            except:
                min_1 = max_1 = float(x) * mul

        return min_1, max_1

    def clean_salary(self, salary):
        global min_
        global max_
        if str(salary).endswith('万'):
            min_, max_ = self.get_max_min_salary('万', 10000, salary)
        elif str(salary).endswith('/年'):
            min_, max_ = self.get_max_min_salary('/年', 10000, salary)
        elif str(salary).endswith('千'):
            min_, max_ = self.get_max_min_salary('千', 1000, salary)
        elif str(salary).endswith('/天'):
            min_, max_ = self.get_max_min_salary('/天', 250, salary)
        elif str(salary).endswith('薪'):
            mouth = int(salary[-3:-1])
            temp = salary.split('·')
            x = str(temp[0])
            end = x[-1]
            if end == '千':
                mul = 1000
                min_, max_ = self.get_max_min_salary(end, mul, x, mouth)
            elif end == '万':
                mul = 10000
                min_, max_ = self.get_max_min_salary(end, mul, x, mouth)
        else:
            min_, max_ = None, None
        return min_, max_

    def clean_city(self, city):
        try:
            city = city.split('·')[0]
        except:
            pass
        return city

    def clean_data(self):
        # 获取数据库中数据
        jobs = Job.objects.all()
        # 清洗每一项数据
        for job in jobs:
            job.city = self.clean_city(job.city)
            min_salary, max_salary = self.clean_salary(job.salary)
            job.min_salary = min_salary
            job.max_salary = max_salary

            job.save()
    # 运行
    def run(self):
        self.clear_if_not_empty()
        self.setup_browser()
        self.search_job()
        self.get_max_page()
        self.crawl_page()
        self.clean_data()
        self.driver.quit()


