import ballerina/http;
import ballerina/time;
import backend.controllers;

// Global controller instances
controllers:RemedyController remedyController = new;
controllers:HerbalPlantController herbalPlantController = new;
controllers:ArticleController articleController = new;
controllers:UserController userController = new;
controllers:PatientController patientController = new;
controllers:DoctorController doctorController = new;
controllers:BookingController bookingController = new;

// Main service for remedy API endpoints
service /api/remedies on new http:Listener(8080) {

    // GET /api/remedies - Get all remedies
    resource function get .() returns http:Response {
        http:Request req = new;
        return remedyController.getAllRemedies(req);
    }

    // GET /api/remedies/{id} - Get remedy by ID
    resource function get [int remedyId]() returns http:Response {
        http:Request req = new;
        return remedyController.getRemedyById(req, remedyId);
    }

    // POST /api/remedies - Create a new remedy (for future use)
    resource function post .(http:Request req) returns http:Response {
        return remedyController.createRemedy(req);
    }

    // PUT /api/remedies/{id} - Update remedy (for future use)
    resource function put [int remedyId](http:Request req) returns http:Response {
        return remedyController.updateRemedy(req, remedyId);
    }

    // DELETE /api/remedies/{id} - Delete remedy (for future use)
    resource function delete [int remedyId]() returns http:Response {
        http:Request req = new;
        return remedyController.deleteRemedy(req, remedyId);
    }
}

// Main service for herbal plants API endpoints
service /api/herbal\-plants on new http:Listener(8080) {

    // GET /api/herbal-plants - Get all herbal plants
    resource function get .() returns http:Response {
        http:Request req = new;
        return herbalPlantController.getAllHerbalPlants(req);
    }

    // GET /api/herbal-plants/{id} - Get herbal plant by ID
    resource function get [int plantId]() returns http:Response {
        http:Request req = new;
        return herbalPlantController.getHerbalPlantById(req, plantId);
    }
}

// Main service for articles API endpoints
service /api/articles on new http:Listener(8080) {

    // GET /api/articles - Get all articles
    resource function get .() returns http:Response {
        http:Request req = new;
        return articleController.getAllArticles(req);
    }

    // GET /api/articles/{id} - Get article by ID
    resource function get [int articleId]() returns http:Response {
        http:Request req = new;
        return articleController.getArticleById(req, articleId);
    }
}

// Authentication service for user management
service /api/auth on new http:Listener(8080) {

    // POST /api/auth/register - Register a new user
    resource function post register(http:Request req) returns http:Response {
        return userController.registerUser(req);
    }

    // POST /api/auth/login - User login
    resource function post login(http:Request req) returns http:Response {
        return userController.loginUser(req);
    }

    // GET /api/auth/profile - Get current user profile
    resource function get profile(http:Request req) returns http:Response {
        return userController.getCurrentUserProfile(req);
    }
}

// User management service
service /api/users on new http:Listener(8080) {

    // GET /api/users - Get all users (admin only)
    resource function get .(http:Request req) returns http:Response {
        return userController.getAllUsers(req);
    }

    // GET /api/users/{id} - Get user by ID
    resource function get [int userId](http:Request req) returns http:Response {
        return userController.getUserById(req, userId);
    }

    // PUT /api/users/{id} - Update user
    resource function put [int userId](http:Request req) returns http:Response {
        return userController.updateUser(req, userId);
    }

    // DELETE /api/users/{id} - Delete user (admin only)
    resource function delete [int userId](http:Request req) returns http:Response {
        return userController.deleteUser(req, userId);
    }

    // GET /api/users/role/{role} - Get users by role (admin only)
    resource function get role/[string role](http:Request req) returns http:Response {
        return userController.getUsersByRole(req, role);
    }
}

// Patient management service
service /api/patients on new http:Listener(8080) {

    // POST /api/patients - Create a new patient record
    resource function post .(http:Request req) returns http:Response {
        return patientController.createPatient(req);
    }

    // GET /api/patients - Get all patients (doctors and admins only)
    resource function get .(http:Request req) returns http:Response {
        return patientController.getAllPatients(req);
    }

    // GET /api/patients/{id} - Get patient by ID
    resource function get [int patientId](http:Request req) returns http:Response {
        return patientController.getPatientById(req, patientId);
    }

    // PUT /api/patients/{id} - Update patient
    resource function put [int patientId](http:Request req) returns http:Response {
        return patientController.updatePatient(req, patientId);
    }

    // DELETE /api/patients/{id} - Delete patient (doctors and admins only)
    resource function delete [int patientId](http:Request req) returns http:Response {
        return patientController.deletePatient(req, patientId);
    }

    // GET /api/patients/user/{userId} - Get patient by user ID
    resource function get user/[int userId](http:Request req) returns http:Response {
        return patientController.getPatientByUserId(req, userId);
    }

    // GET /api/patients/me - Get current user's patient record
    resource function get me(http:Request req) returns http:Response {
        return patientController.getCurrentUserPatient(req);
    }
}

// Doctor management service
service /api/doctors on new http:Listener(8080) {

    // POST /api/doctors - Create a new doctor profile
    resource function post .(http:Request req) returns http:Response {
        return doctorController.createDoctor(req);
    }

    // GET /api/doctors - Get all doctors with optional filtering
    resource function get .(http:Request req) returns http:Response {
        return doctorController.getAllDoctors(req);
    }

    // GET /api/doctors/{id} - Get doctor by ID
    resource function get [int doctorId](http:Request req) returns http:Response {
        return doctorController.getDoctorById(req, doctorId);
    }

    // PUT /api/doctors/{id} - Update doctor profile
    resource function put [int doctorId](http:Request req) returns http:Response {
        return doctorController.updateDoctor(req, doctorId);
    }

    // DELETE /api/doctors/{id} - Delete doctor profile
    resource function delete [int doctorId](http:Request req) returns http:Response {
        return doctorController.deleteDoctor(req, doctorId);
    }

    // GET /api/doctors/user/{userId} - Get doctor by user ID
    resource function get user/[int userId](http:Request req) returns http:Response {
        return doctorController.getDoctorByUserId(req, userId);
    }

    // GET /api/doctors/me - Get current user's doctor profile
    resource function get me(http:Request req) returns http:Response {
        return doctorController.getCurrentUserDoctorProfile(req);
    }

    // GET /api/doctors/specialization/{specialization} - Get doctors by specialization
    resource function get specialization/[string specialization](http:Request req) returns http:Response {
        return doctorController.getDoctorsBySpecialization(req, specialization);
    }

    // GET /api/doctors/location/{location} - Get doctors by location
    resource function get location/[string location](http:Request req) returns http:Response {
        return doctorController.getDoctorsByLocation(req, location);
    }

    // GET /api/doctors/top-rated - Get top-rated doctors
    resource function get top\-rated(http:Request req) returns http:Response {
        return doctorController.getTopRatedDoctors(req);
    }

    // PATCH /api/doctors/{id}/rating - Update doctor rating
    resource function patch [int doctorId]/rating(http:Request req) returns http:Response {
        return doctorController.updateDoctorRating(req, doctorId);
    }

    // GET /api/doctors/specializations - Get available specializations
    resource function get specializations(http:Request req) returns http:Response {
        return doctorController.getSpecializations(req);
    }

    // GET /api/doctors/locations - Get available locations
    resource function get locations(http:Request req) returns http:Response {
        return doctorController.getLocations(req);
    }

    // GET /api/doctors/count - Get doctors count
    resource function get count(http:Request req) returns http:Response {
        return doctorController.getDoctorsCount(req);
    }
}

// Booking management service
service /api/bookings on new http:Listener(8080) {

    // POST /api/bookings - Create a new booking
    resource function post .(http:Request req) returns http:Response {
        return bookingController.createBooking(req);
    }

    // GET /api/bookings - Get all bookings
    resource function get .(http:Request req) returns http:Response {
        return bookingController.getAllBookings(req);
    }

    // GET /api/bookings/{id} - Get booking by ID
    resource function get [int bookingId](http:Request req) returns http:Response {
        return bookingController.getBookingById(req, bookingId);
    }

    // DELETE /api/bookings/{id} - Delete booking
    resource function delete [int bookingId](http:Request req) returns http:Response {
        return bookingController.deleteBooking(req, bookingId);
    }

    // GET /api/bookings/doctor/{doctorId}/upcoming - Get upcoming bookings by doctor
    resource function get doctor/[int doctorId]/upcoming(http:Request req) returns http:Response {
        return bookingController.getUpcomingDoctorBookings(req, doctorId);
    }

    // GET /api/bookings/patient/{patientId}/upcoming - Get upcoming bookings by patient
    resource function get patient/[int patientId]/upcoming(http:Request req) returns http:Response {
        return bookingController.getUpcomingPatientBookings(req, patientId);
    }

    // PATCH /api/bookings/{id}/status - Update booking status
    resource function patch [int bookingId]/status(http:Request req) returns http:Response {
        return bookingController.updateBookingStatus(req, bookingId);
    }

    // PATCH /api/bookings/{id}/cancel - Cancel booking
    resource function patch [int bookingId]/cancel(http:Request req) returns http:Response {
        return bookingController.cancelBooking(req, bookingId);
    }

    // PATCH /api/bookings/{id}/confirm - Confirm booking
    resource function patch [int bookingId]/confirm(http:Request req) returns http:Response {
        return bookingController.confirmBooking(req, bookingId);
    }

    // PATCH /api/bookings/{id}/complete - Complete booking
    resource function patch [int bookingId]/complete(http:Request req) returns http:Response {
        return bookingController.completeBooking(req, bookingId);
    }

    // GET /api/bookings/doctor/{doctorId}/available-slots/{date} - Get available time slots for a doctor on a specific date
    resource function get doctor/[int doctorId]/available\-slots/[string date](http:Request req) returns http:Response {
        return bookingController.getAvailableTimeSlots(req, doctorId, date);
    }

    // GET /api/bookings/doctor/{doctorId}/check-availability/{date}/{time} - Check if a specific time slot is available
    resource function get doctor/[int doctorId]/check\-availability/[string date]/[string time](http:Request req) returns http:Response {
        return bookingController.checkTimeSlotAvailability(req, doctorId, date, time);
    }

    // GET /api/bookings/doctor/{doctorId}/stats - Get booking statistics for a specific doctor
    resource function get doctor/[int doctorId]/stats(http:Request req) returns http:Response {
        return bookingController.getDoctorBookingStats(req, doctorId);
    }

    // GET /api/bookings/patient/{patientId}/stats - Get booking statistics for a specific patient
    resource function get patient/[int patientId]/stats(http:Request req) returns http:Response {
        return bookingController.getPatientBookingStats(req, patientId);
    }
}

// Health check endpoint
service /health on new http:Listener(8080) {
    resource function get .() returns json {
        return {
            "status": "healthy",
            "serviceName": "remedy-api",
            "timestamp": time:utcNow()
        };
    }
}
