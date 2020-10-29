FROM python:3.7-alpine
COPY . /sensors
RUN apk update && apk add --update alpine-sdk && pip install -r /sensors/requirements.txt
WORKDIR /sensors
EXPOSE 5000
CMD ["python", "main.py", "runserver"]