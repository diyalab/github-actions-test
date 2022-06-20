FROM alpine as certs

RUN apk --update add ca-certificates

FROM gcr.io/kaniko-project/executor:debug

SHELL ["/busybox/sh", "-c"]

RUN wget -O /kaniko/jq \
    https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x /kaniko/jq && \
    wget -O /kaniko/reg \
    https://github.com/genuinetools/reg/releases/download/v0.16.1/reg-linux-386 && \
    chmod +x /kaniko/reg && \
    wget -O /crane.tar.gz \ 
    https://github.com/google/go-containerregistry/releases/download/v0.1.1/go-containerregistry_Linux_x86_64.tar.gz && \
    tar -xvzf /crane.tar.gz crane -C /kaniko && \
    rm /crane.tar.gz
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
#RUN
