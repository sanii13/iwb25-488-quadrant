import ballerina/time;

// HerbalPlant data model
public type HerbalPlant record {|
    int plant_id;
    string botanical_name;
    string local_name;
    string description;
    string medicinal_uses;
    string cultivation_steps;
    string? image_url;
    time:Utc created_at?;
    time:Utc updated_at?;
|};

// HerbalPlant creation model (without ID and timestamps)
public type NewHerbalPlant record {|
    string botanical_name;
    string local_name;
    string description;
    string medicinal_uses;
    string cultivation_steps;
    string? image_url;
|};

// HerbalPlant response model
public type HerbalPlantResponse record {|
    int plant_id;
    string botanical_name;
    string local_name;
    string description;
    string medicinal_uses;
    string cultivation_steps;
    string? image_url;
    string? created_at;
    string? updated_at;
|};
