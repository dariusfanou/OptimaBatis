from django.shortcuts import render
from .models import Service,SousService,Publiciter,Intervention
from .serializer import PubliciterSerializer,ServiceSerializer,SousServiceSerializer,InterventionSerializer
from rest_framework import serializers,generics,mixins,viewsets,permissions,authentication
from django.contrib.auth import get_user_model
User=get_user_model()

# Create your views here.

#publiciter

class PubView(viewsets.GenericViewSet,mixins.CreateModelMixin,mixins.UpdateModelMixin,mixins.DestroyModelMixin):
    queryset=Publiciter.objects.all()
    serializer_class=PubliciterSerializer
    permission_classes=[permissions.IsAdminUser]

class pubListRead(viewsets.GenericViewSet,mixins.ListModelMixin,mixins.RetrieveModelMixin):
    queryset=Publiciter.objects.all()
    serializer_class=PubliciterSerializer
    permission_classes=[permissions.IsAuthenticated]

#service
class ServiceModifView(viewsets.GenericViewSet,mixins.CreateModelMixin,mixins.UpdateModelMixin,mixins.DestroyModelMixin):
    queryset=Service.objects.all()
    serializer_class=ServiceSerializer
    permission_classes=[permissions.IsAdminUser]
    
class ServiceListRetriev(viewsets.GenericViewSet,mixins.ListModelMixin,mixins.RetrieveModelMixin):
    queryset=Service.objects.all()
    serializer_class=ServiceSerializer
    permission_classes=[permissions.IsAuthenticated]
    
    
#sous-service
class SousServiceModifView(viewsets.GenericViewSet,mixins.CreateModelMixin,mixins.UpdateModelMixin,mixins.DestroyModelMixin):
    queryset=SousService.objects.all()
    serializer_class=SousServiceSerializer
    permission_classes=[permissions.IsAdminUser]
    
class SousServiceListRetriev(viewsets.GenericViewSet,mixins.ListModelMixin,mixins.RetrieveModelMixin):
    queryset=SousService.objects.all()
    serializer_class=SousServiceSerializer
    permission_classes=[permissions.IsAuthenticated]
    
#intervention

class InterventionView(viewsets.ModelViewSet):
    queryset=Intervention.objects.all()
    serializer_class=InterventionSerializer
    permission_classes=[permissions.IsAuthenticated]
    def get_object(self):
        user_id=self.request.user.id
        ids=self.kwargs.get('pk')
        try:
            obj=Intervention.objects.get(createur__id=user_id,id=ids )
        except Intervention.DoesNotExist:
            raise serializers.ValidationError('vous ne pouvez pas accéder à cet objet')
        return obj
        
    
    def get_queryset(self):
        if self.request.user.is_staff:
            return Intervention.objects.all()
        else:
            user_id=self.request.user.id
            return Intervention.objects.filter(createur__id=user_id)