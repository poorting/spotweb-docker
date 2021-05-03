#!/usr/bin/env sh

mkdir postgres
git clone -b master https://github.com/spotweb/spotweb.git spotweb
chmod a+w spotweb
docker-compose up --build -d
