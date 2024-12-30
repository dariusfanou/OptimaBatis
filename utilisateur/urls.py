from django.urls import path,include
from .views import UtilisateurCreateView,UtilisateurModifView,RequetepasswordResset,ConfirmPasswordResset,PasswordChangeView
from service.views import PubView,pubListRead,ServiceListRetriev,ServiceModifView,SousServiceListRetriev,SousServiceModifView,MessageView,ImageView,NotificationView
from service.views import InterventionView
from rest_framework.routers import DefaultRouter
route=DefaultRouter()
route.registry.extend([
    (r'usermodif',UtilisateurModifView,'usermodif'),
    (r'puball',PubView,'puball'),
    (r'pubalistretriev',pubListRead,'pubalistretriev'),
    (r'serviceretriev',ServiceListRetriev,'serviceretriev'),
    (r'serviceremodifcreate',ServiceModifView,'servicemodifcreate'),
    (r'sousserviceretriev',SousServiceListRetriev,'sousserviceretriev'),
    (r'sousserviceremodifcreate',SousServiceModifView,'sousservicemodifcreate'),
    (r'intervention',InterventionView,'intervention'),
    (r'discussion',MessageView,'discussion'),
    (r'imagediscussion',ImageView,'imgdiscussion'),
    (r'notification',NotificationView,'notifications'),
])
urlpatterns = [
    path('usercreate',UtilisateurCreateView.as_view()),
    path('',include(route.urls)),
    path('passwordreset/',RequetepasswordResset.as_view(),name='password-reset'),
    path('passwordget/<str:token>/',ConfirmPasswordResset.as_view(),name='password-reset-confirm'),
    path('passwordchange/',PasswordChangeView.as_view(),name='password-change')
]
