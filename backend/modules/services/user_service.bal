import ballerina/time;
import ballerina/log;
import backend.models;
import backend.repositories;
import backend.utils;

// User service for business logic
public class UserService {
    private repositories:UserRepository userRepository;

    public function init() {
        self.userRepository = new repositories:UserRepository();
    }

    // Register a new user
    public function registerUser(models:NewUser newUser) returns models:UserResponse|models:UserErrorResponse {
        // Check if email already exists
        boolean|error emailExists = self.userRepository.emailExists(newUser.email);
        if emailExists is error {
            log:printError("Error checking email existence", emailExists);
            return {message: "Internal server error", details: emailExists.message()};
        }
        if emailExists {
            return {message: "Email already exists", details: ()};
        }

        // Hash the password using simple method
        string passwordHash = utils:simpleHashPassword(newUser.password);

        // Create user
        models:User|error createdUser = self.userRepository.createUser(newUser, passwordHash);
        if createdUser is error {
            log:printError("Error creating user", createdUser);
            return {message: "Failed to create user", details: createdUser.message()};
        }

        return self.convertToUserResponse(createdUser);
    }

    // Authenticate user login
    public function loginUser(models:UserLogin loginData) returns models:AuthResponse {
        // Get user by email
        models:User|error? user = self.userRepository.getUserByEmail(loginData.email);
        if user is error {
            log:printError("Error retrieving user", user);
            return {message: "Internal server error"};
        }
        if user is () {
            return {message: "Invalid email or password"};
        }

        // Verify password using simple method
        boolean passwordValid = utils:simpleVerifyPassword(loginData.password, user.password_hash);
        if !passwordValid {
            return {message: "Invalid email or password"};
        }

        // For now, generate a simple token (user_id as string)
        string token = "simple_token_" + user.user_id.toString();

        return {
            message: "Login successful",
            user: self.convertToUserResponse(user),
            token: token
        };
    }

    // Get all users (admin only)
    public function getAllUsers() returns models:UserResponse[]|models:UserErrorResponse {
        models:User[]|error users = self.userRepository.getAllUsers();
        if users is error {
            log:printError("Error retrieving users", users);
            return {message: "Failed to retrieve users", details: users.message()};
        }

        models:UserResponse[] userResponses = [];
        foreach models:User user in users {
            userResponses.push(self.convertToUserResponse(user));
        }
        return userResponses;
    }

    // Get user by ID
    public function getUserById(int userId) returns models:UserResponse|models:UserErrorResponse {
        models:User|error? user = self.userRepository.getUserById(userId);
        if user is error {
            log:printError("Error retrieving user", user);
            return {message: "Failed to retrieve user", details: user.message()};
        }
        if user is () {
            return {message: "User not found", details: ()};
        }

        return self.convertToUserResponse(user);
    }

    // Update user
    public function updateUser(int userId, models:UserUpdate userUpdate) returns models:UserResponse|models:UserErrorResponse {
        string? passwordHash = ();
        string? userPassword = userUpdate.password;
        if userPassword is string {
            passwordHash = utils:simpleHashPassword(userPassword);
        }

        // Check if email already exists (if updating email)
        string? userEmail = userUpdate.email;
        if userEmail is string {
            boolean|error emailExists = self.userRepository.emailExists(userEmail);
            if emailExists is error {
                log:printError("Error checking email existence", emailExists);
                return {message: "Internal server error", details: emailExists.message()};
            }
            if emailExists {
                // Check if it's the same user
                models:User|error? existingUser = self.userRepository.getUserByEmail(userEmail);
                if existingUser is models:User && existingUser.user_id != userId {
                    return {message: "Email already exists", details: "Email is already taken by another user"};
                }
            }
        }

        models:User|error? updatedUser = self.userRepository.updateUser(userId, userUpdate, passwordHash);
        if updatedUser is error {
            log:printError("Error updating user", updatedUser);
            return {message: "Failed to update user", details: updatedUser.message()};
        }
        if updatedUser is () {
            return {message: "User not found", details: "No user found with the given ID"};
        }

        return self.convertToUserResponse(updatedUser);
    }

    // Delete user
    public function deleteUser(int userId) returns models:UserErrorResponse? {
        boolean|error deleted = self.userRepository.deleteUser(userId);
        if deleted is error {
            log:printError("Error deleting user", deleted);
            return {message: "Failed to delete user", details: deleted.message()};
        }
        if !deleted {
            return {message: "User not found", details: "No user found with the given ID"};
        }
        return ();
    }

    // Get users by role
    public function getUsersByRole(models:UserRole role) returns models:UserResponse[]|models:UserErrorResponse {
        models:User[]|error users = self.userRepository.getUsersByRole(role);
        if users is error {
            log:printError("Error retrieving users by role", users);
            return {message: "Failed to retrieve users", details: users.message()};
        }

        models:UserResponse[] userResponses = [];
        foreach models:User user in users {
            userResponses.push(self.convertToUserResponse(user));
        }
        return userResponses;
    }

    // Verify simple token (basic implementation)
    public function verifyToken(string token) returns models:User|error {
        if !token.startsWith("simple_token_") {
            return error("Invalid token format");
        }
        
        string userIdStr = token.substring(13); // Remove "simple_token_" prefix
        int|error userId = int:fromString(userIdStr);
        if userId is error {
            return error("Invalid token");
        }

        models:User|error? user = self.userRepository.getUserById(userId);
        if user is error {
            return user;
        }
        if user is () {
            return error("User not found");
        }

        return user;
    }

    // Private helper methods
    private function convertToUserResponse(models:User user) returns models:UserResponse {
        string? createdAtStr = ();
        string? updatedAtStr = ();
        
        // Handle optional time fields
        time:Utc? createdAt = user.created_at;
        time:Utc? updatedAt = user.updated_at;
        
        if createdAt is time:Utc {
            createdAtStr = time:utcToString(createdAt);
        }
        
        if updatedAt is time:Utc {
            updatedAtStr = time:utcToString(updatedAt);
        }
        
        return {
            user_id: user.user_id,
            email: user.email,
            role: user.role,
            created_at: createdAtStr,
            updated_at: updatedAtStr
        };
    }
}
