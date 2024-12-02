from .models import Service,SousService,Publiciter,Intervention
from rest_framework import serializers
from django.contrib.auth import get_user_model
User=get_user_model()


class PubliciterSerializer(serializers.ModelSerializer):
    
    class Meta:
        model=Publiciter
        fields=['id','image','description','createur']
        read_only_field=['createur']
        
    def create(self,validated_data):
        if self.context['request'].user.is_authenticated:
            validated_data['createur']=self.context['request'].user
            return super().create(validated_data)
        raise serializers.ValidationError('vous n\'etes pas connecter')
    
    def update(self, instance, validated_data):
        if self.context['request'].user.is_authenticated:
            validated_data['createur']=self.context['request'].user
            return super().update(instance, validated_data)
        raise serializers.ValidationError('vous n\'etes pas connecter')
            
            
class ServiceSerializer(serializers.ModelSerializer):
    class Meta:
        model=Service
        fields=['id','label','image','createur']
        read_only_fields=['createur']
        
    def create(self,validated_data):
        if self.context['request'].user.is_authenticated and self.context['request'].user.is_staff:
            validated_data['createur']=self.context['request'].user
            return super().create(validated_data)
        raise serializers.ValidationError('seul les membres admin peuvent créer un service')
    
    def update(self, instance, validated_data):
        if self.context['request'].user.is_authenticated and self.context['request'].user.is_staff:
            validated_data['createur']=self.context['request'].user
            return super().update(instance, validated_data)
        raise serializers.ValidationError('seul les membres admin peuvent créer un service')
    
class SousServiceSerializer(serializers.ModelSerializer):
    service=serializers.PrimaryKeyRelatedField(queryset=Service.objects.all())
    class Meta:
        model=SousService
        fields=['id','label','image','service','createur']
        read_only_fields=['createur']
        
    def create(self,validated_data):
        if self.context['request'].user.is_authenticated and self.context['request'].user.is_staff:
            validated_data['createur']=self.context['request'].user
            return super().create(validated_data)
        raise serializers.ValidationError('seul les membres admin peuvent créer un service')
    
    def update(self, instance, validated_data):
        if self.context['request'].user.is_authenticated and self.context['request'].user.is_staff:
            validated_data['createur']=self.context['request'].user
            return super().update(instance, validated_data)
        raise serializers.ValidationError('seul les membres admin peuvent créer un service')
    
    
class InterventionSerializer(serializers.ModelSerializer):
    date=serializers.DateField(format="%d-%m-%Y")
    heure=serializers.TimeField(format="%H:%M")
    class Meta:
        model=Intervention
        fields=['id','typedemande','description','date','heure','imediatement','image0','image1','image2'
                ,'preferencecontact','actif','createur']
        read_only_fields=['createur']
        
    def create(self, validated_data):
        if self.context['request'].user.is_authenticated:
            validated_data['createur']=self.context['request'].user
            return super().create(validated_data)
        raise serializers.ValidationError('vous n\'etes pas connecter')
    
    def update(self, instance, validated_data):
        if self.context['request'].user.is_authenticated:
            validated_data['createur']=self.context['request'].user
            return super().update(instance, validated_data)
        raise serializers.ValidationError('vous n\'etes pas connecter')