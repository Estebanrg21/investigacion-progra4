#! /bin/bash

rm feria/migrations/0001_initial.py 

rm -rf feria/migrations/__pycache__/

rm -rf feria/__pycache__/

rm -rf investigacion/__pycache__/

python3 manage.py makemigrations feria

python3 manage.py migrate



