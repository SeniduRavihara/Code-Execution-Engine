# Python Code Runner

A Docker-based container for executing Python code securely in an isolated environment.

## 📋 Overview

This runner executes Python programs using Python 3.11 in a lightweight, secure Docker container. It provides a simple and efficient way to run Python code with proper isolation.

## 🏗️ Container Details

- **Base Image**: `python:3.11-slim`
- **Working Directory**: `/app`
- **Python Version**: 3.11
- **Security**: Isolated container execution

## 🛠️ Setup Instructions

### 1. Build the Docker Image

```bash
cd python-runner
docker build -t python-runner:latest .
```

### 2. Verify the Build

```bash
docker images | grep python-runner
```

## 🚀 Usage

### Direct Docker Execution

```bash
# Run Python code directly
docker run --rm python-runner:latest 'print("Hello World")'
```

### With Security Constraints

```bash
# Run with resource limits and security
docker run --rm \
  --memory=256m \
  --cpus=1.0 \
  --network=none \
  --pids-limit=50 \
  python-runner:latest \
  'print("Secure execution!")'
```

## 📝 Python Code Examples

### Hello World
```python
print("Hello, World!")
```

### Loop Example
```python
for i in range(5):
    print(f"Count: {i}")
```

### List Processing
```python
numbers = [1, 2, 3, 4, 5]
squared = [x**2 for x in numbers]
print("Original:", numbers)
print("Squared:", squared)
print("Sum:", sum(squared))
```

### Function Example
```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

for i in range(10):
    print(f"F({i}) = {fibonacci(i)}")
```

### Dictionary Example
```python
person = {
    "name": "John Doe",
    "age": 30,
    "city": "New York"
}

print("Person information:")
for key, value in person.items():
    print(f"{key}: {value}")
```

### Class Example
```python
class Calculator:
    def add(self, x, y):
        return x + y
    
    def multiply(self, x, y):
        return x * y

calc = Calculator()
print("5 + 3 =", calc.add(5, 3))
print("5 * 3 =", calc.multiply(5, 3))
```

## 🔧 Container Configuration

### Dockerfile Breakdown

```dockerfile
FROM python:3.11-slim        # Lightweight Python 3.11
WORKDIR /app                 # Set working directory
COPY run.sh /run.sh         # Copy execution script
RUN chmod +x /run.sh        # Make script executable
ENTRYPOINT ["/run.sh"]      # Use custom script as entrypoint
CMD [""]                    # Default empty command
```

### Execution Script (run.sh)

The execution script handles:

1. **Input Validation**: Checks if code is provided
2. **Direct Execution**: Runs Python code using `-c` flag

```bash
#!/bin/sh

if [ -z "$1" ]; then
  echo "No Python code provided"
  exit 1
fi

python3 -c "$1"
```

## 🔐 Security Features

- **Container Isolation**: Each execution runs in a separate container
- **No Persistent Storage**: Container is removed after execution
- **Resource Limits**: Configurable memory and CPU limits
- **Network Isolation**: No external network access when configured
- **Minimal Base**: Uses slim Python image for reduced attack surface

## ⚡ Performance Characteristics

- **Startup Time**: ~1-2 seconds
- **Memory Usage**: Base ~30MB + code execution
- **CPU Usage**: Varies based on code complexity
- **Disk I/O**: Minimal (no file operations)

## 🚦 Error Handling

### Syntax Errors
```bash
$ docker run --rm python-runner:latest 'print("Hello World"'

  File "<string>", line 1
    print("Hello World"
                       ^
SyntaxError: unterminated string literal (detected at line 1)
```

### Runtime Errors
```bash
$ docker run --rm python-runner:latest 'print(1/0)'

Traceback (most recent call last):
  File "<string>", line 1, in <module>
ZeroDivisionError: division by zero
```

### Import Errors
```bash
$ docker run --rm python-runner:latest 'import nonexistent_module'

Traceback (most recent call last):
  File "<string>", line 1, in <module>
ModuleNotFoundError: No module named 'nonexistent_module'
```

## 🐛 Troubleshooting

### Build Issues
```bash
# Check if base image is available
docker pull python:3.11-slim

# Rebuild with no cache
docker build --no-cache -t python-runner:latest .
```

### Runtime Issues
```bash
# Test with simple code
docker run --rm python-runner:latest 'print("Test")'

# Check Python version
docker run --rm python-runner:latest 'import sys; print(sys.version)'
```

### Memory Issues
```bash
# Monitor resource usage
docker stats

# Increase memory limit
docker run --memory=512m python-runner:latest 'code'
```

## 📚 Python Language Features

### Supported Features
- **Core Syntax**: Variables, functions, classes
- **Data Types**: int, float, str, list, dict, set, tuple
- **Control Structures**: if/else, for/while loops
- **Functions**: def, lambda, decorators
- **Classes**: OOP support, inheritance
- **Modules**: Standard library imports
- **Exception Handling**: try/except/finally
- **Comprehensions**: List, dict, set comprehensions

### Available Standard Library
- **Built-ins**: len, range, enumerate, zip, etc.
- **Math**: math, random modules
- **Data Structures**: collections module
- **String Processing**: re, string modules
- **Date/Time**: datetime, time modules
- **JSON**: json module
- **System**: os, sys modules (limited in container)

### Limitations in Container
- **Network I/O**: Disabled for security
- **File I/O**: Limited to container filesystem
- **External Packages**: Only standard library available
- **System Calls**: Limited system access

## 🚦 Usage in Backend

The backend service uses this runner as follows:

```ballerina
// In hackathon-backend/main.bal
os:Command dockerCmd = {
    value: "docker",
    arguments: [
        "run", "--rm",
        "--memory=256m",
        "--cpus=1.0",
        "--network=none",
        "--pids-limit=50",
        "python-runner:latest",
        pythonCode
    ]
};
```

## 📊 Example Output

```bash
$ docker run --rm python-runner:latest 'print("Hello from Docker!")'

Hello from Docker!
```

## 🔧 Customization

### Add Python Packages
Modify `Dockerfile` to install additional packages:
```dockerfile
FROM python:3.11-slim
RUN pip install numpy pandas matplotlib
WORKDIR /app
COPY run.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["/run.sh"]
```

### Custom Python Version
Change the base image:
```dockerfile
FROM python:3.10-slim  # or python:3.9-slim
```

### Add System Packages
Install system dependencies:
```dockerfile
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*
```

## 📈 Performance Optimization

### Memory Optimization
```bash
# Run with minimal memory
docker run --memory=64m python-runner:latest 'print("Low memory")'
```

### CPU Optimization
```bash
# Limit CPU usage
docker run --cpus=0.5 python-runner:latest 'print("Limited CPU")'
```

## 🤝 Integration

This runner integrates with:
- **Main Backend**: Called via Docker commands
- **Multi-Lang Runner**: Alternative unified approach
- **Security System**: Provides isolated execution environment

## 📊 Comparison with Other Runners

| Feature | Python Runner | Java Runner | Ballerina Runner |
|---------|--------------|-------------|------------------|
| Startup Time | ~1-2s | ~3-4s | ~2-3s |
| Memory Usage | ~30MB | ~100MB | ~50MB |
| Compilation | No | Yes | No |
| Error Handling | Runtime only | Compile + Runtime | Runtime only |

## 🔗 Related Documentation

- [Python Documentation](https://docs.python.org/3/)
- [Python Standard Library](https://docs.python.org/3/library/)
- [Docker Python Best Practices](https://docs.docker.com/language/python/)

## 💡 Best Practices

### Code Structure
```python
# Good: Simple, clear structure
def main():
    result = calculate_something()
    print(f"Result: {result}")

def calculate_something():
    return 42

if __name__ == "__main__":
    main()
```

### Error Handling
```python
# Good: Proper error handling
try:
    result = risky_operation()
    print(f"Success: {result}")
except Exception as e:
    print(f"Error: {e}")
```

### Resource Management
```python
# Good: Memory-conscious code
data = [x for x in range(1000)]  # Instead of range(1000000)
print(f"Processed {len(data)} items")
```
