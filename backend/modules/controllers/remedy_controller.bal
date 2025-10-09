import ballerina/http;
import ballerina/log;
import backend.models;
import backend.services;

// Remedy Controller for handling HTTP requests
public class RemedyController {
    private services:RemedyService remedyService;

    public function init() {
        self.remedyService = new services:RemedyService();
    }

    // GET /api/remedies - Get all remedies
    public function getAllRemedies(http:Request req) returns http:Response {
        http:Response response = new;
        
        models:RemedyResponse[]|error remedies = self.remedyService.getAllRemedies();
        
        if remedies is error {
            log:printError("Error fetching all remedies", 'error = remedies);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to fetch remedies"
            });
        } else {
            response.statusCode = 200;
            response.setJsonPayload(remedies);
        }
        
        return response;
    }

    // GET /api/remedies/{id} - Get remedy by ID
    public function getRemedyById(http:Request req, int remedyId) returns http:Response {
        http:Response response = new;
        
        models:RemedyResponse|models:ErrorResponse|error result = self.remedyService.getRemedyById(remedyId);
        
        if result is error {
            log:printError("Error fetching remedy by ID", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to fetch remedy"
            });
        } else if result is models:ErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 200;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // POST /api/remedies - Create a new remedy
    public function createRemedy(http:Request req) returns http:Response {
        http:Response response = new;
        
        json|error payload = req.getJsonPayload();
        
        if payload is error {
            log:printError("Error reading request payload", 'error = payload);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Unable to parse JSON payload"
            });
            return response;
        }
        
        models:NewRemedy|error newRemedy = payload.cloneWithType(models:NewRemedy);
        
        if newRemedy is error {
            log:printError("Invalid request payload", 'error = newRemedy);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Please provide valid remedy data"
            });
            return response;
        }
        
        models:RemedyResponse|error result = self.remedyService.createRemedy(newRemedy);
        
        if result is error {
            log:printError("Error creating remedy", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to create remedy"
            });
        } else {
            response.statusCode = 201;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // PUT /api/remedies/{id} - Update remedy
    public function updateRemedy(http:Request req, int remedyId) returns http:Response {
        http:Response response = new;
        
        json|error payload = req.getJsonPayload();
        
        if payload is error {
            log:printError("Error reading request payload", 'error = payload);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Unable to parse JSON payload"
            });
            return response;
        }
        
        models:NewRemedy|error updatedRemedy = payload.cloneWithType(models:NewRemedy);
        
        if updatedRemedy is error {
            log:printError("Invalid request payload", 'error = updatedRemedy);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Please provide valid remedy data"
            });
            return response;
        }
        
        models:RemedyResponse|models:ErrorResponse|error result = self.remedyService.updateRemedy(remedyId, updatedRemedy);
        
        if result is error {
            log:printError("Error updating remedy", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to update remedy"
            });
        } else if result is models:ErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 200;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // DELETE /api/remedies/{id} - Delete remedy
    public function deleteRemedy(http:Request req, int remedyId) returns http:Response {
        http:Response response = new;
        
        boolean|models:ErrorResponse|error result = self.remedyService.deleteRemedy(remedyId);
        
        if result is error {
            log:printError("Error deleting remedy", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to delete remedy"
            });
        } else if result is models:ErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 204;
            response.setJsonPayload({
                message: "Remedy deleted successfully"
            });
        }
        
        return response;
    }
}
