# Multi-Language Code Execution Engine

A secure, Docker-based code execution platform that supports Python, Java, and Ballerina programming languages. This system provides a web interface for writing and executing code with real-time feedback, performance metrics, and complexity analysis.

## 🏗️ Architecture

The system consists of multiple components working together:

- **Frontend**: HTML/JavaScript web interface for code input and result display
- **Backend**: Ballerina HTTP service that handles API requests and manages Docker containers
- **Multi-Language Runner**: Unified Docker container supporting Python, Java, and Ballerina
- **Individual Runners**: Separate Docker containers for each language (optional)

## 🚀 Features

- **Multi-Language Support**: Execute Python, Java, and Ballerina code
- **Security**: Isolated Docker containers with resource limits (256MB RAM, 1 CPU, no network)
- **Performance Monitoring**: Execution time tracking and resource usage metrics
- **Code Analysis**: Complexity analysis and pattern detection
- **DSA Examples**: Built-in Data Structures and Algorithms examples
- **Real-time Execution**: Instant code execution with detailed feedback

## 📋 Prerequisites

- Docker Desktop installed and running
- Ballerina Swan Lake (2201.9.0 or later) for backend
- Web browser for frontend
- Git for version control

## 🛠️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/SeniduRavihara/Code-Execution-Engine.git
cd Runners
```

### 2. Build Docker Images

Build the multi-language runner (recommended):

```bash
cd multi-lang-runner
docker build -t multi-lang-runner:latest .
cd ..
```

Or build individual runners:

```bash
# Build Python runner
cd python-runner
docker build -t python-runner:latest .
cd ..

# Build Java runner  
cd java-runner
docker build -t java-runner:latest .
cd ..

# Build Ballerina runner
cd ballerina-runner
docker build -t ballerina-runner:latest .
cd ..
```

### 3. Start the Backend Service

```bash
cd hackathon-backend
bal run
```

The backend will start on `http://localhost:8080`

### 4. Open the Frontend

Open `index.html` in your web browser or serve it using a local server:

```bash
# Using Python
python -m http.server 5500

# Using Node.js
npx serve .
```

## 🔧 Configuration

### Backend Configuration

The backend service (`hackathon-backend/main.bal`) provides:

- **CORS Support**: Configured for local development
- **Resource Limits**: 256MB memory, 1 CPU core per execution
- **Security**: No network access, process limits
- **Timeouts**: 30-second execution timeout

### Docker Security

Each container runs with strict limitations:

```bash
docker run --rm \
  --memory=256m \
  --cpus=1.0 \
  --network=none \
  --pids-limit=50 \
  multi-lang-runner:latest
```

## 📚 API Endpoints

### POST /api/submit
Execute code in specified language

**Request:**
```json
{
  "code": "print('Hello World')",
  "language": "python"
}
```

**Response:**
```json
{
  "success": true,
  "language": "python",
  "output": "Hello World",
  "executionTime": {
    "milliseconds": 45.2,
    "seconds": 0.0452
  },
  "analysis": {
    "linesOfCode": 1,
    "estimatedComplexity": {
      "timeComplexity": "O(1)",
      "detectedPatterns": ["function_call"]
    }
  }
}
```

### GET /api/health
Check system health and available services

### GET /api/languages
List supported programming languages with examples

## 🧠 DSA Examples

The platform includes built-in examples for:

### Sorting Algorithms
- Bubble Sort (Python, Java, Ballerina)
- Time Complexity: O(n²)

### Search Algorithms  
- Binary Search (Python, Java, Ballerina)
- Time Complexity: O(log n)

### Data Structures
- Linked List (Python)
- Stack (Java) 
- Queue (Ballerina)

### Dynamic Programming
- Fibonacci with memoization (Python)
- Factorial (Java)
- Palindrome checker (Ballerina)

## 🔐 Security Features

- **Container Isolation**: Each execution runs in isolated Docker container
- **Resource Limits**: Memory and CPU constraints prevent resource abuse
- **Network Isolation**: No network access from executing code
- **Process Limits**: Maximum 50 processes per container
- **Execution Timeout**: 30-second maximum execution time
- **Code Validation**: Input validation and sanitization

## 🚦 Usage

1. **Select Language**: Choose Python, Java, or Ballerina
2. **Write Code**: Enter your code in the editor
3. **Execute**: Click "Run" or press Ctrl+Enter
4. **View Results**: See output, execution time, and complexity analysis
5. **Try Examples**: Use built-in DSA examples for learning

## 📁 Project Structure

```
Runners/
├── hackathon-backend/          # Ballerina API service
├── multi-lang-runner/          # Unified Docker runner
├── python-runner/              # Python-specific runner
├── java-runner/                # Java-specific runner  
├── ballerina-runner/           # Ballerina-specific runner
├── index.html                  # Web frontend
└── README.md                   # This file
```

## 🐛 Troubleshooting

### Docker Issues
- Ensure Docker Desktop is running
- Check if images are built: `docker images`
- Verify container limits: `docker stats`

### Backend Issues
- Check if port 8080 is available
- Verify Ballerina installation: `bal version`
- Review backend logs for errors

### CORS Issues
- Ensure backend CORS is configured
- Use proper origin in requests
- Check browser developer tools

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Related Projects

- [Ballerina Language](https://ballerina.io/)
- [Docker Documentation](https://docs.docker.com/)
- [Code Execution Security Best Practices](https://owasp.org/www-community/vulnerabilities/Code_Injection)
