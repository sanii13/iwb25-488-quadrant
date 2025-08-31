import ballerina/log;
import ballerina/time;
import backend.models;
import backend.repositories;

// Service class for remedy business logic
public class RemedyService {
    private repositories:RemedyRepository remedyRepo;

    public function init() {
        self.remedyRepo = new repositories:RemedyRepository();
    }

    // Get all remedies
    public function getAllRemedies() returns models:RemedyResponse[]|error {
        models:Remedy[]|error remedies = self.remedyRepo.getAllRemedies();
        
        if remedies is error {
            log:printError("Error fetching all remedies", 'error = remedies);
            return remedies;
        }
        
        models:RemedyResponse[] remedyResponses = [];
        foreach models:Remedy remedy in remedies {
            remedyResponses.push(self.mapToResponse(remedy));
        }
        
        return remedyResponses;
    }

    // Get remedy by ID
    public function getRemedyById(int remedyId) returns models:RemedyResponse|models:ErrorResponse|error {
        models:Remedy|error? remedy = self.remedyRepo.getRemedyById(remedyId);
        
        if remedy is error {
            log:printError("Error fetching remedy by ID", 'error = remedy);
            return remedy;
        }
        
        if remedy is () {
            return {
                message: "Remedy not found",
                details: string `Remedy with ID ${remedyId} does not exist`
            };
        }
        
        return self.mapToResponse(remedy);
    }

    // Create a new remedy
    public function createRemedy(models:NewRemedy newRemedy) returns models:RemedyResponse|error {
        models:Remedy|error remedy = self.remedyRepo.createRemedy(newRemedy);
        
        if remedy is error {
            log:printError("Error creating remedy", 'error = remedy);
            return remedy;
        }
        
        return self.mapToResponse(remedy);
    }

    // Update remedy
    public function updateRemedy(int remedyId, models:NewRemedy updatedRemedy) returns models:RemedyResponse|models:ErrorResponse|error {
        models:Remedy|error? remedy = self.remedyRepo.updateRemedy(remedyId, updatedRemedy);
        
        if remedy is error {
            log:printError("Error updating remedy", 'error = remedy);
            return remedy;
        }
        
        if remedy is () {
            return {
                message: "Remedy not found",
                details: string `Remedy with ID ${remedyId} does not exist`
            };
        }
        
        return self.mapToResponse(remedy);
    }

    // Delete remedy
    public function deleteRemedy(int remedyId) returns boolean|models:ErrorResponse|error {
        boolean|error result = self.remedyRepo.deleteRemedy(remedyId);
        
        if result is error {
            log:printError("Error deleting remedy", 'error = result);
            return result;
        }
        
        if !result {
            return {
                message: "Remedy not found",
                details: string `Remedy with ID ${remedyId} does not exist`
            };
        }
        
        return true;
    }

    // Helper function to map Remedy to RemedyResponse
    private function mapToResponse(models:Remedy remedy) returns models:RemedyResponse {
        string? createdAtStr = remedy.created_at is time:Utc ? time:utcToString(<time:Utc>remedy.created_at) : ();
        string? updatedAtStr = remedy.updated_at is time:Utc ? time:utcToString(<time:Utc>remedy.updated_at) : ();
        
        return {
            remedy_id: remedy.remedy_id,
            name: remedy.name,
            description: remedy.description,
            uses: remedy.uses,
            ingredients: remedy.ingredients,
            steps: remedy.steps,
            cautions: remedy.cautions,
            image_url: remedy.image_url,
            created_at: createdAtStr,
            updated_at: updatedAtStr
        };
    }
}