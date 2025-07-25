#!/bin/bash

LANG="$1"
shift
CODE="$*"

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
