from django.shortcuts import render, redirect
from django.db import connection
from django.http import HttpResponse

# Create your views here.

def home(request):
    return HttpResponse('<h1>gotspaceanot?</h1>')
