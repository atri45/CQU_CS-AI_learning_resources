from math import ceil
from django.db.models import Q
from collections import Counter
from django.db.models.functions import Cast
from django.http import HttpResponseRedirect, JsonResponse
from django.urls import reverse
from django.db.models import Avg, FloatField, F, Count, Min, Max
from django.db.models import IntegerField
from .models import Job
from django.shortcuts import render
from .spyder import JobCrawler
from selenium.common.exceptions import NoSuchWindowException
from selenium.common.exceptions import NoSuchElementException
# 渲染表格数据-------------------------------------------------------------------------------------------------------------
def data_visualization(request):
    jobs = Job.objects.all() # 获取所有的职位数据
    return render(request, 'DataVisualization.html', {'jobs': jobs}) # 将数据传递给模板

# 爬取数据----------------------------------------------------------------------------------------------------------------
def job_search(request):
    if request.method == 'POST':
        job_title = request.POST.get('job_title')
        try:
            # 运行爬虫
            crawler = JobCrawler(job_title)
            crawler.run()
        except NoSuchElementException or NoSuchWindowException:
            crawler.driver.quit()
            print("Element not found, ending session...")
            return HttpResponseRedirect(reverse('visualization:data_visualization'))
            # 此处可以添加任何你希望在此种情况下执行的代码，例如关闭 WebDriver 会话
        finally:
            # 关闭 WebDriver 会话，确保资源被正确释放
            crawler.driver.quit()
        return HttpResponseRedirect(reverse('visualization:data_visualization'))
    else:
        # 如果不是 POST 请求，就显示一个空的表单
        return HttpResponseRedirect(reverse('visualization:data_visualization'))


# 图表数据----------------------------------------------------------------------------------------------------------------
def chart_visualization(request):
    # 获取总工作数
    total_jobs = Job.objects.count()

    # 获取总城市数
    total_cities = Job.objects.values('city').distinct().count()

    # 获取最高工资的工作
    highest_salary_job = Job.objects.annotate(
        max_salary_int=Cast('max_salary', IntegerField())
    ).exclude(max_salary_int=None).order_by('-max_salary_int').first()
    highest_salary = highest_salary_job.max_salary_int if highest_salary_job else None
    # 获取最低工资的工作
    lowest_salary_job = Job.objects.annotate(
        min_salary_int=Cast('min_salary', IntegerField())
    ).exclude(min_salary_int=None).order_by('min_salary_int').first()
    lowest_salary = lowest_salary_job.min_salary_int if lowest_salary_job else None
    # 获取筛选后的数据
    jobs = Job.objects.all().exclude(Q(company_size='不明') | Q(salary='不明') | Q(education='不明') | Q(experience='不明') | Q(min_salary=None) | Q(max_salary=None))
    # 将 min_salary 和 max_salary 字段的值转化为浮点数
    jobs = jobs.annotate(
        min_salary_float=Cast('min_salary', FloatField()),
        max_salary_float=Cast('max_salary', FloatField())
    )
    # 计算每个经验等级的平均工资
    experience_avg_salaries = jobs.values('experience').annotate(
        avg_salary=Avg((F('min_salary_float') + F('max_salary_float')) / 2)
    ).order_by('experience')
    # 计算每个教育等级的平均工资
    education_avg_salaries = jobs.values('education').annotate(
        avg_salary=Avg((F('min_salary_float') + F('max_salary_float')) / 2)
    ).order_by('education')
    # 统计各公司性质的职位数量
    company_nature_data = jobs.values('company_nature').annotate(count=Count('id'))
    # 统计各公司规模的职位数量
    company_size_data = jobs.values('company_size').annotate(count=Count('id'))
    # 统计各行业类别的数量
    industry_data = jobs.values('industry').annotate(count=Count('id'))
    # 统计各城市的数量
    city_data = jobs.values('city').annotate(count=Count('id'))
    # 将数据转化为适合图表的格式
    company_nature_data_chart = [{'name': d['company_nature'], 'value': d['count']} for d in company_nature_data]
    company_size_data_chart = [{'name': d['company_size'], 'value': d['count']} for d in company_size_data]
    industry_data_chart = [{'name': d['industry'], 'value': d['count']} for d in industry_data]
    city_data_chart = [{'name': d['city'], 'value': d['count']} for d in city_data]

    # 平均工资分布直方图----------------------------------------------------------------------------------------------------
    # 计算平均工资
    jobs = Job.objects.filter(min_salary__isnull=False, max_salary__isnull=False).annotate(
        min_salary_int=Cast('min_salary', IntegerField()),
        max_salary_int=Cast('max_salary', IntegerField())
    ).annotate(
        avg_salary=(F('min_salary_int') + F('max_salary_int')) / 2/10000
    )
    min_avg_salary = jobs.aggregate(Min('avg_salary'))['avg_salary__min']
    max_avg_salary = jobs.aggregate(Max('avg_salary'))['avg_salary__max']
    bin_size = ceil((max_avg_salary - min_avg_salary) / 9)
    # 定义边界
    bins = [min_avg_salary + i * bin_size for i in range(10)]

    # 初始化列表以存储计数。
    counts = [0] * len(bins)

    # 计算每个bin的个数
    for job in jobs:
        for i in range(len(bins) - 1):
            if bins[i] <= job.avg_salary < bins[i + 1]:
                counts[i] += 1
                break

    # 词云分析-----------------------------------------------------------------------------------------------------------
    # 从数据库中检索数据并处理标签
    tags_data = Job.objects.exclude(tags__isnull=True).values_list('tags', flat=True)
    tags_list = [tag for tags in tags_data for tag in tags.split(',') if tag]

    # 计数并过滤出现次数为1或者2的词
    tag_counts = Counter(tags_list)
    filtered_tag_counts = {tag: count for tag, count in tag_counts.items() if count > 2}

    # 准备词云数据
    word_cloud_data = [{'name': tag, 'value': count} for tag, count in filtered_tag_counts.items()]

    # 构造一个字典来存储所有的数据-------------------------------------------------------------------------------------------
    data = {
        'experience': list(experience_avg_salaries),
        'education': list(education_avg_salaries),
        'total_jobs': total_jobs,
        'total_cities': total_cities,
        'highest_salary': highest_salary,
        'lowest_salary': lowest_salary,
        'company_nature': company_nature_data_chart,
        'company_size': company_size_data_chart,
        'industry': industry_data_chart,
        'city_geo': city_data_chart,
        'bins': bins,
        'counts': counts,
        'word_cloud_data':word_cloud_data,
    }

    # 如果是 Ajax 请求，返回 JSON 数据
    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        return JsonResponse(data)

    # 如果不是 Ajax 请求，返回 HTML 页面
    return render(request, 'ChartVisualization.html', data)

