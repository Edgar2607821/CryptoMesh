#!/bin/bash
URL=$1
echo "Waiting for service at $URL..."
until $(curl --output /dev/null --silent --head --fail "$URL"); do
    echo "$URL is not available yet. Retrying in 5 seconds..."
    sleep 5
done
echo "Service is up!"