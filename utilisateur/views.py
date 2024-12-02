from django.shortcuts import render
from django.contrib.auth import get_user_model
User=get_user_model()
from .serializer import UtilisateurSerializer
from rest_framework import generics,permissions,viewsets,mixins,serializers,authentication
# Create your views here.

class UtilisateurCreateView(generics.CreateAPIView):
    queryset=User.objects.all()
    serializer_class=UtilisateurSerializer
    
class UtilisateurModifView(viewsets.GenericViewSet,mixins.RetrieveModelMixin,mixins.UpdateModelMixin,mixins.DestroyModelMixin):
    queryset=User.objects.all()
    serializer_class=UtilisateurSerializer
    permission_classes=[permissions.IsAuthenticated]
    authentication_classes=[authentication.SessionAuthentication]
    
    def get_object(self):
        if self.request.user.is_authenticated:
            user=self.request.user
            return User.objects.get(id=user.id)
        raise serializers.ValidationError('vous n\'etes pas connecter')
    
    
    