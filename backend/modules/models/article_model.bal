import ballerina/time;

// Article data model
public type Article record {|
    int article_id;
    string title;
    string category;
    string content;
    string? image_url;
    time:Utc created_at?;
    time:Utc updated_at?;
|};

// Article creation model (without ID and timestamps)
public type NewArticle record {|
    string title;
    string category;
    string content;
    string? image_url;
|};

// Article response model
public type ArticleResponse record {|
    int article_id;
    string title;
    string category;
    string content;
    string? image_url;
    string? created_at;
    string? updated_at;
|};
