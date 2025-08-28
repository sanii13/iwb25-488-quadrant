import ballerina/sql;
import ballerina/io;
import backend.database;
import backend.models;

// Booking repository class for database operations
public class BookingRepository {

    public function init() {
        // Using the shared database client from database module
    }

    // Create a new booking
    public function createBooking(models:BookingCreate booking) returns models:Booking|error {
        sql:ParameterizedQuery query = `
            INSERT INTO bookings (doctor_id, patient_id, date, time, status)
            VALUES (${booking.doctor_id}, ${booking.patient_id}, ${booking.date}, ${booking.time}, ${booking.status ?: "PENDING"})
            RETURNING booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at
        `;

        models:Booking|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            io:println("Error creating booking: ", result.message());
            return error("Failed to create booking");
        }
        return result;
    }

    // Get all bookings with optional filtering
    public function getAllBookings(string? status = (), int? doctorId = (), int? patientId = ()) returns models:Booking[]|error {
        sql:ParameterizedQuery query;

        if status is string && doctorId is int && patientId is int {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings WHERE status = ${status} AND doctor_id = ${doctorId} AND patient_id = ${patientId} 
                     ORDER BY date DESC, time DESC`;
        } else if status is string && doctorId is int {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings WHERE status = ${status} AND doctor_id = ${doctorId} 
                     ORDER BY date DESC, time DESC`;
        } else if status is string && patientId is int {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings WHERE status = ${status} AND patient_id = ${patientId} 
                     ORDER BY date DESC, time DESC`;
        } else if doctorId is int && patientId is int {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings WHERE doctor_id = ${doctorId} AND patient_id = ${patientId} 
                     ORDER BY date DESC, time DESC`;
        } else if status is string {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings WHERE status = ${status} ORDER BY date DESC, time DESC`;
        } else if doctorId is int {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings WHERE doctor_id = ${doctorId} ORDER BY date DESC, time DESC`;
        } else if patientId is int {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings WHERE patient_id = ${patientId} ORDER BY date DESC, time DESC`;
        } else {
            query = `SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at 
                     FROM bookings ORDER BY date DESC, time DESC`;
        }

        stream<models:Booking, sql:Error?> bookingStream = database:dbClient->query(query);
        models:Booking[] bookings = [];
        
        error? e = bookingStream.forEach(function(models:Booking booking) {
            bookings.push(booking);
        });
        
        if e is error {
            io:println("Error fetching bookings: ", e.message());
            return error("Failed to fetch bookings");
        }
        
        return bookings;
    }

    // Get booking by ID
    public function getBookingById(int bookingId) returns models:Booking|error {
        sql:ParameterizedQuery query = `
            SELECT booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at
            FROM bookings 
            WHERE booking_id = ${bookingId}
        `;

        models:Booking|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            io:println("Error fetching booking by ID: ", result.message());
            return error("Booking not found");
        }
        return result;
    }

    // Get bookings with detailed information (including doctor and patient details)
    public function getBookingDetails(int bookingId) returns models:BookingDetails|error {
        sql:ParameterizedQuery query = `
            SELECT 
                b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                b.created_at, b.updated_at,
                d.name as doctor_name, d.specialization as doctor_specialization, 
                d.location as doctor_location, d.contact_number as doctor_contact_number,
                p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
            FROM bookings b
            LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
            LEFT JOIN patients p ON b.patient_id = p.patient_id
            WHERE b.booking_id = ${bookingId}
        `;

        models:BookingDetails|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            io:println("Error fetching booking details: ", result.message());
            return error("Booking not found");
        }
        return result;
    }

    // Get all bookings with detailed information
    public function getAllBookingsWithDetails(string? status = (), int? doctorId = (), int? patientId = ()) returns models:BookingDetails[]|error {
        sql:ParameterizedQuery query;

        if status is string && doctorId is int && patientId is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.status = ${status} AND b.doctor_id = ${doctorId} AND b.patient_id = ${patientId}
                ORDER BY b.date DESC, b.time DESC
            `;
        } else if status is string && doctorId is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.status = ${status} AND b.doctor_id = ${doctorId}
                ORDER BY b.date DESC, b.time DESC
            `;
        } else if status is string && patientId is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.status = ${status} AND b.patient_id = ${patientId}
                ORDER BY b.date DESC, b.time DESC
            `;
        } else if doctorId is int && patientId is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.doctor_id = ${doctorId} AND b.patient_id = ${patientId}
                ORDER BY b.date DESC, b.time DESC
            `;
        } else if status is string {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.status = ${status}
                ORDER BY b.date DESC, b.time DESC
            `;
        } else if doctorId is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.doctor_id = ${doctorId}
                ORDER BY b.date DESC, b.time DESC
            `;
        } else if patientId is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.patient_id = ${patientId}
                ORDER BY b.date DESC, b.time DESC
            `;
        } else {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                ORDER BY b.date DESC, b.time DESC
            `;
        }

        stream<models:BookingDetails, sql:Error?> bookingStream = database:dbClient->query(query);
        models:BookingDetails[] bookings = [];
        
        error? e = bookingStream.forEach(function(models:BookingDetails booking) {
            bookings.push(booking);
        });
        
        if e is error {
            io:println("Error fetching booking details: ", e.message());
            return error("Failed to fetch booking details");
        }
        
        return bookings;
    }

    // Update booking
    public function updateBooking(int bookingId, models:BookingUpdate updateData) returns models:Booking|error {
        // Simple update approach
        if updateData?.status is string {
            sql:ParameterizedQuery query = `
                UPDATE bookings 
                SET status = ${<string>updateData?.status}, updated_at = CURRENT_TIMESTAMP 
                WHERE booking_id = ${bookingId}
                RETURNING booking_id, doctor_id, patient_id, date, time, status, created_at, updated_at
            `;
            
            models:Booking|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:Error {
                io:println("Error updating booking status: ", result.message());
                return error("Failed to update booking");
            }
            return result;
        }
        
        return error("No fields to update");
    }

    // Delete booking
    public function deleteBooking(int bookingId) returns error? {
        sql:ParameterizedQuery query = `DELETE FROM bookings WHERE booking_id = ${bookingId}`;
        
        sql:ExecutionResult|sql:Error result = database:dbClient->execute(query);
        if result is sql:Error {
            io:println("Error deleting booking: ", result.message());
            return error("Failed to delete booking");
        }
        
        if result.affectedRowCount == 0 {
            return error("Booking not found");
        }
    }

    // Check if booking time slot is available
    public function isTimeSlotAvailable(int doctorId, string date, string time, int? excludeBookingId = ()) returns boolean|error {
        sql:ParameterizedQuery query;
        
        if excludeBookingId is int {
            query = `
                SELECT COUNT(*) as count 
                FROM bookings 
                WHERE doctor_id = ${doctorId} 
                AND date = ${date} 
                AND time = ${time} 
                AND status IN ('PENDING', 'CONFIRMED')
                AND booking_id != ${excludeBookingId}
            `;
        } else {
            query = `
                SELECT COUNT(*) as count 
                FROM bookings 
                WHERE doctor_id = ${doctorId} 
                AND date = ${date} 
                AND time = ${time} 
                AND status IN ('PENDING', 'CONFIRMED')
            `;
        }

        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            io:println("Error checking time slot availability: ", result.message());
            return error("Failed to check time slot availability");
        }
        
        return result.count == 0;
    }

    // Get upcoming bookings for a doctor
    public function getUpcomingDoctorBookings(int doctorId, int? limitCount = ()) returns models:BookingDetails[]|error {
        sql:ParameterizedQuery query;
        
        if limitCount is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.doctor_id = ${doctorId} 
                AND (b.date > CURRENT_DATE OR (b.date = CURRENT_DATE AND b.time >= CURRENT_TIME))
                AND b.status IN ('PENDING', 'CONFIRMED')
                ORDER BY b.date ASC, b.time ASC
                LIMIT ${limitCount}
            `;
        } else {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.doctor_id = ${doctorId} 
                AND (b.date > CURRENT_DATE OR (b.date = CURRENT_DATE AND b.time >= CURRENT_TIME))
                AND b.status IN ('PENDING', 'CONFIRMED')
                ORDER BY b.date ASC, b.time ASC
            `;
        }

        stream<models:BookingDetails, sql:Error?> bookingStream = database:dbClient->query(query);
        models:BookingDetails[] bookings = [];
        
        error? e = bookingStream.forEach(function(models:BookingDetails booking) {
            bookings.push(booking);
        });
        
        if e is error {
            io:println("Error fetching upcoming doctor bookings: ", e.message());
            return error("Failed to fetch upcoming doctor bookings");
        }
        
        return bookings;
    }

    // Get upcoming bookings for a patient
    public function getUpcomingPatientBookings(int patientId, int? limitCount = ()) returns models:BookingDetails[]|error {
        sql:ParameterizedQuery query;
        
        if limitCount is int {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.patient_id = ${patientId} 
                AND (b.date > CURRENT_DATE OR (b.date = CURRENT_DATE AND b.time >= CURRENT_TIME))
                AND b.status IN ('PENDING', 'CONFIRMED')
                ORDER BY b.date ASC, b.time ASC
                LIMIT ${limitCount}
            `;
        } else {
            query = `
                SELECT 
                    b.booking_id, b.doctor_id, b.patient_id, b.date, b.time, b.status, 
                    b.created_at, b.updated_at,
                    d.name as doctor_name, d.specialization as doctor_specialization, 
                    d.location as doctor_location, d.contact_number as doctor_contact_number,
                    p.name as patient_name, p.phone_number as patient_phone_number, p.address as patient_address
                FROM bookings b
                LEFT JOIN doctors d ON b.doctor_id = d.doctor_id
                LEFT JOIN patients p ON b.patient_id = p.patient_id
                WHERE b.patient_id = ${patientId} 
                AND (b.date > CURRENT_DATE OR (b.date = CURRENT_DATE AND b.time >= CURRENT_TIME))
                AND b.status IN ('PENDING', 'CONFIRMED')
                ORDER BY b.date ASC, b.time ASC
            `;
        }

        stream<models:BookingDetails, sql:Error?> bookingStream = database:dbClient->query(query);
        models:BookingDetails[] bookings = [];
        
        error? e = bookingStream.forEach(function(models:BookingDetails booking) {
            bookings.push(booking);
        });
        
        if e is error {
            io:println("Error fetching upcoming patient bookings: ", e.message());
            return error("Failed to fetch upcoming patient bookings");
        }
        
        return bookings;
    }

    // Get booking statistics for a doctor
    public function getDoctorBookingStats(int doctorId) returns record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}|error {
        sql:ParameterizedQuery query = `
            SELECT 
                COUNT(*) as totalBookings,
                COUNT(CASE WHEN status = 'PENDING' THEN 1 END) as pendingBookings,
                COUNT(CASE WHEN status = 'CONFIRMED' THEN 1 END) as confirmedBookings,
                COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) as completedBookings,
                COUNT(CASE WHEN status = 'CANCELLED' THEN 1 END) as cancelledBookings
            FROM bookings 
            WHERE doctor_id = ${doctorId}
        `;

        record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            io:println("Error fetching doctor booking statistics: ", result.message());
            return error("Failed to fetch doctor booking statistics");
        }
        
        return result;
    }

    // Get booking statistics for a patient
    public function getPatientBookingStats(int patientId) returns record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}|error {
        sql:ParameterizedQuery query = `
            SELECT 
                COUNT(*) as totalBookings,
                COUNT(CASE WHEN status = 'PENDING' THEN 1 END) as pendingBookings,
                COUNT(CASE WHEN status = 'CONFIRMED' THEN 1 END) as confirmedBookings,
                COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) as completedBookings,
                COUNT(CASE WHEN status = 'CANCELLED' THEN 1 END) as cancelledBookings
            FROM bookings 
            WHERE patient_id = ${patientId}
        `;

        record {int totalBookings; int pendingBookings; int confirmedBookings; int completedBookings; int cancelledBookings;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            io:println("Error fetching patient booking statistics: ", result.message());
            return error("Failed to fetch patient booking statistics");
        }
        
        return result;
    }
}
