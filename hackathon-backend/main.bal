import ballerina/http;
import ballerina/io;
import ballerina/os;
import ballerina/time;
import ballerina/regex;

service /api on new http:Listener(8080) {

    resource function get hello() returns json {
        return {
            "message": "Welcome to Hackathon Platform!",
            "version": "1.0.0",
            "endpoints": {
                "submit": "POST /api/submit",
                "health": "GET /api/health"
            }
        };
    }

    resource function post submit(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();

        // Extract and validate fields
        string code = check payload.code.ensureType(string);
        string lang = check payload.language.ensureType(string);

        // Validate supported languages
        if !(lang == "python" || lang == "java" || lang == "ballerina") {
            json errorResponse = {
                "success": false,
                "error": "Unsupported language: " + lang,
                "supportedLanguages": ["python", "java", "ballerina"]
            };
            check caller->respond(errorResponse);
            return;
        }

        // For Java, ensure proper class structure
        if lang == "java" && !code.includes("class Main") {
            json errorResponse = {
                "success": false,
                "error": "Java code must contain 'public class Main' with main method",
                "example": "public class Main { public static void main(String[] args) { System.out.println(\"Hello\"); } }"
            };
            check caller->respond(errorResponse);
            return;
        }

        // Record start time
        time:Utc startTime = time:utcNow();

        // Build Docker command with performance monitoring
        string dockerImage = "multi-lang-runner:latest";
        
        // Create proper os:Command record
        os:Command dockerCmd = {
            value: "docker",
            arguments: [
                "run", "--rm",
                "--memory=256m",           // Memory limit
                "--cpus=1.0",             // CPU limit  
                "--network=none",         // No network access
                "--pids-limit=50",        // Process limit
                dockerImage,
                lang,
                code
            ]
        };

        json response;
        
        // Execute the Docker command
        os:Process|os:Error result = os:exec(dockerCmd);
        
        if result is os:Process {
            int exitCode = check result.waitForExit();
            time:Utc endTime = time:utcNow();
            
            // Calculate execution time in seconds, then convert to milliseconds
            decimal executionTimeSeconds = time:utcDiffSeconds(endTime, startTime);
            decimal executionTimeMs = executionTimeSeconds * 1000.0d;
            
            // Read the output from stdout and stderr
            byte[] stdoutBytes = check result.output(io:stdout);
            byte[] stderrBytes = check result.output(io:stderr);
            
            string stdout = check string:fromBytes(stdoutBytes);
            string stderr = check string:fromBytes(stderrBytes);
            
            if exitCode == 0 {
                response = {
                    "success": true,
                    "language": lang,
                    "output": stdout.trim(),
                    "executionTime": {
                        "milliseconds": executionTimeMs,
                        "seconds": executionTimeSeconds
                    },
                    "performance": {
                        "memoryLimit": "512MB",
                        "cpuLimit": "1.0 cores",
                        "processLimit": 50,
                        "networkAccess": false
                    },
                    "analysis": analyzeCode(code, lang),
                    "exitCode": exitCode,
                    "timestamp": time:utcToString(endTime)
                };
            } else {
                response = {
                    "success": false,
                    "language": lang,
                    "error": stderr.trim().length() > 0 ? stderr.trim() : "Code execution failed",
                    "output": stdout.trim(),
                    "executionTime": {
                        "milliseconds": executionTimeMs,
                        "seconds": executionTimeSeconds
                    },
                    "analysis": analyzeCode(code, lang),
                    "exitCode": exitCode,
                    "timestamp": time:utcToString(endTime)
                };
            }
        } else {
            time:Utc endTime = time:utcNow();
            decimal executionTimeSeconds = time:utcDiffSeconds(endTime, startTime);
            decimal executionTimeMs = executionTimeSeconds * 1000.0d;
            
            response = {
                "success": false,
                "error": "Failed to start Docker container: " + result.message(),
                "executionTime": {
                    "milliseconds": executionTimeMs,
                    "seconds": executionTimeSeconds
                }
            };
        }

        check caller->respond(response);
    }

    resource function get health() returns json {
        return {
            "status": "healthy",
            "timestamp": time:utcToString(time:utcNow()),
            "services": {
                "docker": "available",
                "codeExecution": "ready"
            },
            "systemInfo": {
                "memoryLimit": "512MB per execution",
                "timeoutLimit": "30 seconds",
                "supportedLanguages": ["python", "java", "ballerina"]
            }
        };
    }

    resource function get languages() returns json {
        return {
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
        };
    }
}

// Function to analyze code complexity
function analyzeCode(string code, string language) returns json {
    json analysis = {
        "linesOfCode": countLines(code),
        "codeLength": code.length(),
        "complexity": "unknown"
    };

    if language == "python" {
        json pythonAnalysis = analyzePythonComplexity(code);
        json patterns = analyzePythonPatterns(code);
        
        analysis = {
            "linesOfCode": countLines(code),
            "codeLength": code.length(),
            "estimatedComplexity": pythonAnalysis,
            "patterns": patterns
        };
    } else if language == "java" {
        json javaAnalysis = analyzeJavaComplexity(code);
        json patterns = analyzeJavaPatterns(code);
        
        analysis = {
            "linesOfCode": countLines(code),
            "codeLength": code.length(),
            "estimatedComplexity": javaAnalysis,
            "patterns": patterns
        };
    }

    return analysis;
}

function countLines(string code) returns int {
    string[] lines = regex:split(code, "\n");
    // Count non-empty lines
    int nonEmptyLines = 0;
    foreach string line in lines {
        if line.trim().length() > 0 {
            nonEmptyLines += 1;
        }
    }
    return nonEmptyLines;
}

function analyzePythonComplexity(string code) returns json {
    string timeComplexity = "O(?)";
    string spaceComplexity = "O(?)";
    string[] patterns = [];
    
    // Basic pattern detection
    if code.includes("for") && regex:matches(code, ".*for.*for.*") {
        patterns.push("nested_loops");
        timeComplexity = "O(n²) - potential nested loops detected";
    } else if code.includes("for") || code.includes("while") {
        patterns.push("single_loop");
        timeComplexity = "O(n) - single loop detected";
    } else {
        timeComplexity = "O(1) - no loops detected";
    }

    if code.includes("[]") || code.includes("list") || code.includes("dict") {
        patterns.push("data_structures");
        spaceComplexity = "O(n) - data structures detected";
    } else {
        spaceComplexity = "O(1) - minimal space usage";
    }

    return {
        "timeComplexity": timeComplexity,
        "spaceComplexity": spaceComplexity,
        "detectedPatterns": <json>patterns
    };
}

function analyzeJavaComplexity(string code) returns json {
    string timeComplexity = "O(?)";
    string spaceComplexity = "O(?)";
    string[] patterns = [];
    
    // Basic pattern detection for Java
    if code.includes("for") && regex:matches(code, ".*for.*for.*") {
        patterns.push("nested_loops");
        timeComplexity = "O(n²) - potential nested loops detected";
    } else if code.includes("for") || code.includes("while") {
        patterns.push("single_loop");
        timeComplexity = "O(n) - single loop detected";
    } else {
        timeComplexity = "O(1) - no loops detected";
    }

    if code.includes("ArrayList") || code.includes("HashMap") || code.includes("[]") {
        patterns.push("data_structures");
        spaceComplexity = "O(n) - data structures detected";
    } else {
        spaceComplexity = "O(1) - minimal space usage";
    }

    return {
        "timeComplexity": timeComplexity,
        "spaceComplexity": spaceComplexity,
        "detectedPatterns": <json>patterns
    };
}

function analyzePythonPatterns(string code) returns json {
    string[] patterns = [];
    
    if code.includes("def ") {
        patterns.push("function_definition");
    }
    if code.includes("class ") {
        patterns.push("class_definition");
    }
    if code.includes("import ") {
        patterns.push("imports");
    }
    if code.includes("try:") || code.includes("except:") {
        patterns.push("error_handling");
    }
    if code.includes("lambda ") {
        patterns.push("lambda_functions");
    }
    
    return <json>patterns;
}

function analyzeJavaPatterns(string code) returns json {
    string[] patterns = [];
    
    if code.includes("public static void main") {
        patterns.push("main_method");
    }
    if code.includes("class ") {
        patterns.push("class_definition");
    }
    if code.includes("import ") {
        patterns.push("imports");
    }
    if code.includes("try {") || code.includes("catch") {
        patterns.push("error_handling");
    }
    if code.includes("interface ") {
        patterns.push("interface_definition");
    }
    
    return <json>patterns;
}