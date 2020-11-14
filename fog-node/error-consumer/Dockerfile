FROM golang:1.14-alpine
COPY . /app
RUN cd /app && go build .
WORKDIR /app
CMD ["go", "run", "."]
