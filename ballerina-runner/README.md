# Ballerina Code Runner

A Docker-based container for executing Ballerina code securely in an isolated environment.

## 📋 Overview

This runner executes Ballerina programs using the official Ballerina Docker image. It provides a simple interface for running Ballerina code with proper isolation and security measures.

## 🏗️ Container Details

- **Base Image**: `ballerina/ballerina:2201.9.0`
- **Working Directory**: `/app`
- **Ballerina Version**: Swan Lake 2201.9.0
- **Security**: Isolated container execution

## 🛠️ Setup Instructions

### 1. Build the Docker Image

```bash
cd ballerina-runner
docker build -t ballerina-runner:latest .
```

### 2. Verify the Build

```bash
docker images | grep ballerina-runner
```

## 🚀 Usage

### Direct Docker Execution

```bash
# Run Ballerina code directly
docker run --rm ballerina-runner:latest 'import ballerina/io; public function main() { io:println("Hello World"); }'
```

### With Security Constraints

```bash
# Run with resource limits and security
docker run --rm \
  --memory=256m \
  --cpus=1.0 \
  --network=none \
  --pids-limit=50 \
  ballerina-runner:latest \
  'import ballerina/io; public function main() { io:println("Secure execution!"); }'
```

## 📝 Ballerina Code Examples

### Hello World
```ballerina
import ballerina/io;

public function main() {
    io:println("Hello, World!");
}
```

### Loop Example
```ballerina
import ballerina/io;

public function main() {
    foreach int i in 0..<5 {
        io:println(string`Count: ${i}`);
    }
}
```

### Function Example
```ballerina
import ballerina/io;

function greet(string name) returns string {
    return string`Hello, ${name}!`;
}

public function main() {
    string message = greet("Ballerina");
    io:println(message);
}
```

### JSON Processing
```ballerina
import ballerina/io;

public function main() {
    json person = {
        "name": "John Doe",
        "age": 30,
        "city": "New York"
    };
    
    io:println("Person: ", person);
    io:println("Name: ", person.name);
}
```

## 🔧 Container Configuration

### Dockerfile Breakdown

```dockerfile
FROM ballerina/ballerina:2201.9.0  # Official Ballerina image
WORKDIR /app                       # Set working directory
ENTRYPOINT ["/bin/bash", "-c"]     # Use bash for execution
CMD ["echo \"$0\" > main.bal && bal run main.bal", "--"]  # Default command
```

### Environment

- **Ballerina Version**: 2201.9.0 (Swan Lake)
- **Java Runtime**: Included in base image
- **Available Libraries**: Standard Ballerina library modules
- **File System**: Temporary container file system

## 🔐 Security Features

- **Container Isolation**: Each execution runs in a separate container
- **No Persistent Storage**: Container is removed after execution
- **Resource Limits**: Can be configured with Docker run parameters
- **Network Isolation**: No external network access when configured

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
        "ballerina-runner:latest",
        ballerinaCode
    ]
};
```

## ⚡ Performance Characteristics

- **Startup Time**: ~2-3 seconds (includes container creation)
- **Memory Usage**: Base ~50MB + code execution
- **CPU Usage**: Varies based on code complexity
- **Disk I/O**: Minimal (temporary files only)

## 🐛 Troubleshooting

### Build Issues
```bash
# Check if base image is available
docker pull ballerina/ballerina:2201.9.0

# Rebuild with no cache
docker build --no-cache -t ballerina-runner:latest .
```

### Runtime Issues
```bash
# Test with simple code
docker run --rm ballerina-runner:latest 'import ballerina/io; public function main() { io:println("Test"); }'

# Check container logs
docker logs <container_id>
```

### Memory Issues
```bash
# Monitor resource usage
docker stats

# Increase memory limit
docker run --memory=512m ballerina-runner:latest <code>
```

## 📚 Ballerina Language Features

### Supported Features
- **Basic Syntax**: Variables, functions, control structures
- **Data Types**: int, string, boolean, decimal, json, xml
- **Collections**: Arrays, maps, records
- **Functions**: Pure functions, main function
- **Modules**: Standard library imports
- **Error Handling**: Basic error handling
- **JSON/XML**: Built-in support for data formats

### Limitations in Container
- **Network I/O**: Disabled for security
- **File I/O**: Limited to container filesystem
- **External Resources**: Cannot access external services
- **Module Installation**: Limited to pre-installed modules

## 🔗 Related Documentation

- [Ballerina Language Guide](https://ballerina.io/learn/)
- [Ballerina Standard Library](https://lib.ballerina.io/)
- [Docker Best Practices](https://docs.docker.com/develop/best-practices/)

## 📊 Example Output

```bash
$ docker run --rm ballerina-runner:latest 'import ballerina/io; public function main() { io:println("Hello from Docker!"); }'

Hello from Docker!
```

## 🤝 Integration

This runner integrates with:
- **Main Backend**: Called via Docker commands
- **Multi-Lang Runner**: Alternative unified approach
- **Security System**: Provides isolated execution environment
