import ballerina/http;
import ballerina/io;
import ballerina/file;

service /api on new http:Listener(8080) {

    resource function get hello() returns string {
        return "Welcome to Hackathon Platform!";
    }

    resource function post submit(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();

        // Extract fields safely - cast to string type
        string code = check payload.code.ensureType(string);
        string lang = check payload.language.ensureType(string);

        // Directory and filename for temp code file
        string codeDir = ".\\code";
        
        // Create directory if it doesn't exist
        var createResult = file:createDir(codeDir);
        if createResult is error {
            // Directory might already exist, continue
        }

        string fileName = "";
        string dockerCommand = "";

        if lang == "python" {
            fileName = codeDir + "\\temp.py";
            check io:fileWriteString(fileName, code);
            dockerCommand = "docker run --rm -v " + codeDir + ":/code python:3 python /code/temp.py";

        } else if lang == "java" {
            fileName = codeDir + "\\Temp.java";
            check io:fileWriteString(fileName, code);
            dockerCommand = "docker run --rm -v " + codeDir + ":/code openjdk:17 bash -c \"cd /code && javac Temp.java && java Temp\"";

        } else if lang == "javascript" {
            fileName = codeDir + "\\app.js";
            check io:fileWriteString(fileName, code);
            dockerCommand = "docker run --rm -v " + codeDir + ":/code node:18 node /code/app.js";

        } else {
            json errorResponse = {
                "error": "Unsupported language: " + lang
            };
            check caller->respond(errorResponse);
            return;
        }

        // For now, return a success response (Docker execution would need OS-specific handling)
        json response = {
            success: true,
            message: "Code received and saved to " + fileName,
            language: lang,
            dockerCommand: dockerCommand
        };

        check caller->respond(response);
    }
}