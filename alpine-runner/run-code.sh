#!/bin/bash

LANG="$1"

# Get code from base64 encoded environment variable
CODE=$(echo "$CODE_TO_EXECUTE_B64" | base64 -d)

# Create temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Set timeout for execution (prevent infinite loops)
TIMEOUT=30

case "$LANG" in
  python)
    echo "$CODE" > script.py
    timeout $TIMEOUT python3 script.py
    EXIT_CODE=$?
    ;;

  java)
    echo "$CODE" > Main.java
    # Compile with timeout
    timeout $TIMEOUT javac Main.java
    if [ $? -eq 0 ]; then
      # Run with timeout
      timeout $TIMEOUT java Main
      EXIT_CODE=$?
    else
      echo "Compilation failed"
      EXIT_CODE=1
    fi
    ;;

  *)
    echo "Supported languages: python, java"
    echo "Usage: run-code <language>"
    EXIT_CODE=1
    ;;
esac

# Clean up
cd /
rm -rf "$TMP_DIR"

# Exit with the same code as the executed program
exit $EXIT_CODE