#!/usr/bin/env bash
set -e

if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

cd /var/www/html

# Discuz runtime writable directories. Do not chmod the whole project.
mkdir -p \
  data/cache \
  data/template \
  data/threadcache \
  data/attachment \
  config \
  uc_server/data \
  uc_client/data/cache

for path in data config uc_server/data uc_client/data/cache; do
  if [ -e "$path" ]; then
    chown -R www-data:www-data "$path" 2>/dev/null || true
    find "$path" -type d -exec chmod 0775 {} + 2>/dev/null || true
    find "$path" -type f -exec chmod 0664 {} + 2>/dev/null || true
  fi
done

exec docker-php-entrypoint "$@"
