import ballerina/http;

// Remedy controller functions
public function getRemedyHello() returns string {
    return "Remedy controller is working!";
}

// Function to handle remedy-related HTTP requests
public function handleRemedyRequest(http:Request req) returns string|error {
    return "Remedy endpoint working!";
}
