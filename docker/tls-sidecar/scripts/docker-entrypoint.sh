#!/bin/sh

if [[ -z "${BACKEND_NAME}" ]]; then
  echo "BACKEND_NAME environment var is undefined"
  exit 1
fi

if [[ -z "${BACKEND_PORT}" ]]; then
  echo "BACKEND_PORT environment var is undefined"
  exit 1
fi

gomplate -f /nginx.conf.tpl -o /etc/nginx/nginx.conf

nginx -t

nginx -g 'daemon off;'