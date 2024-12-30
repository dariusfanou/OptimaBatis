from .models import Service,SousService,Publiciter,Intervention,Images,Message,Notification
from rest_framework import serializers
from django.db.models import Q
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
    created_at=serializers.DateTimeField(format="%d/%m/%Y %H:%M")
    createur_info=serializers.SerializerMethodField()
    enAttente=serializers.SerializerMethodField()
    enCour=serializers.SerializerMethodField()
    terminer=serializers.SerializerMethodField()
    annuler=serializers.SerializerMethodField()
    total=serializers.SerializerMethodField()
    class Meta:
        model=Intervention
        fields=['id','typedemande','description','date','heure','imediatement','image0','image1','image2'
                ,'preferencecontact','actif','createur','createur_info','created_at','enCour','enAttente','annuler','terminer','total']
        read_only_fields=['createur','is_read']
        
    def create(self, validated_data):
        if self.context['request'].user.is_authenticated:
            validated_data['createur']=self.context['request'].user
            return super().create(validated_data)
        raise serializers.ValidationError('vous n\'etes pas connecter')
    
    def update(self, instance, validated_data):
        if self.context['request'].user.is_authenticated:
            validated_data['createur']=instance.user
            return super().update(instance, validated_data)
        raise serializers.ValidationError('vous n\'etes pas connecter')
    
    def get_createur_info(self,obj):
        if obj.createur.photo:
            return {"username":obj.createur.username,"photo":self.context['request'].build_absolute_uri(obj.createur.photo)}
        else:
            return {"username":obj.createur.username,"photo": None}
        
    def get_enCour(self,obj):
        return Intervention.objects.filter(actif='en cour').count()
    
    def get_enAttente(self,obj):
        return Intervention.objects.filter(actif='en attente').count()
    
    def get_terminer(self,obj):
        return Intervention.objects.filter(actif='terminer').count()
    
    def get_annuler(self,obj):
        return Intervention.objects.filter(actif='annuler').count()
    
    def get_total(self,obj):
        return Intervention.objects.count()
    
class ImageSerializer(serializers.ModelSerializer):
        message=serializers.PrimaryKeyRelatedField(queryset=Message.objects.all())
        created_at=serializers.DateTimeField(format='%d/%m/%Y %H:%M',read_only=True)
        class Meta:
            model=Images
            fields=['id','createur','image','message','created_at']
            read_only_fields=['createur','created_at']
        def create(self, validated_data):
            validated_data['createur']=self.context.get('request').user
            return super().create(validated_data)   
        
class MessageSerilizer(serializers.ModelSerializer):
        receiver=serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
        created_at=serializers.DateTimeField(format='%d/%m/%Y %H:%M',read_only=True)
        createur_info=serializers.SerializerMethodField()
        class Meta:
            model=Message
            fields=['id','sender','receiver','content','created_at','image_message','is_read','image','createur_info']
            read_only_fields=['sender','created_at']
        def create(self, validated_data):
            validated_data['sender']=self.context.get('request').user
            if validated_data['content']==None and validated_data['image']==None:
                raise serializers.ValidationError('le content et image doivent pas rester vide')
            return super().create(validated_data)
        
        def get_createur_info(self,obj):
            user=self.context['request'].user
            if not obj.sender==user:
                return {"id":obj.sender.id,"username":obj.sender.username,"photo":self.context['request'].build_absolute_uri(obj.sender.photo)}
            else:
                return {"id":obj.receiver.id,"username":obj.receiver.username,"photo":self.context['request'].build_absolute_uri(obj.receiver.photo)}
                
            
        
class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model=Notification
        fields=['id','title','content','created_at','receiver']
    
    def create(self,validated_data):
        validated_data['receiver']=self.context['request'].user
        return super().create(validated_data)
    
    def update(self,validated_data,instance):
        validated_data['receiver']=self.context['request'].user
        return super().update(instance,validated_data)