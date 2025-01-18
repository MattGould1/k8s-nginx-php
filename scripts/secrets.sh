#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

export $(grep -v '^#' .env | xargs)

echo "SECRET: $(echo -n $SECRET | base64)"
