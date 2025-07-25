#!/bin/sh

if [ -z "$1" ]; then
  echo "No Python code provided"
  exit 1
fi

python3 -c "$1"
