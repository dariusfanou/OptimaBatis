from rest_framework import serializers
from .models import Utilisateur
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import check_password
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
        if self.context['request'].user.is_staff:
            validated_data['is_staff']=True
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
    phone_number=serializers.CharField()
    def validate_phone_number(self,value):
        if not User.objects.filter(numtelephone=value).exists():
            raise serializers.ValidationError("ce compte n'existe pas")
        return value
    
    ###
    
class PasswordChange(serializers.Serializer):
    mypassword=serializers.CharField(write_only=True,required=True)
    new_password=serializers.CharField(write_only=True,required=True)
    def validate_mypasswordr(self,value):
        user=self.context['request'].user
        if not check_password(value,user.password):
            raise serializers.ValidationError("mot de passe incorrect")
        return value
    
    def validate_new_password(self,value):
        if len(value)<8:
            raise serializers.ValidationError('le mot de passe doit comporter 8 caracteres')
        
    def update(self, instance, validated_data):
        user=self.context['request'].user
        instance.set_password(validated_data['new_password'])
        instance.save()
        return instance
    
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