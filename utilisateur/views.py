from django.shortcuts import render
from django.contrib.auth import get_user_model
User=get_user_model()
from .serializer import UtilisateurSerializer
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
    
    
class RequetepasswordResset(APIView):
    def post(self, request):
        email = request.data.get('email')
        if not email:
            return Response({"error": "L'email est requis."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(email=email)
            token = get_random_string(50)  # Génération du jeton
            user.password_reset_token = token  # Assurez-vous que ce champ existe dans le modèle
            user.token_created_at = now()  # Assurez-vous que ce champ existe dans le modèle
            user.save()

            reset_url = f"https://optimabatis-1.onrender.com/resetpassword/{token}/"
            send_mail(
                subject="Réinitialisation de votre mot de passe",
                message=f"Utilisez ce lien pour réinitialiser votre mot de passe : {reset_url}",
                from_email="isidortoy@gmail.com",
                recipient_list=[email]
            )
            return Response(
                {"message": "Un email a été envoyé pour réinitialiser votre mot de passe."},
                status=status.HTTP_200_OK
            )
        except User.DoesNotExist:
            return Response({"error": "Email introuvable."}, status=status.HTTP_404_NOT_FOUND)

            
class ConfirmPasswordResset(APIView):
    def post(self,request,token):
        new_password=request.data.get('new_password')
        try:
            user=User.objects.get(password_reset_token=token)
            if not user.is_token_valid():
                return Response({"error":"token espiré "},status=status.HTTP_404_BAD_REQUEST)
            user.set_password(new_password)
            user.password_reset_token=None
            user.token_created_at=None
            user.save()
            return Response({"message":"mot de passe réinitialiser"},
                            status=status.HTTP_200_OK)
        except User.DoesNotExist:
             return Response({"error":"token introuvable ."},status=status.HTTP_404_NOT_FOUND)