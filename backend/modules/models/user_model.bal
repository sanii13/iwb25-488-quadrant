import ballerina/time;

// User role enumeration
public enum UserRole {
    ADMIN = "ADMIN",
    DOCTOR = "DOCTOR", 
    PATIENT = "PATIENT"
}

// User data model
public type User record {|
    int user_id;
    string email;
    string password_hash;
    UserRole role;
    time:Utc created_at?;
    time:Utc updated_at?;
|};

// User creation model (for registration)
public type NewUser record {|
    string email;
    string password;
    UserRole role;
|};

// User login model
public type UserLogin record {|
    string email;
    string password;
|};

// User response model (without password)
public type UserResponse record {|
    int user_id;
    string email;
    UserRole role;
    string? created_at;
    string? updated_at;
|};

// Authentication response model
public type AuthResponse record {|
    string message;
    UserResponse user?;
    string token?;
|};

// User update model
public type UserUpdate record {|
    string? email;
    string? password;
    UserRole? role;
|};

// User error response model
public type UserErrorResponse record {|
    string message;
    string? details;
|};
