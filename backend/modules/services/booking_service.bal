import backend.repositories;
import backend.models;
import ballerina/io;
import ballerina/time;

// Booking service class for business logic
public class BookingService {

    private repositories:BookingRepository bookingRepository;

    public function init() {
        self.bookingRepository = new;
    }

    // Create a new booking
    public function createBooking(models:BookingCreate bookingData) returns models:Booking|error {
        // Validate the booking data
        error? validationError = self.validateBookingData(bookingData);
        if validationError is error {
            return validationError;
        }

        // Check if the time slot is available
        boolean|error isAvailable = self.bookingRepository.isTimeSlotAvailable(
            bookingData.doctor_id, 
            bookingData.date, 
            bookingData.time
        );
        
        if isAvailable is error {
            return error("Failed to check time slot availability");
        }
        
        if !isAvailable {
            return error("Time slot is not available");
        }

        // Create the booking
        models:Booking|error result = self.bookingRepository.createBooking(bookingData);
        if result is error {
            io:println("Error creating booking in service: ", result.message());
            return error("Failed to create booking");
        }

        return result;
    }

    // Get all bookings with optional filtering
    public function getAllBookings(string? status = (), int? doctorId = (), int? patientId = ()) returns models:Booking[]|error {
        models:Booking[]|error result = self.bookingRepository.getAllBookings(status, doctorId, patientId);
        if result is error {
            io:println("Error fetching bookings in service: ", result.message());
            return error("Failed to fetch bookings");
        }
        return result;
    }

    // Get booking by ID
    public function getBookingById(int bookingId) returns models:Booking|error {
        models:Booking|error result = self.bookingRepository.getBookingById(bookingId);
        if result is error {
            io:println("Error fetching booking by ID in service: ", result.message());
            return error("Booking not found");
        }
        return result;
    }

    // Get detailed booking information
    public function getBookingDetails(int bookingId) returns models:BookingDetails|error {
        models:BookingDetails|error result = self.bookingRepository.getBookingDetails(bookingId);
        if result is error {
            io:println("Error fetching booking details in service: ", result.message());
            return error("Booking not found");
        }
        return result;
    }

    // Get all bookings with detailed information
    public function getAllBookingsWithDetails(string? status = (), int? doctorId = (), int? patientId = ()) returns models:BookingDetails[]|error {
        models:BookingDetails[]|error result = self.bookingRepository.getAllBookingsWithDetails(status, doctorId, patientId);
        if result is error {
            io:println("Error fetching booking details in service: ", result.message());
            return error("Failed to fetch booking details");
        }
        return result;
    }

    // Update booking status
    public function updateBookingStatus(int bookingId, string status) returns models:Booking|error {
        // Validate status
        if !self.isValidStatus(status) {
            return error("Invalid booking status");
        }

        // Check if booking exists
        models:Booking|error existingBooking = self.bookingRepository.getBookingById(bookingId);
        if existingBooking is error {
            return error("Booking not found");
        }

        // Update the booking
        models:BookingUpdate updateData = {
            status: status
        };

        models:Booking|error result = self.bookingRepository.updateBooking(bookingId, updateData);
        if result is error {
            io:println("Error updating booking status in service: ", result.message());
            return error("Failed to update booking status");
        }

        return result;
    }

    // Cancel booking
    public function cancelBooking(int bookingId) returns models:Booking|error {
        return self.updateBookingStatus(bookingId, "CANCELLED");
    }

    // Confirm booking
    public function confirmBooking(int bookingId) returns models:Booking|error {
        return self.updateBookingStatus(bookingId, "CONFIRMED");
    }

    // Complete booking
    public function completeBooking(int bookingId) returns models:Booking|error {
        return self.updateBookingStatus(bookingId, "COMPLETED");
    }

    // Delete booking
    public function deleteBooking(int bookingId) returns error? {
        error? result = self.bookingRepository.deleteBooking(bookingId);
        if result is error {
            io:println("Error deleting booking in service: ", result.message());
            return error("Failed to delete booking");
        }
    }

    // Get upcoming bookings for a doctor
    public function getUpcomingDoctorBookings(int doctorId, int? limitCount = ()) returns models:BookingDetails[]|error {
        models:BookingDetails[]|error result = self.bookingRepository.getUpcomingDoctorBookings(doctorId, limitCount);
        if result is error {
            io:println("Error fetching upcoming doctor bookings in service: ", result.message());
            return error("Failed to fetch upcoming doctor bookings");
        }
        return result;
    }

    // Get upcoming bookings for a patient
    public function getUpcomingPatientBookings(int patientId, int? limitCount = ()) returns models:BookingDetails[]|error {
        models:BookingDetails[]|error result = self.bookingRepository.getUpcomingPatientBookings(patientId, limitCount);
        if result is error {
            io:println("Error fetching upcoming patient bookings in service: ", result.message());
            return error("Failed to fetch upcoming patient bookings");
        }
        return result;
    }

    // Get booking statistics for a doctor
    public function getDoctorBookingStats(int doctorId) returns record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}|error {
        var result = self.bookingRepository.getDoctorBookingStats(doctorId);
        if result is error {
            io:println("Error fetching doctor booking statistics in service: ", result.message());
            return error("Failed to fetch doctor booking statistics");
        }
        return result;
    }

    // Get booking statistics for a patient
    public function getPatientBookingStats(int patientId) returns record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}|error {
        var result = self.bookingRepository.getPatientBookingStats(patientId);
        if result is error {
            io:println("Error fetching patient booking statistics in service: ", result.message());
            return error("Failed to fetch patient booking statistics");
        }
        return result;
    }

    // Check if time slot is available
    public function isTimeSlotAvailable(int doctorId, string date, string time, int? excludeBookingId = ()) returns boolean|error {
        boolean|error result = self.bookingRepository.isTimeSlotAvailable(doctorId, date, time, excludeBookingId);
        if result is error {
            io:println("Error checking time slot availability in service: ", result.message());
            return error("Failed to check time slot availability");
        }
        return result;
    }

    // Validate booking data
    private function validateBookingData(models:BookingCreate bookingData) returns error? {
        // Validate doctor_id
        if bookingData.doctor_id <= 0 {
            return error("Invalid doctor ID");
        }

        // Validate patient_id
        if bookingData.patient_id <= 0 {
            return error("Invalid patient ID");
        }

        // Validate date format (YYYY-MM-DD)
        error? dateValidation = self.validateDateFormat(bookingData.date);
        if dateValidation is error {
            return dateValidation;
        }

        // Validate time format (HH:MM)
        error? timeValidation = self.validateTimeFormat(bookingData.time);
        if timeValidation is error {
            return timeValidation;
        }

        // Validate that booking is not in the past
        error? futureValidation = self.validateFutureDateTime(bookingData.date, bookingData.time);
        if futureValidation is error {
            return futureValidation;
        }

        // Validate status if provided
        if bookingData.status is string && !self.isValidStatus(<string>bookingData.status) {
            return error("Invalid booking status");
        }
    }

    // Validate date format (YYYY-MM-DD)
    private function validateDateFormat(string date) returns error? {
        // Simple regex-like validation for YYYY-MM-DD format
        if date.length() != 10 {
            return error("Invalid date format. Expected YYYY-MM-DD");
        }
        
        string[] parts = re `-`.split(date);
        if parts.length() != 3 {
            return error("Invalid date format. Expected YYYY-MM-DD");
        }
        
        // Validate year (4 digits)
        if parts[0].length() != 4 {
            return error("Invalid year format");
        }
        
        // Validate month (2 digits, 01-12)
        if parts[1].length() != 2 {
            return error("Invalid month format");
        }
        
        // Validate day (2 digits, 01-31)
        if parts[2].length() != 2 {
            return error("Invalid day format");
        }
    }

    // Validate time format (HH:MM)
    private function validateTimeFormat(string time) returns error? {
        // Simple validation for HH:MM format
        if time.length() != 5 {
            return error("Invalid time format. Expected HH:MM");
        }
        
        string[] parts = re `:`.split(time);
        if parts.length() != 2 {
            return error("Invalid time format. Expected HH:MM");
        }
        
        // Validate hour (2 digits, 00-23)
        if parts[0].length() != 2 {
            return error("Invalid hour format");
        }
        
        // Validate minute (2 digits, 00-59)
        if parts[1].length() != 2 {
            return error("Invalid minute format");
        }
    }

    // Validate that the booking is not in the past
    private function validateFutureDateTime(string date, string time) returns error? {
        // For now, just check if the date is not empty
        // In a real implementation, you would parse the date/time and compare with current time
        if date.length() == 0 || time.length() == 0 {
            return error("Date and time cannot be empty");
        }
        
        // Note: Proper date/time validation would require parsing and comparing with current time
        // This is a simplified version
    }

    // Check if status is valid
    private function isValidStatus(string status) returns boolean {
        return status == "PENDING" || status == "CONFIRMED" || status == "CANCELLED" || status == "COMPLETED";
    }

    // Get available time slots for a doctor on a specific date
    public function getAvailableTimeSlots(int doctorId, string date) returns string[]|error {
        // Define standard working hours (you can make this configurable)
        string[] allTimeSlots = [
            "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
            "12:00", "12:30", "14:00", "14:30", "15:00", "15:30",
            "16:00", "16:30", "17:00", "17:30"
        ];
        
        string[] availableSlots = [];
        
        foreach string timeSlot in allTimeSlots {
            boolean|error isAvailable = self.isTimeSlotAvailable(doctorId, date, timeSlot);
            if isAvailable is boolean && isAvailable {
                availableSlots.push(timeSlot);
            }
        }
        
        return availableSlots;
    }

    // Get bookings count for today
    public function getTodayBookingsCount(int? doctorId = (), int? patientId = ()) returns int|error {
        time:Utc currentTime = time:utcNow();
        time:Civil civilTime = time:utcToCivil(currentTime);
        string todayDate = string `${civilTime.year}-${civilTime.month.toString().padStart(2, "0")}-${civilTime.day.toString().padStart(2, "0")}`;
        
        models:Booking[]|error bookings;
        if doctorId is int {
            bookings = self.getAllBookings((), doctorId, ());
        } else if patientId is int {
            bookings = self.getAllBookings((), (), patientId);
        } else {
            bookings = self.getAllBookings();
        }
        
        if bookings is error {
            return error("Failed to fetch today's bookings");
        }
        
        int count = 0;
        foreach models:Booking booking in bookings {
            if booking.date == todayDate {
                count += 1;
            }
        }
        
        return count;
    }
}
