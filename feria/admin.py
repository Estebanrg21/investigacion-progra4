from django.contrib import admin, messages
from django.db import IntegrityError, OperationalError
from .models import *


class BasicModelAdmin(admin.ModelAdmin):
    def add_view(self, request, form_url='', extra_context=None):
        try:
            return super().add_view(request, form_url, extra_context)
        except (IntegrityError, OperationalError) as e:
            request.method = 'GET'
            messages.error(request, str(e).split(",")[1].replace(")", "").replace("\"", "").replace("'", ""))
            return super().add_view(request, form_url, extra_context)

    def change_view(self, request, object_id, form_url='', extra_context=None):
        try:
            return super().change_view(request, object_id, form_url, extra_context)
        except (IntegrityError, OperationalError) as e:
            request.method = 'GET'
            messages.error(request, str(e).split(",")[1].replace(")", "").replace("\"", "").replace("'", ""))
            return super().change_view(request, object_id, form_url, extra_context)


class PuestoProductosInline(admin.TabularInline):
    model = PuestoProductos


class PuestoAdmin(BasicModelAdmin):
    inlines = [
        PuestoProductosInline
    ]


class AgricultorAdmin(BasicModelAdmin):
    pass


class VentaAdmin(BasicModelAdmin):
    pass


admin.site.register(Producto)
admin.site.register(Puesto, PuestoAdmin)
admin.site.register(Venta, VentaAdmin)
admin.site.register(Agricultor, AgricultorAdmin)

admin.site.site_header = 'Administración de feria'
admin.site.site_title = 'Administración de feria'
admin.site.index_title = 'Feria'

