FROM python:3
RUN python3 -m pip install django
COPY . .

RUN python3 manage.py migrate
EXPOSE 8000
CMD ["python","manage.py","runserver","0.0.0.0:8000"]
