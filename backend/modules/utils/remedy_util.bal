import ballerina/http;
import ballerina/log;

// Common utility functions for remedy operations

// Validate remedy data
public function validateRemedyData(json remedyData) returns boolean {
    // Check if required fields exist
    if !(remedyData is map<json>) {
        return false;
    }
    
    map<json> dataMap = <map<json>>remedyData;
    
    if !dataMap.hasKey("name") || 
       !dataMap.hasKey("description") || 
       !dataMap.hasKey("uses") ||
       !dataMap.hasKey("ingredients") ||
       !dataMap.hasKey("steps") ||
       !dataMap.hasKey("cautions") {
        return false;
    }
    
    // Check if name is not empty
    json nameField = dataMap.get("name");
    if nameField is string && nameField.trim().length() == 0 {
        return false;
    }
    
    // Check if ingredients and steps are arrays
    json ingredientsField = dataMap.get("ingredients");
    json stepsField = dataMap.get("steps");
    json cautionsField = dataMap.get("cautions");
    
    if !(ingredientsField is json[]) || !(stepsField is json[]) || !(cautionsField is json[]) {
        return false;
    }
    
    return true;
}

// Sanitize string input
public function sanitizeString(string input) returns string {
    // Remove leading and trailing whitespace
    string sanitized = input.trim();
    
    // Replace multiple spaces with single space
    // Note: In production, you might want to use regex for more sophisticated sanitization
    return sanitized;
}

// Validate URL format (basic validation)
public function isValidUrl(string? url) returns boolean {
    if url is () || url.trim().length() == 0 {
        return true; // URL is optional
    }
    
    // Basic URL validation - starts with http or https
    return url.trim().startsWith("http://") || url.trim().startsWith("https://");
}

// Create standardized error response
public function createErrorResponse(int statusCode, string message, string? details = ()) returns http:Response {
    http:Response response = new;
    response.statusCode = statusCode;
    
    json errorPayload = {
        "message": message
    };
    
    if details is string {
        errorPayload = {
            "message": message,
            "details": details
        };
    }
    
    response.setJsonPayload(errorPayload);
    return response;
}

// Log request details for debugging
public function logRequest(http:Request req, string endpoint) {
    log:printInfo(string `Received ${req.method} request to ${endpoint}`);
}

// Validate positive integer
public function isValidId(int id) returns boolean {
    return id > 0;
}