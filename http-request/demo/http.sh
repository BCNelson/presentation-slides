#!/usr/bin/env bash

exec 3<>/dev/tcp/example.com/80

lines=(
  "GET / HTTP/1.1"
  "Host: example.com"
  "User-Agent: curl"
  "Accept: text/html"
  "Connection: close"
  ""
)

printf "%s\r\n" "${lines[@]}" >&3

cat <&3