import ballerina/sql;
import ballerina/log;
import backend.models;
import backend.database;

// Repository class for remedy operations
public class RemedyRepository {

    // Get all remedies
    public function getAllRemedies() returns models:Remedy[]|error {
        sql:ParameterizedQuery query = `
            SELECT remedy_id, name, description, uses, ingredients, steps, cautions, image_url, created_at, updated_at
            FROM remedies 
            ORDER BY created_at DESC
        `;
        
        stream<models:Remedy, sql:Error?> resultStream = database:dbClient->query(query);
        models:Remedy[] remedies = [];
        
        check from models:Remedy remedy in resultStream
            do {
                remedies.push(remedy);
            };
        
        check resultStream.close();
        return remedies;
    }

    // Get remedy by ID
    public function getRemedyById(int remedyId) returns models:Remedy|error? {
        sql:ParameterizedQuery query = `
            SELECT remedy_id, name, description, uses, ingredients, steps, cautions, image_url, created_at, updated_at
            FROM remedies 
            WHERE remedy_id = ${remedyId}
        `;
        
        models:Remedy|sql:Error result = database:dbClient->queryRow(query);
        
        if result is sql:NoRowsError {
            return ();
        }
        
        if result is sql:Error {
            log:printError("Error fetching remedy by ID", 'error = result);
            return result;
        }
        
        return result;
    }

    // Create a new remedy
    public function createRemedy(models:NewRemedy newRemedy) returns models:Remedy|error {
        sql:ParameterizedQuery query = `
            INSERT INTO remedies (name, description, uses, ingredients, steps, cautions, image_url)
            VALUES (${newRemedy.name}, ${newRemedy.description}, ${newRemedy.uses}, 
                    ${newRemedy.ingredients}, ${newRemedy.steps}, ${newRemedy.cautions}, ${newRemedy.image_url})
            RETURNING remedy_id, name, description, uses, ingredients, steps, cautions, image_url, created_at, updated_at
        `;
        
        models:Remedy|sql:Error result = database:dbClient->queryRow(query);
        
        if result is sql:Error {
            log:printError("Error creating remedy", 'error = result);
            return result;
        }
        
        return result;
    }

    // Update remedy
    public function updateRemedy(int remedyId, models:NewRemedy updatedRemedy) returns models:Remedy|error? {
        sql:ParameterizedQuery query = `
            UPDATE remedies 
            SET name = ${updatedRemedy.name}, 
                description = ${updatedRemedy.description}, 
                uses = ${updatedRemedy.uses},
                ingredients = ${updatedRemedy.ingredients}, 
                steps = ${updatedRemedy.steps}, 
                cautions = ${updatedRemedy.cautions},
                image_url = ${updatedRemedy.image_url},
                updated_at = CURRENT_TIMESTAMP
            WHERE remedy_id = ${remedyId}
            RETURNING remedy_id, name, description, uses, ingredients, steps, cautions, image_url, created_at, updated_at
        `;
        
        models:Remedy|sql:Error result = database:dbClient->queryRow(query);
        
        if result is sql:NoRowsError {
            return ();
        }
        
        if result is sql:Error {
            log:printError("Error updating remedy", 'error = result);
            return result;
        }
        
        return result;
    }

    // Delete remedy
    public function deleteRemedy(int remedyId) returns boolean|error {
        sql:ParameterizedQuery query = `DELETE FROM remedies WHERE remedy_id = ${remedyId}`;
        
        sql:ExecutionResult|sql:Error result = database:dbClient->execute(query);
        
        if result is sql:Error {
            log:printError("Error deleting remedy", 'error = result);
            return result;
        }
        
        return result.affectedRowCount > 0;
    }
}