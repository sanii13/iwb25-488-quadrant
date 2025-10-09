import ballerina/sql;
import ballerina/log;
import backend.models;
import backend.database;

// Repository class for herbal plant operations
public class HerbalPlantRepository {

    // Get all herbal plants
    public function getAllHerbalPlants() returns models:HerbalPlant[]|error {
        sql:ParameterizedQuery query = `
            SELECT plant_id, botanical_name, local_name, description, medicinal_uses, cultivation_steps, image_url, created_at, updated_at
            FROM herbal_plants 
            ORDER BY created_at DESC
        `;
        
        stream<models:HerbalPlant, sql:Error?> resultStream = database:dbClient->query(query);
        models:HerbalPlant[] herbalPlants = [];
        
        check from models:HerbalPlant plant in resultStream
            do {
                herbalPlants.push(plant);
            };
        
        check resultStream.close();
        return herbalPlants;
    }

    // Get herbal plant by ID
    public function getHerbalPlantById(int plantId) returns models:HerbalPlant|error? {
        sql:ParameterizedQuery query = `
            SELECT plant_id, botanical_name, local_name, description, medicinal_uses, cultivation_steps, image_url, created_at, updated_at
            FROM herbal_plants 
            WHERE plant_id = ${plantId}
        `;
        
        models:HerbalPlant|sql:Error result = database:dbClient->queryRow(query);
        
        if result is sql:NoRowsError {
            return ();
        }
        
        if result is sql:Error {
            log:printError("Error fetching herbal plant by ID", 'error = result);
            return result;
        }
        
        return result;
    }

    // Create a new herbal plant
    public function createHerbalPlant(models:NewHerbalPlant newPlant) returns models:HerbalPlant|error {
        sql:ParameterizedQuery query = `
            INSERT INTO herbal_plants (botanical_name, local_name, description, medicinal_uses, cultivation_steps, image_url)
            VALUES (${newPlant.botanical_name}, ${newPlant.local_name}, ${newPlant.description}, 
                    ${newPlant.medicinal_uses}, ${newPlant.cultivation_steps}, ${newPlant.image_url})
            RETURNING plant_id, botanical_name, local_name, description, medicinal_uses, cultivation_steps, image_url, created_at, updated_at
        `;
        
        models:HerbalPlant|sql:Error result = database:dbClient->queryRow(query);
        
        if result is sql:Error {
            log:printError("Error creating herbal plant", 'error = result);
            return result;
        }
        
        return result;
    }

    // Update herbal plant
    public function updateHerbalPlant(int plantId, models:NewHerbalPlant updatedPlant) returns models:HerbalPlant|error? {
        sql:ParameterizedQuery query = `
            UPDATE herbal_plants 
            SET botanical_name = ${updatedPlant.botanical_name}, 
                local_name = ${updatedPlant.local_name}, 
                description = ${updatedPlant.description},
                medicinal_uses = ${updatedPlant.medicinal_uses}, 
                cultivation_steps = ${updatedPlant.cultivation_steps}, 
                image_url = ${updatedPlant.image_url},
                updated_at = CURRENT_TIMESTAMP
            WHERE plant_id = ${plantId}
            RETURNING plant_id, botanical_name, local_name, description, medicinal_uses, cultivation_steps, image_url, created_at, updated_at
        `;
        
        models:HerbalPlant|sql:Error result = database:dbClient->queryRow(query);
        
        if result is sql:NoRowsError {
            return ();
        }
        
        if result is sql:Error {
            log:printError("Error updating herbal plant", 'error = result);
            return result;
        }
        
        return result;
    }

    // Delete herbal plant
    public function deleteHerbalPlant(int plantId) returns boolean|error {
        sql:ParameterizedQuery query = `DELETE FROM herbal_plants WHERE plant_id = ${plantId}`;
        
        sql:ExecutionResult|sql:Error result = database:dbClient->execute(query);
        
        if result is sql:Error {
            log:printError("Error deleting herbal plant", 'error = result);
            return result;
        }
        
        return result.affectedRowCount > 0;
    }
}
