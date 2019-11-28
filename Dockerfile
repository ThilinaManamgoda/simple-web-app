FROM golang:1.12.1 AS builder

# Download and install the latest release of dep
ADD https://github.com/golang/dep/releases/download/v0.5.1/dep-linux-amd64 /usr/bin/dep
RUN chmod +x /usr/bin/dep

COPY Gopkg.toml Gopkg.lock $GOPATH/src/github.com/wso2/simpleWebApp/
COPY main.go $GOPATH/src/github.com/wso2/simpleWebApp/
COPY vendor/ $GOPATH/src/github.com/wso2/simpleWebApp/

WORKDIR $GOPATH/src/github.com/wso2/simpleWebApp/
RUN dep ensure

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /simple-web-app $GOPATH/src/github.com/wso2/simpleWebApp

FROM amd64/alpine:3.10.2
COPY --from=builder /simple-web-app ./
RUN chmod +x ./simple-web-app
ENTRYPOINT ["./simple-web-app"]
