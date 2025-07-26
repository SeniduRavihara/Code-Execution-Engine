import requests
import json

# Test the API
url = "http://localhost:8080/api/submit"

# Test data with double quotes
test_cases = [
    {
        "name": "Python with double quotes",
        "data": {
            "code": 'print("Hello World")\nprint("Line 2")',
            "language": "python"
        }
    },
    {
        "name": "Java with double quotes", 
        "data": {
            "code": 'public class Main { public static void main(String[] args) { System.out.println("Hello World"); } }',
            "language": "java"
        }
    },
    {
        "name": "Ballerina with double quotes",
        "data": {
            "code": 'import ballerina/io; public function main() { io:println("Hello World"); }',
            "language": "ballerina"
        }
    }
]

for test_case in test_cases:
    print(f"\n=== Testing {test_case['name']} ===")
    try:
        response = requests.post(url, json=test_case['data'])
        result = response.json()
        print(f"Status: {response.status_code}")
        print(f"Success: {result.get('success')}")
        print(f"Output: {result.get('output')}")
        if not result.get('success'):
            print(f"Error: {result.get('error')}")
    except Exception as e:
        print(f"Request failed: {e}")
