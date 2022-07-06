# BUILD STAGE
FROM registry.access.redhat.com/ubi8/go-toolset as builder

USER root

ENV GOPATH=/opt/app-root GOCACHE=/mnt/cache GO111MODULE=on

WORKDIR $GOPATH/src/github.com/golang-ex

COPY . .

RUN wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz && \
    rm -rf /usr/bin/go && rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz && \
    export PATH=$PATH:/usr/local/go/bin && \
    rm go1.18.1.linux-amd64.tar.gz && \
    go build -o example-app

# RUN STAGE
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

ARG ARCH=amd64

COPY --from=builder /opt/app-root/src/github.com/golang-ex/example-app /usr/bin/example-app
ENTRYPOINT ["/usr/bin/example-app"]
