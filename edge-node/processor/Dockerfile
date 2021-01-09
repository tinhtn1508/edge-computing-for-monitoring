FROM golang:1.14-alpine
COPY . /app
RUN cd /app && go build -o edge-processor
WORKDIR /app
CMD ./edge-processor
