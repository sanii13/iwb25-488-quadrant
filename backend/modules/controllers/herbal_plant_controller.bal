import ballerina/http;
import ballerina/log;
import backend.models;
import backend.services;

// HerbalPlant Controller for handling HTTP requests
public class HerbalPlantController {
    private services:HerbalPlantService herbalPlantService;

    public function init() {
        self.herbalPlantService = new services:HerbalPlantService();
    }

    // GET /api/herbal-plants - Get all herbal plants
    public function getAllHerbalPlants(http:Request req) returns http:Response {
        http:Response response = new;
        
        models:HerbalPlantResponse[]|error herbalPlants = self.herbalPlantService.getAllHerbalPlants();
        
        if herbalPlants is error {
            log:printError("Error fetching all herbal plants", 'error = herbalPlants);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to fetch herbal plants"
            });
        } else {
            response.statusCode = 200;
            response.setJsonPayload(herbalPlants);
        }
        
        return response;
    }

    // GET /api/herbal-plants/{id} - Get herbal plant by ID
    public function getHerbalPlantById(http:Request req, int plantId) returns http:Response {
        http:Response response = new;
        
        models:HerbalPlantResponse|models:ErrorResponse|error result = self.herbalPlantService.getHerbalPlantById(plantId);
        
        if result is error {
            log:printError("Error fetching herbal plant by ID", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to fetch herbal plant"
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

    // POST /api/herbal-plants - Create a new herbal plant
    public function createHerbalPlant(http:Request req) returns http:Response {
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
        
        models:NewHerbalPlant|error newPlant = payload.cloneWithType(models:NewHerbalPlant);
        
        if newPlant is error {
            log:printError("Invalid request payload", 'error = newPlant);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Please provide valid herbal plant data"
            });
            return response;
        }
        
        models:HerbalPlantResponse|error result = self.herbalPlantService.createHerbalPlant(newPlant);
        
        if result is error {
            log:printError("Error creating herbal plant", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to create herbal plant"
            });
        } else {
            response.statusCode = 201;
            response.setJsonPayload(result);
        }
        
        return response;
    }

    // PUT /api/herbal-plants/{id} - Update herbal plant
    public function updateHerbalPlant(http:Request req, int plantId) returns http:Response {
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
        
        models:NewHerbalPlant|error updatedPlant = payload.cloneWithType(models:NewHerbalPlant);
        
        if updatedPlant is error {
            log:printError("Invalid request payload", 'error = updatedPlant);
            response.statusCode = 400;
            response.setJsonPayload({
                message: "Invalid request payload",
                details: "Please provide valid herbal plant data"
            });
            return response;
        }
        
        models:HerbalPlantResponse|models:ErrorResponse|error result = self.herbalPlantService.updateHerbalPlant(plantId, updatedPlant);
        
        if result is error {
            log:printError("Error updating herbal plant", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to update herbal plant"
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

    // DELETE /api/herbal-plants/{id} - Delete herbal plant
    public function deleteHerbalPlant(http:Request req, int plantId) returns http:Response {
        http:Response response = new;
        
        boolean|models:ErrorResponse|error result = self.herbalPlantService.deleteHerbalPlant(plantId);
        
        if result is error {
            log:printError("Error deleting herbal plant", 'error = result);
            response.statusCode = 500;
            response.setJsonPayload({
                message: "Internal server error",
                details: "Failed to delete herbal plant"
            });
        } else if result is models:ErrorResponse {
            response.statusCode = 404;
            response.setJsonPayload(result);
        } else {
            response.statusCode = 204;
            response.setJsonPayload({
                message: "Herbal plant deleted successfully"
            });
        }
        
        return response;
    }
}
