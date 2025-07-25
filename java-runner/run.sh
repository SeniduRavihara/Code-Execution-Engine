#!/bin/sh

# Fail if no code is provided
if [ -z "$1" ]; then
  echo "No Java code provided"
  exit 1
fi

# Save code to file
echo "$1" > Main.java

# Compile
javac Main.java 2> compile_error.txt
if [ $? -ne 0 ]; then
  echo "--- Compilation Error ---"
  cat compile_error.txt
  exit 1
fi

# Run with timeout and memory constraints
timeout 5s java Main 2> runtime_error.txt
EXIT_CODE=$?

if [ $EXIT_CODE -eq 124 ]; then
  echo "--- Timeout ---"
elif [ $EXIT_CODE -ne 0 ]; then
  echo "--- Runtime Error ---"
  cat runtime_error.txt
fi
