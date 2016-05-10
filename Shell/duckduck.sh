#!/bin/sh

curl -X POST -d @$1 \
--header "Accept: application/json" --header "Content-Type:application/json" \
https://eexcess-dev.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/recommend | python -mjson.tool

