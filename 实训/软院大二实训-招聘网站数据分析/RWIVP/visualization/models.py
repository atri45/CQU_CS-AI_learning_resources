from django.db import models

class Job(models.Model):
    job_name = models.CharField(max_length=255)
    salary = models.CharField(null=True,max_length=255)
    min_salary = models.CharField(null=True,max_length=255)
    max_salary = models.CharField(null=True,max_length=255)
    city = models.CharField(max_length=255)
    experience = models.CharField(max_length=255)
    education = models.CharField(max_length=255)
    tags = models.CharField(max_length=255)
    company_name = models.CharField(max_length=255)
    company_nature = models.CharField(max_length=255)
    company_size = models.CharField(max_length=255)
    industry = models.CharField(max_length=255)
    remarks_str = models.TextField()
    job_link = models.URLField()
