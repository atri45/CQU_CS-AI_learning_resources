from django.urls import path
from .views import *
app_name = 'visualization'  # 设置应用程序命名空间


urlpatterns = [
    path('data_visualization/', data_visualization, name='data_visualization'),
    path('job_search/', job_search, name='job_search'),
    path('chart_visualization/', chart_visualization, name='chart_visualization'),

]
