from rest_framework import serializers
from .models import Utilisateur
from django.contrib.auth import get_user_model
User=get_user_model()
class UtilisateurSerializer(serializers.ModelSerializer):
    password=serializers.CharField(max_length=20,write_only=True,required=False)
    username=serializers.CharField(max_length=50,read_only=True,required=False)
    class Meta:
        model=User
        fields=['id','username','email','numtelephone','first_name','last_name','genre','datenaissance','password','photo']

    def create(self, validated_data):
        password=validated_data.pop('password',None)
        validated_data['username']=validated_data['last_name'] +' ' + validated_data['first_name']
        user=super().create(validated_data)
        if password:
            user.set_password(password)
            user.save()
        return user
    
    def update(self, instance, validated_data):
        password=validated_data.pop('password',None)
        validated_data['username']=validated_data['last_name'] + validated_data['first_name']
        user=super().update(instance,validated_data)
        if password:
            user.set_password(password)
            user.save() 
        return user
    
    
class PasswordRessetRequetSerialiser(serializers.Serializer):
    email=serializers.EmailField()
    def validate_email(self,value):
        if not User.objects.filter(email=value).exists():
            raise serializers.ValidationError("ce compte n'existe pas")
        return value
    
class PasswordResetSerialiser(serializers.Serializer):
    password_reset_token=serializers.CharField()
    new_password=serializers.CharField(min_length=6)
    def validate_token(self,value):
        if not User.objects.filter(password_reset_token=value).exists():
            raise serializers.ValidationError("le code saisi n'est pas correct")
        return value
    def save(self):
        data=self.validated_data
        user=User.objects.get(password_reset_token=data['password_reset_token'])
        user.set_password(data['new_password'])
        user.password_reset_token=None
        user.save()