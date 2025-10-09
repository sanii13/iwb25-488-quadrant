import ballerina/http;
import ballerina/io;
import backend.services;
import backend.models;

// Booking controller class for handling HTTP requests
public class BookingController {

    private services:BookingService bookingService;

    public function init() {
        self.bookingService = new;
    }

    // Create a new booking
    public function createBooking(http:Request req) returns http:Response {
        http:Response response = new;
        
        do {
            // Parse request body
            json|error payload = req.getJsonPayload();
            if payload is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Invalid request",
                    "message": "Invalid JSON payload"
                });
                return response;
            }

            // Validate required fields
            json|error doctorIdResult = payload.doctor_id;
            json|error patientIdResult = payload.patient_id;
            json|error dateResult = payload.date;
            json|error timeResult = payload.time;
            
            if doctorIdResult is error || patientIdResult is error || 
               dateResult is error || timeResult is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Invalid request",
                    "message": "Missing required fields: doctor_id, patient_id, date, time"
                });
                return response;
            }

            // Create booking data
            json|error statusResult = payload.status;
            models:BookingCreate bookingData = {
                doctor_id: check int:fromString(doctorIdResult.toString()),
                patient_id: check int:fromString(patientIdResult.toString()),
                date: dateResult.toString(),
                time: timeResult.toString(),
                status: (statusResult is error) ? "PENDING" : statusResult.toString()
            };

            // Create the booking
            models:Booking|error result = self.bookingService.createBooking(bookingData);
            if result is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Booking creation failed",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 201;
            response.setJsonPayload({
                "message": "Booking created successfully",
                "booking": result
            });

        } on fail error e {
            io:println("Error creating booking: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to create booking"
            });
        }

        return response;
    }

    // Get all bookings with optional filtering
    public function getAllBookings(http:Request req) returns http:Response {
        http:Response response = new;
        
        do {
            // Get query parameters
            string? status = req.getQueryParamValue("status");
            string? doctorIdStr = req.getQueryParamValue("doctor_id");
            string? patientIdStr = req.getQueryParamValue("patient_id");
            string? detailed = req.getQueryParamValue("detailed");

            // Parse optional parameters
            int? doctorId = doctorIdStr is string ? checkpanic int:fromString(doctorIdStr) : ();
            int? patientId = patientIdStr is string ? checkpanic int:fromString(patientIdStr) : ();
            boolean includeDetails = detailed is string && detailed == "true";

            if includeDetails {
                // Get bookings with detailed information
                models:BookingDetails[]|error result = self.bookingService.getAllBookingsWithDetails(status, doctorId, patientId);
                if result is error {
                    response.statusCode = 500;
                    response.setJsonPayload({
                        "error": "Failed to fetch bookings",
                        "message": result.message()
                    });
                    return response;
                }

                response.statusCode = 200;
                response.setJsonPayload({
                    "bookings": result,
                    "count": result.length()
                });
            } else {
                // Get basic booking information
                models:Booking[]|error result = self.bookingService.getAllBookings(status, doctorId, patientId);
                if result is error {
                    response.statusCode = 500;
                    response.setJsonPayload({
                        "error": "Failed to fetch bookings",
                        "message": result.message()
                    });
                    return response;
                }

                response.statusCode = 200;
                response.setJsonPayload({
                    "bookings": result,
                    "count": result.length()
                });
            }

        } on fail error e {
            io:println("Error fetching bookings: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to fetch bookings"
            });
        }

        return response;
    }

    // Get booking by ID
    public function getBookingById(http:Request req, int bookingId) returns http:Response {
        http:Response response = new;
        
        do {
            // Check if detailed information is requested
            string? detailed = req.getQueryParamValue("detailed");
            boolean includeDetails = detailed is string && detailed == "true";

            if includeDetails {
                // Get detailed booking information
                models:BookingDetails|error result = self.bookingService.getBookingDetails(bookingId);
                if result is error {
                    response.statusCode = 404;
                    response.setJsonPayload({
                        "error": "Booking not found",
                        "message": result.message()
                    });
                    return response;
                }

                response.statusCode = 200;
                response.setJsonPayload({
                    "booking": result
                });
            } else {
                // Get basic booking information
                models:Booking|error result = self.bookingService.getBookingById(bookingId);
                if result is error {
                    response.statusCode = 404;
                    response.setJsonPayload({
                        "error": "Booking not found",
                        "message": result.message()
                    });
                    return response;
                }

                response.statusCode = 200;
                response.setJsonPayload({
                    "booking": result
                });
            }

        } on fail error e {
            io:println("Error fetching booking: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to fetch booking"
            });
        }

        return response;
    }

    // Update booking status
    public function updateBookingStatus(http:Request req, int bookingId) returns http:Response {
        http:Response response = new;
        
        do {
            // Parse request body
            json|error payload = req.getJsonPayload();
            if payload is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Invalid request",
                    "message": "Invalid JSON payload"
                });
                return response;
            }

            // Validate required status field
            json|error statusResult = payload.status;
            if statusResult is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Invalid request",
                    "message": "Missing required field: status"
                });
                return response;
            }

            // Update booking status
            models:Booking|error result = self.bookingService.updateBookingStatus(bookingId, statusResult.toString());
            if result is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Status update failed",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "message": "Booking status updated successfully",
                "booking": result
            });

        } on fail error e {
            io:println("Error updating booking status: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to update booking status"
            });
        }

        return response;
    }

    // Cancel booking
    public function cancelBooking(http:Request req, int bookingId) returns http:Response {
        http:Response response = new;
        
        do {
            // Cancel the booking
            models:Booking|error result = self.bookingService.cancelBooking(bookingId);
            if result is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Booking cancellation failed",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "message": "Booking cancelled successfully",
                "booking": result
            });

        } on fail error e {
            io:println("Error cancelling booking: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to cancel booking"
            });
        }

        return response;
    }

    // Confirm booking
    public function confirmBooking(http:Request req, int bookingId) returns http:Response {
        http:Response response = new;
        
        do {
            // Confirm the booking
            models:Booking|error result = self.bookingService.confirmBooking(bookingId);
            if result is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Booking confirmation failed",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "message": "Booking confirmed successfully",
                "booking": result
            });

        } on fail error e {
            io:println("Error confirming booking: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to confirm booking"
            });
        }

        return response;
    }

    // Complete booking
    public function completeBooking(http:Request req, int bookingId) returns http:Response {
        http:Response response = new;
        
        do {
            // Complete the booking
            models:Booking|error result = self.bookingService.completeBooking(bookingId);
            if result is error {
                response.statusCode = 400;
                response.setJsonPayload({
                    "error": "Booking completion failed",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "message": "Booking completed successfully",
                "booking": result
            });

        } on fail error e {
            io:println("Error completing booking: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to complete booking"
            });
        }

        return response;
    }

    // Delete booking
    public function deleteBooking(http:Request req, int bookingId) returns http:Response {
        http:Response response = new;
        
        do {
            // Delete the booking
            error? result = self.bookingService.deleteBooking(bookingId);
            if result is error {
                response.statusCode = 404;
                response.setJsonPayload({
                    "error": "Booking deletion failed",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "message": "Booking deleted successfully"
            });

        } on fail error e {
            io:println("Error deleting booking: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to delete booking"
            });
        }

        return response;
    }

    // Get upcoming bookings for a doctor
    public function getUpcomingDoctorBookings(http:Request req, int doctorId) returns http:Response {
        http:Response response = new;
        
        do {
            // Get optional limit parameter
            string? limitStr = req.getQueryParamValue("limit");
            int? limitCount = limitStr is string ? checkpanic int:fromString(limitStr) : ();

            // Get upcoming bookings
            models:BookingDetails[]|error result = self.bookingService.getUpcomingDoctorBookings(doctorId, limitCount);
            if result is error {
                response.statusCode = 500;
                response.setJsonPayload({
                    "error": "Failed to fetch upcoming bookings",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "upcomingBookings": result,
                "count": result.length()
            });

        } on fail error e {
            io:println("Error fetching upcoming doctor bookings: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to fetch upcoming bookings"
            });
        }

        return response;
    }

    // Get upcoming bookings for a patient
    public function getUpcomingPatientBookings(http:Request req, int patientId) returns http:Response {
        http:Response response = new;
        
        do {
            // Get optional limit parameter
            string? limitStr = req.getQueryParamValue("limit");
            int? limitCount = limitStr is string ? checkpanic int:fromString(limitStr) : ();

            // Get upcoming bookings
            models:BookingDetails[]|error result = self.bookingService.getUpcomingPatientBookings(patientId, limitCount);
            if result is error {
                response.statusCode = 500;
                response.setJsonPayload({
                    "error": "Failed to fetch upcoming bookings",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "upcomingBookings": result,
                "count": result.length()
            });

        } on fail error e {
            io:println("Error fetching upcoming patient bookings: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to fetch upcoming bookings"
            });
        }

        return response;
    }

    // Get booking statistics for a doctor
    public function getDoctorBookingStats(http:Request req, int doctorId) returns http:Response {
        http:Response response = new;
        
        do {
            // Get booking statistics
            var result = self.bookingService.getDoctorBookingStats(doctorId);
            if result is error {
                response.statusCode = 500;
                response.setJsonPayload({
                    "error": "Failed to fetch booking statistics",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "totalBookings": result.totalBookings,
                "pendingBookings": result.pendingBookings,
                "confirmedBookings": result.confirmedBookings,
                "completedBookings": result.completedBookings,
                "cancelledBookings": result.cancelledBookings
            });

        } on fail error e {
            io:println("Error fetching doctor booking statistics: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to fetch booking statistics"
            });
        }

        return response;
    }

    // Get booking statistics for a patient
    public function getPatientBookingStats(http:Request req, int patientId) returns http:Response {
        http:Response response = new;
        
        do {
            // Get booking statistics
            var result = self.bookingService.getPatientBookingStats(patientId);
            if result is error {
                response.statusCode = 500;
                response.setJsonPayload({
                    "error": "Failed to fetch booking statistics",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "totalBookings": result.totalBookings,
                "pendingBookings": result.pendingBookings,
                "confirmedBookings": result.confirmedBookings,
                "completedBookings": result.completedBookings,
                "cancelledBookings": result.cancelledBookings
            });

        } on fail error e {
            io:println("Error fetching patient booking statistics: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to fetch booking statistics"
            });
        }

        return response;
    }

    // Get available time slots for a doctor on a specific date
    public function getAvailableTimeSlots(http:Request req, int doctorId, string date) returns http:Response {
        http:Response response = new;
        
        do {
            // Get available time slots
            string[]|error result = self.bookingService.getAvailableTimeSlots(doctorId, date);
            if result is error {
                response.statusCode = 500;
                response.setJsonPayload({
                    "error": "Failed to fetch available time slots",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "availableTimeSlots": result,
                "date": date,
                "doctorId": doctorId
            });

        } on fail error e {
            io:println("Error fetching available time slots: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to fetch available time slots"
            });
        }

        return response;
    }

    // Check if time slot is available
    public function checkTimeSlotAvailability(http:Request req, int doctorId, string date, string time) returns http:Response {
        http:Response response = new;
        
        do {
            // Check time slot availability
            boolean|error result = self.bookingService.isTimeSlotAvailable(doctorId, date, time);
            if result is error {
                response.statusCode = 500;
                response.setJsonPayload({
                    "error": "Failed to check time slot availability",
                    "message": result.message()
                });
                return response;
            }

            response.statusCode = 200;
            response.setJsonPayload({
                "isAvailable": result,
                "doctorId": doctorId,
                "date": date,
                "time": time
            });

        } on fail error e {
            io:println("Error checking time slot availability: ", e.message());
            response.statusCode = 500;
            response.setJsonPayload({
                "error": "Internal server error",
                "message": "Failed to check time slot availability"
            });
        }

        return response;
    }
}
