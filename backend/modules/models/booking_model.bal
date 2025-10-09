// Booking model representing a doctor appointment booking
public type Booking record {|
    int booking_id?;
    int doctor_id;
    int patient_id;
    string date; // Date in YYYY-MM-DD format
    string time; // Time in HH:MM format
    string status; // PENDING, CONFIRMED, CANCELLED, COMPLETED
    string? created_at?;
    string? updated_at?;
|};

// Type for creating a new booking (without booking_id and timestamps)
public type BookingCreate record {|
    int doctor_id;
    int patient_id;
    string date;
    string time;
    string status?; // Optional, defaults to PENDING
|};

// Type for updating a booking
public type BookingUpdate record {|
    int? doctor_id?;
    int? patient_id?;
    string? date?;
    string? time?;
    string? status?;
|};

// Type for booking with doctor and patient details (for enhanced responses)
public type BookingDetails record {|
    int booking_id?;
    int doctor_id;
    int patient_id;
    string date;
    string time;
    string status;
    string? created_at?;
    string? updated_at?;
    
    // Doctor details
    string? doctor_name?;
    string? doctor_specialization?;
    string? doctor_location?;
    string? doctor_contact_number?;
    
    // Patient details
    string? patient_name?;
    string? patient_phone_number?;
    string? patient_address?;
|};

// Enum for booking statuses
public enum BookingStatus {
    PENDING = "PENDING",
    CONFIRMED = "CONFIRMED",
    CANCELLED = "CANCELLED",
    COMPLETED = "COMPLETED"
}
