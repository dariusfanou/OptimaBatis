from django.shortcuts import render
from .models import Service,SousService,Publiciter,Intervention,Images,Message,Notification
from .serializer import PubliciterSerializer,ServiceSerializer,SousServiceSerializer,InterventionSerializer,MessageSerilizer,ImageSerializer,NotificationSerializer
from rest_framework import serializers,generics,mixins,viewsets,permissions,authentication
from django.db.models import Q
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
    queryset=Intervention.objects.all().order_by('-created_at')
    serializer_class=InterventionSerializer
    permission_classes=[permissions.IsAuthenticated]
    filterset_fields=['actif']
    def get_object(self):
        user_id=self.request.user.id
        ids=self.kwargs.get('pk')
        if self.request.user.is_staff :
            return super().get_object()
        
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
        
class MessageView(viewsets.GenericViewSet,mixins.ListModelMixin,mixins.RetrieveModelMixin,mixins.CreateModelMixin,mixins.UpdateModelMixin,mixins.UpdateModelMixin):
    queryset=Message.objects.all().order_by('-created_at')
    serializer_class=MessageSerilizer
    permission_classes=[permissions.IsAuthenticated]
    authentication_classes=[authentication.SessionAuthentication]
    filterset_fields=['is_read']
    def get_queryset(self):
            user_id=self.request.user.id
            return Message.objects.filter(Q(sender__id=user_id) | Q(receiver__id=user_id))
    def get_object(self):
        from django.shortcuts import get_object_or_404      
        user = self.request.user
        receiver_id=self.kwargs.get('pk')
        receiver=get_object_or_404(User,id=receiver_id)
        obj = super().get_object()

        if obj.sender != user and obj.receiver != user:
            raise permissions.PermissionDenied("Vous n'avez pas le droit d'accéder à ce message.")
        if user and user.is_authentication:
            return Message.objects.filter((Q(sender=user) & Q(receiver=receiver)) |(Q(sender=receiver) & Q(receiver=user))).last()
        return obj
        
class ImageView(viewsets.GenericViewSet,mixins.ListModelMixin,mixins.RetrieveModelMixin,mixins.CreateModelMixin):
    queryset=Images.objects.all().order_by('-created_at')
    serializer_class=ImageSerializer
    permission_classes=[permissions.IsAuthenticated]
    authentication_classes=[authentication.SessionAuthentication]
    def get_queryset(self):
            user_id=self.request.user.id
            return Images.objects.filter(
            message__sender=self.request.user
        ) | Images.objects.filter(
            message__receiver=user_id
        )
        
    def get_object(self):
        # Récupère une image spécifique en vérifiant les droits d'accès
        user = self.request.user
        obj = super().get_object()

        if obj.message.sender != user and obj.message.receiver != user:
            raise permissions.PermissionDenied("Vous n'avez pas le droit d'accéder à cette image.")
        return obj
    
class NotificationView(viewsets.ModelViewSet):
    queryset=Notification.objects.all().order_by('-created_at')
    serializer_class=NotificationSerializer
    permission_classes=[permissions.IsAuthenticated]