FROM golang:1.14-alpine
COPY . /app
RUN cd /app && go build -o go-catalog
WORKDIR /app
CMD ./go-catalog