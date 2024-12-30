from django.shortcuts import render
from django.contrib.auth import get_user_model
from django.conf import settings
User=get_user_model()
from .serializer import UtilisateurSerializer,PasswordRessetRequetSerialiser,PasswordResetSerialiser,PasswordChange
from rest_framework import generics,permissions,viewsets,mixins,serializers,authentication
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.utils.crypto import get_random_string
from django.utils.timezone import timedelta,now
from django.core.exceptions import ObjectDoesNotExist
import requests
# Create your views here.

class UtilisateurCreateView(generics.CreateAPIView):
    queryset=User.objects.all()
    serializer_class=UtilisateurSerializer

class UtilisateurModifView(viewsets.GenericViewSet,mixins.RetrieveModelMixin,mixins.UpdateModelMixin,mixins.DestroyModelMixin,mixins.ListModelMixin):
    queryset=User.objects.all().order_by('first_name')
    serializer_class=UtilisateurSerializer
    permission_classes=[permissions.IsAuthenticated]
    authentication_classes=[authentication.SessionAuthenticationt]

    def get_object(self):
        pk=self.kwargs.get('pk')
        if self.request.user.is_staff:
            user=self.request.user
            return super().get_object()
        
        if self.request.user.is_authenticated:
            user=self.request.user
            return User.objects.get(id=user.id)
        raise serializers.ValidationError('vous n\'etes pas connecter')
    
    def get_queryset(self):
        if self.request.user.is_staff:
            return User.objects.all().filter(is_staff=False)
        raise serializers.ValidationError('vous ne pouvez pas récupérer la liste des utilisateurs')


class RequetepasswordResset(generics.CreateAPIView):
    serializer_class = PasswordRessetRequetSerialiser

    def perform_create(self, serializer):
        phone_number = serializer.validated_data['phone_number']
        
        try:
            # Recherche de l'utilisateur via le numéro de téléphone
            user = User.objects.get(numtelephone=phone_number)  # Adaptez si nécessaire

            # Génération du token de réinitialisation
            token = get_random_string(6)
            user.password_reset_token = token
            user.token_created_at = now()
            user.save()

            # Message à envoyer par SMS
            message = f"Votre code de réinitialisation est : {token}"

            # Envoi du SMS via l'API FasterMessage
            response = self.send_sms_via_fastermessage(phone_number, message)

            # Vérification de la réponse de l'API
            if response.status_code == 200:
                return Response(
                    {"message": "Un SMS a été envoyé pour réinitialiser votre mot de passe."},
                    status=200
                )
            else:
                return Response(
                    {"error": "Échec de l'envoi du SMS."},
                    status=500
                )
        except User.DoesNotExist:
            return Response(
                {"error": "Numéro de téléphone non trouvé."},
                status=404
            )

    def send_sms_via_fastermessage(self, phone_number, message):
        url = f'https://fastermessage.com/api/v1/sms/send?from=FASTERMSG&to={phone_number}&text={message}'
        headers = {'x-api-key': '953ce7e7e6b4061675eb04206577a4d97747a5e6431823589c9afecd6d0a9738'} 
        try:
            response = requests.get(url, headers=headers)
            return response
        except requests.exceptions.RequestException as e:
            return Response(
                {"error": f"Erreur de communication avec l'API FasterMessage: {str(e)}"},
                status=500
            )




class ConfirmPasswordResset(APIView):
    def post(self, request, *args, **kwargs):
        serializer = PasswordResetSerialiser(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Mot de passe réinitialisé avec succès"}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    
    
class PasswordChangeView(generics.UpdateAPIView):
    serializer_class=PasswordChange
    permission_classes=[permissions.IsAuthenticated]
    queryset=User.objects.all()
    def get_object(self):
        return self.request.user