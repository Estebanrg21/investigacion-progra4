from django.urls import  re_path
from . import views
urlpatterns = [
    re_path(r'^$', views.index, name='index'),
    re_path(r'^reporte-ventas/$', views.reporte_ventas, name='reporte_ventas'),
]