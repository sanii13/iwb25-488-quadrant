import ballerina/log;
import backend.models;
import backend.repositories;

// Patient service for business logic
public class PatientService {
    private repositories:PatientRepository patientRepository;
    private repositories:UserRepository userRepository;

    public function init() {
        self.patientRepository = new ();
        self.userRepository = new ();
    }

    // Create a new patient
    public function createPatient(models:NewPatient newPatient) returns models:PatientResponse|models:PatientErrorResponse {
        // Check if user exists
        models:User|error? user = self.userRepository.getUserById(newPatient.user_id);
        if user is error {
            log:printError("Error checking user existence", user);
            return {message: "Internal server error", details: user.message()};
        }
        if user is () {
            return {message: "User not found", details: "No user found with the given ID"};
        }

        // Check if user is already a patient
        boolean|error isPatient = self.patientRepository.isUserPatient(newPatient.user_id);
        if isPatient is error {
            log:printError("Error checking if user is already a patient", isPatient);
            return {message: "Internal server error", details: isPatient.message()};
        }
        if isPatient {
            return {message: "User is already a patient", details: "This user already has a patient record"};
        }

        // Create patient
        models:PatientResponse|error createdPatient = self.patientRepository.createPatient(newPatient);
        if createdPatient is error {
            log:printError("Error creating patient", createdPatient);
            return {message: "Failed to create patient", details: createdPatient.message()};
        }

        return createdPatient;
    }

    // Get patient by ID
    public function getPatientById(int patientId) returns models:PatientResponse|models:PatientErrorResponse {
        models:PatientResponse|error? patient = self.patientRepository.getPatientById(patientId);
        if patient is error {
            log:printError("Error retrieving patient", patient);
            return {message: "Failed to retrieve patient", details: patient.message()};
        }
        if patient is () {
            return {message: "Patient not found", details: "No patient found with the given ID"};
        }

        return patient;
    }

    // Get patient by user ID
    public function getPatientByUserId(int userId) returns models:PatientResponse|models:PatientErrorResponse {
        models:PatientResponse|error? patient = self.patientRepository.getPatientByUserId(userId);
        if patient is error {
            log:printError("Error retrieving patient by user ID", patient);
            return {message: "Failed to retrieve patient", details: patient.message()};
        }
        if patient is () {
            return {message: "Patient not found", details: "No patient record found for this user"};
        }

        return patient;
    }

    // Get all patients with pagination
    public function getAllPatients(int page = 1, int 'limit = 10) returns models:PatientResponse[]|models:PatientErrorResponse {
        models:PatientResponse[]|error patients = self.patientRepository.getAllPatients(page, 'limit);
        if patients is error {
            log:printError("Error retrieving patients", patients);
            return {message: "Failed to retrieve patients", details: patients.message()};
        }

        return patients;
    }

    // Update patient
    public function updatePatient(int patientId, models:PatientUpdate patientUpdate) returns models:PatientResponse|models:PatientErrorResponse {
        // Check if patient exists
        boolean|error exists = self.patientRepository.patientExists(patientId);
        if exists is error {
            log:printError("Error checking patient existence", exists);
            return {message: "Internal server error", details: exists.message()};
        }
        if !exists {
            return {message: "Patient not found", details: "No patient found with the given ID"};
        }

        models:PatientResponse|error? updatedPatient = self.patientRepository.updatePatient(patientId, patientUpdate);
        if updatedPatient is error {
            log:printError("Error updating patient", updatedPatient);
            return {message: "Failed to update patient", details: updatedPatient.message()};
        }
        if updatedPatient is () {
            return {message: "Patient not found", details: "No patient found with the given ID"};
        }

        return updatedPatient;
    }

    // Delete patient
    public function deletePatient(int patientId) returns models:PatientErrorResponse? {
        boolean|error deleted = self.patientRepository.deletePatient(patientId);
        if deleted is error {
            log:printError("Error deleting patient", deleted);
            return {message: "Failed to delete patient", details: deleted.message()};
        }
        if !deleted {
            return {message: "Patient not found", details: "No patient found with the given ID"};
        }
        return ();
    }

    // Get patients count for pagination
    public function getPatientsCount() returns int|models:PatientErrorResponse {
        int|error count = self.patientRepository.getPatientsCount();
        if count is error {
            log:printError("Error getting patients count", count);
            return {message: "Failed to get patients count", details: count.message()};
        }
        return count;
    }
}
