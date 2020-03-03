#!/bin/bash
set -m

if [ -z "${CLAMD_HOST}" ]; then
    host=$(ip route show default | awk '/default/ {print $3}')
else
    host="${CLAMD_HOST}"
fi

port="${CLAMD_PORT:-3310}"

echo "using clamd server: ${host}:${port}"

# start in background

java -jar /var/clamav-rest/clamav-rest-1.0.2.jar --clamd.host="${host}" --clamd.port="${port}"
