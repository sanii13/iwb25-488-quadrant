import ballerina/sql;
import ballerina/time;
import backend.database;
import backend.models;

// User repository for database operations
public class UserRepository {

    // Get all users
    public function getAllUsers() returns models:User[]|error {
        sql:ParameterizedQuery query = `SELECT user_id, email, password_hash, role, created_at, updated_at FROM users ORDER BY created_at DESC`;
        
        stream<models:User, sql:Error?> resultStream = database:dbClient->query(query);
        models:User[] users = [];
        
        check from models:User user in resultStream
            do {
                users.push(user);
            };
        
        check resultStream.close();
        return users;
    }

    // Get user by ID
    public function getUserById(int userId) returns models:User|error? {
        sql:ParameterizedQuery query = `SELECT user_id, email, password_hash, role, created_at, updated_at FROM users WHERE user_id = ${userId}`;
        
        models:User|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        return result;
    }

    // Get user by email
    public function getUserByEmail(string email) returns models:User|error? {
        sql:ParameterizedQuery query = `SELECT user_id, email, password_hash, role, created_at, updated_at FROM users WHERE email = ${email}`;
        
        models:User|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:NoRowsError {
            return ();
        }
        return result;
    }

    // Create a new user
    public function createUser(models:NewUser newUser, string passwordHash) returns models:User|error {
        sql:ParameterizedQuery query = `
            INSERT INTO users (email, password_hash, role, created_at, updated_at) 
            VALUES (${newUser.email}, ${passwordHash}, ${newUser.role}, ${time:utcNow()}, ${time:utcNow()})
            RETURNING user_id, email, password_hash, role, created_at, updated_at
        `;
        
        models:User|sql:Error result = database:dbClient->queryRow(query);
        return result;
    }

    // Update user
    public function updateUser(int userId, models:UserUpdate userUpdate, string? passwordHash) returns models:User|error? {
        // For simplicity, we'll handle each field update separately
        // In a real application, you might want to build dynamic queries
        
        if userUpdate.email is string && passwordHash is string && userUpdate.role is models:UserRole {
            // Update all fields
            sql:ParameterizedQuery query = `
                UPDATE users SET email = ${userUpdate.email}, password_hash = ${passwordHash}, 
                role = ${userUpdate.role}, updated_at = ${time:utcNow()}
                WHERE user_id = ${userId}
                RETURNING user_id, email, password_hash, role, created_at, updated_at
            `;
            models:User|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:NoRowsError {
                return ();
            }
            return result;
        } else if userUpdate.email is string && passwordHash is string {
            // Update email and password
            sql:ParameterizedQuery query = `
                UPDATE users SET email = ${userUpdate.email}, password_hash = ${passwordHash}, 
                updated_at = ${time:utcNow()}
                WHERE user_id = ${userId}
                RETURNING user_id, email, password_hash, role, created_at, updated_at
            `;
            models:User|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:NoRowsError {
                return ();
            }
            return result;
        } else if userUpdate.email is string && userUpdate.role is models:UserRole {
            // Update email and role
            sql:ParameterizedQuery query = `
                UPDATE users SET email = ${userUpdate.email}, role = ${userUpdate.role}, 
                updated_at = ${time:utcNow()}
                WHERE user_id = ${userId}
                RETURNING user_id, email, password_hash, role, created_at, updated_at
            `;
            models:User|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:NoRowsError {
                return ();
            }
            return result;
        } else if passwordHash is string && userUpdate.role is models:UserRole {
            // Update password and role
            sql:ParameterizedQuery query = `
                UPDATE users SET password_hash = ${passwordHash}, role = ${userUpdate.role}, 
                updated_at = ${time:utcNow()}
                WHERE user_id = ${userId}
                RETURNING user_id, email, password_hash, role, created_at, updated_at
            `;
            models:User|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:NoRowsError {
                return ();
            }
            return result;
        } else if userUpdate.email is string {
            // Update only email
            sql:ParameterizedQuery query = `
                UPDATE users SET email = ${userUpdate.email}, updated_at = ${time:utcNow()}
                WHERE user_id = ${userId}
                RETURNING user_id, email, password_hash, role, created_at, updated_at
            `;
            models:User|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:NoRowsError {
                return ();
            }
            return result;
        } else if passwordHash is string {
            // Update only password
            sql:ParameterizedQuery query = `
                UPDATE users SET password_hash = ${passwordHash}, updated_at = ${time:utcNow()}
                WHERE user_id = ${userId}
                RETURNING user_id, email, password_hash, role, created_at, updated_at
            `;
            models:User|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:NoRowsError {
                return ();
            }
            return result;
        } else if userUpdate.role is models:UserRole {
            // Update only role
            sql:ParameterizedQuery query = `
                UPDATE users SET role = ${userUpdate.role}, updated_at = ${time:utcNow()}
                WHERE user_id = ${userId}
                RETURNING user_id, email, password_hash, role, created_at, updated_at
            `;
            models:User|sql:Error result = database:dbClient->queryRow(query);
            if result is sql:NoRowsError {
                return ();
            }
            return result;
        } else {
            return error("No fields to update");
        }
    }

    // Delete user
    public function deleteUser(int userId) returns boolean|error {
        sql:ParameterizedQuery query = `DELETE FROM users WHERE user_id = ${userId}`;
        
        sql:ExecutionResult|sql:Error result = database:dbClient->execute(query);
        if result is sql:Error {
            return result;
        }
        
        return result.affectedRowCount > 0;
    }

    // Check if email exists
    public function emailExists(string email) returns boolean|error {
        sql:ParameterizedQuery query = `SELECT COUNT(*) as count FROM users WHERE email = ${email}`;
        
        record {int count;}|sql:Error result = database:dbClient->queryRow(query);
        if result is sql:Error {
            return result;
        }
        
        return result.count > 0;
    }

    // Get users by role
    public function getUsersByRole(models:UserRole role) returns models:User[]|error {
        sql:ParameterizedQuery query = `SELECT user_id, email, password_hash, role, created_at, updated_at FROM users WHERE role = ${role} ORDER BY created_at DESC`;
        
        stream<models:User, sql:Error?> resultStream = database:dbClient->query(query);
        models:User[] users = [];
        
        check from models:User user in resultStream
            do {
                users.push(user);
            };
        
        check resultStream.close();
        return users;
    }
}
