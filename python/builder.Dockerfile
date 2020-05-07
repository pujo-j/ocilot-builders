FROM golang:1.14-buster AS OCILOT

ENV OCILOT_VERSION v0.1.2
RUN git clone https://github.com/pujo-j/ocilot /build
RUN cd /build  && git checkout ${OCILOT_VERSION} && CGO_ENABLED=0 GOOS="linux" GOARCH="amd64" go build -ldflags '-extldflags=-static' -o ocilot /build/cmd/ocilot/

FROM docker.pkg.github.com/pujo-j/ocilot-builders/python-base:latest

COPY --from=OCILOT /build/ocilot /usr/local/bin/ocilot

RUN mkdir -p /lua/
COPY lua/* /lua/

VOLUME /deploy/

ENTRYPOINT ["/usr/local/bin/ocilot","-l","/lua","/lua/build.lua"]
