from django.shortcuts import render
from django.contrib.auth import get_user_model
from django.conf import settings
User=get_user_model()
from .serializer import UtilisateurSerializer,PasswordRessetRequetSerialiser,PasswordResetSerialiser
from rest_framework import generics,permissions,viewsets,mixins,serializers,authentication
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.utils.crypto import get_random_string
from django.utils.timezone import timedelta,now
from django.core.mail import send_mail
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
    
    
class RequetepasswordResset(generics.CreateAPIView):
    serializer_class=PasswordRessetRequetSerialiser
    def perform_create(self,serializer):
        email=serializer.validated_data['email']
        user=User.objects.get(email=email)
        token = get_random_string(50)
        user.password_reset_token=token
        user.token_created_at = now()
        user.save()
        reset_url = f"https://optimabatis-1.onrender.com/passwordget/{token}/"
        send_mail(
                subject="Réinitialisation de votre mot de passe",
                message=f"Utilisez ce lien pour réinitialiser votre mot de passe : {reset_url}, code de validation  {token} ",
                from_email=settings.EMAIL_HOST_USER,
                recipient_list=[email],fail_silently=False
            )
        return Response(
                {"message": "Un email a été envoyé pour réinitialiser votre mot de passe."},
            )
        
        
   
            
class ConfirmPasswordResset(generics.RetrieveUpdateAPIView):
    queryset=User.objects.all()
    serializer_class=PasswordResetSerialiser
    def retrieve(self,request,*args,**kwargs):
        return Response({"message":"soumettez votre mot de passe et le jeton "},)
    