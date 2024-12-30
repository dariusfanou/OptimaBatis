from django.db import models
from django.contrib.auth import get_user_model
from datetime import datetime
User=get_user_model()
# Create your models here.
class Service(models.Model):
    label=models.CharField(max_length=20)
    image=models.ImageField(upload_to='image_service')
    createur=models.ForeignKey(User,on_delete=models.SET_NULL,null=True,blank=True)
    
    def __str__(self):
        return self.label
    
class SousService(models.Model):
    label=models.CharField(max_length=20)
    image=models.ImageField(upload_to='image_service')
    service=models.ForeignKey(Service,on_delete=models.CASCADE)
    createur=models.ForeignKey(User,on_delete=models.SET_NULL,null=True,blank=True)
    
    def __str__(self):
        return self.label
    
class Publiciter(models.Model):
    image=models.ImageField(upload_to='pub_image')
    description=models.TextField()
    createur=models.ForeignKey(User,on_delete=models.CASCADE,null=True,blank=True)
    
class Intervention(models.Model):
    activite=[('annuler','annuler'),('en cour','en cour'),('terminer','terminer')]
    typedemande=models.CharField(max_length=30)
    description=models.TextField()
    date=models.DateField(blank=True)
    heure=models.TimeField(blank=True)
    imediatement=models.BooleanField(default=False)
    image0=models.ImageField(upload_to='image_intervention',blank=False,null=False)
    image1=models.ImageField(upload_to='image_intervention',blank=True,null=True)
    image2=models.ImageField(upload_to='image_intervention',blank=True,null=True)
    preferencecontact=models.CharField(max_length=20)
    actif=models.CharField(max_length=10,default='en cour',choices=activite) 
    createur=models.ForeignKey(User,on_delete=models.CASCADE,null=True,blank=True)
    created_at=models.DateTimeField(auto_now_add=True,default=datetime.now())
    
class Message(models.Model):
    sender=models.ForeignKey(User,on_delete=models.CASCADE,related_name='sender_message')
    receiver=models.ForeignKey(User,on_delete=models.CASCADE,related_name='receiver_message')
    content=models.TextField()
    image=models.ImageField(upload_to='image_message',blank=True,null=True)
    created_at=models.DateTimeField(auto_now_add=True)
    is_read=models.BooleanField(default=False)
    
class Images(models.Model):
    createur=models.ForeignKey(User,on_delete=models.CASCADE,related_name='createur')
    message=models.ForeignKey(Message,on_delete=models.CASCADE,related_name='meaages_images')
    image=models.ImageField(upload_to='image_message')
    created_at=models.DateTimeField(auto_now_add=True)

class Notification(models.Model):
    title=models.CharField(max_length=30)
    content=models.TextField()
    is_read=models.BooleanField(default=False)
    created_at=models.DateTimeField(auto_now_add=True)
    receiver=models.ForeignKey(User,on_delete=models.CASCADE)