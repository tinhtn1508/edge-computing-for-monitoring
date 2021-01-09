FROM golang:1.14-alpine
COPY . /app
RUN cd /app && go build -o error-comsumer
WORKDIR /app
CMD ./error-comsumer
