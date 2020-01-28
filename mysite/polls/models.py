from django.db import models

# Create your models here.
from django.db.models import Model


class Post(Model):
    content = models.CharField(max_length=200)
