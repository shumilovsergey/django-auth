#!/bin/bash

read -p "Enter project name: " project_name

# make env
virtualenv env
source env/bin/activate 

#pip
pip install --upgrade pip
pip install django
pip install python-dotenv
pip install requests
pip install djangorestframework

#make req
pip freeze > requirements.txt

#input project name
django-admin startproject "$project_name" .

# setings.py
cd "$project_name"
sed -i '' "s|'django.contrib.staticfiles',|'django.contrib.staticfiles',\n    'rest_framework',\n    'rest_framework.authtoken',|" settings.py

# make views
echo 'from rest_framework.decorators import api_view' > views.py
echo 'from rest_framework.response import Response' >> views.py

# migration
cd ../
python manage.py createsuperuser
python manage.py migrate

# make files: .env, const.py, test.rest
touch .env

echo 'POST http://127.0.0.1:8000' > test.rest
echo 'Content-Type: application/json' >> test.rest
echo '{:}' >> test.rest


echo 'from dotenv import load_dotenv' > const.py
echo 'import os' >> const.py
echo ' ' >> const.py
echo 'load_dotenv()' >> const.py
echo '# TG_APP = os.getenv("TG_APP")' >> const.py

#git ignore add: env, .env
echo 'env/' > .gitignore
echo '.env' >> .gitignore



