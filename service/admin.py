from django.contrib import admin
from .models import Service,SousService,Publiciter,Intervention
# Register your models here.
admin.site.register(Service)
admin.site.register(SousService)
admin.site.register(Publiciter)
admin.site.register(Intervention)