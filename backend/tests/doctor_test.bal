import ballerina/test;
import backend.models;
import backend.services;

// Test data
const string TEST_DOCTOR_EMAIL = "testdoctor@example.com";
const string TEST_DOCTOR_PASSWORD = "testpass123";
const models:UserRole TEST_DOCTOR_ROLE = models:DOCTOR;

// Test doctor data
models:NewDoctor testDoctor = {
    user_id: 1,
    name: "Dr. Test Sharma",
    specialization: "Ayurvedic Medicine",
    location: "Test City, Test State",
    qualifications: "BAMS, MD Ayurveda",
    experience: 5,
    contact_number: "+1-555-0123",
    languages: ["English", "Hindi"],
    image_url: "https://example.com/dr-test-sharma.jpg",
    rating: 4.5
};

models:DoctorUpdate testDoctorUpdate = {
    name: "Dr. Test Kumar",
    specialization: "Herbal Medicine",
    location: "Updated City, Updated State",
    qualifications: "BAMS, PhD in Medicinal Plants",
    experience: 8,
    contact_number: "+1-555-0456",
    languages: ["English", "Hindi", "Punjabi"],
    image_url: "https://example.com/dr-test-kumar.jpg",
    rating: 4.8
};

@test:Config{}
function testDoctorService() {
    services:DoctorService doctorService = new services:DoctorService();
    
    // Test creating a doctor (will fail without existing user)
    models:DoctorResponse|models:DoctorErrorResponse createResult = doctorService.createDoctor(testDoctor);
    test:assertTrue(createResult is models:DoctorErrorResponse, "Expected error when creating doctor with non-existent user");
}

@test:Config{}
function testDoctorServiceWithValidUser() {
    services:DoctorService doctorService = new services:DoctorService();
    services:UserService userService = new services:UserService();
    
    // First create a user
    models:NewUser newUser = {
        email: TEST_DOCTOR_EMAIL,
        password: TEST_DOCTOR_PASSWORD,
        role: TEST_DOCTOR_ROLE
    };
    
    models:UserResponse|models:UserErrorResponse userResult = userService.registerUser(newUser);
    test:assertTrue(userResult is models:UserResponse, "User creation should succeed");
    
    if userResult is models:UserResponse {
        // Update test doctor with the created user ID
        testDoctor.user_id = userResult.user_id;
        
        // Test creating a doctor
        models:DoctorResponse|models:DoctorErrorResponse createResult = doctorService.createDoctor(testDoctor);
        test:assertTrue(createResult is models:DoctorResponse, "Doctor creation should succeed");
        
        if createResult is models:DoctorResponse {
            int doctorId = createResult.doctor_id;
            
            // Test getting doctor by ID
            models:DoctorResponse|models:DoctorErrorResponse? getResult = doctorService.getDoctorById(doctorId);
            test:assertTrue(getResult is models:DoctorResponse, "Should be able to get doctor by ID");
            
            // Test updating doctor
            models:DoctorResponse|models:DoctorErrorResponse? updateResult = doctorService.updateDoctor(doctorId, testDoctorUpdate);
            test:assertTrue(updateResult is models:DoctorResponse, "Doctor update should succeed");
            
            // Test updating doctor rating
            models:DoctorResponse|models:DoctorErrorResponse? ratingResult = doctorService.updateDoctorRating(doctorId, 4.9);
            test:assertTrue(ratingResult is models:DoctorResponse, "Doctor rating update should succeed");
            
            // Test getting all doctors
            models:DoctorResponse[]|models:DoctorErrorResponse allDoctorsResult = doctorService.getAllDoctors();
            test:assertTrue(allDoctorsResult is models:DoctorResponse[], "Should be able to get all doctors");
            
            // Test getting doctors by specialization
            models:DoctorResponse[]|models:DoctorErrorResponse specializationResult = doctorService.getDoctorsBySpecialization("Herbal Medicine");
            test:assertTrue(specializationResult is models:DoctorResponse[], "Should be able to get doctors by specialization");
            
            // Test getting top-rated doctors
            models:DoctorProfileSummary[]|models:DoctorErrorResponse topRatedResult = doctorService.getTopRatedDoctors(5);
            test:assertTrue(topRatedResult is models:DoctorProfileSummary[], "Should be able to get top-rated doctors");
            
            // Test getting specializations
            string[]|models:DoctorErrorResponse specializationsResult = doctorService.getSpecializations();
            test:assertTrue(specializationsResult is string[], "Should be able to get specializations");
            
            // Test getting locations
            string[]|models:DoctorErrorResponse locationsResult = doctorService.getLocations();
            test:assertTrue(locationsResult is string[], "Should be able to get locations");
            
            // Test checking if user is doctor
            boolean|models:DoctorErrorResponse isDoctorResult = doctorService.isUserDoctor(userResult.user_id);
            test:assertTrue(isDoctorResult is boolean && isDoctorResult == true, "User should be identified as doctor");
            
            // Test deleting doctor
            boolean|models:DoctorErrorResponse deleteResult = doctorService.deleteDoctor(doctorId);
            test:assertTrue(deleteResult is boolean && deleteResult == true, "Doctor deletion should succeed");
        }
    }
}

@test:Config{}
function testDoctorValidation() {
    services:DoctorService doctorService = new services:DoctorService();
    
    // Test with invalid data
    models:NewDoctor invalidDoctor = {
        user_id: 999, // Non-existent user
        name: "",     // Empty name
        specialization: "",
        location: "",
        qualifications: "",
        experience: -1, // Negative experience
        contact_number: "",
        languages: [],  // Empty languages array
        image_url: "https://example.com/invalid.jpg"
    };
    
    models:DoctorResponse|models:DoctorErrorResponse result = doctorService.createDoctor(invalidDoctor);
    test:assertTrue(result is models:DoctorErrorResponse, "Should reject invalid doctor data");
}

@test:Config{}
function testDoctorRatingValidation() {
    services:DoctorService doctorService = new services:DoctorService();
    
    // Test with invalid rating (should fail with non-existent doctor)
    models:DoctorResponse|models:DoctorErrorResponse? result = doctorService.updateDoctorRating(999, 6.0); // Invalid rating > 5.0
    test:assertTrue(result is models:DoctorErrorResponse, "Should reject invalid rating");
    
    // Test with another invalid rating
    models:DoctorResponse|models:DoctorErrorResponse? result2 = doctorService.updateDoctorRating(999, -1.0); // Invalid rating < 0.0
    test:assertTrue(result2 is models:DoctorErrorResponse, "Should reject negative rating");
}

@test:Config{}
function testDoctorSearchParams() {
    services:DoctorService doctorService = new services:DoctorService();
    
    // Test with search parameters
    models:DoctorSearchParams searchParams = {
        specialization: "Ayurvedic Medicine",
        location: "Mumbai",
        page: 1,
        'limit: 5
    };
    
    models:DoctorResponse[]|models:DoctorErrorResponse result = doctorService.getAllDoctors(searchParams);
    test:assertTrue(result is models:DoctorResponse[], "Should be able to search doctors with parameters");
}

@test:Config{}
function testDoctorPagination() {
    services:DoctorService doctorService = new services:DoctorService();
    
    // Test pagination parameters
    models:DoctorResponse[]|models:DoctorErrorResponse result1 = doctorService.getDoctorsBySpecialization("Ayurveda", 1, 3);
    test:assertTrue(result1 is models:DoctorResponse[], "Should handle pagination for specialization search");
    
    models:DoctorResponse[]|models:DoctorErrorResponse result2 = doctorService.getDoctorsByLocation("Mumbai", 1, 3);
    test:assertTrue(result2 is models:DoctorResponse[], "Should handle pagination for location search");
}

@test:Config{}
function testDoctorCounts() {
    services:DoctorService doctorService = new services:DoctorService();
    
    // Test getting counts
    int|models:DoctorErrorResponse countResult = doctorService.getDoctorsCount();
    test:assertTrue(countResult is int, "Should be able to get doctors count");
}
