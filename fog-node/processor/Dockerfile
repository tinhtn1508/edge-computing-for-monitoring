FROM golang:1.14-alpine
COPY . /app
RUN cd /app && go build -o processor
WORKDIR /app
CMD ./processor