import ballerinax/postgresql;

// Database configuration
configurable string DB_HOST = ?;
configurable int DB_PORT = ?;
configurable string DB_NAME = ?;
configurable string DB_USER = ?;
configurable string DB_PASSWORD = ?;

// Shared database connection pool
public final postgresql:Client dbClient = check new (
    host = DB_HOST,
    port = DB_PORT,
    database = DB_NAME,
    username = DB_USER,
    password = DB_PASSWORD
);
