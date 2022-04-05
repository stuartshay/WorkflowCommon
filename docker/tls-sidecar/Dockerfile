ARG APPLICATION_NAME='tls-sidecar'
ARG BUILD_DATE='1/1/2022'
ARG BUILD_NUMBER=0

FROM mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine

LABEL org.label-schema.application=${APPLICATION_NAME}
LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.version=6.0.1.${BUILD_NUMBER}

RUN apk add --no-cache gomplate ca-certificates

ADD templates/nginx.conf.tpl /nginx.conf.tpl

ADD scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]