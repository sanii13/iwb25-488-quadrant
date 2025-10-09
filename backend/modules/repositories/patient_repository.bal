import ballerina/sql;
import ballerina/time;
import ballerina/log;
import backend.database;
import backend.models;

// Patient repository for database operations
public class PatientRepository {

    // Create a new patient
    public function createPatient(models:NewPatient newPatient) returns models:PatientResponse|error {
        string currentTime = time:utcToString(time:utcNow());
        
        sql:ParameterizedQuery query = `
            INSERT INTO patients (user_id, name, phone_number, address, date_of_birth, medical_notes, image_url, created_at, updated_at)
            VALUES (${newPatient.user_id}, ${newPatient.name}, ${newPatient.phone_number}, 
                    ${newPatient.address}, ${newPatient.date_of_birth}, ${newPatient.medical_notes}, 
                    ${newPatient.image_url}, ${currentTime}, ${currentTime})
            RETURNING patient_id, user_id, name, phone_number, address, date_of_birth, 
                      medical_notes, image_url, created_at, updated_at
        `;

        models:Patient|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error creating patient", 'error = result);
            return error("Failed to create patient");
        }

        return self.convertToPatientResponse(result);
    }

    // Get patient by ID
    public function getPatientById(int patientId) returns models:PatientResponse|error? {
        sql:ParameterizedQuery query = `
            SELECT patient_id, user_id, name, phone_number, address, date_of_birth, 
                   medical_notes, image_url, created_at, updated_at
            FROM patients 
            WHERE patient_id = ${patientId}
        `;

        models:Patient|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        if result is sql:Error {
            log:printError("Error getting patient by ID", 'error = result, patientId = patientId);
            return error("Failed to get patient");
        }

        return self.convertToPatientResponse(result);
    }

    // Get patient by user ID
    public function getPatientByUserId(int userId) returns models:PatientResponse|error? {
        sql:ParameterizedQuery query = `
            SELECT patient_id, user_id, name, phone_number, address, date_of_birth, 
                   medical_notes, image_url, created_at, updated_at
            FROM patients 
            WHERE user_id = ${userId}
        `;

        models:Patient|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        if result is sql:Error {
            log:printError("Error getting patient by user ID", 'error = result, userId = userId);
            return error("Failed to get patient");
        }

        return self.convertToPatientResponse(result);
    }

    // Get all patients with pagination
    public function getAllPatients(int page = 1, int 'limit = 10) returns models:PatientResponse[]|error {
        int offset = (page - 1) * 'limit;
        
        sql:ParameterizedQuery query = `
            SELECT patient_id, user_id, name, phone_number, address, date_of_birth, 
                   medical_notes, image_url, created_at, updated_at
            FROM patients 
            ORDER BY created_at DESC
            LIMIT ${'limit} OFFSET ${offset}
        `;

        stream<models:Patient, sql:Error?> resultStream = database:dbClient->query(query);
        models:PatientResponse[] patients = [];

        check from models:Patient patient in resultStream
            do {
                patients.push(self.convertToPatientResponse(patient));
            };

        check resultStream.close();
        return patients;
    }

    // Update patient
    public function updatePatient(int patientId, models:PatientUpdate patientUpdate) returns models:PatientResponse|error? {
        // First check if patient exists
        boolean|error exists = self.patientExists(patientId);
        if exists is error {
            return exists;
        }
        if !exists {
            return ();
        }
        
        // Get current patient data
        models:PatientResponse|error? currentPatient = self.getPatientById(patientId);
        if currentPatient is error {
            return currentPatient;
        }
        if currentPatient is () {
            return ();
        }
        
        // Build update with current values as defaults
        string name = patientUpdate.name ?: currentPatient.name;
        string phoneNumber = patientUpdate.phone_number ?: currentPatient.phone_number;
        string address = patientUpdate.address ?: currentPatient.address;
        string dateOfBirth = patientUpdate.date_of_birth ?: currentPatient.date_of_birth;
        string? medicalNotes = patientUpdate.medical_notes ?: currentPatient.medical_notes;
        string? imageUrl = patientUpdate.image_url ?: currentPatient.image_url;
        
        sql:ParameterizedQuery query = `
            UPDATE patients SET 
                name = ${name}, 
                phone_number = ${phoneNumber},
                address = ${address}, 
                date_of_birth = ${dateOfBirth},
                medical_notes = ${medicalNotes}, 
                image_url = ${imageUrl},
                updated_at = ${time:utcToString(time:utcNow())}
            WHERE patient_id = ${patientId}
            RETURNING patient_id, user_id, name, phone_number, address, date_of_birth, 
                      medical_notes, image_url, created_at, updated_at
        `;
        
        models:Patient|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        if result is sql:Error {
            log:printError("Error updating patient", 'error = result, patientId = patientId);
            return result;
        }
        
        return self.convertToPatientResponse(result);
    }

    // Delete patient
    public function deletePatient(int patientId) returns boolean|error {
        sql:ParameterizedQuery query = `DELETE FROM patients WHERE patient_id = ${patientId}`;

        sql:ExecutionResult|sql:Error result = database:dbClient->execute(query);
        if result is sql:Error {
            log:printError("Error deleting patient", 'error = result, patientId = patientId);
            return result;
        }

        return result.affectedRowCount > 0;
    }

    // Check if patient exists
    public function patientExists(int patientId) returns boolean|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM patients WHERE patient_id = ${patientId}`;

        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error checking patient existence", 'error = result, patientId = patientId);
            return result;
        }

        return result.count > 0;
    }

    // Check if user is already a patient
    public function isUserPatient(int userId) returns boolean|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM patients WHERE user_id = ${userId}`;

        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error checking if user is patient", 'error = result, userId = userId);
            return result;
        }

        return result.count > 0;
    }

    // Get patients count for pagination
    public function getPatientsCount() returns int|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM patients`;

        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error getting patients count", 'error = result);
            return result;
        }

        return result.count;
    }

    // Private helper methods
    private function convertToPatientResponse(models:Patient patient) returns models:PatientResponse {
        return {
            patient_id: patient.patient_id,
            user_id: patient.user_id,
            name: patient.name,
            phone_number: patient.phone_number,
            address: patient.address,
            date_of_birth: patient.date_of_birth,
            medical_notes: patient.medical_notes,
            image_url: patient.image_url,
            created_at: patient.created_at,
            updated_at: patient.updated_at
        };
    }
}
