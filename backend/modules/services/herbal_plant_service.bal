import ballerina/log;
import ballerina/time;
import backend.models;
import backend.repositories;

// Service class for herbal plant business logic
public class HerbalPlantService {
    private repositories:HerbalPlantRepository herbalPlantRepo;

    public function init() {
        self.herbalPlantRepo = new repositories:HerbalPlantRepository();
    }

    // Get all herbal plants
    public function getAllHerbalPlants() returns models:HerbalPlantResponse[]|error {
        models:HerbalPlant[]|error herbalPlants = self.herbalPlantRepo.getAllHerbalPlants();
        
        if herbalPlants is error {
            log:printError("Error fetching all herbal plants", 'error = herbalPlants);
            return herbalPlants;
        }
        
        models:HerbalPlantResponse[] plantResponses = [];
        foreach models:HerbalPlant plant in herbalPlants {
            plantResponses.push(self.mapToResponse(plant));
        }
        
        return plantResponses;
    }

    // Get herbal plant by ID
    public function getHerbalPlantById(int plantId) returns models:HerbalPlantResponse|models:ErrorResponse|error {
        models:HerbalPlant|error? plant = self.herbalPlantRepo.getHerbalPlantById(plantId);
        
        if plant is error {
            log:printError("Error fetching herbal plant by ID", 'error = plant);
            return plant;
        }
        
        if plant is () {
            return {
                message: "Herbal plant not found",
                details: string `Herbal plant with ID ${plantId} does not exist`
            };
        }
        
        return self.mapToResponse(plant);
    }

    // Create a new herbal plant
    public function createHerbalPlant(models:NewHerbalPlant newPlant) returns models:HerbalPlantResponse|error {
        models:HerbalPlant|error plant = self.herbalPlantRepo.createHerbalPlant(newPlant);
        
        if plant is error {
            log:printError("Error creating herbal plant", 'error = plant);
            return plant;
        }
        
        return self.mapToResponse(plant);
    }

    // Update herbal plant
    public function updateHerbalPlant(int plantId, models:NewHerbalPlant updatedPlant) returns models:HerbalPlantResponse|models:ErrorResponse|error {
        models:HerbalPlant|error? plant = self.herbalPlantRepo.updateHerbalPlant(plantId, updatedPlant);
        
        if plant is error {
            log:printError("Error updating herbal plant", 'error = plant);
            return plant;
        }
        
        if plant is () {
            return {
                message: "Herbal plant not found",
                details: string `Herbal plant with ID ${plantId} does not exist`
            };
        }
        
        return self.mapToResponse(plant);
    }

    // Delete herbal plant
    public function deleteHerbalPlant(int plantId) returns boolean|models:ErrorResponse|error {
        boolean|error result = self.herbalPlantRepo.deleteHerbalPlant(plantId);
        
        if result is error {
            log:printError("Error deleting herbal plant", 'error = result);
            return result;
        }
        
        if !result {
            return {
                message: "Herbal plant not found",
                details: string `Herbal plant with ID ${plantId} does not exist`
            };
        }
        
        return true;
    }

    // Helper function to map HerbalPlant to HerbalPlantResponse
    private function mapToResponse(models:HerbalPlant plant) returns models:HerbalPlantResponse {
        string? createdAtStr = plant.created_at is time:Utc ? time:utcToString(<time:Utc>plant.created_at) : ();
        string? updatedAtStr = plant.updated_at is time:Utc ? time:utcToString(<time:Utc>plant.updated_at) : ();
        
        return {
            plant_id: plant.plant_id,
            botanical_name: plant.botanical_name,
            local_name: plant.local_name,
            description: plant.description,
            medicinal_uses: plant.medicinal_uses,
            cultivation_steps: plant.cultivation_steps,
            image_url: plant.image_url,
            created_at: createdAtStr,
            updated_at: updatedAtStr
        };
    }
}
