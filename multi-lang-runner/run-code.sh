#!/bin/bash

LANG="$1"

# Get code from base64 encoded environment variable to avoid shell escaping issues
CODE=$(echo "$CODE_TO_EXECUTE_B64" | base64 -d)

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

case "$LANG" in
  python)
    echo "$CODE" > script.py
    python3 script.py
    ;;

  java)
    echo "$CODE" > Main.java
    javac Main.java && java Main
    ;;

  ballerina)
    echo "$CODE" > main.bal
    bal run main.bal
    ;;

  *)
    echo "Unsupported language: $LANG"
    exit 1
    ;;
esac
