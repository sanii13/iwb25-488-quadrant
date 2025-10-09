import ballerina/sql;
import ballerina/time;
import ballerina/log;
import backend.database;
import backend.models;

// Doctor repository for database operations
public class DoctorRepository {

    // Create a new doctor
    public function createDoctor(models:NewDoctor newDoctor) returns models:DoctorResponse|error {
        string currentTime = time:utcToString(time:utcNow());
        decimal rating = newDoctor.rating ?: 0.0;
        
        sql:ParameterizedQuery query = `
            INSERT INTO doctors (user_id, name, specialization, location, qualifications, 
                               experience, contact_number, languages, image_url, rating, created_at, updated_at)
            VALUES (${newDoctor.user_id}, ${newDoctor.name}, ${newDoctor.specialization}, 
                    ${newDoctor.location}, ${newDoctor.qualifications}, ${newDoctor.experience}, 
                    ${newDoctor.contact_number}, ${newDoctor.languages}, ${newDoctor.image_url}, 
                    ${rating}, ${currentTime}, ${currentTime})
            RETURNING doctor_id, user_id, name, specialization, location, qualifications, 
                      experience, contact_number, languages, image_url, rating, created_at, updated_at
        `;

        models:Doctor|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error creating doctor", 'error = result);
            return error("Failed to create doctor");
        }

        return self.convertToDoctorResponse(result);
    }

    // Get doctor by ID
    public function getDoctorById(int doctorId) returns models:DoctorResponse|error? {
        sql:ParameterizedQuery query = `
            SELECT doctor_id, user_id, name, specialization, location, qualifications, 
                   experience, contact_number, languages, image_url, rating, created_at, updated_at
            FROM doctors 
            WHERE doctor_id = ${doctorId}
        `;

        models:Doctor|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        if result is sql:Error {
            log:printError("Error getting doctor by ID", 'error = result, doctorId = doctorId);
            return error("Failed to get doctor");
        }

        return self.convertToDoctorResponse(result);
    }

    // Get doctor by user ID
    public function getDoctorByUserId(int userId) returns models:DoctorResponse|error? {
        sql:ParameterizedQuery query = `
            SELECT doctor_id, user_id, name, specialization, location, qualifications, 
                   experience, contact_number, languages, image_url, rating, created_at, updated_at
            FROM doctors 
            WHERE user_id = ${userId}
        `;

        models:Doctor|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        if result is sql:Error {
            log:printError("Error getting doctor by user ID", 'error = result, userId = userId);
            return error("Failed to get doctor");
        }

        return self.convertToDoctorResponse(result);
    }

    // Get all doctors with pagination and optional filters
    public function getAllDoctors(models:DoctorSearchParams searchParams = {}) returns models:DoctorResponse[]|error {
        int page = searchParams?.page ?: 1;
        int 'limit = searchParams?.'limit ?: 10;
        int offset = (page - 1) * 'limit;
        
        sql:ParameterizedQuery query = `
            SELECT doctor_id, user_id, name, specialization, location, qualifications, 
                   experience, contact_number, languages, image_url, rating, created_at, updated_at
            FROM doctors
            ORDER BY rating DESC, experience DESC
            LIMIT ${'limit} OFFSET ${offset}
        `;

        stream<models:Doctor, sql:Error?> resultStream = database:dbClient->query(query);
        models:DoctorResponse[] doctors = [];

        check from models:Doctor doctor in resultStream
            do {
                doctors.push(self.convertToDoctorResponse(doctor));
            };

        check resultStream.close();
        return doctors;
    }

    // Get doctors by specialization
    public function getDoctorsBySpecialization(string specialization, int page = 1, int 'limit = 10) returns models:DoctorResponse[]|error {
        int offset = (page - 1) * 'limit;
        
        sql:ParameterizedQuery query = `
            SELECT doctor_id, user_id, name, specialization, location, qualifications, 
                   experience, contact_number, languages, image_url, rating, created_at, updated_at
            FROM doctors 
            WHERE LOWER(specialization) LIKE LOWER(${"%" + specialization + "%"})
            ORDER BY rating DESC, experience DESC
            LIMIT ${'limit} OFFSET ${offset}
        `;

        stream<models:Doctor, sql:Error?> resultStream = database:dbClient->query(query);
        models:DoctorResponse[] doctors = [];

        check from models:Doctor doctor in resultStream
            do {
                doctors.push(self.convertToDoctorResponse(doctor));
            };

        check resultStream.close();
        return doctors;
    }

    // Get doctors by location
    public function getDoctorsByLocation(string location, int page = 1, int 'limit = 10) returns models:DoctorResponse[]|error {
        int offset = (page - 1) * 'limit;
        
        sql:ParameterizedQuery query = `
            SELECT doctor_id, user_id, name, specialization, location, qualifications, 
                   experience, contact_number, languages, image_url, rating, created_at, updated_at
            FROM doctors 
            WHERE LOWER(location) LIKE LOWER(${"%" + location + "%"})
            ORDER BY rating DESC, experience DESC
            LIMIT ${'limit} OFFSET ${offset}
        `;

        stream<models:Doctor, sql:Error?> resultStream = database:dbClient->query(query);
        models:DoctorResponse[] doctors = [];

        check from models:Doctor doctor in resultStream
            do {
                doctors.push(self.convertToDoctorResponse(doctor));
            };

        check resultStream.close();
        return doctors;
    }

    // Get top-rated doctors
    public function getTopRatedDoctors(int 'limit = 10) returns models:DoctorProfileSummary[]|error {
        sql:ParameterizedQuery query = `
            SELECT doctor_id, name, specialization, location, experience, rating, languages, image_url
            FROM doctors 
            WHERE rating >= 4.0
            ORDER BY rating DESC, experience DESC
            LIMIT ${'limit}
        `;

        stream<models:DoctorProfileSummary, sql:Error?> resultStream = database:dbClient->query(query);
        models:DoctorProfileSummary[] doctors = [];

        check from models:DoctorProfileSummary doctor in resultStream
            do {
                doctors.push(doctor);
            };

        check resultStream.close();
        return doctors;
    }

    // Update doctor
    public function updateDoctor(int doctorId, models:DoctorUpdate doctorUpdate) returns models:DoctorResponse|error? {
        // First check if doctor exists
        boolean|error exists = self.doctorExists(doctorId);
        if exists is error {
            return exists;
        }
        if !exists {
            return ();
        }
        
        // Get current doctor data
        models:DoctorResponse|error? currentDoctor = self.getDoctorById(doctorId);
        if currentDoctor is error {
            return currentDoctor;
        }
        if currentDoctor is () {
            return ();
        }
        
        // Build update with current values as defaults
        string name = doctorUpdate.name ?: currentDoctor.name;
        string specialization = doctorUpdate.specialization ?: currentDoctor.specialization;
        string location = doctorUpdate.location ?: currentDoctor.location;
        string qualifications = doctorUpdate.qualifications ?: currentDoctor.qualifications;
        int experience = doctorUpdate.experience ?: currentDoctor.experience;
        string contactNumber = doctorUpdate.contact_number ?: currentDoctor.contact_number;
        string[] languages = doctorUpdate.languages ?: currentDoctor.languages;
        string? imageUrl = doctorUpdate.image_url ?: currentDoctor.image_url;
        decimal rating = doctorUpdate.rating ?: currentDoctor.rating;
        
        sql:ParameterizedQuery query = `
            UPDATE doctors SET 
                name = ${name}, 
                specialization = ${specialization},
                location = ${location}, 
                qualifications = ${qualifications},
                experience = ${experience}, 
                contact_number = ${contactNumber},
                languages = ${languages},
                image_url = ${imageUrl},
                rating = ${rating},
                updated_at = ${time:utcToString(time:utcNow())}
            WHERE doctor_id = ${doctorId}
            RETURNING doctor_id, user_id, name, specialization, location, qualifications, 
                      experience, contact_number, languages, image_url, rating, created_at, updated_at
        `;
        
        models:Doctor|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        if result is sql:Error {
            log:printError("Error updating doctor", 'error = result, doctorId = doctorId);
            return result;
        }
        
        return self.convertToDoctorResponse(result);
    }

    // Update doctor rating
    public function updateDoctorRating(int doctorId, decimal newRating) returns models:DoctorResponse|error? {
        // Validate rating range
        if newRating < 0.0d || newRating > 5.0d {
            return error("Rating must be between 0.0 and 5.0");
        }
        
        sql:ParameterizedQuery query = `
            UPDATE doctors SET 
                rating = ${newRating},
                updated_at = ${time:utcToString(time:utcNow())}
            WHERE doctor_id = ${doctorId}
            RETURNING doctor_id, user_id, name, specialization, location, qualifications, 
                      experience, contact_number, languages, image_url, rating, created_at, updated_at
        `;
        
        models:Doctor|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        if result is sql:Error {
            log:printError("Error updating doctor rating", 'error = result, doctorId = doctorId);
            return result;
        }
        
        return self.convertToDoctorResponse(result);
    }

    // Delete doctor
    public function deleteDoctor(int doctorId) returns boolean|error {
        sql:ParameterizedQuery query = `DELETE FROM doctors WHERE doctor_id = ${doctorId}`;

        sql:ExecutionResult|sql:Error result = database:dbClient->execute(query);
        if result is sql:Error {
            log:printError("Error deleting doctor", 'error = result, doctorId = doctorId);
            return result;
        }

        return result.affectedRowCount > 0;
    }

    // Check if doctor exists
    public function doctorExists(int doctorId) returns boolean|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM doctors WHERE doctor_id = ${doctorId}`;

        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error checking doctor existence", 'error = result, doctorId = doctorId);
            return result;
        }

        return result.count > 0;
    }

    // Check if user is already a doctor
    public function isUserDoctor(int userId) returns boolean|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM doctors WHERE user_id = ${userId}`;

        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error checking if user is doctor", 'error = result, userId = userId);
            return result;
        }

        return result.count > 0;
    }

    // Get doctors count for pagination
    public function getDoctorsCount(models:DoctorSearchParams searchParams = {}) returns int|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM doctors`;

        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            log:printError("Error getting doctors count", 'error = result);
            return result;
        }

        return result.count;
    }

    // Get available specializations
    public function getSpecializations() returns string[]|error {
        sql:ParameterizedQuery query = `
            SELECT DISTINCT specialization 
            FROM doctors 
            ORDER BY specialization
        `;

        stream<record {string specialization;}, sql:Error?> resultStream = database:dbClient->query(query);
        string[] specializations = [];

        check from record {string specialization;} spec in resultStream
            do {
                specializations.push(spec.specialization);
            };

        check resultStream.close();
        return specializations;
    }

    // Get available locations
    public function getLocations() returns string[]|error {
        sql:ParameterizedQuery query = `
            SELECT DISTINCT location 
            FROM doctors 
            ORDER BY location
        `;

        stream<record {string location;}, sql:Error?> resultStream = database:dbClient->query(query);
        string[] locations = [];

        check from record {string location;} loc in resultStream
            do {
                locations.push(loc.location);
            };

        check resultStream.close();
        return locations;
    }

    // Private helper methods
    private function convertToDoctorResponse(models:Doctor doctor) returns models:DoctorResponse {
        return {
            doctor_id: doctor.doctor_id,
            user_id: doctor.user_id,
            name: doctor.name,
            specialization: doctor.specialization,
            location: doctor.location,
            qualifications: doctor.qualifications,
            experience: doctor.experience,
            contact_number: doctor.contact_number,
            languages: doctor.languages,
            image_url: doctor.image_url,
            rating: doctor.rating,
            created_at: doctor.created_at,
            updated_at: doctor.updated_at
        };
    }
}
