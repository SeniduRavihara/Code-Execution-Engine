# Hackathon Backend - Code Execution API

A Ballerina-based HTTP service that provides secure code execution capabilities for Python, Java, and Ballerina languages using Docker containers.

## 📋 Overview

This backend service acts as the central API for the multi-language code execution engine. It receives code execution requests, manages Docker containers, provides security controls, and returns detailed execution results with performance metrics and code analysis.

## 🏗️ Architecture

- **Framework**: Ballerina Swan Lake 2201.12.7
- **HTTP Service**: RESTful API on port 8080
- **Container Management**: Docker integration for secure code execution
- **Security**: CORS, resource limits, input validation
- **Analysis**: Code complexity and pattern detection

## 🛠️ Setup Instructions

### Prerequisites

1. **Ballerina Installation**
   ```bash
   # Download and install Ballerina Swan Lake 2201.12.7
   # Visit: https://ballerina.io/downloads/
   ```

2. **Docker Installation**
   ```bash
   # Ensure Docker Desktop is installed and running
   docker --version
   ```

3. **Multi-Language Runner Image**
   ```bash
   # Build the multi-lang-runner Docker image
   cd ../multi-lang-runner
   docker build -t multi-lang-runner:latest .
   ```

### Running the Backend

1. **Navigate to backend directory**
   ```bash
   cd hackathon-backend
   ```

2. **Install dependencies**
   ```bash
   bal build
   ```

3. **Start the service**
   ```bash
   bal run
   ```

4. **Verify service is running**
   ```bash
   curl http://localhost:8080/api/hello
   ```

## 🔧 Configuration

### Project Configuration (Ballerina.toml)

```toml
[package]
org = "senid"
name = "hackathon_backend"
version = "0.1.0"
distribution = "2201.12.7"

[build-options]
observabilityIncluded = true
```

### CORS Configuration

```ballerina
@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://127.0.0.1:5500", "http://localhost:3000", "*"],
        allowCredentials: false,
        allowHeaders: ["Content-Type", "Authorization"],
        allowMethods: ["GET", "POST", "OPTIONS"],
        exposeHeaders: ["Content-Type"]
    }
}
```

### Docker Security Configuration

```ballerina
os:Command dockerCmd = {
    value: "docker",
    arguments: [
        "run", "--rm",
        "--memory=256m",           // Memory limit
        "--cpus=1.0",             // CPU limit  
        "--network=none",         // No network access
        "--pids-limit=50",        // Process limit
        "-e", "CODE_TO_EXECUTE_B64=" + code.toBytes().toBase64(),
        "multi-lang-runner:latest",
        language
    ]
};
```

## 📚 API Endpoints

### 1. POST /api/submit

Execute code in specified language.

**Request:**
```json
{
  "code": "print('Hello World')",
  "language": "python"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "language": "python",
  "output": "Hello World",
  "executionTime": {
    "milliseconds": 45.2,
    "seconds": 0.0452
  },
  "performance": {
    "memoryLimit": "256MB",
    "cpuLimit": "1.0 cores",
    "processLimit": 50,
    "networkAccess": false
  },
  "analysis": {
    "linesOfCode": 1,
    "codeLength": 19,
    "estimatedComplexity": {
      "timeComplexity": "O(1) - no loops detected",
      "spaceComplexity": "O(1) - minimal space usage",
      "detectedPatterns": ["function_call"]
    }
  },
  "exitCode": 0,
  "timestamp": "2024-01-15T10:30:45.123Z"
}
```

**Error Response (200):**
```json
{
  "success": false,
  "language": "python",
  "error": "NameError: name 'undefined_var' is not defined",
  "output": "",
  "executionTime": {
    "milliseconds": 23.1,
    "seconds": 0.0231
  },
  "analysis": {
    "linesOfCode": 1,
    "estimatedComplexity": {
      "timeComplexity": "O(1)",
      "detectedPatterns": []
    }
  },
  "exitCode": 1,
  "timestamp": "2024-01-15T10:30:45.123Z"
}
```

### 2. GET /api/health

Check system health and status.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:45.123Z",
  "services": {
    "docker": "available",
    "codeExecution": "ready"
  },
  "systemInfo": {
    "memoryLimit": "256MB per execution",
    "timeoutLimit": "30 seconds",
    "supportedLanguages": ["python", "java", "ballerina"]
  }
}
```

### 3. GET /api/languages

List supported programming languages.

**Response:**
```json
{
  "supportedLanguages": [
    {
      "name": "python",
      "version": "3.x",
      "fileExtension": ".py",
      "example": "print('Hello, World!')"
    },
    {
      "name": "java", 
      "version": "17",
      "fileExtension": ".java",
      "example": "public class Main { public static void main(String[] args) { System.out.println(\"Hello, World!\"); } }"
    },
    {
      "name": "ballerina",
      "version": "2201.9.0",
      "fileExtension": ".bal", 
      "example": "import ballerina/io; public function main() { io:println(\"Hello, World!\"); }"
    }
  ]
}
```

### 4. GET /api/hello

Welcome endpoint with API information.

**Response:**
```json
{
  "message": "Welcome to Hackathon Platform!",
  "version": "1.0.0",
  "endpoints": {
    "submit": "POST /api/submit",
    "health": "GET /api/health"
  }
}
```

## 🔍 Code Analysis Features

### Complexity Analysis

The backend provides automated code complexity analysis:

#### Python Analysis
- **Loop Detection**: Identifies single and nested loops
- **Data Structure Usage**: Detects lists, dictionaries, etc.
- **Pattern Recognition**: Functions, classes, imports, error handling
- **Time Complexity**: Basic O(1), O(n), O(n²) estimation

#### Java Analysis
- **Loop Detection**: for, while, nested loops
- **Data Structure Usage**: Arrays, ArrayList, HashMap
- **Pattern Recognition**: Classes, methods, imports, error handling
- **Compilation Check**: Validates class structure

#### Example Analysis Output
```json
{
  "linesOfCode": 12,
  "codeLength": 245,
  "estimatedComplexity": {
    "timeComplexity": "O(n²) - potential nested loops detected",
    "spaceComplexity": "O(n) - data structures detected",
    "detectedPatterns": ["nested_loops", "data_structures", "function_definition"]
  }
}
```

## 🔐 Security Features

### Input Validation
- **Language Validation**: Only python, java, ballerina allowed
- **Java Class Validation**: Ensures proper class structure
- **Code Sanitization**: Base64 encoding for safe transmission

### Container Security
- **Memory Limits**: 256MB per execution
- **CPU Limits**: 1.0 core maximum
- **Network Isolation**: No external network access
- **Process Limits**: Maximum 50 processes
- **Execution Timeout**: Built-in timeout protection

### Error Handling
- **Graceful Failures**: Proper error responses for all failure modes
- **Detailed Logging**: Comprehensive error information
- **Resource Cleanup**: Automatic container cleanup

## ⚡ Performance Monitoring

### Execution Metrics
- **Timing**: Millisecond-precision execution time
- **Resource Usage**: Memory and CPU monitoring
- **Exit Codes**: Process exit status tracking
- **Output Capture**: Both stdout and stderr

### Performance Characteristics
- **API Response Time**: ~50-200ms (excluding code execution)
- **Container Startup**: ~2-3 seconds
- **Memory Usage**: ~100MB base + execution overhead
- **Concurrent Requests**: Supports multiple simultaneous executions

## 🚦 Usage Examples

### Python Execution
```bash
curl -X POST http://localhost:8080/api/submit \
  -H "Content-Type: application/json" \
  -d '{
    "code": "for i in range(3): print(f\"Count: {i}\")",
    "language": "python"
  }'
```

### Java Execution
```bash
curl -X POST http://localhost:8080/api/submit \
  -H "Content-Type: application/json" \
  -d '{
    "code": "public class Main { public static void main(String[] args) { System.out.println(\"Hello Java\"); } }",
    "language": "java"
  }'
```

### Ballerina Execution
```bash
curl -X POST http://localhost:8080/api/submit \
  -H "Content-Type: application/json" \
  -d '{
    "code": "import ballerina/io; public function main() { io:println(\"Hello Ballerina\"); }",
    "language": "ballerina"
  }'
```

## 🐛 Troubleshooting

### Common Issues

#### Docker Connection Issues
```bash
# Check if Docker is running
docker ps

# Check if multi-lang-runner image exists
docker images | grep multi-lang-runner

# Test Docker execution manually
docker run --rm multi-lang-runner:latest python
```

#### Port Conflicts
```bash
# Check if port 8080 is in use
netstat -an | grep 8080

# Use different port
bal run --port=8081
```

#### Memory Issues
```bash
# Monitor system resources
docker stats

# Increase Docker memory limits
# Docker Desktop > Settings > Resources > Memory
```

### Debug Mode

Enable detailed logging:
```bash
# Set environment variable for verbose logging
export BALLERINA_LOG_LEVEL=DEBUG
bal run
```

### Testing

```bash
# Test health endpoint
curl http://localhost:8080/api/health

# Test with simple code
curl -X POST http://localhost:8080/api/submit \
  -H "Content-Type: application/json" \
  -d '{"code": "print(\"test\")", "language": "python"}'
```

## 📁 Project Structure

```
hackathon-backend/
├── main.bal                    # Main service implementation
├── Ballerina.toml             # Project configuration
├── Dependencies.toml          # Dependency lock file
├── .devcontainer.json         # Dev container config
├── .gitignore                 # Git ignore rules
├── code/                      # Temporary code storage
│   ├── Temp.java
│   └── temp.py
├── target/                    # Build artifacts
└── README.md                  # This file
```

## 🔧 Development

### Local Development Setup

1. **Install Ballerina VS Code Extension**
2. **Configure Dev Container** (optional)
3. **Set up Docker integration**
4. **Run in development mode:**
   ```bash
   bal run --observability-included
   ```

### Testing Changes

```bash
# Build and test
bal build
bal test

# Run with hot reload (if available)
bal run --hot-reload
```

### Adding New Languages

1. **Update language validation:**
   ```ballerina
   if !(lang == "python" || lang == "java" || lang == "ballerina" || lang == "nodejs") {
   ```

2. **Add analysis functions:**
   ```ballerina
   function analyzeNodejsComplexity(string code) returns json {
       // Implementation
   }
   ```

3. **Update supported languages endpoint**

## 🤝 Integration

### Frontend Integration
- **CORS**: Configured for local development
- **Error Handling**: Consistent error response format
- **Real-time Feedback**: Immediate execution results

### Docker Integration
- **Container Management**: Automatic container lifecycle
- **Resource Monitoring**: Performance metrics collection
- **Security Enforcement**: Consistent security policies

## 📊 Monitoring and Observability

### Built-in Metrics
- Request count and timing
- Error rates and types
- Resource usage patterns
- Container execution statistics

### Health Checks
- Service availability
- Docker connectivity
- Resource availability
- System status

## 🔗 Related Documentation

- [Ballerina Language](https://ballerina.io/learn/)
- [Ballerina HTTP Module](https://lib.ballerina.io/ballerina/http/latest)
- [Docker Integration](https://docs.docker.com/)
- [Container Security Best Practices](https://docs.docker.com/engine/security/)

## 📄 License

This project is part of the Multi-Language Code Execution Engine and follows the same licensing terms.
