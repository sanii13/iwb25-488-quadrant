import ballerina/http;

// Main service that handles HTTP requests
service /api on new http:Listener(8080) {

    // Health check endpoint
    resource function get health() returns string {
        return "AyurConnect Backend is running!";
    }

    // Remedies endpoints
    resource function get remedies() returns string {
        return "Remedy endpoint working!";
    }
}
