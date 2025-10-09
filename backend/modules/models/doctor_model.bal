// Doctor data model
public type Doctor record {|
    int doctor_id;
    int user_id;
    string name;
    string specialization;
    string location;
    string qualifications;
    int experience;
    string contact_number;
    string[] languages;
    string? image_url;
    decimal rating;
    string? created_at;
    string? updated_at;
|};

// Doctor creation model
public type NewDoctor record {|
    int user_id;
    string name;
    string specialization;
    string location;
    string qualifications;
    int experience;
    string contact_number;
    string[] languages;
    string? image_url;
    decimal rating?;
|};

// Doctor response model
public type DoctorResponse record {|
    int doctor_id;
    int user_id;
    string name;
    string specialization;
    string location;
    string qualifications;
    int experience;
    string contact_number;
    string[] languages;
    string? image_url;
    decimal rating;
    string? created_at;
    string? updated_at;
|};

// Doctor update model
public type DoctorUpdate record {|
    string? name;
    string? specialization;
    string? location;
    string? qualifications;
    int? experience;
    string? contact_number;
    string[]? languages;
    string? image_url;
    decimal? rating;
|};

// Doctor with user details
public type DoctorWithUser record {|
    int doctor_id;
    int user_id;
    string name;
    string specialization;
    string location;
    string qualifications;
    int experience;
    string contact_number;
    string[] languages;
    string? image_url;
    decimal rating;
    string? created_at;
    string? updated_at;
    // User details
    string email;
    string role;
|};

// Doctor error response model
public type DoctorErrorResponse record {|
    string message;
    string? details?;
|};

// Doctor search parameters
public type DoctorSearchParams record {|
    string? name?;
    string? specialization?;
    string? location?;
    string? language?;
    decimal? min_rating?;
    int? min_experience?;
    int? user_id?;
    int? page?;
    int? 'limit?;
|};

// Doctor profile summary for listings
public type DoctorProfileSummary record {|
    int doctor_id;
    string name;
    string specialization;
    string location;
    int experience;
    decimal rating;
    string[] languages;
    string? image_url;
|};
