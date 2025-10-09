import ballerina/time;

// Remedy data model
public type Remedy record {|
    int remedy_id;
    string name;
    string description;
    string uses;
    string[] ingredients;
    string[] steps;
    string[] cautions;
    string? image_url;
    time:Utc created_at?;
    time:Utc updated_at?;
|};

// Remedy creation model (without ID and timestamps)
public type NewRemedy record {|
    string name;
    string description;
    string uses;
    string[] ingredients;
    string[] steps;
    string[] cautions;
    string? image_url;
|};

// Remedy response model
public type RemedyResponse record {|
    int remedy_id;
    string name;
    string description;
    string uses;
    string[] ingredients;
    string[] steps;
    string[] cautions;
    string? image_url;
    string? created_at;
    string? updated_at;
|};

// Error response model
public type ErrorResponse record {|
    string message;
    string? details;
|};