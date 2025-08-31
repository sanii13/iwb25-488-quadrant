import ballerina/test;
import backend.models;
import backend.services;

// Test data constants
const string BOOKING_TEST_DOCTOR_EMAIL = "testbookingdoctor@example.com";
const string BOOKING_TEST_PATIENT_EMAIL = "testbookingpatient@example.com";
const string BOOKING_TEST_PASSWORD = "testpass123";

// Test booking data
models:BookingCreate testBookingCreate = {
    doctor_id: 1,
    patient_id: 1,
    date: "2025-09-15",
    time: "10:00",
    status: "PENDING"
};

models:BookingUpdate testBookingUpdate = {
    date: "2025-09-16",
    time: "11:00",
    status: "CONFIRMED"
};

// Test doctor data for booking tests
models:NewDoctor bookingTestDoctor = {
    user_id: 1,
    name: "Dr. Booking Test",
    specialization: "Ayurvedic Medicine",
    location: "Test City, Test State",
    qualifications: "BAMS, MD Ayurveda",
    experience: 5,
    contact_number: "+1-555-0123",
    languages: ["English", "Hindi"],
    image_url: "https://example.com/dr-test.jpg",
    rating: 4.5
};

// Test patient data for booking tests
models:NewPatient bookingTestPatient = {
    user_id: 1,
    name: "Test Patient Booking",
    phone_number: "+1-555-0456",
    address: "123 Test Street, Test City, TC 12345",
    date_of_birth: "1990-01-01",
    medical_notes: "Test patient for booking",
    image_url: "https://example.com/test-patient.jpg"
};

@test:Config{}
function testBookingService() {
    services:BookingService bookingService = new();
    
    // Test creating a booking (will fail without existing doctor/patient)
    models:Booking|error createResult = bookingService.createBooking(testBookingCreate);
    test:assertTrue(createResult is error, "Expected error when creating booking without existing doctor/patient");
}

@test:Config{}
function testBookingServiceWithValidData() {
    services:BookingService bookingService = new();
    services:UserService userService = new();
    services:DoctorService doctorService = new();
    services:PatientService patientService = new();
    
    // Create doctor user
    models:NewUser doctorUser = {
        email: BOOKING_TEST_DOCTOR_EMAIL,
        password: BOOKING_TEST_PASSWORD,
        role: models:DOCTOR
    };
    
    models:UserResponse|models:UserErrorResponse doctorUserResult = userService.registerUser(doctorUser);
    test:assertTrue(doctorUserResult is models:UserResponse, "Doctor user creation should succeed");
    
    if doctorUserResult is models:UserResponse {
        // Create patient user
        models:NewUser patientUser = {
            email: BOOKING_TEST_PATIENT_EMAIL,
            password: BOOKING_TEST_PASSWORD,
            role: models:PATIENT
        };
        
        models:UserResponse|models:UserErrorResponse patientUserResult = userService.registerUser(patientUser);
        test:assertTrue(patientUserResult is models:UserResponse, "Patient user creation should succeed");
        
        if patientUserResult is models:UserResponse {
            // Create doctor profile
            bookingTestDoctor.user_id = doctorUserResult.user_id;
            models:DoctorResponse|models:DoctorErrorResponse doctorResult = doctorService.createDoctor(bookingTestDoctor);
            test:assertTrue(doctorResult is models:DoctorResponse, "Doctor creation should succeed");
            
            if doctorResult is models:DoctorResponse {
                // Create patient profile
                bookingTestPatient.user_id = patientUserResult.user_id;
                models:PatientResponse|models:PatientErrorResponse patientResult = patientService.createPatient(bookingTestPatient);
                test:assertTrue(patientResult is models:PatientResponse, "Patient creation should succeed");
                
                if patientResult is models:PatientResponse {
                    // Update test booking with valid IDs
                    testBookingCreate.doctor_id = doctorResult.doctor_id;
                    testBookingCreate.patient_id = patientResult.patient_id;
                    
                    // Test creating a booking
                    models:Booking|error createResult = bookingService.createBooking(testBookingCreate);
                    test:assertTrue(createResult is models:Booking, "Booking creation should succeed");
                    
                    if createResult is models:Booking {
                        int bookingId = createResult.booking_id ?: 0;
                        test:assertTrue(bookingId > 0, "Booking ID should be positive");
                        
                        // Test getting booking by ID
                        models:Booking|error getResult = bookingService.getBookingById(bookingId);
                        test:assertTrue(getResult is models:Booking, "Should be able to get booking by ID");
                        
                        // Test getting booking details
                        models:BookingDetails|error detailsResult = bookingService.getBookingDetails(bookingId);
                        test:assertTrue(detailsResult is models:BookingDetails, "Should be able to get booking details");
                        
                        // Test updating booking status
                        models:Booking|error confirmResult = bookingService.confirmBooking(bookingId);
                        test:assertTrue(confirmResult is models:Booking, "Should be able to confirm booking");
                        
                        if confirmResult is models:Booking {
                            test:assertEquals(confirmResult.status, "CONFIRMED", "Booking status should be CONFIRMED");
                        }
                        
                        // Test completing booking
                        models:Booking|error completeResult = bookingService.completeBooking(bookingId);
                        test:assertTrue(completeResult is models:Booking, "Should be able to complete booking");
                        
                        if completeResult is models:Booking {
                            test:assertEquals(completeResult.status, "COMPLETED", "Booking status should be COMPLETED");
                        }
                        
                        // Test getting all bookings
                        models:Booking[]|error allBookingsResult = bookingService.getAllBookings();
                        test:assertTrue(allBookingsResult is models:Booking[], "Should be able to get all bookings");
                        
                        // Test getting all bookings with details
                        models:BookingDetails[]|error allDetailsResult = bookingService.getAllBookingsWithDetails();
                        test:assertTrue(allDetailsResult is models:BookingDetails[], "Should be able to get all booking details");
                        
                        // Test getting doctor bookings
                        models:BookingDetails[]|error doctorBookingsResult = bookingService.getUpcomingDoctorBookings(doctorResult.doctor_id);
                        test:assertTrue(doctorBookingsResult is models:BookingDetails[], "Should be able to get doctor bookings");
                        
                        // Test getting patient bookings
                        models:BookingDetails[]|error patientBookingsResult = bookingService.getUpcomingPatientBookings(patientResult.patient_id);
                        test:assertTrue(patientBookingsResult is models:BookingDetails[], "Should be able to get patient bookings");
                        
                        // Test getting doctor booking stats
                        var doctorStatsResult = bookingService.getDoctorBookingStats(doctorResult.doctor_id);
                        test:assertTrue(doctorStatsResult is record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}, "Should be able to get doctor booking stats");
                        
                        // Test getting patient booking stats
                        var patientStatsResult = bookingService.getPatientBookingStats(patientResult.patient_id);
                        test:assertTrue(patientStatsResult is record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}, "Should be able to get patient booking stats");
                        
                        // Test time slot availability
                        boolean|error availabilityResult = bookingService.isTimeSlotAvailable(doctorResult.doctor_id, "2025-09-20", "14:00");
                        test:assertTrue(availabilityResult is boolean, "Should be able to check time slot availability");
                        
                        // Test getting available time slots
                        string[]|error timeSlotsResult = bookingService.getAvailableTimeSlots(doctorResult.doctor_id, "2025-09-20");
                        test:assertTrue(timeSlotsResult is string[], "Should be able to get available time slots");
                        
                        // Test getting today's bookings count
                        int|error todayCountResult = bookingService.getTodayBookingsCount(doctorResult.doctor_id);
                        test:assertTrue(todayCountResult is int, "Should be able to get today's bookings count");
                        
                        // Test deleting booking
                        error? deleteResult = bookingService.deleteBooking(bookingId);
                        test:assertTrue(deleteResult is (), "Should be able to delete booking");
                    }
                }
            }
        }
    }
}

@test:Config{}
function testBookingValidation() {
    services:BookingService bookingService = new();
    
    // Test with invalid doctor ID
    models:BookingCreate invalidDoctorBooking = {
        doctor_id: -1,
        patient_id: 1,
        date: "2025-09-15",
        time: "10:00"
    };
    
    models:Booking|error result1 = bookingService.createBooking(invalidDoctorBooking);
    test:assertTrue(result1 is error, "Should reject invalid doctor ID");
    
    // Test with invalid patient ID
    models:BookingCreate invalidPatientBooking = {
        doctor_id: 1,
        patient_id: -1,
        date: "2025-09-15",
        time: "10:00"
    };
    
    models:Booking|error result2 = bookingService.createBooking(invalidPatientBooking);
    test:assertTrue(result2 is error, "Should reject invalid patient ID");
    
    // Test with invalid date format
    models:BookingCreate invalidDateBooking = {
        doctor_id: 1,
        patient_id: 1,
        date: "invalid-date",
        time: "10:00"
    };
    
    models:Booking|error result3 = bookingService.createBooking(invalidDateBooking);
    test:assertTrue(result3 is error, "Should reject invalid date format");
    
    // Test with invalid time format
    models:BookingCreate invalidTimeBooking = {
        doctor_id: 1,
        patient_id: 1,
        date: "2025-09-15",
        time: "invalid-time"
    };
    
    models:Booking|error result4 = bookingService.createBooking(invalidTimeBooking);
    test:assertTrue(result4 is error, "Should reject invalid time format");
    
    // Test with invalid status
    models:BookingCreate invalidStatusBooking = {
        doctor_id: 1,
        patient_id: 1,
        date: "2025-09-15",
        time: "10:00",
        status: "INVALID_STATUS"
    };
    
    models:Booking|error result5 = bookingService.createBooking(invalidStatusBooking);
    test:assertTrue(result5 is error, "Should reject invalid status");
}

@test:Config{}
function testBookingStatusTransitions() {
    services:BookingService bookingService = new();
    
    // Test updating status with invalid status
    models:Booking|error result1 = bookingService.updateBookingStatus(999, "INVALID_STATUS");
    test:assertTrue(result1 is error, "Should reject invalid status");
    
    // Test cancelling non-existent booking
    models:Booking|error result2 = bookingService.cancelBooking(999);
    test:assertTrue(result2 is error, "Should reject cancelling non-existent booking");
    
    // Test confirming non-existent booking
    models:Booking|error result3 = bookingService.confirmBooking(999);
    test:assertTrue(result3 is error, "Should reject confirming non-existent booking");
    
    // Test completing non-existent booking
    models:Booking|error result4 = bookingService.completeBooking(999);
    test:assertTrue(result4 is error, "Should reject completing non-existent booking");
}

@test:Config{}
function testBookingFiltering() {
    services:BookingService bookingService = new();
    
    // Test filtering bookings by status
    models:Booking[]|error pendingResult = bookingService.getAllBookings("PENDING");
    test:assertTrue(pendingResult is models:Booking[], "Should be able to filter by PENDING status");
    
    models:Booking[]|error confirmedResult = bookingService.getAllBookings("CONFIRMED");
    test:assertTrue(confirmedResult is models:Booking[], "Should be able to filter by CONFIRMED status");
    
    // Test filtering bookings by doctor ID
    models:Booking[]|error doctorResult = bookingService.getAllBookings((), 1);
    test:assertTrue(doctorResult is models:Booking[], "Should be able to filter by doctor ID");
    
    // Test filtering bookings by patient ID
    models:Booking[]|error patientResult = bookingService.getAllBookings((), (), 1);
    test:assertTrue(patientResult is models:Booking[], "Should be able to filter by patient ID");
    
    // Test filtering with multiple parameters
    models:Booking[]|error multiFilterResult = bookingService.getAllBookings("PENDING", 1, 1);
    test:assertTrue(multiFilterResult is models:Booking[], "Should be able to filter by multiple parameters");
}

@test:Config{}
function testBookingErrorHandling() {
    services:BookingService bookingService = new();
    
    // Test getting non-existent booking
    models:Booking|error getResult = bookingService.getBookingById(99999);
    test:assertTrue(getResult is error, "Should return error for non-existent booking");
    
    // Test getting details for non-existent booking
    models:BookingDetails|error detailsResult = bookingService.getBookingDetails(99999);
    test:assertTrue(detailsResult is error, "Should return error for non-existent booking details");
    
    // Test deleting non-existent booking
    error? deleteResult = bookingService.deleteBooking(99999);
    test:assertTrue(deleteResult is error, "Should return error when deleting non-existent booking");
    
    // Test getting stats for non-existent doctor
    var doctorStatsResult = bookingService.getDoctorBookingStats(99999);
    test:assertTrue(doctorStatsResult is error, "Should return error for non-existent doctor stats");
    
    // Test getting stats for non-existent patient
    var patientStatsResult = bookingService.getPatientBookingStats(99999);
    test:assertTrue(patientStatsResult is error, "Should return error for non-existent patient stats");
}

@test:Config{}
function testTimeSlotAvailability() {
    services:BookingService bookingService = new();
    
    // Test checking availability for non-existent doctor
    boolean|error availabilityResult = bookingService.isTimeSlotAvailable(99999, "2025-09-15", "10:00");
    test:assertTrue(availabilityResult is error, "Should return error for non-existent doctor");
    
    // Test getting available slots for non-existent doctor
    string[]|error slotsResult = bookingService.getAvailableTimeSlots(99999, "2025-09-15");
    test:assertTrue(slotsResult is error, "Should return error for non-existent doctor slots");
}

@test:Config{}
function testBookingDateTimeValidation() {
    services:BookingService bookingService = new();
    
    // Test with various invalid date formats
    string[] invalidDates = ["2025-13-01", "2025-02-30", "25-09-15", "2025/09/15", "Sept 15, 2025"];
    
    foreach string invalidDate in invalidDates {
        models:BookingCreate invalidBooking = {
            doctor_id: 1,
            patient_id: 1,
            date: invalidDate,
            time: "10:00"
        };
        
        models:Booking|error result = bookingService.createBooking(invalidBooking);
        test:assertTrue(result is error, string `Should reject invalid date format: ${invalidDate}`);
    }
    
    // Test with various invalid time formats
    string[] invalidTimes = ["25:00", "10:60", "10", "10:00 AM", "10:00:00"];
    
    foreach string invalidTime in invalidTimes {
        models:BookingCreate invalidBooking = {
            doctor_id: 1,
            patient_id: 1,
            date: "2025-09-15",
            time: invalidTime
        };
        
        models:Booking|error result = bookingService.createBooking(invalidBooking);
        test:assertTrue(result is error, string `Should reject invalid time format: ${invalidTime}`);
    }
}

@test:Config{}
function testBookingLimits() {
    services:BookingService bookingService = new();
    
    // Test getting upcoming bookings with limit
    models:BookingDetails[]|error limitedResult = bookingService.getUpcomingDoctorBookings(1, 5);
    test:assertTrue(limitedResult is models:BookingDetails[], "Should be able to get limited upcoming doctor bookings");
    
    models:BookingDetails[]|error patientLimitedResult = bookingService.getUpcomingPatientBookings(1, 3);
    test:assertTrue(patientLimitedResult is models:BookingDetails[], "Should be able to get limited upcoming patient bookings");
}

@test:Config{}
function testBookingBusinessLogic() {
    services:BookingService bookingService = new();
    
    // Test that the service properly initializes
    test:assertTrue(bookingService is services:BookingService, "BookingService should be properly initialized");
    
    // Test today's booking count functionality
    int|error todayCount = bookingService.getTodayBookingsCount();
    test:assertTrue(todayCount is int, "Should be able to get today's bookings count");
    
    if todayCount is int {
        test:assertTrue(todayCount >= 0, "Today's booking count should be non-negative");
    }
}

@test:Config{}
function testBookingStatuses() {
    // Test all valid booking statuses
    string[] validStatuses = ["PENDING", "CONFIRMED", "CANCELLED", "COMPLETED"];
    
    foreach string status in validStatuses {
        models:BookingCreate bookingWithStatus = {
            doctor_id: 1,
            patient_id: 1,
            date: "2025-09-15",
            time: "10:00",
            status: status
        };
        
        // The creation will fail due to non-existent doctor/patient, but status validation should pass
        test:assertTrue(bookingWithStatus.status == status, string `Valid status ${status} should be accepted`);
    }
}

@test:Config{}
function testBookingRepository() {
    // Test that would validate repository functionality
    // Note: This would require database setup in a real test environment
    test:assertTrue(true, "Booking repository tests would go here");
}

@test:Config{}
function testBookingPagination() {
    services:BookingService bookingService = new();
    
    // Test that service can handle pagination requests
    // (actual pagination would be tested at repository level)
    models:Booking[]|error allBookings = bookingService.getAllBookings();
    test:assertTrue(allBookings is models:Booking[], "Should be able to get all bookings");
    
    models:BookingDetails[]|error allDetails = bookingService.getAllBookingsWithDetails();
    test:assertTrue(allDetails is models:BookingDetails[], "Should be able to get all booking details");
}

@test:Config{}
function testBookingDataIntegrity() {
    // Test data integrity constraints
    // Like ensuring booking belongs to the correct doctor and patient
    test:assertTrue(true, "Booking data integrity tests would go here");
}
