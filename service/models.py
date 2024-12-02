from django.db import models
from django.contrib.auth import get_user_model

User=get_user_model()
# Create your models here.
class Service(models.Model):
    label=models.CharField(max_length=20)
    image=models.ImageField(upload_to='image_service')
    createur=models.ForeignKey(User,on_delete=models.SET_NULL,null=True)
    
    def __str__(self):
        return self.label
    
class SousService(models.Model):
    label=models.CharField(max_length=20)
    image=models.ImageField(upload_to='image_service')
    service=models.ForeignKey(Service,on_delete=models.CASCADE)
    createur=models.ForeignKey(User,on_delete=models.SET_NULL,null=True)
    
    def __str__(self):
        return self.label
    
class Publiciter(models.Model):
    image=models.ImageField(upload_to='pub_image')
    description=models.TextField()
    createur=models.ForeignKey(User,on_delete=models.CASCADE)
    
class Intervention(models.Model):
    typedemande=models.CharField(max_length=30)
    description=models.TextField()
    date=models.DateField(blank=True)
    heure=models.TimeField(blank=True)
    imediatement=models.BooleanField(default=False)
    image0=models.ImageField(upload_to='image_intervention',blank=False,null=False)
    image1=models.ImageField(upload_to='image_intervention',blank=True,null=True)
    image2=models.ImageField(upload_to='image_intervention',blank=True,null=True)
    preferencecontact=models.CharField(max_length=20)
    actif=models.BooleanField(default=True)
    createur=models.ForeignKey(User,on_delete=models.CASCADE)