from django.urls import include, path, re_path
from django.views.generic import RedirectView

urlpatterns = [

    path('visualization/', include('visualization.urls')),
    re_path(r'^$', RedirectView.as_view(url='/visualization/data_visualization/')),
    path('favicon.ico', RedirectView.as_view(url='/static/favicon.ico')),

    # 其他 URL 配置...
]
