import ballerina/log;
import backend.models;
import backend.repositories;

// Doctor service for business logic
public class DoctorService {
    private repositories:DoctorRepository doctorRepository;
    private repositories:UserRepository userRepository;

    public function init() {
        self.doctorRepository = new repositories:DoctorRepository();
        self.userRepository = new repositories:UserRepository();
    }

    // Create a new doctor profile
    public function createDoctor(models:NewDoctor newDoctor) returns models:DoctorResponse|models:DoctorErrorResponse {
        do {
            // Validate that the user exists and has DOCTOR role
            models:User|error? user = check self.userRepository.getUserById(newDoctor.user_id);
            if user is () {
                models:DoctorErrorResponse errorResponse = {message: "User not found", details: "The specified user ID does not exist"};
                return errorResponse;
            }
            if user is error {
                log:printError("Error retrieving user", 'error = user);
                models:DoctorErrorResponse errorResponse = {message: "Error retrieving user information"};
                return errorResponse;
            }
            
            if user.role != models:DOCTOR {
                models:DoctorErrorResponse errorResponse = {message: "Invalid user role", details: "User must have DOCTOR role to create doctor profile"};
                return errorResponse;
            }

            // Check if user already has a doctor profile
            boolean|error isDoctor = self.doctorRepository.isUserDoctor(newDoctor.user_id);
            if isDoctor is error {
                log:printError("Error checking doctor existence", 'error = isDoctor);
                models:DoctorErrorResponse errorResponse = {message: "Error checking doctor profile existence"};
                return errorResponse;
            }
            if isDoctor {
                models:DoctorErrorResponse errorResponse = {message: "Doctor profile already exists", details: "User already has a doctor profile"};
                return errorResponse;
            }

            // Validate input
            string? validationError = self.validateDoctorInput(newDoctor);
            if validationError is string {
                models:DoctorErrorResponse errorResponse = {message: "Validation error", details: validationError};
                return errorResponse;
            }

            // Create doctor
            models:DoctorResponse|error result = self.doctorRepository.createDoctor(newDoctor);
            if result is error {
                log:printError("Error creating doctor", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to create doctor profile"};
                return errorResponse;
            }

            return result;
        } on fail error e {
            log:printError("Unexpected error in createDoctor", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get doctor by ID
    public function getDoctorById(int doctorId) returns models:DoctorResponse|models:DoctorErrorResponse? {
        do {
            models:DoctorResponse|error? result = check self.doctorRepository.getDoctorById(doctorId);
            if result is () {
                return ();
            }
            if result is error {
                log:printError("Error getting doctor by ID", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to retrieve doctor"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getDoctorById", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get doctor by user ID
    public function getDoctorByUserId(int userId) returns models:DoctorResponse|models:DoctorErrorResponse? {
        do {
            models:DoctorResponse|error? result = check self.doctorRepository.getDoctorByUserId(userId);
            if result is () {
                return ();
            }
            if result is error {
                log:printError("Error getting doctor by user ID", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to retrieve doctor"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getDoctorByUserId", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get all doctors with pagination and filtering
    public function getAllDoctors(models:DoctorSearchParams searchParams = {}) returns models:DoctorResponse[]|models:DoctorErrorResponse {
        do {
            models:DoctorResponse[]|error result = check self.doctorRepository.getAllDoctors(searchParams);
            if result is error {
                log:printError("Error getting all doctors", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to retrieve doctors"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getAllDoctors", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get doctors by specialization
    public function getDoctorsBySpecialization(string specialization, int page = 1, int 'limit = 10) returns models:DoctorResponse[]|models:DoctorErrorResponse {
        do {
            if specialization.trim().length() == 0 {
                models:DoctorErrorResponse errorResponse = {message: "Specialization cannot be empty"};
                return errorResponse;
            }

            models:DoctorResponse[]|error result = check self.doctorRepository.getDoctorsBySpecialization(specialization, page, 'limit);
            if result is error {
                log:printError("Error getting doctors by specialization", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to retrieve doctors"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getDoctorsBySpecialization", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get doctors by location
    public function getDoctorsByLocation(string location, int page = 1, int 'limit = 10) returns models:DoctorResponse[]|models:DoctorErrorResponse {
        do {
            if location.trim().length() == 0 {
                models:DoctorErrorResponse errorResponse = {message: "Location cannot be empty"};
                return errorResponse;
            }

            models:DoctorResponse[]|error result = check self.doctorRepository.getDoctorsByLocation(location, page, 'limit);
            if result is error {
                log:printError("Error getting doctors by location", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to retrieve doctors"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getDoctorsByLocation", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get top-rated doctors
    public function getTopRatedDoctors(int 'limit = 10) returns models:DoctorProfileSummary[]|models:DoctorErrorResponse {
        do {
            if 'limit <= 0 || 'limit > 50 {
                models:DoctorErrorResponse errorResponse = {message: "Limit must be between 1 and 50"};
                return errorResponse;
            }

            models:DoctorProfileSummary[]|error result = check self.doctorRepository.getTopRatedDoctors('limit);
            if result is error {
                log:printError("Error getting top-rated doctors", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to retrieve top-rated doctors"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getTopRatedDoctors", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Update doctor profile
    public function updateDoctor(int doctorId, models:DoctorUpdate doctorUpdate) returns models:DoctorResponse|models:DoctorErrorResponse? {
        do {
            // Validate input
            string? validationError = self.validateDoctorUpdateInput(doctorUpdate);
            if validationError is string {
                models:DoctorErrorResponse errorResponse = {message: "Validation error", details: validationError};
                return errorResponse;
            }

            models:DoctorResponse|error? result = check self.doctorRepository.updateDoctor(doctorId, doctorUpdate);
            if result is () {
                return ();
            }
            if result is error {
                log:printError("Error updating doctor", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to update doctor profile"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in updateDoctor", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Update doctor rating
    public function updateDoctorRating(int doctorId, decimal newRating) returns models:DoctorResponse|models:DoctorErrorResponse? {
        do {
            if newRating < 0.0d || newRating > 5.0d {
                models:DoctorErrorResponse errorResponse = {message: "Invalid rating", details: "Rating must be between 0.0 and 5.0"};
                return errorResponse;
            }

            models:DoctorResponse|error? result = check self.doctorRepository.updateDoctorRating(doctorId, newRating);
            if result is () {
                models:DoctorErrorResponse errorResponse = {message: "Doctor not found"};
                return errorResponse;
            }
            if result is error {
                log:printError("Error updating doctor rating", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to update doctor rating"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in updateDoctorRating", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Delete doctor
    public function deleteDoctor(int doctorId) returns boolean|models:DoctorErrorResponse {
        do {
            boolean|error result = check self.doctorRepository.deleteDoctor(doctorId);
            if result is error {
                log:printError("Error deleting doctor", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to delete doctor"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in deleteDoctor", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get doctors count
    public function getDoctorsCount(models:DoctorSearchParams searchParams = {}) returns int|models:DoctorErrorResponse {
        do {
            int|error result = check self.doctorRepository.getDoctorsCount(searchParams);
            if result is error {
                log:printError("Error getting doctors count", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to get doctors count"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getDoctorsCount", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get available specializations
    public function getSpecializations() returns string[]|models:DoctorErrorResponse {
        do {
            string[]|error result = check self.doctorRepository.getSpecializations();
            if result is error {
                log:printError("Error getting specializations", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to get specializations"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getSpecializations", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Get available locations
    public function getLocations() returns string[]|models:DoctorErrorResponse {
        do {
            string[]|error result = check self.doctorRepository.getLocations();
            if result is error {
                log:printError("Error getting locations", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to get locations"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in getLocations", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Check if user is a doctor
    public function isUserDoctor(int userId) returns boolean|models:DoctorErrorResponse {
        do {
            boolean|error result = check self.doctorRepository.isUserDoctor(userId);
            if result is error {
                log:printError("Error checking if user is doctor", 'error = result);
                models:DoctorErrorResponse errorResponse = {message: "Failed to check doctor status"};
                return errorResponse;
            }
            return result;
        } on fail error e {
            log:printError("Unexpected error in isUserDoctor", 'error = e);
            models:DoctorErrorResponse errorResponse = {message: "An unexpected error occurred"};
            return errorResponse;
        }
    }

    // Private validation methods
    private function validateDoctorInput(models:NewDoctor doctor) returns string? {
        if doctor.name.trim().length() == 0 {
            return "Name cannot be empty";
        }
        if doctor.specialization.trim().length() == 0 {
            return "Specialization cannot be empty";
        }
        if doctor.location.trim().length() == 0 {
            return "Location cannot be empty";
        }
        if doctor.qualifications.trim().length() == 0 {
            return "Qualifications cannot be empty";
        }
        if doctor.contact_number.trim().length() == 0 {
            return "Contact number cannot be empty";
        }
        if doctor.experience < 0 {
            return "Experience cannot be negative";
        }
        if doctor.languages.length() == 0 {
            return "At least one language must be specified";
        }
        if doctor.rating is decimal && (doctor.rating < 0.0d || doctor.rating > 5.0d) {
            return "Rating must be between 0.0 and 5.0";
        }
        return ();
    }

    private function validateDoctorUpdateInput(models:DoctorUpdate doctorUpdate) returns string? {
        if doctorUpdate.name is string && doctorUpdate.name.toString().trim().length() == 0 {
            return "Name cannot be empty";
        }
        if doctorUpdate.specialization is string && doctorUpdate.specialization.toString().trim().length() == 0 {
            return "Specialization cannot be empty";
        }
        if doctorUpdate.location is string && doctorUpdate.location.toString().trim().length() == 0 {
            return "Location cannot be empty";
        }
        if doctorUpdate.qualifications is string && doctorUpdate.qualifications.toString().trim().length() == 0 {
            return "Qualifications cannot be empty";
        }
        if doctorUpdate.contact_number is string && doctorUpdate.contact_number.toString().trim().length() == 0 {
            return "Contact number cannot be empty";
        }
        if doctorUpdate.experience is int && doctorUpdate.experience < 0 {
            return "Experience cannot be negative";
        }
        if doctorUpdate.languages is string[] && (<string[]>doctorUpdate.languages).length() == 0 {
            return "At least one language must be specified";
        }
        if doctorUpdate.rating is decimal && (doctorUpdate.rating < 0.0d || doctorUpdate.rating > 5.0d) {
            return "Rating must be between 0.0 and 5.0";
        }
        return ();
    }
}
