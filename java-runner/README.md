# Java Code Runner

A Docker-based container for executing Java code securely with compilation and runtime error handling.

## 📋 Overview

This runner compiles and executes Java programs using OpenJDK 17 in an isolated Docker environment. It includes comprehensive error handling for both compilation and runtime errors.

## 🏗️ Container Details

- **Base Image**: `openjdk:17-slim`
- **Working Directory**: `/code`
- **Java Version**: OpenJDK 17
- **Security**: Isolated container execution with timeouts

## 🛠️ Setup Instructions

### 1. Build the Docker Image

```bash
cd java-runner
docker build -t java-runner:latest .
```

### 2. Verify the Build

```bash
docker images | grep java-runner
```

## 🚀 Usage

### Direct Docker Execution

```bash
# Run Java code directly
docker run --rm java-runner:latest 'public class Main { public static void main(String[] args) { System.out.println("Hello World"); } }'
```

### With Security Constraints

```bash
# Run with resource limits and security
docker run --rm \
  --memory=256m \
  --cpus=1.0 \
  --network=none \
  --pids-limit=50 \
  java-runner:latest \
  'public class Main { public static void main(String[] args) { System.out.println("Secure execution!"); } }'
```

## 📝 Java Code Examples

### Hello World
```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

### Loop Example
```java
public class Main {
    public static void main(String[] args) {
        for (int i = 0; i < 5; i++) {
            System.out.println("Count: " + i);
        }
    }
}
```

### Array Processing
```java
public class Main {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        int sum = 0;
        
        for (int num : numbers) {
            sum += num;
        }
        
        System.out.println("Sum: " + sum);
        System.out.println("Average: " + (sum / numbers.length));
    }
}
```

### Method Example
```java
public class Main {
    static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n-1) + fibonacci(n-2);
    }
    
    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            System.out.println("F(" + i + ") = " + fibonacci(i));
        }
    }
}
```

## 🔧 Container Configuration

### Dockerfile Breakdown

```dockerfile
FROM openjdk:17-slim          # Lightweight OpenJDK 17
WORKDIR /code                 # Set working directory
COPY run.sh /run.sh          # Copy execution script
RUN chmod +x /run.sh         # Make script executable
ENTRYPOINT ["/run.sh"]       # Use custom script as entrypoint
```

### Execution Script (run.sh)

The execution script handles:

1. **Input Validation**: Checks if code is provided
2. **File Creation**: Saves code to `Main.java`
3. **Compilation**: Uses `javac` with error capture
4. **Execution**: Runs with `java` command
5. **Timeout Handling**: 5-second execution limit
6. **Error Reporting**: Detailed compilation and runtime errors

```bash
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
```

## 🔐 Security Features

- **Container Isolation**: Each execution runs in a separate container
- **No Persistent Storage**: Container is removed after execution
- **Timeout Protection**: 5-second execution limit
- **Resource Limits**: Configurable memory and CPU limits
- **Network Isolation**: No external network access when configured

## ⚡ Performance Characteristics

- **Startup Time**: ~3-4 seconds (includes compilation)
- **Compilation Time**: ~1-2 seconds for simple programs
- **Memory Usage**: Base ~100MB + code execution
- **CPU Usage**: Varies based on code complexity

## 🚦 Error Handling

### Compilation Errors
```bash
$ docker run --rm java-runner:latest 'public class Main { public static void main(String[] args) { System.out.println("Hello World" } }'

--- Compilation Error ---
Main.java:1: error: ';' expected
public class Main { public static void main(String[] args) { System.out.println("Hello World" } }
                                                                                               ^
1 error
```

### Runtime Errors
```bash
$ docker run --rm java-runner:latest 'public class Main { public static void main(String[] args) { int x = 1/0; } }'

--- Runtime Error ---
Exception in thread "main" java.lang.ArithmeticException: / by zero
        at Main.main(Main.java:1)
```

### Timeout Handling
```bash
$ docker run --rm java-runner:latest 'public class Main { public static void main(String[] args) { while(true) {} } }'

--- Timeout ---
```

## 🐛 Troubleshooting

### Build Issues
```bash
# Check if base image is available
docker pull openjdk:17-slim

# Rebuild with no cache
docker build --no-cache -t java-runner:latest .
```

### Compilation Issues
```bash
# Test with simple code
docker run --rm java-runner:latest 'public class Main { public static void main(String[] args) { System.out.println("Test"); } }'

# Check javac version
docker run --rm java-runner:latest 'javac -version'
```

### Runtime Issues
```bash
# Monitor resource usage
docker stats

# Increase timeout (modify run.sh)
timeout 10s java Main
```

## 📚 Java Language Features

### Supported Features
- **Core Syntax**: Classes, methods, variables
- **Data Types**: primitives, arrays, strings
- **Control Structures**: if/else, loops, switch
- **Object-Oriented**: Classes, objects, inheritance
- **Exception Handling**: try/catch/finally
- **Collections**: ArrayList, HashMap (basic usage)
- **Standard Library**: java.lang, java.util

### Limitations in Container
- **Network I/O**: Disabled for security
- **File I/O**: Limited to container filesystem
- **External Libraries**: Only standard library available
- **GUI Applications**: Not supported (headless environment)

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
        "java-runner:latest",
        javaCode
    ]
};
```

## 📊 Example Output

```bash
$ docker run --rm java-runner:latest 'public class Main { public static void main(String[] args) { System.out.println("Hello from Docker!"); } }'

Hello from Docker!
```

## 🔧 Customization

### Modify Timeout
Edit `run.sh` and change the timeout value:
```bash
timeout 10s java Main 2> runtime_error.txt
```

### Add Libraries
Modify `Dockerfile` to include additional JAR files:
```dockerfile
COPY libs/*.jar /code/libs/
ENV CLASSPATH="/code/libs/*:."
```

### Memory Limits
Adjust JVM memory settings in `run.sh`:
```bash
java -Xmx128m Main
```

## 🤝 Integration

This runner integrates with:
- **Main Backend**: Called via Docker commands
- **Multi-Lang Runner**: Alternative unified approach
- **Security System**: Provides isolated execution environment

## 🔗 Related Documentation

- [OpenJDK Documentation](https://openjdk.java.net/documentation/)
- [Java Language Specification](https://docs.oracle.com/javase/specs/)
- [Docker Java Best Practices](https://docs.docker.com/language/java/)
