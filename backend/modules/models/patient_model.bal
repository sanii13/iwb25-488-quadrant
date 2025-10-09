// Patient data model
public type Patient record {|
    int patient_id;
    int user_id;
    string name;
    string phone_number;
    string address;
    string date_of_birth; // ISO date string (YYYY-MM-DD)
    string? medical_notes;
    string? image_url;
    string? created_at;
    string? updated_at;
|};

// Patient creation model
public type NewPatient record {|
    int user_id;
    string name;
    string phone_number;
    string address;
    string date_of_birth; // ISO date string (YYYY-MM-DD)
    string? medical_notes;
    string? image_url;
|};

// Patient response model
public type PatientResponse record {|
    int patient_id;
    int user_id;
    string name;
    string phone_number;
    string address;
    string date_of_birth;
    string? medical_notes;
    string? image_url;
    string? created_at;
    string? updated_at;
|};

// Patient update model
public type PatientUpdate record {|
    string? name;
    string? phone_number;
    string? address;
    string? date_of_birth;
    string? medical_notes;
    string? image_url;
|};

// Patient with user details
public type PatientWithUser record {|
    int patient_id;
    int user_id;
    string name;
    string phone_number;
    string address;
    string date_of_birth;
    string? medical_notes;
    string? image_url;
    string? created_at;
    string? updated_at;
    // User details
    string email;
    string role;
|};

// Patient error response model
public type PatientErrorResponse record {|
    string message;
    string? details;
|};

// Patient search parameters
public type PatientSearchParams record {|
    string? name;
    string? phone_number;
    int? user_id;
    int? page;
    int? 'limit;
|};
