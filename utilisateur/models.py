from django.db import models
from django.contrib.auth.models import AbstractUser
# Create your models here.
class Utilisateur(AbstractUser):
    genres=[('homme','homme'),('femme','femme')]
    email=models.EmailField(blank=True)
    numtelephone=models.CharField(max_length=15,unique=True)
    first_name=models.CharField(max_length=20)
    last_name=models.CharField(max_length=20)
    genre=models.CharField(max_length=10,choices=genres,default='homme')
    datenaissance=models.DateField(null=True)
    photo=models.ImageField(null=True,blank=True,upload_to='photo_profile')
    USERNAME_FIELD='numtelephone'
    REQUIRED_FIELDS=['username']
    def __str__(self):
        return self.username